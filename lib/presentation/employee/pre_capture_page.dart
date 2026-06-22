import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/ps_app_bar.dart';
import '../../core/widgets/ps_button.dart';
import '../../core/widgets/ps_input.dart';
import '../../data/models.dart';

class PreCapturePage extends StatefulWidget {
  const PreCapturePage({super.key});

  @override
  State<PreCapturePage> createState() => _PreCapturePageState();
}

class _PreCapturePageState extends State<PreCapturePage> {
  VehicleType _selectedType = VehicleType.recente;
  final _vinCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _kmCtrl = TextEditingController();

  @override
  void dispose() {
    _vinCtrl.dispose();
    _notesCtrl.dispose();
    _kmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PSAppBar(
        title: 'Pré-capturer un véhicule',
        showBack: true,
        onBackOverride: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Column(
          children: [
            // Info banner
            Container(
              padding: const EdgeInsets.all(AppSpacing.base),
              decoration: BoxDecoration(
                color: AppColors.primarySubtle,
                borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.archive, size: 20, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'Ce véhicule n\'est pas encore demandé. Il sera livré automatiquement si le patron en fait la demande.',
                      style: AppTypography.body13.copyWith(color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Type toggle
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  _buildTypeOption(VehicleType.recente, 'Récente', LucideIcons.car),
                  _buildTypeOption(VehicleType.ancienne, 'Ancienne', LucideIcons.wrench),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            if (_selectedType == VehicleType.recente) ...[
              PSInput(
                controller: _vinCtrl,
                label: 'Code VIN (17 caractères)',
                hint: 'Entrez le VIN...',
                maxLength: 17,
                style: AppTypography.mono15,
                suffixIcon: IconButton(
                  icon: const Icon(LucideIcons.scanLine),
                  onPressed: () {},
                ),
                onChanged: (v) => setState(() {}),
              ),
              _buildVinStatus(_vinCtrl.text),
              const SizedBox(height: AppSpacing.lg),
            ] else ...[
               PSInput(
                controller: _kmCtrl,
                label: 'Kilométrage',
                hint: '0',
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(LucideIcons.gauge, size: 20),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],

            // Photo Grid (2x2)
            _buildPhotoGrid(),

            const SizedBox(height: AppSpacing.lg),
            PSInput(
              controller: _notesCtrl,
              label: 'Observations',
              hint: 'État du véhicule, dommages...',
              maxLines: 3,
            ),
            const SizedBox(height: AppSpacing.xxl),
            PSButton(
              label: 'Ajouter à ma réserve',
              isFullWidth: true,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Véhicule ajouté à votre réserve ✓'), backgroundColor: AppColors.success),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeOption(VehicleType type, String label, IconData icon) {
    final isSelected = _selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedType = type),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryLight : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusInput - 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: isSelected ? AppColors.primary : AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(label, style: AppTypography.label.copyWith(color: isSelected ? AppColors.primary : AppColors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVinStatus(String vin) {
    if (vin.length < 17) return const SizedBox();
    // Simulate statuses
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          const Icon(LucideIcons.checkCircle2, size: 16, color: AppColors.success),
          const SizedBox(width: 6),
          Text('Nouveau — non demandé', style: AppTypography.body13.copyWith(color: AppColors.success)),
        ],
      ),
    );
  }

  Widget _buildPhotoGrid() {
    final labels = _selectedType == VehicleType.recente 
      ? ['Plaque', 'Châssis', 'Avant', 'Arrière']
      : ['Avant', 'Compteur km', 'Plaque', 'Châssis'];
    final icons = _selectedType == VehicleType.recente
      ? [LucideIcons.hash, LucideIcons.idCard, LucideIcons.arrowUp, LucideIcons.arrowDown]
      : [LucideIcons.arrowUp, LucideIcons.gauge, LucideIcons.hash, LucideIcons.idCard];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: 4,
      itemBuilder: (context, i) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border, style: BorderStyle.solid),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icons[i], size: 24, color: AppColors.textMuted),
              const SizedBox(height: 8),
              Text(labels[i], style: AppTypography.body12.copyWith(color: AppColors.textSecondary)),
            ],
          ),
        );
      },
    );
  }
}
