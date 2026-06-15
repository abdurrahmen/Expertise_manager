import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/ps_app_bar.dart';
import '../../core/widgets/ps_button.dart';
import '../../core/widgets/ps_card.dart';
import '../../core/widgets/ps_chip.dart';
import '../../core/widgets/ps_input.dart';
import '../../core/widgets/ps_vin_display.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Show only the employee's own inspections
    final employee = MockData.members[1];
    final myInspections = MockData.inspections.where((i) => i.memberName == employee.name).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PSAppBar(
        title: 'Mon historique',
        actions: [
          IconButton(icon: const Icon(LucideIcons.share2), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.base),
            child: Column(
              children: [
                PSSearchBar(hint: 'Rechercher...'),
                const SizedBox(height: AppSpacing.base),
                SizedBox(
                  height: 32,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      PSChip(label: 'Tous', variant: PSChipVariant.filter, isActive: true),
                      const SizedBox(width: 8),
                      PSChip(label: 'Récente', variant: PSChipVariant.filter),
                      const SizedBox(width: 8),
                      PSChip(label: 'Ancienne', variant: PSChipVariant.filter),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.base),
              itemCount: myInspections.length,
              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.base),
              itemBuilder: (context, index) {
                final insp = myInspections[index];
                return PSCard(
                  padding: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.base),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (insp.vin != null) PSVinDisplay(vin: insp.vin!, isSmall: true) else Text('Véhicule ancien — ${insp.vesselName}', style: AppTypography.label.copyWith(color: AppColors.textPrimary)),
                            const Spacer(),
                            Text(insp.timestamp, style: AppTypography.body12.copyWith(color: AppColors.textSecondary)),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            if (insp.type == VehicleType.recente)
                              PSChip(label: 'Récente', variant: PSChipVariant.vehicleRecente, icon: LucideIcons.car)
                            else
                              PSChip(label: 'Ancienne', variant: PSChipVariant.vehicleAncienne, icon: LucideIcons.wrench),
                            const SizedBox(width: AppSpacing.sm),
                            if (insp.categoryName != null)
                              PSChip(label: insp.categoryName!, variant: PSChipVariant.category, categoryIndex: insp.categoryIndex ?? 0),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.base),
                        // Fake photo thumbnails
                        Row(
                          children: List.generate(4, (i) {
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.border,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(LucideIcons.image, size: 20, color: AppColors.textMuted),
                            );
                          }),
                        ),
                        if (insp.notes != null) ...[
                          const SizedBox(height: AppSpacing.md),
                          Text(insp.notes!, style: AppTypography.body13.copyWith(color: AppColors.textPrimary, fontStyle: FontStyle.italic)),
                        ],
                        const SizedBox(height: AppSpacing.base),
                        const Divider(),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PSButton(label: 'Partager', icon: LucideIcons.share2, variant: PSButtonVariant.ghost, isSmall: true, onPressed: () {}),
                            PSIconButton(icon: LucideIcons.trash2, color: AppColors.error, onPressed: () {}),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
