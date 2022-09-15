import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class ShoppinglistItemsFields with ChangeNotifier {
  final String? listid;
  final String? listname;
  bool? listcheckbox;
  final String? totalitemcount;
  final String? itemid;
  final String? itemname;
  final String? imageurl;
  final String? brand;
  final String? varid;
  final String? menuid;
  final String? varname;
  final String? varmrp;
  final String? varprice;
  final String? varmemberprice;
  final String? varmemberid;
  final String? varstock;
  final String? varminitem;
  final String? varmaxitem;
  final int? varLoyalty;
  final int? mode;
  int? varQty;
  Color? varcolor;
  final bool? discountDisplay;
  final bool? membershipDisplay;
  final String? veg_type;
  final String? type;
  final String? eligible_for_express;
  final String? delivery;
  final String? duration;
  final String? durationType;
  final String? note;
  final String? subscribe;
  final String? paymentmode;
  final String? cronTime;
  final String? name;
  final String? unit;
  final double? weight;

  ShoppinglistItemsFields({
    this.listid,
    this.listname,
    this.listcheckbox,
    this.totalitemcount,
    this.itemid,
    this.itemname,
    this.imageurl,
    this.brand,
    this.varid,
    this.menuid,
    this.varname,
    this.varmrp,
    this.varprice,
    this.varmemberprice,
    this.varmemberid,
    this.varstock,
    this.varminitem,
    this.varmaxitem,
    this.varLoyalty,
    this.mode,
    this.varQty,
    this.varcolor,
    this.discountDisplay,
    this.membershipDisplay,
    this.veg_type,
    this.type,
    this.eligible_for_express,
    this.delivery,
    this.duration,
    this.durationType,
    this.note,
    this.subscribe,
    this.paymentmode,
    this.cronTime,
    this.name,
    this.unit,
    this.weight,
  });
}