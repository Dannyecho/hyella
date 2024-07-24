import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hyella/models/initial_data/file_input_type.dart';
import 'package:hyella/services/auth_requests.dart';

class FileInputBulder extends StatefulWidget {
  FileInputType inputType;
  Function updateData;
  FileInputBulder(
      {super.key, required this.inputType, required this.updateData});

  @override
  State<FileInputBulder> createState() => _FileInputBulderState();
}

class _FileInputBulderState extends State<FileInputBulder> {
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
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();

                  if (result != null) {
                    File file = File(result.files.single.path!);
                    var uploadResult = await AuthRequests().uploadFile(
                      file.path,
                      widget.inputType.name!,
                      "",
                      "",
                    );

                    uploadResult.fold((l) {
                      //  Fluttertoast.showToast(msg: l);
                    }, (r) {
                      widget.inputType.response = r;
                      setState(() {});
                    });
                  }
                },
                child: Text("Choose File"),
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
}
