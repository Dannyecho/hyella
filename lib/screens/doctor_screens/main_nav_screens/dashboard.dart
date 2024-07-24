import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hyella/helper/constants.dart';
import 'package:hyella/helper/styles.dart';
import 'package:hyella/models/signup_result_model.dart';

import 'package:hyella/screens/doctor_screens/card_details/announcements_view.dart';
import 'package:hyella/screens/doctor_screens/card_details/my_patients_view.dart';
import 'package:hyella/screens/doctor_screens/card_details/virtual_consultations_view.dart';

class ProviderDashboard extends StatelessWidget {
  ProviderDashboard({Key? key}) : super(key: key);

  final UserDetails userDetails = GetIt.I<UserDetails>();
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:
          SystemUiOverlayStyle(statusBarColor: Theme.of(context).primaryColor),
      child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  minLeadingWidth: 60,
                  leading: (userDetails.user!.dp == null ||
                          userDetails.user!.dp!.isEmpty)
                      ? CircleAvatar(
                          radius: 50,
                          backgroundColor: Color(0xffC6C6C6),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 50,
                          ),
                        )
                      : CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(userDetails.user!.dp!),
                          backgroundColor: Colors.purple[200],
                        ),
                  subtitle: Styles.semiBold(
                      userDetails.user!.userNameSubtitle ?? "",
                      fontSize: 14,
                      color: Colors.white),
                  title: Styles.bold(
                    userDetails.user!.fullName ?? "",
                    color: Colors.white,
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  height: deviceHeight(context) * .3,
                  width: deviceWidth(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userDetails.appChart!.title ?? "",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        userDetails.appChart!.subtitle ?? "",
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: deviceHeight(context) * .2,
                        width: deviceWidth(context),
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: DChartBarO(
                          groupList: [
                            OrdinalGroup(
                              id: "Bar",
                              data: userDetails.appChart!.data!
                                  .map((e) => OrdinalData(
                                        domain: e.title!,
                                        measure: e.value!,
                                      ))
                                  .toList(),
                            )
                          ],
                          domainAxis: const DomainAxis(
                            gapAxisToLabel: 16,
                            tickLength: 2,
                            lineStyle: LineStyle(color: Colors.white),
                            labelStyle: LabelStyle(
                              color: Colors.white,
                            ),
                          ),
                          /* domainLabelColor: ,
                          measureLabelColor: Colors.white,
                          axisLineColor: Colors.white,
                          measureLabelPaddingToAxisLine: 16,
                          barColor: (barData, index, id) => Colors.white,
                          showBarValue: true, */
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    width: deviceWidth(context),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                      color: Colors.white,
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: userDetails.menu!.cards!.data!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            if (index == 0) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MyPatientsView(),
                                ),
                              );
                            } else if (index == 1) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => VirtualConsultations(),
                                ),
                              );
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AnnouncementsView(),
                                ),
                              );
                            }
                          },
                          child: Container(
                            height: 80,
                            margin: EdgeInsets.only(
                              bottom: 10,
                              left: deviceWidth(context) * .05,
                              right: deviceWidth(context) * .05,
                            ),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color:
                                  userDetails.menu!.cards!.data![index].key ==
                                          "myem"
                                      ? Color(0xffEEF1FB)
                                      : Color(0xffFAF2E9),
                              borderRadius: BorderRadius.circular(
                                15,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  padding: EdgeInsets.all(8),
                                  child: Image.network(userDetails
                                      .menu!.cards!.data![index].picture!),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      userDetails
                                          .menu!.cards!.data![index].title!,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      userDetails
                                          .menu!.cards!.data![index].title!,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
