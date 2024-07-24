import 'package:flutter/material.dart';
import 'package:hyella/models/initial_data/confirm_password_input_type.dart';

class ValidatePasswordInputBuilder extends StatefulWidget {
  ConfirmPasswordInputType inputType;
  Function updateData;
  String password;
  ValidatePasswordInputBuilder(
      {super.key,
      required this.inputType,
      required this.updateData,
      required this.password});

  @override
  State<ValidatePasswordInputBuilder> createState() =>
      _ValidatePasswordInputBuilderState();
}

class _ValidatePasswordInputBuilderState
    extends State<ValidatePasswordInputBuilder> {
  bool obscureText = true;
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
            initialValue: widget.inputType.response,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            obscureText: obscureText,
            onChanged: (value) {
              widget.inputType.response = value;
              widget.updateData();
            },
            validator: (value) {
              if ((value == null || value.isEmpty) &&
                  widget.inputType.requiredField == 1) {
                return "Password is required";
              } else if (value != widget.password) {
                return "Password does not match";
              }

              return null;
            },
            decoration: InputDecoration(
              hintText: widget.inputType.note,
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              fillColor: Colors.white,
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
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
                child: Icon(Icons.lock_outlined),
              ),
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
