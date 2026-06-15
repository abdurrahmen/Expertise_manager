import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Styled text field (spec §8) — label above, focus ring, optional VIN variant.
class PSInput extends StatelessWidget {
  const PSInput({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.leadingIcon,
    this.trailingIcon,
    this.onTrailingTap,
    this.isVin = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.keyboardType,
    this.onChanged,
    this.errorText,
    this.enabled = true,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final VoidCallback? onTrailingTap;
  final bool isVin;
  final bool obscureText;
  final int maxLines;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTypography.label.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        TextField(
          controller: controller,
          obscureText: obscureText,
          maxLines: maxLines,
          keyboardType: keyboardType,
          onChanged: onChanged,
          enabled: enabled,
          style: isVin
              ? AppTypography.mono15.copyWith(color: AppColors.textPrimary)
              : AppTypography.body15.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: isVin ? AppColors.background : AppColors.surface,
            prefixIcon: leadingIcon != null
                ? Icon(leadingIcon, size: 20, color: AppColors.textMuted)
                : null,
            suffixIcon: trailingIcon != null
                ? IconButton(
                    icon: Icon(trailingIcon, size: 20, color: AppColors.textMuted),
                    onPressed: onTrailingTap,
                  )
                : null,
            errorText: errorText,
            errorStyle: AppTypography.body12.copyWith(color: AppColors.error),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.base,
              vertical: AppSpacing.md,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

/// Search bar with icon.
class PSSearchBar extends StatelessWidget {
  const PSSearchBar({
    super.key,
    this.controller,
    this.hint = 'Rechercher...',
    this.onChanged,
  });

  final TextEditingController? controller;
  final String hint;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return PSInput(
      controller: controller,
      hint: hint,
      leadingIcon: Icons.search,
      onChanged: onChanged,
    );
  }
}
