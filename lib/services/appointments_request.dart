import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:hyella/helper/utilities.dart';
import 'package:hyella/models/appt_venues_resp_model.dart';
import 'package:hyella/models/avail_timeslot_response.dart';
import 'package:hyella/models/book_appt_response_model.dart';
import 'package:hyella/models/doctors_list_response_model.dart';
import 'package:hyella/models/initial_data.dart';
import 'package:hyella/models/pre_payment_model.dart';
import 'package:hyella/models/signup_result_model.dart';
import '../helper/constants.dart';
import 'package:http/http.dart' as http;

class AppointmentRequest {
  Future<Either<String, DoctorListResponse>> getDoctorList(
      String specialKey) async {
    try {
      InitialData endPoints = GetIt.I<InitialData>();
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = endPoints.endPoint1!;
      String cid = endPoints.client!.id!;
      String pid = userDetails.user!.pid!;

      String publicKey = Utilities.generateMd5ForApiAuth("app_list_of_doctors");

      String uri =
          "$baseUri?nwp_request=app_list_of_doctors&pid=$pid&cid=$cid&token=$token&public_key=$publicKey&specialty_key=$specialKey";

      Response response =
          await http.get(Uri.parse(uri)).timeout(Duration(seconds: 10));
      var decodedRes = jsonDecode(response.body);

      if (Utilities.responseIsSuccessfull(response)) {
        return Right(DoctorListResponse.fromJson(jsonDecode(response.body)));
      } else {
        return Left(decodedRes['msg']);
      }
    } catch (e) {
      return Left("Error getting data at the moment, please try again later");
    }
  }

  Future<Either<String, AppLocationResponse>> getVenueAndLocation(
      String doctorId, String dependentId, String specialtyKey) async {
    try {
      InitialData endPoints = GetIt.I<InitialData>();
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = endPoints.endPoint1!;
      String cid = endPoints.client!.id!;

      String publicKey =
          Utilities.generateMd5ForApiAuth("app_list_of_doctors2");

      String uri =
          "$baseUri?nwp_request=app_list_of_doctors2&pid=${userDetails.user!.pid}&cid=$cid&token=$token&public_key=$publicKey&doctor_id=$doctorId&dependent_id=$dependentId&specialty_key=$specialtyKey";

      Response response =
          await http.get(Uri.parse(uri)).timeout(Duration(seconds: 10));
      var decodedRes = jsonDecode(response.body);
      if (Utilities.responseIsSuccessfull(response)) {
        return Right(AppLocationResponse.fromJson(decodedRes));
      } else {
        return Left(decodedRes['msg'] ??
            "Error getting data at the moment, please try again later");
      }
    } catch (e) {
      print(e.toString());
      return Left("Error getting data at the moment, please try again later");
    }
  }

  Future<Either<String, AvailableTimeSlotRes>> getTimeSlots(String locationId,
      String date, String doctorId, String dependentId) async {
    try {
      InitialData endPoints = GetIt.I<InitialData>();
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = endPoints.endPoint1!;
      String cid = endPoints.client!.id!;

      String publicKey =
          Utilities.generateMd5ForApiAuth("app_list_of_doctors3");

      String uri =
          "$baseUri?nwp_request=app_list_of_doctors3&pid=${userDetails.user!.pid}&cid=$cid&token=$token&public_key=$publicKey&location_id=$locationId&date=$date&doctor_id=$doctorId&dependent_id=$dependentId";

      Response response =
          await http.get(Uri.parse(uri)).timeout(Duration(seconds: 10));
      var decodedRes = jsonDecode(response.body);
      print(decodedRes);
      print(response.statusCode);
      if (Utilities.responseIsSuccessfull(response)) {
        return Right(AvailableTimeSlotRes.fromJson(decodedRes));
      } else {
        return Left(decodedRes['msg'] ??
            "Error getting data at the moment, please try again later");
      }
    } catch (e) {
      return Left("Error getting data at the moment, please try again later");
    }
  }

  Future<Either<String, PrePaymentResponse>> getPrePaymentData(
      String doctorId, String locationId, String date, String timeId) async {
    try {
      InitialData endPoints = GetIt.I<InitialData>();
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = endPoints.endPoint1!;
      String cid = endPoints.client!.id!;

      String publicKey =
          Utilities.generateMd5ForApiAuth("app_list_of_doctors4");

      String uri =
          "$baseUri?nwp_request=app_list_of_doctors4&pid=${userDetails.user!.pid}&cid=$cid&token=$token&public_key=$publicKey&doctor_id=$doctorId&location_id=$locationId&date=$date&time=$timeId&dependent_id=''";

      Response response =
          await http.get(Uri.parse(uri)).timeout(Duration(seconds: 10));
      var decodedRes = jsonDecode(response.body);
      if (Utilities.responseIsSuccessfull(response)) {
        return Right(PrePaymentResponse.fromJson(decodedRes));
      } else {
        return Left(decodedRes['msg'] ??
            "Error getting data at the moment, please try again later");
      }
    } catch (e) {
      print(e);
      return Left("Error getting data at the moment, please try again later");
    }
  }

  Future<Either<String, BookApptRespModel>> completeAppointment(
    String appointmentRef,
    String doctorId,
  ) async {
    try {
      InitialData endPoints = GetIt.I<InitialData>();

      String baseUri = endPoints.endPoint1!;
      String cid = endPoints.client!.id!;
      String publicKey = Utilities.generateMd5ForApiAuth("app_list_save");
      UserDetails userDetails = GetIt.I<UserDetails>();
      String pid = userDetails.user!.pid!;
      String uri =
          "$baseUri?appointment_ref=$appointmentRef&pid=$pid&nwp_request=app_list_save&cid=$cid&token=$token&public_key=$publicKey&default=default&action=nwp_health&todo=execute&nwp_action=tele_health_connect&nwp_todo=process_request&development_mode_off=1";

      Response res = await http.post(Uri.parse(uri));
      var decodedRes = jsonDecode(res.body);
      if (Utilities.responseIsSuccessfull(res)) {
        // successful
        return Right(BookApptRespModel.fromJson(jsonDecode(res.body)));
      } else {
        return Left(decodedRes['msg'] ??
            "Unable to book appointment at the moment, please try again later.");
      }
    } catch (e) {
      print(e.toString());
      return Left(
          "Unable to book appointment at the moment, please try again later.");
    }
  }
}
