import 'dart:async';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hyella/providers/doctor_appointments_list_provider.dart';
import 'package:hyella/screens/doctor_screens/main_nav_screens/profile.dart';
import 'package:hyella/screens/doctor_screens/main_nav_screens/schedule.dart';
import 'package:provider/provider.dart';
import '../../../providers/messaging_provider.dart';
import '../../../providers/nav_index_provider.dart';
import 'dashboard.dart';
import 'messages.dart';

class ProviderHome extends StatefulWidget {
  const ProviderHome({Key? key}) : super(key: key);

  @override
  _ProviderHomeState createState() => _ProviderHomeState();
}

class _ProviderHomeState extends State<ProviderHome>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    Timer.run(() {
      Provider.of<NavIndexProvider>(context, listen: false).setIndex(0);
      Provider.of<ChatHeadsProvider>(context, listen: false).getContacts(true);
      Provider.of<DoctorAppointmentProvider>(context, listen: false)
          .getSchedules();
    });
  }

  final iconList = <IconData>[
    Icons.home_filled,
    Icons.schedule,
    FontAwesomeIcons.solidCommentDots,
    Icons.more,
  ];

  final titles = <String>["Home", "Schedule", "Chats", "More"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        tabBuilder: (int index, bool isActive) {
          final color =
              isActive ? Theme.of(context).primaryColor : Colors.blueGrey;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              index == 2
                  ? Container(
                      width: 35,
                      child: Stack(
                        children: [
                          Icon(
                            iconList[index],
                            size: 24,
                            color: color,
                          ),
                          Consumer<ChatHeadsProvider>(
                              builder: (context, provider, wid) {
                            return provider.contacts
                                        .where((e) => e.unreadMessages! > 0)
                                        .length >
                                    0
                                ? Align(
                                    alignment: AlignmentDirectional.topEnd,
                                    child: CircleAvatar(
                                      radius: 8,
                                      backgroundColor: Colors.blue,
                                      child: Text(
                                        provider.contacts
                                            .where((element) =>
                                                element.unreadMessages! > 0)
                                            .length
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 8,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox();
                          }),
                        ],
                      ),
                    )
                  : Icon(
                      iconList[index],
                      size: 24,
                      color: color,
                    ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  titles[index],
                  maxLines: 1,
                  style: TextStyle(color: color),
                ),
              )
            ],
          );
        },
        activeIndex:
            Provider.of<NavIndexProvider>(context, listen: true).currentIndex,
        gapLocation: GapLocation.none,
        notchSmoothness: NotchSmoothness.softEdge,
        onTap: (index) => Provider.of<NavIndexProvider>(context, listen: false)
            .setIndex(index),
      ),
      body: [
        ProviderDashboard(),
        ProviderSchedule(),
        DoctorMessages(),
        ProviderProfile(),
      ][Provider.of<NavIndexProvider>(context, listen: true).currentIndex],
    );
  }
}
