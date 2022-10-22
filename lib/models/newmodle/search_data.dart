import '../../models/newmodle/product_data.dart';
import '../../constants/IConstants.dart';
import '../../constants/features.dart';

class StoreSearch {
  List<StoreSearchData>? data;
  StoreSearch({this.data});

  StoreSearch.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <StoreSearchData>[];
      json['data'].forEach((v) {
        data!.add(new StoreSearchData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StoreSearchData {
  int? menuItemCount;
  int? ratings;
  String? location;
  double? distance;
  String? branchId;
  String? shop;
  List<Addon>? addon;
  String? id;
  String? eligibleForExpress;
  var deliveryDuration;
  String? eligibleForSubscription;
  List<SubscriptionSlot>? subscriptionSlot;
  String? category;
  String? categoryId;
  String? itemName;
  String? vegType;
  String? itemFeaturedImage;
  String? salePrice;
  String? isActive;
  String? salesTax;
  String? itemDescription;
  String? brand;
  String? type;
  List<PriceVariationSearch>? priceVariation=[];
  int? loyalty;
  String? netWeight;
  String? price;
  String? priority;
  String? mrp;
  int? stock;
  String? maxItem;
  String? minItem;
  String? weight;
  int? membershipPrice;
  int? loyaltys;
  String? quantity;
  String? increament;
  String? status;
  String? singleshortNote;
  String? paymentMode;
  bool? discointDisplay = false;
  bool? membershipDisplay = false;
  String? unit;
  String? duration;
  String? itemSlug;
  String? regularPrice;
  String? totalQty;
  String? item_description;
  String? manufacturer_description;
  int? replacement;
  // var deliveryDuration;
  String? delivery;
  String? mode;
  String? membershipId;

  StoreSearchData(
      {
        this.menuItemCount,
        this.ratings,
        this.location,
        this.distance,
        this.branchId,
        this.shop,
        this.addon,
        this.id,
        this.eligibleForExpress,
        this.deliveryDuration,
        this.eligibleForSubscription,
        this.subscriptionSlot,
        this.category,
        this.categoryId,
        this.itemName,
        this.vegType,
        this.itemFeaturedImage,
        this.salePrice,
        this.isActive,
        this.salesTax,
        this.itemDescription,
        this.brand,
        this.type,
        this.priceVariation,
        this.loyalty,
        this.netWeight,
        this.price,
        this.priority,
        this.mrp,
        this.stock,
        this.maxItem,
        this.minItem,
        this.weight,
        this.membershipPrice,
        this.loyaltys,
        this.quantity,
        this.increament,
        this.status,
        this.singleshortNote,
        this.paymentMode,
        this.discointDisplay,
        this.membershipDisplay,
        this.unit,
        this.duration,
        this.itemSlug,
        this.regularPrice,
        this.totalQty,
        this.item_description,
        this.manufacturer_description,
        this.replacement,
        this.delivery,
        this.mode,
        this.membershipId,
      });

  StoreSearchData.fromJson(Map<String, dynamic> json) {
    menuItemCount = json['menu_item_count'];
    ratings = json['ratings'];
    location = json['location'];
    distance = double.parse(json['distance'].toString());
    branchId = json['branch_id'];
    shop = json['shop'];
    if (json['addon'] != null) {
      addon = <Addon>[];
      json['addon'].forEach((v) {
        addon!.add(new Addon.fromJson(v));
      });
    }
    id = json['id'];
    eligibleForExpress = Features.isExpressDelivery? Features.isSplit? json['eligible_for_express'] : "0" : "1";
    deliveryDuration = json['delivery_duration'];
    eligibleForSubscription = json['eligible_for_subscription'];
    if (json['subscription_slot'] != null) {
      subscriptionSlot = <SubscriptionSlot>[];
      json['subscription_slot'].forEach((v) {
        subscriptionSlot!.add(new SubscriptionSlot.fromJson(v));
      });
    }
    deliveryDuration = (json['delivery_duration'] == "slot" || json['delivery_duration'] == ""|| json['delivery_duration'] == null)
        ?new DeliveryDurationData(duration: "",durationType: "",note: ""):new DeliveryDurationData.fromJson(json['delivery_duration']is List<dynamic> ?json['delivery_duration'][0]:json['delivery_duration']);
    category = json['category'];
    categoryId = json['category_id'];
    itemName = json['item_name'];
    vegType = json['veg_type'];
    itemFeaturedImage = (json['item_featured_image']==null||json['item_featured_image']==[])?"" : IConstants.API_IMAGE + "items/images/" +json['item_featured_image'];
    salePrice = json['sale_price'];
    isActive = json['is_active'];
    salesTax = json['sales_tax'];
    itemDescription = json['item_description'];
    brand = json['brand'];
    type = json['type'];
    delivery = (json['delivery']??"0").toString();
    mode=(json['mode']??"0").toString();
    if (json['price_variation'] != null) {
      priceVariation = <PriceVariationSearch>[];
      json['price_variation'].forEach((v) {
        priceVariation!.add(new PriceVariationSearch.fromJson(v));
      });
    }
    loyalty = json['loyalty'];
    netWeight = json['net_weight'];
    //price = json['price'];
    priority = json['priority'];
    if(json['type']=="1") {
      price = (IConstants.numberFormat == "1") ? double.parse(json['price'].toString())
          .toStringAsFixed(0) : double.parse(json['price'].toString())
          .toStringAsFixed(IConstants.decimaldigit);
    }
    // print("price..."+json['price'].toString());
    // print("price"+price.toString());
    priority = json['priority'];
    if(json['type']=="1") {
      mrp = (IConstants.numberFormat == "1") ? double.parse(json['mrp'].toString())
          .toStringAsFixed(0) : double.parse(json['mrp'].toString())
          .toStringAsFixed(IConstants.decimaldigit);
    }
    stock = json['stock'];
    maxItem = json['max_item'].toString();
    minItem = json['min_item'].toString();
    weight = json['weight'];
    membershipPrice = json['membership_price'];
    loyaltys = json['loyaltys'];
    quantity = json['quantity'];
    increament = json['increament'];
    status = json['status'];
    singleshortNote = json['singleshortNote'];
    paymentMode = json['payment_mode'];
    if(json['type']=="1") {
      if (json['price'] <= 0 || json['price'] == "" ||
          json['price'] == json['mrp']) {
        discointDisplay = false;
      } else {
        discointDisplay = true;
      }
    }
    if(json['type']=="1") {
      if (json['membership_price'] == '-' || json['membership_price'] == "0" ||
          json['membership_price'] == json['mrp']
          || json['membership_price'] == json['price']) {
        membershipDisplay = false;
      } else {
        membershipDisplay = true;
      }
    }
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menu_item_count'] = this.menuItemCount;
    data['branch_id'] = this.branchId;
    data['shop'] = this.shop;
    if (this.addon != null) {
      data['addon'] = this.addon!.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    data['eligible_for_express'] = this.eligibleForExpress;
    data['delivery_duration'] = this.deliveryDuration;
    data['eligible_for_subscription'] = this.eligibleForSubscription;
    if (this.subscriptionSlot != null) {
      data['subscription_slot'] =
          this.subscriptionSlot!.map((v) => v.toJson()).toList();
    }
    data['category_id'] = this.categoryId;
    data['category'] = this.category;
    data['item_name'] = this.itemName;
    data['veg_type'] = this.vegType;
    data['item_featured_image'] = this.itemFeaturedImage;
    data['sale_price'] = this.salePrice;
    data['is_active'] = this.isActive;
    data['sales_tax'] = this.salesTax;
    data['item_description'] = this.itemDescription;
    data['brand'] = this.brand;
    data['type'] = this.type;
    if (this.priceVariation != null) {
      data['price_variation'] =
          this.priceVariation!.map((v) => v.toJson()).toList();
    }
    data['loyalty'] = this.loyalty;
    data['net_weight'] = this.netWeight;
    data['price'] = this.price;
    data['priority'] = this.priority;
    data['mrp'] = this.mrp;
    data['stock'] = this.stock;
    data['max_item'] = this.maxItem;
    data['min_item'] = this.minItem;
    data['weight'] = this.weight;
    data['membership_price'] = this.membershipPrice;
    data['loyaltys'] = this.loyaltys;
    data['quantity'] = this.quantity;
    data['increament'] = this.increament;
    data['status'] = this.status;
    data['singleshortNote'] = this.singleshortNote;
    data['payment_mode'] = this.paymentMode;
    data['unit'] = this.unit;
    return data;
  }
}

class PriceVariationSearch {
  List<Addon>? addon;
  int? loyalty;
  String? netWeight;
  String? id;
  String? menuItemId;
  String? variationName;
  String? price;
  String? priority;
  String? mrp;
  int? stock;
  String? maxItem;
  String? status;
  String? minItem;
  double? membershipPrice;
  List<ImageDate>? images;
  String? weight;
  String? unit;
  int? loyaltys;
  String? quantity;
  bool? discointDisplay = false;
  bool? membershipDisplay = false;
  String? mode;

  PriceVariationSearch(
      {this.addon,
        this.loyalty,
        this.netWeight,
        this.id,
        this.menuItemId,
        this.variationName,
        this.price,
        this.priority,
        this.mrp,
        this.stock,
        this.maxItem,
        this.status,
        this.minItem,
        this.membershipPrice,
        this.images,
        this.weight,
        this.unit,
        this.loyaltys,
        this.quantity,
        this.membershipDisplay,
        this.discointDisplay,
        this.mode,});

  PriceVariationSearch.fromJson(Map<String, dynamic> json) {
    if (json['addon'] != null) {
      addon = <Addon>[];
      json['addon'].forEach((v) {
        addon!.add(new Addon.fromJson(v));
      });
    }
    variationName = json['variation_name'];
    loyalty = json['loyalty'];
    netWeight = json['net_weight'];
    id = json['id'];
    menuItemId = json['menu_item_id'];
    price = (IConstants.numberFormat == "1")?double.parse(json['price'].toString()).toStringAsFixed(0):double.parse(json['price'].toString()).toStringAsFixed(IConstants.decimaldigit);
    priority = json['priority'];
    mrp = (IConstants.numberFormat == "1")?double.parse(json['mrp'].toString()).toStringAsFixed(0):double.parse(json['mrp'].toString()).toStringAsFixed(IConstants.decimaldigit);
    stock = json['stock'];
    maxItem = json['max_item'];
    status = json['status'];
    minItem = json['min_item'];
    membershipPrice = json['membership_price'];
    if (json['images'] != null) {
      images = <ImageDate>[];
      json['images'].forEach((v) {
        images!.add(new ImageDate.fromJson(v));
      });
    }
    if(json['price'] <= 0 || json['price'] == "" || json['price'] == json['mrp']){
      discointDisplay = false;
    } else {
      discointDisplay = true;
    }
    if(json['membership_price'] == '-' || json['membership_price'] == "0" || json['membership_price'] == json['mrp']
        || json['membership_price'] == json['price']) {
      membershipDisplay = false;
    } else {
      membershipDisplay = true;
    }
    mode= json['mode'];
    weight = json['weight'];
    unit = json['unit'];
    loyaltys = json['loyaltys'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.addon != null) {
      data['addon'] = this.addon!.map((v) => v.toJson()).toList();
    }
    data['loyalty'] = this.loyalty;
    data['net_weight'] = this.netWeight;
    data['id'] = this.id;
    data['menu_item_id'] = this.menuItemId;
    data['variation_name'] = this.variationName;
    data['price'] = this.price;
    data['priority'] = this.priority;
    data['mrp'] = this.mrp;
    data['stock'] = this.stock;
    data['max_item'] = this.maxItem;
    data['status'] = this.status;
    data['min_item'] = this.minItem;
    data['membership_price'] = this.membershipPrice;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    data['weight'] = this.weight;
    data['unit'] = this.unit;
    data['loyaltys'] = this.loyaltys;
    data['quantity'] = this.quantity;
    data['mode']=this.mode;
    return data;
  }
}