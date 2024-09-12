import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelperClass {
  static final dbName = "5StarDB";

  static final TBLGod = "TBLGod";
  static final GodId = "GodId";
  static final GodName = "GodName";
  static final GodGender = "GodGender";

  static final TBLFrame = "TBLFrame";
  static final FrameId = "FrameId";
  static final FramePName = "FramePetName";
  static final FrameAName = "FrameActualName";
  static final FrameUnitPrice = "FrameUnitPrice";
  static final FrameSize = "FrameSize";
  static final FrameTotalStock = "FrameTotalStock";
  static final FrameColor = "FrameColor";

  static final TBLLock = "TBLLock";
  static final LockId = "LockId";
  static final LockName = "LockName";
  static final LockUnitPrice = "LockUnitPrice";
  static final LockMM = "LockMM";
  static final LockTotalStock = "TotalStock";

  static final TBLMirror = "TBLMirror";
  static final MirrorId = "MirrorId";
  static final MirrorDesc = "Description";
  static final MirrorSize = "Measurement";
  static final MirrorUnitPrice = "UnitPrice";
  static final MirrorTotalStock = "TotalStock";

  static final TBLPhotos = "TBLPhotos";
  static final PhotoId = "PhotoId";
  static final PhotoGodId = "GodId";
  static final PhotoSize = "PhotoSize";
  static final PhotoTotalStock = "PhotoTotalStock";
  static final PhotoUnitPrice = "PhotoUnitPrice";

  static final Query = '''
      INSERT INTO $TBLGod ($GodName, $GodGender) VALUES
      ('Shiv_Parvati', 'Male'),('Ram_Sita', 'Male'),('Hanuman', 'Male'),('Ganesh', 'Male'),('Krishna', 'Male'),
      ('Vishnu', 'Male'),('Sai baba', 'Male'),('Brahma', 'Male'),('Saraswati', 'Female'),('Lakshmi', 'Female'),
      ('Mahakali', 'Female'),('Ambe', 'Female'),('Gayatri', 'Female'),('Dasha maa', 'Female'),('Chamunda maa', 'Female'),
      ('Vahanvati', 'Female'),('Meldi maa', 'Female'),('Aashapura', 'Female'),('Sarv Mangla', 'Female'),('Khiodiyar', 'Female'),
      ('Durga', 'Female');
    ''';

  static final DBHelperClass instance = DBHelperClass._init();
  static Database? _database;

  DBHelperClass._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'FiveStarPhotoFrame');
    return openDatabase(path, version: 2, onCreate: _onCreate,onUpgrade: _upgradeDB); //Version will be 1 here
  }

  Future _onCreate(var db, int version) async {
    await db.execute('''
    CREATE TABLE $TBLGod (
      $GodId INTEGER PRIMARY KEY AUTOINCREMENT,
      $GodName TEXT,
      $GodGender TEXT
    )
  ''');

    await db.execute('''
    CREATE TABLE $TBLFrame (
      $FrameId INTEGER PRIMARY KEY AUTOINCREMENT,
      $FramePName TEXT,
      $FrameAName TEXT,
      $FrameUnitPrice INTEGER,
      $FrameSize TEXT,
      $FrameTotalStock INTEGER,
      $FrameColor TEXT
    )
  ''');

    await db.execute('''
    CREATE TABLE $TBLLock (
      $LockId INTEGER PRIMARY KEY AUTOINCREMENT,
      $LockName TEXT,
      $LockUnitPrice INTEGER,
      $LockMM INTEGER,
      $LockTotalStock INTEGER
    )
  ''');

    await db.execute('''
    CREATE TABLE $TBLMirror (
      $MirrorId INTEGER PRIMARY KEY AUTOINCREMENT,
      $MirrorDesc TEXT,
      $MirrorSize TEXT,
      $MirrorUnitPrice INTEGER,
      $MirrorTotalStock INTEGER
    )
  ''');

    await db.execute('''
    CREATE TABLE $TBLPhotos (
      $PhotoId INTEGER PRIMARY KEY AUTOINCREMENT,
      $PhotoGodId INTEGER REFERENCES $TBLGod($GodId),
      $PhotoSize TEXT,
      $PhotoUnitPrice INTEGER,
      $PhotoTotalStock INTEGER
    )
  ''');
    await db.execute(Query);
  }

  ///things to remove
  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(Query);
    }
    // Add more migrations as needed
  }

  /// remove upto this

  Future<int> insertRecord(String table, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // Update a record in any table
  Future<int> updateRecord(
      String table, Map<String, dynamic> row, String columnId, int id) async {
    Database db = await instance.database;
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Delete a record from any table
  Future<int> deleteRecord(String table, String columnId, int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  // Retrieve all records from any table
  Future<List<Map<String, dynamic>>> getAllRecords(String table) async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // Get a specific record by ID
  Future<Map<String, dynamic>?> getRecordById(
      String table, String columnId, int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results =
        await db.query(table, where: '$columnId = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  Future<int> getPhotoCountBySize(String size) async {
    Database db = await instance.database;
    var result = await db.rawQuery(
      'SELECT SUM($PhotoTotalStock) as total FROM $TBLPhotos WHERE $PhotoSize = ?',
      [size],
    );

    // Safely handle possible null value for 'total'
    int totalCount = result.isNotEmpty && result.first['total'] != null
        ? result.first['total'] as int
        : 0;

    return totalCount;
  }

}
