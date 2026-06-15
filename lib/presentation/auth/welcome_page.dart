import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/ps_button.dart';

/// A2 — Welcome screen: "Bienvenue" heading + two CTAs.
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Text(
                'PortScan',
                style: AppTypography.heading28.copyWith(color: AppColors.textPrimary),
              ).animate().fadeIn(duration: 300.ms),
              const SizedBox(height: AppSpacing.xxxl),
              Text(
                'Bienvenue',
                style: AppTypography.heading24.copyWith(color: AppColors.textPrimary),
              ).animate().fadeIn(duration: 300.ms, delay: 100.ms),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Gérez vos inspections de véhicules au port',
                style: AppTypography.body14.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
              const Spacer(flex: 2),
              PSButton(
                label: 'Créer mon entreprise',
                icon: LucideIcons.building2,
                onPressed: () => Navigator.of(context).pushNamed('/create-company'),
                isFullWidth: true,
              ).animate().fadeIn(duration: 200.ms, delay: 300.ms).slideY(begin: 0.04, end: 0),
              const SizedBox(height: AppSpacing.md),
              PSButton(
                label: 'Rejoindre une entreprise',
                icon: LucideIcons.qrCode,
                variant: PSButtonVariant.secondary,
                onPressed: () => Navigator.of(context).pushNamed('/join-company'),
                isFullWidth: true,
              ).animate().fadeIn(duration: 200.ms, delay: 400.ms).slideY(begin: 0.04, end: 0),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
