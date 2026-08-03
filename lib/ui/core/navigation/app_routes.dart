import 'package:flutter/material.dart';
import 'package:algorithmix/ui/features/splash/views/splash_screen.dart';
import 'package:algorithmix/ui/features/auth/views/login_screen.dart';
import 'package:algorithmix/ui/features/auth/views/register_screen.dart';
import 'package:algorithmix/ui/features/dashboard/views/dashboard_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/core_patterns_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/two_pointers_detail_screen.dart';
import 'package:algorithmix/ui/features/algorithms/views/algorithms_screen.dart';
import 'package:algorithmix/ui/features/dsa/views/dsa_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String corePatterns = '/core-patterns';
  static const String twoPointersDetail = '/two-pointers-detail';
  static const String algorithms = '/algorithms';
  static const String dsa = '/dsa';

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      dashboard: (context) => const DashboardScreen(),
      corePatterns: (context) => const CorePatternsScreen(),
      twoPointersDetail: (context) => const TwoPointersDetailScreen(),
      algorithms: (context) => const AlgorithmsScreen(),
      dsa: (context) => const DsaScreen(),
    };
  }
}
