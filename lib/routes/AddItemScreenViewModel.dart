import 'dart:ffi';

import 'package:bgsapp02082020/data/Item.dart';
import 'package:bgsapp02082020/data/ItemRepository.dart';
import 'ProjectDetailsScreen.dart';
import 'SettingsScreen.dart';
import 'package:flutter/material.dart';

class AddItemScreenViewModel {

  final ItemRepository itemRepository;

  AddItemScreenViewModel(this.itemRepository);

  /// Custom method for inserting Item into database
  Future<void> insertItem(Item item) async {
    itemRepository.insertItem(item);
  }

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

  /**
   * Custom method for navigating to ProjectDetailsScreen
   */
  void navigateToProjectDetailsScreen(BuildContext context, project) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ProjectDetailsScreen(project: project,)),
    );
  }

}