import 'package:bgsapp02082020/data/Project.dart';
import 'package:bgsapp02082020/data/ProjectDatabase.dart';
import 'package:sqflite/sqflite.dart';

class MainScreenViewModel {

  ProjectDatabase projectDatabase;
  Future<Database> database;

  void createDatabase() {
    projectDatabase = ProjectDatabase();
    database = projectDatabase.getDatabaseInstance();
  }

  Future<void> insertProject(Project project) async {
    projectDatabase.insertProject(project, database);
  }

}