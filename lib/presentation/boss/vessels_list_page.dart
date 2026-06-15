import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/ps_app_bar.dart';
import '../../core/widgets/ps_button.dart';
import '../../core/widgets/ps_card.dart';
import '../../core/widgets/ps_chip.dart';
import '../../core/widgets/ps_progress.dart';
import '../../data/mock_data.dart';
import 'vessel_detail_page.dart';

class VesselsListPage extends StatefulWidget {
  const VesselsListPage({super.key});

  @override
  State<VesselsListPage> createState() => _VesselsListPageState();
}

class _VesselsListPageState extends State<VesselsListPage> {
  int _activeSegment = 0; // 0: Actifs, 1: Terminés, 2: Archivés

  @override
  Widget build(BuildContext context) {
    // Filter mock data
    final statuses = ['actif', 'terminé', 'archivé'];
    final filtered = MockData.vessels.where((v) => v.status == statuses[_activeSegment]).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PSAppBar(
        title: 'Navires',
        actions: [
          if (MediaQuery.of(context).size.width > AppSpacing.breakpointMobile)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: PSButton(
                label: 'Nouveau navire',
                icon: LucideIcons.plus,
                isSmall: true,
                onPressed: () {},
              ),
            ),
        ],
      ),
      floatingActionButton: MediaQuery.of(context).size.width <= AppSpacing.breakpointMobile
          ? FloatingActionButton(
              onPressed: () {},
              child: const Icon(LucideIcons.plus),
            )
          : null,
      body: Column(
        children: [
          const SizedBox(height: AppSpacing.base),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  _buildSegment(0, 'Actifs'),
                  _buildSegment(1, 'Terminés'),
                  _buildSegment(2, 'Archivés'),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: 8),
              itemCount: filtered.length,
              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.base),
              itemBuilder: (context, index) {
                final vessel = filtered[index];
                return PSCard(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => VesselDetailPage(vessel: vessel),
                    ));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(vessel.name, style: AppTypography.heading18.copyWith(color: AppColors.textPrimary)),
                          PSChip(
                            label: vessel.status.toUpperCase(),
                            variant: vessel.status == 'actif' ? PSChipVariant.success : PSChipVariant.filter,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Récente : ${vessel.foundRecente}/${vessel.totalRecente}',
                                  style: AppTypography.body13.copyWith(color: AppColors.textSecondary),
                                ),
                                const SizedBox(height: 6),
                                PSProgressBar(value: vessel.recenteProgress, height: 6),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.base),
                      Row(
                        children: [
                          Icon(LucideIcons.target, size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Véhicules anciens attendus : ${vessel.foundAncienne}/${vessel.expectedAncienne}',
                            style: AppTypography.body13.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 200.ms, delay: (50 * index).ms).slideY(begin: 0.04, end: 0);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegment(int index, String label) {
    final isActive = _activeSegment == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeSegment = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? AppColors.background : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusInput - 4),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.label.copyWith(
              color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
