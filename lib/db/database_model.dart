import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:todo_app/models/note_model.dart';

class DatabaseModel {
  static final _databasename = "noteapp";
  static final _databaseversion = 1;
  static final table = "note_table";
  static final columnId = "id";
  static final title = "title";
  static final content = "content";
  static Database? _database;

  DatabaseModel._privateConstructor();
  static final DatabaseModel instance = DatabaseModel._privateConstructor();

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDb();
    return _database;
  }

  initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databasename);
    var theDb = await openDatabase(path,
        version: _databaseversion, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
Create Table $table(
  $columnId INTEGER PRIMARY KEY,
  $title TEXT NOT NULL,
  $content TEXT NOT NULL
);
  ''');
    print("Created Table");
  }

  Future<int?> insertNote(NoteModel note) async {
    Database? db = await instance.database;
    return await db?.insert(table, note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int?> updateNote(NoteModel note, id) async {
    var db = await instance.database;
    return await db
        ?.update(table, note.toMap(), where: 'id = ?', whereArgs: [id]);
  }

  Future<int?> deleteNote(int id) async {
    Database? db = await instance.database;
    return await db?.delete(table, where: "id = ?", whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>?> queryAll() async {
    Database? db = await instance.database;
    return await db?.query(table);
  }
}
