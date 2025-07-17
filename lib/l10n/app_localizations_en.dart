// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'PB Authenticator';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get error => 'Error';

  @override
  String get save => 'Save';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get addTitle => 'Add Account';

  @override
  String get addScanQR => 'Scan QR Code';

  @override
  String get addManualInput => 'Manual Input';

  @override
  String get addMethodPrompt => 'Please select input method.';

  @override
  String get cancel => 'Cancel';

  @override
  String get secret => 'Secret key';

  @override
  String get secretInvalidMessage => 'Secret key is invalid';

  @override
  String get issuer => 'Provider/Issuer';

  @override
  String get accountName => 'Account Name';

  @override
  String get digits => 'Number of digits';

  @override
  String get period => 'Time step';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get source => 'Source code';

  @override
  String get clipboard => 'Copied to clipboard';

  @override
  String get noAccounts =>
      'You have no accounts,\n press the + button to add one.';

  @override
  String get loading => 'Loading...';

  @override
  String get editTitle => 'Edit Accounts';

  @override
  String get removeAccounts => 'Remove accounts';

  @override
  String get removeConfirmation =>
      'Please do not forget to turn off 2 factor authentication before removal.\n\nAre you sure that you want to remove the selected account(s)?';

  @override
  String get exitEditTitle => 'Exit';

  @override
  String get exitEditInfo => 'Do you want to exit edit mode without saving?';

  @override
  String get errDuplicateAccount => 'Duplicate account';

  @override
  String get errIdCollision =>
      'A rare ID collision has occurred. Please try again.';

  @override
  String get errNoCameraPermission => 'Camera permission not granted';

  @override
  String get errIncorrectFormat => 'Scanned code is of incorrect format';

  @override
  String get errUnknown => 'Unknown error';

  @override
  String get howItWorksTitle => 'How it works';

  @override
  String get howItWorksTitle1 => 'Secure your accounts';

  @override
  String get howItWorksBody1 =>
      'Add your accounts to generate time-based one-time passwords (TOTP) for secure sign-in.';

  @override
  String get howItWorksTitle2 => 'Scan QR codes';

  @override
  String get howItWorksBody2 =>
      'Easily add new accounts by scanning QR codes provided by your services.';

  @override
  String get howItWorksTitle3 => 'Backup & Restore';

  @override
  String get howItWorksBody3 =>
      'Backup your accounts securely and restore them when needed.';

  @override
  String get howItWorksTitle4 => 'Offline & Private';

  @override
  String get howItWorksBody4 =>
      'All data stays on your device. No internet required for generating codes.';

  @override
  String get skip => 'Skip';

  @override
  String get done => 'Done';

  @override
  String get transferCodesTitle => 'Transfer codes';

  @override
  String get transferCodesDescription =>
      'Transfer your accounts to another device.';

  @override
  String get exportAccounts => 'Export accounts';

  @override
  String get importAccounts => 'Import accounts';

  @override
  String get importSuccess => 'Accounts imported successfully!';

  @override
  String get importDescription =>
      'Import your accounts from Google Authenticator or PB Authenticator by scanning a QR code.';

  @override
  String get exportDescription =>
      'Select which accounts to export and generate a QR code to transfer them to another device.';

  @override
  String get generateQr => 'Generate QR';

  @override
  String get noAccountsSelected => 'No accounts selected.';

  @override
  String get themeMode => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get preventScreenCapture => 'Prevent screen capture';

  @override
  String get helpTitle => 'Help';

  @override
  String get helpBody =>
      'Need assistance? Here you can find answers to common questions and tips for using PB Authenticator.';
}
