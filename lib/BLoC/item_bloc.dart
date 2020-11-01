import 'package:budget_helper/DataLayer/database/database_helper.dart';
import 'bloc.dart';
import 'dart:async';
import 'package:budget_helper/DataLayer/models/item.dart';
import 'package:budget_helper/DataLayer/database/database_constants.dart' as Constants;

class ItemBloc implements Bloc {
  final _controller = StreamController<Item>.broadcast();
  Stream<Item> get itemStream => _controller.stream;

  void saveItem(String name, int categoryId, double value, DateTime date) async {
    Map<String, dynamic> data = Map<String,dynamic>();
    data[Constants.itemsName] = name;
    data[Constants.itemsCategoryId] = categoryId;
    data[Constants.itemsValue] = value;
    data[Constants.itemsDate] = date.millisecondsSinceEpoch;
    await DatabaseHelper.instance.insert(Constants.itemsTable, data);
    //setItem(type);
  }

/*
  void setItem (String table) async{
    _category = await DatabaseHelper.instance.getCategory(id, table);
    _category.type = table;
    _controller.sink.add(_category);
  }
  */

  @override
  void dispose() {
    _controller.close();
  }
}
