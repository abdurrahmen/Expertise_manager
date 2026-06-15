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
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Widget _highlightText(String text, String query) {
    if (query.isEmpty || !text.toLowerCase().contains(query.toLowerCase())) {
      return Text(text, style: AppTypography.body14.copyWith(color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis);
    }

    final matches = query.toLowerCase().allMatches(text.toLowerCase());
    if (matches.isEmpty) {
      return Text(text, style: AppTypography.body14.copyWith(color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis);
    }

    List<TextSpan> spans = [];
    int start = 0;
    for (var match in matches) {
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start)));
      }
      spans.add(TextSpan(
        text: text.substring(match.start, match.end),
        style: const TextStyle(backgroundColor: Color(0xFFFFF176), color: Colors.black, fontWeight: FontWeight.bold),
      ));
      start = match.end;
    }
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: AppTypography.body14.copyWith(color: AppColors.textPrimary),
        children: spans,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final employee = MockData.members[1];
    final query = _searchCtrl.text.toLowerCase();
    
    List<Vehicle> allVehicules = MockData.vessels.expand((v) => v.vehicles).toList();

    List<Vehicle> displayed = allVehicules;
    
    // Apply status/category filter
    if (_activeFilter == 0) {
      displayed = allVehicules.where((v) => employee.categoryIds.contains(v.categoryId)).toList();
    } else if (_activeFilter == 2) {
      displayed = allVehicules.where((v) => v.status == VehicleStatus.enAttente).toList();
    } else if (_activeFilter == 3) {
      displayed = allVehicules.where((v) => v.status == VehicleStatus.trouve).toList();
    }

    // Apply search filter
    if (query.isNotEmpty) {
      displayed = displayed.where((v) => 
        v.vin.toLowerCase().contains(query) || 
        v.model.toLowerCase().contains(query)
      ).toList();
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
                PSSearchBar(
                  controller: _searchCtrl,
                  hint: 'Rechercher un VIN ou Modèle',
                  onChanged: (v) => setState(() {}),
                ),
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
                                  PSVinDisplay(vin: v.vin, isSmall: true, query: _searchCtrl.text),
                                  const SizedBox(width: AppSpacing.sm),
                                  Expanded(child: _highlightText(v.model, _searchCtrl.text)),
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
