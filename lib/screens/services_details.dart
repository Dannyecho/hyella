import 'package:flutter/material.dart';
import 'package:hyella/providers/service_details_provider.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ServiceDetail extends StatefulWidget {
  final String id;
  ServiceDetail({Key? key, required this.id}) : super(key: key);

  @override
  _HtmlTestState createState() => _HtmlTestState();
}

class _HtmlTestState extends State<ServiceDetail> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getHtmlData();
  }

  String src = "";

  getHtmlData() {
    Provider.of<ServiceDetailProvider>(context).getDetails(widget.id).then(
          (value) => value.fold(
            (l) => null,
            (r) {
              src = r!.data.url;
  
              setState(() {});
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: src,
          ),
        ),
      ),
    );
  }
}
