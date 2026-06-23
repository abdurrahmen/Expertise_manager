import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/kpi_card.dart';
import '../../core/widgets/ps_app_bar.dart';
import '../../core/widgets/ps_button.dart';
import '../../core/widgets/ps_card.dart';
import '../../core/widgets/ps_chip.dart';
import '../../core/widgets/ps_vin_display.dart';
import '../../data/mock_data.dart';
import 'la_reserve_page.dart';
import '../../features/import/screens/import_screen.dart';

class BossDashboardPage extends StatelessWidget {
  const BossDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > AppSpacing.breakpointTablet;
    final isMobile = width < AppSpacing.breakpointMobile;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PSAppBar(
        title: 'Tableau de bord',
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.bell),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: KPIs
            LayoutBuilder(builder: (context, constraints) {
              final cols = isDesktop ? 4 : (isMobile ? 1 : 2);
              final ratio = isMobile ? 2.5 : 1.3;
              return GridView.count(
                crossAxisCount: cols,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: AppSpacing.base,
                crossAxisSpacing: AppSpacing.base,
                childAspectRatio: ratio,
                children: [
                  const KPICard(value: 86, label: 'Véhicules trouvés', ringValue: 0.86, suffix: '/100'),
                  const KPICard(value: 14, label: 'En attente', trend: '-2% vs hier'),
                  const KPICard(value: 20, label: 'Véhicules anciens', showLinearProgress: true, linearValue: 0.6, suffix: '/30', icon: LucideIcons.target),
                  KPICard(value: 86, label: 'Taux de complétion', ringValue: 0.86, ringColor: AppColors.success, suffix: '%'),
                ],
              );
            }),
            const SizedBox(height: AppSpacing.xl),

            // Row 2: Charts
            isDesktop
                ? Row(
                    children: [
                      Expanded(child: _buildBarChart()),
                      const SizedBox(width: AppSpacing.xl),
                      Expanded(child: _buildDonutChart()),
                    ],
                  )
                : Column(
                    children: [
                      _buildBarChart(),
                      const SizedBox(height: AppSpacing.xl),
                      _buildDonutChart(),
                    ],
                  ),

            const SizedBox(height: AppSpacing.xl),

            // Row 3: Activity & Team
            isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _buildActivityFeed()),
                      const SizedBox(width: AppSpacing.xl),
                      Expanded(flex: 2, child: _buildTeam()),
                    ],
                  )
                : Column(
                    children: [
                      _buildActivityFeed(),
                      const SizedBox(height: AppSpacing.xl),
                      _buildTeam(),
                    ],
                  ),

            const SizedBox(height: AppSpacing.xl),

            // Row 4: Quick Actions
            Wrap(
              spacing: AppSpacing.base,
              runSpacing: AppSpacing.base,
              children: [
                PSButton(label: 'La Réserve', icon: LucideIcons.archive, variant: PSButtonVariant.secondary, onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const LaReservePage()));
                }),
                PSButton(label: 'Importer', icon: LucideIcons.sparkles, variant: PSButtonVariant.secondary, onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const ImportScreen()));
                }),
                PSButton(label: 'Nouveau navire', icon: LucideIcons.ship, variant: PSButtonVariant.secondary, onPressed: () {}),
                PSButton(label: 'Équipe & Catégories', icon: LucideIcons.users, variant: PSButtonVariant.secondary, onPressed: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    return PSCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Progression par navire', style: AppTypography.heading18.copyWith(color: AppColors.textPrimary)),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final style = AppTypography.body12.copyWith(color: AppColors.textSecondary);
                        String text = '';
                        if (value == 0) text = 'MSC Fantasia';
                        if (value == 1) text = 'CMA CGM...';
                        if (value == 2) text = 'Evergreen..';
                        return SideTitleWidget(meta: meta, child: Text(text, style: style));
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _makeBarGroup(0, 75),
                  _makeBarGroup(1, 93),
                  _makeBarGroup(2, 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppColors.primary,
          width: 24,
          borderRadius: BorderRadius.circular(4),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100,
            color: AppColors.border,
          ),
        ),
      ],
    );
  }

  Widget _buildDonutChart() {
    return PSCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Répartition par catégorie', style: AppTypography.heading18.copyWith(color: AppColors.textPrimary)),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 60,
                    sections: [
                      PieChartSectionData(value: 45, color: AppColors.categoryBg[0], title: '', radius: 24),
                      PieChartSectionData(value: 38, color: AppColors.categoryBg[1], title: '', radius: 24),
                      PieChartSectionData(value: 22, color: AppColors.categoryBg[2], title: '', radius: 24),
                      PieChartSectionData(value: 15, color: AppColors.categoryBg[3], title: '', radius: 24),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('120', style: AppTypography.heading24.copyWith(color: AppColors.textPrimary)),
                      Text('véhicules', style: AppTypography.body12.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityFeed() {
    return PSCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Activité récente', style: AppTypography.heading18.copyWith(color: AppColors.textPrimary)),
          const SizedBox(height: AppSpacing.md),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: MockData.recentActivity.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final act = MockData.recentActivity[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.getCategoryBg(act.memberColorIndex),
                      child: Text(
                        act.memberName.substring(0, 1),
                        style: AppTypography.labelSmall.copyWith(color: AppColors.getCategoryText(act.memberColorIndex)),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: AppTypography.body14.copyWith(color: AppColors.textPrimary),
                              children: [
                                TextSpan(text: '${act.memberName} a trouvé '),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              PSVinDisplay(vin: act.vin, isSmall: true),
                              if (act.categoryName != null) ...[
                                const SizedBox(width: 8),
                                PSChip(label: act.categoryName!, variant: PSChipVariant.category, categoryIndex: act.categoryIndex ?? 0),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(act.timeAgo, style: AppTypography.body12.copyWith(color: AppColors.textMuted)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTeam() {
    return PSCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Équipe aujourd\'hui', style: AppTypography.heading18.copyWith(color: AppColors.textPrimary)),
          const SizedBox(height: AppSpacing.md),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final member = MockData.members[index + 1];
              return Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.getCategoryBg(member.avatarColorIndex),
                    child: Text(
                      member.initials,
                      style: AppTypography.labelSmall.copyWith(color: AppColors.getCategoryText(member.avatarColorIndex)),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: Text(member.name, style: AppTypography.body14.copyWith(color: AppColors.textPrimary))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.successBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('${member.todayCount}', style: AppTypography.labelSmall.copyWith(color: AppColors.success)),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
