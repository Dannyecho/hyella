import 'package:flutter/material.dart';
import 'package:hyella/models/initial_data/date_input_type.dart';
import 'package:intl/intl.dart';

class DateInputBuilder extends StatefulWidget {
  DateInputType inputType;
  Function updateData;
  DateInputBuilder(
      {super.key, required this.inputType, required this.updateData});

  @override
  State<DateInputBuilder> createState() => _DateInputBuilderState();
}

class _DateInputBuilderState extends State<DateInputBuilder> {
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
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.none,
            controller: textEditingController,
            onTap: () async {
              var date = await showDatePicker(
                context: context,
                initialEntryMode: DatePickerEntryMode.calendarOnly,
                initialDate: DateTime.now(),
                firstDate: widget.inputType.min == null
                    ? DateTime.now().subtract(Duration(days: 600000))
                    : DateTime.parse(widget.inputType.min!),
                lastDate: widget.inputType.max == null
                    ? DateTime.now().add(Duration(days: 600000))
                    : DateTime.parse(widget.inputType.max!),
              );

              if (date != null) {
                var formatedDate = DateFormat("yyyy-MM-dd").format(date);
                widget.inputType.response = formatedDate;
                textEditingController.text = formatedDate;
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
