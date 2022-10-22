
import 'dart:ui';

import 'package:grocbay/constants/IConstants.dart';

class CategoryData {
  String? id;
  String? categoryName;
  String? iconImage;
  String? description;
  int? categoryType;
  String? parentId;
  String? heading;
  String? banner;
  int? type;
  List<CategoryData> subCategory = [];
  List<CategoryData> subNestCategory =[];
  Color? textcolor;
  FontWeight? fontweight;

  CategoryData({this.id, this.categoryName, this.iconImage, this.description});

  CategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    iconImage = (json['icon_image']!=null)?IConstants.API_IMAGE+"sub-category/icons/" +json['icon_image']:"";
    description = json['description']!=null?json['description']:"";
    heading = json['heading']!=null?json['heading']:"";
    banner =(json['banner']!=null)? IConstants.API_IMAGE+"sub-category/banners/"+json['banner']:"";
    parentId = json['parentId'];
    categoryType = json['category_type'];
    type = json['type']??0;
   // subNestCategory.add(CategoryData.fromJson(v));
    print("subb1....");
    if (json['SubCategory'] != null) {
      print("subb....");
      subCategory =[];
      json['SubCategory'].forEach((v) {
        subCategory.add(new CategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson({List<CategoryData>? subCategory}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['icon_image'] = this.iconImage;
    data['description'] = this.description;
    data['parentId'] = this.parentId;
    data['heading'] = this.heading;
    data['banner'] = this.banner;
    data['type'] = this.type;
    if ((subCategory??this.subCategory) != null) {
      data['SubCategory'] = (subCategory??this.subCategory).map((v) => v.toJson()).toList();
    }
    return data;
  }
}