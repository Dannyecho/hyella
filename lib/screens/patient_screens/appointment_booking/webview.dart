import 'package:flutter/material.dart';
import 'package:hyella/helper/constants.dart';
import 'package:hyella/helper/general_loader.dart';
import 'package:hyella/helper/route_generator.dart';
import 'package:hyella/helper/scaffold_messg.dart';
import 'package:hyella/providers/auth_provider.dart';
import 'package:hyella/providers/nav_index_provider.dart';
import 'package:hyella/providers/schedule_provider.dart';
import 'package:hyella/screens/patient_screens/main_nav/homepage.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AppointmentWebview extends StatefulWidget {
  final String url;
  final String title;
  AppointmentWebview({Key? key, required this.url, required this.title})
      : super(key: key);

  @override
  _AppointmentWebviewState createState() => _AppointmentWebviewState();
}

class _AppointmentWebviewState extends State<AppointmentWebview> {
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(widget.title),
        leading: GestureDetector(
          onTap: () {
            Provider.of<AuthProvider>(context, listen: false)
                .getUserData(false);
            Navigator.of(context)
                .pushNamedAndRemoveUntil(HOME_PAGE, (route) => false);
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Provider.of<AuthProvider>(context, listen: false).getUserData(false);
          Navigator.of(context)
              .pushNamedAndRemoveUntil(HOME_PAGE, (route) => false);
          return false;
        },
        child: SafeArea(
          child: Container(
            width: deviceWidth(context),
            height: deviceHeight(context),
            child: Stack(
              children: [
                WebView(
                  javascriptMode: JavascriptMode.unrestricted,
                  onPageFinished: (a) {
                    loading = false;
                    setState(() {});
                  },
                  navigationDelegate: (NavigationRequest request) {
                    if (request.url.contains("status=completed")) {
                      showSuccessMessage();

                      return NavigationDecision.prevent;
                    }
                    // else if (request.url.contains("status=failed")) {
                    //   openPaymentDialog(
                    //       context: context, height: 365.h, child: error());
                    //   return NavigationDecision.prevent;
                    // } else if (request.url.contains("status=cancelled")) {
                    //   openPaymentDialog(
                    //       context: context, height: 365.h, child: error());
                    //   return NavigationDecision.prevent;
                    // }

                    return NavigationDecision.navigate;
                  },
                  initialUrl: widget.url,
                ),
                loading
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          generalLoader(),
                        ],
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showSuccessMessage() {
    showSnackbar("Appointment successfully booked!", true);
    Provider.of<NavIndexProvider>(context, listen: false).setIndex(2);
    Provider.of<AuthProvider>(context, listen: false).getUserData(false);
    Provider.of<ScheduleProvider>(context, listen: false).getSchedules();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => HomePage(
                  index: 2,
                )),
        (route) => false);
  }
}
