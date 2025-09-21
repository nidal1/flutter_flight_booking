import 'package:flutter/material.dart';
import 'package:flutter_flight_booking/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.adminPanel)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // TODO: Implement data insertion logic or navigate to a data insertion screen
                // For now, let's just show a snackbar
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.insertDataClicked)));
              },
              child: Text(l10n.insertData),
            ),
          ],
        ),
      ),
    );
  }
}
