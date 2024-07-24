
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../patient_screens/auth/signin.dart';

class DoctorSignUp extends StatefulWidget {
  const DoctorSignUp({Key? key}) : super(key: key);

  @override
  _DoctorSignUp createState() => _DoctorSignUp();
}

class _DoctorSignUp extends State<DoctorSignUp> {
  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  bool loading = false;
  bool facebookLoading = false;
  bool googeLoading = false;
  bool errorEncountered = false;
  List<String> userTypes = [];
  int selectedStateId = -1;
  int selectedCityId = -1;
  String selectedUsertype = 'Doctor';
  bool useEmail = false;
  bool obscurePassword = true;
  String countryCode = "+234";
  String initialCountry = 'NG';
  PhoneNumber number = PhoneNumber(isoCode: 'NG');
  DateFormat format = DateFormat("y-MM-dd");

  void completedWithError() {
    setState(
      () {
        loading = false;
        errorEncountered = true;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: signUpFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Create Doctor Account",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>SignIn(),
                                ),
                              );
                            },
                            child: Text(
                              " Sign in!",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                       Column(
                              children: [
                                SizedBox(
                                  width: 327,
                                  child: TextFormField(
                                    keyboardType: TextInputType.name,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Full name must be provided";
                                      } else if (value.split(" ").length < 2) {
                                        return "Please provide your full name";
                                      } else {
                                        return null;
                                      }
                                    },
                                    controller: fullNameController,
                                    decoration: InputDecoration(
                                      labelText: "Full name",
                                      labelStyle: TextStyle(color: Colors.grey),
                                      contentPadding: EdgeInsets.only(left: 8),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    cursorColor: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                SizedBox(
                                  width: 327,
                                  child: TextFormField(
                                    keyboardType: TextInputType.name,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "User name must be provided";
                                      } else {
                                        return null;
                                      }
                                    },
                                    controller: usernameController,
                                    decoration: InputDecoration(
                                      labelText: "User name",
                                      labelStyle: TextStyle(color: Colors.grey),
                                      contentPadding: EdgeInsets.only(left: 8),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    cursorColor: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                SizedBox(
                                  width: 327,
                                  child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Email must be provided";
                                      } else if (!EmailValidator.validate(
                                          value)) {
                                        return "Input a Valid Email";
                                      } else {
                                        return null;
                                      }
                                    },
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      labelText: "Email address",
                                      labelStyle: TextStyle(color: Colors.grey),
                                      contentPadding: EdgeInsets.only(left: 8),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    cursorColor: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                SizedBox(
                                  width: 327,
                                  child: InternationalPhoneNumberInput(
                                    onInputChanged: (PhoneNumber number) {
                                      countryCode = number.dialCode!;
                                    },
                                    selectorConfig: SelectorConfig(
                                      selectorType:
                                          PhoneInputSelectorType.DIALOG,
                                    ),
                                    ignoreBlank: false,
                                    autoValidateMode: AutovalidateMode.disabled,
                                    selectorTextStyle:
                                        TextStyle(color: Colors.black),
                                    initialValue: number,
                                    textFieldController: phoneController,
                                    formatInput: false,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            signed: true, decimal: true),
                                    inputDecoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      labelText: "Phone number",
                                      labelStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                SizedBox(
                                  width: 327,
                                  child: TextFormField(
                                    keyboardType: TextInputType.visiblePassword,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Passsword must be provided";
                                      } else if (!RegExp(r'^(?=.*[A-Z])')
                                          .hasMatch(value)) {
                                        return "Pasword must contain at least one Uppercase character";
                                      } else if (!RegExp(r'^(?=.*[0-9])')
                                          .hasMatch(value)) {
                                        return "Pasword must contain at least one number";
                                      } else if (!RegExp(r'^(?=.*[!@#\$&*~.])')
                                          .hasMatch(value)) {
                                        return "Password must contain a special character";
                                      } else if (value.length < 8) {
                                        return "Password must be at least 8 digits long";
                                      } else {
                                        return null;
                                      }
                                    },
                                    controller: passwordController,
                                    obscureText: obscurePassword,
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                            !obscurePassword
                                                ? Icons.lock_open
                                                : Icons.lock,
                                            color: Colors.grey),
                                        onPressed: () {
                                          setState(() {
                                            obscurePassword = !obscurePassword;
                                          });
                                        },
                                      ),
                                      labelText: "Enter Password",
                                      labelStyle: TextStyle(color: Colors.grey),
                                      contentPadding: EdgeInsets.only(left: 8),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    cursorColor: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                SizedBox(
                                  width: 327,
                                  child: TextFormField(
                                    keyboardType: TextInputType.none,
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate:
                                                  DateTime.now().subtract(
                                                Duration(days: 6571),
                                              ),
                                              firstDate:
                                                  DateTime.parse("1930-01-01"),
                                              lastDate: DateTime.now())
                                          .then(
                                        (value) {
                                          setState(
                                            () {
                                              dobController.text=
                                                  format.format(value!);
                                            },
                                          );
                                        },
                                      );
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please select your Date of Birth";
                                      } else {
                                        return null;
                                      }
                                    },
                                    controller: dobController,
                                    decoration: InputDecoration(
                                      labelText: "Date of birth",
                                      contentPadding: EdgeInsets.only(left: 8),
                                      labelStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                // SizedBox(
                                //   height: 15,
                                // ),

                                // SizedBox(
                                //   width: 327,
                                //   child: DropdownButtonFormField<int>(
                                //     validator: (value) {
                                //       if (value == -1) {
                                //         return "Please select a state";
                                //       } else {
                                //         return null;
                                //       }
                                //     },
                                //     decoration: InputDecoration(
                                //       contentPadding:
                                //           EdgeInsets.symmetric(horizontal: 10),
                                //       enabledBorder: OutlineInputBorder(
                                //         borderSide: BorderSide(
                                //             color: Colors.grey[600]!, width: 1),
                                //         borderRadius: BorderRadius.circular(10),
                                //       ),
                                //       border: OutlineInputBorder(
                                //         borderSide: BorderSide(
                                //             color: Colors.grey[600]!, width: 1),
                                //         borderRadius: BorderRadius.circular(10),
                                //       ),
                                //     ),
                                //     value: selectedStateId,
                                //     items: states
                                //         .map(
                                //           (e) => DropdownMenuItem(
                                //             child: Text(e.stateName!,
                                //                 style: TextStyle(
                                //                     color: Colors.grey)),
                                //             value: e.id!,
                                //           ),
                                //         )
                                //         .toList(),
                                //     onChanged: (value) {
                                //       selectedStateId = value!;
                                //       getCities(selectedStateId);
                                //     },
                                //   ),
                                // ),
                                // SizedBox(
                                //   height: 15,
                                // ),
                                // SizedBox(
                                //   width: 327,
                                //   child: DropdownButtonFormField<int>(
                                //     validator: (value) {
                                //       if (value == -1) {
                                //         return "Please select a city";
                                //       } else {
                                //         return null;
                                //       }
                                //     },
                                //     decoration: InputDecoration(
                                //       contentPadding:
                                //           EdgeInsets.symmetric(horizontal: 10),
                                //       enabledBorder: OutlineInputBorder(
                                //         borderSide: BorderSide(
                                //             color: Colors.grey[600]!, width: 1),
                                //         borderRadius: BorderRadius.circular(10),
                                //       ),
                                //       border: OutlineInputBorder(
                                //         borderSide: BorderSide(
                                //             color: Colors.grey[600]!, width: 1),
                                //         borderRadius: BorderRadius.circular(10),
                                //       ),
                                //     ),
                                //     value: selectedCityId,
                                //     items: cities
                                //         .map(
                                //           (e) => DropdownMenuItem(
                                //             child: Text(e.cityName!,
                                //                 style: TextStyle(
                                //                     color: Colors.grey)),
                                //             value: e.id!,
                                //           ),
                                //         )
                                //         .toList(),
                                //     onChanged: (value) {
                                //       selectedCityId = value!;
                                //     },
                                //   ),
                                // ),
                                SizedBox(
                                  height: 25,
                                ),
                                SizedBox(
                                  width: 327,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (signUpFormKey.currentState!
                                          .validate()) {
                                        setState(() {
                                          loading = true;
                                        });
                      
                                        
                                      }
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.green.withOpacity(0.9)),
                                    ),
                                    child: Text(
                                      !useEmail
                                          ? "Continue with email"
                                          : "Sign up",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                // Text(
                                //   "OR",
                                //   style: TextStyle(
                                //       color: Colors.black.withOpacity(0.6),
                                //       fontWeight: FontWeight.bold),
                                // ),
                              ],
                            ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // SizedBox(
                      //   width: 327,
                      //   height: 50,
                      //   child: ElevatedButton(
                      //     onPressed: () async {},
                      //     style: ButtonStyle(
                      //       backgroundColor:
                      //           MaterialStateProperty.all(Colors.blue[900]),
                      //     ),
                      //     child: Row(
                      //       children: [
                      //         Container(
                      //           height: 40,
                      //           width: 40,
                      //           child: Icon(
                      //             FontAwesomeIcons.facebookF,
                      //             color: Colors.blue[900],
                      //             size: 20,
                      //           ),
                      //           decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(5),
                      //               color: Colors.white),
                      //         ),
                      //         SizedBox(
                      //           width: 40,
                      //         ),
                      //         Text(
                      //           "Continue with Facebook",
                      //           style: TextStyle(
                      //               color: Colors.white,
                      //               fontSize: 18,
                      //               fontWeight: FontWeight.bold),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 15,
                      // ),
                      // SizedBox(
                      //   width: 327,
                      //   height: 50,
                      //   child: ElevatedButton(
                      //     onPressed: () async {},
                      //     style: ButtonStyle(
                      //       backgroundColor:
                      //           MaterialStateProperty.all(Colors.blue[600]),
                      //     ),
                      //     child: Row(
                      //       children: [
                      //         Container(
                      //           height: 40,
                      //           width: 40,
                      //           padding: EdgeInsets.all(8),
                      //           child: Image.asset("assets/google.png"),
                      //           decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(5),
                      //               color: Colors.white),
                      //         ),
                      //         SizedBox(
                      //           width: 40,
                      //         ),
                      //         Text(
                      //           "Continue with Google",
                      //           style: TextStyle(
                      //               color: Colors.white,
                      //               fontSize: 18,
                      //               fontWeight: FontWeight.bold),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

    );
  }

  bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }
}
