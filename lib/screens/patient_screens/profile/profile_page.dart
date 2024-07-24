import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:hyella/custom_widgets/radio_form_builder.dart';
import 'package:hyella/helper/constants.dart';
import 'package:hyella/helper/scaffold_messg.dart';
import 'package:hyella/models/initial_data.dart';
import 'package:hyella/models/initial_data/radio_input_type.dart';
import 'package:hyella/models/initial_data/signup_data.dart';
import 'package:hyella/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:hyella/custom_widgets/calculated_form_builder.dart';
import 'package:hyella/custom_widgets/color_form_builder.dart';
import 'package:hyella/custom_widgets/date_form_builder.dart';
import 'package:hyella/custom_widgets/date_time_form_builder.dart';
import 'package:hyella/custom_widgets/email_form_builder.dart';
import 'package:hyella/custom_widgets/image_input_builder.dart';
import 'package:hyella/custom_widgets/multi_select_form_builder.dart';
import 'package:hyella/custom_widgets/number_input_form_builder.dart';
import 'package:hyella/custom_widgets/password_form_builder.dart';
import 'package:hyella/custom_widgets/select_file_form_builder.dart';
import 'package:hyella/custom_widgets/select_form_builder.dart';
import 'package:hyella/custom_widgets/tel_form_builder.dart';
import 'package:hyella/custom_widgets/text_area_form_builder.dart';
import 'package:hyella/custom_widgets/text_form_builder.dart';
import 'package:hyella/custom_widgets/time_form_builder.dart';
import 'package:hyella/models/initial_data/calculated_input_type.dart';
import 'package:hyella/models/initial_data/color_input_type.dart';
import 'package:hyella/models/initial_data/date_time_input_type.dart';
import 'package:hyella/models/initial_data/file_input_type.dart';
import 'package:hyella/models/initial_data/multi_select_input_type.dart';
import 'package:hyella/models/initial_data/number_input_type.dart';
import 'package:hyella/models/initial_data/password_input_type.dart';
import 'package:hyella/models/initial_data/picture_input_type.dart';
import 'package:hyella/models/initial_data/select_input_type.dart';

import 'package:hyella/models/initial_data/tel_input_type.dart';
import 'package:hyella/models/initial_data/text_area_input_type.dart';
import 'package:hyella/models/initial_data/text_input_type.dart';
import 'package:hyella/models/initial_data/time_input_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/initial_data/date_input_type.dart';
import '../../../models/initial_data/email_input_type.dart';

import 'change_password.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool loading = false;
  var userDetails;
  PageFormData? updateProfileForm;

  populateFields() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userDetails = jsonDecode(preferences.getString(USER_DETAILS)!);
    var user = userDetails?['user'];
    updateProfileForm = GetIt.I<InitialData>().profileUpdateForm;
    if (updateProfileForm != null && userDetails != null) {
      updateProfileForm!.fields!.forEach((element) {
        if (element.response is String) {
          element.response = (user[element.name]);
        } else if (element.response is List) {
          if (user[element.name] != null) {
            element.response = List<String?>.from(
                [user[element.name].toString()],
                growable: false);
          }
        }
      });
    }
    setState(() {});
  }

  void resetState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      populateFields();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        foregroundColor: Colors.black,
        title: Text("Profile"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChangePassword(
                    isDoctor: false,
                  ),
                ),
              );
            },
            itemBuilder: (context) => [
              PopupMenuItem(child: Text("Change Password"), value: "a"),
            ],
          )
        ],
      ),
      body: Consumer<AuthProvider>(builder: (context, AuthProvider auth, wid) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: (userDetails == null || updateProfileForm == null)
              ? SizedBox()
              : SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(
                        top: 40,
                        bottom: 40,
                        left: screenWidth * .05,
                        right: screenWidth * .05),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            children: updateProfileForm!.fields!.isNotEmpty
                                ? updateProfileForm!.fields!.map(
                                    (e) {
                                      if (e is TextFormType) {
                                        return TextInputBuilder(
                                            textFormType: e,
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
                                      } else if (e is RadioInputType) {
                                        return RadioInputBuilder(
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
                            width: screenWidth * .8,
                            margin: EdgeInsets.only(bottom: 30),
                            height: 50,
                            child: loading
                                ? Center(
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        var radioFormFields = updateProfileForm!
                                            .fields!
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
                                        setState(() {
                                          loading = true;
                                        });
                                        Provider.of<AuthProvider>(context,
                                                listen: false)
                                            .updateProfile(updateProfileForm!)
                                            .then(
                                              (value) => value.fold(
                                                (l) {
                                                  showSnackbar(l, false);
                                                  setState(
                                                    () {
                                                      loading = false;
                                                    },
                                                  );
                                                },
                                                (r) {
                                                  showSnackbar(
                                                    "Profile successfully updated!",
                                                    true,
                                                  );
                                                  setState(
                                                    () {
                                                      loading = false;
                                                    },
                                                  );
                                                },
                                              ),
                                            );
                                      }
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Theme.of(context).primaryColor),
                                    ),
                                    child: Text(
                                      "Update Profile",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        );
      }),
    );
  }
}
