import 'dart:convert';
import '../../models/newmodle/home_page_modle.dart';
import '../api.dart';

class HomePageRepo{
 Future<HomePageData> getData(ParamBodyData? body)async{
   Api api = Api();
   api.body = body!.toJson();
    final resp =await api.Posturl("v3/get-home-page", isv2: false);
   return Future.value( HomePageData.fromJson(json.decode(resp)));
  }
}
final homePagerepo = HomePageRepo();
class ParamBodyData {
  String? user;
  String? branch;
  String? languageId;
  String? mode;
  String? rows;

  ParamBodyData({this.user, this.branch, this.languageId, this.mode, this.rows});

  ParamBodyData.fromJson(Map<String, String> json) {
    user = json['user'];
    branch = json['branch'];
    languageId = json['language_id'];
    mode = json['mode'];
    rows = json['rows'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['user'] = this.user!;
    data['branch'] = this.branch!;
    data['language_id'] = this.languageId!;
    data['mode'] = this.mode!;
    data['rows'] = this.rows!;
    return data;
  }
}
