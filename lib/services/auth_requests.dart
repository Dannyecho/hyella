import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:hyella/helper/constants.dart';
import 'package:hyella/helper/utilities.dart';
import 'package:hyella/models/initial_data.dart';
import 'package:hyella/models/initial_data/signup_data.dart';
import 'package:hyella/models/signup_result_model.dart';
import 'package:hyella/models/upload_file_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthRequests {
  String baseUri = GetIt.I<InitialData>().endPoint1!;
  String cid = GetIt.I<InitialData>().client!.id!;

  Future<Either<String, UserDetails>> signIn(
      String userName, String password, String userType) async {
    SignUpResponse? result;
    try {
      String token = '46866';

      String? fcmToken = await FirebaseMessaging.instance.getToken();
      String requestType =
          userType == "staff" ? "user_mgts_login" : "user_mgt_login";
      String publicKey = Utilities.generateMd5ForApiAuth(requestType);
      String uri =
          "$baseUri?nwp_request=$requestType&cid=$cid&token=$token&public_key=$publicKey";

      http.Response response = await http.post(Uri.parse(uri), body: {
        "email": userName,
        "password": password,
        "fcm_token": fcmToken,
        "u_type": userType,
        "device_uuid": (await Utilities.getDeviceId())
      }, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      }).timeout(
        Duration(seconds: 10),
      );
      var decodedRes = jsonDecode(response.body);

      if (Utilities.responseIsSuccessfull(response)) {
        result = SignUpResponse.fromJson(decodedRes);
      
        // save user details to shareprefs
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString(
          USER_DETAILS,
          jsonEncode(decodedRes['data']),
        );

        return Right(result.data!);
      } else {
        return Left(decodedRes['msg'] ??
            "Unable to sign In at the moment, please try again later");
      }
    } catch (e) {
      print(e.toString());
      return Left("Unable to sign In at the moment, please try again later");
    }
  }

  Future<Either<String, String>> uploadFile(
      String path, String source, String? recieverId, String fileName) async {
    try {
      String publicKey = Utilities.generateMd5ForApiAuth("file_upload");

      String requestType = "file_upload";

      String uri =
          "$baseUri?nwp_request=$requestType&cid=$cid&token=$token&public_key=$publicKey";

      var request = MultipartRequest("POST", Uri.parse(uri));
      request.headers.addAll(
        {"content-type": 'multipart/form-data', "accept": 'application/json'},
      );

      request.files.add(await MultipartFile.fromPath("attachment", path));

      Map<String, String> body = {
        'expiry_in_minutes': "30",
        'readonly': '1',
        'source': source,
        'receiver_id': recieverId ?? "",
        'attachment_name': ''
      };

      request.fields.addAll(body);

      var _data = await request.send();
      Response response = await Response.fromStream(_data);

      var decodedRes = jsonDecode(response.body);
      print(decodedRes);
      UploadFIleResponse uploadFIleResponse =
          UploadFIleResponse.fromJson(decodedRes);

      if (uploadFIleResponse.type == 1) {
        return Right(uploadFIleResponse.data?.attachmentUrl ?? "");
      } else {
        return Left(uploadFIleResponse.msg ?? "");
      }
    } on Exception catch (_) {
      return Left("An error occured");
    }
  }

  Future<Either<String, String?>> resetPassword(
      String email, String userType) async {
    try {
      String token = '46866';

      String requestType =
          userType == "staff" ? "user_mgts_reset" : "user_mgt_reset";
      String publicKey = Utilities.generateMd5ForApiAuth(requestType);
      String uri =
          "$baseUri?nwp_request=$requestType&cid=$cid&token=$token&public_key=$publicKey";

      http.Response response = await http.post(Uri.parse(uri), body: {
        "email": email,
        "u_type": userType
      }, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });

      var result = jsonDecode(response.body);

      if (Utilities.responseIsSuccessfull(response)) {
        return Right(result["msg"]);
      } else {
        return Left(result["msg"]);
      }
    } catch (e) {
      return Left(
          "Unable to reset password at the moment, please try again later");
    }
  }

  Future<Either<String, String?>> resendOtp(
    String email,
  ) async {
    try {
      String requestType = "user_mgt_resend_verify";
      String publicKey = Utilities.generateMd5ForApiAuth(requestType);

      String uri =
          "$baseUri?nwp_request=$requestType&cid=$cid&token=$token&public_key=$publicKey&email=$email";

      http.Response response = await http.post(Uri.parse(uri), body: {
        "email": email
      }, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });

      var result = jsonDecode(response.body);

      if (Utilities.responseIsSuccessfull(response)) {
        return Right(result["msg"]);
      } else {
        return Left(result["msg"]);
      }
    } catch (e) {
      return Left("Unable to resend OTP at the moment, please try again later");
    }
  }

  Future<Either<String, UserDetails>> verifyOtp(String email, String otp,
      bool isDoctor, String action, String userType) async {
    try {
      String requestType = isDoctor ? "user_mgts_verify" : "user_mgt_verify";
      String publicKey = Utilities.generateMd5ForApiAuth(requestType);

      String uri =
          "$baseUri?nwp_request=$requestType&token=$token&cid=$cid&public_key=$publicKey";

      http.Response response = await http.post(Uri.parse(uri), body: {
        "email": email,
        "action": action,
        "vcode": otp,
        "u_type": userType
      }, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });

      var decodedRes = jsonDecode(response.body);

      SignUpResponse result = SignUpResponse.fromJson(decodedRes);

      if (result.type == 1) {
        // save user details to shareprefs
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString(
          USER_DETAILS,
          jsonEncode(result.data),
        );

        return Right(result.data!);
      } else {
        return Left(result.msg!);
      }
    } catch (e) {
      return Left("Unable to verify OTP at the moment, please try again later");
    }
  }

  Future<Either<String, UserDetails>> getUserData(bool isDoctor) async {
    try {
      String requestType =
          isDoctor ? "user_mgts_home_info" : "user_mgt_home_info";
      String publicKey = Utilities.generateMd5ForApiAuth(requestType);
      String pid = GetIt.I<UserDetails>().user!.pid!;
      String uri =
          "$baseUri?nwp_request=$requestType&token=$token&cid=$cid&public_key=$publicKey&pid=$pid";

      http.Response response = await http.post(Uri.parse(uri), headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      var decodedRes = jsonDecode(response.body);

      UserDetails result = UserDetails.fromJson(decodedRes['data']);

      if (Utilities.responseIsSuccessfull(response)) {
        // save user details to shareprefs
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString(
          USER_DETAILS,
          jsonEncode(decodedRes['data']),
        );

        return Right(result);
      } else {
        return Left(decodedRes['msg']);
      }
    } catch (e) {
      return Left(
          "Unable to get user data at the moment, please try again later");
    }
  }

  Future<Either<String, String?>> changePassword(String newPassword,
      String oldPassword, String confirmPassword, bool isDoctor) async {
    try {
      String sid = GetIt.I<UserDetails>().sessionId!;
      String pid = GetIt.I<UserDetails>().user!.pid!;

      String requestType =
          isDoctor ? "user_mgts_new_password" : "user_mgt_new_password";

      String publicKey = Utilities.generateMd5ForApiAuth(requestType);

      String uri =
          "$baseUri?nwp_request=$requestType&pid=$pid&sid=$sid&cid=$cid&token=$token&public_key=$publicKey";

      http.Response response = await http.post(Uri.parse(uri), body: {
        "oldpassword": oldPassword,
        "password": newPassword,
        "confirm_password": confirmPassword
      }, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });

      var result = jsonDecode(response.body);

      if (Utilities.responseIsSuccessfull(response)) {
        return Right(result["msg"]);
      } else {
        return Left(result["msg"]);
      }
    } catch (e) {
      return Left(
          "Unable to change password at the moment, please try again later");
    }
  }

  Future<Either<String, UserDetails>> updateProfile(PageFormData data) async {
    try {
      // String requestType =
      //     isDoctor ? "user_mgts_home_info" : "user_mgt_update_profile";
      // String publicKey = Utilities.generateMd5ForApiAuth(requestType);
      // String pid = GetIt.I<UserDetails>().user!.pid ?? "";
      // String sid = GetIt.I<UserDetails>().sessionId ?? "";
      // String uri =
      //     "$baseUri?nwp_request=$requestType&sid=$sid&pid=$pid&cid=$cid&token=$token&public_key=$publicKey";

      // print(uri);

      // var request = MultipartRequest("POST", Uri.parse(uri));
      // request.headers.addAll(
      //   {"content-type": 'multipart/form-data', "accept": 'application/json'},
      // );
      // if (path != null) {
      //   request.files
      //       .add(await MultipartFile.fromPath("display_picture", path));
      // }

      // Map<String, String> data = {
      //   "first_name": firstName,
      //   "last_name": lastName,
      //   "email": email,
      //   "phone": phone,
      //   "religion": religion,
      //   "address": address,
      //   "nok_name": nokName,
      //   "nok_phone": nokPhone,
      //   "nok_email": nokEmail,
      //   "nok_address": nokAddress,
      //   "allergy": allergy,
      // };

      // request.fields.addAll(data);

      // var _data = await request.send();
      // Response response = await Response.fromStream(_data);
      InitialData endPoints = GetIt.I<InitialData>();
      String baseUri = endPoints.endPoint1!;
      String cid = endPoints.client!.id!;
      String token = '18550';

      String publicKey =
          Utilities.generateMd5ForApiAuth(data.nwpReequest ?? "");

      String uri =
          "$baseUri?nwp_request=${data.nwpReequest}&action=${data.action}&cid=$cid&token=$token&public_key=$publicKey";
      var body = {
        for (var item in data.fields!) item.name: item.response.toString()
      };

      http.Response response =
          await http.post(Uri.parse(uri), body: body, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      }).timeout(Duration(seconds: 10));
      var decodedRes = jsonDecode(response.body);

      SignUpResponse result = SignUpResponse.fromJson(decodedRes);

      if (Utilities.responseIsSuccessfull(response)) {
        // save user details to shareprefs
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString(
          USER_DETAILS,
          jsonEncode(result.data),
        );

        return Right(result.data!);
      } else {
        return Left(result.msg!);
      }
    } catch (e) {
      return Left(
          "Unable to update profile at the moment, please try again later");
    }
  }

  Future<Either<String, String?>> signUp(PageFormData data) async {
    try {
      InitialData endPoints = GetIt.I<InitialData>();
      String baseUri = endPoints.endPoint1!;
      String cid = endPoints.client!.id!;
      String token = '18550';

      String publicKey =
          Utilities.generateMd5ForApiAuth(data.nwpReequest ?? "");

      String uri =
          "$baseUri?nwp_request=${data.nwpReequest}&action=${data.action}&cid=$cid&token=$token&public_key=$publicKey";
      Map<String, dynamic> body = {
        for (var item in data.fields!)
          item.name.toString(): item.response.toString()
      };
      var fcmToken = await FirebaseMessaging.instance.getToken();
      body.addAll({"fcm_token": fcmToken, "u_type": "patient"});
      http.Response response =
          await http.post(Uri.parse(uri), body: body, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      }).timeout(Duration(seconds: 10));
    
      var decodedBody = jsonDecode(response.body);
      
      if (decodedBody["type"] == 1) {
        return Right(decodedBody["msg"]);
      } else {
        return Left(decodedBody["msg"]);
      }
    } on Exception {
      return Left("Unable to sign up at the moment, please try again later");
    }
  }
}
