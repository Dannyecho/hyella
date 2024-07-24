import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:hyella/models/appoitments_model.dart';
import '../helper/constants.dart';
import '../helper/utilities.dart';
import '../models/initial_data.dart';
import '../models/signup_result_model.dart';

class DoctorAppointmentService {
  Future<Either<String, String>> cancelAppointment(String appRef) async {
    try {
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = GetIt.I<InitialData>().endPoint1!;
      String cid = GetIt.I<InitialData>().client!.id!;
      String publicKey = Utilities.generateMd5ForApiAuth("apps_list_cancel");
      String uri =
          "$baseUri?nwp_request=apps_list_cancel&pid=${userDetails.user!.pid}&cid=$cid&token=$token&public_key=$publicKey&appointment_ref=$appRef";

      Response response =
          await post(Uri.parse(uri)).timeout(Duration(seconds: 10));

      if (Utilities.responseIsSuccessfull(response)) {
        return Right("success");
      }

      return Left("Error encountered");
    } on Exception {
      return Left("Error encountered");
    }
  }

  Future<Either<String, List<AppointmentModel>>>
      getUpcomingAppointments() async {
    try {
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = GetIt.I<InitialData>().endPoint1!;
      String cid = GetIt.I<InitialData>().client!.id!;
      String publicKey = Utilities.generateMd5ForApiAuth("app_ls_upcoming");

      String uri =
          "$baseUri?nwp_request=app_ls_upcoming&pid=${userDetails.user!.pid}&cid=$cid&token=$token&public_key=$publicKey";

      Response response =
          await post(Uri.parse(uri)).timeout(Duration(seconds: 10));

      if (response.statusCode != 200) {
        return Left(
            "Unable to get appointments at the moment, please try again later ");
      }

      var body = jsonDecode(response.body);
      print(body['data']['app_list']['upcoming']);
      List<AppointmentModel> appointments = [];

      if (body['data']['app_list']['upcoming'] != null &&
          body['data']['app_list']['upcoming'] is Map) {
        body['data']['app_list']['upcoming'].forEach((key, value) {
          appointments.add(AppointmentModel.fromJson(value));
        });
      }

      return Right(appointments);
    } on Exception {
      return Left("Error encountered");
    }
  }

  Future<Either<String, List<AppointmentModel>>> getCompletedSchedules() async {
    try {
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = GetIt.I<InitialData>().endPoint1!;
      String cid = GetIt.I<InitialData>().client!.id!;
      String publicKey = Utilities.generateMd5ForApiAuth("app_ls_completed");
      String uri =
          "$baseUri?nwp_request=app_ls_completed&pid=${userDetails.user!.pid}&cid=$cid&token=$token&public_key=$publicKey";

      Response response =
          await post(Uri.parse(uri)).timeout(Duration(seconds: 10));

      if (response.statusCode != 200) {
        return Left(
            "Unable to get appointments at the moment, please try again later ");
      }

      var body = jsonDecode(response.body);

      List<AppointmentModel> appointments = [];
      if (body['data']['app_list']['completed'] != null &&
          body['data']['app_list']['completed'] is Map) {
        body['data']['app_list']['completed'].forEach((key, value) {
          appointments.add(AppointmentModel.fromJson(value));
        });
      }

      return Right(appointments);
    } on Exception {
      return Left("Error encountered");
    }
  }

  Future<Either<String, List<AppointmentModel>>> getCancelledSchedules() async {
    try {
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = GetIt.I<InitialData>().endPoint1!;
      String cid = GetIt.I<InitialData>().client!.id!;
      String publicKey = Utilities.generateMd5ForApiAuth("app_ls_cancelled");

      String uri =
          "$baseUri?nwp_request=app_ls_cancelled&pid=${userDetails.user!.pid}&cid=$cid&token=$token&public_key=$publicKey";

      Response response =
          await post(Uri.parse(uri)).timeout(Duration(seconds: 10));

      if (response.statusCode != 200) {
        return Left(
            "Unable to get appointments at the moment, please try again later ");
      }

      var body = jsonDecode(response.body);

      List<AppointmentModel> appointments = [];
      if (body['data']['app_list']['cancelled'] != null &&
          body['data']['app_list']['cancelled'] is Map) {
        body['data']['app_list']['cancelled'].forEach((key, value) {
          appointments.add(AppointmentModel.fromJson(value));
        });
      }

      return Right(appointments);
    } on Exception {
      return Left("Error encountered");
    }
  }
}
