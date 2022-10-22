import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../assets/images.dart';
import '../../components/login_web.dart';
import '../../helper/custome_checker.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/sellingitemsfields.dart';
import '../../providers/myorderitems.dart';
import '../../utils/ResponsiveLayout.dart';
import '../../utils/facebook_app_events.dart';
import '../../utils/prefUtils.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../models/newmodle/cartModle.dart';
import '../../constants/IConstants.dart';
import '../assets/ColorCodes.dart';
import '../constants/api.dart';
import '../constants/features.dart';
import '../controller/mutations/cart_mutation.dart';
import '../generated/l10n.dart';
import '../models/newmodle/product_data.dart';
import '../models/newmodle/search_data.dart';
import '../providers/branditems.dart';
import 'package:provider/provider.dart';
import '../rought_genrator.dart';
import 'package:http/http.dart' as http;

enum StepperAlignment{
  Vertical,Horizontal
}

class CustomeStepper extends StatefulWidget {
  PriceVariation? priceVariation;
  PriceVariationSearch? priceVariationSearch;
  String? from;
  ItemData? itemdata;
  StoreSearchData? searchstoredata;
  bool? checkmembership;
  bool subscription;
  StepperAlignment alignmnt;
  final double? fontSize;
  final double height;
  final double width;
  Addon? addon;
  int index;
  String? issubscription;
 int? groupvalue;
  Function(int,int)? onChange;

  CustomeStepper({Key? key,this.priceVariation,this.priceVariationSearch,this.itemdata,this.searchstoredata,this.from,this.checkmembership,this.subscription = false,this.alignmnt = StepperAlignment.Vertical,required this.height ,this.width = double.infinity,this.addon,required this.index,this.issubscription,this.groupvalue,this.onChange,this.fontSize =12 }) : super(key: key);

  @override
  State<CustomeStepper> createState() => _CustomeStepperState();
}

class _CustomeStepperState extends State<CustomeStepper> with Navigations {

  bool loading = false;
  bool Toppingloading = false;
  bool _isNotify = false;
  List<CartItem> productBox=[];
  List<Widget> stepperButtons = [];
  final item =(VxState.store as GroceStore).CartItemList;
  int toppings = 0;
  String? toppingscheck;
  int _groupValue = -1;
  StateSetter? setstate;
  late Future<List<RepeatToppings>> _futureNonavailable = Future.value([]);

  late StateSetter topupState;
  int? varId = 0;
  int? parentId = 0;

  var itemadd = {};
  List toppingsitem = [];

  List product = [];

  List addToppingsProduct = [];
  String? parentidforupdate = "";
  List<String> deliveries = [];
  bool _checkmembership = false;

  @override
  Widget build(BuildContext context) {
    productBox=  (VxState.store as GroceStore).CartItemList;
    deliveries.clear();

    final cartItemList =(VxState.store as GroceStore).CartItemList;
    for (int i = 0; i < productBox.length; i++) {
      if (productBox[i].mode == "1") {
        _checkmembership = true;
      }
    }
    if(widget.from == "search_screen" && Features.ismultivendor){
      if (widget.searchstoredata!.subscriptionSlot!.length > 0) {
        deliveries.addAll(
            (widget.searchstoredata!.subscriptionSlot![0].deliveries!.split(",")));
      }
    }else {
      if (widget.itemdata!.subscriptionSlot!.length > 0) {
        deliveries.addAll(
            (widget.itemdata!.subscriptionSlot![0].deliveries!.split(",")));
      }
    }
    product.clear();
    for( int i = 0;i < productBox.length ;i++){
      if(widget.from == "search_screen" && Features.ismultivendor) {
        if (productBox[i].itemId == widget.searchstoredata!.id &&
            productBox[i].toppings == "0") {
          product.add(productBox[i].quantity);
        }
      }
      else {
        if (productBox[i].itemId == widget.itemdata!.id &&
            productBox[i].toppings == "0") {
          product.add(productBox[i].quantity);
        }
      }
    }

    List maxQantity = [];
    List maxWeight = [];
    int quantityTotal = 0;
    double weightTotal = 0;

    if(widget.from == "search_screen" && Features.ismultivendor){
      if(widget.searchstoredata!.type == "1"){
        for(int i =0; i< productBox.where((element) => element.itemId == widget.searchstoredata!.id).length ;i++){
          maxWeight.add(productBox[i].weight);
        }
        for(int j = 0; j < maxWeight.length; j++){
          weightTotal = weightTotal + double.parse(maxWeight[j]);
        }
      }
      else {
        for (int i = 0; i < productBox
            .where((element) => element.itemId == widget.searchstoredata!.id)
            .length; i++) {
          maxQantity.add(productBox[i].quantity);
        }
        for (int j = 0; j < maxQantity.length; j++) {
          quantityTotal = quantityTotal + int.parse(maxQantity[j]);
        }
      }
    }
    else{
    if(widget.itemdata!.type == "1"){
      for(int i =0; i< productBox.where((element) => element.itemId == widget.itemdata!.id).length ;i++){
        maxWeight.add(productBox[i].weight);
      }
      for(int j = 0; j < maxWeight.length; j++){
        weightTotal = weightTotal + double.parse(maxWeight[j]);
      }
    }
    else {
      for (int i = 0; i < productBox
          .where((element) => element.itemId == widget.itemdata!.id)
          .length; i++) {
        maxQantity.add(productBox[i].quantity);
      }
      for (int j = 0; j < maxQantity.length; j++) {
        quantityTotal = quantityTotal + int.parse(maxQantity[j]);
      }
    }
    }
    updateCart(int qty,double weight,CartStatus cart,String varid, String parent_id, String toppings, String toppings_id){
      switch(cart){
        case CartStatus.increment:
        if(widget.from == "search_screen" && Features.ismultivendor){
          if(widget.searchstoredata!.type=="1"){
            if((productBox.where((element) => element.itemId == widget.searchstoredata!.id).length > 1 ?weightTotal:double.parse(weight.toString()))
                < double.parse(widget.searchstoredata!.stock.toString())) {
              if((productBox.where((element) => element.itemId == widget.searchstoredata!.id).length > 1 ?weightTotal: double.parse(weight.toString()))
                  <(double.parse(widget.searchstoredata!.maxItem!)*double.parse(widget.searchstoredata!.increament!))) {
                cartcontroller.update((done) {
                  setState(() {
                    loading = !done;
                  });
                }, price: widget.searchstoredata!.price.toString(),
                    quantity: qty.toString(),
                    type: widget.searchstoredata!.type,
                    weight: (weight+double.parse(widget.searchstoredata!.increament!)).toString(),
                    var_id: varid,
                    increament: widget.searchstoredata!.increament,
                    cart_id: parent_id,
                    toppings: toppings,
                    topping_id: toppings_id

                );
              }
              else {
                Fluttertoast.showToast(
                    msg:
                    S.of(context).cant_add_more_item,//"Sorry, you can\'t add more of this item!",
                    fontSize: MediaQuery.of(context).textScaleFactor *13,
                    backgroundColor: Colors.black87,
                    textColor: Colors.white);
              }
            }else{
              Fluttertoast.showToast(
                  msg: S
                      .of(context)
                      .sorry_outofstock, //"Sorry, Out of Stock!",
                  fontSize: MediaQuery
                      .of(context)
                      .textScaleFactor * 13,
                  backgroundColor: Colors.black87,
                  textColor: Colors.white);
            }
          }
          else {

            if (Features.btobModule) {
              if ((productBox
                  .where((element) => element.itemId == widget.searchstoredata!.id)
                  .length > 1 ? quantityTotal : qty) <
                  double.parse(
                      widget.priceVariationSearch!.maxItem!)) {
                cartcontroller.update((done) {
                  setState(() {
                    loading = !done;
                    widget.onChange!(widget.groupvalue!,(productBox
                        .where((element) => element.itemId == widget.searchstoredata!.id)
                        .length > 1 ?(int.parse(productBox
                        .where((element) => element.itemId == widget.searchstoredata!.id).first.quantity!)):(int.parse(productBox
                        .where((element) => element.itemId == widget.searchstoredata!.id).first.quantity!))));

                  });
                }, price: widget.priceVariationSearch!.price.toString(),
                    quantity: (qty + 1).toString(),
                    type: widget.searchstoredata!.type,
                    weight: "1",
                    var_id: varid,
                    increament: widget.searchstoredata!.increament,
                    cart_id: parent_id,
                    toppings: toppings,
                    topping_id: toppings_id
                );
              }
              else {
                if (productBox
                    .where((element) => element.itemId == widget.searchstoredata!.id)
                    .length > 1) {
                }
                else {
                  var varIdold = varid;
                  var varminitemold = widget.priceVariationSearch!.minItem;
                  var varpriceold = widget.priceVariationSearch!.price;
                  if (int.parse(
                      widget.priceVariationSearch!.minItem!) < qty &&
                      int.parse(
                          widget.priceVariationSearch!.maxItem!) >
                          qty){
                    varid = widget.priceVariationSearch!.id!;
                    if ((productBox
                        .where((element) =>
                    element.itemId == widget.searchstoredata!.id)
                        .length > 1 ? quantityTotal : qty) <
                        double.parse(
                            widget.priceVariationSearch!.maxItem!)){
                    }
                    else{
                      var varminitemold = widget.priceVariationSearch!.minItem;
                      var varpriceold = widget.priceVariationSearch!.price;
                      cartcontroller.update((done) {
                        setState(() {
                          loading = !done;
                        });
                      }, price: widget.priceVariationSearch!.price.toString(),
                          quantity: (qty + 1).toString(),
                          type: widget.searchstoredata!.type,
                          weight: "1",
                          var_id: varid,
                          increament: widget.searchstoredata!.increament,
                          cart_id: parent_id,
                          toppings: toppings,
                          topping_id: toppings_id
                      );

                    }

                  }
                  else {
                    var varIdold = varid;
                    var varminitemold = widget.priceVariationSearch!.minItem;
                    var varpriceold = widget.priceVariationSearch!.price;

                    for (int i = widget.groupvalue!; i <
                        widget.searchstoredata!.priceVariation!.length; i++) {
                      if (int.parse(productBox
                          .where((element) =>
                      element.varId == widget.priceVariation!.id)
                          .last
                          .varId
                          .toString()) ==
                          widget.searchstoredata!.priceVariation![i].id) {
                        widget.groupvalue = widget.groupvalue! + 1;
                      }
                      else {
                        if (int.parse(
                            widget.searchstoredata!.priceVariation![i].maxItem
                                .toString()) > qty) {
                          cartcontroller.update((done) {
                            setState(() {
                              loading = !done;
                              widget.onChange!(widget.groupvalue!,qty + 1);
                            });
                          }, price: widget.priceVariationSearch!.price.toString(),
                              quantity: (qty + 1).toString(),
                              type: widget.searchstoredata!.type,
                              weight: "1",
                              var_id: widget.searchstoredata!.priceVariation![i].id!,
                              increament: widget.searchstoredata!.increament,
                              cart_id: parent_id,
                              toppings: toppings,
                              topping_id: toppings_id
                          );
                        }
                        else {
                          if(int.parse(
                              widget.searchstoredata!.priceVariation![widget.searchstoredata!.priceVariation!.length -1].maxItem
                                  .toString()) <= qty) {
                            Fluttertoast.showToast(
                                msg:
                                S
                                    .of(context)
                                    .cant_add_more_item,
                                //"Sorry, you can\'t add more of this item!",
                                fontSize: MediaQuery
                                    .of(context)
                                    .textScaleFactor * 13,
                                backgroundColor: Colors.black87,
                                textColor: Colors.white);
                          }
                        }
                      }

                      widget.groupvalue = widget.groupvalue! + 1;
                      break;

                    }

                  }
                }
              }
            }
            else {
              List<SellingItemsFields> list = [];
              item.forEach((element) {
                if (element.itemId == widget.searchstoredata!.id) {
                  for (int i = 0; i <
                      widget.searchstoredata!.priceVariation!.length; i++) {
                    if (widget.searchstoredata!.priceVariation![i].id ==
                        element.varId) {
                      list.add(SellingItemsFields(weight: double.parse(
                          widget.searchstoredata!.priceVariation![i].weight!),
                          varQty: int.parse(element.quantity.toString())));
                    }
                  }
                }
              });
              if (Features.btobModule ? Check().isOutofStock(
                  maxstock: double.parse(
                      widget.priceVariationSearch!.stock.toString()),
                  stocktype: widget.searchstoredata!.type!,
                  qty: (productBox
                      .where((element) =>
                  element.itemId == widget.searchstoredata!.id)
                      .length > 1) ? quantityTotal.toString() : qty.toString(),
                  itemData: [],
                  searchvariation: widget.priceVariationSearch!,
                  screen: "search_screen")
                  : Check().isOutofStock(
                maxstock: double.parse(
                    widget.priceVariationSearch!.stock.toString()),
                stocktype: widget.searchstoredata!.type!,
                qty: (productBox
                    .where((element) =>
                element.itemId == widget.searchstoredata!.id)
                    .length > 1) ? quantityTotal.toString() : qty.toString(),
                itemData: list,
                searchvariation: widget.priceVariationSearch!,)) {
                Fluttertoast.showToast(
                    msg: S
                        .of(context)
                        .sorry_outofstock,
                    //"Sorry, Out of Stock!",
                    fontSize: MediaQuery
                        .of(context)
                        .textScaleFactor * 13,
                    backgroundColor: Colors.black87,
                    textColor: Colors.white);
              } else {
                if ((productBox
                    .where((element) =>
                element.itemId == widget.searchstoredata!.id)
                    .length > 1 ? quantityTotal : qty) <
                    double.parse(widget.priceVariationSearch!.maxItem!)) {
                  cartcontroller.update((done) {
                    setState(() {
                      loading = !done;
                    });
                  }, price: widget.priceVariationSearch!.price.toString(),
                      quantity: (qty + 1).toString(),
                      type: widget.searchstoredata!.type,
                      weight: "1",
                      var_id: varid,
                      increament: widget.searchstoredata!.increament,
                      cart_id: parent_id,
                      toppings: toppings,
                      topping_id: toppings_id
                  );
                } else {
                  Fluttertoast.showToast(
                      msg:
                      S.of(context).cant_add_more_item, //"Sorry, you can\'t add more of this item!",
                      fontSize: MediaQuery.of(context).textScaleFactor * 13,
                      backgroundColor: Colors.black87,
                      textColor: Colors.white);
                }
              }
            }
          }
        }
        else {
          if (widget.itemdata!.type == "1") {
            if ((productBox.where((element) => element.itemId == widget.itemdata!.id).length > 1 ?weightTotal: double.parse(weight.toString())) <
                double.parse(widget.itemdata!.stock.toString())) {
              if (double.parse(weight.toString()) <
                  (double.parse(widget.itemdata!.maxItem!) *
                      double.parse(widget.itemdata!.increament!))) {
                cartcontroller.update((done) {
                  setState(() {
                    loading = !done;
                  });
                }, price: widget.itemdata!.price.toString(),
                    quantity: qty.toString(),
                    type: widget.itemdata!.type,
                    weight: (weight +
                        double.parse(widget.itemdata!.increament!)).toString(),
                    var_id: varid,
                    increament: widget.itemdata!.increament,
                    cart_id: parent_id,
                    toppings: toppings,
                    topping_id: toppings_id,
                    item_id: widget.itemdata!.id.toString()

                );
              } else {
                Fluttertoast.showToast(
                    msg: S.of(context).cant_add_more_item, //"Sorry, you can\'t add more of this item!",
                    fontSize: MediaQuery.of(context).textScaleFactor * 13,
                    backgroundColor: Colors.black87,
                    textColor: Colors.white);
              }
            } else {
              Fluttertoast.showToast(
                  msg: S
                      .of(context)
                      .sorry_outofstock, //"Sorry, Out of Stock!",
                  fontSize: MediaQuery
                      .of(context)
                      .textScaleFactor * 13,
                  backgroundColor: Colors.black87,
                  textColor: Colors.white);
            }
          }
          else {
            List<SellingItemsFields> list = [];
            item.forEach((element) {
              if (element.itemId == widget.itemdata!.id) {
                for (int i = 0; i < widget.itemdata!.priceVariation!.length; i++) {
                  if (widget.itemdata!.priceVariation![i].id == element.varId) {
                    list.add(SellingItemsFields(weight: double.parse(
                        widget.itemdata!.priceVariation![i].weight!),
                        varQty: int.parse(element.quantity.toString())));
                  }
                }
              }
            });
            if (Features.btobModule ? Check().isOutofStock(
                maxstock: double.parse(widget.priceVariation!.stock.toString()),
               stocktype:  widget.itemdata!.type!,
                qty: (productBox.where((element) => element.itemId == widget.itemdata!.id).length > 1)?quantityTotal.toString() :qty.toString(),
                itemData: [],
                variation: widget.priceVariation!)
                : Check().isOutofStock(
              maxstock: double.parse(widget.priceVariation!.stock.toString()),
              stocktype: widget.itemdata!.type!,
                qty: (productBox.where((element) => element.itemId == widget.itemdata!.id).length > 1)?quantityTotal.toString() :qty.toString(),
              itemData: list, variation: widget.priceVariation!,
            )) {
              Fluttertoast.showToast(
                  msg: S
                      .of(context)
                      .sorry_outofstock,
                  //"Sorry, Out of Stock!",
                  fontSize: MediaQuery
                      .of(context)
                      .textScaleFactor * 13,
                  backgroundColor: Colors.black87,
                  textColor: Colors.white);
            } else {
              List addToppingsProduct = [];
              if (Features.btobModule) {
                if ((productBox
                    .where((element) => element.itemId == widget.itemdata!.id)
                    .length > 1 ? quantityTotal : qty) <
                    double.parse(widget.priceVariation!.maxItem!)) {
                  cartcontroller.update((done) {
                    setState(() {
                      loading = !done;
                      widget.onChange!(widget.groupvalue!,(productBox
                          .where((element) => element.itemId == widget.itemdata!.id)
                      .length > 1 ?(int.parse(productBox
                          .where((element) => element.itemId == widget.itemdata!.id).first.quantity!)):(int.parse(productBox
                          .where((element) => element.itemId == widget.itemdata!.id).first.quantity!))));

                    });
                  }, price: widget.priceVariation!.price.toString(),
                      quantity: (qty + 1).toString(),
                      type: widget.itemdata!.type,
                      weight: "1",
                      var_id: varid,
                      increament: widget.itemdata!.increament,
                      cart_id: parent_id,
                      toppings: toppings,
                      topping_id: toppings_id,
                    item_id: widget.itemdata!.id.toString()
                  );
                }
                else {
                  if (productBox
                      .where((element) => element.itemId == widget.itemdata!.id)
                      .length > 1) {
                  }
                  else {
                    var varIdold = varid;
                    var varminitemold = widget.priceVariation!.minItem;
                    var varpriceold = widget.priceVariation!.price;
                    if (int.parse(widget.priceVariation!.minItem!) < qty && int.parse(widget.priceVariation!.maxItem!) > qty){;
                      varid = widget.priceVariation!.id!;
                      if ((productBox
                          .where((element) =>
                      element.itemId == widget.itemdata!.id).length > 1 ? quantityTotal : qty) <
                          double.parse(
                              widget.priceVariation!.maxItem!)){
                      }
                      else{
                        var varIdold = varid;
                        var varminitemold = widget.priceVariation!.minItem;
                        var varpriceold = widget.priceVariation!.price;
                        cartcontroller.update((done) {
                          setState(() {
                            loading = !done;
                          });
                        }, price: widget.priceVariation!.price.toString(),
                            quantity: (qty + 1).toString(),
                            type: widget.itemdata!.type,
                            weight: "1",
                            var_id: varid,
                            increament: widget.itemdata!.increament,
                            cart_id: parent_id,
                            toppings: toppings,
                            topping_id: toppings_id,
                            item_id: widget.itemdata!.id.toString()
                        );

                      }

                    }
                    else {
                      var varIdold = varid;
                      var varminitemold = widget.priceVariation!.minItem;
                      var varpriceold = widget.priceVariation!.price;
                      for (int i = widget.groupvalue!; i < widget.itemdata!.priceVariation!.length; i++) {
                        if (int.parse(productBox
                            .where((element) =>
                        element.itemId == widget.itemdata!.id).last.varId.toString()) == widget.itemdata!.priceVariation![i].id) {
                          widget.groupvalue = widget.groupvalue! + 1;
                        }
                        else {
                          if (int.parse(widget.itemdata!.priceVariation![i].maxItem.toString()) > qty) {
                            cartcontroller.update((done) {
                              setState(() {
                                loading = !done;
                                widget.onChange!(widget.groupvalue!,qty + 1);
                              });
                            }, price: widget.itemdata!.priceVariation![i].price!,
                                quantity: (qty + 1).toString(),
                                type: widget.itemdata!.type,
                                weight: "1",
                                var_id: varid,
                                increament: widget.itemdata!.increament,
                                cart_id: parent_id,
                                toppings: toppings,
                                topping_id: toppings_id,
                                item_id: widget.itemdata!.id.toString()
                            );
                          }
                          else {
                            if(int.parse(
                                widget.itemdata!.priceVariation![widget.itemdata!.priceVariation!.length -1].maxItem
                                    .toString()) <= qty) {
                              Fluttertoast.showToast(
                                  msg:
                                  S.of(context).cant_add_more_item, //"Sorry, you can\'t add more of this item!",
                                  fontSize: MediaQuery.of(context).textScaleFactor * 13,
                                  backgroundColor: Colors.black87,
                                  textColor: Colors.white);
                            }
                          }
                        }
                        widget.groupvalue = widget.groupvalue! + 1;
                        break;
                      }
                    }
                  }
                }
              }
              else {
                if ((productBox
                    .where((element) => element.itemId == widget.itemdata!.id)
                    .length > 1 ? quantityTotal : qty) <
                    double.parse(widget.priceVariation!.maxItem!)) {
                  cartcontroller.update((done) {
                    setState(() {
                      loading = !done;
                    });
                  }, price: widget.priceVariation!.price.toString(),
                      quantity: (qty + 1).toString(),
                      type: widget.itemdata!.type,
                      weight: "1",
                      var_id: varid,
                      increament: widget.itemdata!.increament,
                      cart_id: parent_id,
                      toppings: toppings,
                      topping_id: toppings_id,
                      item_id: widget.itemdata!.id.toString()
                  );
                }
                else {
                  Fluttertoast.showToast(
                      msg: S.of(context).cant_add_more_item, //"Sorry, you can\'t add more of this item!",
                      fontSize: MediaQuery.of(context).textScaleFactor * 13,
                      backgroundColor: Colors.black87,
                      textColor: Colors.white);
                }
              }
            }
          }
        }
          // TODO: Handle this case.
          break;
        case CartStatus.remove:
          cartcontroller.update((done){
            setState(() {
              loading = !done;
            });
          },
              price: widget.from == "search_screen" && Features.ismultivendor?widget.searchstoredata!.type=="1"?widget.searchstoredata!.price.toString():widget.searchstoredata!.price.toString():
          widget.itemdata!.type=="1"?widget.itemdata!.price.toString():widget.priceVariationSearch!.price.toString(),
              quantity:"0",weight:"0",var_id: widget.from == "search_screen" && Features.ismultivendor?widget.searchstoredata!.type=="1"?widget.searchstoredata!.id!:varid:widget.itemdata!.type=="1"?widget.itemdata!.id!:varid,
              type: widget.from == "search_screen" && Features.ismultivendor?widget.searchstoredata!.type:widget.itemdata!.type,
              increament:widget.from == "search_screen" && Features.ismultivendor?widget.searchstoredata!.increament: widget.itemdata!.increament,cart_id: parent_id,toppings: toppings,
              topping_id: toppings_id,
              item_id: widget.itemdata!.id.toString()
          );
          // TODO: Handle this case.
          break;
        case CartStatus.decrement:
          if (Features.btobModule) {
            if ((productBox.where((element) => element.itemId == widget.itemdata!.id).length > 1 ? quantityTotal : qty) < double.parse(widget.priceVariation!.maxItem!)) {
              cartcontroller.update((done) {
                setState(() {
                  loading = !done;
                  widget.onChange!(widget.groupvalue!,qty - 1);
                });
              },
                  price: widget.from == "search_screen" && Features.ismultivendor
                  ? widget.searchstoredata!.type == "1" ? widget.searchstoredata!
                  .price.toString() : widget.priceVariationSearch!.price
                  .toString()
                  : widget.itemdata!.type == "1" ? widget.itemdata!.price
                  .toString() : widget.priceVariation!.price.toString(),
                  quantity: widget.from == "search_screen" &&
                      Features.ismultivendor ?
                  widget.searchstoredata!.type == "1" ? ((weight) <=
                      (double.parse(widget.searchstoredata!.minItem!) *
                          double.parse(widget.searchstoredata!.increament!)))
                      ? "0"
                      : (qty).toString() : ((qty) <=
                      int.parse(widget.priceVariationSearch!.minItem!))
                      ? "0"
                      : (qty - 1).toString() :
                  widget.itemdata!.type == "1" ? ((weight) <=
                      (double.parse(widget.itemdata!.minItem!) *
                          double.parse(widget.itemdata!.increament!)))
                      ? "0"
                      : (qty).toString() : ((qty) <=
                      int.parse(widget.priceVariation!.minItem!)) ? "0" : (qty -
                      1).toString(),
                  weight: widget.from == "search_screen" && Features.ismultivendor
                      ?
                  widget.searchstoredata!.type == "1" ? ((weight) <=
                      (double.parse(widget.searchstoredata!.minItem!) *
                          double.parse(widget.searchstoredata!.increament!)))
                      ? "0"
                      : (weight -
                      double.parse(widget.searchstoredata!.increament!))
                      .toString() : "0"
                      : widget.itemdata!.type == "1" ? ((weight) <=
                      (double.parse(widget.itemdata!.minItem!) *
                          double.parse(widget.itemdata!.increament!)))
                      ? "0"
                      : (weight - double.parse(widget.itemdata!.increament!))
                      .toString() : "0",
                  var_id: widget.from == "search_screen" && Features.ismultivendor
                      ? widget.searchstoredata!.type == "1" ? widget
                      .searchstoredata!.id! : varid
                      : widget.itemdata!.type == "1"
                      ? widget.itemdata!.id!
                      : varid,
                  type: widget.from == "search_screen" && Features.ismultivendor
                      ? widget.searchstoredata!.type
                      : widget.itemdata!.type,
                  increament: widget.from == "search_screen" &&
                      Features.ismultivendor
                      ? widget.searchstoredata!.increament
                      : widget.itemdata!.increament,
                  cart_id: parent_id,
                  toppings: toppings,
                  topping_id: toppings_id,
                  item_id: widget.itemdata!.id.toString()
              );
            }
            else {
              if (productBox.where((element) => element.itemId == widget.itemdata!.id).length > 1) {
              }
              else {
                var varIdold = varid;
                var varminitemold = widget.priceVariation!.minItem;
                var varpriceold = widget.priceVariation!.price;

                  for (int i = widget.groupvalue!; i < widget.itemdata!.priceVariation!.length; i++) {
                    if (int.parse(widget.itemdata!.priceVariation![0].minItem.toString()) <= qty) {
                      cartcontroller.update((done) {
                        setState(() {
                          loading = !done;
                          widget.onChange!(widget.groupvalue!,qty - 1);
                        });
                      }, price: widget.from == "search_screen" && Features.ismultivendor
                          ? widget.searchstoredata!.type == "1" ? widget.searchstoredata!
                          .price.toString() : widget.priceVariationSearch!.price
                          .toString()
                          : widget.itemdata!.type == "1" ? widget.itemdata!.price
                          .toString() : widget.priceVariation!.price.toString(),
                          quantity: widget.from == "search_screen" &&
                              Features.ismultivendor ?
                          widget.searchstoredata!.type == "1" ? ((weight) <=
                              (double.parse(widget.searchstoredata!.minItem!) *
                                  double.parse(widget.searchstoredata!.increament!)))
                              ? "0"
                              : (qty).toString() : ((qty) <=
                              int.parse(widget.priceVariationSearch!.minItem!))
                              ? "0"
                              : (qty - 1).toString() :
                          widget.itemdata!.type == "1" ? ((weight) <=
                              (double.parse(widget.itemdata!.minItem!) *
                                  double.parse(widget.itemdata!.increament!)))
                              ? "0"
                              : (qty).toString() : ((qty) <=
                              int.parse(widget.priceVariation!.minItem!)) ? "0" : (qty -
                              1).toString(),
                          weight: widget.from == "search_screen" && Features.ismultivendor
                              ?
                          widget.searchstoredata!.type == "1" ? ((weight) <=
                              (double.parse(widget.searchstoredata!.minItem!) *
                                  double.parse(widget.searchstoredata!.increament!)))
                              ? "0"
                              : (weight -
                              double.parse(widget.searchstoredata!.increament!))
                              .toString() : "0"
                              : widget.itemdata!.type == "1" ? ((weight) <=
                              (double.parse(widget.itemdata!.minItem!) *
                                  double.parse(widget.itemdata!.increament!)))
                              ? "0"
                              : (weight - double.parse(widget.itemdata!.increament!))
                              .toString() : "0",
                          var_id: widget.from == "search_screen" && Features.ismultivendor
                              ? widget.searchstoredata!.type == "1" ? widget
                              .searchstoredata!.id! : varid
                              : widget.itemdata!.type == "1"
                              ? widget.itemdata!.id!
                              : varIdold,
                          type: widget.from == "search_screen" && Features.ismultivendor
                              ? widget.searchstoredata!.type
                              : widget.itemdata!.type,
                          increament: widget.from == "search_screen" &&
                              Features.ismultivendor
                              ? widget.searchstoredata!.increament
                              : widget.itemdata!.increament,
                          cart_id: parent_id,
                          toppings: toppings,
                          topping_id: toppings_id,
                          item_id: widget.itemdata!.id.toString()
                      );
                    }
                    else {
                      Fluttertoast.showToast(
                          msg: S.of(context).cant_add_more_item, //"Sorry, you can\'t add more of this item!",
                          fontSize: MediaQuery.of(context).textScaleFactor * 13,
                          backgroundColor: Colors.black87,
                          textColor: Colors.white);
                    }
                    if(int.parse(widget.itemdata!.priceVariation![i].minItem.toString()) == qty) {
                      if (widget.groupvalue! > 1) {
                        setState(() {
                          widget.groupvalue = widget.groupvalue! - 1;
                          widget.onChange!(widget.groupvalue!,qty-1);
                        });
                      }
                      else {
                        widget.groupvalue = 0;
                        widget.onChange!(widget.groupvalue!,qty -1);
                      }
                    }
                    break;
                  }
                }
            }
          }
          else {
            cartcontroller.update((done) {
              setState(() {
                loading = !done;
              });
            }, price: widget.from == "search_screen" && Features.ismultivendor
                ? widget.searchstoredata!.type == "1" ? widget.searchstoredata!
                .price.toString() : widget.priceVariationSearch!.price
                .toString()
                : widget.itemdata!.type == "1" ? widget.itemdata!.price
                .toString() : widget.priceVariation!.price.toString(),
                quantity: widget.from == "search_screen" &&
                    Features.ismultivendor ?
                widget.searchstoredata!.type == "1" ? ((weight) <=
                    (double.parse(widget.searchstoredata!.minItem!) *
                        double.parse(widget.searchstoredata!.increament!)))
                    ? "0"
                    : (qty).toString() : ((qty) <=
                    int.parse(widget.priceVariationSearch!.minItem!))
                    ? "0"
                    : (qty - 1).toString() :
                widget.itemdata!.type == "1" ? ((weight) <=
                    (double.parse(widget.itemdata!.minItem!) *
                        double.parse(widget.itemdata!.increament!)))
                    ? "0"
                    : (qty).toString() : ((qty) <=
                    int.parse(widget.priceVariation!.minItem!)) ? "0" : (qty -
                    1).toString(),
                weight: widget.from == "search_screen" && Features.ismultivendor
                    ?
                widget.searchstoredata!.type == "1" ? ((weight) <=
                    (double.parse(widget.searchstoredata!.minItem!) *
                        double.parse(widget.searchstoredata!.increament!)))
                    ? "0"
                    : (weight -
                    double.parse(widget.searchstoredata!.increament!))
                    .toString() : "0"
                    : widget.itemdata!.type == "1" ? ((weight) <=
                    (double.parse(widget.itemdata!.minItem!) *
                        double.parse(widget.itemdata!.increament!)))
                    ? "0"
                    : (weight - double.parse(widget.itemdata!.increament!))
                    .toString() : "0",
                var_id: widget.from == "search_screen" && Features.ismultivendor
                    ? widget.searchstoredata!.type == "1" ? widget
                    .searchstoredata!.id! : varid
                    : widget.itemdata!.type == "1"
                    ? widget.itemdata!.id!
                    : varid,
                type: widget.from == "search_screen" && Features.ismultivendor
                    ? widget.searchstoredata!.type
                    : widget.itemdata!.type,
                increament: widget.from == "search_screen" &&
                    Features.ismultivendor
                    ? widget.searchstoredata!.increament
                    : widget.itemdata!.increament,
                cart_id: parent_id,
                toppings: toppings,
                topping_id: toppings_id,
                item_id: widget.itemdata!.id.toString()
            );
          }
          // TODO: Handle this case.
          break;
      }
    }

    addToCart(String topping_type, String varid, String toppings, String? parent_id, String? newproduct,List addToppings ) async {
     if(widget.from == "search_screen" && Features.ismultivendor) {
       if (widget.searchstoredata!.type == "1") {
         cartcontroller.addtoCart( storeSearchData: widget.searchstoredata!,
             onload: (isloading) {
           setState(() {
             loading = isloading;
           });
         },topping_type: topping_type,varid: varid,toppings: toppings,parent_id: parent_id!,newproduct: newproduct!,toppingsList: addToppings,fromScreen: "search_screen",context: context);
         if(Features.isfacebookappevent)
           FaceBookAppEvents.facebookAppEvents.logAddToCart(id: int.parse(widget.searchstoredata!.id!).toString(), type: widget.searchstoredata!.itemName!, currency: IConstants.currencyFormat, price: widget.searchstoredata!.type=="1"?double.parse(widget.searchstoredata!.price.toString()):double.parse(widget.priceVariationSearch!.price.toString()));
       }
       else {
         cartcontroller.addtoCart(storeSearchData: widget.searchstoredata!, onload: (isloading) {
           setState(() {
             loading = isloading;
           });
         },topping_type: topping_type,varid: varid,toppings: toppings,parent_id: parent_id!,newproduct: newproduct!, toppingsList: addToppings,itembodysearch: widget.priceVariationSearch!,fromScreen: "search_screen",context: context);
       }
     }
     else{
       if (widget.itemdata!.type == "1") {
         cartcontroller.addtoCart(itemdata: widget.itemdata!, onload: (isloading) {
           setState(() {
             loading = isloading;
           });
         },topping_type: topping_type,varid: varid,toppings: toppings,parent_id: parent_id!,newproduct: newproduct!,toppingsList: addToppings,context: context);
       }
       else {
         if(Features.btobModule){
           cartcontroller.addtoCart(itemdata: widget.itemdata!, onload: (isloading) {
             setState(() {
               loading = isloading;
               widget.onChange!(widget.groupvalue!,(productBox
                   .where((element) => element.itemId == widget.itemdata!.id)
                   .length > 1 ?(int.parse(productBox
                   .where((element) => element.itemId == widget.itemdata!.id).first.quantity!)):1));
             });
           },topping_type: topping_type,varid: varid,toppings: toppings,parent_id: parent_id!,newproduct: newproduct!,toppingsList: addToppings, itembody: widget.priceVariation!,context: context);
         }
         else{
           cartcontroller.addtoCart(itemdata: widget.itemdata!, onload: (isloading) {
             setState(() {
               loading = isloading;
             });
           },topping_type: topping_type,varid: varid,toppings: toppings,parent_id: parent_id!,newproduct: newproduct!,toppingsList: addToppings, itembody: widget.priceVariation!,context: context);
         }

       }
       if(Features.isfacebookappevent)
         FaceBookAppEvents.facebookAppEvents.logAddToCart(id: int.parse(widget.itemdata!.id!).toString(), type: widget.itemdata!.itemName!, currency: IConstants.currencyFormat, price: widget.itemdata!.type=="1"?double.parse(widget.itemdata!.price.toString()):double.parse(widget.priceVariation!.price.toString()));
     }
    }

    toppingsExistance(varid, productid, List checktoppings, List addToppings, ) async {
      List<SellingItemsFields> list = [];
    if(widget.itemdata!.type != "1") {
      item.forEach((element) {
        if (element.itemId == widget.itemdata!.id) {
          for (int i = 0; i <
              widget.itemdata!.priceVariation!.length; i++) {
            if (widget.itemdata!.priceVariation![i].id == element.varId) {
              list.add(SellingItemsFields(weight: double.parse(
                  widget.itemdata!.priceVariation![i].weight!),
                  varQty: int.parse(element.quantity.toString())));
            }
          }
        }
      });
    }

      Map<String, String> resBody = {};
      resBody["id"] = (!PrefUtils.prefs!.containsKey("apikey")) ? PrefUtils.prefs!.getString("tokenid")! : PrefUtils.prefs!.getString('apikey')!;
      resBody["product"] = productid;
      resBody["variation"] = varid;
      if(checktoppings.length > 0) {
        for (int i = 0; i < checktoppings.length; i++) {
          resBody["toppings[" + i.toString() + "][id]"] =
          checktoppings[i]["id"];

        }
      }else{
        resBody["toppings[" "][id]"] = "[]";
      }
      var url = Api.viewToppingsExistingDetails ;
      final response = await http.post(url, body: resBody
      );

      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      if((widget.itemdata!.type == "1")?
      (weightTotal < double.parse(widget.itemdata!.stock.toString()))
      :
     !( Check().isOutofStock(
        maxstock: double.parse(widget.priceVariation!.stock.toString()),
        stocktype: widget.itemdata!.type!,
        qty: quantityTotal.toString() ,
        itemData: list,
        variation: widget.priceVariation!,
      ))) {
        if ((widget.itemdata!.type == "1") ? (weightTotal <
            (double.parse(widget.itemdata!.maxItem!) *
                double.parse(widget.itemdata!.increament!))) : (quantityTotal <
            double.parse(widget.priceVariation!.maxItem!))) {
          if (responseJson['status'].toString() == "400") {
            //add to cart
            if (addToppings.length > 0) {
              await addToCart(
                addToppingsProduct[0]["Toppings_type"],
                addToppingsProduct[0]["varId"],
                addToppingsProduct[0]["toppings"],
                "",
                addToppingsProduct[0]["newproduct"],
                addToppings,
              );
            } else {
              await addToCart(
                  addToppingsProduct[0]["Toppings_type"],
                  addToppingsProduct[0]["varId"],
                  addToppingsProduct[0]["toppings"],
                  "",
                  addToppingsProduct[0]["newproduct"],
                  addToppings
              );
            }
          }
          else if (responseJson['status'].toString() == "200") {
            //update cart
            final box = (VxState.store as GroceStore).CartItemList;
            (widget.from == "search_screen" && Features.ismultivendor) ?
            updateCart(
                widget.searchstoredata!.type == "1" ? int.parse(box
                    .where((element) =>
                element.itemId == widget.searchstoredata!.id &&
                    element.parent_id! == responseJson['parent_id'].toString())
                    .first
                    .quantity!) :
                int.parse(box
                    .where((element) =>
                element.varId ==
                    widget.priceVariationSearch!.id &&
                    element.parent_id! == responseJson['parent_id'].toString())
                    .first
                    .quantity!),
                widget.searchstoredata!.type == "1" ? double.parse(box
                    .where((element) =>
                element.itemId == widget.searchstoredata!.id &&
                    element.parent_id! == responseJson['parent_id'].toString())
                    .first
                    .weight!) : double.parse(box
                    .where((element) =>
                element.itemId == widget.searchstoredata!.id &&
                    element.parent_id! == responseJson['parent_id'].toString())
                    .first
                    .weight!),
                CartStatus.increment,
                widget.searchstoredata!.type == "1"
                    ? widget.searchstoredata!.id!
                    : widget.priceVariationSearch!.id!,
                productBox.last.parent_id!,
                "0",
                "") :
            updateCart(
                widget.itemdata!.type == "1" ? int.parse(box
                    .where((element) =>
                element.itemId == widget.itemdata!.id &&
                    element.parent_id! == responseJson['parent_id'].toString())
                    .first
                    .quantity!) :
                int.parse(box
                    .where((element) =>
                element.varId ==
                    widget.priceVariation!.id &&
                    element.parent_id! == responseJson['parent_id'].toString())
                    .first
                    .quantity!),
                widget.itemdata!.type == "1" ? double.parse(box
                    .where((element) =>
                element.itemId == widget.itemdata!.id &&
                    element.parent_id! == responseJson['parent_id'].toString())
                    .first
                    .weight!) : double.parse(box
                    .where((element) =>
                element.itemId == widget.itemdata!.id &&
                    element.parent_id! == responseJson['parent_id'].toString())
                    .first
                    .weight!),
                CartStatus.increment,
                widget.itemdata!.type == "1" ? widget.itemdata!.id! : widget
                    .priceVariation!.id!,
                responseJson['parent_id'].toString(),
                "0",
                "");
          }
          else {
            Fluttertoast.showToast(
              msg: S.of(context).something_went_wrong,
              fontSize: MediaQuery
                  .of(context)
                  .textScaleFactor * 13,
              backgroundColor: ColorCodes.blackColor,
              textColor: ColorCodes.whiteColor,);
          }
        }
        else {
          Fluttertoast.showToast(
              msg:
              S
                  .of(context)
                  .cant_add_more_item,
              //"Sorry, you can\'t add more of this item!",
              fontSize: MediaQuery
                  .of(context)
                  .textScaleFactor * 13,
              backgroundColor: Colors.black87,
              textColor: Colors.white);
        }
      }else{
        Fluttertoast.showToast(
            msg:
            S
                .of(context)
                .sorry_outofstock,
            fontSize: MediaQuery
                .of(context)
                .textScaleFactor * 13,
            backgroundColor: Colors.black87,
            textColor: Colors.white);
      }

    }

    Widget _myRadioButton({ String? title,  int? value,  Function(int?)? onChanged}) {
      return RadioListTile<int>(
        controlAffinity: ListTileControlAffinity.trailing,
        value: value!,
        groupValue: _groupValue,
        onChanged: onChanged!,
        title: Text(title!),
      );
    }

    dialogforToppings(BuildContext context){
      List addToppings = [];
      List checktoppings = [];
      List checktoppings1 =[];
      return
        showModalBottomSheet(
            shape:RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            context: context,
            builder: ( context) {
              return WillPopScope(
                onWillPop: (){
                  return Future.value(true);
                },
                child: Wrap(
                    children: [
                      StatefulBuilder(builder: (context, setState1)
                      {
                        return Container(
                          decoration: new BoxDecoration(
                              color: Colors.white,
                              borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(25.0),
                                  topRight: const Radius.circular(25.0))),
                          padding: EdgeInsets.only(left: 20, right: 20),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10,),
                              Text(
                                (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.itemName!:widget.itemdata!.itemName!, style: TextStyle(fontSize: 22,
                                  color: ColorCodes.blackColor,
                                  fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10,),
                              Divider(
                                thickness: 1, color: ColorCodes.greyColor, height: 1,),
                              SizedBox(height: 10,),
                              Text(S.of(context).customise, style: TextStyle(fontSize: 18,
                                  color: ColorCodes.blackColor,
                                  fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5,),
                              (widget.addon!.type == "1")?
                              Column(
                                children: [
                                  SingleChildScrollView(
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:widget.addon!.list!.length,
                                        itemBuilder: (_, i) {

                                          return

                                            Column(
                                              children: [
                                                GestureDetector(
                                                  onTap:(){

                                                    setState1((){

                                                      for(int j =0; j< widget.addon!.list!.length; j++){
                                                        if(i == j){
                                                          widget.addon!.list![j].isSelected = true;
                                                          varId = j;
                                                          addToppings.clear();
                                                          addToppings.add({"Toppings_type":"1","toppings_id":  widget.addon!.list![varId!].id!, "toppings_name":widget.addon!.list![varId!].name,"toppings_price":widget.addon!.list![varId!].price});
                                                        }else{
                                                          widget.addon!.list![j].isSelected = false;
                                                        }
                                                      }

                                                    });

                                                  },
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(width: 20,),
                                                      Container(
                                                        child: Text(
                                                          widget.addon!.list![i].name!+" - "+IConstants.currencyFormat + widget.addon!.list![i].price!,
                                                          style: TextStyle(color: (widget.addon!.list![i].isSelected == true) ?ColorCodes.greenColor:ColorCodes.blackColor,
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      handler(widget.addon!.list![i].isSelected),
                                                      SizedBox(width: 20,),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height:20,)
                                              ],
                                            );
                                        }),
                                  ),
                                  SizedBox(height: 20,),
                                  Row(
                                    children: [
                                      Text(((widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.type == "1" : widget.itemdata!.type=="1")?(widget.from == "search_screen" && Features.ismultivendor)?IConstants.currencyFormat + widget.searchstoredata!.price.toString():IConstants.currencyFormat + widget.itemdata!.price.toString(): (widget.from == "search_screen" && Features.ismultivendor)?IConstants.currencyFormat+widget.priceVariationSearch!.price.toString():IConstants.currencyFormat + widget.priceVariation!.price.toString()
                                        , style: TextStyle(fontSize: 20,
                                            color: ColorCodes.blackColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 10,),
                                      (widget.from == "search_screen" && Features.ismultivendor)?Text((widget.searchstoredata!.type=="1")? (widget.searchstoredata!.mrp.toString() != widget.searchstoredata!.price.toString()) ? S.of(context).subscribe_mrp+IConstants.currencyFormat + widget.searchstoredata!.mrp.toString():"":(widget.searchstoredata!.mrp.toString() != widget.searchstoredata!.price.toString()) ? S.of(context).subscribe_mrp+IConstants.currencyFormat + widget.priceVariationSearch!.mrp.toString():"",
                                        style: TextStyle(fontSize: 14,
                                          color: ColorCodes.greyColor,
                                        ),
                                      ):
                                      Text((widget.itemdata!.type=="1")? (widget.itemdata!.mrp.toString() != widget.itemdata!.price.toString()) ? S.of(context).subscribe_mrp+IConstants.currencyFormat + widget.itemdata!.mrp.toString():"":(widget.itemdata!.mrp.toString() != widget.itemdata!.price.toString()) ? S.of(context).subscribe_mrp+IConstants.currencyFormat + widget.priceVariation!.mrp.toString():"",
                                        style: TextStyle(fontSize: 14,
                                          color: ColorCodes.greyColor,
                                        ),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () async {
                                          if(addToppings.length > 0){
                                            checktoppings1.clear();
                                            for(int i =0; i< addToppings.length; i++){
                                              checktoppings1.add(addToppings[i]["toppings_id"]);
                                            }
                                          }

                                          if(checktoppings1.length > 1){
                                            checktoppings1.sort();
                                          }
                                          checktoppings.clear();
                                          for(int j =0; j< checktoppings1.length; j++){
                                            checktoppings.add({"id":checktoppings1[j]});
                                          }
                                          toppingsExistance((widget.itemdata!.type=="1")?addToppingsProduct[0]["productid"] :addToppingsProduct[0]["varId"],addToppingsProduct[0]["productid"],checktoppings,addToppings);
                                          for (int i = 0; i <
                                              widget.addon!.list!.length; i++)
                                            widget.addon!.list![i].isSelected = false;
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          width: 150,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5.0),
                                            border: Border.all(
                                                width: 1, color: ColorCodes.primaryColor),
                                          ),
                                          child: Center(
                                            child: Text(S.of(context).add_items,style: TextStyle(fontSize: 16,
                                                color: ColorCodes.primaryColor,
                                                fontWeight: FontWeight.bold), ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 10,)
                                ],
                              ):
                              Column(
                                children: [
                                  SingleChildScrollView(
                                    child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: widget.addon!.list!.length,
                                        itemBuilder: (_, i) {

                                          return GestureDetector(
                                            behavior: HitTestBehavior.translucent,
                                            onTap: (){

                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 10),
                                              margin: EdgeInsets.symmetric(vertical: 5),
                                              width: MediaQuery.of(context).size.width,
                                              child: Row(

                                                children: [
                                                  Checkbox(
                                                    value: widget.addon!.list![i].isSelected,
                                                    checkColor: ColorCodes.whiteColor,
                                                    activeColor: ColorCodes.primaryColor,
                                                    onChanged: (bool? val) {
                                                      setState1(() {
                                                        widget.addon!.list![i].isSelected = val!;
                                                      });
                                                      if (widget.addon!.list![i].isSelected == true) {
                                                        addToppings.add({"Toppings_type": "0","toppings_id":  widget.addon!.list![i].id!, "toppings_name":widget.addon!.list![i].name,"toppings_price":widget.addon!.list![i].price});
                                                      }else{
                                                        for(int i = 0; i< addToppings.length; i++){
                                                          addToppings.removeAt(i);
                                                        }
                                                      }
                                                      if(widget.addon!.list![i].isSelected == true) {
                                                        toppingscheck = "yes";
                                                      }
                                                    },
                                                  ),
                                                  SizedBox(width: 10,),
                                                  Text( widget.addon!.list![i].name!+" - "+IConstants.currencyFormat + widget.addon!.list![i].price!, style: TextStyle(fontSize: 16,
                                                      color: ColorCodes.greyColor,
                                                      fontWeight: FontWeight.bold),)
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                  SizedBox(height: 20,),
                                  Row(
                                    children: [
                                      (widget.from == "search_screen" && Features.ismultivendor)?
                                      Text((widget.searchstoredata!.type=="1")?IConstants.currencyFormat + widget.searchstoredata!.price.toString(): IConstants.currencyFormat + widget.priceVariationSearch!.price.toString()
                                        , style: TextStyle(fontSize: 20,
                                            color: ColorCodes.blackColor,
                                            fontWeight: FontWeight.bold),
                                      ):
                                      Text((widget.itemdata!.type=="1")?IConstants.currencyFormat + widget.itemdata!.price.toString(): IConstants.currencyFormat + widget.priceVariation!.price.toString()
                                        , style: TextStyle(fontSize: 20,
                                            color: ColorCodes.blackColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 10,),
                                      (widget.from == "search_screen" && Features.ismultivendor)?
                                      Text((widget.searchstoredata!.type=="1")? (widget.searchstoredata!.mrp.toString() != widget.searchstoredata!.price.toString()) ? S.of(context).subscribe_mrp+IConstants.currencyFormat + widget.searchstoredata!.mrp.toString():"":(widget.searchstoredata!.mrp.toString() != widget.searchstoredata!.price.toString()) ? S.of(context).subscribe_mrp+IConstants.currencyFormat + widget.priceVariationSearch!.mrp.toString():"",
                                        style: TextStyle(fontSize: 14,
                                          color: ColorCodes.greyColor,
                                        ),
                                      ):
                                      Text((widget.itemdata!.type=="1")? (widget.itemdata!.mrp.toString() != widget.itemdata!.price.toString()) ? S.of(context).subscribe_mrp+IConstants.currencyFormat + widget.itemdata!.mrp.toString():"":(widget.itemdata!.mrp.toString() != widget.itemdata!.price.toString()) ? S.of(context).subscribe_mrp+IConstants.currencyFormat + widget.priceVariation!.mrp.toString():"",
                                        style: TextStyle(fontSize: 14,
                                          color: ColorCodes.greyColor,
                                        ),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () async {
                                          bool _isProductAdded = false;

                                           if(addToppings.length > 0){
                                             checktoppings.clear();
                                             for(int i =0; i< addToppings.length; i++){
                                               checktoppings.add({"id":addToppings[i]["toppings_id"]});
                                             }
                                           }
                                          toppingsExistance((widget.itemdata!.type=="1")?addToppingsProduct[0]["productid"] :addToppingsProduct[0]["varId"],addToppingsProduct[0]["productid"],checktoppings,addToppings);
                                          for (int i = 0; i < widget.addon!.list!.length; i++) {
                                            widget.addon!.list![i].isSelected = false;
                                          }
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          width: 150,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5.0),
                                            border: Border.all(
                                                width: 1, color: ColorCodes.primaryColor),
                                          ),
                                          child: Center(
                                            child: Text(S.of(context).add_items,style: TextStyle(fontSize: 16,
                                                color: ColorCodes.primaryColor,
                                                fontWeight: FontWeight.bold), ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 10,)
                                ],
                              ),

                            ],
                          ),
                        );
                      }),]),
              );
            }
        );
    }

    dialogforUpdateToppings(BuildContext context) async {
      (widget.from == "search_screen" && Features.ismultivendor)?
      MyorderList().GetRepeateToppings((widget.searchstoredata!.type == "1")?
      widget.searchstoredata!.id!:
      widget.priceVariationSearch!.id!,
          widget.searchstoredata!.id!).then((value) {
        topupState(() {
          _futureNonavailable = Future.value(value);

        });
        _futureNonavailable.then((value) {
          parentidforupdate = value.first.parent_id!;
        });

      }):
      MyorderList().GetRepeateToppings((widget.itemdata!.type == "1")?
      widget.itemdata!.id!:
      widget.priceVariation!.id!,
          widget.itemdata!.id!).then((value) {
        topupState(() {
          _futureNonavailable = Future.value(value);
        });
        _futureNonavailable.then((value) {
          parentidforupdate = value.first.parent_id!;
        });
      });
      return
        showModalBottomSheet(
            shape:RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            context: context,
            builder: ( context) {
              return Wrap(
                  children: [
                    StatefulBuilder(builder: (context, setState1)
                    {
                      topupState = setState1;
                      return Container(
                        decoration: new BoxDecoration(
                            color: Colors.white,
                            borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(25.0),
                                topRight: const Radius.circular(25.0))),
                        padding: EdgeInsets.only(left: 20, right: 20),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10,),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 40,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    (widget.from == "search_screen" && Features.ismultivendor)?"   "+widget.searchstoredata!.itemName!: "   "+ widget.itemdata!.itemName!, style: TextStyle(fontSize: 20,
                                      color: ColorCodes.blackColor,
                                      fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10,),
                            Divider(
                              thickness: 1, color: ColorCodes.greyColor, height: 1,),
                            SizedBox(height: 10,),
                            Text(
                              S.of(context).previous_customisation, style: TextStyle(fontSize: 18,
                                color: ColorCodes.blackColor,
                                fontWeight: FontWeight.w400),
                            ),
                            SizedBox(height: 5,),
                            FutureBuilder<List<RepeatToppings>>(
                              future: _futureNonavailable,
                              builder: (BuildContext context,AsyncSnapshot<List<RepeatToppings>> snapshot){
                                final RepeatToppings = snapshot.data;
                                if (RepeatToppings!=null)
                                  return
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: RepeatToppings.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return Text(RepeatToppings[index].data![index].name!);
                                        });
                                else
                                  return SizedBox.shrink();

                              },
                            ),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: (){
                                    Navigator.of(context).pop();
                                    addToppingsProduct.clear();
                                    addToppingsProduct.add({"Toppings_type":"","varId":  (widget.itemdata!.type! =="1")?"":widget.priceVariation!.id!,"toppings":"0", "parent_id":  "","newproduct":"1","productid":widget.itemdata!.id}); //adding product
                                    dialogforToppings(context);
                                  },
                                  child: Container(
                                    width: 150,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      border: Border.all(
                                          width: 1, color: ColorCodes.primaryColor),
                                    ),
                                    child: Center(
                                      child: Text(S.of(context).i_will_choose,style: TextStyle(fontSize: 16,
                                          color: ColorCodes.primaryColor,
                                          fontWeight: FontWeight.bold), ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: ()   {
                                    final box = (VxState.store as GroceStore).CartItemList;

                                    Navigator.of(context).pop();
                                    (widget.from == "search_screen" && Features.ismultivendor)?
                                    updateCart(
                                        widget.searchstoredata!.type == "1"? int.parse(box
                                            .where((element) =>
                                        element.itemId == widget.searchstoredata!.id && element.parent_id! == parentidforupdate.toString())
                                            .first
                                            .quantity! ):
                                        int.parse(box
                                            .where((element) =>
                                        element.varId ==
                                            widget.priceVariationSearch!.id && element.parent_id! == parentidforupdate.toString())
                                            .first
                                            .quantity!),
                                        widget.searchstoredata!.type == "1"?  double.parse(box
                                            .where((element) =>
                                        element.itemId == widget.searchstoredata!.id && element.parent_id! == parentidforupdate.toString())
                                            .first
                                            .weight!): double.parse(box
                                            .where((element) =>
                                        element.itemId == widget.searchstoredata!.id && element.parent_id! == parentidforupdate.toString())
                                            .first
                                            .weight!),
                                        CartStatus.increment,
                                        widget.searchstoredata!.type == "1"? widget.searchstoredata!.id!:widget.priceVariationSearch!.id!,
                                        parentidforupdate.toString(),
                                        "0",
                                        ""):
                                    updateCart(
                                       widget.itemdata!.type == "1"? int.parse(box
                                        .where((element) =>
                                    element.itemId == widget.itemdata!.id && element.parent_id! == parentidforupdate.toString())
                                        .first
                                        .quantity!):
                                       int.parse(box
                                           .where((element) =>
                                       element.varId ==
                                           widget.priceVariation!.id && element.parent_id! == parentidforupdate.toString())
                                           .first
                                           .quantity!),
                                       widget.itemdata!.type == "1"?  double.parse(box
                                            .where((element) =>
                                        element.itemId == widget.itemdata!.id && element.parent_id! == parentidforupdate.toString())
                                            .first
                                            .weight!): double.parse(box
                                           .where((element) =>
                                       element.itemId == widget.itemdata!.id && element.parent_id! == parentidforupdate.toString())
                                           .first
                                           .weight!),
                                        CartStatus.increment,
                                       widget.itemdata!.type == "1"? widget.itemdata!.id!:widget.priceVariation!.id!,
                                        parentidforupdate.toString(),
                                        "0",
                                        "");

                                  },
                                  child: Container(
                                    width: 150,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      border: Border.all(
                                          width: 1, color: ColorCodes.primaryColor),
                                    ),
                                    child: Center(
                                      child: Text(S.of(context).repeat_topppings,style: TextStyle(fontSize: 16,
                                          color: ColorCodes.primaryColor,
                                          fontWeight: FontWeight.bold), ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 10,)
                          ],
                        ),
                      );
                    }),]);
            }
        );
    }

    dialogforDeleteToppings(BuildContext context) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.0)),
            child: Container(
              height: 150,
              padding: EdgeInsets.only(left: 10),
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  Center(child:

                  Text(S.of(context).remove_cart, style: TextStyle(fontSize: 20),)
                  ),
                  SizedBox(height: 10,),
                  Text(S.of(context).multiple_customization,style: TextStyle(fontSize: 14),),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop();
                          Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(color: ColorCodes.greenColor),
                          ),
                          width: 60,
                          height: 30,
                          child: Center(
                            child: Text(
                              S.of(context).yes,style: TextStyle(color: ColorCodes.greenColor), //'yes'
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 60,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(color: ColorCodes.greenColor),
                          ),
                          child: Center(
                            child: Text(
                              S.of(context).no,style: TextStyle(color: ColorCodes.greenColor), //'no'
                            ),
                          ),
                        ),
                      )

                    ],
                  )
                ],
              ),
            ),

          );
        },
      );
    }


    _notifyMe() async {
      setState(() {
        _isNotify = true;
      });
      int resposne = await Provider.of<BrandItemsList>(context, listen: false).notifyMe((widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.id.toString():widget.itemdata!.id.toString(),(widget.from == "search_screen" && Features.ismultivendor)?widget.priceVariationSearch!.id.toString():widget.priceVariation!.id.toString(),(widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.type!:widget.itemdata!.type!);
      if(resposne == 200) {
        setState(() {
          _isNotify = false;
        });
        Fluttertoast.showToast(msg: S .of(context).you_will_notify,//"You will be notified via SMS/Push notification, when the product is available" ,
            fontSize: MediaQuery.of(context).textScaleFactor *13,
            backgroundColor:
            Colors.black87,
            textColor: Colors.white);

      } else {
        Fluttertoast.showToast(msg: S .of(context).something_went_wrong,//"Something went wrong" ,
            fontSize: MediaQuery.of(context).textScaleFactor *13,
            backgroundColor:
            Colors.black87,
            textColor: Colors.white);
        setState(() {
          _isNotify = false;
        });
      }
    }

    return widget.from == "search_screen" && Features.ismultivendor?
    widget.searchstoredata!.type == "1" ? VxBuilder(
        mutations: {SetCartItem},
        builder: (context, store, index) {
          final box = (VxState.store as GroceStore).CartItemList;
          stepperButtons.clear();
          if (widget.searchstoredata!.stock! <= 0){
            if(widget.issubscription == "Add")  stepperButtons.add(NotificationStepper(
                context, alignmnt: widget.alignmnt,
                fontsize: widget.fontSize!,
                onTap: () {

                  if(!PrefUtils.prefs!.containsKey("apikey") &&Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                    LoginWeb(context,result: (sucsess){
                      if(sucsess){
                        Navigator.of(context).pop();
                        Navigation(context, navigatore: NavigatoreTyp.homenav);
                      }else{
                        Navigator.of(context).pop();
                      }
                    });
                  }
                  else{
                    if (!PrefUtils.prefs!.containsKey("apikey")) {
                      Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push);

                    }
                    else {
                      _notifyMe();
                    }
                  }
                }, isnotify: _isNotify));
          }
          else{
            if(widget.alignmnt == StepperAlignment.Vertical) {
              if(widget.issubscription == "Subscribe")  stepperButtons.add(AddSubsciptionStepper(
                  context, search: widget.searchstoredata!,
                  alignmnt: widget.alignmnt,
                  fontsize: widget.fontSize!,
                  from_screen: "search_screen",
                  onTap: () {

                    if(!PrefUtils.prefs!.containsKey("apikey") &&Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                      LoginWeb(context,result: (sucsess){
                        if(sucsess){
                          Navigator.of(context).pop();
                          Navigation(context, navigatore: NavigatoreTyp.homenav);
                        }else{
                          Navigator.of(context).pop();
                        }
                      });
                    }
                    else{
                      if (!PrefUtils.prefs!.containsKey("apikey")) {
                        Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push);

                      }
                      else {
                        Navigation(context, name: Routename.SubscribeScreen, navigatore: NavigatoreTyp.Push,
                            qparms: {
                              "itemid": widget.searchstoredata!.id,
                              "itemname": widget.searchstoredata!.itemName,
                              "itemimg": widget.searchstoredata!.itemFeaturedImage,
                              "weight" : widget.searchstoredata!.weight,
                              "varname": widget.searchstoredata!.itemName,
                              "varmrp":widget.searchstoredata!.mrp.toString(),
                              "varprice": widget.searchstoredata!.price.toString(),
                              "paymentMode": widget.searchstoredata!.paymentMode,
                              "cronTime": widget.searchstoredata!.subscriptionSlot![0].cronTime,
                              "name": widget.searchstoredata!.subscriptionSlot![0].name,
                              "varid":widget.searchstoredata!.id,
                              "brand": widget.searchstoredata!.brand,
                              "membershipdisplay":widget.searchstoredata!.membershipDisplay! ,
                              "discountdisplay":widget.searchstoredata!.discointDisplay!,
                              "membershipprice":widget.searchstoredata!.membershipPrice,
                              "deliveriesarray": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].deliveries :widget.itemdata!.subscriptionSlot![0].deliveries,
                              "daily":(widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].daily :widget.itemdata!.subscriptionSlot![0].daily,
                              "dailyDays": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].dailyDays :widget.itemdata!.subscriptionSlot![0].dailyDays,
                              "weekend": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].weekend :widget.itemdata!.subscriptionSlot![0].weekend,
                              "weekendDays": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].weekendDays :widget.itemdata!.subscriptionSlot![0].weekendDays,
                              "weekday": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].weekday :widget.itemdata!.subscriptionSlot![0].weekday,
                              "weekdayDays": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].weekdayDays :widget.itemdata!.subscriptionSlot![0].weekdayDays,
                              "custom": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].custom :widget.itemdata!.subscriptionSlot![0].custom,
                              "alternativeDays": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].alternativeDays :widget.itemdata!.subscriptionSlot![0].alternativeDays,
                              "customDays": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].customDays :widget.itemdata!.subscriptionSlot![0].customDays,
                              "varType": widget.itemdata?.type
                            });
                      }
                    }


                  }));
              if(widget.issubscription == "Add") {
                if (box
                    .where((element) => element.itemId == widget.searchstoredata!.id && element.type == widget.searchstoredata!.type)
                    .length <= 0 || double.parse(box
                    .where((element) => element.itemId == widget.searchstoredata!.id)
                    .first
                    .weight!) <= 0){
                  stepperButtons.add(AddItemSteppr(
                      context, fontSize: widget.fontSize!,
                      alignmnt: widget.alignmnt,
                      onTap: () {
                        if (widget.addon == null) {
                          addToCart("", "", "0", "", "0", []);
                        } else {
                          addToppingsProduct.clear();
                          addToppingsProduct.add({
                            "Toppings_type": "",
                            "varId":  (widget.itemdata!.type! =="1")?"":widget.priceVariation!.id!,
                            "toppings": "0",
                            "parent_id": "",
                            "newproduct": "0",
                            "productid":widget.itemdata!.id
                          });
                          dialogforToppings(context);
                        }
                      },
                      isloading: loading));}
                else {
                  int quantity = 0;
                  double weight = 0.0;
                  for (int i = 0; i < box.length; i++) {
                    if (box[i].itemId == widget.searchstoredata!.id &&
                        box[i].toppings == "0") {
                      quantity = quantity + int.parse(box[i].quantity!);
                      weight = weight + double.parse(box[i].weight!);
                    }
                  }

                  stepperButtons.add(
                      UpdateItemSteppr(context,
                          quantity: (box.where((element) => element.itemId ==
                              widget.searchstoredata!.id && element.toppings == "0")
                              .count() > 1) ?
                          quantity
                              : (widget.addon != null) ? (box
                              .where((element) =>
                          element.itemId == widget.searchstoredata!.id)
                              .length * int.parse(box
                              .where((element) =>
                          element.itemId == widget.searchstoredata!.id)
                              .first
                              .quantity!)) : int.parse(box
                              .where((element) =>
                          element.itemId == widget.searchstoredata!.id)
                              .first
                              .quantity!),
                          weight: (box.where((element) =>
                          element.itemId == widget.searchstoredata!.id &&
                              element.toppings == "0")
                              .count() > 1) ?
                          weight
                              : (widget.addon != null) ? totalWeight()
                              : double.parse(box
                              .where((element) =>
                          element.itemId == widget.searchstoredata!.id)
                              .first
                              .weight!),
                          fontSize: widget.fontSize!,
                          skutype: box
                              .where((element) =>
                          element.itemId == widget.searchstoredata!.id)
                              .first
                              .type!,
                          unit: widget.searchstoredata!.unit ?? "kg",
                          onTap: (cartStatus) {
                            if (cartStatus == CartStatus.increment) {
                              if (widget.addon == null) {
                                updateCart(
                                  int.parse(box
                                      .where((element) =>
                                  element.itemId == widget.searchstoredata!.id)
                                      .first
                                      .quantity!),
                                  double.parse(box
                                      .where((element) =>
                                  element.itemId == widget.searchstoredata!.id)
                                      .first
                                      .weight!),
                                  cartStatus,
                                  widget.searchstoredata!.id!,
                                  productBox.last.id!,
                                  "0",
                                  "",);
                              }
                              else {
                                dialogforUpdateToppings(context);
                              }
                            } else {
                              if(box.where((element) => element.itemId == widget.searchstoredata!.id).length > 1 ){
                                dialogforDeleteToppings(context);
                              }else {
                                updateCart(
                                  int.parse(box
                                      .where((element) =>
                                  element.itemId == widget.searchstoredata!.id)
                                      .first
                                      .quantity!),
                                  double.parse(box
                                      .where((element) =>
                                  element.itemId == widget.searchstoredata!.id)
                                      .first
                                      .weight!),
                                  cartStatus,
                                  widget.searchstoredata!.id!,
                                  productBox.last.id!,
                                  "0",
                                  "",);
                              }
                            }
                          },
                          alignmnt: widget.alignmnt,
                          isloading: loading));
                }
              }

            }
            else {
              if (box
                  .where((element) => element.itemId == widget.searchstoredata!.id && element.type == widget.searchstoredata!.type )
                  .length <= 0 || int.parse(box
                  .where((element) => element.itemId == widget.searchstoredata!.id)
                  .first
                  .quantity!) <= 0)
                stepperButtons.add(AddItemSteppr(
                    context, fontSize: widget.fontSize!,
                    alignmnt: widget.alignmnt,
                    onTap: () {
                      if (widget.addon == null) {
                        addToCart("", "", "0", "", "0",[]);
                      } else {
                        addToppingsProduct.clear();
                        addToppingsProduct.add({"Toppings_type":"","varId":   (widget.itemdata!.type! =="1")?"":widget.priceVariation!.id!,"toppings":"0", "parent_id":  "","newproduct":"0","productid":widget.itemdata!.id});
                        dialogforToppings(context);
                      }
                    },
                    isloading: loading));
              else
              {
                int quantity = 0;
                double weight = 0.0;
                if(box.where((element) => element.itemId == widget.searchstoredata!.id).count() >= 1){
                  for( int i = 0;i < box.length ;i++){
                    if(box[i].itemId == widget.searchstoredata!.id && box[i].toppings =="0"){
                      quantity = quantity + int.parse(box[i].quantity!);
                      weight = weight + double.parse(box[i].weight!);
                    }

                  }
                }
                stepperButtons.add(
                    UpdateItemSteppr(context, quantity: (box.where((element) => element.itemId == widget.searchstoredata!.id && element.toppings == "0").count() > 1
                    )?
                    quantity
                        :(widget.addon != null)?(box.where((element) => element.itemId == widget.searchstoredata!.id).length * int.parse(box
                        .where((element) =>
                    element.itemId == widget.searchstoredata!.id)
                        .first
                        .quantity!)):int.parse(box
                        .where((element) =>
                    element.itemId == widget.searchstoredata!.id)
                        .first
                        .quantity!),

                        weight: (box.where((element) => element.itemId == widget.searchstoredata!.id && element.toppings == "0").count() >= 1
                            )?
                        weight
                            : (widget.addon != null) ? totalWeight():
                        double.parse(box
                            .where((element) =>
                        element.itemId == widget.searchstoredata!.id)
                            .first
                            .weight!),
                        fontSize: widget.fontSize!,
                        skutype: box
                            .where((element) =>
                        element.itemId == widget.searchstoredata!.id)
                            .first
                            .type!,
                        unit: widget.searchstoredata!.unit!,
                        onTap: (cartStatus) {
                          if (cartStatus == CartStatus.increment) {
                            if (widget.addon == null) {
                              updateCart(
                                int.parse(box
                                    .where((element) =>
                                element.itemId == widget.searchstoredata!.id)
                                    .first
                                    .quantity!),
                                double.parse(box
                                    .where((element) =>
                                element.itemId == widget.searchstoredata!.id)
                                    .first
                                    .weight!),
                                cartStatus,
                                widget.searchstoredata!.id!,
                                productBox.last.id!,
                                "0",
                                "",);
                            }
                            else
                              dialogforUpdateToppings(context);
                          } else {
                            if(box.where((element) => element.itemId == widget.searchstoredata!.id).length > 1 ){
                              dialogforDeleteToppings(context);
                            }else {
                              updateCart(
                                int.parse(box
                                    .where((element) =>
                                element.itemId == widget.searchstoredata!.id)
                                    .first
                                    .quantity!),
                                double.parse(box
                                    .where((element) =>
                                element.itemId == widget.searchstoredata!.id)
                                    .first
                                    .weight!),
                                cartStatus,
                                widget.searchstoredata!.id!,
                                productBox.last.id!,
                                "0",
                                "",);
                            }
                          }
                        },
                        alignmnt: widget.alignmnt,
                        isloading: loading));
              }


              stepperButtons.add(AddSubsciptionStepper(
                  context, search: widget.searchstoredata!,
                  alignmnt: widget.alignmnt,
                  fontsize: widget.fontSize!,
                  onTap: () {
                    if(!PrefUtils.prefs!.containsKey("apikey") &&Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                      LoginWeb(context,result: (sucsess){
                        if(sucsess){
                          Navigator.of(context).pop();
                          Navigation(context, navigatore: NavigatoreTyp.homenav);
                        }else{
                          Navigator.of(context).pop();
                        }
                      });
                    }
                    else{
                      if (!PrefUtils.prefs!.containsKey("apikey")) {
                        Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push);

                      }
                    }
                  }));
            }
          }
          return widget.alignmnt == StepperAlignment.Vertical
              ? SizedBox(
              height: widget.height,
              width: widget.width,
              child:Column(
                children: stepperButtons,
              ))
              : Container(
              height: widget.height,
              width: widget.width,
              child:
              Row(
                children: stepperButtons,

              ));
        })
        :
    VxBuilder(
        mutations: {SetCartItem},
        builder: (context, store, index) {
          final box = (VxState.store as GroceStore).CartItemList;
          stepperButtons.clear();
          if (widget.priceVariationSearch!.stock! <= 0){
            if(widget.issubscription == "Add")  stepperButtons.add(NotificationStepper(
                context, alignmnt: widget.alignmnt,
                fontsize: widget.fontSize!,
                onTap: () {
                  if(!PrefUtils.prefs!.containsKey("apikey") &&Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                    LoginWeb(context,result: (sucsess){
                      if(sucsess){
                        Navigator.of(context).pop();
                        Navigation(context, navigatore: NavigatoreTyp.homenav);
                      }else{
                        Navigator.of(context).pop();
                      }
                    });
                  }
                  else{
                    if (!PrefUtils.prefs!.containsKey("apikey")) {
                      Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push);
                    }
                    else {
                      _notifyMe();
                    }
                  }
                }, isnotify: _isNotify));
          }
          else{
            if(widget.alignmnt == StepperAlignment.Vertical) {
              if(widget.issubscription == "Subscribe") stepperButtons.add(AddSubsciptionStepper(
                  context, search: widget.searchstoredata!,
                  alignmnt: widget.alignmnt,
                  fontsize: widget.fontSize!,
                  from_screen: "search_screen",
                  onTap: () {

                    if(!PrefUtils.prefs!.containsKey("apikey") &&Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                      LoginWeb(context,result: (sucsess){
                        if(sucsess){
                          Navigator.of(context).pop();
                          Navigation(context, navigatore: NavigatoreTyp.homenav);
                        }else{
                          Navigator.of(context).pop();
                        }
                      });
                    }
                    else{
                      if (!PrefUtils.prefs!.containsKey("apikey")) {
                        Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push);

                      }
                      else {
                        Navigation(context, name: Routename.SubscribeScreen, navigatore: NavigatoreTyp.Push,
                            qparms: {
                              "itemid": widget.searchstoredata!.id,
                              "itemname": widget.searchstoredata!.itemName,
                              "itemimg": widget.searchstoredata!.itemFeaturedImage,
                              "weight" : widget.searchstoredata!.weight,
                              "varname": widget.searchstoredata!.priceVariation![widget.index].variationName !+ widget.searchstoredata!.priceVariation![widget.index].unit!,
                              "varmrp":widget.searchstoredata!.priceVariation![widget.index].mrp.toString(),
                              "varprice": widget.searchstoredata!.priceVariation![widget.index].price.toString(),
                              "paymentMode": widget.searchstoredata!.paymentMode,
                              "cronTime": widget.searchstoredata!.subscriptionSlot![0].cronTime,
                              "name": widget.searchstoredata!.subscriptionSlot![0].name,
                              "varid":widget.searchstoredata!.priceVariation![widget.index].id,
                              "brand": widget.searchstoredata!.brand,
                              "membershipdisplay":widget.searchstoredata!.priceVariation![widget.index].membershipDisplay! ,
                              "discountdisplay":widget.searchstoredata!.priceVariation![widget.index].discointDisplay!,
                              "membershipprice":widget.searchstoredata!.priceVariation![widget.index].membershipPrice,
                              "deliveriesarray": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].deliveries :widget.itemdata!.subscriptionSlot![0].deliveries,
                              "daily":(widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].daily :widget.itemdata!.subscriptionSlot![0].daily,
                              "dailyDays": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].dailyDays :widget.itemdata!.subscriptionSlot![0].dailyDays,
                              "weekend": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].weekend :widget.itemdata!.subscriptionSlot![0].weekend,
                              "weekendDays": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].weekendDays :widget.itemdata!.subscriptionSlot![0].weekendDays,
                              "weekday": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].weekday :widget.itemdata!.subscriptionSlot![0].weekday,
                              "weekdayDays": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].weekdayDays :widget.itemdata!.subscriptionSlot![0].weekdayDays,
                              "custom": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].custom :widget.itemdata!.subscriptionSlot![0].custom,
                              "alternativeDays": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].alternativeDays :widget.itemdata!.subscriptionSlot![0].alternativeDays,
                              "customDays": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].customDays :widget.itemdata!.subscriptionSlot![0].customDays,
                              "varType": widget.itemdata?.type
                            });
                      }
                    }


                  }));
              if(widget.issubscription == "Add") {
                if (box
                    .where((element) =>
                element.varId == widget.priceVariationSearch!.id)
                    .length <= 0 || int.parse(box
                    .where((element) =>
                element.varId == widget.priceVariationSearch!.id).first
                    .quantity!) <= 0){
                  stepperButtons.add(AddItemSteppr(
                      context, fontSize: widget.fontSize!,
                      alignmnt: widget.alignmnt,
                      onTap: () {
                        if (widget.addon == null) {
                          addToCart("", "", "0", "", "0", []);
                        } else {
                          addToppingsProduct.clear();
                          addToppingsProduct.add({
                            "Toppings_type": "",
                            "varId":  (widget.searchstoredata!.type! =="1")?"":widget.priceVariationSearch!.id!,
                            "toppings": "0",
                            "parent_id": "",
                            "newproduct": "0",
                            "productid":widget.searchstoredata!.id
                          });
                          dialogforToppings(context);
                        }
                      },
                      isloading: loading));}
                else {
                  int quantity = 0;
                  double weight = 0.0;

                  for (int i = 0; i < box.length; i++) {
                    if (box[i].varId == widget.priceVariationSearch!.id &&
                        box[i].toppings == "0") {

                      quantity = quantity + int.parse(box[i].quantity!);
                      weight = weight + double.parse(box[i].weight!);
                    }
                  }

                  stepperButtons.add(
                      UpdateItemSteppr(context,
                          quantity: (box.where((element) => element.varId ==
                              widget.priceVariationSearch!.id &&
                              element.toppings == "1")).count() >= 1 ?
                          quantity
                              : (widget.addon != null) ? totalquantity()
                              : int.parse(box
                              .where((element) =>
                          element.varId == widget.priceVariationSearch!.id)
                              .first
                              .quantity!),
                          weight: ((box.where((element) =>
                          element.itemId == widget.searchstoredata!.id &&
                              element.toppings == "0")
                              .count()) > 1
                             )
                              ?
                          weight
                              : (widget.addon != null) ? double.parse(
                              (box.where((element) =>
                              element.itemId == widget.searchstoredata!.id).count() *
                                  double.parse(box
                                      .where((element) =>
                                  element.itemId == widget.searchstoredata!.id)
                                      .first
                                      .weight!)).toString()) : double.parse(
                              box
                                  .where((element) =>
                              element.itemId == widget.searchstoredata!.id)
                                  .first
                                  .weight!),
                          fontSize: widget.fontSize!,
                          skutype: box
                              .where((element) =>
                          element.varId == widget.priceVariationSearch!.id)
                              .first
                              .type!,
                          unit: widget.priceVariationSearch!.unit!,
                          onTap: (cartStatus) {
                            if (cartStatus == CartStatus.increment) {
                              if (widget.addon == null) {
                                updateCart(
                                  int.parse(box
                                      .where((element) =>
                                  element.varId ==
                                      widget.priceVariationSearch!.id)
                                      .first
                                      .quantity!),
                                  double.parse(box
                                      .where((element) =>
                                  element.itemId == widget.searchstoredata!.id)
                                      .first
                                      .weight!),
                                  cartStatus,
                                  widget.priceVariationSearch!.id!,
                                  productBox.last.id!,
                                  "0",
                                  "",);
                              }
                              else
                                dialogforUpdateToppings(context);
                            } else {
                              if(box.where((element) => element.itemId == widget.searchstoredata!.id).length > 1 ){
                                dialogforDeleteToppings(context);
                              }else {
                                updateCart(
                                  int.parse(box
                                      .where((element) =>
                                  element.varId ==
                                      widget.priceVariationSearch!.id)
                                      .first
                                      .quantity!),
                                  double.parse(box
                                      .where((element) =>
                                  element.itemId == widget.searchstoredata!.id)
                                      .first
                                      .weight!),
                                  cartStatus,
                                  widget.priceVariationSearch!.id!,
                                  productBox.last.id!,
                                  "0",
                                  "",);
                              }
                            }
                          },
                          alignmnt: widget.alignmnt,
                          isloading: loading));
                }
              }
            }
            else{
              if (box.where((element) => element.varId == widget.priceVariationSearch!.id).length <= 0 || int.parse(box.where((element) => element.varId == widget.priceVariationSearch!.id).first.quantity!) <= 0)
               {
                 stepperButtons.add(AddItemSteppr(
                    context, fontSize: widget.fontSize!,alignmnt: widget.alignmnt,onTap: () {
                  if(widget.addon == null) {
                    addToCart("", "", "0","","0",[]);
                  }else {
                    addToppingsProduct.clear();
                    addToppingsProduct.add({"Toppings_type":"","varId":   (widget.searchstoredata!.type! =="1")?"":widget.priceVariationSearch!.id!,"toppings":"0", "parent_id":  "","newproduct":"0","productid":widget.itemdata!.id});
                    dialogforToppings(context);
                  }
                },isloading: loading));}
              else {
                int quantity = 0;
                double weight = 0.0;

                for( int i = 0;i < box.length ;i++){
                  if(box[i].varId == widget.priceVariationSearch!.id && box[i].toppings =="0") {
                    quantity = quantity + int.parse(box[i].quantity!);
                    weight = weight + double.parse(box
                        .where((element) =>
                    element.itemId == widget.priceVariationSearch!.id)
                        .first
                        .weight!);
                  }

                }

                stepperButtons.add(
                    UpdateItemSteppr(context, quantity:  (box.where((element) =>  element.varId == widget.priceVariationSearch!.id && element.toppings == "1")).count() >= 1?
                    quantity
                        :(widget.addon != null)? totalquantity():int.parse(box
                        .where((element) =>
                    element.varId == widget.priceVariationSearch!.id)
                        .first
                        .quantity!),
                        weight: (box.where((element) => element.itemId == widget.searchstoredata!.id && element.toppings == "0").count()> 1) ?
                        weight
                            :(widget.addon != null)?double.parse((box.where((element) => element.itemId == widget.searchstoredata!.id).count() *  double.parse(box
                            .where((element) =>
                        element.itemId == widget.searchstoredata!.id)
                            .first
                            .weight!)).toString()): double.parse(box
                            .where((element) =>
                        element.itemId == widget.searchstoredata!.id)
                            .first
                            .weight!),
                        fontSize: widget.fontSize!,
                        skutype: box
                            .where((element) =>
                        element.varId == widget.priceVariationSearch!.id)
                            .first
                            .type!,
                        unit: widget.priceVariationSearch!.unit!,
                        onTap: (cartStatus) {
                          if (cartStatus == CartStatus.increment) {
                            if (widget.addon == null) {
                              updateCart(
                                int.parse(box
                                    .where((element) =>
                                element.varId == widget.priceVariationSearch!.id)
                                    .first
                                    .quantity!),
                                double.parse(box
                                    .where((element) =>
                                element.itemId == widget.searchstoredata!.id)
                                    .first
                                    .weight!),
                                cartStatus,
                                widget.priceVariationSearch!.id!,
                                productBox.last.id!,
                                "0",
                                "",);
                            }
                            else
                              dialogforUpdateToppings(context);
                          } else {
                            if(box.where((element) => element.itemId == widget.searchstoredata!.id).length > 1 ){
                              dialogforDeleteToppings(context);
                            }else {
                              updateCart(
                                int.parse(box
                                    .where((element) =>
                                element.varId ==
                                    widget.priceVariationSearch!.id)
                                    .first
                                    .quantity!),
                                double.parse(box
                                    .where((element) =>
                                element.itemId == widget.searchstoredata!.id)
                                    .first
                                    .weight!),
                                cartStatus,
                                widget.priceVariationSearch!.id!,
                                productBox.last.id!,
                                "0",
                                "",);
                            }
                          }
                        },
                        alignmnt: widget.alignmnt,
                        isloading: loading));
              }

              stepperButtons.add(AddSubsciptionStepper(
                  context, search: widget.searchstoredata!,
                  alignmnt: widget.alignmnt,
                  fontsize: widget.fontSize!,
                  from_screen: "search_screen",
                  onTap: () {
                    if(!PrefUtils.prefs!.containsKey("apikey") &&Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                      LoginWeb(context,result: (sucsess){
                        if(sucsess){
                          Navigator.of(context).pop();
                          Navigation(context, navigatore: NavigatoreTyp.homenav);
                        }else{
                          Navigator.of(context).pop();
                        }
                      });
                    }
                    else{
                      if (!PrefUtils.prefs!.containsKey("apikey")) {
                        Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push);

                      }
                      else {
                        Navigation(context, name: Routename.SubscribeScreen, navigatore: NavigatoreTyp.Push,
                            qparms: {
                              "itemid": widget.searchstoredata!.id,
                              "itemname": widget.searchstoredata!.itemName,
                              "itemimg": widget.searchstoredata!.itemFeaturedImage,
                              "weight" : widget.searchstoredata!.weight,
                              "varname": widget.searchstoredata!.priceVariation![widget.index].variationName !+ widget.searchstoredata!.priceVariation![widget.index].unit!,
                              "varmrp":widget.searchstoredata!.priceVariation![widget.index].mrp.toString(),
                              "varprice": widget.searchstoredata!.priceVariation![widget.index].price.toString(),
                              "paymentMode": widget.searchstoredata!.paymentMode,
                              "cronTime": widget.searchstoredata!.subscriptionSlot![0].cronTime,
                              "name": widget.searchstoredata!.subscriptionSlot![0].name,
                              "varid":widget.searchstoredata!.priceVariation![widget.index].id,
                              "brand": widget.searchstoredata!.brand,
                              "membershipdisplay":widget.searchstoredata!.priceVariation![widget.index].membershipDisplay! ,
                              "discountdisplay":widget.searchstoredata!.priceVariation![widget.index].discointDisplay!,
                              "membershipprice":widget.searchstoredata!.priceVariation![widget.index].membershipPrice,
                              "deliveriesarray": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].deliveries :widget.itemdata!.subscriptionSlot![0].deliveries,
                              "daily":(widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].daily :widget.itemdata!.subscriptionSlot![0].daily,
                              "dailyDays": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].dailyDays :widget.itemdata!.subscriptionSlot![0].dailyDays,
                              "weekend": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].weekend :widget.itemdata!.subscriptionSlot![0].weekend,
                              "weekendDays": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].weekendDays :widget.itemdata!.subscriptionSlot![0].weekendDays,
                              "weekday": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].weekday :widget.itemdata!.subscriptionSlot![0].weekday,
                              "weekdayDays": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].weekdayDays :widget.itemdata!.subscriptionSlot![0].weekdayDays,
                              "custom": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].custom :widget.itemdata!.subscriptionSlot![0].custom,
                              "alternativeDays": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].alternativeDays :widget.itemdata!.subscriptionSlot![0].alternativeDays,
                              "customDays": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].customDays :widget.itemdata!.subscriptionSlot![0].customDays,
                              "varType": widget.itemdata?.type
                            });
                      }
                    }


                  }));
            }

          }
          return widget.alignmnt == StepperAlignment.Vertical
              ? SizedBox(
              height: widget.height,
              width: widget.width,
              child:Column(
                children: stepperButtons,
              ))
              : Container(
              height: widget.height,
              width: widget.width,
              child:
              Row(
                children: stepperButtons,

              ));
        })
        :
      widget.itemdata!.type == "1" ? Center(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: VxBuilder(
            mutations: {SetCartItem},
            builder: (context, store, index) {
              final box = (VxState.store as GroceStore).CartItemList;
              stepperButtons.clear();
              if (widget.itemdata!.stock! <= 0){
                if(widget.issubscription == "Add")  stepperButtons.add(NotificationStepper(
                    context, alignmnt: widget.alignmnt,
                    fontsize: widget.fontSize!,
                    onTap: () {

                      if(!PrefUtils.prefs!.containsKey("apikey") &&Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                        LoginWeb(context,result: (sucsess){
                          if(sucsess){
                            Navigator.of(context).pop();
                            Navigation(context, navigatore: NavigatoreTyp.homenav);
                          }else{
                            Navigator.of(context).pop();
                          }
                        });
                      }
                      else{
                        if (!PrefUtils.prefs!.containsKey("apikey")) {
                          Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push);

                        }
                        else {
                          _notifyMe();
                        }
                      }
                    }, isnotify: _isNotify));
              }
              else{
                if(widget.alignmnt == StepperAlignment.Vertical) {
                  if(widget.issubscription == "Subscribe")  stepperButtons.add(AddSubsciptionStepper(
                      context, itemdata: widget.itemdata!,
                      alignmnt: widget.alignmnt,
                      fontsize: widget.fontSize!,
                      onTap: () {

                        if(!PrefUtils.prefs!.containsKey("apikey") &&Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                          LoginWeb(context,result: (sucsess){
                            if(sucsess){
                              Navigator.of(context).pop();
                              Navigation(context, navigatore: NavigatoreTyp.homenav);
                            }else{
                              Navigator.of(context).pop();
                            }
                          });
                        }
                        else{
                          if (!PrefUtils.prefs!.containsKey("apikey")) {
                            Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push);

                          }
                          else {
                            Navigation(context, name: Routename.SubscribeScreen, navigatore: NavigatoreTyp.Push,
                                qparms: {
                                  "itemid": widget.itemdata!.id,
                                  "itemname": widget.itemdata!.itemName,
                                  "itemimg": widget.itemdata!.itemFeaturedImage,
                                  "weight" : widget.itemdata!.weight,
                                  "varname": widget.itemdata!.itemName,
                                  "varmrp":widget.itemdata!.mrp.toString(),
                                  "varprice": widget.itemdata!.price.toString(),
                                  "paymentMode": widget.itemdata!.paymentMode,
                                  "cronTime": widget.itemdata!.subscriptionSlot![0].cronTime,
                                  "name": widget.itemdata!.subscriptionSlot![0].name,
                                  "varid":widget.itemdata!.id,
                                  "brand": widget.itemdata!.brand,
                                  "membershipdisplay":widget.itemdata!.membershipDisplay,
                                  "discountdisplay":widget.itemdata!.discointDisplay,
                                  "membershipprice":widget.itemdata!.membershipPrice,
                                  "deliveriesarray": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].deliveries :widget.itemdata!.subscriptionSlot![0].deliveries,
                                  "daily":(widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].daily :widget.itemdata!.subscriptionSlot![0].daily,
                                  "dailyDays": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].dailyDays :widget.itemdata!.subscriptionSlot![0].dailyDays,
                                  "weekend": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].weekend :widget.itemdata!.subscriptionSlot![0].weekend,
                                  "weekendDays": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].weekendDays :widget.itemdata!.subscriptionSlot![0].weekendDays,
                                  "weekday": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].weekday :widget.itemdata!.subscriptionSlot![0].weekday,
                                  "weekdayDays": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].weekdayDays :widget.itemdata!.subscriptionSlot![0].weekdayDays,
                                  "custom": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].custom :widget.itemdata!.subscriptionSlot![0].custom,
                                  "alternativeDays": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].alternativeDays :widget.itemdata!.subscriptionSlot![0].alternativeDays,
                                  "customDays": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].customDays :widget.itemdata!.subscriptionSlot![0].customDays,
                                  "varType": widget.itemdata?.type
                                });
                          }
                        }


                      }));
                  if(widget.issubscription == "Add") {
                    if (box.where((element) => element.itemId == widget.itemdata!.id && element.type == widget.itemdata!.type).length <= 0 ||
                        double.parse(box.where((element) => element.itemId == widget.itemdata!.id).first.weight!) <= 0)
                      stepperButtons.add(AddItemSteppr(
                          context, fontSize: widget.fontSize!,
                          alignmnt: widget.alignmnt,
                          onTap: () {
                            if (widget.addon == null) {
                              addToCart("", "", "0", "", "0", []);
                            } else {
                              addToppingsProduct.clear();
                              addToppingsProduct.add({
                                "Toppings_type": "",
                                "varId":  (widget.itemdata!.type! =="1")?"":widget.priceVariation!.id!,
                                "toppings": "0",
                                "parent_id": "",
                                "newproduct": "0",
                                "productid":widget.itemdata!.id
                              });
                              dialogforToppings(context);
                            }
                          },
                          isloading: loading));
                    else {
                      int quantity = 0;
                      double weight = 0.0;
                      for (int i = 0; i < box.length; i++) {
                        if (box[i].itemId == widget.itemdata!.id && box[i].toppings == "0") {

                          quantity = quantity + int.parse(box[i].quantity!);
                          weight = weight + double.parse(box[i].weight!);
                        }
                      }

                      if(VxState.store.userData.membership! == "1"){
                        widget.checkmembership = true;
                      } else {
                        widget.checkmembership = false;
                        for (int i = 0; i < productBox.length; i++) {
                          if (productBox[i].mode == "1") {
                            widget.checkmembership = true;
                          }
                        }
                      }

                      stepperButtons.add(
                          UpdateItemSteppr(context,
                              quantity: (box.where((element) => element.itemId ==
                                  widget.itemdata!.id && element.toppings == "0")
                                  .count() > 1) ?
                              quantity
                                  : (widget.addon != null) ? (box
                                  .where((element) =>
                              element.itemId == widget.itemdata!.id)
                                  .length * int.parse(box
                                  .where((element) =>
                              element.itemId == widget.itemdata!.id)
                                  .first
                                  .quantity!)) : int.parse(box
                                  .where((element) =>
                              element.itemId == widget.itemdata!.id)
                                  .first
                                  .quantity!),


                              weight: (box.where((element) =>
                              element.itemId == widget.itemdata!.id &&
                                  element.toppings == "1")
                                  .count() >= 1) ?
                              weight
                                  : (widget.addon != null) ?
                              totalWeight()
                                  : double.parse(box
                                  .where((element) =>
                              element.itemId == widget.itemdata!.id)
                                  .first
                                  .weight!),
                              fontSize: widget.fontSize!,
                              skutype: box
                                  .where((element) =>
                              element.itemId == widget.itemdata!.id)
                                  .first
                                  .type!,
                              unit: widget.itemdata!.unit ?? "kg",
                              maxItem: widget.itemdata!.maxItem,
                              minItem: widget.itemdata!.minItem,
                              count: widget.itemdata!.increament,
                              price: widget.checkmembership!?widget.itemdata!.membershipDisplay!?double.parse(widget.itemdata!.membershipPrice!):double.parse(widget.itemdata!.price!):double.parse(widget.itemdata!.price!),
                              varid: widget.itemdata!.id,
                              incvalue: widget.itemdata!.increament,
                              Cart_id: box.last.parent_id,

                              onTap: (cartStatus) {
                                if (cartStatus == CartStatus.increment) {
                                  if (widget.addon == null) {
                                    updateCart(
                                        int.parse(box
                                            .where((element) =>
                                        element.itemId == widget.itemdata!.id)
                                            .first
                                            .quantity!),
                                        double.parse(box
                                            .where((element) =>
                                        element.itemId == widget.itemdata!.id)
                                            .first
                                            .weight!),
                                        cartStatus,
                                        widget.itemdata!.id!,
                                        productBox.last.id!,
                                        "0",
                                        "",);
                                  }
                                  else {
                                    dialogforUpdateToppings(context);
                                  }
                                } else {
                                  if(box.where((element) => element.itemId == widget.itemdata!.id).length > 1 ){
                                    dialogforDeleteToppings(context);
                                  }else {
                                    updateCart(
                                      int.parse(box
                                          .where((element) =>
                                      element.itemId == widget.itemdata!.id)
                                          .first
                                          .quantity!),

                                      double.parse(box
                                          .where((element) =>
                                      element.itemId == widget.itemdata!.id)
                                          .first
                                          .weight!),

                                      cartStatus,
                                      widget.itemdata!.id!,
                                      Features.btobModule || widget.itemdata!.type! =="1" ?
                                      box.where((element) => element.itemId == widget.itemdata!.id).first.parent_id!
                                          : box.where((element) => element.varId == widget.priceVariation!.id).first.parent_id!,
                                      "0",
                                      "",);
                                  }
                                }
                              },
                              alignmnt: widget.alignmnt,
                              isloading: loading));
                    }
                  }

                }
                else {
                  if (box
                      .where((element) => element.itemId == widget.itemdata!.id && element.type == widget.itemdata!.type)
                      .length <= 0 || int.parse(box
                      .where((element) => element.itemId == widget.itemdata!.id)
                      .first
                      .quantity!) <= 0) {
                    stepperButtons.add(AddItemSteppr(
                        context, fontSize: widget.fontSize!,
                        alignmnt: widget.alignmnt,
                        onTap: () {
                          if (widget.addon == null) {
                            addToCart("", "", "0", "", "0", []);
                          } else {
                            addToppingsProduct.clear();
                            addToppingsProduct.add(
                                {
                                  "Toppings_type": "",
                                  "varId": (widget.itemdata!.type! == "1")
                                      ? ""
                                      : widget.priceVariation!.id!,
                                  "toppings": "0",
                                  "parent_id": "",
                                  "newproduct": "0",
                                  "productid": widget.itemdata!.id
                                });
                            dialogforToppings(context);
                          }
                        },
                        isloading: loading));
                  }
                  else
                  {
                    int quantity = 0;
                    double weight = 0.0;
                    if(box.where((element) => element.itemId == widget.itemdata!.id).count() >= 1){
                      for( int i = 0;i < box.length ;i++){
                        if(box[i].itemId == widget.itemdata!.id && box[i].toppings =="0"){
                          quantity = quantity + int.parse(box[i].quantity!);
                          weight = weight + double.parse(box[i].weight!);
                        }

                      }
                    }
                    stepperButtons.add(
                        UpdateItemSteppr(context, quantity: (box.where((element) => element.itemId == widget.itemdata!.id && element.toppings == "0").count() > 1
                        )?
                        quantity
                            :(widget.addon != null)?(box.where((element) => element.itemId == widget.itemdata!.id).length * int.parse(box
                            .where((element) =>
                        element.itemId == widget.itemdata!.id)
                            .first
                            .quantity!)):int.parse(box
                            .where((element) =>
                        element.itemId == widget.itemdata!.id)
                            .first
                            .quantity!),

                            weight: (box.where((element) => element.itemId == widget.itemdata!.id && element.toppings == "1").count() >= 1)?
                            weight
                                : (widget.addon != null) ? totalWeight():
                            double.parse(box
                                .where((element) =>
                            element.itemId == widget.itemdata!.id)
                                .first
                                .weight!),

                            fontSize: widget.fontSize!,
                            skutype: box
                                .where((element) =>
                            element.itemId == widget.itemdata!.id)
                                .first
                                .type!,
                            unit: widget.itemdata!.unit!,
                            onTap: (cartStatus) {
                              if (cartStatus == CartStatus.increment) {
                                if (widget.addon == null) {
                                  updateCart(
                                    int.parse(box
                                        .where((element) =>
                                    element.itemId == widget.itemdata!.id)
                                        .first
                                        .quantity!),
                                    double.parse(box
                                        .where((element) =>
                                    element.itemId == widget.itemdata!.id)
                                        .first
                                        .weight!),
                                    cartStatus,
                                    widget.itemdata!.id!,
                                    Features.btobModule || widget.itemdata!.type! =="1" ?
                                    box.where((element) => element.itemId == widget.itemdata!.id).first.parent_id!
                                        : box.where((element) => element.varId == widget.priceVariation!.id).first.parent_id!,
                                    "0",
                                    "",);
                                }
                                else
                                  dialogforUpdateToppings(context);
                              } else {
                                if(box.where((element) => element.itemId == widget.itemdata!.id).length > 1 ){
                                  dialogforDeleteToppings(context);
                                }else {
                                  updateCart(
                                    int.parse(box
                                        .where((element) =>
                                    element.itemId == widget.itemdata!.id)
                                        .first
                                        .quantity!),
                                    double.parse(box
                                        .where((element) =>
                                    element.itemId == widget.itemdata!.id)
                                        .first
                                        .weight!),
                                    cartStatus,
                                    widget.itemdata!.id!,
                                    Features.btobModule || widget.itemdata!.type! =="1" ?
                                    box.where((element) => element.itemId == widget.itemdata!.id).first.parent_id!
                                        : box.where((element) => element.varId == widget.priceVariation!.id).first.parent_id!,
                                    "0",
                                    "",);
                                }
                              }
                            },
                            alignmnt: widget.alignmnt,
                            isloading: loading));
                  }


                  stepperButtons.add(AddSubsciptionStepper(
                      context, itemdata: widget.itemdata!,
                      alignmnt: widget.alignmnt,
                      fontsize: widget.fontSize!,
                      onTap: () {
                        if(!PrefUtils.prefs!.containsKey("apikey") &&Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                          LoginWeb(context,result: (sucsess){
                            if(sucsess){
                              Navigator.of(context).pop();
                              Navigation(context, navigatore: NavigatoreTyp.homenav);
                            }else{
                              Navigator.of(context).pop();
                            }
                          });
                        }
                        else{
                          if (!PrefUtils.prefs!.containsKey("apikey")) {
                            Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push);
                          }
                        }


                      }));
                }

              }
              return widget.alignmnt == StepperAlignment.Vertical
                  ? SizedBox(
                  height: widget.height,
                  width: widget.width,
                  child:Column(
                    children: stepperButtons,
                  ))
                  : Container(
                  height: widget.height,
                  width: widget.width,
                  child:
                  Row(
                    children: stepperButtons,

                  ));
            }),
        ),
      ):
    VxBuilder(
        mutations: {SetCartItem},
        builder: (context, store, index) {
          final box = (VxState.store as GroceStore).CartItemList;
          stepperButtons.clear();
          if (widget.priceVariation!.stock! <= 0){
            if(widget.issubscription == "Add")  stepperButtons.add(NotificationStepper(
                context, alignmnt: widget.alignmnt,
                fontsize: widget.fontSize!,
                onTap: () {
                  if(!PrefUtils.prefs!.containsKey("apikey") &&Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                    LoginWeb(context,result: (sucsess){
                      if(sucsess){
                        Navigator.of(context).pop();
                        Navigation(context, navigatore: NavigatoreTyp.homenav);
                      }else{
                        Navigator.of(context).pop();
                      }
                    });
                  }
                  else{
                    if (!PrefUtils.prefs!.containsKey("apikey")) {
                      Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push);
                    }
                    else {
                      _notifyMe();
                    }
                  }
                }, isnotify: _isNotify));
          }
          else{
            if(widget.alignmnt == StepperAlignment.Vertical) {
              if(widget.issubscription == "Subscribe") stepperButtons.add(AddSubsciptionStepper(
                  context, itemdata: widget.itemdata!,
                  alignmnt: widget.alignmnt,
                  fontsize: widget.fontSize!,
                  onTap: () {

                    if(!PrefUtils.prefs!.containsKey("apikey") &&Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                      LoginWeb(context,result: (sucsess){
                        if(sucsess){
                          Navigator.of(context).pop();
                          Navigation(context, navigatore: NavigatoreTyp.homenav);
                        }else{
                          Navigator.of(context).pop();
                        }
                      });
                    }
                    else{
                      if (!PrefUtils.prefs!.containsKey("apikey")) {
                        Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push);
                      }
                      else {
                        Navigation(context, name: Routename.SubscribeScreen, navigatore: NavigatoreTyp.Push,
                            qparms: {
                              "itemid": widget.itemdata!.id,
                              "itemname": widget.itemdata!.itemName,
                              "itemimg": widget.itemdata!.itemFeaturedImage,
                              "weight" : widget.itemdata!.weight,
                              "varname": widget.itemdata!.priceVariation![widget.index].variationName !+ widget.itemdata!.priceVariation![widget.index].unit!,
                              "varmrp":widget.itemdata!.priceVariation![widget.index].mrp.toString(),
                              "varprice": widget.itemdata!.priceVariation![widget.index].price.toString(),
                              "paymentMode": widget.itemdata!.paymentMode,
                              "cronTime": widget.itemdata!.subscriptionSlot![0].cronTime,
                              "name": widget.itemdata!.subscriptionSlot![0].name,
                              "varid":widget.itemdata!.priceVariation![widget.index].id,
                              "brand": widget.itemdata!.brand,
                              "membershipdisplay":widget.itemdata!.priceVariation![widget.index].membershipDisplay! ,
                              "discountdisplay":widget.itemdata!.priceVariation![widget.index].discointDisplay!,
                              "membershipprice":widget.itemdata!.priceVariation![widget.index].membershipPrice,
                              "deliveriesarray": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].deliveries :widget.itemdata!.subscriptionSlot![0].deliveries,
                              "daily":(widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].daily :widget.itemdata!.subscriptionSlot![0].daily,
                              "dailyDays": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].dailyDays :widget.itemdata!.subscriptionSlot![0].dailyDays,
                              "weekend": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].weekend :widget.itemdata!.subscriptionSlot![0].weekend,
                              "weekendDays": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].weekendDays :widget.itemdata!.subscriptionSlot![0].weekendDays,
                              "weekday": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].weekday :widget.itemdata!.subscriptionSlot![0].weekday,
                              "weekdayDays": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].weekdayDays :widget.itemdata!.subscriptionSlot![0].weekdayDays,
                              "custom": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].custom :widget.itemdata!.subscriptionSlot![0].custom,
                              "alternativeDays": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].alternativeDays :widget.itemdata!.subscriptionSlot![0].alternativeDays,
                              "customDays": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].customDays :widget.itemdata!.subscriptionSlot![0].customDays,
                              "varType": widget.itemdata?.type
                            });
                      }
                    }


                  }));
              if(widget.issubscription == "Add") {
                if(Features.btobModule){
                  if (box
                      .where((element) =>
                  element.itemId == widget.itemdata!.id &&
                      element.type == widget.itemdata!.type)
                      .length <= 0 ||
                      int.parse(box
                          .where((element) =>
                      element.itemId == widget.itemdata!.id)
                          .first
                          .quantity!) <= 0) {
                    stepperButtons.add(AddItemSteppr(
                        context, fontSize: widget.fontSize!,
                        alignmnt: widget.alignmnt,
                        onTap: () {
                          if (widget.addon == null) {
                            addToCart("", "", "0", "", "0", []);
                          } else {
                            addToppingsProduct.clear();
                            addToppingsProduct.add({
                              "Toppings_type": "",
                              "varId": (widget.itemdata!.type! == "1")
                                  ? ""
                                  : widget.priceVariation!.id!,
                              "toppings": "0",
                              "parent_id": "",
                              "newproduct": "0",
                              "productid": widget.itemdata!.id
                            });
                            dialogforToppings(context);
                          }
                        },
                        isloading: loading));
                  }
                  else {
                    int quantity = 0;
                    double weight = 0.0;

                    for (int i = 0; i < box.length; i++) {
                      if (box[i].varId == widget.priceVariation!.id &&
                          box[i].toppings == "0") {
                        quantity = quantity + int.parse(box[i].quantity!);
                        weight = weight + double.parse(box[i].weight!);
                      }
                    }

                    stepperButtons.add(
                        UpdateItemSteppr(context,
                            quantity: (box.where((element) =>
                            element.itemId ==
                                widget.itemdata!.id &&
                                element.toppings == "1")).count() >= 1 ?
                            quantity
                                : (widget.addon != null) ? totalquantity()
                                : int.parse(box
                                .where((element) =>
                            element.itemId ==
                                widget.itemdata!.id)
                                .first
                                .quantity!),

                            weight: ((box.where((element) =>
                            element.itemId == widget.itemdata!.id &&
                                element.toppings == "0")
                                .count()) > 1)
                                ?
                            weight
                                : (widget.addon != null) ? double.parse(
                                (box.where((element) =>
                                element.itemId == widget.itemdata!.id).count() *
                                    double.parse(box
                                        .where((element) =>
                                    element.itemId == widget.itemdata!.id)
                                        .first
                                        .weight!)).toString()) : double.parse(
                                box
                                    .where((element) =>
                                element.itemId == widget.itemdata!.id)
                                    .first
                                    .weight!),
                            fontSize: widget.fontSize!,
                            skutype: box
                                .where((element) =>
                            element.itemId == widget.itemdata!.id)
                                .first
                                .type!,
                            unit: widget.priceVariation!.unit!,
                            onTap: (cartStatus) {
                              if (cartStatus == CartStatus.increment) {
                                if (widget.addon == null) {
                                  updateCart(
                                    int.parse(box
                                        .where((element) =>
                                    element.itemId == widget.itemdata!.id)
                                        .first
                                        .quantity!),
                                    double.parse(box
                                        .where((element) =>
                                    element.itemId == widget.itemdata!.id)
                                        .first
                                        .weight!),
                                    cartStatus,
                                    widget.priceVariation!.id!,
                                    Features.btobModule ||
                                        widget.itemdata!.type! == "1" ?
                                    box
                                        .where((element) =>
                                    element.itemId == widget.itemdata!.id)
                                        .first
                                        .parent_id!
                                        : box
                                        .where((element) =>
                                    element.itemId == widget.itemdata!.id)
                                        .first
                                        .parent_id!,
                                    "0",
                                    "",);
                                }
                                else
                                  dialogforUpdateToppings(context);
                              } else {
                                if (box
                                    .where((element) =>
                                element.itemId == widget.itemdata!.id)
                                    .length > 1) {
                                  dialogforDeleteToppings(context);
                                } else {
                                  updateCart(
                                    int.parse(box
                                        .where((element) =>
                                    element.itemId == widget.itemdata!.id)
                                        .first
                                        .quantity!),
                                    double.parse(box
                                        .where((element) =>
                                    element.itemId == widget.itemdata!.id)
                                        .first
                                        .weight!),
                                    cartStatus,
                                    widget.priceVariation!.id!,
                                    Features.btobModule ||
                                        widget.itemdata!.type! == "1" ?
                                    box
                                        .where((element) =>
                                    element.itemId == widget.itemdata!.id)
                                        .first
                                        .parent_id!
                                        : box
                                        .where((element) =>
                                    element.itemId == widget.itemdata!.id)
                                        .first
                                        .parent_id!,
                                    "0",
                                    "",);
                                }
                              }
                            },
                            alignmnt: widget.alignmnt,
                            isloading: loading));
                  }
                }
                else {
                  if (box
                      .where((element) =>
                  element.varId == widget.priceVariation!.id &&
                      element.type == widget.itemdata!.type)
                      .length <= 0 ||
                      int.parse(box
                          .where((element) =>
                      element.varId == widget.priceVariation!.id)
                          .first
                          .quantity!) <= 0) {
                    stepperButtons.add(AddItemSteppr(
                        context, fontSize: widget.fontSize!,
                        alignmnt: widget.alignmnt,
                        onTap: () {
                          if (widget.addon == null) {
                            addToCart("", "", "0", "", "0", []);
                          } else {
                            addToppingsProduct.clear();
                            addToppingsProduct.add({
                              "Toppings_type": "",
                              "varId": (widget.itemdata!.type! == "1")
                                  ? ""
                                  : widget.priceVariation!.id!,
                              "toppings": "0",
                              "parent_id": "",
                              "newproduct": "0",
                              "productid": widget.itemdata!.id
                            });
                            dialogforToppings(context);
                          }
                        },
                        isloading: loading));
                  }
                  else {
                    int quantity = 0;
                    double weight = 0.0;

                    for (int i = 0; i < box.length; i++) {
                      if (box[i].varId == widget.priceVariation!.id &&
                          box[i].toppings == "0") {
                        quantity = quantity + int.parse(box[i].quantity!);
                        weight = weight + double.parse(box[i].weight!);
                      }
                    }

                    stepperButtons.add(
                        UpdateItemSteppr(context,
                            quantity: (box.where((element) =>
                            element.varId ==
                                widget.priceVariation!.id &&
                                element.toppings == "1")).count() >= 1 ?
                            quantity
                                : (widget.addon != null) ? totalquantity()
                                : int.parse(box
                                .where((element) =>
                            element.varId == widget.priceVariation!.id)
                                .first
                                .quantity!),

                            weight: ((box.where((element) =>
                            element.itemId == widget.itemdata!.id &&
                                element.toppings == "0")
                                .count()) > 1)
                                ?
                            weight
                                : (widget.addon != null) ? double.parse(
                                (box.where((element) =>
                                element.itemId == widget.itemdata!.id).count() *
                                    double.parse(box
                                        .where((element) =>
                                    element.itemId == widget.itemdata!.id)
                                        .first
                                        .weight!)).toString()) : double.parse(
                                box
                                    .where((element) =>
                                element.itemId == widget.itemdata!.id)
                                    .first
                                    .weight!),
                            fontSize: widget.fontSize!,
                            skutype: box
                                .where((element) =>
                            element.varId == widget.priceVariation!.id)
                                .first
                                .type!,
                            unit: widget.priceVariation!.unit!,
                            onTap: (cartStatus) {
                              if (cartStatus == CartStatus.increment) {
                                if (widget.addon == null) {
                                  updateCart(
                                    int.parse(box
                                        .where((element) =>
                                    element.varId == widget.priceVariation!.id)
                                        .first
                                        .quantity!),
                                    double.parse(box
                                        .where((element) =>
                                    element.itemId == widget.itemdata!.id)
                                        .first
                                        .weight!),
                                    cartStatus,
                                    widget.priceVariation!.id!,
                                    Features.btobModule ||
                                        widget.itemdata!.type! == "1" ?
                                    box
                                        .where((element) =>
                                    element.itemId == widget.itemdata!.id)
                                        .first
                                        .parent_id!
                                        : box
                                        .where((element) =>
                                    element.varId == widget.priceVariation!.id)
                                        .first
                                        .parent_id!,
                                    "0",
                                    "",);
                                }
                                else
                                  dialogforUpdateToppings(context);
                              } else {
                                if (box
                                    .where((element) =>
                                element.itemId == widget.itemdata!.id)
                                    .length > 1) {
                                  dialogforDeleteToppings(context);
                                } else {
                                  updateCart(
                                    int.parse(box
                                        .where((element) =>
                                    element.varId == widget.priceVariation!.id)
                                        .first
                                        .quantity!),
                                    double.parse(box
                                        .where((element) =>
                                    element.itemId == widget.itemdata!.id)
                                        .first
                                        .weight!),
                                    cartStatus,
                                    widget.priceVariation!.id!,
                                    Features.btobModule ||
                                        widget.itemdata!.type! == "1" ?
                                    box
                                        .where((element) =>
                                    element.itemId == widget.itemdata!.id)
                                        .first
                                        .parent_id!
                                        : box
                                        .where((element) =>
                                    element.varId == widget.priceVariation!.id)
                                        .first
                                        .parent_id!,
                                    "0",
                                    "",);
                                }
                              }
                            },
                            alignmnt: widget.alignmnt,
                            isloading: loading));
                  }
                }
              }
            }
            else{
              if (box.where((element) => element.varId == widget.priceVariation!.id).length <= 0 || int.parse(box.where((element) => element.varId == widget.priceVariation!.id).first.quantity!) <= 0)
                stepperButtons.add(AddItemSteppr(
                    context, fontSize: widget.fontSize!,alignmnt: widget.alignmnt,onTap: () {
                  if(widget.addon == null) {
                    addToCart("", "", "0","","0",[]);
                  }else {
                    addToppingsProduct.clear();
                    addToppingsProduct.add({"Toppings_type":"","varId":   (widget.itemdata!.type! =="1")?"":widget.priceVariation!.id!,"toppings":"0", "parent_id":  "","newproduct":"0","productid":widget.itemdata!.id});
                    dialogforToppings(context);
                  }
                },isloading: loading));
              else {
                int quantity = 0;
                double weight = 0.0;

                for( int i = 0;i < box.length ;i++){
                  if(box[i].varId == widget.priceVariation!.id && box[i].toppings =="0") {
                    quantity = quantity + int.parse(box[i].quantity!);
                    weight = weight + double.parse(box
                        .where((element) =>
                    element.itemId == widget.itemdata!.id)
                        .first
                        .weight!);
                  }
                }

                stepperButtons.add(
                    UpdateItemSteppr(context, quantity:  (box.where((element) =>  element.varId == widget.priceVariation!.id && element.toppings == "1")).count() >= 1?
                    quantity
                        :(widget.addon != null)?totalquantity()
                        :int.parse(box
                        .where((element) =>
                    element.varId == widget.priceVariation!.id)
                        .first
                        .quantity!),
                        weight: (box.where((element) => element.itemId == widget.itemdata!.id && element.toppings == "0").count()> 1) ?
                        weight
                            :(widget.addon != null)?double.parse((box.where((element) => element.itemId == widget.itemdata!.id).count() *  double.parse(box
                            .where((element) =>
                        element.itemId == widget.itemdata!.id)
                            .first
                            .weight!)).toString()): double.parse(box
                            .where((element) =>
                        element.itemId == widget.itemdata!.id)
                            .first
                            .weight!),
                        fontSize: widget.fontSize!,
                        skutype: box
                            .where((element) =>
                        element.varId == widget.priceVariation!.id)
                            .first
                            .type!,
                        unit: widget.priceVariation!.unit!,
                        onTap: (cartStatus) {
                          if (cartStatus == CartStatus.increment) {
                            if (widget.addon == null) {
                              updateCart(
                                int.parse(box
                                    .where((element) =>
                                element.varId == widget.priceVariation!.id)
                                    .first
                                    .quantity!),
                                double.parse(box
                                    .where((element) =>
                                element.itemId == widget.itemdata!.id)
                                    .first
                                    .weight!),
                                cartStatus,
                                widget.priceVariation!.id!,
                                productBox.last.id!,
                                "0",
                                "",);
                            }
                            else
                              dialogforUpdateToppings(context);
                          } else {
                            if(box.where((element) => element.itemId == widget.itemdata!.id).length > 1 ){
                              dialogforDeleteToppings(context);
                            }else {
                              updateCart(
                                int.parse(box
                                    .where((element) =>
                                element.varId == widget.priceVariation!.id)
                                    .first
                                    .quantity!),
                                double.parse(box
                                    .where((element) =>
                                element.itemId == widget.itemdata!.id)
                                    .first
                                    .weight!),
                                cartStatus,
                                widget.priceVariation!.id!,
                                productBox.last.id!,
                                "0",
                                "",);
                            }
                          }
                        },
                        alignmnt: widget.alignmnt,
                        isloading: loading));
              }

              stepperButtons.add(AddSubsciptionStepper(
                  context, itemdata: widget.itemdata!,
                  alignmnt: widget.alignmnt,
                  fontsize: widget.fontSize!,
                  onTap: () {
                    if(!PrefUtils.prefs!.containsKey("apikey") &&Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                      LoginWeb(context,result: (sucsess){
                        if(sucsess){
                          Navigator.of(context).pop();
                          Navigation(context, navigatore: NavigatoreTyp.homenav);
                        }else{
                          Navigator.of(context).pop();
                        }
                      });
                    }
                    else{
                      if (!PrefUtils.prefs!.containsKey("apikey")) {
                        Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push);

                      }
                      else {
                        Navigation(context, name: Routename.SubscribeScreen, navigatore: NavigatoreTyp.Push,
                            qparms: {
                              "itemid": widget.itemdata!.id,
                              "itemname": widget.itemdata!.itemName,
                              "itemimg": widget.itemdata!.itemFeaturedImage,
                              "weight" : widget.itemdata!.weight,
                              "varname": widget.itemdata!.priceVariation![widget.index].variationName !+ widget.itemdata!.priceVariation![widget.index].unit!,
                              "varmrp":widget.itemdata!.priceVariation![widget.index].mrp.toString(),
                              "varprice": widget.itemdata!.priceVariation![widget.index].price.toString(),
                              "paymentMode": widget.itemdata!.paymentMode,
                              "cronTime": widget.itemdata!.subscriptionSlot![0].cronTime,
                              "name": widget.itemdata!.subscriptionSlot![0].name,
                              "varid":widget.itemdata!.priceVariation![widget.index].id,
                              "brand": widget.itemdata!.brand,
                              "membershipdisplay":widget.itemdata!.priceVariation![widget.index].membershipDisplay! ,
                              "discountdisplay":widget.itemdata!.priceVariation![widget.index].discointDisplay!,
                              "membershipprice":widget.itemdata!.priceVariation![widget.index].membershipPrice,
                              "deliveriesarray": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].deliveries :widget.itemdata!.subscriptionSlot![0].deliveries,
                              "daily":(widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].daily :widget.itemdata!.subscriptionSlot![0].daily,
                              "dailyDays": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].dailyDays :widget.itemdata!.subscriptionSlot![0].dailyDays,
                              "weekend": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].weekend :widget.itemdata!.subscriptionSlot![0].weekend,
                              "weekendDays": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].weekendDays :widget.itemdata!.subscriptionSlot![0].weekendDays,
                              "weekday": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].weekday :widget.itemdata!.subscriptionSlot![0].weekday,
                              "weekdayDays": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].weekdayDays :widget.itemdata!.subscriptionSlot![0].weekdayDays,
                              "custom": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].custom :widget.itemdata!.subscriptionSlot![0].custom,
                              "alternativeDays": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].alternativeDays :widget.itemdata!.subscriptionSlot![0].alternativeDays,
                              "customDays": (widget.from == "search_screen" && Features.ismultivendor)?widget.searchstoredata!.subscriptionSlot![0].customDays :widget.itemdata!.subscriptionSlot![0].customDays,
                              "varType": widget.itemdata?.type
                            });
                      }
                    }


                  }));
            }

          }
          return widget.alignmnt == StepperAlignment.Vertical
              ? SizedBox(
              height: widget.height,
              width: widget.width,
              child:Column(
                children: stepperButtons,
              ))
              : Container(
              height: widget.height,
              width: widget.width,
              child:
              Row(
                children: stepperButtons,

              ));
        });
  }

  double totalWeight() {
    double totalWeight = 0.0;
    List<double> weight = [];
    weight.clear();
    (widget.from == "search_screen" && Features.ismultivendor)?
    weight.addAll(productBox.where((element) => element.itemId == widget.searchstoredata!.id).map((e) =>  double.parse(e.weight!))):
    weight.addAll(productBox.where((element) => element.itemId == widget.itemdata!.id).map((e) =>  double.parse(e.weight!)));
    for(int i = 0;i<weight.length; i++){
      totalWeight = totalWeight + weight[i];
    }
    return totalWeight;
  }

  int totalquantity() {
    int totalquantity = 0;
    List<int> Lisquantity = [];
    Lisquantity.clear();
    (widget.from == "search_screen" && Features.ismultivendor)?
    Lisquantity.addAll(productBox.where((element) => element.varId == widget.priceVariationSearch!.id).map((e) =>  int.parse(e.quantity!))):
    Lisquantity.addAll(productBox.where((element) => element.varId == widget.priceVariation!.id).map((e) =>  int.parse(e.quantity!)));
    for(int i = 0;i< Lisquantity.length; i++){
      totalquantity = totalquantity + Lisquantity[i];
    }
    return totalquantity;
  }

  bool compare(List<Map<String, dynamic>> toppindfrombackend, List addToppings) {
    bool ismapequal = true;
    addToppings.forEach((element) {
      if(!toppindfrombackend.contains(element)){
        ismapequal = false;
      }
    });
    return ismapequal;
  }

}
Widget handler(bool? isSelected) {
  return (isSelected == true )  ?
  Container(
    width: 20.0,
    height: 20.0,
    decoration: BoxDecoration(
      color: ColorCodes.whiteColor,
      border: Border.all(
        color: ColorCodes.greenColor,
      ),
      shape: BoxShape.circle,
    ),
    child: Container(
      margin: EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        color:ColorCodes.whiteColor,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.check,
          color: ColorCodes.greenColor,
          size: 15.0),
    ),
  )
      :
  Icon(
      Icons.radio_button_off_outlined,
      color: ColorCodes.blackColor,
      size: 20.0
  );
}

Widget Loading(BuildContext context) {
  return  Container(
    decoration: BoxDecoration(color: (Features.isSubscription)? ColorCodes.whiteColor:ColorCodes.whiteColor,
    ),
    height: 60,
    width:35,
    child: Center(
      child: SizedBox(
          width: 15.0,
          height: 15.0,
          child: new CircularProgressIndicator(
            color: (Features.isSubscription)?IConstants.isEnterprise?ColorCodes.stepperColor:ColorCodes.stepperColor :IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.stepperColor,
            strokeWidth: 2.0,
            valueColor: new AlwaysStoppedAnimation<Color>((Features.isSubscription)?IConstants.isEnterprise?ColorCodes.stepperColor:ColorCodes.stepperColor :IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.stepperColor),
          )
      ),
    ),
  );
}

Widget AddItemSteppr(BuildContext context,{required double fontSize,required Function() onTap, required StepperAlignment alignmnt, isloading}) {
  return (Features.isSubscription)?
  Expanded(
    flex: 1,
    child: GestureDetector(
      onTap: ()=>onTap(),
      child: Padding(
        padding: EdgeInsets.only(bottom: alignmnt == StepperAlignment.Vertical?0:0),
        child: Container(
          margin: EdgeInsets.only(top:alignmnt == StepperAlignment.Vertical?0:0,bottom: alignmnt == StepperAlignment.Vertical?5:0),
          height: (Features.isSubscription)?alignmnt == StepperAlignment.Vertical?40:40:40.0,
          decoration: new BoxDecoration(
              color: (Features.isSubscription)?IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.whiteColor :IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.whiteColor,
              border: Border.all(color: ColorCodes.darkgreen),
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(5),
                topRight:
                const Radius.circular(5),
                bottomLeft:
                const Radius.circular(5),
                bottomRight:
                const Radius.circular(5),
              )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              isloading? Center(
                child: SizedBox(
                    width: 15.0,
                    height: 15.0,
                    child: new CircularProgressIndicator(
                      color: (Features.isSubscription)?ColorCodes.whiteColor :ColorCodes.primaryColor,
                      strokeWidth: 2.0,
                      valueColor: new AlwaysStoppedAnimation<Color>(ColorCodes.greenColor),
                    )
                ),
              )
                  : Row(
                children: [
                  Icon(Icons.add,color: ColorCodes.darkgreen,size: 18,),
                  SizedBox(width:2),
                  Text(
                    S.current.add,
                    style:
                    TextStyle(
                        color: ColorCodes.darkgreen,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold

                    ),

                    textAlign:
                    TextAlign
                        .center,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  )
      :Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: ()=>onTap(),
        child: Padding(
          padding: EdgeInsets.only(top:alignmnt == StepperAlignment.Vertical?0:0,bottom: alignmnt == StepperAlignment.Vertical?5:0),
          child: Container(
            height: (Features.isSubscription)?alignmnt == StepperAlignment.Vertical?30:40:40.0,
            decoration: new BoxDecoration(
                color: (Features.isSubscription)?IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.whiteColor :IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.whiteColor,
                border: Border.all(color: ColorCodes.varcolor),
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(5),
                  topRight:
                  const Radius.circular(5),
                  bottomLeft:
                  const Radius.circular(5),
                  bottomRight:
                  const Radius.circular(5),
                )),
            child:
            isloading ?
            Center(
              child: SizedBox(
                  width: 15.0,
                  height: 15.0,
                  child: new CircularProgressIndicator(
                    color: (Features.isSubscription)?ColorCodes.whiteColor :ColorCodes.primaryColor,
                    strokeWidth: 2.0,
                    valueColor: new AlwaysStoppedAnimation<Color>(ColorCodes.greenColor),
                  )
              ),
            )
                :Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add,color: ColorCodes.darkgreen,size: 20,),
                SizedBox(width:2),
                Text(
                  S.current.add,//'ADD',
                  style: TextStyle(
                      color: ColorCodes.darkgreen,
                      fontSize: fontSize, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      )
  );
}

Widget UpdateItemSteppr(BuildContext context,{required int quantity,required double weight,required double fontSize,required String skutype,required String unit,required Function(CartStatus) onTap,required StepperAlignment alignmnt,isloading,String? maxItem,String? minItem,String? count,double? price ,String? varid,String? incvalue, String? Cart_id }) {
  return  Expanded(
    flex: 1,
    child: Container(
      margin: EdgeInsets.only(top:alignmnt == StepperAlignment.Vertical?0:0,bottom: alignmnt == StepperAlignment.Vertical?5:0),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: (Features.isSubscription) ? IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.whiteColor:IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.whiteColor,
        border: Border(
          right: BorderSide(width: 1.0, color: ColorCodes.varcolor,),
          left: BorderSide(width: 1.0, color: ColorCodes.varcolor,),
          bottom: BorderSide(width: 1.0, color: ColorCodes.varcolor),
          top: BorderSide(width: 1.0, color: ColorCodes.varcolor),
        ),),
      height: (Features.isSubscription)?60:30,
      padding: EdgeInsets.only(top:alignmnt == StepperAlignment.Vertical?Features.isSubscription?0:0:0,bottom: alignmnt == StepperAlignment.Vertical?(Features.isSubscription)?0:0:0),
      child: Row(
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () =>onTap(CartStatus.decrement),
            child: Container(
               margin: EdgeInsets.only(top:alignmnt == StepperAlignment.Vertical?0:0,bottom: alignmnt == StepperAlignment.Vertical?5:0),
                width: Features.btobModule?alignmnt == StepperAlignment.Vertical?skutype=="1"?30:30:skutype=="1"?30:30:alignmnt == StepperAlignment.Vertical?skutype=="1"?30:30:skutype=="1"?30:35,
                height: (Features.isSubscription)?alignmnt == StepperAlignment.Vertical?60:40:30,
                child: Center(
                  child:
                  Text(
                    "-",
                    textAlign:
                    TextAlign
                        .center,
                    style:
                    TextStyle(
                      fontSize: 18,
                      color: (Features.isSubscription)?ColorCodes.darkgreen :ColorCodes.darkgreen,
                    ),
                  ),
                )),
          ),
          Features.btobModule?
          (isloading)? Loading(context)
              :Container(
              color: (Features.isSubscription) ? IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.whiteColor:IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.whiteColor,
              width: Features.btobModule?alignmnt == StepperAlignment.Vertical?skutype=="1"?15:40:skutype=="1"?25:35:alignmnt == StepperAlignment.Vertical?skutype=="1"?15:30:skutype=="1"?25:35,
              height: (Features.isSubscription)?alignmnt == StepperAlignment.Vertical?60:40:30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      skutype=="1"? weight.toString()+" "+unit:quantity.toStringAsFixed(0),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: skutype=="1"?11:13,
                        color: (Features.isSubscription)?IConstants.isEnterprise?ColorCodes.stepperColor:ColorCodes.stepperColor :IConstants.isEnterprise?ColorCodes.cartgreenColor:ColorCodes.stepperColor, ),
                    ),
                  ),
                  skutype=="1"?
                  GestureDetector(
                      onTap: (){
                        showoptions1(context,count!,minItem!,maxItem!,weight,isloading,skutype,price!,varid,Cart_id,quantity,unit);
                      },
                      child: Icon(Icons.keyboard_arrow_down,color: ColorCodes.darkgreen,size: 20,))
                      :SizedBox.shrink()
                ],
              )):
          Expanded(
            child:(isloading)? Loading(context)
                :Container(
                color: (Features.isSubscription) ? IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.whiteColor:IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.whiteColor,
                height: (Features.isSubscription)?alignmnt == StepperAlignment.Vertical?60:40:30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        skutype=="1"? weight.toString()+" "+unit:quantity.toStringAsFixed(0),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: skutype=="1"?11:13,
                          color: (Features.isSubscription)?IConstants.isEnterprise?ColorCodes.stepperColor:ColorCodes.stepperColor :IConstants.isEnterprise?ColorCodes.cartgreenColor:ColorCodes.stepperColor, ),
                      ),
                    ),
                    skutype=="1"?
                GestureDetector(
                  onTap: (){
                    showoptions1(context,count!,minItem!,maxItem!,weight,isloading,skutype,price!,varid,Cart_id,quantity,unit);
                  },
                    child: Icon(Icons.keyboard_arrow_down,color: ColorCodes.darkgreen,size: 20,))
                        :SizedBox.shrink()
                  ],
                )),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              onTap(CartStatus.increment);
            },
            child: Container(
                width: Features.btobModule?alignmnt == StepperAlignment.Vertical?skutype=="1"?30:30:skutype=="1"?30:35:alignmnt == StepperAlignment.Vertical?skutype=="1"?30:30:skutype=="1"?30:35,
                height: (Features.isSubscription)?alignmnt == StepperAlignment.Vertical?60:40:30,
                decoration: new BoxDecoration(
                  color: (Features.isSubscription)? IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.whiteColor:IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.whiteColor,
                ),
                child: Center(
                  child: Text(
                    "+",
                    textAlign:
                    TextAlign
                        .center,
                    style:
                    TextStyle(
                      fontSize: 18,
                      color: (Features.isSubscription)?ColorCodes.darkgreen :ColorCodes.darkgreen,
                    ),
                  ),
                )),
          ),
        ],
      ),

    ),

  );
}



Widget AddSubsciptionStepper(BuildContext context,{required StepperAlignment alignmnt, ItemData? itemdata,required Function() onTap,required double fontsize, StoreSearchData? search,String? from_screen}) {
  return (Features.isSubscription)?
  from_screen == "search_screen" && Features.ismultivendor?
      search!.eligibleForSubscription =="0" ?
      Expanded(
        flex: 1,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: ()=>onTap(),
            child: Padding(
              padding:  EdgeInsets.only(left:alignmnt == StepperAlignment.Horizontal?10:0,top: alignmnt == StepperAlignment.Vertical?0:0,bottom: alignmnt == StepperAlignment.Vertical?15:0),
              child: Container(
                height: (Features.isSubscription)?alignmnt == StepperAlignment.Vertical?30:40:30.0,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(width: 5.0, color: ColorCodes.darkgreen),
                  ),
                  color: ColorCodes.varcolor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 3),
                    Image.asset(Images.subscribeImg,
                      height: 10.0,
                      width: 10.0,
                      color: ColorCodes.primaryColor,),
                    SizedBox(width: 3),
                    Text(
                      S.current.subscribe,
                      style: TextStyle(
                          fontSize: fontsize,
                          color: ColorCodes.darkgreen,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(width: 5),
                  ],
                ) ,
              ),
            ),
          ),
        ),
      ):alignmnt == StepperAlignment.Vertical?Expanded(
          flex: 1,
          child: SizedBox.shrink()):SizedBox.shrink():
  itemdata!.eligibleForSubscription =="0" ?
  Expanded(
    flex: 1,
    child: MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: ()=>onTap(),
        child: Padding(
          padding:  EdgeInsets.only(left:alignmnt == StepperAlignment.Horizontal?20:0,top: alignmnt == StepperAlignment.Vertical?0:0,bottom: alignmnt == StepperAlignment.Vertical?15:0),
          child: Container(
            height: (Features.isSubscription)?alignmnt == StepperAlignment.Vertical?30:40:30.0,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(width: 3.0, color: ColorCodes.darkgreen),
              ),
              color: ColorCodes.varcolor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 4),
                Image.asset(Images.subscribeImg,
                  height: 12.0,
                  width: 12.0,
                color: ColorCodes.primaryColor,),
                SizedBox(width: 3),
                Text(
                  S.current.subscribe,
                  style: TextStyle(
                      fontSize: fontsize,
                      color: ColorCodes.darkgreen,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
               SizedBox(width: 2),
              ],
            ) ,
          ),
        ),
      ),
    ),
  ):alignmnt == StepperAlignment.Vertical?Expanded(
      flex: 1,
      child: SizedBox.shrink()):SizedBox.shrink():SizedBox.shrink();
}

Widget NotificationStepper(BuildContext context,{required StepperAlignment alignmnt,required Function() onTap, required double fontsize,required bool isnotify}) {
  return Features.isSubscription?Expanded(
    flex: 1,
    child:
    MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          margin: EdgeInsets.only(top:alignmnt == StepperAlignment.Vertical?0:0,bottom: alignmnt == StepperAlignment.Vertical?5:0),
          height: (Features.isSubscription)?alignmnt == StepperAlignment.Vertical?30:40:40.0,
          decoration: new BoxDecoration(
              color: (Features.isSubscription)?IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.whiteColor :IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.whiteColor,
              border: Border.all(color: ColorCodes.darkgreen),
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(5),
                topRight:
                const Radius.circular(5),
                bottomLeft:
                const Radius.circular(5),
                bottomRight:
                const Radius.circular(5),
              )),
          child: isnotify ?
          Center(
            child: SizedBox(
                width: 15.0,
                height: 15.0,
                child: new CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: new AlwaysStoppedAnimation<
                      Color>(Colors.green),)),
          ):
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                  child: Text(S.current.notify_me,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: ColorCodes.darkgreen,
                        fontSize: fontsize),
                    textAlign: TextAlign.center,)),
            ],
          ),
        ),
      ),),
  ):Expanded(
    flex: 1,
    child:
    MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          margin: EdgeInsets.only(top:alignmnt == StepperAlignment.Vertical?0:0,bottom: alignmnt == StepperAlignment.Vertical?5:0),
          decoration: new BoxDecoration(
              color: (Features.isSubscription)?IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.whiteColor :IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.whiteColor,
              border: Border.all(color: ColorCodes.darkgreen),
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(5),
                topRight:
                const Radius.circular(5),
                bottomLeft:
                const Radius.circular(5),
                bottomRight:
                const Radius.circular(5),
              )),
          child:
          isnotify ?
          Center(
            child: SizedBox(
                width: 15.0,
                height: 15.0,
                child: new CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: new AlwaysStoppedAnimation<
                      Color>(Colors.green),)),
          ):
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 10,
              ),
              Center(
                  child: Text(S.current.notify_me,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: ColorCodes.primaryColor,
                        fontSize: fontsize),
                    textAlign: TextAlign.center,)),
            ],
          ),
        ),
      ),

    ),

  );
}

showoptions1(BuildContext context,String count,String minItem,String maxItem,double weightsku,bool loading, String skutype, double price,String? varid,String? cart_id,int qty, String unit) {
  List weight = [];
double total_weight = 0.0;
double total_min = 0.0;
double total_max = 0.0;
int? selectedIndex;


  List<double> Listweight = [];
  weight.clear();
  for( int i = int.parse(minItem);i <= int.parse(maxItem);i++){
    weight.add(i);
    selectedIndex = 0;
    total_min = double.parse(minItem);
    total_max = double.parse(maxItem);
    total_weight = total_min;
  }

  Listweight.clear();
    for(int k = total_min.toInt() ; k <= total_max.toInt(); k++) {
      if(k == total_min.toInt()) {
        total_weight =
            total_min * double.parse(count);
      }
      else{
        total_weight =
            total_weight + (double.parse(count));
      }
    Listweight.add(total_weight);
  }
  (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
  showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState1) {
          return  Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.0)),
            child: Container(
              width: MediaQuery.of(context).size.width / 2.5,
              padding: EdgeInsets.fromLTRB(30, 20, 20, 20),
              child:
              SingleChildScrollView(
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: weight.length,
                    itemBuilder: (_, i) {
                      return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: (){

                          Navigator.of(context).pop();
                          setState1((){
                            selectedIndex = i;

                          });

                          (loading)? Loading(context)
                              :
                          cartcontroller.update((done) {
                            setState1(() {
                              loading = !done;
                            });
                          }, price: price.toString(),
                              quantity: qty.toString(),
                              type: skutype.toString(),
                              weight: Listweight[i].toString(),
                              var_id: varid!,
                              increament: count,
                              cart_id: cart_id!,
                              toppings: "",
                              topping_id: "",

                          );  },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          margin: EdgeInsets.symmetric(vertical: 5),
                           decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(6),
                                   color: selectedIndex==i?ColorCodes.fill:ColorCodes.whiteColor,
                                   border: Border.all(color: ColorCodes.lightGreyColor),
                                 ),
                          child: Row(

                            children: [
                              handlerweight(i,selectedIndex!),
                              SizedBox(width:5),
                              Text(Listweight[i].toString() + unit.toString()),
                              Spacer(),
                              Text(  Features.iscurrencyformatalign?
                              (Listweight[i]*price).toStringAsFixed(2) + " " + IConstants.currencyFormat:
                              IConstants.currencyFormat + " " + (Listweight[i]*price).toStringAsFixed(2),),
                            ],
                          ),
                        ),
                      );
                    }),
              )
            ),
          );
        });
      }) :
      showModalBottomSheet<dynamic>(
      isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0),topRight: Radius.circular(15.0)),
          ),
      context: context,
      builder: (context) {
        return StatefulBuilder(

          builder: (BuildContext context, void Function(void Function()) setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left:8.0,right:8,top:15,bottom: 15),
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: weight.length,
                    itemBuilder: (_, i) {
                      return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: (){
                          Navigator.of(context).pop();
                          setState((){
                            selectedIndex = i;
                          });

                          (loading)? Loading(context)
                              :
                          cartcontroller.update((done) {
                           setState(() {
                            loading = !done;
                            });
                          }, price: price.toString(),
                              quantity: qty.toString(),
                              type: skutype.toString(),
                              weight: Listweight[i].toString(),
                              var_id: varid!,
                              increament: count,
                              cart_id: cart_id!,
                              toppings: "",
                              topping_id: "",
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10,),
                          margin: EdgeInsets.symmetric(vertical: 8,),
                          child: Row(
                            children: [
                              handlerweight(i,selectedIndex!),
                              SizedBox(width:5),
                              Text(Listweight[i].toString() + unit.toString()),
                              Spacer(),
                              Text(
                                Features.iscurrencyformatalign?
                                (Listweight[i]*price).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)+
                                    " " + IConstants.currencyFormat :
                                IConstants.currencyFormat +
                                    " " +
                                    (Listweight[i]*price).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            );
          },
        );
      });
}

Widget handlerweight(int i, int selectedIndex) {
    return (selectedIndex == i) ?
    Icon(
        Icons.radio_button_checked_outlined,
        color: ColorCodes.greenColor)
        :
    Icon(
        Icons.radio_button_off_outlined,
        color: ColorCodes.greenColor);
}
