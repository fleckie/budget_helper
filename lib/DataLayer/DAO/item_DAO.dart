import 'package:budget_helper/DataLayer/database/database_helper.dart';
import 'package:budget_helper/DataLayer/models/item.dart';
import 'package:budget_helper/DataLayer/database/database_constants.dart' as Constants;

class ItemDAO {
  DatabaseHelper databaseHelper;

  ItemDAO._privateConstructor() {
    databaseHelper = DatabaseHelper.instance;
  }

  static final ItemDAO instance = ItemDAO._privateConstructor();

  Future<List<Item>> loadItems(int id, int startOfMonth, int endOfMonth) async {
    List<Map<String,dynamic>> result = await databaseHelper.getItemsInMonthByCategory(id, startOfMonth, endOfMonth);
    return List.generate(result.length, (i) {
      return Item(
          id: result[i]['id'],
          name: result[i]['name'],
          categoryId: result[i]['categoryId'],
          value: result[i]['value'],
          date: DateTime.fromMillisecondsSinceEpoch(result[i]['date']));
    });
  }

  Future<void> saveItem(String name, int categoryId, double value, DateTime date) async {
    Map<String, dynamic> itemMap = Map<String,dynamic>();
    itemMap[Constants.itemsName] = name;
    itemMap[Constants.itemsCategoryId] = categoryId;
    itemMap[Constants.itemsValue] = value;
    itemMap[Constants.itemsDate] = date.millisecondsSinceEpoch;
    await databaseHelper.insert(Constants.itemsTable, itemMap);
  }
}
