import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flight_booking/features/onboarding/data/onboarding_data.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_flight_booking/l10n/app_localizations.dart';
import '../../../core/providers/app_settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // This would come from your localizations
  List<OnboardingData> _getSlides(AppLocalizations l10n) {
    return [
      OnboardingData(
        title: l10n.onboardingTitle1,
        description: l10n.onboardingDesc1,
      ),
      OnboardingData(
        title: l10n.onboardingTitle2,
        description: l10n.onboardingDesc2,
      ),
      OnboardingData(
        title: l10n.onboardingTitle3,
        description: l10n.onboardingDesc3,
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onControlButtonPressed() {
    if (_currentPage < _getSlides(AppLocalizations.of(context)!).length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to the login/home screen
      ref.read(appSettingsProvider.notifier).toggleFirstLoad();

      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final slides = _getSlides(l10n);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: slides.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildSlide(
                    context: context,
                    title: slides[index].title,
                    description: slides[index].description,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                children: [
                  _buildPageIndicator(slides.length, colorScheme),
                  const SizedBox(height: 40),
                  FilledButton(
                    onPressed: _onControlButtonPressed,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(
                      _currentPage == slides.length - 1
                          ? l10n.getStarted
                          : l10n.next,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildPrivacyPolicyText(context, l10n, colorScheme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide({
    required BuildContext context,
    required String title,
    required String description,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Placeholder for an image
          // Image.asset(imagePath, height: 300),
          const FlutterLogo(size: 150),
          const SizedBox(height: 60),
          Text(
            title,
            textAlign: TextAlign.center,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int numPages, ColorScheme colorScheme) {
    List<Widget> list = [];
    for (int i = 0; i < numPages; i++) {
      list.add(
        i == _currentPage
            ? _indicator(true, colorScheme)
            : _indicator(false, colorScheme),
      );
    }
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: list);
  }

  Widget _indicator(bool isActive, ColorScheme colorScheme) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive
            ? colorScheme.primary
            : colorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  Widget _buildPrivacyPolicyText(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
        children: [
          TextSpan(text: l10n.onboardingPolicyAgreement),
          const TextSpan(text: ' '),
          TextSpan(
            text: l10n.termsOfService,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // TODO: Handle Terms of Service tap
                debugPrint('Terms of Service tapped');
              },
          ),
          TextSpan(text: ' ${l10n.and} '),
          TextSpan(
            text: l10n.privacyPolicy,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // TODO: Handle Privacy Policy tap
                debugPrint('Privacy Policy tapped');
              },
          ),
        ],
      ),
    );
  }
}
