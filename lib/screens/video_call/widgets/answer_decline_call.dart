import 'package:flutter/material.dart';
import 'package:hyella/screens/video_call/provider/video_call_provider.dart';
import 'package:hyella/screens/video_call/video_call_screen.dart';
import 'package:provider/provider.dart';

class AnswerDeclineCallPage extends StatefulWidget {
  final String receiverName;
  final String channelId;
  final bool isDoctor;
  final String receiverId;

  const AnswerDeclineCallPage(
      {Key? key,
      required this.channelId,
      required this.receiverName,
      required this.isDoctor,
      required this.receiverId})
      : super(key: key);

  @override
  State<AnswerDeclineCallPage> createState() => _AnswerDeclineCallPageState();
}

class _AnswerDeclineCallPageState extends State<AnswerDeclineCallPage> {
  bool up = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[400],
                radius: 50,
                child: Icon(
                  Icons.person,
                  color: Colors.grey[800],
                  size: 50,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                widget.receiverName + " is calling",
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.red,
                radius: 30,
                child: IconButton(
                  onPressed: () async {
                    // goto home page
                    await Provider.of<VideoCallProvider>(context, listen: false)
                        .endCall(context, widget.channelId, widget.receiverId,
                            widget.isDoctor);
                  },
                  icon: Icon(
                    Icons.call_end,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              SizedBox(
                width: 40,
              ),
              CircleAvatar(
                backgroundColor: Colors.green,
                radius: 30,
                child: IconButton(
                  onPressed: () async {
                    // make a call to the ongoing video call api to notify the backend when a call is answered
                    Provider.of<VideoCallProvider>(context, listen: false)
                        .notifyBackendOfOngoingVideo(
                      widget.channelId,
                      widget.receiverId,
                      widget.isDoctor,
                    );
                    // goto video call page
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => VideoCall(
                          isVideoInitiator: false,
                          recieverName: widget.receiverName,
                          channelName: "test",
                          isDoctor: widget.isDoctor,
                          receiverId: widget.receiverId,
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.phone_enabled,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
