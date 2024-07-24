import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hyella/models/service_response_model.dart';
import 'package:hyella/services/services_requests.dart';

class ServiceDetailProvider extends ChangeNotifier {
  ServicesRequests servicesRequests = ServicesRequests();

  Future<Either<String, ServiceResponseModel?>> getDetails(
    String id,

  ) {
    return servicesRequests.getDetails(id);
  }
}
