import 'dart:convert';
import 'package:covid19_tracker/screens/settings.dart';
import 'package:covid19_tracker/services/country.dart';
import 'package:covid19_tracker/services/network_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool firstTime = true;
  bool isLoadingGlobalData = false;
  bool isLoadingCountryData = false;
  bool isLoadingUsStateData = false;
  bool is404 = false;
  var globalData;
  var countryData;
  var usStateData;
  var lastUpdated;
  var numberFormat = NumberFormat('###,###');
  var countryDropDownValue = 'Today';
  var globalDropDownValue = 'Today';
  var usStateDropDownValue = 'Today';
  var isConnectedGlobal = false;
  var isConnectedCountry = false;
  var isConnectedUs = false;
  var country;
  var selectedState = 'Alabama';
  var width;
  var height;

  Future _getSpecificUsState(endpoint) async {
    print('sending api request to get data');
    setState(() {
      isLoadingUsStateData = true;
    });

    final connectionResult = await Network().checkInternetConnection();

    if (connectionResult) {
      print('connected to the internet');
      setState(() {
        isConnectedUs = true;
      });

      final http.Response response = await Network().getData(endpoint);

      if (response != null && response.statusCode == 200) {
        print('===================');
        print(jsonDecode(response.body));
        usStateData = jsonDecode(response.body);
        print('===================');
        print(usStateData);
        setState(() {
          is404 = false;
          isLoadingUsStateData = false;
          lastUpdated = DateFormat('dd-MM-yyyy  kk:mm').format(DateTime.now());
        });
        print(is404);
      } else if (response.statusCode == 404) {
        print('===================');
        print('state not found');
        usStateData = jsonDecode(response.body);
        print('===================');
        print(usStateData);
        setState(() {
          is404 = true;
          isLoadingUsStateData = false;
          lastUpdated = DateFormat('dd-MM-yyyy  kk:mm').format(DateTime.now());
        });
      }
    } else {
      print('No Internet connetion');
      setState(() {
        isConnectedUs = false;
        isLoadingUsStateData = false;
      });
    }
  }

  Future _getSpecificCountryStats(endpoint) async {
    print('sending api request to get data');
    setState(() {
      isLoadingCountryData = true;
    });

    final connectionResult = await Network().checkInternetConnection();

    if (connectionResult) {
      print('connected to the internet');
      setState(() {
        isConnectedCountry = true;
      });

      final http.Response response = await Network().getData(endpoint);

      if (response != null && response.statusCode == 200) {
        print('===================');
        print(jsonDecode(response.body));
        countryData = jsonDecode(response.body);
        print('===================');
        print(countryData);
        setState(() {
          is404 = false;
          isLoadingCountryData = false;
          lastUpdated = DateFormat('dd-MM-yyyy  kk:mm').format(DateTime.now());
        });
        print(is404);
      } else if (response.statusCode == 404) {
        print('===================');
        print('country not found');
        countryData = jsonDecode(response.body);
        print('===================');
        print(countryData);
        setState(() {
          is404 = true;
          isLoadingCountryData = false;
          lastUpdated = DateFormat('dd-MM-yyyy  kk:mm').format(DateTime.now());
        });
      }
    } else {
      print('No Internet connetion');
      setState(() {
        isConnectedCountry = false;
        isLoadingCountryData = false;
      });
    }
  }

  Future _getGlobalStats(endpoint) async {
    print('sending api request to get data');
    setState(() {
      isLoadingGlobalData = true;
    });

    final connectionResult = await Network().checkInternetConnection();
    if (connectionResult) {
      print('connected to the internet');
      setState(() {
        isConnectedGlobal = true;
      });

      final http.Response response = await Network().getData(endpoint);

      if (response != null && response.statusCode == 200) {
        print('===================');
        print(jsonDecode(response.body));
        globalData = jsonDecode(response.body);
        print('===================');
        print(globalData);

        setState(() {
          isLoadingGlobalData = false;
          lastUpdated = DateFormat('dd-MM-yyyy  kk:mm').format(DateTime.now());
        });
      }
    } else {
      print('No Internet connetion');
      setState(() {
        isConnectedGlobal = false;
        isLoadingGlobalData = false;
      });
    }
  }

  @override
  void initState() {
    _getGlobalStats('/all');
    _getSpecificUsState('/states/$selectedState');
    super.initState();

    Future.delayed(Duration(seconds: 2), () {
      country = Provider.of<CountryNotifier>(context, listen: false).country;
      print(country);
      _getSpecificCountryStats('/countries/$country?strict=false');
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.deepPurple[600],
            appBar: AppBar(
              actions: [
                IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Settings()));
                    }),
              ],
              bottom: TabBar(tabs: [
                Tab(
                  icon: Icon(FontAwesome.globe),
                  text: 'Global',
                ),
                Tab(
                  icon: Icon(
                    FontAwesome.flag,
                  ),
                  text: 'My Country',
                ),
                Tab(
                  child: Container(
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: SvgPicture.asset(
                                    'assets/icons/united-states.svg'),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text('USA'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // text: '',
                ),
              ]),
              backgroundColor: Colors.deepPurple,
              centerTitle: true,
              elevation: 10,
              title: Text(
                "Covid-19 Tracker",
                style: TextStyle(
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              ),
            ),
            floatingActionButton: Consumer<CountryNotifier>(
              builder: (context, notifier, child) => FloatingActionButton(
                onPressed: () {
                  print(notifier.country);
                  if (DefaultTabController.of(context).index == 0) {
                    print('inside global tab');
                    if (globalDropDownValue == 'Today') {
                      print('getting today\'s global data');
                      _getGlobalStats('/all');
                    } else if (globalDropDownValue == 'Yesterday') {
                      print('getting yesterday\'s global data');
                      _getGlobalStats('/all?yesterday=true');
                    } else if (globalDropDownValue == 'Two Days Ago') {
                      print('getting two days ago global data');
                      _getGlobalStats('/all?twoDaysAgo=true');
                    }
                  } else if (DefaultTabController.of(context).index == 1) {
                    print('inside country tab');
                    if (countryDropDownValue == 'Today') {
                      print('getting today\'s country data');
                      _getSpecificCountryStats(
                          '/countries/${notifier.country}?strict=false');
                    } else if (countryDropDownValue == 'Yesterday') {
                      print('getting yesterday\'s country data');
                      _getSpecificCountryStats(
                          '/countries/${notifier.country}?yesterday=true&strict=false');
                    }
                  } else if (DefaultTabController.of(context).index == 2) {
                    print('inside usa tab');
                    if (usStateDropDownValue == 'Today') {
                      print('getting today\'s usa data');
                      print('=========================================');
                      print(notifier.country);
                      _getSpecificCountryStats(
                          '/countries/${notifier.country}?strict=false');
                      _getSpecificUsState(
                          '/states/$selectedState?yesterday=false');
                    } else if (usStateDropDownValue == 'Yesterday') {
                      print('getting yesterday\'s usa data');
                      _getSpecificCountryStats(
                          '/countries/${notifier.country}?yesterday=true&strict=false');
                      _getSpecificUsState(
                          '/states/$selectedState?yesterday=true');
                    }
                  }
                },
                backgroundColor: Colors.green,
                tooltip: 'Reload',
                child: Icon(Icons.refresh),
              ),
            ),
            body: isLoadingGlobalData
                ? Center(
                    child: Theme(
                        data: Theme.of(context).copyWith(
                          canvasColor: Colors.white70,
                        ),
                        child: RefreshProgressIndicator()),
                  )
                : TabBarView(children: [
                    Tab(
                      child: isConnectedGlobal
                          ? isLoadingGlobalData
                              ? Theme(
                                  data: Theme.of(context).copyWith(
                                    canvasColor: Colors.white70,
                                  ),
                                  child: RefreshProgressIndicator())
                              : Container(
                                  width: width,
                                  height: height,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      0.0,
                                      10.0,
                                      0.0,
                                      0.0,
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Text(
                                            "Last Updated: ${lastUpdated.toString()}",
                                            style: TextStyle(
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                          DropdownButton<String>(
                                            value: globalDropDownValue,
                                            icon: Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.purpleAccent,
                                            ),
                                            iconSize: 28,
                                            elevation: 16,
                                            underline: Container(
                                              height: 2.0,
                                              color: Colors.purpleAccent,
                                            ),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                globalDropDownValue = value;
                                                if (globalDropDownValue ==
                                                    'Today') {
                                                  print(
                                                      'getting today globalData');
                                                  _getGlobalStats('/all');
                                                } else if (globalDropDownValue ==
                                                    'Yesterday') {
                                                  print(
                                                      'getting yesterday\'s globalData');
                                                  _getGlobalStats(
                                                      '/all?yesterday=true');
                                                } else if (globalDropDownValue ==
                                                    'Two Days Ago') {
                                                  print(
                                                      'getting two days ago globalData');
                                                  _getGlobalStats(
                                                      '/all?twoDaysAgo=true');
                                                }
                                              });
                                            },
                                            items: [
                                              'Today',
                                              'Yesterday',
                                              'Two Days Ago',
                                            ]
                                                .map<DropdownMenuItem<String>>(
                                                  (value) =>
                                                      DropdownMenuItem<String>(
                                                    child: Text(value),
                                                    value: value,
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Card(
                                                  elevation: 10.0,
                                                  shadowColor:
                                                      Colors.grey.shade600,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  color: Colors.white,
                                                  borderOnForeground: true,
                                                  child: Container(
                                                    height: 80.0,
                                                    width: 90,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Infected',
                                                              style: TextStyle(
                                                                fontSize: 15.0,
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5.0,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              numberFormat
                                                                  .format(
                                                                      globalData[
                                                                          'cases'])
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              FontAwesome
                                                                  .long_arrow_up,
                                                              color: Colors
                                                                  .blueAccent,
                                                              size: 10,
                                                            ),
                                                            Text(
                                                              numberFormat
                                                                  .format(globalData[
                                                                      'todayCases'])
                                                                  .toString(),
                                                              style:
                                                                  TextStyle(),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Card(
                                                  elevation: 10.0,
                                                  shadowColor:
                                                      Colors.grey.shade600,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  color: Colors.white,
                                                  borderOnForeground: true,
                                                  child: Container(
                                                    height: 80.0,
                                                    width: 90,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Deaths',
                                                              style: TextStyle(
                                                                fontSize: 15.0,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5.0,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              numberFormat
                                                                  .format(globalData[
                                                                      'deaths'])
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              FontAwesome
                                                                  .long_arrow_up,
                                                              color: Colors
                                                                  .redAccent,
                                                              size: 10,
                                                            ),
                                                            Text(numberFormat
                                                                .format(globalData[
                                                                    'todayDeaths'])
                                                                .toString()),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Card(
                                                  elevation: 10.0,
                                                  shadowColor:
                                                      Colors.grey.shade600,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  color: Colors.white,
                                                  borderOnForeground: true,
                                                  child: Container(
                                                    height: 80.0,
                                                    width: 90,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Recovered',
                                                              style: TextStyle(
                                                                fontSize: 15.0,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5.0,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              numberFormat
                                                                  .format(globalData[
                                                                      'recovered'])
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              FontAwesome
                                                                  .long_arrow_up,
                                                              color: Colors
                                                                      .greenAccent[
                                                                  700],
                                                              size: 10,
                                                            ),
                                                            Text(numberFormat
                                                                .format(globalData[
                                                                    'todayRecovered'])
                                                                .toString()),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Card(
                                                  elevation: 10.0,
                                                  shadowColor:
                                                      Colors.grey.shade600,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  color: Colors.green[400],
                                                  borderOnForeground: true,
                                                  child: Container(
                                                    height: 80.0,
                                                    width: 120,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Active',
                                                              style: TextStyle(
                                                                fontSize: 15.0,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5.0,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              numberFormat
                                                                  .format(globalData[
                                                                      'active'])
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Card(
                                                  elevation: 10.0,
                                                  shadowColor:
                                                      Colors.grey.shade600,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  color: Colors.redAccent[100],
                                                  borderOnForeground: true,
                                                  child: Container(
                                                    height: 80.0,
                                                    width: 120,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Critical',
                                                              style: TextStyle(
                                                                fontSize: 15.0,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5.0,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              numberFormat
                                                                  .format(globalData[
                                                                      'critical'])
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Card(
                                                  elevation: 10.0,
                                                  shadowColor:
                                                      Colors.grey.shade600,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  color: Colors.blueGrey,
                                                  borderOnForeground: true,
                                                  child: Container(
                                                    height: 80.0,
                                                    width: 100,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Population',
                                                              style: TextStyle(
                                                                fontSize: 15.0,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5.0,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              numberFormat
                                                                  .format(globalData[
                                                                      'population'])
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Card(
                                                  elevation: 10.0,
                                                  shadowColor:
                                                      Colors.grey.shade600,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  color: Colors.blueGrey,
                                                  borderOnForeground: true,
                                                  child: Container(
                                                    height: 80.0,
                                                    width: 85,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Countries',
                                                              style: TextStyle(
                                                                fontSize: 15.0,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5.0,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              numberFormat
                                                                  .format(globalData[
                                                                      'affectedCountries'])
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Card(
                                                  elevation: 10.0,
                                                  shadowColor:
                                                      Colors.grey.shade600,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  color: Colors.blueGrey,
                                                  borderOnForeground: true,
                                                  child: Container(
                                                    height: 80.0,
                                                    width: 100,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Tests',
                                                              style: TextStyle(
                                                                fontSize: 15.0,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5.0,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              numberFormat
                                                                  .format(
                                                                      globalData[
                                                                          'tests'])
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Divider(
                                            color: Colors.white,
                                            indent: 40,
                                            endIndent: 40,
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0, right: 20.0),
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.26,
                                              decoration: BoxDecoration(
                                                color: Colors.white70,
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(40.0),
                                                  topRight:
                                                      Radius.circular(40.0),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Table(
                                                  defaultVerticalAlignment:
                                                      TableCellVerticalAlignment
                                                          .middle,
                                                  columnWidths: {
                                                    0: FractionColumnWidth(0.7),
                                                    1: FractionColumnWidth(0.3),
                                                  },
                                                  children: [
                                                    TableRow(children: [
                                                      Text(
                                                        "Cases Per One Million",
                                                      ),
                                                      Text(
                                                        ": ${globalData['casesPerOneMillion'].toString()}",
                                                      ),
                                                    ]),
                                                    TableRow(children: [
                                                      Text(
                                                        "Deaths Per One Million",
                                                      ),
                                                      Text(
                                                        ": ${globalData['deathsPerOneMillion'].toString()}",
                                                      ),
                                                    ]),
                                                    TableRow(children: [
                                                      Text(
                                                        "Tests Per One Million",
                                                      ),
                                                      Text(
                                                        ": ${globalData['testsPerOneMillion'].toString()}",
                                                      ),
                                                    ]),
                                                    TableRow(children: [
                                                      Text(
                                                        "One Case Per People",
                                                      ),
                                                      Text(
                                                        ": ${globalData['oneCasePerPeople'].toString()}",
                                                      ),
                                                    ]),
                                                    TableRow(children: [
                                                      Text(
                                                        "One Death Per People",
                                                      ),
                                                      Text(
                                                        ": ${globalData['oneDeathPerPeople'].toString()}",
                                                      ),
                                                    ]),
                                                    TableRow(children: [
                                                      Text(
                                                        "One Test Per People",
                                                      ),
                                                      Text(
                                                        ": ${globalData['oneTestPerPeople'].toString()}",
                                                      ),
                                                    ]),
                                                    TableRow(children: [
                                                      Text(
                                                        "Active Per One Million",
                                                      ),
                                                      Text(
                                                        ": ${globalData['activePerOneMillion'].toString()}",
                                                      ),
                                                    ]),
                                                    TableRow(children: [
                                                      Text(
                                                        "Recovered Per One Million",
                                                      ),
                                                      Text(
                                                        ": ${globalData['recoveredPerOneMillion'].toString()}",
                                                      ),
                                                    ]),
                                                    TableRow(children: [
                                                      Text(
                                                        "Critical Per One Million",
                                                      ),
                                                      Text(
                                                        ": ${globalData['criticalPerOneMillion'].toString()}",
                                                      ),
                                                    ]),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                          : Center(
                              child: Container(
                                child: Text(
                                  'No interent connection',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                    ),
                    Tab(
                      child: isConnectedCountry
                          ? !is404
                              ? isLoadingCountryData
                                  ? Theme(
                                      data: Theme.of(context).copyWith(
                                        canvasColor: Colors.white70,
                                      ),
                                      child: RefreshProgressIndicator())
                                  : Container(
                                      width: width,
                                      height: height,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          0.0,
                                          10.0,
                                          0.0,
                                          0.0,
                                        ),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              Text(
                                                "Last Updated: ${lastUpdated.toString()}",
                                                style: TextStyle(
                                                  color: Colors.grey[500],
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 10.0,
                                                      right: 58.0,
                                                    ),
                                                    child: is404
                                                        ? Container(
                                                            height: 50.0,
                                                            width: 40.0,
                                                            color: Colors.white)
                                                        : Container(
                                                            height: 50.0,
                                                            width: 40.0,
                                                            child: (countryData !=
                                                                    null)
                                                                ? Image.network(
                                                                    countryData[
                                                                            'countryInfo']
                                                                        [
                                                                        'flag'],
                                                                  )
                                                                : Container()),
                                                  ),
                                                  Consumer<CountryNotifier>(
                                                    builder: (context, notifier,
                                                            child) =>
                                                        DropdownButton<String>(
                                                      value:
                                                          countryDropDownValue,
                                                      icon: Icon(
                                                        Icons.arrow_drop_down,
                                                        color:
                                                            Colors.purpleAccent,
                                                      ),
                                                      iconSize: 28,
                                                      elevation: 16,
                                                      underline: Container(
                                                        height: 2.0,
                                                        color:
                                                            Colors.purpleAccent,
                                                      ),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          countryDropDownValue =
                                                              value;
                                                          if (countryDropDownValue ==
                                                              'Today') {
                                                            print(
                                                                'getting today data');
                                                            _getSpecificCountryStats(
                                                                '/countries/${notifier.country}?strict=false');
                                                          } else if (countryDropDownValue ==
                                                              'Yesterday') {
                                                            print(
                                                                'getting yesterday\'s data');
                                                            _getSpecificCountryStats(
                                                                '/countries/${notifier.country}?yesterday=true&strict=false');
                                                          }
                                                        });
                                                      },
                                                      items: [
                                                        'Today',
                                                        'Yesterday',
                                                      ]
                                                          .map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                            (value) =>
                                                                DropdownMenuItem<
                                                                    String>(
                                                              child:
                                                                  Text(value),
                                                              value: value,
                                                            ),
                                                          )
                                                          .toList(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Card(
                                                      elevation: 10.0,
                                                      shadowColor:
                                                          Colors.grey.shade600,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      color: Colors.white,
                                                      borderOnForeground: true,
                                                      child: Container(
                                                        height: 80.0,
                                                        width: 90,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  'Infected',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15.0,
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5.0,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  numberFormat
                                                                      .format(countryData[
                                                                          'cases'])
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                  FontAwesome
                                                                      .long_arrow_up,
                                                                  color: Colors
                                                                      .blueAccent,
                                                                  size: 10,
                                                                ),
                                                                Text(
                                                                  numberFormat
                                                                      .format(countryData[
                                                                          'todayCases'])
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Card(
                                                      elevation: 10.0,
                                                      shadowColor:
                                                          Colors.grey.shade600,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      color: Colors.white,
                                                      borderOnForeground: true,
                                                      child: Container(
                                                        height: 80.0,
                                                        width: 90,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  'Deaths',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15.0,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5.0,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  numberFormat
                                                                      .format(countryData[
                                                                          'deaths'])
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                  FontAwesome
                                                                      .long_arrow_up,
                                                                  color: Colors
                                                                      .redAccent,
                                                                  size: 10,
                                                                ),
                                                                Text(numberFormat
                                                                    .format(countryData[
                                                                        'todayDeaths'])
                                                                    .toString()),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Card(
                                                      elevation: 10.0,
                                                      shadowColor:
                                                          Colors.grey.shade600,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      color: Colors.white,
                                                      borderOnForeground: true,
                                                      child: Container(
                                                        height: 80.0,
                                                        width: 90,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  'Recovered',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15.0,
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5.0,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  numberFormat
                                                                      .format(countryData[
                                                                          'recovered'])
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                  FontAwesome
                                                                      .long_arrow_up,
                                                                  color: Colors
                                                                          .greenAccent[
                                                                      700],
                                                                  size: 10,
                                                                ),
                                                                Text(numberFormat
                                                                    .format(countryData[
                                                                        'todayRecovered'])
                                                                    .toString()),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Card(
                                                      elevation: 10.0,
                                                      shadowColor:
                                                          Colors.grey.shade600,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      color: Colors.green[400],
                                                      borderOnForeground: true,
                                                      child: Container(
                                                        height: 80.0,
                                                        width: 120,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  'Active',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15.0,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5.0,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  numberFormat
                                                                      .format(countryData[
                                                                          'active'])
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Card(
                                                      elevation: 10.0,
                                                      shadowColor:
                                                          Colors.grey.shade600,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      color:
                                                          Colors.redAccent[100],
                                                      borderOnForeground: true,
                                                      child: Container(
                                                        height: 80.0,
                                                        width: 120,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  'Critical',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15.0,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5.0,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  numberFormat
                                                                      .format(countryData[
                                                                          'critical'])
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Card(
                                                      elevation: 10.0,
                                                      shadowColor:
                                                          Colors.grey.shade600,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      color: Colors.blueGrey,
                                                      borderOnForeground: true,
                                                      child: Container(
                                                        height: 80.0,
                                                        width: 95,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  'Population',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15.0,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5.0,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  numberFormat
                                                                      .format(countryData[
                                                                          'population'])
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Card(
                                                      elevation: 10.0,
                                                      shadowColor:
                                                          Colors.grey.shade600,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      color: Colors.blueGrey,
                                                      borderOnForeground: true,
                                                      child: Container(
                                                        height: 80.0,
                                                        width: 120,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  'Continent',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15.0,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5.0,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  countryData[
                                                                          'continent']
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Card(
                                                      elevation: 10.0,
                                                      shadowColor:
                                                          Colors.grey.shade600,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      color: Colors.blueGrey,
                                                      borderOnForeground: true,
                                                      child: Container(
                                                        height: 80.0,
                                                        width: 95,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  'Tests',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15.0,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5.0,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  numberFormat
                                                                      .format(countryData[
                                                                          'tests'])
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Divider(
                                                color: Colors.white,
                                                indent: 40,
                                                endIndent: 40,
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20.0, right: 20.0),
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.26,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white70,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(40.0),
                                                      topRight:
                                                          Radius.circular(40.0),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20.0),
                                                    child: Table(
                                                      defaultVerticalAlignment:
                                                          TableCellVerticalAlignment
                                                              .middle,
                                                      columnWidths: {
                                                        0: FractionColumnWidth(
                                                            0.7),
                                                        1: FractionColumnWidth(
                                                            0.3),
                                                      },
                                                      children: [
                                                        TableRow(children: [
                                                          Text(
                                                            "Cases Per One Million",
                                                          ),
                                                          Text(
                                                            ": ${countryData['casesPerOneMillion'].toString()}",
                                                          ),
                                                        ]),
                                                        TableRow(children: [
                                                          Text(
                                                            "Deaths Per One Million",
                                                          ),
                                                          Text(
                                                            ": ${countryData['deathsPerOneMillion'].toString()}",
                                                          ),
                                                        ]),
                                                        TableRow(children: [
                                                          Text(
                                                            "Tests Per One Million",
                                                          ),
                                                          Text(
                                                            ": ${countryData['testsPerOneMillion'].toString()}",
                                                          ),
                                                        ]),
                                                        TableRow(children: [
                                                          Text(
                                                            "One Case Per People",
                                                          ),
                                                          Text(
                                                            ": ${countryData['oneCasePerPeople'].toString()}",
                                                          ),
                                                        ]),
                                                        TableRow(children: [
                                                          Text(
                                                            "One Death Per People",
                                                          ),
                                                          Text(
                                                            ": ${countryData['oneDeathPerPeople'].toString()}",
                                                          ),
                                                        ]),
                                                        TableRow(children: [
                                                          Text(
                                                            "One Test Per People",
                                                          ),
                                                          Text(
                                                            ": ${countryData['oneTestPerPeople'].toString()}",
                                                          ),
                                                        ]),
                                                        TableRow(children: [
                                                          Text(
                                                            "Active Per One Million",
                                                          ),
                                                          Text(
                                                            ": ${countryData['activePerOneMillion'].toString()}",
                                                          ),
                                                        ]),
                                                        TableRow(children: [
                                                          Text(
                                                            "Recovered Per One Million",
                                                          ),
                                                          Text(
                                                            ": ${countryData['recoveredPerOneMillion'].toString()}",
                                                          ),
                                                        ]),
                                                        TableRow(children: [
                                                          Text(
                                                            "Critical Per One Million",
                                                          ),
                                                          Text(
                                                            ": ${countryData['criticalPerOneMillion'].toString()}",
                                                          ),
                                                        ]),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                              : Padding(
                                  padding: const EdgeInsets.all(50.0),
                                  child: Center(
                                    child: Container(
                                      child: Text(
                                        'The country $country was not found or doesn\'t have any cases.',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                          : Center(
                              child: Container(
                                child: Text(
                                  'No interent connection',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                    ),
                    Tab(
                      child: isConnectedUs
                          ? isLoadingUsStateData
                              ? Theme(
                                  data: Theme.of(context).copyWith(
                                    canvasColor: Colors.white70,
                                  ),
                                  child: RefreshProgressIndicator())
                              : Container(
                                  width: width,
                                  height: height,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      0.0,
                                      10.0,
                                      0.0,
                                      0.0,
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Text(
                                            "Last Updated: ${lastUpdated.toString()}",
                                            style: TextStyle(
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              DropdownButton<String>(
                                                value: selectedState,
                                                icon: Icon(
                                                  Icons.arrow_drop_down,
                                                  color: Colors.purpleAccent,
                                                ),
                                                iconSize: 28,
                                                elevation: 16,
                                                underline: Container(
                                                  height: 2.0,
                                                  color: Colors.purpleAccent,
                                                ),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedState = value;
                                                    if (usStateDropDownValue ==
                                                        'Today') {
                                                      print(
                                                          'getting today us state data');
                                                      _getSpecificUsState(
                                                          '/states/$selectedState?');
                                                    } else if (usStateDropDownValue ==
                                                        'Yesterday') {
                                                      print(
                                                          'getting yesterday\'s us state data');
                                                      _getSpecificUsState(
                                                          '/states/$selectedState?yesterday=true');
                                                    }
                                                  });
                                                },
                                                items: [
                                                  'Alabama',
                                                  'Alaska',
                                                  'Arizona',
                                                  'Arkansas',
                                                  'California',
                                                  'Colorado',
                                                  'Connecticut',
                                                  'Delaware',
                                                  'Florida',
                                                  'Georgia',
                                                  'Hawaii',
                                                  'Idaho',
                                                  'Illinois',
                                                  'Indiana',
                                                  'Iowa',
                                                  'Kansas',
                                                  'Kentucky',
                                                  'Louisiana',
                                                  'Maine',
                                                  'Maryland',
                                                  'Massachusetts',
                                                  'Michigan',
                                                  'Minnesota',
                                                  'Mississippi',
                                                  'Missouri',
                                                  'Montana',
                                                  'Nebraska',
                                                  'Nevada',
                                                  'New Hampshire',
                                                  'New Jersey',
                                                  'New Mexico',
                                                  'New York',
                                                  'North Carolina',
                                                  'North Dakota',
                                                  'Ohio',
                                                  'Oklahoma',
                                                  'Oregon',
                                                  'Pennsylvania',
                                                  'Rhode Island',
                                                  'South Carolina',
                                                  'South Dakota',
                                                  'Tennessee',
                                                  'Texas',
                                                  'Utah',
                                                  'Vermont',
                                                  'Virginia',
                                                  'Washington',
                                                  'West Virginia',
                                                  'Wisconsin',
                                                  'Wyoming',
                                                ]
                                                    .map<
                                                        DropdownMenuItem<
                                                            String>>(
                                                      (value) =>
                                                          DropdownMenuItem<
                                                              String>(
                                                        child: Text(value),
                                                        value: value,
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                              SizedBox(
                                                width: 40.0,
                                              ),
                                              DropdownButton<String>(
                                                value: usStateDropDownValue,
                                                icon: Icon(
                                                  Icons.arrow_drop_down,
                                                  color: Colors.purpleAccent,
                                                ),
                                                iconSize: 28,
                                                elevation: 16,
                                                underline: Container(
                                                  height: 2.0,
                                                  color: Colors.purpleAccent,
                                                ),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                onChanged: (value) {
                                                  setState(() {
                                                    usStateDropDownValue =
                                                        value;
                                                    if (usStateDropDownValue ==
                                                        'Today') {
                                                      print(
                                                          'getting today us state data');
                                                      _getSpecificUsState(
                                                          '/states/$selectedState?');
                                                    } else if (usStateDropDownValue ==
                                                        'Yesterday') {
                                                      print(
                                                          'getting yesterday\'s us state data');
                                                      _getSpecificUsState(
                                                          '/states/$selectedState?yesterday=true');
                                                    }
                                                  });
                                                },
                                                items: [
                                                  'Today',
                                                  'Yesterday',
                                                ]
                                                    .map<
                                                        DropdownMenuItem<
                                                            String>>(
                                                      (value) =>
                                                          DropdownMenuItem<
                                                              String>(
                                                        child: Text(value),
                                                        value: value,
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Card(
                                                  elevation: 10.0,
                                                  shadowColor:
                                                      Colors.grey.shade600,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  color: Colors.white,
                                                  borderOnForeground: true,
                                                  child: Container(
                                                    height: 80.0,
                                                    width: 90,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Infected',
                                                              style: TextStyle(
                                                                fontSize: 15.0,
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5.0,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              numberFormat
                                                                  .format(
                                                                      usStateData[
                                                                          'cases'])
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              FontAwesome
                                                                  .long_arrow_up,
                                                              color: Colors
                                                                  .blueAccent,
                                                              size: 10,
                                                            ),
                                                            Text(
                                                              numberFormat
                                                                  .format(usStateData[
                                                                      'todayCases'])
                                                                  .toString(),
                                                              style:
                                                                  TextStyle(),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Card(
                                                  elevation: 10.0,
                                                  shadowColor:
                                                      Colors.grey.shade600,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  color: Colors.white,
                                                  borderOnForeground: true,
                                                  child: Container(
                                                    height: 80.0,
                                                    width: 90,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Deaths',
                                                              style: TextStyle(
                                                                fontSize: 15.0,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5.0,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              numberFormat
                                                                  .format(usStateData[
                                                                      'deaths'])
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              FontAwesome
                                                                  .long_arrow_up,
                                                              color: Colors
                                                                  .redAccent,
                                                              size: 10,
                                                            ),
                                                            Text(numberFormat
                                                                .format(usStateData[
                                                                    'todayDeaths'])
                                                                .toString()),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Card(
                                                  elevation: 10.0,
                                                  shadowColor:
                                                      Colors.grey.shade600,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  color: Colors.white,
                                                  borderOnForeground: true,
                                                  child: Container(
                                                    height: 80.0,
                                                    width: 90,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Recovered',
                                                              style: TextStyle(
                                                                fontSize: 15.0,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5.0,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              numberFormat
                                                                  .format(usStateData[
                                                                      'recovered'])
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              FontAwesome
                                                                  .long_arrow_up,
                                                              color: Colors
                                                                      .greenAccent[
                                                                  700],
                                                              size: 10,
                                                            ),
                                                            Text(usStateData[
                                                                        'todayRecovered'] ==
                                                                    null
                                                                ? '0'
                                                                : numberFormat
                                                                    .format(usStateData[
                                                                        'todayRecovered'])
                                                                    .toString()),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Card(
                                                  elevation: 10.0,
                                                  shadowColor:
                                                      Colors.grey.shade600,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  color: Colors.green[400],
                                                  borderOnForeground: true,
                                                  child: Container(
                                                    height: 80.0,
                                                    width: 200,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Active',
                                                              style: TextStyle(
                                                                fontSize: 15.0,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5.0,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              numberFormat
                                                                  .format(usStateData[
                                                                      'active'])
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Card(
                                                  elevation: 10.0,
                                                  shadowColor:
                                                      Colors.grey.shade600,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  color: Colors.blueGrey,
                                                  borderOnForeground: true,
                                                  child: Container(
                                                    height: 80.0,
                                                    width: 150,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Population',
                                                              style: TextStyle(
                                                                fontSize: 15.0,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5.0,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              numberFormat
                                                                  .format(usStateData[
                                                                      'population'])
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Card(
                                                  elevation: 10.0,
                                                  shadowColor:
                                                      Colors.grey.shade600,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  color: Colors.blueGrey,
                                                  borderOnForeground: true,
                                                  child: Container(
                                                    height: 80.0,
                                                    width: 150,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Tests',
                                                              style: TextStyle(
                                                                fontSize: 15.0,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5.0,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              numberFormat
                                                                  .format(
                                                                      usStateData[
                                                                          'tests'])
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Divider(
                                            color: Colors.white,
                                            indent: 40,
                                            endIndent: 40,
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0, right: 20.0),
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.26,
                                              decoration: BoxDecoration(
                                                color: Colors.white70,
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(40.0),
                                                  topRight:
                                                      Radius.circular(40.0),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Table(
                                                  defaultVerticalAlignment:
                                                      TableCellVerticalAlignment
                                                          .middle,
                                                  columnWidths: {
                                                    0: FractionColumnWidth(0.7),
                                                    1: FractionColumnWidth(0.3),
                                                  },
                                                  children: [
                                                    TableRow(children: [
                                                      Text(
                                                        "Cases Per One Million",
                                                      ),
                                                      Text(
                                                        ": ${usStateData['casesPerOneMillion'].toString()}",
                                                      ),
                                                    ]),
                                                    TableRow(children: [
                                                      Text(
                                                        "Deaths Per One Million",
                                                      ),
                                                      Text(
                                                        ": ${usStateData['deathsPerOneMillion'].toString()}",
                                                      ),
                                                    ]),
                                                    TableRow(children: [
                                                      Text(
                                                        "Tests Per One Million",
                                                      ),
                                                      Text(
                                                        ": ${usStateData['testsPerOneMillion'].toString()}",
                                                      ),
                                                    ]),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                          : Center(
                              child: Container(
                                child: Text(
                                  'No interent connection',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                    ),
                  ]),
          );
        },
      ),
    );
  }
}
