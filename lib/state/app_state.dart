import 'package:pb_authenticator_state/state.dart';
import 'package:pb_authenticator_totp/totp.dart';
import 'package:flutter/widgets.dart';
import 'package:collection/collection.dart' show ListEquality;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

// TODO: Transition to new type
typedef BaseItemType = LegacyAuthenticatorItem;

/// Represents app state.
class AppState extends ChangeNotifier {
  final RepositoryBase<BaseItemType> _repository;

  // Theme and screen capture settings
  ThemeMode _themeMode = ThemeMode.system;
  bool _screenCapturePrevented = false;

  // PIN and biometric settings
  bool _pinEnabled = false;
  bool _biometricEnabled = false;
  DateTime? _lastUnlockTime;
  static const _pinTimeout = Duration(minutes: 5);
  static const _pinKey = 'app_pin';
  static const _pinEnabledKey = 'pinEnabled';
  static const _biometricEnabledKey = 'biometricEnabled';
  static final _secureStorage = FlutterSecureStorage();

  // Show/hide icons setting
  bool _showIcons = true;
  static const _showIconsKey = 'showIcons';
  bool get showIcons => _showIcons;

  // Force monochrome icons setting
  bool _forceMonochromeIcons = false;
  static const _forceMonochromeIconsKey = 'forceMonochromeIcons';
  bool get forceMonochromeIcons => _forceMonochromeIcons;

  // Locale setting
  Locale _locale = const Locale('en');
  static const _localeKey = 'locale';
  Locale get locale => _locale;

  bool get pinEnabled => _pinEnabled;
  bool get biometricEnabled => _biometricEnabled;
  DateTime? get lastUnlockTime => _lastUnlockTime;
  Duration get pinTimeout => _pinTimeout;

  ThemeMode get themeMode => _themeMode;
  bool get screenCapturePrevented => _screenCapturePrevented;

  AppState(this._repository) {
    _loadSettings();
  }

  /// List of TOTP items (internal implementation).
  List<BaseItemType>? _items;

  /// TOTP items as list.
  List<BaseItemType>? get items {
    if (_items == null) {
      loadItems();
    }
    return _items;
  }

  Future loadItems() async {
    _items = await _repository.loadItems();
    notifyListeners();
  }

  /// Adds a TOTP item to the list.
  Future addItem(TotpItem item) async {
    await _repository.addItem(item);
    await loadItems();
  }

  /// Replace list of TOTP items.
  Future replaceItems(List<BaseItemType> items) async {
    await _repository.replaceItems(items);
    await loadItems();
  }

  bool itemsChanged(List<BaseItemType>? newItems) {
    return !const ListEquality().equals(items, newItems);
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt('themeMode') ?? 0;
    _themeMode = ThemeMode.values[themeIndex];
    _screenCapturePrevented = prefs.getBool('screenCapturePrevented') ?? false;
    _pinEnabled = prefs.getBool(_pinEnabledKey) ?? false;
    _biometricEnabled = prefs.getBool(_biometricEnabledKey) ?? false;
    _showIcons = prefs.getBool(_showIconsKey) ?? true;
    _forceMonochromeIcons = prefs.getBool(_forceMonochromeIconsKey) ?? false;
    // Load locale
    final localeCode = prefs.getString(_localeKey);
    if (localeCode != null) {
      _locale = Locale(localeCode);
    }
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
    notifyListeners();
  }

  Future<void> setScreenCapturePrevented(bool value) async {
    _screenCapturePrevented = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('screenCapturePrevented', value);
    // Platform channel will handle screen capture prevention
    notifyListeners();
  }

  Future<void> setPinEnabled(bool value) async {
    _pinEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_pinEnabledKey, value);
    notifyListeners();
  }

  Future<void> setBiometricEnabled(bool value) async {
    _biometricEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricEnabledKey, value);
    notifyListeners();
  }

  Future<void> setShowIcons(bool value) async {
    _showIcons = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showIconsKey, value);
    notifyListeners();
  }

  Future<void> setForceMonochromeIcons(bool value) async {
    _forceMonochromeIcons = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_forceMonochromeIconsKey, value);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
    notifyListeners();
  }

  Future<void> setPin(String pin) async {
    await _secureStorage.write(key: _pinKey, value: pin);
  }

  Future<String?> getPin() async {
    return await _secureStorage.read(key: _pinKey);
  }

  void updateLastUnlockTime() {
    _lastUnlockTime = DateTime.now();
    notifyListeners();
  }

  bool shouldRequireAuth() {
    if (!_pinEnabled && !_biometricEnabled) return false;
    if (_lastUnlockTime == null) return true;
    return DateTime.now().difference(_lastUnlockTime!) > _pinTimeout;
  }
}
