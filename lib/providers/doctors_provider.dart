import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hyella/services/appointments_request.dart';

import '../models/doctors_list_response_model.dart';

class DoctorProvider extends ChangeNotifier {
  AppointmentRequest appointmentRequest = AppointmentRequest();
  DoctorProvider._internal();
  static final DoctorProvider _instance = DoctorProvider._internal();

  factory DoctorProvider() {
    return _instance;
  }

  Future<Either<String, DoctorListResponse>> getDoctorsForApp(String specialtyKey) async {
    return appointmentRequest.getDoctorList(specialtyKey);
  }
}
