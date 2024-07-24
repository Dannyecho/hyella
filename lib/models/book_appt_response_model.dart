class BookApptRespModel {
  final int? type;
  final String? msg;
  final Data? data;

  BookApptRespModel({
    this.type,
    this.msg,
    this.data,
  });

  BookApptRespModel.fromJson(Map<String, dynamic> json)
      : type = json['type'] as int?,
        msg = json['msg'] as String?,
        data = (json['data'] as Map<String, dynamic>?) != null
            ? Data.fromJson(json['data'] as Map<String, dynamic>)
            : null;
}

class Data {
  final String? url;
  final String? urlTitle;

  Data({this.url, this.urlTitle});

  Data.fromJson(Map<String, dynamic> json)
      : url = json['url'] as String?,
        urlTitle = json['url_title'] as String?;
}
