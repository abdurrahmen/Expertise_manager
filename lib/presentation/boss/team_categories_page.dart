import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/ps_app_bar.dart';
import '../../core/widgets/ps_button.dart';
import '../../core/widgets/ps_card.dart';
import '../../core/widgets/ps_chip.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';

class TeamCategoriesPage extends StatelessWidget {
  const TeamCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: PSAppBar(
          title: 'Équipe & Catégories',
        ),
        body: Column(
          children: [
            Container(
              color: AppColors.surface,
              child: TabBar(
                indicatorColor: AppColors.primary,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: AppTypography.label,
                tabs: const [
                  Tab(text: 'Catégories'),
                  Tab(text: 'Équipe'),
                ],
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  _CategoriesTab(),
                  _TeamTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoriesTab extends StatelessWidget {
  const _CategoriesTab();

  @override
  Widget build(BuildContext context) {
    final categories = MockData.categories;
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.xl),
      itemCount: categories.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xl),
            child: PSButton(
              label: 'Nouvelle catégorie',
              icon: LucideIcons.plus,
              onPressed: () {},
            ),
          );
        }
        final cat = categories[index - 1];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.base),
          child: PSCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppColors.getCategoryBg(cat.colorIndex),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(cat.name, style: AppTypography.heading18.copyWith(color: AppColors.textPrimary)),
                      ],
                    ),
                    IconButton(icon: const Icon(LucideIcons.pencil, size: 18), onPressed: () {}),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text('${cat.vehicleCount} véhicules · ${cat.memberCount} employés', style: AppTypography.body13.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: cat.keywords.map((k) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(4)),
                    child: Text(k, style: AppTypography.mono13.copyWith(color: AppColors.textSecondary)),
                  )).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TeamTab extends StatelessWidget {
  const _TeamTab();

  @override
  Widget build(BuildContext context) {
    final members = MockData.members;
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.xl),
      itemCount: members.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xl),
            child: PSButton(
              label: 'Ajouter un membre',
              icon: LucideIcons.plus,
              onPressed: () {},
            ),
          );
        }
        final member = members[index - 1];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.base),
          child: PSCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.getCategoryBg(member.avatarColorIndex),
                  child: Text(member.initials, style: AppTypography.heading18.copyWith(color: AppColors.getCategoryText(member.avatarColorIndex))),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(member.name, style: AppTypography.heading18.copyWith(color: AppColors.textPrimary)),
                          const SizedBox(width: AppSpacing.sm),
                          if (member.role == UserRole.boss)
                            const Icon(LucideIcons.crown, size: 16, color: AppColors.warning),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: member.categoryIds.map((id) {
                          final cat = MockData.categories.firstWhere((c) => c.id == id);
                          return PSChip(label: cat.name, variant: PSChipVariant.category, categoryIndex: cat.colorIndex);
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Switch(value: true, onChanged: (v) {}),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        const Icon(LucideIcons.trendingUp, size: 14, color: AppColors.success),
                        const SizedBox(width: 4),
                        Text('${member.weekCount}/sem', style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
