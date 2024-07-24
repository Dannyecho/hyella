import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hyella/helper/constants.dart';
import 'package:hyella/helper/general_loader.dart';
import 'package:hyella/helper/scaffold_messg.dart';
import 'package:hyella/helper/styles.dart';
import 'package:hyella/models/schedule_model.dart';
import 'package:hyella/providers/auth_provider.dart';
import 'package:hyella/providers/schedule_provider.dart';
import 'package:hyella/screens/patient_screens/appointment_booking/new_reservation_page.dart';
import 'package:provider/provider.dart';

class UpcomingSchedule extends StatefulWidget {
  UpcomingSchedule({Key? key}) : super(key: key);

  @override
  State<UpcomingSchedule> createState() => _UpcomingScheduleState();
}

class _UpcomingScheduleState extends State<UpcomingSchedule> {
  bool cancellingAppointment = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable:
            Provider.of<ScheduleProvider>(context).upcomingSchedule,
        builder: (context, List<ScheduleModel> upcomingSchedules, wid) {
          return upcomingSchedules.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Styles.regular(
                          "You do not have any upcoming appointment\nin your schedule",
                          align: TextAlign.center),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    Provider.of<ScheduleProvider>(context, listen: false)
                        .getUpcomingApp();
                  },
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(top: 15),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                10.0,
                              ),
                              bottomRight: Radius.circular(
                                10.0,
                              ),
                              topRight: Radius.circular(
                                25.0,
                              ),
                              bottomLeft: Radius.circular(
                                10.0,
                              ),
                            ),
                          ),
                          elevation: 3,
                          shadowColor: Colors.black38,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          upcomingSchedules[index].title ?? "",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          upcomingSchedules[index].subTitle ??
                                              "",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black45),
                                        )
                                      ],
                                    ),
                                    CircleAvatar(
                                      radius: 25,
                                      child: upcomingSchedules[index].picture ==
                                              null
                                          ? Icon(Icons.person)
                                          : null,
                                      backgroundImage:
                                          upcomingSchedules[index].picture ==
                                                  null
                                              ? null
                                              : NetworkImage(
                                                  upcomingSchedules[index]
                                                      .picture!),
                                    )
                                  ],
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.solidCalendarDays,
                                            color: Color(0xffA8AFBD),
                                            size: 12,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            upcomingSchedules[index].date!,
                                            style: TextStyle(
                                                color: Color(0xff9A9A9B),
                                                fontSize: 12),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.solidClock,
                                            color: Color(0xffA8AFBD),
                                            size: 12,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            upcomingSchedules[index].time!,
                                            style: TextStyle(
                                              color: Color(0xff9A9A9B),
                                              fontSize: 12,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            size: 10,
                                            color: upcomingSchedules[index]
                                                        .status ==
                                                    "Paid"
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(upcomingSchedules[index].status!)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: deviceWidth(context) * .37,
                                      height: 50,
                                      child: TextButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                            Colors.white,
                                          ),
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                StatefulBuilder(
                                              builder: (context, set) {
                                                return AlertDialog(
                                                  title: Text(
                                                      "Cancel Appointment"),
                                                  content: Text(
                                                      "Are you sure you want to cancel the appointment?"),
                                                  actions: [
                                                    cancellingAppointment
                                                        ? Container(
                                                            height: 40,
                                                            child:
                                                                generalLoader(),
                                                          )
                                                        : Container(
                                                            height: 40,
                                                            child: TextButton(
                                                              style: ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all(
                                                                          Theme.of(context)
                                                                              .primaryColor)),
                                                              onPressed:
                                                                  () async {
                                                                set(
                                                                  () {
                                                                    cancellingAppointment =
                                                                        true;
                                                                  },
                                                                );

                                                                String? response = await Provider.of<
                                                                            ScheduleProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .cancelApp(
                                                                        upcomingSchedules[index]
                                                                            .key!);

                                                                if (response !=
                                                                    null) {
                                                                  Navigator.pop(
                                                                      context);
                                                                  showSnackbar(
                                                                      response,
                                                                      false);
                                                                  set(() {
                                                                    cancellingAppointment =
                                                                        false;
                                                                  });
                                                                } else {
                                                                  Navigator.pop(
                                                                      context);
                                                                  showSnackbar(
                                                                      "Appointment successfully cancelled!",
                                                                      true);

                                                                  Provider.of<ScheduleProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .getUpcomingApp();
                                                                  set(() {
                                                                    cancellingAppointment =
                                                                        false;
                                                                  });
                                                                }
                                                              },
                                                              child: Text(
                                                                "Yes",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        "No",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: deviceWidth(context) * .37,
                                      height: 40,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Theme.of(context)
                                                      .primaryColor),
                                        ),
                                        onPressed: () {
                                          // goto appointment page
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  NewReservation(
                                                specialties:
                                                    Provider.of<AuthProvider>(
                                                            context,
                                                            listen: false)
                                                        .userDetails
                                                        .menu!
                                                        .home!
                                                        .data!,
                                                oldSchedule:
                                                    upcomingSchedules[index],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Reschedule",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: upcomingSchedules.length,
                  ),
                );
        });
  }
}
