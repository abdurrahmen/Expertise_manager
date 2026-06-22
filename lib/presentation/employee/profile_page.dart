import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/ps_app_bar.dart';
import '../../core/widgets/ps_card.dart';
import '../../core/widgets/ps_chip.dart';
import '../../data/mock_data.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final employee = MockData.members[1];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PSAppBar(title: 'Profil'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            // Avatar
            CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.getCategoryBg(employee.avatarColorIndex),
              child: Text(employee.initials, style: AppTypography.heading32.copyWith(color: AppColors.getCategoryText(employee.avatarColorIndex))),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(employee.name, style: AppTypography.heading20.copyWith(color: AppColors.textPrimary)),
            const SizedBox(height: AppSpacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.hardHat, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: AppSpacing.xs),
                Text('Employé(e)', style: AppTypography.body14.copyWith(color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // Categories
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: employee.categoryIds.map((id) {
                final cat = MockData.categories.firstWhere((c) => c.id == id);
                return PSChip(label: cat.name, variant: PSChipVariant.category, categoryIndex: cat.colorIndex);
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Details
            Row(
              children: [
                Expanded(child: _buildStatCard('Aujourd\'hui', '${employee.todayCount}')),
                const SizedBox(width: AppSpacing.base),
                Expanded(child: _buildStatCard('Cette semaine', '${employee.weekCount}')),
                const SizedBox(width: AppSpacing.base),
                Expanded(child: _buildStatCard('Ce mois', '${employee.monthCount}')),
              ],
            ),
            const SizedBox(height: AppSpacing.xxxl),

            // Actions
            PSCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildListTile(LucideIcons.key, 'Changer le code PIN', () {}),
                  const Divider(height: 1),
                  _buildListTile(LucideIcons.settings, 'Apparence', () {}),
                  const Divider(height: 1),
                  _buildListTile(LucideIcons.logOut, 'Changer d\'utilisateur', () {
                    // Sign out flow
                    Navigator.of(context).pushReplacementNamed('/select-profile');
                  }, isError: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return PSCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Column(
        children: [
          Text(value, style: AppTypography.heading24.copyWith(color: AppColors.textPrimary)),
          const SizedBox(height: AppSpacing.xs),
          Text(label, style: AppTypography.caption.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildListTile(IconData icon, String label, VoidCallback onTap, {bool isError = false}) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      leading: Icon(icon, color: isError ? AppColors.error : AppColors.textPrimary),
      title: Text(label, style: AppTypography.body15.copyWith(color: isError ? AppColors.error : AppColors.textPrimary)),
      trailing: const Icon(LucideIcons.chevronRight, size: 20, color: AppColors.textMuted),
    );
  }
}
