import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Floating toast component (spec §7).
enum PSToastType { success, error, info }

class PSToast {
  static void show(
    BuildContext context, {
    required String message,
    PSToastType type = PSToastType.success,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final iconData = _iconForType(type);
    final iconColor = _colorForType(type);
    final iconBgColor = _bgColorForType(type);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.surface,
        elevation: 4,
        margin: _marginForContext(context),
        duration: Duration(seconds: type == PSToastType.error ? 4 : 3),
        dismissDirection: DismissDirection.horizontal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AppColors.border),
        ),
        content: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, size: 16, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: AppTypography.body14.copyWith(color: AppColors.textPrimary),
              ),
            ),
            if (actionLabel != null)
              TextButton(
                onPressed: onAction,
                child: Text(
                  actionLabel,
                  style: AppTypography.label.copyWith(color: AppColors.primary),
                ),
              ),
          ],
        ),
      ),
    );
  }

  static IconData _iconForType(PSToastType type) {
    switch (type) {
      case PSToastType.success:
        return Icons.check_circle_outline;
      case PSToastType.error:
        return Icons.error_outline;
      case PSToastType.info:
        return Icons.info_outline;
    }
  }

  static Color _colorForType(PSToastType type) {
    switch (type) {
      case PSToastType.success:
        return AppColors.success;
      case PSToastType.error:
        return AppColors.error;
      case PSToastType.info:
        return AppColors.primary;
    }
  }

  static Color _bgColorForType(PSToastType type) {
    switch (type) {
      case PSToastType.success:
        return AppColors.successBg;
      case PSToastType.error:
        return AppColors.errorBg;
      case PSToastType.info:
        return AppColors.primarySubtle;
    }
  }

  static EdgeInsets _marginForContext(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1024) {
      // Desktop: bottom-right, max-width 380px
      return EdgeInsets.only(
        left: width - 380 - 16,
        right: 16,
        bottom: 16,
      );
    }
    return const EdgeInsets.all(16);
  }
}
