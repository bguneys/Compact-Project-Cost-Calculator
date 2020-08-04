import 'package:bgsapp02082020/data/Constants.dart';
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

  List<Project> projectList = new List();

  // create ProjectDatabase through creating ProjectRepository instance
  static final projectRepository = ProjectRepository.getInstance();

  // create ViewModel for database operations
  final mainScreenViewModel = MainScreenViewModel(projectRepository);

  @override
  void initState() {
    super.initState();

    populateProjectList();  //Custom method for populating projectList variable from database.
  }

  /**
   * Custom method for populating projectList variable from database.
   */
  void populateProjectList() {
    mainScreenViewModel.getProjects().then((value) {
      setState(() {
        value.forEach((element) {
          projectList.add(Project(
              id: element.id,
              title: element.title,
              durationInDay: element.durationInDay,
              cost: element.cost,
              hourlyCost: element.hourlyCost));
        });
      });

    }).catchError((error) {
      print(error);
    });
  }

  /**
   * Custom method for FAB Click
   */
  void _addProject() async {

    // Boolean to check if a Project with same name exists in database
    bool isProjectNameSame = false;

    // create dummy project
    var sampleProject = Project(
        title: "Delay 300",
        durationInDay: 35,
        cost: 10.0,
        hourlyCost: 2.0);

    // if a Project with same name exists in database then give a warning message
    // await keyword is used here to make flow to wait for this block execution
    await projectList.forEach((element) {
      if (sampleProject.title == element.title) {
        print("Project with same title can't be added.");
        isProjectNameSame = true;
      }
    });

    // if there is no Project wth same name then add Project to the Database and update UI
    if (!isProjectNameSame) {
      // insert a project into the database.
      await mainScreenViewModel.insertProject(sampleProject);

      setState(() {
        // We update UI by adding the Project to the list inside setState() method.
        // We use "0" here for id because id is autoincremented by database
        projectList.add(sampleProject);
      });
    }
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

      body: Container(

        //ListView to show project list
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView.builder(itemBuilder: (context, index) {
                if (index == projectList.length) {
                  return null;
                }
                return ListTile(
                  title: Text(projectList[index].title),
                  leading: Text(projectList[index].id.toString()),
                );
              }),
            ),

            //Buttom bar view
            Container(
                height: 100.0,
                width: double.infinity,
                color: Colors.amberAccent,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text("Cuphead")),
                      Expanded(
                          child: Text("Mugman")),
                    ],
                  ),
                ),
            )
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
