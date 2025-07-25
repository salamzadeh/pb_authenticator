import 'dart:async' show Future;
import '../config/routes.dart';
import '../state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import '../l10n/app_localizations.dart';
import '../ui/adaptive.dart' show AppScaffold, AdaptiveDialogAction;
import 'package:barcode_scan2/barcode_scan2.dart' show BarcodeScanner;

/// Page for adding accounts by scanning QR.
class ScanQRPage extends StatefulWidget {
  const ScanQRPage({super.key});

  @override
  State<ScanQRPage> createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage> {
  @override
  void initState() {
    super.initState();

    // Trigger scan
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        try {
          final value = await _scan();
          // Parse scanned value into item and pop
          var item = BaseItemType.newAuthenticatorItemFromUri(value);
          // Pop until scan page
          Navigator.of(context)
              .popUntil(ModalRoute.withName(AppRoutes.addScan));
          // Pop with scanned item
          Navigator.of(context).pop(item);
        } catch (e) {
          await showAdaptiveDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog.adaptive(
                  title: Text(AppLocalizations.of(context)!.error),
                  content: Text(e.toString()),
                  actions: [
                    AdaptiveDialogAction(
                      child: Text(AppLocalizations.of(context)!.ok),
                      onPressed: () {
                        // Pop dialog
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
          Navigator.of(context)
              .popUntil(ModalRoute.withName(AppRoutes.addScan));
          Navigator.of(context).pop();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text(AppLocalizations.of(context)!.addScanQR),
      body: const Center(),
    );
  }

  // Scans and returns scanned QR code
  // Adapted from documentation of flutter_barcode_reader
  Future _scan() async {
    try {
      var barcode = await BarcodeScanner.scan();
      return barcode.rawContent;
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        return Future.error(
            AppLocalizations.of(context)!.errNoCameraPermission);
      } else {
        return Future.error('${AppLocalizations.of(context)!.errUnknown} $e');
      }
    } on FormatException {
      return Future.error(AppLocalizations.of(context)!.errIncorrectFormat);
    } catch (e) {
      return Future.error('${AppLocalizations.of(context)!.errUnknown} $e');
    }
  }
}
