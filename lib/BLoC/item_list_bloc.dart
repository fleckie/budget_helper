import 'package:budget_helper/DataLayer/database/database_helper.dart';
import 'package:budget_helper/DataLayer/models/item.dart';
import 'bloc.dart';
import 'dart:async';
import 'package:budget_helper/DataLayer/date_helper.dart' as dh;

//TODO Type ist bei getCategory - Abfrage NULL.

class ItemListBloc implements Bloc {
  final _controller = StreamController<List<Item>>.broadcast();
  ItemListBloc();
  Stream<List<Item>> get itemStream => _controller.stream;

  void loadItems(int id, String date) async {

    final int startOfMonth = dh.convertStringToDate(date).millisecondsSinceEpoch;
    final int endOfMonth = dh.convertStringToDate(dh.convertToStartOfNextMonth(date)).millisecondsSinceEpoch;

    final itemList = await DatabaseHelper.instance.getItemsInCategory(id, startOfMonth, endOfMonth);
    _controller.sink.add(itemList);
  }

  @override
  void dispose() {
    _controller.close();
  }
}
