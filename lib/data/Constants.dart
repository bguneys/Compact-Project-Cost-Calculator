

class Constants {

  static final databaseName = "project_database.db";
  static final databaseVersion = 1;

  static final databaseProjectTable = 'projects';
  static final columnProjectId = 'id';
  static final columnProjectTitle = 'title';
  static final columnProjectDurationInDay = 'durationInDay';
  static final columnProjectCost = 'cost';
  static final columnProjectHourlyCost = 'hourlyCost';

  static final databaseItemTable = 'item_table';
  static final columnItemId = 'item_id';
  static final columnItemTitle = 'item_title';
  static final columnItemDurationInDay = 'item_durationInDay';
  static final columnItemCost = 'item_cost';
  static final columnItemHourlyCost = 'item_hourlyCost';
  static final columnItemProjectId = 'item_project_id';
}
