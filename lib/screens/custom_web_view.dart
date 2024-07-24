
import 'package:flutter/material.dart';
import 'package:hyella/helper/constants.dart';
import 'package:hyella/helper/general_loader.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GeneralWebview extends StatefulWidget {
  final String url;
  final String nwpRequest;
  const GeneralWebview(
      {super.key, required this.url, required this.nwpRequest});

  @override
  State<GeneralWebview> createState() => _GeneralWebviewState();
}

class _GeneralWebviewState extends State<GeneralWebview> {
  bool loading = true;

  // Future<void> generateUrl() async {
  //   try {
  //     InitialData endPoints = GetIt.I<InitialData>();
  //     String cid = endPoints.client!.id!;
  //     String privateKey = endPoints.privateKey!;
  //     String publicKey =
  //         Utilities.generateMd5("$token$privateKey$pid${widget.nwpRequest}");
  //     http.Response response = await http.get(Uri.parse(
  //         "${widget.url}?nwp_request=${widget.nwpRequest}&cid=$cid&token=$token&public_key=$publicKey"));
  //     print(response.body);
  //     print(response.statusCode);

  //     if (Utilities.responseIsSuccessfull(response)) {
  //       print(response.body);
  //       jsonDecode(response.body);
  //     }
  //     url = widget;
  //     setState(() {});
  //   } on Exception catch (e) {
  //     print(e);
  //   }
  // }

  String url = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
