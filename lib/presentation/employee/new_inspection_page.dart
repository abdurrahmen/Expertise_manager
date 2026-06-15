import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/ps_app_bar.dart';
import '../../core/widgets/ps_button.dart';
import '../../core/widgets/ps_chip.dart';
import '../../core/widgets/ps_input.dart';
import '../../core/widgets/ps_toast.dart';

class NewInspectionPage extends StatefulWidget {
  const NewInspectionPage({super.key});

  @override
  State<NewInspectionPage> createState() => _NewInspectionPageState();
}

class _NewInspectionPageState extends State<NewInspectionPage> {
  int _typeIndex = 0; // 0: Récente, 1: Ancienne
  final _vinCtrl = TextEditingController();

  Set<String> takenPhotos = {};

  void _submit() {
    PSToast.show(context, message: 'Inspection enregistrée avec succès');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PSAppBar(
        title: 'Nouvelle inspection',
        showBack: true,
        onBack: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Segmented Control
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    _buildSegment(0, 'Récente', LucideIcons.car),
                    _buildSegment(1, 'Ancienne', LucideIcons.wrench),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              if (_typeIndex == 0) ...[
                // Récente
                PSInput(
                  controller: _vinCtrl,
                  label: 'Numéro de châssis (VIN)',
                  hint: 'Scanner ou saisir...',
                  isVin: true,
                  trailingIcon: LucideIcons.scanLine,
                  onTrailingTap: () {
                    // Mock scan
                    setState(() { _vinCtrl.text = 'WVWZZZ3CZW0101'; });
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${_vinCtrl.text.length}/17', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                    if (_vinCtrl.text.length == 14)
                      PSChip(label: 'Dans la liste', variant: PSChipVariant.success),
                  ],
                ),
              ] else ...[
                // Ancienne
                Text('Navire', style: AppTypography.label.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text('Sélectionner un navire'),
                      items: const [
                        DropdownMenuItem(value: '1', child: Text('MSC Fantasia')),
                        DropdownMenuItem(value: '2', child: Text('CMA CGM Marco Polo')),
                      ],
                      onChanged: (v) {},
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.base),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.target, size: 20, color: AppColors.textSecondary),
                      const SizedBox(width: AppSpacing.md),
                      Text('Véhicules anciens : 6/10', style: AppTypography.body14.copyWith(color: AppColors.textPrimary)),
                      const SizedBox(width: AppSpacing.md),
                      const Expanded(
                        child: LinearProgressIndicator(value: 0.6, backgroundColor: AppColors.border, minHeight: 6, borderRadius: BorderRadius.all(Radius.circular(3))),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                const PSInput(
                  label: 'Kilométrage',
                  hint: '0',
                  leadingIcon: LucideIcons.gauge,
                  keyboardType: TextInputType.number,
                ),
              ],

              const SizedBox(height: AppSpacing.xxl),
              Text('Photos obligatoires', style: AppTypography.label.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.sm),
              // Photos Grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: AppSpacing.md,
                crossAxisSpacing: AppSpacing.md,
                childAspectRatio: 1.2,
                children: [
                  _buildPhotoTile('Plaque', LucideIcons.hash),
                  _buildPhotoTile('Châssis/VIN', LucideIcons.idCard),
                  _buildPhotoTile('Avant', LucideIcons.arrowUp),
                  if (_typeIndex == 0) _buildPhotoTile('Arrière', LucideIcons.arrowDown)
                  else _buildPhotoTile('Compteur', LucideIcons.gauge),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
              const PSInput(
                label: 'Observations',
                hint: 'Observations, état du véhicule...',
                maxLines: 4,
              ),
              const SizedBox(height: AppSpacing.xxxl),
              SizedBox(
                height: AppSpacing.fabHeight,
                child: PSButton(
                  label: 'Enregistrer l\'inspection',
                  onPressed: _submit,
                  isFullWidth: true,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegment(int index, String label, IconData icon) {
    final isActive = _typeIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _typeIndex = index),
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryLight : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusInput - 4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: isActive ? AppColors.primary : AppColors.textSecondary),
              const SizedBox(width: AppSpacing.sm),
              Text(
                label,
                style: AppTypography.label.copyWith(
                  color: isActive ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoTile(String label, IconData icon) {
    final isTaken = takenPhotos.contains(label);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isTaken) takenPhotos.remove(label);
          else takenPhotos.add(label);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isTaken ? AppColors.primaryLight.withOpacity(0.5) : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          border: isTaken
              ? Border.all(color: AppColors.primary)
              : Border.all(color: AppColors.border, style: BorderStyle.solid), // Should be dashed for empty
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(isTaken ? LucideIcons.image : icon, size: 28, color: isTaken ? AppColors.primary : AppColors.textMuted),
                const SizedBox(height: AppSpacing.sm),
                Text(label, style: AppTypography.body13.copyWith(color: isTaken ? AppColors.primary : AppColors.textSecondary)),
              ],
            ),
            if (isTaken)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: Icon(LucideIcons.checkCircle2, size: 20, color: AppColors.success),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
