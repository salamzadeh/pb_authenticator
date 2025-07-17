import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../l10n/app_localizations.dart';

class HowItWorksPage extends StatelessWidget {
  const HowItWorksPage({super.key});

  List<PageViewModel> _getPages(BuildContext context) {
    return [
      PageViewModel(
        title: AppLocalizations.of(context)?.howItWorksTitle1 ?? 'Secure your accounts',
        body: AppLocalizations.of(context)?.howItWorksBody1 ?? 'Add your accounts to generate time-based one-time passwords (TOTP) for secure sign-in.',
        image: const Icon(Icons.security, size: 120, color: Colors.blue),
      ),
      PageViewModel(
        title: AppLocalizations.of(context)?.howItWorksTitle2 ?? 'Scan QR codes',
        body: AppLocalizations.of(context)?.howItWorksBody2 ?? 'Easily add new accounts by scanning QR codes provided by your services.',
        image: const Icon(Icons.qr_code_scanner, size: 120, color: Colors.green),
      ),
      PageViewModel(
        title: AppLocalizations.of(context)?.howItWorksTitle3 ?? 'Backup & Restore',
        body: AppLocalizations.of(context)?.howItWorksBody3 ?? 'Backup your accounts securely and restore them when needed.',
        image: const Icon(Icons.backup, size: 120, color: Colors.orange),
      ),
      PageViewModel(
        title: AppLocalizations.of(context)?.howItWorksTitle4 ?? 'Offline & Private',
        body: AppLocalizations.of(context)?.howItWorksBody4 ?? 'All data stays on your device. No internet required for generating codes.',
        image: const Icon(Icons.lock, size: 120, color: Colors.purple),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: _getPages(context),
      showSkipButton: true,
      skip: Text(AppLocalizations.of(context)?.skip ?? 'Skip'),
      next: const Icon(Icons.arrow_forward),
      done: Text(AppLocalizations.of(context)?.done ?? 'Done', style: const TextStyle(fontWeight: FontWeight.w600)),
      onDone: () => Navigator.of(context).pop(),
      onSkip: () => Navigator.of(context).pop(),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.black26,
        activeSize: Size(22.0, 10.0),
        activeColor: Colors.blue,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
} 