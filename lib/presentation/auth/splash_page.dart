import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// A1 — Splash screen: centered wordmark with fade-in, auto-navigates.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/welcome');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'PortScan',
              style: AppTypography.heading28.copyWith(color: AppColors.textPrimary),
            )
                .animate()
                .fadeIn(duration: 600.ms, curve: Curves.easeOut),
            const SizedBox(height: 8),
            Text(
              'Gestion logistique portuaire',
              style: AppTypography.body13.copyWith(color: AppColors.textSecondary),
            )
                .animate()
                .fadeIn(duration: 600.ms, delay: 200.ms, curve: Curves.easeOut),
          ],
        ),
      ),
    );
  }
}
