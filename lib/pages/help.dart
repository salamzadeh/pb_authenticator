import 'package:flutter/material.dart';
import '../ui/adaptive.dart' show AppScaffold;
import '../l10n/app_localizations.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        'question': 'What is PB Authenticator?',
        'answer': 'PB Authenticator is an app for generating time-based one-time passwords (TOTP) to secure your online accounts with two-factor authentication.'
      },
      {
        'question': 'How do I add a new account?',
        'answer': 'Tap the + button on the home screen and choose to scan a QR code or enter details manually.'
      },
      {
        'question': 'How can I transfer my accounts to a new device?',
        'answer': 'Use the "Transfer Codes" menu to export your accounts as QR codes and import them on your new device.'
      },
      {
        'question': 'Are my accounts backed up?',
        'answer': 'Accounts are stored locally on your device. Use the export feature to create a backup.'
      },
      {
        'question': 'Why are my codes not working?',
        'answer': 'Ensure your device time is correct. TOTP codes depend on accurate time settings.'
      },
      {
        'question': 'How do I prevent screen capture?',
        'answer': 'Go to Settings and enable the "Prevent screen capture" option to block screenshots and screen recording.'
      },
      {
        'question': 'Is PB Authenticator open source?',
        'answer': 'Yes! You can view the source code from the menu or on the project’s repository.'
      },
    ];

    return AppScaffold(
      title: Text(AppLocalizations.of(context)!.helpTitle),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Text(
            AppLocalizations.of(context)!.helpBody,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          Text(
            'Frequently Asked Questions',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          ...faqs.map((faq) => ExpansionTile(
                title: Text(faq['question']!),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(faq['answer']!),
                  ),
                ],
              )),
        ],
      ),
    );
  }
} 