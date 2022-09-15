
import 'dart:convert';
import '../../constants/IConstants.dart';
import '../../constants/features.dart';
import '../../models/newmodle/product_data.dart';

import '../../repository/api.dart';



class SubscriptionBoxApi{
  Future<List<Subscription>> getSubsctiptionBox(ParamBodyDatabox? body)async {
    Api api = Api();
    api.body = body!.toJson();
    List<Subscription> list =[];
    final resp = await api.Posturl("get-subscription-box", isv2: false);
    print("resp CustomerEngagementApi $resp");
    json.decode(resp).asMap().forEach((index,val){
      list.add(Subscription.fromJson(val));
    });
    return Future.value(list);
  }

  Future<List<SubscriptionBoxData>> getSubsctiptionBoxID(ParamBodyDatabox? body)async {
    print("body params..."+body.toString());
    Api api = Api();
    api.body = body!.toJson();
    List<SubscriptionBoxData> list =[];
    final resp = await api.Posturl("get-subscription-box-by-id", isv2: false);
    print("resp CustomerEngagementApi $resp");
    json.decode(resp).asMap().forEach((index,val){
      list.add(SubscriptionBoxData.fromJson(val));
    });
    return Future.value(list);
    //return Future.value(SubscriptionBox.fromJson(json.decode(resp)));
  }

  Future<List<SubscriptionBoxData>> getSubsctiptionBoxIDNew(ParamBodyDatabox? body)async {
    print("body params..."+body.toString());
    Api api = Api();
    api.body = body!.toJson();
    List<SubscriptionBoxData> list =[];
    final resp = await api.Posturl("get-subscription-box-by-id", isv2: false);
    print("resp CustomerEngagementApi $resp");
    json.decode(resp).asMap().forEach((index,val){
      list.add(SubscriptionBoxData.fromJson(val));
    });
    return Future.value(list);
    //return Future.value(SubscriptionBox.fromJson(json.decode(resp)));
  }
}

final subscriptionApibox = SubscriptionBoxApi();
class ParamBodyDatabox {
  String? type;
  String? branch;
  String? languageid;
  String? user;
  String? subscription_type;
  String? subscription_id;

  ParamBodyDatabox({this.type, this.branch, this.languageid, this.user ,this.subscription_type,this.subscription_id});

  ParamBodyDatabox.fromJson(Map<String, String> json) {
    type = json['type'];
    branch = json['branch'];
    languageid = json['language_id'];
    user = json['user'];
    subscription_type = json['subscription_type'];
    subscription_id = json['subscription_id'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['type'] = this.type!;
    data['branch'] = this.branch!;
    data['language_id'] = this.languageid!;
    data['user'] = this.user!;
    data['subscription_type'] = this.subscription_type!;
    data['subscription_id'] = this.subscription_id!;
    return data;
  }
}
class Subscription {
  String? id;
  String? boxName;
  String? boxPrice;
  String? boxCount;
  String? branch;
  String? ref;
  String? status;
  String? type;
  List<BoxProducts>? boxProducts;
  String? featuredImage;
  String? subscriptionType;
  String? subscriptionboxDescription;
  String? subscriptionBoxNote;
  List<SubscriptionSlot>? subscriptionSlot;

  Subscription(
      {this.id,
        this.boxName,
        this.boxPrice,
        this.boxCount,
        this.branch,
        this.ref,
        this.status,
        this.type,
        this.boxProducts,
        this.featuredImage,
        this.subscriptionType,
        this.subscriptionboxDescription,
        this.subscriptionBoxNote,
        this.subscriptionSlot});

  Subscription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    boxName = json['boxName'];
    boxPrice = json['boxPrice'];
    boxCount = json['boxCount'];
    branch = json['branch'];
    ref = json['ref'];
    status = json['status'];
    type = json['type'];
    if (json['box_products'] != null) {
      boxProducts = <BoxProducts>[];
      json['box_products'].forEach((v) {
        boxProducts!.add(new BoxProducts.fromJson(v));
      });
    }
    featuredImage = IConstants.API_IMAGE + json['featuredImage'];
    subscriptionType = json['subscriptionType'];
    subscriptionboxDescription = json['subscriptionboxDescription'];
    subscriptionBoxNote = json['subscriptionBoxNote'];
    if (json['subscription_slot'] != null) {
      subscriptionSlot = <SubscriptionSlot>[];
      json['subscription_slot'].forEach((v) {
        subscriptionSlot!.add(new SubscriptionSlot.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['boxName'] = this.boxName;
    data['boxPrice'] = this.boxPrice;
    data['boxCount'] = this.boxCount;
    data['branch'] = this.branch;
    data['ref'] = this.ref;
    data['status'] = this.status;
    data['type'] = this.type;
    if (this.boxProducts != null) {
      data['box_products'] = this.boxProducts!.map((v) => v.toJson()).toList();
    }
    data['featuredImage'] = this.featuredImage;
    data['subscriptionType'] = this.subscriptionType;
    data['subscriptionboxDescription'] = this.subscriptionboxDescription;
    data['subscriptionBoxNote'] = this.subscriptionBoxNote;
    if (this.subscriptionSlot != null) {
      data['subscription_slot'] =
          this.subscriptionSlot!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BoxProducts {
  String? id;
  String? date;
  List<DateItems>? dateItems;

  BoxProducts({this.id, this.date, this.dateItems});

  BoxProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    if (json['date_items'] != null) {
      dateItems = <DateItems>[];
      json['date_items'].forEach((v) {
        dateItems!.add(new DateItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    if (this.dateItems != null) {
      data['date_items'] = this.dateItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DateItems {
  String? id;
  String? date;
  String? label;
  List<Product>? product;

  DateItems({this.id, this.date, this.label, this.product});

  DateItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    label = json['label'];
    if (json['product'] != null) {
      product = <Product>[];
      json['product'].forEach((v) {
        product!.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['label'] = this.label;
    if (this.product != null) {
      data['product'] = this.product!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  String? manufacturerDescription;
  String? itemDescription;
  List<Addon>? addon;
  String? id;
  String? eligibleForExpress;
  String? deliveryDuration;
  String? eligibleForSubscription;
  List<SubscriptionSlot>? subscriptionSlot;
  String? categoryId;
  String? itemName;
  String? vegType;
  String? itemFeaturedImage;
  String? regularPrice;
  String? salePrice;
  String? isActive;
  String? salesTax;
  String? totalQty;
  String? brand;
  String? type;
  List<PriceVariation>? priceVariation;


  int? loyalty;
  String? netWeight;
  String? price;
  String? priority;
  String? mrp;
  int? stock;
  String? maxItem;
  String? minItem;
  String? weight;
  String? membershipPrice;
  String? unit;
  int? loyaltys;
  String? quantity;
  String? increament;
  String? status;
  String? singleshortNote;
  List<Reviews>? reviews;
  int? rating;
  String? reviewDate;
  int? ratingCount;
  String? paymentMode;
  String? duration;
  String? itemSlug;
  String? item_description;
  String? manufacturer_description;
  int? replacement;
  String? delivery;
  String? mode;
  String? membershipId;

  bool? discointDisplay = false;
  bool? membershipDisplay = false;


  Product(
      {this.manufacturerDescription,
        this.itemDescription,
        this.addon,
        this.id,
        this.eligibleForExpress,
        this.deliveryDuration,
        this.eligibleForSubscription,
        this.subscriptionSlot,
        this.categoryId,
        this.itemName,
        this.vegType,
        this.itemFeaturedImage,
        this.regularPrice,
        this.salePrice,
        this.isActive,
        this.salesTax,
        this.totalQty,
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
        this.unit,
        this.loyaltys,
        this.quantity,
        this.increament,
        this.status,
        this.singleshortNote,
        this.reviews,
        this.rating,
        this.reviewDate,
        this.ratingCount});

  Product.fromJson(Map<String, dynamic> json) {

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

    paymentMode = json['payment_mode'];
    duration = json['duration'];
    categoryId = json['category_id'];
    itemName = json['item_name'];
    itemSlug = json['item_slug'];
    vegType = json['veg_type'];
    itemFeaturedImage = (json['item_featured_image']==null||json['item_featured_image']==[])?"" : IConstants.API_IMAGE + "items/images/" +json['item_featured_image'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    isActive = json['is_active'];
    salesTax = json['sales_tax'];
    totalQty = json['total_qty'];
    replacement = json['replacement'];
    brand = json['brand'];
    item_description = json['item_description'];
    manufacturer_description = json['manufacturer_description'];
    type = json['type'];
    delivery = (json['delivery']??"0");
    mode=(json['mode']??"0");
    loyalty = json['loyalty'];
    netWeight = json['net_weight'];
    if(json['type']=="1") {
      price = (IConstants.numberFormat == "1") ? double.parse(json['price'].toString())
          .toStringAsFixed(0) : double.parse(json['price'].toString())
          .toStringAsFixed(IConstants.decimaldigit);
    }

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
    if(json['type']=="1") {
      membershipPrice = (IConstants.numberFormat == "1") ? double.parse(
          json['membership_price'].toString()).toStringAsFixed(0) : double
          .parse(json['membership_price'].toString()).toStringAsFixed(
          IConstants.decimaldigit);
    }
    unit = json['unit']??"";
    loyaltys = json['loyaltys'];
    quantity = json['quantity'];
    increament = json['increament']??"1";
    status = json['status'];
    if(json['type']=="1") {
      if (json['price'] <= 0 || json['price'] == "" ||
          json['price'] == json['mrp']) {
        discointDisplay = false;
      } else {
        discointDisplay = true;
      }
    }

    if(json['type']=="1") {
      if (json['membership_price'] == '-' || json['membership_price'] == 0 ||
          json['membership_price'] == json['mrp']
          || json['membership_price'] == json['price']) {
        membershipDisplay = false;
      } else {
        membershipDisplay = true;
      }
    }
    singleshortNote = json['singleshortNote']??"";
    if(json['type']=="0") {
      if (json['price_variation'] != null) {
        priceVariation = <PriceVariation>[];
        json['price_variation'].forEach((v) {
          v.addAll({
            "type": type
          });
          priceVariation!.add(new PriceVariation.fromJson(v));
        });
      }
    }
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) { reviews!.add(new Reviews.fromJson(v)); });
    }
    reviewDate = (json['review_date'] == ""|| json['review_date'] ==null) ?"":json['review_date'] ;
    ratingCount =  (json['rating_count'] == ""|| json['rating_count'] ==null) ?0:json['rating_count'] ;


    manufacturerDescription = json['manufacturer_description'];
    itemDescription = json['item_description'];

    rating = json['rating'];
    reviewDate = json['review_date'];
    ratingCount = json['rating_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['manufacturer_description'] = this.manufacturerDescription;
    data['item_description'] = this.itemDescription;
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
    data['item_name'] = this.itemName;
    data['veg_type'] = this.vegType;
    data['item_featured_image'] = this.itemFeaturedImage;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['is_active'] = this.isActive;
    data['sales_tax'] = this.salesTax;
    data['total_qty'] = this.totalQty;
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
    data['unit'] = this.unit;
    data['loyaltys'] = this.loyaltys;
    data['quantity'] = this.quantity;
    data['increament'] = this.increament;
    data['status'] = this.status;
    data['singleshortNote'] = this.singleshortNote;
    if (this.reviews != null) {
      data['reviews'] = this.reviews!.map((v) => v.toJson()).toList();
    }
    data['rating'] = this.rating;
    data['review_date'] = this.reviewDate;
    data['rating_count'] = this.ratingCount;
    return data;
  }
}

class SubscriptionSlot {
  String? id;
  String? name;
  String? cronTime;
  String? deliveryTime;
  String? branch;
  String? status;
  String? daily;
  String? dailyDays;
  String? weekend;
  String? weekendDays;
  String? weekday;
  String? weekdayDays;
  String? custom;
  String? customDays;
  String? ref;
  String? deliveries;
  String? alternateDays;

  SubscriptionSlot(
      {this.id,
        this.name,
        this.cronTime,
        this.deliveryTime,
        this.branch,
        this.status,
        this.daily,
        this.dailyDays,
        this.weekend,
        this.weekendDays,
        this.weekday,
        this.weekdayDays,
        this.custom,
        this.customDays,
        this.ref,
        this.deliveries,
        this.alternateDays});

  SubscriptionSlot.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cronTime = json['cronTime'];
    deliveryTime = json['deliveryTime'];
    branch = json['branch'];
    status = json['status'];
    daily = json['daily'];
    dailyDays = json['dailyDays'];
    weekend = json['weekend'];
    weekendDays = json['weekendDays'];
    weekday = json['weekday'];
    weekdayDays = json['weekdayDays'];
    custom = json['custom'];
    customDays = json['customDays'];
    ref = json['ref'];
    deliveries = json['deliveries'];
    alternateDays = json['alternate_days'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['cronTime'] = this.cronTime;
    data['deliveryTime'] = this.deliveryTime;
    data['branch'] = this.branch;
    data['status'] = this.status;
    data['daily'] = this.daily;
    data['dailyDays'] = this.dailyDays;
    data['weekend'] = this.weekend;
    data['weekendDays'] = this.weekendDays;
    data['weekday'] = this.weekday;
    data['weekdayDays'] = this.weekdayDays;
    data['custom'] = this.custom;
    data['customDays'] = this.customDays;
    data['ref'] = this.ref;
    data['deliveries'] = this.deliveries;
    data['alternate_days'] = this.alternateDays;
    return data;
  }
}

class PriceVariation {
  int? loyalty;
  String? id;
  String? netWeight;
  String? menuItemId;
  String? variationName;
  double? price;
  String? priority;
  double? mrp;
  int? stock;
  String? maxItem;
  String? status;
  String? minItem;
  String? weight;
  double? membershipPrice;
  String? unit;
  int? loyaltys;
  List<ImageDate>? images;
  String? quantity;
  bool? discointDisplay = false;
  bool? membershipDisplay = false;

  PriceVariation(
      {this.loyalty,
        this.id,
        this.netWeight,
        this.menuItemId,
        this.variationName,
        this.price,
        this.priority,
        this.mrp,
        this.stock,
        this.maxItem,
        this.status,
        this.minItem,
        this.weight,
        this.membershipPrice,
        this.unit,
        this.loyaltys,
        this.images,
        this.quantity,
        this.membershipDisplay,
        this.discointDisplay,});

  PriceVariation.fromJson(Map<String, dynamic> json) {
    loyalty = json['loyalty'];
    id = json['id'];
    netWeight = json['net_weight'];
    menuItemId = json['menu_item_id'];
    variationName = json['variation_name'];
    price = (json['price'] as num).toDouble();
    priority = json['priority'];
    mrp = (json['mrp'] as num).toDouble();
    stock = json['stock'];
    maxItem = json['max_item'];
    status = json['status'];
    minItem = json['min_item'];
    weight = json['weight'];
    membershipPrice = (json['membership_price'] as num).toDouble();
    unit = json['unit'];
    loyaltys = json['loyaltys'];
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
    if(json['membership_price'] == '-' || double.parse(json['membership_price'].toString()) <= 0 || json['membership_price'] == json['mrp']
        || json['membership_price'] == json['price']) {
      membershipDisplay = false;
    } else {
      membershipDisplay = true;
    }
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['loyalty'] = this.loyalty;
    data['id'] = this.id;
    data['net_weight'] = this.netWeight;
    data['menu_item_id'] = this.menuItemId;
    data['variation_name'] = this.variationName;
    data['price'] = this.price;
    data['priority'] = this.priority;
    data['mrp'] = this.mrp;
    data['stock'] = this.stock;
    data['max_item'] = this.maxItem;
    data['status'] = this.status;
    data['min_item'] = this.minItem;
    data['weight'] = this.weight;
    data['membership_price'] = this.membershipPrice;
    data['unit'] = this.unit;
    data['loyaltys'] = this.loyaltys;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    data['quantity'] = this.quantity;
    return data;
  }

}


class Addon {
  String? status;
  String? type;
  String? id;
  String? name;
  String? branch;
  String? date;
  List<Box>? list;

  Addon(
      {this.status,
        this.type,
        this.id,
        this.name,
        this.branch,
        this.date,
        this.list});

  Addon.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    type = json['type'];
    id = json['id'];
    name = json['name'];
    branch = json['branch'];
    date = json['date'];
    if (json['list'] != null) {
      list = <Box>[];
      json['list'].forEach((v) {
        list!.add(new Box.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['type'] = this.type;
    data['id'] = this.id;
    data['name'] = this.name;
    data['branch'] = this.branch;
    data['date'] = this.date;
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Box {
  String? id;
  String? ref;
  String? name;
  String? price;
  String? status;

  Box({this.id, this.ref, this.name, this.price, this.status});

  Box.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ref = json['ref'];
    name = json['name'];
    price = json['price'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ref'] = this.ref;
    data['name'] = this.name;
    data['price'] = this.price;
    data['status'] = this.status;
    return data;
  }
}
//
// class SubscriptionSlot {
//   String? id;
//   String? name;
//   String? cronTime;
//   String? deliveryTime;
//   String? branch;
//   String? status;
//   String? daily;
//   String? dailyDays;
//   String? weekend;
//   String? weekendDays;
//   String? weekday;
//   String? weekdayDays;
//   String? custom;
//   String? customDays;
//   String? ref;
//   String? deliveries;
//
//   SubscriptionSlot(
//       {this.id,
//         this.name,
//         this.cronTime,
//         this.deliveryTime,
//         this.branch,
//         this.status,
//         this.daily,
//         this.dailyDays,
//         this.weekend,
//         this.weekendDays,
//         this.weekday,
//         this.weekdayDays,
//         this.custom,
//         this.customDays,
//         this.ref,
//         this.deliveries});
//
//   SubscriptionSlot.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     cronTime = json['cronTime'];
//     deliveryTime = json['deliveryTime'];
//     branch = json['branch'];
//     status = json['status'];
//     daily = json['daily'];
//     dailyDays = json['dailyDays'];
//     weekend = json['weekend'];
//     weekendDays = json['weekendDays'];
//     weekday = json['weekday'];
//     weekdayDays = json['weekdayDays'];
//     custom = json['custom'];
//     customDays = json['customDays'];
//     ref = json['ref'];
//     deliveries = json['deliveries'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['cronTime'] = this.cronTime;
//     data['deliveryTime'] = this.deliveryTime;
//     data['branch'] = this.branch;
//     data['status'] = this.status;
//     data['daily'] = this.daily;
//     data['dailyDays'] = this.dailyDays;
//     data['weekend'] = this.weekend;
//     data['weekendDays'] = this.weekendDays;
//     data['weekday'] = this.weekday;
//     data['weekdayDays'] = this.weekdayDays;
//     data['custom'] = this.custom;
//     data['customDays'] = this.customDays;
//     data['ref'] = this.ref;
//     data['deliveries'] = this.deliveries;
//     return data;
//   }
// }
//
// class PriceVariation {
//   int? loyalty;
//   String? id;
//   String? netWeight;
//   String? menuItemId;
//   String? variationName;
//   double? price;
//   String? priority;
//   int? mrp;
//   int? stock;
//   String? maxItem;
//   String? status;
//   String? minItem;
//   String? weight;
//   int? membershipPrice;
//   String? unit;
//   int? loyaltys;
//   List<ImageDate>? images;
//   String? quantity;
//
//   PriceVariation(
//       {this.loyalty,
//         this.id,
//         this.netWeight,
//         this.menuItemId,
//         this.variationName,
//         this.price,
//         this.priority,
//         this.mrp,
//         this.stock,
//         this.maxItem,
//         this.status,
//         this.minItem,
//         this.weight,
//         this.membershipPrice,
//         this.unit,
//         this.loyaltys,
//         this.images,
//         this.quantity});
//
//   PriceVariation.fromJson(Map<String, dynamic> json) {
//     loyalty = json['loyalty'];
//     id = json['id'];
//     netWeight = json['net_weight'];
//     menuItemId = json['menu_item_id'];
//     variationName = json['variation_name'];
//     price = (json['price'] as num).toDouble();
//     priority = json['priority'];
//     mrp = json['mrp'];
//     stock = json['stock'];
//     maxItem = json['max_item'];
//     status = json['status'];
//     minItem = json['min_item'];
//     weight = json['weight'];
//     membershipPrice = json['membership_price'];
//     unit = json['unit'];
//     loyaltys = json['loyaltys'];
//     if (json['images'] != null) {
//       images = <ImageDate>[];
//       json['images'].forEach((v) {
//         images!.add(new ImageDate.fromJson(v));
//       });
//     }
//     quantity = json['quantity'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['loyalty'] = this.loyalty;
//     data['id'] = this.id;
//     data['net_weight'] = this.netWeight;
//     data['menu_item_id'] = this.menuItemId;
//     data['variation_name'] = this.variationName;
//     data['price'] = this.price;
//     data['priority'] = this.priority;
//     data['mrp'] = this.mrp;
//     data['stock'] = this.stock;
//     data['max_item'] = this.maxItem;
//     data['status'] = this.status;
//     data['min_item'] = this.minItem;
//     data['weight'] = this.weight;
//     data['membership_price'] = this.membershipPrice;
//     data['unit'] = this.unit;
//     data['loyaltys'] = this.loyaltys;
//     if (this.images != null) {
//       data['images'] = this.images!.map((v) => v.toJson()).toList();
//     }
//     data['quantity'] = this.quantity;
//     return data;
//   }
//
// }
class ImageDate {
  String? id;
  String? image;
  String? ref;

  ImageDate({this.id, this.image, this.ref});

  ImageDate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image =  IConstants.API_IMAGE+"items/images/" +json['image'];
    ref = json['ref'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['ref'] = this.ref;
    return data;
  }
}

class Reviews {
  String? comment;
  String? user;
  String? purchased_verified;

  Reviews({this.comment, this.user, this.purchased_verified});

  Reviews.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
    user = json['user'];
    purchased_verified = json['purchased_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment'] = this.comment;
    data['user'] = this.user;
    data['purchased_verified']= this.purchased_verified;
    return data;
  }
}



class SubscriptionBox {
  int? status;
  List<SubscriptionBoxData>? data;

  SubscriptionBox({this.status, this.data});

  SubscriptionBox.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <SubscriptionBoxData>[];
      json['data'].forEach((v) {
        data!.add(new SubscriptionBoxData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubscriptionBoxData {
  String? id;
  String? boxName;
  String? boxPrice;
  String? boxCount;
  String? branch;
  String? ref;
  String? status;
  String? type;
  List<BoxProduct>? boxProducts;
  String? featuredImage;
  String? subscriptionType;
  String? subscriptionboxDescription;
  String? subscriptionBoxNote;
  List<SubscriptionSlot>? subscriptionSlot;

  SubscriptionBoxData(
      {this.id,
        this.boxName,
        this.boxPrice,
        this.boxCount,
        this.branch,
        this.ref,
        this.status,
        this.type,
        this.boxProducts,
        this.featuredImage,
        this.subscriptionType,
        this.subscriptionboxDescription,
        this.subscriptionBoxNote,
        this.subscriptionSlot});

  SubscriptionBoxData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    boxName = json['boxName'];
    boxPrice = json['boxPrice'];
    boxCount = json['boxCount'];
    branch = json['branch'];
    ref = json['ref'];
    status = json['status'];
    type = json['type'];
    if (json['box_products'] != null) {
      boxProducts = <BoxProduct>[];
      json['box_products'].forEach((v) {
        boxProducts!.add(new BoxProduct.fromJson(v));
      });
    }
    featuredImage = IConstants.API_IMAGE + "items/images/" +json['featuredImage'];
    subscriptionType = json['subscriptionType'];
    subscriptionboxDescription = json['subscriptionboxDescription'];
    subscriptionBoxNote = json['subscriptionBoxNote'];
    if (json['subscription_slot'] != null) {
      subscriptionSlot = <SubscriptionSlot>[];
      json['subscription_slot'].forEach((v) {
        subscriptionSlot!.add(new SubscriptionSlot.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['boxName'] = this.boxName;
    data['boxPrice'] = this.boxPrice;
    data['boxCount'] = this.boxCount;
    data['branch'] = this.branch;
    data['ref'] = this.ref;
    data['status'] = this.status;
    data['type'] = this.type;
    if (this.boxProducts != null) {
      data['box_products'] = this.boxProducts!.map((v) => v.toJson()).toList();
    }
    data['featuredImage'] = this.featuredImage;
    data['subscriptionType'] = this.subscriptionType;
    data['subscriptionboxDescription'] = this.subscriptionboxDescription;
    data['subscriptionBoxNote'] = this.subscriptionBoxNote;
    if (this.subscriptionSlot != null) {
      data['subscription_slot'] =
          this.subscriptionSlot!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class BoxProduct {
  String? id;
  String? label;
  List<Products>? products;

  BoxProduct({this.id, this.label, this.products});

  BoxProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['label'] = this.label;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class Products {
  String? manufacturerDescription;
  String? itemDescription;
  List<Addon>? addon;
  String? id;
  String? eligibleForExpress;
  String? deliveryDuration;
  String? eligibleForSubscription;
  List<SubscriptionSlot>? subscriptionSlot;
  String? paymentMode;
  String? duration;
  String? categoryId;
  String? itemName;
  String? itemSlug;
  String? vegType;
  String? itemFeaturedImage;
  String? regularPrice;
  String? salePrice;
  String? isActive;
  String? salesTax;
  String? totalQty;
  String? brand;
  String? type;
  List<PriceVariation>? priceVariation;
  int? loyalty;
  String? netWeight;
  int? price;
  String? priority;
  int? mrp;
  int? stock;
  int? maxItem;
  int? minItem;
  String? weight;
  int? membershipPrice;
  int? loyaltys;
  String? quantity;
  String? increament;
  String? status;
  String? singleshortNote;
  List<Reviews>? reviews;
  int? rating;
  String? reviewDate;
  int? ratingCount;
  bool? discointDisplay = false;
  bool? membershipDisplay = false;

  Products(
      {this.manufacturerDescription,
        this.itemDescription,
        this.addon,
        this.id,
        this.eligibleForExpress,
        this.deliveryDuration,
        this.eligibleForSubscription,
        this.subscriptionSlot,
        this.paymentMode,
        this.duration,
        this.categoryId,
        this.itemName,
        this.itemSlug,
        this.vegType,
        this.itemFeaturedImage,
        this.regularPrice,
        this.salePrice,
        this.isActive,
        this.salesTax,
        this.totalQty,
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
        this.reviews,
        this.rating,
        this.reviewDate,
        this.ratingCount,
      this.membershipDisplay,
      this.discointDisplay});

  Products.fromJson(Map<String, dynamic> json) {
    manufacturerDescription = json['manufacturer_description'];
    itemDescription = json['item_description'];
    if (json['addon'] != null) {
      addon = <Addon>[];
      json['addon'].forEach((v) {
        addon!.add(new Addon.fromJson(v));
      });
    }
    id = json['id'];
    eligibleForExpress = json['eligible_for_express'];
    deliveryDuration = json['delivery_duration'];
    eligibleForSubscription = json['eligible_for_subscription'];
    if (json['subscription_slot'] != null) {
      subscriptionSlot = <SubscriptionSlot>[];
      json['subscription_slot'].forEach((v) {
        subscriptionSlot!.add(new SubscriptionSlot.fromJson(v));
      });
    }
    if(json['type']=="1") {
      if (json['price'] <= 0 || json['price'] == "" ||
          json['price'] == json['mrp']) {
        discointDisplay = false;
      } else {
        discointDisplay = true;
      }
    }

    if(json['type']=="1") {
      if (json['membership_price'] == '-' || json['membership_price'] == 0 ||
          json['membership_price'] == json['mrp']
          || json['membership_price'] == json['price']) {
        membershipDisplay = false;
      } else {
        membershipDisplay = true;
      }
    }
    paymentMode = json['payment_mode'];
    duration = json['duration'];
    categoryId = json['category_id'];
    itemName = json['item_name'];
    itemSlug = json['item_slug'];
    vegType = json['veg_type'];
    itemFeaturedImage = IConstants.API_IMAGE + "items/images/" + json['item_featured_image'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    isActive = json['is_active'];
    salesTax = json['sales_tax'];
    totalQty = json['total_qty'];
    brand = json['brand'];
    type = json['type'];
    if (json['price_variation'] != null) {
      priceVariation = <PriceVariation>[];
      json['price_variation'].forEach((v) {
        priceVariation!.add(new PriceVariation.fromJson(v));
      });
    }
    loyalty = json['loyalty'];
    netWeight = json['net_weight'];
    price = json['price'];
    priority = json['priority'];
    mrp = json['mrp'];
    stock = json['stock'];
    maxItem = int.parse(json['max_item'].toString());
    minItem = int.parse(json['min_item'].toString());
    weight = json['weight'];
    membershipPrice = json['membership_price'];
    loyaltys = json['loyaltys'];
    quantity = json['quantity'];
    increament = json['increament'];
    status = json['status'];
    singleshortNote = json['singleshortNote'];
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(new Reviews.fromJson(v));
      });
    }
    rating = json['rating'];
    reviewDate = json['review_date'];
    ratingCount = json['rating_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['manufacturer_description'] = this.manufacturerDescription;
    data['item_description'] = this.itemDescription;
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
    data['payment_mode'] = this.paymentMode;
    data['duration'] = this.duration;
    data['category_id'] = this.categoryId;
    data['item_name'] = this.itemName;
    data['item_slug'] = this.itemSlug;
    data['veg_type'] = this.vegType;
    data['item_featured_image'] = this.itemFeaturedImage;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['is_active'] = this.isActive;
    data['sales_tax'] = this.salesTax;
    data['total_qty'] = this.totalQty;
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
    if (this.reviews != null) {
      data['reviews'] = this.reviews!.map((v) => v.toJson()).toList();
    }
    data['rating'] = this.rating;
    data['review_date'] = this.reviewDate;
    data['rating_count'] = this.ratingCount;
    return data;
  }
}





