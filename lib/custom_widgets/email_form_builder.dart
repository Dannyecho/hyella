import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:hyella/models/initial_data/email_input_type.dart';

class EmailInputBuilder extends StatefulWidget {
  EmailInputType textFormType;
  Function updateData;
  EmailInputBuilder(
      {super.key, required this.textFormType, required this.updateData});

  @override
  State<EmailInputBuilder> createState() => _EmailInputBuilderState();
}

class _EmailInputBuilderState extends State<EmailInputBuilder> {
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
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              widget.textFormType.response = value;
              widget.updateData();
            },
            validator: (value) {
              if ((value == null || value.isEmpty) &&
                  widget.textFormType.requiredField == 1) {
                return widget.textFormType.validationMessage;
              } else if (!EmailValidator.validate(value!)) {
                return "Input a valid email";
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
