import 'package:flutter/material.dart';
import 'package:hyella/helper/dialog.dart';
import 'package:hyella/helper/general_loader.dart';
import 'package:hyella/helper/scaffold_messg.dart';
import 'package:hyella/helper/styles.dart';
import 'package:hyella/models/initial_data.dart';
import 'package:hyella/providers/auth_provider.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';

import '../../../helper/route_generator.dart';

class OtpScreen extends StatefulWidget {
  final InitialData endPoints;
  final bool isDoctor;
  final String action;
  final String email;
  OtpScreen(
      {Key? key,
      required this.endPoints,
      required this.isDoctor,
      required this.action,
      required this.email})
      : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  int endTime = DateTime.now().millisecondsSinceEpoch + 5000 * 60;
  String? otp;

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: LoaderOverlay(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.network(
                    widget.endPoints.client!.logo!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Enter OTP",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Please enter 6-digits code that was sent to your email ",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 20,
                ),
                OTPTextField(
                  length: 6,
                  width: MediaQuery.of(context).size.width * .9,
                  margin: const EdgeInsets.symmetric(horizontal: 0),
                  textFieldAlignment: MainAxisAlignment.spaceBetween,
                  fieldWidth: MediaQuery.of(context).size.width * .13,
                  fieldStyle: FieldStyle.box,
                  outlineBorderRadius: 15,
                  style: const TextStyle(fontSize: 17),
                  onCompleted: (pin) {
                    setState(() {
                      otp = pin;
                    });
                  },
                ),
                const SizedBox(
                  height: 60,
                ),
                Container(
                  width: screenWidth * .9,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (otp == null) {
                        showSnackbar("Please input OTP and try again", false);
                      } else {
                        DialogUtil.showLoadingDialog(context);
                        Provider.of<AuthProvider>(context, listen: false)
                            .verifyOtp(
                                widget.email,
                                otp!,
                                widget.isDoctor,
                                widget.action,
                                widget.isDoctor ? "staff" : "patient")
                            .then(
                              (value) => value.fold(
                                (l) {
                                  DialogUtil.dismissLoadingDialog(context);
                                  showSnackbar(l, false);
                                },
                                (r) {
                                  DialogUtil.dismissLoadingDialog(context);
                                  showSnackbar(
                                      "OTP successfully verified, you will be redirected soon",
                                      true);
                                  Future.delayed(
                                    const Duration(seconds: 4),
                                    () {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                        (r.user!.isPatient == 1)
                                            ? HOME_PAGE
                                            : DOCTOR_HOME,
                                      );
                                    },
                                  );
                                },
                              ),
                            );
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor)),
                    child: const Text(
                      "Confirm",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                resendingOtp
                    ? generalLoader()
                    : TextButton(
                        onPressed: () {
                          setState(() {
                            resendingOtp = true;
                          });
                          Provider.of<AuthProvider>(context, listen: false)
                              .resendOtp(widget.email)
                              .then(
                                (value) => value.fold(
                                  (l) {
                                    setState(() {
                                      resendingOtp = false;
                                    });
                                    showSnackbar(l, false);
                                  },
                                  (r) {
                                    setState(() {
                                      resendingOtp = false;
                                    });
                                    showSnackbar(r ?? "OTP resent!", true);
                                  },
                                ),
                              );
                        },
                        child: Styles.bold(
                          "Resend OTP",
                          fontSize: 14,
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool resendingOtp = false;
}
