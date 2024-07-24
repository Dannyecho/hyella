
import 'package:flutter/material.dart';
import 'package:hyella/helper/constants.dart';
import 'package:hyella/custom_widgets/home_page_headers.dart';
import 'package:hyella/providers/auth_provider.dart';
import 'package:hyella/providers/color_provider.dart';
import 'package:hyella/providers/nav_index_provider.dart';
import 'package:hyella/screens/custom_web_view.dart';
import 'package:hyella/screens/patient_screens/appointment_booking/new_reservation_page.dart';
import 'package:hyella/screens/patient_screens/appointment_booking/webview.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../helper/utilities.dart';
import '../card_details/medical_history.dart';
import '../card_details/online_consultation.dart';
import '../card_details/tips.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Consumer2<AuthProvider, ColorNameProvider>(
          builder: (context, authProvider, colors, wid) {
        return Container(
          color: Color(0xffF8F8F8),
          child: RefreshIndicator(
            onRefresh: () async {
              Provider.of<AuthProvider>(context, listen: false)
                  .getUserData(false);
            },
            child: Column(
              children: [
                Container(
                  height: _height * .35,
                  child: Stack(
                    children: [
                      Container(
                        height: _height * .25,
                        margin: EdgeInsets.only(bottom: 25),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.elliptical(500, _height * .05),
                            bottomRight: Radius.elliptical(500, _height * .05),
                          ),
                        ),
                      ),
                      Positioned(
                        left: _width * .05,
                        top: _width * .05,
                        right: 20,
                        child: DashboardHeader(
                          balance:
                              authProvider.userDetails.user!.userNameSubtitle ??
                                  "",
                          context: context,
                          name: authProvider.userDetails.user!.initial ?? "",
                          logoUri: (authProvider.userDetails.user!.dp == null ||
                                  authProvider.userDetails.user!.dp!.isEmpty)
                              ? null
                              : authProvider.userDetails.user!.dp,
                          isFirstTime:
                              authProvider.userDetails.user!.isFirstUse == 1,
                        ),
                      ),
                      Positioned(
                        left: _width * .045,
                        right: _width * .045,
                        top: _height * .15,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (authProvider.userDetails.webViews?.appBook
                                        ?.webview ==
                                    1) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => GeneralWebview(
                                        url: authProvider.userDetails.webViews!
                                            .appBook!.endpoint!,
                                        nwpRequest: authProvider
                                            .userDetails
                                            .webViews!
                                            .appBook!
                                            .params!
                                            .nwpWebiew!,
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => NewReservation(
                                        specialties: authProvider
                                            .userDetails.menu!.home!.data!),
                                  ),
                                );
                              },
                              child: Card(
                                shadowColor: Colors.black45,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: Utilities.fromHex(colors.tertiaryColor),
                                elevation: 15,
                                child: Container(
                                  width: _width * .427,
                                  height: _width * .35,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: -10,
                                        top: -10,
                                        child: Container(
                                          height: _width * .2,
                                          width: _width * .2,
                                          decoration: BoxDecoration(
                                            color: Utilities.fromHex(
                                                    colors.tertiaryColor)
                                                .withAlpha(255),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(_width),
                                              topRight:
                                                  Radius.circular(_width * .8),
                                              bottomLeft:
                                                  Radius.circular(_width * .8),
                                              bottomRight:
                                                  Radius.circular(_width * .8),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        // padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(5),
                                                  ),
                                                  color: Utilities.fromHex(
                                                      colors.secondaryColor)),
                                              child: Icon(
                                                FontAwesomeIcons.calendarPlus,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              authProvider.userDetails.user!
                                                  .bookAppointment!,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              authProvider.userDetails.user!
                                                  .bookAppointmentSubtitle!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => AppointmentWebview(
                                        url: authProvider
                                                .userDetails.fundWalletUrl ??
                                            "",
                                        title: authProvider
                                                .userDetails.user!.accBalance ??
                                            "Fund Wallet"),
                                  ),
                                );
                              },
                              child: Container(
                                child: Card(
                                  shadowColor: Colors.black45,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  color: Utilities.fromHex(colors.color5),
                                  elevation: 15,
                                  child: Container(
                                    width: _width * .427,
                                    height: _width * .35,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          left: -10,
                                          top: -10,
                                          child: Container(
                                            height: _width * .2,
                                            width: _width * .2,
                                            decoration: BoxDecoration(
                                              color: Utilities.fromHex(
                                                      colors.color5)
                                                  .withAlpha(255),
                                              borderRadius: BorderRadius.only(
                                                topLeft:
                                                    Radius.circular(_width),
                                                topRight: Radius.circular(
                                                    _width * .8),
                                                bottomLeft: Radius.circular(
                                                    _width * .8),
                                                bottomRight: Radius.circular(
                                                    _width * .8),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(5),
                                                    ),
                                                    color: Utilities.fromHex(
                                                        colors.color4)),
                                                child: Icon(
                                                  FontAwesomeIcons.wallet,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                authProvider.userDetails.user!
                                                    .accBalance!,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                authProvider.userDetails.user!
                                                    .accBalanceSubtitle!,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                serviceSection(
                  authProvider,
                  context,
                ),
                SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount:
                        authProvider.userDetails.menu!.cards!.data!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          if (index == 0) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MedicalHistory(
                                  title: authProvider.userDetails.menu!.cards!
                                      .data![index].title!,
                                ),
                              ),
                            );
                          } else if (index == 1) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => OnlineConsultation(
                                  title: authProvider.userDetails.menu!.cards!
                                      .data![index].title!,
                                ),
                              ),
                            );
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Tips(
                                  title: authProvider.userDetails.menu!.cards!
                                      .data![index].title!,
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          height: 80,
                          margin: EdgeInsets.only(
                            bottom: 10,
                            left: _width * .05,
                            right: _width * .05,
                          ),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Utilities.fromHex(colors.color6),
                            borderRadius: BorderRadius.circular(
                              15,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                child: authProvider.userDetails.menu!.cards!
                                            .data![index].picture !=
                                        null
                                    ? Image.network(
                                        authProvider.userDetails.menu!.cards!
                                            .data![index].picture!,
                                      )
                                    : SizedBox(),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: _width * .6,
                                    child: Text(
                                      authProvider.userDetails.menu!.cards!
                                          .data![index].title!,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: _width * .6,
                                    child: Text(
                                      authProvider.userDetails.menu!.cards!
                                          .data![index].subTitle!,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black54,
                                      ),
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
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget serviceSection(AuthProvider authProvider, BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: deviceWidth(context) * .05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Services",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              TextButton(
                  onPressed: () {
                    Provider.of<NavIndexProvider>(context, listen: false)
                        .setIndex(4);
                  },
                  child: Text(
                    "See all",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 14,
                    ),
                  ))
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: deviceWidth(context) * .05),
          child: CarouselSlider(
            items: authProvider.userDetails.menu!.home!.data!
                .where((element) =>
                    element.title != "List of All Services & Specialities")
                .map(
                  (e) => GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NewReservation(
                            specialtyId: e.key!,
                            specialties:
                                authProvider.userDetails.menu!.home!.data!,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xffe4e5e9),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      padding: EdgeInsets.only(right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            child: Image.network(e.picture!),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: deviceWidth(context) * .7 - 120,
                            child: Text(
                              e.title!.length > 16
                                  ? e.title!.substring(0, 15) + "..."
                                  : e.title!,
                              maxLines: 1,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
            options: CarouselOptions(
              height: 60,
              viewportFraction: 0.7,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 4),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
          ),
        ),
      ],
    );
  }
}
