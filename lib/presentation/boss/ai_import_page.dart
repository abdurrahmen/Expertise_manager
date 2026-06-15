import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/ps_app_bar.dart';
import '../../core/widgets/ps_button.dart';
import '../../core/widgets/ps_card.dart';

class AIImportPage extends StatefulWidget {
  const AIImportPage({super.key});

  @override
  State<AIImportPage> createState() => _AIImportPageState();
}

class _AIImportPageState extends State<AIImportPage> {
  bool _isProcessing = false;

  void _simulateUpload() {
    setState(() => _isProcessing = true);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _isProcessing = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PSAppBar(title: 'Importer un document'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.base),
                  decoration: BoxDecoration(
                    color: AppColors.primarySubtle,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                  ),
                  child: Row(
                    children: [
                      Icon(LucideIcons.sparkles, color: AppColors.primary),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          'Extraire automatiquement les véhicules, NIVs et modèles d\'un manifeste via l\'IA Mistral/Groq.',
                          style: AppTypography.body14.copyWith(color: AppColors.textPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                if (_isProcessing)
                  PSCard(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xxxl),
                      child: Column(
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: AppSpacing.xl),
                          Text('Analyse en cours...', style: AppTypography.heading18.copyWith(color: AppColors.textPrimary)),
                          const SizedBox(height: AppSpacing.sm),
                          Text('Extraction des données avec Groq', style: AppTypography.body13.copyWith(color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  )
                else
                  GestureDetector(
                    onTap: _simulateUpload,
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.xxxl),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                        border: Border.all(color: AppColors.border, style: BorderStyle.solid), // Should be dashed, solid for now
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: AppColors.primarySubtle,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(LucideIcons.uploadCloud, size: 32, color: AppColors.primary),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          Text('Glissez un fichier ou appuyez pour choisir', style: AppTypography.heading18.copyWith(color: AppColors.textPrimary), textAlign: TextAlign.center),
                          const SizedBox(height: AppSpacing.sm),
                          Text('PDF, JPG, PNG, WEBP', style: AppTypography.body13.copyWith(color: AppColors.textSecondary)),
                          const SizedBox(height: AppSpacing.xxl),
                          PSButton(label: 'Sélectionner un fichier', onPressed: _simulateUpload),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
