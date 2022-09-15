import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CategoriesFields with ChangeNotifier {
  final String? catid;
  final String? subcatid;
  final String? title;
  final String? description;
  final double? price;
  final String? imageUrl;
  final String? heading;
  int? startItemIndex;
  Color? boxbackcolor;
  Color? boxsidecolor;
  Color? textcolor;
  FontWeight? fontweight;
  final type;
  final parentId;
  Color? featuredCategoryBColor;
  final String? subcatdata;


  CategoriesFields({
    this.catid,
    this.subcatid,
    this.title,
    this.description,
    this.price,
    this.imageUrl,
    this.startItemIndex,
    this.boxbackcolor,
    this.boxsidecolor,
    this.textcolor,
    this.type,
    this.parentId,
    this.fontweight,
    this.featuredCategoryBColor,
    this.heading,
    this.subcatdata,
  });
}

