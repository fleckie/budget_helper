import 'package:budget_helper/BLoC/app_bloc.dart';
import 'package:budget_helper/BLoC/bloc_provider.dart';
import 'package:budget_helper/DataLayer/models/category.dart';
import 'package:budget_helper/UI/items/add_item_screen.dart';
import 'package:budget_helper/UI/items/item_list.dart';
import 'package:flutter/material.dart';

class ItemScreen extends StatelessWidget {
  final Category category;
  ItemScreen(this.category);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category.name),
      actions: <Widget>[
        IconButton (
          onPressed: (){},
          icon: Icon(Icons.settings),
          tooltip: "Edit Category",
        )
      ],),
      body: ItemList(category),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            pushAddItemScreen(context, category);
          },
          child: Icon(Icons.add),
          tooltip: "Add a new item"),
    );
  }

  pushAddItemScreen(BuildContext context, Category category) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddItemScreen(category);
    }));
    final categoryScreenBloc = BlocProvider.of<AppBloc>(context).categoryScreenBloc;
    categoryScreenBloc.reSinkDate();
  }
}
