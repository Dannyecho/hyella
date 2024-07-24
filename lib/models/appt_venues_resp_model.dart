class AppLocationResponse {
  final int? type;
  final String? msg;
  final ApptLocationData? data;

  AppLocationResponse({
    this.type,
    this.msg,
    this.data,
  });

  AppLocationResponse.fromJson(Map<String, dynamic> json)
      : type = json['type'] as int?,
        msg = json['msg'] as String?,
        data = (json['data'] as Map<String, dynamic>?) != null
            ? ApptLocationData.fromJson(json['data'] as Map<String, dynamic>)
            : null;
}

class ApptLocationData {
  final String? fieldLabel;
  final Map<String, dynamic>? listOption;

  ApptLocationData({
    this.fieldLabel,
    this.listOption,
  });

  ApptLocationData.fromJson(Map<String, dynamic> json)
      : fieldLabel = json['field_label'] as String?,
        listOption = (json['list_option'] as Map<String, dynamic>?);
}

class VenueModel {
  final String id;
  final String venue;
  bool selected;

  VenueModel({required this.venue, required this.id, this.selected = false});
}
