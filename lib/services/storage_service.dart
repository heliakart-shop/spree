import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_config.dart';

class StorageService {
  static Future<void> savePath(String path) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setString(AppConfig.savedLinkKey, path);
  }

  static Future<String?> getSavedPath() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    return storage.getString(AppConfig.savedLinkKey);
  }

  static Future<void> setAccessStatus(int status) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setInt(AppConfig.isPermittedKey, status);
  }

  static Future<int> getAccessStatus() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    return storage.getInt(AppConfig.isPermittedKey) ?? 0;
  }

  static Future<void> setRequestStatus(int status) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setInt(AppConfig.isRequestedKey, status);
  }

  static Future<int> getRequestStatus() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    return storage.getInt(AppConfig.isRequestedKey) ?? 0;
  }

  static Future<void> setAnswerStatus(int status) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setInt(AppConfig.gotAnswerKey, status);
  }

  static Future<int> getAnswerStatus() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    return storage.getInt(AppConfig.gotAnswerKey) ?? 0;
  }

  static Future<bool> hasSavedPath() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    return storage.containsKey(AppConfig.savedLinkKey);
  }
}
