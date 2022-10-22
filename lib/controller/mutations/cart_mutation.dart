import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocbay/constants/IConstants.dart';
import 'package:grocbay/models/newmodle/search_data.dart';
import 'package:provider/provider.dart';
import '../../assets/ColorCodes.dart';
import '../../constants/features.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/cartModle.dart';
import '../../models/newmodle/product_data.dart';
import '../../providers/cartItems.dart';
import '../../repository/cart/cart_repo.dart';
import '../../services/firebaseAnaliticsService.dart';
import '../../utils/prefUtils.dart';
import 'package:velocity_x/velocity_x.dart';

enum CartTask{
  add,update,fetch
}
enum CartStatus{
  increment,remove,decrement
}
class CartController{
  final store = VxState.store as GroceStore;
  CartRepo _cart = CartRepo();

  reorder(Function(bool) onload,{required String orderid}){
    onload(false);
    _cart.reorder(orderid).then((value) {
      SetCartItem(CartTask.fetch,onloade: (value){
          onload(true);
        });
    });

  }

  update(Function(bool) onload,{required String price,required String quantity,required String weight, String? item_id, required String var_id,String? type,String? increament, required String cart_id,String? toppings, String? topping_id}){
  onload(false);
  _cart.updateCart({
      "user":PrefUtils.prefs!.containsKey("apikey")?PrefUtils.prefs!.getString("apikey")!:PrefUtils.prefs!.getString("ftokenid")!,
      "var_id":var_id,
      "quantity":quantity,
      "weight":weight,
      "price":price,
      "increment":increament??"1",
      "branch":PrefUtils.prefs!.getString("branch")??"999",
    "cart_id":cart_id.toString(),
    "toppings": toppings!,
    "toppings_id": (topping_id! == "null")?"":topping_id
    }).then((value) {
      if(value){
        SetCartItem(CartTask.update,quantity: quantity,weight:weight, itemid: item_id, varid: var_id,skutype:type,parent_id:cart_id,onloade: (value){
          onload(true);
        });
      }else{
        SetCartItem(CartTask.add ,onloade: (value){
          onload(true);
        });
      }
    });
  }
  clear(Function(bool) status){
    _cart.emptyCart().then((value) {
      if(value){
        (VxState.store as GroceStore).CartItemList.clear();
        status(value);
      }
    });
  }
  fetch({required Function(bool) onload}){
    onload(false);
    SetCartItem(CartTask.fetch ,onloade: (value){
      onload(true);
      if(Features.ismultivendor)  if(!PrefUtils.prefs!.containsKey("branch")) PrefUtils.prefs!.setString("branch", (VxState.store as GroceStore).CartItemList.first.branch!);
    });
  }

  addtoCart({ItemData? itemdata,Function(bool)? onload,String? topping_type,String? varid,String? toppings,String? parent_id,String?
  newproduct, required List toppingsList,StoreSearchData? storeSearchData,PriceVariation? itembody,PriceVariationSearch? itembodysearch,String? fromScreen,required BuildContext context,int? groupValue}) {
    if(fromScreen == "search_screen" && Features.ismultivendor) {
      onload!(true);
      List<CartItem> productBox = (VxState.store as GroceStore).CartItemList;

      bool _isAddCart = false;
      for(int i = 0; i < productBox.length; i++) {
        if(storeSearchData!.branchId == productBox[i].branch) {
          _isAddCart = true;
          break;
        }
      }
      if(productBox.length <= 0) {
        _isAddCart = true;
      }
      Map<String, String> resBody = {};
      if(_isAddCart) {
        fas.LogAddtoCart(
            itemId: (storeSearchData!.type == "1") ? storeSearchData.id! : itembodysearch!.id!,
            itemName: (storeSearchData.type == "1") ? storeSearchData.itemName! : itembodysearch!
                .variationName!,
            itemCategory: (storeSearchData.type == "1")
                ? storeSearchData.categoryId!
                : itembodysearch!
                .menuItemId!,
            quantity: (toppings == "1") ? 0 : 1,
            amount: (storeSearchData.type == "1")
                ? double.parse(storeSearchData.price!)
                : double
                .parse(itembodysearch!.price!),
            value: Cart.ADD);


        resBody["user"] = PrefUtils.prefs!.containsKey("apikey") ? PrefUtils.prefs!
            .getString("apikey")! : PrefUtils.prefs!.getString("ftokenid")!;
        resBody["var_id"] = storeSearchData.type == "1" ? storeSearchData.id! : itembodysearch!.id!;
        resBody["itemId"] = storeSearchData.id!;
        resBody["stock"] = storeSearchData.type == "1" ? storeSearchData.stock.toString() : itembodysearch!
            .stock.toString();
        resBody["varName"] = storeSearchData.type == "1" ? "1kg" : itembodysearch!.variationName! +
            itembodysearch.unit!;
        resBody["varMinItem"] = storeSearchData.type == "1" ? storeSearchData.minItem! : itembodysearch!
            .minItem ?? "0";
        resBody["varMaxItem"] = storeSearchData.type == "1" ? storeSearchData.maxItem! : itembodysearch!
            .maxItem ?? "0";
        resBody["itemLoyalty"] = storeSearchData.type == "1"
            ? storeSearchData.loyalty.toString()
            : itembodysearch!.loyalty.toString();
        resBody["varStock"] = storeSearchData.type == "1"
            ? storeSearchData.stock.toString()
            : itembodysearch!
            .stock.toString();
        resBody["varMrp"] = storeSearchData.type == "1" ? storeSearchData.mrp.toString() : itembodysearch!
            .mrp
            .toString();
        resBody["itemName"] = storeSearchData.itemName!;
        resBody["quantity"] = storeSearchData.type == "1"
            ? "1"
            : itembodysearch!
            .minItem ?? "1";
        resBody["weight"] = storeSearchData.type == "1" ? (double
            .parse(storeSearchData.minItem ?? "1") *
            double.parse(storeSearchData.increament!)).toString() : "1";
        resBody["price"] = storeSearchData.type == "1" ? storeSearchData.price.toString() : itembodysearch!
            .price.toString();
        resBody["membershipPrice"] = storeSearchData.type == "1" ? storeSearchData.membershipPrice
            .toString() : itembodysearch!.membershipPrice.toString();
        resBody["itemActualprice"] = storeSearchData.type == "1"
            ? storeSearchData.mrp.toString()
            : itembodysearch!.mrp.toString();
        resBody["itemImage"] = storeSearchData.type == "1"
            ? storeSearchData.itemFeaturedImage!
            : itembodysearch!.images != null ? itembodysearch.images!.length > 0
            ? itembodysearch
            .images![0].image!
            : storeSearchData.itemFeaturedImage ?? "" : storeSearchData
            .itemFeaturedImage ?? "";
        resBody["membershipId"] = storeSearchData.membershipId ??= "0";
        resBody["mode"] = storeSearchData.mode ?? "0";
        resBody["membership"] = (VxState.store as GroceStore).userData.membership ??
            "0";
        resBody["veg_type"] = storeSearchData.vegType ?? "";
        resBody["eligible_for_express"] = storeSearchData.eligibleForExpress ?? "0";
        resBody["delivery"] = storeSearchData.delivery!;
        resBody["duration"] = storeSearchData.deliveryDuration.duration;
        resBody["duration_type"] = storeSearchData.deliveryDuration.durationType;
        resBody["note"] = storeSearchData.deliveryDuration.note;
        resBody["type"] = storeSearchData.type!;
        resBody["status"] = storeSearchData.type == "1" ? storeSearchData.status! : itembodysearch!.status!;
        resBody["branch"] = storeSearchData.branchId!;
        resBody["increment"] = storeSearchData.increament ?? "1";
        resBody["toppings"] = toppings!;
        resBody["topping_type"] = topping_type!;
        resBody["toppings_id"] = (toppings == "1") ? varid! : "";
        resBody["parent_id"] = (toppings == "1") ? parent_id! : "";
        resBody["newproduct"] = newproduct!;
        if(toppingsList.length > 0) {
          for (int i = 0; i < toppingsList.length; i++) {
            resBody["toppings_datas[" + i.toString() + "][toppings_type]"] =
            toppingsList[i]["Toppings_type"];
            resBody["toppings_datas[" + i.toString() + "][toppings_id]"] =
            toppingsList[i]["toppings_id"];
            resBody["toppings_datas[" + i.toString() + "][toppings_name]"] =
            toppingsList[i]["toppings_name"];
            resBody["toppings_datas[" + i.toString() + "][toppings_price]"] =
            toppingsList[i]["toppings_price"];
          }
        }
        if (storeSearchData.type == "1") {
          if (store.CartItemList
              .where((element) =>
          element.itemId.toString() == storeSearchData.id.toString())
              .length > 0 && toppings == "0" && newproduct == "0") {
            update((done) {
              onload(false);
            },
              price: storeSearchData.price.toString(),
              var_id: storeSearchData.id.toString(),
              type: storeSearchData.type,
              quantity: "1",
              weight: storeSearchData.weight.toString(),
              increament: storeSearchData.increament.toString(),
              cart_id: parent_id!,
              toppings: toppings,
              topping_id: (toppings == "1") ? varid : "",
              item_id: storeSearchData.id.toString(),
            );
          } else
            _cart.addtoCart(resBody).then((value) {
              if (value["status"])
                SetCartItem(CartTask.add, skutype: storeSearchData.type,
                    data: CartItem.fromJson(value["data"][0]),
                    onloade: (value) {
                      onload(value);
                    });
              onload(false);
            });
        } else {
          if (store.CartItemList
              .where((element) =>
          element.varId.toString() == itembodysearch!.id.toString())
              .length > 0 && toppings == "0" && newproduct == "0") {
            update((done) {
              onload(false);
            },
              price: itembodysearch!.price.toString(),
              var_id: itembodysearch.id.toString(),
              type: storeSearchData.type,
              quantity: "1",
              weight: "1",
              cart_id: parent_id!,
              toppings: toppings,
              topping_id: (toppings == "1") ? varid : "",
              item_id: itembodysearch.menuItemId.toString(),
            );
          } else
            _cart.addtoCart(resBody).then((value) {
              if (value["status"])
                SetCartItem(CartTask.add, skutype: storeSearchData.type,
                    data: CartItem.fromJson(value["data"][0]),
                    onloade: (value) {
                      onload(value);
                    });
              onload(false);
            });
        }
      }
      else {
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Container(
                height: 140,
                width: 110,
                child: Column(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height:15),
                          Text("Replace cart item?",
                            style: TextStyle(
                              color: Colors.black54, fontSize: 16,fontWeight: FontWeight.bold,
                            ),),
                          SizedBox(height: 10),
                          Text(
                            "Your cart contains items. Do you want to discard the selection and add this item?",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    onload(false);
                                  },
                                  height: 15,
                                  minWidth: 25,
                                  color: Colors.transparent,
                                  padding: EdgeInsets.all(0),
                                  child: Text(
                                    "NO",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: ColorCodes.greenColor),)
                              ),
                              SizedBox(width: 20),
                              FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Provider.of<CartItems>(context, listen: false).emptyCart().then((_) {
                                      productBox.clear();
                                      addtoCart(
                                          storeSearchData: storeSearchData,
                                          onload: onload,
                                          topping_type: topping_type,
                                          varid: varid,
                                          toppings: toppings,
                                          parent_id: parent_id,
                                          newproduct: newproduct,
                                          context: context,
                                          itembodysearch: itembodysearch,
                                          toppingsList: [],
                                        fromScreen: "search_screen"

                                      );
                                    });
                                  },
                                  height: 15,
                                  minWidth: 25,
                                  color: Colors.transparent,
                                  padding: EdgeInsets.all(0),
                                  child: Text(
                                    "YES",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: ColorCodes.greenColor),)
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    }
    else{
      onload!(true);
      List<CartItem> productBox = (VxState.store as GroceStore).CartItemList;
      bool _isAddCart = false;
      for(int i = 0; i < productBox.length; i++) {
        if(PrefUtils.prefs!.getString("branch") == productBox[i].branch) {
          _isAddCart = true;
          break;
        }
      }
      if(productBox.length <= 0) {
        _isAddCart = true;
      }
      Map<String, String> resBody = {};
      if(_isAddCart) {
        fas.LogAddtoCart(
            itemId: (itemdata!.type == "1") ? itemdata.id! : itembody!.id!,
            itemName: (itemdata.type == "1") ? itemdata.itemName! : itembody!
                .variationName!,
            itemCategory: (itemdata.type == "1")
                ? itemdata.categoryId!
                : itembody!
                .menuItemId!,
            quantity: (toppings == "1") ? 0 : 1,
            amount: (itemdata.type == "1")
                ? double.parse(itemdata.price!)
                : double
                .parse(itembody!.price!),
            value: Cart.ADD);


        resBody["user"] = PrefUtils.prefs!.containsKey("apikey") ? PrefUtils.prefs!
            .getString("apikey")! : PrefUtils.prefs!.getString("ftokenid")!;
        resBody["var_id"] = itemdata.type == "1" ? itemdata.id! : itembody!.id!;
        resBody["itemId"] = itemdata.id!;
        resBody["stock"] = itemdata.type == "1" ? itemdata.stock.toString() : itembody!
            .stock.toString();
        resBody["varName"] = itemdata.type == "1" ? "1kg" : itembody!.variationName! +
            itembody.unit!;
        resBody["varMinItem"] = itemdata.type == "1" ? itemdata.minItem! : itembody!
            .minItem ?? "0";
        resBody["varMaxItem"] = itemdata.type == "1" ? itemdata.maxItem! : itembody!
            .maxItem ?? "0";
        resBody["itemLoyalty"] = itemdata.type == "1"
            ? itemdata.loyalty.toString()
            : itembody!.loyalty.toString();
        resBody["varStock"] = itemdata.type == "1"
            ? itemdata.stock.toString()
            : itembody!
            .stock.toString();
        resBody["varMrp"] = itemdata.type == "1" ? itemdata.mrp.toString() : itembody!
            .mrp
            .toString();
        resBody["itemName"] = itemdata.itemName!;
        resBody["quantity"] = itemdata.type == "1"
            ? "1"
            : itembody!
            .minItem ?? "1";
        resBody["weight"] = itemdata.type == "1" ? (double
            .parse(itemdata.minItem ?? "1") *
            double.parse(itemdata.increament!)).toString() : "1";
        resBody["price"] = itemdata.type == "1" ? itemdata.price.toString() : itembody!
            .price.toString();
        resBody["membershipPrice"] = itemdata.type == "1" ? itemdata.membershipPrice
            .toString() : itembody!.membershipPrice.toString();
        resBody["itemActualprice"] = itemdata.type == "1"
            ? itemdata.mrp.toString()
            : itembody!.mrp.toString();
        resBody["itemImage"] = itemdata.type == "1"
            ? itemdata.itemFeaturedImage!
            : itembody!.images != null ? itembody.images!.length > 0
            ? itembody.images![0].image!
            : itemdata.itemFeaturedImage ?? "" : itemdata
            .itemFeaturedImage ?? "";
        resBody["membershipId"] = itemdata.membershipId ??= "0";
        resBody["mode"] = itemdata.mode ?? "0";
        resBody["membership"] = (VxState.store as GroceStore).userData.membership ??
            "0";
        resBody["veg_type"] = itemdata.vegType ?? "";
        resBody["eligible_for_express"] = itemdata.eligibleForExpress ?? "0";
        resBody["delivery"] = itemdata.delivery!;
        resBody["duration"] = itemdata.deliveryDuration.duration;
        resBody["duration_type"] = itemdata.deliveryDuration.durationType;
        resBody["note"] = itemdata.deliveryDuration.note;
        resBody["type"] = itemdata.type!;
        resBody["status"] = itemdata.type == "1" ? itemdata.status! : itembody!.status!;
        resBody["branch"] = PrefUtils.prefs!.getString("branch") ?? "999";
        resBody["increment"] = itemdata.increament ?? "1";
        resBody["toppings"] = toppings!;
        resBody["topping_type"] = topping_type!;
        resBody["toppings_id"] = (toppings == "1") ? varid! : "";
        resBody["parent_id"] = (toppings == "1") ? parent_id! : "";
        resBody["newproduct"] = newproduct!;
        if(toppingsList.length > 0) {
          for (int i = 0; i < toppingsList.length; i++) {
            resBody["toppings_datas[" + i.toString() + "][toppings_type]"] =
            toppingsList[i]["Toppings_type"];
            resBody["toppings_datas[" + i.toString() + "][toppings_id]"] =
            toppingsList[i]["toppings_id"];
            resBody["toppings_datas[" + i.toString() + "][toppings_name]"] =
            toppingsList[i]["toppings_name"];
            resBody["toppings_datas[" + i.toString() + "][toppings_price]"] =
            toppingsList[i]["toppings_price"];
          }
        }
        if (itemdata.type == "1") {
          if (store.CartItemList
              .where((element) =>
          element.itemId.toString() == itemdata.id.toString())
              .length > 0 && toppings == "0" && newproduct == "0") {
            update((done) {
              onload(false);
            },
              price: itemdata.price.toString(),
              var_id: itemdata.id.toString(),
              type: itemdata.type,
              quantity: "1",
              weight: itemdata.weight.toString(),
              increament: itemdata.increament.toString(),
              cart_id: parent_id!,
              toppings: toppings,
              topping_id: (toppings == "1") ? varid : "",
              item_id: itemdata.id.toString(),
            );
          } else
            _cart.addtoCart(resBody).then((value) {
              if (value["status"])
                SetCartItem(CartTask.add, skutype: itemdata.type,
                    data: CartItem.fromJson(value["data"][0]),
                    onloade: (value) {
                      onload(value);
                    });
              onload(false);
            });
        } else {
          if (store.CartItemList
              .where((element) =>
          element.varId.toString() == itembody!.id.toString())
              .length > 0 && toppings == "0" && newproduct == "0") {
            update((done) {
              onload(false);
            },
              price: itembody!.price.toString(),
              var_id: itembody.id.toString(),
              type: itemdata.type,
              quantity: "1",
              weight: "1",
              cart_id: parent_id!,
              toppings: toppings,
              topping_id: (toppings == "1") ? varid : "",
              item_id: itembody.menuItemId.toString(),
            );
          } else
            _cart.addtoCart(resBody).then((value) {
              if (value["status"])
                SetCartItem(CartTask.add, skutype: itemdata.type,
                    data: CartItem.fromJson(value["data"][0]),
                    onloade: (value) {
                      onload(value);
                    });
              onload(false);
            });
        }
      }
      else {
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Container(
                height: 140,
                width: 110,
                child: Column(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height:15),
                          Text("Replace cart item?",
                            style: TextStyle(
                              color: Colors.black54, fontSize: 16,fontWeight: FontWeight.bold,
                            ),),
                          SizedBox(height: 10),
                          Text(
                            "Your cart contains items. Do you want to discard the selection and add this item?",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    onload(false);
                                  },
                                  height: 15,
                                  minWidth: 25,
                                  color: Colors.transparent,
                                  padding: EdgeInsets.all(0),
                                  child: Text(
                                    "NO",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: ColorCodes.greenColor),)
                              ),
                              SizedBox(width: 20),
                              FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Provider.of<CartItems>(context, listen: false).emptyCart().then((_) {
                                      productBox.clear();
                                      addtoCart(
                                          itemdata: itemdata,
                                          onload: onload,
                                          topping_type: topping_type,
                                          varid: varid,
                                          toppings: toppings,
                                          parent_id: parent_id,
                                          newproduct: newproduct,
                                          context: context,
                                          itembody: itembody,
                                          toppingsList: []
                                      );
                                    });
                                  },
                                  height: 15,
                                  minWidth: 25,
                                  color: Colors.transparent,
                                  padding: EdgeInsets.all(0),
                                  child: Text(
                                    "YES",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: ColorCodes.greenColor),)
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
      }
  }
}
final cartcontroller = CartController();
class SetCartItem extends VxMutation<GroceStore>{
  CartRepo _cart = CartRepo();
  CartTask type;
  String? itemid;
  String? varid;
  String? quantity;
  String? weight;
  Function(bool) onloade;
  CartItem? data;
  String? skutype;
  String? parent_id;
  SetCartItem(this.type, {this.quantity,this.weight, this.itemid, this.varid,required this. onloade, this.data,this.skutype,this.parent_id});
  @override
  perform() async{
    // TODO: implement perform
    switch(type){
      case CartTask.add:
        store!.CartItemList.add(data!);
        onloade(false);
        // TODO: Handle this case.
        break;
      case CartTask.update:
        if(skutype=="1") {
          if (double.parse(weight!) > 0 ) {
            store!.CartItemList.where((element) => element.itemId == varid && element.parent_id == parent_id).first.quantity = quantity!;
            store!.CartItemList.where((element) => element.itemId == varid && element.parent_id == parent_id).first.weight = weight!;
          }else {
            store!.CartItemList.removeAt(
                store!.CartItemList.indexWhere((element) => element.itemId ==
                    varid && element.parent_id == parent_id));
          }
        }else{
          if (int.parse(quantity!) > 0)
            Features.btobModule?
            store!
                .CartItemList
                .where((element) => element.itemId == itemid)
                .first
                .quantity = quantity!:
            store!
                .CartItemList
                .where((element) => element.varId == varid && element.parent_id == parent_id)
                .first
                .quantity = quantity!;
          else
            store!.CartItemList.removeAt(
                store!.CartItemList.indexWhere((element) => element.varId ==
                    varid && element.parent_id == parent_id));
        }
        onloade(false);
        // TODO: Handle this case.
        break;
      case CartTask.fetch:
        store!.CartItemList = await _cart.getCart((value){
          onloade(value.isNotEmpty);
        });
        // TODO: Handle this case.
        break;

    }
  }
}