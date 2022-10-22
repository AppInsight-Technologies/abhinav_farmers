import 'dart:convert';

import '../../models/newmodle/product_data.dart';
import '../../repository/api.dart';
import '../../utils/prefUtils.dart';

class ShoppingList{
  List<ItemData> data = [];
 Future<List<ItemData>> get(itemid)async{
   print("id:");
   Api api = Api();
   api.body ={
     "id":itemid,
     "user": PrefUtils.prefs!.containsKey("apikey")?PrefUtils.prefs!.getString("apikey")!:PrefUtils.prefs!.getString("tokenid")!,
   };
   final result = json.decode(await api.Posturl("get-shopping-list-item",isv2: true));
   if(result!=null){
     result.asMap().forEach((index, value) => data.add(ItemData.fromJson(result[index])));
     return Future.value(data);
   }
   else{
     return [];
   }
  }
}