import 'package:shared_preferences/shared_preferences.dart';

class SessionPreferences {
  static SharedPreferences? _preferences;

  static const _keySiteList = 'siteList';
  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setSiteList(List<dynamic> siteList) async {
    List<String> castSiteList = [];
    for(var i=0; i<siteList.length; i++)
      castSiteList.add(siteList[i]);
    await _preferences!.setStringList(_keySiteList, castSiteList);
  }

  static List<String>? getSiteList() => _preferences!.getStringList(_keySiteList);
}
