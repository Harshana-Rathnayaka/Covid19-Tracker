import 'package:covid19_tracker/services/connectivity_service.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'enums/connectivity_status.dart';
import 'screens/home.dart';
import 'services/country.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CountryNotifier()),
          StreamProvider<ConnectivityStatus>.value(value: ConnectivityService().connectionStatusController.stream, initialData: null),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MyHomePage(),
          theme: ThemeData(
            fontFamily: 'Montserrat',
            primarySwatch: Colors.purple,
            canvasColor: Colors.purpleAccent[200],
          ),
        ));
  }
}
