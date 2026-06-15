import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Progress indicators (spec §5, §8) — linear bar and circular ring.

class PSProgressBar extends StatelessWidget {
  const PSProgressBar({
    super.key,
    required this.value,
    this.height = 8,
    this.color,
    this.trackColor,
  });

  final double value; // 0.0 – 1.0
  final double height;
  final Color? color;
  final Color? trackColor;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.clamp(0, 1)),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, _) {
        return Container(
          height: height,
          decoration: BoxDecoration(
            color: trackColor ?? AppColors.border,
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: animatedValue,
            child: Container(
              decoration: BoxDecoration(
                color: color ?? AppColors.primary,
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
          ),
        );
      },
    );
  }
}

class PSProgressRing extends StatelessWidget {
  const PSProgressRing({
    super.key,
    required this.value,
    this.size = 60,
    this.strokeWidth = 6,
    this.color,
    this.centerText,
    this.centerSubText,
  });

  final double value; // 0.0 – 1.0
  final double size;
  final double strokeWidth;
  final Color? color;
  final String? centerText;
  final String? centerSubText;

  Color get _color {
    if (color != null) return color!;
    if (value < 0.5) return AppColors.error;
    if (value < 0.8) return AppColors.warning;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.clamp(0, 1)),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, _) {
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: animatedValue,
                strokeWidth: strokeWidth,
                backgroundColor: AppColors.border,
                valueColor: AlwaysStoppedAnimation(_color),
                strokeCap: StrokeCap.round,
              ),
              if (centerText != null)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        centerText!,
                        style: AppTypography.label.copyWith(color: AppColors.textPrimary),
                      ),
                      if (centerSubText != null)
                        Text(
                          centerSubText!,
                          style: AppTypography.body12.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                          ),
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
}
