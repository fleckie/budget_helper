import 'package:budget_helper/BLoC/app_bloc.dart';
import 'package:budget_helper/BLoC/bloc_provider.dart';
import 'package:budget_helper/BLoC/category_screen_bloc.dart';
import 'package:budget_helper/BLoC/item_date_bloc.dart';
import 'package:flutter/material.dart';

import 'BLoC/item_bloc.dart';
import 'BLoC/item_list_bloc.dart';
import 'UI/main_screen.dart';

void main() => runApp(BudgetApp());

class BudgetApp extends StatelessWidget {
  AppBloc _bloc;

  BudgetApp() {
    _bloc = AppBloc();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _bloc,
      child: MaterialApp(
        title: 'Budget',
        theme: ThemeData.light(),
        home: MainScreen(),
      ),
    );
  }
}
