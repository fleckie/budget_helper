//TODO implement item list
//TODO init with calling item_list_bloc load items

import 'package:budget_helper/BLoC/app_bloc.dart';
import 'package:budget_helper/BLoC/bloc_provider.dart';
import 'package:budget_helper/BLoC/item_list_bloc.dart';
import 'package:budget_helper/DataLayer/models/category.dart';
import 'package:budget_helper/DataLayer/models/item.dart';
import 'package:flutter/material.dart';

class ItemList extends StatelessWidget {
  //TODO category in bloc integrieren
  final Category category;
  ItemList(this.category);

  @override
  Widget build(BuildContext context) {
    final itemScreenBloc = BlocProvider.of<AppBloc>(context).itemListBloc;
    final categoryScreenBloc = BlocProvider.of<AppBloc>(context).categoryScreenBloc;
    categoryScreenBloc.dateStream.listen((date){
      itemScreenBloc.loadItems(category.id, date);
    });
    categoryScreenBloc.reSinkDate();


    return StreamBuilder<List<Item>>(
      stream: itemScreenBloc.itemStream,
      builder: (context, snapshot) {
        final results = snapshot.data;
        return results == null
            ? Center(child: CircularProgressIndicator())
            : _buildItems(results);
      },
    );
  }

  Widget _buildItems(List<Item> items) {
    return items.length == 0
        ? Center(child: Text('No items yet'))
        : ListView.separated(
            itemCount: items.length,
            separatorBuilder: (BuildContext context, int index) =>
                Divider(height: 1),
            itemBuilder: (context, index) {
              final item = items[index];
              return InkWell(
                  onTap: () {},
                  onDoubleTap: () {},
                  child: _buildCustomTile(item));
            });
  }

  Widget _buildCustomTile(Item item) {
    final _dateString = "${item.date.day}/${item.date.month}";
    return Card(
        elevation: 7.0,
        child: Container(
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.all(6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                        backgroundColor: Colors.lightGreen,
                        foregroundColor: Colors.white,
                        child: Icon(Icons.mood)),
                    Padding(padding: EdgeInsets.only(left: 16.0)),
                    Text(item.name, style: TextStyle(fontSize: 20.0)),
                  ],
                ),
                Text(_dateString),
                Text(item.value.toString(), style: TextStyle(fontSize: 20.0))
              ],
            )));
  }

  showItemDetails(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Container();
    }));
  }
}
