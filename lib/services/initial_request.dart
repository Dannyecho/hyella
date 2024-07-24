import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hyella/helper/constants.dart';
import 'package:hyella/helper/utilities.dart';
import 'package:hyella/models/initial_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dartz/dartz.dart';

class InitialRequest {
  final String request_type = 'initialize_ss';
  final String hospital_id = '100';
  final String app_secret = '55b6b3ffb7889de4d24d9761fc773f81';
  final String app_name = 'com.hyella.telehealth';

  Future<Either<String, InitialData>> getEndPoints() async {
    final Uri initialUrl = Uri.parse(
        "https://webapp.hyella.com.ng/demo/emr-v1.3/engine/api/?nwp_request=$request_type&hospital_id=$hospital_id&app_secret=$app_secret&app_name=$app_name");
    InitialData endPoints;

    SharedPreferences preferences = await SharedPreferences.getInstance();

    try {
      http.Response response =
          await http.post(initialUrl).timeout(Duration(seconds: 10));

      var data = jsonDecode(response.body)['data'];

      if (Utilities.responseIsSuccessfull(response)) {
        endPoints = InitialData.fromJson(data);

        // save endpoints and other details to shared preferences
        String encoded = jsonEncode(endPoints);
        preferences.setString(END_POINT, encoded);

        return Right(endPoints);
      } else {
        return Left("Error getting endpoints");
      }
    } catch (e) {
      print(e.toString());
      return Left("Error getting endpoints");
    }
  }

  Future<Either<String, InitialData?>> getSavedEndPoint() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? encodedEndpoint = preferences.getString(END_POINT);
      InitialData endPoints;
      if (encodedEndpoint != null) {
        endPoints = InitialData.fromJson(jsonDecode(encodedEndpoint));
        return Right(endPoints);
      } else {
        return Left("Error");
      }
    } on Exception {
      return Left("Error");
    }
  }
}
