// ignore_for_file: depend_on_referenced_packages

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:streakit/models/habit.dart';

class HabitDatabaseHelper {
  static final HabitDatabaseHelper instance = HabitDatabaseHelper._init();
  static Database? _database;

  HabitDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('habits.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE habits (
      id $idType,
      name $textType,
      notes $textType,
      icon $intType,
      color $intType,
      completed_days $textType NOT NULL,
      order_index $intType NOT NULL DEFAULT 0 
    )
  ''');
  }

  Future<Habit> createHabit(Habit habit) async {
    final db = await instance.database;
    final id = await db.insert('habits', habit.toMap());
    return habit.copyWith(id: id);
  }

  Future<List<Habit>> readAllHabits() async {
    final db = await instance.database;
    final result = await db.query('habits', orderBy: 'order_index');
    return result.map((map) => Habit.fromMap(map)).toList();
  }

  Future<Habit?> readHabit(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'habits',
      columns: ['id', 'name', 'notes', 'icon', 'color', 'completed_days'],
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Habit.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> updateHabit(Habit habit) async {
    final db = await instance.database;
    return db.update(
      'habits',
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  Future<int> deleteHabit(int id) async {
    final db = await instance.database;
    return db.delete(
      'habits',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateHabitOrder(int id, int newOrderIndex) async {
    final db = await instance.database;
    await db.update(
      'habits',
      {'order_index': newOrderIndex},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
