// import 'package:flutter/material.dart';

// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:hyella/helper/colors.dart';
// import 'package:hyella/helper/get_random_colors.dart';
// import 'package:hyella/models/doctor_model.dart';
// import 'package:hyella/models/review_model.dart';

// class DoctorDetail extends StatefulWidget {
//   final Doctor? doctor;
//   DoctorDetail({Key? key, this.doctor}) : super(key: key);

//   @override
//   _DoctorDetailState createState() => _DoctorDetailState();
// }

// class _DoctorDetailState extends State<DoctorDetail> {
//   List<ReviewModel> reviews = [];

//   @override
//   void initState() {
//     super.initState();
//     getReviews();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double _width = MediaQuery.of(context).size.width;
//     final double _height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       bottomSheet: Container(
//         padding: EdgeInsets.symmetric(horizontal: _width * .05, vertical: 5),
//         height: 120,
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Consultation price",
//                   style: TextStyle(
//                     color: Colors.black45,
//                   ),
//                 ),
//                 Text(
//                   widget.doctor!.cPrice,
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//                 )
//               ],
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Container(
//               width: _width * .9,
//               height: 60,
//               child: TextButton(
//                 style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all(
//                         Theme.of(context).primaryColor)),
//                 onPressed: () {},
//                 child: Text(
//                   "Book Appointment",
//                   style: TextStyle(color: Colors.white, fontSize: 20),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//       body: SafeArea(
//         child: Container(
//           color: Theme.of(context).primaryColor,
//           child: Column(
//             children: [
//               Container(
//                 height: _height * .3,
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Container(
//                           width: _width * .33,
//                           alignment: Alignment.topLeft,
//                           child: IconButton(
//                             onPressed: () => Navigator.pop(context),
//                             icon:
//                                 Icon(Icons.arrow_back_ios, color: Colors.white),
//                           ),
//                         ),
//                         Container(
//                           width: _width * .33,
//                           padding: EdgeInsets.only(top: 30),
//                           alignment: Alignment.center,
//                           child: CircleAvatar(
//                             radius: 50,
//                             child: Icon(
//                               Icons.person,
//                               size: 50,
//                               color: Colors.white,
//                             ),
//                             backgroundColor: Color(0xffD0D4FE),
//                           ),
//                         ),
//                         Container(
//                           width: _width * .33,
//                         )
//                       ],
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Text(
//                       widget.doctor!.name,
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 25,
//                           fontWeight: FontWeight.w500),
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     Text(
//                       widget.doctor!.specialty,
//                       style: TextStyle(color: Colors.white30, fontSize: 15),
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         GestureDetector(
//                           onTap: () {},
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: CircleAvatar(
//                               radius: 30,
//                               backgroundColor: Color(0xff9F97E3),
//                               child: Icon(Icons.call,
//                                   size: 30, color: Colors.white),
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: CircleAvatar(
//                             radius: 30,
//                             backgroundColor: Color(0xff9F97E3),
//                             child: Icon(
//                               FontAwesomeIcons.solidCommentDots,
//                               size: 30,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: CircleAvatar(
//                             radius: 30,
//                             backgroundColor: Color(0xff9F97E3),
//                             child: Icon(
//                               Icons.video_call,
//                               size: 30,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: Container(
//                   width: _width,
//                   padding: EdgeInsets.symmetric(horizontal: _width * .05),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(15),
//                       topRight: Radius.circular(15),
//                     ),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: 20),
//                       Text(
//                         "About doctor",
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500, fontSize: 25),
//                       ),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Text(
//                         widget.doctor!.description!,
//                         style: TextStyle(
//                             fontWeight: FontWeight.w400, fontSize: 20),
//                       ),
//                       SizedBox(
//                         height: 15,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               Text(
//                                 "Reviews",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w500, fontSize: 25),
//                               ),
//                               SizedBox(
//                                 width: 5,
//                               ),
//                               Icon(
//                                 Icons.star,
//                                 size: 18,
//                                 color: getColor(widget.doctor!.rating!.round()),
//                               ),
//                               Text(
//                                 widget.doctor!.rating.toString(),
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                             ],
//                           ),
//                           TextButton(
//                             onPressed: () {},
//                             child: Text(
//                               "See all",
//                               style: TextStyle(
//                                   color: Theme.of(context).primaryColor),
//                             ),
//                           )
//                         ],
//                       ),
//                       reviews.isEmpty
//                           ? Center(
//                               child: CircularProgressIndicator(),
//                             )
//                           : Container(
//                               height: 150,
//                               child: ListView.builder(
//                                 itemBuilder: (context, index) {
//                                   return Container(
//                                     width: _width * .7,
//                                     child: Card(
//                                       elevation: 3,
//                                       shadowColor: Colors.black26,
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(10.0),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Row(
//                                                   children: [
//                                                     CircleAvatar(
//                                                       backgroundColor:
//                                                           avatarBgColor,
//                                                       radius: 25,
//                                                       child: Icon(
//                                                         Icons.person,
//                                                         color: Colors.white,
//                                                       ),
//                                                     ),
//                                                     SizedBox(
//                                                       width: 15,
//                                                     ),
//                                                     Column(
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .start,
//                                                       children: [
//                                                         Text(
//                                                           reviews[index].name,
//                                                           overflow: TextOverflow
//                                                               .ellipsis,
//                                                           style: TextStyle(
//                                                             fontSize: 20,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w500),
//                                                         ),
//                                                         SizedBox(
//                                                           height: 5,
//                                                         ),
//                                                         Text(
//                                                           reviews[index]
//                                                                       .date
//                                                                       .difference(
//                                                                           DateTime
//                                                                               .now())
//                                                                       .inDays >
//                                                                   1
//                                                               ? reviews[index]
//                                                                       .date
//                                                                       .difference(
//                                                                           DateTime
//                                                                               .now())
//                                                                       .inDays
//                                                                       .toString() +
//                                                                   " days ago"
//                                                               : reviews[index]
//                                                                       .date
//                                                                       .difference(
//                                                                           DateTime
//                                                                               .now())
//                                                                       .inDays
//                                                                       .toString() +
//                                                                   " day ago",
//                                                           style: TextStyle(fontSize: 15,
//                                                               color: Colors
//                                                                   .black54),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Container(
//                                                   margin: EdgeInsets.only(
//                                                       right: 10),
//                                                   padding: EdgeInsets.symmetric(
//                                                       horizontal: 5,
//                                                       vertical: 3),
//                                                   decoration: BoxDecoration(
//                                                     color: Color(0xffFEF8EA),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             10),
//                                                   ),
//                                                   child: Row(
//                                                     mainAxisSize:
//                                                         MainAxisSize.min,
//                                                     children: [
//                                                       Icon(
//                                                         Icons.star,
//                                                         size: 18,
//                                                         color: getColor(widget
//                                                             .doctor!.rating!
//                                                             .round()),
//                                                       ),
//                                                       Text(widget.doctor!.rating
//                                                           .toString())
//                                                     ],
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                             SizedBox(
//                                               height: 12,
//                                             ),
//                                             Text(
//                                               reviews[index].review,
//                                               maxLines: 2,
//                                               overflow: TextOverflow.ellipsis,
//                                               style: TextStyle(
//                                                   fontWeight: FontWeight.w400, fontSize: 20),
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 itemCount: reviews.length,
//                                 scrollDirection: Axis.horizontal,
//                               ),
//                             ),
//                       SizedBox(
//                         height: 15,
//                       ),
//                       Text(
//                         "Location",
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500, fontSize: 25),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           CircleAvatar(
//                             radius: 30,
//                             backgroundColor: Color(0xffF0EEFA),
//                             child: Icon(
//                               Icons.location_pin,
//                               size: 30,
//                               color: Theme.of(context).primaryColor,
//                             ),
//                           ),
//                           SizedBox(
//                             width: 20,
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 widget.doctor!.hospital,
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w400, fontSize: 20),
//                               ),
//                               SizedBox(
//                                 height: 5,
//                               ),
//                               Text(
//                                 widget.doctor!.location,
//                                 style: TextStyle(
//                                     fontSize: 15, color: Colors.black45),
//                               )
//                             ],
//                           )
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void getReviews() {
//     //get reviews from the back end
//     var r = <ReviewModel>[
//       ReviewModel(
//           id: "1",
//           name: "Joana Perkins",
//           rating: "5.0",
//           review:
//               "Many Thanks to the doctor,aaa aaaaa aaaaaaaaa aaaaaaaaaaa aaaaaaa",
//           date: DateTime.now(),
//           userDp: "userDp"),
//       ReviewModel(
//           id: "1",
//           name: "Joana Perkins",
//           date: DateTime.now(),
//           rating: "5.0",
//           review: "Many Thanks to the doctor",
//           userDp: "userDp"),
//     ];

//     setState(() {
//       reviews = r;
//     });
//   }
// }
