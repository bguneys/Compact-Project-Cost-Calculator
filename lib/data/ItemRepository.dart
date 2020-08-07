import 'package:bgsapp02082020/data/ProjectDatabase.dart';

import 'Item.dart';

class ItemRepository {

  ProjectDatabase _projectDatabase;
  static ItemRepository _itemRepository;

  //making repository instance singleton with a private constructor
  ItemRepository._privateConstructor(){
    _projectDatabase = ProjectDatabase.projectDatabase;
  }

  static ItemRepository getInstance() {

    if (_itemRepository == null) {
      _itemRepository = ItemRepository._privateConstructor();
    }

    return _itemRepository;
  }

  /// Custom method for inserting an Item into database
  Future<void> insertItem(Item item) async {
    _projectDatabase.insertItem(item);
  }

  /// Custom method for getting all Item list addiged to a Project from database
  Future<List<Item>> getItemsWithProjectId(int itemProjectId) async {
    return _projectDatabase.getItemsWithProjectId(itemProjectId);
  }

  /// Custom method for updating an Item inside Database table
  Future<void> updateItem(Item item) async {
    _projectDatabase.updateItem(item);
  }

}