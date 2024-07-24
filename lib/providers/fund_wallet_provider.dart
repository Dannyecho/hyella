import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hyella/services/wallet_service.dart';

import '../models/initial_fund_wallet_model.dart';

class WalletProvider extends ChangeNotifier {
  WalletServices walletServices = WalletServices();
  Future<Either<String, InitialFundWalletResponse>> saveFundingInfo(
      String amount, String paymentMethod) async {
    return walletServices.saveFundingInfo(amount, paymentMethod);
  }

  Future<Either<String, String>> updatePaymentStatus(
    String transactionRef,
    String paymentMethod,
    String paymentStatus,
  ) async {
    return walletServices.updatePaymentStatus(
        transactionRef, paymentMethod, paymentStatus);
  }
}
