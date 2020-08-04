import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Constants.dart';
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
          return db.execute(
            "CREATE TABLE ${Constants.databaseTable} (${Constants.columnId} INTEGER PRIMARY KEY AUTOINCREMENT, ${Constants.columnTitle} TEXT, ${Constants.columnDurationInDay} INTEGER, ${Constants.columnCost} REAL, ${Constants.columnHourly} REAL)",
          );
        },
        version: Constants.databaseVersion,
      );
      return _database;
    }
  }

  /// Custom method for inserting data into table
  Future<void> insertProject(Project project) async {
    final Database db = await projectDatabase.databaseInstance;

    await db.insert(
      Constants.databaseTable,
      project.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Custom method for getting all Project list from database
  Future<List<Project>> getProjects() async {
    final Database db = await projectDatabase.databaseInstance;

    final List<Map<String, dynamic>> maps = await db.query(Constants.databaseTable);

    // Convert the List<Map<String, dynamic> into a List<Project>.
    return List.generate(maps.length, (i) {
      return Project(
        id: maps[i]['id'],
        title: maps[i]['title'],
        durationInDay: maps[i]['durationInDay'],
        cost: maps[i]['cost'],
        hourlyCost: maps[i]['hourlyCost'],
      );
    });
  }

  /// Custom method for updating a Project inside Database table
  Future<void> updateProject(Project project) async {
    final db = await projectDatabase.databaseInstance;

    await db.update(
      Constants.databaseTable,
      project.toMap(),
      where: "id = ?",
      whereArgs: [project.id],
    );

  }

  /// Custom method for deleting a Project from Database table
  Future<void> deleteProject(Project project) async {
    final db = await projectDatabase.databaseInstance;

    await db.delete(
      Constants.databaseTable,
      where: "id = ?",
      whereArgs: [project.id],
    );

  }
}
