import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:hyella/helper/route_generator.dart';
import 'package:hyella/models/appoitments_model.dart';
import 'package:hyella/models/signup_result_model.dart';
import 'package:hyella/providers/doctor_appointments_list_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../helper/general_loader.dart';
import '../../../helper/scaffold_messg.dart';
import '../../../helper/styles.dart';
import '../../../providers/nav_index_provider.dart';
import '../../../providers/schedule_provider.dart';

class ProviderSchedule extends StatefulWidget {
  const ProviderSchedule({Key? key}) : super(key: key);

  @override
  _ProviderScheduleState createState() => _ProviderScheduleState();
}

class _ProviderScheduleState extends State<ProviderSchedule>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  TextEditingController newDateController = TextEditingController();
  TextEditingController newTimeController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  DateFormat dateFormat = DateFormat("M-d-y");
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool accepting = false;

  bool cancellingAppointment = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          title: Text(
            "Schedule",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: WillPopScope(
          onWillPop: () async {
            Provider.of<NavIndexProvider>(context, listen: false).setIndex(0);
            return false;
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: _width * .05),
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 45,
                  width: _width * .9,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10)),
                  child: TabBar(
                    controller: _tabController,
                    // give the indicator a decoration (color and border radius)
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          10.0,
                        ),
                        color: Theme.of(context).primaryColor),
                    labelColor: Colors.white,

                    unselectedLabelColor: Colors.black45,
                    tabs: [
                      Tab(
                        text: 'Upcoming',
                      ),
                      Tab(
                        text: 'Completed',
                      ),
                      Tab(
                        text: 'Cancelled',
                      ),
                    ],
                  ),
                ),
                // tab bar view here
                Consumer<DoctorAppointmentProvider>(builder:
                    (context, DoctorAppointmentProvider schedule, wid) {
                  return Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        schedule.loadingUpcomingSch
                            ? shimmerEffect()
                            : upcomingTab(_width),
                        schedule.loadingCompletedSch
                            ? shimmerEffect()
                            : completedTab(_width),
                        schedule.loadingCanceledSch
                            ? shimmerEffect()
                            : cancelledTab(_width),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget upcomingTab(double width) {
    return ValueListenableBuilder(
      valueListenable:
          Provider.of<DoctorAppointmentProvider>(context).upcomingSchedule,
      builder: (context, List<AppointmentModel> upcomingSchedules, wid) {
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
                  Provider.of<DoctorAppointmentProvider>(context, listen: false)
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
                                        upcomingSchedules[index].title!,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        upcomingSchedules[index].subTitle ?? "",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black45),
                                      )
                                    ],
                                  ),
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundImage: NetworkImage(
                                        upcomingSchedules[index].picture!),
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
                                          color:
                                              upcomingSchedules[index].status ==
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
                                  Expanded(
                                    child: Container(
                                      width: width * .37,
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
                                                            height: 25,
                                                            width: 25,
                                                            child:
                                                                generalLoader(),
                                                          )
                                                        : Container(
                                                            height: 40,
                                                            child: TextButton(
                                                              style:
                                                                  ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty.all(
                                                                        Theme.of(context)
                                                                            .primaryColor),
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                set(() {
                                                                  cancellingAppointment =
                                                                      true;
                                                                });

                                                                String? response = await Provider.of<
                                                                            DoctorAppointmentProvider>(
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
                                                            color:
                                                                Colors.black),
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
                                  ),
                                  Expanded(
                                      child: IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                        CHAT,
                                        arguments: {
                                          'pid':
                                              GetIt.I<UserDetails>().user!.pid!,
                                          'receiver_name':
                                              upcomingSchedules[index].title,
                                          'channel_id': upcomingSchedules[index]
                                              .channelName!,
                                          'receiver_id':
                                              upcomingSchedules[index]
                                                  .receiverId!,
                                          'is_doctor': true,
                                          'key': upcomingSchedules[index].key!
                                        },
                                      );
                                    },
                                    icon: Icon(Icons.chat_outlined),
                                  )),
                                  upcomingSchedules[index].status == "Pending"
                                      ? Expanded(
                                          child: Container(
                                            width: width * .37,
                                            height: 40,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Theme.of(context)
                                                            .primaryColor),
                                              ),
                                              onPressed: () {
                                                // set initial text fields values
                                                setState(() {
                                                  newDateController.text =
                                                      upcomingSchedules[index]
                                                          .date!;
                                                  newTimeController.text =
                                                      upcomingSchedules[index]
                                                          .time!;
                                                });
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      StatefulBuilder(builder:
                                                          (context, reload) {
                                                    return SimpleDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                      title: Text(
                                                          "Accept Appointment"),
                                                      titlePadding:
                                                          EdgeInsets.only(
                                                        left: 15,
                                                        right: 15,
                                                        top: 15,
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      contentPadding:
                                                          EdgeInsets.all(15),
                                                      children: [
                                                        Text(
                                                            "Please propose new date and time if you are not comfortable with the current date and time."),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Form(
                                                          key: formKey,
                                                          child: Column(
                                                            children: [
                                                              TextFormField(
                                                                controller:
                                                                    newDateController,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .none,
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      "Tap to select a new date",
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                    ),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                    ),
                                                                  ),
                                                                  errorBorder: OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      borderSide:
                                                                          BorderSide(
                                                                              color: Colors.red[500]!)),
                                                                ),
                                                                onTap:
                                                                    () async {
                                                                  DateTime?
                                                                      date =
                                                                      await showDatePicker(
                                                                    context:
                                                                        context,
                                                                    initialDate:
                                                                        DateTime
                                                                            .now(),
                                                                    firstDate:
                                                                        DateTime
                                                                            .now(),
                                                                    lastDate:
                                                                        DateTime.now()
                                                                            .add(
                                                                      Duration(
                                                                          days:
                                                                              365),
                                                                    ),
                                                                  );

                                                                  if (date !=
                                                                      null) {
                                                                    newDateController
                                                                            .text =
                                                                        dateFormat
                                                                            .format(date);
                                                                  }
                                                                },
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              TextFormField(
                                                                controller:
                                                                    newTimeController,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .none,
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      "Tap to select a new time",
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                    ),
                                                                  ),
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                    ),
                                                                  ),
                                                                  errorBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                Colors.red[500]!),
                                                                  ),
                                                                ),
                                                                onTap:
                                                                    () async {
                                                                  TimeOfDay? time = await showTimePicker(
                                                                      context:
                                                                          context,
                                                                      initialTime:
                                                                          TimeOfDay
                                                                              .now());

                                                                  if (time !=
                                                                      null) {
                                                                    newTimeController
                                                                            .text =
                                                                        time.format(
                                                                            context);
                                                                  }
                                                                },
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              TextFormField(
                                                                controller:
                                                                    remarkController,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .text,
                                                                maxLines: 5,
                                                                minLines: 3,
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      "Do you have any remarks?",
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                    ),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                    ),
                                                                  ),
                                                                  errorBorder:
                                                                      OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              10),
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                Colors.red[500]!,
                                                                          )),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              accepting
                                                                  ? Container(
                                                                      height:
                                                                          40,
                                                                      child:
                                                                          generalLoader(),
                                                                    )
                                                                  : ElevatedButton(
                                                                      onPressed:
                                                                          () async {
                                                                        reload(
                                                                            () {
                                                                          accepting =
                                                                              true;
                                                                        });
                                                                        Provider.of<ScheduleProvider>(context, listen: false)
                                                                            .acceptApp(
                                                                                upcomingSchedules[index].key!,
                                                                                newDateController.text.trim(),
                                                                                newTimeController.text.trim(),
                                                                                remarkController.text)
                                                                            .then(
                                                                          (value) {
                                                                            value.fold(
                                                                              (l) {
                                                                                showSnackbar(l, false);
                                                                              },
                                                                              (r) {
                                                                                showSnackbar(r, true);
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                            );
                                                                          },
                                                                        );
                                                                        reload(
                                                                            () {
                                                                          accepting =
                                                                              false;
                                                                        });
                                                                      },
                                                                      child: Text(
                                                                          "Accept"),
                                                                      style:
                                                                          ButtonStyle(
                                                                        backgroundColor:
                                                                            MaterialStateProperty.all(Theme.of(context).primaryColor),
                                                                      ),
                                                                    )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    );
                                                  }),
                                                );
                                              },
                                              child: Text(
                                                "Accept",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox()
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
      },
    );
  }

  Widget completedTab(double width) {
    return ValueListenableBuilder(
        valueListenable:
            Provider.of<DoctorAppointmentProvider>(context).completedSchedule,
        builder: (context, List<AppointmentModel> completedSchedule, wid) {
          return completedSchedule.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Styles.regular(
                          "You do not have any completed appointment\nin your schedule",
                          align: TextAlign.center),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    Provider.of<DoctorAppointmentProvider>(context,
                            listen: false)
                        .getCompletedApp();
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
                            padding: const EdgeInsets.all(20.0),
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
                                          completedSchedule[index].title!,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          completedSchedule[index].subTitle ??
                                              "",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black45),
                                        )
                                      ],
                                    ),
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundImage: NetworkImage(
                                          completedSchedule[index].picture!),
                                    )
                                  ],
                                ),
                                Divider(),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.solidCalendarAlt,
                                            color: Color(0xffA8AFBD),
                                            size: 12,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            completedSchedule[index].date!,
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
                                            FontAwesomeIcons.solidClock,
                                            color: Color(0xffA8AFBD),
                                            size: 12,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            completedSchedule[index].time!,
                                            style: TextStyle(
                                                color: Color(0xff9A9A9B),
                                                fontSize: 12),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: completedSchedule.length,
                  ),
                );
        });
  }

  Widget cancelledTab(double width) {
    return ValueListenableBuilder(
      valueListenable:
          Provider.of<DoctorAppointmentProvider>(context).canceledSchedule,
      builder: (context, List<AppointmentModel> cancelledSchedules, wid) {
        return cancelledSchedules.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Styles.regular(
                        "You do not have any cancelled appointment\nin your schedule",
                        align: TextAlign.center),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  Provider.of<DoctorAppointmentProvider>(context, listen: false)
                      .getCanceledApp();
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
                                        cancelledSchedules[index].title!,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        cancelledSchedules[index].subTitle ??
                                            "",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black45,
                                        ),
                                      )
                                    ],
                                  ),
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundImage: NetworkImage(
                                        cancelledSchedules[index].picture!),
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
                                          FontAwesomeIcons.solidCalendarAlt,
                                          color: Color(0xffA8AFBD),
                                          size: 12,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          cancelledSchedules[index].date!,
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
                                          cancelledSchedules[index].time!,
                                          style: TextStyle(
                                            color: Color(0xff9A9A9B),
                                            fontSize: 12,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: cancelledSchedules.length,
                ),
              );
      },
    );
  }

  Widget shimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemBuilder: (context, index) => Container(
          height: 100,
          margin: EdgeInsets.symmetric(vertical: 10),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        itemCount: 8,
      ),
    );
  }
}
