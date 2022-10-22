import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DelChargeFields with ChangeNotifier {
  final String? id;
  final String? createdDate;
  final String? minimumOrderAmountNoraml;
  final String? deliveryChargeNormal;
  final String? minimumOrderAmountPrime;
  final String? deliveryChargePrime;
  final String? minimumOrderAmountExpress;
  final String? deliveryChargeExpress;
  final String? deliveryDurationExpress;
  final String? subscriptionDeliveryCharge;
  final String? minimum_order_amount_subscription;
  final String? delsubscription;
  final String? delprimesubscription;


  DelChargeFields({
    required this.id,
    this.createdDate,
    this.minimumOrderAmountNoraml,
    this.deliveryChargeNormal,
    this.minimumOrderAmountPrime,
    this.deliveryChargePrime,
    this.minimumOrderAmountExpress,
    this.deliveryChargeExpress,
    this.deliveryDurationExpress,
    this.subscriptionDeliveryCharge,
    this.minimum_order_amount_subscription,
    this.delsubscription,
    this.delprimesubscription
  });
}
