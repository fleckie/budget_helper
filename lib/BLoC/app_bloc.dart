import 'package:budget_helper/BLoC/bloc.dart';
import 'package:budget_helper/BLoC/category_screen_bloc.dart';
import 'package:budget_helper/BLoC/item_bloc.dart';
import 'package:budget_helper/BLoC/item_date_bloc.dart';
import 'package:budget_helper/BLoC/item_list_bloc.dart';

class AppBloc implements Bloc {
  CategoryScreenBloc _categoryScreenBloc;
  ItemBloc _itemBloc;
  ItemDateBloc _itemDateBloc;
  ItemListBloc _itemListBloc;

  AppBloc() {
    _categoryScreenBloc = CategoryScreenBloc();
    _itemBloc = ItemBloc();
    _itemDateBloc = ItemDateBloc();
    _itemListBloc = ItemListBloc();
  }

  ItemListBloc get itemListBloc => _itemListBloc;

  ItemDateBloc get itemDateBloc => _itemDateBloc;

  ItemBloc get itemBloc => _itemBloc;

  CategoryScreenBloc get categoryScreenBloc => _categoryScreenBloc;

  @override
  void dispose() {
  }
}
