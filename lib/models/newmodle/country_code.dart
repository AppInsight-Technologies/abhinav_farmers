import 'dart:convert';

import 'package:flutter/services.dart';

class CountryCodes{
  String? name;
  String? dialCode;
  String? code;
  String? currency_format;
  List? data;
  List<CountryCodes> list =[];

  Future<List<CountryCodes>> loadCountryCodeData() async {
    final jsonText = await rootBundle.loadString('assets/data/country_code.json');
    json.decode(jsonText).asMap().forEach((index, value){
      list.add(CountryCodes.fromJson(value));
    });
    //return list.where((element) => element.code == code).first;
    return list;
  }

  CountryCodes({this.name, this.dialCode, this.code});

  CountryCodes.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    dialCode = json['dial_code'];
    code = json['code'];
    currency_format = json['country_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['dial_code'] = this.dialCode;
    data['code'] = this.code;
    data['country_code'] = this.currency_format;
    return data;
  }
}
