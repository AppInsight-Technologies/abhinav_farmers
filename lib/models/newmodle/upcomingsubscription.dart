import 'dart:convert';

import 'package:intl/intl.dart';

import '../../constants/IConstants.dart';
import '../../models/newmodle/subscription_data.dart';
import '../../repository/api.dart';

class UpcomingSubscriptionApi {
  Future<List<UpcomingSubscription>> getUpcomingSubscription(ParamBodyDataUpcomingbox? body)async {
    print("body params..."+body.toString());
    Api api = Api();
    api.body = body!.toJson();
    List<UpcomingSubscription> list =[];
    final resp = await api.Posturl("get-upcoming-subscription", isv2: false);
    print("upcoming subscription data...... $resp");
    json.decode(resp).asMap().forEach((index,val){
      list.add(UpcomingSubscription.fromJson(val));
    });
    return Future.value(list);
    //return Future.value(SubscriptionBox.fromJson(json.decode(resp)));
  }
}
final upcomingSubscriptionApi = UpcomingSubscriptionApi();

class ParamBodyDataUpcomingbox {
  String? branch;
  String? languageid;
  String? user;
  String? ref;

  ParamBodyDataUpcomingbox({this.branch, this.languageid, this.user ,this.ref});

  ParamBodyDataUpcomingbox.fromJson(Map<String, String> json) {
    branch = json['branch'];
    languageid = json['language_id'];
    user = json['user'];
    ref = json['ref'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['branch'] = this.branch!;
    data['language_id'] = this.languageid!;
    data['user'] = this.user!;
    data['ref'] = this.ref!;
    return data;
  }
}

class UpcomingSubscription {
  String? date;
  List<UpcomingData>? data;

  UpcomingSubscription({this.date, this.data});

  UpcomingSubscription.fromJson(Map<String, dynamic> json) {
    String dates = json['date'].toString();
    final f = new DateFormat('yyyy-MM-dd');
    var parsedDate = f.parse(dates.trim());
    date = DateFormat('d MMM, EEE').format(parsedDate).toString();//(DateFormat('d MMM, EEE').format(json['date'])).toString() ;
    if (json['data'] != null) {
      data = <UpcomingData>[];
      json['data'].forEach((v) {
        data!.add(new UpcomingData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date ;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UpcomingData {
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
  int? price;
  String? priority;
  int? mrp;
  int? stock;
  String? maxItem;
  String? minItem;
  String? weight;
  int? membershipPrice;
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

  UpcomingData(
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

  UpcomingData.fromJson(Map<String, dynamic> json) {
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
    categoryId = json['category_id'];
    itemName = json['item_name'];
    vegType = json['veg_type'];
    itemFeaturedImage = IConstants.API_IMAGE + "items/images/"+ json['item_featured_image'];
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
    maxItem = json['max_item'].toString();
    minItem = json['min_item'].toString();
    weight = json['weight'];
    membershipPrice = json['membership_price'];
    unit = json['unit'];
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