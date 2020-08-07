import 'package:bgsapp02082020/data/Item.dart';
import 'package:bgsapp02082020/data/ItemRepository.dart';
import 'package:flutter/material.dart';

import 'AddItemScreenViewModel.dart';

class AddItemScreen extends StatefulWidget {

  // In the constructor, we create an object with Item obtained from ProjectDetailsScreen
  AddItemScreen({Key key}) : super(key: key);

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {

  // create ProjectDatabase through creating ProjectRepository instance
  static final itemRepository = ItemRepository.getInstance();

  // create ViewModel
  final addItemScreenViewModel = AddItemScreenViewModel(itemRepository);

  // Global key for form
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Add Item"),
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 20.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: Text("Item Title: "),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 0.0),
                            child: TextFormField(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 20.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: Text("Hourly Cost: "),
                        ),
                          Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 0.0),
                                child: TextFormField(),
                              ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 20.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: Text("Duration (days): "),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 0.0),
                            child: TextFormField(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 20.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: Text("Work Hours in a Day: "),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 0.0),
                            child: TextFormField(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 0.0),
                    child: Text("Total Cost: 100"),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 0.0),
                      child: RaisedButton(
                        child: Text('Add'),
                        onPressed: () {
                          print("Item added.");
                        }
                      ),
                    ),
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
    addItemScreenViewModel.handleAppBarClick(value, context);
  }
}
