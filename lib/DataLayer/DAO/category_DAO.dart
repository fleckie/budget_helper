import 'package:budget_helper/DataLayer/database/database_helper.dart';
import 'package:budget_helper/DataLayer/models/category.dart';
import 'package:budget_helper/DataLayer/database/database_constants.dart'
    as Constants;

class CategoryDAO {
  DatabaseHelper databaseHelper;

  CategoryDAO._privateConstructor() {
    databaseHelper = DatabaseHelper.instance;
  }

  static final CategoryDAO instance = CategoryDAO._privateConstructor();

  Future<Map<String, List>> loadCategories() async {
    final expenses = await databaseHelper.getCategorySubtypeTable('Expenses');
    final incomes = await databaseHelper.getCategorySubtypeTable('Incomes');
    final Map<String, List<Category>> map = Map<String, List<Category>>();
    map['Expenses'] = expenses;
    map['Incomes'] = incomes;
    return map;
  }

  Future<void> saveCategory(String name, String type, int color) async {
    // generate a new category and get its id
    int id = await databaseHelper.insert("Categories", {'id': null});
    // choose table to insert data into
    Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['color'] = color;
    await databaseHelper.insert(type, data);
  }

  Future<void> updateCategory(int id, String name, String type, int color) async {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['color'] = color;
    await databaseHelper.insert(type, data);
  }

  Future<void> deleteCategory(int id) async {
    await databaseHelper.delete(Constants.categoriesTable, id);
  }

  //TODO: move to a new DAO
  Future<double> loadNetTotal(int endOfMonth) async {
    double expenses = 0;
    double income = 0;
    List<Map<String, dynamic>> resultMap =
        await databaseHelper.getNetTotalAtSpecificDate(endOfMonth);
    if (resultMap.isEmpty) {
      return 0;
    }
    resultMap.forEach((e) => {
          if (e['type'] == 'Expenses')
            {expenses = e['sum']}
          else if (e['type'] == 'Incomes')
            {income = e['sum']}
        });
    return income - expenses;
  }

  //TODO: simplify/combine the two similar functions
  Future<double> loadNetTotalOfSpecificMonth(
      int startOfMonth, int endOfMonth) async {
    double expenses = 0;
    double income = 0;
    List<Map<String, dynamic>> resultMap = await databaseHelper
        .getNetTotalForSpecificMonth(startOfMonth, endOfMonth);
    if (resultMap.isEmpty) {
      return 0;
    }
    resultMap.forEach((e) => {
          if (e['type'] == 'Expenses')
            {expenses = e['sum']}
          else if (e['type'] == 'Incomes')
            {income = e['sum']}
        });
    return income - expenses;
  }

  Future<Map<int, double>> loadValueBreakdown(
      int startOfMonth, int endOfMonth) async {
    final List<Map<String, dynamic>> resultMap = await databaseHelper
        .getAggregatedValueByCategory(startOfMonth, endOfMonth);
    final Map<int, double> map = Map<int, double>();
    resultMap.forEach((e) => {map[e[Constants.itemsCategoryId]] = e['sum']});
    return map;
  }
}
