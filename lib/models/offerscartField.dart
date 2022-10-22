import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class offerCartFields with ChangeNotifier {
  final int? itemId;
  final int? varId;
  final String? varName;
  final int? varMinItem;
  final int? varMaxItem;
  final int? varStock;
  final double? varMrp;
  final String? itemName;
  final int? itemQty;
  final double? itemPrice;
  final String? membershipPrice;
  final double? itemActualprice;
  final String? itemImage;

  offerCartFields({
    this.itemId,
    this.varId,
    this.varName,
    this.varMinItem,
    this.varMaxItem,
    this.varStock,
    this.varMrp,
    this.itemName,
    this.itemQty,
    this.itemPrice,
    this.membershipPrice,
    this.itemActualprice,
    this.itemImage,
});

}