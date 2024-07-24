class WebViews {
  final Chat? chat;
  final ChatMsg? chatMsg;
  final AppBook? appBook;
  final Services? services;
  final More? more;
  final Profile? profile;
  final Schedule? schedule;
  final Home? home;
  final VideoChat? videoChat;

  WebViews(
      {this.chat,
      this.chatMsg,
      this.appBook,
      this.services,
      this.more,
      this.profile,
      this.schedule,
      this.home,
      this.videoChat});

  WebViews.fromJson(Map<String, dynamic> json)
      : chat = (json['chat'] as Map<String, dynamic>?) != null
            ? Chat.fromJson(json['chat'] as Map<String, dynamic>)
            : null,
        videoChat = (json['video_chat'] as Map<String, dynamic>?) != null
            ? VideoChat.fromJson(json['video_chat'] as Map<String, dynamic>)
            : null,
        chatMsg = (json['chat_msg'] as Map<String, dynamic>?) != null
            ? ChatMsg.fromJson(json['chat_msg'] as Map<String, dynamic>)
            : null,
        appBook = (json['app_book'] as Map<String, dynamic>?) != null
            ? AppBook.fromJson(json['app_book'] as Map<String, dynamic>)
            : null,
        services = (json['services'] as Map<String, dynamic>?) != null
            ? Services.fromJson(json['services'] as Map<String, dynamic>)
            : null,
        more = (json['more'] as Map<String, dynamic>?) != null
            ? More.fromJson(json['more'] as Map<String, dynamic>)
            : null,
        profile = (json['profile'] as Map<String, dynamic>?) != null
            ? Profile.fromJson(json['profile'] as Map<String, dynamic>)
            : null,
        schedule = (json['schedule'] as Map<String, dynamic>?) != null
            ? Schedule.fromJson(json['schedule'] as Map<String, dynamic>)
            : null,
        home = (json['home'] as Map<String, dynamic>?) != null
            ? Home.fromJson(json['home'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {
        'chat': chat?.toJson(),
        'chat_msg': chatMsg?.toJson(),
        'app_book': appBook?.toJson(),
        'services': services?.toJson(),
        'more': more?.toJson(),
        'profile': profile?.toJson(),
        'schedule': schedule?.toJson(),
        'home': home?.toJson()
      };
}

class Chat {
  final int? webview;
  final String? endpoint;
  final Params? params;

  Chat({
    this.webview,
    this.endpoint,
    this.params,
  });

  Chat.fromJson(Map<String, dynamic> json)
      : webview = json['webview'] as int?,
        endpoint = json['endpoint'] as String?,
        params = (json['params'] as Map<String, dynamic>?) != null
            ? Params.fromJson(json['params'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() =>
      {'webview': webview, 'endpoint': endpoint, 'params': params?.toJson()};
}

class Params {
  final String? token;
  final String? nwpWebiew;
  final String? pid;
  final String? hash;

  Params({
    this.token,
    this.nwpWebiew,
    this.pid,
    this.hash,
  });

  Params.fromJson(Map<String, dynamic> json)
      : token = json['token'] as String?,
        nwpWebiew = json['nwp_webiew'] as String?,
        pid = json['pid'] as String?,
        hash = json['hash'] as String?;

  Map<String, dynamic> toJson() =>
      {'token': token, 'nwp_webiew': nwpWebiew, 'pid': pid, 'hash': hash};
}

class ChatMsg {
  final int? webview;
  final String? endpoint;
  final Params? params;

  ChatMsg({
    this.webview,
    this.endpoint,
    this.params,
  });

  ChatMsg.fromJson(Map<String, dynamic> json)
      : webview = json['webview'] as int?,
        endpoint = json['endpoint'] as String?,
        params = (json['params'] as Map<String, dynamic>?) != null
            ? Params.fromJson(json['params'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() =>
      {'webview': webview, 'endpoint': endpoint, 'params': params?.toJson()};
}

class AppBook {
  final int? webview;
  final String? endpoint;
  final Params? params;

  AppBook({
    this.webview,
    this.endpoint,
    this.params,
  });

  AppBook.fromJson(Map<String, dynamic> json)
      : webview = json['webview'] as int?,
        endpoint = json['endpoint'] as String?,
        params = (json['params'] as Map<String, dynamic>?) != null
            ? Params.fromJson(json['params'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() =>
      {'webview': webview, 'endpoint': endpoint, 'params': params?.toJson()};
}

class Services {
  final int? webview;
  final String? endpoint;
  final Params? params;

  Services({
    this.webview,
    this.endpoint,
    this.params,
  });

  Services.fromJson(Map<String, dynamic> json)
      : webview = json['webview'] as int?,
        endpoint = json['endpoint'] as String?,
        params = (json['params'] as Map<String, dynamic>?) != null
            ? Params.fromJson(json['params'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() =>
      {'webview': webview, 'endpoint': endpoint, 'params': params?.toJson()};
}

class More {
  final int? webview;
  final String? endpoint;
  final Params? params;

  More({
    this.webview,
    this.endpoint,
    this.params,
  });

  More.fromJson(Map<String, dynamic> json)
      : webview = json['webview'] as int?,
        endpoint = json['endpoint'] as String?,
        params = (json['params'] as Map<String, dynamic>?) != null
            ? Params.fromJson(json['params'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() =>
      {'webview': webview, 'endpoint': endpoint, 'params': params?.toJson()};
}

class Profile {
  final int? webview;
  final String? endpoint;
  final Params? params;

  Profile({
    this.webview,
    this.endpoint,
    this.params,
  });

  Profile.fromJson(Map<String, dynamic> json)
      : webview = json['webview'] as int?,
        endpoint = json['endpoint'] as String?,
        params = (json['params'] as Map<String, dynamic>?) != null
            ? Params.fromJson(json['params'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() =>
      {'webview': webview, 'endpoint': endpoint, 'params': params?.toJson()};
}

class Schedule {
  final int? webview;
  final String? endpoint;
  final Params? params;

  Schedule({
    this.webview,
    this.endpoint,
    this.params,
  });

  Schedule.fromJson(Map<String, dynamic> json)
      : webview = json['webview'] as int?,
        endpoint = json['endpoint'] as String?,
        params = (json['params'] as Map<String, dynamic>?) != null
            ? Params.fromJson(json['params'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() =>
      {'webview': webview, 'endpoint': endpoint, 'params': params?.toJson()};
}

class Home {
  final int? webview;
  final String? endpoint;
  final Params? params;

  Home({
    this.webview,
    this.endpoint,
    this.params,
  });

  Home.fromJson(Map<String, dynamic> json)
      : webview = json['webview'] as int?,
        endpoint = json['endpoint'] as String?,
        params = (json['params'] as Map<String, dynamic>?) != null
            ? Params.fromJson(json['params'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() =>
      {'webview': webview, 'endpoint': endpoint, 'params': params?.toJson()};
}

class VideoChat {
  final int? webview;
  final String? endpoint;
  final Params? params;

  VideoChat({
    this.webview,
    this.endpoint,
    this.params,
  });

  VideoChat.fromJson(Map<String, dynamic> json)
      : webview = json['webview'] as int?,
        endpoint = json['endpoint'] as String?,
        params = (json['params'] as Map<String, dynamic>?) != null
            ? Params.fromJson(json['params'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() =>
      {'webview': webview, 'endpoint': endpoint, 'params': params?.toJson()};
}
