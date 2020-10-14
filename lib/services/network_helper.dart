import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;

class Network {
  final String url = "https://disease.sh/v3/covid-19";

  getData(endpoint) async {
    var fullUrl = url + endpoint;

    return await http.get(fullUrl);
  }

  checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      return true;
    }
  }
}
