import 'package:budget_helper/DataLayer/DAO/category_DAO.dart';
import 'bloc.dart';
import 'dart:async';
import 'package:budget_helper/DataLayer/models/category.dart';
import 'package:budget_helper/DataLayer/date_helper.dart' as dh;

class CategoryScreenBloc implements Bloc {
  final CategoryDAO categoryDAO = CategoryDAO.instance;
  Map<int, double> _valueBreakdownMap;
  String _date;

  final _categoryListController =
      StreamController<Map<String, List<Category>>>.broadcast();
  final _dateController = StreamController<String>.broadcast();
  final _valueBreakdownByCategory =
      StreamController<Map<int, double>>.broadcast();

  Stream<Map<String, List<Category>>> get categoryListStream =>
      _categoryListController.stream;

  Stream<String> get dateStream => _dateController.stream;

  Stream<Map<int, double>> get valueBreakdown =>
      _valueBreakdownByCategory.stream;

  void loadCategories() async {
    final categoryMap = await categoryDAO.loadCategories();
    _categoryListController.sink.add(categoryMap);
    initDate();
  }

  void saveCategory(String name, String type) async {
    await categoryDAO.saveCategory(name, type);
  }

  void deleteCategory(int id) async {
    await categoryDAO.deleteCategory(id);
    loadCategories();
  }

  //Breaking down item values by category
  void loadValueBreakdown() async {
    int startOfMonth = dh.convertStringToDate(_date).millisecondsSinceEpoch;
    int endOfMonth = dh
        .convertStringToDate(dh.convertToStartOfNextMonth(_date))
        .millisecondsSinceEpoch;
    _valueBreakdownMap =
        await categoryDAO.loadValueBreakdown(startOfMonth, endOfMonth);
    _valueBreakdownByCategory.sink.add(_valueBreakdownMap);
  }

//Date methods
  void initDate() {
    _date = dh.convertDateToString(DateTime.now());
    _dateController.sink.add(_date);
    loadValueBreakdown();
  }

  //resinking the last set date to trigger an event at potential listeners
  void reSinkDate() {
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

  @override
  void dispose() {
    _categoryListController.close();
    _dateController.close();
    _valueBreakdownByCategory.close();
  }
}
