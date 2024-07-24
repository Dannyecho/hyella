class ScheduleModel {
  final String? key;
  final String? picture;
  final String? title;
  final String? subTitle;
  final String? status;
  final String? date;
  final String? time;
  final String? specialtyKey;
  final String? locationId;
  final String? dependentId;
  final String? doctorId;
  final String? appointmentId;

  ScheduleModel({
    this.key,
    this.specialtyKey,
    this.picture,
    this.title,
    this.subTitle,
    this.status,
    this.date,
    this.time,
    this.dependentId,
    this.doctorId,
    this.appointmentId,
    this.locationId,
  });

  ScheduleModel.fromJson(Map<String, dynamic> json)
      : key = json['key'] as String?,
        picture = json['picture'] as String?,
        specialtyKey = json['specialty_key'] as String?,
        title = json['title'] as String?,
        subTitle = json['sub_title'] as String?,
        status = json['status'] as String?,
        appointmentId = json['appointment_id'] as String?,
        date = json['date'] as String?,
        doctorId = json['doctor_id'] as String?,
        locationId = json["location_id"] as String?,
        dependentId = json["dependent_id"] as String?,
        time = json['time'] as String?;

  Map<String, dynamic> toJson() => {
        'key': key,
        'picture': picture,
        'title': title,
        'sub_title': subTitle,
        'status': status,
        'date': date,
        'time': time
      };
}
