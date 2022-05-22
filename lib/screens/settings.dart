import 'package:flutter/material.dart';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../services/country.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _isLoading = false;
  String selectedCountryName;
  String selectedCountryDialCode;
  Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    var countryNotifier = Provider.of<CountryNotifier>(context);

    return Scaffold(
      backgroundColor: Colors.deepPurple[200],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 10,
        title: Text("Settings", style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold, fontSize: 22.0)),
      ),
      body: _isLoading
          ? Center(child: Theme(data: Theme.of(context).copyWith(canvasColor: Colors.white), child: RefreshProgressIndicator()))
          : Container(
              height: size.height,
              width: size.width,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Select Your Country', style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold)),
                    CountryListPick(
                      theme: CountryTheme(isDownIcon: false, isShowFlag: true, showEnglishName: true, isShowTitle: true),
                      initialSelection: countryNotifier.countryDialCode ?? '+94',
                      onChanged: (CountryCode code) {
                        setState(() {
                          selectedCountryName = code.name;
                          selectedCountryDialCode = code.dialCode;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    Consumer<CountryNotifier>(
                      builder: (context, notifier, child) => MaterialButton(
                        onPressed: () => saveCountry(notifier),
                        height: 40.0,
                        color: Colors.purpleAccent,
                        elevation: 10.0,
                        textColor: Colors.white,
                        minWidth: 150.0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Text('Save', style: TextStyle(fontSize: 18.0)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

// saving a country to local memory
  void saveCountry(CountryNotifier notifier) {
    setState(() => _isLoading = true);
    final countrySaved = notifier.saveCountry(selectedCountryName ?? notifier.country, selectedCountryDialCode ?? notifier.countryDialCode);
    if (countrySaved) {
      Fluttertoast.showToast(backgroundColor: Colors.green, msg: '${notifier.country} was saved as your country.');
    } else {
      Fluttertoast.showToast(backgroundColor: Colors.redAccent, msg: 'Something went wrong.');
    }
    setState(() => _isLoading = false);
  }
}
