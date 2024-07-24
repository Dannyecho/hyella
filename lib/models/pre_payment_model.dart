class PrePaymentResponse {
  final int? type;
  final String? msg;
  final PrePaymentData? data;

  PrePaymentResponse({
    this.type,
    this.msg,
    this.data,
  });

  PrePaymentResponse.fromJson(Map<String, dynamic> json)
      : type = json['type'] as int?,
        msg = json['msg'] as String?,
        data = (json['data'] as Map<String, dynamic>?) != null
            ? PrePaymentData.fromJson(json['data'] as Map<String, dynamic>)
            : null;
}

class PrePaymentData {
  final String? fieldLabel;
  final String? instruction;
  final Map<String, dynamic>? tableRow;
  final String? appointmentRef;
  final int? paymentDue;

  PrePaymentData(
      {this.fieldLabel,
      this.instruction,
      this.tableRow,
      this.appointmentRef,
      this.paymentDue});

  PrePaymentData.fromJson(Map<String, dynamic> json)
      : fieldLabel = json['field_label'] as String?,
        instruction = json['instruction'] as String?,
        paymentDue = json['total_amount_due'] as int?,
        tableRow = json['table_row'] as Map<String, dynamic>?,
        appointmentRef = json['appointment_ref'] as String?;
}

class TableData {
  final String? title;
  final String? value;

  TableData({this.title, this.value});
}
