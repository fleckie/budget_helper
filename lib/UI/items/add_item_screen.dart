import 'package:budget_helper/BLoC/app_bloc.dart';
import 'package:budget_helper/BLoC/bloc_provider.dart';
import 'package:budget_helper/DataLayer/models/category.dart';
import 'package:budget_helper/DataLayer/models/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:budget_helper/DataLayer/date_helper.dart' as dh;

class AddItemScreen extends StatefulWidget {
  final Category category;
  final Item item;

  AddItemScreen(this.category, [this.item]);

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController valueController = TextEditingController();
  DateTime _date;
  StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    if (widget.item == null) {
      initializeDate();
      nameController.text = widget.category.name;
    } else {
      _date = widget.item.date;
      nameController.text = widget.item.name;
      valueController.text = widget.item.value.toString();
    }
  }

  //hook up the stream containing the currentMonth and resink the data there
  void initializeDate() {
    subscription = BlocProvider.of<AppBloc>(context)
        .categoryScreenBloc
        .dateStream
        .listen(onData);
    BlocProvider.of<AppBloc>(context).categoryScreenBloc.reSinkDate();
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

  saveItem() {
    final bloc = BlocProvider.of<AppBloc>(context).itemBloc;
    if (widget.item == null) {
      bloc.saveItem(nameController.text, widget.category.id,
          widget.category.type, double.parse(valueController.text), _date);
    } else {
      bloc.saveItem(
          nameController.text,
          widget.category.id,
          widget.category.type,
          double.parse(valueController.text),
          _date,
          widget.item.id);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text('Add a new Item')),
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
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Builder(builder: (BuildContext context) {
                          return RaisedButton(
                            onPressed: () => checkInput(context),
                            color: Colors.indigoAccent,
                            child: Text('Add Item'),
                          );
                        }),
                      )
                    ]))));
  }
}
