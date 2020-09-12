import 'package:bgsapp02082020/data/Item.dart';
import 'package:bgsapp02082020/data/ItemRepository.dart';
import 'package:bgsapp02082020/data/Project.dart';
import 'package:bgsapp02082020/data/ProjectRepository.dart';
import 'package:bgsapp02082020/routes/ProjectDetailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'EditItemScreenViewModel.dart';
import 'EditProjectScreenViewModel.dart';

class EditProjectScreen extends StatefulWidget {
  final Project project;

  // In the constructor, we create an object with Item obtained from ProjectDetailsScreen
  EditProjectScreen({Key key, @required this.project}) : super(key: key);

  @override
  _EditProjectScreenState createState() => _EditProjectScreenState(project: project);
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  final Project project;

  // In constructor we create an object with Item obtained from AddItemScreen
  _EditProjectScreenState({@required this.project});

  static final projectRepository = ProjectRepository.getInstance();   // create ProjectDatabase through creating ProjectRepository instance

  final editProjectScreenViewModel = EditProjectScreenViewModel(projectRepository);   // create ViewModel

  final _formKey = GlobalKey<FormState>();   // Global key for form

  //TextEditControllers for each TextFormField
  final projectNoteTextFieldController = TextEditingController();
  //final projectCurrencyTextFieldController = TextEditingController();

  String dropdownValue = 'USD'; //DropDownButton initial value

  @override
  void initState() {
    projectNoteTextFieldController.text = project.note;
    //projectCurrencyTextFieldController.text = project.currency;

    super.initState();

    // initilize TextEditController and total cost values with chosen item values

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(project.title, style: Theme.of(context).textTheme.headline6),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            editProjectScreenViewModel.navigateToProjectDetailsScreen(context, project.id, project.title);
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
                            controller: projectNoteTextFieldController,
                            decoration: InputDecoration(
                                labelText: "Project notes: "
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
                        Text("Project Currency:", style: Theme.of(context).textTheme.subtitle1),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                          child: DropdownButton<String>(
                              value: dropdownValue,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              underline: Container(
                                height: 2,
                                color: Colors.white,
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  dropdownValue = newValue;
                                });
                              },
                              items: <String>['USD', 'EUR', 'GBP', 'TRY']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value, style: Theme.of(context).textTheme.bodyText1),
                                );
                              }).toList(),
                            ),
                        ),
                      ],
                    ),
                  ),


                  Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24.0, 20.0, 20.0, 24.0),
                      child: RaisedButton(
                          child: Text('Save'),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              // calculate total cost from inputs
                              String newProjectNote = projectNoteTextFieldController.text;
                              String newProjectCurrency = dropdownValue;

                              // insert Project to the database
                              var editedProject= Project(id: project.id,
                                  title: project.title,
                                  hourlyCost: project.hourlyCost,
                                  durationInDay: project.durationInDay,
                                  cost: project.cost,
                                  note: newProjectNote,
                                  currency: newProjectCurrency);

                              await editProjectScreenViewModel.updateProject(editedProject);

                              // go to ProjectDetailsScreen after inserting Item into database
                              editProjectScreenViewModel.navigateToProjectDetailsScreen(context, editedProject.id, editedProject.title);
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
    projectNoteTextFieldController.dispose();
    //projectCurrencyTextFieldController.dispose();

    super.dispose();
  }

  /**
   * Custom method for handling clicks on AppBar OverFlow menu
   */
  void _handleAppBarClick(String value) {
    editProjectScreenViewModel.handleAppBarClick(value, context);
  }

}