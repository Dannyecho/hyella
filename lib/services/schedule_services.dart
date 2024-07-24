import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:hyella/models/book_appt_response_model.dart';
import '../helper/constants.dart';
import '../helper/utilities.dart';
import '../models/initial_data.dart';
import '../models/schedule_model.dart';
import '../models/signup_result_model.dart';

class ScheduleServices {
  Future<Either<String, BookApptRespModel>> rescheduleAppointment(
      {required String appRef,
      required String appDate,
      required String apTime,
      required String doctorId,
      required String locationId,
      required String specialtyKey,
      required String remark}) async {
    try {
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = GetIt.I<InitialData>().endPoint1!;
      String cid = GetIt.I<InitialData>().client!.id!;

      String publicKey =
          Utilities.generateMd5ForApiAuth("app_list_update_resch");

      String uri =
          "$baseUri?nwp_request=app_list_update_resch&pid=${userDetails.user!.pid}&cid=$cid&token=$token&public_key=$publicKey&appointment_ref=$appRef";
      var data = {
        "appointment_date": appDate,
        "appointment_time": apTime,
        "location_id": locationId,
        "remark": remark,
        "appointment_id": appRef,
        "doctor_id": doctorId,
        "specialty_key": specialtyKey
      };
      Response response = await post(
          Uri.parse(
            uri,
          ),
          body: data,
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
          }).timeout(Duration(seconds: 10));
      var decodedData = jsonDecode(response.body);
      if (Utilities.responseIsSuccessfull(response)) {
        return Right(BookApptRespModel.fromJson(decodedData));
      }

      return Left(decodedData['msg']);
    } on Exception catch (_) {
      return Left("Error encountered, please try again later.");
    }
  }

  Future<Either<String, String>> cancelAppointment(String appRef) async {
    try {
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = GetIt.I<InitialData>().endPoint1!;
      String cid = GetIt.I<InitialData>().client!.id!;
      String publicKey = Utilities.generateMd5ForApiAuth("app_list_cancel");

      String uri =
          "$baseUri?nwp_request=app_list_cancel&pid=${userDetails.user!.pid}&cid=$cid&token=$token&public_key=$publicKey&appointment_ref=$appRef";

      Response response =
          await post(Uri.parse(uri)).timeout(Duration(seconds: 10));

      if (Utilities.responseIsSuccessfull(response)) {
        return Right("success");
      }

      return Left("Error encountered");
    } on Exception catch (_) {
      return Left("Error encountered");
    }
  }

  Future<Either<String, String>> acceptAppointment(
      String appRef, String appDate, String appTime, String remark) async {
    try {
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = GetIt.I<InitialData>().endPoint1!;
      String cid = GetIt.I<InitialData>().client!.id!;
      String publicKey = Utilities.generateMd5ForApiAuth("apps_list_update");

      String uri =
          "$baseUri?nwp_request=apps_list_update&pid=${userDetails.user!.pid}&cid=$cid&token=$token&public_key=$publicKey&appointment_ref=$appRef";

      Response response = await post(Uri.parse(uri), body: {
        "appointment_status": "confirmed",
        "appointment_date": appDate,
        "appointment_time": appTime,
        "remark": remark
      }, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      }).timeout(Duration(seconds: 10));
      var decodedBody = jsonDecode(response.body);
      print(decodedBody);
      if (Utilities.responseIsSuccessfull(response) &&
          decodedBody['type'] == 1) {
        return Right(decodedBody['msg']);
      }

      return Left(decodedBody['msg']);
    } on Exception catch (e) {
      print(e.toString());
      return Left(
          "Unable to accept appointment at the moment, please try again later");
    }
  }

  Future<Either<String, List<ScheduleModel>>> getUpcomingSchedules() async {
    try {
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = GetIt.I<InitialData>().endPoint1!;
      String cid = GetIt.I<InitialData>().client!.id!;
      String publicKey = Utilities.generateMd5ForApiAuth("app_l_upcoming");

      String uri =
          "$baseUri?nwp_request=app_l_upcoming&pid=${userDetails.user!.pid}&cid=$cid&token=$token&public_key=$publicKey";

      Response response =
          await post(Uri.parse(uri)).timeout(Duration(seconds: 10));

      if (response.statusCode != 200) {
        return Left(
            "Unable to get appointments at the moment, please try again later ");
      }

      var body = jsonDecode(response.body);

      List<ScheduleModel> appointments = [];

      if (body['data']['app_list']['upcoming'] != null &&
          body['data']['app_list']['upcoming'] is Map) {
        body['data']['app_list']['upcoming'].forEach((key, value) {
          appointments.add(ScheduleModel.fromJson(value));
        });
      }

      return Right(appointments);
    } on Exception catch (_) {
      return Left("Error encountered");
    }
  }

  Future<Either<String, List<ScheduleModel>>> getCompletedSchedules() async {
    try {
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = GetIt.I<InitialData>().endPoint1!;
      String cid = GetIt.I<InitialData>().client!.id!;
      String publicKey = Utilities.generateMd5ForApiAuth("app_l_completed");

      String uri =
          "$baseUri?nwp_request=app_l_completed&pid=${userDetails.user!.pid}&cid=$cid&token=$token&public_key=$publicKey";

      Response response =
          await post(Uri.parse(uri)).timeout(Duration(seconds: 10));

      if (response.statusCode != 200) {
        return Left(
            "Unable to get appointments at the moment, please try again later ");
      }

      var body = jsonDecode(response.body);
      List<ScheduleModel> appointments = [];
      if (body['data']['app_list']['completed'] != null &&
          body['data']['app_list']['completed'] is Map) {
        body['data']['app_list']['completed'].forEach((key, value) {
          appointments.add(
            ScheduleModel.fromJson(value),
          );
        });
      }

      return Right(appointments);
    } on Exception catch (_) {
      return Left("Error encountered");
    }
  }

  Future<Either<String, List<ScheduleModel>>> getCancelledSchedules() async {
    try {
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = GetIt.I<InitialData>().endPoint1!;
      String cid = GetIt.I<InitialData>().client!.id!;
      String publicKey = Utilities.generateMd5ForApiAuth("app_l_cancelled");

      String uri =
          "$baseUri?nwp_request=app_l_cancelled&pid=${userDetails.user!.pid}&cid=$cid&token=$token&public_key=$publicKey";

      Response response =
          await post(Uri.parse(uri)).timeout(Duration(seconds: 10));

      var body = jsonDecode(response.body);
      if (Utilities.responseIsSuccessfull(response)) {
        List<ScheduleModel> appointments = [];
        if (body['data']['app_list']['cancelled'] != null &&
            body['data']['app_list']['cancelled'] is Map) {
          body['data']['app_list']['cancelled'].forEach((key, value) {
            appointments.add(ScheduleModel.fromJson(value));
          });
        }

        return Right(appointments);
      } else {
        return Left(body['msg']);
      }
    } on Exception catch (_) {
      return Left("Error encountered");
    }
  }
}
