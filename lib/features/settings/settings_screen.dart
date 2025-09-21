import 'package:flutter/material.dart';
import 'package:flutter_flight_booking/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_flight_booking/l10n/app_localizations.dart';
import '../../../core/providers/app_settings_provider.dart';
import '../auth/controllers/auth_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);
    final l10n = AppLocalizations.of(context)!;
    final authProvider = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        leading: BackButton(
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: Text(l10n.darkMode),
            value: settings.isDark,
            onChanged: (_) => notifier.toggleDark(),
          ),
          SwitchListTile(
            title: Text(l10n.rtlMode),
            value: settings.isRtl,
            onChanged: (_) => notifier.toggleRtl(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          authProvider.signOut();
        },
        tooltip: l10n.logout,
        child: const Icon(Icons.logout),
      ),
    );
  }
}
