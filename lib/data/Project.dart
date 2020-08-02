import 'dart:ffi';
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
      'id': id,
      'title': title,
      'durationInDay': durationInDay,
      'cost': cost,
      'hourlyCost': hourlyCost,
    };
  }

}