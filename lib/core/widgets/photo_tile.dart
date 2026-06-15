import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class PhotoTile extends StatelessWidget {
  const PhotoTile({
    super.key,
    required this.label,
    required this.icon,
    this.isTaken = false,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isTaken;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isTaken ? AppColors.primaryLight.withOpacity(0.5) : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          border: isTaken
              ? Border.all(color: AppColors.primary)
              : Border.all(color: AppColors.border, style: BorderStyle.solid), // Dashboard/dashed not naturally supported in short code
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
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.checkCircle2, size: 20, color: AppColors.success),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
