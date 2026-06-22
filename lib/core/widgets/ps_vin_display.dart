import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// VIN code display box — JetBrains Mono, background fill, border (spec §8).
class PSVinDisplay extends StatelessWidget {
  const PSVinDisplay({
    super.key,
    required this.vin,
    this.isSmall = false,
    this.query = '',
  });

  final String vin;
  final bool isSmall;
  final String query;

  @override
  Widget build(BuildContext context) {
    Widget textWidget;
    final style = (isSmall ? AppTypography.mono13 : AppTypography.mono15).copyWith(
      color: AppColors.textPrimary,
    );

    if (query.isEmpty || !vin.toLowerCase().contains(query.toLowerCase())) {
      textWidget = Text(
        vin,
        style: style,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    } else {
      final matches = query.toLowerCase().allMatches(vin.toLowerCase());
      List<TextSpan> spans = [];
      int start = 0;
      for (var match in matches) {
        if (match.start > start) {
          spans.add(TextSpan(text: vin.substring(start, match.start)));
        }
        spans.add(TextSpan(
          text: vin.substring(match.start, match.end),
          style: const TextStyle(backgroundColor: Color(0xFFFFF176), color: Colors.black, fontWeight: FontWeight.bold),
        ));
        start = match.end;
      }
      if (start < vin.length) {
        spans.add(TextSpan(text: vin.substring(start)));
      }
      textWidget = RichText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(style: style, children: spans),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
        border: Border.all(color: AppColors.border),
      ),
      child: textWidget,
    );
  }

}
