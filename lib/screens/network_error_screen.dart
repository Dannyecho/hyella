import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hyella/helper/constants.dart';
import 'package:hyella/helper/dialog.dart';
import 'package:hyella/helper/scaffold_messg.dart';
import 'package:hyella/models/initial_data.dart';
import 'package:hyella/providers/auth_provider.dart';
import 'package:hyella/providers/initial_data_provider.dart';
import 'package:hyella/providers/color_provider.dart';
import 'package:hyella/screens/patient_screens/auth/signin.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkError extends StatefulWidget {
  NetworkError({Key? key}) : super(key: key);

  @override
  _NetworkErrorState createState() => _NetworkErrorState();
}

class _NetworkErrorState extends State<NetworkError> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoaderOverlay(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 300,
                width: 300,
                child: Image.asset(
                  'assets/network_error.jpg',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "No Signal",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              Text(
                "No Internet Connection \n Please Try Again",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width * .5,
                child: ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blue[700]),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          15.0,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    fetchResources(context);
                  },
                  child: Text(
                    "Refresh",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchResources(BuildContext context) async {
    try {
      DialogUtil.showLoadingDialog(context);
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      InitialData? endpoints;
      // get the endpoints from the provided api endpoint
      Provider.of<InitialRequestProvider>(context, listen: false)
          .getInitialEndpoints()
          .then(
        (value) {
          value.fold(
            (l) {
              DialogUtil.dismissLoadingDialog(context);
            },
            (r) {
              endpoints = r;

              if (endpoints != null) {
                Provider.of<ColorNameProvider>(context, listen: false)
                    .setColors(
                  endpoints!.client!.color1!,
                  endpoints!.client!.color2!,
                  endpoints!.client!.color3!,
                  endpoints!.client!.color4!,
                  endpoints!.client!.color5!,
                  endpoints!.client!.color6!,
                  endpoints!.client!.name!,
                );

                // set initial data
                Provider.of<AuthProvider>(context, listen: false)
                    .setInitialData(endpoints!, null);

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => SignIn(),
                  ),
                );
              } else {
                // get endpoints from the sharedpreferences
                String? encodedEndpoints =
                    sharedPreferences.getString(END_POINT);
                // set colors and name if there is any stored info
                if (encodedEndpoints != null) {
                  InitialData decodedEndPoints =
                      InitialData.fromJson(jsonDecode(encodedEndpoints));
                  // set the colors and app name
                  Provider.of<ColorNameProvider>(context, listen: false)
                      .setColors(
                          decodedEndPoints.client!.color1!,
                          decodedEndPoints.client!.color2!,
                          decodedEndPoints.client!.color3!,
                          decodedEndPoints.client!.color4!,
                          decodedEndPoints.client!.color5!,
                          decodedEndPoints.client!.color6!,
                          decodedEndPoints.client!.name!);

                  // set initial data
                  Provider.of<AuthProvider>(context, listen: false)
                      .setInitialData(decodedEndPoints, null);

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => SignIn(),
                        settings: RouteSettings(name: "signIn")),
                  );
                } else {
                  showSnackbar(
                      "Unable to get initial data required for the application to work properly, please try again later",
                      false);
                }
              }
            },
          );
        },
      );
      DialogUtil.dismissLoadingDialog(context);
    } on SocketException {
      DialogUtil.dismissLoadingDialog(context);
    } catch (e) {
      DialogUtil.dismissLoadingDialog(context);
    }
  }
}
