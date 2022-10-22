import 'package:flutter/material.dart';
import '../constants/IConstants.dart';

class CategoriesModel {
  String? subcatid;
  String? title;
  String? imageUrl;
  String? catid;
  Color? _featuredCategoryBColor;

  CategoriesModel({String? id, String? categoryName, String? iconImage, String? parentId, Color? featuredCategoryBColor}) {
    this.subcatid = id;
    this.title = categoryName;
    this.imageUrl = iconImage;
    this.catid = parentId;
    this._featuredCategoryBColor = featuredCategoryBColor;
  }

  String get id => subcatid!;
  set id(String id) => subcatid = id;
  String get categoryName => title!;
  set categoryName(String categoryName) => title = categoryName;
  String get iconImage => imageUrl!;
  set iconImage(String iconImage) => imageUrl = iconImage;
  String get parentId => catid!;
  set parentId(String parentId) => catid = parentId;
  Color get featuredCategoryBColor => _featuredCategoryBColor!;
  set branch(Color featuredCategoryBColor) => _featuredCategoryBColor = featuredCategoryBColor;

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    subcatid = json['id'];
    title = json['category_name'];
    imageUrl = IConstants.API_IMAGE + "sub-category/icons/" + json['icon_image'];
    catid = json['parentId'];
    _featuredCategoryBColor = json['featuredCategoryBColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.subcatid;
    data['category_name'] = this.title;
    data['icon_image'] = this.imageUrl;
    data['parentId'] = this.catid;
    data['featuredCategoryBColor'] = this._featuredCategoryBColor;
    return data;
  }
}
