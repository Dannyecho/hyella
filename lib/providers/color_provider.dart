import 'package:flutter/material.dart';

class ColorNameProvider extends ChangeNotifier {
  String primaryColor = '7684FF';
  String secondaryColor = 'ff80ab';
  String tertiaryColor = 'e4e5e9';
  String color4 = "a00245";
  String color5 = "a00245";
  String color6 = "119040";
  String name = 'hyella';

  Future<void> setColors(String color1, String color2, String color3,
      String color4, String color5, String color6, String hospitalName) async {
    try {
      primaryColor = color1;
      secondaryColor = color2;
      tertiaryColor = color3;
      this.color4 = color4;
      this.color5 = color5;
      this.color6 = color6;
      name = hospitalName;

      notifyListeners();
    } on Exception {

    }
  }
}
