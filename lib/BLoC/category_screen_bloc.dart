import 'package:budget_helper/DataLayer/DAO/category_DAO.dart';
import 'bloc.dart';
import 'dart:async';
import 'package:budget_helper/DataLayer/models/category.dart';
import 'package:budget_helper/DataLayer/date_helper.dart' as dh;

class CategoryScreenBloc implements Bloc {
  final CategoryDAO categoryDAO = CategoryDAO.instance;
  Map<String, List> _categoryMap;
  Map<int, double> _valueBreakdownMap;
  String _date;
  Map<String, double> _netTotal;

  final _categoryListController =
      StreamController<Map<String, List<Category>>>.broadcast();
  final _valueBreakdownByCategory =
      StreamController<Map<int, double>>.broadcast();
  final _dateController = StreamController<String>.broadcast();
  final _netTotalController = StreamController<Map<String, double>>.broadcast();

  Stream<Map<String, List<Category>>> get categoryListStream =>
      _categoryListController.stream;

  Stream<String> get dateStream => _dateController.stream;

  Stream<Map<int, double>> get valueBreakdown =>
      _valueBreakdownByCategory.stream;

  Stream<Map<String, double>> get netTotalStream => _netTotalController.stream;

  Future<void> loadCategories() async {
    _categoryMap = await categoryDAO.loadCategories();
    _categoryListController.sink.add(_categoryMap);
  }

  Future<void> saveCategory(String name, String type, int color) async {
    await categoryDAO.saveCategory(name, type, color);
  }

  Future<void> updateCategory(
      int id, String name, String type, int color) async {
    await categoryDAO.updateCategory(id, name, type, color);
  }

  void deleteCategory(int id) async {
    await categoryDAO.deleteCategory(id);
    loadCategories();
  }

  void updateScreen() async {
    await loadCategories();
    await loadValueBreakdown();
    await loadNetTotal();
  }

  Future<void> loadNetTotal() async {
    double netTotalOverall = await loadNetTotalAtSpecificDate();
    double netTotalSpecificMonth = await loadNetTotalOfSpecificMonth();
    _netTotal = Map<String, double>();
    _netTotal['overall'] = netTotalOverall;
    _netTotal['month'] = netTotalSpecificMonth;
    _netTotalController.sink.add(_netTotal);
  }

  Future<double> loadNetTotalAtSpecificDate() async {
    int endOfMonth = dh
            .convertStringToDate(dh.convertToStartOfNextMonth(_date))
            .millisecondsSinceEpoch -
        1;
    return await categoryDAO.loadNetTotal(endOfMonth);
  }

  Future<double> loadNetTotalOfSpecificMonth() async {
    int startOfMonth = dh.convertStringToDate(_date).millisecondsSinceEpoch;
    int endOfMonth = dh
            .convertStringToDate(dh.convertToStartOfNextMonth(_date))
            .millisecondsSinceEpoch -
        1;
    return await categoryDAO.loadNetTotalOfSpecificMonth(
        startOfMonth, endOfMonth);
  }

  //Breaking down item values by category
  Future<void> loadValueBreakdown() async {
    int startOfMonth = dh.convertStringToDate(_date).millisecondsSinceEpoch;
    int endOfMonth = dh
            .convertStringToDate(dh.convertToStartOfNextMonth(_date))
            .millisecondsSinceEpoch -
        1;
    _valueBreakdownMap =
        await categoryDAO.loadValueBreakdown(startOfMonth, endOfMonth);
    _valueBreakdownByCategory.sink.add(_valueBreakdownMap);
  }

//Date methods
  void initDate() {
    _date = dh.convertDateToString(DateTime.now());
    _dateController.sink.add(_date);
  }

  //resinking the last set date to trigger an event at potential listeners
  void reSinkDate() {
    _dateController.sink.add(_date);
  }

  void setDate(DateTime date) {
    _date = dh.convertDateToString(date);
    _dateController.sink.add(_date);
    updateScreen();
  }

  void previousMonth() {
    _date = dh.convertToStartOfLastMonth(_date);
    _dateController.sink.add(_date);
    updateScreen();
  }

  void nextMonth() {
    _date = dh.convertToStartOfNextMonth(_date);
    _dateController.sink.add(_date);
    updateScreen();
  }

  @override
  void dispose() {
    _categoryListController.close();
    _dateController.close();
    _valueBreakdownByCategory.close();
    _netTotalController.close();
  }
}
