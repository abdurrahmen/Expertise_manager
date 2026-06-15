import 'package:flutter/material.dart';

/// PortScan design-system color tokens (spec §1).
/// Light mode only — modern blue accent on white/light-gray.
class AppColors {
  AppColors._();

  // ── Primary ──
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryHover = Color(0xFF1D4ED8);
  static const Color primaryLight = Color(0xFFDBEAFE);
  static const Color primarySubtle = Color(0xFFEFF6FF);

  // ── Surfaces ──
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E8F0);

  // ── Text ──
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  // ── Status ──
  static const Color success = Color(0xFF16A34A);
  static const Color successBg = Color(0xFFF0FDF4);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningBg = Color(0xFFFFFBEB);
  static const Color error = Color(0xFFDC2626);
  static const Color errorBg = Color(0xFFFEF2F2);

  // ── Category tag palette (6 colors, cycle by index) ──
  static const List<Color> categoryBg = [
    Color(0xFFDBEAFE), // blue
    Color(0xFFEDE9FE), // violet
    Color(0xFFD1FAE5), // teal
    Color(0xFFFEF3C7), // amber
    Color(0xFFFCE7F3), // rose
    Color(0xFFE0E7FF), // indigo
  ];

  static const List<Color> categoryText = [
    Color(0xFF1E40AF),
    Color(0xFF5B21B6),
    Color(0xFF065F46),
    Color(0xFF92400E),
    Color(0xFF9D174D),
    Color(0xFF3730A3),
  ];

  /// Get category background color by index (cycles through 6).
  static Color getCategoryBg(int index) => categoryBg[index % categoryBg.length];

  /// Get category text color by index (cycles through 6).
  static Color getCategoryText(int index) => categoryText[index % categoryText.length];

  // ── Vehicle type tags ──
  static const Color vehicleRecenteBg = primaryLight;
  static const Color vehicleRecenteText = primary;
  static const Color vehicleAncienneBg = Color(0xFFF1F5F9);
  static const Color vehicleAncienneText = Color(0xFF475569);

  // ── Elevation ──
  static const List<BoxShadow> elevation = [
    BoxShadow(
      color: Color(0x140F172A), // rgba(15,23,42,0.08)
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  // ── Subtle grid line color (charts) ──
  static const Color gridLine = Color(0xFFF1F5F9);
}
