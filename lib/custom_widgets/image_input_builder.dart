import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hyella/helper/styles.dart';
import 'package:hyella/models/initial_data/picture_input_type.dart';
import 'package:hyella/services/auth_requests.dart';
import 'package:image_picker/image_picker.dart';

class ImageInputBulder extends StatefulWidget {
  PictureInputType inputType;
  Function updateData;
  ImageInputBulder(
      {super.key, required this.inputType, required this.updateData});

  @override
  State<ImageInputBulder> createState() => _ImageInputBulderState();
}

class _ImageInputBulderState extends State<ImageInputBulder> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .9,
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  // open bottom sheet to select image
                  showModalBottomSheet(
                    context: context,
                    useRootNavigator: true,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(25))),
                    builder: (context) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Select image source",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FWt.mediumBold,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Divider(
                            color: Colors.black45,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              XFile? file = await takePhoto(ImageSource.camera);

                              if (file != null) {
                                var result = await AuthRequests().uploadFile(
                                  file.path,
                                  widget.inputType.name!,
                                  "",
                                  file.name,
                                );

                                result.fold((l) {
                                  Fluttertoast.showToast(msg: l);
                                }, (r) {
                                  widget.inputType.response = r;
                                  if (mounted) {
                                    setState(() {});
                                  }
                                });
                              }
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.camera,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  "Camera",
                                  style: TextStyle(
                                      fontSize: 14, fontWeight: FWt.semiBold),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              XFile? file =
                                  await takePhoto(ImageSource.gallery);
                              if (file != null) {
                                var result = await AuthRequests().uploadFile(
                                    file.path,
                                    widget.inputType.name!,
                                    "",
                                    file.name);

                                Navigator.pop(context);
                                result.fold((l) {
                                  Fluttertoast.showToast(msg: l);
                                }, (r) {
                                  widget.inputType.response = r;
                                  setState(() {});
                                });
                              }
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.image,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  "Gallery",
                                  style: TextStyle(
                                      fontSize: 14, fontWeight: FWt.semiBold),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                child: Text("Choose Image"),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                widget.inputType.fieldLabel!,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Visibility(
                visible: widget.inputType.response != null &&
                    widget.inputType.response!.isNotEmpty,
                child: Icon(
                  Icons.check,
                  color: Theme.of(context).primaryColor,
                ),
              )
            ],
          ),
          Visibility(
            visible: widget.inputType.note != null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5,
                ),
                Text(
                  widget.inputType.note ?? "",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<XFile?> takePhoto(ImageSource source) async {
    return await _picker.pickImage(source: source);
  }
}
