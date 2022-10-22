import 'dart:convert';


import 'package:grocbay/models/newmodle/store_banner.dart';
import 'package:grocbay/models/newmodle/store_data.dart';
import 'package:http/http.dart' as http;

import 'api.dart';


/*
class StoreRepo {

  Future<List<StoreData>?> getStore(body) async {
    var url = Api.getStorelist;

    final response = await http.post(url, body: body);
    final responseJson = json.decode(utf8.decode(response.bodyBytes));
    print("responseJson....promo.." + responseJson.toString());

    if (responseJson.toString() != "[]") {
      final itemJson =
      json.encode(responseJson['data']); //fetching sub categories data
      final itemJsondecode = json.decode(itemJson);
print("itemjson decode..."+itemJsondecode.toString());

      List<StoreData> data = [];
      *//*itemJsondecode.asMap().forEach((index, value) =>
          data.add(itemJsondecode[index] as Map<String, dynamic>));*//*
      itemJsondecode.asMap().forEach((index, value) =>
          data.add(
              StoreData.fromJson(value)
          )

      );
      return Future.value(data);
    }
    else {

    }
  }
}*/


class StoreRepo{
  Future<StoreOfferbanner> getBanner(ParamBodyData? body) async{
    Api api = Api();
    api.body = body!.toJson();
    final resp =await api.Posturl("get-store-banner",isv2: false);
    print("resp store banner...$resp");
    return Future.value( StoreOfferbanner.fromJson(json.decode(resp)));
  }
  Future<StoreData> getStore(ParamBodyData? body)async{
    Api api = Api();
    api.body = body!.toJson();
    final resp =await api.Posturl("get-store-list",isv2: false);
    print("resp home store page....$resp");
    return Future.value( StoreData.fromJson(json.decode(resp)));
  }

}
final storeRepo = StoreRepo();
class ParamBodyData {
  String? id;
  String? lat;
  String? long;
  String? refid;


  ParamBodyData({this.id, this.lat, this.long,this.refid});

  ParamBodyData.fromJson(Map<String, String> json) {
    id = json['ids'];
    lat = json['lat'];
    long = json['long'];
    refid = json['ref'];

  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['ids'] = this.id!;
    data['lat'] = this.lat!;
    data['long'] = this.long!;
    data['ref'] = this.refid??"";
    return data;
  }
}
