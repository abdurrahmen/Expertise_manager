import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/ps_app_bar.dart';
import '../../core/widgets/ps_button.dart';
import '../../core/widgets/ps_chip.dart';
import '../../core/widgets/ps_input.dart';
import '../../core/widgets/ps_progress.dart';
import '../../core/widgets/ps_vin_display.dart';
import '../../data/models.dart';

class VesselDetailPage extends StatefulWidget {
  const VesselDetailPage({super.key, required this.vessel});

  final Vessel vessel;

  @override
  State<VesselDetailPage> createState() => _VesselDetailPageState();
}

class _VesselDetailPageState extends State<VesselDetailPage> {
  int _statusFilter = 0; // 0: Tous, 1: En attente, 2: Trouvés
  int _expectedAncienne = 0;

  @override
  void initState() {
    super.initState();
    _expectedAncienne = widget.vessel.expectedAncienne;
  }

  @override
  Widget build(BuildContext context) {
    List<Vehicle> displayedVehicles = widget.vessel.vehicles;
    if (_statusFilter == 1) {
      displayedVehicles = displayedVehicles.where((v) => v.status == VehicleStatus.enAttente).toList();
    } else if (_statusFilter == 2) {
      displayedVehicles = displayedVehicles.where((v) => v.status == VehicleStatus.trouve).toList();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PSAppBar(
        title: widget.vessel.name,
        showBack: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PSButton(label: 'Ajouter', icon: LucideIcons.plus, isSmall: true, onPressed: () {}),
          ),
        ],
      ),
      body: Column(
        children: [
          // Subtitle progress row
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base, vertical: AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: PSProgressBar(value: widget.vessel.recenteProgress),
                ),
                const SizedBox(width: AppSpacing.base),
                Text(
                  '${widget.vessel.foundRecente}/${widget.vessel.totalRecente} trouvés',
                  style: AppTypography.body13.copyWith(color: AppColors.textPrimary),
                ),
                Text(
                  ' (${(widget.vessel.recenteProgress * 100).round()}%)',
                  style: AppTypography.body13.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const Divider(),

          // Expected ancienne stepper
          Padding(
            padding: const EdgeInsets.all(AppSpacing.base),
            child: Row(
              children: [
                Text('Véhicules anciens attendus', style: AppTypography.body14.copyWith(color: AppColors.textPrimary)),
                const Spacer(),
                Text('${widget.vessel.foundAncienne} trouvés sur ', style: AppTypography.body13.copyWith(color: AppColors.textSecondary)),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
                    color: AppColors.surface,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(LucideIcons.minus, size: 16),
                        onPressed: () => setState(() { if (_expectedAncienne > 0) _expectedAncienne--; }),
                      ),
                      Text('$_expectedAncienne', style: AppTypography.heading18.copyWith(color: AppColors.textPrimary)),
                      IconButton(
                        icon: const Icon(LucideIcons.plus, size: 16),
                        onPressed: () => setState(() => _expectedAncienne++),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),

          // Filters
          Padding(
            padding: const EdgeInsets.all(AppSpacing.base),
            child: Column(
              children: [
                PSSearchBar(hint: 'Rechercher par VIN ou Modèle'),
                const SizedBox(height: AppSpacing.base),
                SizedBox(
                  height: 32,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildFilterChip(0, 'Tous'),
                      const SizedBox(width: 8),
                      _buildFilterChip(1, 'En attente'),
                      const SizedBox(width: 8),
                      _buildFilterChip(2, 'Trouvés'),
                      const SizedBox(width: 16),
                      Container(width: 1, color: AppColors.border),
                      const SizedBox(width: 16),
                      PSChip(label: 'Berline', variant: PSChipVariant.filter),
                      const SizedBox(width: 8),
                      PSChip(label: 'SUV', variant: PSChipVariant.filter),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.separated(
              itemCount: displayedVehicles.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final v = displayedVehicles[index];
                return ListTile(
                  onTap: () {
                    // Tap opens bottom sheet (mocked for now)
                  },
                  title: Row(
                    children: [
                      PSVinDisplay(vin: v.vin, isSmall: true),
                      const SizedBox(width: AppSpacing.sm),
                      Text(v.model, style: AppTypography.body14.copyWith(color: AppColors.textPrimary)),
                    ],
                  ),
                  subtitle: v.status == VehicleStatus.trouve && v.foundByName != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text('${v.foundByName} · ${v.foundTime}', style: AppTypography.body12.copyWith(color: AppColors.textSecondary)),
                        )
                      : null,
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
                ).animate().fadeIn(duration: 200.ms, delay: (20 * index).ms);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(int index, String label) {
    return PSChip(
      label: label,
      variant: PSChipVariant.filter,
      isActive: _statusFilter == index,
      onTap: () => setState(() => _statusFilter = index),
    );
  }
}
