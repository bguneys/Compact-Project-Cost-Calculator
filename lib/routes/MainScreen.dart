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

  // global key to be used for reaching Scaffold widget to show Snackbar
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  //Project list variable to store Projects from database and show them oin ListView
  List<Project> projectList = new List();

  // create ProjectDatabase through creating ProjectRepository instance
  static final projectRepository = ProjectRepository.getInstance();

  // create ViewModel for database operations
  final mainScreenViewModel = MainScreenViewModel(projectRepository);

  //TextController for controlling text entered in TextFormField for project title
  TextEditingController textController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    populateProjectList();  //Custom method for populating projectList variable from database.
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.green[800],

      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.green[800],
        elevation: 0.0,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _handleAppBarClick,
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
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 4.0, 10.0, 2.0),
                  child: Card(
                    elevation: 2.0,
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        mainScreenViewModel.navigateToProjectDetailsScreen(context, projectList[index]);
                        print('Card tapped.');
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          ListTile(
                            title: Text(projectList[index].title),
                            leading: Text(projectList[index].id.toString()),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),

            //Buttom bar view
            Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 16.0, 8.0, 16.0),
                child: Row(
                  children: <Widget>[

                    // TextFormField
                    Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.green
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(45)),
                            ),
                            hintText: "Type new project title..",
                            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
                          ),
                          controller: textController,
                        )),

                    // FAB
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 8.0, 0.0),
                      child: Container(
                        child: FloatingActionButton(
                          backgroundColor: Colors.amberAccent,
                          foregroundColor: Colors.green[800],
                          onPressed: _addProject,
                          tooltip: 'Add Project',
                          child: Icon(Icons.add),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
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

    // get text entered in TextFormField and assign that as project title
    String projectTitle = textController.text;

    // check if TextFormField is empty. If yes then give a warning message.
    if (!projectTitle.isEmpty && !projectTitle.trim().isEmpty ) {

      var sampleProject = Project(title: projectTitle);

      // if a Project with same name exists in database then give a warning message
      // await keyword is used here to make flow to wait for this block execution
      await projectList.forEach((element) {
        if (sampleProject.title == element.title) {
          var snackBar = SnackBar(content: Text('Project with same title exists'));
          _scaffoldKey.currentState.showSnackBar(snackBar);
          isProjectNameSame = true; // make boolean true if there is a project with same name
        }
      });

      // if there is no Project wth same name then add Project to the Database and update UI
      if (!isProjectNameSame) {
        // insert a project into the database.
        await mainScreenViewModel.insertProject(sampleProject);

        setState(() {
          // We update UI by adding the Project to the list inside setState() method.
          projectList.add(sampleProject);
        });
      }

    } else {
        var snackBar = SnackBar(content: Text('Project title can\'t be empty'));
        _scaffoldKey.currentState.showSnackBar(snackBar);
        print("Project title can\'t be empty");
    }

  }

  /**
   * Custom method for handling clicks on AppBar OverFlow menu
   */
  void _handleAppBarClick(String value) {
    mainScreenViewModel.handleAppBarClick(value, context);
  }

}
