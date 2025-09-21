import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_flight_booking/l10n/app_localizations.dart';
import 'package:flutter_flight_booking/app/app_router.dart';
import '../core/theme/app_theme.dart';
import '../core/providers/app_settings_provider.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final router = ref.watch(routerProvider);
    final fontFamily = settings.isRtl ? 'Cairo' : 'Inter';

    return MaterialApp.router(
      onGenerateTitle: (context) {
        // This makes sure the app title in the OS task switcher is localized.
        return AppLocalizations.of(context)!.appTitle;
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: settings.isRtl ? const Locale('ar') : const Locale('en'),
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(fontFamily),
      darkTheme: buildDarkTheme(fontFamily),
      themeMode: settings.isDark ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
      builder: (context, child) {
        return Directionality(
          textDirection: settings.isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        );
      },
    );
  }
}
