import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AppSharedPreferences {
  Future setLastDBUpdate(int value);

  int getLastDBUpdate();

  Future setVUHash(String value);

  String getVUHash();

// Future setFromCity(District value);
// District getFromCity();
//
// Future setToCity(District value);
// District getToCity();
//
Future setFirstTimeOpen(bool value);
bool getFirstTimeOpen();
//
// Future setHomePageInt(HomePageIntRes value);
// HomePageIntRes getHomePageInt();
}

@Injectable(as: AppSharedPreferences)
@injectable
class AppSharedPreferencesImpl extends AppSharedPreferences {
  final SharedPreferences sharedPreferences;

  AppSharedPreferencesImpl(this.sharedPreferences);

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
  setVUHash(String value) async {
    return await sharedPreferences.setString('vuHash', value);
  }

  @override
  String getVUHash() {
    return sharedPreferences.getString('vuHash') ?? "";
  }
  @override
  bool getFirstTimeOpen() {
    return sharedPreferences.getBool('first_time_open') ?? true;
  }

  @override
  setFirstTimeOpen(bool value) async {
    return await sharedPreferences.setBool('first_time_open', value);
  }
}
//
//   @override
//   setLastDBUpdate(int value) async {
//     return await sharedPreferences.setInt('last_db_update', value);
//   }
//
//   @override
//   District getFromCity() {
//     String saved = sharedPreferences.getString('from') ?? "";
//     if (saved.isEmpty) {
//       return District();
//     } else {
//       return District.fromJson(jsonDecode(saved));
//     }
//   }
//
//   @override
//   setFromCity(District value) async {
//     return await sharedPreferences.setString(
//         'from', jsonEncode(value.toJson()));
//   }
//
//   @override
//   District getToCity() {
//     String saved = sharedPreferences.getString('to') ?? "";
//     if (saved.isEmpty) {
//       return District();
//     } else {
//       return District.fromJson(jsonDecode(saved));
//     }
//   }
//
//   @override
//   setToCity(District value) async {
//     return await sharedPreferences.setString('to', jsonEncode(value.toJson()));
//   }
//

//
//   @override
//   String getVHash() {
//     return sharedPreferences.getString('vhash') ?? "";
//   }
//
//   @override
//   setVHash(String value) async {
//     return await sharedPreferences.setString('vhash', value);
//   }
//
//   @override
//   Future<bool> setHomePageInt(HomePageIntRes value) async {
//     return await sharedPreferences.setString(
//         "homeInfo", jsonEncode(value.toJson()));
//   }
//
//   @override
//   HomePageIntRes getHomePageInt() {
//     return HomePageIntRes.fromJson(
//         jsonDecode(sharedPreferences.getString("homeInfo") ?? "{}"));
//   }
