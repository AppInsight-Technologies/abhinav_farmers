import 'dart:convert';
import 'dart:math';
import '../constants/IConstants.dart';
import '../models/categoriesModel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../utils/prefUtils.dart';
import '../constants/api.dart';

class CategoryProvider with ChangeNotifier {
  List<CategoriesModel> _items = [];
  List<CategoriesModel> _itemsTwo = [];
  List<CategoriesModel> _itemsThree = [];

  CategoriesModel? resultfinal;

  Future<List<CategoriesModel>> fetchCategoryOne() async {
    // imp feature in adding async is the it automatically wrap into Future.
    var url = Api.getFeaturedCategories /*+ IConstants.categoryOne + "/" + PrefUtils.prefs!.getString('branch')*/;

    try {
      _items.clear();
      final response = await http.post(url,
          body: {
            "id": IConstants.categoryOne,
            "branch": PrefUtils.prefs!.getString('branch'),
            "language_id": IConstants.languageId,
          });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));

      var list = [Color(0xffC6EEF1), Color(0xffC6F1C6), Color(0xffC6D6F1), Color(0xffE9F1C6), Color(0xffE9F1C6), Color(0xffE1C6F1), Color(0xffC6C7F1)];
      final _random = new Random();

      if(responseJson.toString() != "[]") {
        Map<String, dynamic> resdata;
        responseJson.asMap().forEach((index, value) {
          resdata = responseJson[index] as Map<String, dynamic>;
          print("$url catdata:$resdata");
          resdata["featuredCategoryBColor"] = /*list[_random.nextInt(list.length)]*/Colors.white;
          resultfinal = CategoriesModel.fromJson(resdata);
          _items.add(resultfinal!);
        });
      }
      return _items;
    } catch (error) {
      throw error;
    }
  }

  Future<List<CategoriesModel>> fetchCategoryTwo() async {
    // imp feature in adding async is the it automatically wrap into Future.
    var url = Api.getFeaturedCategories/* + IConstants.categoryTwo + "/" + PrefUtils.prefs!.getString('branch')*/;

    try {
      _itemsTwo.clear();
      final response = await http.post(url,
          body: {
            "id": IConstants.categoryTwo,
            "branch": PrefUtils.prefs!.getString('branch'),
            "language_id": IConstants.languageId,
          });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));

      var list = [Color(0xffC6EEF1), Color(0xffC6F1C6), Color(0xffC6D6F1), Color(0xffE9F1C6), Color(0xffE9F1C6), Color(0xffE1C6F1), Color(0xffC6C7F1)];
      final _random = new Random();

      if(responseJson.toString() != "[]") {
        Map<String, dynamic> resdata;
        responseJson.asMap().forEach((index, value) {
          resdata = responseJson[index] as Map<String, dynamic>;
          resdata["featuredCategoryBColor"] = /*list[_random.nextInt(list.length)]*/Colors.white;
          var result = CategoriesModel.fromJson(resdata);
          _itemsTwo.add(result);
        });
      }
      return _itemsTwo;
    } catch (error) {
      throw error;
    }
  }

  Future<List<CategoriesModel>> fetchCategoryThree() async {
    // imp feature in adding async is the it automatically wrap into Future.
    var categoryId = IConstants.categoryThree;
    var url = Api.getFeaturedCategories/* + categoryId + "/" + PrefUtils.prefs!.getString('branch')*/;
    var list = [Color(0xffC6EEF1), Color(0xffC6F1C6), Color(0xffC6D6F1), Color(0xffE9F1C6), Color(0xffE9F1C6), Color(0xffE1C6F1), Color(0xffC6C7F1)];
    final _random = new Random();
    _itemsThree.clear();
    try {
      final response = await http.post(url,
          body: {
            "id": IConstants.categoryThree,
            "branch": PrefUtils.prefs!.getString('branch'),
            "language_id": IConstants.languageId,
          });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      debugPrint("Category three . . . .. . . . " + {
        "id": IConstants.categoryThree,
        "branch": PrefUtils.prefs!.getString('branch'),
        "language_id": IConstants.languageId,
      }.toString() + " . .. .. ." + responseJson.toString());
      if(responseJson.toString() != "[]") {
        Map<String, dynamic> resdata;
        responseJson.asMap().forEach((index, value) {
          resdata = responseJson[index] as Map<String, dynamic>;
          resdata["featuredCategoryBColor"] = /*list[_random.nextInt(list.length)]*/Colors.white;
          var _catItems = CategoriesModel.fromJson(resdata);
          _itemsThree.add(_catItems);
        });
      }
      return _itemsThree;
      // notifyListeners();
    } catch (error) {
      throw error;
    }
  }

}