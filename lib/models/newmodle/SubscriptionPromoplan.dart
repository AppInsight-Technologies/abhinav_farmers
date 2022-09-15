import 'dart:convert';
import 'package:flutter/cupertino.dart';

import '../../repository/api.dart';

class SubscriptionPromoplanApi{
  Future<SubscriptionPromoplan> getSubscriptionPromoplan(ParamBodyData? body)async {
    Api api = Api();
    api.body = body!.toJson();

    var resp = await api.Posturl("get-subscription-promoplan", isv2: false);
    print("resp SubscriptionPromoplanApi $resp");
    return Future.value( SubscriptionPromoplan.fromJson(json.decode(resp)));
  }
}
final SubscriptionApi = SubscriptionPromoplanApi();
class ParamBodyData {
  String? branchtype;
  String? branch;
  String? ref;
  String? id;
  String? price;
  String? total;
  ParamBodyData({this.branchtype, this.branch,this.ref,this.id,this.price,this.total});

  ParamBodyData.fromJson(Map<String, String> json) {
    branchtype = json['branchtype'];
    branch = json['branch'];
    ref = json['ref'];
    id = json['id'];
    price  = json['price'];
    total  = json['total'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['branchtype'] = this.branchtype!;
    data['branch'] = this.branch!;
    data['ref'] = this.ref!;
    data['id'] = this.id!;
    data['price'] = this.price!;
    data['total'] = this.total!;
    return data;
  }
}

class SubscriptionPromoplan {
  int? status;
  List<Data>? data;

  SubscriptionPromoplan({this.status, this.data});

  SubscriptionPromoplan.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? planName;
  double? subscriptionamount;
  String? days;
  String? isdefault;
  double? grandtotal;
  String? discountType;
  String? discountAmount;
  String? status;

  Data(
      {
        this.id,
        this.planName,
        this.subscriptionamount,
        this.days,
        this.isdefault,
        this.grandtotal,
        this.discountType,
        this.discountAmount,
        this.status});

  Data.fromJson(Map<String, dynamic> json) {
    debugPrint("json['grandtotal'].toString()...."+json['grandtotal'].toString());
    id = json['id'];
    planName = json['planName'];
    subscriptionamount = double.parse(json['subscriptionamount'].toString());
    days = json['days'];
    isdefault = json['isdefault'];
    grandtotal = double.parse(json['grandtotal'].toString());
    discountType = json['discount_type'];
    discountAmount = json['discount_amount'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['planName'] = this.planName;
    data['subscriptionamount'] = this.subscriptionamount;
    data['days'] = this.days;
    data['isdefault'] = this.isdefault;
    data['grandtotal'] = this.grandtotal;
    data['discount_type'] = this.discountType;
    data['discount_amount'] = this.discountAmount;
    data['status'] = this.status;
    return data;
  }
}