import 'package:hyella/models/initial_data.dart';
import 'package:hyella/models/initial_data/calculated_input_type.dart';
import 'package:hyella/models/initial_data/color_input_type.dart';
import 'package:hyella/models/initial_data/confirm_password_input_type.dart';
import 'package:hyella/models/initial_data/date_input_type.dart';
import 'package:hyella/models/initial_data/date_time_input_type.dart';
import 'package:hyella/models/initial_data/email_input_type.dart';
import 'package:hyella/models/initial_data/file_input_type.dart';
import 'package:hyella/models/initial_data/html_input_type.dart';
import 'package:hyella/models/initial_data/multi_select_input_type.dart';
import 'package:hyella/models/initial_data/number_input_type.dart';
import 'package:hyella/models/initial_data/password_input_type.dart';
import 'package:hyella/models/initial_data/picture_input_type.dart';
import 'package:hyella/models/initial_data/radio_input_type.dart';
import 'package:hyella/models/initial_data/select_input_type.dart';
import 'package:hyella/models/initial_data/tel_input_type.dart';
import 'package:hyella/models/initial_data/text_area_input_type.dart';
import 'package:hyella/models/initial_data/text_input_type.dart';
import 'package:hyella/models/initial_data/time_input_type.dart';

class PageFormData {
  final String? title;
  final String? subTitle;
  final String? action;
  final String? nwpReequest;
  final List<dynamic>? fields;

  PageFormData(
      {required this.action,
      required this.fields,
      required this.nwpReequest,
      required this.subTitle,
      required this.title});
  PageFormData.fromJson(Map<String, dynamic> json)
      : action = json['action'],
        nwpReequest = json['nwp_request'],
        subTitle = json['subtitle'],
        title = json['title'],
        fields = (json['fields'] as List?)?.map((dynamic e) {
          var data = e['form_field'];
          if (data == FormType.text.backendEquivalent) {
            return TextFormType.fromJson(e);
          } else if (data == FormType.select.backendEquivalent) {
            return SelectInputType.fromJson(e);
          } else if (data == FormType.confirm_password.backendEquivalent) {
            return ConfirmPasswordInputType.fromJson(e);
          } else if (data == FormType.multiSelect.backendEquivalent) {
            return MultiSelectInputType.fromJson(e);
          } else if (data == FormType.date5.backendEquivalent) {
            return DateInputType.fromJson(e);
          } else if (data == FormType.date5time.backendEquivalent) {
            return DateTimeInputType.fromJson(e);
          } else if (data == FormType.time.backendEquivalent) {
            return TimeInputType.fromJson(e);
          } else if (data == FormType.textarea.backendEquivalent) {
            return TextAreaInputType.fromJson(e);
          } else if (data == FormType.password.backendEquivalent) {
            return PasswordInputType.fromJson(e);
          } else if (data == FormType.tel.backendEquivalent) {
            return TelInputType.fromJson(e);
          } else if (data == FormType.email.backendEquivalent) {
            return EmailInputType.fromJson(e);
          } else if (data == FormType.decimal.backendEquivalent) {
            return NumberInputType.fromJson(e);
          } else if (data == FormType.number.backendEquivalent) {
            return NumberInputType.fromJson(e);
          } else if (data == FormType.calculated.backendEquivalent) {
            return CalculatedInputType.fromJson(e);
          } else if (data == FormType.file.backendEquivalent) {
            return FileInputType.fromJson(e);
          } else if (data == FormType.picture.backendEquivalent) {
            return PictureInputType.fromJson(e);
          } else if (data == FormType.radio.backendEquivalent) {
            return RadioInputType.fromJson(e);
          } else if (data == FormType.checkbox.backendEquivalent) {
            return SelectInputType.fromJson(e);
          } else if (data == FormType.html.backendEquivalent) {
            return HtmlInputType.fromJson(e);
          } else if (data == FormType.color.backendEquivalent) {
            return ColorInputType.fromJson(e);
          } else if (data == FormType.oldPassword.backendEquivalent) {
            return PasswordInputType.fromJson(e);
          }

          return e;
        }).toList();

  Map<String, dynamic> toJson() => {
        'action': action,
        'nwp_request': nwpReequest,
        'subtitle': subTitle,
        'title': title,
        'fields': fields?.map(
          (e) {
            if (e is Map) {
              return e;
            } else {
              return e.toJson();
            }
          },
        ).toList()
      };
}

extension on FormType {
  String get backendEquivalent {
    switch (this) {
      case FormType.date5:
        return "date-5";
      case FormType.text:
        return "text";
      case FormType.select:
        return "select";
      case FormType.multiSelect:
        return "multi-select";
      case FormType.date5time:
        return "date-5time";
      case FormType.time:
        return "time";
      case FormType.textarea:
        return "textarea";
      case FormType.password:
        return "password";
      case FormType.tel:
        return "tel";
      case FormType.email:
        return "email";
      case FormType.decimal:
        return "decimal";
      case FormType.number:
        return "number";
      case FormType.calculated:
        return "calculated";
      case FormType.file:
        return "file";
      case FormType.picture:
        return "picture";
      case FormType.radio:
        return "radio";
      case FormType.checkbox:
        return "checkbox";
      case FormType.html:
        return "html";
      case FormType.color:
        return "color";
      case FormType.oldPassword:
        return "old-password";
      case FormType.confirm_password:
        return 'confirm_password';
    }
  }
}
