import 'dart:async';
import 'dart:ui';

import 'package:budget_helper/DataLayer/models/category.dart';
import 'package:budget_helper/DataLayer/models/item.dart';
import 'package:flutter/material.dart';
import 'package:budget_helper/BLoC/app_bloc.dart';
import 'package:budget_helper/BLoC/category_screen_bloc.dart';
import 'package:budget_helper/BLoC/bloc_provider.dart';

class CategoryPicker extends StatefulWidget {
  final Category category;
  final callback;
  final Item item;
  CategoryPicker(this.category, this.callback, [this.item]);

  @override
  _CategoryPickerState createState() {
    return _CategoryPickerState();
  }
}

class _CategoryPickerState extends State<CategoryPicker> {
  List<Category> _categoryList;
  Category _currentCategory;
  StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    hookupCategoryStream();
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
  }

  void hookupCategoryStream(){
    CategoryScreenBloc bloc =
        BlocProvider.of<AppBloc>(context).categoryScreenBloc;
    subscription = bloc.categoryListStream.listen(onData);
    bloc.loadCategories();
  }

  void onData(Map<String, List<Category>> results) {
    List<Category> categoryList = results[widget.category.type];
    Category currentCategory;
    currentCategory = categoryList
        .firstWhere((e) => e.id == widget.category.id);
    setState(() {
      _categoryList = categoryList;
      _currentCategory = currentCategory;});
  }

  void changeCategory (Category newCategory){
    setState(() => _currentCategory = newCategory);
    widget.callback(newCategory);
  }

  @override
  Widget build(BuildContext context) {
    return _currentCategory == null
              ? Center(child: CircularProgressIndicator())
              : _buildCategoryPicker();
  }

  _buildCategoryPicker() {
    return DropdownButton<Category>(
      value: _currentCategory,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      onChanged: (Category newCategory) {
        changeCategory(newCategory);
      },
      items: _categoryList.map<DropdownMenuItem<Category>>((Category category) {
        return DropdownMenuItem<Category>(
          value: category,
          child: Text(category.name),
        );
      }).toList(),
    );
  }
}
