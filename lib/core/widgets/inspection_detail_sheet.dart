import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'ps_app_bar.dart';
import 'ps_chip.dart';
import 'ps_vin_display.dart';
import '../../data/models.dart';

class InspectionDetailSheet extends StatelessWidget {
  const InspectionDetailSheet({super.key, required this.inspection});

  final Inspection inspection;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Détails de l\'inspection', style: AppTypography.heading18.copyWith(color: AppColors.textPrimary)),
                IconButton(icon: const Icon(LucideIcons.x), onPressed: () => Navigator.of(context).pop()),
              ],
            ),
          ),
          const Divider(),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (inspection.vin != null) PSVinDisplay(vin: inspection.vin!) else Text('Ancienne', style: AppTypography.heading20.copyWith(color: AppColors.textPrimary)),
                      const Spacer(),
                      if (inspection.type == VehicleType.recente)
                        PSChip(label: 'Récente', variant: PSChipVariant.vehicleRecente)
                      else
                        PSChip(label: 'Ancienne', variant: PSChipVariant.vehicleAncienne),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(inspection.model ?? 'Modèle inconnu', style: AppTypography.body14.copyWith(color: AppColors.textPrimary)),
                  const SizedBox(height: AppSpacing.xl),
                  _buildRow(LucideIcons.userCircle, 'Fait par', inspection.memberName),
                  const SizedBox(height: AppSpacing.sm),
                  _buildRow(LucideIcons.ship, 'Navire', inspection.vesselName),
                  const SizedBox(height: AppSpacing.sm),
                  _buildRow(LucideIcons.clock, 'Date & Heure', inspection.timestamp),
                  const SizedBox(height: AppSpacing.xxl),
                  Text('Notes', style: AppTypography.label.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: AppSpacing.sm),
                  Text(inspection.notes ?? 'Aucune observation.', style: AppTypography.body14.copyWith(color: AppColors.textPrimary)),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: AppSpacing.sm),
        Text(label, style: AppTypography.body14.copyWith(color: AppColors.textSecondary)),
        const Spacer(),
        Text(value, style: AppTypography.body14.copyWith(color: AppColors.textPrimary)),
      ],
    );
  }
}
