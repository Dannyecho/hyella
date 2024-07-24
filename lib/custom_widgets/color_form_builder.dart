import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hyella/models/initial_data/color_input_type.dart';

class ColorFormBuilder extends StatefulWidget {
  ColorInputType inputType;
  Function updateData;
  ColorFormBuilder(
      {super.key, required this.inputType, required this.updateData});

  @override
  State<ColorFormBuilder> createState() => _ColorFormBuilderState();
}

class _ColorFormBuilderState extends State<ColorFormBuilder> {
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Colors.transparent;

  void changeColor(Color color) {
    widget.inputType.response = color.value.toRadixString(16);
    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(widget.inputType.fieldLabel!),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: pickerColor,
                onColorChanged: changeColor,
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Select Color'),
                onPressed: () {
                  setState(() => currentColor = pickerColor);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * .9,
            margin: EdgeInsets.only(bottom: 20),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: Theme.of(context).primaryColor, width: 1),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: widget.inputType.response != null &&
                          widget.inputType.response!.isNotEmpty,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: currentColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      widget.inputType.response == null ||
                              widget.inputType.response!.isEmpty
                          ? widget.inputType.fieldLabel!
                          : widget.inputType.response!,
                    ),
                  ],
                ),
              ],
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
