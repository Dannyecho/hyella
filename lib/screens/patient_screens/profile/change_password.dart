import 'package:flutter/material.dart';
import 'package:hyella/helper/general_loader.dart';
import 'package:hyella/helper/scaffold_messg.dart';
import 'package:hyella/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  final bool isDoctor;
  ChangePassword({Key? key, required this.isDoctor}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController currentPasswordContr = TextEditingController();
  TextEditingController newPasswordContr = TextEditingController();
  TextEditingController confirmPasswordContr = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  IconData? passwordIcon = Icons.visibility_off;
  bool passwordVisibility = true;
  IconData? currentPasswordIcon = Icons.visibility_off;
  bool currentPasswordVisibility = true;
  IconData? confirmPasswordIcon = Icons.visibility_off;
  bool confirmPasswordVisibility = true;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password"),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Container(
            height: screenHeight,
            margin: EdgeInsets.symmetric(horizontal: screenWidth * .05),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Current Password",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: screenWidth * .9,
                    height: 80,
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: currentPasswordVisibility,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password must be provided";
                        } else {
                          return null;
                        }
                      },
                      controller: currentPasswordContr,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              currentPasswordVisibility =
                                  !currentPasswordVisibility;
                              if (currentPasswordVisibility) {
                                currentPasswordIcon = Icons.visibility_off;
                              } else {
                                currentPasswordIcon = Icons.visibility;
                              }
                            });
                          },
                          icon: Icon(
                            currentPasswordIcon,
                            color: Color(0xffE5E5E5),
                          ),
                        ),
                        labelText: "Enter current password",
                        contentPadding: EdgeInsets.all(8),
                      ),
                      cursorColor: Colors.black,
                    ),
                  ),
                  Text(
                    "New Password",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: screenWidth * .9,
                    height: 80,
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: passwordVisibility,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password must be provided";
                        } else if (value.length <= 6) {
                          return "Password must contain more than six characters";
                        } else {
                          return null;
                        }
                      },
                      controller: newPasswordContr,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              passwordVisibility = !passwordVisibility;
                              if (passwordVisibility) {
                                passwordIcon = Icons.visibility_off;
                              } else {
                                passwordIcon = Icons.visibility;
                              }
                            });
                          },
                          icon: Icon(
                            passwordIcon,
                            color: Color(0xffE5E5E5),
                          ),
                        ),
                        labelText: "Enter new password",
                        contentPadding: EdgeInsets.all(8),
                      ),
                      cursorColor: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Confirm Password",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: screenWidth * .9,
                    height: 80,
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: confirmPasswordVisibility,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password must be provided";
                        } else if (newPasswordContr.text.trim() !=
                            confirmPasswordContr.text.trim()) {
                          return "Password do not match";
                        } else {
                          return null;
                        }
                      },
                      controller: confirmPasswordContr,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              confirmPasswordVisibility =
                                  !confirmPasswordVisibility;
                              if (confirmPasswordVisibility) {
                                confirmPasswordIcon = Icons.visibility_off;
                              } else {
                                confirmPasswordIcon = Icons.visibility;
                              }
                            });
                          },
                          icon: Icon(
                            confirmPasswordIcon,
                            color: Color(0xffE5E5E5),
                          ),
                        ),
                        labelText: "Confirm password",
                        contentPadding: EdgeInsets.all(8),
                      ),
                      cursorColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: loading
          ? Container(
              height: 50,
              child: generalLoader(),
            )
          : Container(
              width: screenWidth * .9,
              margin: EdgeInsets.only(bottom: 30, left: screenWidth * .05),
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });
                    var result = await Provider.of<AuthProvider>(
                      context,
                      listen: false,
                    ).changePassword(
                        newPasswordContr.text.trim(),
                        currentPasswordContr.text.trim(),
                        confirmPasswordContr.text.trim(),
                        widget.isDoctor);

                    result.fold((l) {
                      showSnackbar(l, false);
                      setState(() {
                        loading = false;
                      });
                    }, (r) {
                      showSnackbar(r ?? "Password successfully updated!", true);

                      setState(() {
                        loading = false;
                      });
                      Navigator.pop(context);
                    });
                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).primaryColor),
                ),
                child: Text(
                  "Change Password",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
    );
  }
}
