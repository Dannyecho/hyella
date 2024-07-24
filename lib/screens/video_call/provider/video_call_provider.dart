import 'dart:async';
import 'dart:convert';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:hyella/helper/api_constants.dart';
import 'package:hyella/models/initial_data.dart';
import 'package:hyella/services/messaging_services.dart';
import 'package:permission_handler/permission_handler.dart';

enum VideoCallState {
  LOADING,
  CALL_ANSWERED,
  CALL_NOT_ANSWERED,
  ERROR,
  WAITING_FOR_RESPONSE,
  JOINED_SUCCESSFULLY,
  CALL_ENDED
}

class VideoCallProvider extends ChangeNotifier {
  MessagingServices messagingServices = MessagingServices();
  VideoCallState videoCallState = VideoCallState.LOADING;

  bool audioEnabled = true;
  bool videoEnabled = true;
  int? userUid;

  RtcEngine? engine;

  bool isJoined = false, switchCamera = true, switchRender = true;

  ValueNotifier<List<int>> remoteUid = ValueNotifier([]);
  String token = "";

  AudioPlayer audioPlayer = AudioPlayer();

  void playWaitingSound() async {
    await audioPlayer.setReleaseMode(ReleaseMode.loop);
    await audioPlayer.play(AssetSource('audio/ringing.mp3'),
        mode: PlayerMode.mediaPlayer);
  }

  void autoEndIncaseOfNotPicking() async {
    Future.delayed(
      Duration(seconds: 15),
      () async {
        // stop playing is waiting sound
        stopPlayingSound();

        videoCallState = VideoCallState.CALL_NOT_ANSWERED;
        notifyListeners();

        // release the audio player resource
        await audioPlayer.release();

        // leave the video call channel
        await engine!.leaveChannel();

        // set the states accordingly
        videoEnabled = true;
        audioEnabled = true;
      },
    );
  }

  void stopPlayingSound() async {
    await audioPlayer.stop();
  }

  Future<void> initEngine(
      {required String channelName,
      required bool isDoctor,
      required String receiverId,
      required BuildContext context,
      required bool isInitiator}) async {
    try {
      videoCallState = VideoCallState.LOADING;
      notifyListeners();

      await [Permission.microphone, Permission.camera].request();

      //play waiting sound if the current user initiated the call
      // if (isInitiator) {
      //   playWaitingSound();
      // }
      engine = createAgoraRtcEngine();

      await engine?.initialize(RtcEngineContext(
        appId: GetIt.I<InitialData>().agoraAppId!,
        channelProfile: ChannelProfileType.channelProfileCommunication1v1,
      ));

      Future.delayed(Duration(seconds: 1));

      _addListeners(context, receiverId, channelName, isDoctor);

      await engine?.setChannelProfile(
          ChannelProfileType.channelProfileCommunication1v1);
      await engine?.enableVideo();
      await engine?.startPreview();

      await joinChannel(
        GetIt.I<InitialData>().agoraAppId!,
        "test",
      );

      // set the token
      token = GetIt.I<InitialData>().agoraAppId!;

      videoCallState = VideoCallState.JOINED_SUCCESSFULLY;
      notifyListeners();

      if (isInitiator) {
        autoEndIncaseOfNotPicking();
      }
    } on AgoraRtcException catch (e) {
      print("wahala" + e.toString());
      print(e.message);
      print(e.code);
      videoCallState = VideoCallState.ERROR;
      notifyListeners();
    }
  }

  void toggleVideo() async {
    if (videoEnabled) {
      videoEnabled = false;
      await engine!.enableLocalVideo(false);

      notifyListeners();
      return;
    }

    videoEnabled = true;
    await engine!.enableLocalVideo(true);
    notifyListeners();
  }

  void toggleAudio() async {
    if (audioEnabled) {
      audioEnabled = false;
      await engine!.enableLocalAudio(false);
      notifyListeners();
      return;
    }
    audioEnabled = true;
    await engine!.enableLocalAudio(true);
    notifyListeners();
  }

  void _addListeners(BuildContext context, String receiverId,
      String channelName, bool isDoctor) {
    engine!.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (
        channel,
        uid,
      ) {
        isJoined = true;
        userUid = uid;
        notifyListeners();
      },
      onConnectionStateChanged: (connection, type, reason) async {
        if (reason ==
            ConnectionChangedReasonType.connectionChangedBannedByServer) {
          // leave channel
          endCall(context, channelName, receiverId, isDoctor);
        }
      },
      onUserJoined: (con, uid, elapsed) {
        remoteUid.value = [...remoteUid.value, uid];

        // stop playing waititng sound
        stopPlayingSound();
        notifyListeners();
      },
      onUserOffline: (con, uid, reason) {
        var tempUids = remoteUid.value;
        tempUids.removeWhere((element) => element == uid);
        remoteUid.value = [...tempUids];

        notifyListeners();
      },
      onLeaveChannel: (con, stats) {
        isJoined = false;
        remoteUid.value = [];
        notifyListeners();
      },
    ));
  }

  joinChannel(String token, String channelName) async {
    await [Permission.microphone, Permission.camera].request();

    await engine!.joinChannel(
        token: token,
        channelId: channelName,
        uid: 0,
        options: ChannelMediaOptions());
  }

  Future<void> endCall(BuildContext context, String channelName,
      String receiverId, bool isDoctor) async {
    videoCallState = VideoCallState.LOADING;

    // navigate the user to the homepage
    Navigator.of(context).pop();

    kickUsersOut(channelName);

    stopPlayingSound();
    // play leave channel sound
    await audioPlayer.play(AssetSource("audio/end_call.mp3"),
        mode: PlayerMode.lowLatency);

    // release the
    await audioPlayer.release();

    await engine!.leaveChannel();
    await engine!.stopPreview();

    videoCallState = VideoCallState.CALL_ENDED;
    notifyListeners();

    // update our local server
    messagingServices.endVideoCall(userUid.toString(), channelName, receiverId);
  }

  switchCameraCall() {
    engine!.switchCamera().then((value) {
      switchCamera = !switchCamera;
      notifyListeners();
    });
  }

  switchRenderCall() {
    switchRender = !switchRender;
    remoteUid.value = List.of(remoteUid.value.reversed);
    notifyListeners();
  }

  Future<void> notifyBackendOfOngoingVideo(
      String channelName, String receiverId, bool isDoctor) {
    return messagingServices.onGoingVideoCall(
        channelName, isDoctor, receiverId);
  }

  Future<void> kickUsersOut(String channelName) async {
    final String uri = agoraBaseUrl + agoraKickingEndpoint;
    final headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Authorization': 'Basic $token'
    };

    await http.post(
      Uri.parse(uri),
      body: jsonEncode({
        "appid": GetIt.I<InitialData>().agoraAppId!,
        "cname": channelName,
        "time": 1,
        "privileges": ["join_channel"]
      }),
      headers: headers,
    );
  }
}
