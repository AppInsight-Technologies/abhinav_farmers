import 'package:flutter/cupertino.dart';
import 'package:grocbay/constants/features.dart';

class CartItem {
  String? restaurantName;
  String? id;
  String? eligibleForExpress;
  String? durationType;
  String? duration;
  String? user;
  String? varId;
  String? quantity;
  String? createdDate;
  String? time;
  String? price;
  String? status;
  String? branch;
  String? itemId;
  String? varName;
  String? varMinItem;
  String? varMaxItem;
  String? itemLoyalty;
  String? varStock;
  String? varMrp;
  String? itemName;
  String? membershipPrice;
  String? itemActualprice;
  String? itemImage;
  String? membershipId;
  String? mode;
  String? type;
  String? delivery;
  String? vegType;
  String? note;
  String? addOn;
  String? weight;
  String? increment;

  String? unit;
  List<Offer>? offer;
  List<Toppings>? toppings_data = [];
  String? parent_id;
  String? toppings;
  String? toppingsId;

  CartItem(
      {
        this.restaurantName,
        this.id,
        this.eligibleForExpress,
        this.durationType,
        this.duration,
        this.user,
        this.varId,
        this.quantity,
        this.createdDate,
        this.time,
        this.price,
        this.status,
        this.branch,
        this.itemId,
        this.varName,
        this.varMinItem,
        this.varMaxItem,
        this.itemLoyalty,
        this.varStock,
        this.varMrp,
        this.itemName,
        this.membershipPrice,
        this.itemActualprice,
        this.itemImage,
        this.membershipId,
        this.mode,
        this.type,
        this.vegType,
        this.note,
        this.addOn,
        this.delivery,
        this.weight,
        this.offer,
        this.increment,
        this.unit,
        this.toppings_data,
        this.parent_id,
        this.toppings,
        this.toppingsId
      });

  CartItem.fromJson(Map<String, dynamic> json) {
    restaurantName = json['restaurant_name']??"";
    id = json['id'];
    eligibleForExpress = Features.isExpressDelivery? Features.isSplit? json['eligible_for_express'].toString() : "0" : "1";//json['eligible_for_express'].toString();
    durationType = Features.isSplit ? json['duration_type'].toString():"";
    duration = Features.isSplit ? json['duration'].toString():"";
    user = json['user'];
    varId = json['var_id'];
    quantity = json['quantity'];
    createdDate = json['created_date'];
    time = json['time'];
    price = json['price'].toString();
    status = (json['status']).toString();
    branch = json['branch'];
    itemId = json['itemId'];
    varName = json['varName'];
    varMinItem = json['varMinItem'];
    varMaxItem = json['varMaxItem'];
    itemLoyalty = json['itemLoyalty'];
    varStock = (json['varStock']).toString();
    varMrp = (json['varMrp']).toString();
    itemName = json['itemName'];
    membershipPrice = (json['membershipPrice']).toString();
    itemActualprice = (json['itemActualprice']).toString();
    itemImage = json['itemImage'];
    membershipId = json['membershipId'];
    mode = json['mode'];
    type = json['type'];
    vegType = json['veg_type'];
    note = json['note']??"";
    addOn = json['addon'];
    delivery=json['delivery'];
    weight =json['weight'];
    increment =json['increment'].toString();
    unit = json['unit']??"";
    if (json['offer'] != null) {
      offer = [];
      json['offer'].forEach((v) {
        offer!.add(new Offer.fromJson(v));
      });
    }
    if (json['toppings_data'] != null) {
      toppings_data = [];
      json['toppings_data'].forEach((v) {
        toppings_data!.add(new Toppings.fromJson(v));
      });
    }
    parent_id = json['parent_id'] != null ? json['parent_id'].toString():"";
    toppings = json["toppings"].toString();
    toppingsId = json["toppings_id"].toString();
  }

  Map<String, dynamic> toJson({price,quantity}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restaurant_name'] = this.restaurantName;
    data['id'] = this.id;
    data['eligible_for_express'] = this.eligibleForExpress;
    data['duration_type'] = this.durationType;
    data['duration'] = this.duration;
    data['user'] = this.user;
    data['var_id'] = this.varId;
    data['quantity'] = quantity??this.quantity;
    data['created_date'] = this.createdDate;
    data['time'] = this.time;
    data['price'] = price??this.price;
    data['status'] = this.status;
    data['branch'] = this.branch;
    data['itemId'] = this.itemId;
    data['varName'] = this.varName;
    data['varMinItem'] = this.varMinItem;
    data['varMaxItem'] = this.varMaxItem;
    data['itemLoyalty'] = this.itemLoyalty;
    data['varStock'] = this.varStock;
    data['varMrp'] = this.varMrp;
    data['itemName'] = this.itemName;
    data['membershipPrice'] = this.membershipPrice;
    data['itemActualprice'] = this.itemActualprice;
    data['itemImage'] = this.itemImage;
    data['membershipId'] = this.membershipId;
    data['mode'] = this.mode;
    data['type'] = this.type;
    data['veg_type'] = this.vegType;
    data['note'] = this.note;
    data['addon'] = this.addOn;
    data['delivery']=this.delivery;
    data['weight']=this.weight;
    data['increment']= this.increment;
    data['unit']= this.unit;
    if (this.offer != null) {
      data['offer'] = this.offer!.map((v) => v.toJson()).toList();
    }
    if (this.toppings_data != null) {
      data['toppings_data'] = this.toppings_data!.map((v) => v.toJson()).toList();
    }
    data['parent_id'] = this.parent_id;
    data['toppings'] = this.toppings;
    data['toppings_id'] = this.toppingsId;
    return data;
  }
}
class Offer {
  String? orderAmount;

  Offer({this.orderAmount});

  Offer.fromJson(Map<String, dynamic> json) {
    orderAmount = json['orderAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderAmount'] = this.orderAmount;
    return data;
  }
}
class Toppings {
  String? id;
  List<Ref>? ref;
  String? name;
  String? price;
  String? status;

  Toppings({this.id, this.ref, this.name, this.price, this.status});

  Toppings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['ref'] != null) {
      ref = <Ref>[];
      json['ref'].forEach((v) {
        ref!.add(new Ref.fromJson(v));
      });
    }
    name = json['name'];
    price = json['price'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.ref != null) {
      data['ref'] = this.ref!.map((v) => v.toJson()).toList();
    }
    data['name'] = this.name;
    data['price'] = this.price;
    data['status'] = this.status;
    return data;
  }
}

class Ref {
  String? id;
  String? name;
  String? type;
  String? date;
  String? branch;
  String? status;

  Ref({this.id, this.name, this.type, this.date, this.branch, this.status});

  Ref.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    date = json['date'];
    branch = json['branch'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['date'] = this.date;
    data['branch'] = this.branch;
    data['status'] = this.status;
    return data;
  }
}