import '../constants/IConstants.dart';

class BrandsFieldModel {
  String? id;
  String? categoryName;
  String? iconImage;

  BrandsFieldModel({this.id, this.categoryName, this.iconImage});

  BrandsFieldModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    if(json['icon_image'] == null) iconImage = "";
    else iconImage = IConstants.API_IMAGE + "sub-category/icons/" + json['icon_image'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['icon_image'] = this.iconImage;
    return data;
  }
}