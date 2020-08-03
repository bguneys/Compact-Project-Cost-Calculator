import 'package:bgsapp02082020/data/Project.dart';
import 'package:bgsapp02082020/data/ProjectRepository.dart';
import 'package:sqflite/sqflite.dart';

class MainScreenViewModel {

  final ProjectRepository projectRepository;

  MainScreenViewModel(this.projectRepository);

  /// Custom method for inserting data into table
  Future<void> insertProject(Project project) async {
    projectRepository.insertProject(project);
  }

  /// Custom method for getting all Project list from database
  Future<List<Project>> getProjects() async {
    return projectRepository.getProjects();
  }

  /// Custom method for updating a Project inside Database table
  Future<void> updateProject(Project project) async {
    projectRepository.updateProject(project);
  }

}