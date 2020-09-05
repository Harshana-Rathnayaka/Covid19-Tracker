import 'package:http/http.dart' as http;

class Network {
  final String url = "https://disease.sh/v3/covid-19";

  // get global total
  getData(endpoint) async {
    var fullUrl = url + endpoint;

    return await http.get(fullUrl);
  }
}
