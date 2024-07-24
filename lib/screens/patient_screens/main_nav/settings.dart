import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hyella/models/signup_result_model.dart';
import 'package:hyella/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../../providers/nav_index_provider.dart';
import '../../doctor_screens/card_details/card_details_webview.dart';
import '../auth/signin.dart';

class Settings extends StatefulWidget {
  Settings({
    Key? key,
  }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  UserDetails userDetails = GetIt.I<UserDetails>();
  List<Data3> items = [
    ...GetIt.I<UserDetails>().menu!.more!.data!,
    Data3(title: "Logout")
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    return Consumer<AuthProvider>(builder: (
      context,
      AuthProvider auth,
      wid,
    ) {
      return Scaffold(
        body: WillPopScope(
          onWillPop: () async {
            Provider.of<NavIndexProvider>(context, listen: false).setIndex(0);
            return false;
          },
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: _width * .05),
                  child: Text(
                    "More",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CardDetailWebView(
                                  url: userDetails.menu!.more!.htmlSrc!,
                                  title: userDetails.menu!.more!.title ?? ""),
                            ),
                          );
                          // _launchUrl(userDetails.menu!.more!.htmlSrc!);
                        },
                        child: Container(
                          height: _height * .4,
                          margin:
                              EdgeInsets.symmetric(horizontal: _width * .05),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(30),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            margin: EdgeInsets.zero,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(30),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                    userDetails.menu!.more!.htmlImg!,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: _width * .05),
                        child: Wrap(
                          runAlignment: WrapAlignment.spaceBetween,
                          alignment: WrapAlignment.spaceBetween,
                          children: items.map((e) {
                            if (e.title == "Logout") {
                              return Container(
                                width: _width * .425,
                                height: _height * .2,
                                child: GestureDetector(
                                  onTap: () async {
                                    await Provider.of<AuthProvider>(context,
                                            listen: false)
                                        .logout();

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignIn(),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(30),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.logout,
                                          size: 40,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Logout",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                            return Container(
                              width: _width * .425,
                              height: _height * .2,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => CardDetailWebView(
                                          url: e.menuKey!,
                                          title: e.title ?? ""),
                                    ),
                                  );
                                  // _launchUrl(userDetails.menu!.more!
                                  //     .data![0].menuKey);
                                },
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(30),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 40,
                                          child: Image.network(
                                            e.icon!,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          e.title ?? "",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
