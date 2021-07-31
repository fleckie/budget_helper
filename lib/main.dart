import 'package:budget_helper/BLoC/app_bloc.dart';
import 'package:budget_helper/BLoC/bloc_provider.dart';
import 'package:flutter/material.dart';

import 'UI/main_screen.dart';

void main() => runApp(BudgetApp());

class BudgetApp extends StatelessWidget {
  AppBloc _bloc;

  BudgetApp() {
    final _bloc = AppBloc();
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
