import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('vi'); // Default to Vietnamese

  Locale get locale => _locale;

  Future<void> setLocale(Locale newLocale) async {
    if (_locale == newLocale) return;
    _locale = newLocale;
    notifyListeners();
    _saveLocaleToSharedPreferences(newLocale);
  }

  Future<void> _saveLocaleToSharedPreferences(Locale newLocale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('language_code', newLocale.languageCode);
  }

  Future<void> loadLocaleFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('language_code');
    if (languageCode != null) {
      _locale = Locale(languageCode);
      notifyListeners();
    }
  }
}
