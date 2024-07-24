import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hyella/helper/constants.dart';
import 'package:hyella/helper/general_loader.dart';
import 'package:hyella/helper/route_generator.dart';
import 'package:hyella/models/signup_result_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebView extends StatefulWidget {
  final String url;
  final String title;
  CustomWebView({Key? key, required this.url, required this.title})
      : super(key: key);

  @override
  CustomWebViewState createState() => CustomWebViewState();
}

class CustomWebViewState extends State<CustomWebView> {
  bool loading = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(widget.title),
      ),
      body: WillPopScope(
        onWillPop: () async {
          UserDetails userDetails = GetIt.I<UserDetails>();

          Navigator.of(context).pushReplacementNamed(
            (userDetails.user!.isPatient == 1) ? HOME_PAGE : DOCTOR_HOME,
          );

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
                  initialUrl: widget.url,
                ),
                loading
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          generalLoader(),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Go Back"),
                          )
                        ],
                      )
                    : Stack(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
