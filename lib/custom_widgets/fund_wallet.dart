import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutterwave_standard/core/flutterwave.dart';
import 'package:flutterwave_standard/models/requests/customer.dart';
import 'package:flutterwave_standard/models/requests/customizations.dart';
import 'package:flutterwave_standard/models/responses/charge_response.dart';
import 'package:get_it/get_it.dart';
import 'package:hyella/helper/constants.dart';
import 'package:hyella/helper/general_loader.dart';
import 'package:hyella/helper/scaffold_messg.dart';
import 'package:hyella/helper/styles.dart';
import 'package:hyella/models/initial_data.dart';
import 'package:hyella/providers/fund_wallet_provider.dart';
import 'package:provider/provider.dart';

import '../models/signup_result_model.dart';

class FundWallet extends StatefulWidget {
  @override
  _FundWalletState createState() => _FundWalletState();
}

class PaymentMethodModel {
  int id;
  String name;
  String key;

  PaymentMethodModel({required this.id, required this.name, required this.key});
}

class _FundWalletState extends State<FundWallet> {
  TextEditingController amountController = TextEditingController(text: "");

  String flutterWavePublicKey = "";
  String flutterWaveEncryptionKey = "";

  String paystackPublicKey = "";
  String paystackEncryptionKey = "";
  final plugin = PaystackPlugin();

  List<PaymentMethodModel> paymentMethod = [
    PaymentMethodModel(id: 0, name: "FlutterWave", key: "flutter_payment"),
    PaymentMethodModel(id: 1, name: "PayStack", key: "paystack_payment")
  ];

  int selectedPaymentMethod = 0;
  bool loading = false;

  @override
  void initState() {
    super.initState();

    initializePaymentGateWaysData();
  }

  initializePaymentGateWaysData() {
    InitialData initialData = GetIt.I<InitialData>();
    if (initialData.flutterPayment != null) {
      flutterWaveEncryptionKey = initialData.flutterPayment!.encryptionKey!;
      flutterWavePublicKey = initialData.flutterPayment!.publicKey!;
    }

    if (initialData.paystackPayment != null) {
      paystackEncryptionKey = initialData.paystackPayment!.encryptionKey!;
      paystackPublicKey = initialData.paystackPayment!.publicKey!;
      plugin.initialize(publicKey: paystackPublicKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 10,
          ),
          Styles.bold("Fund My Wallet"),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            width: MediaQuery.of(context).size.width * .8,
            child: TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(8),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor, width: 2),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                hintText: "Enter amount to fund your wallet",
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(
              left: deviceWidth(context) * .1,
            ),
            child: Styles.regular(
              "Select Payment Method",
              fontSize: 16,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: deviceWidth(context) * .1,
            ),
            child: Column(
              children: paymentMethod
                  .map(
                    (e) => GestureDetector(
                      onTap: () {
                        setState(
                          () {
                            selectedPaymentMethod = e.id;
                          },
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            child: Radio<int>(
                              activeColor: Theme.of(context).primaryColor,
                              value: e.id,
                              groupValue: selectedPaymentMethod,
                              onChanged: (value) {
                                setState(
                                  () {
                                    selectedPaymentMethod = value!;
                                  },
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Styles.regular(e.name)
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          loading
              ? generalLoader()
              : Container(
                  height: 40,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).disabledColor,
                      ),
                    ),
                    onPressed: () {
                      if (amountController.text.trim() != "") {
                        initiatePayment();
                      } else {
                        showSnackbar(
                            "Please input amount to fund your account with.",
                            false);
                      }
                    },
                    child: Text(
                      "Fund Wallet",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }

  initiatePayment() async {
    setState(() {
      loading = true;
    });

    // store initial transaction data
    Provider.of<WalletProvider>(context, listen: false)
        .saveFundingInfo(amountController.text.trim(),
            paymentMethod[selectedPaymentMethod].key)
        .then(
          (value) => value.fold(
            (l) {
              showSnackbar(l, false);
              setState(() {
                loading = false;
              });
            },
            (r) {
              if (selectedPaymentMethod == 0) {
                beginPaymentWithFlutterWave(r.transactionRef!);
              } else {
                beginPaymentWithPayStack(r.transactionRef!);
              }
            },
          ),
        );
  }

  beginPaymentWithPayStack(String reference) async {
    // get user detail
    UserDetails userDetails = GetIt.I<UserDetails>();

    try {
      Charge charge = Charge()
        // append 2 zeros to the end of the figure since due to paystack plugin crazy implementation
        ..amount = int.parse(amountController.text.trim())
        ..reference = reference
        // or ..accessCode = _getAccessCodeFrmInitialization()
        ..email = userDetails.user!.email;

      CheckoutResponse response = await plugin.checkout(
        context,
        method: CheckoutMethod.card,
        charge: charge,
      );
      //check if the payment is successful or not and report back
      reportBackToServer(response.status, reference);
    } on Exception {
      setState(() {
        loading = false;
      });
      showSnackbar(
          "Error encountered while funding wallet, please try again later",
          false);
    }
  }

  reportBackToServer(bool status, String reference) async {
    if (status) {
      //call endpoint for successful payment
      Provider.of<WalletProvider>(context, listen: false).updatePaymentStatus(
          reference, paymentMethod[selectedPaymentMethod].key, "success");

      // provide value to customer
      showSnackbar(
          "Payment Successful, N${amountController.text.trim()} has been added to your account.",
          true);
      setState(() {
        loading = false;
      });

      Navigator.pop(context);
    } else {
      showSnackbar(
          "Error occurred during transaction, please try again.", false);
      //call endpoint for failed payment
      await Provider.of<WalletProvider>(context, listen: false)
          .updatePaymentStatus(
              reference, paymentMethod[selectedPaymentMethod].key, "fail");

      Navigator.pop(context);
    }
  }

  beginPaymentWithFlutterWave(String reference) async {
    UserDetails userDetails = GetIt.I<UserDetails>();
    // get the initial data
    InitialData initialData = GetIt.I<InitialData>();
    // get user detail
    final Flutterwave flutterwave = Flutterwave(
      context: context,
      publicKey: initialData.flutterPayment!.publicKey!,
      currency: "NGN",
      amount: amountController.text.trim(),
      paymentOptions: "card, bank transfer, ussd",
      customer: Customer(
        email: userDetails.user!.email!,
        name: userDetails.user!.fullName!,
        phoneNumber: userDetails.user!.phone!,
      ),
      redirectUrl: '',
      customization: Customization(title: "Fund Wallet"),
      txRef: reference,
      isTestMode: false,
    );

    try {
      final ChargeResponse? response = await flutterwave.charge();
      if (response == null) {
        // user didn't complete the transaction. Payment wasn't successful.
        showSnackbar(
          "Unable to complete transaction at the moment, please try again later.",
          false,
        );
        setState(() {
          loading = false;
        });
      } else {
        final isSuccessful = checkPaymentIsSuccessful(response, reference);
        //check if the payment is successful or not and report back
        reportBackToServer(isSuccessful, reference);
      }
    } catch (error) {
      // handleError(error);
      showSnackbar(
          "Error occurred during transaction please try again.", false);
      setState(() {
        loading = false;
      });
    }
  }

  bool checkPaymentIsSuccessful(final ChargeResponse? response, String ref) {
    return response?.success ?? false;
  }
}
