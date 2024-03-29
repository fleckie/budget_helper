import 'package:flutter/foundation.dart';

class Item {
  final int id;
  final int categoryId;
  final String type;
  final String name;
  final double value;
  final DateTime date;

  Item(
      {@required this.id,
      @required this.name,
      @required this.categoryId,
      @required this.type,
      @required this.value,
      this.date});
}
