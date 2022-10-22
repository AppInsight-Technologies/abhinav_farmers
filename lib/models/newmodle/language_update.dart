import 'dart:convert';
import 'package:grocbay/models/language.dart';

import '../../repository/api.dart';

class languageUpdateApi{
  Future<languageUpdate> sendlanguageUpdate(ParamBodyData? body)async {
    Api api = Api();
    api.body = body!.toJson();

    var resp = await api.Posturl("languageCodeUpdate", isv2: false);
    print("resp languageCodeUpdate $resp");
    return Future.value(languageUpdate.fromJson(json.decode(resp)));
  }
}
final languageApi = languageUpdateApi();
class ParamBodyData {
  String? id;
  String? language_code;
  ParamBodyData({this.id, this.language_code});

  ParamBodyData.fromJson(Map<String, String> json) {
    id = json['id'];
    language_code = json['language_code'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['id'] = this.id!;
    data['language_code'] = this.language_code!;
    return data;
  }
}


class languageUpdate {
  int? status;
  String? data;

  languageUpdate({this.status, this.data});

  languageUpdate.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['data'] = this.data;
    return data;
  }
}




