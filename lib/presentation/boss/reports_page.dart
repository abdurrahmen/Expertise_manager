import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/ps_app_bar.dart';
import '../../core/widgets/ps_card.dart';
import '../../core/widgets/ps_chip.dart';
import '../../core/widgets/ps_input.dart';
import '../../core/widgets/ps_vin_display.dart';
import '../../data/mock_data.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PSAppBar(
        title: 'Rapports',
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.share2),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.base),
            child: Column(
              children: [
                PSSearchBar(hint: 'Rechercher par VIN, employé, navire...'),
                const SizedBox(height: AppSpacing.base),
                SizedBox(
                  height: 32,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      PSChip(label: 'Aujourd\'hui', variant: PSChipVariant.filter, icon: LucideIcons.calendar),
                      const SizedBox(width: 8),
                      PSChip(label: 'Navire', variant: PSChipVariant.filter, icon: LucideIcons.ship),
                      const SizedBox(width: 8),
                      PSChip(label: 'Catégorie', variant: PSChipVariant.filter, icon: LucideIcons.tag),
                      const SizedBox(width: 8),
                      PSChip(label: 'Employé', variant: PSChipVariant.filter, icon: LucideIcons.users),
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
              itemCount: MockData.inspections.length,
              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.base),
              itemBuilder: (context, index) {
                final insp = MockData.inspections[index];
                return PSCard(
                  padding: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.base),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (insp.vin != null) PSVinDisplay(vin: insp.vin!, isSmall: true) else Text('Véhicule ancien', style: AppTypography.label.copyWith(color: AppColors.textPrimary)),
                            const Spacer(),
                            Text(insp.timestamp, style: AppTypography.body12.copyWith(color: AppColors.textSecondary)),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Text(insp.model ?? '', style: AppTypography.body14.copyWith(color: AppColors.textPrimary)),
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
                        const SizedBox(height: AppSpacing.base),
                        Row(
                          children: [
                            Icon(LucideIcons.userCircle, size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: AppSpacing.xs),
                            Text(insp.memberName, style: AppTypography.body13.copyWith(color: AppColors.textSecondary)),
                            const Spacer(),
                            Icon(LucideIcons.ship, size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: AppSpacing.xs),
                            Text(insp.vesselName, style: AppTypography.body13.copyWith(color: AppColors.textSecondary)),
                          ],
                        ),
                        if (insp.notes != null) ...[
                          const SizedBox(height: AppSpacing.md),
                          Text(insp.notes!, style: AppTypography.body13.copyWith(color: AppColors.textPrimary, fontStyle: FontStyle.italic)),
                        ],
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
