import 'dart:convert';
import '../../constants/IConstants.dart';
import '../../constants/features.dart';
import '../../models/newmodle/cartModle.dart';
import '../../models/newmodle/product_data.dart';
import '../../repository/api.dart';
import '../../utils/prefUtils.dart';

class CartRepo{
  List<CartItem> cartlist = [];

  Future<CartFetch> getSudgetstedCart()async {
    Api api = Api();
    return CartFetch.fromJson(json.decode(await api.Geturl("v2/restaurant/get-items-data-by-cart?rows=0&branch=${PrefUtils.prefs!.getString("branch")??999}&user=${PrefUtils.prefs!.containsKey("apikey")?PrefUtils.prefs!.getString("apikey"):PrefUtils.prefs!.getString("ftokenid")}&language_id=${PrefUtils.prefs!.getString("language_id")??"en"}",isv2: false)));
  }

  Future<bool> reorder(String orderid)async{
    Api api = Api();
    if(json.decode(await api.Geturl("reorder/$orderid/${PrefUtils.prefs!.getString("branch")}/${PrefUtils.prefs!.containsKey("apikey")?PrefUtils.prefs!.getString("apikey"):PrefUtils.prefs!.getString("ftokenid")}",isv2: false))["status"]==200){
      return Future.value(true);
    }else  return Future.value(false);
  }

  Future<bool>  updateCart(Map<String,String> body)async{
    Api api = Api();
    api.body = body;
    if(json.decode(await api.Posturl("v3/update-cart",isv2: false))["status"]==200)
    return Future.value(true);
    else  return Future.value(false);
  }

  Future<Map<String,dynamic>>  addtoCart(Map<String,String> body)async{
    Api api = Api();

    api.body = body;
    Map<String,dynamic> _map = {};
    var resp = await api.Posturl("v3/add-to-cart-toppings",isv2: false);
    if(resp!=null&&json.decode(resp)["status"]==200) {
      _map["status"] = true;
      _map["data"] = json.decode(resp)["cart"];
      _map['data'].asMap().forEach((index, value) => _map["data"][index].addAll({"parent_id":json.decode(resp)["parent_id"]}));
      return Future.value(_map);
    } else {
      _map["status"] = true;
      return Future.value(_map);
    }
  }
  Future<bool>  emptyCart()async{
    Api api = Api();
    if(json.decode(await api.Geturl("empty-cart/${PrefUtils.prefs!.containsKey("apikey")?PrefUtils.prefs!.getString("apikey"):PrefUtils.prefs!.getString("ftokenid")}",isv2: false))["status"]==200){
      return Future.value(true);
    }else  return Future.value(false);
  }

  Future<bool> awailiblityCheck(String itemid)async{
    Api api = Api();
    if(json.decode(await api.Geturl("cart-check/${PrefUtils.prefs!.getString("branch")}/$itemid",isv2: false))["status"]==0){
      return Future.value(true);
    }else  return Future.value(false);
  }

  Future<List<CartItem>> getCart(Function(List<CartItem>) loading) async{
    Api api = Api();
    var jsonresp = Features.ismultivendor ?
    json.decode(await api.Geturl("v3/get-cart-items-vendor/${PrefUtils.prefs!.containsKey("apikey")?PrefUtils.prefs!.getString("apikey"):PrefUtils.prefs!.getString("ftokenid")}/${IConstants.refIdForMultiVendor}/${0}/${PrefUtils.prefs!.getString("language_id")??"en"}",isv2: false))
        :
    json.decode(await api.Geturl("v3/get-cart-items/${PrefUtils.prefs!.containsKey("apikey")?PrefUtils.prefs!.getString("apikey"):PrefUtils.prefs!.getString("ftokenid")}/${PrefUtils.prefs!.getString("branch")??"999"}",isv2: false));
   jsonresp.asMap().forEach((index, value){
      cartlist.add(CartItem.fromJson(jsonresp[index] as Map<String,dynamic>));
    });
   loading(cartlist);
   return cartlist;
  }
}
class CartFetch {
  List<ItemData>? data;
  String? label;

  CartFetch({this.data, this.label});

  CartFetch.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ItemData>[];
      json['data'].forEach((v) {
        data!.add(new ItemData.fromJson(v));
      });
    }
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['label'] = this.label;
    return data;
  }
}