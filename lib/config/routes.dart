import 'package:flutter/cupertino.dart';

import '../pages/how_it_works.dart';
import '../pages/transfer_codes.dart';
import '../pages/help.dart';

class AppRoutes {
  static const String home = '/';
  static const String add = '/add';
  static const String addScan = '/add/scan';
  static const String edit = '/edit';
  static const String settings = '/settings';
  static const String howItWorks = '/howItWorks';
  static const String transferCodes = '/transferCodes';
  static const String help = '/help';
}

final Map<String, WidgetBuilder> appRoutes = {
  AppRoutes.howItWorks: (context) => const HowItWorksPage(),
  AppRoutes.transferCodes: (context) => const TransferCodesPage(),
  AppRoutes.help: (context) => const HelpPage(),
};
