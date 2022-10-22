import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../constants/api.dart';
import 'package:http/http.dart' as http;

import '../utils/prefUtils.dart';
import '../assets/ColorCodes.dart';
import '../constants/IConstants.dart';
import '../models/brandfields.dart';

class CarouselItemsList with ChangeNotifier {
  List<BrandsFields> _items = [];
  List<BrandsFields> _brandItems = [];

  Future<void> fetchBanner() async { // imp feature in adding async is the it automatically wrap into Future.
    bool _isWeb = false;

    try {
      if (Platform.isIOS) {
        _isWeb = false;
      } else {
        _isWeb = false;
      }
    } catch (e) {
      _isWeb = true;
    }

    try {
      _items.clear();
      final response = await http.post(
          Api.getAdsOne + PrefUtils.prefs!.getString('branch')!,
          body: { // await keyword is used to wait to this operation is complete.
          }
      );
      final responseJson = json.decode(utf8.decode(response.bodyBytes));

//      var idlist = responseJson.map<int>((m) => m['id'] as int).toList();
//      var imagelist = responseJson.map<String>((m) => m['banner_image'] as String).toList();

      List data = [];

      responseJson.asMap().forEach((index, value) =>
          data.add(responseJson[index] as Map<String, dynamic>)
      );

      for (int i = 0; i < data.length; i++){
        if(_isWeb){
          if(data[i]['display_for'].toString().contains("0")){//web
            _items.add( BrandsFields(
              id: data[i]['id'].toString(),
              imageUrl: IConstants.API_IMAGE + "banners/banner/" + data[i]['banner_image'].toString(),
              banner_for: data[i]['banner_for'].toString(),
              banner_data: data[i]['data'].toString(),
              clickLink: data[i]['click_link'].toString(),
              displayFor: data[i]['display_for'].toString(),
            ));
          }
        } else {
          if(data[i]['display_for'].toString().contains("1")){//App
            _items.add( BrandsFields(
              id: data[i]['id'].toString(),
              imageUrl: IConstants.API_IMAGE + "banners/banner/" + data[i]['banner_image'].toString(),
              banner_for: data[i]['banner_for'].toString(),
              banner_data: data[i]['data'].toString(),
              clickLink: data[i]['click_link'].toString(),
              displayFor: data[i]['display_for'].toString(),
            ));
          }
        }
      }
      notifyListeners();

    } catch (error) {
      throw error;
    }
  }

  List<BrandsFields> get items {
    return [..._items];
  }

  Future<void> fetchBrandsItems(String brandsId) async {
    // imp feature in adding async is the it automatically wrap into Future.
    var url = Api.getBrandsData + brandsId;
    try {
      _brandItems.clear();
      final response = await http.post(url, body: {
        // await keyword is used to wait to this operation is complete.
        "branch": PrefUtils.prefs!.getString('branch'),
        "language_id": IConstants.languageId,
      });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      debugPrint("bb,,,,,"+responseJson.toString());

//      var idlist = responseJson.map<int>((m) => m['id'] as int).toList();
//      var imagelist = responseJson.map<String>((m) => m['banner_image'] as String).toList();

      List data = [];

      responseJson.asMap().forEach((index, value) =>
          data.add(responseJson[index] as Map<String, dynamic>));

      Color boxbackcolor;
      Color boxsidecolor;
      Color textcolor;

      for (int i = 0; i < data.length; i++) {
        if(i != 0) {
          boxbackcolor = ColorCodes.whiteColor;
          boxsidecolor = ColorCodes.blackColor;
          textcolor = ColorCodes.blackColor;
        } else {
          boxbackcolor = ColorCodes.mediumBlueColor;
          boxsidecolor = ColorCodes.mediumBlueColor;
          textcolor = ColorCodes.whiteColor;
        }
        _brandItems.add(BrandsFields(
          id: data[i]['id'].toString(),
          title: data[i]['category_name'].toString(),
          imageUrl: IConstants.API_IMAGE +
              "sub-category/icons/" +
              data[i]['icon_image'].toString(),
          boxbackcolor: boxbackcolor,
          boxsidecolor: boxsidecolor,
          textcolor: textcolor,
        ));
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<BrandsFields> get brands {
    return [..._brandItems];
  }

}