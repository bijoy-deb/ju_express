import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

import '../model/common/district.dart';

@injectable
class DataBaseHelper {
  static DataBaseHelper? _databaseHelper;
  static Database? _database;

  String districtTable = 'district_table';
  String distID = 'distID';
  String distTitle = 'distTitle';

  DataBaseHelper._createInstance();

  factory DataBaseHelper() {
    _databaseHelper ??= DataBaseHelper._createInstance();
    return _databaseHelper!;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    String path = "";
    await getDatabasesPath()
        .then((value) => {
      if(Platform.isIOS){
        path = "$value/bus_database.db"
      }else{
        path='${value}bus_database.db'
      }
    });
    final database = openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE district(distID TEXT PRIMARY KEY,topDistrict TEXT, distTitle TEXT)',
        );
      },
      version: 1,
    );
    return database;
  }

  Future<List<District>> getDistricts() async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('district');

    return List.generate(maps.length, (i) {
      return District(
          distId: maps[i]['distID'], distTitle: maps[i]['distTitle']);
    });
  }

  Future<void> insertDistricts(List<District> district) async {
    Database db = await database;
    district.forEach((element) async => await db.insert(
          'district',
          element.toJson(),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        ));
  }

  Future<void> clearDistricts() async {
    Database db = await database;
    await db.delete("district");
  }
}
