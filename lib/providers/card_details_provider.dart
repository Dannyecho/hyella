import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hyella/services/card_details_service.dart';

import '../models/reminders_response_model.dart';

class CardDetailProvider extends ChangeNotifier {
  CardDetailsService cardDetailsService = CardDetailsService();
  Future<Either<String, RemindersResponse>> getMedicalHistory() async {
    return cardDetailsService.getMedicalHistory();
  }

  Future<Either<String, RemindersResponse>> getOnlineConsultation() async {
    return cardDetailsService.getConsultation();
  }

  Future<Either<String, RemindersResponse>> getTips() async {
    return cardDetailsService.getTips();
  }

    Future<Either<String, RemindersResponse>> getMyPatients() async {
    return cardDetailsService.getPatients();
  }

  Future<Either<String, RemindersResponse>> getVirtualConsultations() async {
    return cardDetailsService.getVirtualConsultations();
  }
  
  Future<Either<String, RemindersResponse>> getAnnouncement() async {
    return cardDetailsService.getAnnouncements();
  }
}
