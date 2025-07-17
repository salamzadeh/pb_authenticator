import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'PB Authenticator'**
  String get appName;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @addTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Account'**
  String get addTitle;

  /// No description provided for @addScanQR.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get addScanQR;

  /// No description provided for @addManualInput.
  ///
  /// In en, this message translates to:
  /// **'Manual Input'**
  String get addManualInput;

  /// No description provided for @addMethodPrompt.
  ///
  /// In en, this message translates to:
  /// **'Please select input method.'**
  String get addMethodPrompt;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @secret.
  ///
  /// In en, this message translates to:
  /// **'Secret key'**
  String get secret;

  /// No description provided for @secretInvalidMessage.
  ///
  /// In en, this message translates to:
  /// **'Secret key is invalid'**
  String get secretInvalidMessage;

  /// No description provided for @issuer.
  ///
  /// In en, this message translates to:
  /// **'Provider/Issuer'**
  String get issuer;

  /// No description provided for @accountName.
  ///
  /// In en, this message translates to:
  /// **'Account Name'**
  String get accountName;

  /// No description provided for @digits.
  ///
  /// In en, this message translates to:
  /// **'Number of digits'**
  String get digits;

  /// No description provided for @period.
  ///
  /// In en, this message translates to:
  /// **'Time step'**
  String get period;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source code'**
  String get source;

  /// No description provided for @licenses.
  ///
  /// In en, this message translates to:
  /// **'Acknowledgements'**
  String get licenses;

  /// No description provided for @clipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get clipboard;

  /// No description provided for @noAccounts.
  ///
  /// In en, this message translates to:
  /// **'You have no accounts,\n press the + button to add one.'**
  String get noAccounts;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @editTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Accounts'**
  String get editTitle;

  /// No description provided for @removeAccounts.
  ///
  /// In en, this message translates to:
  /// **'Remove accounts'**
  String get removeAccounts;

  /// No description provided for @removeConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Please do not forget to turn off 2 factor authentication before removal.\n\nAre you sure that you want to remove the selected account(s)?'**
  String get removeConfirmation;

  /// No description provided for @exitEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exitEditTitle;

  /// No description provided for @exitEditInfo.
  ///
  /// In en, this message translates to:
  /// **'Do you want to exit edit mode without saving?'**
  String get exitEditInfo;

  /// No description provided for @errDuplicateAccount.
  ///
  /// In en, this message translates to:
  /// **'Duplicate account'**
  String get errDuplicateAccount;

  /// No description provided for @errIdCollision.
  ///
  /// In en, this message translates to:
  /// **'A rare ID collision has occurred. Please try again.'**
  String get errIdCollision;

  /// No description provided for @errNoCameraPermission.
  ///
  /// In en, this message translates to:
  /// **'Camera permission not granted'**
  String get errNoCameraPermission;

  /// No description provided for @errIncorrectFormat.
  ///
  /// In en, this message translates to:
  /// **'Scanned code is of incorrect format'**
  String get errIncorrectFormat;

  /// No description provided for @errUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get errUnknown;

  /// No description provided for @howItWorksTitle.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get howItWorksTitle;

  /// No description provided for @howItWorksTitle1.
  ///
  /// In en, this message translates to:
  /// **'Secure your accounts'**
  String get howItWorksTitle1;

  /// No description provided for @howItWorksBody1.
  ///
  /// In en, this message translates to:
  /// **'Add your accounts to generate time-based one-time passwords (TOTP) for secure sign-in.'**
  String get howItWorksBody1;

  /// No description provided for @howItWorksTitle2.
  ///
  /// In en, this message translates to:
  /// **'Scan QR codes'**
  String get howItWorksTitle2;

  /// No description provided for @howItWorksBody2.
  ///
  /// In en, this message translates to:
  /// **'Easily add new accounts by scanning QR codes provided by your services.'**
  String get howItWorksBody2;

  /// No description provided for @howItWorksTitle3.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get howItWorksTitle3;

  /// No description provided for @howItWorksBody3.
  ///
  /// In en, this message translates to:
  /// **'Backup your accounts securely and restore them when needed.'**
  String get howItWorksBody3;

  /// No description provided for @howItWorksTitle4.
  ///
  /// In en, this message translates to:
  /// **'Offline & Private'**
  String get howItWorksTitle4;

  /// No description provided for @howItWorksBody4.
  ///
  /// In en, this message translates to:
  /// **'All data stays on your device. No internet required for generating codes.'**
  String get howItWorksBody4;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @transferCodesTitle.
  ///
  /// In en, this message translates to:
  /// **'Transfer codes'**
  String get transferCodesTitle;

  /// No description provided for @transferCodesDescription.
  ///
  /// In en, this message translates to:
  /// **'Transfer your accounts to another device.'**
  String get transferCodesDescription;

  /// No description provided for @exportAccounts.
  ///
  /// In en, this message translates to:
  /// **'Export accounts'**
  String get exportAccounts;

  /// No description provided for @importAccounts.
  ///
  /// In en, this message translates to:
  /// **'Import accounts'**
  String get importAccounts;

  /// No description provided for @importSuccess.
  ///
  /// In en, this message translates to:
  /// **'Accounts imported successfully!'**
  String get importSuccess;

  /// No description provided for @importDescription.
  ///
  /// In en, this message translates to:
  /// **'Import your accounts from Google Authenticator or PB Authenticator by scanning a QR code.'**
  String get importDescription;

  /// No description provided for @exportDescription.
  ///
  /// In en, this message translates to:
  /// **'Select which accounts to export and generate a QR code to transfer them to another device.'**
  String get exportDescription;

  /// No description provided for @generateQr.
  ///
  /// In en, this message translates to:
  /// **'Generate QR'**
  String get generateQr;

  /// No description provided for @noAccountsSelected.
  ///
  /// In en, this message translates to:
  /// **'No accounts selected.'**
  String get noAccountsSelected;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeMode;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @preventScreenCapture.
  ///
  /// In en, this message translates to:
  /// **'Prevent screen capture'**
  String get preventScreenCapture;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
