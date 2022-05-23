import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'enums/connectivity_status.dart';
import 'screens/home.dart';
import 'services/connectivity_service.dart';
import 'services/country_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CountryNotifier()),
          StreamProvider<ConnectivityStatus>.value(value: ConnectivityService().connectionStatusController.stream, initialData: ConnectivityStatus.Offline),
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
