import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils {
  static void showToast(String msg, Color backgroundColor, Color textColor, ToastGravity toastGravity) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: toastGravity,
        timeInSecForIosWeb: 1,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: 16.0);
  }

  static void info(String msg) {
    showToast(msg, Colors.black, Colors.white, ToastGravity.SNACKBAR);
  }

  static void error(String msg) {
    showToast(msg, Colors.red, Colors.white, ToastGravity.SNACKBAR);
  }

  static void success(String msg) {
    showToast(msg, Colors.green, Colors.white, ToastGravity.SNACKBAR);
  }

  static void warning(String msg) {
    showToast(msg, Colors.orange, Colors.white, ToastGravity.SNACKBAR);
  }
}
