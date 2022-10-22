import 'package:hive/hive.dart';

part 'hiveDB.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  int itemId;

  @HiveField(1)
  int varId;

  @HiveField(2)
  String varName;

  @HiveField(3)
  int varMinItem;

  @HiveField(4)
  int varMaxItem;

  @HiveField(5)
  int varStock;

  @HiveField(6)
  double varMrp;

  @HiveField(7)
  String itemName;

  @HiveField(8)
  int itemQty;

  @HiveField(9)
  double itemPrice;

  @HiveField(10)
  String membershipPrice;

  @HiveField(11)
  double itemActualprice;

  @HiveField(12)
  String itemImage;

  @HiveField(13)
  double? itemWeight;

  @HiveField(14)
  int itemLoyalty;

  @HiveField(15)
  int membershipId;

  @HiveField(16)
  int mode;

  @HiveField(17)
  String veg_type;

  @HiveField(18)
  String type;

  @HiveField(19)
  String eligible_for_express;

  @HiveField(20)
  String delivery;

  @HiveField(21)
  String duration;

  @HiveField(22)
  String durationType;

  @HiveField(23)
  String? note;

  Product({required this.itemId, required this.varId, required this.varName, required this.varMinItem,
      required this.varMaxItem, required this.varStock, required this.varMrp, required this.itemName,
      required this.itemQty, required this.itemPrice, required this.membershipPrice, required this.itemActualprice, required this.itemImage,
   this.itemWeight, required this.itemLoyalty, required this.membershipId, required this.mode, required this.veg_type, required this.type,
    required this.eligible_for_express,required this.delivery,required this.duration,required this.durationType, this.note
  });

}