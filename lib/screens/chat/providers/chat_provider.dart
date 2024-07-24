import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:get_it/get_it.dart';
import 'package:hyella/helper/constants.dart';
import 'package:hyella/models/chat_model.dart';
import 'package:hyella/models/initial_data.dart';
import 'package:hyella/services/auth_requests.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../helper/scaffold_messg.dart';
import '../../../providers/messaging_provider.dart';

class ChatProvider extends ChangeNotifier {
  AgoraRtmClient? client;
  AgoraRtmChannel? _channel;

  List<ChatModel> messages = [];

  bool loading = true;
  bool errorEncountered = false;
  bool sendingMessage = false;

  var getIt = GetIt.instance;

  void setLoadingToTrue() {
    loading = true;
    notifyListeners();
  }

  List<List<ChatModel>> get groupedMessages {
    return groupBy(
      messages,
      (ChatModel model) {
        print(model.date);
        return DateFormat('d/M/y').format(
          DateTime.fromMillisecondsSinceEpoch(
            model.date ?? DateTime.now().millisecondsSinceEpoch,
          ),
        );
      },
    ).values.toList();
  }

  ScrollController scrollController = ScrollController();

  void scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 20),
      curve: Curves.easeInOut,
    );

    notifyListeners();

    sendReadReceipt();
  }

  void logout() {
    client?.logout();
  }

  void scrollToBottomWithInset(double insets) {
    Future.delayed(
      Duration(milliseconds: 300),
      (() {
        scrollController.jumpTo(
          scrollController.position.maxScrollExtent + insets,
        );
      }),
    );

    notifyListeners();
  }

  Future<void> createClient(
      String pid, String channelId, bool isDoctor, String receiverId) async {
    client =
        await AgoraRtmClient.createInstance(getIt<InitialData>().agoraAppId!);

    client?.onConnectionStateChanged = (int state, int reason) {
      if (state == 5 || state == 8) {
        debugPrint("User logged out");
        client?.logout();
      }
      if (state == 3) {
        debugPrint("User connected Successfully");
      }
    };

    try {
      //login to the channel with the app id since the project is in test mode for now
      await client?.login(null, pid);
      _channel = await _createChannel(channelId);

      if (_channel != null) {
        await _channel?.join();
        sendingMessage = false;
        notifyListeners();
      } else {
        showSnackbar(
            "Unable to get chats at the moment, please try again later", false);
        loading = false;
        sendingMessage = false;
        errorEncountered = true;
        notifyListeners();
      }
    } on Exception catch (_) {}
  }

  Future<AgoraRtmChannel?> _createChannel(String channelName) async {
    try {
      AgoraRtmChannel? channel = await client?.createChannel(channelName);

      if (channel != null) {
        channel.onMemberJoined = (AgoraRtmMember member) {};
        channel.onMemberLeft = (AgoraRtmMember member) {};
        channel.onMessageReceived =
            (AgoraRtmMessage message, AgoraRtmMember member) {
          var chatType = ChatModel.checkType(
            message.text.trim(),
          );

          var actualMessage = ChatModel.getMainMessage(message.text, chatType);
          var chatKey = ChatModel.getChatKey(message.text);

          if (chatType == ChatType.receipt) {
            // mark all messages as seen
            for (var message in messages) {
              message.isRead = true;
            }

            notifyListeners();

            return;
          }

          if (chatType == ChatType.delete) {
            // deleted the chat with the received key
            String chatKey = message.text.split(deleteChatTypeDelimeter).last;

            messages.removeWhere(
              (element) => element.key == chatKey,
            );

            notifyListeners();

            return;
          }

          ChatModel newMessage;

          newMessage = ChatModel(
            key: chatKey,
            senderId: member.userId,
            date: DateTime.now().millisecondsSinceEpoch,
            message: actualMessage,
            type: ChatModel.checkType(
              message.text.trim(),
            ),
          );

          messages.add(newMessage);
          notifyListeners();
        };
      }
      return channel;
    } on Exception catch (_) {
      return null;
    }
  }

  Future<void> getPreviousChats(
      BuildContext context, String receiverId, bool isDoctor) async {
    loading = true;
    errorEncountered = false;
    notifyListeners();
    if (isDoctor) {
      await Provider.of<ChatHeadsProvider>(context, listen: false)
          .getDoctorPreviousChats(receiverId)
          .then(
            (value) => value.fold(
              (l) {
                showSnackbar(
                    "Unable to get chats at the moment, please try again later",
                    false);
                loading = false;
                errorEncountered = true;
                notifyListeners();
              },
              (r) {
                messages = r;
                loading = false;
                errorEncountered = false;
                notifyListeners();
              },
            ),
          );
    } else {
      await Provider.of<ChatHeadsProvider>(context, listen: false)
          .getPatientPreviousChats(receiverId)
          .then(
            (value) => value.fold(
              (l) {
                showSnackbar(
                    "Unable to get chats at the moment, please try again later",
                    false);
                loading = false;
                errorEncountered = true;
                notifyListeners();
              },
              (r) {
                messages = r;
                loading = false;
                errorEncountered = false;

                notifyListeners();
                Future.delayed(Duration(seconds: 1));
                scrollToBottomWithInset(100);
                notifyListeners();
              },
            ),
          );
    }
  }

  Future<void> sendFileMessage(
      {required BuildContext context,
      required String receiverId,
      required String senderPid,
      required bool isDoctor,
      required List<String> selectedFiles,
      required ChatType type}) async {
    AuthRequests authRequests = AuthRequests();

    //upload file to the backend and get links
    selectedFiles.forEach((element) async {
      var response = await authRequests.uploadFile(element, "chat", receiverId,
          "file${Random().nextInt(5000).toString()}");
      response.fold((l) {}, (r) async {
        String chatKey = _channel!.channelId! +
            "*" +
            DateTime.now().millisecondsSinceEpoch.toString();

        // append the file extension and chat key to the ned of the messages
        var messageBody = "$r${type.getExtension()}$chatKeyDelimeter$chatKey";

        var newMessage = ChatModel(
          key: chatKey,
          date: DateTime.now().millisecondsSinceEpoch,
          senderId: senderPid,
          message: r,
          type: type,
        );

        // add the message
        messages.add(newMessage);
        notifyListeners();

        await _channel?.sendMessage(
          AgoraRtmMessage.fromText(messageBody),
          true,
          true,
        );

        if (!isDoctor) {
          Provider.of<ChatHeadsProvider>(context, listen: false)
              .sendMessageToServerPatient(
            messageBody,
            newMessage.key!,
            receiverId,
          );
        } else {
          Provider.of<ChatHeadsProvider>(context, listen: false)
              .sendMessageToServerDoctor(
            messageBody,
            newMessage.key!,
            receiverId,
          );
        }
      });
    });
  }

  void deleteChat(BuildContext context, String chatKey) async {
    messages.firstWhere((element) => element.key == chatKey).isDeleted = true;
    notifyListeners();

    var messageBody =
        "Delete Message! ${ChatType.receipt.getExtension()}$chatKey";
    await _channel?.sendMessage(
      AgoraRtmMessage.fromText(messageBody),
      false,
      true,
    );

    Provider.of<ChatHeadsProvider>(context, listen: false).deleteChat(chatKey);
  }

  void sendReadReceipt() async {
    var messageBody = "Message Read! ${ChatType.receipt.getExtension()}";

    await _channel?.sendMessage(
      AgoraRtmMessage.fromText(messageBody),
      false,
      true,
    );
  }

  void sendMessage(
      {required String message,
      required BuildContext context,
      required String receiverId,
      required String senderPid,
      required bool isDoctor,
      List<String>? selectedFiles,
      List<String>? selectedImages}) async {
    print("send message");
    try {
      if (message.trim().isEmpty &&
          (selectedFiles == null || selectedFiles.isEmpty) &&
          (selectedImages == null || selectedImages.isEmpty)) {
        showSnackbar("Provide a message to send!", false);
        return;
      }

      // show loader
      sendingMessage = true;
      notifyListeners();

      if (selectedFiles != null && selectedFiles.isNotEmpty) {
        await sendFileMessage(
            context: context,
            receiverId: receiverId,
            senderPid: senderPid,
            isDoctor: isDoctor,
            selectedFiles: selectedFiles,
            type: ChatType.file);
      }

      if (selectedImages != null && selectedImages.isNotEmpty) {
        await sendFileMessage(
            context: context,
            receiverId: receiverId,
            senderPid: senderPid,
            isDoctor: isDoctor,
            selectedFiles: selectedImages,
            type: ChatType.image);
      }

      String chatKey = _channel!.channelId! +
          "*" +
          DateTime.now().millisecondsSinceEpoch.toString();
      var messageBody =
          "${message.trim()}${ChatType.text.getExtension()}$chatKeyDelimeter$chatKey";

      // send other message if message is not empty
      if (message.trim().isNotEmpty) {
        var newMessage = ChatModel(
          key: chatKey,
          date: DateTime.now().millisecondsSinceEpoch,
          senderId: senderPid,
          message: messageBody,
          type: ChatType.text,
        );
        // add the message
        messages.add(ChatModel(
          key: chatKey,
          date: DateTime.now().millisecondsSinceEpoch,
          senderId: senderPid,
          message: message,
          type: ChatType.text,
        ));

        await _channel?.sendMessage(
          AgoraRtmMessage.fromText(
            messageBody,
          ),
          false,
          true,
        );

        if (!isDoctor) {
          Provider.of<ChatHeadsProvider>(context, listen: false)
              .sendMessageToServerPatient(
                  messageBody, newMessage.key!, receiverId);
        } else {
          Provider.of<ChatHeadsProvider>(context, listen: false)
              .sendMessageToServerDoctor(
                  messageBody, newMessage.key!, receiverId);
        }
      }
      scrollToBottom();
      sendingMessage = false;

      notifyListeners();
    } on Exception catch (e) {
      print("wdf" + e.toString());
      sendingMessage = false;
      notifyListeners();
    }
  }
}
