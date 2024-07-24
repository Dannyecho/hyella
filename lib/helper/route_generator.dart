import 'package:flutter/material.dart';
import 'package:hyella/screens/chat/chat.dart';
import 'package:hyella/screens/network_error_screen.dart';
import 'package:hyella/screens/doctor_screens/main_nav_screens/provider_home_screen.dart';
import 'package:hyella/screens/splash_screen.dart';

import '../screens/patient_screens/main_nav/homepage.dart';

const String HOME_PAGE = '/home';
const String DOCTOR_HOME = "/doctorHome";
const String INITIAL_PAGE = '/';
const String SETTING_PAGE = '/setting';
const String SIGN_IN_PAGE = '/signin';
const String DOCTOR_DETAILS = '/doctor_details';
const String NETWORK_ERROR = '/network_erro';
const String CHAT = '/chat';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;
    switch (settings.name) {
      case INITIAL_PAGE:
        return MaterialPageRoute(
          builder: (_) {
            return SplashScreen();
          },
          settings: RouteSettings(name: "splash"),
        );

      case CHAT:
        return MaterialPageRoute(
          builder: (_) {
            final args = settings.arguments as Map;
            return Chat(
              chatKey: args['key'],
              pid: args['pid'],
              isDoctor: args['is_doctor'],
              channelId: args['channel_id'],
              receiverId: args['receiver_id'],
              receiverName: args['receiver_name'],
            );
          },
          settings: RouteSettings(name: "splash"),
        );

      case NETWORK_ERROR:
        return MaterialPageRoute(
            builder: (_) {
              return NetworkError();
            },
            settings: RouteSettings(name: "networkError"));
      case DOCTOR_HOME:
        return MaterialPageRoute(
            builder: (_) {
              return ProviderHome();
            },
            settings: RouteSettings(name: "doctorHome"));
      // case DOCTOR_DETAILS:
      //   final args = settings.arguments as Doctor;
      //   return MaterialPageRoute(
      //       builder: (_) {
      //         return DoctorDetail(
      //           doctor: args,
      //         );
      //       },
      //       settings: RouteSettings(name: "doctorDetails"));
      case HOME_PAGE:
        return MaterialPageRoute(
            builder: (_) => HomePage(),
            settings: RouteSettings(name: "patientHome"));

      default:
        return MaterialPageRoute(
          builder: (_) => Container(),
        );
    }
  }
}
