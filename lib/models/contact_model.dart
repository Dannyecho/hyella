class ContactModel {
  final String? receiverId;
  final String? channelName;
  final String? key;
  final String? picture;
  final String? title;
  final String? subTitle;
  final String? fcmToken;
   int? unreadMessages;
  final String? lastMessage;

  ContactModel({
    this.receiverId,
    this.channelName,
    this.key,
    this.picture,
    this.title,
    this.subTitle,
    this.fcmToken,
    this.unreadMessages,
    this.lastMessage,
  });

  ContactModel.fromJson(Map<String, dynamic> json)
    : receiverId = json['receiver_id'] as String?,
      channelName = json['channel_name'] as String?,
      key = json['key'] as String?,
      picture = json['picture'] as String?,
      title = json['title'] as String?,
      subTitle = json['sub_title'] as String?,
      fcmToken = json['fcm_token'] as String?,
      unreadMessages = json['unread_messages'] as int?,
      lastMessage = json['last_message'] as String?;

  Map<String, dynamic> toJson() => {
    'receiver_id' : receiverId,
    'channel_name' : channelName,
    'key' : key,
    'picture' : picture,
    'title' : title,
    'sub_title' : subTitle,
    'fcm_token' : fcmToken,
    'unread_messages' : unreadMessages,
    'last_message' : lastMessage
  };
}