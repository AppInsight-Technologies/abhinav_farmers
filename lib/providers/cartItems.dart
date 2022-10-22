import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../controller/mutations/cart_mutation.dart';
import '../constants/api.dart';
import '../blocs/cart_item_bloc.dart';
import '../constants/features.dart';
import '../models/cartItemsField.dart';
import '../data/hiveDB.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../utils/prefUtils.dart';

class CartItems with ChangeNotifier {
  static List<CartItemsFields> itemsList = [];
  final _cartItemController = StreamController<List<CartItemsFields>>();

  Future<int> addToCart(String? itemId, String? varId, String? varName, String? varMinItem,
      String? varMaxItem, String? varLoyalty, String? varStock, String? varMrp, String? itemName,
      String? qty, String? price, String? membershipPrice, String? itemImage,
      String? membershipId, String? mode, String? veg_type, String? type,String? eligibleforexpress, String? delivery,String? duration, String? durationType,String? note) async { // imp feature in adding async is the it automatically wrap into Future.
    String user = (PrefUtils.prefs!.containsKey("apikey")) ? PrefUtils.prefs!.getString("tokenid")! : PrefUtils.prefs!.getString("apikey")!;
   try {
      final response = await http.post(
          Api.addToCart,
          body: {
            "user": user,
            "itemId": itemId,
            "var_id": varId,
            "varName": varName,
            "varMinItem": varMinItem,
            "varMaxItem": varMaxItem,
            "itemLoyalty": varLoyalty,
            "varStock": varStock,
            "varMrp": varMrp,
            "itemName": itemName,
            "quantity": qty,
            "price": price,
            "membershipPrice": membershipPrice,
            "itemActualprice": varMrp,
            "itemImage": itemImage,
            "membershipId": membershipId,
            "mode": mode,
            "membership": (PrefUtils.prefs!.containsKey("apikey")) ? "0" : PrefUtils.prefs!.getString('membership'),
            "branch": PrefUtils.prefs!.getString('branch'),
            "veg_type": veg_type,
            "type": type,
            "eligible_for_express": eligibleforexpress,
            "delivery" :delivery,
            "duration": duration,
            "duration_type": durationType,
            "note": note
          }
      );
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      if(responseJson['status'].toString() == "200") {
        return 200;
      } else {
        return 400;
      }

    } catch (error) {
      throw error;
    }
  }

  Future<int> updateCart(String varId, String qty, String price) async { // imp feature in adding async is the it automatically wrap into Future.
    String user = (PrefUtils.prefs!.containsKey("apikey")) ? PrefUtils.prefs!.getString("tokenid")! : PrefUtils.prefs!.getString('apikey')!;
    try {
      final response = await http.post(
          Api.updateCart,
          body: { // await keyword is used to wait to this operation is complete.
            "user": user,
            "var_id": varId,
            "quantity": qty,
            "price": price,
            "branch": PrefUtils.prefs!.getString('branch'),
          }
      );
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      if(responseJson['status'].toString() == "200") {
        return 200;
      } else {
        return 400;
      }

    } catch (error) {
      throw error;
    }
  }

  Future<int> reOrder(String orderId) async { // imp feature in adding async is the it automatically wrap into Future.
    var url = Api.reorder + orderId + "/" + PrefUtils.prefs!.getString('branch')! + "/" + PrefUtils.prefs!.getString('apikey')!;
    try {
      final response = await http.get(url,);
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      if(responseJson['status'].toString() == "200") {
        SetCartItem(CartTask.fetch ,onloade: (value){

      });
        return 200;
      } else {
        return 400;
      }

    } catch (error) {
      throw error;
    }
  }

  Future<int> emptyCart() async { // imp feature in adding async is the it automatically wrap into Future.
    String user = (!PrefUtils.prefs!.containsKey("apikey")) ? PrefUtils.prefs!.getString("ftokenid")! : PrefUtils.prefs!.getString('apikey')!;

    var url = Api.emptyCart + user;
    try {
      final response = await http
          .get(
        url,
      );
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      if(responseJson['status'].toString() == "200") {
        return 200;
      } else {
        return 400;
      }

    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchCartItems() async {
    // imp feature in adding async is the it automatically wrap into Future.
    String user = (!PrefUtils.prefs!.containsKey("apikey")) ? PrefUtils.prefs!.getString("tokenid")! : PrefUtils.prefs!.getString('apikey')!;
    var url = Api.getCartItems + user + "/" + PrefUtils.prefs!.getString('branch')!;
    try {
      final response = await http.get(url,);
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      itemsList.clear();
      if(responseJson.toString() != "[]") {
        final dataJsondecode = json.decode(json.encode(responseJson));

        List data = []; //list for categories
        dataJsondecode.asMap().forEach((index, value) => data.add(
            dataJsondecode[index] as Map<String, dynamic>)); //store each category values in data list
        await Hive.box<Product>(productBoxName).clear();
        for (int i = 0; i < data.length; i++) {
          itemsList.add(CartItemsFields(
            itemId: int.parse(data[i]['itemId'].toString()),
            varId: int.parse(data[i]['var_id'].toString()),
            varName: data[i]['varName'].toString(),
            varMinItem: int.parse(data[i]['varMinItem'].toString()),
            varMaxItem: int.parse(data[i]['varMaxItem'].toString()),
            varStock: int.parse(data[i]['varStock'].toString()),
            varMrp: double.parse((data[i]['varMrp']??0.0).toString()),
            itemName: data[i]['itemName'].toString(),
            itemQty: int.parse(data[i]['quantity'].toString()),
            status: int.parse(data[i]['status'].toString()),
            itemPrice: double.parse((data[i]['price']??0.0).toString()),
            membershipPrice: data[i]['membershipPrice'].toString(),
            itemActualprice: double.parse((data[i]['itemActualprice']??0.0).toString()),
            itemImage: data[i]['itemImage'].toString(),
            itemLoyalty: int.parse(data[i]['itemLoyalty'].toString()),
            membershipId: int.parse(data[i]['membershipId'].toString()),
            mode: int.parse(data[i]['mode'].toString()),
            veg_type : data[i]['veg_type'].toString(),
            type : data[i]['type'].toString(),
            eligible_for_express: Features.isExpressDelivery ? data[i]['eligible_for_express'].toString() : "1",
            delivery: data[i]['delivery'].toString(),
            duration: data[i]['duration'].toString(),
            durationType: data[i]['duration_type'].toString(),
            note: data[i]['note'].toString(),
            subscribe:data[i]['eligible_for_subscription'].toString(),
            paymentmode:data[i]['payment_mode'].toString(),
            addOn: int.parse(data[i]['addon']),
          ));//add each category values into _items
          Product products = Product(
              itemId: int.parse(data[i]['itemId'].toString()),
              varId: int.parse(data[i]['var_id'].toString()),
              varName: data[i]['varName'].toString(),
              varMinItem: int.parse(data[i]['varMinItem'].toString()),
              varMaxItem: int.parse(data[i]['varMaxItem'].toString()),
              itemLoyalty: int.parse(data[i]['itemLoyalty'].toString()),
              varStock: int.parse(data[i]['varStock'].toString()),
              varMrp: double.parse((data[i]['varMrp']??0.0).toString()),
              itemName: data[i]['itemName'].toString(),
              itemQty: int.parse(data[i]['quantity'].toString()),
              itemPrice: double.parse((data[i]['price']??0.0).toString()),
              membershipPrice: data[i]['membershipPrice'].toString(),
              itemActualprice: double.parse((data[i]['itemActualprice']??0.0).toString()),
              itemImage: data[i]['itemImage'].toString(),
              membershipId: int.parse(data[i]['membershipId'].toString()),
              mode: int.parse(data[i]['mode'].toString()),
              veg_type : data[i]['veg_type'].toString(),
              type : data[i]['type'].toString(),
              eligible_for_express: Features.isExpressDelivery ? data[i]['eligible_for_express'].toString() : "1",
              delivery: data[i]['delivery'].toString(),
              duration: data[i]['duration'].toString(),
              durationType: data[i]['duration_type'].toString(),
              note: data[i]['note'].toString()
          );
          Hive.box<Product>(productBoxName).add(products);
        }
        cartBloc.cartitemSink.add(itemsList);
        for (int i = 0; i < data.length; i++) {
          if(int.parse(data[i]['mode'].toString()) == 1) {
            PrefUtils.prefs!.setString("membership", "1");
          }
        }
      } else {
        await Hive.box<Product>(productBoxName).clear();
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<CartItemsFields> get items {
    return [...itemsList];
  }
  Stream <List<CartItemsFields>> get itemss {
    return _cartItemController.stream;
  }
}