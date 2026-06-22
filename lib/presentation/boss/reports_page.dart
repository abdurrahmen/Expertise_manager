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

import 'package:share_plus/share_plus.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _shareReport() {
    Share.share('Exportation des rapports de PortScan - ${DateTime.now()}');
  }

  Widget _highlightText(String text, String query) {
    if (query.isEmpty || !text.toLowerCase().contains(query.toLowerCase())) {
      return Text(text, style: AppTypography.body14.copyWith(color: AppColors.textPrimary));
    }
    final matches = query.toLowerCase().allMatches(text.toLowerCase());
    List<TextSpan> spans = [];
    int start = 0;
    for (var match in matches) {
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start)));
      }
      spans.add(TextSpan(
        text: text.substring(match.start, match.end),
        style: const TextStyle(backgroundColor: Color(0xFFFFF176), color: Colors.black, fontWeight: FontWeight.bold),
      ));
      start = match.end;
    }
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }
    return RichText(
      text: TextSpan(style: AppTypography.body14.copyWith(color: AppColors.textPrimary), children: spans),
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchCtrl.text.toLowerCase();
    var filtered = MockData.inspections;
    if (query.isNotEmpty) {
      filtered = filtered.where((insp) => 
        (insp.vin?.toLowerCase().contains(query) ?? false) ||
        insp.memberName.toLowerCase().contains(query) ||
        insp.vesselName.toLowerCase().contains(query) ||
        (insp.model?.toLowerCase().contains(query) ?? false)
      ).toList();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PSAppBar(
        title: 'Rapports',
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.share2),
            onPressed: _shareReport,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.base),
            child: Column(
              children: [
                PSSearchBar(
                  controller: _searchCtrl,
                  hint: 'Rechercher par VIN, employé, navire...',
                  onChanged: (v) => setState(() {}),
                ),
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
              itemCount: filtered.length,
              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.base),
              itemBuilder: (context, index) {
                final insp = filtered[index];
                return PSCard(
                  padding: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.base),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (insp.vin != null) PSVinDisplay(vin: insp.vin!, isSmall: true, query: _searchCtrl.text) else Text('Véhicule ancien', style: AppTypography.label.copyWith(color: AppColors.textPrimary)),
                            const Spacer(),
                            Text(insp.timestamp, style: AppTypography.body12.copyWith(color: AppColors.textSecondary)),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Expanded(child: _highlightText(insp.model ?? '', _searchCtrl.text)),
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
                            Expanded(child: _highlightText(insp.memberName, _searchCtrl.text)),
                            const SizedBox(width: AppSpacing.md),
                            Icon(LucideIcons.ship, size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: AppSpacing.xs),
                            Expanded(child: _highlightText(insp.vesselName, _searchCtrl.text)),
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

