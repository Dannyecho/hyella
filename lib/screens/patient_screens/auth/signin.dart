import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hyella/helper/dialog.dart';
import 'package:hyella/helper/scaffold_messg.dart';
import 'package:hyella/models/initial_data.dart';
import 'package:hyella/providers/auth_provider.dart';
import 'package:hyella/screens/doctor_screens/main_nav_screens/provider_home_screen.dart';
import 'package:hyella/screens/patient_screens/auth/signup_page.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../main_nav/homepage.dart';
import 'forgot_password.dart';

class SignIn extends StatefulWidget {
  SignIn({Key? key, required}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool googleSigning = false;
  bool facebookSigning = false;
  IconData? currentPasswordIcon = Icons.visibility_off;
  bool currentPasswordVisibility = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool loadingInitialData = true;
  bool isDoctor = false;

  InitialData? initialData;

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      getInitialData();
    });
  }

  void getInitialData() {
    initialData = GetIt.I<InitialData>();
    loadingInitialData = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final double _height = MediaQuery.of(context).size.height;
    final double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: LoaderOverlay(
        overlayColor: Color(0xffE3E8F2),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: SingleChildScrollView(
            child: Container(
              height: _height,
              width: _width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Color(0xffE3E8F2),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: -100,
                    child: Container(
                      height: MediaQuery.of(context).size.height * .7,
                      width: MediaQuery.of(context).size.width,
                      child: SvgPicture.asset(
                        "assets/med.svg",
                        colorBlendMode: BlendMode.softLight,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Image.network(
                            GetIt.I<InitialData>().client!.logo!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Welcome",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          "Please provide you login details",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * .8,
                                child: TextFormField(
                                  controller: emailController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please input your email";
                                    } else if (!EmailValidator.validate(
                                        emailController.text.trim())) {
                                      return "Please provide a valid email";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      contentPadding: EdgeInsets.zero,
                                      prefixIcon: Icon(
                                        Icons.email_outlined,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      focusColor:
                                          Theme.of(context).primaryColor,
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 2),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 1.5),
                                      ),
                                      labelStyle: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      labelText: "Email Address"),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                width: MediaQuery.of(context).size.width * .8,
                                child: TextFormField(
                                  controller: passwordController,
                                  obscureText: currentPasswordVisibility,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Password must be provided";
                                    } else if (value.length < 5) {
                                      return "Password must be at least 5 digits long";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      focusColor:
                                          Theme.of(context).primaryColor,
                                      fillColor: Theme.of(context).primaryColor,
                                      prefixIcon: Icon(
                                        Icons.lock_outline,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            currentPasswordVisibility =
                                                !currentPasswordVisibility;
                                            if (currentPasswordVisibility) {
                                              currentPasswordIcon =
                                                  Icons.visibility_off;
                                            } else {
                                              currentPasswordIcon =
                                                  Icons.visibility;
                                            }
                                          });
                                        },
                                        icon: Icon(
                                          currentPasswordIcon,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 2),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 1.5),
                                      ),
                                      labelStyle: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                      labelText: "Password"),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 42.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      setState(() {
                                        isDoctor = !isDoctor;
                                      });
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value: isDoctor,
                                        checkColor:
                                            Theme.of(context).primaryColor,
                                        activeColor: Colors.white,
                                        onChanged: (value) {
                                          setState(() {
                                            isDoctor = value!;
                                          });
                                        },
                                      ),
                                      Text(
                                        "I am a health service provider",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.symmetric(
                                    horizontal: _width * .1),
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => ForgotPassword(
                                            logo: GetIt.I<InitialData>()
                                                .client!
                                                .logo,
                                            isStaff: isDoctor,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    )),
                              ),
                              Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width * .8,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      DialogUtil.showLoadingDialog(context);
                                      var result = await Provider.of<
                                                  AuthProvider>(context,
                                              listen: false)
                                          .signIn(
                                              emailController.text.trim(),
                                              passwordController.text.trim(),
                                              isDoctor ? "staff" : "patient");

                                      result.fold(
                                        (l) {
                                          DialogUtil.dismissLoadingDialog(
                                              context);
                                          showSnackbar(l, false);
                                        },
                                        (r) {
                                          DialogUtil.dismissLoadingDialog(
                                              context);

                                          if (r!.user!.isStaff == 1) {
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProviderHome(),
                                              ),
                                            );
                                          } else {
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    HomePage(),
                                              ),
                                            );
                                          }
                                        },
                                      );
                                    }
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context).primaryColor,
                                    ),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                    ),
                                  ),
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                              // provider.endPoints.client!.socialLogin != 0
                              //     ? Container()
                              //     : SizedBox(
                              //         height: 80,
                              //       ),
                              // provider.endPoints.client!.socialLogin != 0
                              //     ? Container()
                              //     : Column(
                              //         children: [
                              //           Padding(
                              //             padding: EdgeInsets.symmetric(
                              //                 horizontal: 20.0, vertical: 20),
                              //             child: Stack(
                              //               children: [
                              //                 Divider(
                              //                   thickness: 2,
                              //                   height: 25,
                              //                 ),
                              //                 Positioned(
                              //                   width: 25,
                              //                   height: 25,
                              //                   left: MediaQuery.of(context)
                              //                           .size
                              //                           .width *
                              //                       .43,
                              //                   child: CircleAvatar(
                              //                     child: Text(
                              //                       "Or",
                              //                       style: TextStyle(
                              //                           color: Theme.of(
                              //                                   context)
                              //                               .primaryColor),
                              //                     ),
                              //                     backgroundColor:
                              //                         Colors.white,
                              //                   ),
                              //                 ),
                              //               ],
                              //             ),
                              //           ),
                              //           SizedBox(
                              //             height: 15,
                              //           ),
                              //           // googleSigning
                              //           //     ? CircularProgressIndicator()
                              //           //     : Container(
                              //           //         height: 50,
                              //           //         width: MediaQuery.of(context)
                              //           //                 .size
                              //           //                 .width *
                              //           //             .7,
                              //           //         child: SignInButton(
                              //           //           Buttons.Google,
                              //           //           padding:
                              //           //               EdgeInsets.symmetric(
                              //           //                   horizontal: 15,
                              //           //                   vertical: 10),
                              //           //           text: 'Sign in with Google',
                              //           //           shape:
                              //           //               RoundedRectangleBorder(
                              //           //             borderRadius:
                              //           //                 BorderRadius.circular(
                              //           //                     10.0),
                              //           //           ),
                              //           //           onPressed: () {
                              //           //             setState(() {
                              //           //               googleSigning = true;
                              //           //             });

                              //           //             // Navigator.of(context)
                              //           //             //     .pushReplacementNamed(
                              //           //             //         HOME_PAGE);
                              //           //           },
                              //           //         ),
                              //           //       ),
                              //           SizedBox(
                              //             height: 15,
                              //           ),
                              //           // facebookSigning
                              //           //     ? CircularProgressIndicator()
                              //           //     : Container(
                              //           //         height: 50,
                              //           //         width: MediaQuery.of(context)
                              //           //                 .size
                              //           //                 .width *
                              //           //             .7,
                              //           //         child: SignInButton(
                              //           //           Buttons.Facebook,
                              //           //           padding:
                              //           //               EdgeInsets.symmetric(
                              //           //                   horizontal: 15,
                              //           //                   vertical: 10),
                              //           //           text:
                              //           //               'Sign in with Facebook',
                              //           //           shape:
                              //           //               RoundedRectangleBorder(
                              //           //             borderRadius:
                              //           //                 BorderRadius.circular(
                              //           //                     10.0),
                              //           //           ),
                              //           //           onPressed: () {
                              //           //             setState(() {
                              //           //               googleSigning = true;
                              //           //             });

                              //           //             // Navigator.of(context)
                              //           //             //     .pushReplacementNamed(
                              //           //             //         HOME_PAGE);
                              //           //           },
                              //           //         ),
                              //           //       ),
                              //         ],
                              //       ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      bottomSheet: Container(
        height: 60,
        margin: EdgeInsets.symmetric(horizontal: _width * .05),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Don\'t have an account yet? ",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUp(),
                  ),
                ),
                child: Text(
                  "REGISTER",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
