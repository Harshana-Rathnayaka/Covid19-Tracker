import 'package:covid19_tracker/services/country.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CountryNotifier(),
      child: Consumer<CountryNotifier>(
          builder: (context, CountryNotifier notifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MyHomePage(),
          theme: ThemeData(
            fontFamily: 'Montserrat',
            primarySwatch: Colors.purple,
            canvasColor: Colors.purpleAccent[200],
          ),
        );
      }),
    );
  }
}
