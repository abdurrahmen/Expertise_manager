import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/widgets/ps_nav.dart';
import '../../data/mock_data.dart';
import 'ai_import_page.dart';
import 'boss_dashboard_page.dart';
import 'reports_page.dart';
import 'settings_page.dart';
import 'team_categories_page.dart';
import 'vessels_list_page.dart';

/// Boss shell with adaptive navigation.
class BossShell extends StatefulWidget {
  const BossShell({super.key});

  @override
  State<BossShell> createState() => _BossShellState();
}

class _BossShellState extends State<BossShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const BossDashboardPage(),
    const VesselsListPage(),
    const AIImportPage(),
    const TeamCategoriesPage(),
    const ReportsPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    // Assuming Karim Benzema (boss) from mock data for demo
    final boss = MockData.members[0];

    return PSAdaptiveNav(
      items: const [
        PSNavItem(icon: LucideIcons.layoutDashboard, label: 'Tableau de bord'),
        PSNavItem(icon: LucideIcons.ship, label: 'Navires'),
        PSNavItem(icon: LucideIcons.sparkles, label: 'Importer'),
        PSNavItem(icon: LucideIcons.users, label: 'Équipe'),
        PSNavItem(icon: LucideIcons.fileText, label: 'Rapports'),
        PSNavItem(icon: LucideIcons.settings, label: 'Paramètres'),
      ],
      currentIndex: _currentIndex,
      onIndexChanged: (i) => setState(() => _currentIndex = i),
      userName: boss.name,
      roleLabel: 'Administrateur',
      body: _pages[_currentIndex],
    );
  }
}
