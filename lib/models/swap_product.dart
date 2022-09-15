import 'package:flutter/cupertino.dart';
import '../constants/IConstants.dart';
import '../constants/features.dart';

class SwapProduct {
  String? eligibleForExpress;
  List<DeliveryDuration>? deliveryDuration;
  String? eligibleForSubscription;
  List<SubscriptionSlot>? subscriptionSlot;
  String? paymentMode;
  String? id;
  String? categoryId;
  String? delivery;
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
  int? replacement;
  List<PriceVariation>? priceVariation;

  SwapProduct(
      {
        this.eligibleForExpress,
        this.deliveryDuration,
        this.eligibleForSubscription,
        this.subscriptionSlot,
        this.paymentMode,
        this.id,
        this.categoryId,
        this.delivery,
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
        this.replacement,
        this.priceVariation});

  SwapProduct.fromJson(Map<String, dynamic> json) {
    eligibleForExpress = Features.isExpressDelivery ? Features.isSplit ? json['eligible_for_express'] : "0" : "1";
    if (json['delivery_duration'] != null) {
      deliveryDuration = <DeliveryDuration>[];
      if(json['delivery_duration'] == "slot" || json['delivery_duration'] == ""){
        debugPrint("delivery duration... slot");
        deliveryDuration!.add(new DeliveryDuration.fromJson(DeliveryDuration(note: "",duration: "",durationType: "").toJson()));
      }else {
        debugPrint("delivery duration... not slot");
        json['delivery_duration'].forEach((v) {
          deliveryDuration!.add(new DeliveryDuration.fromJson(v));
        });
      }
    }

    eligibleForSubscription = json['eligible_for_subscription'];
    if (json['subscription_slot'] != null) {
      subscriptionSlot = <SubscriptionSlot>[];
      if(json['subscription_slot'].isEmpty ){
        debugPrint("empty....");
        subscriptionSlot!.add(new SubscriptionSlot.fromJson(SubscriptionSlot(cronTime: "",deliveryTime: "").toJson()));
      }else {
        debugPrint("not empty....");
        json['subscription_slot'].forEach((v) {
          subscriptionSlot!.add(new SubscriptionSlot.fromJson(v));
        });
      }
    }
    paymentMode = json['payment_mode'];
    id = json['id'];
    categoryId = json['category_id'];
    delivery = (json['delivery'] ?? "");
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
    replacement = json['replacement'];
    if (json['price_variation'] != null) {
      priceVariation = <PriceVariation>[];
      json['price_variation'].forEach((v) {
        priceVariation!.add(new PriceVariation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eligible_for_express'] = this.eligibleForExpress;
    if (this.deliveryDuration != null) {
      data['delivery_duration'] =
          this.deliveryDuration!.map((v) => v.toJson()).toList();
    }
    data['eligible_for_subscription'] = this.eligibleForSubscription;
    if (this.subscriptionSlot != null) {
      data['subscription_slot'] =
          this.subscriptionSlot!.map((v) => v.toJson()).toList();
    }
    data['payment_mode'] = this.paymentMode;
    data['id'] = this.id;
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
    data['replacement'] = this.replacement;
    if (this.priceVariation != null) {
      data['price_variation'] =
          this.priceVariation!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class DeliveryDuration {
  String? id;
  String? durationType;
  String? duration;
  String? status;
  String? branch;
  String? note;

  DeliveryDuration(
      {this.id,
        this.durationType,
        this.duration,
        this.status,
        this.branch,
        this.note});

  DeliveryDuration.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    durationType = Features.isSplit ? json['durationType'] : "";
    duration = Features.isSplit ? json['duration'] : "";
    status = json['status'];
    branch = json['branch'];
    note = (json['note'] ?? "");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['durationType'] = this.durationType;
    data['duration'] = this.duration;
    data['status'] = this.status;
    data['branch'] = this.branch;
    data['note'] = this.note;
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

  SubscriptionSlot(
      {this.id,
        this.name,
        this.cronTime,
        this.deliveryTime,
        this.branch,
        this.status});

  SubscriptionSlot.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cronTime = (json['cronTime'] ?? "");
    deliveryTime = (json['deliveryTime'] ?? "");
    branch = json['branch'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['cronTime'] = this.cronTime;
    data['deliveryTime'] = this.deliveryTime;
    data['branch'] = this.branch;
    data['status'] = this.status;
    return data;
  }
}
class PriceVariation {
  String? id;
  String? netWeight;
  String? menuItemId;
  String? variationName;
  int? price;
  String? priority;
  int? mrp;
  int? stock;
  String? maxItem;
  String? status;
  String? minItem;
  String? weight;
  int? membershipPrice;
  String? unit;
  int? loyalty;
  List<String>? images;

  PriceVariation(
      {this.id,
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
        this.loyalty,
        this.images});

  PriceVariation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    netWeight = json['net_weight'];
    menuItemId = json['menu_item_id'];
    variationName = json['variation_name'];
    price = json['price'];
    priority = json['priority'];
    mrp = json['mrp'];
    stock = json['stock'];
    maxItem = json['max_item'];
    status = json['status'];
    minItem = json['min_item'];
    weight = json['weight'];
    membershipPrice = json['membership_price'];
    unit = json['unit'];
    loyalty = json['loyalty'];
    if (json['images'] != null) {
      images = <String>[];
      json['images'].forEach((v) {
        images!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    data['loyalty'] = this.loyalty;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v).toList();
    }
    return data;
  }
}
