import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MistralService {
  final String? apiKey;

  MistralService({this.apiKey});

  String get _apiKey => apiKey ?? dotenv.env['MISTRAL_API_KEY'] ?? '';

  Future<String> performOcr(Uint8List imageBytes, String mimeType) async {
    if (_apiKey.isEmpty) {
      throw Exception('Mistral API Key is missing. Please check your settings.');
    }

    final base64Image = base64Encode(imageBytes);
    final url = Uri.parse('https://api.mistral.ai/v1/ocr');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "mistral-ocr-latest",
        "document": {
          "type": "image_url",
          "image_url": "data:$mimeType;base64,$base64Image"
        }
      }),
    ).timeout(const Duration(seconds: 60));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final pages = data['pages'] as List<dynamic>;
      return pages.map((p) => p['markdown'] ?? p['text'] ?? p['content'] ?? '').join('\n');
    } else if (response.statusCode == 401) {
      throw Exception('Clé Mistral invalide — vérifiez dans Paramètres');
    } else if (response.statusCode == 429) {
      throw Exception('Limite Mistral atteinte — réessayez dans quelques secondes');
    } else {
      throw Exception('Erreur OCR (${response.statusCode}): ${response.body}');
    }
  }
}
