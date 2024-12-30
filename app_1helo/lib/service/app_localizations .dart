// ignore_for_file: file_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  late Map<String, String> _localizedStrings;

  Future<void> load() async {
    // Default language is 'vi' if the selected locale's language code is not available
    String jsonString;
    try {
      jsonString = await rootBundle
          .loadString('assets/lang/${locale.languageCode}.json');
    } catch (e) {
      // If the selected locale file is not found, fall back to Vietnamese
      jsonString = await rootBundle.loadString('assets/lang/vi.json');
    }

    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      AppLocalizationsDelegate();
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Support both Vietnamese and English languages
    return ['en', 'vi'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // Default to Vietnamese if the locale is not provided or not supported
    Locale effectiveLocale =
        ['en', 'vi'].contains(locale.languageCode) ? locale : const Locale('vi');
    AppLocalizations localizations = AppLocalizations(effectiveLocale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
