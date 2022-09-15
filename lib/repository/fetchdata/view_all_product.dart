import 'dart:convert';

import '../../constants/IConstants.dart';
import '../../constants/features.dart';
import '../../models/newmodle/home_page_modle.dart';
import '../../utils/prefUtils.dart';

import '../api.dart';
enum ViewProductOf{
  featured,discount,itemData,offer
}
class ViewProduct{
  String url = "";

  Future<OfferByCart> getData(ViewProductOf viewproduct, {required Function(bool) status})async {
    status(false);
    Api api = Api();
    api.body = {
      "rows":"0",
      "branch": PrefUtils.prefs!.getString("branch")!,
      "user":"${PrefUtils.prefs!.containsKey("apikey")?PrefUtils.prefs!.getString("apikey"):PrefUtils.prefs!.getString("tokenid")}",
      "language_id":IConstants.languageId,
      "ref": IConstants.refIdForMultiVendor.toString(),
      "branchtype":IConstants.branchtype.toString(),
    };
    switch(viewproduct){

      case ViewProductOf.featured:
        url = await api.Posturl("v3/restaurant/get-featured-by-cart", isv2: false);
        print("featured......."+url.toString());
        status(true);
        print('yakee en aytu....');
        // TODO: Handle this case.
        break;
      case ViewProductOf.discount:
        url = await api.Posturl("v3/restaurant/get-discount-by-cart", isv2: false);
        status(true);
        // TODO: Handle this case.
        break;
      case ViewProductOf.itemData:
        url = await api.Posturl("v3/restaurant/get-items-data-by-cart",isv2: false);
        status(true);
        // TODO: Handle this case.
        break;
      case ViewProductOf.offer:
        url = await api.Posturl("v3/restaurant/get-offer-by-cart", isv2: false);
        status(true);
        // TODO: Handle this case.
        break;
      // case ViewProductOf.forget:
      //   url = await api.Posturl("v3/restaurant/get-featured-by-cart", isV2: false);
      //   status(true);
        // TODO: Handle this case.
        break;
    }

    return Future.value(OfferByCart.fromJson(json.decode(url)));
  }
}
final viewProducts = ViewProduct();