class UploadFIleResponse {
  final int? type;
  final String? msg;
  final Data? data;

  UploadFIleResponse({
    this.type,
    this.msg,
    this.data,
  });

  UploadFIleResponse.fromJson(Map<String, dynamic> json)
    : type = json['type'] as int?,
      msg = json['msg'] as String?,
      data = (json['data'] as Map<String,dynamic>?) != null ? Data.fromJson(json['data'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'type' : type,
    'msg' : msg,
    'data' : data?.toJson()
  };
}

class Data {
  final String? attachmentName;
  final String? attachmentUrl;
  final String? errorMsg;

  Data({
    this.attachmentName,
    this.attachmentUrl,
    this.errorMsg,
  });

  Data.fromJson(Map<String, dynamic> json)
    : attachmentName = json['attachment_name'] as String?,
      attachmentUrl = json['attachment_url'] as String?,
      errorMsg = json['error_msg'] as String?;

  Map<String, dynamic> toJson() => {
    'attachment_name' : attachmentName,
    'attachment_url' : attachmentUrl,
    'error_msg' : errorMsg
  };
}