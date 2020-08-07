import 'package:bgsapp02082020/data/Item.dart';
import 'package:bgsapp02082020/data/ItemRepository.dart';
import 'package:flutter/material.dart';
import 'AddItemScreen.dart';
import 'EditItemScreen.dart';
import 'SettingsScreen.dart';

class ProjectDetailsScreenViewModel {

  final ItemRepository itemRepository;

  ProjectDetailsScreenViewModel(this.itemRepository);

  /// Custom method for inserting Item into database
  Future<void> insertItem(Item item) async {
    itemRepository.insertItem(item);
  }

  /// Custom method for getting all Items assinged to a Project from database
  Future<List<Item>> getItemWithProjectId(int itemProjectId) async {
    return itemRepository.getItemsWithProjectId(itemProjectId);
  }

  /// Custom method for updating an Item inside database
  Future<void> updateItem(Item item) async {
    itemRepository.updateItem(item);
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
   * Custom method for navigating to EditItemScreen with chosen project data
   */
  void navigateToEditItemScreen(BuildContext context, Item item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditItemScreen(item: item)),
    );
  }

  /**
   * Custom method for navigating to AddItemScreen with chosen project data
   */
  void navigateToAddItemScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddItemScreen()),
    );
  }
}