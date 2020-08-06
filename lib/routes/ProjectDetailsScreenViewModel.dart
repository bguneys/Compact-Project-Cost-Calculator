import 'package:flutter/material.dart';
import 'SettingsScreen.dart';

class ProjectDetailsScreenViewModel {





  /**
   * Custom method for handling clicks on AppBar OverFlow menu
   */
  void handleAppBarClick(String value, BuildContext context) {
    switch (value) {
      case 'Settings':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsScreen()),
        );
        break;
    }
  }
}