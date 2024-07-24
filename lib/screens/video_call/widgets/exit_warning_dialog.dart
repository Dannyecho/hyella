import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/video_call_provider.dart';

class ExitWarningDialog extends StatelessWidget {
  final bool isDoctor;
  final String channelName;
  final String receiverId;
  const ExitWarningDialog({
    Key? key,
    required this.channelName,
    required this.isDoctor,
    required this.receiverId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      titlePadding: EdgeInsets.only(top: 20, bottom: 10),
      title: Center(
        child: Text(
          "End Video Call",
          style: TextStyle(fontSize: 16),
        ),
      ),
      children: [
        Text(
          "Are you sure you want to end the video call?",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "No",
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () async {
                Provider.of<VideoCallProvider>(context, listen: false)
                    .endCall(context, channelName, receiverId, isDoctor);
              },
              child: Text(
                "Yes",
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        )
      ],
    );
  }
}
