import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:hyella/custom_widgets/calculated_form_builder.dart';
import 'package:hyella/custom_widgets/color_form_builder.dart';
import 'package:hyella/custom_widgets/date_form_builder.dart';
import 'package:hyella/custom_widgets/date_time_form_builder.dart';
import 'package:hyella/custom_widgets/email_form_builder.dart';
import 'package:hyella/custom_widgets/image_input_builder.dart';
import 'package:hyella/custom_widgets/multi_select_form_builder.dart';
import 'package:hyella/custom_widgets/number_input_form_builder.dart';
import 'package:hyella/custom_widgets/password_form_builder.dart';
import 'package:hyella/custom_widgets/radio_form_builder.dart';
import 'package:hyella/custom_widgets/select_file_form_builder.dart';
import 'package:hyella/custom_widgets/select_form_builder.dart';
import 'package:hyella/custom_widgets/tel_form_builder.dart';
import 'package:hyella/custom_widgets/text_area_form_builder.dart';
import 'package:hyella/custom_widgets/text_form_builder.dart';
import 'package:hyella/custom_widgets/time_form_builder.dart';
import 'package:hyella/custom_widgets/validate_password_form_builder.dart';
import 'package:hyella/helper/dialog.dart';
import 'package:hyella/helper/styles.dart';
import 'package:hyella/models/initial_data.dart';
import 'package:hyella/models/initial_data/calculated_input_type.dart';
import 'package:hyella/models/initial_data/color_input_type.dart';
import 'package:hyella/models/initial_data/confirm_password_input_type.dart';
import 'package:hyella/models/initial_data/date_time_input_type.dart';
import 'package:hyella/models/initial_data/file_input_type.dart';
import 'package:hyella/models/initial_data/multi_select_input_type.dart';
import 'package:hyella/models/initial_data/number_input_type.dart';
import 'package:hyella/models/initial_data/password_input_type.dart';
import 'package:hyella/models/initial_data/picture_input_type.dart';
import 'package:hyella/models/initial_data/radio_input_type.dart';
import 'package:hyella/models/initial_data/select_input_type.dart';
import 'package:hyella/models/initial_data/signup_data.dart';
import 'package:hyella/models/initial_data/tel_input_type.dart';
import 'package:hyella/models/initial_data/text_area_input_type.dart';
import 'package:hyella/models/initial_data/text_input_type.dart';
import 'package:hyella/models/initial_data/time_input_type.dart';
import 'package:hyella/providers/auth_provider.dart';
import 'package:hyella/screens/patient_screens/auth/signin.dart';
import 'package:provider/provider.dart';
import '../../../models/initial_data/date_input_type.dart';
import '../../../models/initial_data/email_input_type.dart';

class SignUp extends StatefulWidget {
  SignUp({
    Key? key,
  }) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  InitialData initialData = GetIt.I<InitialData>();
  GlobalKey<FormState> firstKey = GlobalKey<FormState>();
  List<PageFormData>? forms = GetIt.I<InitialData>().signupForm;
  PageFormData? selectedForm;

  void resetState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      showOptions();
    });
  }

  showOptions() {
    if (forms?.length == 1) {
      selectedForm = forms!.first;
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => SimpleDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          titlePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          title: Text("Signup Options"),
          children: forms
              ?.map(
                (e) => TextButton(
                  onPressed: () {
                    selectedForm = e;
                    selectedForm!.fields!.forEach((e) {
                      if (e is List) {
                        e = [];
                      } else {
                        e = '';
                      }
                    });
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  child: Text(
                    e.title ?? "",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              )
              .toList(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: selectedForm == null
          ? Container()
          : SafeArea(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(
                  FocusNode(),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: _width * .05,
                        right: _width * .05,
                        top: 15,
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Form(
                      key: firstKey,
                      child: SingleChildScrollView(
                        child: Column(
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
                              selectedForm!.title ?? "",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FWt.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              selectedForm?.subTitle ?? "",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Column(
                              children: selectedForm!.fields!.isNotEmpty
                                  ? selectedForm!.fields!.map(
                                      (e) {
                                        if (e is TextFormType) {
                                          return TextInputBuilder(
                                              textFormType: e,
                                              updateData: resetState);
                                        } else if (e is RadioInputType) {
                                          return RadioInputBuilder(
                                              inputType: e,
                                              updateData: resetState);
                                        } else if (e is SelectInputType) {
                                          return SelectInputBuilder(
                                              inputType: e,
                                              updateData: resetState);
                                        } else if (e is MultiSelectInputType) {
                                          return MultiSelectFormBuilder(
                                              inputType: e,
                                              updateData: resetState);
                                        } else if (e is DateInputType) {
                                          return DateInputBuilder(
                                              inputType: e,
                                              updateData: resetState);
                                        } else if (e is DateTimeInputType) {
                                          return DateTimeInputBuilder(
                                              inputType: e,
                                              updateData: resetState);
                                        } else if (e is TimeInputType) {
                                          return TimeInputBuilder(
                                              inputType: e,
                                              updateData: resetState);
                                        } else if (e is TextAreaInputType) {
                                          return TextAreaInputBuilder(
                                              textFormType: e,
                                              updateData: resetState);
                                        } else if (e is PasswordInputType) {
                                          return PasswordInputBuilder(
                                              inputType: e,
                                              updateData: resetState);
                                        } else if (e
                                            is ConfirmPasswordInputType) {
                                          return ValidatePasswordInputBuilder(
                                            inputType: e,
                                            updateData: resetState,
                                            password: selectedForm!.fields!
                                                    .whereType<
                                                        PasswordInputType>()
                                                    .first
                                                    .response ??
                                                "",
                                          );
                                        } else if (e is TelInputType) {
                                          return TelInputBuilder(
                                              textFormType: e,
                                              updateData: resetState);
                                        } else if (e is EmailInputType) {
                                          return EmailInputBuilder(
                                              textFormType: e,
                                              updateData: resetState);
                                        } else if (e is NumberInputType) {
                                          return NumberInputBuilder(
                                              inputType: e,
                                              updateData: resetState);
                                        } else if (e is CalculatedInputType) {
                                          return CalculatedFormBuilder(
                                              inputType: e,
                                              updateData: resetState);
                                        } else if (e is FileInputType) {
                                          return FileInputBulder(
                                              inputType: e,
                                              updateData: resetState);
                                        } else if (e is PictureInputType) {
                                          return ImageInputBulder(
                                              inputType: e,
                                              updateData: resetState);
                                        } else if (e is ColorInputType) {
                                          return ColorFormBuilder(
                                              inputType: e,
                                              updateData: resetState);
                                        }

                                        return Container();
                                      },
                                    ).toList()
                                  : [],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 50,
                              width: _width * .9,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (firstKey.currentState!.validate()) {
                                    var radioFormFields = selectedForm!.fields!
                                        .whereType<RadioInputType>();
                                    if (radioFormFields.isNotEmpty) {
                                      var e = radioFormFields.first;
                                      if (e.requiredField == 1 &&
                                          (e.response == null ||
                                              e.response == "")) {
                                        Fluttertoast.showToast(
                                            msg: e.validationMessage ?? "",
                                            toastLength: Toast.LENGTH_LONG,
                                            textColor: Colors.white,
                                            backgroundColor: Colors.red,
                                            fontSize: 16,
                                            gravity: ToastGravity.CENTER);

                                        return;
                                      }
                                    }

                                    DialogUtil.showLoadingDialog(context);

                                    var response =
                                        await Provider.of<AuthProvider>(context,
                                                listen: false)
                                            .signUp(
                                      data: selectedForm!,
                                    );

                                    DialogUtil.dismissLoadingDialog(context);

                                    response.fold(
                                      (l) {
                                        Fluttertoast.showToast(
                                            msg: l,
                                            toastLength: Toast.LENGTH_LONG,
                                            textColor: Colors.white,
                                            backgroundColor: Colors.red,
                                            fontSize: 16,
                                            gravity: ToastGravity.CENTER);
                                      },
                                      (r) {
                                        Fluttertoast.showToast(
                                            msg: r ??
                                                "Account created successfully",
                                            toastLength: Toast.LENGTH_LONG,
                                            textColor: Colors.white,
                                            backgroundColor: Colors.green,
                                            fontSize: 16,
                                            gravity: ToastGravity.CENTER);

                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SignIn(),
                                          ),
                                        );
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
                                  "Register",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Already have an account? ",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignIn(),
                                    ),
                                  ),
                                  child: Text(
                                    "SIGN IN",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
      resizeToAvoidBottomInset: false,
    );
  }
}
