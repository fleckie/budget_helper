import 'dart:async';
import 'package:budget_helper/DataLayer/models/category.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'database_constants.dart' as Constants;
import 'database_setup.dart' as Setup;

//TODO: initialize database only once
class DatabaseHelper {
  //*named, private Constructor (indicated by the underscore). No public constructor
  DatabaseHelper._privateConstructor();

  //static instance of the class
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  //static database with getter
  static Database _database;

  Future<Database> get database async {
    return _database != null ? _database : _database = await _initDatabase();
  }

  // Opens Database and executes onCreate, if it wast already created
  _initDatabase() async {
    String path = join(await getDatabasesPath(), Constants.databaseName);
    //for debugging:
    Sqflite.setDebugModeOn(false);
    return await openDatabase(path,
        version: Constants.databaseVersion,
        onCreate: _onCreate,
        onOpen: _onOpen);
  }

// Creating database tables
  Future _onCreate(Database db, int version) async {
    var batch = db.batch();
    Setup.commands.forEach((command) {
      db.execute(command);
    });
    await batch.commit();
  }

  Future _onOpen(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  // General insert method
  //return value int is the id that is used to create Subtypes of categories
  Future<int> insert(String tableName, Map<String, dynamic> map) async {
    return await _database.insert(tableName, map,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //method to retrieve the 2 subtypes of categories
  //TODO: move List generation to DAO
  Future<List<Category>> getCategorySubtypeTable(String tableName) async {
    final Database db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> result = await db.query(tableName, orderBy: Constants.expensesName);
    return List.generate(result.length, (i) {
      return Category(result[i]['id'], result[i]['name'], tableName, result[i]['color']);
    });
  }

  Future<void> delete(String table, int id) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String,dynamic>>> getItemsInMonthByCategory(int categoryId, int startOfMonth, int endOfMonth) async {
    return await _database.rawQuery(
        '''
      SELECT * from ${Constants.itemsTable}
      WHERE ${Constants.itemsCategoryId} == $categoryId 
      AND ${Constants.itemsDate} BETWEEN $startOfMonth AND $endOfMonth
      ORDER BY ${Constants.itemsDate}
       ''');
  }

  Future<List<Map<String,dynamic>>> getNetTotalAtSpecificDate(int endOfMonth) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.rawQuery(
      '''SELECT ${Constants.itemsType}, sum(${Constants.itemsValue})
      as sum FROM ${Constants.itemsTable}
      WHERE ${Constants.itemsDate} < $endOfMonth
      GROUP BY ${Constants.itemsType}
      ''');
  }

  Future<List<Map<String,dynamic>>> getNetTotalForSpecificMonth(int startOfMonth, int endOfMonth) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.rawQuery(
        '''SELECT ${Constants.itemsType}, sum(${Constants.itemsValue})
      as sum FROM ${Constants.itemsTable}
      WHERE ${Constants.itemsDate} BETWEEN $startOfMonth AND $endOfMonth
      GROUP BY ${Constants.itemsType}
      ''');
  }

  Future<List<Map<String, dynamic>>> getAggregatedValueByCategory(
      int startOfMonth, int endOfMonth) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.rawQuery(
        '''SELECT ${Constants.itemsCategoryId}, sum(${Constants.itemsValue})  
        as sum FROM ${Constants.itemsTable} 
        WHERE ${Constants.itemsDate} BETWEEN $startOfMonth AND $endOfMonth
        GROUP BY ${Constants.itemsCategoryId} 
        ''');
  }

/*
  Future<Category> getCategory(int id, String table) async {
    final Database db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> result = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
    return Category(result[0]['id'], result[0]['name'], result[0]['type']);
  }
   */
}
