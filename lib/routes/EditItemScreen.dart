import 'package:bgsapp02082020/data/Item.dart';
import 'package:bgsapp02082020/data/ItemRepository.dart';
import 'package:flutter/material.dart';

import 'AddItemScreenViewModel.dart';

class EditItemScreen extends StatefulWidget {
  final Item item;

  // In the constructor, we create an object with Item obtained from ProjectDetailsScreen
  EditItemScreen({Key key, @required this.item}) : super(key: key);

  @override
  _EditItemScreenState createState() => _EditItemScreenState(item: item);
}

class _EditItemScreenState extends State<EditItemScreen> {
  final Item item;

  // In constructor we create an object with Item obtained from AddItemScreen
  _EditItemScreenState({@required this.item});

  // create ProjectDatabase through creating ProjectRepository instance
  static final itemRepository = ItemRepository.getInstance();

  // create ViewModel
  //final addItemScreenViewModel = AddItemScreenViewModel(itemRepository);

  // Global key for form
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(item.title),
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
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 4.0),
                child: Text("Hourly Cost: "),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 16.0),
                child: TextFormField(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 4.0),
                child: Text("Duration (days): "),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 16.0),
                child: TextFormField(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 4.0),
                child: Text("Work Hours in a Day: "),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 16.0),
                child: TextFormField(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 16.0),
                child: Text("Total Cost: 100"),
              ),
            ]
          ),
        ),
      ),
    );
  }

  /**
   * Custom method for handling clicks on AppBar OverFlow menu
   */
  void _handleAppBarClick(String value) {
    //addItemScreenViewModel.handleAppBarClick(value, context);
  }
}
