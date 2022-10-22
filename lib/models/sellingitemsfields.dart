import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SellingItemsFields with ChangeNotifier {
  final String? id;
  final String? title;
  final String? imageUrl;
  final String? brand;
  final String? itemqty;
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
  int varQty=0;
  Color? varcolor;
  final int? mode;
  final bool? discountDisplay;
  final bool? membershipDisplay;
  final String? description;
  final String? manufacturedesc;
  final String? offerId;
  final String? offerTitle;
  Color? border;
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
  String? offertext;
  final String? unit;
  final double? weight;
  final double? netWeight;
  final String? salePrice;

  SellingItemsFields({
    this.id,
    this.title,
    this.imageUrl,
    this.brand,
    this.itemqty,
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
    this.varQty=0,
    this.varcolor,
    this.mode,
    this.discountDisplay,
    this.membershipDisplay,
    this.description,
    this.manufacturedesc,
    this.offerId,
    this.offerTitle,
    this.border,
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
    this.offertext,
    this.unit,
    this.weight,
    this.netWeight,
    this.salePrice,
  });
}