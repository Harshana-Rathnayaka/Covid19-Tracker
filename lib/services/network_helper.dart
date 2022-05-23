import 'dart:io';

import 'package:http/http.dart' as http;

class Network {
  final String url = "https://disease.sh/v3/covid-19";

  Future getData(endpoint) async {
    var fullUrl = url + endpoint;

    try {
      return await http.get(Uri.parse(fullUrl)).timeout(Duration(seconds: 10));
    } on SocketException {
      throw SocketException('No internet connection.');
    }
  }
}
