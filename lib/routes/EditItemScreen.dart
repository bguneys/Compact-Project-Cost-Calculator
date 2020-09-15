import 'package:bgsapp02082020/data/Item.dart';
import 'package:bgsapp02082020/data/ItemRepository.dart';
import 'package:bgsapp02082020/data/Project.dart';
import 'package:bgsapp02082020/routes/ProjectDetailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'EditItemScreenViewModel.dart';
import 'dart:io';
import 'package:intl/intl.dart';

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

  var numberFormat; //2 decimals and thousand separator format for currencies

  @override
  void initState() {
    super.initState();

    // find device local and declare NumberFormat using it
    findSystemLocale().then((locale) {
      print(locale);
      numberFormat = NumberFormat.currency(locale: locale, name: "");
    }).then((value) {
      // initilize TextEditController and total cost values with chosen item values
      titleTextFieldController.text = item.title;
      hourlyCostTextFieldController.text = "${numberFormat.format(item.hourlyCost).toString()}";
      daysTextFieldController.text = item.durationInDay.toString();
      workHoursADayTextFieldController.text = item.workHoursInADay.toString();

      setState(() {
        _totalCostString = "${numberFormat.format(item.cost).toString()}";
      });

    });



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(item.title, style: Theme.of(context).textTheme.headline6),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            editItemScreenViewModel.navigateToProjectDetailsScreen(context, project.id, project.title);
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
        height: double.infinity,
        color: Theme.of(context).backgroundColor,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[

                  Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 16.0, 16.0, 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Title:", style: Theme.of(context).textTheme.headline4),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Theme(
                                data: ThemeData(primaryColor: Color(0xFFFAFAFA), hintColor: Color.fromARGB(100, 255, 255, 255)),
                                child: TextFormField(
                                  style: Theme.of(context).textTheme.bodyText2,
                                  controller: titleTextFieldController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Please enter some value";
                                    }
                                    return null;
                                  },
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
                                      hintText: "Type new item title..",
                                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 16.0, 16.0, 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Hourly Cost (${project.currency}):", style: Theme.of(context).textTheme.headline4),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Theme(
                                data: ThemeData(primaryColor: Color(0xFFFAFAFA), hintColor: Color.fromARGB(100, 255, 255, 255)),
                                child: TextFormField(
                                  style: Theme.of(context).textTheme.bodyText2,
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
                                      hintText: "Type hourly cost..",
                                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 16.0, 16.0, 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Duration (days):", style: Theme.of(context).textTheme.headline4),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Theme(
                                data: ThemeData(primaryColor: Color(0xFFFAFAFA), hintColor: Color.fromARGB(100, 255, 255, 255)),
                                child: TextFormField(
                                  style: Theme.of(context).textTheme.bodyText2,
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
                                      hintText: "Type estimated duration..",
                                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 16.0, 16.0, 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Working Hours in a Day:", style: Theme.of(context).textTheme.headline4),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Theme(
                                data: ThemeData(primaryColor: Color(0xFFFAFAFA), hintColor: Color.fromARGB(100, 255, 255, 255)),
                                child: TextFormField(
                                  style: Theme.of(context).textTheme.bodyText2,
                                  controller: workHoursADayTextFieldController,
                                  keyboardType: TextInputType.number,
                                  onChanged: _calculateTotalCost,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Please enter some value";
                                    }else if (double.parse(value) > 24) {
                                      return "Working hours a day can't be above 24";
                                    }

                                    return null;
                                  },
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
                                      hintText: "Type working hours a day..",
                                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 20.0, 20.0, 24.0),
                    child: Text("Total Cost: $_totalCostString ${project.currency}",
                      style: Theme.of(context).textTheme.headline4
                    ),
                  ),

                  Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24.0, 20.0, 20.0, 24.0),
                      child: RaisedButton(
                          child: Text('SAVE', style: Theme.of(context).textTheme.subtitle1),
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
                              editItemScreenViewModel.navigateToProjectDetailsScreen(context, project.id, project.title);

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
        _totalCostString = "Total Cost: ${numberFormat.format(0).toString()} ${project.currency}"; // if not all fields entered then total cost shown zero

      } else {
        double hourlyCost = double.parse(hourlyCostString);
        int days = int.parse(daysString);
        double workHoursInADay = double.parse(workHoursInADayString);

        double totalCost = (hourlyCost * workHoursInADay) * days;

        _totalCostString = "${numberFormat.format(totalCost).toString()}"; // String with 2 digits after comma
      }

    });

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
