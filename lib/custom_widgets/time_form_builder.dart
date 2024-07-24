import 'package:flutter/material.dart';
import 'package:hyella/helper/extensions.dart';
import 'package:hyella/models/initial_data/time_input_type.dart';

class TimeInputBuilder extends StatefulWidget {
  TimeInputType inputType;
  Function updateData;
  TimeInputBuilder(
      {super.key, required this.inputType, required this.updateData});

  @override
  State<TimeInputBuilder> createState() => _TimeInputBuilderState();
}

class _TimeInputBuilderState extends State<TimeInputBuilder> {
  TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    textEditingController.text = widget.inputType.response ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .9,
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.none,
            controller: textEditingController,
            onTap: () async {
              var time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );

              if (time != null) {
                var formatedTime = time.to24hours();
                widget.inputType.response = formatedTime;
                textEditingController.text = formatedTime;
                setState(() {});
                widget.updateData();
              }
            },
            validator: (value) {
              if ((value == null || value.isEmpty) &&
                  widget.inputType.requiredField == 1) {
                return widget.inputType.validationMessage;
              }

              return null;
            },
            decoration: InputDecoration(
              hintText: widget.inputType.note,
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              fillColor: Colors.white,
              focusColor: Theme.of(context).primaryColor,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: Theme.of(context).primaryColor, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: Theme.of(context).primaryColor, width: 1),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: Theme.of(context).primaryColor, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.error, width: 1),
              ),
              labelStyle: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
              labelText: widget.inputType.fieldLabel,
            ),
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
