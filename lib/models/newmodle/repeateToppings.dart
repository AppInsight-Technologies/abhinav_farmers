import 'dart:convert';
import 'package:flutter/cupertino.dart';

import '../../repository/api.dart';
import '../../utils/prefUtils.dart';

class Repeat{
  Future<RepeatTopping> getRepeatTopping(ParamBodyData? body)async {
    Api api = Api();
    api.body = body!.toJson();

    var resp = await api.Posturl("restaurant/get-repeat-toppings", isv2: true);
    print("resp repeate $resp");
    return Future.value( RepeatTopping.fromJson(json.decode(resp)));
  }
}
// final repeat = Repeat();
class ParamBodyData {
  String? user;
  String? branch;
  String? varid;
  String? itemid;


  ParamBodyData({this.user, this.branch, this.varid, this.itemid});

  ParamBodyData.fromJson(Map<String, String> json) {
    user = json['user'];
    branch = json['branch'];
    varid = json['var_id'];
    itemid = json['itemId'];

  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['user'] = this.user!;
    data['branch'] = this.branch!;
    data['var_id'] = this.varid!;
    data['itemId'] = this.itemid!;

    return data;
  }
}
class RepeatTopping {
  int? status;
  List<Data>? data;

  RepeatTopping({this.status, this.data});

  RepeatTopping.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? ref;
  String? price;

  Data({this.id, this.name, this.ref, this.price});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    ref = json['ref'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['ref'] = this.ref;
    data['price'] = this.price;
    return data;
  }
}