import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';



class FlushbarUtil {
  static void showSuccess(BuildContext context, String message) {
    Flushbar(
      message: message,
      duration: Duration(seconds: 3),
      backgroundColor: Colors.green,
      margin: EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.TOP,

      mainButton: IconButton(
        icon: const Icon(Icons.close, color: Colors.white),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ).show(context);
  }

  static void showError(BuildContext context, String message) {
    Flushbar(
      message: message,
      duration: Duration(seconds: 3),
      backgroundColor: Colors.red,
      margin: EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.TOP,

      mainButton: IconButton(
        icon: const Icon(Icons.close, color: Colors.white),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ).show(context);
  }
}