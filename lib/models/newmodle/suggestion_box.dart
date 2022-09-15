import 'dart:convert';
import '../../repository/api.dart';

class SuggestionBoxApi{
  Future<SuggestionBox> getSuggeationBox(ParamBodyData? body)async {
    Api api = Api();
    api.body = body!.toJson();

    var resp = await api.Posturl("add/customer-suggestion", isv2: false);
    print("resp suggersionboxApi $resp");
    return Future.value(SuggestionBox.fromJson(json.decode(resp)));
  }
}
final SuggestionApi = SuggestionBoxApi();
class ParamBodyData {
  String? branch;
  String? ref;
  String? customerId;
  String? customerName;
  String? mobileNumber;
  String? suggestion;

  ParamBodyData({this.branch, this.ref, this.customerId, this.customerName, this.mobileNumber, this.suggestion});

  ParamBodyData.fromJson(Map<String, String> json) {
    branch = json['branch'];
    ref= json['ref'];
    customerId = json['customerId'];
    customerName = json['customerName'];
    mobileNumber = json['mobileNumber'];
    suggestion = json['suggestion'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['branch'] = this.branch!;
    data['ref'] = this.ref!;
    data['customerId'] = this.customerId!;
    data['customerName'] = this.customerName!;
    data['mobileNumber'] = this.mobileNumber!;
    data['suggestion'] = this.suggestion!;
    return data;
  }
}
class SuggestionBox {
  int? status;

  SuggestionBox({this.status});

  SuggestionBox.fromJson(Map<String, dynamic> json) {
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    return data;
  }
}