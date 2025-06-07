/// lib/features/auth/presentation/pages/login_page.dart
///
/// The login screen where users can sign in to their accounts.
/// It interacts with the [AuthBloc] to handle login logic and state changes.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/utils/app_colors.dart';
import 'package:task_manager_app/utils/app_styles.dart';
import 'package:task_manager_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:task_manager_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:task_manager_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:task_manager_app/features/auth/presentation/widgets/auth_form_field.dart';
import 'package:task_manager_app/app/routes/app_router.dart'; // We'll define this later

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      BlocProvider.of<AuthBloc>(context).add(
        AuthLoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Navigate to task list page on successful login
            Navigator.of(context).pushReplacementNamed(AppRoutes.taskList);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.redError,
              ),
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // App Logo/Icon
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurple,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                    const SizedBox(height: 32.0),
                    Text(
                      'Welcome back!',
                      style: AppStyles.heading2.copyWith(color: AppColors.textDark),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24.0),
                    AuthFormField(
                      controller: _emailController,
                      labelText: 'Email Address',
                      hintText: 'example@email.com',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    AuthFormField(
                      controller: _passwordController,
                      labelText: 'Password',
                      hintText: '********',
                      obscureText: true,
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // TODO: Implement Forgot Password functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Forgot Password? Not implemented yet.')),
                          );
                        },
                        child: Text(
                          'Forgot password?',
                          style: AppStyles.smallText.copyWith(color: AppColors.greyText),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: state is AuthLoading ? null : _onLoginPressed,
                      style: AppStyles.primaryButtonStyle,
                      child: state is AuthLoading
                          ? const CircularProgressIndicator(color: AppColors.textLight)
                          : const Text('Log in'),
                    ),
                    const SizedBox(height: 24.0),
                    // Social login options (placeholder as per image)
                    Row(
                      children: [
                        const Expanded(child: Divider(color: AppColors.greyText)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('or log in with', style: AppStyles.smallText),
                        ),
                        const Expanded(child: Divider(color: AppColors.greyText)),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialButton(Icons.facebook), // Placeholder, actual integration needed
                        const SizedBox(width: 20),
                        _buildSocialButton(Icons.g_mobiledata), // Placeholder
                        const SizedBox(width: 20),
                        _buildSocialButton(Icons.apple), // Placeholder
                      ],
                    ),
                    const SizedBox(height: 32.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: AppStyles.bodyText2.copyWith(color: AppColors.greyText),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed(AppRoutes.registration);
                          },
                          child: Text(
                            'Get started!',
                            style: AppStyles.bodyText2.copyWith(color: AppColors.primaryPurple, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSocialButton(IconData icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.lightGreyBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyText.withOpacity(0.2)),
      ),
      child: Icon(icon, color: AppColors.textDark, size: 30),
    );
  }
}

