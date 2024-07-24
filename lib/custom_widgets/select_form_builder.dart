import 'package:flutter/material.dart';
import 'package:hyella/models/initial_data/select_input_type.dart';

class SelectInputBuilder extends StatefulWidget {
  SelectInputType inputType;
  Function updateData;
  SelectInputBuilder(
      {super.key, required this.inputType, required this.updateData});

  @override
  State<SelectInputBuilder> createState() => _SelectInputBuilderState();
}

class _SelectInputBuilderState extends State<SelectInputBuilder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .9,
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              hintText: widget.inputType.note,
              labelText: widget.inputType.fieldLabel,
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              filled: true,
              fillColor: Colors.white,
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
            ),
            value: widget.inputType.response == ''
                ? null
                : widget.inputType.response,
            items: widget.inputType.formFieldOptions!.values.map((map) {
              return DropdownMenuItem(
                child: Text(map.toString()),
                value: map.toString(),
              );
            }).toList(),
            onChanged: (value) {
              widget.inputType.response = value;
              widget.updateData();
            },
            hint: Text(widget.inputType.fieldLabel ?? ""),
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
