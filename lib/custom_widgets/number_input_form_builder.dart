
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hyella/models/initial_data/number_input_type.dart';

class NumberInputBuilder extends StatefulWidget {
  NumberInputType inputType;
  Function updateData;
  NumberInputBuilder(
      {super.key, required this.inputType, required this.updateData});

  @override
  State<NumberInputBuilder> createState() => _NumberInputBuilderState();
}

class _NumberInputBuilderState extends State<NumberInputBuilder> {
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
            initialValue: widget.inputType.response,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(widget.inputType.max),
            ],
            onChanged: (value) {
              widget.inputType.response = value;
              widget.updateData();
            },
            validator: (value) {
              if (widget.inputType.requiredField == 1) {
                if ((value == null || value.isEmpty)) {
                  return widget.inputType.validationMessage;
                } else if (widget.inputType.min != null &&
                    value.length < widget.inputType.min!) {
                  return "Number should be longer than ${widget.inputType.min} digits";
                }
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
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.error, width: 1),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: Theme.of(context).primaryColor, width: 1),
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
