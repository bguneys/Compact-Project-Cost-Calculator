import 'dart:convert';

import 'package:bgsapp02082020/data/Item.dart';
import 'package:bgsapp02082020/data/ItemRepository.dart';
import 'package:bgsapp02082020/data/Project.dart';
import 'package:bgsapp02082020/data/ProjectRepository.dart';
import 'package:bgsapp02082020/routes/ProjectDetailsScreenViewModel.dart';
import 'package:flutter/material.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final int projectId;
  final String projectTitle;

  // In the constructor, we create an object with Project obtained from MainScreen
  ProjectDetailsScreen({Key key, @required this.projectId, @required this.projectTitle}) : super(key: key);

  @override
  // In createState() callback we create state class with project argument
  _ProjectDetailsScreenState createState() =>
      _ProjectDetailsScreenState(projectId: projectId, projectTitle: projectTitle);
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  final int projectId;
  final String projectTitle;

  // In constructor we create an object with Project obtained from ProjectDetailsScreen
  _ProjectDetailsScreenState({@required this.projectId, @required this.projectTitle});

  // create ProjectDatabase through creating ItemRepository instance
  static final itemRepository = ItemRepository.getInstance();

  // create ProjectDatabase through creating ProjectRepository instance
  static final projectRepository = ProjectRepository.getInstance();

  // create ViewModel
  final projectDetailsScreenViewModel =
      ProjectDetailsScreenViewModel(itemRepository, projectRepository);

  //Item list variable to store Items from database
  List<Item> itemList = new List();

  Item longTappedItem; // Item to be used in _showDialog() method

  FocusNode _focusNode = new FocusNode(); // used to hide soft keyboard

  Project selectedProject;

  String projectCurrency;

  double totalProjectCost;
  int totalProjectDuration;
  double totalProjectHourlyCost;

  @override
  void initState() {
    super.initState();

    populateItemList(); // Custom method for populating itemList variable from database.
    getProject(); // fetch Project chosen with project id and updated values.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[800],

      appBar: AppBar(
        title: Text(projectTitle),
        backgroundColor: Colors.green[800],
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              projectDetailsScreenViewModel.navigateToEditProjectScreen(context, selectedProject);
            },
          ),

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

              //ListView
              Expanded(
                child: ListView.builder(itemBuilder: (context, index) {
                  if (index == itemList.length) {
                    return null;
                  }

                  return Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 4.0, 10.0, 2.0),
                       child: InkWell(
                         splashColor: Colors.blue.withAlpha(30),
                         onTap: () {
                           projectDetailsScreenViewModel.navigateToEditItemScreen(context, itemList[index], selectedProject);
                           //print('Item tapped.');
                         },
                         onLongPress: () {
                           _showDialog(); // custom method for showing AlertDialog
                           longTappedItem = itemList[index]; // Item to be used in _showDialog() method
                         },
                         child: Column(
                           mainAxisSize: MainAxisSize.max,
                           children: <Widget>[
                             ListTile(
                               title: Text(itemList[index].title),
                               leading: Text(itemList[index].workHoursInADay.toString()),
                             ),
                           ],
                         )
                       ),
                    );
                }),
              ),

              // Bottom section
              Container(
                color: Colors.blue,
                width: double.infinity,
                //height: 200.0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 16.0, 8.0, 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget> [

                      //Project details Texts
                      Expanded(
                        child: Wrap(
                          direction: Axis.vertical,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 4.0),
                              child: Text("Total cost: ${totalProjectCost.toStringAsFixed(2)} $projectCurrency"),
                            ),

                            Padding(
                              padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                              child: Text("Total hourly cost: ${totalProjectHourlyCost.toStringAsFixed(2)} $projectCurrency/h"),
                            ),

                            Padding(
                              padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 16.0),
                              child: Text("Total duration: ${totalProjectDuration.toString()} days"),
                            ),
                          ],
                        ),
                      ),

                      //FAB
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 8.0, 0.0),
                        child: Container(
                          child: FloatingActionButton(
                            backgroundColor: Colors.amberAccent,
                            foregroundColor: Colors.green[800],
                            tooltip: 'Add Item',
                            child: Icon(Icons.add),
                            onPressed: () {
                              projectDetailsScreenViewModel.navigateToAddItemScreen(context, selectedProject);
                            },
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),

            ],
        ),
      ),

    );
  }

  /**
   * Custom method for handling clicks on AppBar OverFlow menu
   */
  void _handleAppBarClick(String value) {
    projectDetailsScreenViewModel.handleAppBarClick(value, context);
  }

  /**
   * Custom method for populating itemList variable from database.
   */
  void populateItemList() async {
    itemList.clear();

    await projectDetailsScreenViewModel.getItemWithProjectId(projectId).then((value) {

      totalProjectCost = 0.0;
      totalProjectDuration = 0;
      double totalProjectHours = 0.0;
      totalProjectHourlyCost = 0.0;

      setState(() {
        value.forEach((element) {
          itemList.add(Item(
              id: element.id,
              title: element.title,
              durationInDay: element.durationInDay,
              cost: element.cost,
              hourlyCost: element.hourlyCost,
              workHoursInADay: element.workHoursInADay));

          // calculate total cost, duration, hours for the project
          totalProjectCost = totalProjectCost + element.cost;
          totalProjectDuration = totalProjectDuration + element.durationInDay;
          totalProjectHours = totalProjectHours + (element.hourlyCost * element.durationInDay);
        });

        // calculate total hourly cost for the project via total cost and total hours
        totalProjectHourlyCost = totalProjectCost / totalProjectHours;

      });
    }).catchError((error) {
      print(error);
    });
  }

  /**
   * Custom method for fetching Project chosen with project id and updated values
   * for edited/ newly added items. If
   */
  void getProject() async {
    await projectDetailsScreenViewModel.getProjectWithId(projectId).then((projectList) {
      selectedProject = Project(
          id: projectList.first.id,
          title: projectList.first.title,
          cost: totalProjectCost,
          durationInDay: totalProjectDuration,
          hourlyCost: totalProjectHourlyCost,
          note: projectList.first.note,
          currency: projectList.first.currency);

      projectDetailsScreenViewModel.updateProject(selectedProject);

      setState(() {
        projectCurrency = projectList.first.currency;
      });

    }).catchError((error) {
      print(error);
    });
  }

  /**
   * Custom method for database testing
   */
  void _addItemsToDatabase() async {
    var sampleItem = Item(id: 3, title: "Test Item 3", projectId: 1);

    // insert a project into the database.
    await projectDetailsScreenViewModel.insertItem(sampleItem);

    itemList.add(sampleItem);
  }

  /**
   * Custom method for deleting an item from the list
   */
  void _deleteItem(Item item) async {
    await projectDetailsScreenViewModel.deleteItem(item);
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
          title: Text('Delete Item?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                _deleteItem(longTappedItem);
                populateItemList();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
