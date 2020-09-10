import 'dart:ffi';
import 'package:bgsapp02082020/data/Item.dart';
import 'package:bgsapp02082020/data/ItemRepository.dart';
import 'package:bgsapp02082020/data/Project.dart';
import 'package:bgsapp02082020/data/ProjectRepository.dart';
import 'ProjectDetailsScreen.dart';
import 'SettingsScreen.dart';
import 'package:flutter/material.dart';

class EditProjectScreenViewModel {

  final ProjectRepository projectRepository;

  EditProjectScreenViewModel(this.projectRepository);

  /// Custom method for updating Item into database
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
   * Custom method for navigating to ProjectDetailsScreen
   */
  void navigateToProjectDetailsScreen(BuildContext context, int projectId, String projectTitle) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ProjectDetailsScreen(projectId: projectId, projectTitle: projectTitle))
    );
  }

}

