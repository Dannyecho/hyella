import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hyella/models/initial_data/multi_select_input_type.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
// import 'package:multiselect/multiselect.dart';

class MultiSelectFormBuilder extends StatefulWidget {
  MultiSelectInputType inputType;
  Function updateData;
  MultiSelectFormBuilder(
      {super.key, required this.inputType, required this.updateData});

  @override
  State<MultiSelectFormBuilder> createState() => _MultiSelectFormBuilderState();
}

class _MultiSelectFormBuilderState extends State<MultiSelectFormBuilder> {
  @override
  void initState() {
    super.initState();
    if (widget.inputType.response != null) {
      widget.inputType.response!.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .9,
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DropDownMultiSelect(
          MultiSelectBottomSheet(
            initialValue: ["Select Value"],
            searchable: true,
            title: Text((widget.inputType.response!.isEmpty
                ? widget.inputType.fieldLabel!
                : "")),
            selectedColor: Theme.of(context).primaryColor,
            /* decoration: InputDecoration(
              labelText: ,
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
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
            ), */
            items: widget.inputType.formFieldOptions!.values
                .map((e) => MultiSelectItem(e, e.toString()))
                .toList(),
            /* selectedValues: (widget.inputType.response == null ||
                    widget.inputType.response!.contains("null"))
                ? []
                : widget.inputType.response!
                    .where((element) => element != 'null')
                    .toList(), */
            onSelectionChanged: (value) {
              if (value.length < widget.inputType.min!) {
                Fluttertoast.showToast(
                    msg:
                        "Please select at least ${widget.inputType.min} items");

                return;
              }

              if (value.length > widget.inputType.max!) {
                Fluttertoast.showToast(
                    msg: "Please select at most ${widget.inputType.min} items");

                return;
              }

              setState(() {
                widget.inputType.response = value.cast<String>();
              });

              widget.updateData();
            },
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
