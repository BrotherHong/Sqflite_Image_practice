import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'model/photo.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  static const String TABLE_NAME = "IMAGE";

  Future<Database> get database async {
    return _database ??= await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'image.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $TABLE_NAME(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      data TEXT
    )
    ''');
  }

  Future<int> insertPhoto(Photo photo) async {
    Database db = await database;
    return await db.insert(TABLE_NAME, photo.toMap());
  }

  Future<int> updatePhoto(Photo photo) async {
    Database db = await database;
    return await db.update(
      TABLE_NAME,
      photo.toMap(),
      where: "id = ?",
      whereArgs: [photo.id],
    );
  }

  Future<int> deletePhoto(Photo photo) async {
    Database db = await database;
    return await db.delete(
      TABLE_NAME,
      where: "id = ?",
      whereArgs: [photo.id],
    );
  }

  Future<List<Photo>> getPhotos() async {
    Database db = await database;
    var data = await db.query(TABLE_NAME);

    List<Photo> photos =
        data.isNotEmpty ? data.map((e) => Photo.fromMap(e)).toList() : [];

    return photos;
  }
}
