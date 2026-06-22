import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key, this.pendingCount = 0});

  final int pendingCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.warning,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.wifiOff, size: 16, color: AppColors.textPrimary),
            const SizedBox(width: 8),
            Text(
              'Mode hors ligne engagé',
              style: AppTypography.label.copyWith(color: AppColors.textPrimary),
            ),
            if (pendingCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.textPrimary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$pendingCount en attente',
                  style: AppTypography.labelSmall.copyWith(color: AppColors.warning),
                ),
              ),
            ],
          ],
        ),
      ),
    ).animate().slideY(begin: -1, end: 0, duration: 300.ms, curve: Curves.easeOut);
  }
}
