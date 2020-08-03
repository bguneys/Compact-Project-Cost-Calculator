import 'package:bgsapp02082020/data/Project.dart';
import 'package:bgsapp02082020/data/ProjectDatabase.dart';
import 'package:bgsapp02082020/data/ProjectRepository.dart';
import 'package:bgsapp02082020/routes/MainScreenViewModel.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _projectTitle = "None";

  // create ProjectDatabase through creating ProjectRepository instance
  static final projectRepository = ProjectRepository.getInstance();

  // create ViewModel for database operations
  final mainScreenViewModel = MainScreenViewModel(projectRepository);

  // Custom method for FAB click
  void _addProject() async {

    // create dummy project
    var sampleProject = Project(
        id: 0,
        title: "Test Project",
        durationInDay: 35,
        cost: 10.0,
        hourlyCost: 2.0);

    // insert a project into the database.
    await mainScreenViewModel.insertProject(sampleProject);

    // call to re-build widgets with a Text widget showing sample project title
    setState(() {
      _projectTitle = sampleProject.title;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_projectTitle',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _addProject,
        tooltip: 'Add Project',
        child: Icon(Icons.add),
      ),
    );
  }
}
