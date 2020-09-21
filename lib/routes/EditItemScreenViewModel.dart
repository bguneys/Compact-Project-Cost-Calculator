import 'dart:ffi';
import 'package:bgsapp02082020/data/Item.dart';
import 'package:bgsapp02082020/data/ItemRepository.dart';
import 'ProjectDetailsScreen.dart';
import 'SettingsScreen.dart';
import 'package:flutter/material.dart';

class EditItemScreenViewModel {

  final ItemRepository itemRepository;

  EditItemScreenViewModel(this.itemRepository);

  /// Custom method for inserting Item into database
  Future<void> insertItem(Item item) async {
    itemRepository.insertItem(item);
  }

  /// Custom method for updating Item into database
  Future<void> updateItem(Item item) async {
    itemRepository.updateItem(item);
  }

  /**
   * Custom method for handling clicks on AppBar OverFlow menu
   */
  void handleAppBarClick(String value, BuildContext context) {
    switch (value) {
      case 'About':
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
  void navigateToProjectDetailsScreen(BuildContext context, int projectId, String projectTitle) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ProjectDetailsScreen(projectId: projectId, projectTitle: projectTitle)),
    );
  }

}