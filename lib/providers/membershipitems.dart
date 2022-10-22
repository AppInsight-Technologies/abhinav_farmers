import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grocbay/models/VxModels/VxStore.dart';
import 'package:velocity_x/velocity_x.dart';
import '../assets/ColorCodes.dart';
import '../constants/api.dart';
import 'package:http/http.dart' as http;

import '../constants/features.dart';
import '../utils/prefUtils.dart';
import '../constants/IConstants.dart';
import '../models/membershipfields.dart';

class MembershipitemsList with ChangeNotifier {
  List<MembershipFields> _items = [];
  List<MembershipFields> _typesitems = [];
  GroceStore store = VxState.store;

  Future<void> Getmembership () async { // imp feature in adding async is the it automatically wrap into Future.
    try {
      _items.clear();
      _typesitems.clear();
      var membershiptext = "Select";
      var membershipbackground = Color(0xFFE5F3F2);
      var membershiptextcolor = Color(0xff39827E);
      var bordercolor = Color(0xff39827E);

      final response = await http.post(
          Api.getMembership,
          body: { // await keyword is used to wait to this operation is complete.
            "branchtype": IConstants.branchtype.toString(),
            "branch": IConstants.isEnterprise && Features.ismultivendor ?IConstants.refIdForMultiVendor:PrefUtils.prefs!.getString('branch'),
            "ref": IConstants.refIdForMultiVendor
          }
      );

      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      if (responseJson['data'].toString() != "[]") {
        final dataJson = json.encode(responseJson['data']); //fetching categories data
        final dataJsondecode = json.decode(dataJson);


        List data = []; //list for categories

        dataJsondecode.asMap().forEach((index, value) =>
            data.add(dataJsondecode[index] as Map<String, dynamic>)
        ); //store each category values in data list

        for (int i = 0; i < data.length; i++){
          _items.add(MembershipFields(
            name: data[i]['name'].toString(),
            description: data[i]['description'].toString(),
            avator: IConstants.API_IMAGE +(Vx.isWeb?data[i]["web_avator"].toString(): data[i]['avator'].toString()),

          ));

          final membertypesJson = json.encode(data[i]['types']); //fetching sub categories data
          final membertypesJsondecode = json.decode(membertypesJson);
          List pricevardata = []; //list for subcategories

          if (membertypesJsondecode == null){

          } else {
            membertypesJsondecode.asMap().forEach((index, value) =>
                pricevardata.add(
                    membertypesJsondecode[index] as Map<String, dynamic>)
            );
            for (int j = 0; j < pricevardata.length; j++) {
              _typesitems.add(MembershipFields(
                typesid: pricevardata[j]['id'].toString(),
                typesexpdate:pricevardata[j]['expiry_date'].toString(),
                typesname: pricevardata[j]['name'].toString(),
                typesprice: pricevardata[j]['price'].toString(),
                typesdiscountprice: pricevardata[j]['discounted_price'].toString(),
                typesduration: pricevardata[j]['duration'].toString(),
                text: membershiptext,
                backgroundcolor: membershipbackground,
                textcolor: membershiptextcolor,
                borderColor: bordercolor,
              ));
            }
          }
        }
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> Getmembershipdetails () async { // imp feature in adding async is the it automatically wrap into Future.
    try {
      final response = await http.post(
          Api.getMembershipDetail,
          body: { // await keyword is used to wait to this operation is complete.
            "userid": PrefUtils.prefs!.getString('apikey'),
            "branch": PrefUtils.prefs!.getString('branch'),
          }
      );

      final responseJson = json.decode(utf8.decode(response.bodyBytes));

      if (responseJson.toString() != "[]") {
        PrefUtils.prefs!.setString("post_image", IConstants.API_IMAGE +(Vx.isWeb?responseJson["web_post_image"]:responseJson['post_image']));
        PrefUtils.prefs!.setString("orderid", responseJson['orderId']);
        PrefUtils.prefs!.setString("orderdate", responseJson['orderDate']);
        PrefUtils.prefs!.setString("expirydate", responseJson['expiry_date']);
        PrefUtils.prefs!.setString("membershipname",responseJson['name'].toString() == "null" ? "" : responseJson['name'].toString() );
        PrefUtils.prefs!.setString("duration", responseJson['duration']);
        PrefUtils.prefs!.setString("membershipprice", responseJson['price']);
        PrefUtils.prefs!.setString("membershipaddress", responseJson['address']);
        PrefUtils.prefs!.setString("memebershippaytype", responseJson['paymentType']);
        PrefUtils.prefs!.setString("membershipuser", responseJson['user']);
        PrefUtils.prefs!.setString("post_image", IConstants.API_IMAGE +(Vx.isWeb?responseJson["web_post_image"]:responseJson['post_image']));

      }
    } catch (error) {
      throw error;
    }
  }

  List<MembershipFields> get items {
    return [..._items];
  }

  List<MembershipFields> get typesitems {
    return [..._typesitems];
  }


}