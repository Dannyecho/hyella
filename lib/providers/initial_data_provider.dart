import 'package:flutter/material.dart';
import 'package:hyella/models/initial_data.dart';
import 'package:hyella/services/initial_request.dart';
import 'package:dartz/dartz.dart';

class InitialRequestProvider extends ChangeNotifier {
  InitialRequest initialRequest = InitialRequest();

  Future<Either<String, InitialData>> getInitialEndpoints() async {
    return initialRequest.getEndPoints();
  }

  Future<Either<String, InitialData?>> getSavedEndpoints() async {
    return initialRequest.getSavedEndPoint();
  }
}
