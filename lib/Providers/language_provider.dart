import 'package:Clothes_App/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  // shared pref object
  Future<SharedPreferences> _sharedPreference = SharedPreferences.getInstance();

  Locale _appLocale = Locale('en');

  Locale get appLocale {
    locale.then((localeValue) {
      if (localeValue != null) {
        _appLocale = Locale(localeValue);
      }
    });

    return _appLocale;
  }

  void updateLanguage(String languageCode) {
    if (languageCode == "ar") {
      _appLocale = Locale("ar");
    } else {
      _appLocale = Locale("en");
    }
    changeLanguage(languageCode);
    notifyListeners();
  }

  Future<void> changeLanguage(String value) {
    return _sharedPreference.then((prefs) {
      return prefs.setString(kLanguageCode, value);
    });
  }

  Future<String> get locale {
    return _sharedPreference.then((prefs) {
      return prefs.getString(kLanguageCode) ?? null;
    });
  }
}
