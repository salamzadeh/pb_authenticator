// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appName => 'پی‌بی احرازگر';

  @override
  String get ok => 'تأیید';

  @override
  String get yes => 'بله';

  @override
  String get no => 'خیر';

  @override
  String get error => 'خطا';

  @override
  String get save => 'ذخیره';

  @override
  String get edit => 'ویرایش';

  @override
  String get add => 'افزودن';

  @override
  String get addTitle => 'افزودن حساب';

  @override
  String get addScanQR => 'اسکن کد QR';

  @override
  String get addManualInput => 'ورود دستی';

  @override
  String get addMethodPrompt => 'لطفاً روش ورود را انتخاب کنید.';

  @override
  String get cancel => 'انصراف';

  @override
  String get secret => 'کلید مخفی';

  @override
  String get secretInvalidMessage => 'کلید مخفی نامعتبر است';

  @override
  String get issuer => 'ارائه‌دهنده/صادرکننده';

  @override
  String get accountName => 'نام حساب';

  @override
  String get digits => 'تعداد ارقام';

  @override
  String get period => 'گام زمانی';

  @override
  String get settingsTitle => 'تنظیمات';

  @override
  String get source => 'کد منبع';

  @override
  String get clipboard => 'در کلیپ‌بورد کپی شد';

  @override
  String get noAccounts =>
      'شما هیچ حسابی ندارید،\n برای افزودن یک حساب دکمه + را فشار دهید.';

  @override
  String get loading => 'در حال بارگذاری...';

  @override
  String get editTitle => 'ویرایش حساب‌ها';

  @override
  String get removeAccounts => 'حذف حساب‌ها';

  @override
  String get removeConfirmation =>
      'لطفاً قبل از حذف، احراز هویت دو مرحله‌ای را غیرفعال کنید.\n\nآیا مطمئن هستید که می‌خواهید حساب(های) انتخاب شده را حذف کنید؟';

  @override
  String get exitEditTitle => 'خروج';

  @override
  String get exitEditInfo =>
      'آیا می‌خواهید بدون ذخیره از حالت ویرایش خارج شوید؟';

  @override
  String get errDuplicateAccount => 'حساب تکراری';

  @override
  String get errIdCollision =>
      'یک برخورد نادر شناسه رخ داده است. لطفاً دوباره تلاش کنید.';

  @override
  String get errNoCameraPermission => 'دسترسی دوربین داده نشده است';

  @override
  String get errIncorrectFormat => 'کد اسکن شده فرمت نادرست دارد';

  @override
  String get errUnknown => 'خطای ناشناخته';

  @override
  String get howItWorksTitle => 'نحوه کارکرد';

  @override
  String get howItWorksTitle1 => 'حساب‌های خود را ایمن کنید';

  @override
  String get howItWorksBody1 =>
      'حساب‌های خود را اضافه کنید تا رمزهای یکبار مصرف مبتنی بر زمان (TOTP) برای ورود امن تولید کنید.';

  @override
  String get howItWorksTitle2 => 'اسکن کدهای QR';

  @override
  String get howItWorksBody2 =>
      'به راحتی با اسکن کدهای QR ارائه شده توسط سرویس‌ها، حساب جدید اضافه کنید.';

  @override
  String get howItWorksTitle3 => 'پشتیبان‌گیری و بازیابی';

  @override
  String get howItWorksBody3 =>
      'حساب‌های خود را به صورت امن پشتیبان‌گیری و در صورت نیاز بازیابی کنید.';

  @override
  String get howItWorksTitle4 => 'آفلاین و خصوصی';

  @override
  String get howItWorksBody4 =>
      'تمام داده‌ها روی دستگاه شما باقی می‌ماند. برای تولید کدها نیازی به اینترنت نیست.';

  @override
  String get skip => 'رد کردن';

  @override
  String get done => 'انجام شد';

  @override
  String get transferCodesTitle => 'انتقال کدها';

  @override
  String get transferCodesDescription =>
      'حساب‌های خود را به دستگاه دیگری منتقل کنید.';

  @override
  String get exportAccounts => 'خروجی گرفتن از حساب‌ها';

  @override
  String get importAccounts => 'وارد کردن حساب‌ها';

  @override
  String get importSuccess => 'حساب‌ها با موفقیت وارد شدند!';

  @override
  String get importDescription =>
      'حساب‌های خود را از Google Authenticator یا PB Authenticator با اسکن کد QR وارد کنید.';

  @override
  String get exportDescription =>
      'حساب‌هایی که می‌خواهید صادر کنید را انتخاب و یک کد QR برای انتقال به دستگاه دیگر تولید کنید.';

  @override
  String get generateQr => 'تولید کد QR';

  @override
  String get noAccountsSelected => 'هیچ حسابی انتخاب نشده است.';

  @override
  String get themeMode => 'حالت نمایش';

  @override
  String get themeSystem => 'سیستم';

  @override
  String get themeLight => 'روشن';

  @override
  String get themeDark => 'تاریک';

  @override
  String get preventScreenCapture => 'جلوگیری از عکس‌برداری صفحه';

  @override
  String get helpTitle => 'راهنما';

  @override
  String get helpBody =>
      'نیاز به کمک دارید؟ اینجا می‌توانید پاسخ سوالات متداول و نکاتی برای استفاده از پی‌بی احرازگر را بیابید.';
}
