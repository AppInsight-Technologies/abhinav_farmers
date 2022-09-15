import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DeliveryslotFields with ChangeNotifier {
  final String? day;
  final String? date;
  final String? dateformat;
  double? width;
  final String? time;
  final String? id;
  Color? selectedColor;
  bool? isSelect;
  final String? index;
  final String? status;
  Color? textColor;

  DeliveryslotFields({
    this.day,
    this.date,
    this.dateformat,
    this.width,
    this.time,
    this.id,
    this. selectedColor,
    this.isSelect,
    this.index,
    this.status,
    this.textColor
  });
}