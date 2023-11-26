import 'package:Fixed_Point_Adherence/models/plant_zone.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:encrypt/encrypt.dart';

const String dataTable = 'fpa_wipro_data';
const String userTable = 'fpa_wipro_users';
const String plantTable = 'fpa_wipro_plants';
const String zoneTable = 'fpa_wipro_zones';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._init();
  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;

    return await initDatabase();
  }

  DatabaseHelper._init();

  /// ******* Basic Database *********

  // initialize database
  Future<Database> initDatabase() async {
    // create the database
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'fpa_db.db');

    // create/open an instance of the database
    return await openDatabase(path,
        version: 1, onCreate: _createDB, onConfigure: _onConfigure);
  }

  // configure foreign key
  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  // create the database tables
  void _createDB(Database db, int version) async {
    // Create Data table
    await db.execute('''
        CREATE TABLE $dataTable (
          datePicked TEXT, 
          plantName TEXT, 
          zoneName TEXT, 
          zoneLeader TEXT, 
          pathType TEXT, 
          imagePath TEXT
        )
  ''');

    // Create Users table
    await db.execute('''
        CREATE TABLE $userTable (
          username TEXT PRIMARY KEY NOT NULL,
          password TEXT NOT NULL,
          accType TEXT NOT NULL
        )
        ''');

    // Create default admin user
    final key = Key.fromUtf8("e16ce888a20dadb8");
    final iv = IV.fromUtf8("e16ce888a20dadb8");
    final encrypter = Encrypter(AES(key));
    final encryptedPassword = encrypter.encrypt("password", iv: iv);

    // insert default user into table
    await db.insert(
      userTable,
      {
        'username': 'admin',
        'password': encryptedPassword.base64,
        'accType': 'admin'
      },
    );

    // Creating table to store different Plants
    await db.execute('''
        CREATE TABLE $plantTable 
        (
            id INTEGER PRIMARY KEY,
            plantName TEXT NOT NULL
        )
      ''');

    // Creating Zones table
    await db.execute('''
        CREATE TABLE $zoneTable (
          id INTEGER PRIMARY KEY,
          zoneName TEXT NOT NULL,
          plantId INTEGER,
          FOREIGN KEY (plantId) REFERENCES $plantTable (id) ON DELETE CASCADE
        )
      ''');
  }

  // Close the database instance
  Future<void> closeDatabase() async {
    final db = await _instance.db;
    db.close();
  }

  /// ******* CRUD Data Table ********

  // Inserting data in the data table
  Future<void> insertData(
    String datePicked,
    String plantName,
    String zoneName,
    String zoneLeader,
    String pathType,
    String imagePath,
  ) async {
    final db = await _instance.db;
    await db.insert(dataTable, {
      'datePicked': datePicked,
      'plantName': plantName,
      'zoneName': zoneName,
      'zoneLeader': zoneLeader,
      'pathType': pathType,
      'imagePath': imagePath
    });
  }

  // Deleting 1 week old data
  Future<void> deleteData() async {
    final db = await _instance.db;
    await db.delete(dataTable,
        where:
            'strftime(\'%s\', date(substr(datepicked, 7) || \'-\' || substr(datepicked, 4, 2) || \'-\' || substr(datepicked, 1, 2))) < strftime(\'%s\', \'now\', \'-8 days\');');
  }

  // Get all records from data table
  Future<List<Map<String, dynamic>>?> getRecordsData() async {
    final db = await _instance.db;
    return await db.query(dataTable);
  }

  // Get records by date
  Future<List<Map<String, dynamic>>?> getRecordsDataByDate(String date) async {
    final db = await _instance.db;

    final dataGivenDate = await db.query(
      dataTable,
      where: 'datePicked = ?',
      whereArgs: [date],
    );

    return dataGivenDate;
  }

  // Count number of entries today
  Future<int> countEntriesToday(String date) async {
    final db = await _instance.db;
    int? count = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM $dataTable WHERE datePicked = \'$date\''));

    if (count == null) {
      return 0;
    } else {
      return count;
    }
  }

  /// ***** CRUD Plant Table *****

  // Inserting plant data
  Future<void> addNewPlant(Plant plant) async {
    final db = await _instance.db;
    await db.insert(plantTable, {
      'id': plant.id,
      'plantName': plant.plantName,
    });
  }

  // Getting plant data
  Future<List<Map<String, dynamic>>?> getPlants() async {
    final db = await _instance.db;
    return await db.query(plantTable, orderBy: 'plantName');
  }

  // Count number of plants
  Future<int> countPlants() async {
    final db = await _instance.db;
    int? count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $plantTable'));

    if (count == null) {
      return 0;
    } else {
      return count;
    }
  }

  // Deleting plant data (also zones along with it)
  Future<void> deletePlant(Plant plant) async {
    final db = await _instance.db;
    await db.delete(plantTable, where: 'id = ?', whereArgs: [plant.id]);
  }

  /// ***** CRUD Zone Table *****

  // Inserting Zone Data
  Future<void> addNewZone(Zone zone) async {
    final db = await _instance.db;
    await db.insert(zoneTable, {
      'id': zone.id,
      'zoneName': zone.zoneName,
      'plantId': zone.plantId,
    });
  }

  // Getting Zone Data
  Future<List<Map<String, dynamic>>?> getZones(Plant plant) async {
    final db = await _instance.db;
    return await db.query(
      zoneTable,
      where: 'plantId = ?',
      whereArgs: [plant.id],
      orderBy: 'zoneName',
    );
  }

  // Count number of zones
  Future<int> countZones() async {
    final db = await _instance.db;
    int? count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $zoneTable'));

    if (count == null) {
      return 0;
    } else {
      return count;
    }
  }

  // Deleting Zone Data
  Future<void> deleteZone(Zone zone) async {
    final db = await _instance.db;
    await db.delete(
      zoneTable,
      where: 'id = ?',
      whereArgs: [zone.id],
    );
  }

  /// ********* CRUD User Table **********

  // Inserting User Data
  Future<void> insertRecordUser(
      String username, String password, String accType) async {
    final db = await _instance.db;
    await db.insert(userTable, {
      'username': username,
      'password': password,
      'accType': accType,
    });
  }

  // Update Password of User
  Future<void> updateAccountPassword(String username, String password) async {
    final db = await _instance.db;
    await db.rawUpdate(
      'UPDATE $userTable SET password = ? WHERE username = ?',
      [password, username],
    );
  }

  // Count number of admins
  Future<int> countAdmins() async {
    final db = await _instance.db;
    int? count = Sqflite.firstIntValue(await db
        .rawQuery('SELECT COUNT(*) FROM $userTable WHERE accType = \'admin\''));

    if (count == null) {
      return 0;
    } else {
      return count;
    }
  }

  // Count number of users
  Future<int> countUsers() async {
    final db = await _instance.db;
    int? count = Sqflite.firstIntValue(await db
        .rawQuery('SELECT COUNT(*) FROM $userTable WHERE accType = \'user\''));

    if (count == null) {
      return 0;
    } else {
      return count;
    }
  }

  // Getting all the Users' Details
  Future<List<Map<String, dynamic>>?> getsUsersBasedOnAccountType(
      String accType) async {
    final db = await _instance.db;
    return await db.query(
      userTable,
      where: 'accType = ?',
      orderBy: 'username',
      whereArgs: [accType],
    );
  }

  // Getting single User's Details
  Future<List<Map<String, dynamic>>?> getRecordsSingleUser(
      String username) async {
    final db = await _instance.db;

    final singleUserDetails = await db.query(
      userTable,
      where: 'username = ?',
      whereArgs: [username],
    );

    return singleUserDetails;
  }

  // Deleting User's Details
  Future<void> deleteRecordUser(String username) async {
    final db = await _instance.db;
    await db.delete(userTable, where: 'username = ?', whereArgs: [username]);
  }
}
