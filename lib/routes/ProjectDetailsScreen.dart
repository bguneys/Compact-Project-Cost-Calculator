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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[800],

      appBar: AppBar(
        title: Text("Project Title"),
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

      body: Center(
        child: Text("Hello"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: populateItemList,
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
    projectDetailsScreenViewModel.getItemWithProjectId(project.id).then((value) {
      setState(() {
        value.forEach((element) {
          itemList.add(Item(
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
   * Custom method for database testing
   */
  void _addItemsToDatabase() async {
    var sampleItem3 = Item(id: 3, title: "Test Item 3", projectId: 2);

    // insert a project into the database.
    await projectDetailsScreenViewModel.insertItem(sampleItem3);

    await populateItemList();

    itemList.forEach((element) {
      print("Item:  " + element.toString());
    });
  }
}
