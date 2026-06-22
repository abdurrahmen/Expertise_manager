import 'models.dart';

/// Static mock data for all screens — UI demo only.
class MockData {
  MockData._();

  static final company = Company(
    id: '1',
    name: 'PortLog Algérie',
    joinCode: 'PLG42X',
  );

  static final categories = [
    VehicleCategory(id: 'c1', name: 'Berline', colorIndex: 0, keywords: ['sedan', 'berline'], vehicleCount: 45, memberCount: 3),
    VehicleCategory(id: 'c2', name: 'SUV', colorIndex: 1, keywords: ['suv', '4x4'], vehicleCount: 38, memberCount: 2),
    VehicleCategory(id: 'c3', name: 'Utilitaire', colorIndex: 2, keywords: ['van', 'utilitaire'], vehicleCount: 22, memberCount: 2),
    VehicleCategory(id: 'c4', name: 'Camion', colorIndex: 3, keywords: ['truck', 'camion'], vehicleCount: 15, memberCount: 1),
    VehicleCategory(id: 'c5', name: 'Pick-up', colorIndex: 4, keywords: ['pickup'], vehicleCount: 12, memberCount: 2),
    VehicleCategory(id: 'c6', name: 'Citadine', colorIndex: 5, keywords: ['city', 'citadine'], vehicleCount: 20, memberCount: 3),
  ];

  static final members = [
    Member(id: 'm1', name: 'Karim Benzema', role: UserRole.boss, avatarColorIndex: 0, categoryIds: ['c1', 'c2', 'c3'], todayCount: 5, weekCount: 28, monthCount: 112),
    Member(id: 'm2', name: 'Yacine Adli', role: UserRole.employee, avatarColorIndex: 1, categoryIds: ['c1', 'c2'], todayCount: 8, weekCount: 35, monthCount: 98),
    Member(id: 'm3', name: 'Samir Nasri', role: UserRole.employee, avatarColorIndex: 2, categoryIds: ['c3', 'c4'], todayCount: 6, weekCount: 22, monthCount: 87),
    Member(id: 'm4', name: 'Riyad Mahrez', role: UserRole.employee, avatarColorIndex: 3, categoryIds: ['c5', 'c6'], todayCount: 4, weekCount: 19, monthCount: 76),
    Member(id: 'm5', name: 'Ismaël Bennacer', role: UserRole.employee, avatarColorIndex: 4, categoryIds: ['c2', 'c5'], todayCount: 7, weekCount: 31, monthCount: 105),
  ];

  static List<Vessel>? _vessels;
  static List<Vessel> get vessels {
    _vessels ??= [
      Vessel(
        id: 'v1', name: 'MSC Fantasia', totalRecente: 45, foundRecente: 32,
        expectedAncienne: 10, foundAncienne: 6, status: 'actif',
        vehicles: _generateVehicles('v1', 'MSC Fantasia', 45),
      ),
      Vessel(
        id: 'v2', name: 'CMA CGM Marco Polo', totalRecente: 30, foundRecente: 28,
        expectedAncienne: 8, foundAncienne: 8, status: 'actif',
        vehicles: _generateVehicles('v2', 'CMA CGM Marco Polo', 30),
      ),
      Vessel(
        id: 'v3', name: 'Maersk Sealand', totalRecente: 20, foundRecente: 20,
        expectedAncienne: 5, foundAncienne: 5, status: 'terminé',
        vehicles: _generateVehicles('v3', 'Maersk Sealand', 20),
      ),
      Vessel(
        id: 'v4', name: 'Evergreen Atlas', totalRecente: 15, foundRecente: 3,
        expectedAncienne: 4, foundAncienne: 1, status: 'actif',
        vehicles: _generateVehicles('v4', 'Evergreen Atlas', 15),
      ),
    ];
    return _vessels!;
  }

  static List<Vehicle> _generateVehicles(String vesselId, String vesselName, int count) {
    final models = ['Toyota Corolla', 'Hyundai Tucson', 'Renault Clio', 'Peugeot 3008', 'Kia Sportage', 'VW Golf', 'Dacia Duster', 'Ford Ranger'];
    final vins = [
      'JTDKN3DU5A0', 'WVWZZZ3CZW0', 'VF1RFB00X5', 'VF30ERFNV1',
      'KNDPM3AC8L7', 'WVWZZZ1KZX', 'UU1HSDACG6', 'MNBMFEB2X6',
      'TMBJJ7NE1M0', 'SJNFAAJ11U0', 'WF0XXXGCDX1', 'SALLSAAG4CA',
      'YV1PZ7950F1', 'ZHWGE11T58L', 'JTEBU5JRXG5',
    ];
    final catIds = ['c1', 'c2', 'c3', 'c4', 'c5', 'c6'];
    return List.generate(count, (i) {
      final isFound = i < (count * 0.6).round();
      return Vehicle(
        id: '${vesselId}_v$i',
        vin: '${vins[i % vins.length]}${(100 + i).toString().padLeft(3, '0')}',
        model: models[i % models.length],
        type: VehicleType.recente,
        status: isFound ? VehicleStatus.trouve : VehicleStatus.enAttente,
        categoryId: catIds[i % catIds.length],
        foundByName: isFound ? members[i % members.length].name : null,
        foundTime: isFound ? '${9 + (i % 8)}h${(i * 7) % 60}${(i * 7) % 60 < 10 ? "0" : ""}' : null,
        vesselId: vesselId,
      );
    });
  }

  static final recentActivity = [
    ActivityItem(memberName: 'Yacine Adli', memberColorIndex: 1, vin: 'JTDKN3DU5A0100', categoryName: 'Berline', categoryIndex: 0, timeAgo: 'il y a 5 min'),
    ActivityItem(memberName: 'Samir Nasri', memberColorIndex: 2, vin: 'WVWZZZ3CZW0101', categoryName: 'SUV', categoryIndex: 1, timeAgo: 'il y a 12 min'),
    ActivityItem(memberName: 'Riyad Mahrez', memberColorIndex: 3, vin: 'VF1RFB00X5102', categoryName: 'Pick-up', categoryIndex: 4, timeAgo: 'il y a 18 min'),
    ActivityItem(memberName: 'Ismaël Bennacer', memberColorIndex: 4, vin: 'VF30ERFNV1103', categoryName: 'Citadine', categoryIndex: 5, timeAgo: 'il y a 25 min'),
    ActivityItem(memberName: 'Yacine Adli', memberColorIndex: 1, vin: 'KNDPM3AC8L7104', categoryName: 'Berline', categoryIndex: 0, timeAgo: 'il y a 32 min'),
  ];

  static final inspections = [
    Inspection(id: 'i1', vin: 'JTDKN3DU5A0100', model: 'Toyota Corolla', type: VehicleType.recente, vesselName: 'MSC Fantasia', categoryName: 'Berline', categoryIndex: 0, memberName: 'Yacine Adli', timestamp: 'Aujourd\'hui, 14:30', notes: 'Véhicule en bon état, aucun dommage visible.'),
    Inspection(id: 'i2', vin: 'WVWZZZ3CZW0101', model: 'Hyundai Tucson', type: VehicleType.recente, vesselName: 'MSC Fantasia', categoryName: 'SUV', categoryIndex: 1, memberName: 'Samir Nasri', timestamp: 'Aujourd\'hui, 13:45'),
    Inspection(id: 'i3', model: 'Renault Kangoo', type: VehicleType.ancienne, vesselName: 'CMA CGM Marco Polo', categoryName: 'Utilitaire', categoryIndex: 2, memberName: 'Riyad Mahrez', timestamp: 'Aujourd\'hui, 11:20', km: 145000, notes: 'Pneus usés, pare-brise fissuré.'),
    Inspection(id: 'i4', vin: 'VF30ERFNV1103', model: 'Peugeot 3008', type: VehicleType.recente, vesselName: 'MSC Fantasia', categoryName: 'Citadine', categoryIndex: 5, memberName: 'Ismaël Bennacer', timestamp: 'Hier, 16:50'),
    Inspection(id: 'i5', model: 'Dacia Logan', type: VehicleType.ancienne, vesselName: 'Evergreen Atlas', categoryName: 'Berline', categoryIndex: 0, memberName: 'Yacine Adli', timestamp: 'Hier, 10:15', km: 210000),
  ];

  // Weekly inspection counts for line chart (7 days)
  static const weeklyInspections = [12, 18, 15, 22, 19, 25, 14];
  static const weekDays = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];

  static final reserveItems = [
    ReserveItem(
      id: 'r1',
      vin: 'JTDKN3DU5A0200',
      model: 'Toyota Corolla',
      categoryId: 'c1',
      employeeId: 'm2',
      employeeName: 'Yacine Adli',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      status: 'captured',
    ),
    ReserveItem(
      id: 'r2',
      vin: 'WVWZZZ3CZW0201',
      model: 'Hyundai Tucson',
      categoryId: 'c2',
      employeeId: 'm3',
      employeeName: 'Samir Nasri',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      status: 'matched',
      linkedVesselName: 'MSC Fantasia',
    ),
    ReserveItem(
      id: 'r3',
      vin: 'VF1RFB00X5202',
      model: 'Renault Clio',
      categoryId: 'c1',
      employeeId: 'm4',
      employeeName: 'Riyad Mahrez',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      status: 'done',
      linkedVesselName: 'CMA CGM Marco Polo',
    ),
  ];
}
