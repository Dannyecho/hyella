import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showSnackbar(String title, bool isSuccess) {
  return Fluttertoast.showToast(
      msg: title,
      backgroundColor: isSuccess ? Colors.green :  Colors.red[600],
      gravity: ToastGravity.CENTER,
      toastLength: Toast.LENGTH_LONG);
}
