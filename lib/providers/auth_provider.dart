import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hyella/models/initial_data.dart';
import 'package:hyella/models/initial_data/signup_data.dart';
import 'package:hyella/models/signup_result_model.dart';
import 'package:hyella/services/auth_requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  late AuthRequests authRequests;
  late UserDetails userDetails;
  var getIt = GetIt.instance;

  Future<void> setInitialData(InitialData data, UserDetails? details) async {
    if (getIt.isRegistered<InitialData>()) {
      getIt.unregister<InitialData>();
    }

    getIt.registerSingleton<InitialData>(data);

    if (details != null) {
      if (getIt.isRegistered<UserDetails>()) {
        getIt.unregister<UserDetails>();
      }
      getIt.registerSingleton<UserDetails>(details);
      userDetails = details;
    }
    Future.delayed(Duration(microseconds: 2));
    // this is delayed so that the user details and endpoints gets registered first
    authRequests = AuthRequests();
    notifyListeners();
  }

  Future<void> getUserData(bool isDoctor) async {
    var result = await authRequests.getUserData(isDoctor);

    result.fold((l) {
      print(l);
    }, (r) {
      print("working");
      // set the user details
      if (getIt.isRegistered<UserDetails>()) {
        getIt.unregister<UserDetails>();
      }

      getIt.registerSingleton<UserDetails>(r);
      userDetails = r;
      notifyListeners();
    });
  }

  Future<Either<String, UserDetails?>> signIn(
      String email, String password, String userType) async {
    var res = await authRequests.signIn(email, password, userType);

    res.fold((l) {}, (r) {
      // set the user details
      if (getIt.isRegistered<UserDetails>()) {
        getIt.unregister<UserDetails>();
      }

      getIt.registerSingleton<UserDetails>(r);
      userDetails = r;
      notifyListeners();
    });

    return res;
  }

  Future<Either<String, String?>> resetPassword(
      String email, String userType) async {
    return authRequests.resetPassword(email, userType);
  }

  Future<void> logout() async {
    // clear all shared prefs
    getIt.unregister<UserDetails>();

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }

  Future<Either<String, String?>> resendOtp(
    String email,
  ) async {
    return authRequests.resendOtp(email);
  }

  Future<Either<String, UserDetails>> verifyOtp(String email, String otp,
      bool isDoctor, String action, String userType) async {
    var res =
        await authRequests.verifyOtp(email, otp, isDoctor, action, userType);
    res.fold((l) {}, (r) {
      // set the user details
      if (getIt.isRegistered<UserDetails>()) {
        getIt.unregister<UserDetails>();
      }
      getIt.registerSingleton<UserDetails>(r);
      notifyListeners();
    });
    return res;
  }

  Future<Either<String, String?>> changePassword(String newPassword,
      String oldPassword, String confirmPassword, bool isDoctor) async {
    return authRequests.changePassword(
        newPassword, oldPassword, confirmPassword, isDoctor);
  }

  Future<Either<String, UserDetails>> updateProfile(PageFormData data) async {
    var res = await authRequests.updateProfile(
     data );

    res.fold((l) {}, (r) {
      // set the user details
      if (getIt.isRegistered<UserDetails>()) {
        getIt.unregister<UserDetails>();
      }

      getIt.registerSingleton<UserDetails>(r);
      userDetails = r;
      notifyListeners();
    });
    return res;
  }

  Future<Either<String, String?>> signUp({required PageFormData data}) async {
    return authRequests.signUp(data);
  }
}
