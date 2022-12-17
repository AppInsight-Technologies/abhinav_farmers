import 'dart:convert';

import '../../repository/api.dart';

class CustomerremoveApi{
  Future<Customerremove> getCustomerremove(ParamBodyData? body)async {
    Api api = Api();
    api.body = body!.toJson();

    var resp = await api.Posturl("customer/delete", isv2: false);
    print("resp CustomerEngagementApi $resp");
    return Future.value( Customerremove.fromJson(json.decode(resp)));
  }
}
final customerremoveApi = CustomerremoveApi();
class ParamBodyData {
  String? user;

  ParamBodyData({ this.user});

  ParamBodyData.fromJson(Map<String, String> json) {
    user = json['user'];

  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['user'] = this.user!;

    return data;
  }
}


class Customerremove {
  int? status;


  Customerremove({this.status});

  Customerremove.fromJson(Map<String, dynamic> json) {
    status = json['status'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;

    return data;
  }
}
