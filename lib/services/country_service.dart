import 'package:flutter/cupertino.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CountryNotifier extends ChangeNotifier {
  SharedPreferences? _sharedPreferences;
  final String countryKey = "country";
  final String countryCodeKey = "countryDialCode";
  String? _country;
  String? _countryDialCode;

// getters
  String? get country => _country;
  String? get countryDialCode => _countryDialCode;

  CountryNotifier() {
    _loadFromPrefs(); // default values
  }

  // function to save the country
  bool saveCountry(country, countryDialCode) {
    _country = country ?? 'Sri Lanka';
    _countryDialCode = countryDialCode ?? '+94';
    try {
      _saveToPrefs();
      notifyListeners();
      return true;
    } catch (e) {
      print(e.toString());
      notifyListeners();
      return false;
    }
  }

  // initiating SharedPreferences
  _initPrefs() async {
    if (_sharedPreferences == null) {
      _sharedPreferences = await SharedPreferences.getInstance();
    }
  }

  // loading saved preferences
  _loadFromPrefs() async {
    await _initPrefs();
    _country = _sharedPreferences!.getString(countryKey);
    _countryDialCode = _sharedPreferences!.getString(countryCodeKey);

    notifyListeners();
  }

  // saving to preferences
  _saveToPrefs() async {
    await _initPrefs();
    _sharedPreferences!.setString(countryKey, _country!);
    _sharedPreferences!.setString(countryCodeKey, _countryDialCode!);
  }
}
