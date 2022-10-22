import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class PickuplocFields with ChangeNotifier {
  final String? id;
  final String? name;
  final String? address;
  final String? contact;
  final double? latitude;
  final double? longitude;
  final String? deliveryChargeForRegularUser;
  final String? deliveryChargeForMembershipUser;
  Color? selectedColor;
  bool? isSelect;
  final String? index;

  PickuplocFields({
    this.id,
    this.name,
    this.address,
    this.contact,
    this.latitude,
    this.longitude,
    this.deliveryChargeForRegularUser,
    this.deliveryChargeForMembershipUser,
    this. selectedColor,
    this.isSelect,
    this.index,
  });
}