import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:hyella/helper/utilities.dart';
import 'package:hyella/models/emr_result.dart';
import 'package:hyella/models/initial_data.dart';
import 'package:hyella/models/signup_result_model.dart';

class EmrRequests {
  Future<Either<String, EmrResult?>> getDetails(
    String id,
    String token,
  ) async {
    try {
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = GetIt.I<InitialData>().endPoint1!;
      String cid = GetIt.I<InitialData>().client!.id!;
      String sid = GetIt.I<UserDetails>().sessionId!;
      String publicKey =
          Utilities.generateMd5ForApiAuth("user_mgt_update_profile");

      String uri = "$baseUri?nwp_request=user_mgt_update_profile";

      http.Response response = await http.post(
        Uri.parse(uri),
        headers: {
          "id": id,
          "sid": sid,
          "token": token,
          "nwp_request": "emr",
          "cid": cid,
          "public_key": publicKey,
          "pid": userDetails.user!.pid ?? ""
        },
      );
      var result = jsonDecode(response.body);
      EmrResult res = EmrResult.fromJson(result);

      if (result["type"] == 1) {
        return Right(res);
      } else {
        return Left(result["msg"]);
      }
    } catch (e) {
      return Left(
          "Unable to get details at the moment, please try again later");
    }
  }
}
