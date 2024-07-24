import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hyella/helper/constants.dart';
import 'package:hyella/helper/route_generator.dart';
import 'package:hyella/models/initial_data.dart';
import 'package:hyella/models/signup_result_model.dart';
import 'package:hyella/providers/initial_data_provider.dart';
import 'package:hyella/providers/auth_provider.dart';
import 'package:hyella/providers/color_provider.dart';
import 'package:hyella/screens/network_error_screen.dart';
import 'package:hyella/screens/patient_screens/auth/signin.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

ValueNotifier<bool> navigate = ValueNotifier(false);

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer.run(() {
      fetchResources();
    });
  }

  fetchResources() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      late InitialData endpoints;
      // get the endpoints from the provided api endpoint
      Provider.of<InitialRequestProvider>(context, listen: false)
          .getInitialEndpoints()
          .then(
        (value) {
          value.fold(
            (l) async {
              // get endpoints from the sharedpreferences
              String? encodedEndpoints = sharedPreferences.getString(END_POINT);
              // set colors and name if there is any stored info
              String? encodedUserData =
                  sharedPreferences.getString(USER_DETAILS);
              bool isLoggedIn =
                  (encodedUserData != null && encodedUserData.isNotEmpty);

              if (encodedEndpoints != null) {
                // there must be a stored initial data then
                InitialData decodedEndPoints =
                    InitialData.fromJson(jsonDecode(encodedEndpoints));
                //set the colors and app name
                Provider.of<ColorNameProvider>(context, listen: false)
                    .setColors(
                        decodedEndPoints.client!.color1!,
                        decodedEndPoints.client!.color2!,
                        decodedEndPoints.client!.color3!,
                        decodedEndPoints.client!.color4!,
                        decodedEndPoints.client!.color5!,
                        decodedEndPoints.client!.color6!,
                        decodedEndPoints.client!.name!);

                if (isLoggedIn) {
                  UserDetails userDetails =
                      UserDetails.fromJson(jsonDecode(encodedUserData));
                  // set the user details
                  await Provider.of<AuthProvider>(context, listen: false)
                      .setInitialData(decodedEndPoints, userDetails);

                  if (mounted) {
                    Navigator.of(context).pushReplacementNamed(
                      (userDetails.user!.isPatient == 1)
                          ? HOME_PAGE
                          : DOCTOR_HOME,
                    );
                  }
                } else {
                  // set only endpoints
                  await Provider.of<AuthProvider>(context, listen: false)
                      .setInitialData(decodedEndPoints, null);
                  if (mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => SignIn(),
                          settings: RouteSettings(name: "signIn")),
                    );
                  }
                }
              } else {
                if (mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => NetworkError(),
                        settings: RouteSettings(name: "networkError")),
                  );
                }
              }
            },
            (r) async {
              endpoints = r;
              // check if user is logged in by checking for previously cached user data
              String? userData = sharedPreferences.getString(USER_DETAILS);
              bool isLoggedIn = userData != null && userData.isNotEmpty;

              await Provider.of<ColorNameProvider>(context, listen: false)
                  .setColors(
                      endpoints.client!.color1!,
                      endpoints.client!.color2!,
                      endpoints.client!.color3!,
                      endpoints.client!.color4!,
                      endpoints.client!.color5!,
                      endpoints.client!.color6!,
                      endpoints.client!.name!);

              if (isLoggedIn) {
                // get user details from shared preference
                UserDetails userDetails = UserDetails.fromJson(
                  jsonDecode(userData),
                );

                await Provider.of<AuthProvider>(context, listen: false)
                    .setInitialData(endpoints, userDetails);

                if (mounted) {
                  Navigator.of(context).pushReplacementNamed(
                    (userDetails.user!.isPatient == 1)
                        ? HOME_PAGE
                        : DOCTOR_HOME,
                  );
                }
              } else {
                await Provider.of<AuthProvider>(context, listen: false)
                    .setInitialData(endpoints, null);
                if (mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => SignIn(),
                        settings: RouteSettings(name: "signIn")),
                  );
                }
              }
            },
          );
        },
      );
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => SignIn(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset(
                "assets/splash.jpg",
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
