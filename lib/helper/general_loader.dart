import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget generalLoader() {
  return Center(
    child: Platform.isAndroid
        ?const CircularProgressIndicator()
        : const CupertinoActivityIndicator(),
  );
}