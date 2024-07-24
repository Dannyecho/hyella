import 'package:hyella/models/initial_data/base_input_type.dart';

class TimeInputType extends BaseInputType {
  final String? name;
  final String? fieldLabel;
  final String? formField;
  final int? requiredField;
  final String? note;
  final String? min;
  final String? max;
  String? response;
  final String? validationMessage;

  TimeInputType(
      {this.name,
      this.fieldLabel,
      this.formField,
      this.requiredField,
      this.note,
      this.min,
      this.max,
      this.validationMessage,
      this.response});

  TimeInputType.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        fieldLabel = json['field_label'] as String?,
        formField = json['form_field'] as String?,
        requiredField = json['required_field'] as int?,
        note = json['note'] as String?,
        min = json['min'] as String?,
        response = '',
        max = json['max'] as String?,
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
        'response': response
      };
}
