import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var selectedCountry;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.deepPurple[200],
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          centerTitle: true,
          elevation: 10,
          title: Text(
            "Settings",
            style: TextStyle(
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
            ),
          ),
        ),
        body: Container(
          height: 300,
          width: MediaQuery.of(context).size.width,
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
                CountryListPick(
                  isDownIcon: true,
                  isShowFlag: true,
                  showEnglishName: true,
                  isShowTitle: true,
                  initialSelection: '+94',
                  onChanged: (CountryCode code) {
                    setState(() {
                      selectedCountry = code.name;
                    });
                    print(selectedCountry);
                  },
                ),
                SizedBox(height: 20.0),
                MaterialButton(
                  onPressed: () {},
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
