import 'package:budget_helper/DataLayer/DAO/item_DAO.dart';
import 'bloc.dart';
import 'dart:async';
import 'package:budget_helper/DataLayer/models/item.dart';

class ItemBloc implements Bloc {
  final _controller = StreamController<Item>.broadcast();
  Stream<Item> get itemStream => _controller.stream;
  final ItemDAO itemDAO = ItemDAO.instance;

  void saveItem(String name, int categoryId, double value, DateTime date) async {
    await itemDAO.saveItem(name, categoryId, value, date);
  }


  @override
  void dispose() {
    _controller.close();
  }
}
