import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hyella/main.dart';
import 'package:hyella/models/signup_result_model.dart';
import 'package:hyella/providers/auth_provider.dart';
import 'package:hyella/providers/doctor_appointments_list_provider.dart';
import 'package:hyella/providers/messaging_provider.dart';
import 'package:hyella/providers/schedule_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialSetup {
  static void setupSingletons() {
    var getIt = GetIt.instance;

    // register auth provider
    getIt.registerSingleton<AuthProvider>(AuthProvider());
  }

  static void setMessageHandler() {
    SystemChannels.lifecycle.setMessageHandler((msg) async {
      if (msg == AppLifecycleState.resumed.toString()) {
        if (!GetIt.I.isRegistered<UserDetails>() ||
            GetIt.I<UserDetails>().user == null) {
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          sharedPreferences.clear();

          return;
        }

        // user info
        UserDetails userDetails = GetIt.I<UserDetails>();

        if (userDetails.user!.isPatient == 1) {
          Provider.of<ScheduleProvider>(navigatorKey.currentContext!,
                  listen: false)
              .getSchedules();
          Provider.of<ChatHeadsProvider>(navigatorKey.currentContext!,
                  listen: false)
              .getContacts(false);
        } else {
          Provider.of<DoctorAppointmentProvider>(navigatorKey.currentContext!,
                  listen: false)
              .getSchedules();
          Provider.of<ChatHeadsProvider>(navigatorKey.currentContext!,
                  listen: false)
              .getContacts(true);
        }
      }

      return null;
    });
  }
}
