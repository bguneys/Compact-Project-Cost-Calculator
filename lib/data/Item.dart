import 'dart:ffi';

import 'package:bgsapp02082020/data/Constants.dart';

class Item {
    final int id;
    final String title;
    final int durationInDay;
    final double cost;
    final double hourlyCost;
    final int projectId;

  const Item({
      this.id,
      this.title,
      this.durationInDay,
      this.cost,
      this.hourlyCost,
      this.projectId,});

  Map<String, dynamic> toMap() {
    return {
      Constants.columnItemId : id,
      Constants.columnItemTitle: title,
      Constants.columnItemDurationInDay: durationInDay,
      Constants.columnItemCost: cost,
      Constants.columnItemHourlyCost: hourlyCost,
      Constants.columnItemProjectId: projectId
    };
  }

  @override
  String toString() {
      return ("id :" + id.toString() + " - title: " + title);
  }
}