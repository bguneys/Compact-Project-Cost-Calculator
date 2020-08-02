import 'dart:ffi';

class Item {
  final int id;
  final String title;
  final int durationInDay;
  final Float cost;
  final Float hourlyCost;

  const Item({
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