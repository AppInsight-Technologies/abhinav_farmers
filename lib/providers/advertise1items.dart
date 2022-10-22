import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../constants/api.dart';
import 'package:http/http.dart' as http;
import '../constants/IConstants.dart';
import '../models/advertise1fields.dart';
import '../utils/prefUtils.dart';

class Advertise1ItemsList with ChangeNotifier {
  List<Advertise1Fields> _items = [];
  List<Advertise1Fields> _items1 = [];
  List<Advertise1Fields> _items2 = [];
  List<Advertise1Fields> _items3 = [];
  List<Advertise1Fields> _items4 = [];
  List<Advertise1Fields> _pages= [];
  List<Advertise1Fields> _footer = [];
  List<Advertise1Fields> _websiteSlider = [];
  List<Advertise1Fields> _itemBanner =[];
  List<Advertise1Fields> _popupbanner = [];

  Future<void> fetchadvertisecategory1 () async { // imp feature in adding async is the it automatically wrap into Future.
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
      _items.clear();
      final response = await http.get(Api.getAdsTwo + PrefUtils.prefs!.getString('branch')!);
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      List data = [];
      responseJson.asMap().forEach((index, value) =>
          data.add(responseJson[index] as Map<String, dynamic>)
      );
      for (int i = 0; i < data.length; i++)
      {
        if(_isWeb){
          if(data[i]['display_for'].toString().contains("0")){//web
            _items.add(Advertise1Fields(
              id: data[i]['id'].toString(),
              imageUrl: IConstants.API_IMAGE + "banners/banner/" + data[i]['banner_image'].toString(),
              bannerFor: data[i]['banner_for'].toString(),
              bannerData: data[i]['data'].toString(),
              clickLink: data[i]['click_link'].toString(),
              displayFor: data[i]['display_for'].toString(),
            ));
          }
        } else {
          if(data[i]['display_for'].toString().contains("1")){//App
            _items.add(Advertise1Fields(
              id: data[i]['id'].toString(),
              imageUrl: IConstants.API_IMAGE + "banners/banner/" + data[i]['banner_image'].toString(),
              bannerFor: data[i]['banner_for'].toString(),
              bannerData: data[i]['data'].toString(),
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

  Future<void> fetchAdvertisecategory2 () async { // imp feature in adding async is the it automatically wrap into Future.
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
      _items2.clear();
      final response = await http.get(Api.getAdsNine  + PrefUtils.prefs!.getString('branch')!);
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      List data = [];
      responseJson.asMap().forEach((index, value) =>
          data.add(responseJson[index] as Map<String, dynamic>)
      );
      for (int i = 0; i < data.length; i++)
      {
        if(_isWeb){
          if(data[i]['display_for'].toString().contains("0")){//web
            _items2.add(Advertise1Fields(
              id: data[i]['id'].toString(),
              imageUrl: IConstants.API_IMAGE + "banners/banner/" + data[i]['banner_image'].toString(),
              bannerFor: data[i]['banner_for'].toString(),
              bannerData: data[i]['data'].toString(),
              clickLink: data[i]['click_link'].toString(),
              displayFor: data[i]['display_for'].toString(),
            ));
          }
        } else {
          if(data[i]['display_for'].toString().contains("1")){//App
            _items2.add(Advertise1Fields(
              id: data[i]['id'].toString(),
              imageUrl: IConstants.API_IMAGE + "banners/banner/" + data[i]['banner_image'].toString(),
              bannerFor: data[i]['banner_for'].toString(),
              bannerData: data[i]['data'].toString(),
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

  Future<void> pageDetails(String id) async {
    var url = Api.pageDetails + id;

    try {
      _pages.clear();
      final response = await http
          .get(
        url,
      );
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      debugPrint('page...'+responseJson.toString());
      List data = [];
      responseJson.asMap().forEach((index, value) =>
          data.add(responseJson[index] as Map<String, dynamic>)
      );
      for (int i = 0; i < data.length; i++){
        _pages.add(Advertise1Fields(
          title: data[i]['title'].toString(),
          content: data[i]['content'].toString(),
        ));

      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchMainBanner1() async {
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
      _itemBanner.clear();
      final response = await http.get(Api.getAdsFifteen + PrefUtils.prefs!.getString('branch')!);
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      _itemBanner.clear();
      debugPrint("mainBanner.."+responseJson.toString());
      List data = [];
      responseJson.asMap().forEach((index, value) =>
          data.add(responseJson[index] as Map<String, dynamic>)
      );
      for (int i = 0; i < data.length; i++) {
        if (_isWeb) {
          if (data[i]['display_for'].toString().contains("0")) { //web
            _itemBanner.add(Advertise1Fields(
              id: data[i]['id'].toString(),
              imageUrl: IConstants.API_IMAGE + "banners/banner/" +
                  data[i]['banner_image'].toString(),
              bannerFor: data[i]['banner_for'].toString(),
              bannerData: data[i]['data'].toString(),
              clickLink: data[i]['click_link'].toString(),
              displayFor: data[i]['display_for'].toString(),
            ));
          }
        } else {
          if (data[i]['display_for'].toString().contains("1")) { //Ap
            _itemBanner.add(Advertise1Fields(
              id: data[i]['id'].toString(),
              imageUrl: IConstants.API_IMAGE + "banners/banner/" +
                  data[i]['banner_image'].toString(),
              bannerFor: data[i]['banner_for'].toString(),
              bannerData: data[i]['data'].toString(),
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

  Future<void> fetchPopupBanner () async {
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
      _popupbanner.clear();
      final response = await http.get(Api.getPopupBanner + PrefUtils.prefs!.getString('branch')!);
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      debugPrint("responseJson..."+responseJson.toString());
      List data = [];
      responseJson.asMap().forEach((index, value) =>
          data.add(responseJson[index] as Map<String, dynamic>)
      );
      for (int i = 0; i < data.length; i++){
        if(_isWeb){
          if(data[i]['display_for'].toString().contains("0")){//web
            _popupbanner.add(Advertise1Fields(
              id: data[i]['id'].toString(),
              imageUrl: IConstants.API_IMAGE + "banners/banner/" + data[i]['banner_image'].toString(),
              bannerFor: data[i]['banner_for'].toString(),
              bannerData: data[i]['data'].toString(),
              clickLink: data[i]['click_link'].toString(),
              displayFor: data[i]['display_for'].toString(),
              description: data[i]['description'].toString(),
            ));
          }
        } else {
          if(data[i]['display_for'].toString().contains("1")){//App
            _popupbanner.add(Advertise1Fields(
              id: data[i]['id'].toString(),
              imageUrl: IConstants.API_IMAGE + "banners/banner/" + data[i]['banner_image'].toString(),
              bannerFor: data[i]['banner_for'].toString(),
              bannerData: data[i]['data'].toString(),
              clickLink: data[i]['click_link'].toString(),
              displayFor: data[i]['display_for'].toString(),
              description: data[i]['description'].toString(),
            ));
          }
        }
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAdvertisecategory3 () async { // imp feature in adding async is the it automatically wrap into Future.
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
      _items3.clear();
      final response = await http.get(Api.getAdsTen + PrefUtils.prefs!.getString('branch')!);
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      List data = [];
      responseJson.asMap().forEach((index, value) =>
          data.add(responseJson[index] as Map<String, dynamic>)
      );
      for (int i = 0; i < data.length; i++)
      {
        if(_isWeb){
          if(data[i]['display_for'].toString().contains("0")){//web
            _items3.add(Advertise1Fields(
              id: data[i]['id'].toString(),
              imageUrl: IConstants.API_IMAGE + "banners/banner/" + data[i]['banner_image'].toString(),
              bannerFor: data[i]['banner_for'].toString(),
              bannerData: data[i]['data'].toString(),
              clickLink: data[i]['click_link'].toString(),
              displayFor: data[i]['display_for'].toString(),
            ));
          }
        } else {
          if(data[i]['display_for'].toString().contains("1")){//App
            _items3.add(Advertise1Fields(
              id: data[i]['id'].toString(),
              imageUrl: IConstants.API_IMAGE + "banners/banner/" + data[i]['banner_image'].toString(),
              bannerFor: data[i]['banner_for'].toString(),
              bannerData: data[i]['data'].toString(),
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

  Future<void> fetchAdvertisementItem1 () async {
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
      _items1.clear();
      final response = await http.get(Api.getAdsFive + PrefUtils.prefs!.getString('branch')!);
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      List data = [];
      responseJson.asMap().forEach((index, value) =>
          data.add(responseJson[index] as Map<String, dynamic>)
      );
      for (int i = 0; i < data.length; i++){
        if(_isWeb){
          if(data[i]['display_for'].toString().contains("0")){//web
            _items1.add(Advertise1Fields(
              id: data[i]['id'].toString(),
              imageUrl: IConstants.API_IMAGE + "banners/banner/" + data[i]['banner_image'].toString(),
              bannerFor: data[i]['banner_for'].toString(),
              bannerData: data[i]['data'].toString(),
              clickLink: data[i]['click_link'].toString(),
              displayFor: data[i]['display_for'].toString(),
            ));
          }
        } else {
          if(data[i]['display_for'].toString().contains("1")){//App
            _items1.add(Advertise1Fields(
              id: data[i]['id'].toString(),
              imageUrl: IConstants.API_IMAGE + "banners/banner/" + data[i]['banner_image'].toString(),
              bannerFor: data[i]['banner_for'].toString(),
              bannerData: data[i]['data'].toString(),
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

  Future<void> fetchAdvertisementVerticalslider() async {
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
      _items4.clear();
      final response = await http.get(Api.getAdsEleven + PrefUtils.prefs!.getString('branch')!);
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      List data = [];
      responseJson.asMap().forEach((index, value) =>
          data.add(responseJson[index] as Map<String, dynamic>)
      );
      for (int i = 0; i < data.length; i++){
        if(_isWeb){
          if(data[i]['display_for'].toString().contains("0")){//web
            _items4.add(Advertise1Fields(
              id: data[i]['id'].toString(),
              imageUrl: IConstants.API_IMAGE + "banners/banner/" + data[i]['banner_image'].toString(),
              bannerFor: data[i]['banner_for'].toString(),
              bannerData: data[i]['data'].toString(),
              clickLink: data[i]['click_link'].toString(),
              displayFor: data[i]['display_for'].toString(),
            ));
          }
        } else {
          if(data[i]['display_for'].toString().contains("1")){//App
            _items4.add(Advertise1Fields(
              id: data[i]['id'].toString(),
              imageUrl: IConstants.API_IMAGE + "banners/banner/" + data[i]['banner_image'].toString(),
              bannerFor: data[i]['banner_for'].toString(),
              bannerData: data[i]['data'].toString(),
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

  Future<void> fetchFooter() async {
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
      List data = [];
      if(responseJson.toString() != "[]") {
        responseJson.asMap().forEach((index, value) =>
            data.add(responseJson[index] as Map<String, dynamic>)
        );
        for (int i = 0; i < data.length; i++) {
          if(_isWeb){
            if(data[i]['display_for'].toString().contains("0")){//web
              _footer.add(Advertise1Fields(
                id: data[i]['id'].toString(),
                imageUrl: IConstants.API_IMAGE + "banners/banner/" +
                    data[i]['banner_image'].toString(),
                bannerFor: data[i]['banner_for'].toString(),
                bannerData: data[i]['data'].toString(),
                clickLink: data[i]['click_link'].toString(),
                displayFor: data[i]['display_for'].toString(),
              ));
            }
          } else {
            if(data[i]['display_for'].toString().contains("1")){//App
              _footer.add(Advertise1Fields(
                id: data[i]['id'].toString(),
                imageUrl: IConstants.API_IMAGE + "banners/banner/" +
                    data[i]['banner_image'].toString(),
                bannerFor: data[i]['banner_for'].toString(),
                bannerData: data[i]['data'].toString(),
                clickLink: data[i]['click_link'].toString(),
                displayFor: data[i]['display_for'].toString(),
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

  List<Advertise1Fields> get items {
    return [..._items];
  }
  List<Advertise1Fields> get items1 {
    return [..._items1];
  }
  List<Advertise1Fields> get items2 {
    return [..._items2];
  }
  List<Advertise1Fields> get item3 {
    return [..._items3];
  }
  List<Advertise1Fields> get pages {
    return [..._pages];
  }
  List<Advertise1Fields> get item4 {
    return [..._items4];
  }

  Future<void> websiteSlider() async { // imp feature in adding async is the it automatically wrap into Future.
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
      _websiteSlider.clear();
      final response = await http.get(Api.getAdsThree + PrefUtils.prefs!.getString('branch')!);
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      if(responseJson.toString() != "[]") {
        List data = [];
        responseJson.asMap().forEach((index, value) =>
            data.add(responseJson[index] as Map<String, dynamic>)
        );
        for (int i = 0; i < data.length; i++) {
          if(_isWeb){
            if(data[i]['display_for'].toString().contains("0")){//web
              _websiteSlider.add(Advertise1Fields(
                id: data[i]['id'].toString(),
                imageUrl: IConstants.API_IMAGE + "banners/banner/" +
                    data[i]['banner_image'].toString(),
                bannerFor: data[i]['banner_for'].toString(),
                bannerData: data[i]['data'].toString(),
                clickLink: data[i]['click_link'].toString(),
                displayFor: data[i]['display_for'].toString(),
              ));
            }
          } else {
            if(data[i]['display_for'].toString().contains("1")){//App
              _websiteSlider.add(Advertise1Fields(
                id: data[i]['id'].toString(),
                imageUrl: IConstants.API_IMAGE + "banners/banner/" +
                    data[i]['banner_image'].toString(),
                bannerFor: data[i]['banner_for'].toString(),
                bannerData: data[i]['data'].toString(),
                clickLink: data[i]['click_link'].toString(),
                displayFor: data[i]['display_for'].toString(),
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

  List<Advertise1Fields> get websiteItems {
    return [..._websiteSlider];
  }

  List<Advertise1Fields> get footerItems {
    return [..._footer];
  }
  List<Advertise1Fields> get itemBanner {
    return [..._itemBanner];
  }
  List<Advertise1Fields> get popupbanner {
    return [..._popupbanner];
  }
}