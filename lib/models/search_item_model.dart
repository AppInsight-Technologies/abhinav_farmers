import 'package:flutter/material.dart';
import '../constants/IConstants.dart';

class SearchtemModel {
  String? _id;
  String? _category;
  String? _itemName;
  String? _itemSlug;
  String? _vegType;
  String? _itemFeaturedImage;
  String? _regularPrice;
  String? _salePrice;
  String? _isActive;
  String? _salesTax;
  String? _totalQty;
  String? _brand;
  String? _type;
  List<PriceVariation1>? _priceVariation;

  SearchtemModel(
      {String? id,
        String? category,
        String? itemName,
        String? itemSlug,
        String? vegType,
        String? itemFeaturedImage,
        String? regularPrice,
        String? salePrice,
        String? isActive,
        String? salesTax,
        String? totalQty,
        String? brand,
        String? type,
        List<PriceVariation1>? priceVariation})  {
    this._id = id;
    this._category = category;
    this._itemName = itemName;
    this._itemSlug = itemSlug;
    this._vegType = vegType;
    this._itemFeaturedImage = itemFeaturedImage;
    this._regularPrice = regularPrice;
    this._salePrice = salePrice;
    this._isActive = isActive;
    this._salesTax = salesTax;
    this._totalQty = totalQty;
    this._brand = brand;
    this._type = type;
    this._priceVariation = priceVariation;
  }

  String get id => _id!;
  set id(String id) => _id = id;
  String get category => _category!;
  set category(String category) => _category = category;
  String get itemName => _itemName!;
  set itemName(String itemName) => _itemName = itemName;
  String get itemSlug => _itemSlug!;
  set itemSlug(String itemSlug) => _itemSlug = itemSlug;
  String get vegType => _vegType!;
  set vegType(String vegType) => _vegType = vegType;
  String get itemFeaturedImage => _itemFeaturedImage!;
  set itemFeaturedImage(String itemFeaturedImage) =>
      _itemFeaturedImage = itemFeaturedImage;
  String get regularPrice => _regularPrice!;
  set regularPrice(String regularPrice) => _regularPrice = regularPrice;
  String get salePrice => _salePrice!;
  set salePrice(String salePrice) => _salePrice = salePrice;
  String get isActive => _isActive!;
  set isActive(String isActive) => _isActive = isActive;
  String get salesTax => _salesTax!;
  set salesTax(String salesTax) => _salesTax = salesTax;
  String get totalQty => _totalQty!;
  set totalQty(String totalQty) => _totalQty = totalQty;
  String get brand => _brand!;
  set brand(String brand) => _brand = brand;
  String get type => _type!;
  set type(String type) => _type = type;
  List<PriceVariation1> get priceVariation => _priceVariation!;
  set priceVariation(List<PriceVariation1> priceVariation) =>
      _priceVariation = priceVariation;

  SearchtemModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _category = json['category'];
    _itemName = json['itemName'];
    _itemSlug = json['itemSlug'];
    _vegType = json['veg_type'];
    _itemFeaturedImage =  IConstants.API_IMAGE + "items/images/" + json['itemFeaturedImage'].toString();
    _regularPrice = json['regular_price'];
    _salePrice = json['sale_price'];
    _isActive = json['isActive'];
    _salesTax = json['salesTax'];
    _totalQty = json['total_qty'];
    _brand = json['brand'];
    _type = json['type'];
    if (json['priceVariation'] != null) {
      _priceVariation = <PriceVariation1>[];
      json['priceVariation'].forEach((v) {
        _priceVariation!.add(new PriceVariation1.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['category'] = this._category;
    data['itemName'] = this._itemName;
    data['itemSlug'] = this._itemSlug;
    data['veg_type'] = this._vegType;
    data['itemFeaturedImage'] = this._itemFeaturedImage;
    data['regular_price'] = this._regularPrice;
    data['sale_price'] = this._salePrice;
    data['isActive'] = this._isActive;
    data['salesTax'] = this._salesTax;
    data['total_qty'] = this._totalQty;
    data['brand'] = this._brand;
    data['type'] = this._type;
    if (this._priceVariation != null) {
      data['priceVariation'] =
          this._priceVariation!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PriceVariation1 {
  String? _netWeight;
  String? _id;
  String? _menuItemId;
  String? _variationName;
  String? _price;
  String? _priority;
  String? _mrp;
  int? _stock;
  String? _maxItem;
  String? _status;
  String? _minItem;
  double? _membershipPrice;
  List<String>? _images;
  String? _weight;
  String? _unit;
  int? _loyalty;
  int? _quantity;
Color varcolor = Colors.black54;
  bool? _membershipDisplay;
  bool? _discointDisplay;

  PriceVariation1(
      {String? netWeight,
        String? id,
        String? menuItemId,
        String? variationName,
        String? price,
        String? priority,
        String? mrp,
        int? stock,
        String? maxItem,
        String? status,
        String? minItem,
        double? membershipPrice,
        List<String>? images,
        String? weight,
        String? unit,
        int? loyalty,
        int? quantity}) {
    this._netWeight = netWeight;
    this._id = id;
    this._menuItemId = menuItemId;
    this._variationName = variationName;
    this._price = price;
    this._priority = priority;
    this._mrp = mrp;
    this._stock = stock;
    this._maxItem = maxItem;
    this._status = status;
    this._minItem = minItem;
    this._membershipPrice = membershipPrice;
    this._images = images;
    this._weight = weight;
    this._unit = unit;
    this._loyalty = loyalty;
    this._quantity = quantity;
  }

  String get netWeight => _netWeight!;
  set netWeight(String netWeight) => _netWeight = netWeight;
  String get id => _id!;
  set id(String id) => _id = id;
  String get menuItemId => _menuItemId!;
  set menuItemId(String menuItemId) => _menuItemId = menuItemId;
  String get variationName => _variationName!;
  set variationName(String variationName) => _variationName = variationName;
  String get price => _price!;
  set price(String price) => _price = price;
  String get priority => _priority!;
  set priority(String priority) => _priority = priority;
  String get mrp => _mrp!;
  set mrp(String mrp) => _mrp = mrp;
  int get stock => _stock!;
  set stock(int stock) => _stock = stock;
  String get maxItem => _maxItem!;
  set maxItem(String maxItem) => _maxItem = maxItem;
  String get status => _status!;
  set status(String status) => _status = status;
  String get minItem => _minItem!;
  set minItem(String minItem) => _minItem = minItem;
  double get membershipPrice => _membershipPrice!;
  set membershipPrice(double membershipPrice) =>
      _membershipPrice = membershipPrice;
  List<String> get images => _images!;
  set images(List<String> images) => _images = images;
  String get weight => _weight!;
  set weight(String weight) => _weight = weight;
  String get unit => _unit!;
  set unit(String unit) => _unit = unit;
  int get loyalty => _loyalty!;
  set loyalty(int loyalty) => _loyalty = loyalty;
  int get quantity => _quantity!;
  set quantity(int quantity) => _quantity = quantity;
  bool get membershipDisplay => _membershipDisplay!;
  set membershipDisplay(bool membershipDisplay) => _membershipDisplay = membershipDisplay;
  bool get discountDisplay => _discointDisplay!;
  set discountDisplay(bool discountDisplay) => _discointDisplay = discountDisplay;

  PriceVariation1.fromJson(Map<String, dynamic> json) {
    bool isdiscount = false;
    bool ismembership = false;

    if(double.parse(json['price'].toString()) <= 0 || json['price'].toString() == "" || double.parse(json['price'].toString()) == double.parse(json['mrp'].toString())){
      isdiscount = false;
    } else {
      isdiscount = true;
    }

    if(json['membership_price'].toString() == '-' || json['membership_price'].toString() == "0" || double.parse(json['membership_price'].toString()) == double.parse(json['mrp'].toString())
        || double.parse(json['membership_price'].toString()) == double.parse(json['price'].toString())) {
      ismembership = false;
    } else {
      ismembership = true;
    }

    _netWeight = json['net_weight'];
    _id = json['id'];
    _menuItemId = json['menu_item_id'];
    _variationName = json['variationName'];
    _price = (IConstants.numberFormat == "1") ? json['price'].toStringAsFixed(0) : json['price'].toStringAsFixed(2);
    _priority = json['priority'];
    _mrp = (IConstants.numberFormat == "1") ? json['mrp'].toStringAsFixed(0) : json['mrp'].toStringAsFixed(2);
    _stock = json['stock'];
    _maxItem = json['maxItem'];
    _status = json['status'];
    _minItem = json['minItem'];
    _membershipPrice = json['membership_price']+.0;
    if (json['images'] != null) {
      _images = <String>[];
      json['images'].forEach((v) {
        _images = json['images'].cast<String>();
      });
    }
    _weight = json['weight'].toString();
    _unit = json['unit'];
    _loyalty = json['loyalty'].toString() == "" || json['loyalty'].toString() == "null" ? 0 : int.parse(json['loyalty'].toString());
    _quantity = int.parse(json['quantity'].toString());
    _discountDisplay: isdiscount;
    _membershipDisplay: ismembership;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['net_weight'] = this._netWeight;
    data['id'] = this._id;
    data['menu_item_id'] = this._menuItemId;
    data['variationName'] = this._variationName;
    data['price'] = this._price;
    data['priority'] = this._priority;
    data['mrp'] = this._mrp;
    data['stock'] = this._stock;
    data['maxItem'] = this._maxItem;
    data['status'] = this._status;
    data['minItem'] = this._minItem;
    data['membership_price'] = this._membershipPrice;
    if (this._images != null) {
      data['images'] = this._images;
    }
    data['weight'] = this._weight;
    data['unit'] = this._unit;
    data['loyalty'] = this._loyalty;
    data['quantity'] = this._quantity;
    return data;
  }
}