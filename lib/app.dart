import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/core/theme/app_theme.dart';
import 'src/presentation/pages/auth/login_page.dart';
import 'src/presentation/pages/student/student_dashboard.dart';
import 'src/presentation/pages/admin/admin_dashboard.dart';
import 'src/presentation/pages/club/club_dashboard.dart';
import 'src/config/dependency_injection.dart';
import 'src/presentation/providers/auth_provider.dart';

class CampusConnectApp extends StatelessWidget {
  const CampusConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: DependencyInjection.providers,
      child: MaterialApp(
        title: 'CampusConnect',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            // DEBUG: Print authentication state
            print('=== AUTH STATE ===');
            print('IsLoggedIn: ${authProvider.isLoggedIn}');
            print('User: ${authProvider.user}');
            print('User Role: ${authProvider.user?.role}');
            print('==================');
            
            if (authProvider.isLoggedIn) {
              final role = authProvider.user!.role;
              print('Navigating to dashboard for role: $role');
              return _getDashboardForRole(role);
            } else {
              return const LoginPage();
            }
          },
        ),
      ),
    );
  }

  Widget _getDashboardForRole(String role) {
    print('Getting dashboard for role: $role');
    
    switch (role) {
      case 'admin':
        return const AdminDashboard();
      case 'student':
        return const StudentDashboard();
      case 'advisor':
      case 'coordinator':
      case 'subgroup_head':
        return const ClubDashboard();
      default:
        print('Unknown role: $role, defaulting to StudentDashboard');
        return const StudentDashboard();
    }
  }
}