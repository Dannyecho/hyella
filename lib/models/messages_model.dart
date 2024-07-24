import 'package:flutter/material.dart';

class MessagesModel extends ChangeNotifier {
  String doctorName;
  String doctorSpec;
  String id;

  MessagesModel(
      {required this.id, required this.doctorName, required this.doctorSpec});

  Map<String, dynamic> toMap() {
    return {
      'doctorName': doctorName,
      'doctorSpec': doctorSpec,
      'id': id,
    };
  }

  factory MessagesModel.fromMap(Map map) {
    return MessagesModel(
      doctorName: map['doctorName'],
      id: map['Id'],
      doctorSpec: map["doctorSpec"],
    );
  }
}

class Chats {
  String author;
  String chat;
  DateTime time;
  String id;

  Chats(
      {required this.id,
      required this.author,
      required this.chat,
      required this.time});

  Map<String, dynamic> toMap() {
    return {
      'author': author,
      'chat': chat,
      'id': id,
      "time": time.microsecondsSinceEpoch
    };
  }

  factory Chats.fromMap(Map map) {
    return Chats(
      author: map['author'],
      id: map['Id'],
      chat: map["chat"],
      time: DateTime.fromMicrosecondsSinceEpoch(map['time']),
    );
  }
}
