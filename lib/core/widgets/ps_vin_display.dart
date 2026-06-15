import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// VIN code display box — JetBrains Mono, background fill, border (spec §8).
class PSVinDisplay extends StatelessWidget {
  const PSVinDisplay({
    super.key,
    required this.vin,
    this.isSmall = false,
  });

  final String vin;
  final bool isSmall;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        vin,
        style: (isSmall ? AppTypography.mono13 : AppTypography.mono15).copyWith(
          color: AppColors.textPrimary,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
