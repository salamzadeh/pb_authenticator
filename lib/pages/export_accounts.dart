import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import 'package:pb_authenticator_totp/totp_item.dart';
import 'package:pb_authenticator_totp/otpauth_migration.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import '../l10n/app_localizations.dart';

class ExportAccountsPage extends StatefulWidget {
  const ExportAccountsPage({super.key});

  @override
  State<ExportAccountsPage> createState() => _ExportAccountsPageState();
}

class _ExportAccountsPageState extends State<ExportAccountsPage> {
  static const int maxAccountsPerBatch = 10; // Google Authenticator uses 10
  List<String> _qrUris = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _generateQrUris());
  }

  void _generateQrUris() {
    final state = Provider.of<AppState>(context, listen: false);
    final items = state.items ?? [];
    final otpAuths = items.map((item) => _toOtpAuthUri(item.totp)).toList();
    _qrUris = [];
    for (int i = 0; i < otpAuths.length; i += maxAccountsPerBatch) {
      final batch = otpAuths.sublist(i, (i + maxAccountsPerBatch > otpAuths.length) ? otpAuths.length : i + maxAccountsPerBatch);
      final uri = OtpAuthMigration().encode(batch, batchSize: otpAuths.length, batchIndex: (i ~/ maxAccountsPerBatch), batchId: 1);
      _qrUris.add(uri);
    }
    setState(() {});
  }

  String _toOtpAuthUri(TotpItem item) {
    final algorithm = item.algorithm.name.toUpperCase();
    return 'otpauth://totp/${Uri.encodeComponent(item.issuer)}:${Uri.encodeComponent(item.accountName)}?secret=${item.secret}&issuer=${Uri.encodeComponent(item.issuer)}&algorithm=$algorithm&digits=${item.digits}&period=${item.period}';
  }

  @override
  Widget build(BuildContext context) {
    if (_qrUris.isEmpty) {
      final state = Provider.of<AppState>(context, listen: false);
      final items = state.items ?? [];
      if (items.isEmpty) {
        return Scaffold(
          appBar: AppBar(title: Text(AppLocalizations.of(context)?.exportAccounts ?? 'Export accounts')),
          body: Center(child: Text(AppLocalizations.of(context)?.noAccounts ?? 'No accounts to export.')),
        );
      }
      // Still loading QR codes
      return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)?.exportAccounts ?? 'Export accounts')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)?.exportAccounts ?? 'Export accounts')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)?.exportAccounts ?? 'Export accounts',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: BarcodePainterWidget(data: _qrUris[_currentIndex]),
            ),
          ),
          if (_qrUris.length > 1)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: _currentIndex > 0
                        ? () => setState(() => _currentIndex--)
                        : null,
                  ),
                  Text('${_currentIndex + 1} / ${_qrUris.length}'),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: _currentIndex < _qrUris.length - 1
                        ? () => setState(() => _currentIndex++)
                        : null,
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class BarcodePainterWidget extends StatelessWidget {
  final String data;
  const BarcodePainterWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // barcode_scan2 does not provide a direct widget, so we use a placeholder for now.
    // You should replace this with a QR code widget compatible with your requirements.
    return Container(
      color: Colors.white,
      width: 240,
      height: 240,
      alignment: Alignment.center,
      child: Text(
        'QR code here',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
} 