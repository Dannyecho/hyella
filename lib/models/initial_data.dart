import 'package:hyella/models/initial_data/signup_data.dart';

enum FormType {
  text,
  select,
  multiSelect,
  date5,
  date5time,
  time,
  textarea,
  password,
  tel,
  email,
  decimal,
  number,
  calculated,
  file,
  picture,
  radio,
  checkbox,
  html,
  color,
  oldPassword,
  confirm_password
}

class InitialData {
  final String? endPoint1;
  final String? endPoint2;
  final String? endPoint3;
  final String? privateKey;
  final Client? client;
  final String? agoraAppId;
  final FlutterPayment? flutterPayment;
  final PaystackPayment? paystackPayment;
  final List<PageFormData>? signupForm;
  // final List<dynamic>? signinForm;
  final PageFormData? profileUpdateForm;
  // final List<dynamic>? resetPasswordForm;

  InitialData(
      {this.endPoint1,
      this.endPoint2,
      this.endPoint3,
      this.privateKey,
      this.client,
      this.flutterPayment,
      this.paystackPayment,
      this.agoraAppId,
      this.profileUpdateForm,
      this.signupForm});

  InitialData.fromJson(Map<String, dynamic> json)
      : endPoint1 = json['end_point1'] as String?,
        endPoint2 = json['end_point2'] as String?,
        endPoint3 = json['end_point3'] as String?,
        privateKey = json['private_key'] as String?,
        agoraAppId = json['agora_api_key'] as String?,
        signupForm = (json['forms']['sign_up'] as List?) != null
            ? (json['forms']['sign_up'] as List)
                .map((e) => PageFormData.fromJson(e as Map<String, dynamic>))
                .toList()
            : null,
        profileUpdateForm =
            (json['forms']['profile_update'] as Map<String, dynamic>?) != null
                ? PageFormData.fromJson(
                    json['forms']['profile_update'] as Map<String, dynamic>)
                : null,
        client = (json['client'] as Map<String, dynamic>?) != null
            ? Client.fromJson(json['client'] as Map<String, dynamic>)
            : null,
        flutterPayment =
            (json['flutter_payment'] as Map<String, dynamic>?) != null
                ? FlutterPayment.fromJson(
                    json['flutter_payment'] as Map<String, dynamic>)
                : null,
        paystackPayment =
            (json['paystack_payment'] as Map<String, dynamic>?) != null
                ? PaystackPayment.fromJson(
                    json['paystack_payment'] as Map<String, dynamic>)
                : null;

  Map<String, dynamic> toJson() => {
        'end_point1': endPoint1,
        'end_point2': endPoint2,
        'end_point3': endPoint3,
        'private_key': privateKey,
        'client': client?.toJson(),
        'agora_api_key': agoraAppId,
        'flutter_payment': flutterPayment?.toJson(),
        'paystack_payment': paystackPayment?.toJson(),
        'forms': {
          'sign_up': signupForm?.map((e) => e.toJson()).toList(),
          'profile_update': profileUpdateForm?.toJson()
        },
      };
}

class Client {
  final String? id;
  final String? name;
  final String? tagline;
  final String? logo;
  final int? socialLogin;
  final String? color1;
  final String? color2;
  final String? color3;
  final String? color4;
  final String? color5;
  final String? color6;

  Client({
    this.id,
    this.name,
    this.tagline,
    this.logo,
    this.socialLogin,
    this.color1,
    this.color2,
    this.color3,
    this.color4,
    this.color5,
    this.color6,
  });

  Client.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        name = json['name'] as String?,
        tagline = json['tagline'] as String?,
        logo = json['logo'] as String?,
        socialLogin = json['social_login'] as int?,
        color1 = json['color1'] as String?,
        color2 = json['color2'] as String?,
        color3 = json['color3'] as String?,
        color4 = json['color4'] as String?,
        color5 = json['color5'] as String?,
        color6 = json['color6'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'tagline': tagline,
        'logo': logo,
        'social_login': socialLogin,
        'color1': color1,
        'color2': color2,
        'color3': color3,
        'color4': color4,
        'color5': color5,
        'color6': color6
      };
}

class FlutterPayment {
  final String? gateway;
  final String? publicKey;
  final String? encryptionKey;

  FlutterPayment({
    this.gateway,
    this.publicKey,
    this.encryptionKey,
  });

  FlutterPayment.fromJson(Map<String, dynamic> json)
      : gateway = json['gateway'] as String?,
        publicKey = json['public_key'] as String?,
        encryptionKey = json['encryption_key'] as String?;

  Map<String, dynamic> toJson() => {
        'gateway': gateway,
        'public_key': publicKey,
        'encryption_key': encryptionKey
      };
}

class PaystackPayment {
  final String? gateway;
  final String? publicKey;
  final String? encryptionKey;

  PaystackPayment({
    this.gateway,
    this.publicKey,
    this.encryptionKey,
  });

  PaystackPayment.fromJson(Map<String, dynamic> json)
      : gateway = json['gateway'] as String?,
        publicKey = json['public_key'] as String?,
        encryptionKey = json['encryption_key'] as String?;

  Map<String, dynamic> toJson() => {
        'gateway': gateway,
        'public_key': publicKey,
        'encryption_key': encryptionKey
      };
}
