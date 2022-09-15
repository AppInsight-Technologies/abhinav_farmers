import 'package:grocbay/models/newmodle/store_banner.dart';
import 'package:grocbay/models/newmodle/store_data.dart';

import '../../models/newmodle/category_store_modle.dart';
import 'dart:convert';
import '../api.dart';

class CategoryStoreRepo{


  Future<StoreOfferbanner> getBanner(ParamBodyData1? body) async{
    Api api = Api();
    api.body = body!.toJson();
    final resp =await api.Posturl("get-store-banner",isv2: false);
    print("resp store banner...$resp");
    return Future.value( StoreOfferbanner.fromJson(json.decode(resp)));
  }

  Future<StoreData> getData(ParamBodyData1? body)async{
    Api api = Api();
    api.body = body!.toJson();
    final resp =await api.Posturl("get-CategoryTegs-store-list",isv2: false);
    print("resp category store page....category...$resp");
    return Future.value( StoreData.fromJson(json.decode(resp)));
  }
}
final categoryStoreRepo = CategoryStoreRepo();
class ParamBodyData1{
  String? lat;
  String? long;
  String? id;
  String? refid;

  ParamBodyData1({this.lat, this.long, this.id,this.refid});

  ParamBodyData1.fromJson(Map<String, String> json) {
    id = id;
    lat = json['lat'];
    long = json['long'];
    refid = json['ref'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['id'] = this.id.toString();
    data['lat'] = this.lat!;
    data['long'] = this.long!;
    data['ref'] = this.refid??"";
    return data;
  }
}