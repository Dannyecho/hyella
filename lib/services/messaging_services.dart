import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:hyella/models/chat_model.dart';
import 'package:hyella/models/contact_model.dart';
import '../helper/constants.dart';
import '../helper/utilities.dart';
import '../models/initial_data.dart';
import '../models/signup_result_model.dart';
import 'package:http/http.dart' as http;

class MessagingServices {
  Future<Either<String, String>> onGoingVideoCall(
      String videoId, bool isDoctor, String receiverId) async {
    try {
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = GetIt.I<InitialData>().endPoint1!;
      String cid = GetIt.I<InitialData>().client!.id!;

      String nwpRequest = isDoctor ? "vid_d_ongoing" : "vid_ongoing";
      String publicKey = Utilities.generateMd5ForApiAuth(nwpRequest);
      String uri =
          "$baseUri?nwp_request=$nwpRequest&sid=${userDetails.sessionId}&pid=${userDetails.user!.pid}&cid=$cid&token=$token&public_key=$publicKey&receiver_id=$receiverId&video_id=$videoId";

      http.Response response =
          await http.post(Uri.parse(uri)).timeout(Duration(seconds: 10));
      if (Utilities.responseIsSuccessfull(response)) {
        return Right("Video ongoing call successful");
      } else {
        return Left("Error encountered, please try again later");
      }
    } catch (e) {
      return Left("Error encountered, please try again later");
    }
  }

  Future<Either<String, String>> endVideoCall(
      String uid, String channelName, String receiverId) async {
    try {
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = GetIt.I<InitialData>().endPoint1!;
      String cid = GetIt.I<InitialData>().client!.id!;

      String nwpRequest = "vid_end";
      String publicKey = Utilities.generateMd5ForApiAuth(nwpRequest);

      String uri =
          "$baseUri?nwp_request=$nwpRequest&sid=${userDetails.sessionId}d&pid=${userDetails.user!.pid}&cid=$cid&token=$token&public_key=$publicKey&receiver_id=$receiverId";

      http.Response response =
          await http.post(Uri.parse(uri)).timeout(Duration(seconds: 10));
      if (Utilities.responseIsSuccessfull(response)) {
        return Right("End call successful");
      } else {
        return Left("Unable to end call at the moment, please try again later");
      }
    } catch (e) {
      return Left("Unable to end call at the moment, please try again later");
    }
  }

  void setChatToRead(String chatKey, String receiverId, bool isDoctor) async {
    try {
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = GetIt.I<InitialData>().endPoint1!;
      String cid = GetIt.I<InitialData>().client!.id!;

      String nwpRequest = isDoctor ? "msgs_read" : "msg_read";
      String publicKey = Utilities.generateMd5ForApiAuth(nwpRequest);

      String uri = isDoctor
          ? "$baseUri?nwp_request=$nwpRequest&pid=${userDetails.user!.pid}&cid=$cid&token=$token&public_key=$publicKey&patient_id=$receiverId&chat_key=$chatKey"
          : "$baseUri?nwp_request=$nwpRequest&pid=${userDetails.user!.pid}&cid=$cid&token=$token&public_key=$publicKey&doctor_id=$receiverId&chat_key=$chatKey";

      await http.post(Uri.parse(uri)).timeout(Duration(seconds: 10));
    } on Exception {}
  }

  Future<Either<String, String>> getRtcToken(
      String channelName, bool isDoctor, String receiverId) async {
    try {
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = GetIt.I<InitialData>().endPoint1!;
      String cid = GetIt.I<InitialData>().client!.id!;

      String nwpRequest = isDoctor ? "vid_d_start" : "vid_start";
      String publicKey = Utilities.generateMd5ForApiAuth(nwpRequest);

      String uri =
          "$baseUri?nwp_request=$nwpRequest&sid=${userDetails.sessionId}&pid=${userDetails.user!.pid}&cid=$cid&token=$token&public_key=$publicKey&receiver_id=$receiverId";

      http.Response response =
          await http.post(Uri.parse(uri)).timeout(Duration(seconds: 10));

      // http.Response response = await http
      //     .get(Uri.parse(
      //         "https://agora-token-gener.herokuapp.com/rtc/$channelName/publisher/uid/${userDetails.user!.pid}/?expiry=100000"))
      //     .timeout(Duration(seconds: 10));

      if (Utilities.responseIsSuccessfull(response)) {
        var dData = jsonDecode(response.body);

        return Right(dData["rtcToken"]);
      } else {
        return Left(
            "Unable to get token at the moment, please try again later");
      }
    } on Exception catch (_) {
      return Left("Unable to get token at the moment, please try again later");
    }
  }

  Future<Either<String, String>> getRtmToken(
      {required bool isDoctor,
      required String receiverId,
      required String channelId,
      required String pid}) async {
    try {
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = GetIt.I<InitialData>().endPoint1!;
      String cid = GetIt.I<InitialData>().client!.id!;

      String sid = userDetails.sessionId ?? "";

      String nwpRequest = isDoctor ? "msg_d_rtm" : "msg_rtm";
      String publicKey = Utilities.generateMd5ForApiAuth(nwpRequest);

      String uri =
          "$baseUri?nwp_request=$nwpRequest&sid=$sid&pid=${userDetails.user!.pid}&cid=$cid&token=$token&public_key=$publicKey&receiver_id=$receiverId";

      http.Response response =
          await http.post(Uri.parse(uri)).timeout(Duration(seconds: 10));

      await http
          .get(Uri.parse("https://agora-token-gener.herokuapp.com/rtm/$pid"))
          .timeout(Duration(seconds: 10));

      if (Utilities.responseIsSuccessfull(response)) {
        var dData = jsonDecode(response.body);

        return Right(dData["rtmToken"]);
      } else {
        return Left(
            "Unable to get token at the moment, please try again later");
      }
    } on Exception {
      return Left("Unable to get token at the moment, please try again later");
    }
  }

  Future<Either<String, List<ContactModel>>> getPatientContacts() async {
    try {
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = GetIt.I<InitialData>().endPoint1!;
      String cid = GetIt.I<InitialData>().client!.id!;

      String publicKey = Utilities.generateMd5ForApiAuth("msg_contact_list");
      String uri =
          "$baseUri?nwp_request=msg_contact_list&pid=${userDetails.user!.pid}&cid=$cid&token=$token&public_key=$publicKey";

      http.Response response =
          await http.post(Uri.parse(uri)).timeout(Duration(seconds: 10));
      var decodedBody = jsonDecode(response.body);
      log(response.body);
      if (Utilities.responseIsSuccessfull(response)) {
        // success
        List<ContactModel> contacts = [];
        decodedBody['data']['msg_contacts'].forEach((key, value) {
          contacts.add(ContactModel.fromJson(value));
        });
        return Right(contacts);
      } else {
        return Left(decodedBody['msg']);
      }
    } on Exception {
      return Left("Unable to get data at the moment, please try again later ");
    }
  }

  Future<Either<String, List<ContactModel>>> getStaffContacts() async {
    try {
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = GetIt.I<InitialData>().endPoint1!;
      String cid = GetIt.I<InitialData>().client!.id!;

      String publicKey = Utilities.generateMd5ForApiAuth("msgs_contact_list");
      print("wdf" + userDetails.user!.toJson().toString());
      String uri =
          "$baseUri?nwp_request=msgs_contact_list&pid=${userDetails.user!.pid}&cid=$cid&token=$token&public_key=$publicKey";
      http.Response response = await http.post(Uri.parse(uri));
      var decodedBody = jsonDecode(response.body);
      if ((Utilities.responseIsSuccessfull(response)) &&
          decodedBody['type'] == 1) {
        // success
        List<ContactModel> contacts = [];

        decodedBody['data']['msg_contacts'].forEach((key, value) {
          contacts.add(ContactModel.fromJson(value));
        });
        return Right(contacts);
      } else {
        return Left(decodedBody['msg']);
      }
    } on Exception {
      return Left("Unable to get data at the moment, please try again later ");
    }
  }

  Future<Either<String, String>> sendMessageToServerDoctor(
      String message, String chatKey, String receiverId) async {
    try {
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = GetIt.I<InitialData>().endPoint1!;
      String cid = GetIt.I<InitialData>().client!.id!;

      String publicKey = Utilities.generateMd5ForApiAuth("msg_save_d_msg");
      String uri =
          "$baseUri?nwp_request=msg_save_d_msg&pid=${userDetails.user!.pid}&cid=$cid&token=$token&public_key=$publicKey";

      http.Response response = await http.post(Uri.parse(uri), body: {
        "message": message,
        "chat_key": chatKey,
        "receiver_id": receiverId
      });
      var decodedResponse = jsonDecode(response.body);
      if (Utilities.responseIsSuccessfull(response)) {
        var decodedBody = jsonDecode(response.body);

        return Right(decodedBody['msg']);
      } else {
        return Left(decodedResponse['msg']);
      }
    } catch (e) {
      return Left("Unable to save message to server, please try again later");
    }
  }

  Future<Either<String, String>> sendMessageToServerPatient(
      String message, String chatKey, String receiverId) async {
    try {
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = GetIt.I<InitialData>().endPoint1!;
      String cid = GetIt.I<InitialData>().client!.id!;

      String publicKey = Utilities.generateMd5ForApiAuth("msg_save_msg");
      String uri =
          "$baseUri?nwp_request=msg_save_msg&pid=${userDetails.user!.pid}&cid=$cid&token=$token&public_key=$publicKey";

      http.Response response = await http.post(Uri.parse(uri), body: {
        "message": message,
        "chat_key": chatKey,
        "receiver_id": receiverId
      });
      var decodedResponse = jsonDecode(response.body);

      if (Utilities.responseIsSuccessfull(response)) {
        var decodedBody = jsonDecode(response.body);

        return Right(decodedBody['msg']);
      } else {
        return Left(decodedResponse['msg']);
      }
    } catch (e) {
      return Left("Unable to save message to server, please try again later");
    }
  }

  Future<Either<String, String>> deleteChat(String chatKey) async {
    try {
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = GetIt.I<InitialData>().endPoint1!;
      String cid = GetIt.I<InitialData>().client!.id!;

      String publicKey = Utilities.generateMd5ForApiAuth("msg_del");
      String uri =
          "$baseUri?nwp_request=msg_del&pid=${userDetails.user!.pid}&cid=$cid&token=$token&public_key=$publicKey&chat_key=$chatKey";

      http.Response response = await http.post(Uri.parse(uri));
      var decodedResponse = jsonDecode(response.body);

      if (Utilities.responseIsSuccessfull(response)) {
        var decodedBody = jsonDecode(response.body);

        return Right(decodedBody['msg']);
      } else {
        return Left(decodedResponse['msg']);
      }
    } catch (e) {
      return Left("Unable to delete message, please try again later");
    }
  }

  Future<Either<String, List<ChatModel>>> getDoctorPreviousChats(
      String patientId) async {
    try {
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = GetIt.I<InitialData>().endPoint1!;
      String cid = GetIt.I<InitialData>().client!.id!;

      String publicKey = Utilities.generateMd5ForApiAuth("msgs_get_convo");
      String uri =
          "$baseUri?nwp_request=msgs_get_convo&patient_id=$patientId&pid=${userDetails.user!.pid}&cid=$cid&token=$token&public_key=$publicKey";

      http.Response response = await http.post(Uri.parse(uri));
      var decodedBody = jsonDecode(response.body);
      if (Utilities.responseIsSuccessfull(response)) {
        // success
        List<ChatModel> chats = [];

        decodedBody['data']['msg_conversation'].forEach((key, value) {
          chats.add(ChatModel.fromJson(value));
        });
        return Right(chats);
      } else {
        return Left(decodedBody['msg']);
      }
    } on Exception {
      return Left("Unable to get data at the moment, please try again later ");
    }
  }

  Future<Either<String, List<ChatModel>>> getPatientPreviousChats(
      String doctorId) async {
    try {
      UserDetails userDetails = GetIt.I<UserDetails>();
      String baseUri = GetIt.I<InitialData>().endPoint1!;
      String cid = GetIt.I<InitialData>().client!.id!;

      String publicKey = Utilities.generateMd5ForApiAuth("msg_get_convo");
      String uri =
          "$baseUri?nwp_request=msg_get_convo&doctor_id=$doctorId&pid=${userDetails.user!.pid}&cid=$cid&token=$token&public_key=$publicKey";

      http.Response response = await http.post(Uri.parse(uri));
      var decodedBody = jsonDecode(response.body);
      print(decodedBody);
      if (Utilities.responseIsSuccessfull(response)) {
        // success
        List<ChatModel> chats = [];

        decodedBody['data']['msg_conversation'].forEach((key, value) {
          chats.add(ChatModel.fromJson(value));
        });
        return Right(chats);
      } else {
        return Left(decodedBody['msg']);
      }
    } on Exception {
      return Left("Unable to get data at the moment, please try again later ");
    }
  }
}
