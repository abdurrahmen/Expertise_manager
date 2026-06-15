import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';

/// A5 — Select Profile: grid of member cards.
class SelectProfilePage extends StatelessWidget {
  const SelectProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final members = MockData.members;
    final company = MockData.company;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.xxl),
              Text(
                company.name,
                style: AppTypography.heading24.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.sm),
              GestureDetector(
                onTap: () => Navigator.of(context).pushReplacementNamed('/welcome'),
                child: Text(
                  'Changer d\'entreprise',
                  style: AppTypography.body14.copyWith(color: AppColors.primary),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'Qui êtes-vous ?',
                style: AppTypography.heading18.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: AppSpacing.base,
                        mainAxisSpacing: AppSpacing.base,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: members.length,
                      itemBuilder: (context, i) {
                        final member = members[i];
                        return _ProfileCard(member: member, index: i);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.member, required this.index});

  final Member member;
  final int index;

  @override
  Widget build(BuildContext context) {
    final bgColor = AppColors.getCategoryBg(member.avatarColorIndex);
    final textColor = AppColors.getCategoryText(member.avatarColorIndex);
    final isBoss = member.role == UserRole.boss;

    return GestureDetector(
      onTap: () {
        final route = isBoss ? '/boss' : '/employee';
        Navigator.of(context).pushReplacementNamed('/pin', arguments: {'member': member, 'nextRoute': route});
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      member.initials,
                      style: AppTypography.heading20.copyWith(color: textColor),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Icon(
                      isBoss ? LucideIcons.crown : LucideIcons.hardHat,
                      size: 12,
                      color: isBoss ? AppColors.warning : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Text(
                member.name,
                style: AppTypography.label.copyWith(color: AppColors.textPrimary),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    )
    .animate()
    .fadeIn(duration: 200.ms, delay: (50 * index).ms)
    .slideY(begin: 0.04, end: 0);
  }
}
