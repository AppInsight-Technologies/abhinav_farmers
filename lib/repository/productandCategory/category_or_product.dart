import 'dart:convert';
import 'package:grocbay/models/newmodle/search_data.dart';
import 'package:grocbay/models/newmodle/store_data.dart';

import '../../constants/IConstants.dart';
import '../../constants/features.dart';
import '../../generated/l10n.dart';

import '../../models/newmodle/category_modle.dart';
import '../../models/newmodle/product_data.dart';
import '../../repository/api.dart';
import '../../utils/prefUtils.dart';

class ProductRepo {
  List<StoreData> _nestItem = [];
  Future<List<StoreData>> getStore(lat,long,ids) async {
    Api api = Api();
    print("fetching productof varid:${lat}");
    List<StoreData> _itemdata =[];
    api.body = {
      'lat': lat,
      'long': long,
      'ids': ids,
    };
    _itemdata.clear();
    json.decode(await api.Posturl("get-store-list",isv2: false)).asMap().forEach((index, value) {
      _itemdata.clear();
      _itemdata.add(StoreData.fromJson(value)) ;
    });
    print("item data store...."+_itemdata.toString());
    return _itemdata;
  }
Future<List<CategoryData>>  getCategory()async {
  Api api = Api();
   var resp = json.decode(await api.Geturl(
      "restaurant/get-categories?branch=${PrefUtils.prefs!.getString("branch") ??
          "999"}&language_id=${PrefUtils.prefs!.getString("language_id") ??
          "0"}",isv2: false));
  if (resp["status"]) {
    List<CategoryData> caatdata;
   return CategoryDataModle.fromJson(resp).data!/*.data.forEach((element) =>
        getSubcategory(element, (p0) {
          element.subCategory.addAll(p0);
          caatdata.add(element);
        }))*/;
    // return caatdata;
  }
  else{
    return [];
  }
}
getSubcategory(String catid, Function(List<CategoryData>) response) async {
  Api api = Api();
    if(catid!=null) {

        api.body={
          "language_id":IConstants.languageId,//PrefUtils.prefs.getString("language_id"),
          "branch":PrefUtils.prefs!.getString("branch")??"999",
          "allKey":S .current.all,
        };
      var resp = await api.Posturl("restaurant/get-sub-category/${catid}");
     // https://manage.grocbay.com/api/app-manager/get-functionality/v2/restaurant/get-sub-category-deep/150
      print("hello"+resp.toString());
      if (resp != "[]") {
        if (SubCatModle.fromJson(json.decode(resp)).status!) {
         response( SubCatModle.fromJson(json.decode(resp)).data!);
        } else {
          response([]);
        }
      } else {
        response([]);
      }
    }
    else{
      response([]);
    }
  }
Future<List<CategoryData>> getSubNestcategory(String catid,/* Function(List<CategoryData>) response*/) async {
  Api api = Api();
  api.body = {
    "branch": PrefUtils.prefs!.getString("branch")??"999",
    "allKey": "All",
    "language_id": IConstants.languageId,//"0",
  };
  final resp = await api.Posturl("restaurant/get-sub-category-deep/${catid}");
  // https://manage.grocbay.com/api/app-manager/get-functionality/v2/restaurant/get-sub-category-deep/150
  print("response,,,,,"+resp.toString());
  List<CategoryData> data = [];
  if ((json.decode(resp)).toString() == "[]")
   return [];
  else
    print("data,,,,,,"+json.decode(resp)["data"].toString());
    json.decode(resp)["data"].asMap().forEach((index, value) {
      data.add(CategoryData.fromJson(value));
    });
    return Future.value(data);
}

  Future<List<ItemData>> getCartProductLists(categoryId, {start = 0, end = 0, type=0,}) async {
    Api api = Api();
    api.body = {
      "id": categoryId,
      "start": start.toString(),
      "end": end.toString(),
      "branch": PrefUtils.prefs!.getString("branch")??"999",
      "user": PrefUtils.prefs!.getString("apiKey") ?? PrefUtils.prefs!.getString("tokenid")!,
      "language_id": IConstants.languageId,//"0",
      "type" : type.toString(),
      "ref": IConstants.refIdForMultiVendor.toString(),
      "branchtype": IConstants.branchtype.toString(),
    };
 final response = await api.Posturl("v3/restaurant/get-menuitem-by-cart", isv2: false);
if((json.decode(response)["data"]).toString()=="[]")
  return [];
else
    return Future.value(ItemModle.fromJson(json.decode(response)).data);
  }

  Future<List<ItemData>> getSurveytProductLists() async {
    Api api = Api();
    api.body = {

      "start": "0",
      "end": "0",
      "branch": PrefUtils.prefs!.getString("branch")??"999",
     "branchtype": IConstants.branchtype.toString(),
    };
    final response = await api.Posturl("get-survey-products", isv2: false);
    if((json.decode(response)["data"]).toString()=="[]")
      return [];
    else
      return Future.value(ItemModle.fromJson(json.decode(response)).data);
  }

  Future<List<ItemData>?> getcategoryitemlist(categoryId) async {
    Api api = Api();
  api.body = {
    "branch": PrefUtils.prefs!.getString("branch")!,
    "language_id": IConstants.languageId,//"0",
    "ref": IConstants.refIdForMultiVendor.toString(),
    "branchtype": IConstants.branchtype.toString(),
  };
  final response = await api.Posturl("v3/get-items-by-cart/$categoryId/${PrefUtils.prefs!.getString("apiKey") ?? "1"}", isv2: false);
  List<ItemData> data =[];
  if((json.decode(response)).toString()=="[]")
    return null;
  else{
    json.decode(response).asMap().forEach((index, value){
      data.add(ItemData.fromJson(value));
    });
    return Future.value(data);
  }

}
  Future<List<ItemData>?> getBrandProductLists(categoryId, {start = 0, end = 0,}) async {
    Api api = Api();
    api.body = {
      "id": categoryId,
      "start": start.toString(),
      "end": end.toString(),
      "branch": PrefUtils.prefs!.getString("branch")!,
      "user": PrefUtils.prefs!.getString("apiKey") ?? "1",
      "language_id": IConstants.languageId,//"0"
      "ref": IConstants.refIdForMultiVendor.toString(),
      "branchtype": IConstants.branchtype.toString(),
    };
    final response = await api.Posturl("v3/restaurant/get-menuitem-by-brand-by-cart", isv2: false);

    if((json.decode(response)["data"]).toString()=="[]")
      return null;
    else
    return Future.value(ItemModle
        .fromJson(json.decode(response))
        .data);
  }
  Future<List<ItemData>> getProduct(prodid,type) async {
    Api api = Api();
  print("fetching productof varid:${prodid}");
  List<ItemData> _itemdata =[];
    api.body = {
      'id': prodid,
      'branch': PrefUtils.prefs!.getString("branch")??"999",
      'user': PrefUtils.prefs!.containsKey("apikey")?PrefUtils.prefs!.getString("apikey")!:PrefUtils.prefs!.getString("tokenid")!,
      'language_id': IConstants.languageId,//'0'
      'type':type,
      "ref": IConstants.refIdForMultiVendor,
      "branchtype": IConstants.branchtype.toString(),
    };
  _itemdata.clear();
    json.decode(await api.Posturl("v3/single-product-by-var",isv2: false)).asMap().forEach((index, value) {
      _itemdata.clear();
      _itemdata.add(ItemData.fromJson(value)) ;
    });
  return _itemdata;
  }

  Future<List<StoreSearchData>> getSearchStoreQuery(query,String? lat,String? long,{int start = 0 ,int end = 0}) async {
    Api api = Api();
    if(start!=null){
      api.body = {

        "ref": IConstants.refIdForMultiVendor,
        "lat":lat!,
        "long":long!,
        'branch': PrefUtils.prefs!.getString("branch")!,
        'user': PrefUtils.prefs!.containsKey("apikey")?PrefUtils.prefs!.getString("apikey")!:PrefUtils.prefs!.getString("ftokenid")!,
        'language_id': IConstants.languageId,//'0',
        'item_name': '$query',
        'start':'$start',
        'end':'$end',
      };
    }
    /*else
    api.body = {
      'branch': PrefUtils.prefs!.getString("branch"),
      'user': PrefUtils.prefs!.containsKey("apikey")?PrefUtils.prefs!.getString("apikey"):PrefUtils.prefs!.getString("tokenid"),
      'language_id': '0',
      'item_name': '$query',
    };*/
    final resp =  await api.Posturl("v3/search-product-for-vendor", isv2: false);
    print("search.......store..."+start.toString()+",,,,,,"+resp.toString());
    return Future.value(StoreSearch.fromJson(json.decode(resp)).data??=[]);
  }

  Future<List<ItemData>> getSearchQuery(query,{int start = 0 ,int end = 0}) async {
    Api api = Api();
  if(start!=null){
    api.body = {
      'branch': PrefUtils.prefs!.getString("branch")!,
      'user': PrefUtils.prefs!.containsKey("apikey")?PrefUtils.prefs!.getString("apikey")!:PrefUtils.prefs!.getString("ftokenid")!,
      'language_id': IConstants.languageId,//'0',
      'item_name': '$query',
      'start':'$start',
      'end':'$end',
      "ref": IConstants.refIdForMultiVendor.toString(),
      "branchtype": IConstants.branchtype.toString(),
    };
  }
  /*else
    api.body = {
      'branch': PrefUtils.prefs!.getString("branch"),
      'user': PrefUtils.prefs!.containsKey("apikey")?PrefUtils.prefs!.getString("apikey"):PrefUtils.prefs!.getString("tokenid"),
      'language_id': '0',
      'item_name': '$query',
    };*/
  final resp =  await api.Posturl("v3/restaurant/search-items-by-cart", isv2: false);
  print("search......."+start.toString()+",,,,,,"+resp.toString());
    return Future.value(ItemModle.fromJson(json.decode(resp)).data??=[]);
  }
 /* Future<ItemModle> getRecentProduct(prodid) async {
    Api api = Api();
    return Future.value(ItemModle.fromJson(json.decode(await api.Geturl("v3/restaurant/get-recent-products-by-cart/$prodid/${PrefUtils.prefs!.containsKey("apikey")?PrefUtils.prefs!.getString("apikey"):PrefUtils.prefs!.getString("ftokenid")}/${PrefUtils.prefs!.getString("branch")??"999"}",isv2: false))));
  }*/
  Future<ItemModle> getRecentProduct(prodid) async {
    Api api = Api();
    api.body = {
      "ref":IConstants.isEnterprise && Features.ismultivendor?IConstants.refIdForMultiVendor.toString():IConstants.refIdForMultiVendor.toString(),
      "branchtype": IConstants.branchtype.toString(),
    };
    return Future.value(ItemModle.fromJson(json.decode(await api.Posturl("v3/restaurant/get-recent-products-by-cart/$prodid/${PrefUtils.prefs!.containsKey("apikey")?PrefUtils.prefs!.getString("apikey"):PrefUtils.prefs!.getString("ftokenid")}/${PrefUtils.prefs!.getString("branch")??"999"}",isv2: false))));
  }

}
class CategoryDataModle {
  bool? status;
  List<CategoryData>? data;

  CategoryDataModle({this.status, this.data});

  CategoryDataModle.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <CategoryData>[];
      json['data'].forEach((v) {
        data!.add(new CategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class ItemModle {
  bool? status;
  List<ItemData>? data =[];
  String? label;

  ItemModle({this.status, this.data,this.label});

  ItemModle.fromJson(Map<String, dynamic> json) {
    status = json['status']??true;
    if (json['data'] != null) {
      data = <ItemData>[];
      json['data'].forEach((v) {

        data!.add(new ItemData.fromJson(v));
      });
      label = json['label'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['label'] = this.label;
    return data;
  }
}
class SubCatModle {
  bool? status;
  List<CategoryData>? data;

  SubCatModle({this.status, this.data});

  SubCatModle.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <CategoryData>[];
      json['data'].forEach((v) {
        data!.add(new CategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
