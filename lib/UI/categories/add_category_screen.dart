import 'package:budget_helper/BLoC/app_bloc.dart';
import 'package:budget_helper/BLoC/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:budget_helper/UI/helpers/custom_snack_bar.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:budget_helper/DataLayer/models/category.dart';

class AddCategoryScreen extends StatefulWidget {
  AddCategoryScreen([this.category]);

  final Category category;

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategoryScreen> {
  final TextEditingController controller = TextEditingController();
  String _headline;
  String _buttonText;
  bool _expense;
  String _type;
  Color _currentColor;

  @override
  void initState() {
    super.initState();
    if (widget.category == null) {
      setState(() {
        _headline = 'Add a New Category';
        _buttonText = 'Add category';
        _expense = false;
        _type = 'Incomes';
        _currentColor = Colors.blueAccent;
      });
    } else {
      setState(() {
        controller.text = widget.category.name;
        _headline = 'Edit Category';
        _buttonText = 'Update Category';
        _expense = widget.category.type == 'Expenses' ? true : false;
        _type = widget.category.type;
        _currentColor = Color(widget.category.color);
      });
    }
  }

  void saveCategory(BuildContext context) async {
    if (controller.text.isEmpty) {
      showCustomSnackBar(context, "Please enter a name for the category");
    } else {
      final categoryBloc = BlocProvider.of<AppBloc>(context).categoryScreenBloc;
      try {
        if (widget.category == null) {
          await categoryBloc.saveCategory(
              controller.text, _type, _currentColor.value);
        } else {
          await categoryBloc.updateCategory(
              widget.category.id, controller.text, _type, _currentColor.value);
        }
      } catch (e) {
        showCustomSnackBar(
            context, "Oops.. Something went wrong. Please try again");
      }
      Navigator.of(context).pop();
    }
  }

  void toggle(bool value) {
    setState(() => _expense = value);
    String type = _expense == true ? 'Expenses' : 'Incomes';
    setState(() => _type = type);
    print(_currentColor.value);
  }

  void changeColor(Color color) => setState(() => _currentColor = color);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text(_headline)),
        body: Container(
            child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 32.0,
                ),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextField(
                        controller: controller,
                        decoration: new InputDecoration(
                          labelText: 'Name the Category',
                        )),
                  ),
                  // Color Picker
                  Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                      child: Container(
                          width: 80,
                          height: 80,
                          margin: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            // borderRadius: BorderRadius.circular(50.0),
                            color: _currentColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: _currentColor.withOpacity(0.8),
                                offset: Offset(1.0, 2.0),
                                blurRadius: 3.0,
                              ),
                            ],
                          ),
                          child: InkWell(onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Select a color'),
                                    content: SingleChildScrollView(
                                      child: BlockPicker(
                                        pickerColor: _currentColor,
                                        onColorChanged: changeColor,
                                      ),
                                    ),
                                  );
                                });
                          }))),
                  Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Switch(
                              value: _expense,
                              onChanged: widget.category == null
                                  ? (bool value) {
                                      toggle(value);
                                    }
                                  : null),
                          Text(_type),
                        ],
                      )),
                  Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Builder(builder: (BuildContext context) {
                        return RaisedButton(
                          onPressed: () => saveCategory(context),
                          color: Colors.indigoAccent,
                          child: Text(_buttonText),
                        );
                      }))
                ]))));
  }
}
