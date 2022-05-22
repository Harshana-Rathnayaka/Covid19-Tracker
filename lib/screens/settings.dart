import 'package:country_list_pick/country_list_pick.dart';
import 'package:covid19_tracker/services/country.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var selectedCountry;
  bool isLoading = false;
  var countryDialCode = '+94';
  var width;
  var height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.deepPurple[200],
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          centerTitle: true,
          elevation: 10,
          title: Text("Settings", style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold, fontSize: 22.0)),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                height: height / 2,
                width: width,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Select Your Country',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Consumer<CountryNotifier>(
                        builder: (context, notifier, child) => CountryListPick(
                          theme: CountryTheme(isDownIcon: false, isShowFlag: true, showEnglishName: true, isShowTitle: true),
                          initialSelection: notifier.countryDialCode,
                          onChanged: (CountryCode code) {
                            print(code.dialCode);
                            setState(() {
                              selectedCountry = code.name;
                              countryDialCode = code.dialCode;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Consumer<CountryNotifier>(
                        builder: (context, notifier, child) => MaterialButton(
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                            });
                            Future.delayed(Duration(seconds: 1), () {
                              final countrySaved = notifier.saveCountry(selectedCountry, countryDialCode);
                              if (countrySaved) {
                                setState(() {
                                  isLoading = false;
                                });
                                Fluttertoast.showToast(backgroundColor: Colors.green, msg: '$selectedCountry was saved as your country');
                              } else {
                                Fluttertoast.showToast(backgroundColor: Colors.redAccent, msg: 'something went wrong');
                                print('something went wrong');
                              }
                            });
                          },
                          height: 40.0,
                          color: Colors.purpleAccent,
                          elevation: 10.0,
                          textColor: Colors.white,
                          minWidth: 150.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Save',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
