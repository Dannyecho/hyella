import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:hyella/helper/utilities.dart';
import 'package:hyella/models/initial_data.dart';
import 'package:hyella/models/initial_data/calculated_input_type.dart';
import 'package:hyella/models/signup_result_model.dart';

class CalculatedFormBuilder extends StatefulWidget {
  CalculatedInputType inputType;
  Function updateData;
  CalculatedFormBuilder(
      {super.key, required this.inputType, required this.updateData});

  @override
  State<CalculatedFormBuilder> createState() => _CalculatedFormBuilderState();
}

class _CalculatedFormBuilderState extends State<CalculatedFormBuilder> {
  TextEditingController textEditingController = TextEditingController();
  List<String> suggestions = [];
  @override
  void initState() {
    super.initState();
    getSuggestions();
  }

  void getSuggestions() async {
    try {
      InitialData endPoints = GetIt.I<InitialData>();
      UserDetails userDetails = GetIt.I<UserDetails>();
      String cid = endPoints.client!.id!;
      String privateKey = endPoints.privateKey!;
      String pid = userDetails.user!.pid!;

      var response = await http.get(Uri.parse(widget.inputType.action! + "&"));

      var decodedBody = jsonDecode(response.body);

      if (Utilities.responseIsSuccessfull(response)) {
        var data = decodedBody['data'] as List;
        suggestions = data.map((e) => e.toString()).toList();
      }
    } on Exception {
      suggestions = ["Test"];
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
          TypeAheadField(
            controller: textEditingController,
            decorationBuilder: (context, child) {
              return TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  focusColor: Theme.of(context).primaryColor,
                  // hintText: widget.inputType.note,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 1),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 1),
                  ),
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.error, width: 1),
                  ),
                  contentPadding: EdgeInsets.all(8),
                  labelText: widget.inputType.fieldLabel,
                  hintStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              );
            },
            suggestionsCallback: (pattern) async {
              // get the doctor's list if the list is empty
              getSuggestions();
              return suggestions;
            },
            itemBuilder: (context, String suggestion) {
              return ListTile(
                title: Text(suggestion),
              );
            },
            onSelected: (String suggestion) {
              textEditingController.text = suggestion;
              widget.inputType.response = suggestion;
              setState(() {});
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
