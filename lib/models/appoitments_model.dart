class AppointmentModel {
  final String? key;
  final String? picture;
  final String? title;
  final String? subTitle;
  final String? status;
  final String? date;
  final String? time;
  final String? channelName;
  final String? receiverId;

  AppointmentModel(
      {this.key,
      this.picture,
      this.title,
      this.subTitle,
      this.status,
      this.date,
      this.receiverId,
      this.time,
      this.channelName});

  AppointmentModel.fromJson(Map<String, dynamic> json)
      : key = json['key'] as String?,
        picture = json['picture'] as String?,
        title = json['title'] as String?,
        subTitle = json['sub_title'] as String?,
        status = json['status'] as String?,
        date = json['date'] as String?,
        channelName = json['channel_name'] as String?,
        receiverId = json['receiver_id'] as String?,
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
