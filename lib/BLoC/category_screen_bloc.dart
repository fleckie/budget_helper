import 'package:budget_helper/DataLayer/database/database_helper.dart';
import 'bloc.dart';
import 'dart:async';
import 'package:budget_helper/DataLayer/models/category.dart';
import 'package:budget_helper/DataLayer/date_helper.dart' as dh;

class CategoryScreenBloc implements Bloc {
  final _categoryListController = StreamController<Map<String, List<Category>>>.broadcast();
  final _dateController = StreamController<String>.broadcast();
  final _valueBreakdownByCategory = StreamController<Map<int, double>>.broadcast();

  Stream<Map<String, List<Category>>> get categoryListStream =>
      _categoryListController.stream;
  Stream<String> get dateStream => _dateController.stream;
  Stream<Map<int, double>> get valueBreakdown =>
      _valueBreakdownByCategory.stream;

  String _date;
  Map<int, double> _valueBreakdownMap;

  void loadCategories() async {
    final expenses =
    await DatabaseHelper.instance.getCategorySubtypeTable('Expenses');
    final incomes =
    await DatabaseHelper.instance.getCategorySubtypeTable('Incomes');
    final Map<String, List<Category>> map = Map<String, List<Category>>();
    map['Expenses'] = expenses;
    map['Incomes'] = incomes;
    _categoryListController.sink.add(map);
    initDate();
  }

  void deleteCategory(int id) async {
    await DatabaseHelper.instance.delete("Categories", id);
    loadCategories();
  }

  Future<int> saveCategory(String name, String type) async {
    // generate a new category and get its id
    int id = await DatabaseHelper.instance.insert("Categories", {'id': null});
    // choose table to insert data into
    Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    await DatabaseHelper.instance.insert(type, data);
    return id;
  }

//Date methods
  void initDate() {
    _date = dh.convertDateToString(DateTime.now());
    _dateController.sink.add(_date);
    loadValueBreakdown();
  }

  //resinking the last set date to trigger an event at potential listeners
  void reSinkDate(){
    _dateController.sink.add(_date);
  }

  void setDate(DateTime date) {
    _date = dh.convertDateToString(date);
    _dateController.sink.add(_date);
    loadValueBreakdown();
  }

  void previousMonth() {
    _date = dh.convertToStartOfLastMonth(_date);
    _dateController.sink.add(_date);
    loadValueBreakdown();
  }

  void nextMonth() {
    _date = dh.convertToStartOfNextMonth(_date);
    _dateController.sink.add(_date);
    loadValueBreakdown();
  }

  //Breaking down item values by category
  void loadValueBreakdown () async{
    int startOfMonth = dh.convertStringToDate(_date).millisecondsSinceEpoch;
    int endOfMonth = dh.convertStringToDate(dh.convertToStartOfNextMonth(_date)).millisecondsSinceEpoch;
    _valueBreakdownMap = await DatabaseHelper.instance.getAggregatedValueByCategory(startOfMonth, endOfMonth);
    _valueBreakdownByCategory.sink.add(_valueBreakdownMap);
  }


  @override
  void dispose() {
    _categoryListController.close();
    _dateController.close();
    _valueBreakdownByCategory.close();
  }



}
