/// PortScan data models.
library models;

enum UserRole { boss, employee }
enum VehicleType { recente, ancienne }
enum VehicleStatus { enAttente, trouve, fait, capture, horsListe }

class ReserveItem {
  final String id;
  final String vin;
  final String? model;
  final String categoryId;
  final String employeeId;
  final String employeeName;
  final DateTime timestamp;
  final String status; // "captured", "matched", "done"
  final String? linkedVesselName;
  final String? notes;

  ReserveItem({
    required this.id,
    required this.vin,
    this.model,
    required this.categoryId,
    required this.employeeId,
    required this.employeeName,
    required this.timestamp,
    this.status = 'captured',
    this.linkedVesselName,
    this.notes,
  });
}

class Company {
  final String id;
  final String name;
  final String joinCode;
  Company({required this.id, required this.name, required this.joinCode});
}

class Member {
  final String id;
  final String name;
  final UserRole role;
  final int avatarColorIndex;
  final List<String> categoryIds;
  final int todayCount;
  final int weekCount;
  final int monthCount;
  Member({
    required this.id,
    required this.name,
    required this.role,
    this.avatarColorIndex = 0,
    this.categoryIds = const [],
    this.todayCount = 0,
    this.weekCount = 0,
    this.monthCount = 0,
  });

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }
}

class VehicleCategory {
  final String id;
  final String name;
  final int colorIndex;
  final List<String> keywords;
  final int vehicleCount;
  final int memberCount;
  VehicleCategory({
    required this.id,
    required this.name,
    required this.colorIndex,
    this.keywords = const [],
    this.vehicleCount = 0,
    this.memberCount = 0,
  });
}

class Vessel {
  final String id;
  final String name;
  final int totalRecente;
  final int foundRecente;
  final int expectedAncienne;
  final int foundAncienne;
  final String status; // "actif", "terminé", "archivé"
  final List<Vehicle> vehicles;
  Vessel({
    required this.id,
    required this.name,
    this.totalRecente = 0,
    this.foundRecente = 0,
    this.expectedAncienne = 0,
    this.foundAncienne = 0,
    this.status = 'actif',
    this.vehicles = const [],
  });

  double get recenteProgress =>
      totalRecente > 0 ? foundRecente / totalRecente : 0;
  double get ancienneProgress =>
      expectedAncienne > 0 ? foundAncienne / expectedAncienne : 0;
}

class Vehicle {
  final String id;
  final String vin;
  final String model;
  final VehicleType type;
  final VehicleStatus status;
  final String? categoryId;
  final String? foundByName;
  final String? foundTime;
  final String vesselId;
  Vehicle({
    required this.id,
    required this.vin,
    required this.model,
    required this.type,
    required this.status,
    this.categoryId,
    this.foundByName,
    this.foundTime,
    required this.vesselId,
  });
}

class Inspection {
  final String id;
  final String? vin;
  final String? model;
  final VehicleType type;
  final String vesselName;
  final String? categoryName;
  final int? categoryIndex;
  final String memberName;
  final String timestamp;
  final String? notes;
  final List<String> photoUrls;
  final int? km;
  Inspection({
    required this.id,
    this.vin,
    this.model,
    required this.type,
    required this.vesselName,
    this.categoryName,
    this.categoryIndex,
    required this.memberName,
    required this.timestamp,
    this.notes,
    this.photoUrls = const [],
    this.km,
  });
}

class ActivityItem {
  final String memberName;
  final int memberColorIndex;
  final String vin;
  final String? categoryName;
  final int? categoryIndex;
  final String timeAgo;
  ActivityItem({
    required this.memberName,
    required this.memberColorIndex,
    required this.vin,
    this.categoryName,
    this.categoryIndex,
    required this.timeAgo,
  });
}
