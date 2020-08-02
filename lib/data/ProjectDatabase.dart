import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Project.dart';

class ProjectDatabase {

  /**
   * Custom method for creating database and table
   */
  Future<Database> getDatabaseInstance() async {
    WidgetsFlutterBinding.ensureInitialized();
    final database = openDatabase(
      // Set the path to the database using the `join` function from the
      // `path` package
      join(await getDatabasesPath(), 'project_database.db'),
      // When the database is first created, create a table to store data.
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE projects(id INTEGER PRIMARY KEY, title TEXT, durationInDay INTEGER, cost REAL, hourlyCost REAL)",
        );
      },
      version: 1,
    );

    return database;
  }

  /**
   * Custom method for inserting data into table
   */
  Future<void> insertProject(Project project, Future<Database> database) async {
    // Get a reference to the database.
    final Database db = await database;

    // Insert the Project into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same project is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      'projects', //table name
      project.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /**
  * Custom method for getting all Project list from database
  */
  Future<List<Project>> getProjects(Future<Database> database) async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('projects');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
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

  /**
   * Custom method for updating a Project inside Database table
   */
  Future<void> updateProject(Project project, Future<Database> database) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Dog.
    await db.update(
      'projects',
      project.toMap(),
      // Ensure that the Dog has a matching id.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [project.id],
    );
  }

  /**
   * Custom method for deleting a Project from Database table
   */
  Future<void> deleteProject(Project project, Future<Database> database) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'projects',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [project.id],
    );
  }



}
