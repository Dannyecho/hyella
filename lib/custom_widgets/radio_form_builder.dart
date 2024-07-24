import 'package:flutter/material.dart';
import 'package:hyella/helper/styles.dart';
import 'package:hyella/models/initial_data/radio_input_type.dart';

class RadioInputBuilder extends StatefulWidget {
  final RadioInputType inputType;
  Function updateData;
  RadioInputBuilder(
      {super.key, required this.inputType, required this.updateData});

  @override
  State<RadioInputBuilder> createState() => _RadioInputBuilderState();
}

class _RadioInputBuilderState extends State<RadioInputBuilder> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.inputType.fieldLabel ?? "",
          style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).primaryColor,
              fontWeight: FWt.bold),
        ),
        SizedBox(
          height: 5,
        ),
        Column(
          children: widget.inputType.formFieldOptions!.values
              .where((element) => element != "")
              .map((map) {
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                widget.inputType.response = map.toString();
                setState(() {});
              },
              child: Row(
                children: [
                  SizedBox(
                    height: 30,
                    width: 20,
                    child: Radio(
                      activeColor: Theme.of(context).primaryColor,
                      value: map.toString(),
                      groupValue: widget.inputType.response,
                      onChanged: (value) {
                        widget.inputType.response = map.toString();
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(map.toString()),
                ],
              ),
            );
          }).toList(),
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
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
