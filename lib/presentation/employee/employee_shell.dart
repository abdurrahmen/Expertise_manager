import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/ps_nav.dart';
import '../../data/mock_data.dart';
import 'employee_home_page.dart';
import 'history_page.dart';
import 'new_inspection_page.dart';
import 'profile_page.dart';
import 'search_page.dart';

class EmployeeShell extends StatefulWidget {
  const EmployeeShell({super.key});

  @override
  State<EmployeeShell> createState() => _EmployeeShellState();
}

class _EmployeeShellState extends State<EmployeeShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const EmployeeHomePage(),
    const SearchPage(),
    const HistoryPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final employee = MockData.members[1]; // Yacine Adli

    return PSAdaptiveNav(
      items: const [
        PSNavItem(icon: LucideIcons.home, label: 'Accueil'),
        PSNavItem(icon: LucideIcons.search, label: 'Rechercher'),
        PSNavItem(icon: LucideIcons.history, label: 'Historique'),
        PSNavItem(icon: LucideIcons.userCircle, label: 'Profil'),
      ],
      currentIndex: _currentIndex,
      onIndexChanged: (i) => setState(() => _currentIndex = i),
      userName: employee.name,
      roleLabel: 'Employé(e)',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => const NewInspectionPage(),
            fullscreenDialog: true,
          ));
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(LucideIcons.camera, color: Colors.white),
        label: const Text('Nouvelle inspection', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: _pages[_currentIndex],
    );
  }
}
