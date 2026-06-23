import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/ps_app_bar.dart';
import '../notifiers/import_notifier.dart';
import '../models/import_models.dart';

class ReviewScreen extends ConsumerWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(importProvider);
    final notifier = ref.read(importProvider.notifier);

    final totalVehicles = state.reviewItems.length;
    final matchedCount = state.reviewItems.where((v) => v.reserveMatched).length;
    final invalidCount = state.reviewItems.where((v) => !v.vinValid && v.type == 'recente').length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PSAppBar(
        title: 'Vérification des données',
        showBack: true,
        onBackOverride: () => ref.read(importProvider.notifier).pickFiles(), // Or back to idle
      ),
      body: Column(
        children: [
          _buildSummaryBar(totalVehicles, matchedCount, invalidCount),
          Expanded(
            child: _buildReviewList(state, notifier),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context, state, notifier),
    );
  }

  Widget _buildSummaryBar(int total, int matched, int invalid) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          _buildSummaryItem('$total', 'Détectés', LucideIcons.layers),
          if (matched > 0) ...[
            const SizedBox(width: 12),
            _buildSummaryItem('$matched', 'En réserve', LucideIcons.checkCheck, color: AppColors.success),
          ],
          if (invalid > 0) ...[
            const SizedBox(width: 12),
            _buildSummaryItem('$invalid', 'A corriger', LucideIcons.alertTriangle, color: AppColors.error),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String value, String label, IconData icon, {Color? color}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color?.withOpacity(0.08) ?? AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color?.withOpacity(0.2) ?? AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: color ?? AppColors.textSecondary),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(value, style: AppTypography.label.copyWith(color: color ?? AppColors.textPrimary)),
                Text(label, style: AppTypography.body12.copyWith(color: color?.withOpacity(0.8) ?? AppColors.textSecondary, fontSize: 10)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewList(ImportState state, ImportNotifier notifier) {
    // Group by file name
    final Map<String, List<ExtractedVehicle>> groups = {};
    for (var item in state.reviewItems) {
        groups.putIfAbsent(item.sourceFileName, () => []).add(item);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final entry in groups.entries) ...[
          _buildGroupHeader(entry.key, entry.value.length),
          const SizedBox(height: 12),
          for (int i = 0; i < entry.value.length; i++)
            _VehicleCard(
              vehicle: entry.value[i],
              onToggle: () => notifier.toggleSelection(state.reviewItems.indexOf(entry.value[i])),
              onUpdate: (model, vessel, category) => notifier.updateReviewItem(
                state.reviewItems.indexOf(entry.value[i]),
                model: model,
                vessel: vessel,
                category: category,
              ),
            ).animate(delay: Duration(milliseconds: 50 * i)).fadeIn().slideX(begin: 0.03),
          const SizedBox(height: 24),
        ],
      ],
    );
  }

  Widget _buildGroupHeader(String name, int count) {
      return Row(
        children: [
          const Icon(LucideIcons.fileText, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Text(name, style: AppTypography.label.copyWith(color: AppColors.textSecondary)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(4)),
            child: Text('$count', style: AppTypography.body12.copyWith(fontWeight: FontWeight.bold)),
          ),
        ],
      );
  }

  Widget _buildBottomBar(BuildContext context, ImportState state, ImportNotifier notifier) {
    final selectedCount = state.reviewItems.where((v) => v.selected && (v.vinValid || v.type == 'ancienne')).length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: notifier.pickFiles,
                style: OutlinedButton.styleFrom(
                   padding: const EdgeInsets.symmetric(vertical: 16),
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Ajouter'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: selectedCount > 0 ? notifier.importSelected : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Importer ($selectedCount)', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  final ExtractedVehicle vehicle;
  final VoidCallback onToggle;
  final Function(String?, String?, String?) onUpdate;

  const _VehicleCard({required this.vehicle, required this.onToggle, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    final bool isInvalid = !vehicle.vinValid && vehicle.type == 'recente';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: vehicle.selected ? AppColors.primarySubtle.withOpacity(0.4) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: vehicle.selected ? AppColors.primary : AppColors.border,
          width: vehicle.selected ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: vehicle.selected,
                  onChanged: (v) => onToggle(),
                  activeColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              vehicle.vin ?? 'Ancienne — sans VIN',
                              style: GoogleFonts.jetBrainsMono(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: vehicle.vin == null ? AppColors.textMuted : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          _buildBadge(
                            vehicle.type == 'recente' ? 'Récente' : 'Ancienne',
                            vehicle.type == 'recente' ? AppColors.primary : Colors.grey,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildInlineEditField(
                        label: 'Modèle',
                        value: vehicle.model ?? '',
                        icon: LucideIcons.car,
                        onChanged: (v) => onUpdate(v, null, null),
                      ),
                      const SizedBox(height: 8),
                      _buildInlineEditField(
                        label: 'Navire',
                        value: vehicle.vessel ?? '',
                        icon: LucideIcons.ship,
                        onChanged: (v) => onUpdate(null, v, null),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (vehicle.reserveMatched || isInvalid || vehicle.alreadyExists)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.border.withOpacity(0.3),
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(11), bottomRight: Radius.circular(11)),
              ),
              child: Row(
                children: [
                  if (vehicle.reserveMatched)
                    _buildStatusTag('Déjà en réserve', AppColors.success, LucideIcons.checkCheck),
                  if (isInvalid)
                    _buildStatusTag('VIN Invalide', AppColors.error, LucideIcons.alertTriangle),
                  if (vehicle.alreadyExists)
                    _buildStatusTag('Déjà importé', AppColors.error, LucideIcons.copy),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildStatusTag(String label, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildInlineEditField({
    required String label,
    required String value,
    required IconData icon,
    required ValueChanged<String> onChanged,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textMuted),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value.isEmpty ? 'Non spécifié' : value,
            style: AppTypography.body14.copyWith(
              color: value.isEmpty ? AppColors.textMuted : AppColors.textPrimary,
              fontStyle: value.isEmpty ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ),
        Icon(LucideIcons.pencil, size: 12, color: AppColors.textMuted.withOpacity(0.5)),
      ],
    );
  }
}
