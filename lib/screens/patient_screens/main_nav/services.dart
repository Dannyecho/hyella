import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hyella/models/signup_result_model.dart';
import 'package:hyella/providers/auth_provider.dart';
import 'package:hyella/screens/custom_web_view.dart';
import 'package:provider/provider.dart';
import '../../../custom_widgets/shimmer_effects.dart';
import '../../../providers/nav_index_provider.dart';
import '../appointment_booking/new_reservation_page.dart';

class Services extends StatefulWidget {
  Services({Key? key}) : super(key: key);

  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  bool loading = true;
  List<SpecialtyModel> services = [];

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      getServices();
    });
  }

  void getServices() {
    setState(() {
      loading = true;
    });
    UserDetails userDetails =
        Provider.of<AuthProvider>(context, listen: false).userDetails;
    services = userDetails.menu!.home!.data!
        .where(
            (element) => element.title != "List of All Services & Specialities")
        .toList();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Provider.of<NavIndexProvider>(context, listen: false).setIndex(0);
          return false;
        },
        child: SafeArea(
            child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin:
                  EdgeInsets.symmetric(horizontal: _width * .05, vertical: 10),
              child: Text(
                "Our Services",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              ),
            ),
            loading
                ? Expanded(
                    child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: _width * .05),
                    child: ShimmerEffect(),
                  ))
                : Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: _width * .05),
                      child: ListView.builder(
                        itemCount: services.length,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            var userDetails = GetIt.I<UserDetails>();
                            if (userDetails.webViews?.appBook?.webview == 1) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => GeneralWebview(
                                    url: userDetails
                                        .webViews!.appBook!.endpoint!,
                                    nwpRequest: userDetails
                                        .webViews!.appBook!.params!.nwpWebiew!,
                                  ),
                                ),
                              );
                              return;
                            }
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => NewReservation(
                                  specialtyId: services[index].key!,
                                  specialties: Provider.of<AuthProvider>(
                                          context,
                                          listen: false)
                                      .userDetails
                                      .menu!
                                      .home!
                                      .data!,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(15),
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              ),
                            ),
                            child: ListTile(
                              leading: Container(
                                height: 40,
                                width: 40,
                                child: services[index].picture == null
                                    ? null
                                    : Image.network(services[index].picture!),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              title: Text(
                                services[index].title!,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
          ],
        )),
      ),
    );
  }
}
