import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/contact.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('contacts.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const dateTimeType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE contacts ( 
      id $idType, 
      name $textType,
      phone $textType,
      createdTime $dateTimeType
    )
    ''');
  }

  Future<int> create(Contact contact) async {
    final db = await instance.database;
    return await db.insert('contacts', contact.toMap());
  }

  Future<Contact> readContact(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      'contacts',
      columns: ['id', 'name', 'phone', 'createdTime'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Contact.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Contact>> readAllContacts() async {
    final db = await instance.database;

    final orderBy = 'createdTime DESC';
    final result = await db.query('contacts', orderBy: orderBy);

    return result.map((json) => Contact.fromMap(json)).toList();
  }

  Future<int> update(Contact contact) async {
    final db = await instance.database;

    return db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
