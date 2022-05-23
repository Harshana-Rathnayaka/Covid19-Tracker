import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../enums/connectivity_status.dart';
import '../models/country.dart';
import '../models/global.dart';
import '../models/state.dart';
import '../screens/settings.dart';
import '../services/country.dart';
import '../services/network_helper.dart';
import '../utils/constants.dart';
import '../utils/helper_methods.dart';
import '../utils/widgets/BottomContainer.dart';
import '../utils/widgets/InfoCard.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  Global globalData;
  Country countryData;
  States usStateData;
  List days = ['Today', 'Yesterday', 'Two Days Ago'];
  String selectedDropdownValue = 'Today';
  String selectedState = 'Alabama';
  Size size;

  @override
  void initState() {
    super.initState();

    _getGlobalData();
    _getUsaData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    CountryNotifier countryNotifier = Provider.of<CountryNotifier>(context);
    if (countryNotifier.country != null) _getCountryData(countryNotifier.country);
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    final connectionStatus = Provider.of<ConnectivityStatus>(context);

    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.deepPurple[600],
            appBar: AppBar(
              backgroundColor: Colors.deepPurple,
              centerTitle: true,
              elevation: 10,
              title: Text("Covid-19 Tracker", style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold, fontSize: 22.0)),
              actions: [IconButton(icon: Icon(Icons.settings), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Settings())))],
              bottom: TabBar(tabs: [
                Tab(icon: Icon(Icons.travel_explore), text: 'Global'),
                Tab(icon: Icon(Icons.flag), text: 'My Country'),
                Tab(
                  child: Column(
                    children: [
                      Expanded(child: Row(children: [Expanded(child: SvgPicture.asset('assets/icons/united-states.svg'))])),
                      Padding(padding: const EdgeInsets.only(top: 8.0), child: Text('USA')),
                    ],
                  ),
                  // text: '',
                ),
              ]),
            ),
            floatingActionButton: Consumer<CountryNotifier>(
              builder: (context, notifier, child) => FloatingActionButton(
                backgroundColor: Colors.green,
                tooltip: 'Reload',
                child: Icon(Icons.refresh),
                onPressed: () {
                  _handleFloatingBtn(context, connectionStatus, notifier);
                },
              ),
            ),
            body: TabBarView(children: [
              _isLoading || globalData == null
                  ? Center(child: Theme(data: Theme.of(context).copyWith(canvasColor: Colors.white), child: RefreshProgressIndicator()))
                  : Tab(
                      child: globalData != null
                          ? Container(
                              width: size.width,
                              height: size.height,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      lastUpdatedTime(globalData.updated),
                                      DropdownButton<String>(
                                        value: selectedDropdownValue,
                                        icon: Icon(Icons.arrow_drop_down, color: Colors.purpleAccent),
                                        iconSize: 28,
                                        elevation: 16,
                                        underline: Container(height: 2.0, color: Colors.purpleAccent),
                                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                        items: days.map<DropdownMenuItem<String>>((value) => DropdownMenuItem<String>(child: Text(value), value: value)).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedDropdownValue = value;
                                            if (connectionStatus != ConnectivityStatus.Offline) {
                                              _getGlobalData(selectedDropdownValue);
                                            } else {
                                              showToast('No internet connection.');
                                            }
                                          });
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            InfoCard(
                                              heading: 'Infected',
                                              bodyText1: globalData.cases,
                                              bodyText2: globalData.todayCases,
                                              headingColor: Colors.blue,
                                              bodyText1Color: Colors.black,
                                            ),
                                            InfoCard(
                                              heading: 'Deaths',
                                              bodyText1: globalData.deaths,
                                              bodyText2: globalData.todayDeaths,
                                              headingColor: Colors.red,
                                              bodyText1Color: Colors.black,
                                            ),
                                            InfoCard(
                                              heading: 'Recovered',
                                              bodyText1: globalData.recovered,
                                              bodyText2: globalData.todayRecovered,
                                              headingColor: Colors.green,
                                              bodyText1Color: Colors.black,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            InfoCard(heading: 'Active', bodyText1: globalData.active, backgroundColor: Colors.green[400]),
                                            InfoCard(heading: 'Critical', bodyText1: globalData.critical, backgroundColor: Colors.redAccent[100]),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            InfoCard(heading: 'Population', bodyText1: globalData.population, backgroundColor: Colors.blueGrey),
                                            InfoCard(heading: 'Countries', bodyText1: globalData.affectedCountries, backgroundColor: Colors.blueGrey),
                                            InfoCard(heading: 'Tests', bodyText1: globalData.tests, backgroundColor: Colors.blueGrey),
                                          ],
                                        ),
                                      ),
                                      Divider(color: Colors.white, indent: 10, endIndent: 10),
                                      SizedBox(height: 5.0),
                                      BottomContainer(
                                        child: Table(
                                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                          columnWidths: {0: FractionColumnWidth(0.7), 1: FractionColumnWidth(0.3)},
                                          children: [
                                            TableRow(children: [Text("Cases Per One Million"), Text(": ${numberFormat.format(globalData.casesPerOneMillion).toString()}")]),
                                            TableRow(children: [Text("Deaths Per One Million"), Text(": ${numberFormat.format(globalData.deathsPerOneMillion).toString()}")]),
                                            TableRow(children: [Text("Tests Per One Million"), Text(": ${numberFormat.format(globalData.testsPerOneMillion).toString()}")]),
                                            TableRow(children: [Text("One Case Per People"), Text(": ${globalData.oneCasePerPeople.toString()}")]),
                                            TableRow(children: [Text("One Death Per People"), Text(": ${globalData.oneDeathPerPeople.toString()}")]),
                                            TableRow(children: [Text("One Test Per People"), Text(": ${globalData.oneTestPerPeople.toString()}")]),
                                            TableRow(children: [Text("Active Per One Million"), Text(": ${numberFormat.format(globalData.activePerOneMillion).toString()}")]),
                                            TableRow(children: [Text("Recovered Per One Million"), Text(": ${numberFormat.format(globalData.recoveredPerOneMillion).toString()}")]),
                                            TableRow(children: [Text("Critical Per One Million"), Text(": ${numberFormat.format(globalData.criticalPerOneMillion).toString()}")]),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Center(child: Text('No records found', style: TextStyle(color: Colors.white)))),
              Consumer<CountryNotifier>(
                builder: (context, notifier, child) => Tab(
                  child: _isLoading
                      ? Center(child: Theme(data: Theme.of(context).copyWith(canvasColor: Colors.white), child: RefreshProgressIndicator()))
                      : countryData != null
                          ? Container(
                              width: size.width,
                              height: size.height,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      lastUpdatedTime(countryData.updated),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 10.0, right: 50.0),
                                            child: countryData != null ? Container(height: 38.0, width: 40.0, child: Image.network(countryData.countryInfo.flag)) : Container(),
                                          ),
                                          Consumer<CountryNotifier>(
                                            builder: (context, notifier, child) => DropdownButton<String>(
                                              value: selectedDropdownValue,
                                              icon: Icon(Icons.arrow_drop_down, color: Colors.purpleAccent),
                                              iconSize: 28,
                                              elevation: 16,
                                              underline: Container(height: 2.0, color: Colors.purpleAccent),
                                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                              items: days.map<DropdownMenuItem<String>>((value) => DropdownMenuItem<String>(child: Text(value), value: value)).toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedDropdownValue = value;

                                                  if (connectionStatus != ConnectivityStatus.Offline) {
                                                    _getCountryData(notifier.country, selectedDropdownValue);
                                                  } else {
                                                    showToast('No internet connection.');
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            InfoCard(
                                              heading: 'Infected',
                                              bodyText1: countryData.cases,
                                              bodyText2: countryData.todayCases,
                                              headingColor: Colors.blue,
                                              bodyText1Color: Colors.black,
                                            ),
                                            InfoCard(
                                              heading: 'Deaths',
                                              bodyText1: countryData.deaths,
                                              bodyText2: countryData.todayDeaths,
                                              headingColor: Colors.red,
                                              bodyText1Color: Colors.black,
                                            ),
                                            InfoCard(
                                              heading: 'Recovered',
                                              bodyText1: countryData.recovered,
                                              bodyText2: countryData.todayRecovered,
                                              headingColor: Colors.green,
                                              bodyText1Color: Colors.black,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            InfoCard(heading: 'Active', bodyText1: countryData.active, backgroundColor: Colors.green[400]),
                                            InfoCard(heading: 'Critical', bodyText1: countryData.critical, backgroundColor: Colors.redAccent[100]),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            InfoCard(heading: 'Population', bodyText1: countryData.population, backgroundColor: Colors.blueGrey),
                                            InfoCard(heading: 'Continent', bodyText1: countryData.continent, backgroundColor: Colors.blueGrey),
                                            InfoCard(heading: 'Tests', bodyText1: countryData.tests, backgroundColor: Colors.blueGrey),
                                          ],
                                        ),
                                      ),
                                      Divider(color: Colors.white, indent: 10, endIndent: 10),
                                      SizedBox(height: 5.0),
                                      BottomContainer(
                                        child: Table(
                                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                          columnWidths: {0: FractionColumnWidth(0.7), 1: FractionColumnWidth(0.3)},
                                          children: [
                                            TableRow(children: [Text("Cases Per One Million"), Text(": ${numberFormat.format(countryData.casesPerOneMillion).toString()}")]),
                                            TableRow(children: [Text("Deaths Per One Million"), Text(": ${numberFormat.format(countryData.deathsPerOneMillion).toString()}")]),
                                            TableRow(children: [Text("Tests Per One Million"), Text(": ${numberFormat.format(countryData.testsPerOneMillion).toString()}")]),
                                            TableRow(children: [Text("One Case Per People"), Text(": ${countryData.oneCasePerPeople.toString()}")]),
                                            TableRow(children: [Text("One Death Per People"), Text(": ${countryData.oneDeathPerPeople.toString()}")]),
                                            TableRow(children: [Text("One Test Per People"), Text(": ${countryData.oneTestPerPeople.toString()}")]),
                                            TableRow(children: [Text("Active Per One Million"), Text(": ${numberFormat.format(countryData.activePerOneMillion).toString()}")]),
                                            TableRow(children: [Text("Recovered Per One Million"), Text(": ${numberFormat.format(countryData.recoveredPerOneMillion).toString()}")]),
                                            TableRow(children: [Text("Critical Per One Million"), Text(": ${numberFormat.format(countryData.criticalPerOneMillion).toString()}")]),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Center(child: Text(notifier.country != null ? 'No records found for ${notifier.country}' : 'Please select a country from Settings', style: TextStyle(color: Colors.white))),
                ),
              ),
              _isLoading || usStateData == null
                  ? Center(child: Theme(data: Theme.of(context).copyWith(canvasColor: Colors.white), child: RefreshProgressIndicator()))
                  : Tab(
                      child: usStateData != null
                          ? Container(
                              width: size.width,
                              height: size.height,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      lastUpdatedTime(usStateData.updated),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          DropdownButton<String>(
                                            value: selectedState,
                                            icon: Icon(Icons.arrow_drop_down, color: Colors.purpleAccent),
                                            iconSize: 28,
                                            elevation: 16,
                                            underline: Container(height: 2.0, color: Colors.purpleAccent),
                                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                            items: states.map<DropdownMenuItem<String>>((value) => DropdownMenuItem<String>(child: Text(value), value: value)).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                selectedState = value;

                                                if (connectionStatus != ConnectivityStatus.Offline) {
                                                  _getUsaData(selectedDropdownValue);
                                                } else {
                                                  showToast('No internet connection.');
                                                }
                                              });
                                            },
                                          ),
                                          SizedBox(width: 40.0),
                                          DropdownButton<String>(
                                            value: selectedDropdownValue,
                                            icon: Icon(Icons.arrow_drop_down, color: Colors.purpleAccent),
                                            iconSize: 28,
                                            elevation: 16,
                                            underline: Container(height: 2.0, color: Colors.purpleAccent),
                                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                            items: days.map<DropdownMenuItem<String>>((value) => DropdownMenuItem<String>(child: Text(value), value: value)).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                selectedDropdownValue = value;

                                                if (connectionStatus != ConnectivityStatus.Offline) {
                                                  _getUsaData(selectedDropdownValue);
                                                } else {
                                                  showToast('No internet connection.');
                                                }
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            InfoCard(
                                              heading: 'Infected',
                                              bodyText1: usStateData.cases,
                                              bodyText2: usStateData.todayCases,
                                              headingColor: Colors.blue,
                                              bodyText1Color: Colors.black,
                                            ),
                                            InfoCard(
                                              heading: 'Deaths',
                                              bodyText1: usStateData.deaths,
                                              bodyText2: usStateData.todayDeaths,
                                              headingColor: Colors.red,
                                              bodyText1Color: Colors.black,
                                            ),
                                            InfoCard(
                                              heading: 'Recovered',
                                              bodyText1: usStateData.recovered,
                                              bodyText2: 0,
                                              headingColor: Colors.green,
                                              bodyText1Color: Colors.black,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [InfoCard(heading: 'Active', bodyText1: usStateData.active, backgroundColor: Colors.green[400])],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            InfoCard(heading: 'Population', bodyText1: usStateData.population, backgroundColor: Colors.blueGrey),
                                            InfoCard(heading: 'Tests', bodyText1: usStateData.tests, backgroundColor: Colors.blueGrey),
                                          ],
                                        ),
                                      ),
                                      Divider(color: Colors.white, indent: 10, endIndent: 10),
                                      SizedBox(height: 5.0),
                                      BottomContainer(
                                        child: Table(
                                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                          columnWidths: {0: FractionColumnWidth(0.7), 1: FractionColumnWidth(0.3)},
                                          children: [
                                            TableRow(children: [Text("Cases Per One Million"), Text(": ${numberFormat.format(usStateData.casesPerOneMillion).toString()}")]),
                                            TableRow(children: [Text("Deaths Per One Million"), Text(": ${numberFormat.format(usStateData.deathsPerOneMillion).toString()}")]),
                                            TableRow(children: [Text("Tests Per One Million"), Text(": ${numberFormat.format(usStateData.testsPerOneMillion).toString()}")]),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Center(child: Text('No records found', style: TextStyle(color: Colors.white)))),
            ]),
          );
        },
      ),
    );
  }

// last updated time
  Text lastUpdatedTime(time) => Text(
        "Last Updated: ${DateFormat('yyyy-MM-dd  kk:mm').format(DateTime.fromMillisecondsSinceEpoch(time)).toString()}",
        style: TextStyle(color: Colors.grey[500]),
      );

// get global data
  Future _getGlobalData([dropDownValue]) async {
    String endpoint = '/all';

    setState(() {
      globalData = null;
      _isLoading = true;
    });

    if (dropDownValue != null) {
      if (dropDownValue == 'Yesterday') {
        endpoint = '/all?yesterday=true';
      } else if (dropDownValue == 'Two Days Ago') {
        endpoint = '/all?twoDaysAgo=true';
      }
    }

    Network().getData(endpoint).then((response) {
      if (response != null && response.statusCode == 200) setState(() => globalData = Global.fromRawJson(response.body));
    }, onError: (error) => showToast(error.message.toString()));
    setState(() => _isLoading = false);
  }

// get specific country data
  Future _getCountryData(country, [dropDownValue]) async {
    String endpoint = '/countries/$country?strict=false';

    setState(() {
      countryData = null;
      _isLoading = true;
    });

    if (dropDownValue != null && dropDownValue == 'Yesterday') endpoint = '/countries/$country?yesterday=true&strict=false';

    Network().getData(endpoint).then((response) {
      if (response != null && response.statusCode == 200) setState(() => countryData = Country.fromRawJson(response.body));
    }, onError: (error) => showToast(error.message.toString()));
    setState(() => _isLoading = false);
  }

// get USA data by state
  Future _getUsaData([dropDownValue]) async {
    String endpoint = '/states/$selectedState?yesterday=false';

    setState(() {
      usStateData = null;
      _isLoading = true;
    });

    if (dropDownValue != null && dropDownValue == 'Yesterday') endpoint = '/states/$selectedState?yesterday=true';

    Network().getData(endpoint).then((response) {
      if (response != null && response.statusCode == 200) setState(() => usStateData = States.fromRawJson(response.body));
    }, onError: (error) => showToast(error.message.toString()));
    setState(() => _isLoading = false);
  }

// floating action btn click
  void _handleFloatingBtn(context, connectionStatus, notifier) {
    if (connectionStatus != ConnectivityStatus.Offline) {
      if (DefaultTabController.of(context).index == 0) {
        _getGlobalData(selectedDropdownValue);
      } else if (DefaultTabController.of(context).index == 1) {
        _getCountryData(notifier.country, selectedDropdownValue);
      } else if (DefaultTabController.of(context).index == 2) {
        _getUsaData(selectedDropdownValue);
      }
    } else {
      showToast('No internet connection.');
    }
  }
}
