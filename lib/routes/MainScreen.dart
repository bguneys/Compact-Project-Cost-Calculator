import 'package:bgsapp02082020/data/Project.dart';
import 'package:bgsapp02082020/data/ProjectRepository.dart';
import 'package:bgsapp02082020/routes/MainScreenViewModel.dart';
import 'package:flutter/material.dart';

import 'SettingsScreen.dart';

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

  /**
   * Custom method for FAB Click
   */
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

  /**
   * Custom method for handling clicks on AppBar OverFlow menu
   */
  void _handleClick(String value) {
    switch (value) {
      case 'Settings':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _handleClick,
            icon: Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) {
              return {'Settings'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
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
