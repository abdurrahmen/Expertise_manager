import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GroqService {
  final String? apiKey;

  GroqService({this.apiKey});

  String get _apiKey => apiKey ?? dotenv.env['GROQ_API_KEY'] ?? '';

  Future<Map<String, dynamic>> extractVehicles(String markdown, String categoriesJson) async {
    if (_apiKey.isEmpty) {
      throw Exception('Groq API Key is missing. Please check your settings.');
    }

    final systemPrompt = '''
Tu es un expert en documents de transit maritime (Bill of Lading / connaissement).

RÈGLES IMPORTANTES :
- "X UNITS" ou "QTY: X UNIT" = nombre de véhicules. Si 2 UNITS avec 2 VINs différents → 2 véhicules séparés.
- "X PACKAGES" ou "X COLIS" = accessoires livrés AVEC un véhicule — IGNORER, ce ne sont pas des véhicules.
- Chaque VIN = exactement 17 caractères alphanumériques, jamais les lettres I, O ou Q.
- Format courant : "VIN NO.:XXXXX" ou "VIN NO/ENGINE NO:XXXXX/YYYYY" — prendre UNIQUEMENT la partie avant le /.
- Si un VIN de 17 caractères contient I, O ou Q, c'est probablement une erreur OCR : remplace O→0, I→1, Q→0.

CATÉGORIES DISPONIBLES (suggère la plus pertinente, ou null) :
$categoriesJson

Pour chaque véhicule extrait, retourne :
- "vin"                : 17 caractères — OBLIGATOIRE (null si véhicule ancien sans VIN identifiable)
- "vessel"             : nom exact du navire, champ "Ocean Vessel" — null si absent
- "model"              : marque + modèle complet, ex : "JMC T822 4X2 Dump Truck" — null si absent
- "suggested_category" : nom exact d'une catégorie de la liste, ou null
- "type"               : "recente" si VIN présent, "ancienne" si pas de VIN

Réponds UNIQUEMENT en JSON valide, sans texte autour, sans balises markdown :
{"vehicles":[{"vin":"LEFYFCC37THN16789","vessel":"GLORY LILY V.2603","model":"JMC T822 Dump Truck","suggested_category":"Camions Shacman/JMC","type":"recente"}],"total":1,"source":"description courte du document"}
''';

    final url = Uri.parse('https://api.groq.com/openai/v1/chat/completions');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "llama-3.3-70b-versatile",
        "temperature": 0.1,
        "max_tokens": 2048,
        "messages": [
          { "role": "system", "content": systemPrompt },
          { "role": "user",   "content": "Voici le document (markdown):\n\n$markdown" }
        ]
      }),
    ).timeout(const Duration(seconds: 45));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String content = data['choices'][0]['message']['content'];
      
      // Sanitise JSON
      content = content.replaceAll('```json', '').replaceAll('```', '').trim();
      
      try {
        return jsonDecode(content);
      } catch (e) {
        // Simple retry with stricter instruction if parsing fails
        return await _retryExtraction(markdown, categoriesJson);
      }
    } else if (response.statusCode == 401) {
      throw Exception('Clé Groq invalide — vérifiez dans Paramètres');
    } else if (response.statusCode == 429) {
      throw Exception('Limite Groq atteinte — réessayez dans quelques secondes');
    } else {
      throw Exception('Erreur Groq (${response.statusCode}): ${response.body}');
    }
  }

  Future<Map<String, dynamic>> _retryExtraction(String markdown, String categoriesJson) async {
    // Implement retry logic with even stricter prompt if needed
    // For now, just throwing a parse error as the second attempt is handled by the notifier anyway
    throw Exception('Extraction JSON échouée. Format invalide reçu de Groq.');
  }
}
