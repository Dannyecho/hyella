import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import 'package:hyella/services/messaging_services.dart';
import '../models/chat_model.dart';
import '../models/contact_model.dart';

class ChatHeadsProvider extends ChangeNotifier {
  MessagingServices messagingServices = MessagingServices();

  List<ContactModel> contacts = [];
  List<ContactModel> copyContacts = [];
  bool errorLoadingData = false;
  bool loading = true;
  String errorMessage =
      "Unable to load your chats at the moment\nplease try again later";

  void setReadCountToZero(String chatKey, bool isDoctor, String receiverId) {
    if (contacts.where((element) => element.key == chatKey).isNotEmpty) {
      contacts.firstWhere((element) => element.key == chatKey).unreadMessages =
          0;
      copyContacts
          .firstWhere((element) => element.key == chatKey)
          .unreadMessages = 0;
    }

    notifyListeners();

    messagingServices.setChatToRead(chatKey, receiverId, isDoctor);
  }

  Future<Either<String, String>> sendMessageToServerPatient(
      String message, String chatId, String receiverId) async {
    return messagingServices.sendMessageToServerPatient(
        message, chatId, receiverId);
  }

  Future<Either<String, String>> deleteChat(String chatKey) async {
    return messagingServices.deleteChat(chatKey);
  }

  Future<Either<String, String>> sendMessageToServerDoctor(
      String message, String chatId, String receiverId) async {
    return messagingServices.sendMessageToServerDoctor(
        message, chatId, receiverId);
  }

  void filterContact(String filter) {
    if (filter.isEmpty) {
      contacts = copyContacts;
      notifyListeners();
    } else {
      contacts = copyContacts
          .where((element) =>
              element.title!.toLowerCase().contains(filter.toLowerCase()) ||
              element.subTitle!.toLowerCase().contains(filter.toLowerCase()))
          .toList();
      notifyListeners();
    }
  }

  Future<void> getContacts(bool isDoctor) async {
    loading = true;
    errorLoadingData = false;
    notifyListeners();
    Either<String, List<ContactModel>> res;

    if (isDoctor) {
      res = await messagingServices.getStaffContacts();
    } else {
      res = await messagingServices.getPatientContacts();
    }

    res.fold((l) {
      errorLoadingData = true;
      loading = false;
      errorMessage = l;
      notifyListeners();
    }, (r) {
      r.sort(
        (a, b) => b.unreadMessages!.compareTo(a.unreadMessages!),
      );
      contacts = r;
      copyContacts = r;

      errorLoadingData = false;
      loading = false;
      notifyListeners();
    });
  }

  Future<Either<String, List<ChatModel>>> getPatientPreviousChats(
      String doctorId) async {
    return messagingServices.getPatientPreviousChats(doctorId);
  }

  Future<Either<String, List<ChatModel>>> getDoctorPreviousChats(
      String patientId) async {
    return messagingServices.getDoctorPreviousChats(patientId);
  }
}
