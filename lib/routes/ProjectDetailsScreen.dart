import 'package:bgsapp02082020/data/Item.dart';
import 'package:bgsapp02082020/data/ItemRepository.dart';
import 'package:bgsapp02082020/data/Project.dart';
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

  // create ProjectDatabase through creating ProjectRepository instance
  static final itemRepository = ItemRepository.getInstance();

  // create ViewModel
  final projectDetailsScreenViewModel =
      ProjectDetailsScreenViewModel(itemRepository);

  //Item list variable to store Items from database
  List<Item> itemList = new List();

  int projectId;

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

            ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amberAccent,
        foregroundColor: Colors.green[800],
        tooltip: 'Add Item',
        child: Icon(Icons.add),
        onPressed: () {
          projectDetailsScreenViewModel.navigateToAddItemScreen(context, project);
        },
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
    projectDetailsScreenViewModel.getItemWithProjectId(projectId).then((value) {
      setState(() {
        value.forEach((element) {
          itemList.add(Item(
              id: element.id,
              title: element.title,
              durationInDay: element.durationInDay,
              cost: element.cost,
              hourlyCost: element.hourlyCost,
              workHoursInADay: element.workHoursInADay));
        });
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
}
