import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_flight_booking/features/auth/controllers/auth_providers.dart';
import 'package:flutter_flight_booking/l10n/app_localizations.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  @override
  void initState() {
    super.initState();
    // Send the verification email as soon as the user lands on this screen.
    // This is safe to call multiple times, as Firebase has rate-limiting.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(authControllerProvider).sendCurrentUserEmailVerification();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authController = ref.read(authControllerProvider);
    final l10n = AppLocalizations.of(context)!;
    // It's safe to assume the user is non-null here because of the router logic.
    final userEmail = FirebaseAuth.instance.currentUser?.email;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.verifyYourEmail)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.verificationEmailSent(userEmail ?? l10n.yourEmailAddress),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              Text(l10n.checkInboxForVerification, textAlign: TextAlign.center),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () async {
                  await authController.sendCurrentUserEmailVerification();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.verificationEmailResent)),
                    );
                  }
                },
                child: Text(l10n.resendEmail),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: authController.signOut,
                child: Text(l10n.cancel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
