import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hyella/helper/dialog.dart';
import 'package:hyella/helper/scaffold_messg.dart';
import 'package:hyella/providers/auth_provider.dart';
import 'package:hyella/screens/patient_screens/auth/signin.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  final bool isStaff;
  final String? logo;
  ForgotPassword({Key? key, this.logo, required this.isStaff})
      : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: LoaderOverlay(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: SingleChildScrollView(
            child: Container(
              height: _height,
              width: _width,
              child: SafeArea(
                child: Stack(
                  children: [
                    Positioned(
                        child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )),
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
                    Form(
                      key: formKey,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            widget.logo == null
                                ? Container()
                                : Image.network(
                                    widget.logo!,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.fill,
                                  ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Recover Password",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              "Please provide you email to recover \n your password",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: _width * .8,
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
                                    contentPadding: EdgeInsets.zero,
                                    label: Text("Please input your email"),
                                    focusColor: Theme.of(context).primaryColor,
                                    fillColor: Theme.of(context).primaryColor,
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 2),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 1.5),
                                    ),
                                    labelStyle: TextStyle(
                                        color: Theme.of(context).primaryColor)),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width * .8,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    DialogUtil.showLoadingDialog(context);
                                    var result =
                                        await Provider.of<AuthProvider>(context,
                                                listen: false)
                                            .resetPassword(
                                                emailController.text.trim(),
                                                widget.isStaff
                                                    ? "staff"
                                                    : "patient");
                                    result.fold(
                                      (l) {
                                        showSnackbar(l, false);
                                        DialogUtil.dismissLoadingDialog(
                                            context);
                                      },
                                      (r) {
                                        showSnackbar(r!, true);
                                        DialogUtil.dismissLoadingDialog(
                                            context);
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
                                  "Send Instruction",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
