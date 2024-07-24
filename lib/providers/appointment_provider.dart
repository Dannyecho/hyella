import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hyella/models/avail_timeslot_response.dart';
import 'package:hyella/models/book_appt_response_model.dart';
import 'package:hyella/models/pre_payment_model.dart';
import 'package:hyella/services/appointments_request.dart';
import '../models/appt_venues_resp_model.dart';

class AppointmentProvider extends ChangeNotifier {
  AppointmentRequest appointmentRequest = AppointmentRequest();

  Future<Either<String, BookApptRespModel>> completeAppointment(
    String appointmentRef,
    String doctorId,
  ) async {
    var res =
        await appointmentRequest.completeAppointment(appointmentRef, doctorId);
    return res;
  }

  Future<Either<String, AppLocationResponse>> getVenueAndLocation(
      String doctorId, String dependentId, String specialtyKey) async {
    return appointmentRequest.getVenueAndLocation(doctorId, dependentId, specialtyKey);
  }

  Future<Either<String, AvailableTimeSlotRes>> getTimeSlots(String locationId,
      String date, String doctorId, String dependentId) async {
    return appointmentRequest.getTimeSlots(
        locationId, date, doctorId, dependentId);
  }

  Future<Either<String, PrePaymentResponse>> getPrePaymentData(
      String doctorId, String locationId, String date, String timeId) async {
    return appointmentRequest.getPrePaymentData(
        doctorId, locationId, date, timeId);
  }
}
