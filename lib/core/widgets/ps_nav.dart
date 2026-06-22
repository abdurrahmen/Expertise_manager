import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Navigation item data.
class PSNavItem {
  final IconData icon;
  final String label;
  final String? section; // Added section support
  const PSNavItem({required this.icon, required this.label, this.section});
}

/// Adaptive navigation — bottom nav (<600px), nav rail (600–1024px),
/// expanded rail (>1024px) with active pill (spec §8, §10).
class PSAdaptiveNav extends StatelessWidget {
  const PSAdaptiveNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onIndexChanged,
    required this.body,
    this.roleLabel,
    this.userName,
    this.floatingActionButton,
    this.onLogout, // New logout support
  });

  final List<PSNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  final Widget body;
  final String? roleLabel;
  final String? userName;
  final Widget? floatingActionButton;
  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < AppSpacing.breakpointMobile) {
      return _buildWithBottomNav(context);
    } else if (width < AppSpacing.breakpointTablet) {
      return _buildWithNavRail(context, expanded: false);
    } else {
      return _buildWithNavRail(context, expanded: true);
    }
  }

  Widget _buildWithBottomNav(BuildContext context) {
    return Scaffold(
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        height: AppSpacing.bottomNavHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (i) {
            final isActive = i == currentIndex;
            return Expanded(
              child: GestureDetector(
                onTap: () => onIndexChanged(i),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  height: AppSpacing.bottomNavHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primaryLight : Colors.transparent,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
                        ),
                        child: Icon(
                          items[i].icon,
                          size: 24,
                          color: isActive ? AppColors.primary : AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        items[i].label,
                        style: AppTypography.navLabel.copyWith(
                          color: isActive ? AppColors.primary : AppColors.textMuted,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildWithNavRail(BuildContext context, {required bool expanded}) {
    final railWidth = expanded ? AppSpacing.navRailExpandedWidth : AppSpacing.navRailWidth;

    // Group items by section
    final Map<String?, List<int>> groups = {};
    for (int i = 0; i < items.length; i++) {
        final section = items[i].section;
        groups.putIfAbsent(section, () => []).add(i);
    }

    return Scaffold(
      floatingActionButton: floatingActionButton,
      body: Row(
        children: [
          Container(
            width: railWidth,
            color: AppColors.surface,
            child: Column(
              children: [
                // Wordmark
                Container(
                  height: AppSpacing.appBarHeight,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: expanded ? Alignment.centerLeft : Alignment.center,
                  child: Text(
                    expanded ? 'PortScan' : 'PS',
                    style: AppTypography.heading20.copyWith(color: AppColors.textPrimary),
                  ),
                ),
                const Divider(height: 1),
                const SizedBox(height: 8),
                // Nav items grouped by sections
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    children: [
                      for (final entry in groups.entries) ...[
                        if (entry.key != null && expanded)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
                            child: Text(
                              entry.key!.toUpperCase(),
                              style: AppTypography.body12.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          )
                        else if (entry.key != null && !expanded)
                          const Divider(height: 32, indent: 16, endIndent: 16),
                        
                        for (final i in entry.value)
                          _NavRailItem(
                            icon: items[i].icon,
                            label: items[i].label,
                            isActive: i == currentIndex,
                            expanded: expanded,
                            onTap: () => onIndexChanged(i),
                          ),
                      ],
                      // Logout as a secondary item
                      if (onLogout != null) ...[
                        const Divider(height: 32, indent: 16, endIndent: 16),
                        _NavRailItem(
                          icon: Icons.logout_rounded,
                          label: 'Déconnexion',
                          isActive: false,
                          expanded: expanded,
                          onTap: onLogout!,
                          isDestructive: true,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ],
                  ),
                ),
                // User section
                if (userName != null) ...[
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: expanded
                        ? Row(
                            children: [
                              _UserAvatar(name: userName!, size: 32),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(userName!, style: AppTypography.label.copyWith(color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                                    if (roleLabel != null)
                                      Text(roleLabel!, style: AppTypography.body12.copyWith(color: AppColors.textSecondary)),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : _UserAvatar(name: userName!, size: 32),
                  ),
                ],
              ],
            ),
          ),
          Container(width: 1, color: AppColors.border),
          Expanded(child: body),
        ],
      ),
    );
  }
}

class _NavRailItem extends StatelessWidget {
  const _NavRailItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.expanded,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final bool expanded;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive 
        ? Colors.red.shade400 
        : (isActive ? AppColors.primary : AppColors.textSecondary);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
          hoverColor: isDestructive ? Colors.red.withOpacity(0.05) : AppColors.primarySubtle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: expanded ? 12 : 0,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primaryLight : Colors.transparent,
              borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
            ),
            child: expanded
                ? Row(
                    children: [
                      Icon(icon, size: 22, color: color),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          label,
                          style: AppTypography.body14.copyWith(
                            color: color,
                            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Tooltip(
                      message: label,
                      child: Icon(icon, size: 22, color: color),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({required this.name, this.size = 40});

  final String name;
  final double size;

  String get _initials {
    final parts = name.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          _initials,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.primary,
            fontSize: size * 0.35,
          ),
        ),
      ),
    );
  }
}
