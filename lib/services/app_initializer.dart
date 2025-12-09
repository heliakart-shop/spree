import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_config.dart';
import 'connectivity_service.dart';
import 'storage_service.dart';

class AppInitializer {
  final Function() onComplete;
  final Function() onError;
  final Function() onShowMainMenu;
  final Function(double) onProgressUpdate;

  bool isActive = true;
  bool shouldRetryWithGet = true;
  double loadingTime = AppConfig.defaultLoadingTime;
  double elapsedTime = 0.0;
  Timer? loadingTimer;

  AppInitializer({
    required this.onComplete,
    required this.onError,
    required this.onShowMainMenu,
    required this.onProgressUpdate,
  });

  Future<void> initialize() async {
    isActive = true;
    await _checkConditions();
    _startProgressTimer();
  }

  Future<void> _checkConditions() async {
    await _checkNetwork();
  }

  Future<void> _checkNetwork() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool hasInternet = await ConnectivityService.hasConnection();

    if (!hasInternet &&
        (prefs.getInt(AppConfig.isRequestedKey) ?? 0) == 1 &&
        (prefs.getInt(AppConfig.gotAnswerKey) ?? 0) == 1 &&
        (prefs.getInt(AppConfig.isPermittedKey) ?? 0) == 0) {
      onShowMainMenu();
      return;
    }

    if (!hasInternet) {
      onError();
      return;
    }

    await _handleRequests(prefs);
  }

  Future<void> _handleRequests(SharedPreferences prefs) async {
    if (((prefs.getInt(AppConfig.isRequestedKey) ?? 0) == 0 ||
            !prefs.containsKey(AppConfig.savedLinkKey)) &&
        (prefs.getInt(AppConfig.gotAnswerKey) ?? 0) == 0) {
      await _makeRequest(false);
    } else if ((prefs.getInt(AppConfig.isPermittedKey) ?? 0) == 1) {
      await _openContentView();
    } else {
      onShowMainMenu();
    }
  }

  Future<void> _makeRequest(bool useGetMethod) async {
    try {
      http.Response response = await ConnectivityService.sendRequest(
        useGetMethod,
        AppConfig.defaultEndpoint,
      );
      await _handleResponse(response);
    } catch (e) {
      onShowMainMenu();
    }
  }

  Future<void> _handleResponse(http.Response response) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConfig.isRequestedKey, 1);

    await _checkStatusCode(response);
    await prefs.setInt(AppConfig.gotAnswerKey, 1);
  }

  Future<void> _checkStatusCode(http.Response response) async {
    if (response.statusCode == 405 && shouldRetryWithGet) {
      shouldRetryWithGet = false;
      await _makeRequest(true);
    } else if (response.statusCode == 404) {
      onShowMainMenu();
    } else if (response.statusCode >= 200 && response.statusCode < 300) {
      await _checkPageContent();
    } else {
      onShowMainMenu();
    }
  }

  Future<void> _checkPageContent() async {
    try {
      http.Response contentResponse =
          await http.get(Uri.parse(AppConfig.defaultEndpoint));

      if (contentResponse.statusCode == 200) {
        await _analyzeContent(contentResponse.body);
      } else {
        onShowMainMenu();
      }
    } catch (e) {
      onShowMainMenu();
    }
  }

  Future<void> _analyzeContent(String pageContent) async {
    if (pageContent.contains(AppConfig.verificationKey)) {
      onShowMainMenu();
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt(AppConfig.isPermittedKey, 1);
      onComplete();
    }
  }

  Future<void> _openContentView() async {
    onComplete();
  }

  void _startProgressTimer() {
    loadingTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (elapsedTime < loadingTime) {
        elapsedTime += 0.016;
        onProgressUpdate(elapsedTime / loadingTime);
      } else {
        timer.cancel();
      }
    });
  }

  void dispose() {
    loadingTimer?.cancel();
  }
}
