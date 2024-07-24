import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hyella/helper/styles.dart';
import 'package:hyella/models/schedule_model.dart';
import 'package:hyella/providers/schedule_provider.dart';
import 'package:provider/provider.dart';

class CompletedSchedule extends StatelessWidget {
  const CompletedSchedule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Provider.of<ScheduleProvider>(context).completedSchedule,
      builder: (context, List<ScheduleModel> completedSchedule, wid) {
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
                  Provider.of<ScheduleProvider>(context, listen: false)
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
                                        completedSchedule[index].subTitle ?? "",
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
                                          FontAwesomeIcons.solidCalendarDays,
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
      },
    );
  }
}
