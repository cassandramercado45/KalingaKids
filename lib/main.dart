import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/app_state.dart';
import 'theme.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/main_navigation_wrapper.dart';
import 'screens/info/about_screen.dart';
import 'screens/info/faq_screen.dart';
import 'screens/info/contact_screen.dart';
import 'screens/info/emergency_screen.dart';
import 'screens/info/admin_inbox_screen.dart';
import 'screens/admin/barangay_detail_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/wellness/growth_monitoring_screen.dart';
import 'screens/wellness/vaccination_screen.dart';
import 'screens/wellness/milestones_screen.dart';
import 'screens/parenting/nutrition_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const KalingaKidsApp(),
    ),
  );
}

class KalingaKidsApp extends StatelessWidget {
  const KalingaKidsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return MaterialApp(
      title: 'KalingaKids',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: !appState.isInitialized
          ? const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            )
          : const SplashScreen(),
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const MainNavigationWrapper(),
        '/profile': (context) => const MainNavigationWrapper(initialIndex: 3),
        '/about': (context) => const AboutScreen(),
        '/faq': (context) => const FAQScreen(),
        '/contact': (context) => const ContactScreen(),
        '/emergency': (context) => const EmergencyScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/growth': (context) => const GrowthMonitoringScreen(),
        '/vaccination': (context) => const VaccinationScreen(),
        '/milestones': (context) => const MilestonesScreen(),
        '/nutrition': (context) => const NutritionScreen(),
        '/admin_inbox': (context) => const AdminInboxScreen(),
        '/barangay_detail': (context) => const BarangayDetailScreen(),
      },
    );
  }
}
