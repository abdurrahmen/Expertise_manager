import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Button variants following spec §8.
enum PSButtonVariant { primary, secondary, ghost, destructive }

class PSButton extends StatefulWidget {
  const PSButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = PSButtonVariant.primary,
    this.icon,
    this.isSmall = false,
    this.isFullWidth = false,
    this.isEnabled = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final PSButtonVariant variant;
  final IconData? icon;
  final bool isSmall;
  final bool isFullWidth;
  final bool isEnabled;

  @override
  State<PSButton> createState() => _PSButtonState();
}

class _PSButtonState extends State<PSButton> {
  bool _pressing = false;

  Color get _bgColor {
    if (!widget.isEnabled) return AppColors.border;
    switch (widget.variant) {
      case PSButtonVariant.primary:
        return _pressing ? AppColors.primaryHover : AppColors.primary;
      case PSButtonVariant.secondary:
        return AppColors.surface;
      case PSButtonVariant.ghost:
        return Colors.transparent;
      case PSButtonVariant.destructive:
        return AppColors.errorBg;
    }
  }

  Color get _textColor {
    if (!widget.isEnabled) return AppColors.textMuted;
    switch (widget.variant) {
      case PSButtonVariant.primary:
        return Colors.white;
      case PSButtonVariant.secondary:
        return AppColors.textPrimary;
      case PSButtonVariant.ghost:
        return AppColors.primary;
      case PSButtonVariant.destructive:
        return AppColors.error;
    }
  }

  BorderSide? get _border {
    if (widget.variant == PSButtonVariant.secondary) {
      return const BorderSide(color: AppColors.border);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.isSmall ? AppSpacing.buttonHeightSmall : AppSpacing.buttonHeight;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressing = true),
      onTapUp: (_) => setState(() => _pressing = false),
      onTapCancel: () => setState(() => _pressing = false),
      child: AnimatedScale(
        scale: _pressing ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: SizedBox(
          width: widget.isFullWidth ? double.infinity : null,
          height: height,
          child: Material(
            color: _bgColor,
            borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
            child: InkWell(
              onTap: widget.isEnabled ? widget.onPressed : null,
              borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
                  border: _border != null ? Border.fromBorderSide(_border!) : null,
                ),
                child: Row(
                  mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, size: 20, color: _textColor),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                    Text(widget.label, style: AppTypography.button.copyWith(color: _textColor)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Icon-only button (36×36, transparent → primarySubtle on hover).
class PSIconButton extends StatelessWidget {
  const PSIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.color,
    this.size = 20,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final child = Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
        hoverColor: AppColors.primarySubtle,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon, size: size, color: color ?? AppColors.textPrimary),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: child);
    }
    return child;
  }
}
