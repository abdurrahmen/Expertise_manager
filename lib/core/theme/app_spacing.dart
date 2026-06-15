/// PortScan spacing & radius tokens (spec §4).
/// 4px base grid system.
class AppSpacing {
  AppSpacing._();

  // ── Spacing ──
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 40;

  // ── Border radius ──
  static const double radiusInput = 8;
  static const double radiusButton = 8;
  static const double radiusCard = 12;
  static const double radiusModal = 16;
  static const double radiusFull = 999;

  // ── Specific dimensions ──
  static const double appBarHeight = 56;
  static const double bottomNavHeight = 60;
  static const double navRailWidth = 72;
  static const double navRailExpandedWidth = 240;
  static const double inputHeight = 48;
  static const double buttonHeight = 48;
  static const double buttonHeightSmall = 40;
  static const double fabHeight = 52;
  static const double iconSize = 24;
  static const double iconSizeSmall = 20;
  static const double iconSizeLarge = 28;
  static const double iconSizeEmpty = 56;
  static const double maxContentWidth = 1400;

  // ── Breakpoints ──
  static const double breakpointMobile = 600;
  static const double breakpointTablet = 1024;
}
