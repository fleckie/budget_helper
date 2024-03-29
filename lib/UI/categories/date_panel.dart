import 'package:budget_helper/BLoC/app_bloc.dart';
import 'package:budget_helper/BLoC/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:budget_helper/DataLayer/date_helper.dart' as dh;

class DatePanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AppBloc>(context).categoryScreenBloc;
    return StreamBuilder<String>(
        stream: bloc.dateStream,
        initialData: dh.convertDateToString(DateTime.now()),
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
