
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grocbay/repository/productandCategory/category_or_product.dart';
import '../../controller/mutations/cat_and_product_mutation.dart';
import '../controller/mutations/cart_mutation.dart';
import '../models/VxModels/VxStore.dart';
import '../models/newmodle/cartModle.dart';
import '../models/newmodle/product_data.dart';
import 'package:velocity_x/velocity_x.dart';
import '../assets/ColorCodes.dart';
import '../assets/images.dart';
import '../constants/IConstants.dart';
import '../constants/features.dart';
import '../data/calculations.dart';
import '../generated/l10n.dart';
import '../providers/branditems.dart';
import '../rought_genrator.dart';
import '../utils/ResponsiveLayout.dart';
import '../utils/prefUtils.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../widgets/simmers/checkout_screen.dart';
import 'package:provider/provider.dart';

class OfferScreen extends StatefulWidget {
  static const routeName = '/offer-screen';


  String minimumOrderAmountNoraml="";
  String deliveryChargeNormal ="";
  String minimumOrderAmountPrime = "";
  String deliveryChargePrime = "";
  String minimumOrderAmountExpress ="";
  String deliveryChargeExpress = "";
  String deliveryType = "";
  String addressId = "";
  String note = "";
  String deliveryCharge = "";
  String deliveryDurationExpress = "";
  String groupValue = "";
  Map<String, String>? params1;

  OfferScreen(Map<String, String> params){
    this.params1= params;
    this.minimumOrderAmountNoraml = params["minimumOrderAmountNoraml"]??"" ;
    this.deliveryChargeNormal = params["deliveryChargeNormal"]??"";
    this.minimumOrderAmountPrime = params["minimumOrderAmountPrime"]??"";
    this.deliveryChargePrime = params["deliveryChargePrime"]??"";
    this.minimumOrderAmountExpress = params["minimumOrderAmountExpress"]??"";
    this.deliveryChargeExpress = params["deliveryChargeExpress"]??"";
    this.deliveryType = params["deliveryType"]??"";
    this.addressId = params["addressId"]??"";
    this.note = params["note"]??"";
    this.deliveryCharge = params["deliveryCharge"]??"";
    this.deliveryDurationExpress = params["deliveryDurationExpress"]??"";
    this.groupValue = params["_groupValue"]??"";
  }

  @override
  _OfferScreenState createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> with Navigations{
  List<CartItem> productBox=[];
  BrandItemsList? offersData;
  int _selectedOffer = -1;
  bool _checkmembership = false;
  bool _isLoading = true;
  var _checkoffers = false;
  bool _isAddToCart = false;
  bool _isWeb = false;
  var _address = "";

  @override
  void initState() {
    productBox = (VxState.store as GroceStore).CartItemList;

    try {
      if (Platform.isIOS) {
        setState(() {
          _isWeb = false;
        });
      } else  {
        setState(() {
          _isWeb = false;
        });
      }
    } catch (e) {
      setState(() {
        _isWeb = true;
      });
    }


    if ((VxState.store as GroceStore).userData.membership == "1") {
      setState(() {
        _checkmembership = true;
      });
    } else {
      setState(() {
        _checkmembership = false;
      });
      for (int i = 0; i < productBox.length; i++) {
        if (productBox[i].mode == "1") {
          setState(() {
            _checkmembership = true;
          });
        }
      }
    }
    Future.delayed(Duration.zero, () async {
      _address = PrefUtils.prefs!.getString("restaurant_address")!;
      if(Features.isOffers) {
        Provider.of<BrandItemsList>(context, listen: false).getOffers().then((
            _) {
          setState(() {
            offersData = Provider.of<BrandItemsList>(context, listen: false);
            if (offersData!.offers.length > 0) {
              _isLoading = false;
              _checkoffers = true;
            } else {
              final routeArgs = ModalRoute
                  .of(context)!
                  .settings
                  .arguments as Map<String, dynamic>;
              final _groupValue =/* routeArgs['_groupValue']*/widget.groupValue;
              final String _minimumOrderAmountNoraml = /*routeArgs['minimumOrderAmountNoraml']*/widget.minimumOrderAmountNoraml;
              final String _deliveryChargeNormal = /*routeArgs['deliveryChargeNormal']*/widget.deliveryChargeNormal;
              final String _minimumOrderAmountPrime = /*routeArgs['minimumOrderAmountPrime']*/widget.minimumOrderAmountPrime;
              final String _deliveryChargePrime = /*routeArgs['deliveryChargePrime']*/widget.deliveryChargePrime;
              final String _minimumOrderAmountExpress = /*routeArgs['minimumOrderAmountExpress']*/widget.minimumOrderAmountExpress;
              final String _deliveryChargeExpress = /*routeArgs['deliveryChargeExpress']*/widget.deliveryChargeExpress;
              final _groupValueAdvance = /*routeArgs['deliveryType']*/widget.deliveryType;
              final _message = /*routeArgs['note']*/widget.note;
              final finalSlotDelivery = routeArgs['finalSlotDelivery'];
              final finalExpressDelivery = routeArgs['finalExpressDelivery'];
              final _deliveryDurationExpress = /*routeArgs['deliveryDurationExpress']*/widget.deliveryDurationExpress;
              final deliveryCharge =/*routeArgs['deliveryCharge']*/widget.deliveryCharge;
              final deliveryType =/*routeArgs['deliveryType']*/widget.deliveryType;

              if (_isWeb) {
           /*     Navigator.of(context)
                    .pushNamed(PaymentScreen.routeName, arguments: {
                  'minimumOrderAmountNoraml': _minimumOrderAmountNoraml.toString(),
                  'deliveryChargeNormal': _deliveryChargeNormal.toString(),
                  'minimumOrderAmountPrime': _minimumOrderAmountPrime.toString(),
                  'deliveryChargePrime': _deliveryChargePrime.toString(),
                  'minimumOrderAmountExpress': _minimumOrderAmountExpress.toString(),
                  'deliveryChargeExpress': _deliveryChargeExpress.toString(),
                  'addressId': routeArgs['addressId'].toString(),
                  'deliveryType': deliveryType.toString(),
                  'note': _message.toString(),
                  'deliveryCharge':deliveryCharge.toString(),
                  'deliveryDurationExpress': _deliveryDurationExpress.toString(),
                });*/
                Navigation(context, name: Routename.PaymentScreen, navigatore: NavigatoreTyp.Push,
                    qparms: {
                      'minimumOrderAmountNoraml': _minimumOrderAmountNoraml.toString(),
                      'deliveryChargeNormal': _deliveryChargeNormal.toString(),
                      'minimumOrderAmountPrime': _minimumOrderAmountPrime.toString(),
                      'deliveryChargePrime': _deliveryChargePrime.toString(),
                      'minimumOrderAmountExpress': _minimumOrderAmountExpress.toString(),
                      'deliveryChargeExpress': _deliveryChargeExpress.toString(),
                      'addressId': /*routeArgs['addressId'].toString()*/widget.addressId,
                      'deliveryType': deliveryType.toString(),
                      'note': _message.toString(),
                      'deliveryCharge':deliveryCharge.toString(),
                      'deliveryDurationExpress': _deliveryDurationExpress.toString(),
                      'fromScreen':'',
                      'responsejson':"",
                    });
              } else {
                if (_groupValue == "2") {
                  /*Navigator.of(context)
                      .pushReplacementNamed(PickupScreen.routeName);*/
                  Navigation(context, name: Routename.PickupScreen, navigatore: NavigatoreTyp.Push);
                } else {
                 /* Navigator.of(context).pushReplacementNamed(
                      ConfirmorderScreen.routeName,
                      arguments: {"prev": "cart_screen"});*/
                  Navigation(context, name:Routename.ConfirmOrder,navigatore: NavigatoreTyp.Push,
                      parms:{"prev": "cart_screen"});
                }
              }
            }
          });
        });
      }else{
        final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        final _groupValue =/* routeArgs['_groupValue']*/widget.groupValue;
        if(_groupValue == 2) {
         /* Navigator.of(context)
              .pushReplacementNamed(PickupScreen.routeName);*/
          Navigation(context, name: Routename.PickupScreen, navigatore: NavigatoreTyp.Push);
        }else{
         /* Navigator.of(context).pushReplacementNamed(
              ConfirmorderScreen.routeName,
              arguments: {"prev": "cart_screen"});*/
          Navigation(context, name:Routename.ConfirmOrder,navigatore: NavigatoreTyp.Push,
              parms:{"prev": "cart_screen"});
        }
      }
    });
    super.initState();
  }
  removeToCart() async {
    String? itemId, varId, varName,
        varMinItem, varMaxItem, varLoyalty, varStock, varMrp, itemName, qty, price, membershipPrice, itemImage, veg_type, type,eligibleforexpress,delivery,duration,durationType,note;
    // widget.isdbonprocess();
    //  if (itemCount + 1 <= int.parse(widget.varminitem)) {
    productBox = (VxState.store as GroceStore).CartItemList;
    try {

      // }
      for (int i = 0; i < productBox.length; i++) {
        if (productBox[i].mode =="4") {
          itemId = productBox[i]
              .itemId
              .toString();
          varId = productBox[i]
              .varId
              .toString();
          varName = productBox[i]
              .varName!;
          varMinItem = productBox[i]
              .varMinItem
              .toString();
          varMaxItem = productBox[i]
              .varMaxItem
              .toString();
          varLoyalty = productBox[i]
              .itemLoyalty
              .toString();
          varStock = productBox[i]
              .varStock
              .toString();
          varMrp = productBox[i]
              .varMrp
              .toString();
          itemName = productBox[i]
              .itemName!;
          price = productBox[i]
              .price
              .toString();
          membershipPrice = productBox[i]
              .membershipPrice
              .toString();
          itemImage = productBox[i]
              .itemImage!;
          veg_type = productBox[i]
              .vegType!;
          type = productBox[i]
              .type!;
          eligibleforexpress = productBox[i]
              .eligibleForExpress!;
          delivery = productBox[i]
              .delivery!;
          duration = productBox[i]
              .duration!;
          durationType = productBox[i]
              .durationType!;
          note = productBox[i]
              .note!;
          break;
        }
      }
      cartcontroller.update((done){
        setState(() {
          _isAddToCart = !done;
        });
      },price: double.parse(price!).toString(),var_id:varId!,quantity: "0",weight: "0",
        cart_id: productBox.where((e) => e.itemId ==itemId).first.parent_id!,toppings: "",
        topping_id: "",);
     /* final s = await Provider.of<CartItems>(context, listen: false).
      updateCart(varId, itemCount.toString(), price).then((_) async {
        if (itemCount + 1 == int.parse(varMinItem)) {
          for (int i = 0; i < productBox.length; i++) {
            if (productBox[i]
                .mode == 1) {
              PrefUtils.prefs!.setString("membership", "0");
            }
            if (productBox[i]
                .varId == int.parse(varId)) {
              productBox.clear();
              break;
            }
          }

          final cartItemsData = Provider.of<CartItems>(context, listen: false);
          for (int i = 0; i < cartItemsData.items.length; i++) {
            // if(cartItemsData.items[i].varId == int.parse(varId)) {
            cartItemsData.items[i].itemQty = itemCount;
            //  }
          }
          _bloc.setCartItem(cartItemsData);
          Provider.of<CartItems>(context, listen: false).fetchCartItems().then((
              _) {
            setState(() {
              // _isAddToCart = false;
            });
          });
        } else {
          cartBloc.cartItems();
          final sellingitemData = Provider.of<SellingItemsList>(
              context, listen: false);
          for (int i = 0; i < sellingitemData.featuredVariation.length; i++) {
            // if(sellingitemData.featuredVariation[i].varid == varId) {
            sellingitemData.featuredVariation[i].varQty = itemCount;
            //  }
          }
          _bloc.setFeaturedItem(sellingitemData);
          for (int i = 0; i < sellingitemData.itemspricevarOffer.length; i++) {
            //  if (sellingitemData.itemspricevarOffer[i].varid == varId) {
            sellingitemData.itemspricevarOffer[i].varQty = itemCount;
            break;
            // }
          }
          _bloc.setFeaturedItem(sellingitemData);
          for (int i = 0; i < sellingitemData.discountedVariation.length; i++) {
            // if(sellingitemData.discountedVariation[i].varid == varId) {
            sellingitemData.discountedVariation[i].varQty = itemCount;
            break;
            //  }
          }
          _bloc.setFeaturedItem(sellingitemData);

          final cartItemsData = Provider.of<CartItems>(context, listen: false);
          for (int i = 0; i < cartItemsData.items.length; i++) {
            // if(cartItemsData.items[i].varId == int.parse(varId)) {
            cartItemsData.items[i].itemQty = itemCount;
            // }
          }
          _bloc.setCartItem(cartItemsData);

          setState(() {
            // _isAddToCart = false;
          });
          Product products = Product(
            itemId: int.parse(itemId),
            varId: int.parse(varId),
            varName: varName,
            varMinItem: int.parse(varMinItem),
            varMaxItem: int.parse(varMaxItem),
            varStock: int.parse(varStock),
            varMrp: double.parse(varMrp),
            itemName: itemName,
            itemQty: itemCount,
            itemPrice: double.parse(price),
            membershipPrice: membershipPrice,
            itemActualprice: double.parse(varMrp),
            itemImage: itemImage,
            membershipId: 0,
            mode: 4,
            veg_type: veg_type,
            type: type,
          );

          var items = Hive.box<Product>(productBoxName);

          for (int i = 0; i < items.length; i++) {
            if (Hive
                .box<Product>(productBoxName)
                .values
                .elementAt(i)
                .varId == int.parse(varId)) {
              Hive.box<Product>(productBoxName).putAt(i, products);
            }
          }
        }
      }
      );*/
      //cartBloc.cartItems();
    }catch(e){

    }
  }
  @override
  Widget build(BuildContext context) {
    offersData = Provider.of<BrandItemsList>(context, listen: false);

    _addToCart() async {
      debugPrint("Add to cart....");
      String itemId, varId, varName,unit,brand,
          varMinItem, varMaxItem, varLoyalty, varStock, varMrp, itemName, qty, price, membershipPrice, itemImage, veg_type, type,eligibleforexpress,delivery,duration,durationType,note;
      productBox = (VxState.store as GroceStore).CartItemList;
      for (int i = 0; i < productBox.length; i++) {
        if (productBox[i].mode =="4") {
          removeToCart();
        }
      }
      debugPrint("Add to cart....1.."+offersData!.offers.length.toString());
        for (int j = 0; j < offersData!.offers.length; j++) {
          if (_selectedOffer == j) {
            itemId = offersData!.offers[j].menuid!;
            brand =offersData!.offers[j].brand!;
            varId = offersData!.offers[j].varid!;
            varName = offersData!.offers[j].varname!;
            unit =offersData!.offers[j].unit!;
            varMinItem = offersData!.offers[j].varminitem!;
            varMaxItem = offersData!.offers[j].varmaxitem!;
            varLoyalty = offersData!.offers[j].varLoyalty.toString();
            varStock = offersData!.offers[j].varstock!;
            varMrp = offersData!.offers[j].varmrp!;
            itemName = offersData!.offers[j].title!;
            price = offersData!.offers[j].varprice!;
            membershipPrice = offersData!.offers[j].varmemberprice!;
            itemImage = offersData!.offers[j].imageUrl!;
            veg_type = offersData!.offers[j].veg_type!;
            type = offersData!.offers[j].type!;
            eligibleforexpress = productBox[0]
                .eligibleForExpress!;
            delivery = "";
            duration = productBox[0]
                .duration!;
            durationType =productBox[0]
                .durationType!;
            note = productBox[0]
                .note!;
            cartcontroller.addtoCart(itemdata: ItemData(type: offersData!.offers[j].type,eligibleForExpress: offersData!.offers[j].eligible_for_express,vegType: offersData!.offers[j].veg_type,delivery: offersData!.offers[j].delivery??"0",
                duration: offersData!.offers[j].duration??"0",brand: offersData!.offers[j].brand,id: itemId,itemName: itemName,mode: "4",deliveryDuration:DeliveryDurationData(duration:offersData!.offers[j].duration??"",status: "",durationType: offersData!.offers[j].durationType??"",note: "", id: "",branch: "",blockFor: "") ), onload: (onload){

            setState(() {
              _isAddToCart = onload;
            });
            setState(() {
              _isAddToCart = false;
              //  _varQty = _itemCount;
            });
            },topping_type: "",varid: "",toppings: "0",parent_id: "",newproduct: "0",toppingsList: [],itembody: PriceVariation(quantity: 1,mode: "4",status: "0",discointDisplay: offersData!.offers[j].discountDisplay,
                loyaltys: offersData!.offers[j].varLoyalty,membershipDisplay: offersData!.offers[j].membershipDisplay,menuItemId: offersData!.offers[j].menuid,
                netWeight: offersData!.offers[j].weight.toString(),weight: offersData!.offers[j].weight.toString(),id: varId,variationName: varName,unit:unit,minItem: varMinItem,maxItem: varMaxItem,loyalty: 0,stock: double.parse(varStock),mrp: varMrp,
                price: price,membershipPrice: membershipPrice),context: context);
              break;
          }
          else{
            if((VxState.store as GroceStore).CartItemList.where((element) => element.varId == offersData!.offers[j].varid).length>0)
            cartcontroller.update((done){
              setState(() {
                _isAddToCart = !done;
              });
            },price: offersData!.offers[j].varprice!,var_id:offersData!.offers[j].varid! ,quantity: "0",weight: "0",
              cart_id: productBox.where((e) => e.itemId ==offersData!.offers[j].id).first.parent_id!,toppings: "",
              topping_id: "",);
          }
        }

    }
   /* _addToCart() async {
      String itemId, varId, varName,brand,
          varMinItem, varMaxItem, varLoyalty, varStock, varMrp, itemName, qty, price, membershipPrice, itemImage, veg_type, type,eligibleforexpress,delivery,duration,durationType,note;

      for (int i = 0; i < productBox.values.length; i++) {
        if (productBox.values.elementAt(i).mode == 4) {
          removeToCart(0);
        }
      }
      try {
        for (int j = 0; j < offersData.offers.length; j++) {
          if (_selectedOffer == j) {
            itemId = offersData.offers[j].menuid;
            brand =offersData.offers[j].brand;
            varId = offersData.offers[j].varid;
            varName = offersData.offers[j].varname;
            varMinItem = offersData.offers[j].varminitem;
            varMaxItem = offersData.offers[j].varmaxitem;
            varLoyalty = offersData.offers[j].varLoyalty.toString();
            varStock = offersData.offers[j].varstock;
            varMrp = offersData.offers[j].varmrp;
            itemName = offersData.offers[j].title;
            price = offersData.offers[j].varprice;
            membershipPrice = offersData.offers[j].varmemberprice;
            itemImage = offersData.offers[j].imageUrl;
            veg_type = offersData.offers[j].veg_type;
            type = offersData.offers[j].type;
            eligibleforexpress = productBox.values
                .elementAt(0)
                .eligible_for_express;
            delivery = productBox.values
                .elementAt(0)
                .delivery;
            duration = productBox.values
                .elementAt(0)
                .duration;
            durationType = productBox.values
                .elementAt(0)
                .durationType;
            note = productBox.values
                .elementAt(0)
                .note;
            break;
          }
        }
        await Provider.of<CartItems>(context, listen: false).addToCart(
            itemId,
            varId,
            varName,
            varMinItem,
            varMaxItem,
            varLoyalty,
            varStock,
            varMrp,
            itemName,
            "1",
            price.toString(),
            membershipPrice,
            itemImage,
            "0",
            "4",
            veg_type,
            type,
            eligibleforexpress,
            delivery,
            duration,
            durationType,
            note).then((_) async {

          setState(() {
            _isAddToCart = false;
          });
          Product products = Product(
              itemId: int.parse(itemId),
              varId: int.parse(varId),
              varName: varName,
              varMinItem: int.parse(varMinItem),
              varMaxItem: int.parse(varMaxItem),
              itemLoyalty: int.parse(varLoyalty),
              varStock: int.parse(varStock),
              varMrp: double.parse(varMrp),
              itemName: itemName,
              itemQty: 1,
              itemPrice: double.parse(price),
              membershipPrice: membershipPrice,
              itemActualprice: double.parse(varMrp),
              itemImage: itemImage,
              membershipId: 0,
              mode: 4,
              eligible_for_express: eligibleforexpress,
              delivery: delivery,
              duration: duration,
              durationType: durationType,
              note: note
          );

          productBox.add(products);

          *//*  final routeArgs =
        ModalRoute
            .of(context)
            .settings
            .arguments as Map<String, dynamic>;
        final _groupValue = routeArgs['_groupValue'];
        if (_groupValue == 2) {
          Navigator.of(context)
              .pushReplacementNamed(PickupScreen.routeName);
        } else {
          Navigator.of(context).pushReplacementNamed(
              ConfirmorderScreen.routeName,
              arguments: {"prev": "cart_screen"});
        }*//*
          *//* Orderfood();*//*
          // (_slots ) ? _isPickup ? Orderfood(): Features.isSplit ? OrderfoodSplit() : Orderfood() :OrderfoodSplit();
        });
      }catch(e){
      }
    }*/



    Widget _offers() {
      double deviceWidth = MediaQuery.of(context).size.width;
      int widgetsInRow = 3;
      double aspectRatio = (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 125;

      if (deviceWidth > 1200) {
        widgetsInRow = 5;
        aspectRatio =
            (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 295;
      } else if (deviceWidth > 768) {
        widgetsInRow = 4;
        aspectRatio =
            (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 195;
      }
      return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
              color: ColorCodes.whiteColor,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                  top: 8.0, left: 20.0, right: 20.0, bottom: 8.0),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        Images.Offer,
                        height: 25.0,
                        width: 25.0,
                      ),
                      SizedBox(width: 10,),
                      Text(
                        S .of(context).thank_you_shopping,//"Thank you for shopping with us. Your order qualifies for a gift",
                        style: TextStyle(
                            color: ColorCodes.greenColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height:10),
                  SizedBox(
                    // height: 190,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: offersData!.offers.length,
                      itemBuilder: (_, i) => /*GestureDetector(
                    onTap: () {
                      for(int j = 0; j < offersData.offers.length; j++) {
                        setState(() {
                          if(i == j) {
                            offersData.offers[i].border = ColorCodes.mediumBlueColor;
                          } else {
                            offersData.offers[j].border = ColorCodes.lightBlueColor;
                          }
                          offersData = Provider.of<BrandItemsList>(context, listen: false);
                          _selectedOffer = i;
                        });
                      }
                    },
                    child:*/ Container(
                          width: 150.0,
                          // padding: EdgeInsets.all(10.0),
                          padding: _isWeb?EdgeInsets.symmetric(horizontal: 200):EdgeInsets.all(0),
                          margin: EdgeInsets.only(top: 5.0, right: 10.0, bottom: 5.0),
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.all(new Radius.circular(2.0)),
                          ),

                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  width:MediaQuery.of(context).size.width,
                                  height: 110,
                                  // elevation: 2,
                                  decoration: BoxDecoration(
                                   // borderRadius: BorderRadius.circular(5),
                                   // border: Border.all(color: ColorCodes.lightgreen),
                                  ),
                                  margin: EdgeInsets.all(5),
                                  child:Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment: _isWeb?MainAxisAlignment.center:MainAxisAlignment.start,
                                        children: [
                                          //  Text(offersData.offers[i].offerTitle),
                                          SizedBox(width: 10,),
                                          CachedNetworkImage(
                                            imageUrl: offersData!.offers[i].imageUrl,
                                            placeholder: (context, url) =>
                                                Image.asset(
                                                  Images.defaultProductImg,
                                                  width: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                                  height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                                ),
                                            errorWidget: (context, url, error) => Image.asset(
                                              Images.defaultProductImg,
                                              width: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                              height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                            ),
                                            width: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                            height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                            fit: BoxFit.fill,
                                          ),
                                          SizedBox(width: 20,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SizedBox(height: 10,),
                                              Text(offersData!.offers[i].brand!,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                   // fontWeight: FontWeight.bold,
                                                  )),
                                              Text(offersData!.offers[i].title!,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              Text(offersData!.offers[i].varname!, style: TextStyle(
                                                fontSize: 14,
                                                color: ColorCodes.greenColor,
                                                fontWeight: FontWeight.bold,
                                              )),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  _checkmembership?
                                                  (offersData!.offers[i].membershipDisplay!)?
                                                  Text(
                                                    Features.iscurrencyformatalign?
                                                    offersData!.offers[i].varmemberprice! + IConstants.currencyFormat :
                                                      IConstants.currencyFormat + offersData!.offers[i].varmemberprice!,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: ResponsiveLayout.isSmallScreen(context) ? 15 : ResponsiveLayout.isMediumScreen(context) ? 13 : 15,)
                                                  ):
                                                  (offersData!.offers[i].discountDisplay!)?
                                                  Text(Features.iscurrencyformatalign?
                                                  offersData!.offers[i].varprice !+ IConstants.currencyFormat :
                                                  IConstants.currencyFormat + offersData!.offers[i].varprice!,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: ResponsiveLayout.isSmallScreen(context) ? 15 : ResponsiveLayout.isMediumScreen(context) ? 13 : 15,)
                                                  ):
                                                  Text(
                                                    Features.iscurrencyformatalign?
                                                    offersData!.offers[i].varmrp !+ IConstants.currencyFormat :
                                                      IConstants.currencyFormat + offersData!.offers[i].varmrp!,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: ResponsiveLayout.isSmallScreen(context) ? 15 : ResponsiveLayout.isMediumScreen(context) ? 13 : 15,)
                                                  ):  (offersData!.offers[i].discountDisplay!)?
                                                  Text(
                                                    Features.iscurrencyformatalign?
                                                    offersData!.offers[i].varprice !+ IConstants.currencyFormat :
                                                      IConstants.currencyFormat + offersData!.offers[i].varprice!,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: ResponsiveLayout.isSmallScreen(context) ? 15 : ResponsiveLayout.isMediumScreen(context) ? 13 : 15,)
                                                  ):
                                                  Text(
                                                      Features.iscurrencyformatalign?
                                                      offersData!.offers[i].varmrp !+ IConstants.currencyFormat :
                                                      IConstants.currencyFormat + offersData!.offers[i].varmrp!,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: ResponsiveLayout.isSmallScreen(context) ? 15 : ResponsiveLayout.isMediumScreen(context) ? 13 : 15,)
                                                  ),
                                                  _isWeb?SizedBox(width: 70,):SizedBox(width: 15,),
                                                  VxBuilder(
                                                      mutations: {ProductMutation},
                                                      builder: (context, box, _) {
                                                        if ( _selectedOffer == i)
                                                          return Container(
                                                            height: 30,
                                                            width: MediaQuery.of(context).size.width/4,
                                                            decoration: BoxDecoration(
                                                              border: Border.all(color: ColorCodes.varcolor),
                                                              borderRadius: BorderRadius.circular(3),
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                GestureDetector(
                                                                  onTap:(){
                                                                    setState(() {
                                                                      _selectedOffer=-1;
                                                                      removeToCart();
                                                                    });
                                                                  },
                                                                  child: Container(
                                                                      width: 30,
                                                                      height: 30,
                                                                      // decoration: new BoxDecoration(
                                                                      //   border: Border.all(
                                                                      //     color: ColorCodes.primaryColor,
                                                                      //     width: 2,
                                                                      //   ),
                                                                      //   borderRadius:
                                                                      //   new BorderRadius.only(
                                                                      //     bottomLeft:
                                                                      //     const Radius.circular(
                                                                      //         3),
                                                                      //     topLeft:
                                                                      //     const Radius.circular(
                                                                      //         3),
                                                                      //   ),
                                                                      // ),
                                                                      child: Center(
                                                                        child: Text(
                                                                          "-",
                                                                          textAlign: TextAlign
                                                                              .center,
                                                                          style: TextStyle(
                                                                            fontSize: 20,
                                                                            color:ColorCodes.primaryColor,
                                                                          ),
                                                                        ),
                                                                      )),
                                                                ),
                                                                Spacer(),
                                                                Container(
                                                                    child:Center(
                                                                      child:Text(offersData!.offers[i].varQty.toString(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: ColorCodes.primaryColor),),
                                                                    )
                                                                ),
                                                                Spacer(),
                                                                GestureDetector(
                                                                    onTap: (){

                                                                    },
                                                                    child:Container(
                                                                        width: 30,
                                                                        height: 30,
                                                                        // decoration: new BoxDecoration(
                                                                        //   border: Border.all(
                                                                        //     color: ColorCodes.lightblue,
                                                                        //     width: 2,
                                                                        //   ),
                                                                        //   borderRadius:
                                                                        //   new BorderRadius.only(
                                                                        //     bottomRight:
                                                                        //     const Radius.circular(
                                                                        //         3),
                                                                        //     topRight:
                                                                        //     const Radius.circular(
                                                                        //         3),
                                                                        //   ),
                                                                        // ),
                                                                        child: Center(
                                                                          child: Text(
                                                                            "+",
                                                                            textAlign: TextAlign
                                                                                .center,
                                                                            style: TextStyle(
                                                                              fontSize: 20,
                                                                              color:ColorCodes.primaryColor,
                                                                            ),
                                                                          ),
                                                                        ))),
                                                              ],
                                                            ),
                                                          );
                                                        else return VxBuilder(
                                                            mutations: {SetCartItem},
                                                            // valueListenable: Hive.box<Product>(productBoxName).listenable(),
                                                            builder: (context, store, index)
                                                        {
                                                          final box = (VxState
                                                              .store as GroceStore)
                                                              .CartItemList;
                                                          return GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  _selectedOffer =
                                                                      i;
                                                                  offersData!
                                                                      .offers[i]
                                                                      .varQty =
                                                                  1;
                                                                  _addToCart();
                                                                });
                                                                // _addToCart();
                                                                /*
                                              _addToCart( i,int.parse(*/ /*offersData.offers[i]*/ /*store.OfferCartList[i].menuid),
                                                int.parse(store.OfferCartList[i].varid),
                                                store.OfferCartList[i].title,
                                                store.OfferCartList[i].varname,
                                                int.parse(store.OfferCartList[i].varminitem),
                                                int.parse(store.OfferCartList[i].varmaxitem),
                                                // int.parse(store.OfferCartList[i].varstock),
                                                double.parse(store.OfferCartList[i].varmrp),
                                                store.OfferCartList[i].title,
                                                1,
                                                double.parse(store.OfferCartList[i].varprice),
                                                store.OfferCartList[i].varmemberprice,
                                                double.parse(store.OfferCartList[i].varmrp),
                                                store.OfferCartList[i].imageUrl,
                                                store.OfferCartList[i].discountDisplay,
                                              );*/
                                                              },
                                                              child: Container(
                                                                height: 30,
                                                                width: MediaQuery
                                                                    .of(context)
                                                                    .size
                                                                    .width / 4,
                                                                decoration: BoxDecoration(
                                                                    border: Border
                                                                        .all(
                                                                        color: ColorCodes
                                                                            .varcolor,
                                                                        width: 1)
                                                                ),
                                                                child: Center(
                                                                    child: Text(
                                                                      S.of(context).add,//'ADD',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color: ColorCodes
                                                                              .primaryColor,
                                                                          fontSize: 16),)),
                                                              )
                                                          );
                                                        });

                                                      }),
                                                ],
                                              ),
                                            ],
                                          ),
                                          /* if(offersData.offers[i].discountDisplay)
                                    RichText(
                                      text: new TextSpan(
                                        style: new TextStyle(
                                          fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 15 : 16,
                                          color: Colors.black,
                                        ),
                                        children: <TextSpan>[
                                          new TextSpan(
                                              text: IConstants.currencyFormat + offersData.offers[i].varprice + ' ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,)),

                                          new TextSpan(
                                            text: IConstants.currencyFormat + offersData.offers[i].varmrp,
                                            style: TextStyle(
                                              decoration: TextDecoration.lineThrough,
                                              fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,),),
                                        ],
                                      ),
                                    )
                                  else
                                    RichText(
                                      text: new TextSpan(
                                        style: new TextStyle(
                                          fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 15 : 16,
                                          color: Colors.black,
                                        ),
                                        children: <TextSpan>[
                                          new TextSpan(
                                              text: IConstants.currencyFormat + offersData.offers[i].varmrp,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,)),
                                        ],
                                      ),
                                    )*/
                                        ],
                                      ))),
                              SizedBox(height: 5,),
                            ],
                          )
                      ),
                      //  ),
                    ),

                  ),
                  if(_isWeb)_buildBottomNavigationBar(),
                  if(_isWeb) Footer(address: _address),
                ],
              )));
    }

    Widget body(){
      return _isLoading
          ? Expanded(
        child: Center(
            child:_isWeb?CircularProgressIndicator():CheckOutShimmer()),
      )
          :Expanded(
          child: SingleChildScrollView(child:Column(
        children: [
          if(Features.isOffers)
            if(offersData!.offers.length > 0)
              _offers(),
        ],
      )));
    }
    return WillPopScope(
        onWillPop: () {
          Future.delayed(Duration.zero, () async {
            removeToCart();
            // Navigator.of(context).pop();
         /*   Navigator.of(context).pushReplacementNamed(CartScreen.routeName, arguments: {
              "afterlogin": ""
            });*/
            Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
          });
          return Future.value(false);
        },
        child: Scaffold(
          appBar: (ResponsiveLayout.isSmallScreen(context)&&_checkoffers) ?
          gradientappbarmobile() : null,
          body: Column(
            children: [
              if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
                Header(false),
              body(),
            ],
          ),
          bottomNavigationBar:_isWeb ? SizedBox.shrink() :_checkoffers?
          VxBuilder(
              mutations: {SetCartItem},
              // valueListenable: Hive.box<Product>(productBoxName).listenable(),
              builder: (context,store, index) {
                final box = (VxState.store as GroceStore).CartItemList;
                if (box.isEmpty) return SizedBox.shrink();
                return BottomNaviagation(
                  itemCount: (CartCalculations.itemCount).toString() + " " + S
                      .of(context)
                      .items,
                  title: S
                      .of(context)
                      .proceed_to_pay,
                  total: _checkmembership ? (CartCalculations.totalMember)
                      .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)
                      :
                  (CartCalculations.total).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                  onPressed: () {
                    setState(() {
                      final routeArgs =
                      ModalRoute
                          .of(context)!
                          .settings
                          .arguments as Map<String, dynamic>;
                      final _groupValue = /*routeArgs['_groupValue']*/widget.groupValue;
                      if (_groupValue == 2) {
                       /* Navigator.of(context)
                            .pushReplacementNamed(PickupScreen.routeName);*/
                        Navigation(context, name: Routename.PickupScreen, navigatore: NavigatoreTyp.Push);
                      } else {
                      /*  Navigator.of(context).pushReplacementNamed(
                            ConfirmorderScreen.routeName,
                            arguments: {"prev": "cart_screen"});*/
                        Navigation(context, name:Routename.ConfirmOrder,navigatore: NavigatoreTyp.Push,
                            parms:{"prev": "cart_screen"});
                      }
                      // });
                    });
                  },
                );}):null ,
        ));
  }
  _buildBottomNavigationBar(){
    return Container(
        width: _isWeb?MediaQuery.of(context).size.width*0.60:MediaQuery.of(context).size.width,
        color: Theme.of(context).primaryColor,
        height: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
                onTap: () => {
                  setState(() {
                    final routeArgs =ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
                    final _groupValue =/* routeArgs['_groupValue']*/widget.groupValue;
                    final String _minimumOrderAmountNoraml = /*routeArgs['minimumOrderAmountNoraml']*/widget.minimumOrderAmountNoraml;
                    final String _deliveryChargeNormal = /*routeArgs['deliveryChargeNormal']*/widget.deliveryChargeNormal;
                    final String _minimumOrderAmountPrime = /*routeArgs['minimumOrderAmountPrime']*/widget.minimumOrderAmountPrime;
                    final String _deliveryChargePrime = /*routeArgs['deliveryChargePrime']*/widget.deliveryChargePrime;
                    final String _minimumOrderAmountExpress = /*routeArgs['minimumOrderAmountExpress']*/widget.minimumOrderAmountExpress;
                    final String _deliveryChargeExpress = /*routeArgs['deliveryChargeExpress']*/widget.deliveryChargeExpress;
                    final _groupValueAdvance = /*routeArgs['deliveryType']*/widget.deliveryType;
                    final _message = /*routeArgs['note']*/widget.note;
                    final finalSlotDelivery = routeArgs['finalSlotDelivery'];
                    final finalExpressDelivery = routeArgs['finalExpressDelivery'];
                    final _deliveryDurationExpress = /*routeArgs['deliveryDurationExpress']*/widget.deliveryDurationExpress;
                    final deliveryCharge =/*routeArgs['deliveryCharge']*/widget.deliveryCharge;
                    final deliveryType =/*routeArgs['deliveryType']*/widget.deliveryType;

              /*      Navigator.of(context)
                        .pushNamed(PaymentScreen.routeName, arguments: {
                      'minimumOrderAmountNoraml': _minimumOrderAmountNoraml.toString(),
                      'deliveryChargeNormal': _deliveryChargeNormal.toString(),
                      'minimumOrderAmountPrime': _minimumOrderAmountPrime.toString(),
                      'deliveryChargePrime': _deliveryChargePrime.toString(),
                      'minimumOrderAmountExpress': _minimumOrderAmountExpress.toString(),
                      'deliveryChargeExpress': _deliveryChargeExpress.toString(),
                      'addressId': routeArgs['addressId'].toString(),
                      'deliveryType': *//*(_groupValueAdvance == 1)
                      ? "Default"
                      : "OptionTwo"*//*deliveryType.toString(),
                      'note': _message.toString(),
                      'deliveryCharge':*//* (_groupValueAdvance == 1)
                      ? finalSlotDelivery.toString()
                      : finalExpressDelivery.toString()*//*deliveryCharge.toString(),
                      'deliveryDurationExpress': _deliveryDurationExpress.toString(),
                    });*/
                    Navigation(context, name: Routename.PaymentScreen, navigatore: NavigatoreTyp.Push,
                        qparms: {
                        'minimumOrderAmountNoraml': _minimumOrderAmountNoraml.toString(),
                        'deliveryChargeNormal': _deliveryChargeNormal.toString(),
                        'minimumOrderAmountPrime': _minimumOrderAmountPrime.toString(),
                        'deliveryChargePrime': _deliveryChargePrime.toString(),
                        'minimumOrderAmountExpress': _minimumOrderAmountExpress.toString(),
                        'deliveryChargeExpress': _deliveryChargeExpress.toString(),
                        'addressId': /*routeArgs['addressId'].toString()*/widget.addressId,
                        'deliveryType':deliveryType.toString(),
                        'note': _message.toString(),
                        'deliveryCharge':deliveryCharge.toString(),
                        'deliveryDurationExpress': _deliveryDurationExpress.toString(),
                          'fromScreen':'',
                          'responsejson':"",
                        });
                  })
                },
                child: Text(/*'CONFIRM ORDER'*/S.of(context).confirm_order,  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold),)),
          ],));
  }
  gradientappbarmobile() {
    return  AppBar(
      brightness: Brightness.dark,
      toolbarHeight: 60.0,
      elevation: (IConstants.isEnterprise)?0:1,
      automaticallyImplyLeading: false,
      leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorCodes.iconColor),
          onPressed: () {
            // Navigator.of(context).pop();
            Future.delayed(Duration.zero, () async {
              removeToCart();
        /*      Navigator.of(context).pushReplacementNamed(CartScreen.routeName, arguments: {
                "afterlogin": ""
              });*/
              Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
              return Future.value(false);
            });
          }
      ),
      titleSpacing: 0,
      title: Text(S.of(context).offers,//"Offers",
        style: TextStyle(color: ColorCodes.iconColor, fontWeight: FontWeight.bold, fontSize: 18),),
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  ColorCodes.appbarColor,
                  ColorCodes.appbarColor2
                ]
            )
        ),
      ),
    );
  }
}
