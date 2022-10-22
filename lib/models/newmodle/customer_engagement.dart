import 'dart:convert';
import '../../repository/api.dart';

class CustomerEngagementApi{
  Future<CustomerEngagement> getCustomerEngagement(ParamBodyData? body)async {
    Api api = Api();
    api.body = body!.toJson();

    var resp = await api.Posturl("v3/get-customerenagement-questions", isv2: false);
    print("resp CustomerEngagementApi $resp");
    return Future.value( CustomerEngagement.fromJson(json.decode(resp)));
  }
}
final CustomerApi = CustomerEngagementApi();
class ParamBodyData {
  String? branchtype;
  String? branch;
  ParamBodyData({this.branchtype, this.branch});

  ParamBodyData.fromJson(Map<String, String> json) {
    branchtype = json['branchtype'];
    branch = json['branch'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['branchtype'] = this.branchtype!;
    data['branch'] = this.branch!;
    return data;
  }
}


class CustomerEngagement {
  int? status;
  List<Data>? data;

  CustomerEngagement({this.status, this.data});

  CustomerEngagement.fromJson(Map<String, dynamic> json) {
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
  String? type;
  String? question;
  List<String>? answers;
  String? status;
  String? branch;

  Data(
      {this.id,
        this.type,
        this.question,
        this.answers,
        this.status,
        this.branch});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    question = json['question'];
    answers = (json['answers'] == "" || json['answers'] == null)?"":json['answers'].cast<String>();
    status = json['status'];
    branch = json['branch'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['question'] = this.question;
    data['answers'] = this.answers;
    data['status'] = this.status;
    data['branch'] = this.branch;
    return data;
  }
}



