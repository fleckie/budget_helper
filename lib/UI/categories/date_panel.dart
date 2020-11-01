import 'package:budget_helper/BLoC/bloc_provider.dart';
import 'package:budget_helper/BLoC/category_screen_bloc.dart';
import 'package:flutter/material.dart';

class DatePanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CategoryScreenBloc>(context);
    return StreamBuilder<String>(
        stream: bloc.dateStream,
        builder: (context, snapshot) {
          String date = snapshot.data;
          return Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    onPressed: () => bloc.previousMonth(),
                    icon: Icon(Icons.chevron_left,
                        color: ThemeData.light().buttonColor),
                  ),
                  Text(date != null ? date : "Loading Date"),
                  IconButton(
                    onPressed: () => bloc.nextMonth(),
                    icon: Icon(Icons.chevron_right,
                        color: ThemeData.light().buttonColor),
                  )
                ],
              ));
        });
  }
}
