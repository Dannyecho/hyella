import 'package:flutter/material.dart';

Color getColor(int? star) {
  switch (star) {
    case 1:
      return Colors.red;
    case 2:
      return Colors.redAccent;
    case 3:
      return Colors.blue;
    case 4:
      return Colors.grey;
    case 5:
      return Colors.orangeAccent;
    default:
      return Colors.orange;
  }
}
