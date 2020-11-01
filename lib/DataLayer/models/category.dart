import 'package:flutter/foundation.dart';

class Category {
  final int id;
  final String name;
  String type;
  Category(@required this.id, @required this.name, this.type);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
