import 'package:budget_helper/BLoC/app_bloc.dart';
import 'package:budget_helper/BLoC/bloc_provider.dart';
import 'package:budget_helper/BLoC/item_bloc.dart';
import 'package:budget_helper/BLoC/item_date_bloc.dart';
import 'package:budget_helper/DataLayer/models/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class AddItemScreen extends StatefulWidget {
  final Category category;
  AddItemScreen(this.category);
  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController valueController = TextEditingController();
  DateTime _pickedDate;
  StreamSubscription subscription;
  ItemDateBloc itemDateBloc;

  addItem(BuildContext context, DateTime date) {
    (nameController.text.isEmpty || valueController.text.isEmpty)
        ? showCustomSnackBar(context, 'No empty fields')
        : double.tryParse(valueController.text) == null
            ? showCustomSnackBar(context, 'Value is not a number!')
            : commitItem(date);
  }

  showCustomSnackBar(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.redAccent,
        content: new Text(
          message,
          textAlign: TextAlign.center,
        )));
  }

  commitItem(DateTime date) {
    final bloc = BlocProvider.of<AppBloc>(context).itemBloc;
    bloc.saveItem(nameController.text, widget.category.id,
        double.parse(valueController.text), date);
    Navigator.of(context).pop();
  }

  Future<void> pickDate(DateTime initialDate) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
    );
    picked != null
        ? BlocProvider.of<AppBloc>(context).itemDateBloc.setDate(picked)
        : showCustomSnackBar(context, "No Date picked");
  }

  @override
  void initState() {
    nameController.text = widget.category.name;
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    subscription?.cancel();
    await listen();
    initDate();
    super.didChangeDependencies();
  }

  Future<void> listen() async {
    itemDateBloc = BlocProvider.of<AppBloc>(context).itemDateBloc;
    subscription = itemDateBloc.dateStream.listen((date) {
      setState(() {
        date == null ? _pickedDate = DateTime.now() : _pickedDate = date;
      });
    });
  }

  Future<void> initDate() async {
    await itemDateBloc.initDate();
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text('Add a new Item')),
        body: _pickedDate == null
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
                          keyboardType: TextInputType.number,
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
                                  '${_pickedDate.day.toString()} / ${_pickedDate.month.toString()} / ${_pickedDate.year.toString()}'),
                              RaisedButton(
                                  onPressed: () {
                                    pickDate(_pickedDate);
                                  },
                                  child: Text('Pick a date'))
                            ],
                          ))),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Builder(builder: (BuildContext context) {
                          return RaisedButton(
                            onPressed: () => addItem(context, _pickedDate),
                            color: Colors.indigoAccent,
                            child: Text('Add Item'),
                          );
                        }),
                      )
                    ]))));
  }
}
