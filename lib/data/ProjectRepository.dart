import 'package:bgsapp02082020/data/ProjectDatabase.dart';
import 'Project.dart';

class ProjectRepository {

  ProjectDatabase _projectDatabase;
  static ProjectRepository _projectRepository;

  //making repository instance singleton with a private constructor
  ProjectRepository._privateConstructor(){
    _projectDatabase = ProjectDatabase.projectDatabase;
  }

  static ProjectRepository getInstance() {

    if (_projectRepository == null) {
      _projectRepository = ProjectRepository._privateConstructor();
    }

    return _projectRepository;
  }

  /// Custom method for inserting data into table
  Future<void> insertProject(Project project) async {
    _projectDatabase.insertProject(project);
  }

  /// Custom method for deleting a Project from Database
  Future<void> deleteProject(Project project) async {
    _projectDatabase.deleteProject(project);
  }

  /// Custom method for getting all Project list from database
  Future<List<Project>> getProjects() async {
    return _projectDatabase.getProjects();
  }

  /// Custom method for getting Project with a certain id from database
  Future<List<Project>> getIProjectWithId(int selectedProjectId) async {
    return _projectDatabase.getProjectWithId(selectedProjectId);
  }

  /// Custom method for updating a Project inside Database table
  Future<void> updateProject(Project project) async {
    _projectDatabase.updateProject(project);
  }

}