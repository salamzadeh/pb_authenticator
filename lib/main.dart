import 'package:pb_authenticator/pages/how_it_works.dart';
import 'package:pb_authenticator/pages/transfer_codes.dart';

import 'state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart'
    show GlobalMaterialLocalizations, GlobalWidgetsLocalizations;
import 'l10n/app_localizations.dart';
import 'state/file_storage.dart';
import 'package:pb_authenticator_state/state.dart' show Repository;
import 'pages/pages.dart';
import 'package:provider/provider.dart';

import 'config/routes.dart';

void main() {
  var repository = Repository(FileStorage());
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => AppState(repository))],
    child: MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  // Locale information
  final Iterable<Locale> supportedLocales = [const Locale('en')];
  final Iterable<LocalizationsDelegate> localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const MethodChannel _platform = MethodChannel('screen_capture');

  void _updateScreenCapture(bool prevent) async {
    try {
      await _platform.invokeMethod(prevent ? 'prevent' : 'allow');
    } catch (e) {
      // ignore
    }
  }

  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);

    return Consumer<AppState>(
      builder: (context, appState, _) {
        _updateScreenCapture(appState.screenCapturePrevented);
        return MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: appState.themeMode,
          initialRoute: AppRoutes.home,
          routes: {
            AppRoutes.home: (context) => const AndroidHomePage(),
            AppRoutes.edit: (context) => const AndroidEditPage(),
            AppRoutes.add: (context) => const AddPage(),
            AppRoutes.addScan: (context) => const ScanQRPage(),
            AppRoutes.settings: (context) => const SettingsPage(),
            AppRoutes.settingAcknowledgements: (context) =>
                const AcknowledgementsPage(),
            AppRoutes.howItWorks: (context) => const HowItWorksPage(),
            AppRoutes.transferCodes: (context) => const TransferCodesPage(),
          },
          localizationsDelegates: localizationsDelegates,
          supportedLocales: supportedLocales,
        );
      },
    );
  }
}
