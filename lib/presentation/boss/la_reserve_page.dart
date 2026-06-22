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
import '../../data/models.dart';

class LaReservePage extends StatefulWidget {
  const LaReservePage({super.key});

  @override
  State<LaReservePage> createState() => _LaReservePageState();
}

class _LaReservePageState extends State<LaReservePage> {
  final _searchCtrl = TextEditingController();
  int _statusFilter = 0; // 0: Tous, 1: Capturé, 2: Matchés, 3: Fait

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reserveItems = MockData.reserveItems; 
    final query = _searchCtrl.text.toLowerCase();

    List<ReserveItem> filtered = reserveItems;
    if (_statusFilter == 1) filtered = filtered.where((i) => i.status == 'captured').toList();
    if (_statusFilter == 2) filtered = filtered.where((i) => i.status == 'matched').toList();
    if (_statusFilter == 3) filtered = filtered.where((i) => i.status == 'done').toList();

    if (query.isNotEmpty) {
      filtered = filtered.where((i) => 
        i.vin.toLowerCase().contains(query) || 
        (i.model?.toLowerCase().contains(query) ?? false) ||
        i.employeeName.toLowerCase().contains(query)
      ).toList();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PSAppBar(
        title: 'La Réserve',
        actions: [
          IconButton(icon: const Icon(LucideIcons.share2), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Info banner
          Container(
            padding: const EdgeInsets.all(AppSpacing.base),
            color: AppColors.primarySubtle,
            child: Row(
              children: [
                const Icon(LucideIcons.archive, size: 20, color: AppColors.primary),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'Véhicules capturés par l\'équipe avant toute demande. Auto-livrés si le patron les demande.',
                    style: AppTypography.body13.copyWith(color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          ),
          
          // Stats row
          Padding(
            padding: const EdgeInsets.all(AppSpacing.base),
            child: Row(
              children: [
                Expanded(child: _buildStatChip('${reserveItems.length} Capturés', const Color(0xFFF5F3FF), const Color(0xFF7C3AED))),
                const SizedBox(width: 8),
                Expanded(child: _buildStatChip('${reserveItems.where((i) => i.status == 'matched').length} Matchés', AppColors.successBg, AppColors.success)),
                const SizedBox(width: 8),
                Expanded(child: _buildStatChip('${reserveItems.where((i) => i.status == 'done').length} Faits', AppColors.primaryLight, AppColors.primary)),
              ],
            ),
          ),

          // Search & Filters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
            child: Column(
              children: [
                PSSearchBar(
                  controller: _searchCtrl,
                  hint: 'Rechercher un VIN...',
                  onChanged: (v) => setState(() {}),
                ),
                const SizedBox(height: AppSpacing.base),
                SizedBox(
                  height: 32,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildFilterChip(0, 'Tous'),
                      const SizedBox(width: 8),
                      _buildFilterChip(1, 'Capturé'),
                      const SizedBox(width: 8),
                      _buildFilterChip(2, 'Matchés'),
                      const SizedBox(width: 8),
                      _buildFilterChip(3, 'Fait'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.base),
              itemCount: filtered.length,
              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.base),
              itemBuilder: (context, index) {
                final item = filtered[index];
                return _ReserveCard(item: item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, Color bg, Color text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Text(label, textAlign: TextAlign.center, style: AppTypography.labelSmall.copyWith(color: text)),
    );
  }

  Widget _buildFilterChip(int index, String label) {
    return PSChip(
      label: label,
      variant: PSChipVariant.filter,
      isActive: _statusFilter == index,
      onTap: () => setState(() => _statusFilter = index),
    );
  }
}

class _ReserveCard extends StatelessWidget {
  const _ReserveCard({required this.item});
  final ReserveItem item;

  @override
  Widget build(BuildContext context) {
    final catMatch = MockData.categories.where((c) => c.id == item.categoryId);
    final cat = catMatch.isNotEmpty ? catMatch.first : MockData.categories.first;
    final isMatched = item.status == 'matched';

    return PSCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PSVinDisplay(vin: item.vin, isSmall: true),
              const Spacer(),
              _buildStateBadge(item.status),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              if (item.model != null) ...[
                Text(item.model!, style: AppTypography.body14.copyWith(color: AppColors.textPrimary)),
                const SizedBox(width: 8),
              ],
              PSChip(label: cat.name, variant: PSChipVariant.category, categoryIndex: cat.colorIndex),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.getCategoryBg(cat.colorIndex % 6),
                child: Text(item.employeeName.substring(0, 1), style: AppTypography.labelSmall.copyWith(color: AppColors.getCategoryText(cat.colorIndex % 6))),
              ),
              const SizedBox(width: 8),
              Text(item.employeeName, style: AppTypography.body13.copyWith(color: AppColors.textSecondary)),
              const Spacer(),
              Text('Il y a 2h', style: AppTypography.body12.copyWith(color: AppColors.textMuted)),
            ],
          ),
          if (isMatched && item.linkedVesselName != null) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFFE6FFFA), borderRadius: BorderRadius.circular(6)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.cornerDownRight, size: 14, color: Color(0xFF00897B)),
                  const SizedBox(width: 4),
                  Text('Lié à : ${item.linkedVesselName}', style: AppTypography.labelSmall.copyWith(color: const Color(0xFF00897B))),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStateBadge(String status) {
    switch (status) {
      case 'captured':
        return PSChip(label: 'Capturé', variant: PSChipVariant.filter);
      case 'matched':
        return PSChip(label: 'Matché', variant: PSChipVariant.success);
      case 'done':
        return PSChip(label: 'Fait', variant: PSChipVariant.primary);
      default:
        return const SizedBox();
    }
  }
}
