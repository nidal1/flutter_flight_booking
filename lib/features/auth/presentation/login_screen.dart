import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_flight_booking/core/services/firebase_service.dart'
    show GOOGLE_AUTH_FAILED, FACEBOOK_LOGIN_CANCELLED;
import 'package:flutter_flight_booking/l10n/app_localizations.dart';
import 'package:flutter_flight_booking/features/auth/controllers/auth_providers.dart';
import 'package:flutter_flight_booking/shared/widgets/login_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  _clearInputs() {
    _emailController.clear();
    _passwordController.clear();
  }

  Future<void> _submit(Future<void> Function() authFunc) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      await authFunc();
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      // final l10n = AppLocalizations.of(context)!;
      String? message = e.message;
      if (e.code == GOOGLE_AUTH_FAILED || e.code == FACEBOOK_LOGIN_CANCELLED) {
        message = null; // Don't show snackbar for cancellation
      }
      if (message != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.somethingWentWrong)));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      final authController = ref.read(authControllerProvider);
      _submit(() async {
        await authController.login(
          email: _emailController.text,
          password: _passwordController.text,
        );
        _clearInputs();
      });
    }
  }

  void _handleGoogleLogin() {
    _submit(ref.read(authControllerProvider).signInWithGoogleProvider);
  }

  // void _handleFacebookLogin() {
  //   _submit(ref.read(authControllerProvider).signInWithFacebookProvider);
  // }

  void _handleForgotPassword() {
    context.go('/forgot-password');
  }

  void _handleGoToSignUp(BuildContext context) {
    context.go('/signup');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 40),
                Text(
                  l10n.welcomeBack,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(l10n.loginToYourAccount, textAlign: TextAlign.center),
                const SizedBox(height: 40),

                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: l10n.emailLabel),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return l10n.enterAValidEmail;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: _handleForgotPassword,
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        l10n.forgotYourPassword,
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),

                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: l10n.passwordLabel),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return l10n.passwordMinLength;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                FilledButton(
                  onPressed: () {
                    if (_isLoading) return;
                    _handleLogin();
                  },
                  child: Text(l10n.login),
                ),

                const SizedBox(height: 16),

                LoginProviders(
                  // handleFacebookLogin: _handleFacebookLogin,
                  handleGoogleLogin: _handleGoogleLogin,
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () => _handleGoToSignUp(context),
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        l10n.dontHaveAnAccount,
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
