import 'bloc.dart';
import 'dart:async';
import 'package:budget_helper/DataLayer/date_helper.dart' as dh;

class ItemDateBloc implements Bloc {
  DateTime _date;
  final _controller = StreamController<DateTime>.broadcast();
  Stream<DateTime> get dateStream => _controller.stream;

  Future<void>  initDate() async {
    _date = DateTime.now();
    _controller.sink.add(DateTime.now());
  }

  void setDate(DateTime date) {
    _date = date;
    _controller.sink.add(_date);
  }

  @override
  void dispose() {
    _controller.close();
  }
}
