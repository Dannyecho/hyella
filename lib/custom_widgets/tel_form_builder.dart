
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hyella/models/initial_data/tel_input_type.dart';

class TelInputBuilder extends StatefulWidget {
  TelInputType textFormType;
  Function updateData;
  TelInputBuilder(
      {super.key, required this.textFormType, required this.updateData});

  @override
  State<TelInputBuilder> createState() => _TelInputBuilderState();
}

class _TelInputBuilderState extends State<TelInputBuilder> {
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
            initialValue: widget.textFormType.response,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              LengthLimitingTextInputFormatter(widget.textFormType.max),
            ],
            onChanged: (value) {
              widget.textFormType.response = value;
              widget.updateData();
            },
            validator: (value) {
              if (widget.textFormType.requiredField == 1) {
                if ((value == null || value.isEmpty)) {
                  return widget.textFormType.validationMessage;
                } else if (widget.textFormType.min != null &&
                    value.length < widget.textFormType.min!) {
                  return "Number should be longer than ${widget.textFormType.min} digits";
                }
              }

              return null;
            },
            decoration: InputDecoration(
              hintText: widget.textFormType.note,
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
              labelText: widget.textFormType.fieldLabel,
            ),
          ),
          Visibility(
            visible: widget.textFormType.note != null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5,
                ),
                Text(
                  widget.textFormType.note ?? "",
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
