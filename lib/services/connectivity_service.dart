import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static Future<bool> hasConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  static Future<http.Response> sendRequest(bool useGetMethod, String endpoint) async {
    if (useGetMethod) {
      return await http.get(Uri.parse(endpoint));
    } else {
      return await http.head(Uri.parse(endpoint));
    }
  }
}
