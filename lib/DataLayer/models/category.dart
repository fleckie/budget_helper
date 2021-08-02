import 'package:flutter/foundation.dart';

class Category {
  final int id;
  final String name;
  String type;
  int color;
  Category(@required this.id, @required this.name, this.type, this.color);

  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'name': name,
  //   };
  // }
}
