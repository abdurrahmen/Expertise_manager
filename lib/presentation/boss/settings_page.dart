import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/ps_app_bar.dart';
import '../../core/widgets/ps_card.dart';
import '../../core/widgets/ps_input.dart';
import '../../core/widgets/ps_vin_display.dart';
import '../../data/mock_data.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PSAppBar(title: 'Paramètres'),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          Text('ENTREPRISE', style: AppTypography.sectionHeader.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.sm),
          PSCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(MockData.company.name, style: AppTypography.heading18.copyWith(color: AppColors.textPrimary)),
                const SizedBox(height: AppSpacing.md),
                Text('Code d\'invitation', style: AppTypography.label.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    PSVinDisplay(vin: MockData.company.joinCode),
                    const Spacer(),
                    IconButton(icon: const Icon(LucideIcons.copy, size: 20), onPressed: () {}),
                    IconButton(icon: const Icon(LucideIcons.share2, size: 20), onPressed: () {}),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('CLÉS API IA', style: AppTypography.sectionHeader.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.sm),
          PSCard(
            child: Column(
              children: [
                PSInput(
                  label: 'Mistral AI',
                  hint: 'Mettre à jour la clé API',
                  leadingIcon: LucideIcons.key,
                  trailingIcon: LucideIcons.eyeOff,
                  obscureText: true,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text('Obtenir une clé', style: AppTypography.body12.copyWith(color: AppColors.primary)),
                  ),
                ),
                const SizedBox(height: AppSpacing.base),
                PSInput(
                  label: 'Groq',
                  hint: 'Mettre à jour la clé API',
                  leadingIcon: LucideIcons.key,
                  trailingIcon: LucideIcons.eyeOff,
                  obscureText: true,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text('Obtenir une clé', style: AppTypography.body12.copyWith(color: AppColors.primary)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('APPARENCE', style: AppTypography.sectionHeader.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.sm),
          PSCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Langue', style: AppTypography.body14.copyWith(color: AppColors.textPrimary)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Français', style: AppTypography.body14.copyWith(color: AppColors.textSecondary)),
                  const Icon(LucideIcons.chevronRight, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('À PROPOS', style: AppTypography.sectionHeader.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.sm),
          PSCard(
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Version', style: AppTypography.body14.copyWith(color: AppColors.textPrimary)),
                  trailing: Text('2.0.0', style: AppTypography.body14.copyWith(color: AppColors.textSecondary)),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Support', style: AppTypography.body14.copyWith(color: AppColors.primary)),
                  trailing: const Icon(LucideIcons.externalLink, size: 16, color: AppColors.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
