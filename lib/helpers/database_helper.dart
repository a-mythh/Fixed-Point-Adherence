import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:encrypt/encrypt.dart';

const String dataTable = 'fpa_wipro_data';
const String userTable = 'fpa_wipro_users';
const String plantTable = 'fpa_wipro_plants';
const String zoneTable = 'fpa_wipro_zones';

class DatabaseHelper 
{
  static final DatabaseHelper _instance = DatabaseHelper._init();
  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database> get db async 
  {
    if (_db != null) return _db!;

    return await initDatabase();
  }

  DatabaseHelper._init();

  /// ******* Basic Database *********

  // initialize database
  Future<Database> initDatabase() async 
  {
    // create the database
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'fpa_db.db');

    // create/open an instance of the database
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // create the database tables
  void _createDB(Database db, int version) async 
  {
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
    await db.insert(userTable, 
      {
        'username': 'admin',
        'password': encryptedPassword.base64,
        'accType': 'admin'
      },
    );

    // Creating table to store different Plants
    await db.execute(
      '''
        CREATE TABLE $plantTable 
        (
            plantName TEXT PRIMARY KEY NOT NULL
        )
      '''
    );

    // Creating Zones table
    await db.execute(
      '''
        CREATE TABLE $zoneTable (
          zoneName TEXT PRIMARY KEY, 
          plantName TEXT, 
          zoneLeader TEXT, 
          FOREIGN KEY(plantName) REFERENCES fpa_wipro_plants(plantName)
        )
      ''');
  }

  // Close the database instance
  Future<void> closeDatabase() async 
  {
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
    ) 
  async 
  {
    final db = await _instance.db;
    await db.insert(dataTable, 
      {
        'datePicked': datePicked,
        'plantName': plantName,
        'zoneName': zoneName,
        'zoneLeader': zoneLeader,
        'pathType': pathType,
        'imagePath': imagePath
      }
    );
  }

  // Get all records from data table
  Future<List<Map<String, dynamic>>?> getRecordsData() async 
  {
    final db = await _instance.db;
    return await db.query(dataTable);
  }





  /// ***** CRUD Plant Table *****

  // Inserting plant data
  Future<void> insertRecordPlants(String plantName) async 
  {
    final db = await _instance.db;
    await db.insert(plantTable, {'plantName': plantName});
  }

  // Getting plant data
  Future<List<Map<String, dynamic>>?> getRecordsPlants() async 
  {
    final db = await _instance.db;
    return await db.query(plantTable);
  }

  // Deleting plant data (also zones along with it)
  Future<void> deleteRecordPlants(String plantName) async 
  {
    final db = await _instance.db;
    await db.delete(plantTable, where: 'plantName = ?', whereArgs: [plantName]);
    await db.delete(zoneTable, where: 'plantName = ?', whereArgs: [plantName]);
  }





  /// ***** CRUD Zone Table *****

  // Inserting Zone Data
  Future<void> insertRecordZones(String zoneName, String zoneLeader, String plantName) async 
  {
    final db = await _instance.db;
    await db.insert(zoneTable, 
      {
        'zoneName': zoneName,
        'plantName': plantName,
        'zoneLeader': zoneLeader
      }
    );
  }

  // Getting Zone Data
  Future<List<Map<String, dynamic>>?> getRecordsZones() async 
  {
    final db = await _instance.db;
    return await db.query(zoneTable);
  }

  // Getting Zone Data of specific Plant
  Future<List<Map<String, dynamic>>?> getRecordsZonesWrtPlant(String plantName) async 
  {
    final db = await _instance.db;
    return await db.query(zoneTable, where: 'plantName = ?', whereArgs: [plantName]);
  }

  // Deleting Zone Data
  Future<void> deleteRecordZones (String zoneName) async 
  {
    final db = await _instance.db;
    await db.delete('fpa_wipro_zones', where: 'zoneName = ?', whereArgs: [zoneName]);
  }




  /// ********* CRUD User Table **********

  // Inserting User Data
  Future<void> insertRecordUser(String username, String password, String accType) async 
  {
    final db = await _instance.db;
    await db.insert(userTable,
        {
          'username': username, 
          'password': password, 
          'accType': accType
        }
      );
  }

  // Update Password of User
  Future<void> updateRecordUserPassword(String username, String password) async 
  {
    final db = await _instance.db;
    await db.rawUpdate(
        'UPDATE $userTable SET password = ? WHERE username = ?',
        [password, username],
    );
  }

  // Getting all the Users' Details
  Future<List<Map<String, dynamic>>?> getRecordsUser() async 
  {
    final db = await _instance.db;
    return await db.query(userTable);
  }

  // Getting single User's Details
  Future<List<Map<String, dynamic>>?> getRecordsSingleUser(String username) async 
  {
    final db = await _instance.db;

    final singleUserDetails = await db.query(
        userTable, 
        where: 'username = ?', 
        whereArgs: [username],
      );

    return singleUserDetails;
  }

  // Deleting User's Details
  Future<void> deleteRecordUser(String username) async 
  {
    final db = await _instance.db;
    await db.delete(userTable, where: 'username = ?', whereArgs: [username]);
  }
}
