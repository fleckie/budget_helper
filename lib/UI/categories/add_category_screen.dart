import 'package:budget_helper/BLoC/bloc_provider.dart';
import 'package:budget_helper/BLoC/category_screen_bloc.dart';
import 'package:budget_helper/DataLayer/models/category.dart';
import 'package:flutter/material.dart';


//TODO Snackbar verallgemeinern

class AddCategoryScreen extends StatefulWidget {
  AddCategoryScreen();

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategoryScreen> {
  final TextEditingController controller = TextEditingController();
  bool _expense = false;

  void addCategory(BuildContext context) async {
    if (controller.text.isEmpty) {
      showCustomSnackBar(context, "Please enter a name for the category");
    } else {
      String type = _expense ? "Expenses" : "Incomes";
      final categoryBloc = BlocProvider.of<CategoryScreenBloc>(context);
      try {
        await categoryBloc.saveCategory(controller.text, type);
      }catch (e){
        showCustomSnackBar(context, "Oops.. Something went wrong. Please try again");
      }
      Navigator.of(context).pop();
    }
  }

  showCustomSnackBar(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.redAccent,
        content: new Text(
          message,
          textAlign: TextAlign.center,
        )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Add a new Category')),
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
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                          children: <Widget>[
                            Checkbox(
                                value: _expense,
                                onChanged: (bool value) {
                                  setState(() => _expense = value);
                                }),
                            Text("Category for Expenses?"),
                          ],
                        )),
                  Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Builder(builder: (BuildContext context) {
                        return RaisedButton(
                          onPressed: () => addCategory(context),
                          color: Colors.indigoAccent,
                          child: Text('Add Category'),
                        );
                      }))
                ]))));
  }
}
