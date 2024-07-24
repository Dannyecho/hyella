class ServiceResponseModel {
  ServiceResponseModel({
    required this.type,
    required this.msg,
    required this.data,
  });
  late final int type;
  late final String msg;
  late final Data data;

  ServiceResponseModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    msg = json['msg'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['type'] = type;
    _data['msg'] = msg;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.key,
    required this.title,
    required this.callbackType,
    required this.url,
  });
  late final String key;
  late final String title;
  late final String callbackType;
  late final String url;
  late final String picture;

  Data.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    title = json['title'];
    picture = json['picture'];
    callbackType = json['callback_type'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['key'] = key;
    _data['title'] = title;
    _data['callback_type'] = callbackType;
    _data['url'] = url;
    return _data;
  }
}
