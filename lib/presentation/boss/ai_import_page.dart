import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/ps_app_bar.dart';
import '../../core/widgets/ps_button.dart';
import '../../core/widgets/ps_card.dart';
import '../../core/widgets/ps_chip.dart';
import '../../core/widgets/ps_vin_display.dart';

class AIImportPage extends StatefulWidget {
  const AIImportPage({super.key});

  @override
  State<AIImportPage> createState() => _AIImportPageState();
}

class _AIImportPageState extends State<AIImportPage> {
  bool _isProcessing = false;
  bool _showReview = false;
  bool _showAutoMatchBanner = false;

  void _simulateUpload() {
    setState(() {
      _isProcessing = true;
      _showReview = false;
      _showAutoMatchBanner = false;
    });
    
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _showReview = true;
          _showAutoMatchBanner = true;
        });
      }
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
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!_showReview) ...[
                  _buildIntroCard(),
                  const SizedBox(height: AppSpacing.xxl),
                  if (_isProcessing) _buildProcessingCard() else _buildDropZone(),
                ] else ...[
                  if (_showAutoMatchBanner) _buildAutoMatchBanner(),
                  const SizedBox(height: AppSpacing.lg),
                  _buildReviewHeader(),
                  const SizedBox(height: AppSpacing.base),
                  _buildReviewList(),
                  const SizedBox(height: AppSpacing.xxl),
                  _buildActionButtons(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIntroCard() {
    return Container(
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
    );
  }

  Widget _buildProcessingCard() {
    return PSCard(
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
    );
  }

  Widget _buildDropZone() {
    return GestureDetector(
      onTap: _simulateUpload,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          border: Border.all(color: AppColors.border, style: BorderStyle.solid), 
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
    );
  }

  Widget _buildAutoMatchBanner() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.successBg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.checkCheck, color: Color(0xFF16A34A)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              '2 véhicule(s) déjà capturé(s) en réserve — marqués Trouvé automatiquement',
              style: AppTypography.label.copyWith(color: const Color(0xFF16A34A)),
            ),
          ),
          IconButton(
            icon: const Icon(LucideIcons.x, size: 16, color: Color(0xFF16A34A)),
            onPressed: () => setState(() => _showAutoMatchBanner = false),
          ),
        ],
      ),
    ).animate().slideY(begin: -0.2, end: 0, duration: 250.ms).fadeIn();
  }

  Widget _buildReviewHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Vérification (12 véhicules)', style: AppTypography.heading18),
        Row(
          children: [
            TextButton(onPressed: () {}, child: const Text('Tout sélectionner')),
            TextButton(onPressed: () {}, child: const Text('Désélectionner')),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4, // Simple mock list
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final isMatch = index < 2; // Match the first two for the demo
        return PSCard(
          child: Row(
            children: [
              Checkbox(value: true, onChanged: (v) {}, activeColor: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const PSVinDisplay(vin: 'JTDKN3DU5A0', isSmall: true),
                        if (isMatch) ...[
                          const SizedBox(width: 8),
                          PSChip(label: 'Matché', variant: PSChipVariant.success),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: 'Toyota Corolla',
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                              border: OutlineInputBorder(),
                            ),
                            style: AppTypography.body14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        PSChip(label: 'Berline', variant: PSChipVariant.category, categoryIndex: 0),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        PSButton(label: 'Importer 12 véhicules', isFullWidth: true, onPressed: () => Navigator.pop(context)),
        const SizedBox(height: AppSpacing.md),
        PSButton(label: 'Importer un autre fichier', variant: PSButtonVariant.secondary, isFullWidth: true, onPressed: () => setState(() => _showReview = false)),
      ],
    );
  }
}
