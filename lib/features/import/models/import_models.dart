import 'package:file_picker/file_picker.dart';

enum ImportPhase { idle, selecting, processing, reviewing, importing, done }

enum FileStatus { pending, processing, done, error, empty }

class ImportFile {
  final String name;
  final int sizeBytes;
  final String path;
  final PlatformFile platformFile;
  final FileStatus status;
  final String? errorMessage;
  final int vehiclesFound;
  final double progress;

  ImportFile({
    required this.name,
    required this.sizeBytes,
    required this.path,
    required this.platformFile,
    this.status = FileStatus.pending,
    this.errorMessage,
    this.vehiclesFound = 0,
    this.progress = 0.0,
  });

  ImportFile copyWith({
    FileStatus? status,
    String? errorMessage,
    int? vehiclesFound,
    double? progress,
  }) {
    return ImportFile(
      name: name,
      sizeBytes: sizeBytes,
      path: path,
      platformFile: platformFile,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      vehiclesFound: vehiclesFound ?? this.vehiclesFound,
      progress: progress ?? this.progress,
    );
  }
}

class ExtractedVehicle {
  String? vin;
  String? vessel;
  String? model;
  String? suggestedCategory;
  final String type; // recente | ancienne
  bool selected;
  bool reserveMatched;
  bool alreadyExists;
  bool vinValid;
  final String sourceFileName;

  ExtractedVehicle({
    this.vin,
    this.vessel,
    this.model,
    this.suggestedCategory,
    required this.type,
    this.selected = true,
    this.reserveMatched = false,
    this.alreadyExists = false,
    this.vinValid = true,
    required this.sourceFileName,
  });

  factory ExtractedVehicle.fromJson(Map<String, dynamic> json, String sourceFileName) {
    return ExtractedVehicle(
      vin: json['vin'],
      vessel: json['vessel'],
      model: json['model'],
      suggestedCategory: json['suggested_category'],
      type: json['type'] ?? 'recente',
      sourceFileName: sourceFileName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vin': vin,
      'vessel': vessel,
      'model': model,
      'suggested_category': suggestedCategory,
      'type': type,
    };
  }
}

class ImportState {
  final List<ImportFile> fileQueue;
  final List<ExtractedVehicle> reviewItems;
  final ImportPhase phase;
  final String? errorMessage;
  final String? processingStep;
  final double totalProgress;

  ImportState({
    this.fileQueue = const [],
    this.reviewItems = const [],
    this.phase = ImportPhase.idle,
    this.errorMessage,
    this.processingStep,
    this.totalProgress = 0.0,
  });

  ImportState copyWith({
    List<ImportFile>? fileQueue,
    List<ExtractedVehicle>? reviewItems,
    ImportPhase? phase,
    String? errorMessage,
    String? processingStep,
    double? totalProgress,
  }) {
    return ImportState(
      fileQueue: fileQueue ?? this.fileQueue,
      reviewItems: reviewItems ?? this.reviewItems,
      phase: phase ?? this.phase,
      errorMessage: errorMessage,
      processingStep: processingStep ?? this.processingStep,
      totalProgress: totalProgress ?? this.totalProgress,
    );
  }
}
