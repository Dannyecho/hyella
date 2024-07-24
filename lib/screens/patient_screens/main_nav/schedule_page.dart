import 'package:flutter/material.dart';
import 'package:hyella/helper/constants.dart';
import 'package:hyella/providers/schedule_provider.dart';
import 'package:hyella/screens/patient_screens/main_nav/sub_widgets/cancelled_schedule.dart';
import 'package:hyella/screens/patient_screens/main_nav/sub_widgets/completed_schedule.dart';
import 'package:hyella/screens/patient_screens/main_nav/sub_widgets/error_getting_appointments.dart';
import 'package:hyella/screens/patient_screens/main_nav/sub_widgets/shcedule_shimmer.dart';
import 'package:hyella/screens/patient_screens/main_nav/sub_widgets/upcoming_schedule.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../providers/nav_index_provider.dart';

class Schedule extends StatefulWidget {
  Schedule({Key? key}) : super(key: key);

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  TextEditingController newDateController = TextEditingController();
  TextEditingController newTimeController = TextEditingController();
  DateFormat dateFormat = DateFormat("M-d-y");
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool rescheduling = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color(0xffF8F8F8),
        body: WillPopScope(
          onWillPop: () async {
            Provider.of<NavIndexProvider>(context, listen: false).setIndex(0);
            return false;
          },
          child: SafeArea(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: deviceWidth(context) * .05),
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Schedule",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // give the tab bar a height [can change height to preferred height]
                  Container(
                    height: 45,
                    width: deviceWidth(context) * .9,
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
                        // first tab [you can add an icon using the icon property]
                        Tab(
                          text: 'Upcoming',
                        ),

                        // second tab [you can add an icon using the icon property]
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
                  Consumer<ScheduleProvider>(
                      builder: (context, ScheduleProvider schedule, wid) {
                    return Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          schedule.loadingUpcomingSch
                              ? ScheduleShimmer()
                              : schedule.errorLoadingUpcomingSch
                                  ? ErrorGettingAppointment()
                                  : UpcomingSchedule(),
                          schedule.loadingCompletedSch
                              ? ScheduleShimmer()
                              : schedule.errorLoadingCompletedSch
                                  ? ErrorGettingAppointment()
                                  : CompletedSchedule(),
                          schedule.loadingCanceledSch
                              ? ScheduleShimmer()
                              : schedule.errorLoadingCanceledSch
                                  ? ErrorGettingAppointment()
                                  : CancelledSchedule(),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void getAppointments() {
    Provider.of<ScheduleProvider>(context, listen: false).getSchedules();
  }
}
