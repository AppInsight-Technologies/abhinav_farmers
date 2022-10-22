// import 'package:geocoder/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocbay/models/newmodle/address.dart';
import 'package:grocbay/models/newmodle/shoppingModel.dart';
import 'package:grocbay/utils/prefUtils.dart';

import '../../constants/IConstants.dart';

class SocialAuthUser {
  String? name;
  String? firstName;
  String? lastName;
  Picture? picture;
  String? email;
  String? id;
  Address? address;
  bool? newuser;

  SocialAuthUser(
      {this.name,
        this.firstName,
        this.lastName,
        this.picture,
        this.email,
        this.id,
        this.newuser});

  SocialAuthUser.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    newuser = json['newuser']??false;
    picture =
    json['picture'] != null ? new Picture.fromJson(json['picture']) : null;
    email = json['email'];
    id = json['id'];
  }

  Map<String, dynamic> toJson({bool? newuser, String? id}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    if (this.picture != null) {
      data['picture'] = this.picture!.toJson();
    }
    data['newuser'] = newuser??this.newuser;
    data['email'] = this.email;
    data['id'] = id??this.id;
    return data;
  }
}

class Picture {
  Data? data;

  Picture({this.data});

  Picture.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? height;
  bool? isSilhouette;
  String? url;
  int? width;

  Data({this.height, this.isSilhouette, this.url, this.width});

  Data.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    isSilhouette = json['is_silhouette'];
    url = json['url'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['height'] = this.height;
    data['is_silhouette'] = this.isSilhouette;
    data['url'] = this.url;
    data['width'] = this.width;
    return data;
  }
}
class UserModle {
  bool? status;
  List<UserData>? data;
  int? notificationCount;
  List<Prepaid>? prepaid;
  List<ShoppingListData>? shoppingList;
  UserModle({this.status, this.data, this.notificationCount, this.prepaid,this.shoppingList});
  UserModle.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <UserData>[];
      json['data'].forEach((v) {
        data!.add(UserData.fromJson(new UserData.fromJson(v).toJson(branch: PrefUtils.prefs!.getString("branch"))));
      });
    }
    notificationCount = json['notification_count'];
    if (json['prepaid'] != null) {
      prepaid = <Prepaid>[];
      json['prepaid'].forEach((v) {
        prepaid!.add(new Prepaid.fromJson(v));
      });
    }

    if (json['ShoppingList'] != null) {
      shoppingList = <ShoppingListData>[];
      json['ShoppingList'].forEach((v) {
        shoppingList!.add(new ShoppingListData.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['notification_count'] = this.notificationCount;
    if (this.prepaid != null) {
      data['prepaid'] = this.prepaid!.map((v) => v.toJson()).toList();
    }

    if (this.shoppingList != null) {
      data['ShoppingList'] = this.shoppingList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserData {
  String? id;
  String? email;
  String? mobileNumber;
  String? username;
  String? gst;
  String? membership = "0";
  String? area;
  String? ip;
  String? createdDate;
  String? channel;
  String? device;
  String? latitude;
  String? longitude;
  bool? isActive;
  bool? delevrystatus = false;
  String? branch;
  bool? isOnline;
  String? apiKey;
  String? otp;
  String? path;
  String? registrationKey;
  String? sex;
  String? myref;
  int? welcomebonus;
  String? shopName;
  String? pinCode;
  List<Address>? billingAddress;
  String? customerEngagementFlag;
  String? languageCode;
  String? prepaidModule;

  UserData(
      {this.id,
        this.email,
        this.mobileNumber,
        this.username,
        this.gst,
        this.membership ,
        this.area,
        this.ip,
        this.createdDate,
        this.channel,
        this.device,
        this.latitude,
        this.longitude,
        this.isActive,
        this.branch ,
        this.isOnline,
        this.apiKey,
        this.otp,
        this.path,
        this.registrationKey,
        this.sex,
        this.myref,
        this.welcomebonus,
        this.delevrystatus = false,
        this.billingAddress,
        this.customerEngagementFlag,
        this.shopName,
        this.pinCode,
        this.languageCode,
        this.prepaidModule,
      });

  UserData.fromJson(Map<String, dynamic> json) {

    id = json['id'].toString();
    email = json['email'];
    mobileNumber = json['mobileNumber'];
    username = json['username'];
    gst = json['gst'];
    membership = json['membership'];
    area = json['area'];
    ip = json['ip'];
    createdDate = json['createdDate'];
    channel = json['channel'];
    device = json['device'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isActive = json['isActive'];
    branch = json['branch'];
    isOnline = json['isOnline'];
    apiKey = json['apiKey'];
    otp = json['otp'];
    path = json['path'];
    registrationKey = json['registrationKey'];
    sex = json['sex'];
    myref = json['myref'];
    welcomebonus = json['welcomebonus'];
    shopName = json['shopName'];
    pinCode = json['pinCode'];
    if (json['billingAddress'] != null) {
      billingAddress = <Address>[];
      json['billingAddress'].forEach((v) {
        billingAddress!.add(new Address.fromJson(v));
      });
    }
    customerEngagementFlag = json['customerEngagementFlag'];
    languageCode = json['language_code']??IConstants.languageId;
    prepaidModule = json['prepaidModule'];
    IConstants.languageId = json['language_code']??IConstants.languageId;
  }

  Map<String, dynamic> toJson({String? branch}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['mobileNumber'] = this.mobileNumber;
    data['username'] = this.username;
    data['gst'] = this.gst;
    data['membership'] = this.membership;
    data['area'] = this.area;
    data['ip'] = this.ip;
    data['createdDate'] = this.createdDate;
    data['channel'] = this.channel;
    data['device'] = this.device;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['isActive'] = this.isActive;
    data['branch'] = branch??this.branch;
    data['isOnline'] = this.isOnline;
    data['apiKey'] = this.apiKey;
    data['otp'] = this.otp;
    data['path'] = this.path;
    data['registrationKey'] = this.registrationKey;
    data['sex'] = this.sex;
    data['myref'] = this.myref;
    data['welcomebonus'] = this.welcomebonus;
    data['shopName'] = this.shopName;
    data['pinCode'] = this.pinCode;
    if (this.billingAddress != null) {
      data['billingAddress'] =
          this.billingAddress!.map((v) => v.toJson()).toList();
    }
    data['customerEngagementFlag'] = this.customerEngagementFlag;
    data['language_code'] = this.languageCode;
    data['prepaidModule'] = this.prepaidModule;
    return data;
  }
}

class Prepaid   {
  int? postpaid;
  int? prepaid;
  double? loyalty;
  double? subscriptionPrepaid;

  Prepaid({this.postpaid, this.prepaid, this.loyalty, this.subscriptionPrepaid});

  Prepaid.fromJson(Map<String, dynamic> json) {
    postpaid = json['postpaid'];
    prepaid = json['prepaid'];
    loyalty = double.parse(json['loyalty'].toString());
    subscriptionPrepaid = double.parse(json['subscriptionPrepaid'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['postpaid'] = this.postpaid;
    data['prepaid'] = this.prepaid;
    data['loyalty'] = this.loyalty;
    data['subscriptionPrepaid'] = this.subscriptionPrepaid;
    return data;
  }
}


