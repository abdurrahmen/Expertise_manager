import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/kpi_card.dart';
import '../../core/widgets/ps_app_bar.dart';
import '../../core/widgets/ps_button.dart';
import '../../core/widgets/ps_card.dart';
import '../../data/mock_data.dart';
import 'new_inspection_page.dart';

class EmployeeHomePage extends StatelessWidget {
  const EmployeeHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final employee = MockData.members[1]; // Yacine Adli

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PSAppBar(title: 'PortScan', actions: [
        IconButton(icon: const Icon(LucideIcons.bell), onPressed: () {}),
      ]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PSCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bonjour, ${employee.name.split(' ')[0]}', style: AppTypography.heading20.copyWith(color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text('15 Juin 2026', style: AppTypography.body14.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            const KPICard(
              value: 32,
              label: 'Progression du jour',
              ringValue: 0.65,
              ringColor: AppColors.primary,
              suffix: '/50',
            ),
            const SizedBox(height: AppSpacing.base),
            const KPICard(
              value: 8,
              label: 'Véhicules anciens (tous navires)',
              showLinearProgress: true,
              linearValue: 0.8,
              suffix: '/10',
              icon: LucideIcons.target,
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Navires actifs', style: AppTypography.heading18.copyWith(color: AppColors.textPrimary)),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.md),
                itemBuilder: (context, index) {
                  final vessel = MockData.vessels[index];
                  return SizedBox(
                    width: 240,
                    child: PSCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(vessel.name, style: AppTypography.heading18.copyWith(color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Récente: ${vessel.foundRecente}/${vessel.totalRecente}', style: AppTypography.body13.copyWith(color: AppColors.textSecondary)),
                              Text('${(vessel.recenteProgress * 100).round()}%', style: AppTypography.body13.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(duration: 200.ms, delay: (50 * index).ms).slideX(begin: 0.1, end: 0);
                },
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            PSButton(
              label: 'Nouvelle inspection',
              icon: LucideIcons.camera,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => const NewInspectionPage(),
                  fullscreenDialog: true,
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
