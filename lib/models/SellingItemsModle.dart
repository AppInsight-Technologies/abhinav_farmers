class SellingItemModel {
  List<Data> _data = [];
  String? _label;

  SellingItemModel({List<Data>? data, String? label}) {
    this._data = data!;
    this._label = label;
  }

  List<Data> get data => _data;
  set data(List<Data> data) => _data = data;
  String get label => _label!;
  set label(String label) => _label = label;

  SellingItemModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {

      json['data'].forEach((v) {
        _data.add(new Data.fromJson(v));
      });
    }
    _label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._data != null) {
      data['data'] = this._data.map((v) => v.toJson()).toList();
    }
    data['label'] = this._label;
    return data;
  }
}

class Data {
  String? _id;
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
  List<PriceVariation>? _priceVariation;

  Data(
      {String? id,
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
        List<PriceVariation>? priceVariation}) {
    this._id = id;
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
  List<PriceVariation> get priceVariation => _priceVariation!;
  set priceVariation(List<PriceVariation> priceVariation) =>
      _priceVariation = priceVariation;

  Data.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _itemName = json['item_name'];
    _itemSlug = json['item_slug'];
    _vegType = json['veg_type'];
    _itemFeaturedImage = json['item_featured_image'];
    _regularPrice = json['regular_price'];
    _salePrice = json['sale_price'];
    _isActive = json['is_active'];
    _salesTax = json['sales_tax'];
    _totalQty = json['total_qty'];
    _brand = json['brand'];
    _type = json['type'];
    if (json['price_variation'] != null) {
      _priceVariation = <PriceVariation>[];
      json['price_variation'].forEach((v) {
        _priceVariation!.add(new PriceVariation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['item_name'] = this._itemName;
    data['item_slug'] = this._itemSlug;
    data['veg_type'] = this._vegType;
    data['item_featured_image'] = this._itemFeaturedImage;
    data['regular_price'] = this._regularPrice;
    data['sale_price'] = this._salePrice;
    data['is_active'] = this._isActive;
    data['sales_tax'] = this._salesTax;
    data['total_qty'] = this._totalQty;
    data['brand'] = this._brand;
    data['type'] = this._type;
    if (this._priceVariation != null) {
      data['price_variation'] =
          this._priceVariation!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PriceVariation {
  String? _id;
  String? _netWeight;
  String? _menuItemId;
  String? _variationName;
  double? _price;
  String? _priority;
  double? _mrp;
  int? _stock;
  String? _maxItem;
  String? _status;
  String? _minItem;
  String? _weight;
  double? _membershipPrice;
  String? _unit;
  double? _loyalty;
  List<String>? _images;
  int? _quantity;

  PriceVariation(
      {String? id,
        String? netWeight,
        String? menuItemId,
        String? variationName,
        double? price,
        String? priority,
        double? mrp,
        int? stock,
        String? maxItem,
        String? status,
        String? minItem,
        String? weight,
        double? membershipPrice,
        String? unit,
        double? loyalty,
        List<String>? images,
        int? quantity}) {
    this._id = id;
    this._netWeight = netWeight;
    this._menuItemId = menuItemId;
    this._variationName = variationName;
    this._price = price;
    this._priority = priority;
    this._mrp = mrp;
    this._stock = stock;
    this._maxItem = maxItem;
    this._status = status;
    this._minItem = minItem;
    this._weight = weight;
    this._membershipPrice = membershipPrice;
    this._unit = unit;
    this._loyalty = loyalty;
    this._images = images;
    this._quantity = quantity;
  }

  String get id => _id!;
  set id(String id) => _id = id;
  String get netWeight => _netWeight!;
  set netWeight(String netWeight) => _netWeight = netWeight;
  String get menuItemId => _menuItemId!;
  set menuItemId(String menuItemId) => _menuItemId = menuItemId;
  String get variationName => _variationName!;
  set variationName(String variationName) => _variationName = variationName;
  double get price => _price!;
  set price(double price) => _price = price;
  String get priority => _priority!;
  set priority(String priority) => _priority = priority;
  double get mrp => _mrp!;
  set mrp(double mrp) => _mrp = mrp;
  int get stock => _stock!;
  set stock(int stock) => _stock = stock;
  String get maxItem => _maxItem!;
  set maxItem(String maxItem) => _maxItem = maxItem;
  String get status => _status!;
  set status(String status) => _status = status;
  String get minItem => _minItem!;
  set minItem(String minItem) => _minItem = minItem;
  String get weight => _weight!;
  set weight(String weight) => _weight = weight;
  double get membershipPrice => _membershipPrice!;
  set membershipPrice(double membershipPrice) =>
      _membershipPrice = membershipPrice;
  String get unit => _unit!;
  set unit(String unit) => _unit = unit;
  double get loyalty => _loyalty!;
  set loyalty(double loyalty) => _loyalty = loyalty;
  List<String> get images => _images!;
  set images(List<String> images) => _images = images;
  int get quantity => _quantity!;
  set quantity(int quantity) => _quantity = quantity;

  PriceVariation.fromJson(Map<String, dynamic> json) {
    print("${json['price']}");
    _id = json['id'];
    _netWeight = json['net_weight'];
    _menuItemId = json['menu_item_id'];
    _variationName = json['variation_name'];
    _price = double.parse(json['price'].toString());
    _priority = json['priority'];
    _mrp = double.parse(json['mrp'].toString());
    _stock = json['stock'];
    _maxItem = json['max_item'];
    _status = json['status'];
    _minItem = json['min_item'];
    _weight = json['weight'];
    _membershipPrice = json['membership_price']+.0;
    _unit = json['unit'];
    _loyalty = double.parse(json['loyalty'].toString());
    _images = json['images'].cast<String>();
    _quantity = int.parse(json['quantity'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['net_weight'] = this._netWeight;
    data['menu_item_id'] = this._menuItemId;
    data['variation_name'] = this._variationName;
    data['price'] = this._price;
    data['priority'] = this._priority;
    data['mrp'] = this._mrp;
    data['stock'] = this._stock;
    data['max_item'] = this._maxItem;
    data['status'] = this._status;
    data['min_item'] = this._minItem;
    data['weight'] = this._weight;
    data['membership_price'] = this._membershipPrice;
    data['unit'] = this._unit;
    data['loyalty'] = this._loyalty;
    data['images'] = this._images;
    data['quantity'] = this._quantity;
    return data;
  }
}