import 'package:grocbay/models/newmodle/home_store_modle.dart';
import 'dart:convert';
import '../../constants/IConstants.dart';
import '../../models/newmodle/search_data.dart';
import '../../utils/prefUtils.dart';
import '../api.dart';

class SearchStoreRepo{
  Future<List<StoreSearchData>> getStoreSearch(query,String lat,
  String long,{int start = 0 ,int end = 0})async{
    Api api = Api();
    if(start!=null){
      api.body = {

        "ref": IConstants.refIdForMultiVendor,
        "lat":lat,
        "long":long,
        'branch': PrefUtils.prefs!.getString("branch")!,
        'user': PrefUtils.prefs!.containsKey("apikey")?PrefUtils.prefs!.getString("apikey")!:PrefUtils.prefs!.getString("tokenid")!,
        'language_id': IConstants.languageId,//'0',
        'item_name': '$query',
        'start':'$start',
        'end':'$end',
      };
    }
    final resp =await api.Posturl("v3/search-product-for-vendor",isv2: false);
    print("resp home store page....repository....$resp");
    return Future.value(StoreSearch.fromJson(json.decode(resp)).data??=[]);
  }
}
final searchStorerepo = SearchStoreRepo();
