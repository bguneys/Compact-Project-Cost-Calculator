import 'dart:io';
import 'package:bgsapp02082020/data/Constants.dart';
import 'package:bgsapp02082020/data/Project.dart';
import 'package:bgsapp02082020/data/ProjectRepository.dart';
import 'package:bgsapp02082020/routes/MainScreenViewModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  Project longTappedProject; //long tapped Project to be deleted

  FocusNode _focusNode = new FocusNode(); // used to hide soft keyboard

  var numberFormat; //2 decimals and thousand separator format for currencies

  @override
  void initState() {
    super.initState();

    // find device local and declare NumberFormat using it
    findSystemLocale().then((locale) {
      print(locale);
      numberFormat = NumberFormat.currency(locale: locale, name: "");
    });

    populateProjectList(); // custom method for populating project list
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
      backgroundColor: Theme.of(context).backgroundColor,

      appBar: AppBar(
        title: Text("PROJECTS", style: Theme.of(context).textTheme.headline6),
        backgroundColor: Theme.of(context).backgroundColor,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            //ListView to show project list
            Expanded(
              child: ListView.builder(
                itemCount: projectList.length,
                itemBuilder: (context, index) {
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
                          mainScreenViewModel.navigateToProjectDetailsScreen(context, projectList[index].id, projectList[index].title);
                        },
                        onLongPress: () {
                          longTappedProject = projectList[index];  //Project to be used in _showDialog() method
                          _showDialog(); // custom method for showing AlertDialog
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            ListTile(
                              title: Text(projectList[index].title, style: Theme.of(context).textTheme.subtitle1),
                              trailing: Text("Duration: ${projectList[index].durationInDay.toString()} days\n"
                                  "Cost: ${numberFormat.format(projectList[index].cost).toString()} ${projectList[index].currency}",
                                  style: Theme.of(context).textTheme.headline5,
                                  textAlign: TextAlign.end),
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
                        child: Theme(
                          data: ThemeData(primaryColor: Color(0xFFFAFAFA), hintColor: Color.fromARGB(100, 255, 255, 255)),
                          child: TextFormField(
                            style: Theme.of(context).textTheme.bodyText2,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).cardColor
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(45)),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).cardColor
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(45)),
                              ),
                              hintText: "Type new project title..",
                              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
                            ),
                            controller: textController,
                            focusNode: _focusNode, // used to hide soft keyboard
                          ),
                        )),

                    // FAB
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 8.0, 0.0),
                      child: Container(
                        child: FloatingActionButton(
                          backgroundColor: Color(0xFFFFc640),
                          foregroundColor: Theme.of(context).backgroundColor,
                          onPressed: _addProject,
                          tooltip: 'Add Project',
                          child: Icon(Icons.add, size: 32.0),

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
    projectList.clear();

    mainScreenViewModel.getProjects().then((value) {
      setState(() {
        value.forEach((element) {
          projectList.add(Project(
              id: element.id,
              title: element.title,
              durationInDay: element.durationInDay,
              cost: element.cost,
              hourlyCost: element.hourlyCost,
              note: element.note,
              currency: element.currency));
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

      // create a new Project with title and initial note and currency values
      var sampleProject = Project(title: projectTitle,
                                  cost: 0.0,
                                  durationInDay: 0,
                                  hourlyCost: 0.0,
                                  note: "",
                                  currency: "USD");

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
        populateProjectList();

        // make TextFormField empty after adding Project
        textController.text = "";

        _focusNode.unfocus(); // used to hide soft keyboard
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

  /**
   * Custom method for deleting an item from the list
   */
  void _deleteProject(Project project) async {
    await mainScreenViewModel.deleteProject(project);
  }

  /**
   * Custom method for showing AlertDialog
   */
  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button to close dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Project?', style: Theme.of(context).textTheme.bodyText1),
          actions: <Widget>[
            FlatButton(
              child: Text('YES', style: Theme.of(context).textTheme.subtitle1),
              onPressed: () {
                _deleteProject(longTappedProject);
                populateProjectList();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('NO', style: Theme.of(context).textTheme.bodyText1),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /**
   * Custom method for determining locale of the device
   */
  Future<String> findSystemLocale() {
    try {
      Intl.systemLocale = Intl.canonicalizedLocale(Platform.localeName);
    } catch (e) {
      return Future.value();
    }
    return Future.value(Intl.systemLocale);
  }


}
