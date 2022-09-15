import 'dart:convert';

import 'package:grocbay/models/VxModels/VxStore.dart';
import 'package:grocbay/models/newmodle/store_data.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constants/IConstants.dart';
import '../../models/newmodle/home_page_modle.dart';
import '../../utils/prefUtils.dart';

import '../api.dart';
enum ViewStoreOf{
  cat_tags,stores,nearby_store
}
class ViewStore{
  String url = "";

  Future<StoreData> getData(ViewStoreOf storeproduct, {required Function(bool) status})async {
    status(false);
    Api api = Api();
    api.body = {
      // "rows":"0",
      // "branch": PrefUtils.prefs!.getString("branch")!,
      // "user":"${PrefUtils.prefs!.containsKey("apikey")?PrefUtils.prefs!.getString("apikey"):PrefUtils.prefs!.getString("tokenid")}",
      // "language_id":IConstants.languageId
      "lat": (VxState.store as GroceStore).userData.latitude??PrefUtils.prefs!.getString("latitude")!,
      "long": (VxState.store as GroceStore).userData.longitude??PrefUtils.prefs!.getString("longitude")!,
      "ref": IConstants.refIdForMultiVendor
    };
    switch(storeproduct){

      case ViewStoreOf.cat_tags:
        url = await api.Posturl("get-all-category-tags",isv2: false);
        print("featured......."+url.toString());
        status(true);
        print('yakee en aytu....');
        // TODO: Handle this case.
        break;
      case ViewStoreOf.stores:
        url = await api.Posturl("get-all-stores",isv2: false);
        status(true);
        // TODO: Handle this case.
        break;
      case ViewStoreOf.nearby_store:
        url = await api.Posturl("get/nearest-store",isv2: false);
        status(true);
        // TODO: Handle this case.
        break;
    }
    return Future.value(StoreData.fromJson(json.decode(url)));
  }
}
final viewStores = ViewStore();