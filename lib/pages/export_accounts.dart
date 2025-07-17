import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import 'package:pb_authenticator_totp/totp_item.dart';
import 'package:pb_authenticator_totp/otpauth_migration.dart';
import '../l10n/app_localizations.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ExportAccountsPage extends StatefulWidget {
  const ExportAccountsPage({super.key});

  @override
  State<ExportAccountsPage> createState() => _ExportAccountsPageState();
}

class _ExportAccountsPageState extends State<ExportAccountsPage> {
  static const int maxAccountsPerBatch = 10; // Google Authenticator uses 10
  List<String> _qrUris = [];
  int _currentIndex = 0;
  List<bool> _selected = [];
  bool _qrGenerated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initSelection());
  }

  void _initSelection() {
    final state = Provider.of<AppState>(context, listen: false);
    final items = state.items ?? [];
    setState(() {
      _selected = List.generate(items.length, (_) => true);
      _qrUris = [];
      _qrGenerated = false;
      _currentIndex = 0;
    });
  }

  void _generateQrUris() {
    final state = Provider.of<AppState>(context, listen: false);
    final items = state.items ?? [];
    final selectedItems = <TotpItem>[];
    for (int i = 0; i < items.length; i++) {
      if (_selected[i]) {
        selectedItems.add(items[i].totp);
      }
    }
    if (selectedItems.isEmpty) {
      setState(() {
        _qrUris = [];
        _qrGenerated = true;
      });
      return;
    }
    final otpAuths = selectedItems.map((item) => _toOtpAuthUri(item)).toList();
    final qrUris = <String>[];
    for (int i = 0; i < otpAuths.length; i += maxAccountsPerBatch) {
      final batch = otpAuths.sublist(i, (i + maxAccountsPerBatch > otpAuths.length) ? otpAuths.length : i + maxAccountsPerBatch);
      final uri = OtpAuthMigration().encode(batch, batchSize: otpAuths.length, batchIndex: (i ~/ maxAccountsPerBatch), batchId: 1);
      qrUris.add(uri);
    }
    setState(() {
      _qrUris = qrUris;
      _qrGenerated = true;
      _currentIndex = 0;
    });
    if (qrUris.isNotEmpty) {
      _showQrDialog(qrUris);
    }
  }

  void _showQrDialog(List<String> qrUris) {
    int dialogIndex = 0;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(16),
              content: SizedBox(
                width: 360,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    QrImageView(
                      data: qrUris[dialogIndex],
                      version: QrVersions.auto,
                      size: 320,
                      backgroundColor: Colors.white,
                      errorStateBuilder: (cxt, err) => Center(child: Text('QR error', style: TextStyle(color: Colors.red))),
                    ),
                    if (qrUris.length > 1)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: dialogIndex > 0
                                  ? () => setState(() => dialogIndex--)
                                  : null,
                            ),
                            Text('${dialogIndex + 1} / ${qrUris.length}'),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward),
                              onPressed: dialogIndex < qrUris.length - 1
                                  ? () => setState(() => dialogIndex++)
                                  : null,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _toOtpAuthUri(TotpItem item) {
    final algorithm = item.algorithm.name.toUpperCase();
    return 'otpauth://totp/${Uri.encodeComponent(item.issuer)}:${Uri.encodeComponent(item.accountName)}?secret=${item.secret}&issuer=${Uri.encodeComponent(item.issuer)}&algorithm=$algorithm&digits=${item.digits}&period=${item.period}';
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final items = state.items ?? [];
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(loc?.exportAccounts ?? 'Export accounts')),
      body: items.isEmpty
          ? Center(child: Text(loc?.noAccounts ?? 'No accounts to export.'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Icon(Icons.qr_code, size: 48, color: Colors.blue),
                  const SizedBox(height: 8),
                  Text(
                    loc?.exportDescription ?? 'Select which accounts to export and generate a QR code to transfer them to another device.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, i) {
                        final item = items[i];
                        return CheckboxListTile(
                          value: _selected[i],
                          onChanged: (val) {
                            setState(() {
                              _selected[i] = val ?? false;
                            });
                          },
                          title: Text('${item.totp.issuer}: ${item.totp.accountName}'),
                        );
                      },
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.qr_code),
                    label: Text(loc?.generateQr ?? 'Generate QR'),
                    onPressed: _selected.any((s) => s) ? _generateQrUris : null,
                  ),
                  const SizedBox(height: 16),
                  if (_qrGenerated && _qrUris.isEmpty)
                    Text(loc?.noAccountsSelected ?? 'No accounts selected.'),
                ],
              ),
            ),
    );
  }
}

class BarcodePainterWidget extends StatelessWidget {
  final String data;
  const BarcodePainterWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: data,
      version: QrVersions.auto,
      size: 240,
      backgroundColor: Colors.white,
      errorStateBuilder: (cxt, err) => Center(child: Text('QR error', style: TextStyle(color: Colors.red))),
    );
  }
} 
