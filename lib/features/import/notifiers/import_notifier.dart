import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdfx/pdfx.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../models/import_models.dart';
import '../../../core/services/mistral_service.dart';
import '../../../core/services/groq_service.dart';

final importProvider = StateNotifierProvider<ImportNotifier, ImportState>((ref) {
  return ImportNotifier();
});

class ImportNotifier extends StateNotifier<ImportState> {
  ImportNotifier() : super(ImportState());

  final MistralService _mistral = MistralService();
  final GroqService _groq = GroqService();
  
  SupabaseClient? get _supabase {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  Future<void> pickFiles() async {
    state = state.copyWith(phase: ImportPhase.selecting);
    
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'webp'],
      );

      if (result == null || result.files.isEmpty) {
        state = state.copyWith(phase: ImportPhase.idle);
        return;
      }

      final newFiles = result.files.map((f) => ImportFile(
        name: f.name,
        sizeBytes: f.size,
        path: f.path ?? '',
        platformFile: f,
      )).toList();

      state = state.copyWith(
        fileQueue: [...state.fileQueue, ...newFiles],
        phase: ImportPhase.idle,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Erreur lors de la sélection: $e',
        phase: ImportPhase.idle,
      );
    }
  }

  void removeFile(int index) {
    final newList = [...state.fileQueue];
    newList.removeAt(index);
    state = state.copyWith(fileQueue: newList);
  }

  Future<void> processQueue() async {
    if (state.fileQueue.isEmpty) return;

    state = state.copyWith(phase: ImportPhase.processing, totalProgress: 0.0);

    for (int i = 0; i < state.fileQueue.length; i++) {
      final file = state.fileQueue[i];
      if (file.status == FileStatus.done || file.status == FileStatus.processing) continue;

      try {
        await _processFile(i);
      } catch (e) {
        _updateFile(i, status: FileStatus.error, errorMessage: e.toString());
      }
      
      state = state.copyWith(totalProgress: (i + 1) / state.fileQueue.length);
    }

    state = state.copyWith(phase: ImportPhase.reviewing);
  }

  Future<void> _processFile(int index) async {
    _updateFile(index, status: FileStatus.processing, progress: 0.1);
    final file = state.fileQueue[index];

    List<Uint8List> images = [];
    
    // Step A: Render to Images
    state = state.copyWith(processingStep: '${file.name}: Préparation...');
    if (file.name.toLowerCase().endsWith('.pdf')) {
      images = await _renderPdfToImages(file, index);
    } else {
      final bytes = await _getFileBytes(file);
      images = [bytes];
    }

    // Step A.2: Compress
    state = state.copyWith(processingStep: '${file.name}: Optimization...');
    for (int j = 0; j < images.length; j++) {
      images[j] = await _compressImage(images[j]);
    }

    // Step B: Mistral OCR
    state = state.copyWith(processingStep: '${file.name}: OCR Mistral...');
    String fullMarkdown = '';
    for (int j = 0; j < images.length; j++) {
      final pageMarkdown = await _runOcrWithRetry(images[j], 'image/jpeg');
      fullMarkdown += '\n--- PAGE ${j + 1} ---\n$pageMarkdown';
      _updateFile(index, progress: 0.1 + (0.4 * (j + 1) / images.length));
    }

    // Step C: Groq Extraction
    state = state.copyWith(processingStep: '${file.name}: Extraction Groq...');
    final categories = await _getCompanyCategories();
    final extraction = await _groq.extractVehicles(fullMarkdown, categories);
    
    final vehicleJsons = extraction['vehicles'] as List<dynamic>;
    List<ExtractedVehicle> fileVehicles = [];

    for (var v in vehicleJsons) {
      final ev = ExtractedVehicle.fromJson(v, file.name);
      // Step D: Normalise VIN
      if (ev.vin != null) {
        ev.vin = _normaliseVin(ev.vin!);
        ev.vinValid = ev.vin!.length == 17;
      } else {
        ev.vinValid = false;
      }
      fileVehicles.add(ev);
    }

    // Step E: Reserve Match
    state = state.copyWith(processingStep: '${file.name}: Vérification réserve...');
    if (fileVehicles.any((v) => v.vin != null)) {
      await _matchReserve(fileVehicles);
    }

    // Finalize file
    _updateFile(index, status: FileStatus.done, vehiclesFound: fileVehicles.length, progress: 1.0);
    state = state.copyWith(
      reviewItems: [...state.reviewItems, ...fileVehicles],
    );
  }

  Future<List<Uint8List>> _renderPdfToImages(ImportFile file, int index) async {
    final doc = await PdfDocument.openFile(file.path);
    List<Uint8List> pages = [];
    for (int i = 1; i <= doc.pagesCount; i++) {
        state = state.copyWith(processingStep: '${file.name}: Rendu page $i/$doc.pagesCount...');
        final page = await doc.getPage(i);
        final image = await page.render(
            width: page.width * 2,
            height: page.height * 2,
            format: PdfPageImageFormat.jpeg,
            quality: 85,
        );
        if (image != null) pages.add(image.bytes);
        await page.close();
    }
    await doc.close();
    return pages;
  }

  Future<Uint8List> _getFileBytes(ImportFile file) async {
    if (kIsWeb) {
      return file.platformFile.bytes!;
    } else {
      return await File(file.path).readAsBytes();
    }
  }

  Future<Uint8List> _compressImage(Uint8List bytes) async {
    final result = await FlutterImageCompress.compressWithList(
      bytes,
      minWidth: 1920,
      minHeight: 1080,
      quality: 85,
    );
    return result;
  }

  Future<String> _runOcrWithRetry(Uint8List bytes, String mimeType) async {
    try {
      return await _mistral.performOcr(bytes, mimeType);
    } catch (e) {
      // Small delay and retry once
      await Future.delayed(const Duration(seconds: 3));
      return await _mistral.performOcr(bytes, mimeType);
    }
  }

  Future<String> _getCompanyCategories() async {
    // In a real app, fetch from Supabase. For now, mock or fetch if session active.
    // {{CATEGORIES_JSON}}
    return '[{"id": "1", "name": "Berline"}, {"id": "2", "name": "SUV"}, {"id": "3", "name": "Camions Shacman/JMC"}]';
  }

  String _normaliseVin(String raw) {
    String v = raw.trim().toUpperCase();
    // Groq returns a VIN with a / in it (VIN/engine pair), take only the part before the /
    if (v.contains('/')) {
        v = v.split('/')[0].trim();
    }
    v = v.replaceAll('O', '0').replaceAll('I', '1').replaceAll('Q', '0');
    v = v.replaceAll(RegExp(r'[^A-HJ-NPR-Z0-9]'), '');
    return v.length == 17 ? v : raw;
  }

  Future<void> _matchReserve(List<ExtractedVehicle> vehicles) async {
    // Mock Supabase RPC for now since we don't have the real DB connected in this environment usually
    // or if we do, use it:
    /*
    final vins = vehicles.where((v) => v.vin != null).map((v) => v.vin!).toList();
    final response = await _supabase.rpc('match_reserve_on_import', params: {
        'p_company_id': '...',
        'p_vins': vins,
    });
    */
    // For demo, let's say every 3rd vehicle matches
    for (int i = 0; i < vehicles.length; i++) {
        if (i % 3 == 0) {
            vehicles[i].reserveMatched = true;
        }
    }
  }

  void _updateFile(int index, {FileStatus? status, String? errorMessage, int? vehiclesFound, double? progress}) {
    final newList = [...state.fileQueue];
    newList[index] = newList[index].copyWith(
      status: status,
      errorMessage: errorMessage,
      vehiclesFound: vehiclesFound,
      progress: progress,
    );
    state = state.copyWith(fileQueue: newList);
  }

  void toggleSelection(int index) {
    final newList = [...state.reviewItems];
    newList[index].selected = !newList[index].selected;
    state = state.copyWith(reviewItems: newList);
  }

  void updateReviewItem(int index, {String? model, String? vessel, String? category}) {
    final newList = [...state.reviewItems];
    if (model != null) newList[index].model = model;
    if (vessel != null) newList[index].vessel = vessel;
    if (category != null) newList[index].suggestedCategory = category;
    state = state.copyWith(reviewItems: newList);
  }

  Future<void> importSelected() async {
    state = state.copyWith(phase: ImportPhase.importing);
    // Implementation of Step 4: Bulk insert etc.
    // For now, simulated success
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(phase: ImportPhase.done);
  }
}
