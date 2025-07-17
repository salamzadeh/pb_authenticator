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
import 'pages/lock_screen.dart';

void main() {
  var repository = Repository(FileStorage());
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => AppState(repository))],
    child: MainApp(),
  ));
}

class MainApp extends StatefulWidget {
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
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool _locked = false;
  bool _initialCheckDone = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkInitialAuth();
  }

  Future<void> _checkInitialAuth() async {
    if (_initialCheckDone) return;
    final appState = Provider.of<AppState>(context, listen: false);
    if (appState.shouldRequireAuth()) {
      setState(() { _locked = true; });
      final unlocked = await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const LockScreenPage(), fullscreenDialog: true),
      );
      if (unlocked == true) {
        setState(() { _locked = false; });
      }
    }
    _initialCheckDone = true;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);

    return Consumer<AppState>(
      builder: (context, appState, _) {
        widget._updateScreenCapture(appState.screenCapturePrevented);
        return MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: appState.themeMode,
          initialRoute: AppRoutes.home,
          routes: {
            AppRoutes.home: (context) => _AuthGate(child: const AndroidHomePage()),
            AppRoutes.edit: (context) => _AuthGate(child: const AndroidEditPage()),
            AppRoutes.add: (context) => _AuthGate(child: const AddPage()),
            AppRoutes.addScan: (context) => _AuthGate(child: const ScanQRPage()),
            AppRoutes.settings: (context) => _AuthGate(child: const SettingsPage()),
            AppRoutes.howItWorks: (context) => _AuthGate(child: const HowItWorksPage()),
            AppRoutes.transferCodes: (context) => _AuthGate(child: const TransferCodesPage()),
            AppRoutes.help: (context) => _AuthGate(child: const HelpPage()),
          },
          localizationsDelegates: widget.localizationsDelegates,
          supportedLocales: widget.supportedLocales,
          builder: (context, child) {
            if (_locked) return const SizedBox.shrink();
            return child!;
          },
        );
      },
    );
  }
}

class _AuthGate extends StatefulWidget {
  final Widget child;
  const _AuthGate({required this.child});
  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> with WidgetsBindingObserver {
  bool _locked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkAuth();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAuth();
    }
  }

  Future<void> _checkAuth() async {
    final appState = Provider.of<AppState>(context, listen: false);
    if (appState.shouldRequireAuth()) {
      setState(() { _locked = true; });
      final unlocked = await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const LockScreenPage(), fullscreenDialog: true),
      );
      if (unlocked == true) {
        setState(() { _locked = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_locked) {
      return const SizedBox.shrink();
    }
    return widget.child;
  }
}
