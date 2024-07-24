import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hyella/helper/general_loader.dart';
import 'package:hyella/helper/scaffold_messg.dart';
import 'package:hyella/helper/styles.dart';
import 'package:hyella/models/reminders_response_model.dart';
import 'package:hyella/providers/card_details_provider.dart';
import 'package:provider/provider.dart';

import '../../../helper/colors.dart';
import '../../patient_screens/card_details/card_details_webview.dart';

class MyPatientsView extends StatefulWidget {
  @override
  _MyPatientsViewState createState() => _MyPatientsViewState();
}

class _MyPatientsViewState extends State<MyPatientsView> {
  List<Reminder> reminders = [];
  bool loading = true;
  bool errorEncountered = false;
  @override
  void initState() {
    super.initState();
    Timer.run(() {
      getDetails();
    });
  }

  void getDetails() {
    setState(() {
      loading = true;
    });
    Provider.of<CardDetailProvider>(context, listen: false)
        .getMyPatients()
        .then(
          (value) => value.fold(
            (l) {
              showSnackbar(l, false);
              if (l != "No Records Found") {
                errorEncountered = true;
              }
              loading = false;
              setState(() {});
            },
            (r) {
              errorEncountered = false;
              reminders = r.data!.data!;
              loading = false;
              errorEncountered = false;

              setState(() {});
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Patients",
        ),
      ),
      body: loading
          ? generalLoader()
          : errorEncountered
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Styles.regular(
                          "Unable to get data at the moment,\nplease try again.",
                          align: TextAlign.center),
                      ElevatedButton(
                          onPressed: getDetails, child: Text("Refresh"))
                    ],
                  ),
                )
              : reminders.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Styles.bold("No results found!",
                              fontSize: 14, align: TextAlign.center),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: reminders.length,
                      itemBuilder: (context, index) => Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xffFAF2E9),
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CardDetailWebView(
                                    url: reminders[index].url!,
                                    title: reminders[index].title!),
                              ),
                            );
                          },
                          leading: Container(
                            height: 40,
                            width: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: avatarBgColor,
                            ),
                            padding: EdgeInsets.all(4),
                            child: Text(
                              reminders[index].info!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xff5A88EC),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(
                            reminders[index].title!,
                            maxLines: 3,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(reminders[index].subTitle!),
                        ),
                      ),
                    ),
    );
  }
}
