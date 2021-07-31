import 'package:budget_helper/BLoC/app_bloc.dart';
import 'package:budget_helper/BLoC/bloc_provider.dart';
import 'package:budget_helper/UI/categories/add_category_screen.dart';
import 'package:budget_helper/UI/categories/category_list.dart';
import 'package:budget_helper/UI/categories/date_panel.dart';
import 'package:budget_helper/UI/categories/net_total.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AppBloc>(context).categoryScreenBloc;
    bloc.initDate();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            title: NetTotal(),
            bottom: TabBar(tabs: [
              Tab(icon: Text("Expenses")),
              Tab(icon: Text("Income"))
            ])),
        body: Column(
          children: <Widget>[
            DatePanel(),
            Expanded(
              //TODO: set local state variable and pass it instead of hardcoded string
              child: TabBarView(children: [
                CategoryList("Expenses"),
                CategoryList("Incomes")
              ]),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              pushAddCategoryScreen(context);
            },
            child: Icon(Icons.add),
            tooltip: 'Add a category'),
        //bottomNavigationBar: null,
      ),
    );
  }

  pushAddCategoryScreen(BuildContext context) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddCategoryScreen();
    }));
    BlocProvider.of<AppBloc>(context).categoryScreenBloc.updateScreen();
  }
}
