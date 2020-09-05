import 'dart:convert';

import 'package:covid19_tracker/screens/settings.dart';
import 'package:covid19_tracker/services/network_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool firstTime = true;
  bool isLoading = false;
  var data;
  var lastUpdated;
  var numberFormat = NumberFormat('###,###');

  Future _getGlobalStats(endpoint) async {
    print('sending api request to get data');
    setState(() {
      isLoading = true;
    });
    final http.Response response = await Network().getData('/all');

    if (response != null && response.statusCode == 200) {
      print('===================');
      print(jsonDecode(response.body));
      data = jsonDecode(response.body);
      print('===================');
      print(data);
      print("cases: ${data['cases']}");
      setState(() {
        isLoading = false;
        lastUpdated = DateFormat('dd-MM-yyyy  kk:mm').format(DateTime.now());
      });
    }
  }

  @override
  void initState() {
    _getGlobalStats('/all');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: Colors.deepPurple[600],
        // resizeToAvoidBottomInset: true,
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _getGlobalStats('/all');
          },
          backgroundColor: Colors.green,
          tooltip: 'Reload',
          child: Icon(Icons.refresh),
        ),
        body: isLoading
            ? Center(
                child: RefreshProgressIndicator(),
              )
            : TabBarView(children: [
                Tab(
                  child: isLoading
                      ? RefreshProgressIndicator()
                      : Container(
                          height: MediaQuery.of(context).size.height,
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
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Card(
                                              elevation: 10.0,
                                              shadowColor: Colors.grey.shade600,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              color: Colors.white,
                                              borderOnForeground: true,
                                              child: Container(
                                                height: 80.0,
                                                width: 90,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
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
                                                            color: Colors.blue,
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
                                                                  data['cases'])
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                                          color:
                                                              Colors.blueAccent,
                                                          size: 10,
                                                        ),
                                                        Text(
                                                          numberFormat
                                                              .format(data[
                                                                  'todayCases'])
                                                              .toString(),
                                                          style: TextStyle(),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Card(
                                              elevation: 10.0,
                                              shadowColor: Colors.grey.shade600,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              color: Colors.white,
                                              borderOnForeground: true,
                                              child: Container(
                                                height: 80.0,
                                                width: 90,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
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
                                                            color: Colors.red,
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
                                                              .format(data[
                                                                  'deaths'])
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                                          color:
                                                              Colors.redAccent,
                                                          size: 10,
                                                        ),
                                                        Text(numberFormat
                                                            .format(data[
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
                                              shadowColor: Colors.grey.shade600,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              color: Colors.white,
                                              borderOnForeground: true,
                                              child: Container(
                                                height: 80.0,
                                                width: 90,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
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
                                                            color: Colors.green,
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
                                                              .format(data[
                                                                  'recovered'])
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                                              .greenAccent[700],
                                                          size: 10,
                                                        ),
                                                        Text(numberFormat
                                                            .format(data[
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
                                              shadowColor: Colors.grey.shade600,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              color: Colors.green[400],
                                              borderOnForeground: true,
                                              child: Container(
                                                height: 80.0,
                                                width: 120,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
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
                                                            color: Colors.white,
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
                                                              .format(data[
                                                                  'active'])
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
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
                                              shadowColor: Colors.grey.shade600,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              color: Colors.redAccent[100],
                                              borderOnForeground: true,
                                              child: Container(
                                                height: 80.0,
                                                width: 120,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
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
                                                            color: Colors.white,
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
                                                              .format(data[
                                                                  'critical'])
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
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
                                              shadowColor: Colors.grey.shade600,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              color: Colors.blueGrey,
                                              borderOnForeground: true,
                                              child: Container(
                                                height: 80.0,
                                                width: 95,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
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
                                                            color: Colors.white,
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
                                                              .format(data[
                                                                  'population'])
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
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
                                              shadowColor: Colors.grey.shade600,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              color: Colors.blueGrey,
                                              borderOnForeground: true,
                                              child: Container(
                                                height: 80.0,
                                                width: 90,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
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
                                                            color: Colors.white,
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
                                                              .format(data[
                                                                  'affectedCountries'])
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
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
                                              shadowColor: Colors.grey.shade600,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              color: Colors.blueGrey,
                                              borderOnForeground: true,
                                              child: Container(
                                                height: 80.0,
                                                width: 95,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
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
                                                            color: Colors.white,
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
                                                                  data['tests'])
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
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
                                    ],
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
                                    padding: const EdgeInsets.only(left:20.0, right: 20.0),
                                    child: Container(
                                      height: MediaQuery.of(context).size.height *
                                          0.31,
                                      decoration: BoxDecoration(
                                        color: Colors.white70,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(40.0),
                                          topRight: Radius.circular(40.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Table(
                                          defaultVerticalAlignment:
                                              TableCellVerticalAlignment.middle,
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
                                                ": ${data['casesPerOneMillion'].toString()}",
                                              ),
                                            ]),
                                            TableRow(children: [
                                              Text(
                                                "Deaths Per One Million",
                                              ),
                                              Text(
                                                ": ${data['deathsPerOneMillion'].toString()}",
                                              ),
                                            ]),
                                            TableRow(children: [
                                              Text(
                                                "Tests Per One Million",
                                              ),
                                              Text(
                                                ": ${data['testsPerOneMillion'].toString()}",
                                              ),
                                            ]),
                                            TableRow(children: [
                                              Text(
                                                "One Case Per People",
                                              ),
                                              Text(
                                                ": ${data['oneCasePerPeople'].toString()}",
                                              ),
                                            ]),
                                            TableRow(children: [
                                              Text(
                                                "One Death Per People",
                                              ),
                                              Text(
                                                ": ${data['oneDeathPerPeople'].toString()}",
                                              ),
                                            ]),
                                            TableRow(children: [
                                              Text(
                                                "One Test Per People",
                                              ),
                                              Text(
                                                ": ${data['oneTestPerPeople'].toString()}",
                                              ),
                                            ]),
                                            TableRow(children: [
                                              Text(
                                                "Active Per One Million",
                                              ),
                                              Text(
                                                ": ${data['activePerOneMillion'].toString()}",
                                              ),
                                            ]),
                                            TableRow(children: [
                                              Text(
                                                "Recovered Per One Million",
                                              ),
                                              Text(
                                                ": ${data['recoveredPerOneMillion'].toString()}",
                                              ),
                                            ]),
                                            TableRow(children: [
                                              Text(
                                                "Critical Per One Million",
                                              ),
                                              Text(
                                                ": ${data['criticalPerOneMillion'].toString()}",
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
                        ),
                ),
                Tab(
                  child: Text("Country"),
                )
              ]),
      ),
    );
  }
}
