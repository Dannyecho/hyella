import 'package:hyella/models/initial_data/base_input_type.dart';

class CalculatedInputType extends BaseInputType {
  final String? name;
  final String? fieldLabel;
  final String? formField;
  final int? requiredField;
  final String? note;
  final int? min;
  final int? max;
  final String? action;
  String? response;
  final String? validationMessage;

  CalculatedInputType(
      {this.name,
      this.fieldLabel,
      this.formField,
      this.requiredField,
      this.note,
      this.min,
      this.max,
      this.action,
      this.validationMessage,
      this.response});

  CalculatedInputType.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        fieldLabel = json['field_label'] as String?,
        formField = json['form_field'] as String?,
        requiredField = json['required_field'] as int?,
        note = json['note'] as String?,
        min = json['min'] as int?,
        max = json['max'] as int?,
        response = "",
        action = json['action'] as String?,
        validationMessage = json['validation_message'] as String?;

  Map<String, dynamic> toJson() => {
        'validation_message': validationMessage,
        'name': name,
        'field_label': fieldLabel,
        'form_field': formField,
        'required_field': requiredField,
        'note': note,
        'min': min,
        'max': max,
        'action': action,
        'response': response
      };
}
