import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hyella/custom_widgets/radio_form_builder.dart';
import 'package:hyella/helper/scaffold_messg.dart';
import 'package:hyella/models/initial_data.dart';
import 'package:hyella/models/initial_data/radio_input_type.dart';
import 'package:hyella/models/initial_data/signup_data.dart';
import 'package:hyella/models/signup_result_model.dart';
import 'package:hyella/providers/auth_provider.dart';
import 'package:hyella/screens/patient_screens/profile/change_password.dart';
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

import '../../../models/initial_data/date_input_type.dart';
import '../../../models/initial_data/email_input_type.dart';

class ProfileSetting extends StatefulWidget {
  ProfileSetting({Key? key}) : super(key: key);

  @override
  _ProfileSettingState createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  List<String> choices = const <String>["a", "b", "c"];
  // PickedFile? _imageFile;
  // final ImagePicker _picker = ImagePicker();
  // // TextEditingController fullNameContr = TextEditingController();
  // TextEditingController firstNameContr = TextEditingController();
  // TextEditingController LastNameContr = TextEditingController();
  // TextEditingController phoneContr = TextEditingController();
  // TextEditingController emailContr = TextEditingController();
  // TextEditingController addressCont = TextEditingController();

  // TextEditingController nokNameContr = TextEditingController();
  // TextEditingController nokPhoneContr = TextEditingController();
  // TextEditingController nokEmailContr = TextEditingController();
  // TextEditingController nokAddressCont = TextEditingController();
  // TextEditingController allergyContr = TextEditingController();
  // TextEditingController otherReligionController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool loading = false;
  String religion = "Christianity";

  List<String> religions = [
    "Islam",
    "Christianity",
    "Judaism",
    "Hinduism",
    "Buddhism",
    "Others"
  ];
  UserDetails? userDetails;
  PageFormData? updateProfileForm;

  populateFields() {
    userDetails = GetIt.I<UserDetails>();
    updateProfileForm = GetIt.I<InitialData>().profileUpdateForm;
    if (updateProfileForm != null) {
      updateProfileForm!.fields!.forEach((element) {
        if (element.response is String) {
          element.response = userDetails?.user?.toJson()[element.name];
        } else if (element.response is List) {
          element.response = [
            userDetails?.user?.toJson()[element.name].toString()
          ] as List<String>?;
        }
      });
    }
    // firstNameContr.text = userDetails!.user!.fullName!.split(" ").first;
    // LastNameContr.text = userDetails!.user!.fullName!.split(" ").last;
    // phoneContr.text = userDetails!.user!.phone!;
    // emailContr.text = userDetails!.user!.email!;
    // religion = (userDetails!.user!.religion == null ||
    //         userDetails!.user!.religion!.isEmpty)
    //     ? "Christianity"
    //     : userDetails!.user!.religion!;
    // addressCont.text = userDetails!.user!.address ?? "";
    // nokNameContr.text = userDetails!.user!.nokName ?? "";
    // nokPhoneContr.text = userDetails!.user!.nokPhone ?? "";
    // nokEmailContr.text = userDetails!.user!.nokEmail ?? "";
    // nokAddressCont.text = userDetails!.user!.nokAddress ?? "";
    // allergyContr.text = userDetails!.user!.allergy ?? "";
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
                    isDoctor: true,
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
                                            textFormType: e, updateData: () {});
                                      } else if (e is RadioInputType) {
                                        return RadioInputBuilder(
                                            inputType: e, updateData: () {});
                                      } else if (e is SelectInputType) {
                                        return SelectInputBuilder(
                                            inputType: e, updateData: () {});
                                      } else if (e is MultiSelectInputType) {
                                        return MultiSelectFormBuilder(
                                            inputType: e, updateData: () {});
                                      } else if (e is DateInputType) {
                                        return DateInputBuilder(
                                            inputType: e, updateData: () {});
                                      } else if (e is DateTimeInputType) {
                                        return DateTimeInputBuilder(
                                            inputType: e, updateData: () {});
                                      } else if (e is TimeInputType) {
                                        return TimeInputBuilder(
                                            inputType: e, updateData: () {});
                                      } else if (e is TextAreaInputType) {
                                        return TextAreaInputBuilder(
                                            textFormType: e, updateData: () {});
                                      } else if (e is PasswordInputType) {
                                        return PasswordInputBuilder(
                                            inputType: e, updateData: () {});
                                      } else if (e is TelInputType) {
                                        return TelInputBuilder(
                                            textFormType: e, updateData: () {});
                                      } else if (e is EmailInputType) {
                                        return EmailInputBuilder(
                                            textFormType: e, updateData: () {});
                                      } else if (e is NumberInputType) {
                                        return NumberInputBuilder(
                                            inputType: e, updateData: () {});
                                      } else if (e is CalculatedInputType) {
                                        return CalculatedFormBuilder(
                                            inputType: e, updateData: () {});
                                      } else if (e is FileInputType) {
                                        return FileInputBulder(
                                            inputType: e, updateData: () {});
                                      } else if (e is PictureInputType) {
                                        return ImageInputBulder(
                                            inputType: e, updateData: () {});
                                      } else if (e is ColorInputType) {
                                        return ColorFormBuilder(
                                            inputType: e, updateData: () {});
                                      }

                                      return Container();
                                    },
                                  ).toList()
                                : [],
                          ),
                          // Container(
                          //   margin: EdgeInsets.only(top: 30),
                          //   width: 100,
                          //   height: 100,
                          //   alignment: Alignment.center,
                          //   child: Stack(
                          //     children: [
                          //       _imageFile != null
                          //           ? CircleAvatar(
                          //               radius: 50,
                          //               backgroundColor: Color(0xffC6C6C6),
                          //               backgroundImage: FileImage(
                          //                 File(_imageFile!.path),
                          //               ),
                          //             )
                          //           : (userDetails!.user!.dp == null ||
                          //                   userDetails!.user!.dp!.isEmpty)
                          //               ? CircleAvatar(
                          //                   radius: 50,
                          //                   backgroundColor: Color(0xffC6C6C6),
                          //                   child: Icon(
                          //                     Icons.person,
                          //                     color: Colors.white,
                          //                     size: 50,
                          //                   ),
                          //                 )
                          //               : CircleAvatar(
                          //                   radius: 50,
                          //                   backgroundColor: Color(0xffC6C6C6),
                          //                   backgroundImage: NetworkImage(
                          //                     userDetails!.user!.dp!,
                          //                   ),
                          //                 ),
                          //       Align(
                          //         alignment: Alignment.bottomRight,
                          //         child: CircleAvatar(
                          //           radius: 18,
                          //           backgroundColor:
                          //               Theme.of(context).primaryColor,
                          //           child: IconButton(
                          //             onPressed: () {
                          //               showDialog(
                          //                 context: context,
                          //                 builder: (context) => SimpleDialog(
                          //                   title: Text("Select Image Source"),
                          //                   children: [
                          //                     Row(
                          //                       mainAxisAlignment:
                          //                           MainAxisAlignment.center,
                          //                       children: <Widget>[
                          //                         TextButton.icon(
                          //                           icon: Icon(Icons.camera),
                          //                           onPressed: () async {
                          //                             await takePhoto(
                          //                                 ImageSource.camera);
                          //                             Navigator.pop(context);
                          //                           },
                          //                           label: Text("Camera"),
                          //                         ),
                          //                         TextButton.icon(
                          //                           icon: Icon(Icons.image),
                          //                           onPressed: () async {
                          //                             await takePhoto(
                          //                                 ImageSource.gallery);
                          //                             Navigator.pop(context);
                          //                           },
                          //                           label: Text("Gallery"),
                          //                         ),
                          //                       ],
                          //                     )
                          //                   ],
                          //                 ),
                          //               );
                          //             },
                          //             icon: Icon(
                          //               Icons.camera_alt_outlined,
                          //               color: Colors.white,
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 30,
                          // ),
                          // Container(
                          //   width: screenWidth * .8,
                          //   child: TextFormField(
                          //     keyboardType: TextInputType.name,
                          //     textCapitalization: TextCapitalization.words,
                          //     validator: (value) {
                          //       if (value!.isEmpty) {
                          //         return "First Name must be provided";
                          //       } else {
                          //         return null;
                          //       }
                          //     },
                          //     controller: firstNameContr,
                          //     decoration: InputDecoration(
                          //       hintText: "Enter First Name",
                          //       floatingLabelBehavior:
                          //           FloatingLabelBehavior.never,
                          //       contentPadding: EdgeInsets.zero,
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // Container(
                          //   width: screenWidth * .8,
                          //   child: TextFormField(
                          //     keyboardType: TextInputType.name,
                          //     textCapitalization: TextCapitalization.words,
                          //     validator: (value) {
                          //       if (value!.isEmpty) {
                          //         return "Last Name must be provided";
                          //       } else {
                          //         return null;
                          //       }
                          //     },
                          //     controller: LastNameContr,
                          //     decoration: InputDecoration(
                          //       hintText: "Enter Last Name",
                          //       floatingLabelBehavior:
                          //           FloatingLabelBehavior.never,
                          //       contentPadding: EdgeInsets.zero,
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // Container(
                          //   width: screenWidth * .8,
                          //   child: TextFormField(
                          //     keyboardType: TextInputType.emailAddress,
                          //     validator: (value) {
                          //       if (value!.isEmpty) {
                          //         return "Email address must be provided";
                          //       } else if (!EmailValidator.validate(value)) {
                          //         return "Please provide a valid email";
                          //       } else {
                          //         return null;
                          //       }
                          //     },
                          //     controller: emailContr,
                          //     decoration: InputDecoration(
                          //       floatingLabelBehavior:
                          //           FloatingLabelBehavior.never,
                          //       hintText: "Enter Email Address",
                          //       contentPadding: EdgeInsets.zero,
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // Container(
                          //   width: screenWidth * .8,
                          //   child: TextFormField(
                          //     keyboardType: TextInputType.phone,
                          //     validator: (value) {
                          //       if (value!.isEmpty) {
                          //         return "Phone number must be provided";
                          //       } else {
                          //         return null;
                          //       }
                          //     },
                          //     controller: phoneContr,
                          //     decoration: InputDecoration(
                          //       floatingLabelBehavior:
                          //           FloatingLabelBehavior.never,
                          //       hintText: "Enter phone number",
                          //       contentPadding: EdgeInsets.zero,
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // Container(
                          //   width: screenWidth * .8,
                          //   child: TextFormField(
                          //     keyboardType: TextInputType.multiline,
                          //     validator: (value) {
                          //       if (value!.isEmpty) {
                          //         return "Home address must be provided";
                          //       } else {
                          //         return null;
                          //       }
                          //     },
                          //     controller: addressCont,
                          //     minLines: 1,
                          //     maxLines: 5,
                          //     decoration: InputDecoration(
                          //       floatingLabelBehavior:
                          //           FloatingLabelBehavior.never,
                          //       hintText: "Enter Home Address",
                          //       contentPadding: EdgeInsets.zero,
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // Container(
                          //   width: screenWidth * 0.8,
                          //   child: DropdownButtonFormField<String>(
                          //     decoration: InputDecoration(
                          //       hintText: "Select Religion",
                          //       contentPadding: EdgeInsets.all(8),
                          //     ),
                          //     value: religion,
                          //     items: religions.map((map) {
                          //       return DropdownMenuItem(
                          //         child: Text(map),
                          //         value: map,
                          //       );
                          //     }).toList(),
                          //     onChanged: (value) {
                          //       setState(() {
                          //         religion = value!;
                          //       });
                          //     },
                          //     hint: Text("Select Item"),
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // religion != "Others"
                          //     ? SizedBox()
                          //     : Container(
                          //         width: screenWidth * .8,
                          //         child: TextFormField(
                          //           keyboardType: TextInputType.name,
                          //           textCapitalization:
                          //               TextCapitalization.words,
                          //           validator: (value) {
                          //             if (value!.isEmpty) {
                          //               return "Name of religion must be provided";
                          //             } else if (value.split(" ").length < 2) {
                          //               return "Please provide your religion name";
                          //             } else {
                          //               return null;
                          //             }
                          //           },
                          //           controller: otherReligionController,
                          //           decoration: InputDecoration(
                          //             hintText: "Enter Name of Religion",
                          //             floatingLabelBehavior:
                          //                 FloatingLabelBehavior.never,
                          //             contentPadding: EdgeInsets.zero,
                          //           ),
                          //         ),
                          //       ),
                          // religion != "Other"
                          //     ? SizedBox()
                          //     : SizedBox(
                          //         height: 10,
                          //       ),
                          // Container(
                          //   width: screenWidth * .8,
                          //   child: TextFormField(
                          //     keyboardType: TextInputType.name,
                          //     textCapitalization: TextCapitalization.words,
                          //     validator: (value) {
                          //       if (value!.isEmpty) {
                          //         return "NOK Full Name must be provided";
                          //       } else if (value.split(" ").length < 2) {
                          //         return "Please provide full name";
                          //       } else {
                          //         return null;
                          //       }
                          //     },
                          //     controller: nokNameContr,
                          //     decoration: InputDecoration(
                          //       hintText: "Enter Next of Kin Full Name",
                          //       floatingLabelBehavior:
                          //           FloatingLabelBehavior.never,
                          //       contentPadding: EdgeInsets.zero,
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // Container(
                          //   width: screenWidth * .8,
                          //   child: TextFormField(
                          //     keyboardType: TextInputType.emailAddress,
                          //     validator: (value) {
                          //       if (value!.isNotEmpty &&
                          //           !EmailValidator.validate(value)) {
                          //         return "Please provide a valid email";
                          //       } else {
                          //         return null;
                          //       }
                          //     },
                          //     controller: nokEmailContr,
                          //     decoration: InputDecoration(
                          //       floatingLabelBehavior:
                          //           FloatingLabelBehavior.never,
                          //       hintText: "Enter NOK Email Address",
                          //       contentPadding: EdgeInsets.zero,
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // Container(
                          //   width: screenWidth * .8,
                          //   child: TextFormField(
                          //     keyboardType: TextInputType.phone,
                          //     validator: (value) {
                          //       if (value!.isEmpty) {
                          //         return "Phone number must be provided";
                          //       } else {
                          //         return null;
                          //       }
                          //     },
                          //     controller: nokPhoneContr,
                          //     decoration: InputDecoration(
                          //       floatingLabelBehavior:
                          //           FloatingLabelBehavior.never,
                          //       hintText: "Enter NOK phone number",
                          //       contentPadding: EdgeInsets.zero,
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // Container(
                          //   width: screenWidth * .8,
                          //   child: TextFormField(
                          //     keyboardType: TextInputType.multiline,
                          //     validator: (value) {
                          //       if (value!.isEmpty) {
                          //         return "Home address must be provided";
                          //       } else {
                          //         return null;
                          //       }
                          //     },
                          //     maxLines: 5,
                          //     minLines: 1,
                          //     controller: nokAddressCont,
                          //     decoration: InputDecoration(
                          //       floatingLabelBehavior:
                          //           FloatingLabelBehavior.never,
                          //       hintText: "Enter NOK Home Address",
                          //       contentPadding: EdgeInsets.zero,
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // Container(
                          //   width: screenWidth * .8,
                          //   child: TextFormField(
                          //     keyboardType: TextInputType.text,
                          //     controller: allergyContr,
                          //     decoration: InputDecoration(
                          //       floatingLabelBehavior:
                          //           FloatingLabelBehavior.never,
                          //       hintText:
                          //           "What are you allergic to? (Separate with comma)",
                          //       contentPadding: EdgeInsets.zero,
                          //     ),
                          //   ),
                          // ),
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

  // Future<void> takePhoto(ImageSource source) async {
  //   final imageGotten = await _picker.getImage(source: source);

  //   setState(() {
  //     _imageFile = imageGotten;
  //   });
  // }
}

// import 'dart:async';
// import 'dart:io';
// import 'package:email_validator/email_validator.dart';
// import 'package:flutter/material.dart';
// import 'package:hyella/helper/constants.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import '../../../helper/scaffold_messg.dart';
// import '../../../models/signup_result_model.dart';
// import '../../../providers/auth_provider.dart';
// import '../../patient_screens/profile/change_password.dart';

// class ProfileSetting extends StatefulWidget {
//   const ProfileSetting({Key? key}) : super(key: key);

//   @override
//   State<ProfileSetting> createState() => _ProfileSettingState();
// }

// class _ProfileSettingState extends State<ProfileSetting> {
//   List<String> choices = const <String>["a", "b", "c"];
//   PickedFile? _imageFile;
//   final ImagePicker _picker = ImagePicker();
//   // TextEditingController fullNameContr = TextEditingController();
//   TextEditingController firstNameContr = TextEditingController();
//   TextEditingController LastNameContr = TextEditingController();
//   TextEditingController phoneContr = TextEditingController();
//   TextEditingController emailContr = TextEditingController();
//   TextEditingController addressCont = TextEditingController();

//   TextEditingController nokNameContr = TextEditingController();
//   TextEditingController nokPhoneContr = TextEditingController();
//   TextEditingController nokEmailContr = TextEditingController();
//   TextEditingController nokAddressCont = TextEditingController();
//   TextEditingController allergyContr = TextEditingController();
//   TextEditingController otherReligionController = TextEditingController();
//   GlobalKey<FormState> formKey = GlobalKey<FormState>();

//   bool loading = false;
//   String religion = "Christianity";

//   List<String> religions = [
//     "Islam",
//     "Christianity",
//     "Judaism",
//     "Hinduism",
//     "Buddhism",
//     "Others"
//   ];
//   UserDetails? userDetails;

//   populateFields() {
//     userDetails = Provider.of<AuthProvider>(context, listen: false).userDetails;
//     firstNameContr.text = userDetails!.user!.fullName!.split(" ").first;
//     LastNameContr.text = userDetails!.user!.fullName!.split(" ").last;
//     phoneContr.text = userDetails!.user!.phone!;
//     emailContr.text = userDetails!.user!.email!;

//     setState(() {});
//   }

//   @override
//   void initState() {
//     super.initState();
//     Timer.run(() {
//       populateFields();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         foregroundColor: Colors.white,
//         backgroundColor: Theme.of(context).primaryColor,
//         centerTitle: true,
//         title: Text(
//           "Profile Settings",
//           style: TextStyle(color: Colors.white),
//         ),
//         actions: [
//           PopupMenuButton<String>(
//             color: Colors.white,
//             icon: Icon(
//               Icons.more_vert,
//               color: Colors.white,
//             ),
//             onSelected: (value) {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) => ChangePassword(
//                     isDoctor: true,
//                   ),
//                 ),
//               );
//             },
//             itemBuilder: (context) =>
//                 [PopupMenuItem(child: Text("Change Password"), value: "a")],
//           )
//         ],
//       ),
//       body: Consumer<AuthProvider>(
//         builder: (context, AuthProvider auth, wid) {
//           return GestureDetector(
//             onTap: () {
//               FocusScope.of(context).requestFocus(FocusNode());
//             },
//             child: SingleChildScrollView(
//               child: Form(
//                 key: formKey,
//                 child: Container(
//                   margin: EdgeInsets.only(
//                       bottom: 160, left: deviceWidth(context) * .1),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Container(
//                         margin: EdgeInsets.only(top: 30),
//                         width: 100,
//                         height: 100,
//                         alignment: Alignment.center,
//                         child: Stack(
//                           children: [
//                             _imageFile != null
//                                 ? CircleAvatar(
//                                     radius: 50,
//                                     backgroundColor: Color(0xffC6C6C6),
//                                     backgroundImage: FileImage(
//                                       File(_imageFile!.path),
//                                     ),
//                                   )
//                                 : CircleAvatar(
//                                     radius: 50,
//                                     backgroundColor: Color(0xffC6C6C6),
//                                     backgroundImage: NetworkImage(
//                                       auth.userDetails.user!.dp!,
//                                     ),
//                                   ),
//                             Align(
//                               alignment: Alignment.bottomRight,
//                               child: CircleAvatar(
//                                 radius: 18,
//                                 backgroundColor: Theme.of(context).primaryColor,
//                                 child: IconButton(
//                                   onPressed: () {
//                                     showDialog(
//                                       context: context,
//                                       builder: (context) => SimpleDialog(
//                                         title: Text("Select Image Source"),
//                                         children: [
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: <Widget>[
//                                               TextButton.icon(
//                                                 icon: Icon(Icons.camera),
//                                                 onPressed: () async {
//                                                   await takePhoto(
//                                                       ImageSource.camera);
//                                                   Navigator.pop(context);
//                                                 },
//                                                 label: Text("Camera"),
//                                               ),
//                                               TextButton.icon(
//                                                 icon: Icon(Icons.image),
//                                                 onPressed: () async {
//                                                   await takePhoto(
//                                                       ImageSource.gallery);
//                                                   Navigator.pop(context);
//                                                 },
//                                                 label: Text("Gallery"),
//                                               ),
//                                             ],
//                                           )
//                                         ],
//                                       ),
//                                     );
//                                   },
//                                   icon: Icon(
//                                     Icons.camera_alt_outlined,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         height: 30,
//                       ),
//                       Container(
//                         width: deviceWidth(context) * .8,
//                         child: TextFormField(
//                           keyboardType: TextInputType.name,
//                           textCapitalization: TextCapitalization.words,
//                           controller: firstNameContr,
//                           decoration: InputDecoration(
//                             hintText: "Enter First Name",
//                             floatingLabelBehavior: FloatingLabelBehavior.never,
//                             contentPadding: EdgeInsets.zero,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Container(
//                         width: deviceWidth(context) * .8,
//                         child: TextFormField(
//                           keyboardType: TextInputType.name,
//                           textCapitalization: TextCapitalization.words,
//                           controller: LastNameContr,
//                           decoration: InputDecoration(
//                             hintText: "Enter Last Name",
//                             floatingLabelBehavior: FloatingLabelBehavior.never,
//                             contentPadding: EdgeInsets.zero,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Container(
//                         width: deviceWidth(context) * .8,
//                         child: TextFormField(
//                           keyboardType: TextInputType.emailAddress,
//                           controller: emailContr,
//                           decoration: InputDecoration(
//                             floatingLabelBehavior: FloatingLabelBehavior.never,
//                             hintText: "Enter Email Address",
//                             contentPadding: EdgeInsets.zero,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Container(
//                         width: deviceWidth(context) * .8,
//                         child: TextFormField(
//                           keyboardType: TextInputType.phone,
//                           controller: phoneContr,
//                           decoration: InputDecoration(
//                             floatingLabelBehavior: FloatingLabelBehavior.never,
//                             hintText: "Enter phone number",
//                             contentPadding: EdgeInsets.zero,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Container(
//                         width: deviceWidth(context) * .8,
//                         child: TextFormField(
//                           keyboardType: TextInputType.multiline,
//                           controller: addressCont,
//                           minLines: 1,
//                           maxLines: 5,
//                           decoration: InputDecoration(
//                             floatingLabelBehavior: FloatingLabelBehavior.never,
//                             hintText: "Enter Home Address",
//                             contentPadding: EdgeInsets.zero,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Container(
//                         width: deviceWidth(context) * 0.8,
//                         child: DropdownButtonFormField<String>(
//                           decoration: InputDecoration(
//                             hintText: "Select Religion",
//                             contentPadding: EdgeInsets.all(8),
//                           ),
//                           value: religion,
//                           items: religions.map((map) {
//                             return DropdownMenuItem(
//                               child: Text(map),
//                               value: map,
//                             );
//                           }).toList(),
//                           onChanged: (value) {
//                             setState(() {
//                               religion = value!;
//                             });
//                           },
//                           hint: Text("Select Item"),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       religion != "Others"
//                           ? SizedBox()
//                           : Container(
//                               width: deviceWidth(context) * .8,
//                               child: TextFormField(
//                                 keyboardType: TextInputType.name,
//                                 textCapitalization: TextCapitalization.words,
//                                 controller: otherReligionController,
//                                 decoration: InputDecoration(
//                                   hintText: "Enter Name of Religion",
//                                   floatingLabelBehavior:
//                                       FloatingLabelBehavior.never,
//                                   contentPadding: EdgeInsets.zero,
//                                 ),
//                               ),
//                             ),
//                       religion != "Other"
//                           ? SizedBox()
//                           : SizedBox(
//                               height: 10,
//                             ),
//                       Container(
//                         width: deviceWidth(context) * .8,
//                         child: TextFormField(
//                           keyboardType: TextInputType.name,
//                           textCapitalization: TextCapitalization.words,
//                           controller: nokNameContr,
//                           decoration: InputDecoration(
//                             hintText: "Enter Next of Kin Full Name",
//                             floatingLabelBehavior: FloatingLabelBehavior.never,
//                             contentPadding: EdgeInsets.zero,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Container(
//                         width: deviceWidth(context) * .8,
//                         child: TextFormField(
//                           keyboardType: TextInputType.emailAddress,
//                           validator: (value) {
//                             if (value!.isNotEmpty &&
//                                 !EmailValidator.validate(value)) {
//                               return "Please provide a valid email";
//                             } else {
//                               return null;
//                             }
//                           },
//                           controller: nokEmailContr,
//                           decoration: InputDecoration(
//                             floatingLabelBehavior: FloatingLabelBehavior.never,
//                             hintText: "Enter NOK Email Address",
//                             contentPadding: EdgeInsets.zero,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Container(
//                         width: deviceWidth(context) * .8,
//                         child: TextFormField(
//                           keyboardType: TextInputType.phone,
//                           controller: nokPhoneContr,
//                           decoration: InputDecoration(
//                             floatingLabelBehavior: FloatingLabelBehavior.never,
//                             hintText: "Enter NOK phone number",
//                             contentPadding: EdgeInsets.zero,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Container(
//                         width: deviceWidth(context) * .8,
//                         child: TextFormField(
//                           keyboardType: TextInputType.multiline,
//                           maxLines: 5,
//                           minLines: 1,
//                           controller: nokAddressCont,
//                           decoration: InputDecoration(
//                             floatingLabelBehavior: FloatingLabelBehavior.never,
//                             hintText: "Enter NOK Home Address",
//                             contentPadding: EdgeInsets.zero,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Container(
//                         width: deviceWidth(context) * .8,
//                         child: TextFormField(
//                           keyboardType: TextInputType.text,
//                           controller: allergyContr,
//                           decoration: InputDecoration(
//                             floatingLabelBehavior: FloatingLabelBehavior.never,
//                             hintText:
//                                 "What are you allergic to? (Separate with comma)",
//                             contentPadding: EdgeInsets.zero,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Container(
//                         width: deviceWidth(context) * .8,
//                         margin: EdgeInsets.only(bottom: 30),
//                         height: 50,
//                         child: loading
//                             ? Center(
//                                 child: Container(
//                                   height: 50,
//                                   width: 50,
//                                   child: CircularProgressIndicator(),
//                                 ),
//                               )
//                             : ElevatedButton(
//                                 onPressed: () {
//                                   if (formKey.currentState!.validate()) {
//                                     setState(() {
//                                       loading = true;
//                                     });
//                                     Provider.of<AuthProvider>(context,
//                                             listen: false)
//                                         .updateProfile(
//                                             firstNameContr.text.trim(),
//                                             LastNameContr.text.trim(),
//                                             emailContr.text.trim(),
//                                             phoneContr.text.trim(),
//                                             religion == "Others"
//                                                 ? otherReligionController.text
//                                                     .trim()
//                                                 : religion,
//                                             addressCont.text.trim(),
//                                             nokNameContr.text.trim(),
//                                             nokPhoneContr.text.trim(),
//                                             nokEmailContr.text.trim(),
//                                             nokAddressCont.text.trim(),
//                                             allergyContr.text.trim(),
//                                             _imageFile != null
//                                                 ? _imageFile!.path
//                                                 : null,
//                                             true)
//                                         .then(
//                                           (value) => value.fold(
//                                             (l) {
//                                               showSnackbar(l, false);
//                                               setState(
//                                                 () {
//                                                   loading = false;
//                                                 },
//                                               );
//                                             },
//                                             (r) {
//                                               showSnackbar(
//                                                   "Profile successfully updated!",
//                                                   true);
//                                               setState(
//                                                 () {
//                                                   loading = false;
//                                                 },
//                                               );
//                                             },
//                                           ),
//                                         );
//                                   }
//                                 },
//                                 style: ButtonStyle(
//                                   backgroundColor: MaterialStateProperty.all(
//                                       Theme.of(context).primaryColor),
//                                 ),
//                                 child: Text(
//                                   "Update Profile",
//                                   style: TextStyle(
//                                       color: Colors.white, fontSize: 20),
//                                 ),
//                               ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Future<void> takePhoto(ImageSource source) async {
//     final imageGotten = await _picker.getImage(source: source);

//     setState(() {
//       _imageFile = imageGotten;
//     });
//   }
// }
