import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/authentication/response/login_response_model.dart';
import '../model/common/district.dart';
import '../model/home/home_page_int_res.dart';

abstract class AppSharedPrefs {
  Future setLastDBUpdate(int value);

  int getLastDBUpdate();

  Future setAuthCode(String authcode);

  String getAuthCode();

  Future setUserInfo(UserInfo userInfo);

  UserInfo getUserInfo();

  Future setLnCode(String value);

  String getLnCode();

  Future setVHash(String value);

  String getVHash();

  Future setFromCity(District value);

  District getFromCity();

  Future setToCity(District value);

  District getToCity();

  Future setFirstEntry(bool value);

  bool getFirstEntry();

  Future setHomePageInt(HomePageIntRes value);

  HomePageIntRes getHomePageInt();
}

@Injectable(as: AppSharedPrefs)
@injectable
class AppSharedPreferencesImpl extends AppSharedPrefs {
  final SharedPreferences sharedPreferences;

  AppSharedPreferencesImpl(this.sharedPreferences);

  @override
  setAuthCode(String authcode) async {
    return await sharedPreferences.setString('auth_code', authcode);
  }

  @override
  String getAuthCode() {
    return sharedPreferences.getString('auth_code') ?? "";
  }

  @override
  Future<bool> setUserInfo(UserInfo userInfo) async {
    return await sharedPreferences.setString(
        "userInfo", jsonEncode(userInfo.toJson()));
  }

  @override
  UserInfo getUserInfo() {
    return UserInfo.fromJson(
        jsonDecode(sharedPreferences.getString("userInfo") ?? "{}"));
  }

  @override
  int getLastDBUpdate() {
    return sharedPreferences.getInt('last_db_update') ??
        DateTime.now().subtract(const Duration(days: 2)).millisecondsSinceEpoch;
  }

  @override
  setLastDBUpdate(int value) async {
    return await sharedPreferences.setInt('last_db_update', value);
  }

  @override
  String getLnCode() {
    return sharedPreferences.getString('lnCode') ?? "1";
  }

  @override
  setLnCode(String value) async {
    return await sharedPreferences.setString('lnCode', value);
  }

  @override
  District getFromCity() {
    String saved = sharedPreferences.getString('from') ?? "";
    if (saved.isEmpty) {
      return District();
    } else {
      return District.fromJson(jsonDecode(saved));
    }
  }

  @override
  setFromCity(District value) async {
    return await sharedPreferences.setString(
        'from', jsonEncode(value.toJson()));
  }

  @override
  District getToCity() {
    String saved = sharedPreferences.getString('to') ?? "";
    if (saved.isEmpty) {
      return District();
    } else {
      return District.fromJson(jsonDecode(saved));
    }
  }

  @override
  setToCity(District value) async {
    return await sharedPreferences.setString('to', jsonEncode(value.toJson()));
  }

  @override
  bool getFirstEntry() {
    return sharedPreferences.getBool('first_entry') ?? true;
  }

  @override
  setFirstEntry(bool value) async {
    return await sharedPreferences.setBool('first_entry', value);
  }

  @override
  String getVHash() {
    return sharedPreferences.getString('vhash') ?? "";
  }

  @override
  setVHash(String value) async {
    return await sharedPreferences.setString('vhash', value);
  }

  @override
  Future<bool> setHomePageInt(HomePageIntRes value) async {
    return await sharedPreferences.setString(
        "homeInfo", jsonEncode(value.toJson()));
  }

  @override
  HomePageIntRes getHomePageInt() {
    return HomePageIntRes.fromJson(
        jsonDecode(sharedPreferences.getString("homeInfo") ?? "{}"));
  }
}
