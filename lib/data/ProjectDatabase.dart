import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Constants.dart';
import 'Item.dart';
import 'Project.dart';

class ProjectDatabase {

  //making database instance singleton with a private constructor
  ProjectDatabase._privateConstructor();
  static final ProjectDatabase projectDatabase = ProjectDatabase._privateConstructor();

  static Database _database;

  Future<Database> get databaseInstance async {
    if (_database != null) {
      return _database;

    } else {
      _database = await openDatabase(
        // Set the path to the database using the `join` function from the `path` package
        join(await getDatabasesPath(), Constants.databaseName),
        // When the database is created first time, create a table to store data.
        onCreate: (db, version) {
          // creating projects table
          db.execute(
            "CREATE TABLE ${Constants.databaseProjectTable} (${Constants.columnProjectId} INTEGER PRIMARY KEY AUTOINCREMENT, ${Constants.columnProjectTitle} TEXT, ${Constants.columnProjectDurationInDay} INTEGER, ${Constants.columnProjectCost} REAL, ${Constants.columnProjectHourlyCost} REAL, ${Constants.columnProjectNote} TEXT, ${Constants.columnProjectCurrency} TEXT)"
          );

          // creating items table with foreign key
          db.execute(
            "CREATE TABLE ${Constants.databaseItemTable} (${Constants.columnItemId} INTEGER PRIMARY KEY AUTOINCREMENT, ${Constants.columnItemTitle} TEXT, ${Constants.columnItemDurationInDay} INTEGER, ${Constants.columnItemCost} REAL, ${Constants.columnItemHourlyCost} REAL, ${Constants.columnItemUnitCost} REAL, ${Constants.columnItemOnetimeCost} REAL, ${Constants.columnItemUnits} INTEGER, ${Constants.columnItemWorkHoursInADay} REAL, ${Constants.columnItemCostType} INTEGER, ${Constants.columnItemProjectId} INTEGER, FOREIGN KEY(${Constants.columnItemProjectId}) REFERENCES ${Constants.databaseProjectTable}(${Constants.columnProjectId}))"
          );
        },
        onConfigure: _onConfigure,
        version: Constants.databaseVersion,
      );
      return _database;
    }
  }

  /**
   *  Custom method to enable Foregin Key property in database
   */
  static Future _onConfigure(Database db) async {
    await db.execute("PRAGMA foreign_keys = ON");
  }

  /// Custom method for inserting a Project into table
  Future<void> insertProject(Project project) async {
    final Database db = await projectDatabase.databaseInstance;

    await db.insert(
      Constants.databaseProjectTable,
      project.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Custom method for getting all Project list from database
  Future<List<Project>> getProjects() async {
    final Database db = await projectDatabase.databaseInstance;

    final List<Map<String, dynamic>> maps = await db.query(Constants.databaseProjectTable);

    // Convert the List<Map<String, dynamic> into a List<Project>.
    return List.generate(maps.length, (i) {
      return Project(
        id: maps[i][Constants.columnProjectId],
        title: maps[i][Constants.columnProjectTitle],
        durationInDay: maps[i][Constants.columnProjectDurationInDay],
        cost: maps[i][Constants.columnProjectCost],
        hourlyCost: maps[i][Constants.columnProjectHourlyCost],
        note: maps[i][Constants.columnProjectNote],
        currency: maps[i][Constants.columnProjectCurrency],
      );
    });
  }

  /// Custom method for getting all Items assigned to a Project from database
  Future<List<Item>> getItemsWithProjectId(int itemProjectId) async {

    final Database db = await projectDatabase.databaseInstance;

    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM ${Constants.databaseItemTable} WHERE ${Constants.columnItemProjectId} = ?', [itemProjectId]);

    // Convert the List<Map<String, dynamic> into a List<Item.
    return List.generate(maps.length, (i) {
      return Item(
        id: maps[i][Constants.columnItemId],
        title: maps[i][Constants.columnItemTitle],
        durationInDay: maps[i][Constants.columnItemDurationInDay],
        cost: maps[i][Constants.columnItemCost],
        hourlyCost: maps[i][Constants.columnItemHourlyCost],
        unitCost: maps[i][Constants.columnItemUnitCost],
        onetimeCost: maps[i][Constants.columnItemOnetimeCost],
        units: maps[i][Constants.columnItemUnits],
        workHoursInADay: maps[i][Constants.columnItemWorkHoursInADay],
        costType: maps[i][Constants.columnItemCostType],
        projectId: maps[i][Constants.columnItemProjectId],
      );
    });
  }

  /// Custom method for updating a Project inside Database table
  Future<void> updateProject(Project project) async {
    final db = await projectDatabase.databaseInstance;

    await db.update(
      Constants.databaseProjectTable,
      project.toMap(),
      where: "${Constants.columnProjectId} = ?",
      whereArgs: [project.id],
    );
  }

  /// Custom method for deleting a Project from Database table
  Future<void> deleteProject(Project project) async {
    final db = await projectDatabase.databaseInstance;

    await db.delete(
      Constants.databaseProjectTable,
      where: "${Constants.columnProjectId} = ?",
      whereArgs: [project.id],
    );
  }

  /// Custom method for inserting item into database
  Future<void> insertItem(Item item) async {
    final Database db = await projectDatabase.databaseInstance;

    await db.insert(
      Constants.databaseItemTable,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Custom method for deleting a Project from Database table
  Future<void> deleteItem(Item item) async {
    final db = await projectDatabase.databaseInstance;

    await db.delete(
      Constants.databaseItemTable,
      where: "${Constants.columnItemId} = ?",
      whereArgs: [item.id],
    );
  }

  /// Custom method for getting project with a certain id from database
  Future<List<Project>> getProjectWithId(int selectedProjectId) async {

    final Database db = await projectDatabase.databaseInstance;

    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM ${Constants.databaseProjectTable} WHERE ${Constants.columnProjectId} = ?', [selectedProjectId]);

    //final Project selectedProject = maps[0][0];

    // Convert the List<Map<String, dynamic> into a List<Item.
    return List.generate(maps.length, (i) {
      return Project(
        id: maps[i][Constants.columnProjectId],
        title: maps[i][Constants.columnProjectTitle],
        durationInDay: maps[i][Constants.columnProjectDurationInDay],
        cost: maps[i][Constants.columnProjectCost],
        hourlyCost: maps[i][Constants.columnProjectHourlyCost],
        note: maps[i][Constants.columnProjectNote],
        currency: maps[i][Constants.columnProjectCurrency],
      );
    });
  }

  /// Custom method for updating an Item inside Database table
  Future<void> updateItem(Item item) async {
    final db = await projectDatabase.databaseInstance;

    await db.update(
      Constants.databaseItemTable,
      item.toMap(),
      where: "${Constants.columnItemId} = ?",
      whereArgs: [item.id],
    );
  }

}
