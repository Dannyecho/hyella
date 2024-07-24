import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hyella/helper/constants.dart';
import 'package:hyella/helper/general_loader.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../helper/utilities.dart';
import '../../../models/initial_data.dart';
import '../../../models/signup_result_model.dart';

class CardDetailWebView extends StatefulWidget {
  final String url;
  final String title;
  CardDetailWebView({Key? key, required this.url, required this.title})
      : super(key: key);

  @override
  _CardDetailWebViewState createState() => _CardDetailWebViewState();
}

class _CardDetailWebViewState extends State<CardDetailWebView> {
  bool loading = true;
  String completeUrl = "";
  @override
  void initState() {
    super.initState();
    getCompleteUrl();
  }

  getCompleteUrl() {
    InitialData endPoints = GetIt.I<InitialData>();
    UserDetails userDetails = GetIt.I<UserDetails>();
    String pid = userDetails.user!.pid!;
    String cid = endPoints.client!.id!;
    String privateKey = endPoints.privateKey!;
    String publicKey =
        Utilities.generateMd5("$token$privateKey$pid$privateKey");

    completeUrl =
        "${widget.url}&pid=$pid&cid=$cid&token=$token&public_key=$publicKey";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(widget.title),
      ),
      body: SafeArea(
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
                initialUrl: completeUrl,
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
    );
  }
}
