import 'package:flutter/material.dart';
import 'package:hyella/models/initial_data/text_input_type.dart';

class TextInputBuilder extends StatefulWidget {
  TextFormType textFormType;
  Function updateData;
  TextInputBuilder(
      {super.key, required this.textFormType, required this.updateData});

  @override
  State<TextInputBuilder> createState() => _TextInputBuilderState();
}

class _TextInputBuilderState extends State<TextInputBuilder> {
  GlobalKey key = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .9,
      padding: EdgeInsets.symmetric(horizontal: 0),
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            initialValue: widget.textFormType.response,
            onChanged: (value) {
              widget.textFormType.response = value;
              widget.updateData();
            },
            validator: (value) {
              if ((value == null || value.isEmpty) &&
                  widget.textFormType.requiredField == 1) {
                return widget.textFormType.validationMessage!.isEmpty
                    ? "Field is required"
                    : widget.textFormType.validationMessage!;
              }

              return null;
            },
            decoration: InputDecoration(
              // hintText: widget.textFormType.note,
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              fillColor: Colors.white,
              filled: true,
              focusColor: Theme.of(context).primaryColor,
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
