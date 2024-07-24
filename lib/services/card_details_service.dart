import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';
import 'package:hyella/helper/utilities.dart';
import 'package:hyella/models/reminders_response_model.dart';
import 'package:hyella/models/signup_result_model.dart';

import '../helper/constants.dart';
import '../models/initial_data.dart';

class CardDetailsService {
  Future<Either<String, RemindersResponse>> getMedicalHistory() async {
    try {
      InitialData endPoints = GetIt.I<InitialData>();
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = endPoints.endPoint1!;
      String cid = endPoints.client!.id!;

      String publicKey = Utilities.generateMd5ForApiAuth("card_menu");
      String sid = userDetails.sessionId!;
      String uri =
          "$baseUri?nwp_request=card_menu&id=myemr&pid=${userDetails.user!.pid}&sid=$sid&cid=$cid&token=$token&public_key=$publicKey";

      http.Response response =
          await http.post(Uri.parse(uri)).timeout(Duration(seconds: 10));

      var decodedBody = jsonDecode(response.body);

      if ((Utilities.responseIsSuccessfull(response)) &&
          decodedBody['type'] == 1) {
        // success
        return Right(RemindersResponse.fromJson(jsonDecode(response.body)));
      } else {
        return Left(decodedBody['msg']);
      }
    } on Exception {
      return Left("Unable to get data at the moment, please try again later ");
    }
  }

  Future<Either<String, RemindersResponse>> getConsultation() async {
    try {
      InitialData endPoints = GetIt.I<InitialData>();
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = endPoints.endPoint1!;
      String cid = endPoints.client!.id!;
      String publicKey = Utilities.generateMd5ForApiAuth("card_menu");
      String sid = userDetails.sessionId!;
      String uri =
          "$baseUri?nwp_request=card_menu&id=myrem&pid=${userDetails.user!.pid}&sid=$sid&cid=$cid&token=$token&public_key=$publicKey";

      http.Response response =
          await http.post(Uri.parse(uri)).timeout(Duration(seconds: 10));
      var decodedBody = jsonDecode(response.body);

      if ((Utilities.responseIsSuccessfull(response)) &&
          decodedBody['type'] == 1) {
        // success
        return Right(RemindersResponse.fromJson(jsonDecode(response.body)));
      } else {
        return Left(decodedBody['msg']);
      }
    } on Exception {
      return Left("Unable to get data at the moment, please try again later ");
    }
  }

  Future<Either<String, RemindersResponse>> getTips() async {
    try {
      InitialData endPoints = GetIt.I<InitialData>();
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = endPoints.endPoint1!;
      String cid = endPoints.client!.id!;
      String publicKey = Utilities.generateMd5ForApiAuth("card_menu");
      String sid = userDetails.sessionId!;
      String uri =
          "$baseUri?nwp_request=card_menu&id=mytip&pid=${userDetails.user!.pid}&sid=$sid&cid=$cid&token=$token&public_key=$publicKey";

      http.Response response =
          await http.post(Uri.parse(uri)).timeout(Duration(seconds: 10));

      var decodedBody = jsonDecode(response.body);

      if ((Utilities.responseIsSuccessfull(response)) &&
          decodedBody['type'] == 1) {
        // success
        return Right(RemindersResponse.fromJson(jsonDecode(response.body)));
      } else {
        return Left(decodedBody['msg']);
      }
    } on Exception {
      return Left("Unable to get data at the moment, please try again later ");
    }
  }

  Future<Either<String, RemindersResponse>> getPatients() async {
    try {
      InitialData endPoints = GetIt.I<InitialData>();
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = endPoints.endPoint1!;
      String cid = endPoints.client!.id!;
      String publicKey = Utilities.generateMd5ForApiAuth("card_menu");
      String sid = userDetails.sessionId!;
      String uri =
          "$baseUri?nwp_request=card_menu&id=mypat&pid=${userDetails.user!.pid}&sid=$sid&cid=$cid&token=$token&public_key=$publicKey";

      http.Response response =
          await http.post(Uri.parse(uri)).timeout(Duration(seconds: 10));
      var decodedBody = jsonDecode(response.body);

      if ((Utilities.responseIsSuccessfull(response)) &&
          decodedBody['type'] == 1) {
        // success
        return Right(RemindersResponse.fromJson(jsonDecode(response.body)));
      } else {
        return Left(decodedBody['msg']);
      }
    } on Exception {
      return Left("Unable to get data at the moment, please try again later ");
    }
  }

  Future<Either<String, RemindersResponse>> getVirtualConsultations() async {
    try {
      InitialData endPoints = GetIt.I<InitialData>();
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = endPoints.endPoint1!;
      String cid = endPoints.client!.id!;
      String publicKey = Utilities.generateMd5ForApiAuth("card_menu");
      String sid = userDetails.sessionId!;
      String uri =
          "$baseUri?nwp_request=card_menu&id=mynot&pid=${userDetails.user!.pid}&sid=$sid&cid=$cid&token=$token&public_key=$publicKey";

      http.Response response =
          await http.post(Uri.parse(uri)).timeout(Duration(seconds: 10));

      var decodedBody = jsonDecode(response.body);

      if ((Utilities.responseIsSuccessfull(response)) &&
          decodedBody['type'] == 1) {
        // success
        return Right(RemindersResponse.fromJson(jsonDecode(response.body)));
      } else {
        return Left(decodedBody['msg']);
      }
    } on Exception {
      return Left("Unable to get data at the moment, please try again later ");
    }
  }

  Future<Either<String, RemindersResponse>> getAnnouncements() async {
    try {
      InitialData endPoints = GetIt.I<InitialData>();
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = endPoints.endPoint1!;
      String cid = endPoints.client!.id!;
      String publicKey = Utilities.generateMd5ForApiAuth("card_menu");
      String sid = userDetails.sessionId!;
      String uri =
          "$baseUri?nwp_request=card_menu&id=myinf&pid=${userDetails.user!.pid}&sid=$sid&cid=$cid&token=$token&public_key=$publicKey";

      http.Response response =
          await http.post(Uri.parse(uri)).timeout(Duration(seconds: 10));

      var decodedBody = jsonDecode(response.body);

      if ((Utilities.responseIsSuccessfull(response)) &&
          decodedBody['type'] == 1) {
        // success
        return Right(RemindersResponse.fromJson(jsonDecode(response.body)));
      } else {
        return Left(decodedBody['msg']);
      }
    } on Exception {
      return Left("Unable to get data at the moment, please try again later ");
    }
  }
}
