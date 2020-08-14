import 'dart:convert';

import 'package:bgsapp02082020/data/Item.dart';
import 'package:bgsapp02082020/data/ItemRepository.dart';
import 'package:bgsapp02082020/data/Project.dart';
import 'package:bgsapp02082020/data/ProjectRepository.dart';
import 'package:bgsapp02082020/routes/ProjectDetailsScreenViewModel.dart';
import 'package:flutter/material.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final Project project;

  // In the constructor, we create an object with Project obtained from MainScreen
  ProjectDetailsScreen({Key key, @required this.project}) : super(key: key);

  @override
  // In createState() callback we create state class with project argument
  _ProjectDetailsScreenState createState() =>
      _ProjectDetailsScreenState(project: project);
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  final Project project;

  // In constructor we create an object with Project obtained from ProjectDetailsScreen
  _ProjectDetailsScreenState({@required this.project});

  // create ProjectDatabase through creating ItemRepository instance
  static final itemRepository = ItemRepository.getInstance();

  // create ProjectDatabase through creating ProjectRepository instance
  static final projectRepository = ProjectRepository.getInstance();

  // create ViewModel
  final projectDetailsScreenViewModel =
      ProjectDetailsScreenViewModel(itemRepository, projectRepository);

  //Item list variable to store Items from database
  List<Item> itemList = new List();

  int projectId;

  double totalProjectCost;
  int totalProjectDuration;
  double totalProjectHourlyCost;
  String projectCurrencyString = "\$";

  @override
  void initState() {
    super.initState();

    projectId = project.id;

    populateItemList(); // Custom method for populating itemList variable from database.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[800],

      appBar: AppBar(
        title: Text(project.title),
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
                           projectDetailsScreenViewModel.navigateToEditItemScreen(context, itemList[index], project);
                           print('Item tapped.');
                         },
                         onLongPress: () {
                           _deleteItem(itemList[index]);
                           populateItemList();
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
                              child: Text("Total cost: ${totalProjectCost.toStringAsFixed(2)} $projectCurrencyString"),
                            ),

                            Padding(
                              padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                              child: Text("Total hourly cost: ${totalProjectHourlyCost.toStringAsFixed(2)} $projectCurrencyString/h"),
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
                              projectDetailsScreenViewModel.navigateToAddItemScreen(context, project);
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
  void populateItemList() {
    itemList.clear();
    projectDetailsScreenViewModel.getItemWithProjectId(projectId).then((value) {

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

        //Update Project values with edited or newly added items.
        // if item list is empty then make inital values equal to zero
        if (itemList.isEmpty) {
          var newProject = Project(id: project.id,
              title: project.title,
              cost: 0.0,
              durationInDay: 0,
              hourlyCost: 0.0);

          projectDetailsScreenViewModel.updateProject(newProject);

        } else {
          var newProject = Project(id: project.id,
              title: project.title,
              cost: totalProjectCost,
              durationInDay: totalProjectDuration,
              hourlyCost: totalProjectHourlyCost);

          projectDetailsScreenViewModel.updateProject(newProject);
        }

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
}
