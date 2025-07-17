import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'export_accounts.dart';
import 'import_accounts.dart';

class TransferCodesPage extends StatelessWidget {
  const TransferCodesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.transferCodesTitle ?? 'Transfer codes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)?.transferCodesDescription ?? 'Transfer your accounts to another device.',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: const Icon(Icons.upload_file, size: 32),
              label: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                child: Text(
                  AppLocalizations.of(context)?.exportAccounts ?? 'Export accounts',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ExportAccountsPage()),
                );
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.download, size: 32),
              label: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                child: Text(
                  AppLocalizations.of(context)?.importAccounts ?? 'Import accounts',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ImportAccountsPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} 