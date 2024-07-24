import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:hyella/models/revenue_model.dart';
import '../helper/constants.dart';
import '../helper/utilities.dart';
import '../models/initial_data.dart';
import '../models/signup_result_model.dart';
import 'package:http/http.dart' as http;

class RevenueService {
  Future<Either<String, RevenueModel>> getRevenue() async {
    try {
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = GetIt.I<InitialData>().endPoint1!;
      String cid = GetIt.I<InitialData>().client!.id!;

      String publicKey = Utilities.generateMd5ForApiAuth("apps_revenue_gen");

      String uri =
          "$baseUri?nwp_request=apps_revenue_gen&pid=${userDetails.user!.pid}&cid=$cid&token=$token&public_key=$publicKey";

      http.Response response =
          await http.post(Uri.parse(uri)).timeout(Duration(seconds: 10));
      var decodedBody = jsonDecode(response.body);
      if (Utilities.responseIsSuccessfull(response)) {
        return Right(
          RevenueModel.fromJson(
            decodedBody["data"],
          ),
        );
      } else {
        return decodedBody['msg'];
      }
    } on Exception {
      return Left("Unable to get data at the moment, please try again later ");
    }
  }
}
