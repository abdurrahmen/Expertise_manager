import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import 'core/theme/app_theme.dart';
import 'presentation/auth/splash_page.dart';
import 'presentation/auth/welcome_page.dart';
import 'presentation/auth/create_company_page.dart';
import 'presentation/auth/join_company_page.dart';
import 'presentation/auth/select_profile_page.dart';
import 'presentation/auth/pin_entry_page.dart';
import 'presentation/boss/boss_shell.dart';
import 'presentation/employee/employee_shell.dart';

void main() {
  runApp(const PortScanApp());
}

class PortScanApp extends StatelessWidget {
  const PortScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp(
        title: 'PortScan',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashPage(),
          '/welcome': (context) => const WelcomePage(),
          '/create-company': (context) => const CreateCompanyPage(),
          '/join-company': (context) => const JoinCompanyPage(),
          '/select-profile': (context) => const SelectProfilePage(),
          '/pin': (context) => const PinEntryPage(),
          '/boss': (context) => const BossShell(),
          '/employee': (context) => const EmployeeShell(),
        },
      ),
    );
  }
}
