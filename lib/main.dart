import 'package:bgsapp02082020/routes/MainScreen.dart';
import 'package:flutter/material.dart';

import 'data/AppStrings.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      theme: ThemeData(
        primaryColor: Color(0xFF115969),
        backgroundColor: Color(0xFF115969),
        cardColor: Color(0xFFFAFAFA),
        accentColor: Color(0xFF115969),
        errorColor: Color(0xFFFFc640),
        visualDensity: VisualDensity.adaptivePlatformDensity,

        textTheme: TextTheme(
          headline6: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Color(0xFFFAFAFA)),
          headline5: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: Color(0xFF115969), height: 1.5),
          headline4: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xFFFAFAFA)),
          subtitle1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xFF115969)),
          subtitle2: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xFFFAFAFA)),
          bodyText1: TextStyle(fontSize: 16.0, color: Color(0xFF115969), fontWeight: FontWeight.normal),
          bodyText2: TextStyle(fontSize: 16.0, color: Color(0xFFFAFAFA), fontWeight: FontWeight.normal),
        ),

        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFFFFc640),
          textTheme: ButtonTextTheme.accent,
        )
      ),
      home: MainScreen(title: AppStrings.mainScreenTitle),
    );
  }
}

