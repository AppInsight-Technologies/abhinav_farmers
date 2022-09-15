import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grocbay/constants/features.dart';
import 'package:grocbay/models/VxModels/VxStore.dart';
import 'package:velocity_x/velocity_x.dart';
import '../blocs/adress_bloc.dart';
import 'package:http/http.dart' as http;

import '../utils/prefUtils.dart';
import '../constants/IConstants.dart';
import '../models/addressfields.dart';
import '../constants/api.dart';

class AddressItemsList with ChangeNotifier {
  List<AddressFields> _items = [];
  String? stringValue;
  GroceStore store = VxState.store;

  Future<void> NewAddress(String latitude, String longitude, String branch) async {
    // imp feature in adding async is the it automatically wrap into Future.
    var name;
    try {
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      // if (PrefUtils.prefs!.getString('FirstName') != null) {
      //   if (PrefUtils.prefs!.getString('LastName') != null) {
      //     name =
      //         PrefUtils.prefs!.getString('FirstName') + " " + PrefUtils.prefs!.getString('LastName');
      //   } else {
      //     name = PrefUtils.prefs!.getString('FirstName');
      //   }
      // } else {
      //   name = "";
      // }
      name = store.userData.username;
      final response = await http.post(Api.addAddress, body: {
        // await keyword is used to wait to this operation is complete.
        "apiKey": PrefUtils.prefs!.getString('apiKey'),
        "addressType": PrefUtils.prefs!.getString('newaddresstype'),
        "fullName": name,
        "address": PrefUtils.prefs!.getString('newaddress'),
        "longitude": longitude,
        "latitude": latitude,
        "branch": branch,
        "default": "1",
      });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
    } catch (error) {
      throw error;
    }
  }

  Future<void> UpdateAddress(String addressid, String latitude, String longitude, String branch) async {
    // imp feature in adding async is the it automatically wrap into Future.
    var name;
    try {
      // if (PrefUtils.prefs!.getString('FirstName') != null) {
      //   if (PrefUtils.prefs!.getString('LastName') != null) {
      //     name =
      //         PrefUtils.prefs!.getString('FirstName') + " " + PrefUtils.prefs!.getString('LastName');
      //   } else {
      //     name = PrefUtils.prefs!.getString('FirstName');
      //   }
      // } else {
      //   name = "";
      // }
      name = store.userData.username;
      final response = await http.post(Api.updateAddress, body: {
        // await keyword is used to wait to this operation is complete.
        "apiKey": PrefUtils.prefs!.getString('apiKey'),
        "addressId": addressid,
        "addressType": PrefUtils.prefs!.getString('newaddresstype'),
        "fullName": name,
        "address": PrefUtils.prefs!.getString('newaddress'),
        "longitude": longitude,
        "latitude": latitude,
        "branch": branch,
      });
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAddress() async {

    // imp feature in adding async is the it automatically wrap into Future.
    try {
      _items.clear();
      final response = await http.post(Api.getAddress, body: {
        // await keyword is used to wait to this operation is complete.
        "customer": PrefUtils.prefs!.getString('apikey'),
        "branch": PrefUtils.prefs!.getString('branch'),
        "ref" : IConstants.refIdForMultiVendor,
      });
print("get addresssss return"+Api.getAddress.toString()+"////"+{
    // await keyword is used to wait to this operation is complete.
    "customer": PrefUtils.prefs!.getString('apikey'),
    "branch": PrefUtils.prefs!.getString('branch'),
    "ref" : IConstants.refIdForMultiVendor,

}.toString());
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      print("wecfre" + responseJson.toString());

      final dataJson = json.encode(responseJson); //fetching categories data

      final dataJsondecode = json.decode(dataJson)["data"];
      print("data jsons descode..."+dataJsondecode.toString());

      List data = []; //list for categories

      dataJsondecode.asMap().forEach((index, value) => data.add(dataJsondecode[
              index]
          as Map<String, dynamic>)); //store each category values in data list

      for (int j = 0; j < data.length; j++) {
        IconData icon;
        if (data[j]['addresstype'].toString().toLowerCase() == "work") {
          data[j]['addresstype'] = "Work";
          icon = Icons.work;
        } else if (data[j]['addresstype'].toString().toLowerCase() == "home") {
          data[j]['addresstype'] = "Home";
          icon = Icons.home;
        } else {
          data[j]['addresstype'] = "Other";
          icon = Icons.location_on;
        }
        _items.add(AddressFields(
          userid: data[j]['id'].toString(),
          useraddtype: data[j]['addresstype'].toString(),
          username: data[j]['customername'].toString(),
          useraddress: data[j]['address'].toString(),
          userlat: data[j]['lattitude'].toString(),
          userlong: data[j]['logingitude'].toString(),
          addressdefault: data[j]['default'].toString(),
          addressicon: icon,
        ));
        adressbloc.sinkadress.add(_items);
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> setDefaultAddress(String addressid) async {
    // imp feature in adding async is the it automatically wrap into Future.

    try {
      final response = await http.post(Api.setDefaultAddress, body: {
        // await keyword is used to wait to this operation is complete.
        "id": addressid,
        "branch": PrefUtils.prefs!.getString('branch'),
      });
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteAddress(String addressid) async {
    // imp feature in adding async is the it automatically wrap into Future.
    try {
      final response = await http.post(Api.removeAddress, body: {
        // await keyword is used to wait to this operation is complete.
        "apiKey": PrefUtils.prefs!.getString('apiKey'),
        "addressId": addressid,
        "branch": PrefUtils.prefs!.getString('branch'),
      });
    } catch (error) {
      throw error;
    }
  }

  List<AddressFields> get items {
    return [..._items];
  }
}
