import 'package:budget_helper/BLoC/category_screen_bloc.dart';
import 'package:budget_helper/BLoC/bloc_provider.dart';
import 'package:budget_helper/BLoC/app_bloc.dart';
import 'package:budget_helper/DataLayer/models/category.dart';
import 'package:budget_helper/UI/items/item_screen.dart';
import 'package:flutter/material.dart';

class CategoryList extends StatefulWidget {
  final String type;
  CategoryList(this.type);

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  CategoryScreenBloc bloc;
  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<AppBloc>(context).categoryScreenBloc;
    bloc.loadCategories();
    return StreamBuilder<Map<String, List<Category>>>(
        stream: bloc.categoryListStream,
        builder: (context, snapshot) {
          var results = snapshot.data;
          return results == null
              ? Center(child: CircularProgressIndicator())
              : results[widget.type].isEmpty
                  ? Center(child: Text('No Categories yet'))
                  : _buildCategories(results[widget.type]);
        });
  }

  Widget _buildCategories(List<Category> categories) {
    return StreamBuilder<Map<int, double>>(
      stream: bloc.valueBreakdown,
      builder: (context, snapshot) {
        return categories == null
            ? Center(child: Text('No categories yet'))
            : snapshot.data == null
                ? Center(child: CircularProgressIndicator())
                : ListView.separated(
                    itemCount: categories.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(height: 1),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return _buildCustomTile(
                          category, snapshot.data[category.id]);
                    });
      },
    );
  }

  Widget _buildCustomTile(Category category, double value) {
    return InkWell(
        onTap: () {
          pushItemScreen(context, category);
        },
        onDoubleTap: () {
          bloc.deleteCategory(category.id);
        },
        child: Card(
            elevation: 7.0,
            child: new Container(
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.all(6.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        child: new Text(category.name[0].toUpperCase())),
                    Padding(padding: EdgeInsets.only(left: 16.0)),
                    Text(category.name, style: TextStyle(fontSize: 20.0)),
                    Text(value == null ? "0" : value.toString())
                  ],
                ))));
  }

  pushItemScreen(BuildContext context, Category category) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ItemScreen(category);
    }));
    bloc.loadValueBreakdown();
  }
}
