import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'ps_progress.dart';

/// KPI stat card with animated number and optional circular ring (spec §5).
class KPICard extends StatelessWidget {
  const KPICard({
    super.key,
    required this.value,
    required this.label,
    this.ringValue,
    this.icon,
    this.trend,
    this.ringColor,
    this.suffix,
    this.showLinearProgress = false,
    this.linearValue = 0,
  });

  final int value;
  final String label;
  final double? ringValue; // 0.0 – 1.0 for circular ring
  final IconData? icon;
  final String? trend; // e.g. "+12% vs hier"
  final Color? ringColor;
  final String? suffix; // e.g. "/20"
  final bool showLinearProgress;
  final double linearValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    TweenAnimationBuilder<int>(
                      tween: IntTween(begin: 0, end: value),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOutCubic,
                      builder: (context, val, _) {
                        return Text(
                          '$val${suffix ?? ''}',
                          style: AppTypography.statNumber.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        );
                      },
                    ),
                    if (icon != null) ...[
                      const SizedBox(width: 8),
                      Icon(icon, size: 20, color: AppColors.textSecondary),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: AppTypography.statLabel.copyWith(color: AppColors.textSecondary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (trend != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        trend!.startsWith('+') ? Icons.trending_up : Icons.trending_down,
                        size: 14,
                        color: trend!.startsWith('+') ? AppColors.success : AppColors.error,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        trend!,
                        style: AppTypography.body12.copyWith(
                          color: trend!.startsWith('+') ? AppColors.success : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ],
                if (showLinearProgress) ...[
                  const SizedBox(height: 8),
                  PSProgressBar(value: linearValue, height: 6),
                ],
              ],
            ),
          ),
          if (ringValue != null) ...[
            const SizedBox(width: 12),
            PSProgressRing(
              value: ringValue!,
              size: 60,
              strokeWidth: 6,
              color: ringColor,
              centerText: '${(ringValue! * 100).round()}%',
            ),
          ],
        ],
      ),
    );
  }
}
