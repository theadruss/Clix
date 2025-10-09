import 'package:provider/provider.dart';
import 'package:campus_connect/src/presentation/providers/auth_provider.dart';
import 'package:campus_connect/src/presentation/providers/event_provider.dart';
import 'package:campus_connect/src/presentation/providers/club_provider.dart';

class DependencyInjection {
  static List<ChangeNotifierProvider> get providers => [
    ChangeNotifierProvider<AuthProvider>(
      create: (context) => AuthProvider(),
    ),
    ChangeNotifierProvider<EventProvider>(
      create: (context) => EventProvider(),
    ),
    ChangeNotifierProvider<ClubProvider>(
      create: (context) => ClubProvider(),
    ),
  ];
}