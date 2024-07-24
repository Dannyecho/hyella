class EmrResult {
  EmrResult({
    required this.type,
    required this.msg,
    required this.data,
  });
  late final int type;
  late final String msg;
  late final Data data;
  
  EmrResult.fromJson(Map<String, dynamic> json){
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
    required this.title,
    required this.callbackType,
    required this.params,
  });
  late final String title;
  late final String callbackType;
  late final Params params;
  
  Data.fromJson(Map<String, dynamic> json){
    title = json['title'];
    callbackType = json['callback_type'];
    params = Params.fromJson(json['params']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['callback_type'] = callbackType;
    _data['params'] = params.toJson();
    return _data;
  }
}

class Params {
  Params({
    required this.id,
    required this.subTitle,
    required this.info,
    required this.html,
    required this.buttonCaption,
    required this.action,
  });
  late final String id;
  late final String subTitle;
  late final String info;
  late final String html;
  late final String buttonCaption;
  late final String action;
  
  Params.fromJson(Map<String, dynamic> json){
    id = json['id'];
    subTitle = json['sub_title'];
    info = json['info'];
    html = json['html'];
    buttonCaption = json['button_caption'];
    action = json['action'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['sub_title'] = subTitle;
    _data['info'] = info;
    _data['html'] = html;
    _data['button_caption'] = buttonCaption;
    _data['action'] = action;
    return _data;
  }
}