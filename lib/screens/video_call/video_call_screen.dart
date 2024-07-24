import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hyella/helper/constants.dart';
import 'package:hyella/screens/video_call/widgets/contol_icon.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'provider/video_call_provider.dart';

class VideoCall extends StatefulWidget {
  final bool isVideoInitiator;
  final String recieverName;
  final String channelName;
  final bool isDoctor;
  final String receiverId;

  const VideoCall(
      {Key? key,
      this.isVideoInitiator = true,
      required this.recieverName,
      required this.channelName,
      required this.isDoctor,
      required this.receiverId})
      : super(key: key);

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  NumberFormat formatter = NumberFormat("00");

  @override
  void initState() {
    super.initState();
    Timer.run(
      () {
        // init agora engine
        Provider.of<VideoCallProvider>(context, listen: false).initEngine(
          channelName: widget.channelName,
          isDoctor: widget.isDoctor,
          receiverId: widget.receiverId,
          context: context,
          isInitiator: widget.isVideoInitiator,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Provider.of<VideoCallProvider>(context, listen: false).endCall(
            context,
            widget.channelName,
            widget.receiverId,
            widget.isDoctor,
          );
          return true;
        },
        child: Consumer<VideoCallProvider>(
            builder: (context, VideoCallProvider videoCallProvider, wid) {
          if (videoCallProvider.videoCallState == VideoCallState.LOADING)
            return Center(child: const CircularProgressIndicator());

          return Stack(
            children: [
              videoCallProvider.remoteUid.value.isNotEmpty
                  ? SizedBox(
                      width: deviceWidth(context),
                      height: deviceHeight(context),
                      child: AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: videoCallProvider.engine!,
                          canvas: VideoCanvas(
                              uid: videoCallProvider.remoteUid.value.first),
                        ),
                      ),
                    )
                  : SizedBox(
                      width: deviceWidth(context),
                      height: deviceHeight(context),
                      child: AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: videoCallProvider.engine!,
                          canvas: VideoCanvas(uid: 0),
                        ),
                      ),
                    ),
              SafeArea(
                child: Container(
                  height: 40,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Container(
                    alignment: Alignment.center,
                    height: 30,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        8,
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: Column(
                      children: [
                        Text(widget.recieverName,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          videoCallProvider.videoCallState ==
                                  VideoCallState.ERROR
                              ? "Unable to Initiate Call!"
                              : videoCallProvider.videoCallState ==
                                      VideoCallState.CALL_NOT_ANSWERED
                                  ? "Call not answered!"
                                  : videoCallProvider.remoteUid.value.isEmpty
                                      ? "Connecting..."
                                      : "",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              videoCallProvider.remoteUid.value.isNotEmpty
                  ? Align(
                      alignment: Alignment.topRight,
                      child: videoCallProvider.videoEnabled
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: 150,
                                  right: 10,
                                ),
                                width: 120,
                                height: 120,
                                child: AgoraVideoView(
                                  controller: VideoViewController(
                                    rtcEngine: videoCallProvider.engine!,
                                    canvas: VideoCanvas(uid: 0),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),
                    )
                  : SizedBox(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  height: 80,
                  width: 292,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      40,
                    ),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: videoCallProvider.videoCallState ==
                                VideoCallState.CALL_NOT_ANSWERED ||
                            videoCallProvider.videoCallState ==
                                VideoCallState.ERROR
                        ? [
                            ControlIcon(
                              onTap: () {
                                videoCallProvider.endCall(
                                  context,
                                  widget.channelName,
                                  widget.receiverId,
                                  widget.isDoctor,
                                );
                              },
                              bgColor: Colors.red[600]!,
                              activeIcon: SvgPicture.asset(
                                "assets/Call.svg",
                              ),
                            ),
                          ]
                        : [
                            ControlIcon(
                              onTap: videoCallProvider.toggleVideo,
                              bgColor: Colors.grey[200]!,
                              activeIcon: const Icon(
                                Icons.videocam,
                                size: 24,
                                color: Colors.black,
                              ),
                              inActiveIcon: const Icon(
                                Icons.videocam_off,
                                size: 24,
                                color: Colors.black,
                              ),
                              value: videoCallProvider.videoEnabled,
                            ),
                            ControlIcon(
                              onTap: videoCallProvider.switchCameraCall,
                              bgColor: Colors.grey[200]!,
                              activeIcon: const Icon(
                                Icons.flip_camera_ios,
                                size: 24,
                                color: Colors.black,
                              ),
                            ),
                            ControlIcon(
                              onTap: videoCallProvider.toggleAudio,
                              bgColor: Colors.grey[200]!,
                              activeIcon: const Icon(
                                Icons.mic,
                                size: 24,
                                color: Colors.black,
                              ),
                              inActiveIcon: const Icon(
                                Icons.mic_off,
                                size: 24,
                                color: Colors.black,
                              ),
                              value: videoCallProvider.audioEnabled,
                            ),
                            ControlIcon(
                              onTap: () async {
                                videoCallProvider.endCall(
                                  context,
                                  widget.channelName,
                                  widget.receiverId,
                                  widget.isDoctor,
                                );
                              },
                              bgColor: Colors.red[600]!,
                              activeIcon: SvgPicture.asset(
                                "assets/Call.svg",
                              ),
                            )
                          ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
