import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:pb_authenticator_totp/otpauth_migration.dart';
import 'package:pb_authenticator_totp/totp_item.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../l10n/app_localizations.dart';

class ImportAccountsPage extends StatefulWidget {
  const ImportAccountsPage({super.key});

  @override
  State<ImportAccountsPage> createState() => _ImportAccountsPageState();
}

class _ImportAccountsPageState extends State<ImportAccountsPage> {
  bool _importing = false;
  String? _resultMessage;

  Future<void> _scanAndImport() async {
    setState(() {
      _importing = true;
      _resultMessage = null;
    });
    try {
      final scanResult = await BarcodeScanner.scan();
      final uri = scanResult.rawContent;
      if (uri.isEmpty) {
        setState(() {
          _importing = false;
          _resultMessage = AppLocalizations.of(context)?.errIncorrectFormat ?? 'Scanned code is of incorrect format';
        });
        return;
      }
      final uris = OtpAuthMigration().decode(uri);
      if (uris.isEmpty) {
        setState(() {
          _importing = false;
          _resultMessage = AppLocalizations.of(context)?.errIncorrectFormat ?? 'Scanned code is of incorrect format';
        });
        return;
      }
      final items = uris.map((u) => TotpItem.fromUri(u)).toList();
      final state = Provider.of<AppState>(context, listen: false);
      for (final item in items) {
        await state.addItem(item);
      }
      setState(() {
        _importing = false;
        _resultMessage = AppLocalizations.of(context)?.importSuccess ?? 'Accounts imported successfully!';
      });
    } catch (e) {
      setState(() {
        _importing = false;
        _resultMessage = AppLocalizations.of(context)?.errUnknown ?? 'Unknown error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)?.importAccounts ?? 'Import accounts')),
      body: Center(
        child: _importing
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code_2, size: 64, color: Colors.blue),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      AppLocalizations.of(context)?.importDescription ??
                          'Import your accounts from Google Authenticator or PB Authenticator by scanning a QR code.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.qr_code_scanner),
                    label: Text(AppLocalizations.of(context)?.importAccounts ?? 'Import accounts'),
                    onPressed: _scanAndImport,
                  ),
                  if (_resultMessage != null) ...[
                    const SizedBox(height: 24),
                    Text(_resultMessage!, textAlign: TextAlign.center),
                  ]
                ],
              ),
      ),
    );
  }
} 