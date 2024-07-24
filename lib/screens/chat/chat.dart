import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hyella/helper/constants.dart';
import 'package:hyella/main.dart';
import 'package:hyella/models/signup_result_model.dart';
import 'package:hyella/providers/messaging_provider.dart';
import 'package:hyella/screens/chat/chat_item.dart';
import 'package:hyella/screens/chat/providers/chat_provider.dart';
import 'package:hyella/screens/custom_web_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../helper/styles.dart';

class Chat extends StatefulWidget {
  final String receiverName;
  final String receiverId;
  final String channelId;
  final String pid;
  final bool isDoctor;
  final String chatKey;

  const Chat(
      {Key? key,
      required this.pid,
      required this.receiverName,
      required this.channelId,
      required this.isDoctor,
      required this.chatKey,
      required this.receiverId})
      : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  DateFormat dateFormat = DateFormat('dd MMM yyyy');

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      getInitialData();
    });
  }

  void getInitialData() async {
    Provider.of<ChatProvider>(context, listen: false)
        .getPreviousChats(context, widget.receiverId, widget.isDoctor);

    Provider.of<ChatProvider>(context, listen: false).createClient(
        widget.pid, widget.channelId, widget.isDoctor, widget.receiverId);

    // set the unread message count to zero
    Provider.of<ChatHeadsProvider>(context, listen: false)
        .setReadCountToZero(widget.chatKey, widget.isDoctor, widget.receiverId);
  }

  List<String> selectedImages = [];
  List<String> selectedFiles = [];

  @override
  void dispose() {
    Provider.of<ChatProvider>(navigatorKey.currentContext!, listen: false)
        .logout();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, ChatProvider chatProvider, wid) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: Text(
              widget.receiverName,
            ),
            automaticallyImplyLeading: true,
            actions: [
              Visibility(
                visible:
                    GetIt.I<UserDetails>().webViews?.videoChat?.webview == 1,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => GeneralWebview(
                          url: GetIt.I<UserDetails>()
                              .webViews!
                              .videoChat!
                              .endpoint!,
                          nwpRequest: GetIt.I<UserDetails>()
                              .webViews!
                              .videoChat!
                              .params!
                              .nwpWebiew!,
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.video_call,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: WillPopScope(
              onWillPop: () async {
                Provider.of<ChatProvider>(context, listen: false)
                    .setLoadingToTrue();

                Navigator.pop(context);
                return false;
              },
              child: chatProvider.loading
                  ? shimmerEffect()
                  : chatProvider.errorEncountered
                      ? SizedBox(
                          width: deviceWidth(context),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Styles.regular(
                                  "Unable to load your chats at the moment\nplease try again later",
                                  fontSize: 14,
                                  align: TextAlign.center),
                              const SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                onPressed: () => chatProvider.getPreviousChats(
                                    context,
                                    widget.receiverId,
                                    widget.isDoctor),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Theme.of(context).primaryColor)),
                                child: const Text("Tap to retry"),
                              )
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                physics: ClampingScrollPhysics(),
                                controller: chatProvider.scrollController,
                                itemCount: chatProvider.groupedMessages.length,
                                padding: EdgeInsets.only(top: 20),
                                itemBuilder: (context, index) => Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        (dateFormat.format(
                                                  DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                    chatProvider
                                                        .groupedMessages[index]
                                                        .first
                                                        .date!,
                                                  ),
                                                ) ==
                                                dateFormat
                                                    .format(DateTime.now())
                                            ? "Today"
                                            : dateFormat.format(
                                                DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                  chatProvider
                                                      .groupedMessages[index]
                                                      .first
                                                      .date!,
                                                ),
                                              )),
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Column(
                                      children: chatProvider
                                          .groupedMessages[index]
                                          .map((e) => ChatItem(
                                              chatModel: e, pid: widget.pid))
                                          .toList(),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            sendMessageWidget(chatProvider),
                            Wrap(
                              children: selectedImages
                                  .map(
                                    (e) => Container(
                                      height: 100,
                                      width: 80,
                                      margin: EdgeInsets.only(top: 10),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Image.file(
                                              File(e),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          Positioned(
                                            right: 10,
                                            top: 5,
                                            child: GestureDetector(
                                              onTap: () {
                                                selectedImages.remove(e);
                                                setState(() {});
                                              },
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Wrap(
                              children: selectedFiles
                                  .map(
                                    (e) => Container(
                                      height: 100,
                                      width: 100,
                                      margin: EdgeInsets.only(top: 10),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Image.file(
                                              File(e),
                                            ),
                                          ),
                                          Positioned(
                                            right: 5,
                                            child: GestureDetector(
                                              onTap: () {
                                                selectedFiles.remove(e);
                                                setState(() {});
                                              },
                                              child: Icon(
                                                Icons.close,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            )
                          ],
                        ),
            ),
          ),
        );
      },
    );
  }

  TextEditingController messageController = TextEditingController();

  Widget sendMessageWidget(ChatProvider chatProvider) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20))),
                builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      title: Text("Add Image From Camera"),
                      leading: Icon(Icons.camera_alt),
                      onTap: () async {
                        var file = await takePhoto(ImageSource.camera);
                        if (file != null) {
                          selectedImages.add(file.path);
                          setState(() {});
                        }

                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text("Add Image From Gallery"),
                      leading: Icon(Icons.photo),
                      onTap: () async {
                        var file = await takePhoto(ImageSource.gallery);
                        if (file != null) {
                          selectedImages.add(file.path);
                          setState(() {});
                        }
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text("Add File"),
                      leading: Icon(Icons.folder),
                      onTap: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          allowMultiple: false,
                          allowCompression: true,
                          allowedExtensions: ['pdf', 'doc'],
                        );

                        if (result != null) {
                          selectedFiles =
                              result.files.map((e) => e.path!).toList();
                        }
                      },
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              );
            },
            icon: CircleAvatar(
              backgroundColor: Colors.white54,
              child: Icon(
                Icons.add,
                size: 15,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextField(
              controller: messageController,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 7,
              onTap: () async {
                // Future.delayed(Duration(seconds: 1), () {
                //   chatProvider.scrollToBottomWithInset(
                //       MediaQuery.of(context).viewInsets.bottom);
                // });
              },
              decoration: const InputDecoration(
                hintText: 'Input message',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          chatProvider.sendingMessage
              ? CircularProgressIndicator()
              : GestureDetector(
                  child: Icon(
                    Icons.send,
                    size: 30,
                    color: Theme.of(context).primaryColor,
                  ),
                  onTap: () {
                    Provider.of<ChatProvider>(context, listen: false)
                        .sendMessage(
                      message: messageController.text,
                      context: context,
                      receiverId: widget.receiverId,
                      senderPid: GetIt.I<UserDetails>().user!.pid!,
                      isDoctor: widget.isDoctor,
                      selectedImages: selectedImages,
                      selectedFiles: selectedFiles,
                    );

                    messageController.clear();
                    selectedFiles.clear();
                    selectedImages.clear();
                  },
                )
        ],
      ),
    );
  }

  Widget shimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemBuilder: (context, index) => Container(
          height: 60,
          margin: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                5,
              ),
            ),
          ),
        ),
        itemCount: 8,
      ),
    );
  }

  ImagePicker _picker = ImagePicker();

  Future<XFile?> takePhoto(ImageSource source) async {
    return await _picker.pickImage(source: source);
  }
}
