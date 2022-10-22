import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CartItemsFields with ChangeNotifier {
  final int? itemId;
  final int? varId;
  final String? varName;
  final int? varMinItem;
  final int? varMaxItem;
  final int? varStock;
  final double? varMrp;
  final String? itemName;
  int itemQty=0;
  final int? status;
  final double? itemPrice;
  final String? membershipPrice;
  final double? itemActualprice;
  final String? itemImage;
  final double? itemWeight;
  final int? itemLoyalty;
  final int? membershipId;
  final int? mode;
  final String? veg_type;
  final String? type;
  final String? delivery;
  final String? duration;
  final String? durationType;
  final String? note;
  final String? eligible_for_express;
  final String? subscribe;
  final String? paymentmode;
  final String? cronTime;
  final String? Status;
  final int? addOn;

  CartItemsFields({
    this.itemId,
    this.varId,
    this.varName,
    this.varMinItem,
    this.varMaxItem,
    this.varStock,
    this.varMrp,
    this.itemName,
    this.itemQty=0,
    this.status,
    this.itemPrice,
    this.membershipPrice,
    this.itemActualprice,
    this.itemImage,
    this.itemWeight,
    this.itemLoyalty,
    this.membershipId,
    this.mode,
    this.veg_type,
    this.type,
    this.delivery,
    this.duration,
    this.durationType,
    this.note,
    this.eligible_for_express,
    this.subscribe,
    this.paymentmode,
    this.cronTime,
    this.Status,
    this.addOn
  });
/*  offerCart(int itemId,int varId,String varName,int varMinItem,int varMaxItem,int varStock,double varMrp,String itemName,int itemQty,double itemPrice,String membershipPrice, double itemActualprice, String itemImage){
    this.itemId;
    this.varId;
    this.varName;
    this.varMinItem;
    this.varMaxItem;
    this.varStock;
    this.varMrp;
    this.itemName;
    this.itemQty;
    this.itemPrice;
    this.membershipPrice;
    this.itemActualprice;
    this.itemImage;
  }*/
}