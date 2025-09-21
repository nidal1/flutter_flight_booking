import 'package:flutter/material.dart';

class LoginProviders extends StatelessWidget {
  final VoidCallback handleGoogleLogin;
  // final VoidCallback handleFacebookLogin;

  const LoginProviders({
    super.key,
    required this.handleGoogleLogin,
    // required this.handleFacebookLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildProviderButton(
            onTap: handleGoogleLogin,
            // IMPORTANT: Make sure you have a Google logo at this path
            assetName: 'assets/images/google_logo.png',
            context: context,
          ),
        ),
        // const SizedBox(width: 24),
        // Expanded(
        //   child: _buildProviderButton(
        //     onTap: handleFacebookLogin,
        //     // IMPORTANT: Make sure you have a Facebook logo at this path
        //     assetName: 'assets/images/meta_logo.png',
        //     context: context,
        //   ),
        // ),
      ],
    );
  }

  Widget _buildProviderButton({
    required VoidCallback onTap,
    required String assetName,
    required BuildContext context,
  }) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(12),
        side: BorderSide(color: Theme.of(context).colorScheme.outline),
      ),
      child: Image.asset(assetName, height: 24, width: 24),
    );
  }
}
