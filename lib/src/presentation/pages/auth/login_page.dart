import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/text_styles.dart';
import '../../../presentation/providers/auth_provider.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (authProvider.error != null) {
        _showErrorDialog(authProvider.error!);
      }
    }
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkGray,
        title: Text(
          'Login Failed',
          style: AppTextStyles.headlineSmall.copyWith(color: AppColors.pureWhite),
        ),
        content: Text(
          error,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.pureWhite),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: AppTextStyles.buttonMedium.copyWith(color: AppColors.accentYellow),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                // Logo and Welcome
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.accentYellow,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.school_rounded,
                          size: 40,
                          color: AppColors.darkGray,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Welcome to CampusConnect',
                        style: AppTextStyles.headlineLarge.copyWith(
                          fontSize: 28,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to manage campus events',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.mediumGray,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                // Login Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        label: 'Email',
                        hintText: 'Enter your email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email_rounded),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        label: 'Password',
                        hintText: 'Enter your password',
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        prefixIcon: const Icon(Icons.lock_rounded),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // TODO: Implement forgot password
                          },
                          child: Text(
                            'Forgot Password?',
                            style: AppTextStyles.link,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      CustomButton(
                        text: 'Sign In',
                        onPressed: _handleLogin,
                        isLoading: authProvider.isLoading,
                      ),
                      const SizedBox(height: 24),
                      // Quick Login Demo Buttons
                      Text(
                        'Demo Accounts',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.mediumGray,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: [
                          _DemoAccountChip(
                            role: 'Admin',
                            email: 'admin@campus.edu',
                            password: 'password',
                            onTap: (email, password) {
                              _emailController.text = email;
                              _passwordController.text = password;
                              _handleLogin();
                            },
                          ),
                          _DemoAccountChip(
                            role: 'Student',
                            email: 'student@campus.edu',
                            password: 'password',
                            onTap: (email, password) {
                              _emailController.text = email;
                              _passwordController.text = password;
                              _handleLogin();
                            },
                          ),
                          _DemoAccountChip(
                            role: 'Club',
                            email: 'club@campus.edu',
                            password: 'password',
                            onTap: (email, password) {
                              _emailController.text = email;
                              _passwordController.text = password;
                              _handleLogin();
                            },
                          ),
                          _DemoAccountChip(
                            role: 'Advisor',
                            email: 'advisor@campus.edu',
                            password: 'password',
                            onTap: (email, password) {
                              _emailController.text = email;
                              _passwordController.text = password;
                              _handleLogin();
                            },
                          ),
                          _DemoAccountChip(
                            role: 'External',
                            email: 'external@org.com',
                            password: 'password',
                            onTap: (email, password) {
                              _emailController.text = email;
                              _passwordController.text = password;
                              _handleLogin();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.mediumGray,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: AppTextStyles.link.copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DemoAccountChip extends StatelessWidget {
  final String role;
  final String email;
  final String password;
  final Function(String, String) onTap;

  const _DemoAccountChip({
    required this.role,
    required this.email,
    required this.password,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(email, password),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.darkGray,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.accentYellow,
            width: 1,
          ),
        ),
        child: Text(
          role,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.accentYellow,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
