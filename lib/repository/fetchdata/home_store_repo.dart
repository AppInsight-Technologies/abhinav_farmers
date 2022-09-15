import 'package:grocbay/models/newmodle/home_store_modle.dart';
import 'dart:convert';
import '../api.dart';

class HomeStoreRepo{
  Future<Home_Store> getData(ParamBodyData? body)async{
    Api api = Api();
    api.body = body!.toJson();
    final resp =await api.Posturl("get-category-root-homepage",isv2: false);
    print("resp home store page....$resp");
    return Future.value( Home_Store.fromJson(json.decode(resp)));
  }
}
final homeStorerepo = HomeStoreRepo();
class ParamBodyData {
  String? user;
  String? lat;
  String? long;
  String? refid;
  String? language_id;


  ParamBodyData({this.user, this.lat, this.long,this.refid,this.language_id});

  ParamBodyData.fromJson(Map<String, String> json) {
    user = json['user'];
    lat = json['lat'];
    long = json['long'];
    refid = json['ref'];
    language_id = json['language_id'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['user'] = this.user??"";
    data['lat'] = this.lat??"";
    data['long'] = this.long??"";
    data['ref'] = this.refid??"";
    data['language_id'] = this.language_id??"";
    return data;
  }
}