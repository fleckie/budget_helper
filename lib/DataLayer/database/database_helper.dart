import 'dart:async';
import 'package:budget_helper/DataLayer/database/database_setup.dart';
import 'package:budget_helper/DataLayer/models/category.dart';
import 'package:budget_helper/DataLayer/models/item.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'database_constants.dart' as Constants;
import 'database_setup.dart' as Setup;

//TODO change hardcoded ids to constants
//TODO: create DAO classes and move methods for different models there
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
  Future<int> insert(String tableName, Map<String, dynamic> map) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.insert(tableName, map,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //method to retrieve the 2 subtypes of categories
  Future<List<Category>> getCategorySubtypeTable(String tableName) async {
    final Database db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> result = await db.query(tableName);
    return List.generate(result.length, (i) {
      return Category(result[i]['id'], result[i]['name'], tableName);
    });
  }

  Future<Category> getCategory(int id, String table) async {
    final Database db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> result = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
    return Category(result[0]['id'], result[0]['name'], result[0]['type']);
    ;
  }

  Future<void> delete(String table, int id) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Item>> getItemsInCategory(int categoryId, int startOfMonth, int endOfMonth) async {
    final Database db = await DatabaseHelper.instance.database;
    //TODO raw query including correct month
    final List<Map<String, dynamic>> result = await db.rawQuery(
        '''
      SELECT * from ${Constants.itemsTable}
      WHERE ${Constants.itemsCategoryId} == $categoryId 
      AND ${Constants.itemsDate} BETWEEN $startOfMonth AND $endOfMonth
       ''');
    return List.generate(result.length, (i) {
      return Item(
          id: result[i]['id'],
          name: result[i]['name'],
          categoryId: result[i]['categoryId'],
          value: result[i]['value'],
          date: DateTime.fromMillisecondsSinceEpoch(result[i]['date']));
    });
  }

  Future<List<Item>> getItems() async {
    final Database db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> result =
        await db.query(Constants.itemsTable);
    return List.generate(result.length, (i) {
      return Item(
        id: result[i][Constants.itemsId],
        name: result[i][Constants.itemsName],
        categoryId: result[i][Constants.itemsCategoryId],
        value: result[i][Constants.itemsValue],
      );
    });
  }

  Future<Map<int, double>> getAggregatedValueByCategory(
      int startOfMonth, int endOfMonth) async {
    final Database db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
        '''SELECT ${Constants.itemsCategoryId}, sum(${Constants.itemsValue})  
        as Summe FROM ${Constants.itemsTable} 
        WHERE ${Constants.itemsDate} BETWEEN $startOfMonth AND $endOfMonth
        GROUP BY ${Constants.itemsCategoryId} 
        ''');
    final Map<int, double> map = Map<int, double>();
    result.forEach((e) => {map[e[Constants.itemsCategoryId]] = e['Summe']});
    return map;
  }
}
