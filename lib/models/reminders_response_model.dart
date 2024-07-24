class RemindersResponse {
  final int? type;
  final String? msg;
  final Data? data;

  RemindersResponse({
    this.type,
    this.msg,
    this.data,
  });

  RemindersResponse.fromJson(Map<String, dynamic> json)
      : type = json['type'] as int?,
        msg = json['msg'] as String?,
        data = (json['data'] as Map<String, dynamic>?) != null
            ? Data.fromJson(json['data'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() =>
      {'type': type, 'msg': msg, 'data': data?.toJson()};
}

class Data {
  final String? key;
  final List<Reminder>? data;

  Data({
    this.key,
    this.data,
  });

  Data.fromJson(Map<String, dynamic> json)
      : key = json['key'] as String?,
        data = (json['data'] as List?)
            ?.map((dynamic e) => Reminder.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() =>
      {'key': key, 'data': data?.map((e) => e.toJson()).toList()};
}

class Reminder {
  final String? key;
  final int? date;
  final String? info;
  final String? icon;
  final String? title;
  final String? subTitle;
  final String? message;
  final String? menuKey;
  final String? url;

  Reminder(
      {this.key,
      this.date,
      this.info,
      this.icon,
      this.title,
      this.subTitle,
      this.message,
      this.menuKey,
      this.url});

  Reminder.fromJson(Map<String, dynamic> json)
      : key = json['key'] as String?,
        date = json['date'] as int?,
        info = json['info'] as String?,
        icon = json['icon'] as String?,
        title = json['title'] as String?,
        subTitle = json['sub_title'] as String?,
        message = json['message'] as String?,
        url = json['url'] as String?,
        menuKey = json['menu_key'] as String?;

  Map<String, dynamic> toJson() => {
        'key': key,
        'date': date,
        'info': info,
        'icon': icon,
        'url': url,
        'title': title,
        'sub_title': subTitle,
        'message': message,
        'menu_key': menuKey
      };
}
