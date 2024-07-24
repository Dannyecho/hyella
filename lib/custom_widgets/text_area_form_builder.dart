import 'package:flutter/material.dart';
import 'package:hyella/models/initial_data/text_area_input_type.dart';

class TextAreaInputBuilder extends StatefulWidget {
  TextAreaInputType textFormType;
  Function updateData;
  TextAreaInputBuilder(
      {super.key, required this.textFormType, required this.updateData});

  @override
  State<TextAreaInputBuilder> createState() => _TextAreaInputBuilderState();
}

class _TextAreaInputBuilderState extends State<TextAreaInputBuilder> {
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
            maxLines: widget.textFormType.max,
            minLines: 1,
            onChanged: (value) {
              widget.textFormType.response = value;
              widget.updateData();
            },
            validator: (value) {
              if ((value == null || value.isEmpty) &&
                  widget.textFormType.requiredField == 1) {
                return widget.textFormType.validationMessage;
              }

              return null;
            },
            decoration: InputDecoration(
              hintText: widget.textFormType.note,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
              alignLabelWithHint: true,
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
