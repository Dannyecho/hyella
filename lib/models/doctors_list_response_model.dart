class DoctorListResponse {
  final int? type;
  final String? msg;
  final DoctorListData? data;

  DoctorListResponse({
    this.type,
    this.msg,
    this.data,
  });

  DoctorListResponse.fromJson(Map<String, dynamic> json)
      : type = json['type'] as int?,
        msg = json['msg'] as String?,
        data = (json['data'] as Map<String, dynamic>?) != null
            ? DoctorListData.fromJson(json['data'] as Map<String, dynamic>)
            : null;
}

class DoctorListData {
  final String? fieldLabel;
  final Map<String, dynamic>? doctors;
  final String? dependentFieldLabel;
  final DependentListOption? dependentListOption;

  DoctorListData({
    this.fieldLabel,
    this.doctors,
    this.dependentFieldLabel,
    this.dependentListOption,
  });

  DoctorListData.fromJson(Map<String, dynamic> json)
      : fieldLabel = json['field_label'] as String?,
        doctors = json['list_option'] as Map<String, dynamic>?,
        dependentFieldLabel = json['dependent_field_label'] as String?,
        dependentListOption =
            (json['dependent_list_option'] as Map<String, dynamic>?) != null
                ? DependentListOption.fromJson(
                    json['dependent_list_option'] as Map<String, dynamic>)
                : null;
}

class DoctorModel {
  final String id;
  final String doctorName;

  DoctorModel({required this.doctorName, required this.id});
}

class DependentListOption {
  final String? ed120;
  final String? ed121;

  DependentListOption({
    this.ed120,
    this.ed121,
  });

  DependentListOption.fromJson(Map<String, dynamic> json)
      : ed120 = json['ed120'] as String?,
        ed121 = json['ed121'] as String?;

  Map<String, dynamic> toJson() => {'ed120': ed120, 'ed121': ed121};
}
