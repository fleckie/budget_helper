import 'package:flutter/material.dart';

showCustomSnackBar(BuildContext context, String message){
  Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.redAccent,
      content: new Text(
        message,
        textAlign: TextAlign.center,
      )));
}