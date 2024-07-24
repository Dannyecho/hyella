import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:hyella/custom_widgets/webview.dart';
import 'package:hyella/helper/route_generator.dart';
import 'package:hyella/main.dart';
import 'package:hyella/models/signup_result_model.dart';
import 'package:hyella/providers/auth_provider.dart';
import 'package:hyella/providers/doctor_appointments_list_provider.dart';
import 'package:hyella/providers/messaging_provider.dart';
import 'package:hyella/providers/schedule_provider.dart';
import 'package:hyella/screens/video_call/widgets/answer_decline_call.dart';
import 'package:provider/provider.dart';

Future<void> myBackgroundMessageHandler(RemoteMessage message) async {}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

class PushNotificationsManager {
  final BuildContext context;
  PushNotificationsManager({
    required this.context,
  });

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'In App Calling and Chatting Notifications', // title
      description:
          "This channel is used to notify you in case of in-app message or call",
      importance: Importance.max,
      enableLights: true,
      enableVibration: true,
      playSound: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification!.android;
        var data = message.data;
        var key = data['key'];
        if (notification != null) {
          if (android != null) {
            flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(channel.id, channel.name,
                    channelDescription: channel.description,
                    playSound: true,
                    importance: Importance.max,
                    priority: Priority.max,
                    icon: 'logo',
                    timeoutAfter: 1500,
                    visibility: NotificationVisibility.public,
                    fullScreenIntent: true,
                    // if the notification is for a video call, set the ongoing to true
                    ongoing: (key == "video_call" || key == "videos_call")),
              ),
            );
          } else {
            flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title ?? "",
              notification.body,
              NotificationDetails(
                iOS: DarwinNotificationDetails(
                  presentAlert: true,
                  presentBadge: true,
                  presentSound: true,
                  subtitle: "",
                ),
              ),
            );
          }

          await handleNotificationIntents(message, false);
          flutterLocalNotificationsPlugin.cancel(notification.hashCode);
        }
      },
    );

    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

    // manage when user opens application by clicking notifications
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      Future.delayed(Duration(seconds: 5), () {
        handleNotificationIntents(message, true);
      });
    }

    // manage notification from notification while the app is minimized
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      handleNotificationIntents(message, true);
    });

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
    } else {}
  }

  Future<void> handleNotificationIntents(
      RemoteMessage message, bool openingViaNotification) async {
    var data = message.data;
    var key = data['key'];

    if (key == "open_webview") {
      String title = data['title'];
      String url = data['url'];
      navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (context) => CustomWebView(url: url, title: title),
          settings: RouteSettings(name: "webview"),
        ),
      );
      return;
    }

    if (key == "app_l_upcoming") {
      // get new messages
      Provider.of<ScheduleProvider>(navigatorKey.currentContext!, listen: false)
          .getSchedules();
      return;
    }

    if (key == "app_ls_upcoming") {
      // get new messages
      Provider.of<DoctorAppointmentProvider>(navigatorKey.currentContext!,
              listen: false)
          .getSchedules();
      return;
    }

    if (key == "msg_contact_list") {
      // new message for patient
      // goto user chat screen
      var decoded = jsonDecode(data['data']);
      String channelId = decoded['channel_name'];
      String receiverName = decoded['sender_name'];
      String receiverId = decoded['sender_id'];
      String key = decoded['key'];

      String? routeName =
          ModalRoute.of(navigatorKey.currentContext!)!.settings.name;

      // // get new list of chat heads
      Provider.of<ChatHeadsProvider>(navigatorKey.currentContext!,
              listen: false)
          .getContacts(false);

      if (routeName != CHAT && openingViaNotification) {
        navigatorKey.currentState!.pushNamed(CHAT, arguments: {
          'pid': GetIt.I<UserDetails>().user!.pid!,
          'receiver_name': receiverName,
          'channel_id': channelId,
          'receiver_id': receiverId,
          'is_doctor': false,
          'key': key
        });
      }
    }

    if (key == "msgs_contact_list") {
      // new message for doctor
      var decoded = jsonDecode(data['data']);
      String channelId = decoded['channel_name'];
      String receiverName = decoded['sender_name'];
      String receiverId = decoded['sender_id'];
      String key = decoded['key'];

      String? routeName =
          ModalRoute.of(navigatorKey.currentContext!)!.settings.name;

      Provider.of<ChatHeadsProvider>(navigatorKey.currentContext!,
              listen: false)
          .getContacts(true);

      if (routeName != CHAT && openingViaNotification) {
        navigatorKey.currentState!.pushNamed(CHAT, arguments: {
          'pid': GetIt.I<UserDetails>().user!.pid!,
          'receiver_name': receiverName,
          'channel_id': channelId,
          'receiver_id': receiverId,
          'is_doctor': true,
          'key': key
        });
      }
    }

    if (key == "video_call" || key == "videos_call") {
      var decoded = jsonDecode(data['data']);
      String channelId = decoded['chanel_name'];
      String receiverName = decoded['sender_name'];
      String receiverId = decoded['sender_id'];
      // GOTO answer or delcine video call page
      navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (context) => AnswerDeclineCallPage(
            channelId: channelId,
            receiverName: receiverName,
            isDoctor: key == "videos_call",
            receiverId: receiverId,
          ),
          settings: RouteSettings(name: "answerDecline"),
        ),
      );
    }

    if (key == 'user_mgt_home_info') {
      if (navigatorKey.currentContext != null) {
        Provider.of<AuthProvider>(navigatorKey.currentContext!, listen: false)
            .getUserData(false);
      }
    }

    if (key == 'user_mgts_home_info') {
      if (navigatorKey.currentContext != null) {
        Provider.of<AuthProvider>(navigatorKey.currentContext!, listen: false)
            .getUserData(true);
      }
    }
  }
}
