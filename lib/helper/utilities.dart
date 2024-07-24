import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:hyella/helper/constants.dart';
import 'package:hyella/main.dart';
import 'package:hyella/models/initial_data.dart';
import 'package:hyella/models/signup_result_model.dart';
import 'package:hyella/providers/auth_provider.dart';
import 'package:hyella/screens/patient_screens/auth/signin.dart';
import 'package:provider/provider.dart';

class Utilities {
  static String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  static String generateMd5ForApiAuth(String nwpRequest) {
    InitialData endPoints = GetIt.I<InitialData>();
    UserDetails? userDetails =
        GetIt.I.isRegistered<UserDetails>() ? GetIt.I<UserDetails>() : null;
    String cid = endPoints.client!.id!;
    return md5
        .convert(utf8.encode("$token$cid${userDetails?.user?.pid}$nwpRequest"))
        .toString();
  }

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static bool responseIsSuccessfull(Response response) {
    if (response.statusCode == 401) {
      // log user out
      Provider.of<AuthProvider>(navigatorKey.currentContext!, listen: false)
          .logout();

      Navigator.pushReplacement(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => SignIn(),
        ),
      );
      return false;
    }

    return ((response.statusCode == 200 || response.statusCode == 201) &&
        jsonDecode(response.body)['type'] == 1);
  }

  static Future<String?> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
    return null;
  }
}
