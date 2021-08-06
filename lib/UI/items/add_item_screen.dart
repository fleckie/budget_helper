import 'package:budget_helper/BLoC/app_bloc.dart';
import 'package:budget_helper/BLoC/bloc_provider.dart';
import 'package:budget_helper/BLoC/category_screen_bloc.dart';
import 'package:budget_helper/BLoC/item_bloc.dart';
import 'package:budget_helper/DataLayer/models/category.dart';
import 'package:budget_helper/DataLayer/models/item.dart';
import 'package:budget_helper/UI/items/category_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:budget_helper/DataLayer/date_helper.dart' as dh;

class AddItemScreen extends StatefulWidget {
  final Category presetCategory;
  final Item item;

  AddItemScreen(this.presetCategory, [this.item]);

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  CategoryScreenBloc _categoryScreenBlock;
  ItemBloc _itemBloc;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController valueController = TextEditingController();
  DateTime _date;
  String _headline;
  String _buttonText;
  StreamSubscription subscription;
  Category _currentCategory;

  @override
  void initState() {
    super.initState();
    _itemBloc = BlocProvider.of<AppBloc>(context).itemBloc;
    _categoryScreenBlock = BlocProvider.of<AppBloc>(context).categoryScreenBloc;
    if (widget.item == null) {
      initializeDate();
      setState(() {
        _currentCategory = widget.presetCategory;
        nameController.text = widget.presetCategory.name;
        _headline = 'Add an Item';
        _buttonText = 'Add Item';
      });
    } else {
      setState(() {
        _currentCategory = widget.presetCategory;
        _date = widget.item.date;
        nameController.text = widget.item.name;
        valueController.text = widget.item.value.toString();
        _headline = 'Edit Item';
        _buttonText = 'Update Item';
      });
    }
  }

  //hook up the stream containing the currentMonth and resink the data there
  void initializeDate() {
    subscription = _categoryScreenBlock.dateStream.listen(onData);
    _categoryScreenBlock.reSinkDate();
  }

  //sets the date to the current date, if the user is adding items in the current month.
  //otherwise the first day of the currently displayed month is set
  void onData(String date) {
    setState(() {
      _date = date == dh.convertDateToString(DateTime.now())
          ? DateTime.now()
          : dh.convertStringToDate(date);
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  //date picker
  Future<void> pickDate() async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
    );
    picked != null
        ? setState(() => _date = picked)
        : showCustomSnackBar(context, "No Date picked");
  }

  //checks input before committing an item
  checkInput(BuildContext context) {
    (nameController.text.isEmpty || valueController.text.isEmpty)
        ? showCustomSnackBar(context, 'No empty fields')
        : double.tryParse(valueController.text) == null
            ? showCustomSnackBar(context, 'Value is not a number!')
            : saveItem();
  }

  showCustomSnackBar(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.redAccent,
        content: new Text(
          message,
          textAlign: TextAlign.center,
        )));
  }

  void saveItem() {
    if (widget.item == null) {
      _itemBloc.saveItem(nameController.text, _currentCategory.id,
          _currentCategory.type, double.parse(valueController.text), _date);
    } else {
      _itemBloc.saveItem(
          nameController.text,
          _currentCategory.id,
          _currentCategory.type,
          double.parse(valueController.text),
          _date,
          widget.item.id);
    }
    _categoryScreenBlock.setDate(_date);
    Navigator.of(context).pop();
  }

  void deleteItem() {
    _itemBloc.deleteItem(widget.item.id);
    _categoryScreenBlock.reSinkDate();
    Navigator.of(context).pop();
  }

  void categoryPickerCallback(Category newCategory) {
    setState(() => _currentCategory = newCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(_headline),
          actions: <Widget>[
            widget.item != null
                ? IconButton(
                    onPressed: () => deleteItem(),
                    icon: Icon(Icons.delete),
                    tooltip: "Delete this item",
                  )
                : Container()
          ],
        ),
        body: _date == null
            ? Center(child: CircularProgressIndicator())
            : Container(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 32.0,
                    ),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: TextField(
                            controller: nameController,
                            decoration: new InputDecoration(
                              labelText: 'Name the item',
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: TextField(
                          controller: valueController,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          decoration: new InputDecoration(
                            labelText: 'Value',
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Center(
                              child: Column(
                            children: <Widget>[
                              Text(
                                  '${_date.day.toString()} / ${_date.month.toString()} / ${_date.year.toString()}'),
                              RaisedButton(
                                  onPressed: () {
                                    pickDate();
                                  },
                                  child: Text('Pick a date'))
                            ],
                          ))),
                      CategoryPicker(
                        widget.presetCategory,
                        categoryPickerCallback,
                        widget.item,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Builder(builder: (BuildContext context) {
                          return RaisedButton(
                            onPressed: () => checkInput(context),
                            color: Colors.indigoAccent,
                            child: Text(_buttonText),
                          );
                        }),
                      )
                    ]))));
  }
}
