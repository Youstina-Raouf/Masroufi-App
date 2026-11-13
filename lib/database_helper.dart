import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

import 'models/expense_item.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'expenses.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE expenses(
            id INTEGER PRIMARY KEY,
            title TEXT,
            price TEXT,
            date TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertExpense(ExpenseItem expense) async {
    final db = await database;
    return await db.insert(
      'expenses',
      {
        'id': expense.id,
        'title': expense.title,
        'price': expense.price.toString(),
        'date': expense.date.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ExpenseItem>> getExpenses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('expenses', orderBy: 'date DESC');

    return List.generate(maps.length, (i) {
      return ExpenseItem(
        id: maps[i]['id'],
        title: maps[i]['title'],
        price: maps[i]['price'] is double ? maps[i]['price'] : double.tryParse(maps[i]['price'].toString()) ?? 0.0,
        date: DateTime.parse(maps[i]['date']),
      );
    });
  }

  Future<int> deleteExpense(int id) async {
    final db = await database;
    return await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }
}