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

class MyReservePage extends StatefulWidget {
  const MyReservePage({super.key});

  @override
  State<MyReservePage> createState() => _MyReservePageState();
}

class _MyReservePageState extends State<MyReservePage> {
  final _searchCtrl = TextEditingController();
  int _statusFilter = 0; // 0: Tous, 1: Capturé, 2: Matchés, 3: Fait

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final employeeId = 'm2'; // Mock current employee (Yacine Adli)
    final reserveItems = MockData.reserveItems.where((i) => i.employeeId == employeeId).toList();
    final query = _searchCtrl.text.toLowerCase();

    List<ReserveItem> filtered = reserveItems;
    if (_statusFilter == 1) filtered = filtered.where((i) => i.status == 'captured').toList();
    if (_statusFilter == 2) filtered = filtered.where((i) => i.status == 'matched').toList();
    if (_statusFilter == 3) filtered = filtered.where((i) => i.status == 'done').toList();

    if (query.isNotEmpty) {
      filtered = filtered.where((i) => 
        i.vin.toLowerCase().contains(query) || 
        (i.model?.toLowerCase().contains(query) ?? false)
      ).toList();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PSAppBar(title: 'Ma réserve'),
      body: Column(
        children: [
          // Filters
          Padding(
            padding: const EdgeInsets.all(AppSpacing.base),
            child: Column(
              children: [
                PSSearchBar(
                  controller: _searchCtrl,
                  hint: 'Rechercher dans ma réserve...',
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
          const Divider(),

          // List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.base),
              itemCount: filtered.length,
              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.base),
              itemBuilder: (context, index) {
                final item = filtered[index];
                return _EmployeeReserveCard(item: item);
              },
            ),
          ),
        ],
      ),
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

class _EmployeeReserveCard extends StatelessWidget {
  const _EmployeeReserveCard({required this.item});
  final ReserveItem item;

  @override
  Widget build(BuildContext context) {
    final catMatch = MockData.categories.where((c) => c.id == item.categoryId);
    final cat = catMatch.isNotEmpty ? catMatch.first : MockData.categories.first;
    final isMatched = item.status == 'matched';

    return PSCard(
      backgroundColor: isMatched ? AppColors.successBg : AppColors.surface,
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
          if (isMatched) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(6)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.checkCheck, size: 14, color: Colors.white),
                  const SizedBox(width: 4),
                  Text('Correspondance trouvée !', style: AppTypography.labelSmall.copyWith(color: Colors.white)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text('Lié à : ${item.linkedVesselName}', style: AppTypography.body12.copyWith(color: AppColors.success)),
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
