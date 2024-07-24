import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:hyella/models/initial_fund_wallet_model.dart';
import '../helper/constants.dart';
import '../helper/utilities.dart';
import '../models/initial_data.dart';
import '../models/signup_result_model.dart';
import 'package:http/http.dart' as http;

class WalletServices {
  Future<Either<String, InitialFundWalletResponse>> saveFundingInfo(
      String amount, String paymentMethod) async {
    try {
      InitialData endPoints = GetIt.I<InitialData>();
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = endPoints.endPoint1!;
      String cid = endPoints.client!.id!;

      String publicKey = Utilities.generateMd5ForApiAuth("m_fundw_save_req");

      String uri =
          "$baseUri?nwp_request=m_fundw_save_req&pid=${userDetails.user!.pid}&cid=$cid&token=$token&public_key=$publicKey";

      Response response = await http.post(Uri.parse(uri), body: {
        'amount': amount,
        'payment_method': paymentMethod
      }).timeout(Duration(seconds: 10));

      var decodedBody = jsonDecode(response.body);

      if (Utilities.responseIsSuccessfull(response)) {
        return Right(InitialFundWalletResponse.fromJson(decodedBody['data']));
      }

      return Left(decodedBody['msg']);
    } on Exception catch (_) {
      return const Left(
          "Unable to fund wallet at the moment, please try again later");
    }
  }

  Future<Either<String, String>> updatePaymentStatus(
    String transactionRef,
    String paymentMethod,
    String paymentStatus,
  ) async {
    try {
      InitialData endPoints = GetIt.I<InitialData>();
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = endPoints.endPoint1!;
      String cid = endPoints.client!.id!;
      String pid = userDetails.user!.pid!;

      String publicKey =
          Utilities.generateMd5ForApiAuth("m_fundw_update_status");

      String uri =
          "$baseUri?nwp_request=m_fundw_update_status&pid=$pid&cid=$cid&token=$token&public_key=$publicKey&transaction_ref=$transactionRef&payment_method=$paymentMethod&payment_status=$paymentStatus";

      Response response =
          await http.post(Uri.parse(uri)).timeout(Duration(seconds: 10));

      var decodedBody = jsonDecode(response.body);

      if ((Utilities.responseIsSuccessfull(response)) &&
          decodedBody['type'] == 1) {
        return Right(decodedBody['msg']);
      }

      return Left(decodedBody['msg']);
    } on Exception catch (_) {
      return const Left(
          "Unable to fund wallet at the moment, please try again later");
    }
  }
}
