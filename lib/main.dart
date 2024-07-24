import 'dart:async';
import 'dart:io';

import 'package:connection_notifier/connection_notifier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:hyella/di.dart';
import 'package:hyella/helper/notification_helper.dart';
import 'package:hyella/helper/styles.dart';
import 'package:hyella/helper/utilities.dart';
import 'package:hyella/providers/appointment_provider.dart';
import 'package:hyella/providers/card_details_provider.dart';
import 'package:hyella/providers/doctor_appointments_list_provider.dart';
import 'package:hyella/providers/fund_wallet_provider.dart';
import 'package:hyella/providers/initial_data_provider.dart';
import 'package:hyella/providers/auth_provider.dart';
import 'package:hyella/providers/color_provider.dart';
import 'package:hyella/providers/doctors_provider.dart';
import 'package:hyella/providers/messaging_provider.dart';
import 'package:hyella/providers/nav_index_provider.dart';
import 'package:hyella/providers/revenue_provider.dart';
import 'package:hyella/providers/schedule_provider.dart';
import 'package:hyella/providers/service_details_provider.dart';
import 'package:hyella/screens/chat/providers/chat_provider.dart';
import 'package:hyella/screens/video_call/provider/video_call_provider.dart';
import 'package:power_file_view/power_file_view.dart';
import 'helper/route_generator.dart';
import 'package:provider/provider.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  PowerFileViewManager.initLogEnable(true, true);
  PowerFileViewManager.initEngine();
  InitialSetup.setupSingletons();
  HttpOverrides.global = MyHttpOverrides();

  InitialSetup.setMessageHandler();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<DoctorProvider>(
          create: (_) {
            return DoctorProvider();
          },
        ),
        ChangeNotifierProvider<VideoCallProvider>(
          create: (_) {
            return VideoCallProvider();
          },
        ),
        ChangeNotifierProvider<NavIndexProvider>(
          create: (_) {
            return NavIndexProvider();
          },
        ),
        ChangeNotifierProvider<InitialRequestProvider>(
          create: (_) {
            return InitialRequestProvider();
          },
        ),
        ChangeNotifierProvider<ColorNameProvider>(
          create: (_) {
            return ColorNameProvider();
          },
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) {
            return AuthProvider();
          },
        ),
        ChangeNotifierProvider<ServiceDetailProvider>(
          create: (_) {
            return ServiceDetailProvider();
          },
        ),
        ChangeNotifierProvider<CardDetailProvider>(
          create: (_) {
            return CardDetailProvider();
          },
        ),
        ChangeNotifierProvider<AppointmentProvider>(
          create: (_) {
            return AppointmentProvider();
          },
        ),
        ChangeNotifierProvider<ScheduleProvider>(
          create: (_) {
            return ScheduleProvider();
          },
        ),
        ChangeNotifierProvider<DoctorAppointmentProvider>(
          create: (_) {
            return DoctorAppointmentProvider();
          },
        ),
        ChangeNotifierProvider<ChatHeadsProvider>(
          create: (_) {
            return ChatHeadsProvider();
          },
        ),
        ChangeNotifierProvider<RevenueProvider>(
          create: (_) {
            return RevenueProvider();
          },
        ),
        ChangeNotifierProvider<WalletProvider>(
          create: (_) {
            return WalletProvider();
          },
        ),
        ChangeNotifierProvider<ChatProvider>(
          create: (_) {
            return ChatProvider();
          },
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Timer.run(
      () {
        // print("initstate");
        initNotification();
      },
    );
  }

  void initNotification() async {
    await PushNotificationsManager(context: context).init();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ColorNameProvider>(
      builder: (BuildContext context, value, Widget? child) =>
          ConnectionNotifier(
        connectionNotificationOptions: ConnectionNotificationOptions(
          height: 60,
          disconnectedContent: Container(
            child: Styles.bold(
              "You do not have an active internet access.",
              color: Colors.white,
              fontSize: 12,
              align: TextAlign.center,
            ),
          ),
          connectedContent: Container(
            alignment: Alignment.center,
            child: Styles.bold(
              "Internet restored!",
              color: Colors.white,
              fontSize: 12,
              align: TextAlign.center,
            ),
          ),
        ),
        child: MaterialApp(
          title: value.name,
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            buttonTheme: ButtonThemeData(
              buttonColor: Theme.of(context).primaryColor,
            ),
            primaryColor: Utilities.fromHex(value.primaryColor),
            disabledColor: Utilities.fromHex(value.tertiaryColor),
            primaryColorDark: Color(0xff9055D8),
            primaryColorLight: Color(0xff9099D8),
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(secondary: Utilities.fromHex(value.secondaryColor)),
          ),
          initialRoute: '/',
          onGenerateRoute: (settings) => RouteGenerator.generateRoute(settings),
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
