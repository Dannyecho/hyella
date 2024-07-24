import 'package:hyella/helper/constants.dart';

enum ChatType { text, image, file, receipt, delete }

class ChatModel {
  final String? key;
  final String? senderId;
  final String? message;
  final int? date;
  final ChatType type;
  bool isDeleted;
  bool isRead;

  ChatModel(
      {this.key,
      this.senderId,
      this.message,
      this.date,
      required this.type,
      this.isRead = false,
      this.isDeleted = false});

  ChatModel.fromJson(Map<String, dynamic> json)
      : key = json['key'] as String?,
        senderId = json['source'] as String?,
        date = json['date'] as int?,
        isDeleted = false,
        isRead = json['read']??false,
        message = getMainMessage(
          json['message'] as String,
          checkType(
            json['message'],
          ),
        ),
        type = checkType(
          json['message'],
        );

  static ChatType checkType(String message) {
    if (message.contains(imageChatTypeDelimeter)) {
      return ChatType.image;
    }
    if (message.contains(fileChatTypeDelimeter)) {
      return ChatType.file;
    }
    if (message.contains(receiptChatTypeDelimeter)) {
      return ChatType.receipt;
    }

    if (message.contains(textChatTypeDelimeter)) {
      return ChatType.text;
    }

    return ChatType.delete;
  }

  static String getMainMessage(String messageFromAgora, ChatType type) {
    String separator = "";
    switch (type) {
      case ChatType.text:
        separator = textChatTypeDelimeter;
        break;
      case ChatType.image:
        separator = imageChatTypeDelimeter;
        break;
      case ChatType.file:
        separator = fileChatTypeDelimeter;
        break;
      case ChatType.receipt:
        separator = receiptChatTypeDelimeter;
        break;
      case ChatType.delete:
        separator = deleteChatTypeDelimeter;
    }

    String actualMessage = messageFromAgora.split(separator).first;

    return actualMessage;
  }

  static String getChatKey(String messageFromAgora) {
    String separator = chatKeyDelimeter;
    // the last part of the message is the chatKey
    String messageKey = messageFromAgora.split(separator).last;
    return messageKey;
  }

  Map<String, dynamic> toJson() => {
        'key': key,
        'source': senderId,
        'message': message,
      };
}

extension NameExtension on ChatType {
  String getExtension() {
    switch (this) {
      case ChatType.text:
        return textChatTypeDelimeter;
      case ChatType.image:
        return imageChatTypeDelimeter;
      case ChatType.file:
        return fileChatTypeDelimeter;
      case ChatType.receipt:
        return receiptChatTypeDelimeter;
      case ChatType.delete:
        return deleteChatTypeDelimeter;
    }
  }
}
