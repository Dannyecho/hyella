import 'package:flutter/material.dart';
import 'package:hyella/helper/constants.dart';
import '../screens/patient_screens/profile/profile_page.dart';

class DashboardHeader extends StatelessWidget {
  final String balance;
  final String name;
  final BuildContext context;
  final String? logoUri;
  final bool isFirstTime;
  DashboardHeader(
      {required this.balance,
      required this.context,
      required this.name,
      required this.logoUri,
      required this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    String wave = isFirstTime ? "👋" : "";
    return Container(
      margin: EdgeInsets.only(top: 30, bottom: 10),
      width: deviceWidth(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello ${name.split(" ").first} $wave",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    balance,
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => Profile(),
                        settings: RouteSettings(name: "profile")),
                  );
                },
                child: (logoUri == null)
                    ? CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          color: Colors.grey[300],
                          size: 30,
                        ),
                      )
                    : CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(logoUri!),
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
