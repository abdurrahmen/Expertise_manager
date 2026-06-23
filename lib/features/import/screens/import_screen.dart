import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/ps_app_bar.dart';
import '../notifiers/import_notifier.dart';
import '../models/import_models.dart';
import 'review_screen.dart';

class ImportScreen extends ConsumerWidget {
  const ImportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(importProvider);
    final notifier = ref.read(importProvider.notifier);

    // If processing is done, we could automatically go to review, 
    // but the state management usually handles the phase switch
    if (state.phase == ImportPhase.reviewing) {
        return const ReviewScreen();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PSAppBar(title: 'Importation Documentaire'),
      body: Stack(
        children: [
          _buildContent(context, state, notifier),
          if (state.phase == ImportPhase.processing)
            _buildProcessingOverlay(context, state),
        ],
      ),
      bottomNavigationBar: _buildBottomAction(context, state, notifier),
    );
  }

  Widget _buildContent(BuildContext context, ImportState state, ImportNotifier notifier) {
    if (state.fileQueue.isEmpty && state.phase == ImportPhase.idle) {
      return _buildEmptyState(notifier);
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Text(
               'File d\'attente (${state.fileQueue.length})',
               style: AppTypography.heading20.copyWith(color: AppColors.textPrimary),
             ),
             if (state.phase == ImportPhase.idle)
               TextButton.icon(
                 onPressed: notifier.pickFiles,
                 icon: const Icon(LucideIcons.plus),
                 label: const Text('Ajouter'),
               ),
           ],
        ),
        const SizedBox(height: AppSpacing.md),
        ...List.generate(state.fileQueue.length, (i) {
          final file = state.fileQueue[i];
          return _FileQueueItem(
            file: file,
            onRemove: state.phase == ImportPhase.idle ? () => notifier.removeFile(i) : null,
          ).animate(delay: Duration(milliseconds: 30 * i)).fadeIn().slideX(begin: 0.05);
        }),
        const SizedBox(height: 80), // Space for bottom bar
      ],
    );
  }

  Widget _buildEmptyState(ImportNotifier notifier) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primarySubtle,
              shape: BoxShape.circle,
            ),
            child: Icon(LucideIcons.sparkles, size: 48, color: AppColors.primary),
          ),
          const SizedBox(height: 24),
          Text(
            'Prêt à importer ?',
            style: AppTypography.heading24.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Sélectionnez des BL, listes de colisage ou photos de véhicules pour extraire les VINs automatiquement.',
              textAlign: TextAlign.center,
              style: AppTypography.body16.copyWith(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: notifier.pickFiles,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(LucideIcons.filePlus2),
            label: const Text('Sélectionner des fichiers', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.95, 0.95)),
    );
  }

  Widget _buildProcessingOverlay(BuildContext context, ImportState state) {
    return Container(
      color: Colors.black.withOpacity(0.05),
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(32),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(strokeWidth: 5),
                ),
                const SizedBox(height: 24),
                Text(
                  'Extraction en cours...',
                  style: AppTypography.heading20.copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  state.processingStep ?? 'Traitement des documents...',
                  textAlign: TextAlign.center,
                  style: AppTypography.body14.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: state.totalProgress,
                    backgroundColor: AppColors.border,
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${(state.totalProgress * 100).toInt()}% terminé',
                  style: AppTypography.labelSmall.copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ),
        ).animate().fadeIn().scale(),
      ),
    );
  }

  Widget? _buildBottomAction(BuildContext context, ImportState state, ImportNotifier notifier) {
    if (state.fileQueue.isEmpty || state.phase == ImportPhase.processing) return null;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: notifier.processQueue,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Lancer l\'analyse', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

class _FileQueueItem extends StatelessWidget {
  final ImportFile file;
  final VoidCallback? onRemove;

  const _FileQueueItem({required this.file, this.onRemove});

  @override
  Widget build(BuildContext context) {
    final bool isPdf = file.name.toLowerCase().endsWith('.pdf');
    final Color statusColor = _getStatusColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 6,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
              ),
            ),
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Icon(
                isPdf ? LucideIcons.fileText : LucideIcons.image,
                color: AppColors.textSecondary,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    file.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.label.copyWith(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${(file.sizeBytes / 1024 / 1024).toStringAsFixed(2)} MB',
                        style: AppTypography.body12.copyWith(color: AppColors.textMuted),
                      ),
                      const SizedBox(width: 8),
                      Container(width: 3, height: 3, decoration: const BoxDecoration(color: AppColors.textMuted, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Text(
                        _getStatusLabel(),
                        style: AppTypography.labelSmall.copyWith(color: statusColor, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (onRemove != null)
              IconButton(onPressed: onRemove, icon: const Icon(LucideIcons.x, size: 18, color: AppColors.textMuted))
            else if (file.status == FileStatus.processing)
               const Padding(
                 padding: EdgeInsets.only(right: 16),
                 child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
               )
            else if (file.status == FileStatus.done)
               const Padding(
                 padding: EdgeInsets.only(right: 16),
                 child: Icon(LucideIcons.checkCircle2, color: AppColors.success, size: 20),
               ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (file.status) {
      case FileStatus.pending: return AppColors.textMuted;
      case FileStatus.processing: return AppColors.primary;
      case FileStatus.done: return AppColors.success;
      case FileStatus.error: return AppColors.error;
      case FileStatus.empty: return Colors.orange;
    }
  }

  String _getStatusLabel() {
    switch (file.status) {
      case FileStatus.pending: return 'En attente';
      case FileStatus.processing: return 'Traitement...';
      case FileStatus.done: return '${file.vehiclesFound} véhicules trouvés';
      case FileStatus.error: return 'Erreur';
      case FileStatus.empty: return 'Aucun résultat';
    }
  }
}
