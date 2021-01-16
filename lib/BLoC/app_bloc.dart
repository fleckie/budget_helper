import 'package:budget_helper/BLoC/bloc.dart';
import 'package:budget_helper/BLoC/category_screen_bloc.dart';
import 'package:budget_helper/BLoC/item_bloc.dart';
import 'package:budget_helper/BLoC/item_list_bloc.dart';

class AppBloc implements Bloc {
  CategoryScreenBloc _categoryScreenBloc;
  ItemBloc _itemBloc;
  ItemListBloc _itemListBloc;

  AppBloc() {
    _categoryScreenBloc = CategoryScreenBloc();
    _itemBloc = ItemBloc();
    _itemListBloc = ItemListBloc();
  }

  ItemListBloc get itemListBloc => _itemListBloc;

  ItemBloc get itemBloc => _itemBloc;

  CategoryScreenBloc get categoryScreenBloc => _categoryScreenBloc;

  @override
  void dispose() {
  }
}
