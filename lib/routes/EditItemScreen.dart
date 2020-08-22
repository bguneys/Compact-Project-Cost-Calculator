import 'package:bgsapp02082020/data/Item.dart';
import 'package:bgsapp02082020/data/ItemRepository.dart';
import 'package:bgsapp02082020/data/Project.dart';
import 'package:bgsapp02082020/routes/ProjectDetailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'EditItemScreenViewModel.dart';

class EditItemScreen extends StatefulWidget {
  final Item item;
  final Project project;

  // In the constructor, we create an object with Item obtained from ProjectDetailsScreen
  EditItemScreen({Key key, @required this.item, @required this.project}) : super(key: key);

  @override
  _EditItemScreenState createState() => _EditItemScreenState(item: item, project: project);
}

class _EditItemScreenState extends State<EditItemScreen> {
  final Item item;
  final Project project;

  // In constructor we create an object with Item obtained from AddItemScreen
  _EditItemScreenState({@required this.item, @required this.project});

  static final itemRepository = ItemRepository.getInstance();   // create ProjectDatabase through creating ProjectRepository instance

  final editItemScreenViewModel = EditItemScreenViewModel(itemRepository);   // create ViewModel

  final _formKey = GlobalKey<FormState>();   // Global key for form

  String _totalCostString = ""; // total cost calculated for each input

  //TextEditControllers for each TextFormField
  final titleTextFieldController = TextEditingController();
  final hourlyCostTextFieldController = TextEditingController();
  final daysTextFieldController = TextEditingController();
  final workHoursADayTextFieldController = TextEditingController();


  @override
  void initState() {
    super.initState();

    // initilize TextEditController and total cost values with chosen item values
    titleTextFieldController.text = item.title;
    hourlyCostTextFieldController.text = item.hourlyCost.toString();
    daysTextFieldController.text = item.durationInDay.toString();
    workHoursADayTextFieldController.text = item.workHoursInADay.toString();
    _totalCostString = item.cost.toString();

    print("Item prop: title: " + item.title + " - hourlyCost: " + item.hourlyCost.toString() + " - workHours: " + item.workHoursInADay.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(item.title),
        backgroundColor: Colors.green[800],
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            editItemScreenViewModel.navigateToProjectDetailsScreen(context, project);
          },
        ),
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
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[

                  Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 16.0, 16.0, 24.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: titleTextFieldController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter some value";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                labelText: "Title: "
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 16.0, 16.0, 24.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: hourlyCostTextFieldController,
                            keyboardType: TextInputType.number,
                            onChanged: _calculateTotalCost,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter some value";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                labelText: "Hourly Cost : "
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 16.0, 16.0, 24.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: daysTextFieldController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                            onChanged: _calculateTotalCost,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter some value";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: "Duration (days): ",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 16.0, 16.0, 24.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: workHoursADayTextFieldController,
                            keyboardType: TextInputType.number,
                            onChanged: _calculateTotalCost,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter some value";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: "Work Hours in a Day: ",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 20.0, 20.0, 24.0),
                    child: Text(_totalCostString),
                  ),

                  Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24.0, 20.0, 20.0, 24.0),
                      child: RaisedButton(
                          child: Text('Save'),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {

                              // calculate total cost from inputs
                              String titleString = titleTextFieldController.text;
                              String hourlyCostString = hourlyCostTextFieldController.text;
                              String daysString = daysTextFieldController.text;
                              String workHoursInADayString = workHoursADayTextFieldController.text;

                              double hourlyCost = double.parse(hourlyCostString);
                              int days = int.parse(daysString);
                              double workHoursInADay = double.parse(workHoursInADayString);

                              double totalCost = (hourlyCost * workHoursInADay) * days;

                              // insert Item to the database
                              var editedItem = Item(id: item.id,
                                                    title: titleString,
                                                    hourlyCost: hourlyCost,
                                                    durationInDay: days,
                                                    cost: totalCost,
                                                    workHoursInADay: workHoursInADay,
                                                    projectId: project.id);

                              await editItemScreenViewModel.updateItem(editedItem);

                              // go to ProjectDetailsScreen after inserting Item into database
                              editItemScreenViewModel.navigateToProjectDetailsScreen(context, project);

                              //print("title: " + titleString + " - hourlyCost: " + hourlyCost.toString() + " - days: " + days.toString() + " - total cost " + totalCost.toString() + " - projectId: " + project.id.toString());
                            }
                          }
                      ),
                    ),
                  ),
                ]
            ),
          ),
        ),
      ),
    );
  }


  @override
  void dispose() {
    titleTextFieldController.dispose();
    hourlyCostTextFieldController.dispose();
    daysTextFieldController.dispose();
    workHoursADayTextFieldController.dispose();

    super.dispose();

  }

  /**
   * Custom method for handling clicks on AppBar OverFlow menu
   */
  void _handleAppBarClick(String value) {
    editItemScreenViewModel.handleAppBarClick(value, context);
  }

  /**
   * Custom method for calculatig total cost.
   * If one of the TextFormField is empty then totalCost String is shown zero
   */
  void _calculateTotalCost(String value) {

    // calculate total cost from inputs
    String hourlyCostString = hourlyCostTextFieldController.text;
    String daysString = daysTextFieldController.text;
    String workHoursInADayString = workHoursADayTextFieldController.text;

    setState(() {

      if (hourlyCostString.isEmpty || daysString.isEmpty || workHoursInADayString.isEmpty) {
        //do nothing
        print("Warning total cost: 0");
        _totalCostString = "Total Cost: 0.00"; // if not all fields entered then total cost shown zero

      } else {
        double hourlyCost = double.parse(hourlyCostString);
        int days = int.parse(daysString);
        double workHoursInADay = double.parse(workHoursInADayString);

        double totalCost = (hourlyCost * workHoursInADay) * days;

        _totalCostString = "Total Cost: " + totalCost.toStringAsFixed(2); // String with 2 digits after comma
      }

    });

  }

}
