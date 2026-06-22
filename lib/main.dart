import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/app_theme.dart';
import 'presentation/auth/splash_page.dart';
import 'presentation/auth/welcome_page.dart';
import 'presentation/auth/create_company_page.dart';
import 'presentation/auth/join_company_page.dart';
import 'presentation/auth/select_profile_page.dart';
import 'presentation/auth/pin_entry_page.dart';
import 'presentation/boss/boss_shell.dart';
import 'presentation/employee/employee_shell.dart';
import 'presentation/employee/employee_home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Prevent Google Fonts from making network requests that can silently
  // block app startup on web and mobile — use bundled/system fonts instead.
  GoogleFonts.config.allowRuntimeFetching = false;

  // Surface Flutter framework errors
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kDebugMode) {
      debugPrint('FlutterError: ${details.exceptionAsString()}');
    }
  };

  runZonedGuarded(
    () => runApp(const PortScanApp()),
    (error, stack) {
      if (kDebugMode) {
        debugPrint('Uncaught error: $error');
        debugPrint('$stack');
      }
    },
  );
}

class PortScanApp extends StatelessWidget {
  const PortScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PortScan',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(),
        '/welcome': (context) => const WelcomePage(),
        '/create-company': (context) => const CreateCompanyPage(),
        '/join-company': (context) => const JoinCompanyPage(),
        '/select-profile': (context) => const SelectProfilePage(),
        '/pin': (context) => const PinEntryPage(),
        '/boss': (context) => const BossShell(),
        '/employee': (context) => const EmployeeShell(),
      },
    );
  }
}
