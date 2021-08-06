import 'package:budget_helper/DataLayer/database/database_helper.dart';
import 'package:budget_helper/DataLayer/models/item.dart';
import 'package:budget_helper/DataLayer/database/database_constants.dart'
    as Constants;

class ItemDAO {
  DatabaseHelper databaseHelper;

  ItemDAO._privateConstructor() {
    databaseHelper = DatabaseHelper.instance;
  }

  static final ItemDAO instance = ItemDAO._privateConstructor();

  Future<List<Item>> loadItems(int id, int startOfMonth, int endOfMonth) async {
    List<Map<String, dynamic>> result = await databaseHelper
        .getItemsInMonthByCategory(id, startOfMonth, endOfMonth);
    return List.generate(result.length, (i) {
      return Item(
          id: result[i][Constants.itemsId],
          name: result[i][Constants.itemsName],
          categoryId: result[i][Constants.itemsCategoryId],
          type: result[i][Constants.itemsType],
          value: result[i][Constants.itemsValue],
          date: DateTime.fromMillisecondsSinceEpoch(result[i][Constants.itemsDate]));
    });
  }

  Future<void> saveItem(String name, int categoryId, String type, double value,
      DateTime date, [int id]) async {
    Map<String, dynamic> itemMap = Map<String, dynamic>();
    itemMap[Constants.itemsName] = name;
    itemMap[Constants.itemsCategoryId] = categoryId;
    itemMap[Constants.itemsType] = type;
    itemMap[Constants.itemsValue] = value;
    itemMap[Constants.itemsDate] = date.millisecondsSinceEpoch;
    if (id != null){
      itemMap[Constants.itemsId] = id;
    }
    await databaseHelper.insert(Constants.itemsTable, itemMap);
  }

  Future<void> deleteItem(int id) async {
    await databaseHelper.delete(Constants.itemsTable, id);
  }

}
