import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../models/brandfieldsModel.dart';
import '../utils/prefUtils.dart';
import '../constants/api.dart';

class CarouselItems with ChangeNotifier {
  List<BrandsFields> _items = [];
  List<BrandsFields> _advertiseOne = [];
  List<BrandsFields> _featureAdsOne = [];
  List<BrandsFields> _featureAdsTwo = [];
  List<BrandsFields> _featureAdsThree = [];
  List<BrandsFields> _featureAdsFour = [];
  List<BrandsFields> _footer = [];

  BrandsFields? resultfinal;

  Future<List<BrandsFields>> fetchBanner() async {
    // imp feature in adding async is the it automatically wrap into Future.
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
      final response = await http.get(Api.getAdsOne + PrefUtils.prefs!.getString('branch')!);
      final responseJson = json.decode(utf8.decode(response.bodyBytes));

      if(responseJson.toString() != "[]") {
        Map<String, dynamic> resdata;
        responseJson.asMap().forEach((index, value) {
          resdata = responseJson[index] as Map<String, dynamic>;
          resultfinal = BrandsFields.fromJson(resdata);
          if (_isWeb) {
            if (resdata["display_for"].toString().contains("0")) //web
              _items.add(resultfinal!);
          } else {
            if (resdata["display_for"].toString().contains("1")) //App
              _items.add(resultfinal!);
          }
        });
      }
    return _items;
    } catch (error) {
      throw error;
    }
  }

  Future<List<BrandsFields>> fetchadvertisecategory1 () async { // imp feature in adding async is the it automatically wrap into Future.
    bool _isWeb = false;

    try {
      if(Platform.isIOS) {
        _isWeb = false;
      } else {
        _isWeb = false;
      }
    } catch (e) {
      _isWeb = true;
    }

    try {
      _advertiseOne.clear();
      final response = await http.get(Api.getAdsTwo + PrefUtils.prefs!.getString('branch')!);
      final responseJson = json.decode(utf8.decode(response.bodyBytes));

      if(responseJson.toString() != "[]") {
        Map<String, dynamic> resdata;
        responseJson.asMap().forEach((index, value) {
          resdata = responseJson[index] as Map<String, dynamic>;
          resultfinal = BrandsFields.fromJson(resdata);
          if (_isWeb) {
            if (resdata["display_for"].toString().contains("0")) { //web
              _advertiseOne.add(resultfinal!);
            }
          } else {
            if (resdata["display_for"].toString().contains("1")) { //App
              _advertiseOne.add(resultfinal!);
            }
          }
        });
      }
      return _advertiseOne;
    } catch (error) {
      throw error;
    }
  }

  Future<List<BrandsFields>> fetchAdvertisecategory2() async { // imp feature in adding async is the it automatically wrap into Future.
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
      _featureAdsOne.clear();
      final response = await http.get(Api.getAdsFive + PrefUtils.prefs!.getString('branch')!);
      final responseJson = json.decode(utf8.decode(response.bodyBytes));

      if(responseJson.toString() != "[]") {
        Map<String, dynamic> resdata;
        responseJson.asMap().forEach((index, value) {
          resdata = responseJson[index] as Map<String, dynamic>;
          resultfinal = BrandsFields.fromJson(resdata);
          if (_isWeb) {
            if (resdata["display_for"].toString().contains("0")) { //web
              _featureAdsOne.add(resultfinal!);
            }
          } else {
            if (resdata["display_for"].toString().contains("1")) { //App
              _featureAdsOne.add(resultfinal!);
            }
          }
        });
      }
      return _featureAdsOne;
    } catch (error) {
      throw error;
    }
  }


  Future<List<BrandsFields>> fetchAdvertisecategory3 () async { // imp feature in adding async is the it automatically wrap into Future.
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
      _featureAdsTwo.clear();
      final response = await http.get(Api.getAdsNine  + PrefUtils.prefs!.getString('branch')!);
      final responseJson = json.decode(utf8.decode(response.bodyBytes));

      if(responseJson.toString() != "[]") {
        Map<String, dynamic> resdata;
        responseJson.asMap().forEach((index, value) {
          resdata = responseJson[index] as Map<String, dynamic>;
          resultfinal = BrandsFields.fromJson(resdata);
          if (_isWeb) {
            if (resdata["display_for"].toString().contains("0")) { //web
              _featureAdsTwo.add(resultfinal!);
            }
          } else {
            if (resdata["display_for"].toString().contains("1")) { //App
              _featureAdsTwo.add(resultfinal!);
            }
          }
        });
      }
      return _featureAdsTwo;
    } catch (error) {
      throw error;
    }
  }

  Future<List<BrandsFields>> fetchAdvertisecategory4 () async { // imp feature in adding async is the it automatically wrap into Future.
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
      _featureAdsThree.clear();
      final response = await http.get(Api.getAdsTen + PrefUtils.prefs!.getString('branch')!);
      final responseJson = json.decode(utf8.decode(response.bodyBytes));

      if(responseJson.toString() != "[]") {
        Map<String, dynamic> resdata;
        responseJson.asMap().forEach((index, value) {
          resdata = responseJson[index] as Map<String, dynamic>;
          resultfinal = BrandsFields.fromJson(resdata);
          if (_isWeb) {
            if (resdata["display_for"].toString().contains("0")) { //web
              _featureAdsThree.add(resultfinal!);
            }
          } else {
            if (resdata["display_for"].toString().contains("1")) { //App
              _featureAdsThree.add(resultfinal!);
            }
          }
        });
      }
      return _featureAdsThree;
    } catch (error) {
      throw error;
    }
  }

  Future<List<BrandsFields>> fetchAdvertisecategory5() async { // imp feature in adding async is the it automatically wrap into Future.
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
      _featureAdsFour.clear();
      final response = await http.get(Api.getAdsEleven + PrefUtils.prefs!.getString('branch')!);
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      if(responseJson.toString() != "[]") {
        Map<String, dynamic> resdata;
        responseJson.asMap().forEach((index, value) {
          resdata = responseJson[index] as Map<String, dynamic>;
          resultfinal = BrandsFields.fromJson(resdata);
          if (_isWeb) {
            if (resdata["display_for"].toString().contains("0")) { //web
              _featureAdsFour.add(resultfinal!);
            }
          } else {
            if (resdata["display_for"].toString().contains("1")) { //App
              _featureAdsFour.add(resultfinal!);
            }
          }
        });
      }
      return _featureAdsFour;
    } catch (error) {
      throw error;
    }
  }

  Future<List<BrandsFields>> fetchFooter() async {
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
      _footer.clear();
      final response = await http.get(Api.getFooter + PrefUtils.prefs!.getString('branch')!);
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      if(responseJson.toString() != "[]") {
        Map<String, dynamic> resdata;
        responseJson.asMap().forEach((index, value) {
          resdata = responseJson[index] as Map<String, dynamic>;
          resultfinal= BrandsFields.fromJson(resdata);
          if (_isWeb) {
            if(resdata["display_for"].toString().contains("0")) { //web
              _footer.add(resultfinal!);
            }
          } else {
            if(resdata["display_for"].toString().contains("1")) { //App
              _footer.add(resultfinal!);
            }
          }
        });
        return _footer;
      }else{
        return [];
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

}