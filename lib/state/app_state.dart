import 'package:pb_authenticator_state/state.dart';
import 'package:pb_authenticator_totp/totp.dart';
import 'package:flutter/widgets.dart';
import 'package:collection/collection.dart' show ListEquality;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

// TODO: Transition to new type
typedef BaseItemType = LegacyAuthenticatorItem;

/// Represents app state.
class AppState extends ChangeNotifier {
  final RepositoryBase<BaseItemType> _repository;

  // Theme and screen capture settings
  ThemeMode _themeMode = ThemeMode.system;
  bool _screenCapturePrevented = false;

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
    // Platform channel will handle screen capture prevention
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
}
