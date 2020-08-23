import 'package:bgsapp02082020/data/Item.dart';
import 'package:bgsapp02082020/data/ItemRepository.dart';
import 'package:bgsapp02082020/data/Project.dart';
import 'package:bgsapp02082020/data/ProjectRepository.dart';
import 'package:flutter/material.dart';
import 'AddItemScreen.dart';
import 'EditItemScreen.dart';
import 'EditProjectScreen.dart';
import 'MainScreen.dart';
import 'SettingsScreen.dart';

class ProjectDetailsScreenViewModel {

  final ItemRepository itemRepository;
  final ProjectRepository projectRepository;

  ProjectDetailsScreenViewModel(this.itemRepository, this.projectRepository);

  /// Custom method for inserting Item into database
  Future<void> insertItem(Item item) async {
    itemRepository.insertItem(item);
  }

  /// Custom method for deleting an Item from database
  Future<void> deleteItem(Item item) async {
    itemRepository.deleteItem(item);
  }

  /// Custom method for getting all Items assinged to a Project from database
  Future<List<Item>> getItemWithProjectId(int itemProjectId) async {
    return itemRepository.getItemsWithProjectId(itemProjectId);
  }

  /// Custom method for updating an Item inside database
  Future<void> updateItem(Item item) async {
    itemRepository.updateItem(item);
  }

  /// Custom method for updating a Project inside Database table
  Future<void> updateProject(Project project) async {
    projectRepository.updateProject(project);
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
  void navigateToEditItemScreen(BuildContext context, Item item, Project project) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => EditItemScreen(item: item, project: project)),
    );
  }

  /**
   * Custom method for navigating to AddItemScreen with chosen project data
   */
  void navigateToAddItemScreen(BuildContext context, project) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AddItemScreen(project: project,)),
    );
  }

  /**
   * Custom method for navigating to EditProjectScreen with chosen project data
   */
  void navigateToEditProjectScreen(BuildContext context, project) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => EditProjectScreen(project: project)),
    );
  }

  /**
   * Custom method for navigating to EditProjectScreen with chosen project data
   */
  void navigateToMainScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
  }
}