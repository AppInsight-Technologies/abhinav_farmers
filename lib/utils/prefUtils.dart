import 'package:shared_preferences/shared_preferences.dart';


class PrefUtils {
  //static PrefUtils _storageUtil;
  // static SharedPreferences _preferences;//=await SharedPreferences.getInstance();
  //static Future<SharedPreferences> get _instance async => _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences? prefs;

  PrefUtils._();

  static Future init() async {
    prefs = await SharedPreferences.getInstance();
  }
}
