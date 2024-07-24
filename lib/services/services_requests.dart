import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:hyella/helper/constants.dart';
import 'package:hyella/helper/utilities.dart';
import 'package:hyella/models/initial_data.dart';
import 'package:hyella/models/service_response_model.dart';
import 'package:hyella/models/signup_result_model.dart';
import 'package:http/http.dart' as http;

class ServicesRequests {
  Future<Either<String, ServiceResponseModel?>> getDetails(
    String id,
  ) async {
    try {
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = GetIt.I<InitialData>().endPoint1!;
      String cid = GetIt.I<InitialData>().client!.id!;
      String publicKey = Utilities.generateMd5ForApiAuth("service");
      String sid = userDetails.sessionId!;
      String uri =
          "$baseUri?nwp_request=service&id=${id.toLowerCase()}&sid=$sid&token=$token&cid=$cid&public_key=$publicKey";

      http.Response response = await http.post(
        Uri.parse(uri),
      );

      var result = jsonDecode(response.body);
      ServiceResponseModel res = ServiceResponseModel.fromJson(result);

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
