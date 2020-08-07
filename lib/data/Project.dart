import 'dart:ffi';
import 'package:bgsapp02082020/data/Constants.dart';

import 'Item.dart';

class Project {
  final int id;
  final String title;
  final int durationInDay;
  final double cost;
  final double hourlyCost;

  const Project({
      this.id,
      this.title,
      this.durationInDay,
      this.cost,
      this.hourlyCost});

  Map<String, dynamic> toMap() {
    return {
      Constants.columnProjectId : id,
      Constants.columnProjectTitle : title,
      Constants.columnProjectDurationInDay : durationInDay,
      Constants.columnProjectCost : cost,
      Constants.columnProjectHourlyCost : hourlyCost,
    };
  }

}