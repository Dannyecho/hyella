class AvailableTimeSlotRes {
  final int? type;
  final String? msg;
  final AvailTimeSlotData? data;

  AvailableTimeSlotRes({
    this.type,
    this.msg,
    this.data,
  });

  AvailableTimeSlotRes.fromJson(Map<String, dynamic> json)
      : type = json['type'] as int?,
        msg = json['msg'] as String?,
        data = (json['data'] as Map<String, dynamic>?) != null
            ? AvailTimeSlotData.fromJson(json['data'] as Map<String, dynamic>)
            : null;
}

class AvailTimeSlotData {
  final String? fieldLabel;
  final Map<String, dynamic>? listOption;
  final String? instruction;

  AvailTimeSlotData({
    this.fieldLabel,
    this.listOption,
    this.instruction
  });

  AvailTimeSlotData.fromJson(Map<String, dynamic> json)
      : fieldLabel = json['field_label'] as String?,
        listOption = (json['list_option'] as Map<String, dynamic>?),
        instruction = json['instruction'] as String?;
}

class TimeSlotModel {
  final String id;
  final String time;
  bool selected;

  TimeSlotModel({required this.time, required this.id, this.selected = false});
}
