import 'package:provider/provider.dart';
import 'package:campus_connect/src/data/datasources/remote/auth_api.dart';
import 'package:campus_connect/src/data/repositories/auth_repository_impl.dart';
import 'package:campus_connect/src/presentation/providers/auth_provider.dart';

class DependencyInjection {
  static List<ChangeNotifierProvider> providers = [
    ChangeNotifierProvider<AuthProvider>(
      create: (context) => AuthProvider(
        authRepository: AuthRepositoryImpl(
          authApi: AuthApi(),
        ),
      ),
    ),
  ];
}