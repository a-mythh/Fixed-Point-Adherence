import 'dart:typed_data';

import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  DatabaseHelper.internal();

  Future<Database> initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path_ = path.join(databasesPath, 'fpa_db.db');
    var db = await openDatabase(path_, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    // Create your tables here if needed
    await db.execute('CREATE TABLE fpa_wipro_data (datePicked TEXT, plantName TEXT, zoneName TEXT, zoneLeader TEXT, pathType TEXT, imagePath TEXT)');
    await db.execute('CREATE TABLE fpa_wipro_users (username TEXT PRIMARY KEY, password TEXT, accType TEXT)');
    await db.execute('CREATE TABLE fpa_wipro_plants (plantName TEXT PRIMARY KEY)');
    await db.execute('CREATE TABLE fpa_wipro_zones (zoneName TEXT PRIMARY KEY)');
  }

  Future<void> closeDatabase() async {
    if (_db != null && _db!.isOpen) {
      await _db!.close();
      _db = null;
    }
  }
  //Main DATA table (DATA -> EXCEL)
  Future<void> insertRecordData(String datePicked, String plantName, String zoneName, String zoneLeader, String pathType, String imagePath) async {
    Database? db = await this.db;
    await db?.insert('fpa_wipro_data', {'datePicked': datePicked, 'plantName': plantName, 'zoneName' : zoneName, 'zoneLeader' : zoneLeader, 'pathType' : pathType, 'imagePath' : imagePath});
  }

  Future<List<Map<String, dynamic>>?> getRecordsData() async {
    Database? db = await this.db;
    return await db?.query('fpa_wipro_data');
  }

  // PLANTS Data
  Future<void> insertRecordPlants(String plantName) async {
    Database? db = await this.db;
    await db?.insert('fpa_wipro_plants', {'plantName' : plantName});
  }

  Future<List<Map<String, dynamic>>?> getRecordsPlants() async {
    Database? db = await this.db;
    return await db?.query('fpa_wipro_plants');
  }

  Future<void> deleteRecordPlants(String plantName) async {
    Database? db = await this.db;
    await db?.delete('fpa_wipro_plants', where: 'plantName = ?', whereArgs: [plantName]);
  }

  //ZONES Data
  Future<void> insertRecordZones(String zoneName) async {
    Database? db = await this.db;
    await db?.insert('fpa_wipro_zones', {'zoneName': zoneName});
  }

  Future<List<Map<String, dynamic>>?> getRecordsZones() async {
    Database? db = await this.db;
    return await db?.query('fpa_wipro_zones');
  }

  Future<void> deleteRecordZones(String zoneName) async {
    Database? db = await this.db;
    await db?.delete('fpa_wipro_zones', where: 'zoneName = ?', whereArgs: [zoneName]);
  }

  //USERS Data
  //TO-DO
  /*
  Future<void> insertRecordUser(String username, String password, String accType) async {
    Database? db = await this.db;
    await db?.insert('fpa_wipro_users', {'username': username, 'password': password, 'accType': accType});
  }
  */

  Future<void> insertRecordUser(String username, String password) async {
    Database? db = await this.db;
    await db?.insert('fpa_wipro_users', {'username': username, 'password': password});
  }

  Future<List<Map<String, dynamic>>?> getRecordsUser() async {
    Database? db = await this.db;
    return await db?.query('fpa_wipro_users');
  }

  Future<List<Map<String, dynamic>>?> getRecordsSingleUser(String username) async {
    Database? db = await this.db;
    return await db?.query('fpa_wipro_users', where: 'username = ?', whereArgs: [username]);
  }

  Future<void> deleteRecordUser(String username) async {
    Database? db = await this.db;
    await db?.delete('fpa_wipro_users', where: 'username = ?', whereArgs: [username]);
  }
}