import 'dart:math';

import 'package:flutter/widgets.dart';

const baseUrl = "http://telehealthapi.openclass.ng/";
const userData = "userData";
//MediaQuery Width
double deviceWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

//MediaQuery Height
double deviceHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

final String END_POINT = 'endPoint';
final String USER_DETAILS = 'Data';
final String SUCCESS = 'success';
final String token = (Random().nextInt(90000000) + 100000000).toString();

final String chatKeyDelimeter = "****key****";
final String fileChatTypeDelimeter = "####file####";
final String textChatTypeDelimeter = "####text####";
final String imageChatTypeDelimeter = "####image####";
final String receiptChatTypeDelimeter = "####receipt####";
final String deleteChatTypeDelimeter = "####delete####";
