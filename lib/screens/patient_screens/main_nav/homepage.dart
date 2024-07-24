import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:hyella/models/signup_result_model.dart';
import 'package:hyella/providers/nav_index_provider.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:hyella/providers/schedule_provider.dart';
import 'package:hyella/screens/custom_web_view.dart';
import 'package:hyella/screens/patient_screens/main_nav/schedule_page.dart';
import 'package:hyella/screens/patient_screens/main_nav/services.dart';
import 'package:hyella/screens/patient_screens/main_nav/settings.dart';
import 'package:provider/provider.dart';
import '../../../providers/messaging_provider.dart';
import 'dashboard.dart';
import 'messages.dart';

class HomePage extends StatefulWidget {
  final int? index;
  HomePage({
    Key? key,
     this.index
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final iconList = <IconData>[
    Icons.home_filled,
    FontAwesomeIcons.solidCommentDots,
    Icons.schedule_rounded,
    Icons.more,
  ];
  @override
  void initState() {
    super.initState();
    Timer.run(() {
      Provider.of<NavIndexProvider>(context, listen: false).setIndex(widget.index?? 0);
      Provider.of<ChatHeadsProvider>(context, listen: false).getContacts(false);
      Provider.of<ScheduleProvider>(context, listen: false).getSchedules();
    });
  }

  final titles = <String>["Home", "Chats", "Schedule", "More"];
  final UserDetails userDetails = GetIt.I<UserDetails>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        elevation: 8,
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.medical_services,
          color: Colors.white,
        ),
        onPressed: () {
          Provider.of<NavIndexProvider>(context, listen: false).setIndex(4);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        tabBuilder: (int index, bool isActive) {
          final color =
              isActive ? Theme.of(context).primaryColor : Colors.blueGrey;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              index == 1
                  ? Container(
                      width: 30,
                      child: Stack(
                        children: [
                          Icon(
                            iconList[index],
                            size: 24,
                            color: color,
                          ),
                          Consumer<ChatHeadsProvider>(
                            builder: (context, provider, wid) {
                              if (provider.contacts
                                      .where((element) =>
                                          element.unreadMessages! > 0)
                                      .length >
                                  0)
                                return Align(
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
                                );

                              return SizedBox();
                            },
                          ),
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
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.defaultEdge,
        onTap: (index) => Provider.of<NavIndexProvider>(context, listen: false)
            .setIndex(index),
      ),
      body: [
        userDetails.webViews?.home!.webview == 1
            ? GeneralWebview(
                url: userDetails.webViews!.home!.endpoint!,
                nwpRequest: userDetails.webViews!.home!.params!.nwpWebiew!,
              )
            : Dashboard(),
        userDetails.webViews?.chat!.webview == 1
            ? GeneralWebview(
                url: userDetails.webViews!.chat!.endpoint!,
                nwpRequest: userDetails.webViews!.chat!.params!.nwpWebiew!,
              )
            : Messages(),
        userDetails.webViews?.schedule!.webview == 1
            ? GeneralWebview(
                url: userDetails.webViews!.schedule!.endpoint!,
                nwpRequest: userDetails.webViews!.schedule!.params!.nwpWebiew!,
              )
            : Schedule(),
        // userDetails.webViews?.more!.webview == 1
        //     ? GeneralWebview(
        //         url: userDetails.webViews!.more!.endpoint!,
        //         nwpRequest: userDetails.webViews!.more!.params!.nwpWebiew!,
        //       )
        //     :
        Settings(),
        userDetails.webViews?.services!.webview == 1
            ? GeneralWebview(
                url: userDetails.webViews!.services!.endpoint!,
                nwpRequest: userDetails.webViews!.services!.params!.nwpWebiew!,
              )
            : Services(),
      ][Provider.of<NavIndexProvider>(context, listen: true).currentIndex],
    );
  }
}
