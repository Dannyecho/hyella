import 'package:hyella/models/webviews.dart';

class SignUpResponse {
  final int? type;
  final String? msg;
  final UserDetails? data;

  SignUpResponse({
    this.type,
    this.msg,
    this.data,
  });

  SignUpResponse.fromJson(Map<String, dynamic> json)
      : type = json['type'] as int?,
        msg = json['msg'] as String?,
        data = (json['data'] as Map<String, dynamic>?) != null
            ? UserDetails.fromJson(json['data'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() =>
      {'type': type, 'msg': msg, 'data': data?.toJson()};
}

class UserDetails {
  final String? sessionId;
  final User? user;
  final String? fundWalletUrl;
  final List<dynamic>? emr;
  final Menu? menu;
  final List<dynamic>? notice;
  final List<dynamic>? trends;
  final AppChart? appChart;
  final WebViews? webViews;

  UserDetails(
      {this.sessionId,
      this.user,
      this.emr,
      this.fundWalletUrl,
      this.menu,
      this.notice,
      this.appChart,
      this.trends,
      this.webViews});

  UserDetails.fromJson(Map<String, dynamic> json)
      : sessionId = json['session_id'] as String?,
        fundWalletUrl = json['url'] as String?,
        user = (json['user'] as Map<String, dynamic>?) != null
            ? User.fromJson(json['user'] as Map<String, dynamic>)
            : null,
        webViews = (json['web_views'] as Map<String, dynamic>?) != null
            ? WebViews.fromJson(json['web_views'] as Map<String, dynamic>)
            : null,
        appChart = (json['app_chart'] as Map<String, dynamic>?) != null
            ? AppChart.fromJson(json['app_chart'] as Map<String, dynamic>)
            : null,
        emr = json['emr'] as List?,
        menu = (json['menu'] as Map<String, dynamic>?) != null
            ? Menu.fromJson(json['menu'] as Map<String, dynamic>)
            : null,
        notice = json['notice'] as List?,
        trends = json['trends'] as List?;

  Map<String, dynamic> toJson() => {
        'session_id': sessionId,
        'user': user?.toJson(),
        'emr': emr,
        'menu': menu?.toJson(),
        'notice': notice,
        'trends': trends,
        'app_chart': appChart?.toJson(),
        'url': fundWalletUrl,
        'web_views': webViews?.toJson()
      };
}

class User {
  final String? pid;
  final int? hasFamily;
  final int? isStaff;
  final int? isPatient;
  final int? isFirstUse;
  final int? isVerified;
  final String? careGiver;
  final String? patientType;
  final String? emrNumber;
  final String? fullName;
  final String? userNameSubtitle;
  final String? initial;
  final String? phone;
  final String? email;
  final String? birthDay;
  final String? dp;
  final String? accBalance;
  final String? accBalanceSubtitle;
  final String? bookAppointment;
  final String? bookAppointmentSubtitle;
  final String? religion;
  final String? address;
  final String? nokName;
  final String? nokPhone;
  final String? nokEmail;
  final String? nokAddress;
  final String? allergy;

  User({
    this.pid,
    this.hasFamily,
    this.isStaff,
    this.isPatient,
    this.isFirstUse,
    this.isVerified,
    this.careGiver,
    this.patientType,
    this.emrNumber,
    this.fullName,
    this.userNameSubtitle,
    this.initial,
    this.phone,
    this.email,
    this.birthDay,
    this.dp,
    this.accBalance,
    this.accBalanceSubtitle,
    this.bookAppointment,
    this.bookAppointmentSubtitle,
    this.religion,
    this.address,
    this.nokName,
    this.nokPhone,
    this.nokEmail,
    this.nokAddress,
    this.allergy,
  });

  User.fromJson(Map<String, dynamic> json)
      : pid = json['pid'] as String?,
        hasFamily = json['has_family'] as int?,
        isStaff = json['is_staff'] as int?,
        isPatient = json['is_patient'] as int?,
        isFirstUse = json['is_first_use'] as int?,
        isVerified = json['is_verified'] as int?,
        careGiver = json['care_giver'] as String?,
        patientType = json['patient_type'] as String?,
        emrNumber = json['emr_number'] as String?,
        fullName = json['full_name'] as String?,
        userNameSubtitle = json['user_name_subtitle'] as String?,
        initial = json['initial'] as String?,
        phone = json['phone'] as String?,
        email = json['email'] as String?,
        birthDay = json['birth_day'] as String?,
        dp = json['dp'] as String?,
        accBalance = json['acc_balance'] as String?,
        accBalanceSubtitle = json['acc_balance_subtitle'] as String?,
        bookAppointment = json['book_appointment'] as String?,
        bookAppointmentSubtitle = json['book_appointment_subtitle'] as String?,
        religion = json['religion'] as String?,
        address = json['address'] as String?,
        nokName = json['nok_name'] as String?,
        nokPhone = json['nok_phone'] as String?,
        nokEmail = json['nok_email'] as String?,
        nokAddress = json['nok_address'] as String?,
        allergy = json['allergy'] as String?;

  Map<String, dynamic> toJson() => {
        'pid': pid,
        'has_family': hasFamily,
        'is_staff': isStaff,
        'is_patient': isPatient,
        'is_first_use': isFirstUse,
        'is_verified': isVerified,
        'care_giver': careGiver,
        'patient_type': patientType,
        'emr_number': emrNumber,
        'full_name': fullName,
        'user_name_subtitle': userNameSubtitle,
        'initial': initial,
        'phone': phone,
        'email': email,
        'birth_day': birthDay,
        'dp': dp,
        'acc_balance': accBalance,
        'acc_balance_subtitle': accBalanceSubtitle,
        'book_appointment': bookAppointment,
        'book_appointment_subtitle': bookAppointmentSubtitle,
        'religion': religion,
        'address': address,
        'nok_name': nokName,
        'nok_phone': nokPhone,
        'nok_email': nokEmail,
        'nok_address': nokAddress,
        'allergy': allergy
      };
}

class Menu {
  final Cards? cards;
  final Home? home;
  final More? more;

  Menu({
    this.cards,
    this.home,
    this.more,
  });

  Menu.fromJson(Map<String, dynamic> json)
      : cards = (json['cards'] as Map<String, dynamic>?) != null
            ? Cards.fromJson(json['cards'] as Map<String, dynamic>)
            : null,
        home = (json['home'] as Map<String, dynamic>?) != null
            ? Home.fromJson(json['home'] as Map<String, dynamic>)
            : null,
        more = (json['more'] as Map<String, dynamic>?) != null
            ? More.fromJson(json['more'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {
        'cards': cards?.toJson(),
        'home': home?.toJson(),
        'more': more?.toJson()
      };
}

class Cards {
  final String? title;
  final List<Data4>? data;

  Cards({
    this.title,
    this.data,
  });

  Cards.fromJson(Map<String, dynamic> json)
      : title = json['title'] as String?,
        data = (json['data'] as List?)
            ?.map((dynamic e) => Data4.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() =>
      {'title': title, 'data': data?.map((e) => e.toJson()).toList()};
}

class Data4 {
  final String? key;
  final String? picture;
  final String? title;
  final String? subTitle;
  final String? menuKey;

  Data4({
    this.key,
    this.picture,
    this.title,
    this.subTitle,
    this.menuKey,
  });

  Data4.fromJson(Map<String, dynamic> json)
      : key = json['key'] as String?,
        picture = json['picture'] as String?,
        title = json['title'] as String?,
        subTitle = json['sub_title'] as String?,
        menuKey = json['menu_key'] as String?;

  Map<String, dynamic> toJson() => {
        'key': key,
        'picture': picture,
        'title': title,
        'sub_title': subTitle,
        'menu_key': menuKey
      };
}

class Home {
  final String? title;
  final List<SpecialtyModel>? data;

  Home({
    this.title,
    this.data,
  });

  Home.fromJson(Map<String, dynamic> json)
      : title = json['title'] as String?,
        data = (json['data'] as List?)
            ?.map((dynamic e) =>
                SpecialtyModel.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() =>
      {'title': title, 'data': data?.map((e) => e.toJson()).toList()};
}

class SpecialtyModel {
  final String? key;
  final String? icon;
  final String? title;
  final String? subTitle;
  final String? menuKey;
  final String? picture;
  final String? appointmentLabel;
  bool selected = false;

  SpecialtyModel(
      {this.key,
      this.icon,
      this.title,
      this.subTitle,
      this.picture,
      this.appointmentLabel,
      this.menuKey,
      required this.selected});

  SpecialtyModel.fromJson(Map<String, dynamic> json)
      : key = json['key'] as String?,
        icon = json['icon'] as String?,
        subTitle = json['sub_title'] as String?,
        selected = false,
        picture = json['picture'] as String?,
        appointmentLabel = json['appointment_label'] as String?,
        title = json['title'] as String?,
        menuKey = json['menu_key'] as String?;

  Map<String, dynamic> toJson() => {
        'key': key,
        'picture': picture,
        'icon': icon,
        'subtitle': subTitle,
        'title': title,
        'menu_key': menuKey,
        'appointment_label': appointmentLabel
      };
}

class More {
  final String? title;
  final String? htmlContent;
  final String? htmlSrc;
  final String? htmlImg;
  List<Data3>? data;

  More({
    this.title,
    this.htmlContent,
    this.htmlSrc,
    this.htmlImg,
    this.data,
  });

  More.fromJson(Map<String, dynamic> json)
      : title = json['title'] as String?,
        htmlContent = json['html_content'] as String?,
        htmlSrc = json['html_src'] as String?,
        htmlImg = json['html_img'] as String?,
        data = (json['data'] as List?)
            ?.map((dynamic e) => Data3.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'title': title,
        'html_content': htmlContent,
        'html_src': htmlSrc,
        'html_img': htmlImg,
        'data': data?.map((e) => e.toJson()).toList()
      };
}

class Data3 {
  final String? key;
  final String? icon;
  final String? title;
  final String? subTitle;
  final String? menuKey;

  Data3({
    this.key,
    this.icon,
    this.title,
    this.subTitle,
    this.menuKey,
  });

  Data3.fromJson(Map<String, dynamic> json)
      : key = json['key'] as String?,
        icon = json['icon'] as String?,
        title = json['title'] as String?,
        subTitle = json['sub_title'] as String?,
        menuKey = json['menu_key'] as String?;

  Map<String, dynamic> toJson() => {
        'key': key,
        'icon': icon,
        'title': title,
        'sub_title': subTitle,
        'menu_key': menuKey
      };
}

class AppChart {
  final String? title;
  final String? subtitle;
  final List<Data>? data;

  AppChart({
    this.title,
    this.subtitle,
    this.data,
  });

  AppChart.fromJson(Map<String, dynamic> json)
      : title = json['title'] as String?,
        subtitle = json['subtitle'] as String?,
        data = (json['data'] as List?)
            ?.map((dynamic e) => Data.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'title': title,
        'subtitle': subtitle,
        'data': data?.map((e) => e.toJson()).toList()
      };
}

class Data {
  final String? key;
  final String? title;
  final int? value;

  Data({
    this.key,
    this.title,
    this.value,
  });

  Data.fromJson(Map<String, dynamic> json)
      : key = json['key'] as String?,
        title = json['title'] as String?,
        value = json['value'] as int?;

  Map<String, dynamic> toJson() => {'key': key, 'title': title, 'value': value};
}
