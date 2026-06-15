import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/ps_app_bar.dart';
import '../../core/widgets/ps_chip.dart';
import '../../core/widgets/ps_input.dart';
import '../../core/widgets/ps_vin_display.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int _activeFilter = 0; // 0: Assigned, 1: Tous, 2: En attente, 3: Trouvés

  @override
  Widget build(BuildContext context) {
    final employee = MockData.members[1];
    List<Vehicle> allVehicules = MockData.vessels.expand((v) => v.vehicles).toList();

    List<Vehicle> displayed = allVehicules;
    if (_activeFilter == 0) {
      displayed = allVehicules.where((v) => employee.categoryIds.contains(v.categoryId)).toList();
    } else if (_activeFilter == 2) {
      displayed = allVehicules.where((v) => v.status == VehicleStatus.enAttente).toList();
    } else if (_activeFilter == 3) {
      displayed = allVehicules.where((v) => v.status == VehicleStatus.trouve).toList();
    }

    // Group by vessel
    final Map<String, List<Vehicle>> groupedByVessel = {};
    for (var v in displayed) {
      groupedByVessel.putIfAbsent(v.vesselId, () => []).add(v);
    }

    final found = displayed.where((v) => v.status == VehicleStatus.trouve).length;
    final pending = displayed.length - found;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PSAppBar(title: 'Rechercher'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.base),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PSSearchBar(hint: 'Rechercher un VIN ou Modèle'),
                const SizedBox(height: AppSpacing.base),
                SizedBox(
                  height: 32,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildFilter(0, 'Mes catégories'),
                      const SizedBox(width: 8),
                      _buildFilter(1, 'Tous'),
                      const SizedBox(width: 8),
                      _buildFilter(2, 'En attente'),
                      const SizedBox(width: 8),
                      _buildFilter(3, 'Trouvés'),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.base),
                Text(
                  '${displayed.length} véhicules · $found trouvés · $pending en attente',
                  style: AppTypography.body13.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: groupedByVessel.length,
              itemBuilder: (context, index) {
                final vesselId = groupedByVessel.keys.elementAt(index);
                final vehicles = groupedByVessel[vesselId]!;
                final vessel = MockData.vessels.firstWhere((v) => v.id == vesselId);
                final vFound = vehicles.where((v) => v.status == VehicleStatus.trouve).length;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(AppSpacing.base, AppSpacing.lg, AppSpacing.base, AppSpacing.sm),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(vessel.name.toUpperCase(), style: AppTypography.sectionHeader.copyWith(color: AppColors.textSecondary)),
                          Text('$vFound/${vehicles.length}', style: AppTypography.sectionHeader.copyWith(color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    ...vehicles.map((v) {
                      return Container(
                        color: AppColors.surface,
                        child: Column(
                          children: [
                            ListTile(
                              title: Row(
                                children: [
                                  PSVinDisplay(vin: v.vin, isSmall: true),
                                  const SizedBox(width: AppSpacing.sm),
                                  Expanded(child: Text(v.model, style: AppTypography.body14.copyWith(color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (v.categoryId != null) ...[
                                    PSChip(label: 'Cat', variant: PSChipVariant.category, categoryIndex: int.parse(v.categoryId!.substring(1))),
                                    const SizedBox(width: 8),
                                  ],
                                  if (v.status == VehicleStatus.trouve)
                                    Icon(LucideIcons.checkCircle2, color: AppColors.success, size: 20)
                                  else
                                    Icon(LucideIcons.clock, color: AppColors.warning, size: 20),
                                ],
                              ),
                            ),
                            const Divider(height: 1),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilter(int index, String label) {
    return PSChip(
      label: label,
      variant: PSChipVariant.filter,
      isActive: _activeFilter == index,
      onTap: () => setState(() => _activeFilter = index),
    );
  }
}
