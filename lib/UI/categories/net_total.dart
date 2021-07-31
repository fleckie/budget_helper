import 'package:budget_helper/BLoC/app_bloc.dart';
import 'package:budget_helper/BLoC/bloc_provider.dart';
import 'package:flutter/material.dart';

class NetTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AppBloc>(context).categoryScreenBloc;
    bloc.loadNetTotal();
    return StreamBuilder<Map<String, double>>(
        stream: bloc.netTotalStream,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? CircularProgressIndicator()
              : Container(
                  child: Column(
                  children: <Widget>[
                    Text(
                        "Net Worth at the end of the month: ${snapshot.data['overall']}"),
                    Text("Net Worth for this month: ${snapshot.data['month']}")
                  ],
                ));
        });
  }
}
