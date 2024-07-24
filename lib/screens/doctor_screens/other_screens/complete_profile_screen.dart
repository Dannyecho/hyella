// import 'dart:async';
// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import '../../../providers/auth_provider.dart';


// class CompleteProfile extends StatefulWidget {
//   const CompleteProfile({Key? key}) : super(key: key);

//   @override
//   State<CompleteProfile> createState() => _CompleteProfileState();
// }

// class _CompleteProfileState extends State<CompleteProfile> {
//   List<EduBackGround> edubgs = [
//     EduBackGround(
//       qualification: TextEditingController(),
//       endDate: TextEditingController(),
//       courseController: TextEditingController(),
//       schoolNameControler: TextEditingController(),
//       startDate: TextEditingController(),
//     )
//   ];
//   bool errorLoadingData = false;
//   bool loading = true;
//   List<DocSpecialtyModel> specialties = [];
//   List<RequiredDocuments> requiredDocuments = [];
//   List<DocSpecialtyModel> selectedSpecialties = [];
//   List<File> uploadedDocument = [];
//   GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   bool submitting = false;

//   @override
//   void initState() {
//     super.initState();
//     Timer.run(() {
//       getSpecialties();
//     });
//   }

//   void getSpecialties() {
//     setState(() {
//       loading = true;
//     });
//     UserDetails? userProfile =
//         Provider.of<AuthProvider>(context, listen: false).userDetails.value;

//     Provider.of<DoctorProfileProvide>(context, listen: false)
//         .getDoctorSpecialties(userProfile!.accessToken!)
//         .then((value) => value.fold((l) {
//               loading = false;
//               errorLoadingData = true;
//               setState(() {});
//             }, (r) {
//               specialties = r;
//               loading = false;
//               errorLoadingData = false;
//               setState(() {});
//             }));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Profile Settings"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//         child: loading
//             ? generalLoader()
//             : errorLoadingData
//                 ? SizedBox(
//                     width: deviceWidth(context),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Styles.bold(
//                             "Unable to load data at the moment\nplease try again later",
//                             fontSize: 14,
//                             align: TextAlign.center),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         ElevatedButton(
//                             onPressed: getSpecialties,
//                             child: const Text("Tap to retry"))
//                       ],
//                     ),
//                   )
//                 : SingleChildScrollView(
//                     child: Form(
//                       key: formKey,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Styles.regular(
//                             "Please provide the following information to complete your profile",
//                             align: TextAlign.center,
//                           ),
//                           const SizedBox(
//                             height: 20,
//                           ),
//                           Column(
//                             children: edubgs
//                                 .map(
//                                   (e) => Column(
//                                     children: [
//                                       TextFormField(
//                                         controller: e.schoolNameControler,
//                                         decoration: InputDecoration(
//                                           hintText: "Institution name",
//                                           border: OutlineInputBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                           ),
//                                           contentPadding:
//                                               const EdgeInsets.symmetric(
//                                             horizontal: 10,
//                                             vertical: 5,
//                                           ),
//                                         ),
//                                         validator: (value) {
//                                           if (value == null || value.isEmpty) {
//                                             return "Please input your institution name";
//                                           } else {
//                                             return null;
//                                           }
//                                         },
//                                       ),
//                                       const SizedBox(
//                                         height: 15,
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           SizedBox(
//                                             width: deviceWidth(context) * .4,
//                                             child: TextFormField(
//                                               controller: e.startDate,
//                                               onTap: () async {
//                                                 DateTime? selectedDate =
//                                                     await showDatePicker(
//                                                         context: context,
//                                                         initialDate:
//                                                             DateTime.now(),
//                                                         firstDate: DateTime
//                                                                 .now()
//                                                             .subtract(
//                                                                 const Duration(
//                                                                     days: 50 *
//                                                                         365)),
//                                                         lastDate:
//                                                             DateTime.now());
//                                                 if (selectedDate != null) {
//                                                   e.startDate.text.trim() =
//                                                       DateFormat("yyyy-MM-dd")
//                                                           .format(selectedDate);
//                                                 }
//                                               },
//                                               keyboardType: TextInputType.none,
//                                               decoration: InputDecoration(
//                                                 hintText: "Start date",
//                                                 border: OutlineInputBorder(
//                                                   borderRadius:
//                                                       BorderRadius.circular(10),
//                                                 ),
//                                                 contentPadding:
//                                                     const EdgeInsets.symmetric(
//                                                   horizontal: 10,
//                                                   vertical: 5,
//                                                 ),
//                                               ),
//                                               validator: (value) {
//                                                 if (value == null ||
//                                                     value.isEmpty) {
//                                                   return "Input start date";
//                                                 } else {
//                                                   return null;
//                                                 }
//                                               },
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: deviceWidth(context) * .4,
//                                             child: TextFormField(
//                                               controller: e.endDate,
//                                               onTap: () async {
//                                                 DateTime? selectedDate =
//                                                     await showDatePicker(
//                                                         context: context,
//                                                         initialDate:
//                                                             DateTime.now(),
//                                                         firstDate: DateTime
//                                                                 .now()
//                                                             .subtract(
//                                                                 const Duration(
//                                                                     days: 50 *
//                                                                         365)),
//                                                         lastDate:
//                                                             DateTime.now());
//                                                 if (selectedDate != null) {
//                                                   e.endDate.text.trim() =
//                                                       DateFormat("yyyy-MM-dd")
//                                                           .format(selectedDate);
//                                                 }
//                                               },
//                                               keyboardType: TextInputType.none,
//                                               decoration: InputDecoration(
//                                                 hintText: "End date",
//                                                 border: OutlineInputBorder(
//                                                   borderRadius:
//                                                       BorderRadius.circular(10),
//                                                 ),
//                                                 contentPadding:
//                                                     const EdgeInsets.symmetric(
//                                                   horizontal: 10,
//                                                   vertical: 5,
//                                                 ),
//                                               ),
//                                               validator: (value) {
//                                                 if (value == null ||
//                                                     value.isEmpty) {
//                                                   return "Input end date";
//                                                 } else {
//                                                   return null;
//                                                 }
//                                               },
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       const SizedBox(
//                                         height: 15,
//                                       ),
//                                       TextFormField(
//                                         controller: e.courseController,
//                                         decoration: InputDecoration(
//                                           hintText: "Course studied",
//                                           border: OutlineInputBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                           ),
//                                           contentPadding:
//                                               const EdgeInsets.symmetric(
//                                             horizontal: 10,
//                                             vertical: 5,
//                                           ),
//                                         ),
//                                         validator: (value) {
//                                           if (value == null || value.isEmpty) {
//                                             return "Please input the course studied";
//                                           } else {
//                                             return null;
//                                           }
//                                         },
//                                       ),
//                                       const Divider(
//                                         color: Colors.black,
//                                         height: 20,
//                                       )
//                                     ],
//                                   ),
//                                 )
//                                 .toList(),
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               edubgs.length > 1
//                                   ? SizedBox(
//                                       width: 40,
//                                       child: FloatingActionButton(
//                                         onPressed: () {
//                                           setState(() {
//                                             edubgs.removeLast();
//                                           });
//                                         },
//                                         backgroundColor: Colors.red,
//                                         child: const Icon(
//                                           Icons.remove,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     )
//                                   : SizedBox(),
//                               SizedBox(
//                                 width: edubgs.length > 1 ? 30 : 0,
//                               ),
//                               SizedBox(
//                                 width: 40,
//                                 child: FloatingActionButton(
//                                   onPressed: () {
//                                     edubgs.add(EduBackGround(
//                                         qualification: TextEditingController(),
//                                         endDate: TextEditingController(),
//                                         courseController:
//                                             TextEditingController(),
//                                         schoolNameControler:
//                                             TextEditingController(),
//                                         startDate: TextEditingController()));
//                                     setState(() {});
//                                   },
//                                   backgroundColor: Colors.green,
//                                   child: const Icon(
//                                     Icons.add,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                           const SizedBox(
//                             height: 15,
//                           ),
//                           MultiSelectDialogField<DocSpecialtyModel>(
//                             items: specialties
//                                 .map((e) =>
//                                     MultiSelectItem(e, e.specialityName!))
//                                 .toList(),
//                             listType: MultiSelectListType.LIST,
//                             title: Styles.regular(
//                               "Tap to select your areas of specialization",
//                             ),
//                             decoration: BoxDecoration(
//                               shape: BoxShape.rectangle,
//                               border: Border.all(
//                                 color: Colors.grey,
//                               ),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             buttonText: const Text(
//                                 "Tap to select your areas of specialization"),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return "Please select a specialty";
//                               } else {
//                                 return null;
//                               }
//                             },
//                             onConfirm: (values) {
//                               selectedSpecialties = values;
//                               values.forEach((element) {
//                                 requiredDocuments
//                                     .addAll(element.requiredDocuments!);
//                               });
//                               setState(() {});
//                             },
//                           ),
//                           const SizedBox(
//                             height: 15,
//                           ),
//                           requiredDocuments.isEmpty
//                               ? SizedBox()
//                               : Styles.bold(
//                                   "Please upload the following documents",
//                                   fontSize: 14),
//                           const SizedBox(
//                             height: 15,
//                           ),
//                           // Column(
//                           //   children: selectedSpecialties
//                           //       .map((e) => e.requiredDocuments
//                           //           .map((e) => Container())
//                           //           .toList())
//                           //       .toList(),
//                           // ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: requiredDocuments
//                                 .toSet()
//                                 .map(
//                                   (e) => Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Styles.regular(e.document!.documentName!),
//                                       Row(
//                                         children: [
//                                           TextButton(
//                                             onPressed: () async {
//                                               FilePickerResult? result =
//                                                   await FilePicker.platform
//                                                       .pickFiles();

//                                               if (result != null) {
//                                                 File file = File(
//                                                     result.files.single.path!);

//                                                 // add the selected file to the corresponding document
//                                                 var sepcInQuestion =
//                                                     selectedSpecialties
//                                                         .firstWhere((element) =>
//                                                             element.id ==
//                                                             e.specialityId);

//                                                 var docInQuestion =
//                                                     sepcInQuestion
//                                                         .requiredDocuments!
//                                                         .firstWhere((element) =>
//                                                             element.id == e.id);
//                                                 // set the uploaded document path as the description of the document, which will be used while uploading the document
//                                                 docInQuestion.document!
//                                                         .documentDescription =
//                                                     file.path;
//                                                 // I dont need this for now
//                                                 // uploadedDocument.add(file);
//                                                 e.uploaded = true;
//                                                 setState(() {});
//                                               } else {
//                                                 // User canceled the picker
//                                               }
//                                             },
//                                             child: Text(
//                                               "Tap to upload document",
//                                               style: TextStyle(
//                                                   color: Theme.of(context)
//                                                       .primaryColor),
//                                             ),
//                                             style: ButtonStyle(
//                                               backgroundColor:
//                                                   MaterialStateProperty.all(
//                                                       Colors.white),
//                                               shape: MaterialStateProperty.all(
//                                                 RoundedRectangleBorder(
//                                                   side: const BorderSide(
//                                                     color: Colors.grey,
//                                                   ),
//                                                   borderRadius:
//                                                       BorderRadius.circular(10),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           const SizedBox(
//                                             width: 20,
//                                           ),
//                                           e.uploaded
//                                               ? const Icon(
//                                                   Icons.done,
//                                                   color: Colors.green,
//                                                 )
//                                               : SizedBox()
//                                         ],
//                                       ),
//                                       const SizedBox(
//                                         height: 10,
//                                       )
//                                     ],
//                                   ),
//                                 )
//                                 .toList(),
//                           ),
//                           const SizedBox(
//                             height: 20,
//                           ),
//                           submitting
//                               ? generalLoader()
//                               : Container(
//                                   alignment: Alignment.center,
//                                   child: SizedBox(
//                                     width: deviceWidth(context),
//                                     height: 45,
//                                     child: ElevatedButton(
//                                       onPressed: () async {
//                                         if (formKey.currentState!.validate()) {
//                                           if (requiredDocuments
//                                               .where((element) =>
//                                                   !element.uploaded)
//                                               .isNotEmpty) {
//                                             showSnackbar(context,
//                                                 "Please ensure you upload all the required documents.");
//                                             return;
//                                           }

//                                           setState(() {
//                                             submitting = true;
//                                           });
//                                           UserDetails userDetails =
//                                               Provider.of<AuthProvider>(context,
//                                                       listen: false)
//                                                   .userDetails
//                                                   .value!;
//                                           // continue submission
//                                           Provider.of<DoctorProfileProvide>(
//                                                   context,
//                                                   listen: false)
//                                               .updateProfile(
//                                                 userDetails.accessToken!,
//                                                 userDetails.id!,
//                                                 edubgs,
//                                                 selectedSpecialties,
//                                               )
//                                               .then(
//                                                 (value) => value.fold(
//                                                   (l) {
//                                                     setState(() {
//                                                       submitting = false;
//                                                     });
//                                                     showSnackbar(context, l);
//                                                   },
//                                                   (r) {
//                                                     setState(() {
//                                                       submitting = false;
//                                                     });
//                                                     showSnackbar(context, r!);

//                                                     Future.delayed(
//                                                         Duration(seconds: 2),
//                                                         () {
//                                                       Navigator.pop(context);
//                                                     });
//                                                   },
//                                                 ),
//                                               );
//                                         }
//                                       },
//                                       style: ButtonStyle(
//                                         backgroundColor:
//                                             MaterialStateProperty.all(
//                                           Colors.green.withOpacity(0.9),
//                                         ),
//                                         shape: MaterialStateProperty.all(
//                                           RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                           ),
//                                         ),
//                                       ),
//                                       child: const Text(
//                                         "Submit Profile",
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                         ],
//                       ),
//                     ),
//                   ),
//       ),
//     );
//   }
// }
