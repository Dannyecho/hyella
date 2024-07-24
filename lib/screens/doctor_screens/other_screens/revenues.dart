import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hyella/helper/constants.dart';
import 'package:hyella/helper/scaffold_messg.dart';
import 'package:hyella/helper/styles.dart';
import 'package:hyella/models/revenue_model.dart';
import 'package:hyella/providers/revenue_provider.dart';
import 'package:provider/provider.dart';

import '../../../custom_widgets/shimmer_effects.dart';

class RevenuesView extends StatefulWidget {
  RevenuesView({Key? key}) : super(key: key);

  @override
  State<RevenuesView> createState() => _RevenuesViewState();
}

class _RevenuesViewState extends State<RevenuesView> {
  bool loading = true;
  bool error = false;
  RevenueModel? revenues;

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      getRevenue();
    });
  }

  getRevenue() {
    Provider.of<RevenueProvider>(context, listen: false)
        .getRevenue()
        .then((value) {
      value.fold((l) {
        showSnackbar(l, false);
        loading = false;
        error = true;
        setState(() {});
      }, (r) {
        revenues = r;
        loading = false;
        error = false;
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text(
          "Earned Revenue",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: loading
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: ShimmerEffect(),
            )
          : error
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Styles.regular(
                        "Unable to load your revenue history at the moment\nplease try again later",
                        fontSize: 14,
                        align: TextAlign.center),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: getRevenue,
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).primaryColor)),
                        child: const Text("Tap to retry"))
                  ],
                )
              : SingleChildScrollView(
                  child: Container(
                    height: deviceHeight(context),
                    margin: EdgeInsets.only(
                      top: 30,
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: deviceWidth(context) * .9,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(color: Colors.grey, blurRadius: 5),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Styles.regular(revenues!.title!, fontSize: 18),
                              SizedBox(
                                height: 10,
                              ),
                              Styles.bold(
                                revenues!.totalRevenue!,
                                fontSize: 18,
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: deviceWidth(context) * .05,
                          ),
                          alignment: Alignment.centerLeft,
                          child: Styles.bold(
                            "Monthly Breakdown",
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: ListView(
                            children: revenues!.details!
                                .map(
                                  (e) => ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          AssetImage("assets/wallet.jpg"),
                                    ),
                                    title: Text(e.title!),
                                    subtitle: Text(e.amount!),
                                  ),
                                )
                                .toList(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
    );
  }
}
