import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hyella/helper/constants.dart';
import 'package:hyella/models/chat_model.dart';
import 'package:hyella/screens/chat/providers/chat_provider.dart';
import 'package:image_preview/image_preview.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:power_file_view/power_file_view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ChatItem extends StatefulWidget {
  final ChatModel chatModel;
  final String pid;
  ChatItem({Key? key, required this.chatModel, required this.pid})
      : super(key: key);

  @override
  State<ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  final DateFormat dateFormat = DateFormat('hh:mm a');

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.chatModel.isDeleted
          ? Text(
              "This message is deleted",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            )
          : GestureDetector(
              onLongPress: () {
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        onTap: () {
                          Provider.of<ChatProvider>(context, listen: false)
                              .deleteChat(context, widget.chatModel.key!);
                          Navigator.pop(context);
                        },
                        title: Text(
                          "Delete",
                          style: TextStyle(fontSize: 12, color: Colors.red),
                        ),
                        trailing: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: deviceWidth(context) * .8,
                    child: FutureBuilder<Widget>(
                      future: showChat(context, widget.chatModel),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Shimmer(
                            child: Container(
                              color: Colors.white,
                              width: deviceWidth(context) * .7,
                            ),
                            gradient: LinearGradient(
                              colors: [Colors.black45, Colors.white],
                            ),
                          );
                        } else if (snapshot.hasData) {
                          return snapshot.data!;
                        }

                        return SizedBox();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          dateFormat.format(
                            DateTime.fromMillisecondsSinceEpoch(
                              widget.chatModel.date!,
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      widget.chatModel.isRead
                          ? SizedBox(
                              width: 20,
                              child: Stack(
                                children: [
                                  Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  Positioned(
                                    top: 1,
                                    left: 5,
                                    child: Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.black45,
                            )
                    ],
                  ),
                ],
              ),
            ),
      padding: EdgeInsets.all(10),
      margin: !(widget.chatModel.senderId == widget.pid)
          ? EdgeInsets.only(
              right: deviceWidth(context) * .1,
              bottom: 15,
              left: 20,
            )
          : EdgeInsets.only(
              left: deviceWidth(context) * .1, bottom: 15, right: 20),
      decoration: BoxDecoration(
        color: !(widget.chatModel.senderId == widget.pid)
            ? Colors.white
            : Colors.green[100],
        boxShadow: [BoxShadow(blurRadius: 3, color: Colors.grey)],
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
    );
  }

  Future<Widget> showChat(BuildContext context, ChatModel chatModel) async {
    if (chatModel.type == ChatType.text) {
      return Text(
        chatModel.message ?? "",
        style: TextStyle(
          fontSize: 14,
        ),
      );
    } else if (chatModel.type == ChatType.image) {
      return GestureDetector(
        onTap: () {
          openImagesPage(
            Navigator.of(context),
            imgUrls: [chatModel.message!],
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: CachedNetworkImage(
            imageUrl: chatModel.message!,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else if (chatModel.type == ChatType.file) {
      final _directory = await getTemporaryDirectory();
      int randomInt = Random().nextInt(50000);
      final downloadPath = "${_directory.path}/fileview/$randomInt.pdf";
      return PowerFileViewWidget(
        downloadUrl: chatModel.message,
        filePath: downloadPath,
        loadingBuilder: (viewType, progress) {
          return Container(
            color: Colors.grey,
            alignment: Alignment.center,
            child: Text("Loading: $progress"),
          );
        },
        errorBuilder: (viewType) {
          return Container(
            color: Colors.red,
            alignment: Alignment.center,
            child: const Text("Something went wrong!!!!"),
          );
        },
      );
    }

    return SizedBox();
  }
}
