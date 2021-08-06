import 'package:budget_helper/DataLayer/DAO/item_DAO.dart';
import 'bloc.dart';
import 'dart:async';
import 'package:budget_helper/DataLayer/models/item.dart';

class ItemBloc implements Bloc {
  final _controller = StreamController<Item>.broadcast();

  Stream<Item> get itemStream => _controller.stream;
  final ItemDAO itemDAO = ItemDAO.instance;

  void saveItem(
      String name, int categoryId, String type, double value, DateTime date,
      [int id]) async {
    if (id == null) {
      await itemDAO.saveItem(name, categoryId, type, value, date);
    } else {
      await itemDAO.saveItem(name, categoryId, type, value, date, id);
    }
  }

  void deleteItem(int id) async {
    await itemDAO.deleteItem(id);
  }

  @override
  void dispose() {
    _controller.close();
  }
}
