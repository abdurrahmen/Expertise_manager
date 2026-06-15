import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Status badge / chip (spec §8).
enum PSChipVariant { success, warning, error, category, filter, vehicleRecente, vehicleAncienne }

class PSChip extends StatelessWidget {
  const PSChip({
    super.key,
    required this.label,
    this.variant = PSChipVariant.filter,
    this.icon,
    this.isActive = false,
    this.categoryIndex = 0,
    this.onTap,
  });

  final String label;
  final PSChipVariant variant;
  final IconData? icon;
  final bool isActive;
  final int categoryIndex;
  final VoidCallback? onTap;

  Color get _bgColor {
    switch (variant) {
      case PSChipVariant.success:
        return AppColors.successBg;
      case PSChipVariant.warning:
        return AppColors.warningBg;
      case PSChipVariant.error:
        return AppColors.errorBg;
      case PSChipVariant.category:
        return AppColors.getCategoryBg(categoryIndex);
      case PSChipVariant.filter:
        return isActive ? AppColors.primaryLight : AppColors.surface;
      case PSChipVariant.vehicleRecente:
        return AppColors.vehicleRecenteBg;
      case PSChipVariant.vehicleAncienne:
        return AppColors.vehicleAncienneBg;
    }
  }

  Color get _textColor {
    switch (variant) {
      case PSChipVariant.success:
        return AppColors.success;
      case PSChipVariant.warning:
        return AppColors.warning;
      case PSChipVariant.error:
        return AppColors.error;
      case PSChipVariant.category:
        return AppColors.getCategoryText(categoryIndex);
      case PSChipVariant.filter:
        return isActive ? AppColors.primary : AppColors.textPrimary;
      case PSChipVariant.vehicleRecente:
        return AppColors.vehicleRecenteText;
      case PSChipVariant.vehicleAncienne:
        return AppColors.vehicleAncienneText;
    }
  }

  BorderSide get _border {
    switch (variant) {
      case PSChipVariant.filter:
        return BorderSide(
          color: isActive ? AppColors.primary : AppColors.border,
        );
      default:
        return BorderSide.none;
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.fromBorderSide(_border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: _textColor),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              style: AppTypography.labelSmall.copyWith(color: _textColor),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: child);
    }

    return child;
  }
}

/// Horizontal scrollable filter chip row (spec §8).
class PSFilterChipRow extends StatelessWidget {
  const PSFilterChipRow({
    super.key,
    required this.labels,
    required this.activeIndex,
    required this.onSelected,
    this.icons,
  });

  final List<String> labels;
  final int activeIndex;
  final ValueChanged<int> onSelected;
  final List<IconData?>? icons;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(labels.length, (i) {
          return Padding(
            padding: EdgeInsets.only(right: i < labels.length - 1 ? 8 : 0),
            child: PSChip(
              label: labels[i],
              variant: PSChipVariant.filter,
              isActive: i == activeIndex,
              icon: icons != null ? icons![i] : null,
              onTap: () => onSelected(i),
            ),
          );
        }),
      ),
    );
  }
}
