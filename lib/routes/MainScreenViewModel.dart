import 'package:bgsapp02082020/data/Item.dart';
import 'package:bgsapp02082020/data/ItemRepository.dart';
import 'package:bgsapp02082020/data/Project.dart';
import 'package:bgsapp02082020/data/ProjectRepository.dart';
import 'package:bgsapp02082020/routes/ProjectDetailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'SettingsScreen.dart';

class MainScreenViewModel {

  final ProjectRepository projectRepository;
  final ItemRepository itemRepository;

  MainScreenViewModel(this.projectRepository, this.itemRepository,);

  /// Custom method for inserting data into table
  Future<void> insertProject(Project project) async {
    projectRepository.insertProject(project);
  }

  /// Custom method for deleting a Project from Database
  Future<void> deleteProject(Project project) async {
    projectRepository.deleteProject(project);
  }

  /// Custom method for getting all Project list from database
  Future<List<Project>> getProjects() async {
    return projectRepository.getProjects();
  }

  /// Custom method for updating a Project inside Database table
  Future<void> updateProject(Project project) async {
    projectRepository.updateProject(project);
  }

  /// Custom method for getting all Items assinged to a Project from database
  Future<List<Item>> getItemWithProjectId(int itemProjectId) async {
    return itemRepository.getItemsWithProjectId(itemProjectId);
  }

  /// Custom method for deleting an Item from database
  Future<void> deleteItem(Item item) async {
    itemRepository.deleteItem(item);
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
   * Custom method for navigating to ProjectDetailsScreen with chosen project data
   */
  void navigateToProjectDetailsScreen(BuildContext context, int projectId, String projectTitle) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ProjectDetailsScreen(projectId: projectId, projectTitle: projectTitle)),
    );
  }

}