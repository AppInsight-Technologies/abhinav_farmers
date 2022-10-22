import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:grocbay/screens/promocode_screen.dart';
import '../../repository/authenticate/AuthRepo.dart';
import 'package:intl/intl.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/cartModle.dart';
import '../../screens/paytm_screen.dart';
import 'package:velocity_x/velocity_x.dart';
import '../controller/payment/payment_contoller.dart';
import '../providers/sellingitems.dart';
import '../rought_genrator.dart';
import '../widgets/bottom_navigation.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

import '../generated/l10n.dart';
import 'package:shimmer/shimmer.dart';
import '../assets/ColorCodes.dart';
import '../assets/images.dart';
import '../constants/features.dart';
import '../widgets/simmers/pymentoption_Simmer.dart';

import '../constants/api.dart';
import '../providers/cartItems.dart';
import '../utils/prefUtils.dart';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import 'package:package_info/package_info.dart';
import '../main.dart';
import '../utils/ResponsiveLayout.dart';
import '../data/calculations.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../providers/branditems.dart';
import '../constants/IConstants.dart';

class PaymentScreen extends StatefulWidget {
  static const routeName = '/payment-screen';

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
  String fromScreen = "";
  Map<String, String>? params1;
  PaymentScreen(Map<String, String> params){
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
    this.fromScreen = params["fromScreen"]??"";
  }
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> with Navigations {

  final flutterWebviewPlugin = new FlutterWebviewPlugin();
//  Box<Product> productBox;
  int _groupValue = -1;
  var totlamount;
  var _checkpromo = false;
  var _displaypromo = false;
  var _promocode = "";
  double minorderamount = 0;
  double deliverycharge = 0;
  var walletbalance = "0";
  var loyaltyPoints = "0";
  String promoType = "";
  bool _ischeckbox = true;
  bool _ischeckboxshow = true;
  double deliveryamount = 0;
  final myController = TextEditingController();
  String _savedamount = "";
  String _promoamount = "";
  String? promovarprice;
  String promomessage = "";
  String promocashbackmsg = "";
  bool _isWallet = false;
  bool _isLoayalty = false;
  var paymentData;
  bool _isRemainingAmount = false;
  double walletAmount = 0.0;
  double remainingAmount = 0.0;
  double remLoyaltyPoint = 0;
  bool _isPickup = false;
  int pickupValue = -1;
  double cartTotal = 0.0;
  bool _showDeliveryinfo = false;
  bool _isLoading = true;
  bool _checkmembership = false;
  var _message = TextEditingController();
  bool _isLoyaltyToast = false;
  bool _isSwitch = false;
  double loyaltyPointsUser = 0;
  double loyaltyAmount = 0.0;
  String? note;
  bool _isWeb = false;
  PackageInfo? packageInfo;
  var _address = "";
  MediaQueryData? queryData;
  double? wid;
  double? maxwid;
  String? deliverychargetext;
  //BrandItemsList offersData;
  var responsejson = "";
  int _selectedOffer = 0;
  bool iphonex = false;
  double deliveryAmt = 0;
  bool _slots = true;
  String membershipvx = (VxState.store as GroceStore).userData.membership!;
  List<CartItem> productBox=[];
  int _selectedIndex = 0;

  @override
  void initState() {
    productBox = /*Hive.box<Product>(productBoxName)*/(VxState.store as GroceStore).CartItemList;

    Future.delayed(Duration.zero, () async {
      try {
        if (Platform.isIOS) {
          setState(() {
            _isWeb = false;
            iphonex = MediaQuery.of(context).size.height >= 812.0;
          });
        } else {
          setState(() {
            _isWeb = false;
          });
        }
      } catch (e) {
        setState(() {
          _isWeb = true;
        });
      }
      _address = PrefUtils.prefs!.getString("restaurant_address")!;
      final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      deliveryAmt = double.parse(/*routeArgs['deliveryCharge']*/widget.deliveryCharge);
      if(!Vx.isWeb)
      if(PrefUtils.prefs!.containsKey("orderId")) {
        final orderId = PrefUtils.prefs!.getString("orderId");
        await  paymentStatus(orderId!);
       // await  paymentStatus(orderId);
      }
      _initial();
      packageInfo = await PackageInfo.fromPlatform();
    });

    super.initState();
  }

  Future<void> _initial() async {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    await Provider.of<BrandItemsList>(context, listen: false).fetchPaymentMode().then((_) {
      /*setState(() {
        _isPaymentLoading = false;
      });*/
    });
   /* Provider.of<BrandItemsList>(context,listen: false).userDetails().then((_) async {

    });*/
    fetchUserDetail();
  }
 fetchUserDetail()async{
   final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
   setState(() {
     if (PrefUtils.prefs!.getString("isPickup") == "yes") {
       _isPickup = true;
     } else {
       _isPickup = false;
     }
     if (membershipvx == "1") {
       _checkmembership = true;
     } else {
       _checkmembership = false;
       for (int i = 0; i < productBox.length; i++) {
         if (productBox[i].mode == "1") {
           _checkmembership = true;
         }
       }
     }

     if(routeArgs['fromScreen'] == "promocodeScreen"){

       _promoamount = routeArgs['amount'].toString();
       LogicPromo();
     }


     if (/*routeArgs['deliveryType']*/widget.deliveryType == "express") {
       minorderamount = double.parse(/*routeArgs['minimumOrderAmountExpress']!*/widget.minimumOrderAmountExpress);
       deliverycharge = double.parse(/*routeArgs['deliveryChargeExpress']!*/widget.deliveryChargeExpress);
       note = /*routeArgs['note']*/widget.note;
     } else {
       if (membershipvx == "1") {
         minorderamount = double.parse(/*routeArgs['minimumOrderAmountPrime']!*/widget.minimumOrderAmountPrime);
         deliverycharge = double.parse(/*routeArgs['deliveryChargePrime']!*/widget.deliveryChargePrime);
         note = /*routeArgs['note']*/widget.note;
       } else {
         minorderamount = double.parse(/*routeArgs['minimumOrderAmountNoraml']!*/widget.minimumOrderAmountNoraml);
         deliverycharge = double.parse(/*routeArgs['deliveryChargeNormal']!*/widget.deliveryChargeNormal);
         note = /*routeArgs['note']*/widget.note;
       }
     }

     walletbalance = /*PrefUtils.prefs!.getString("wallet_balance")*/(VxState.store as GroceStore).prepaid.prepaid.toString(); //user wallet balance
     loyaltyPoints = double.parse(/*PrefUtils.prefs!.getString("loyalty_balance"*/(VxState.store as GroceStore).prepaid.loyalty.toString()).toStringAsFixed(0); // user loyalty points
     if (membershipvx == "1" ||_checkmembership) {
       cartTotal = CartCalculations.totalMember;
     } else {
       cartTotal = CartCalculations.total;
     }
     /* if (Calculations.totalmrp < minorderamount) {
          deliveryAmt = deliverycharge;
        }*/

     paymentData = Provider.of<BrandItemsList>(context,listen: false);
     for(int i = 0; i < paymentData.itemspayment.length; i++){
       //if payment mode is wallet
       if(paymentData.itemspayment[i].paymentMode == "2") {
         _isWallet = true;
         break;
       } else {
         _isWallet = false;
       }
     }
     for(int i = 0; i < paymentData.itemspayment.length; i++){
       //if payment mode is Loyalty

       if(paymentData.itemspayment[i].paymentMode == "4") {
         _isLoayalty = true;
         break;
       } else {
         _isLoayalty = false;
       }
     }
   });

   double totalAmount = 0.0; //Order amount
   !_displaypromo ? _isPickup ? totalAmount = (cartTotal + deliveryAmt) : totalAmount = (cartTotal + deliveryAmt) : totalAmount = (double.parse(_promoamount));
   await Provider.of<BrandItemsList>(context, listen: false).getLoyalty().then((_) async {
     final loyaltyData = Provider.of<BrandItemsList>(context,listen: false);
     if(loyaltyData.itemsLoyalty.length > 0) {

     } else {
       setState(() {
         _isLoayalty = false;
       });
     }

     if(_isLoayalty){
       await Provider.of<BrandItemsList>(context,listen: false).checkLoyalty(totalAmount.toString()).then((_) {
         setState(() {
           _isLoading = false;
           _isSwitch = true;


           //check user eligible to use Loyalty points or not
           final loyaltyData = Provider.of<BrandItemsList>(context,listen: false);
           if (double.parse(loyaltyData.itemsLoyalty[0].minimumOrderAmount!) <= totalAmount) {
             _isSwitch = true;
             _isLoyaltyToast = false;
             //Compare user loyalty balance to apply loyalty points
             if(PrefUtils.prefs!.getDouble("loyaltyPointsUser") !<= int.parse(loyaltyPoints)) {
               loyaltyPointsUser = PrefUtils.prefs!.getDouble("loyaltyPointsUser")!;
               loyaltyAmount = ((loyaltyPointsUser * 1) / int.parse(loyaltyData.itemsLoyalty[0].points!));
               if(loyaltyAmount.toString() == "NaN") {
                 loyaltyAmount = 0.0;
               }
             } else {
               /*loyaltyPointsUser = PrefUtils.prefs!.getDouble("loyaltyPointsUser") - double.parse(loyaltyPoints);
                loyaltyAmount = ((loyaltyPointsUser * 1) / int.parse(loyaltyData.itemsLoyalty[0].points));*/
               loyaltyPointsUser = double.parse(loyaltyPoints);
               loyaltyAmount = ((loyaltyPointsUser * 1) / int.parse(loyaltyData.itemsLoyalty[0].points!));
               if(loyaltyAmount.toString() == "NaN") {
                 loyaltyAmount = 0.0;
               }
             }
           } else {
             _isSwitch = true;
             _isLoyaltyToast = true;
           }
         });
       });
     } else {
       setState(() {
         _isLoading = false;
       });
     }
   });

   setState(() {
     if(_isWallet) {
       double totalAmount = 0.0;
       !_displaypromo ? _isPickup ? totalAmount = (cartTotal + deliveryAmt) : totalAmount = (cartTotal + deliveryAmt) : totalAmount = (double.parse(_promoamount));

       if (int.parse(walletbalance) <= 0 /*|| double.parse((cartTotal + deliveryamount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)) > int.parse(walletbalance)*/) {
         _isRemainingAmount = false;
         _ischeckboxshow = false;
         _ischeckbox = false;
       } else if (_isSwitch ? totalAmount <= (int.parse(walletbalance) + loyaltyAmount) : totalAmount <= (int.parse(walletbalance))) {
         _isRemainingAmount = false;
         _groupValue = -1;
         PrefUtils.prefs!.setString("payment_type", "wallet");
         walletAmount = _isSwitch ? (totalAmount - loyaltyAmount) : totalAmount;
       } else if (_isSwitch ? totalAmount > (int.parse(walletbalance) + loyaltyAmount) : totalAmount > int.parse(walletbalance)) {
         bool _isOnline = false;
         for(int i = 0; i < paymentData.itemspayment.length; i++) {
           if(paymentData.itemspayment[i].paymentMode == "1") {
             _groupValue = i;
             _isOnline = true;
             break;
           }
         }
         if(_isOnline) {
           _groupValue = -1;
           _isRemainingAmount = true;
           walletAmount = double.parse(walletbalance);
           remainingAmount = _isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0) ? totalAmount - double.parse(walletbalance) - loyaltyAmount: (totalAmount - int.parse(walletbalance));
         } else {
           _isWallet = false;
           _ischeckbox = false;
         }
         for(int i = 0; i < paymentData.itemspayment.length; i++) {
           if(paymentData.itemspayment[i].paymentMode == "1") {
             _groupValue = i;
             break;
           }
         }
       }
     } else {
       _ischeckbox = false;
     }


     //if both wallet is not there in payment method
     if(!_isWallet) {
       _groupValue = 0;
       if(paymentData.itemspayment[0].paymentMode == "1") {
         PrefUtils.prefs!.setString("payment_type", "paytm");
       } else {
         PrefUtils.prefs!.setString("payment_type", paymentData.itemspayment[0].paymentType);
       }
     }

   });
 }
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    _message.dispose();
    payment.dispose();
    super.dispose();
  }
  Future<void> paymentStatus(String orderId) async { // imp feature in adding async is the it automatically wrap into Future.
    var url = Api.getOrderStatus + orderId;
    try {
      final response = await http
          .post(
          url,
          body: { // await keyword is used to wait to this operation is complete.
            "branch": PrefUtils.prefs!.getString('branch')??"999",
          }
      );
      final responseJson = json.decode(response.body);
      if(responseJson['status'].toString() == "yes") {
        PrefUtils.prefs!.remove("orderId");
      } else {
        //await _cancelOrder();
        await _cancelOrderback();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> _cancelOrder() async { // imp feature in adding async is the it automatically wrap into Future.
    try {
      final response = await http.post(
          Api.cancelOrder,
          body: { // await keyword is used to wait to this operation is complete.
            "id": PrefUtils.prefs!.getString('orderId'),
            "note": "Payment cancelled by user",
            "branch": PrefUtils.prefs!.getString('branch')??"999",
          }
      );
      final responseJson = json.decode(response.body);
      if(responseJson['status'].toString() == "200"){
        PrefUtils.prefs!.remove("orderId");
        await Provider.of<BrandItemsList>(context,listen: false).userDetails().then((_) {
          setState(() {

          });
        });
      }

    } catch (error) {
      Fluttertoast.showToast(msg: S .of(context).something_went_wrong,//"Something went wrong!!!",
        fontSize: MediaQuery.of(context).textScaleFactor *13,);
      throw error;
    }
  }

  Future<void> _cancelOrderback() async { // imp feature in adding async is the it automatically wrap into Future.
    try {
      final response = await http.post(
          Api.cancelOrderBack,
          body: { // await keyword is used to wait to this operation is complete.
            "id": PrefUtils.prefs!.getString('orderId'),
            "note": "Payment cancelled by user",
            "branch": PrefUtils.prefs!.getString('branch')??"999",
          }
      );
      final responseJson = json.decode(response.body);
      if(responseJson['status'].toString() == "200"){
        PrefUtils.prefs!.remove("orderId");
       /* await Provider.of<BrandItemsList>(context,listen: false).userDetails().then((_) {
          setState(() {

          });
        });*/
      }

    } catch (error) {
      Fluttertoast.showToast(msg: S .of(context).something_went_wrong,//"Something went wrong!!!",
        fontSize: MediaQuery.of(context).textScaleFactor *13,);
      throw error;
    }
  }


  Widget handler(int isSelected) {
    if (_groupValue != -1) {
      if (paymentData.itemspayment[_groupValue].paymentType == "online") {
        PrefUtils.prefs!.setString("payment_type", "paytm");
      } /*else if (paymentData.itemspayment[_groupValue].paymentType == "pickupfromstore") {
        prefs.setString("payment_type", "pickup");
      }*/
      else {
        PrefUtils.prefs!.setString(
            "payment_type", paymentData.itemspayment[_groupValue].paymentType);
      }
    }
    PrefUtils.prefs!.setString("amount", "0");
    PrefUtils.prefs!.setString("wallet_type", "4");

    return (isSelected == _groupValue )  ?
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
        color: ColorCodes.lightGreyColor);


  }

  Widget _myRadioButton({String? title, int? value, Function(int?)? onChanged}) {
    if (_groupValue != -1) {
      if (paymentData.itemspayment[_groupValue].paymentType == "online") {
        PrefUtils.prefs!.setString("payment_type", "paytm");
      } /*else if (paymentData.itemspayment[_groupValue].paymentType == "pickupfromstore") {
        prefs.setString("payment_type", "pickup");
      }*/
      else {
        PrefUtils.prefs!.setString(
            "payment_type", paymentData.itemspayment[_groupValue].paymentType);
      }
    }
    PrefUtils.prefs!.setString("amount", "0");
    PrefUtils.prefs!.setString("wallet_type", "4");

    return Theme(
      data: ThemeData(
        unselectedWidgetColor: ColorCodes.greylight,
      ),
      child: Radio<int>(
        activeColor: ColorCodes.greenColor,
        value: value!,
        groupValue: _groupValue,
        onChanged: onChanged!,
        //title: Text(title),
      ),
    );
  }

  // _addToCart() async {
  //   String? itemId, varId, varName,
  //       varMinItem, varMaxItem, varLoyalty, varStock, varMrp, itemName, qty, price, membershipPrice, itemImage, veg_type, type,eligibleforexpress,delivery,duration,durationType,note;
  //
  //   // for(int j = 0; j < offersData.offers.length; j++) {
  //   //   if(_selectedOffer == j) {
  //   //     itemId = offersData.offers[j].menuid;
  //   //     varId = offersData.offers[j].varid;
  //   //     varName = offersData.offers[j].varname;
  //   //     varMinItem = offersData.offers[j].varminitem;
  //   //     varMaxItem = offersData.offers[j].varmaxitem;
  //   //     varLoyalty = offersData.offers[j].varLoyalty.toString();
  //   //     varStock = offersData.offers[j].varstock;
  //   //     varMrp = offersData.offers[j].varmrp;
  //   //     itemName = offersData.offers[j].title;
  //   //     price = offersData.offers[j].varprice;
  //   //     membershipPrice = offersData.offers[j].varmemberprice;
  //   //     itemImage = offersData.offers[j].imageUrl;
  //   //     veg_type = offersData.offers[j].veg_type;
  //   //     type = offersData.offers[j].type;
  //   //     eligibleforexpress = productBox.values.elementAt(0).eligible_for_express;
  //   //     delivery = productBox.values.elementAt(0).delivery;
  //   //     duration = productBox.values.elementAt(0).duration;
  //   //     durationType = productBox.values.elementAt(0).durationType;
  //   //     note = productBox.values.elementAt(0).note;
  //   //     break;
  //   //   }
  //   // }
  //   await Provider.of<CartItems>(context, listen: false).addToCart(
  //       itemId, varId, varName, varMinItem, varMaxItem, varLoyalty, varStock, varMrp, itemName,
  //       "1", price.toString(), membershipPrice, itemImage, "0", "4", veg_type, type,eligibleforexpress,delivery,duration,durationType,note).then((_) async {
  //     Product products = Product(
  //         itemId: int.parse(itemId),
  //         varId: int.parse(varId),
  //         varName: varName,
  //         varMinItem: int.parse(varMinItem),
  //         varMaxItem: int.parse(varMaxItem),
  //         itemLoyalty: int.parse(varLoyalty),
  //         varStock: int.parse(varStock),
  //         varMrp: double.parse(varMrp),
  //         itemName: itemName,
  //         itemQty: 1,
  //         itemPrice: double.parse(price),
  //         membershipPrice: membershipPrice,
  //         itemActualprice: double.parse(varMrp),
  //         itemImage: itemImage,
  //         membershipId: 0,
  //         mode: 4,
  //         eligible_for_express: eligibleforexpress,
  //         delivery: delivery,
  //         duration: duration,
  //         durationType: durationType,
  //         note: note
  //     );
  //
  //    // productBox.add(products);
  //     /* Orderfood();*/
  //     if(_slots){
  //       if(_isPickup){
  //         Orderfood();
  //       }else {
  //         if(Features.isSplit){
  //           OrderfoodSplit();
  //         }else{
  //           Orderfood();
  //         }
  //       }
  //     }else{
  //       Orderfood();
  //     }
  //    // (_slots ) ? _isPickup ? Orderfood(): Features.isSplit ? OrderfoodSplit() : Orderfood() :OrderfoodSplit();
  //   });
  // }
 /* removeToCart(itemCount) async {
    String itemId, varId, varName,
        varMinItem, varMaxItem, varLoyalty, varStock, varMrp, itemName, qty, price, membershipPrice, itemImage, veg_type, type,eligibleforexpress,delivery,duration,durationType,note;

    // widget.isdbonprocess();
    //  if (itemCount + 1 <= int.parse(widget.varminitem)) {
    try {
      itemCount = 0;
      // }
      for (int i = 0; i < productBox.values.length; i++) {
        if (productBox.values
            .elementAt(i)
            .mode == 4) {
          itemId = productBox.values
              .elementAt(i)
              .itemId
              .toString();
          varId = productBox.values
              .elementAt(i)
              .varId
              .toString();
          varName = productBox.values
              .elementAt(i)
              .varName;
          varMinItem = productBox.values
              .elementAt(i)
              .varMinItem
              .toString();
          varMaxItem = productBox.values
              .elementAt(i)
              .varMaxItem
              .toString();
          varLoyalty = productBox.values
              .elementAt(i)
              .itemLoyalty
              .toString();
          varStock = productBox.values
              .elementAt(i)
              .varStock
              .toString();
          varMrp = productBox.values
              .elementAt(i)
              .varMrp
              .toString();
          itemName = productBox.values
              .elementAt(i)
              .itemName;
          price = productBox.values
              .elementAt(i)
              .itemPrice
              .toString();
          membershipPrice = productBox.values
              .elementAt(i)
              .membershipPrice
              .toString();
          itemImage = productBox.values
              .elementAt(i)
              .itemImage;
          veg_type = productBox.values
              .elementAt(i)
              .veg_type;
          type = productBox.values
              .elementAt(i)
              .type;
          eligibleforexpress = productBox.values
              .elementAt(i)
              .eligible_for_express;
          delivery = productBox.values
              .elementAt(i)
              .delivery;
          duration = productBox.values
              .elementAt(i)
              .duration;
          durationType = productBox.values
              .elementAt(i)
              .durationType;
          note = productBox.values
              .elementAt(i)
              .note;
          break;
        }
      }
      final s = await Provider.of<CartItems>(context, listen: false).
      updateCart(varId, itemCount.toString(), price).then((_) async {
        if (itemCount + 1 == int.parse(varMinItem)) {
          for (int i = 0; i < productBox.values.length; i++) {
            if (productBox.values
                .elementAt(i)
                .mode == 1) {
              PrefUtils.prefs!.setString("membership", "0");
            }
            if (productBox.values
                .elementAt(i)
                .varId == int.parse(varId)) {
              productBox.deleteAt(i);
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
      );
    }catch(e){

    }
  }*/

  Future<void> Orderfood() async {
    final routeArgs = ModalRoute
        .of(context)!
        .settings
        .arguments as Map<String, String>;
    final cartItemsData = Provider.of<CartItems>(context, listen: false);
    String deliveryDurationExpress = /*routeArgs['deliveryDurationExpress']!*/widget
        .deliveryDurationExpress;
    String? finalDate;
    DateTime now= DateTime.now();
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    setState(() {
      finalDate =  DateFormat("dd-MM-yyyy").format(dateParse).toString();
    });
    var url = Api.newOrderByCart;
    String channel = "";
    var membership = "";
    var index = "";
    String type = "1";
    String orderId="";
    bool mode = false;
    String surveyorderid = "";
    String surveyproductname = "";
    for (int i = 0; i < productBox.length; i++) {
      if (productBox[i].mode == "1") {
        index = i.toString();
        membership = productBox[i].membershipId.toString();
        break;
      }else if(productBox[i].mode == "3"){
        mode = true;
        surveyorderid = productBox[i].itemId!;
        surveyproductname = productBox[i].itemName!;
      }
    }
    String? _only;
    for (int i = 0; i < productBox.length; i++)
      if (productBox.length == 1 && productBox[i].mode == "1") {
        _only = "1";
      } else {
        _only = "0";
      }

    try {
      if (Platform.isIOS) {
        channel = "IOS";
      } else {
        channel = "Android";
      }
    } catch (e) {
      channel = "Web";
    }

    //  try {

    final loyaltyData = Provider.of<BrandItemsList>(context, listen: false);

    var resBody = {};
    resBody["userId"] = PrefUtils.prefs!.getString('apikey');
    resBody["walletType"] = PrefUtils.prefs!.getString("wallet_type");
    resBody["walletBalance"] = PrefUtils.prefs!.getString('amount');
    resBody["apiKey"] = PrefUtils.prefs!.getString('apikey');
    resBody["restId"] = /*PrefUtils.prefs!.getString('resId')*/ "0";
    resBody["addressId"] = /*PrefUtils.prefs!.getString('addressId')*/
    /*routeArgs['addressId']*/widget.addressId;
    resBody["orderType"] =
    _isPickup ? "pickup" : (/*routeArgs['deliveryType']*/widget.deliveryType ==
        "Default") ? "Delivery" : "express";
    resBody["paymentType"] = PrefUtils.prefs!.getString('payment_type');
    resBody["promocode"] = _promocode;
    resBody["fix_time"] = _isPickup ? PrefUtils.prefs!.getString('fixtime')
        : (/*routeArgs['deliveryType']*/widget.deliveryType == "OptionTwo")
        ? deliveryDurationExpress + " - express"
        : PrefUtils.prefs!.getString('fixtime');
    resBody["fixdate"] = _isPickup
        ? PrefUtils.prefs!.getString('fixdate')
        : (/*routeArgs['deliveryType']*/widget.deliveryType == "OptionTwo")
        ? finalDate
        : PrefUtils.prefs!.getString('fixdate');
    resBody["promo"] = _promocode;
    // resBody["promotype"] = promoType;//PrefUtils.prefs!.getString("promocodeType");
    // resBody["promovalue"] = _savedamount;
//      resBody["membership"] = PrefUtils.prefs!.getString('fixtime');
    resBody["only"] = _only;
    resBody["channel"] = channel;
    resBody["membership"] = membership;
    resBody["membership_active"] = membershipvx;
    resBody["note"] = mode? "Survey Product "+surveyproductname+"(#"+surveyorderid+")"+" added":note;
    resBody["branch"] = PrefUtils.prefs!.getString("branch") ?? "999";
    resBody["ref"] = IConstants.refIdForMultiVendor.toString();
    resBody["branchtype"] = IConstants.branchtype.toString();
    resBody["loyalty"] =
    (_isSwitch && _isLoayalty && (double.parse(loyaltyPoints) > 0)) ? "1" : "0";
    resBody["loyalty_points"] = loyaltyPointsUser.roundToDouble().toString();
    resBody["point"] =
    (loyaltyData.itemsLoyalty.length > 0) ? loyaltyData.itemsLoyalty[0].points
        .toString() : "0";
    resBody["version"] = _isWeb ? "web 1.0.0" : packageInfo!.version + "+" +
        packageInfo!.buildNumber;
    resBody["survey_mode"] = mode? "1":"0";

    bool toppings = false;
    List itemsToppings = [];
    for (int i = 0; i < productBox.length; i++) {
       if(productBox[i].toppings_data!.length > 0){
         toppings = true;
       }else{
         toppings = false;
       }

      if(toppings) {
        itemsToppings.clear();
        for (int j = 0; j < productBox[i].toppings_data!.length; j++) {
          itemsToppings.add(productBox[i].toppings_data![j].toJson());
        }
      }

        if (double.parse(productBox[i].varStock!) > 0 &&
            productBox[i].status.toString() == "0") {
          if (index != "") {
            if (int.parse(index) == i) {}
            else {
              resBody["items[" + i.toString() + "][productId]"] =
                  productBox[i].itemId.toString();
              resBody["items[" + i.toString() + "][priceVariation]"] =
                  productBox[i].varId.toString();
              resBody["items[" + i.toString() + "][quantity]"] =
                  productBox[i].quantity.toString();
              resBody["items[" + i.toString() + "][weight]"] =
                  productBox[i].weight.toString();
              resBody["items[" + i.toString() + "][mrp]"] =
                  productBox[i].varMrp.toString();
            //  resBody["items[" + i.toString() + "][toppings]"] = itemsToppings.toString();
              if(toppings) {
                for (int j = 0; j < productBox[i].toppings_data!.length; j++) {
                  resBody["items[" + i.toString() + "][toppings][" + j.toString() + "][id]"] =
                      productBox[i].toppings_data![j].id.toString();
                  resBody["items[" + i.toString() + "][toppings][" + j.toString() + "][name]"] =
                      productBox[i].toppings_data![j].name.toString();
                  resBody["items[" + i.toString() + "][toppings][" + j.toString() + "][price]"] =
                      productBox[i].toppings_data![j].price.toString();
                  resBody["items[" + i.toString() + "][toppings][" + j.toString() + "][quantity]"] =
                      (productBox[i].type =="1")? productBox[i].weight.toString() :productBox[i].quantity.toString();
                }
              }

              if (membershipvx == "1" ||_checkmembership) { //membered user
                if (productBox[i].membershipPrice == '-' ||
                    double.parse(productBox[i].membershipPrice!).toStringAsFixed(0) == "0") {
                  if (double.parse(productBox[i].price!) <= 0 ||
                      productBox[i].price.toString() == "" ||
                      productBox[i].price == productBox[i].varMrp) {
                    resBody["items[" + i.toString() + "][price]"] =
                        productBox[i].varMrp.toString();
                  } else {
                    resBody["items[" + i.toString() + "][price]"] =
                        productBox[i].price.toString();
                  }
                } else {
                  resBody["items[" + i.toString() + "][price]"] =
                      productBox[i].membershipPrice;
                }
              } else { //Non membered user
                if (double.parse(productBox[i].price!) <= 0 ||
                    productBox[i].price.toString() == "" ||
                    productBox[i].price == productBox[i].varMrp) {
                  resBody["items[" + i.toString() + "][price]"] =
                      productBox[i].varMrp.toString();
                } else {
                  resBody["items[" + i.toString() + "][price]"] =
                      productBox[i].price.toString();
                }
              }

              if (productBox[i].mode == "4") {
                resBody["items[" + i.toString() + "][type]"] = "2";
              } else {
                resBody["items[" + i.toString() + "][type]"] = "1";
              }
            }
          }
          else {
            resBody["items[" + i.toString() + "][productId]"] =
                productBox[i].itemId.toString();
            resBody["items[" + i.toString() + "][priceVariation]"] =
                productBox[i].varId.toString();
            resBody["items[" + i.toString() + "][quantity]"] =
                productBox[i].quantity.toString();
            resBody["items[" + i.toString() + "][weight]"] =
                productBox[i].weight.toString();
            resBody["items[" + i.toString() + "][mrp]"] =
                productBox[i].varMrp.toString();

             if(toppings) {
                for (int j = 0; j < productBox[i].toppings_data!.length; j++) {
                  resBody["items[" + i.toString() + "][toppings][" + j.toString() + "][id]"] =
                      productBox[i].toppings_data![j].id.toString();
                  resBody["items[" + i.toString() + "][toppings][" + j.toString() + "][name]"] =
                      productBox[i].toppings_data![j].name.toString();
                  resBody["items[" + i.toString() + "][toppings][" + j.toString() + "][price]"] =
                      productBox[i].toppings_data![j].price.toString();
                  resBody["items[" + i.toString() + "][toppings][" + j.toString() + "][quantity]"] =
                  (productBox[i].type =="1")? productBox[i].weight.toString() :productBox[i].quantity.toString();
                }
              }

            if (membershipvx == "1"||_checkmembership) { //membered user
              if (productBox[i].membershipPrice == '-' ||
                  double.parse(productBox[i].membershipPrice!).toStringAsFixed(0) == "0") {
                if (double.parse(productBox[i].price!) <= 0 ||
                    productBox[i].price.toString() == "" ||
                    productBox[i].price == productBox[i].varMrp) {
                  resBody["items[" + i.toString() + "][price]"] =
                      productBox[i].varMrp.toString();
                } else {
                  resBody["items[" + i.toString() + "][price]"] =
                      productBox[i].price.toString();
                }
              } else {
                resBody["items[" + i.toString() + "][price]"] =
                    productBox[i].membershipPrice;
              }
            } else { //Non membered user
              if (double.parse(productBox[i].price!) <= 0 ||
                  productBox[i].price.toString() == "" ||
                  productBox[i].price == productBox[i].varMrp) {
                resBody["items[" + i.toString() + "][price]"] =
                    productBox[i].varMrp.toString();
              } else {
                resBody["items[" + i.toString() + "][price]"] =
                    productBox[i].price.toString();
              }
            }

            if (productBox[i].mode == "4") {
              resBody["items[" + i.toString() + "][type]"] = "2";
            } else {
              resBody["items[" + i.toString() + "][type]"] = "1";
            }
          }
        }

    }
      debugPrint("fromstore..." + resBody.toString());
      final response = await http.post(
        url,
        body: resBody,
      );
      debugPrint("Orderfood...response" + resBody.toString());
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      debugPrint("Orderfood...responseJson" + responseJson.toString());
      responsejson = responseJson['status'].toString();
      if (responseJson['status'].toString() == "true") {
        final orderencode = json.encode(responseJson['order']);
        final orderdecode = json.decode(orderencode);
        if (PrefUtils.prefs!.getString('payment_type') == "paytm") {
          String orderAmount = orderdecode['orderAmount'].toString();
          PrefUtils.prefs!.setString("orderId", orderdecode['id'].toString());
          orderId = orderdecode['id'].toString();
          final routeArgs = ModalRoute
              .of(context)!
              .settings
              .arguments as Map<String, String>;
          //  Navigator.of(context).pop();

          await payment.startPaytmTransaction(context, _isWeb,
              orderId: orderdecode['id'].toString(),
              username: PrefUtils.prefs!.getString('userID'),
              amount: orderAmount,
              routeArgs: /* routeArgs*/widget.params1,
              prev: "PaymentScreen"
          );
        } else {
          for (int i = 0; i < productBox.length; i++) {
            if (productBox[i].mode == "1") {
              PrefUtils.prefs!.setString("membership", "2");
              auth.getuserProfile(onsucsess: (value){
              }, onerror: (){
              });
            }
          }
          Provider.of<CartItems>(context, listen: false).emptyCart().then((_) {
            //productBox.deleteFromDisk();
            productBox.clear();
            //await DBProvider.db.deleteAllItem();
      /*      Navigator.of(context).pushReplacementNamed(
                OrderconfirmationScreen.routeName,
                arguments: {
                  'orderstatus': "success",
                  'orderid': orderdecode['id'].toString()
                });*/
            Navigation(context, name: Routename.OrderConfirmation,
                navigatore: NavigatoreTyp.Push,
                parms: {'orderstatus': "success",
                  'orderid': orderdecode['id'].toString()});
          });
          final sellingitemData = Provider.of<SellingItemsList>(
              context, listen: false);
          for (int i = 0; i < sellingitemData.featuredVariation.length; i++) {
            sellingitemData.featuredVariation[i].varQty = 0;
          }

          for (int i = 0; i < sellingitemData.itemspricevarOffer.length; i++) {
            sellingitemData.itemspricevarOffer[i].varQty = 0;
            break;
          }
          for (int i = 0; i < sellingitemData.itemspricevarSwap.length; i++) {
            sellingitemData.itemspricevarSwap[i].varQty = 0;
            break;
          }

          for (int i = 0; i < sellingitemData.discountedVariation.length; i++) {
            sellingitemData.discountedVariation[i].varQty = 0;
            break;
          }

          final cartItemsData = Provider.of<CartItems>(context, listen: false);
          for (int i = 0; i < cartItemsData.items.length; i++) {
            cartItemsData.items[i].itemQty = 0;
          }
        }
      } else {
        setState(() {
          _checkpromo = false;
          Navigator.of(context).pop();
          Fluttertoast.showToast(msg: S
              .of(context)
              .something_went_wrong, //"Something went wrong!!!",
            fontSize: MediaQuery
                .of(context)
                .textScaleFactor * 13,);
        });
      }
    /*} catch (error) {
      throw error;
    }*/
  }

  Future<void> OrderfoodSplit() async {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    String deliveryDurationExpress = /*routeArgs['deliveryDurationExpress']!*/widget.deliveryDurationExpress;
    String? finalDate;
    DateTime now= DateTime.now();
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    setState(() {
      finalDate =  DateFormat("dd-MM-yyyy").format(dateParse).toString() ;
      debugPrint("syyyy...."+finalDate.toString());
    });
    var url = Features.sellerModule?Api.newOrderByCartSplitSeller:Api.newOrderByCartSplit;
    String channel = "";
    var membership = "";
    var index = "";
    String type = "1";
    bool mode = false;
    String surveyorderid = "";
    String surveyproductname = "";
    for (int i = 0; i < productBox.length; i++) {
      if (productBox[i].mode == "1") {
        index = i.toString();
        membership = productBox[i].membershipId.toString();
        break;
      }else if(productBox[i].mode == "3"){
        mode = true;
        surveyorderid = productBox[i].itemId!;
        surveyproductname = productBox[i].itemName!;
      }
    }

    try {
      if (Platform.isIOS) {
        channel = "IOS";
      } else {
        channel = "Android";
      }
    } catch (e) {
      channel = "Web";
    }

    try {
      final loyaltyData = Provider.of<BrandItemsList>(context,listen: false);
      var resBody = {};
      resBody["userId"] = PrefUtils.prefs!.getString('apikey');
      resBody["walletType"] = PrefUtils.prefs!.getString("wallet_type");
      resBody["walletBalance"] = PrefUtils.prefs!.getString('amount');
      resBody["apiKey"] = PrefUtils.prefs!.getString('apikey');
      resBody["restId"] = /*PrefUtils.prefs!.getString('resId')*/ "0";
      resBody["addressId"] = /*PrefUtils.prefs!.getString('addressId');*//*routeArgs['addressId']*/widget.addressId;
      //  resBody["orderType"] = _isPickup ? "pickup" : (routeArgs['deliveryType'] == "express") ? "express" : "Delivery";
      resBody["paymentType"] = PrefUtils.prefs!.getString('payment_type');
      resBody["promocode"] = _promocode;
      //   resBody["fix_time"] = _isPickup ? PrefUtils.prefs!.getString('fixtime')
      //      /*: (productBox.values.elementAt(0).eligible_for_express == "0") ?  deliveryDurationExpress*/ : PrefUtils.prefs!.getString('fixtime');
      // resBody["fixdate"] = _isPickup ? PrefUtils.prefs!.getString('fixdate') /*:(productBox.values.elementAt(0).eligible_for_express == "0") ? finalDate*/ : PrefUtils.prefs!.getString('fixdate');
      resBody["promo"] = _promocode;
      resBody["promotype"] = promoType;//PrefUtils.prefs!.getString("promocodeType");
      resBody["promovalue"] = _savedamount;
//      resBody["membership"] = PrefUtils.prefs!.getString('fixtime');
      resBody["channel"] = channel;
      resBody["membership"] = membership;
      resBody["membership_active"] = membershipvx;
      resBody["note"] = mode? "Survey Product "+surveyproductname+"(#"+surveyorderid+")"+" added":note;
      resBody["branch"] = PrefUtils.prefs!.getString("branch")??"999";
      resBody["ref"] = IConstants.refIdForMultiVendor.toString();
      resBody["branchtype"] = IConstants.branchtype.toString();
      resBody["loyalty"] = (_isSwitch && _isLoayalty && (double.parse(loyaltyPoints) > 0)) ? "1" : "0";
      resBody["loyalty_points"] = loyaltyPointsUser.roundToDouble().toString();
      resBody["point"] = (loyaltyData.itemsLoyalty.length > 0) ? loyaltyData.itemsLoyalty[0].points.toString() : "0";
      resBody["version"] = _isWeb ? "web 1.0.0" : packageInfo!.version + "+" + packageInfo!.buildNumber;

      resBody["expressDeliveryCharge"] = /*routeArgs['deliveryChargeExpress']*/widget.deliveryChargeExpress;
      resBody["survey_mode"] = mode? "1":"0";
      if(membershipvx == "1") {
        resBody["normalDeliveryCharge"] = /*routeArgs['deliveryChargePrime']*/widget.deliveryChargePrime;
      }else{
        resBody["normalDeliveryCharge"] = /* routeArgs['deliveryChargeNormal']*/widget.deliveryChargeNormal;
      }
      bool toppings = false;
      List itemsToppings = [];
      for (int i = 0; i < productBox.length; i++) {
        debugPrint("length...."+productBox[i].toppings_data!.length.toString());
        if(productBox[i].toppings_data!.length > 0){
          toppings = true;
        }else{
          toppings = false;
        }

        if(toppings) {
          debugPrint("toppings hihihi....else");
          itemsToppings.clear();
          for (int j = 0; j < productBox[i].toppings_data!.length; j++) {
            debugPrint("entered - times");
            /*resBody["items[toppings]"]*/  itemsToppings.add(productBox[i].toppings_data![j].toJson());
            debugPrint("itemsToppings...."+itemsToppings.toString());
          }
        }

        if(double.parse(productBox[i].varStock!) > 0 && productBox[i].status.toString() == "0") {
          if (index != "") {
            if (int.parse(index) == i) {}
            else {
              resBody["items[" + i.toString() + "][productId]"] =
                  productBox[i].itemId.toString();
              resBody["items[" + i.toString() + "][priceVariation]"] =
                  productBox[i].varId.toString();
              resBody["items[" + i.toString() + "][quantity]"] =
                  productBox[i].quantity.toString();
              resBody["items[" + i.toString() + "][weight]"] =
                  productBox[i].weight.toString();
              resBody["items[" + i.toString() + "][mrp]"] =
                  productBox[i].varMrp.toString();
              if(toppings) {
                debugPrint("toppings hihihi....");
                for (int j = 0; j < productBox[i].toppings_data!.length; j++) {
                  resBody["items[" + i.toString() + "][toppings][" + j.toString() + "][id]"] =
                      productBox[i].toppings_data![j].id.toString();
                  resBody["items[" + i.toString() + "][toppings][" + j.toString() + "][name]"] =
                      productBox[i].toppings_data![j].name.toString();
                  resBody["items[" + i.toString() + "][toppings][" + j.toString() + "][price]"] =
                      productBox[i].toppings_data![j].price.toString();
                  resBody["items[" + i.toString() + "][toppings][" + j.toString() + "][quantity]"] =
                  (productBox[i].type =="1")? productBox[i].weight.toString() :productBox[i].quantity.toString();
                }
              }

              //   resBody["orderType"] = _isPickup ? "pickup" : (routeArgs['deliveryType'] == "express") ? "express" : "Delivery";

              if (/*routeArgs['deliveryType']*/widget.deliveryType == "Default") {
                resBody["items[" + i.toString() + "][orderType]"] =
                _isPickup ? "pickup" : "Delivery";
              }
              else if (/*routeArgs['deliveryType']*/widget.deliveryType == "OptionTwo") {
                if (productBox[i].eligibleForExpress == "0") {
                  resBody["items[" + i.toString() + "][orderType]"] =
                  _isPickup ? "pickup" : "express";
                }
                else if (productBox[i].eligibleForExpress == "1" ||
                    productBox[i].eligibleForExpress == "") {
                  resBody["items[" + i.toString() + "][orderType]"] =
                  _isPickup ? "pickup" : "Delivery";
                }
              }
              else if (_isPickup == true) {
                resBody["items[" + i.toString() + "][orderType]"] =
                _isPickup ? "pickup" : "Delivery";
              }


              if (productBox[i].durationType == "0") {
                resBody["items[" + i.toString() + "][duration_type]"] = "date";
                resBody["items[" + i.toString() + "][duration]"] =
                    productBox[i].duration.toString();
              }
              else if (productBox[i].durationType == "1") {
                resBody["items[" + i.toString() + "][duration_type]"] = "time";
                resBody["items[" + i.toString() + "][duration]"] =
                    productBox[i].duration.toString();
              } else {
                resBody["items[" + i.toString() + "][duration_type]"] = "slot";
                resBody["items[" + i.toString() + "][duration]"] =
                    productBox[i].duration.toString();
              }

              if (/*routeArgs['deliveryType'] */widget.deliveryType== "Default") {
                if (productBox[i].durationType == "0") {
                  resBody["items[" + i.toString() + "][fix_time]"] =
                  "6:00 AM - 9:00 PM";
                  resBody["items[" + i.toString() + "][fixdate]"] =
                      productBox[i].duration.toString();
                } else if (productBox[i].durationType == "1") {
                  DateTime? finalDate = now.add(
                      Duration(hours: int.parse(productBox[i].duration!)));
                  var fixdate = "${finalDate.day}-${finalDate.month}-${finalDate
                      .year}";
                  resBody["items[" + i.toString() + "][fix_time]"] =
                  "6:00 AM - 9:00 PM";
                  resBody["items[" + i.toString() + "][fixdate]"] = fixdate;
                }
                else {
                  resBody["items[" + i.toString() + "][fix_time]"] =
                      PrefUtils.prefs!.getString('fixtime');
                  resBody["items[" + i.toString() + "][fixdate]"] =
                      PrefUtils.prefs!.getString('fixdate');
                }
              } else {
                if (productBox[i].durationType == "0" &&
                    productBox[i].eligibleForExpress == "1") {
                  resBody["items[" + i.toString() + "][fix_time]"] =
                  "6:00 AM - 9:00 PM";
                  resBody["items[" + i.toString() + "][fixdate]"] =
                      productBox[i].duration.toString();
                } else if (productBox[i].durationType == "1" &&
                    productBox[i].eligibleForExpress == "1") {
                  DateTime? finalDate = now.add(
                      Duration(hours: int.parse(productBox[i].duration!)));
                  var fixdate = "${finalDate.day}-${finalDate.month}-${finalDate
                      .year}";

                  resBody["items[" + i.toString() + "][fix_time]"] =
                  "6:00 AM - 9:00 PM";
                  resBody["items[" + i.toString() + "][fixdate]"] = fixdate;
                }
                else if (productBox[i].eligibleForExpress == "0") {
                  resBody["items[" + i.toString() + "][fix_time]"] =
                      deliveryDurationExpress + " - express";
                  resBody["items[" + i.toString() + "][fixdate]"] = finalDate;
                } else {
                  resBody["items[" + i.toString() + "][fix_time]"] =
                      PrefUtils.prefs!.getString('fixtime');
                  resBody["items[" + i.toString() + "][fixdate]"] =
                      PrefUtils.prefs!.getString('fixdate');
                }
              }

              if (membershipvx == "1"||_checkmembership) { //membered user
                if (productBox[i].membershipPrice == '-' ||
                    double.parse(productBox[i].membershipPrice!).toStringAsFixed(0) == "0") {
                  if (double.parse(productBox[i].price!) <= 0 ||
                      productBox[i].price.toString() == "" ||
                      productBox[i].price == productBox[i].varMrp) {
                    resBody["items[" + i.toString() + "][price]"] =
                        productBox[i].varMrp.toString();
                  } else {
                    resBody["items[" + i.toString() + "][price]"] =
                        productBox[i].price.toString();
                  }
                } else {
                  resBody["items[" + i.toString() + "][price]"] =
                      productBox[i].membershipPrice;
                }
              } else { //Non membered user
                if (double.parse(productBox[i].price!) <= 0 ||
                    productBox[i].price.toString() == "" ||
                    productBox[i].price == productBox[i].varMrp) {
                  resBody["items[" + i.toString() + "][price]"] =
                      productBox[i].varMrp.toString();
                } else {
                  resBody["items[" + i.toString() + "][price]"] =
                      productBox[i].price.toString();
                }
              }

              if (membershipvx == "1"||_checkmembership) { //membered user
                if (productBox[i].membershipPrice == '-' ||
                    double.parse(productBox[i].membershipPrice!).toStringAsFixed(0) == "0") {
                  if (double.parse(productBox[i].price!) <= 0 ||
                      productBox[i].price.toString() == "" ||
                      productBox[i].price == productBox[i].varMrp) {
                    if(productBox[i].type=="1"){
                      resBody["items[" + i.toString() + "][totalPrice]"] =
                          (double.parse(productBox[i].varMrp!) *
                              double.parse(productBox[i].weight!)).toString();
                    }else{
                      resBody["items[" + i.toString() + "][totalPrice]"] =
                          (double.parse(productBox[i].varMrp!) *
                              int.parse(productBox[i].quantity!)).toString();
                    }
                  } else {
                    if(productBox[i].type=="1"){
                      resBody["items[" + i.toString() + "][totalPrice]"] =
                          (double.parse(productBox[i].price!) *
                              double.parse(productBox[i].weight!)).toString();
                    }else{
                      resBody["items[" + i.toString() + "][totalPrice]"] =
                          (double.parse(productBox[i].price!) *
                              int.parse(productBox[i].quantity!)).toString();
                    }
                  }
                } else {
                  if(productBox[i].type=="1"){
                    resBody["items[" + i.toString() + "][totalPrice]"] =
                        (double.parse(productBox[i].membershipPrice!) *
                            double.parse(productBox[i].weight!)).toString();
                  }else{
                    resBody["items[" + i.toString() + "][totalPrice]"] =
                        (double.parse(productBox[i].membershipPrice!) *
                            int.parse(productBox[i].quantity!)).toString();
                  }
                }
              } else { //Non membered user
                if (double.parse(productBox[i].price!) <= 0 ||
                    productBox[i].price.toString() == "" ||
                    productBox[i].price == productBox[i].varMrp) {
                  if(productBox[i].type=="1"){
                    resBody["items[" + i.toString() + "][totalPrice]"] =
                        (double.parse(productBox[i].varMrp!) *
                            double.parse(productBox[i].weight!)).toString();
                  }else{
                    resBody["items[" + i.toString() + "][totalPrice]"] =
                        (double.parse(productBox[i].varMrp!) *
                            int.parse(productBox[i].quantity!)).toString();
                  }
                } else {
                  if(productBox[i].type=="1"){
                    resBody["items[" + i.toString() + "][totalPrice]"] =
                        (double.parse(productBox[i].price!) *
                            double.parse(productBox[i].weight!)).toString();
                  }else{
                    resBody["items[" + i.toString() + "][totalPrice]"] =
                        (double.parse(productBox[i].price!) *
                            int.parse(productBox[i].quantity!)).toString();
                  }
                }
              }


              if (productBox[i].mode == "4") {
                resBody["items[" + i.toString() + "][type]"] = "2";
              } else {
                resBody["items[" + i.toString() + "][type]"] = "1";
              }
            }
          }
          else {
            resBody["items[" + i.toString() + "][productId]"] =
                productBox[i].itemId.toString();
            resBody["items[" + i.toString() + "][priceVariation]"] =
                productBox[i].varId.toString();
            resBody["items[" + i.toString() + "][quantity]"] =
                productBox[i].quantity.toString();
            resBody["items[" + i.toString() + "][weight]"] =
                productBox[i].weight.toString();
            resBody["items[" + i.toString() + "][mrp]"] =
                productBox[i].varMrp.toString();

            if(toppings) {
              debugPrint("toppings hihihi....");
              for (int j = 0; j < productBox[i].toppings_data!.length; j++) {
                resBody["items[" + i.toString() + "][toppings][" + j.toString() + "][id]"] =
                    productBox[i].toppings_data![j].id.toString();
                resBody["items[" + i.toString() + "][toppings][" + j.toString() + "][name]"] =
                    productBox[i].toppings_data![j].name.toString();
                resBody["items[" + i.toString() + "][toppings][" + j.toString() + "][price]"] =
                    productBox[i].toppings_data![j].price.toString();
                resBody["items[" + i.toString() + "][toppings][" + j.toString() + "][quantity]"] =
                (productBox[i].type =="1")? productBox[i].weight.toString() :productBox[i].quantity.toString();
              }
            }

            if (/*routeArgs['deliveryType'] */widget.deliveryType== "Default") {
              resBody["items[" + i.toString() + "][orderType]"] =
              _isPickup ? "pickup" : "Delivery";
            }
            else if (/*routeArgs['deliveryType']*/widget.deliveryType == "OptionTwo") {
              if (productBox[i].eligibleForExpress == "0") {
                resBody["items[" + i.toString() + "][orderType]"] =
                _isPickup ? "pickup" : "express";
              }
              else if (productBox[i].eligibleForExpress == "1" ||
                  productBox[i].eligibleForExpress == "") {
                resBody["items[" + i.toString() + "][orderType]"] =
                _isPickup ? "pickup" : "Delivery";
              }
            }
            else if (_isPickup == true) {
              resBody["items[" + i.toString() + "][orderType]"] =
              _isPickup ? "pickup" : "Delivery";
            }

            if (productBox[i].durationType == "0") {
              resBody["items[" + i.toString() + "][duration_type]"] = "date";
              resBody["items[" + i.toString() + "][duration]"] =
                  productBox[i].duration.toString();
            }
            else if (productBox[i].durationType == "1") {
              resBody["items[" + i.toString() + "][duration_type]"] = "time";
              resBody["items[" + i.toString() + "][duration]"] =
                  productBox[i].duration.toString();
            } else {
              resBody["items[" + i.toString() + "][duration_type]"] = "slot";
              resBody["items[" + i.toString() + "][duration]"] =
                  productBox[i].duration.toString();
            }


            if (/*routeArgs['deliveryType']*/widget.deliveryType == "Default") {
              if (productBox[i].durationType == "0") {
                resBody["items[" + i.toString() + "][fix_time]"] =
                "6:00 AM - 9:00 PM";
                resBody["items[" + i.toString() + "][fixdate]"] =
                    productBox[i].duration.toString();
              } else if (productBox[i].durationType == "1") {
                DateTime finalDate = now.add(
                    Duration(hours: int.parse(productBox[i].duration!)));
                var fixdate = "${finalDate.day}-${finalDate.month}-${finalDate
                    .year}";

                resBody["items[" + i.toString() + "][fix_time]"] =
                "6:00 AM - 9:00 PM";
                resBody["items[" + i.toString() + "][fixdate]"] = fixdate;
              }
              else {
                resBody["items[" + i.toString() + "][fix_time]"] =
                    PrefUtils.prefs!.getString('fixtime');
                resBody["items[" + i.toString() + "][fixdate]"] =
                    PrefUtils.prefs!.getString('fixdate');
              }
            } else {
              if (productBox[i].durationType == "0" &&
                  productBox[i].eligibleForExpress == "1") {
                resBody["items[" + i.toString() + "][fix_time]"] =
                "6:00 AM - 9:00 PM";
                resBody["items[" + i.toString() + "][fixdate]"] =
                    productBox[i].duration.toString();
              } else if (productBox[i].durationType == "1" &&
                  productBox[i].eligibleForExpress == "1") {
                DateTime finalDate = now.add(
                    Duration(hours: int.parse(productBox[i].duration!)));
                var fixdate = "${finalDate.day}-${finalDate.month}-${finalDate
                    .year}";

                resBody["items[" + i.toString() + "][fix_time]"] =
                "6:00 AM - 9:00 PM";
                resBody["items[" + i.toString() + "][fixdate]"] = fixdate;
              }
              else if (productBox[i].eligibleForExpress == "0") {
                resBody["items[" + i.toString() + "][fix_time]"] =
                    deliveryDurationExpress + " - express";
                resBody["items[" + i.toString() + "][fixdate]"] = finalDate;
              } else {
                resBody["items[" + i.toString() + "][fix_time]"] =
                    PrefUtils.prefs!.getString('fixtime');
                resBody["items[" + i.toString() + "][fixdate]"] =
                    PrefUtils.prefs!.getString('fixdate');
              }
            }


            if (membershipvx == "1"||_checkmembership) { //membered user
              if (productBox[i].membershipPrice == '-' ||
                  double.parse(productBox[i].membershipPrice!).toStringAsFixed(0) == "0") {
                if (double.parse(productBox[i].price!) <= 0 ||
                    productBox[i].price.toString() == "" ||
                    productBox[i].price == productBox[i].varMrp) {
                  resBody["items[" + i.toString() + "][price]"] =
                      productBox[i].varMrp.toString();
                } else {
                  resBody["items[" + i.toString() + "][price]"] =
                      productBox[i].price.toString();
                }
              } else {
                resBody["items[" + i.toString() + "][price]"] =
                    productBox[i].membershipPrice;
              }
            } else { //Non membered user
              if (double.parse(productBox[i].price!) <= 0 ||
                  productBox[i].price.toString() == "" ||
                  productBox[i].price == productBox[i].varMrp) {
                resBody["items[" + i.toString() + "][price]"] =
                    productBox[i].varMrp.toString();
              } else {
                resBody["items[" + i.toString() + "][price]"] =
                    productBox[i].price.toString();
              }
            }

            if (membershipvx == "1"||_checkmembership) { //membered user
              if (productBox[i].membershipPrice == '-' ||
                  double.parse(productBox[i].membershipPrice!).toStringAsFixed(0) == "0") {
                if (double.parse(productBox[i].price!) <= 0 ||
                    productBox[i].price.toString() == "" ||
                    productBox[i].price == productBox[i].varMrp) {
                  if(productBox[i].type=="1") {
                    resBody["items[" + i.toString() + "][totalPrice]"] =
                        (double.parse(productBox[i].varMrp!) *
                            double.parse(productBox[i].weight!)).toString();
                  }else{
                    resBody["items[" + i.toString() + "][totalPrice]"] =
                        (double.parse(productBox[i].varMrp!) *
                            int.parse(productBox[i].quantity!)).toString();
                  }
                } else {
                  if(productBox[i].type=="1") {
                    resBody["items[" + i.toString() + "][totalPrice]"] =
                        (double.parse(productBox[i].price!) *
                            double.parse(productBox[i].weight!)).toString();
                  }else{
                    resBody["items[" + i.toString() + "][totalPrice]"] =
                        (double.parse(productBox[i].price!) *
                            int.parse(productBox[i].quantity!)).toString();
                  }
                }
              } else {
                if(productBox[i].type=="1") {
                  resBody["items[" + i.toString() + "][totalPrice]"] =
                      (double.parse(productBox[i].membershipPrice!) *
                          double.parse(productBox[i].weight!)).toString();
                }else{
                  resBody["items[" + i.toString() + "][totalPrice]"] =
                      (double.parse(productBox[i].membershipPrice!) *
                          int.parse(productBox[i].quantity!)).toString();
                }
              }
            } else { //Non membered user
              if (double.parse(productBox[i].price!) <= 0 ||
                  productBox[i].price.toString() == "" ||
                  productBox[i].price == productBox[i].varMrp) {
                if(productBox[i].type=="1") {
                  resBody["items[" + i.toString() + "][totalPrice]"] =
                      (double.parse(productBox[i].varMrp!) *
                          double.parse(productBox[i].weight!)).toString();
                }else{
                  resBody["items[" + i.toString() + "][totalPrice]"] =
                      (double.parse(productBox[i].varMrp!) *
                          int.parse(productBox[i].quantity!)).toString();
                }
              } else {
                if(productBox[i].type=="1") {
                  resBody["items[" + i.toString() + "][totalPrice]"] =
                      (double.parse(productBox[i].price!) *
                          double.parse(productBox[i].weight!)).toString();
                }else{
                  resBody["items[" + i.toString() + "][totalPrice]"] =
                      (double.parse(productBox[i].price!) *
                          int.parse(productBox[i].quantity!)).toString();
                }
              }
            }

            if (productBox[i].mode == "4") {
              resBody["items[" + i.toString() + "][type]"] = "2";
            } else {
              resBody["items[" + i.toString() + "][type]"] = "1";
            }
          }
        }
      }

      debugPrint("resBody . . . . .. ");
      debugPrint(resBody.toString());

      final response = await http.post(
        url,
        body: resBody,
      );
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      debugPrint("asdf......."+responseJson.toString());
      responsejson=responseJson['status'].toString();
      if (responseJson['status'].toString() == "true") {
        final orderencode = json.encode(responseJson['order']);
        final orderdecode = json.decode(orderencode);
        if (PrefUtils.prefs!.getString('payment_type') == "paytm") {
          String orderAmount = orderdecode['orderAmount'].toString();
          PrefUtils.prefs!.setString("orderId", orderdecode['ref_id'].toString());

          final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          // if(Vx.isWeb){
          //   Navigator.of(context)
          //       .pushReplacementNamed(PaytmScreen.routeName, arguments: {
          //     'orderId': orderdecode['ref_id'].toString(),
          //     'orderAmount': orderAmount,
          //     'minimumOrderAmountNoraml': /*routeArgs['minimumOrderAmountNoraml']*/widget.minimumOrderAmountNoraml,
          //     'deliveryChargeNormal': /*routeArgs['deliveryChargeNormal']*/widget.deliveryChargeNormal,
          //     'minimumOrderAmountPrime': /*routeArgs['minimumOrderAmountPrime']*/widget.minimumOrderAmountPrime,
          //     'deliveryChargePrime': /*routeArgs['deliveryChargePrime']*/widget.deliveryChargePrime,
          //     'minimumOrderAmountExpress': /*routeArgs['minimumOrderAmountExpress']*/widget.minimumOrderAmountExpress,
          //     'deliveryChargeExpress': /*routeArgs['deliveryChargeExpress']*/widget.deliveryChargeExpress,
          //     'deliveryType':/* routeArgs['deliveryType']*/widget.deliveryType,
          //     'note': /*routeArgs['note']*/widget.note,
          //     'addressId': /*routeArgs['addressId']*/widget.addressId,
          //     'deliveryCharge':/* routeArgs['deliveryCharge']*/widget.deliveryCharge,
          //     'deliveryDurationExpress' : /*routeArgs['deliveryDurationExpress']*/widget.deliveryDurationExpress,
          //
          //   });
          //
          // }else {
            payment.startPaytmTransaction(
                context, _isWeb, orderId: orderdecode['ref_id'].toString(),
                username: PrefUtils.prefs!.getString('userID'),
                amount: orderAmount,
                routeArgs: widget.params1,
                prev: "PaymentScreen");
        //  }
        } else {
          for (int i = 0; i < productBox.length; i++) {
            if (productBox[i].mode == "1") {
              PrefUtils.prefs!.setString("membership", "2");
              auth.getuserProfile(onsucsess: (value){

              }, onerror: (){

              });
            }
          }
          Provider.of<CartItems>(context, listen: false).emptyCart().then((_) {
            //productBox.deleteFromDisk();
            productBox.clear();
            //await DBProvider.db.deleteAllItem();
           // Navigator.of(context).pushReplacementNamed(OrderconfirmationScreen.routeName, arguments: {'orderstatus': "success",'orderid':orderdecode['ref_id'].toString()});
            Navigation(context, name: Routename.OrderConfirmation, navigatore: NavigatoreTyp.Push,
                parms: {'orderstatus' : "success",
                  'orderid': orderdecode['ref_id'].toString()});
          });
          final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);
          for(int i = 0; i < sellingitemData.featuredVariation.length; i++) {
            sellingitemData.featuredVariation[i].varQty = 0;
          }

          for (int i = 0; i < sellingitemData.itemspricevarOffer.length; i++) {
            sellingitemData.itemspricevarOffer[i].varQty = 0;
            break;
          }
          for(int i = 0; i < sellingitemData.itemspricevarSwap.length; i++) {
            sellingitemData.itemspricevarSwap[i].varQty = 0;
            break;
          }

          for(int i = 0; i < sellingitemData.discountedVariation.length; i++) {
            sellingitemData.discountedVariation[i].varQty = 0;
            break;
          }

          final cartItemsData = Provider.of<CartItems>(context, listen: false);
          for(int i = 0; i < cartItemsData.items.length; i++) {
            cartItemsData.items[i].itemQty = 0;
          }
        }
      } else {
        setState(() {
          _checkpromo = false;
        });
        Navigator.of(context).pop();
         Fluttertoast.showToast(msg: S .of(context).something_went_wrong,//"Something went wrong!!!"
        );
      }
    } catch (error) {
      throw error;
    }
  }

//   Future<void> checkPromo() async {
//     // imp feature in adding async is the it automatically wrap into Future.
//     if (myController.text == "") {
//       setState(() {
//         _checkpromo = false;
//         // Navigator.of(context).pop();
//       });
//        Fluttertoast.showToast(msg: S .of(context).please_enter_valid_promo,//"Please enter a valid Promocode!!!",
//         fontSize: MediaQuery.of(context).textScaleFactor *13,);
//     } else {
//       var item = [];
//       for (int i = 0; i < productBox.length; i++) {
//         if (!_checkmembership) {
//           if (double.parse(productBox[i].price!) <= 0 || productBox[i].price.toString() == "" || productBox[i].price == productBox[i].varMrp) {
//             promovarprice = productBox[i].varMrp.toString();
//           } else {
//             promovarprice = productBox[i].price.toString();
//           }
//         } else {
//           if(double.parse(productBox[i].membershipPrice!) <= 0 || productBox[i].membershipPrice == "" || double.parse(productBox[i].membershipPrice!) == productBox[i].varMrp) {
//             promovarprice = productBox[i].varMrp.toString();
//           } else {
//             promovarprice = productBox[i].membershipPrice;
//           }
//         }
//         var item1 = {};
//         item1["\"itemid\""] =
//             "\"" + productBox[i].varId.toString() + "\"";
//         item1["\"qty\""] = productBox[i].quantity.toString();
//         item1["\"price\""] = promovarprice;
//         item.add(item1);
//       }
//
//     //  try {
//         setState(() {
//           _promocode = myController.text;
//         });
//
//         final response = await http.post(Api.checkPromocode, body: {
//           "promocode": myController.text,
//           "items": item.toString(),
//           "user": PrefUtils.prefs!.getString('apikey'),
//           "total": cartTotal.toString(),
//           "delivery": /*_isPickup ? "0.0" :*/ deliveryAmt.toString(),
//           "branch": PrefUtils.prefs!.getString('branch')??"999",
//         });
//         print("promocde././././." + {
//           "promocode": myController.text,
//           "items": item.toString(),
//           "user": PrefUtils.prefs!.getString('apikey'),
//           "total": cartTotal.toString(),
//           "delivery": /*_isPickup ? "0.0" :*/ deliveryAmt.toString(),
//           "branch": PrefUtils.prefs!.getString('branch')??"999",
//         }.toString());
//         final responseJson = json.decode(response.body);
//         promoType = responseJson['prmocodeType'].toString();
// print("addgh"+responseJson['amount'].toString());
//         if (responseJson['status'].toString() == "done") {
//           if ((responseJson['prmocodeType'].toString() == "cashback") || (responseJson['prmocodeType'].toString() == "Cashback")){
//             setState(() {
//               _checkpromo = false;
//               _displaypromo = true;
//               _savedamount = responseJson['amount'].toString();
//               /*  if (_isPickup)
//                 _promoamount = ((cartTotal + deliveryAmt)).toString();
//               else*/
//               _promoamount = ((cartTotal + deliveryAmt)).toString();
//               _promocode = myController.text;
//
//               //walletAmount = double.parse(walletbalance);
//               //remainingAmount = double.parse(_promoamount) - double.parse(walletbalance);
//
//               promocashbackmsg = responseJson['msg'].toString();
//               promomessage = responseJson['prmocodeType'].toString();
//             });
//            _dialogForPromo()  ;
//
//           }
//           else {
//             setState(() {
//               _checkpromo = false;
//               _displaypromo = true;
//               _savedamount = responseJson['amount'].toString();
//               /* if (_isPickup)
//                 _promoamount = (cartTotal -
//                     double.parse(responseJson['amount'].toString()))
//                     .toString();
//               else*/
//               _promoamount = ((cartTotal + deliveryAmt) -
//                   double.parse(responseJson['amount'].toString()))
//                   .toString();
//
//               _promocode = myController.text;
//
//               //walletAmount = double.parse(walletbalance);
//               //remainingAmount = double.parse(_promoamount) - double.parse(walletbalance);
//
//               promocashbackmsg = responseJson['msg'].toString();
//               promomessage = responseJson['prmocodeType'].toString();
//             });
//           }
//           setState(() {
//             _ischeckbox = !_ischeckbox;
//           });
//           //Apply loaylty after applied promocde
//           if (_isLoayalty &&
//               responseJson['prmocodeType'].toString().toLowerCase() != "cashback") {
//             await Provider.of<BrandItemsList>(context,listen: false)
//                 .checkLoyalty(_promoamount)
//                 .then((_) {
//               setState(() {
//                 _isSwitch = true;
//                 double totalAmount = 0.0; //Order amount
//                 !_displaypromo
//                     ? /*_isPickup
//                     ? totalAmount = cartTotal
//                     :*/ totalAmount = (cartTotal + deliveryAmt)
//                     : totalAmount = (double.parse(_promoamount));
//
//                 //check user eligible to use Loyalty points or not
//                 final loyaltyData = Provider.of<BrandItemsList>(context,listen: false);
//                 if (double.parse(
//                     loyaltyData.itemsLoyalty[0].minimumOrderAmount!) <=
//                     totalAmount) {
//                   _isSwitch = true;
//                   _isLoyaltyToast = false;
//                   //Compare user loyalty balance to apply loyalty points
//                   if (PrefUtils.prefs!.getDouble("loyaltyPointsUser") !<=
//                       int.parse(loyaltyPoints)) {
//                     loyaltyPointsUser = PrefUtils.prefs!.getDouble("loyaltyPointsUser")!;
//                     loyaltyAmount = ((loyaltyPointsUser * 1) /
//                         int.parse(loyaltyData.itemsLoyalty[0].points!));
//                   } else {
//                     /*loyaltyPointsUser = prefs.getDouble("loyaltyPointsUser") - int.parse(loyaltyPoints);
//                     loyaltyAmount = ((loyaltyPointsUser * 1) / int.parse(loyaltyData.itemsLoyalty[0].points));*/
//
//                     loyaltyPointsUser = double.parse(loyaltyPoints);
//                     loyaltyAmount = ((loyaltyPointsUser * 1) /
//                         int.parse(loyaltyData.itemsLoyalty[0].points!));
//                   }
//                 } else {
//                   _isSwitch = true;
//                   _isLoyaltyToast = true;
//                 }
//
//                 //Consider wallet and loyalty
//                 if (_isWallet) {
//                   double totalAmount = 0.0;
//                   !_displaypromo
//                       ? /*_isPickup
//                       ? totalAmount = cartTotal
//                       :*/ totalAmount = (cartTotal + deliveryAmt)
//                       : totalAmount = (double.parse(_promoamount));
//
//                   if (int.parse(walletbalance) <=
//                       0 /*|| double.parse((cartTotal + deliveryamount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)) > int.parse(walletbalance)*/) {
//                     _isRemainingAmount = false;
//                     _ischeckboxshow = false;
//                     _ischeckbox = false;
//                     _isRemainingAmount = false;
//                   } else if (_isSwitch &&
//                       !_isLoyaltyToast &&
//                       _isLoayalty &&
//                       (double.parse(loyaltyPoints) > 0)
//                       ? totalAmount <=
//                       (int.parse(walletbalance) + loyaltyAmount)
//                       : totalAmount <= (int.parse(walletbalance))) {
//                     _isRemainingAmount = false;
//                     _groupValue = -1;
//                     PrefUtils.prefs!.setString("payment_type", "wallet");
//                     walletAmount = _isSwitch &&
//                         !_isLoyaltyToast &&
//                         _isLoayalty &&
//                         (double.parse(loyaltyPoints) > 0)
//                         ? (totalAmount - loyaltyAmount)
//                         : totalAmount;
//                   } else if (_isSwitch &&
//                       !_isLoyaltyToast &&
//                       _isLoayalty &&
//                       (double.parse(loyaltyPoints) > 0)
//                       ? totalAmount > (int.parse(walletbalance) + loyaltyAmount)
//                       : totalAmount > int.parse(walletbalance)) {
//                     bool _isOnline = false;
//                     for (int i = 0; i < paymentData.itemspayment.length; i++) {
//                       if (paymentData.itemspayment[i].paymentMode == "1") {
//                         _groupValue = i;
//                         _isOnline = true;
//                         break;
//                       }
//                     }
//                     if (_isOnline) {
//                       _groupValue = -1;
//                       _isRemainingAmount = true;
//                       walletAmount = double.parse(walletbalance);
//                       remainingAmount = _isSwitch &&
//                           !_isLoyaltyToast &&
//                           _isLoayalty &&
//                           (double.parse(loyaltyPoints) > 0)
//                           ? totalAmount -
//                           double.parse(walletbalance) -
//                           loyaltyAmount
//                           : (totalAmount - int.parse(walletbalance));
//                     } else {
//                       _isWallet = false;
//                       _ischeckbox = false;
//                     }
//                     for (int i = 0; i < paymentData.itemspayment.length; i++) {
//                       if (paymentData.itemspayment[i].paymentMode == "1") {
//                         _groupValue = i;
//                         break;
//                       }
//                     }
//                   }
//                 } else {
//                   _ischeckbox = false;
//                 }
//
//                  });
//             });
//           } else {
//             //Navigator.of(context).pop();
//           }
//         } else if (responseJson['status'].toString() == "error") {
//           setState(() {
//             _checkpromo = false;
//             _displaypromo = false;
//             _savedamount = "";
//             _promoamount = "";
//             _promocode = "";
//           });
//           //Navigator.of(context).pop();
//            Fluttertoast.showToast(msg: responseJson['msg'].toString(), fontSize: MediaQuery.of(context).textScaleFactor *13,);
//         }
//       // } catch (error) {
//       //   throw error;
//       // }
//     }
//   }


  _dialogForPromo (){

   debugPrint("cashback....dialog");
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          //  Stack(
          //   overflow: Overflow.visible,
          //   children: [
          content:
          Container(
            height:200,

            child: Stack(
              //overflow: Overflow.visible,
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height:5),
                      Text(S.of(context).cash_back,
                        style: TextStyle(
                          color: Colors.black, fontSize: 22,fontWeight: FontWeight.bold,
                        ), ),
                      SizedBox(height:10),
                      Text(
                      _promocode,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),),
                      SizedBox(height:10),
                      Text(
                        Features.iscurrencyformatalign?
                        _savedamount + IConstants.currencyFormat:
                        IConstants.currencyFormat + _savedamount,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),),
                      Text(
                        S.of(context).saving_with_this_coupon,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18,color: Colors.grey),),
                      SizedBox(height:20),
                      Text(
                        S.of(context).yay,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: ColorCodes.greenColor),),
                    ],
                  ),
                ),
                Positioned(
                  left: 100,
                  top: -50,
                  child: InkWell(
                    child:CircleAvatar(
                      radius: 25.0,
                      backgroundColor: Colors.white,
                      child:  Image.asset(Images.home_offer, height: 60.0, width: 60.0),
                    ),
                  ),
                ),
              ],
            ),
          ),

          //   ],
          // ),
        );
      },
    );

  }

  _dialogforPromo (String promocode, String amount){


    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
        ),
          content:
          Stack(
            //overflow: Overflow.visible,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 10,top: 0, right: 10,bottom: 20
                ),
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  // boxShadow: [
                  //   BoxShadow(color: Colors.white,offset: Offset(0,10),
                  //       blurRadius: 10
                  //   ),
                  // ]
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(" \'" + promocode + " \'"+ " "+S.of(context).applied,//"applied",
                      style: TextStyle(
                        color: Colors.black, fontSize: 22,fontWeight: FontWeight.bold,
                      ), ),
                    SizedBox(height:8),
                    IConstants.numberFormat == "1" ?
                    Text(IConstants.currencyFormat+" "+ double.parse(amount).toStringAsFixed(0),style: TextStyle(color: ColorCodes.blackColor, fontSize: 40,fontWeight: FontWeight.bold), )
                        :
                    Text(IConstants.currencyFormat+" "+ double.parse(amount).toStringAsFixed(IConstants.decimaldigit),style: TextStyle(color: ColorCodes.blackColor, fontSize: 40,fontWeight: FontWeight.bold), ),
                    SizedBox(height:3),
                    Text(
                      S.of(context).saving_coupon,//"savings with this coupon",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18,color: ColorCodes.blackColor, fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    Text(/*"Keep using "*/S.of(context).keep_using+ promocode +/*" and save more with each order"*/S.of(context).save_more_order, textAlign: TextAlign.center, style: TextStyle(color: ColorCodes.blackColor,
                        fontSize: 17), ),
                    SizedBox(height:17),
                    Text(
                      S.of(context).yay,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: ColorCodes.primaryColor),),
                  ],
                ),
              ),
              Positioned(
                left: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?MediaQuery.of(context).size.width/8:MediaQuery.of(context).size.width/4,
                top: -50,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,//Constants.avatarRadius,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Image.asset(
                      Images.appLoyalty,
                      color: ColorCodes.primaryColor,
                      height: 45,
                      width: 45,
                    ),
                  ),
                ),
              ),
            ],
          )
        );
      },
    );


  }

  Future<void> LogicPromo() async{
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    // final response = json.encode(routeArgs['responsejson']);
    // final responseJson = json.decode(response);

    debugPrint("ststus..."+routeArgs['prmocodeType']);
    if (membershipvx == "1") {
      debugPrint("totalMember...."+ CartCalculations.totalMember.toString());
      cartTotal = CartCalculations.totalMember;
    } else {
      debugPrint("total...."+CartCalculations.total.toString());
      cartTotal = CartCalculations.total;
    }
    if (routeArgs['status'] == "done") {
      _dialogforPromo(routeArgs['promocode'],routeArgs['amount']);
      promoType = routeArgs['prmocodeType'];
      // debugPrint("ststus..."+responseJson.toString());
      if ((routeArgs['prmocodeType'] == "cashback") || (routeArgs['prmocodeType'] == "Cashback")){
        setState(() {
          _checkpromo = false;
          _displaypromo = true;
          /*_savedamount = "0.0";*/
          _savedamount = routeArgs['amount'].toString();
          /*  if (_isPickup)
                _promoamount = ((cartTotal + deliveryAmt)).toString();
              else*/
          _promoamount = ((cartTotal + deliveryAmt)).toString();
          _promocode = routeArgs['promocode'];

          //walletAmount = double.parse(walletbalance);
          //remainingAmount = double.parse(_promoamount) - double.parse(walletbalance);

          promocashbackmsg = routeArgs['msg'];
          promomessage = routeArgs['prmocodeType'];
        });}
      else {
        setState(() {
          _checkpromo = false;
          _displaypromo = true;
          _savedamount = routeArgs['amount'];
          /* if (_isPickup)
                _promoamount = (cartTotal -
                    double.parse(responseJson['amount'].toString()))
                    .toString();
              else*/
          _promoamount = ((cartTotal + deliveryAmt) -
              double.parse(routeArgs['amount']))
              .toString();

          debugPrint("_promoamount....."+_promoamount.toString() +"  "+routeArgs['amount']+"  "+cartTotal.toString());
          _promocode = routeArgs['promocode'];

          //walletAmount = double.parse(walletbalance);
          //remainingAmount = double.parse(_promoamount) - double.parse(walletbalance);

          promocashbackmsg = routeArgs['msg'];
          promomessage = routeArgs['prmocodeType'];
        });
      }
      setState(() {
        _ischeckbox = !_ischeckbox;
      });
      //Apply loaylty after applied promocde
      if (_isLoayalty &&
          routeArgs['prmocodeType'] != "cashback") {
        await Provider.of<BrandItemsList>(context,listen: false)
            .checkLoyalty(_promoamount)
            .then((_) {
          setState(() {
            _isSwitch = true;
            double totalAmount = 0.0; //Order amount
            !_displaypromo
                ? /*_isPickup
                    ? totalAmount = cartTotal
                    :*/ totalAmount = (cartTotal + deliveryAmt)
                : totalAmount = (double.parse(_promoamount));

            //check user eligible to use Loyalty points or not
            final loyaltyData = Provider.of<BrandItemsList>(context,listen: false);
            if (double.parse(
                loyaltyData.itemsLoyalty[0].minimumOrderAmount.toString()) <=
                totalAmount) {
              _isSwitch = true;
              _isLoyaltyToast = false;
              //Compare user loyalty balance to apply loyalty points
              if (PrefUtils.prefs!.getDouble("loyaltyPointsUser")! <=
                  int.parse(loyaltyPoints)) {
                loyaltyPointsUser = PrefUtils.prefs!.getDouble("loyaltyPointsUser")!;
                loyaltyAmount = ((loyaltyPointsUser * 1) /
                    int.parse(loyaltyData.itemsLoyalty[0].points.toString()));
              } else {
                /*loyaltyPointsUser = prefs.getDouble("loyaltyPointsUser") - int.parse(loyaltyPoints);
                    loyaltyAmount = ((loyaltyPointsUser * 1) / int.parse(loyaltyData.itemsLoyalty[0].points));*/

                loyaltyPointsUser = double.parse(loyaltyPoints);
                loyaltyAmount = ((loyaltyPointsUser * 1) /
                    int.parse(loyaltyData.itemsLoyalty[0].points.toString()));
              }
            } else {
              _isSwitch = true;
              _isLoyaltyToast = true;
            }

            //Consider wallet and loyalty
            if (_isWallet) {
              double totalAmount = 0.0;
              !_displaypromo
                  ? /*_isPickup
                      ? totalAmount = cartTotal
                      :*/ totalAmount = (cartTotal + deliveryAmt)
                  : totalAmount = (double.parse(_promoamount));

              if (int.parse(walletbalance) <=
                  0 /*|| double.parse((cartTotal + deliveryamount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)) > int.parse(walletbalance)*/) {
                _isRemainingAmount = false;
                _ischeckboxshow = false;
                _ischeckbox = false;
                _isRemainingAmount = false;
              } else if (_isSwitch &&
                  !_isLoyaltyToast &&
                  _isLoayalty &&
                  (double.parse(loyaltyPoints) > 0)
                  ? totalAmount <=
                  (int.parse(walletbalance) + loyaltyAmount)
                  : totalAmount <= (int.parse(walletbalance))) {
                _isRemainingAmount = false;
                _groupValue = -1;
                PrefUtils.prefs!.setString("payment_type", "wallet");
                walletAmount = _isSwitch &&
                    !_isLoyaltyToast &&
                    _isLoayalty &&
                    (double.parse(loyaltyPoints) > 0)
                    ? (totalAmount - loyaltyAmount)
                    : totalAmount;
              } else if (_isSwitch &&
                  !_isLoyaltyToast &&
                  _isLoayalty &&
                  (double.parse(loyaltyPoints) > 0)
                  ? totalAmount > (int.parse(walletbalance) + loyaltyAmount)
                  : totalAmount > int.parse(walletbalance)) {
                bool _isOnline = false;
                for (int i = 0; i < paymentData.itemspayment.length; i++) {
                  if (paymentData.itemspayment[i].paymentMode == "1") {
                    _groupValue = i;
                    _isOnline = true;
                    break;
                  }
                }
                if (_isOnline) {
                  _groupValue = -1;
                  _isRemainingAmount = true;
                  walletAmount = double.parse(walletbalance);
                  remainingAmount = _isSwitch &&
                      !_isLoyaltyToast &&
                      _isLoayalty &&
                      (double.parse(loyaltyPoints) > 0)
                      ? totalAmount -
                      double.parse(walletbalance) -
                      loyaltyAmount
                      : (totalAmount - int.parse(walletbalance));
                } else {
                  _isWallet = false;
                  _ischeckbox = false;
                }
                for (int i = 0; i < paymentData.itemspayment.length; i++) {
                  if (paymentData.itemspayment[i].paymentMode == "1") {
                    _groupValue = i;
                    break;
                  }
                }
              }
            } else {
              _ischeckbox = false;
            }

            // Navigator.of(context).pop();
          });
        });
      } else {
        //Navigator.of(context).pop();
      }
    }
    else if (routeArgs['status'] == "error") {
      setState(() {
        _checkpromo = false;
        _displaypromo = false;
        _savedamount = "";
        _promoamount = "";
        _promocode = "";
      });
      //Navigator.of(context).pop();
       Fluttertoast.showToast(msg: routeArgs['msg'], fontSize: MediaQuery.of(context).textScaleFactor *13,);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _isPaymentMethod = false;
    paymentData = Provider.of<BrandItemsList>(context,listen: false);
    final loyaltyData = Provider.of<BrandItemsList>(context,listen: false);

    if (paymentData.itemspayment.length <= 0) {
      _isPaymentMethod = false;
    } else {
      _isPaymentMethod = true;
    }

    if (_ischeckbox && _isRemainingAmount) {
      _isRemainingAmount = true;
    } else {
      _isRemainingAmount = false;
    }

    double deliveryamount = 0;

    if (cartTotal < minorderamount) {
      deliveryamount = deliverycharge;
    }

    List<CartItem> cartItemsData =( VxState.store as GroceStore).CartItemList;
   // final cartItemsData = (VxState.store as GroceStore).CartItemList;//Provider.of<CartItems>(context,listen: false);
    for(int i=0;i<cartItemsData.length;i++)
      if (cartItemsData.length <= 1) {
        debugPrint("if..."+cartItemsData[i].mode.toString());
        if (cartItemsData[i].mode == "1") {
          debugPrint("mode 1....");
          _slots = false;
        }
      }
      else if(cartItemsData.length>=1) {
        _slots = true;
      }

    /* if (!_isLoading) if (_checkmembership
        ? (Calculations.totalmrp < minorderamount)
        : (Calculations.totalmrp < minorderamount)) {
      if (deliverycharge <= 0) {
        deliverychargetext = "FREE";
      } else {
        deliverychargetext =
            "+ " + IConstants.currencyFormat + " " + deliverycharge.toString();
      }
    } else {
      deliverychargetext = "FREE";
    }*/
    if (deliveryAmt <= 0) {
      deliverychargetext = "FREE";
    }
    else {
      deliverychargetext =
      Features.iscurrencyformatalign?
      IConstants.numberFormat == "1"?"+ " + deliveryAmt.toStringAsFixed(0)  + " " + IConstants.currencyFormat:
      "+ " + deliveryAmt.toStringAsFixed(IConstants.decimaldigit) + " " +  IConstants.currencyFormat :
      IConstants.numberFormat == "1"?"+ " + IConstants.currencyFormat + " " + deliveryAmt.toStringAsFixed(0):
          "+ " + IConstants.currencyFormat + " " + deliveryAmt.toStringAsFixed(IConstants.decimaldigit);
    }

    _dialogforPromo(BuildContext context) {

      return showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Container(
                    height: 180.0,
                    child: !_checkpromo
                        ? Column(
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        Text(
                          S .of(context).apply_promocode,//"Apply promo code",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: 120.0,
                          //height: 10.0,
                          child: TextField(
                            controller: myController,
                            onSubmitted: (String newVal) {
                              /*prefs.setString("promovalue", newVal);
                                  setState(() {
                                    _checkpromo = true;
                                    _promocode = newVal;
                                  });*/
                              setState(() {
                                _checkpromo = true;
                              });
                             // checkPromo();
                            },
                          ),
                        ),
                        SizedBox(height: 20.0),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _checkpromo = true;
                              });
                              //checkPromo();
                            },
                            child: Container(
                              width: 120.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(3.0),
                                  border: Border(
                                    top: BorderSide(
                                      width: 1.0,
                                      color: Colors.grey,
                                    ),
                                    bottom: BorderSide(
                                      width: 1.0,
                                      color: Colors.grey,
                                    ),
                                    left: BorderSide(
                                      width: 1.0,
                                      color: Colors.grey,
                                    ),
                                    right: BorderSide(
                                      width: 1.0,
                                      color: Colors.grey,
                                    ),
                                  )),
                              child: Center(
                                  child: Text(
                                    S .of(context).apply,//'Apply',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                          ),
                        ),
                      ],
                    )
                        : Center(
                      child: CircularProgressIndicator(),
                    )),
              );
            });
          });
    }

    _popupForloyaltynote() {
      showDialog(
          // barrierDismissible: false,
          context: context,
          builder: (context) {
              return
              Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0)),
                  child: Container(
                    width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
                    // color: Theme.of(context).primaryColor,
                   // height: 100.0,
                    color: ColorCodes.whiteColor,
                    padding: EdgeInsets.only(top: 25.0, left: 20.0, right: 20.0, bottom: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            S .of(context).loyalty_redemption, //'Loyalty Redemption..'
                            style: TextStyle(color: ColorCodes.blackColor,fontSize: 25.0, fontWeight: FontWeight.bold)
                          //'Product catalogue and offers are location specific'
                        ),
                        Divider(),
                        Text(
                            loyaltyData.itemsLoyalty[0].note!,
                            style: TextStyle(color: ColorCodes.greyColor,fontSize: 15.0, fontWeight: FontWeight.w600)
                          //'Product catalogue and offers are location specific'
                        ),

                        // SizedBox(height: 30,)
                      ],
                    ),
                  ),
                );

          });
    }


    _dialogForloyaltynote() {
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: SafeArea(
              child: Container(
                width: double.infinity,
                color: ColorCodes.whiteColor,
                padding: EdgeInsets.only(top: 25.0, left: 20.0, right: 20.0, bottom: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        S .of(context).loyalty_redemption, //'Loyalty Redemption..'
                        style: TextStyle(color: ColorCodes.blackColor,fontSize: 25.0, fontWeight: FontWeight.bold)
                      //'Product catalogue and offers are location specific'
                    ),
                    Divider(),
                    Text(
                loyaltyData.itemsLoyalty[0].note!,
                        style: TextStyle(color: ColorCodes.greyColor,fontSize: 15.0, fontWeight: FontWeight.w600)
                      //'Product catalogue and offers are location specific'
                    ),

                    // SizedBox(height: 30,)
                  ],
                ),
              ),
            ),
          );
        },
      );
      // showModalBottomSheet(
      //     // barrierDismissible: false,
      //     context: context,
      //     builder: (context) {
      //         return
      //         Dialog(
      //             shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.circular(3.0)),
      //             child: Container(
      //               width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.20:MediaQuery.of(context).size.width,
      //               // color: Theme.of(context).primaryColor,
      //               height: 100.0,
      //               child: Center(
      //                 child: Text(
      //                     loyaltyData.itemsLoyalty[0].note//'Placing order...'
      //                 ),
      //               ),
      //               //   ],
      //               // )
      //             ),
      //           );
      //
      //     });
    }


    _dialogforOrdering(BuildContext context) {
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return AbsorbPointer(
                child: WillPopScope(
                  onWillPop: (){
                    return Future.value(false);
                  },
                  child: Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0)),
                    child: Container(
                        width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.20:MediaQuery.of(context).size.width,
                        // color: Theme.of(context).primaryColor,
                        height: 100.0,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(),
                            SizedBox(
                              width: 40.0,
                            ),
                            Text(
                              S .of(context).placing_order,//'Placing order...'
                            ),
                          ],
                        )),
                  ),
                ),
              );
            });
          });
    }

    _buildBottomNavigationBar() {
      return  _isLoading
          ? Shimmer.fromColors(
          baseColor: ColorCodes.shimmerColor,
          highlightColor: ColorCodes.shimmerColor,
          child: new Container(
            margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
            height: 80.0,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
          ))
          :
      BottomNaviagation(
        itemCount: CartCalculations.itemCount.toString() + " " + S .of(context).items,
        title: S .current.proceed_pay, //'PROCEED TO PAY',
        total: !_displaypromo ? _isPickup
        ?
        _isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0)
            ?
        (cartTotal +   deliveryAmt - loyaltyAmount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) :
        (cartTotal + deliveryAmt).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) :
        _isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0) ?
        (cartTotal + deliveryAmt - loyaltyAmount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) :
        (cartTotal + deliveryAmt).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) :
        (promomessage.toLowerCase() == 'cashback') ?
        _isSwitch && !_isLoyaltyToast &&   _isLoayalty && (double.parse(loyaltyPoints) > 0) ?
        (cartTotal + deliveryAmt - loyaltyAmount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) :
        (cartTotal + deliveryAmt).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) :
        _isSwitch &&  !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0) ?
        (double.parse(_promoamount) - loyaltyAmount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) :
        (double.parse(_promoamount)).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
        onPressed: (){
          setState(() {
            if(!_isPaymentMethod) {
              Fluttertoast.showToast(
                msg: S .of(context).currently_no_payment,//"currently there are no payment methods available",
                fontSize: MediaQuery.of(context).textScaleFactor *13,);
            }
            else {
              if (!_ischeckbox && _groupValue == -1) {
                Fluttertoast.showToast(
                  msg: S .of(context).please_select_paymentmenthods,//"Please select a payment method!!!",
                  fontSize: MediaQuery.of(context).textScaleFactor *13,);
              } else {
                if (_ischeckbox && _isRemainingAmount) {
                  PrefUtils.prefs!.setString("payment_type", "paytm");
                  //prefs.setString("amount", walletbalance);
                  PrefUtils.prefs!.setString(
                      "amount", walletAmount.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit));
                  PrefUtils.prefs!.setString("wallet_type", "0");
                } else if (_ischeckbox) {
                  PrefUtils.prefs!.setString("payment_type", "wallet");
                  //prefs.setString("amount", (cartTotal + deliveryAmt).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit));
                  PrefUtils.prefs!.setString(
                      "amount", walletAmount.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit));
                  PrefUtils.prefs!.setString("wallet_type", "0");
                }
                _dialogforOrdering(context);
               /* if(_slots && Features.isSplit){
                  OrderfoodSplit();
                }else if(_isPickup){
                  Orderfood();
                }else{
                  Orderfood();
                }*/
                if(_slots){
                  if(_isPickup){
                    Orderfood();
                  }else {
                    if(Features.isSplit){
                      OrderfoodSplit();
                    }else{
                      Orderfood();
                    }
                  }
                }else{
                  Orderfood();
                }
                //(_slots ) ? _isPickup ? Orderfood(): Features.isSplit ? OrderfoodSplit() : Orderfood() :OrderfoodSplit();
                // if(Features.isOffers) {
                //   if (offersData.offers.length > 0) {
                //     _addToCart();
                //   } else {
                //     /*Orderfood();*/
                //    (_slots ) ? _isPickup ? Orderfood(): Features.isSplit ? OrderfoodSplit() : Orderfood() :OrderfoodSplit();
                //   }
                // } else {
                //  (_slots ) ? _isPickup ? Orderfood(): Features.isSplit ? OrderfoodSplit() : Orderfood() :OrderfoodSplit();
                // }
                /*if(prefs.containsKey("orderId")) {
                            _cancelOrder().then((value) async {
                              Orderfood();
                            });
                          } else {
                            Orderfood();
                          }*/
              }
            }
          });
        },
      );
      // return SingleChildScrollView(
      //   child: Container(
      //     width: MediaQuery.of(context).size.width,
      //     height: 50.0,
      //     child: Row(
      //       children: <Widget>[
      //         Container (
      //             color: Theme.of(context).primaryColor,
      //             height: 50,
      //             width: MediaQuery.of(context).size.width * 40 / 100,
      //             child: Column(
      //               children: <Widget>[
      //                 SizedBox(
      //                   height: 15,
      //                 ),
      //                 Center(
      //                   child: !_displaypromo
      //                       ? _isPickup
      //                       ? _isSwitch &&
      //                       !_isLoyaltyToast &&
      //                       _isLoayalty &&
      //                       (double.parse(loyaltyPoints) > 0)
      //                       ? Text(
      //                     S .of(context).total//"Total: "
      //                         + IConstants.currencyFormat +
      //                         " " +
      //                         (cartTotal +
      //                             deliveryAmt -
      //                             loyaltyAmount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
      //                             // .roundToDouble()
      //                             // .toString(),
      //                     style: TextStyle(
      //                         color: Colors.white,
      //                         fontWeight: FontWeight.bold),
      //                   )
      //                       : Text(
      //                     S .of(context).total//"Total: "
      //                         + IConstants.currencyFormat +
      //                         " " +
      //                         (cartTotal + deliveryAmt).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
      //                     style: TextStyle(
      //                         color: Colors.white,
      //                         fontWeight: FontWeight.bold),
      //                   )
      //                       : _isSwitch &&
      //                       !_isLoyaltyToast &&
      //                       _isLoayalty &&
      //                       (double.parse(loyaltyPoints) > 0)
      //                       ? Text(
      //                     S .of(context).total//"Total: "
      //                         + IConstants.currencyFormat +
      //                         " " +
      //                         (cartTotal +
      //                             deliveryAmt -
      //                             loyaltyAmount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
      //                             // .roundToDouble()
      //                             // .toString(),
      //                     style: TextStyle(
      //                         color: Colors.white,
      //                         fontWeight: FontWeight.bold),
      //                   )
      //                       : Text(
      //                     S .of(context).total//"Total: "
      //                         + IConstants.currencyFormat +
      //                         " " +
      //                         (cartTotal + deliveryAmt)
      //                             .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
      //                     style: TextStyle(
      //                         color: Colors.white,
      //                         fontWeight: FontWeight.bold),
      //                   )
      //                       : Row(children: [
      //                     SizedBox(
      //                       width: 10,
      //                     ),
      //                     if (promomessage.toLowerCase() == 'cashback')
      //                       _isSwitch &&
      //                           !_isLoyaltyToast &&
      //                           _isLoayalty &&
      //                           (double.parse(loyaltyPoints) > 0)
      //                           ? Text(
      //                         S .of(context).total//"Total: "
      //                             + IConstants.currencyFormat +
      //                             " " +
      //                             (cartTotal +
      //                                 deliveryAmt -
      //                                 loyaltyAmount)
      //                             .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
      //                                 // .roundToDouble()
      //                                 // .toString(),
      //                         style: TextStyle(
      //                             color: Colors.white,
      //                             fontWeight: FontWeight.bold),
      //                         textAlign: TextAlign.center,
      //                       )
      //                           : Text(
      //                         S .of(context).total//"Total: "
      //                             + IConstants.currencyFormat +
      //                             " " +
      //                             (cartTotal + deliveryAmt)
      //                                 .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
      //                         style: TextStyle(
      //                             color: Colors.white,
      //                             fontWeight: FontWeight.bold),
      //                         textAlign: TextAlign.center,
      //                       )
      //                     else
      //                       _isSwitch &&
      //                           !_isLoyaltyToast &&
      //                           _isLoayalty &&
      //                           (double.parse(loyaltyPoints) > 0)
      //                           ? Text(
      //                           S .of(context).total//"Total: "
      //                               + IConstants.currencyFormat +
      //                               " " +
      //                               (double.parse(_promoamount) -
      //                                   loyaltyAmount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
      //                                   // .roundToDouble()
      //                                   // .toString(),
      //                           style: TextStyle(
      //                               color: Colors.white,
      //                               fontWeight: FontWeight.bold),
      //                           textAlign: TextAlign.center)
      //                           : Text(
      //                           S .of(context).total//"Total: "
      //                               + IConstants.currencyFormat +
      //                               " " +
      //                               (double.parse(_promoamount))
      //                                   .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
      //                           style: TextStyle(
      //                               color: Colors.white,
      //                               fontWeight: FontWeight.bold),
      //                           textAlign: TextAlign.center)
      //                   ]),
      //                 ),
      //               ],
      //             )),
      //         !_isPaymentMethod ? GestureDetector (
      //           onTap: () {
      //             Fluttertoast.showToast(
      //                 msg:  S .of(context).currently_no_payment,//"currently there are no payment methods available",
      //               fontSize: MediaQuery.of(context).textScaleFactor *13,);
      //           },
      //           child: Container(
      //             color: Colors.grey,
      //             width: MediaQuery.of(context).size.width * 60 / 100,
      //             height: 50,
      //             child: Column(
      //               children: <Widget>[
      //                 SizedBox(
      //                   height: 17,
      //                 ),
      //                 Center(
      //                   child: Text(
      //                       S .of(context).proceed_pay,//'PROCEED TO PAY',
      //                     style: TextStyle(
      //                         color: Colors.white,
      //                         fontWeight: FontWeight.bold),
      //                   ),
      //                 )
      //               ],
      //             ),
      //
      //           ),
      //         )
      //             : GestureDetector (
      //           onTap: () {
      //             if (!_ischeckbox && _groupValue == -1) {
      //               Fluttertoast.showToast(
      //                   msg: S .of(context).please_select_paymentmenthods,//"Please select a payment method!!!",
      //                 fontSize: MediaQuery.of(context).textScaleFactor *13,);
      //             } else {
      //               if (_ischeckbox && _isRemainingAmount) {
      //                 PrefUtils.prefs!.setString("payment_type", "paytm");
      //                 //prefs.setString("amount", walletbalance);
      //                 PrefUtils.prefs!.setString(
      //                     "amount", walletAmount.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit));
      //                 PrefUtils.prefs!.setString("wallet_type", "0");
      //               } else if (_ischeckbox) {
      //                 PrefUtils.prefs!.setString("payment_type", "wallet");
      //                 //prefs.setString("amount", (cartTotal + deliveryAmt).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit));
      //                 PrefUtils.prefs!.setString(
      //                     "amount", walletAmount.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit));
      //                 PrefUtils.prefs!.setString("wallet_type", "0");
      //               }
      //               _dialogforOrdering(context);
      //               if(Features.isOffers) {
      //                 if (offersData.offers.length > 0) {
      //                   _addToCart();
      //                 } else {
      //                   /*Orderfood();*/
      //                   (_slots)?OrderfoodSplit(): Orderfood();
      //                 }
      //               } else {
      //                 (_slots)?OrderfoodSplit(): Orderfood();
      //               }
      //               /*if(prefs.containsKey("orderId")) {
      //                       _cancelOrder().then((value) async {
      //                         Orderfood();
      //                       });
      //                     } else {
      //                       Orderfood();
      //                     }*/
      //             }
      //           },
      //           child: Container(
      //             color: Theme.of(context).primaryColor,
      //             width: MediaQuery.of(context).size.width * 60 / 100,
      //             height: 50,
      //             child: Column(
      //               children: <Widget>[
      //                 SizedBox(
      //                   height: 17,
      //                 ),
      //                 Center(
      //                   child: Text(
      //                       S .of(context).proceed_pay,//'PROCEED TO PAY',
      //                     style: TextStyle(
      //                         color: Colors.white,
      //                         fontWeight: FontWeight.bold),
      //                   ),
      //                 )
      //               ],
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // );
    }

    gradientappbarmobile() {
      return AppBar(
        brightness: Brightness.dark,
        toolbarHeight: 60.0,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: ColorCodes.iconColor),
            onPressed: () {

            //  Navigator.of(context).pop();
              (Features.ismultivendor)?
              Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":""}):
              widget.fromScreen == "cartscreen"?
              Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":""}):
                  widget.fromScreen == "pickupscreen" ?
                  Navigation(context, name: Routename.PickupScreen, navigatore: NavigatoreTyp.Push) :
              Navigation(context, name:Routename.ConfirmOrder,navigatore: NavigatoreTyp.Push,
                  parms:{"prev": "payment"});

            }
        ),
        title: Text(
          (IConstants.isEnterprise && Features.ismultivendor)?IConstants.storename:S .of(context).payment_option,//'Payment Options',
        style: TextStyle(color: ColorCodes.iconColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        titleSpacing: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    ColorCodes.appbarColor,
                    ColorCodes.appbarColor2
                  ])),
        ),
      );
    }
    PreferredSizeWidget gradientappbarlite() {
      return NewGradientAppBar(
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              ColorCodes.appbarColor,
              ColorCodes.appbarColor2
            ]),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: ColorCodes.iconColor),
            onPressed: () async{
              /* Navigator.pushNamedAndRemoveUntil(
                    context, CartScreen.routeName, (route) => false);*/
              Navigator.of(context).pop();

              return Future.value(false);
            }
        ),
        elevation: (IConstants.isEnterprise)?0:1,
        title: Text(
          (IConstants.isEnterprise && Features.ismultivendor)?IConstants.storename:S .of(context).payment_option,//"Payment Options",
          style: TextStyle(color: ColorCodes.iconColor,
          ),
        ),
        /* actions: [
            Container(
              height: 25,
              width: 25,
              margin: EdgeInsets.only(top: 15, bottom: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(
                    SearchitemScreen.routeName,
                  );
                },
                child: Icon(
                  Icons.search,
                  size: 18,
                  color: Color(0xFF124475),
                ),
              ),
            ),
            SizedBox(width: 10),*/
        // Container(
        //   height: 35,
        //   width: 35,
        //   margin: EdgeInsets.only(top: 10, bottom: 10),
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //     borderRadius: BorderRadius.circular(100),
        //   ),
        //   child: GestureDetector(
        //     behavior: HitTestBehavior.translucent,
        //     onTap: () {
        //       if (Platform.isIOS) {
        //         Share.share('Download ' +
        //             IConstants.APP_NAME +
        //             ' from App Store https://apps.apple.com/us/app/id1512751692');
        //       } else {
        //         Share.share('Download ' +
        //             IConstants.APP_NAME +
        //             ' from Google Play Store https://play.google.com/store/apps/details?id=com.shiva_sai_mart.store');
        //       }
        //     },
        //     child: Icon(
        //       Icons.share_outlined,
        //       color: Color(0xFF124475),
        //     ),
        //   ),
        // ),
        // SizedBox(width: 10),
        // Container(
        //   margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
        //   child: ValueListenableBuilder(
        //     valueListenable: Hive.box<Product>(productBoxName).listenable(),
        //     builder: (context, Box<Product> box, index) {
        //       if (box.values.isEmpty)
        //         return Container(
        //           width: 35,
        //           height: 35,
        //           decoration: BoxDecoration(
        //               borderRadius: BorderRadius.circular(100),
        //               color: Theme.of(context).buttonColor),
        //           child: GestureDetector(
        //             onTap: () {
        //               Navigator.of(context).pushNamed(CartScreen.routeName);
        //             },
        //             child: Icon(
        //               Icons.shopping_cart_outlined,
        //               size: 20,
        //               color: Theme.of(context).primaryColor,
        //             ),
        //           ),
        //         );
        //       int cartCount = 0;
        //       for (int i = 0;
        //           i < Hive.box<Product>(productBoxName).length;
        //           i++) {
        //         cartCount = cartCount +
        //             Hive.box<Product>(productBoxName)
        //                 .values
        //                 .elementAt(i)
        //                 .itemQty;
        //       }
        //       return Container(
        //         //margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
        //         child: Consumer<Calculations>(
        //           builder: (_, cart, ch) => Badge(
        //             child: ch,
        //             color: Colors.green,
        //             value: cartCount.toString(),
        //           ),
        //           child: Container(
        //             width: 35,
        //             height: 35,
        //             //margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
        //             decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(100),
        //                 color: Theme.of(context).buttonColor),
        //             child: GestureDetector(
        //               onTap: () {
        //                 Navigator.of(context).pushNamed(CartScreen.routeName);
        //               },
        //               child: Icon(
        //                 Icons.shopping_cart_outlined,
        //                 color: Theme.of(context).primaryColor,
        //               ),
        //             ),
        //           ),
        //         ),
        //       );
        //     },
        //   ),
        // ),
        // SizedBox(width: 10),
        // ],
      );
    }
    // Widget _offers() {
    //   double deviceWidth = MediaQuery.of(context).size.width;
    //   int widgetsInRow = 3;
    //   double aspectRatio = (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 125;
    //
    //   if (deviceWidth > 1200) {
    //     widgetsInRow = 5;
    //     aspectRatio =
    //         (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 295;
    //   } else if (deviceWidth > 768) {
    //     widgetsInRow = 4;
    //     aspectRatio =
    //         (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 195;
    //   }
    //
    //   return Padding(
    //     padding: EdgeInsets.only(
    //         top: 8.0, left: 20.0, right: 20.0, bottom: 8.0),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Text(
    //           S .of(context).thank_you_shopping,//"Thank you for shopping with us. Your order qualifies for a gift",
    //           style: TextStyle(
    //               color: ColorCodes.blackColor,
    //               fontWeight: FontWeight.bold),
    //         ),
    //         SizedBox(
    //           height: 170,
    //           child: new ListView.builder(
    //             shrinkWrap: true,
    //             scrollDirection: Axis.horizontal,
    //             itemCount: offersData.offers.length,
    //             itemBuilder: (_, i) => GestureDetector(
    //               onTap: () {
    //                 for(int j = 0; j < offersData.offers.length; j++) {
    //                   setState(() {
    //                     if(i == j) {
    //                       offersData.offers[i].border = ColorCodes.mediumBlueColor;
    //                     } else {
    //                       offersData.offers[j].border = ColorCodes.lightBlueColor;
    //                     }
    //                     offersData = Provider.of<BrandItemsList>(context, listen: false);
    //                     _selectedOffer = i;
    //                   });
    //                 }
    //               },
    //               child: Container(
    //                 width: 150.0,
    //                 padding: EdgeInsets.all(10.0),
    //                 margin: EdgeInsets.only(top: 5.0, right: 10.0, bottom: 5.0),
    //                 decoration: new BoxDecoration(
    //                   //color: Colors.white,
    //                   /*image: new DecorationImage(
    //                     image: new NetworkImage(imageUrl),
    //                   ),*/
    //                   borderRadius: new BorderRadius.all(new Radius.circular(2.0)),
    //                   border: new Border.all(
    //                     color: offersData.offers[i].border,
    //                     width: 2.0,
    //                   ),
    //                 ),
    //
    //                 child: Column(
    //                   children: [
    //                     Text(offersData.offers[i].offerTitle),
    //                     CachedNetworkImage(
    //                       imageUrl: offersData.offers[i].imageUrl,
    //                       placeholder: (context, url) =>
    //                           Image.asset(
    //                             Images.defaultProductImg,
    //                             width: ResponsiveLayout.isSmallScreen(context) ? 75 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
    //                             height: ResponsiveLayout.isSmallScreen(context) ? 75 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
    //                           ),
    //                       errorWidget: (context, url, error) => Image.asset(
    //                         Images.defaultProductImg,
    //                         width: ResponsiveLayout.isSmallScreen(context) ? 75 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
    //                         height: ResponsiveLayout.isSmallScreen(context) ? 75 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
    //                       ),
    //                       width: ResponsiveLayout.isSmallScreen(context) ? 75 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
    //                       height: ResponsiveLayout.isSmallScreen(context) ? 75 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
    //                       fit: BoxFit.fill,
    //                     ),
    //                     Flexible(
    //                       child: Text(offersData.offers[i].title + "-" + offersData.offers[i].varname,
    //                           overflow: TextOverflow.ellipsis,
    //                           maxLines: 2,
    //                           style: TextStyle(
    //                             fontSize: 13,
    //                             fontWeight: FontWeight.bold,
    //                           )),
    //                     ),
    //                     if(offersData.offers[i].discountDisplay)
    //                       RichText(
    //                         text: new TextSpan(
    //                           style: new TextStyle(
    //                             fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 15 : 16,
    //                             color: Colors.black,
    //                           ),
    //                           children: <TextSpan>[
    //                             new TextSpan(
    //                                 text: IConstants.currencyFormat + offersData.offers[i].varprice + ' ',
    //                                 style: TextStyle(
    //                                   fontWeight: FontWeight.bold,
    //                                   fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,)),
    //
    //                             new TextSpan(
    //                               text: IConstants.currencyFormat + offersData.offers[i].varmrp,
    //                               style: TextStyle(
    //                                 decoration: TextDecoration.lineThrough,
    //                                 fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,),),
    //                           ],
    //                         ),
    //                       )
    //                     else
    //                       RichText(
    //                         text: new TextSpan(
    //                           style: new TextStyle(
    //                             fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 15 : 16,
    //                             color: Colors.black,
    //                           ),
    //                           children: <TextSpan>[
    //                             new TextSpan(
    //                                 text: IConstants.currencyFormat + offersData.offers[i].varmrp,
    //                                 style: TextStyle(
    //                                   fontWeight: FontWeight.bold,
    //                                   fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,)),
    //                           ],
    //                         ),
    //                       )
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // }
    Expanded? _bodyWeb() {

      double amountPayable = 0.0;

      Widget promocodeMethod() {
        if( deliverychargetext=="FREE"){

          if ((CartCalculations.totalmrp - (amountPayable-deliveryAmt)) > 0) {
            double savings=(CartCalculations.totalmrp - (amountPayable-deliveryAmt));
            return (CartCalculations.totalmrp - amountPayable) > 0 ?Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                DottedBorder(
                  padding: EdgeInsets.zero,
                  color: ColorCodes.greenColor,
                  //strokeWidth: 1,
                  dashPattern: [3.0],
                  child: Container(
                    padding: EdgeInsets.only(left: 6.0, right: 6.0),
                    height: 30.0,
                    //color: ColorCodes.lightBlueColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S .of(context).your_savings,//"Your savings",
                          style: TextStyle(
                              fontSize: 13.0,
                              color: ColorCodes.greenColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          Features.iscurrencyformatalign?
                          (CartCalculations.totalmrp - amountPayable).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + " " + IConstants.currencyFormat :
                          IConstants.currencyFormat +
                              " " +
                              (CartCalculations.totalmrp - amountPayable).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                          style: TextStyle(
                              fontSize: 13.0,
                              color: ColorCodes.greenColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                // Divider(color: ColorCodes.blackColor),
              ],
            ):
            SizedBox.shrink();
          } else {
            return Container();
          }
        }
        else{
          if ((CartCalculations.totalmrp - (amountPayable-deliveryAmt)) > 0) {
            double savings=(CartCalculations.totalmrp - (amountPayable-deliveryAmt));
            return Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                DottedBorder(
                  padding: EdgeInsets.zero,
                  color: ColorCodes.greenColor,
                  strokeWidth: 1,
                  dashPattern: [3.0],
                  child: Container(
                    padding: EdgeInsets.only(left: 6.0, right: 6.0),
                    height: 30.0,
                    //color: ColorCodes.lightBlueColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S .of(context).your_savings,//"Your savings",
                          style: TextStyle(
                              fontSize: 13.0,
                              color: ColorCodes.greenColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          Features.iscurrencyformatalign?
                         (CartCalculations.totalmrp - (amountPayable-deliveryAmt)).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + " " + IConstants.currencyFormat :
                          IConstants.currencyFormat +
                              " " + (CartCalculations.totalmrp - (amountPayable-deliveryAmt)).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                          style: TextStyle(
                              fontSize: 13.0,
                              color: ColorCodes.greenColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                //Divider(color: ColorCodes.blackColor),
              ],
            );
          } else {
            return Container();
          }}
      }

      Widget paymentDetails() {
        return Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.40,
              margin: EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                color: ColorCodes.whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              padding: EdgeInsets.only(
                  top: 8.0, left: 10.0, right: 10.0, bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          S .of(context).amount_payable,//"Amount Payable",
                          style: TextStyle(
                              fontSize: 18.0,
                              color: ColorCodes.greenColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          S .of(context).incl_tax,//"(Incl. of all taxes)",
                          style: TextStyle(
                              fontSize: 12.0, color: ColorCodes.greenColor),
                        ),
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S .of(context).your_cart_value,//"Your cart value",
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color:
                                  ColorCodes.greyColor),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            // if (!_isPickup)
                            Text(
                              S .of(context).payment_delivery_charge,//"Delivery charges",
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color:
                                  ColorCodes.greyColor),
                            ),
                            // Row(
                            //   children: [
                            //     Text(
                            //       S .of(context).payment_delivery_charge,//"Delivery charges",
                            //       style: TextStyle(
                            //           fontSize: 14.0,
                            //           fontWeight: FontWeight.bold,
                            //           color:
                            //           ColorCodes.greyColor),
                            //     ),
                            //
                            //     (deliverychargetext != "FREE") ?
                            //     SimpleTooltip(
                            //       maxHeight: MediaQuery.of(context).size.width * 24.7/100,
                            //       borderColor: Theme.of(context).primaryColor,
                            //       tooltipTap: ()
                            //       {
                            //         setState(() {
                            //           _showDeliveryinfo = !_showDeliveryinfo;
                            //         }
                            //         );
                            //       },
                            //       hideOnTooltipTap: true,
                            //       show:_showDeliveryinfo ,
                            //       tooltipDirection: TooltipDirection.down,
                            //       ballonPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                            //       child:
                            //       IconButton(
                            //         padding: EdgeInsets.all(0),
                            //         icon:Icon(Icons.help_outline,size: 15,),
                            //         onPressed: (){
                            //           setState(() {
                            //             _showDeliveryinfo = !_showDeliveryinfo;
                            //           }
                            //           );
                            //         },
                            //       ),
                            //       content: Container(child:Column(children:[
                            //         _checkmembership ? Text(S .of(context).Shop//'Shop '
                            //             +IConstants.currencyFormat+(minorderamount - Calculations.totalMember).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)+ S .of(context).more_to_get,//' more to get free delivery',
                            //           style: TextStyle(
                            //               fontWeight: FontWeight.w500,
                            //               color:Colors.black,
                            //               fontStyle: FontStyle.normal,
                            //               fontSize: 12,
                            //               decoration: TextDecoration.none
                            //           ),
                            //         )
                            //             :
                            //         Text(S .of(context).Shop//'Shop '
                            //             +IConstants.currencyFormat+(minorderamount - cartTotal).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)+ S .of(context).more_to_get,//' more to get free delivery',
                            //           style: TextStyle(
                            //               fontWeight: FontWeight.w500,
                            //               color:Colors.black,
                            //               fontStyle: FontStyle.normal,
                            //               fontSize: 12,
                            //               decoration: TextDecoration.none
                            //           ),
                            //         ),
                            //         SizedBox(height: 3,),
                            //         GestureDetector(onTap:()
                            //         {
                            //           /*Navigator.of(context).pushNamed(
                            //                 CategoryScreen.routeName,
                            //               );*/
                            //           /*Navigator.of(context).pushNamedAndRemoveUntil(
                            //               '/home-screen', (Route<dynamic> route) => false);*/
                            //           Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
                            //
                            //         },
                            //             child: Center(
                            //               child:Text(S .of(context).Shop_more,//'Shop more',
                            //                 style: TextStyle(color:Color(0xffff3333),fontSize: 12,fontWeight: FontWeight.w500,decoration: TextDecoration.none),),))])),
                            //       arrowTipDistance: 2,
                            //       minimumOutSidePadding: 10,
                            //       arrowLength: 8,
                            //     )
                            //         :
                            //     SimpleTooltip(
                            //
                            //       ballonPadding: EdgeInsets.symmetric(vertical: 3,horizontal: 5),
                            //       tooltipTap: (){
                            //         setState(() {
                            //           _showDeliveryinfo = !_showDeliveryinfo;
                            //         });
                            //       },
                            //       //animationDuration: Duration(seconds: 3),
                            //       hideOnTooltipTap: true,
                            //       show:_showDeliveryinfo ,
                            //       arrowTipDistance: 0,
                            //       arrowLength: 5,
                            //       tooltipDirection: TooltipDirection.down,
                            //       child: IconButton(
                            //
                            //         padding: EdgeInsets.all(0),
                            //         icon:Icon(
                            //           Icons.help_outline,
                            //           size: 15,
                            //
                            //         ),onPressed: (){
                            //         setState(() {
                            //           _showDeliveryinfo = !_showDeliveryinfo;
                            //         });
                            //       },),
                            //       content: Text(
                            //         S .of(context).Yay,
                            //         //'Yay!Free Delivery',
                            //         style: TextStyle(
                            //           fontSize: 12,
                            //           color: Colors.black54,
                            //           decoration: TextDecoration.none,
                            //         ),
                            //       ),
                            //       borderColor: Theme.of(context).primaryColor,
                            //     )
                            //   ],
                            // ),
                            //  if (!_isPickup)
                            SizedBox(
                              height: 10.0,
                            ),
                            if(!_checkmembership)
                            if ((CartCalculations.totalprice)  > 0)

                              Text(
                                S .of(context).discount_applied,//"Discount applied:",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color:
                                    ColorCodes.greyColor),
                              ),
                            /*if ((Calculations.totalmrp - cartTotal) > 0)
                              SizedBox(
                                height: 10.0,
                              ),*/
                            if(!_checkmembership)
                            if ((CartCalculations.totalprice) > 0)
                              SizedBox(
                                height: 10.0,
                              ),
                            if(_checkmembership)
                              if((CartCalculations.totalMembersPrice ) > 0)
                                Text(
                                  S .of(context).membership_savings,//"Membership savings:",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color:
                                      ColorCodes.greyColor),
                                ),
                            if(_checkmembership)
                              if((CartCalculations.totalMembersPrice ) > 0)
                                SizedBox(
                                  height: 10.0,
                                ),


                            if (_displaypromo &&
                                promomessage.toString().toLowerCase() !=
                                    'cashback')
                              new RichText(
                                text: new TextSpan(
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color:
                                      ColorCodes.greyColor),
                                  children: <TextSpan>[
                                    new TextSpan(text: S .of(context).promo,//'Promo ('
                                    ),
                                    new TextSpan(
                                      text: _promocode,
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          color:
                                          ColorCodes.greyColor),
                                    ),
                                    new TextSpan(text: ')'),
                                  ],
                                ),
                              ),
                            if (_displaypromo &&
                                promomessage.toString().toLowerCase() !=
                                    'cashback')
                              SizedBox(
                                height: 10.0,
                              ),
                            if (!_isLoyaltyToast &&
                                _isSwitch &&
                                _isLoayalty &&
                                (double.parse(loyaltyPoints) > 0))
                              Text(
                                S .of(context).you_saved + (S .of(context).coins) + ")",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color:
                                    ColorCodes.greyColor),
                              ),
                            if (!_isLoyaltyToast &&
                                _isSwitch &&
                                _isLoayalty &&
                                (double.parse(loyaltyPoints) > 0))
                              SizedBox(
                                height: 10.0,
                              ),
                            Text(
                              S .of(context).amount_payable,//"Amount payable:",
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color:
                                  ColorCodes.primaryColor),
                            ),
                          ],
                        ),
                        /*Container(
                            child: VerticalDivider(
                                color: ColorCodes.greyColor)),*/
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              Features.iscurrencyformatalign?
                              CartCalculations.totalmrp.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + " " + IConstants.currencyFormat :
                              IConstants.currencyFormat +
                                  " " +
                                  CartCalculations.totalmrp.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color:
                                  ColorCodes.greyColor),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            //if (!_isPickup)
                            Text(
                              deliverychargetext!,
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color:
                                  ColorCodes.greyColor),
                            ),
                            // if (!_isPickup)
                            SizedBox(
                              height: 10.0,
                            ),
                            if(!_checkmembership)
                            if ((CartCalculations.totalprice) > 0)
                              Text(
                                "- " +
                                    (CartCalculations.totalmrp - cartTotal)
                                        .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color:
                                    ColorCodes.greyColor),
                              ),
                            /*if ((Calculations.totalmrp - cartTotal) > 0)
                              SizedBox(
                                height: 10.0,
                              ),*/
                            if(!_checkmembership)
                            if ((CartCalculations.totalprice) > 0)
                              SizedBox(
                                height: 10.0,
                              ),
                            if(_checkmembership)
                              if((CartCalculations.totalMembersPrice ) > 0)
                                Text(
                                  "-"+ (CartCalculations.totalMembersPrice)
                                      .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color:
                                      ColorCodes.greyColor),
                                ),

                            if(_checkmembership)
                              if((CartCalculations.totalMembersPrice ) > 0)
                                SizedBox(
                                  height: 10.0,
                                ),


                            if (_displaypromo &&
                                promomessage.toString().toLowerCase() !=
                                    'cashback')
                              Text(
                                Features.iscurrencyformatalign?
                                "- " +
                                    double.parse(_savedamount)
                                        .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) +" " + IConstants.currencyFormat :
                                "- " +
                                    IConstants.currencyFormat +
                                    " " +
                                    double.parse(_savedamount)
                                        .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color:
                                    ColorCodes.primaryColor),
                              ),
                            if (_displaypromo &&
                                promomessage.toString().toLowerCase() !=
                                    'cashback')
                              SizedBox(
                                height: 10.0,
                              ),
                            if (!_isLoyaltyToast &&
                                _isSwitch &&
                                _isLoayalty &&
                                (double.parse(loyaltyPoints) > 0))
                              Text(
                                Features.iscurrencyformatalign?
                                "- " +
                                    loyaltyAmount.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)+
                                    " " + IConstants.currencyFormat
                                    :
                                "- " +
                                    IConstants.currencyFormat +
                                    " " +
                                    loyaltyAmount.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color:
                                    ColorCodes.greyColor),
                              ),
                            if (!_isLoyaltyToast &&
                                _isSwitch &&
                                _isLoayalty &&
                                (double.parse(loyaltyPoints) > 0))
                              SizedBox(
                                height: 10.0,
                              ),
                            Text(
                              Features.iscurrencyformatalign?
                              amountPayable.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) +
                                  " " + IConstants.currencyFormat :
                              IConstants.currencyFormat +
                                  " " +
                                  amountPayable.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color:
                                  ColorCodes.primaryColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Divider(
                    color: ColorCodes.greyColor,
                    thickness: 0.8,
                  ),

                  // promocodeMethod() goes here
                  promocodeMethod(),
                ],
              ),
            ),
            /*if(Features.isOffers)
              if(offersData.offers.length > 0)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: _offers(),
                ),*/


            /* MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _dialogforPromo(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.40,
                  color: ColorCodes.whiteColor,
                  padding:
                  EdgeInsets.only(left: 10.0, right: 10.0, bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Apply Promo Code",
                        style: TextStyle(
                            color: ColorCodes.blackColor,
                            fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: ColorCodes.greyColor,
                      ),
                    ],
                  ),
                ),
              ),
            ):SizedBox.shrink(),*/
            (productBox.length == 1 && productBox[0].mode == 1)
                ? SizedBox.shrink()
                : Divider(
              color: ColorCodes.lightGreyColor,
              thickness: 2.5,
              indent: 450,
              endIndent: 450,
            ),
            !_isPaymentMethod
                ? MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Fluttertoast.showToast(
                    msg:
                    S .of(context).currently_no_payment,//"currently there are no payment methods available",
                    fontSize: MediaQuery.of(context).textScaleFactor *13,);
                },
                child: Container(
                  color: Theme.of(context).primaryColor,
                  width: MediaQuery.of(context).size.width * 0.40,
                  height: 50,
                  child: Center(
                    child: Text(
                      S .of(context).proceed_pay,//'PROCEED TO PAY',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            )
                : MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  if (!_ischeckbox && _groupValue == -1) {
                    Fluttertoast.showToast(
                      msg: S .of(context).please_select_paymentmenthods,//"Please select a payment method!!!",
                      fontSize: MediaQuery.of(context).textScaleFactor *13,);
                  } else {
                    if (_ischeckbox && _isRemainingAmount) {
                      PrefUtils.prefs!.setString("payment_type", "paytm");
                      //PrefUtils.prefs!.setString("amount", walletbalance);
                      PrefUtils.prefs!.setString(
                          "amount", walletAmount.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit));
                      PrefUtils.prefs!.setString("wallet_type", "0");
                    } else if (_ischeckbox) {
                      PrefUtils.prefs!.setString("payment_type", "wallet");
                      //PrefUtils.prefs!.setString("amount", (cartTotal + deliveryAmt).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit));
                      PrefUtils.prefs!.setString(
                          "amount", walletAmount.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit));
                      PrefUtils.prefs!.setString("wallet_type", "0");
                    }
                    _dialogforOrdering(context);
                    if(_slots){
                      if(_isPickup){
                        Orderfood();
                      }else {
                        if(Features.isSplit){
                          OrderfoodSplit();
                        }else{
                          Orderfood();
                        }
                      }
                    }else{
                      Orderfood();
                    }
                   // (_slots ) ? _isPickup ? Orderfood(): Features.isSplit ? OrderfoodSplit() : Orderfood() :OrderfoodSplit();
                    // if(Features.isOffers) {
                    //   if (offersData.offers.length > 0) {
                    //     _addToCart();
                    //   } else {
                    //    (_slots ) ? _isPickup ? Orderfood(): Features.isSplit ? OrderfoodSplit() : Orderfood() :OrderfoodSplit();
                    //   }
                    // }else{
                    //  (_slots ) ? _isPickup ? Orderfood(): Features.isSplit ? OrderfoodSplit() : Orderfood() :OrderfoodSplit();
                    // }
                    /*  if(offersData.offers.length > 0) {
                      _addToCart();
                    } else {
                      Orderfood();
                    }*/
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.40,
                  decoration: BoxDecoration(
                      color: ColorCodes.primaryColor,
                      borderRadius: BorderRadius.circular(5)
                  ),
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  margin: EdgeInsets.only(top: 15),
                  child: Row(
                    children: [
                      SizedBox(width: 20),
                      Image.asset(
                        Images.bag, height: 30, width: 30, color: ColorCodes.whiteColor,
                      ),
                      SizedBox(width: 5,),
                      Column(
                        children: [
                          Text(CartCalculations.itemCount.toString() + " " + S .of(context).items,
                              style: TextStyle( color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height:5),
                          Row(
                            children: [
                              Text(IConstants.currencyFormat,  style: TextStyle( color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                              Text(!_displaypromo ? _isPickup
        ?
        _isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0)
        ?
        (cartTotal +   deliveryAmt - loyaltyAmount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) :
        (cartTotal + deliveryAmt).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) :
        _isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0) ?
        (cartTotal + deliveryAmt - loyaltyAmount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) :
        (cartTotal + deliveryAmt).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) :
        (promomessage.toLowerCase() == 'cashback') ?
        _isSwitch && !_isLoyaltyToast &&   _isLoayalty && (double.parse(loyaltyPoints) > 0) ?
        (cartTotal + deliveryAmt - loyaltyAmount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) :
        (cartTotal + deliveryAmt).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) :
        _isSwitch &&  !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0) ?
        (double.parse(_promoamount) - loyaltyAmount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) :
        (double.parse(_promoamount)).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                              style: TextStyle( color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                      Text(
                        S .of(context).proceed_pay,//'PROCEED TO PAY',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: ColorCodes.whiteColor,
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                ),
                // child: Container(
                //   color: Theme.of(context).primaryColor,
                //   width: MediaQuery.of(context).size.width * 0.40,
                //   height: 50,
                //   child: Center(
                //     child: Text(
                //       S .of(context).proceed_pay,//'PROCEED TO PAY',
                //       style: TextStyle(
                //           color: Colors.white, fontWeight: FontWeight.bold),
                //     ),
                //   ),
                // ),
              ),
            ),
          ],
        );
      }
      void _handleRadioValueChange1(int value) {
        setState(() {
          _groupValue = value;
          _ischeckbox = false;
        });
      }
      Widget paymentSelection() {
        final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.40,
              margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.only(
                  top: 8.0, left: 10.0, right: 10.0, bottom: 8.0),
              decoration: BoxDecoration(
                color: ColorCodes.whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Column(
                children: [
                  if (_isPaymentMethod)
                    if (_isWallet)
                      _ischeckboxshow
                          ? GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          setState(() {
                            _ischeckbox = !_ischeckbox;
                            double totalAmount = 0.0;
                            !_displaypromo ? /*_isPickup ? totalAmount = cartTotal :*/ totalAmount = (cartTotal + deliveryAmt) : totalAmount = (double.parse(_promoamount));
                            if(_isWallet) {
                              if (int.parse(walletbalance) <= 0 /*|| double.parse((cartTotal + deliveryamount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)) > int.parse(walletbalance)*/) {
                                _isRemainingAmount = false;
                                _ischeckboxshow = false;
                                _ischeckbox = false;
                              } else if (_isSwitch ? totalAmount <= (int.parse(walletbalance) + loyaltyAmount) : totalAmount <= (int.parse(walletbalance))) {
                                _isRemainingAmount = false;
                                _groupValue = -1;
                                PrefUtils.prefs!.setString("payment_type", "wallet");
                                walletAmount = _isSwitch ? (totalAmount - loyaltyAmount) : totalAmount;
                              } else if (_isSwitch ? totalAmount > (int.parse(walletbalance) + loyaltyAmount) : totalAmount > int.parse(walletbalance)) {
                                bool _isOnline = false;
                                for(int i = 0; i < paymentData.itemspayment.length; i++) {
                                  if(paymentData.itemspayment[i].paymentMode == "1") {
                                    _isOnline = true;
                                    break;
                                  }
                                }
                                if(_isOnline) {
                                  _groupValue = -1;
                                  _isRemainingAmount = true;
                                  walletAmount = double.parse(walletbalance);
                                  remainingAmount = _isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0) ? totalAmount - double.parse(walletbalance) - loyaltyAmount: (totalAmount - int.parse(walletbalance));
                                } else {
                                  _isWallet = false;
                                  _ischeckbox = false;
                                }
                                for(int i = 0; i < paymentData.itemspayment.length; i++) {
                                  if(paymentData.itemspayment[i].paymentMode == "1") {
                                    _groupValue = i;
                                    break;
                                  }
                                }

                              }
                            } else {
                              _ischeckbox = false;
                            }
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 5, bottom: 5),
                         /* decoration: BoxDecoration(
                              color: ColorCodes.whiteColor,
                              boxShadow: [
                                BoxShadow(
                                  color: ColorCodes.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                )
                              ]
                          )*/
                         decoration: BoxDecoration(
                         color: ColorCodes.whiteColor,
                         borderRadius: BorderRadius.circular(5.0),
                         border: Border(
                         top: BorderSide(width: 1.0, color: ColorCodes.greylight,),
                         bottom: BorderSide(width: 1.0, color: ColorCodes.greylight,),
                         left: BorderSide(width: 1.0, color: ColorCodes.greylight,),
                         right: BorderSide(width: 1.0, color: ColorCodes.greylight,),
                         )),
                          width: MediaQuery.of(context).size.width * 0.40,
                          padding: EdgeInsets.only(
                              top: 20.0, left: 10.0, right: 10.0, bottom: 20.0),
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Image.asset(Images.walletImg,
                                  height: 25.0,
                                  width: 25.0,
                                  color: Theme.of(context).primaryColor),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    /*IConstants.APP_NAME + " "+*/ S .of(context).wallet,//" Wallet",
                                    style: TextStyle(
                                        color: ColorCodes.blackColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text(
                                        S .of(context).balance,//"Balance:  ",
                                        style: TextStyle(
                                            color: ColorCodes.blackColor,
                                            fontSize: 14.0),
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        Features.iscurrencyformatalign?
                                        walletbalance + " " + IConstants.currencyFormat:
                                        IConstants.currencyFormat + " " + walletbalance,
                                        style: TextStyle(
                                            color: ColorCodes.blackColor,
                                            fontSize: 14.0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Spacer(),
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  setState(() {
                                    _ischeckbox = !_ischeckbox;
                                    double totalAmount = 0.0;
                                    !_displaypromo ? /*_isPickup ? totalAmount = cartTotal :*/ totalAmount = (cartTotal + deliveryAmt) : totalAmount = (double.parse(_promoamount));
                                    if(_isWallet) {
                                      if (int.parse(walletbalance) <= 0 /*|| double.parse((cartTotal + deliveryamount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)) > int.parse(walletbalance)*/) {
                                        _isRemainingAmount = false;
                                        _ischeckboxshow = false;
                                        _ischeckbox = false;
                                      } else if (_isSwitch ? totalAmount <= (int.parse(walletbalance) + loyaltyAmount) : totalAmount <= (int.parse(walletbalance))) {
                                        _isRemainingAmount = false;
                                        _groupValue = -1;
                                        PrefUtils.prefs!.setString("payment_type", "wallet");
                                        walletAmount = _isSwitch ? (totalAmount - loyaltyAmount) : totalAmount;
                                      } else if (_isSwitch ? totalAmount > (int.parse(walletbalance) + loyaltyAmount) : totalAmount > int.parse(walletbalance)) {
                                        bool _isOnline = false;
                                        for(int i = 0; i < paymentData.itemspayment.length; i++) {
                                          if(paymentData.itemspayment[i].paymentMode == "1") {
                                            _isOnline = true;
                                            break;
                                          }
                                        }
                                        if(_isOnline) {
                                          _groupValue = -1;
                                          _isRemainingAmount = true;
                                          walletAmount = double.parse(walletbalance);
                                          remainingAmount = _isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0) ? totalAmount - double.parse(walletbalance) - loyaltyAmount: (totalAmount - int.parse(walletbalance));
                                        } else {
                                          _isWallet = false;
                                          _ischeckbox = false;
                                        }
                                        for(int i = 0; i < paymentData.itemspayment.length; i++) {
                                          if(paymentData.itemspayment[i].paymentMode == "1") {
                                            _groupValue = i;
                                            break;
                                          }
                                        }

                                      }
                                    } else {
                                      _ischeckbox = false;
                                    }
                                  });
                                },
                                child: Row(
                                  children: [
                                    if (_ischeckboxshow && _ischeckbox)
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                    if (_ischeckboxshow && _ischeckbox)
                                      Text(
                                        Features.iscurrencyformatalign?
                                        walletAmount.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) +
                                            " " + IConstants.currencyFormat :
                                        IConstants.currencyFormat +
                                            " " +
                                            walletAmount.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                        style: TextStyle(
                                            color: ColorCodes.greenColor,
                                            fontSize: 18.0),
                                      ),
                                    SizedBox(width: 10.0),
                                    _ischeckbox
                                        ? Icon(
                                      Icons.check_box,
                                      size: 25.0,
                                      color: ColorCodes.greenColor,
                                    )
                                        : Icon(
                                      Icons.check_box_outline_blank,
                                      size: 25.0,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                          : GestureDetector(
                        onTap: (){
                          Fluttertoast.showToast(msg: S .of(context).wallet_toast);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 5, bottom: 5),
                          /*decoration: BoxDecoration(
                              color: ColorCodes.whiteColor,
                              boxShadow: [
                                BoxShadow(
                                  color: ColorCodes.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                )
                              ]
                          )*/
                          decoration: BoxDecoration(
                              color: ColorCodes.whiteColor,
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border(
                                top: BorderSide(width: 1.0, color: ColorCodes.greylight,),
                                bottom: BorderSide(width: 1.0, color: ColorCodes.greylight,),
                                left: BorderSide(width: 1.0, color: ColorCodes.greylight,),
                                right: BorderSide(width: 1.0, color: ColorCodes.greylight,),
                              )),
                          width: MediaQuery.of(context).size.width * 0.40,
                          padding: EdgeInsets.only(
                              top: 20.0, left: 10.0, right: 10.0, bottom: 20.0),
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Image.asset(Images.walletImg,
                                  height: 25.0,
                                  width: 25.0,
                                  color: (walletbalance == "0")? ColorCodes.grey : Theme.of(context).primaryColor),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    /*IConstants.APP_NAME + " "+*/ S .of(context).wallet,//" Wallet",
                                    style: TextStyle(
                                        color: (walletbalance == "0")? ColorCodes.grey : ColorCodes.blackColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text(
                                        S .of(context).balance,//"Balance:  ",
                                        style: TextStyle(
                                            color: (walletbalance == "0")? ColorCodes.grey : ColorCodes.greyColor,
                                            fontSize: 14.0),
                                      ),
                                      SizedBox(
                                        height: 2.0,
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        Features.iscurrencyformatalign?
                                        walletbalance + " " + IConstants.currencyFormat:
                                        IConstants.currencyFormat + " " + walletbalance,
                                        style: TextStyle(
                                            color: (walletbalance == "0")? ColorCodes.grey : ColorCodes.greyColor,
                                            fontSize: 14.0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  Icon(Icons.check_box_outline_blank,
                                      size: 25.0, color: (walletbalance == "0")? ColorCodes.grey : ColorCodes.greenColor)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                  if (_isLoayalty && (double.parse(loyaltyPoints) > 0))
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        setState(() {
                          _isLoyaltyToast ?
                          Fluttertoast.showToast(msg: S .of(context).minimum_order_amount/*"Minimum order amount should be "*/ + loyaltyData.itemsLoyalty[0].minimumOrderAmount.toString(),  fontSize: MediaQuery.of(context).textScaleFactor *13,backgroundColor: Colors.black87, textColor: Colors.white)
                              :
                          _isSwitch = !_isSwitch;
                          if(_isWallet) {
                            double totalAmount = 0.0;
                            !_displaypromo ? /*_isPickup ? totalAmount = cartTotal :*/ totalAmount = (cartTotal + deliveryAmt) : totalAmount = (double.parse(_promoamount));

                            if (int.parse(walletbalance) <= 0 /*|| double.parse((cartTotal + deliveryamount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)) > int.parse(walletbalance)*/) {
                              _isRemainingAmount = false;
                              _ischeckboxshow = false;
                              _ischeckbox = false;
                            } else if (_isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0) ? totalAmount <= (int.parse(walletbalance) + loyaltyAmount) : totalAmount <= (int.parse(walletbalance))) {
                              _isRemainingAmount = false;
                              _groupValue = -1;
                              PrefUtils.prefs!.setString("payment_type", "wallet");
                              walletAmount = _isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0) ? (totalAmount - loyaltyAmount) : totalAmount;
                            } else if (_isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0) ? totalAmount > (int.parse(walletbalance) + loyaltyAmount) : totalAmount > int.parse(walletbalance)) {
                              bool _isOnline = false;
                              for(int i = 0; i < paymentData.itemspayment.length; i++) {
                                if(paymentData.itemspayment[i].paymentMode == "1") {
                                  _groupValue = i;
                                  _isOnline = true;
                                  break;
                                }
                              }
                              if(_isOnline) {
                                _groupValue = -1;
                                _isRemainingAmount = true;
                                walletAmount = double.parse(walletbalance);
                                remainingAmount = _isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0) ? totalAmount - double.parse(walletbalance) - loyaltyAmount: (totalAmount - int.parse(walletbalance));
                              } else {
                                _isWallet = false;
                                _ischeckbox = false;
                              }
                              for(int i = 0; i < paymentData.itemspayment.length; i++) {
                                if(paymentData.itemspayment[i].paymentMode == "1") {
                                  _groupValue = i;
                                  break;
                                }
                              }
                            }
                          } else {
                            _ischeckbox = false;
                          }
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 5, bottom: 5),
                        /*decoration: BoxDecoration(
                            color: ColorCodes.whiteColor,
                            boxShadow: [
                              BoxShadow(
                                color: ColorCodes.grey.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: Offset(0, 5),
                              )
                            ]
                        )*/
                        decoration: BoxDecoration(
                            color: ColorCodes.whiteColor,
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border(
                              top: BorderSide(width: 1.0, color: ColorCodes.greylight,),
                              bottom: BorderSide(width: 1.0, color: ColorCodes.greylight,),
                              left: BorderSide(width: 1.0, color: ColorCodes.greylight,),
                              right: BorderSide(width: 1.0, color: ColorCodes.greylight,),
                            )),
                        width: MediaQuery.of(context).size.width * 0.40,
                        padding: EdgeInsets.only(
                            top: 15.0, left: 10.0, right: 10.0, bottom: 15.0),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Image.asset(Images.coinImg,
                              height: 25.0,
                              width: 25.0,),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      S .of(context).loyalty,//"Loyalty",
                                      style: TextStyle(
                                          color: ColorCodes.blackColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 5),
                                    GestureDetector(
                                      onTap: () {
                                        _popupForloyaltynote();
                                      },
                                      child:Icon(
                                        Icons.info_outline,
                                        color: ColorCodes.redColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                      S .of(context).balance,//"Balance:  ",
                                      style: TextStyle(
                                          color: ColorCodes.greyColor, fontSize: 14.0),
                                    ),
                                    Image.asset(
                                      Images.coinImg,
                                      height: 16.0,
                                      width: 16.0,
                                    ),
                                    Text(
                                      loyaltyPoints,
                                      style: TextStyle(
                                          color: ColorCodes.greyColor, fontSize: 14.0),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Spacer(),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                setState(() {
                                  _isLoyaltyToast ?
                                  Fluttertoast.showToast(msg: S .of(context).minimum_order_amount/*"Minimum order amount should be "*/ + loyaltyData.itemsLoyalty[0].minimumOrderAmount.toString(),  fontSize: MediaQuery.of(context).textScaleFactor *13,backgroundColor: Colors.black87, textColor: Colors.white)
                                      :
                                  _isSwitch = !_isSwitch;
                                  if(_isWallet) {
                                    double totalAmount = 0.0;
                                    !_displaypromo ?/* _isPickup ? totalAmount = cartTotal :*/ totalAmount = (cartTotal + deliveryAmt) : totalAmount = (double.parse(_promoamount));

                                    if (int.parse(walletbalance) <= 0 /*|| double.parse((cartTotal + deliveryamount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)) > int.parse(walletbalance)*/) {
                                      _isRemainingAmount = false;
                                      _ischeckboxshow = false;
                                      _ischeckbox = false;
                                    } else if (_isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0) ? totalAmount <= (int.parse(walletbalance) + loyaltyAmount) : totalAmount <= (int.parse(walletbalance))) {
                                      _isRemainingAmount = false;
                                      _groupValue = -1;
                                      PrefUtils.prefs!.setString("payment_type", "wallet");
                                      walletAmount = _isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0) ? (totalAmount - loyaltyAmount) : totalAmount;
                                    } else if (_isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0) ? totalAmount > (int.parse(walletbalance) + loyaltyAmount) : totalAmount > int.parse(walletbalance)) {
                                      bool _isOnline = false;
                                      for(int i = 0; i < paymentData.itemspayment.length; i++) {
                                        if(paymentData.itemspayment[i].paymentMode == "1") {
                                          _groupValue = i;
                                          _isOnline = true;
                                          break;
                                        }
                                      }
                                      if(_isOnline) {
                                        _groupValue = -1;
                                        _isRemainingAmount = true;
                                        walletAmount = double.parse(walletbalance);
                                        remainingAmount = _isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0) ? totalAmount - double.parse(walletbalance) - loyaltyAmount: (totalAmount - int.parse(walletbalance));
                                      } else {
                                        _isWallet = false;
                                        _ischeckbox = false;
                                      }
                                      for(int i = 0; i < paymentData.itemspayment.length; i++) {
                                        if(paymentData.itemspayment[i].paymentMode == "1") {
                                          _groupValue = i;
                                          break;
                                        }
                                      }
                                    }
                                  } else {
                                    _ischeckbox = false;
                                  }
                                });
                              },

                              child: Row(
                                children: [
                                  Image.asset(
                                    Images.coinImg,
                                    height: 16.0,
                                    width: 16.0,
                                  ),
                                  Text(
                                    " " +
                                        loyaltyPointsUser
                                            .roundToDouble()
                                            .toStringAsFixed(0),
                                    style: TextStyle(
                                        color: ColorCodes.greenColor, fontSize: 18.0),
                                  ),
                                  SizedBox(width: 10.0),
                                  _isLoyaltyToast
                                      ? Icon(
                                      Icons.check_box_outline_blank,
                                      size: 25.0,
                                      color: ColorCodes.greenColor
                                  )
                                      : _isSwitch
                                      ? Icon(Icons.check_box,
                                      color: ColorCodes.greenColor,
                                      size: 25.0)
                                      : Icon(
                                    Icons.check_box_outline_blank,
                                    size: 25.0,
                                    color: ColorCodes.greenColor,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  (productBox.length == 1 && productBox[0].mode == 1)
                      ? SizedBox.shrink()
                      :
                  (Features.isPromocode)?
                  !_checkpromo?
                  // GestureDetector(
                  //   behavior: HitTestBehavior.translucent,
                  //   /*onTap: () {
                  //     //_dialogforPromo(context);
                  //   },*/
                  //   child: Container(
                  //     width: MediaQuery.of(context).size.width * 0.40,
                  //     margin: EdgeInsets.only(top: 5, bottom: 5),
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.all(Radius.circular(2.0)),
                  //       boxShadow: [
                  //         BoxShadow(
                  //           color: Colors.grey.withOpacity(0.4),
                  //           spreadRadius: 1,
                  //           blurRadius: 4,
                  //           offset: Offset(0, 1), // changes position of shadow
                  //         ),
                  //       ],
                  //     ),
                  //     padding: EdgeInsets.only(
                  //         top: 0.0, left: 10.0, right: 0.0, bottom: 0.0),
                  //     //padding: EdgeInsets.only(left: 15),
                  //     child: Row(
                  //       //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: <Widget>[
                  //         Image.asset(Images.appLoyalty, width: 24, height: 24, color: ColorCodes.blackColor),
                  //         SizedBox(
                  //           width: 10,
                  //         ),
                  //         Container(
                  //           width: MediaQuery.of(context).size.width / 4,
                  //           child: TextField(
                  //             decoration: InputDecoration(
                  //               border: InputBorder.none,
                  //               hintText: S .of(context).enter_promo,
                  //               hintStyle: TextStyle(/*color: ColorCodes.lightgrey,*/ fontSize: 14,
                  //                   /*fontWeight: FontWeight.bold*/),),//'Enter Promo Code'),
                  //             controller: myController,
                  //             onSubmitted: (String newVal) {
                  //               /*prefs.setString("promovalue", newVal);
                  //                         setState(() {
                  //                           _checkpromo = true;
                  //                           _promocode = newVal;
                  //                         });*/
                  //               setState(() {
                  //                 _checkpromo = true;
                  //               });
                  //               checkPromo();
                  //             },),
                  //         ),
                  //         Spacer(),
                  //         MouseRegion(
                  //           cursor: SystemMouseCursors.click,
                  //           child: GestureDetector(
                  //             onTap: () {
                  //               setState(() {
                  //                 _checkpromo = true;
                  //               });
                  //               checkPromo();
                  //             },
                  //             child: Container(
                  //               width: 80.0,
                  //               height: 80,
                  //               decoration: BoxDecoration(
                  //                 color: ColorCodes.greenColor,
                  //                 borderRadius: BorderRadius.circular(2.0),
                  //               ),
                  //               child: Center(
                  //                 child:Text(
                  //                   S .of(context).apply,//"Payment Method",
                  //                   style: TextStyle(
                  //                       fontSize: 19.0,
                  //                       color: ColorCodes.whiteColor,
                  //                       fontWeight: FontWeight.bold),
                  //                 )
                  //                 /*Icon(Icons.keyboard_arrow_right_sharp, size: 35, color: ColorCodes.greenColor,),*/),
                  //             ),
                  //           ),
                  //         ),
                  //
                  //       ],
                  //     ),
                  //   ),
                  // ):
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    /*onTap: () {
                  //_dialogforPromo(context);
                },*/
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.40,
                      margin: EdgeInsets.only(left:0, right: 0, top: 10, bottom: 5),
                     /* decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(2.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ],
                      )*/decoration: BoxDecoration(
                        color: ColorCodes.whiteColor,
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border(
                          top: BorderSide(width: 1.0, color: ColorCodes.greylight,),
                          bottom: BorderSide(width: 1.0, color: ColorCodes.greylight,),
                          left: BorderSide(width: 1.0, color: ColorCodes.greylight,),
                          right: BorderSide(width: 1.0, color: ColorCodes.greylight,),
                        )),
                      padding: EdgeInsets.only(
                          top: 0.0, left: 20.0, right: 0.0, bottom: 0.0),
                      //padding: EdgeInsets.only(left: 15),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Image.asset(Images.appLoyalty, width: 24, height: 24, color: ColorCodes.blackColor),
                          SizedBox(
                            width: 10,
                          ),
                          (routeArgs['fromScreen'].toString() == "promocodeScreen")?
                          Container(
                            width: MediaQuery.of(context).size.width / 4.5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  routeArgs['promocode'],
                                  style: TextStyle(fontSize: 16, color: ColorCodes.blackColor, fontWeight: FontWeight.bold),

                                ),
                                SizedBox(height: 5,),
                                Text(
                                  S.of(context).offer_applied,//"Offer applied on the bill",

                                  style: TextStyle(fontSize: 16, color: ColorCodes.blackColor, fontWeight: FontWeight.bold),

                                ),
                              ],
                            ),

                          )
                              :Container(
                            width: MediaQuery.of(context).size.width / 4.5,
                            child: Text(
                              S.of(context).apply_coupon_payment,//"Apply Coupon",
                              style: TextStyle(fontSize: 19, color: ColorCodes.blackColor, fontWeight: FontWeight.bold),
                            ),

                          ),
                          Spacer(),
                          MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child:(routeArgs['fromScreen'].toString() == "promocodeScreen")?

                              GestureDetector(
                                onTap: (){
                                  // Navigator.of(context).pushNamed(PaymentScreen.routeName,arguments: {
                                  //   'fromScreen':'',
                                  //   'responsejson':"",
                                  //   'minimumOrderAmountNoraml': routeArgs['minimumOrderAmountNoraml'],
                                  //   'deliveryChargeNormal': routeArgs['deliveryChargeNormal'],
                                  //   'minimumOrderAmountPrime': routeArgs['minimumOrderAmountPrime'],
                                  //   'deliveryChargePrime': routeArgs['deliveryChargePrime'],
                                  //   'minimumOrderAmountExpress': routeArgs['minimumOrderAmountExpress'],
                                  //   'deliveryChargeExpress': routeArgs['deliveryChargeExpress'],
                                  //   'deliveryType': routeArgs['deliveryType'],
                                  //   'addressId': PrefUtils.prefs!.getString("addressId"),
                                  //   'note': routeArgs['note'],
                                  //   'deliveryCharge': routeArgs['deliveryCharge'],
                                  //   'deliveryDurationExpress' : routeArgs['minimumOrderAmountNoraml'],
                                  // });

                                  Navigation(context, name: Routename.PaymentScreen, navigatore: NavigatoreTyp.Push,
                                      qparms: {
                                        'fromScreen':'',
                                        'responsejson':"",
                                        'minimumOrderAmountNoraml': routeArgs['minimumOrderAmountNoraml'],
                                        'deliveryChargeNormal': routeArgs['deliveryChargeNormal'],
                                        'minimumOrderAmountPrime': routeArgs['minimumOrderAmountPrime'],
                                        'deliveryChargePrime': routeArgs['deliveryChargePrime'],
                                        'minimumOrderAmountExpress': routeArgs['minimumOrderAmountPrime'],
                                        'deliveryChargeExpress': routeArgs['deliveryChargeExpress'],
                                        'deliveryType': routeArgs['deliveryType'],
                                        'addressId': PrefUtils.prefs!.getString("addressId"),
                                        'note': routeArgs['note'],
                                        'deliveryCharge':  routeArgs['deliveryCharge'],
                                        'deliveryDurationExpress' :  routeArgs['minimumOrderAmountNoraml'],
                                      });
                                },
                                child: Container(
                                    padding: EdgeInsets.only(left: 5,right: 5),
                                    width: (MediaQuery.of(context).size.width / 7),
                                    height: 60,
                                    child: Center(
                                        child:Text(/*"Remove"*/S.of(context).remove,style: TextStyle(
                                            color: ColorCodes.discountoff,fontWeight: FontWeight.bold
                                          /*Icon(Icons.keyboard_arrow_right_sharp, size: 35, color: ColorCodes.greenColor,),*/),
                                        ))),
                              )

                                  :GestureDetector(
                                onTap: () {
                                  final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
                                  Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?
                                      PromocodeWeb(context,
                                          deliveryAmt: widget.deliveryCharge.toString(),
                                  minimumOrderAmountNoraml: widget.minimumOrderAmountNoraml,
                                  deliveryChargeNormal: widget.deliveryChargeNormal,
                                  minimumOrderAmountPrime: widget.minimumOrderAmountPrime,
                                  deliveryChargePrime: widget.deliveryChargePrime,
                                  minimumOrderAmountExpress: widget.minimumOrderAmountExpress,
                                  deliveryChargeExpress: widget.deliveryChargeExpress,
                                  deliveryType: widget.deliveryType,
                                  addressId: PrefUtils.prefs!.getString("addressId"),
                                  note: widget.note,
                                  deliveryCharge: widget.deliveryCharge.toString(),
                                  deliveryDurationExpress : widget.deliveryDurationExpress,)
                                      :
                                  Navigation(context, name: Routename.PromocodeScreen, navigatore: NavigatoreTyp.Push,
                                      qparms: {
                                        "deliveryAmt": widget.deliveryCharge.toString(),
                                        'minimumOrderAmountNoraml': /*routeArgs['minimumOrderAmountNoraml']*/widget.minimumOrderAmountNoraml,
                                        'deliveryChargeNormal': /*routeArgs['deliveryChargeNormal']*/widget.deliveryChargeNormal,
                                        'minimumOrderAmountPrime': /*routeArgs['minimumOrderAmountPrime']*/widget.minimumOrderAmountPrime,
                                        'deliveryChargePrime': /*routeArgs['deliveryChargePrime']*/widget.deliveryChargePrime,
                                        'minimumOrderAmountExpress': /*routeArgs['minimumOrderAmountPrime']*/widget.minimumOrderAmountExpress,
                                        'deliveryChargeExpress':/* routeArgs['deliveryChargeExpress']*/widget.deliveryChargeExpress,
                                        'deliveryType': /*routeArgs['deliveryType']*/widget.deliveryType,
                                        'addressId': PrefUtils.prefs!.getString("addressId"),
                                        'note': /*routeArgs['note']*/widget.note,
                                        'deliveryCharge': /* routeArgs['deliveryCharge']*/widget.deliveryCharge.toString(),
                                        'deliveryDurationExpress' : /* routeArgs['minimumOrderAmountNoraml']*/widget.deliveryDurationExpress,
                                      });
                                  debugPrint("mini...."+widget.deliveryCharge.toString());
                                },
                                child: Container(
                                  padding: EdgeInsets.only(left: 5,right: 5),
                                  width: (MediaQuery.of(context).size.width / 7),
                                  height: 60,
                                  child: Center(
                                    child:Icon(Icons.keyboard_arrow_right_sharp, size: 35),
                                    /*Icon(Icons.keyboard_arrow_right_sharp, size: 35, color: ColorCodes.greenColor,),*/),
                                ),
                              )

                          ),

                        ],
                      ),
                    ),
                  ):
                  Center(
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor,),
                    ),
                  ):SizedBox.shrink(),
                  (productBox.length == 1 && productBox[0].mode == 1)
                      ? SizedBox.shrink()
                      :

                  Padding(
                      padding: const EdgeInsets.only(left:20.0,right:20.0),
                      child: SizedBox(height:20)/*Divider(
                  color: ColorCodes.whiteColor,
                  //thickness: 2.5,
                ),*/
                  ),

                ],
              ),
            ),
            SizedBox(height:30),

            _isPaymentMethod
                ? Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.40,
                      margin: EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                        color: ColorCodes.whiteColor,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      padding: EdgeInsets.only(
                          top: 8.0, left: 10.0, right: 10.0, bottom: 20.0),
                      child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.40,
                          padding: EdgeInsets.only(
                              top: 10.0, left: 35.0, right: 35.0, bottom: 10.0),
                          child: Text(
                            S .of(context).payment_option,//"Payment Method",
                            style: TextStyle(
                                fontSize: 19.0,
                                color: ColorCodes.greenColor,
                                fontWeight: FontWeight.bold),
                          )),
                      SizedBox(
                        child: new ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: paymentData.itemspayment.length,
                          itemBuilder: (_, i) => Column(
                            children: [
                              if (paymentData.itemspayment[i].paymentMode ==
                                  "1")
                                _isRemainingAmount
                                    ? GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: (){
                                    _handleRadioValueChange1(i);
                                  },
                                  child: Container(
                                    width:
                                    MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.only(
                                        left: 35.0,
                                        right: 35.0,
                                        bottom: 20.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              paymentData.itemspayment[i]
                                                  .paymentName,
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: ColorCodes
                                                      .greyColor),
                                            ),
                                            Image.asset(Images.onlineImg, height: 24),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              Features.iscurrencyformatalign?
                                              remainingAmount
                                                      .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) +
                                                  " " + IConstants.currencyFormat :
                                                IConstants.currencyFormat +
                                                    " " +
                                                    remainingAmount
                                                        .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                                style: TextStyle(
                                                    color: ColorCodes
                                                        .blackColor,
                                                    fontSize: 12.0)),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            handler(i),
                                            /*SizedBox(
                                              width: 20.0,
                                              child: _myRadioButton(
                                                title: "",
                                                value: i,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    _groupValue = newValue!;
                                                    _ischeckbox = false;
                                                  });
                                                },
                                              ),
                                            ),*/
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                    :
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: (){
                                    _handleRadioValueChange1(i);
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 40,
                                    padding: EdgeInsets.only(
                                        top: 10,
                                        left: 35.0,
                                        right: 35.0,
                                        bottom: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              paymentData.itemspayment[i]
                                                  .paymentName,
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: ColorCodes
                                                      .greyColor),
                                            ),
                                            SizedBox(height: 10),
                                            Image.asset(Images.onlineImg, height: 24),
                                          ],
                                        ),
                                        handler(i),
                                        /*SizedBox(
                                          width: 15.0,
                                          child: _myRadioButton(
                                            title: "",
                                            value: i,
                                            onChanged: (newValue) {
                                              setState(() {
                                                _groupValue = newValue!;
                                                _ischeckbox = false;
                                              });
                                            },
                                          ),
                                        )*/
                                      ],
                                    ),
                                  ),
                                ),
                              if (paymentData.itemspayment[i].paymentMode ==
                                  "7")
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: (){
                                    _handleRadioValueChange1(i);
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.only(
                                        top: 10,
                                        left: 35.0,
                                        right: 35.0,
                                        bottom: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Image.asset(Images.sodexoImg, width: 35, height: 35),
                                        // SizedBox(width: 5),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              // Row(
                                              //   children: [
                                              //     Text(
                                              //       paymentData
                                              //           .itemspayment[i].paymentName,
                                              //       style: TextStyle(
                                              //           fontSize: 14.0,
                                              //           fontWeight: FontWeight.bold,
                                              //           color: ColorCodes
                                              //               .greyColor),
                                              //     ),
                                              //   ],
                                              // ),
                                              // SizedBox(height: 5),
                                              Image.asset(Images.sodexoImg, height: 25),
                                              // SizedBox(
                                              //   height: 10.0,
                                              // ),
                                              // Row(
                                              //   children: [
                                              //     Image.asset(
                                              //         Images.cardMachineImg),
                                              //     SizedBox(width: 10.0),
                                              //     Expanded(
                                              //         child: Text(
                                              //         S .of(context).our_delivery_personnel,//"Our delivery personnel will carry a swipe machine & orders can be paid via Debit/Credit card at the time of delivery.",
                                              //           style: TextStyle(
                                              //               fontSize: 12.0,
                                              //               color:
                                              //               ColorCodes.greyColor),
                                              //         )),
                                              //     SizedBox(width: 50.0),
                                              //   ],
                                              // ),
                                            ],
                                          ),
                                        ),
                                        handler(i),
                                        /*SizedBox(
                                          width: 15.0,
                                          child: _myRadioButton(
                                            title: "",
                                            value: i,
                                            onChanged: (newValue) {
                                              setState(() {
                                                _groupValue = newValue!;
                                                _ischeckbox = false;
                                              });
                                            },
                                          ),
                                        ),*/
                                      ],
                                    ),
                                  ),
                                ),
                              if (paymentData.itemspayment[i].paymentMode ==
                                  "0")
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: (){
                                    _handleRadioValueChange1(i);
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 40,
                                    padding: EdgeInsets.only(
                                        top: 10.0,
                                        left: 35.0,
                                        right: 35.0,
                                        bottom: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset(Images.walletImg, width: 28, height: 28),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    paymentData
                                                        .itemspayment[i].paymentName,
                                                    style: TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight: FontWeight.bold,
                                                        color: ColorCodes
                                                            .greyColor),
                                                  ),
                                                ],
                                              ),
                                              // SizedBox(
                                              //   height: 10.0,
                                              // ),
                                              // Row(
                                              //   children: [
                                              //     Image.asset(
                                              //         Images.cardMachineImg),
                                              //     SizedBox(width: 10.0),
                                              //     Expanded(
                                              //         child: Text(
                                              //         S .of(context).our_delivery_personnel,//"Our delivery personnel will carry a swipe machine & orders can be paid via Debit/Credit card at the time of delivery.",
                                              //           style: TextStyle(
                                              //               fontSize: 12.0,
                                              //               color:
                                              //               ColorCodes.greyColor),
                                              //         )),
                                              //     SizedBox(width: 50.0),
                                              //   ],
                                              // ),
                                            ],
                                          ),
                                        ),
                                        handler(i),
                                       /* SizedBox(
                                          width: 15.0,
                                          child: _myRadioButton(
                                            title: "",
                                            value: i,
                                            onChanged: (newValue) {
                                              setState(() {
                                                _groupValue = newValue!;
                                                _ischeckbox = false;
                                              });
                                            },
                                          ),
                                        ),*/
                                      ],
                                    ),
                                  ),
                                ),
                              if (paymentData.itemspayment[i].paymentMode == "6")
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: (){
                                    _handleRadioValueChange1(i);
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 40,
                                    padding: EdgeInsets.only(
                                        left: 35.0, right: 35.0, bottom: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(Images.cashImg, width: 35, height: 35),
                                        SizedBox(width: 5),
                                        Expanded(
                                          child: Container(
                                            width: MediaQuery.of(context).size.width * 40,
                                            padding: EdgeInsets.only(
                                                top: 10.0,
                                                /* left: 20.0,
                                                  right: 20.0,*/
                                                bottom: 10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  S .of(context).cash_delivery,//"Cash on Delivery",//"Cash",
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight: FontWeight.bold,
                                                      color:
                                                      ColorCodes.greyColor),
                                                ),
                                                // SizedBox(
                                                //   height: 10.0,
                                                // ),
                                                // Row(
                                                //   children: [
                                                //     Image.asset(
                                                //       Images.cashImg,
                                                //       width: 26.0,
                                                //       height: 26.0,
                                                //     ),
                                                //     SizedBox(width: 10.0),
                                                //     Expanded(
                                                //         child: Text(
                                                //           S .of(context).tips_to_ensure,//"Tip: To ensure a contactless delivery, we recommend you use an online payment method.",
                                                //           style: TextStyle(
                                                //               fontSize: 12.0,
                                                //               color: ColorCodes
                                                //                   .greyColor),
                                                //         )),
                                                //     SizedBox(width: 50.0),
                                                //   ],
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        handler(i),
                                       /* SizedBox(
                                          width: 15.0,
                                          child: _myRadioButton(
                                            title: "",
                                            value: i,
                                            onChanged: (newValue) {
                                              setState(() {
                                                _groupValue = newValue!;
                                                _ischeckbox = false;
                                              });
                                            },
                                          ),
                                        )*/
                                      ],
                                    ),
                                  ),
                                ),
                              if (paymentData.itemspayment[i].paymentMode == "6" || paymentData.itemspayment[i].paymentMode ==
                                  "0" || paymentData.itemspayment[i].paymentMode == "1")
                                Container(
                                  width: MediaQuery.of(context).size.width * 40,
                                  margin: EdgeInsets.only(left: 35, right: 35),
                                  child: DottedLine(
                                      dashColor: ColorCodes.lightGreyColor,
                                      lineThickness: 1.0,
                                      dashLength: 2.0,
                                      dashRadius: 0.0,
                                      dashGapLength: 1.0),
                                ),
                            ],
                          ),
                        ),
                      ),

              ],
            ),
                    ),
                  ],
                )
                : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  S .of(context).no_payment,//"Currently there is no payment methods",
                  style: TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        );
      }

      if (!_displaypromo) {
        /*  if (_isPickup) {
          if (_isSwitch &&
              !_isLoyaltyToast &&
              _isLoayalty &&
              (double.parse(loyaltyPoints) > 0)) {
            amountPayable = (cartTotal - loyaltyAmount).roundToDouble();
          } else {
            amountPayable = cartTotal;
          }
        } else*/ {
          // else statement for _isPickup
          if (_isSwitch &&
              !_isLoyaltyToast &&
              _isLoayalty &&
              (double.parse(loyaltyPoints) > 0)) {
            amountPayable =
                (cartTotal + deliveryAmt - loyaltyAmount).roundToDouble();
          } else {
            amountPayable = (cartTotal + deliveryAmt);
          }
        }
      } else {
        //else statement for !_displaypromo
        /* if (_isPickup) {
          if (_isSwitch &&
              !_isLoyaltyToast &&
              _isLoayalty &&
              (double.parse(loyaltyPoints) > 0)) {
            amountPayable =
                (cartTotal - double.parse(_savedamount) - loyaltyAmount)
                    .roundToDouble();
          } else {
            amountPayable = (cartTotal - double.parse(_savedamount));
          }
        } else*/ {
          // else statement for _isPickup
          // if (_isSwitch &&
          //     !_isLoyaltyToast &&
          //     _isLoayalty &&
          //     (double.parse(loyaltyPoints) > 0)) {
          //   amountPayable = (cartTotal +
          //       deliveryAmt /*-
          //       double.parse(_savedamount)*/ -
          //       loyaltyAmount)
          //       .roundToDouble();
          // } else {
          //   amountPayable =
          //   (cartTotal + deliveryAmt /*- double.parse(_savedamount)*/);
          // }



          if (_isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0)) {
            amountPayable = (promomessage.toLowerCase() == 'cashback') ?
            (cartTotal + deliveryAmt - loyaltyAmount)
                :
            (cartTotal + deliveryAmt - double.parse(_savedamount) - loyaltyAmount);
            //.roundToDouble();
          } else {
            amountPayable = (promomessage.toLowerCase() == 'cashback') ?
            (cartTotal + deliveryAmt) :
            (cartTotal + deliveryAmt - double.parse(_savedamount));
          }
        }
      }
      queryData = MediaQuery.of(context);
      wid= queryData!.size.width;
      maxwid=wid!*0.90;
      return (_isWeb && !ResponsiveLayout.isSmallScreen(context))
          ?  Expanded(
        child: SingleChildScrollView(
          child: Container(
            color: (Vx.isWeb) ? ColorCodes.greyColord : ColorCodes.whiteColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                _isLoading
                    ? Center(
                  child: PaymnetOption(),//CircularProgressIndicator(),
                )
                    :
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    constraints: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid!):null,

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(child: paymentSelection()),
                        Flexible(child: paymentDetails()),
                      ],
                    ),
                  ),
                ),
                if (_isWeb)
                  Footer(
                      address: _address),
              ],
            ),
          ),
        ),
      )
          : null;
    }

    Widget _bodyMobile() {
      final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      double amountPayable = 0.0;
     Widget paymentMode() {
       return Container(
         decoration: BoxDecoration(
             color: ColorCodes.whiteColor,
             // boxShadow: [
             //   BoxShadow(
             //     color: ColorCodes.grey.withOpacity(0.5),
             //     spreadRadius: 5,
             //     blurRadius: 5,
             //     offset: Offset(0, 5),
             //   )
             // ]
         ),
         child: Column (
           children: <Widget>[
             if (_isPaymentMethod)
               if (_isWallet)
                 _ischeckboxshow
                     ? GestureDetector(
                   behavior: HitTestBehavior.translucent,
                   onTap: () {
                     setState(() {
                       _ischeckbox = !_ischeckbox;
                       double totalAmount = 0.0;
                       !_displaypromo ? /*_isPickup ? totalAmount = cartTotal :*/ totalAmount = (cartTotal + deliveryAmt) : totalAmount = (double.parse(_promoamount));
                       if(_isWallet) {
                         if (int.parse(walletbalance) <= 0 /*|| double.parse((cartTotal + deliveryamount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)) > int.parse(walletbalance)*/) {
                           _isRemainingAmount = false;
                           _ischeckboxshow = false;
                           _ischeckbox = false;
                         } else if (_isSwitch ? totalAmount <= (int.parse(walletbalance) + loyaltyAmount) : totalAmount <= (int.parse(walletbalance))) {
                           _isRemainingAmount = false;
                           _groupValue = -1;
                           PrefUtils.prefs!.setString("payment_type", "wallet");
                           walletAmount = _isSwitch ? (totalAmount - loyaltyAmount) : totalAmount;
                         } else if (_isSwitch ? totalAmount > (int.parse(walletbalance) + loyaltyAmount) : totalAmount > int.parse(walletbalance)) {
                           bool _isOnline = false;
                           for(int i = 0; i < paymentData.itemspayment.length; i++) {
                             if(paymentData.itemspayment[i].paymentMode == "1") {
                               _isOnline = true;
                               break;
                             }
                           }
                           if(_isOnline) {
                             _groupValue = -1;
                             _isRemainingAmount = true;
                             walletAmount = double.parse(walletbalance);
                             remainingAmount = _isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0) ? totalAmount - double.parse(walletbalance) - loyaltyAmount: (totalAmount - int.parse(walletbalance));
                           } else {
                             _isWallet = false;
                             _ischeckbox = false;
                           }
                           for(int i = 0; i < paymentData.itemspayment.length; i++) {
                             if(paymentData.itemspayment[i].paymentMode == "1") {
                               _groupValue = i;
                               break;
                             }
                           }

                            }
                          } else {
                            _ischeckbox = false;
                          }
                        });
                      },

                      child: Container(
                        margin: EdgeInsets.only(left:15, right: 15, top: 15, bottom: 5),
                        decoration: BoxDecoration(
                            color: ColorCodes.whiteColor,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border(
                              top: BorderSide(width: 1.0, color: ColorCodes.greylight,),
                              bottom: BorderSide(width: 1.0, color: ColorCodes.greylight,),
                              left: BorderSide(width: 1.0, color: ColorCodes.greylight,),
                              right: BorderSide(width: 1.0, color: ColorCodes.greylight,),
                            )),
                        padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Image.asset(Images.walletImg, width: 25,height: 25, color: (walletbalance == "0")? ColorCodes.grey : ColorCodes.blackColor),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  IConstants.APP_NAME + " "+  S .of(context).wallet,//" Wallet",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: (walletbalance == "0")? ColorCodes.grey : ColorCodes.blackColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      S .of(context).wallet_balance,    //"Balance:  ",
                                      style: TextStyle(
                                          color: ColorCodes.greyColor,
                                          fontSize: 12.0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 3.0,
                                    ),
                                    Text(
                                      Features.iscurrencyformatalign?
                                      walletbalance + "" + IConstants.currencyFormat:
                                      IConstants.currencyFormat + "" + walletbalance,
                                      style: TextStyle(
                                          color: ColorCodes.greyColor,
                                          fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Spacer(),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                setState(() {
                                  _ischeckbox = !_ischeckbox;
                                  double totalAmount = 0.0;
                                  !_displaypromo ? /*_isPickup ? totalAmount = cartTotal :*/ totalAmount = (cartTotal + deliveryAmt) : totalAmount = (double.parse(_promoamount));
                                  if(_isWallet) {
                                    if (int.parse(walletbalance) <= 0 /*|| double.parse((cartTotal + deliveryamount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)) > int.parse(walletbalance)*/) {
                                      _isRemainingAmount = false;
                                      _ischeckboxshow = false;
                                      _ischeckbox = false;
                                    } else if (_isSwitch ? totalAmount <= (int.parse(walletbalance) + loyaltyAmount) : totalAmount <= (int.parse(walletbalance))) {
                                      _isRemainingAmount = false;
                                      _groupValue = -1;
                                      PrefUtils.prefs!.setString("payment_type", "wallet");
                                      walletAmount = _isSwitch ? (totalAmount - loyaltyAmount) : totalAmount;
                                    } else if (_isSwitch ? totalAmount > (int.parse(walletbalance) + loyaltyAmount) : totalAmount > int.parse(walletbalance)) {
                                      bool _isOnline = false;
                                      for(int i = 0; i < paymentData.itemspayment.length; i++) {
                                        if(paymentData.itemspayment[i].paymentMode == "1") {
                                          _isOnline = true;
                                          break;
                                        }
                                      }
                                      if(_isOnline) {
                                        _groupValue = -1;
                                        _isRemainingAmount = true;
                                        walletAmount = double.parse(walletbalance);
                                        remainingAmount = _isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0) ? totalAmount - double.parse(walletbalance) - loyaltyAmount: (totalAmount - int.parse(walletbalance));
                                      } else {
                                        _isWallet = false;
                                        _ischeckbox = false;
                                      }
                                      for(int i = 0; i < paymentData.itemspayment.length; i++) {
                                        if(paymentData.itemspayment[i].paymentMode == "1") {
                                          _groupValue = i;
                                          break;
                                        }
                                      }

                                    }
                                  } else {
                                    _ischeckbox = false;
                                  }
                                });
                              },
                              child: Row(
                                children: [
                                  if (_ischeckboxshow && _ischeckbox)
                                    SizedBox(
                                      width: 4.0,
                                    ),
                                  if (_ischeckboxshow && _ischeckbox)
                                    Text(
                                      Features.iscurrencyformatalign?
                                      walletAmount.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)+
                                          " " + IConstants.currencyFormat :
                                      IConstants.currencyFormat +
                                          " " +
                                          walletAmount.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                      style: TextStyle(
                                          color: (walletbalance == "0")? ColorCodes.grey : ColorCodes.blackColor,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  SizedBox(width: 5.0),
                                  _ischeckbox
                                      ? Icon(
                                    Icons.check_box,
                                    size: 25.0,
                                    color: ColorCodes.greenColor,
                                  )
                                      : Icon(
                                      Icons.check_box_outline_blank,
                                      size: 25.0,
                                      color: (walletbalance == "0")? ColorCodes.grey : ColorCodes.blackColor
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),

                      ),
                    )
                        : GestureDetector(
                         onTap: (){
                           Fluttertoast.showToast(msg: S.of(context).wallet_toast/*"Your wallet balance is 0"*/);
                         },
                          child: Container(
                      margin: EdgeInsets.only(left:15, right: 15, top: 20, bottom: 5),
                      // decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.all(Radius.circular(2.0)),
                      //     boxShadow: [
                      //       BoxShadow(
                      //         color: Colors.grey.withOpacity(0.4),
                      //         spreadRadius: 1,
                      //         blurRadius: 4,
                      //         offset: Offset(0, 1), // changes position of shadow
                      //       ),
                      //     ],
                      // ),
                            decoration: BoxDecoration(
                                color: ColorCodes.whiteColor,
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border(
                                  top: BorderSide(width: 1.0, color: ColorCodes.greylight,),
                                  bottom: BorderSide(width: 1.0, color: ColorCodes.greylight,),
                                  left: BorderSide(width: 1.0, color: ColorCodes.greylight,),
                                  right: BorderSide(width: 1.0, color: ColorCodes.greylight,),
                                )),
                      padding: EdgeInsets.only(left: 10, top: 20, right: 10, bottom: 20),
                      child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Image.asset(Images.walletImg, width: 25,height: 25, color: (walletbalance == "0")? ColorCodes.grey : ColorCodes.blackColor),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  /*IConstants.APP_NAME + " "+*/ S .of(context).wallet,//" Wallet",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: (walletbalance == "0")? ColorCodes.grey : ColorCodes.blackColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                      S .of(context).wallet_balance,    //"Balance:  ",
                                      style: TextStyle(
                                          color: ColorCodes.grey,
                                          fontSize: 12.0),
                                    ),
                                    SizedBox(
                                      width: 3.0,
                                    ),
                                    Text(
                                      Features.iscurrencyformatalign?
                                      walletbalance + "" +  IConstants.currencyFormat:
                                      IConstants.currencyFormat + "" + walletbalance,
                                      style: TextStyle(
                                          color: ColorCodes.grey,
                                          fontSize: 12.0),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Spacer(),
                            Row(
                              children: [
                                Icon(Icons.check_box_outline_blank,
                                    size: 25.0, color: (walletbalance == "0")? ColorCodes.grey : ColorCodes.blackColor)
                              ],
                            ),
                          ],
                      ),
                    ),
                        ),
                if (_isLoayalty && (double.parse(loyaltyPoints) > 0))
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      setState(() {
                        _isLoyaltyToast ?
                        Fluttertoast.showToast(msg: S .of(context).minimum_order_amount/*"Minimum order amount should be "*/ + loyaltyData.itemsLoyalty[0].minimumOrderAmount.toString(),  fontSize: MediaQuery.of(context).textScaleFactor *13,backgroundColor: Colors.black87, textColor: Colors.white)
                            :
                        _isSwitch = !_isSwitch;
                        if(_isWallet) {
                          double totalAmount = 0.0;
                          !_displaypromo ? /*_isPickup ? totalAmount = cartTotal :*/ totalAmount = (cartTotal + deliveryAmt) : totalAmount = (double.parse(_promoamount));

                          if (int.parse(walletbalance) <= 0 /*|| double.parse((cartTotal + deliveryamount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)) > int.parse(walletbalance)*/) {
                            _isRemainingAmount = false;
                            _ischeckboxshow = false;
                            _ischeckbox = false;
                          } else if (_isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0) ? totalAmount <= (int.parse(walletbalance) + loyaltyAmount) : totalAmount <= (int.parse(walletbalance))) {
                            _isRemainingAmount = false;
                            _groupValue = -1;
                            PrefUtils.prefs!.setString("payment_type", "wallet");
                            walletAmount = _isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0) ? (totalAmount - loyaltyAmount) : totalAmount;
                          } else if (_isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0) ? totalAmount > (int.parse(walletbalance) + loyaltyAmount) : totalAmount > int.parse(walletbalance)) {
                            bool _isOnline = false;
                            for(int i = 0; i < paymentData.itemspayment.length; i++) {
                              if(paymentData.itemspayment[i].paymentMode == "1") {
                                _groupValue = i;
                                _isOnline = true;
                                break;
                              }
                            }
                            if(_isOnline) {
                              _groupValue = -1;
                              _isRemainingAmount = true;
                              walletAmount = double.parse(walletbalance);
                              remainingAmount = _isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0) ? totalAmount - double.parse(walletbalance) - loyaltyAmount: (totalAmount - int.parse(walletbalance));
                            } else {
                              _isWallet = false;
                              _ischeckbox = false;
                            }
                            for(int i = 0; i < paymentData.itemspayment.length; i++) {
                              if(paymentData.itemspayment[i].paymentMode == "1") {
                                _groupValue = i;
                                break;
                              }
                            }
                          }
                        } else {
                          _ischeckbox = false;
                        }
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(left:15, right: 15, top: 5, bottom: 5),
                      // decoration: BoxDecoration(
                      //   color: Colors.white,
                      //   borderRadius: BorderRadius.all(Radius.circular(2.0)),
                      //   boxShadow: [
                      //     BoxShadow(
                      //       color: Colors.grey.withOpacity(0.4),
                      //       spreadRadius: 1,
                      //       blurRadius: 4,
                      //       offset: Offset(0, 1), // changes position of shadow
                      //     ),
                      //   ],
                      // ),


                      decoration: BoxDecoration(
                          color: ColorCodes.whiteColor,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border(
                            top: BorderSide(width: 1.0, color: ColorCodes.greylight,),
                            bottom: BorderSide(width: 1.0, color: ColorCodes.greylight,),
                            left: BorderSide(width: 1.0, color: ColorCodes.greylight,),
                            right: BorderSide(width: 1.0, color: ColorCodes.greylight,),
                          )),
                      width: MediaQuery.of(context).size.width,
                      //color: ColorCodes.whiteColor,
                      padding: EdgeInsets.only(
                          top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Image.asset(Images.coinImg, width: 23,height: 23,),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    S .of(context).loyalty,//"Loyalty",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: ColorCodes.blackColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 8),
                                  // GestureDetector(
                                  //     onTap: () {
                                  //       _dialogForloyaltynote();
                                  //     },
                                  //     child: Image.asset(Images.icon_loyalty, width: 15,height: 15,color:Colors.red)),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    S .of(context).loyalty_balance,//"Loyalty Balance ",//"Balance:  ",
                                    style: TextStyle(
                                        color: ColorCodes.greyColor, fontSize: 12.0, ),
                                  ),
                                  Image.asset(
                                    Images.coinImg,
                                    height: 12.0,
                                    width: 12.0,
                                  ),
                                  Text(
                                    loyaltyPoints,
                                    style: TextStyle(
                                        color: ColorCodes.greyColor, fontSize: 12.0,),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              // Container(
                              //   width: MediaQuery.of(context).size.width / 1.8,
                              //   height: 15,
                              //   child: Expanded(
                              //       child:
                              //         Text(
                              //           loyaltyData.itemsLoyalty[0].note,//'Placing order...'
                              //           maxLines: 1,
                              //           overflow: TextOverflow.clip,
                              //           style: TextStyle(
                              //             color: ColorCodes.greyColor, fontSize: 12.0, ),
                              //         ),
                              //
                              //   ),
                              // ),
                              // SizedBox(height: 5),
                              GestureDetector(
                                onTap: () {
                                  _dialogForloyaltynote();

                                },
                                child: Text(
                                   S .of(context).know_more,//'Know More...'
                                  style: TextStyle(
                                    color: ColorCodes.primaryColor, fontSize: 12.0, ),
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              setState(() {
                                _isLoyaltyToast ?
                                Fluttertoast.showToast(msg: S .of(context).minimum_order_amount/*"Minimum order amount should be "*/ + loyaltyData.itemsLoyalty[0].minimumOrderAmount.toString(),  fontSize: MediaQuery.of(context).textScaleFactor *13,backgroundColor: Colors.black87, textColor: Colors.white)
                                    :
                                _isSwitch = !_isSwitch;
                                if(_isWallet) {
                                  double totalAmount = 0.0;
                                  !_displaypromo ? /*_isPickup ? totalAmount = cartTotal :*/ totalAmount = (cartTotal + deliveryAmt) : totalAmount = (double.parse(_promoamount));

                                  if (int.parse(walletbalance) <= 0 /*|| double.parse((cartTotal + deliveryamount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)) > int.parse(walletbalance)*/) {
                                    _isRemainingAmount = false;
                                    _ischeckboxshow = false;
                                    _ischeckbox = false;
                                  } else if (_isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0) ? totalAmount <= (int.parse(walletbalance) + loyaltyAmount) : totalAmount <= (int.parse(walletbalance))) {
                                    _isRemainingAmount = false;
                                    _groupValue = -1;
                                    PrefUtils.prefs!.setString("payment_type", "wallet");
                                    walletAmount = _isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0) ? (totalAmount - loyaltyAmount) : totalAmount;
                                  } else if (_isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0) ? totalAmount > (int.parse(walletbalance) + loyaltyAmount) : totalAmount > int.parse(walletbalance)) {
                                    bool _isOnline = false;
                                    for(int i = 0; i < paymentData.itemspayment.length; i++) {
                                      if(paymentData.itemspayment[i].paymentMode == "1") {
                                        _groupValue = i;
                                        _isOnline = true;
                                        break;
                                      }
                                    }
                                    if(_isOnline) {
                                      _groupValue = -1;
                                      _isRemainingAmount = true;
                                      walletAmount = double.parse(walletbalance);
                                      remainingAmount = _isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0) ? totalAmount - double.parse(walletbalance) - loyaltyAmount: (totalAmount - int.parse(walletbalance));
                                    } else {
                                      _isWallet = false;
                                      _ischeckbox = false;
                                    }
                                    for(int i = 0; i < paymentData.itemspayment.length; i++) {
                                      if(paymentData.itemspayment[i].paymentMode == "1") {
                                        _groupValue = i;
                                        break;
                                      }
                                    }
                                  }
                                } else {
                                  _ischeckbox = false;
                                }
                              });
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  Images.coinImg,
                                  height: 15.0,
                                  width: 15.0,
                                ),
                                Text(
                                  " " +
                                      loyaltyPointsUser
                                          .roundToDouble()
                                          .toStringAsFixed(0),
                                  style: TextStyle(
                                      color: ColorCodes.blackColor, fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 5.0),
                                _isLoyaltyToast
                                    ? Icon(
                                    Icons.check_box_outline_blank,
                                    size: 25.0,
                                    color: ColorCodes.blackColor
                                )
                                    : _isSwitch
                                    ? Icon(Icons.check_box,
                                    color: ColorCodes.greenColor,
                                    size: 25.0)
                                    : Icon(
                                    Icons.check_box_outline_blank,
                                    size: 25.0,
                                    color: ColorCodes.blackColor
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // if (_isLoayalty && (double.parse(loyaltyPoints) > 0))
                //   Padding(
                //     padding: const EdgeInsets.only(left:20.0,right:20.0),
                //     child: Divider(
                //       color: ColorCodes.lightGreyColor,
                //       //thickness: 2.5,
                //     ),
                //   ),
                (productBox.length == 1 && productBox[0].mode == 1)
                    ? SizedBox.shrink()
                    :
                (Features.isPromocode)?
                !_checkpromo?
              //   GestureDetector(
              //     behavior: HitTestBehavior.translucent,
              //     /*onTap: () {
              //   //_dialogforPromo(context);
              // },*/
              //     child: Container(
              //       margin: EdgeInsets.only(left:15, right: 15, top: 5, bottom: 5),
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         borderRadius: BorderRadius.all(Radius.circular(2.0)),
              //         boxShadow: [
              //           BoxShadow(
              //             color: Colors.grey.withOpacity(0.4),
              //             spreadRadius: 1,
              //             blurRadius: 4,
              //             offset: Offset(0, 1), // changes position of shadow
              //           ),
              //         ],
              //       ),
              //       padding: EdgeInsets.only(
              //           top: 0.0, left: 10.0, right: 0.0, bottom: 0.0),
              //       //padding: EdgeInsets.only(left: 15),
              //       child: Row(
              //         //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: <Widget>[
              //           Image.asset(Images.appLoyalty, width: 24, height: 24, color: ColorCodes.blackColor),
              //           SizedBox(
              //             width: 10,
              //           ),
              //           Container(
              //             width: MediaQuery.of(context).size.width / 2,
              //             child: TextField(
              //               decoration: InputDecoration(
              //                 border: InputBorder.none,
              //                 hintText: S .of(context).enter_promo,
              //                 hintStyle: TextStyle(/*color: ColorCodes.lightgrey,*/ fontSize: 14,
              //                     /*fontWeight: FontWeight.bold*/),),//'Enter Promo Code'),
              //               controller: myController,
              //               onSubmitted: (String newVal) {
              //                 /*prefs.setString("promovalue", newVal);
              //                       setState(() {
              //                         _checkpromo = true;
              //                         _promocode = newVal;
              //                       });*/
              //                 setState(() {
              //                   _checkpromo = true;
              //                 });
              //                 checkPromo();
              //               },),
              //           ),
              //           Spacer(),
              //           MouseRegion(
              //             cursor: SystemMouseCursors.click,
              //             child: GestureDetector(
              //               onTap: () {
              //                 setState(() {
              //                   _checkpromo = true;
              //                 });
              //                 checkPromo();
              //
              //               },
              //               // GestureDetector(
              //               //     onTap: () {
              //               //       _dialogForloyaltynote();
              //               //     },
              //               //     child: Image.asset(Images.icon_loyalty, width: 15,height: 15,color:Colors.red)),
              //               child: Container(
              //                 padding: EdgeInsets.only(left: 5,right: 5),
              //                 width: (MediaQuery.of(context).size.width / 5.1),
              //                 height: 60,
              //                 decoration: BoxDecoration(
              //                   color: ColorCodes.greenColor,
              //                   borderRadius: BorderRadius.circular(2.0),
              //                 ),
              //                 child: Center(
              //                     child:Text(
              //                       S .of(context).apply,
              //                       style: TextStyle(
              //                           fontSize: 19.0,
              //                           color: ColorCodes.whiteColor,
              //                           fontWeight: FontWeight.bold),
              //                     )
              //                   /*Icon(Icons.keyboard_arrow_right_sharp, size: 35, color: ColorCodes.greenColor,),*/),
              //               ),
              //             ),
              //           ),
              //
              //         ],
              //       ),
              //     ),
              //   ):
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  /*onTap: () {
                //_dialogforPromo(context);
              },*/
                  child: Container(
                    margin: EdgeInsets.only(left:15, right: 15, top: 5, bottom: 5),
                          // decoration: BoxDecoration(
                          //   color: Colors.white,
                          //   borderRadius: BorderRadius.all(Radius.circular(2.0)),
                          //   boxShadow: [
                          //     BoxShadow(
                          //       color: Colors.grey.withOpacity(0.4),
                          //       spreadRadius: 1,
                          //       blurRadius: 4,
                          //       offset: Offset(0, 1), // changes position of shadow
                          //     ),
                          //   ],
                          // ),
                    decoration: BoxDecoration(
                        color: ColorCodes.whiteColor,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border(
                          top: BorderSide(width: 1.0, color: ColorCodes.greylight,),
                          bottom: BorderSide(width: 1.0, color: ColorCodes.greylight,),
                          left: BorderSide(width: 1.0, color: ColorCodes.greylight,),
                          right: BorderSide(width: 1.0, color: ColorCodes.greylight,),
                        )),
                          padding: EdgeInsets.only(
                              top: 0.0, left: 10.0, right: 0.0, bottom: 0.0),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Image.asset(Images.appLoyalty, width: 24, height: 24, /*color: ColorCodes.blackColor*/),
                        SizedBox(
                          width: 10,
                        ),
                        (routeArgs['fromScreen'].toString() == "promocodeScreen")?
                        Container(
                          width: MediaQuery.of(context).size.width / 1.6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                routeArgs['promocode'],
                                style: TextStyle(fontSize: 16, color: ColorCodes.blackColor, fontWeight: FontWeight.bold),

                              ),
                              SizedBox(height: 5,),
                              Text(
                                S.of(context).offer_applied,//"Offer applied on the bill",

                                style: TextStyle(fontSize: 16, color: ColorCodes.blackColor, fontWeight: FontWeight.bold),

                              ),
                            ],
                          ),

                        )
                            :Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Text(
                            S.of(context).apply_coupon,//"Apply Coupon",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),

                        ),
                        Spacer(),
                        MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child:(routeArgs['fromScreen'].toString() == "promocodeScreen")?

                            GestureDetector(
                              onTap: (){
                              /*  Navigator.of(context).pushNamed(PaymentScreen.routeName,arguments: {
                                  'fromScreen':'',
                                  'responsejson':"",
                                  'minimumOrderAmountNoraml': routeArgs['minimumOrderAmountNoraml'],
                                  'deliveryChargeNormal': routeArgs['deliveryChargeNormal'],
                                  'minimumOrderAmountPrime': routeArgs['minimumOrderAmountPrime'],
                                  'deliveryChargePrime': routeArgs['deliveryChargePrime'],
                                  'minimumOrderAmountExpress': routeArgs['minimumOrderAmountExpress'],
                                  'deliveryChargeExpress': routeArgs['deliveryChargeExpress'],
                                  'deliveryType': routeArgs['deliveryType'],
                                  'addressId': PrefUtils.prefs.getString("addressId"),
                                  'note': routeArgs['note'],
                                  'deliveryCharge': routeArgs['deliveryCharge'],
                                  'deliveryDurationExpress' : routeArgs['minimumOrderAmountNoraml'],
                                });*/

                                Navigation(context, name: Routename.PaymentScreen, navigatore: NavigatoreTyp.Push,
                                    qparms: {
                                      'fromScreen':'',
                                      'responsejson':"",
                                      'minimumOrderAmountNoraml': routeArgs['minimumOrderAmountNoraml'],
                                      'deliveryChargeNormal': routeArgs['deliveryChargeNormal'],
                                      'minimumOrderAmountPrime': routeArgs['minimumOrderAmountPrime'],
                                      'deliveryChargePrime': routeArgs['deliveryChargePrime'],
                                      'minimumOrderAmountExpress': routeArgs['minimumOrderAmountPrime'],
                                      'deliveryChargeExpress': routeArgs['deliveryChargeExpress'],
                                      'deliveryType': routeArgs['deliveryType'],
                                      'addressId': PrefUtils.prefs!.getString("addressId"),
                                      'note': routeArgs['note'],
                                      'deliveryCharge':  routeArgs['deliveryCharge'],
                                      'deliveryDurationExpress' :  routeArgs['minimumOrderAmountNoraml'],
                                    });
                              },
                              child: Container(
                                  padding: EdgeInsets.only(left: 0,right: 0),
                                  width: (MediaQuery.of(context).size.width / 6.1),
                                  height: 60,
                                  child: Center(
                                      child:Text(/*"Remove"*/S.of(context).remove,style: TextStyle(
                                          color: ColorCodes.primaryColor,fontWeight: FontWeight.bold
                                        /*Icon(Icons.keyboard_arrow_right_sharp, size: 35, color: ColorCodes.greenColor,),*/),
                                      ))),
                            )

                                :GestureDetector(
                              onTap: () {
                                final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
                                Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?
                                PromocodeWeb(context,
                                    deliveryAmt:  widget.deliveryCharge.toString(),
                                    minimumOrderAmountNoraml: widget.minimumOrderAmountNoraml,
                                    deliveryChargeNormal: widget.deliveryChargeNormal,
                                    minimumOrderAmountPrime: widget.minimumOrderAmountPrime,
                                    deliveryChargePrime: widget.deliveryChargePrime,
                                    minimumOrderAmountExpress: widget.minimumOrderAmountExpress,
                                    deliveryChargeExpress: widget.deliveryChargeExpress,
                                    deliveryType: widget.deliveryType,
                                    addressId: PrefUtils.prefs!.getString("addressId"),
                                    note: widget.note,
                                    deliveryCharge: widget.deliveryCharge.toString(),
                                    deliveryDurationExpress : widget.deliveryDurationExpress,
                                )
                                    :
                                Navigation(context, name: Routename.PromocodeScreen, navigatore: NavigatoreTyp.Push,
                                    qparms: {
                                      "deliveryAmt":  widget.deliveryCharge.toString(),
                                      'minimumOrderAmountNoraml': /*routeArgs['minimumOrderAmountNoraml']*/widget.minimumOrderAmountNoraml,
                                      'deliveryChargeNormal': /*routeArgs['deliveryChargeNormal']*/widget.deliveryChargeNormal,
                                      'minimumOrderAmountPrime': /*routeArgs['minimumOrderAmountPrime']*/widget.minimumOrderAmountPrime,
                                      'deliveryChargePrime': /*routeArgs['deliveryChargePrime']*/widget.deliveryChargePrime,
                                      'minimumOrderAmountExpress': /*routeArgs['minimumOrderAmountPrime']*/widget.minimumOrderAmountExpress,
                                      'deliveryChargeExpress':/* routeArgs['deliveryChargeExpress']*/widget.deliveryChargeExpress,
                                      'deliveryType': /*routeArgs['deliveryType']*/widget.deliveryType,
                                      'addressId': PrefUtils.prefs!.getString("addressId"),
                                      'note': /*routeArgs['note']*/widget.note,
                                      'deliveryCharge': /* routeArgs['deliveryCharge']*/widget.deliveryCharge.toString(),
                                      'deliveryDurationExpress' : /* routeArgs['minimumOrderAmountNoraml']*/widget.deliveryDurationExpress,
                                    });

                                debugPrint("mini...."+widget.deliveryCharge.toString());
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 5,right: 5),
                              //  width: (MediaQuery.of(context).size.width / 5.1),
                                height: 60,
                                child: Center(
                                  child:Icon(Icons.keyboard_arrow_right_sharp, size: 35),
                                  /*Icon(Icons.keyboard_arrow_right_sharp, size: 35, color: ColorCodes.greenColor,),*/),
                              ),
                            )

                        ),

                      ],
                    ),
                  ),
                ):
                Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor,),
                  ),
                ):SizedBox.shrink(),
                (productBox.length == 1 && productBox[0].mode == 1)
                    ? SizedBox.shrink()
                    :

                Padding(
                  padding: const EdgeInsets.only(left:20.0,right:20.0),
                  child: Divider(
                    color: ColorCodes.whiteColor,
                    //thickness: 2.5,
                  ),
                ),
              ]
          ),
        );
      }

      Widget promocodeMethod() {
        if( deliverychargetext=="FREE"){

          if ((CartCalculations.totalmrp - (amountPayable-deliveryAmt)) > 0) {
            double savings=(CartCalculations.totalmrp - (amountPayable-deliveryAmt));
            return (CartCalculations.totalmrp - amountPayable) > 0 ?Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                DottedBorder(
                  padding: EdgeInsets.zero,
                  color: ColorCodes.blackColor,
                  //strokeWidth: 1,
                  dashPattern: [3.0],
                  child: Container(
                    padding: EdgeInsets.only(left: 6.0, right: 6.0),
                    height: 30.0,
                    //color: ColorCodes.lightBlueColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S .of(context).your_savings,//"Your savings",
                          style: TextStyle(
                              fontSize: 13.0,
                              color: ColorCodes.blackColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          Features.iscurrencyformatalign?
                          (CartCalculations.totalmrp - amountPayable).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) +
                              " " + IConstants.currencyFormat :
                          IConstants.currencyFormat +
                              " " +
                              (CartCalculations.totalmrp - amountPayable).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                          style: TextStyle(
                              fontSize: 13.0,
                              color: ColorCodes.blackColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                // Divider(color: ColorCodes.blackColor),
              ],
            ):
                SizedBox.shrink();
          } else {
            return Container();
          }
        }
        else{
          if ((CartCalculations.totalmrp - (amountPayable-deliveryAmt)) > 0) {
            double savings=(CartCalculations.totalmrp - (amountPayable-deliveryAmt));
            return Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                DottedBorder(
                  padding: EdgeInsets.zero,
                  color: ColorCodes.greenColor,
                  strokeWidth: 1,
                  dashPattern: [3.0],
                  child: Container(
                    padding: EdgeInsets.only(left: 6.0, right: 6.0),
                    height: 30.0,
                    //color: ColorCodes.lightBlueColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S .of(context).your_savings,//"Your savings",
                          style: TextStyle(
                              fontSize: 13.0,
                              color: ColorCodes.greenColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          Features.iscurrencyformatalign?
                         (CartCalculations.totalmrp - (amountPayable-deliveryAmt)).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) +
                             " " + IConstants.currencyFormat :
                          IConstants.currencyFormat +
                              " " + (CartCalculations.totalmrp - (amountPayable-deliveryAmt)).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                          style: TextStyle(
                              fontSize: 13.0,
                              color: ColorCodes.greenColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                //Divider(color: ColorCodes.blackColor),
              ],
            );
          } else {
            return Container();
          }}
      }

      void _handleRadioValueChange1(int value) {
        setState(() {
          _selectedIndex = value;
          _groupValue = value;
          _ischeckbox = false;
        });
      }

      Widget paymentDetails() {
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: ColorCodes.whiteColor,
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: ColorCodes.grey.withOpacity(0.3),
                  //     spreadRadius: 4,
                  //     blurRadius: 5,
                  //     offset: Offset(0, 3),
                  //   )
                  // ]
              ),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                  top: 5.0, left: 20.0, right: 20.0, bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Container(
                  //   margin: EdgeInsets.only(bottom: 16.0),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.end,
                  //     children: [
                  //       Text(
                  //         S .of(context).amount_payable,//"Amount Payable",
                  //         style: TextStyle(
                  //             fontSize: 15.0,
                  //             color: ColorCodes.blackColor,
                  //             fontWeight: FontWeight.bold),
                  //       ),
                  //       Text(
                  //       S .of(context).incl_tax,//"(Incl. of all taxes)",
                  //         style: TextStyle(
                  //             fontSize: 10.0, color: ColorCodes.blackColor),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width:  MediaQuery.of(context).size.width / 2.3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S .of(context).your_cart_value,//"Your cart value",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: ColorCodes.greyColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              DottedLine(
                                  dashColor: ColorCodes.lightgrey,
                                  lineThickness: 1.0,
                                  dashLength: 2.0,
                                  dashRadius: 0.0,
                                  dashGapLength: 1.0),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                S .of(context).payment_delivery_charge,//"Delivery charges",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: ColorCodes.greyColor,
                                    fontWeight: FontWeight.bold),

                              ),
                              // if (!_isPickup)
                            //   Container(
                            //     height:20,
                            //     child: Row(
                            //       children: [
                            //         Text(
                            //           S .of(context).payment_delivery_charge,//"Delivery charges",
                            //           style: TextStyle(
                            //               fontSize: 14.0,
                            //               color: ColorCodes.greyColor,
                            //               fontWeight: FontWeight.bold),
                            //
                            //         ),
                            //
                            //        (deliverychargetext != "FREE") ?
                            //         SimpleTooltip(
                            //           maxHeight: MediaQuery.of(context).size.width * 24.7/100,
                            //           borderColor: Theme.of(context).primaryColor,
                            //           tooltipTap: ()
                            //           {
                            //             setState(() {
                            //               _showDeliveryinfo = !_showDeliveryinfo;
                            //             }
                            //             );
                            //           },
                            //           hideOnTooltipTap: true,
                            //           show:_showDeliveryinfo ,
                            //           tooltipDirection: TooltipDirection.down,
                            //           ballonPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                            //           child:
                            //           IconButton(
                            //             padding: EdgeInsets.all(0),
                            //             icon:Icon(Icons.help_outline,size: 15,),
                            //             onPressed: (){
                            //               setState(() {
                            //                 _showDeliveryinfo = !_showDeliveryinfo;
                            //               }
                            //               );
                            //             },
                            //           ),
                            //           content: Container(child:Column(children:[
                            //             _checkmembership ? Text('Shop '+IConstants.currencyFormat+(minorderamount - Calculations.totalMember).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)+' more to get free delivery',
                            //               style: TextStyle(
                            //                   fontWeight: FontWeight.w500,
                            //                   color:Colors.black,
                            //                   fontStyle: FontStyle.normal,
                            //                   fontSize: 12,
                            //                   decoration: TextDecoration.none
                            //               ),
                            //             )
                            //                 :
                            //             Text('Shop '+IConstants.currencyFormat+(minorderamount - cartTotal).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)+' more to get free delivery',
                            //               style: TextStyle(
                            //                   fontWeight: FontWeight.w500,
                            //                   color:Colors.black,
                            //                   fontStyle: FontStyle.normal,
                            //                   fontSize: 12,
                            //                   decoration: TextDecoration.none
                            //               ),
                            //             ),
                            //             SizedBox(height: 3,),
                            //             GestureDetector(onTap:()
                            //             {
                            //               /*Navigator.of(context).pushNamed(
                            //                 CategoryScreen.routeName,
                            //               );*/
                            //               /*Navigator.of(context).pushNamedAndRemoveUntil(
                            //               '/home-screen', (Route<dynamic> route) => false);*/
                            //               Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
                            //
                            //             },
                            //                 child: Center(
                            //                   child:Text('Shop more',style: TextStyle(color:Color(0xffff3333),fontSize: 12,fontWeight: FontWeight.w500,decoration: TextDecoration.none),),))])),
                            //           arrowTipDistance: 2,
                            //           minimumOutSidePadding: 10,
                            //           arrowLength: 8,
                            //         )
                            //             :
                            //         SimpleTooltip(
                            //
                            //           ballonPadding: EdgeInsets.symmetric(vertical: 3,horizontal: 5),
                            //           tooltipTap: (){
                            //             setState(() {
                            //               _showDeliveryinfo = !_showDeliveryinfo;
                            //             });
                            //           },
                            //           //animationDuration: Duration(seconds: 3),
                            //           hideOnTooltipTap: true,
                            //           show:_showDeliveryinfo ,
                            //           arrowTipDistance: 0,
                            //           arrowLength: 5,
                            //           tooltipDirection: TooltipDirection.down,
                            //           child: IconButton(
                            //
                            //             padding: EdgeInsets.all(0),
                            //             icon:Icon(
                            //             Icons.help_outline,
                            //             size: 15,
                            //
                            //           ),onPressed: (){
                            //             setState(() {
                            //               _showDeliveryinfo = !_showDeliveryinfo;
                            //             });
                            //           },),
                            //           content: Text(
                            //             //S .of(context).yay_freedelivery,
                            //             'Yay!Free Delivery',
                            //             style: TextStyle(
                            //               fontSize: 12,
                            //               color: Colors.black54,
                            //               decoration: TextDecoration.none,
                            //             ),
                            //           ),
                            //           borderColor: Theme.of(context).primaryColor,
                            //         )
                            // //Icon(Icons.help_outline, color: Theme.of(context).primaryColor, size: 15.0,),
                            //       ],
                            //     ),
                            //   ),
                              // if (!_isPickup)
                              SizedBox(
                                height: 5.0,
                              ),
                              DottedLine(
                                  dashColor: ColorCodes.lightgrey,
                                  lineThickness: 1.0,
                                  dashLength: 2.0,
                                  dashRadius: 0.0,
                                  dashGapLength: 1.0),
                              SizedBox(
                                height: 5.0,
                              ),
                              if(!_checkmembership)
                              if ((CartCalculations.totalprice)  > 0)

                                Text(
                                  S .of(context).discount_applied,//"Discount applied:",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: ColorCodes.greyColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              /*if ((Calculations.totalmrp - cartTotal) > 0)
                                SizedBox(
                                  height: 10.0,
                                ),*/
                              if(!_checkmembership)
                              if ((CartCalculations.totalprice) > 0)
                                SizedBox(
                                  height: 5.0,
                                ),
                              if(!_checkmembership)
                              if ((CartCalculations.totalprice) > 0)
                                DottedLine(
                                    dashColor: ColorCodes.lightgrey,
                                    lineThickness: 1.0,
                                    dashLength: 2.0,
                                    dashRadius: 0.0,
                                    dashGapLength: 1.0),
                              if(!_checkmembership)
                              if ((CartCalculations.totalprice) > 0)
                                SizedBox(
                                  height: 5.0,
                                ),
                              if(_checkmembership)
                                if((CartCalculations.totalMembersPrice /*- Calculations.totalprice*/) > 0)
                                  Text(
                                    S .of(context).membership_savings,//"Membership savings:",
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: ColorCodes.greyColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                              if(_checkmembership)
                                if((CartCalculations.totalMembersPrice /*- Calculations.totalprice*/) > 0)
                                  SizedBox(
                                    height: 5.0,
                                  ),
                              if(_checkmembership)
                                if((CartCalculations.totalMembersPrice /*- Calculations.totalprice*/) > 0)
                                  DottedLine(
                                      dashColor: ColorCodes.lightgrey,
                                      lineThickness: 1.0,
                                      dashLength: 2.0,
                                      dashRadius: 0.0,
                                      dashGapLength: 1.0),
                              if(_checkmembership)
                                if((CartCalculations.totalMembersPrice /*- Calculations.totalprice*/) > 0)
                                  SizedBox(
                                    height: 5.0,
                                  ),

                              if (_displaypromo &&
                                  promomessage.toString().toLowerCase() !=
                                      'cashback')
                                new RichText(
                                  text: new TextSpan(
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: ColorCodes.greyColor,
                                        fontWeight: FontWeight.bold),
                                    children: <TextSpan>[
                                      new TextSpan(text: S .of(context).promo,//'Promo ('
                                      ),
                                      new TextSpan(
                                        text: _promocode,
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: ColorCodes.greyColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      new TextSpan(text: ')'),
                                    ],
                                  ),
                                ),
                              if (_displaypromo &&
                                  promomessage.toString().toLowerCase() !=
                                      'cashback')
                                SizedBox(
                                  height: 5.0,
                                ),
                              if (_displaypromo &&
                                  promomessage.toString().toLowerCase() !=
                                      'cashback')
                                DottedLine(
                                    dashColor: ColorCodes.lightgrey,
                                    lineThickness: 1.0,
                                    dashLength: 2.0,
                                    dashRadius: 0.0,
                                    dashGapLength: 1.0),
                              if (_displaypromo &&
                                  promomessage.toString().toLowerCase() !=
                                      'cashback')
                                SizedBox(
                                  height: 5.0,
                                ),
                              if (!_isLoyaltyToast &&
                                  _isSwitch &&
                                  _isLoayalty &&
                                  (double.parse(loyaltyPoints) > 0))
                                Text(
                                  S .of(context).you_saved + (S .of(context).coins) + ")",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color:
                                      ColorCodes.greyColor),
                                ),
                              if (!_isLoyaltyToast &&
                                  _isSwitch &&
                                  _isLoayalty &&
                                  (double.parse(loyaltyPoints) > 0))
                                SizedBox(
                                  height: 10.0,
                                ),
                              Text(
                                S .of(context).amount_payable,//"Amount payable:",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: ColorCodes.blackColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        /* Container(
                            child: VerticalDivider(
                                color: ColorCodes.greyColor)),*/
                        Container(
                          width:  MediaQuery.of(context).size.width / 4.7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                Features.iscurrencyformatalign?
                                CartCalculations.totalmrp.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)+
                                    " " + IConstants.currencyFormat :
                                IConstants.currencyFormat +
                                    " " +
                                    CartCalculations.totalmrp.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                style: TextStyle(
                                    fontSize: 13.0,
                                    color: ColorCodes.greyColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              // if (!_isPickup)
                              Text(
                                deliverychargetext!,
                                style: TextStyle(
                                    fontSize: 13.0, color: ColorCodes.greyColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              // if (!_isPickup)
                              SizedBox(
                                height: 10.0,
                              ),
                              if(!_checkmembership)
                              if ((CartCalculations.totalprice) > 0)
                                Text(
                                  "- " +
                                      (CartCalculations.totalmrp - cartTotal)
                                          .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      color: ColorCodes.greyColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              /*if ((Calculations.totalmrp - cartTotal) > 0)
                                SizedBox(
                                  height: 10.0,
                                ),*/
                              if(!_checkmembership)
                              if ((CartCalculations.totalprice) > 0)
                                SizedBox(
                                  height: 10.0,
                                ),
                              if(_checkmembership)
                                if((CartCalculations.totalMembersPrice /*- Calculations.totalprice*/) > 0)
                                  Text(
                                   "-"+ (/*Calculations.totalprice -*/ CartCalculations.totalMembersPrice)
                                        .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        color: ColorCodes.greyColor,
                                        fontWeight: FontWeight.bold),
                                  ),

                              if(_checkmembership)
                                if((CartCalculations.totalMembersPrice /*- Calculations.totalprice*/) > 0)
                                  SizedBox(
                                    height: 10.0,
                                  ),
                              if (_displaypromo &&
                                  promomessage.toString().toLowerCase() !=
                                      'cashback')
                                Text(
                                  Features.iscurrencyformatalign?
                                  "- " +
                                      double.parse(_savedamount)
                                          .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)+
                                      " " +IConstants.currencyFormat :
                                  "- " +
                                      IConstants.currencyFormat +
                                      " " +
                                      double.parse(_savedamount)
                                          .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      color: ColorCodes.greyColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              if (_displaypromo &&
                                  promomessage.toString().toLowerCase() !=
                                      'cashback')
                                SizedBox(
                                  height: 10.0,
                                ),
                              if (!_isLoyaltyToast &&
                                  _isSwitch &&
                                  _isLoayalty &&
                                  (double.parse(loyaltyPoints) > 0))
                                Text(
                                  Features.iscurrencyformatalign?"- " +
                                      loyaltyAmount.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) +
                                      " " + IConstants.currencyFormat :
                                  "- " +
                                      IConstants.currencyFormat +
                                      " " +
                                      loyaltyAmount.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      color: ColorCodes.greyColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              if (!_isLoyaltyToast &&
                                  _isSwitch &&
                                  _isLoayalty &&
                                  (double.parse(loyaltyPoints) > 0))
                                SizedBox(
                                  height: 10.0,
                                ),
                              Text(
                                Features.iscurrencyformatalign?
                                amountPayable.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) +
                                    " " + IConstants.currencyFormat :
                                IConstants.currencyFormat +
                                    " " +
                                    amountPayable.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold,
                                    color: ColorCodes.blackColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  // Divider(
                  //   color: ColorCodes.greyColor,
                  //   thickness: 0.8,
                  // ),

                  // promocodeMethod() goes here
                  promocodeMethod(),
                ],
              ),
            ),
            /*if(Features.isOffers)
              if(offersData.offers.length > 0)
                _offers(),*/
            // (productBox.length == 1 && productBox.values.elementAt(0).mode == 1)
            //     ? SizedBox.shrink()
            //     :
            //     (Features.isPromocode)?
            //     !_checkpromo?
            // GestureDetector(
            //   behavior: HitTestBehavior.translucent,
            //   /*onTap: () {
            //     //_dialogforPromo(context);
            //   },*/
            //   child: Padding(
            //     padding: const EdgeInsets.only(left:20.0,right:20),
            //     child: Material(
            //       elevation: 1,
            //       child: Container(
            //         padding: EdgeInsets.only(left: 15),
            //         decoration: BoxDecoration(
            //           color: ColorCodes.whiteColor,
            //           borderRadius: BorderRadius.circular(6)
            //         ),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: <Widget>[
            //             Container(
            //               width: 170,
            //               child: TextField(
            //                 decoration: InputDecoration(
            //                     border: InputBorder.none,
            //                     hintText: S .of(context).enter_promo),//'Enter Promo Code'),
            //                 controller: myController,
            //                 onSubmitted: (String newVal) {
            //                   /*prefs.setString("promovalue", newVal);
            //                             setState(() {
            //                               _checkpromo = true;
            //                               _promocode = newVal;
            //                             });*/
            //                   setState(() {
            //                     _checkpromo = true;
            //                   });
            //                   checkPromo();
            //                 },),
            //             ),
            //             MouseRegion(
            //               cursor: SystemMouseCursors.click,
            //               child: GestureDetector(
            //                 onTap: () {
            //                   setState(() {
            //                     _checkpromo = true;
            //                   });
            //                   checkPromo();
            //                 },
            //                 child: Container(
            //                   width: 100.0,
            //                   height: 48.0,
            //                   decoration: BoxDecoration(
            //                     color: Theme.of(context).primaryColor,
            //                     borderRadius: BorderRadius.circular(4.0),
            //                   ),
            //                   child: Center(
            //                       child: Text(
            //                         S .of(context).apply,//'Apply',
            //                         textAlign: TextAlign.center,
            //                         style: TextStyle(color: Colors.white),
            //                       )),
            //                 ),
            //               ),
            //             ),
            //
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ):
            //     Center(
            //       child: CircularProgressIndicator(
            //         valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor,),
            //       ),
            //     ):SizedBox.shrink(),
            // (productBox.length == 1 && productBox.values.elementAt(0).mode == 1)
            //     ? SizedBox.shrink()
            //     :
            //
            // Padding(
            //   padding: const EdgeInsets.only(left:20.0,right:20.0),
            //       child: Divider(
            //       color: ColorCodes.whiteColor,
            //   //thickness: 2.5,
            // ),
            //     ),
          ],
        );
      }

      Widget paymentSelection() {
        return Container(
          decoration: BoxDecoration(
            color: ColorCodes.whiteColor,
            // boxShadow: [
            //   BoxShadow(
            //     color: ColorCodes.grey.withOpacity(0.3),
            //     spreadRadius: 4,
            //     blurRadius: 5,
            //     offset: Offset(0, 3),
            //   )
            // ],
          ),
          child: Column(
            children: [
              // if (_isLoayalty && (double.parse(loyaltyPoints) > 0))
              //   GestureDetector(
              //     behavior: HitTestBehavior.translucent,
              //     onTap: () {
              //       setState(() {
              //         _isLoyaltyToast ?
              //         Fluttertoast.showToast(msg: S .of(context).minimum_order_amount/*"Minimum order amount should be "*/ + loyaltyData.itemsLoyalty[0].minimumOrderAmount.toString(),  fontSize: MediaQuery.of(context).textScaleFactor *13,backgroundColor: Colors.black87, textColor: Colors.white)
              //             :
              //         _isSwitch = !_isSwitch;
              //         if(_isWallet) {
              //           double totalAmount = 0.0;
              //           !_displaypromo ? /*_isPickup ? totalAmount = cartTotal :*/ totalAmount = (cartTotal + deliveryAmt) : totalAmount = (double.parse(_promoamount));
              //
              //           if (int.parse(walletbalance) <= 0 /*|| double.parse((cartTotal + deliveryamount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)) > int.parse(walletbalance)*/) {
              //             _isRemainingAmount = false;
              //             _ischeckboxshow = false;
              //             _ischeckbox = false;
              //           } else if (_isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0) ? totalAmount <= (int.parse(walletbalance) + loyaltyAmount) : totalAmount <= (int.parse(walletbalance))) {
              //             _isRemainingAmount = false;
              //             _groupValue = -1;
              //             PrefUtils.prefs!.setString("payment_type", "wallet");
              //             walletAmount = _isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0) ? (totalAmount - loyaltyAmount) : totalAmount;
              //           } else if (_isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0) ? totalAmount > (int.parse(walletbalance) + loyaltyAmount) : totalAmount > int.parse(walletbalance)) {
              //             bool _isOnline = false;
              //             for(int i = 0; i < paymentData.itemspayment.length; i++) {
              //               if(paymentData.itemspayment[i].paymentMode == "1") {
              //                 _groupValue = i;
              //                 _isOnline = true;
              //                 break;
              //               }
              //             }
              //             if(_isOnline) {
              //               _groupValue = -1;
              //               _isRemainingAmount = true;
              //               walletAmount = double.parse(walletbalance);
              //               remainingAmount = _isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0) ? totalAmount - double.parse(walletbalance) - loyaltyAmount: (totalAmount - int.parse(walletbalance));
              //             } else {
              //               _isWallet = false;
              //               _ischeckbox = false;
              //             }
              //             for(int i = 0; i < paymentData.itemspayment.length; i++) {
              //               if(paymentData.itemspayment[i].paymentMode == "1") {
              //                 _groupValue = i;
              //                 break;
              //               }
              //             }
              //           }
              //         } else {
              //           _ischeckbox = false;
              //         }
              //       });
              //     },
              //     child: Container(
              //       width: MediaQuery.of(context).size.width,
              //       color: ColorCodes.whiteColor,
              //       padding: EdgeInsets.only(
              //           top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: <Widget>[
              //           Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text(
              //                 S .of(context).pay_using_supercoin,//"Pay Using Saving Coins",
              //                 style: TextStyle(
              //                     color: ColorCodes.blackColor,
              //                     fontWeight: FontWeight.bold),
              //               ),
              //               Row(
              //                 children: [
              //                   Text(
              //                     S .of(context).balance,//"Balance:  ",
              //                     style: TextStyle(
              //                         color: ColorCodes.blackColor, fontSize: 10.0),
              //                   ),
              //                   Image.asset(
              //                     Images.coinImg,
              //                     height: 10.0,
              //                     width: 12.0,
              //                   ),
              //                   Text(
              //                     loyaltyPoints,
              //                     style: TextStyle(
              //                         color: ColorCodes.blackColor, fontSize: 10.0),
              //                   ),
              //                 ],
              //               ),
              //             ],
              //           ),
              //           GestureDetector(
              //             behavior: HitTestBehavior.translucent,
              //             onTap: () {
              //               setState(() {
              //                 _isLoyaltyToast ?
              //                 Fluttertoast.showToast(msg: S .of(context).minimum_order_amount/*"Minimum order amount should be "*/ + loyaltyData.itemsLoyalty[0].minimumOrderAmount.toString(),  fontSize: MediaQuery.of(context).textScaleFactor *13,backgroundColor: Colors.black87, textColor: Colors.white)
              //                     :
              //                 _isSwitch = !_isSwitch;
              //                 if(_isWallet) {
              //                   double totalAmount = 0.0;
              //                   !_displaypromo ? /*_isPickup ? totalAmount = cartTotal :*/ totalAmount = (cartTotal + deliveryAmt) : totalAmount = (double.parse(_promoamount));
              //
              //                   if (int.parse(walletbalance) <= 0 /*|| double.parse((cartTotal + deliveryamount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)) > int.parse(walletbalance)*/) {
              //                     _isRemainingAmount = false;
              //                     _ischeckboxshow = false;
              //                     _ischeckbox = false;
              //                   } else if (_isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0) ? totalAmount <= (int.parse(walletbalance) + loyaltyAmount) : totalAmount <= (int.parse(walletbalance))) {
              //                     _isRemainingAmount = false;
              //                     _groupValue = -1;
              //                     PrefUtils.prefs!.setString("payment_type", "wallet");
              //                     walletAmount = _isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0) ? (totalAmount - loyaltyAmount) : totalAmount;
              //                   } else if (_isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0) ? totalAmount > (int.parse(walletbalance) + loyaltyAmount) : totalAmount > int.parse(walletbalance)) {
              //                     bool _isOnline = false;
              //                     for(int i = 0; i < paymentData.itemspayment.length; i++) {
              //                       if(paymentData.itemspayment[i].paymentMode == "1") {
              //                         _groupValue = i;
              //                         _isOnline = true;
              //                         break;
              //                       }
              //                     }
              //                     if(_isOnline) {
              //                       _groupValue = -1;
              //                       _isRemainingAmount = true;
              //                       walletAmount = double.parse(walletbalance);
              //                       remainingAmount = _isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0) ? totalAmount - double.parse(walletbalance) - loyaltyAmount: (totalAmount - int.parse(walletbalance));
              //                     } else {
              //                       _isWallet = false;
              //                       _ischeckbox = false;
              //                     }
              //                     for(int i = 0; i < paymentData.itemspayment.length; i++) {
              //                       if(paymentData.itemspayment[i].paymentMode == "1") {
              //                         _groupValue = i;
              //                         break;
              //                       }
              //                     }
              //                   }
              //                 } else {
              //                   _ischeckbox = false;
              //                 }
              //               });
              //             },
              //             child: Row(
              //               children: [
              //                 Image.asset(
              //                   Images.coinImg,
              //                   height: 12.0,
              //                   width: 14.0,
              //                 ),
              //                 Text(
              //                   " " +
              //                       loyaltyPointsUser
              //                           .roundToDouble()
              //                           .toStringAsFixed(0),
              //                   style: TextStyle(
              //                       color: ColorCodes.blackColor, fontSize: 12.0),
              //                 ),
              //                 SizedBox(width: 20.0),
              //                 _isLoyaltyToast
              //                     ? Icon(
              //                   Icons.radio_button_off,
              //                   size: 20.0,
              //                 )
              //                     : _isSwitch
              //                     ? Container(
              //                   width: 20.0,
              //                   height: 20.0,
              //                   decoration: BoxDecoration(
              //                     color: ColorCodes.whiteColor,
              //                     border: Border.all(
              //                       color: ColorCodes.darkthemeColor,
              //                     ),
              //                     shape: BoxShape.circle,
              //                   ),
              //                   child: Container(
              //                     margin: EdgeInsets.all(1.5),
              //                     decoration: BoxDecoration(
              //                       color: ColorCodes.mediumBlueColor,
              //                       shape: BoxShape.circle,
              //                     ),
              //                     child: Icon(Icons.check,
              //                         color: ColorCodes.whiteColor,
              //                         size: 15.0),
              //                   ),
              //                 )
              //                     : Icon(
              //                   Icons.radio_button_off,
              //                   size: 20.0,
              //                 )
              //               ],
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // if (_isLoayalty && (double.parse(loyaltyPoints) > 0))
              //   Padding(
              //     padding: const EdgeInsets.only(left:20.0,right:20.0),
              //     child: Divider(
              //       color: ColorCodes.lightGreyColor,
              //       //thickness: 2.5,
              //     ),
              //   ),
              // if (_isPaymentMethod)
              //   if (_isWallet)
              //     _ischeckboxshow
              //         ? GestureDetector(
              //       behavior: HitTestBehavior.translucent,
              //       onTap: () {
              //         setState(() {
              //           _ischeckbox = !_ischeckbox;
              //           double totalAmount = 0.0;
              //           !_displaypromo ? /*_isPickup ? totalAmount = cartTotal :*/ totalAmount = (cartTotal + deliveryAmt) : totalAmount = (double.parse(_promoamount));
              //           if(_isWallet) {
              //             if (int.parse(walletbalance) <= 0 /*|| double.parse((cartTotal + deliveryamount).toStringAsFixed(IConstants.decimaldigit)) > int.parse(walletbalance)*/) {
              //               _isRemainingAmount = false;
              //               _ischeckboxshow = false;
              //               _ischeckbox = false;
              //             } else if (_isSwitch ? totalAmount <= (int.parse(walletbalance) + loyaltyAmount) : totalAmount <= (int.parse(walletbalance))) {
              //               _isRemainingAmount = false;
              //               _groupValue = -1;
              //               PrefUtils.prefs!.setString("payment_type", "wallet");
              //               walletAmount = _isSwitch ? (totalAmount - loyaltyAmount) : totalAmount;
              //             } else if (_isSwitch ? totalAmount > (int.parse(walletbalance) + loyaltyAmount) : totalAmount > int.parse(walletbalance)) {
              //               bool _isOnline = false;
              //               for(int i = 0; i < paymentData.itemspayment.length; i++) {
              //                 if(paymentData.itemspayment[i].paymentMode == "1") {
              //                   _isOnline = true;
              //                   break;
              //                 }
              //               }
              //               if(_isOnline) {
              //                 _groupValue = -1;
              //                 _isRemainingAmount = true;
              //                 walletAmount = double.parse(walletbalance);
              //                 remainingAmount = _isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0) ? totalAmount - double.parse(walletbalance) - loyaltyAmount: (totalAmount - int.parse(walletbalance));
              //               } else {
              //                 _isWallet = false;
              //                 _ischeckbox = false;
              //               }
              //               for(int i = 0; i < paymentData.itemspayment.length; i++) {
              //                 if(paymentData.itemspayment[i].paymentMode == "1") {
              //                   _groupValue = i;
              //                   break;
              //                 }
              //               }
              //
              //             }
              //           } else {
              //             _ischeckbox = false;
              //           }
              //         });
              //       },
              //       child: Container(
              //         width: MediaQuery.of(context).size.width,
              //         color: ColorCodes.whiteColor,
              //         padding: EdgeInsets.only(
              //             top: 20.0, left: 20.0, right: 20.0, bottom: 20.0),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: <Widget>[
              //             Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Text(
              //                   IConstants.APP_NAME + " "+  S .of(context).wallet,//" Wallet",
              //                   style: TextStyle(
              //                       color: ColorCodes.blackColor,
              //                       fontWeight: FontWeight.bold),
              //                 ),
              //                 Row(
              //                   children: [
              //                     Text(
              //                     S .of(context).balance,    //"Balance:  ",
              //                       style: TextStyle(
              //                           color: ColorCodes.blackColor,
              //                           fontSize: 10.0),
              //                     ),
              //                     Image.asset(Images.walletImg,
              //                         height: 13.0,
              //                         width: 16.0,
              //                         color: ColorCodes.darkthemeColor),
              //                     SizedBox(
              //                       width: 5.0,
              //                     ),
              //                     Text(
              //                       IConstants.currencyFormat + " " + walletbalance,
              //                       style: TextStyle(
              //                           color: ColorCodes.blackColor,
              //                           fontSize: 10.0),
              //                     ),
              //                   ],
              //                 ),
              //               ],
              //             ),
              //             GestureDetector(
              //               behavior: HitTestBehavior.translucent,
              //               onTap: () {
              //                 setState(() {
              //                   _ischeckbox = !_ischeckbox;
              //                   double totalAmount = 0.0;
              //                   !_displaypromo ? /*_isPickup ? totalAmount = cartTotal :*/ totalAmount = (cartTotal + deliveryAmt) : totalAmount = (double.parse(_promoamount));
              //                   if(_isWallet) {
              //                     if (int.parse(walletbalance) <= 0 /*|| double.parse((cartTotal + deliveryamount).toStringAsFixed(IConstants.decimaldigit)) > int.parse(walletbalance)*/) {
              //                       _isRemainingAmount = false;
              //                       _ischeckboxshow = false;
              //                       _ischeckbox = false;
              //                     } else if (_isSwitch ? totalAmount <= (int.parse(walletbalance) + loyaltyAmount) : totalAmount <= (int.parse(walletbalance))) {
              //                       _isRemainingAmount = false;
              //                       _groupValue = -1;
              //                       PrefUtils.prefs!.setString("payment_type", "wallet");
              //                       walletAmount = _isSwitch ? (totalAmount - loyaltyAmount) : totalAmount;
              //                     } else if (_isSwitch ? totalAmount > (int.parse(walletbalance) + loyaltyAmount) : totalAmount > int.parse(walletbalance)) {
              //                       bool _isOnline = false;
              //                       for(int i = 0; i < paymentData.itemspayment.length; i++) {
              //                         if(paymentData.itemspayment[i].paymentMode == "1") {
              //                           _isOnline = true;
              //                           break;
              //                         }
              //                       }
              //                       if(_isOnline) {
              //                         _groupValue = -1;
              //                         _isRemainingAmount = true;
              //                         walletAmount = double.parse(walletbalance);
              //                         remainingAmount = _isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0) ? totalAmount - double.parse(walletbalance) - loyaltyAmount: (totalAmount - int.parse(walletbalance));
              //                       } else {
              //                         _isWallet = false;
              //                         _ischeckbox = false;
              //                       }
              //                       for(int i = 0; i < paymentData.itemspayment.length; i++) {
              //                         if(paymentData.itemspayment[i].paymentMode == "1") {
              //                           _groupValue = i;
              //                           break;
              //                         }
              //                       }
              //
              //                     }
              //                   } else {
              //                     _ischeckbox = false;
              //                   }
              //                 });
              //               },
              //               child: Row(
              //                 children: [
              //                   if (_ischeckboxshow && _ischeckbox)
              //                     Image.asset(Images.walletImg,
              //                         height: 15.0,
              //                         width: 18.0,
              //                         color: ColorCodes.darkthemeColor),
              //                   if (_ischeckboxshow && _ischeckbox)
              //                     SizedBox(
              //                       width: 5.0,
              //                     ),
              //                   if (_ischeckboxshow && _ischeckbox)
              //                     Text(
              //                       IConstants.currencyFormat +
              //                           " " +
              //                           walletAmount.toStringAsFixed(IConstants.decimaldigit),
              //                       style: TextStyle(
              //                           color: ColorCodes.blackColor,
              //                           fontSize: 12.0),
              //                     ),
              //                   SizedBox(width: 20.0),
              //                   _ischeckbox
              //                       ? Icon(
              //                     Icons.radio_button_checked,
              //                     size: 20.0,
              //                     color: ColorCodes.mediumBlueColor,
              //                   )
              //                       : Icon(
              //                     Icons.radio_button_off,
              //                     size: 20.0,
              //                   )
              //                 ],
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     )
              //         : Container(
              //       width: MediaQuery.of(context).size.width,
              //       padding: EdgeInsets.only(
              //           top: 20.0, left: 20.0, right: 20.0, bottom: 20.0),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: <Widget>[
              //           Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text(
              //                 IConstants.APP_NAME + " "+ S .of(context).wallet,//" Wallet",
              //                 style: TextStyle(
              //                     color: ColorCodes.greyColor,
              //                     fontWeight: FontWeight.bold),
              //               ),
              //               Row(
              //                 children: [
              //                   Text(
              //                     S .of(context).balance,    //"Balance:  ",
              //                     style: TextStyle(
              //                         color: ColorCodes.greyColor,
              //                         fontSize: 10.0),
              //                   ),
              //                   SizedBox(
              //                     height: 2.0,
              //                   ),
              //                   Image.asset(Images.walletImg,
              //                       height: 13.0,
              //                       width: 16.0,
              //                       color: ColorCodes.darkthemeColor),
              //                   SizedBox(
              //                     width: 5.0,
              //                   ),
              //                   Text(
              //                     IConstants.currencyFormat + " " + walletbalance,
              //                     style: TextStyle(
              //                         color: ColorCodes.greyColor,
              //                         fontSize: 10.0),
              //                   ),
              //                 ],
              //               ),
              //             ],
              //           ),
              //           Row(
              //             children: [
              //               Icon(Icons.radio_button_off,
              //                   size: 20.0, color: ColorCodes.greyColor)
              //             ],
              //           ),
              //         ],
              //       ),
              //     ),
              // if (_isPaymentMethod)
              //   if (_isWallet)
              //     Padding(
              //       padding: const EdgeInsets.only(left:20.0,right:20.0),
              //       child: Divider(
              //         color: ColorCodes.lightGreyColor,
              //       ),
              //     ),
              _isPaymentMethod
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(
                          top: 10.0, left: 20.0, right: 20.0, bottom: 5.0),
                      child: Text(
                        S .of(context).payment_option,//"Payment Method",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: ColorCodes.blackColor,
                            fontWeight: FontWeight.bold),
                      )),
                  new ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: paymentData.itemspayment.length,
                    itemBuilder: (_, i) => Column(
                      children: [
                        if (paymentData.itemspayment[i].paymentMode ==
                            "1")
                          _isRemainingAmount
                              ? GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: (){
                              _handleRadioValueChange1(i);
                            },
                            child: Container(
                              width:
                              MediaQuery.of(context).size.width,
                              padding: EdgeInsets.only(
                                  top: 10.0,
                                  left: 20.0,
                                  right: 20.0,
                                  bottom: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        paymentData.itemspayment[i]
                                            .paymentName,
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                            color: ColorCodes
                                                .blackColor),
                                      ),
                                      Image.asset(Images.onlineImg, height: 24),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        Features.iscurrencyformatalign?
                                        remainingAmount
                                                .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) +
                                            " " + IConstants.currencyFormat :
                                          IConstants.currencyFormat +
                                              " " +
                                              remainingAmount
                                                  .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                          style: TextStyle(
                                              color: ColorCodes
                                                  .blackColor,
                                              fontSize: 12.0)),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      handler(i),
                                      // SizedBox(
                                      //   width: 20.0,
                                      //   child: _myRadioButton(
                                      //     title: "",
                                      //     value: i,
                                      //     onChanged: (newValue) {
                                      //       setState(() {
                                      //         _groupValue = newValue!;
                                      //         _ischeckbox = false;
                                      //       });
                                      //     },
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                              : GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: (){
                              _handleRadioValueChange1(Features.isMembership && (_checkmembership)?0:i);
                            },
                            child: Container(
                              width:
                              MediaQuery.of(context).size.width,
                              padding: EdgeInsets.only(
                                  top: 10,
                                  left: 20.0,
                                  right: 20.0,
                                  bottom: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        paymentData.itemspayment[i]
                                            .paymentName,
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                            color: ColorCodes.blackColor),
                                      ),
                                      SizedBox(height: 10),
                                      Image.asset(Images.onlineImg, height: 24),
                                    ],
                                  ),
                                  handler(Features.isMembership && (_checkmembership)?0:i),
                                  // SizedBox(
                                  //   width: 15.0,
                                  //   child: _myRadioButton(
                                  //     title: "",
                                  //     value: i,
                                  //     onChanged: (newValue) {
                                  //       setState(() {
                                  //         _groupValue = newValue!;
                                  //         _ischeckbox = false;
                                  //       });
                                  //     },
                                  //   ),
                                  // )
                                ],
                              ),
                            ),
                          ),
                        if (paymentData.itemspayment[i].paymentMode ==
                            "7")
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: (){
                              _handleRadioValueChange1(i);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.only(
                                  top: 10,
                                  left: 35.0,
                                  right: 35.0,
                                  bottom: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  // Image.asset(Images.sodexoImg, width: 35, height: 35),
                                  // SizedBox(width: 5),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        // Row(
                                        //   children: [
                                        //     Text(
                                        //       paymentData
                                        //           .itemspayment[i].paymentName,
                                        //       style: TextStyle(
                                        //           fontSize: 14.0,
                                        //           fontWeight: FontWeight.bold,
                                        //           color: ColorCodes
                                        //               .greyColor),
                                        //     ),
                                        //   ],
                                        // ),
                                        // SizedBox(height: 5),
                                        Image.asset(Images.sodexoImg, height: 25),
                                        // SizedBox(
                                        //   height: 10.0,
                                        // ),
                                        // Row(
                                        //   children: [
                                        //     Image.asset(
                                        //         Images.cardMachineImg),
                                        //     SizedBox(width: 10.0),
                                        //     Expanded(
                                        //         child: Text(
                                        //         S .of(context).our_delivery_personnel,//"Our delivery personnel will carry a swipe machine & orders can be paid via Debit/Credit card at the time of delivery.",
                                        //           style: TextStyle(
                                        //               fontSize: 12.0,
                                        //               color:
                                        //               ColorCodes.greyColor),
                                        //         )),
                                        //     SizedBox(width: 50.0),
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                  ),
                                  handler(i)
                                  // SizedBox(
                                  //   width: 15.0,
                                  //   child: _myRadioButton(
                                  //     title: "",
                                  //     value: i,
                                  //     onChanged: (newValue) {
                                  //       setState(() {
                                  //         _groupValue = newValue!;
                                  //         _ischeckbox = false;
                                  //       });
                                  //     },
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        if (paymentData.itemspayment[i].paymentMode ==
                            "0")
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: (){
                              _handleRadioValueChange1(i);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.only(
                                  top: 10.0,
                                  left: 20.0,
                                  right: 20.0,
                                  bottom: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(Images.walletImg, color:ColorCodes.blackColor,width: 28, height: 28),
                                            SizedBox(width: 10),
                                            Text(
                                              paymentData
                                                  .itemspayment[i].paymentName,
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: ColorCodes
                                                      .blackColor),
                                            ),
                                          ],
                                        ),
                                        // SizedBox(
                                        //   height: 10.0,
                                        // ),
                                        // Row(
                                        //   children: [
                                        //     Image.asset(
                                        //         Images.cardMachineImg),
                                        //     SizedBox(width: 10.0),
                                        //     Expanded(
                                        //         child: Text(
                                        //         S .of(context).our_delivery_personnel,//"Our delivery personnel will carry a swipe machine & orders can be paid via Debit/Credit card at the time of delivery.",
                                        //           style: TextStyle(
                                        //               fontSize: 12.0,
                                        //               color:
                                        //               ColorCodes.greyColor),
                                        //         )),
                                        //     SizedBox(width: 50.0),
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                  ),
                                  handler(i),
                                  // SizedBox(
                                  //   width: 15.0,
                                  //   child: _myRadioButton(
                                  //     title: "",
                                  //     value: i,
                                  //     onChanged: (newValue) {
                                  //       setState(() {
                                  //         _groupValue = newValue!;
                                  //         _ischeckbox = false;
                                  //       });
                                  //     },
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        if (paymentData.itemspayment[i].paymentMode == "6")
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: (){
                              _handleRadioValueChange1(i);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.only(
                                  left: 20.0, right: 20.0, bottom: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(Images.cashImg, color:ColorCodes.blackColor,width: 35, height: 35),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: Container(
                                      width:
                                      MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.only(
                                          top: 10.0,
                                          /* left: 20.0,
                                            right: 20.0,*/
                                          bottom: 10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            S .of(context).cash_delivery,//"Cash on Delivery",//"Cash",
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                ColorCodes.blackColor),
                                          ),
                                          // SizedBox(
                                          //   height: 10.0,
                                          // ),
                                          // Row(
                                          //   children: [
                                          //     Image.asset(
                                          //       Images.cashImg,
                                          //       width: 26.0,
                                          //       height: 26.0,
                                          //     ),
                                          //     SizedBox(width: 10.0),
                                          //     Expanded(
                                          //         child: Text(
                                          //           S .of(context).tips_to_ensure,//"Tip: To ensure a contactless delivery, we recommend you use an online payment method.",
                                          //           style: TextStyle(
                                          //               fontSize: 12.0,
                                          //               color: ColorCodes
                                          //                   .greyColor),
                                          //         )),
                                          //     SizedBox(width: 50.0),
                                          //   ],
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  handler(i)
                                  // SizedBox(
                                  //   width: 15.0,
                                  //   child: _myRadioButton(
                                  //     title: "",
                                  //     value: i,
                                  //     onChanged: (newValue) {
                                  //       setState(() {
                                  //         _groupValue = newValue!;
                                  //         _ischeckbox = false;
                                  //       });
                                  //     },
                                  //   ),
                                  // )
                                ],
                              ),
                            ),
                          ),
                        if (paymentData.itemspayment[i].paymentMode == "6" || paymentData.itemspayment[i].paymentMode ==
                            "0" || paymentData.itemspayment[i].paymentMode == "1")
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: DottedLine(
                                dashColor: ColorCodes.lightGreyColor,
                                lineThickness: 1.0,
                                dashLength: 2.0,
                                dashRadius: 0.0,
                                dashGapLength: 1.0),
                          ),
                      ],
                    ),
                  ),
                  (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
                      ? !_isPaymentMethod
                      ? GestureDetector(
                    onTap: () {
                      Fluttertoast.showToast(
                        msg:
                        S .of(context).currently_no_payment,//"currently there are no payment methods available",
                        fontSize: MediaQuery.of(context).textScaleFactor *13,);
                    },
                    child: Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 10),
                      color: Theme.of(context).primaryColor,
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: Center(
                        child: Text(
                          S .of(context).proceed_pay,//'PROCEED TO PAY',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                      : GestureDetector(
                    onTap: () {
                      if (!_ischeckbox && _groupValue == -1) {
                        Fluttertoast.showToast(
                          msg:
                          S .of(context).please_select_paymentmenthods,//"Please select a payment method!!!",
                          fontSize: MediaQuery.of(context).textScaleFactor *13,);
                      } else {
                        if (_ischeckbox && _isRemainingAmount) {
                          PrefUtils.prefs!.setString(
                              "payment_type", "paytm");
                          //prefs.setString("amount", walletbalance);
                          PrefUtils.prefs!.setString("amount",
                              walletAmount.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit));
                          PrefUtils.prefs!.setString("wallet_type", "0");
                        } else if (_ischeckbox) {
                          PrefUtils.prefs!.setString(
                              "payment_type", "wallet");
                          //prefs.setString("amount", (cartTotal + deliveryamount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit));
                          PrefUtils.prefs!.setString("amount",
                              walletAmount.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit));
                          PrefUtils.prefs!.setString("wallet_type", "0");
                        }
                        _dialogforOrdering(context);

                        if(_slots){
                          if(_isPickup){
                            Orderfood();
                          }else {
                            if(Features.isSplit){
                              OrderfoodSplit();
                            }else{
                              Orderfood();
                            }
                          }
                        }else{
                          Orderfood();
                        }

                       // (_slots ) ? _isPickup ? Orderfood(): Features.isSplit ? OrderfoodSplit() : Orderfood() :OrderfoodSplit();
                        /*if(Features.isOffers) {
                          if (offersData.offers.length > 0) {
                            _addToCart();
                          } else {
                           (_slots ) ? _isPickup ? Orderfood(): Features.isSplit ? OrderfoodSplit() : Orderfood() :OrderfoodSplit();
                          }
                        }else{
                         (_slots ) ? _isPickup ? Orderfood(): Features.isSplit ? OrderfoodSplit() : Orderfood() :OrderfoodSplit();
                        }*/
                        /*if(offersData.offers.length > 0) {
                          _addToCart();
                        } else {
                          Orderfood();
                        }*/
                        /*if(prefs.containsKey("orderId")) {
                                          _cancelOrder().then((value) async {
                                            Orderfood();
                                          });
                                        } else {
                                          Orderfood();
                                        }*/
                      }
                    },
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      padding:
                      EdgeInsets.symmetric(horizontal: 10),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: Center(
                        child: Text(
                          S .of(context).proceed_pay,//'PROCEED TO PAY',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                      : SizedBox.shrink(),
                  SizedBox(
                    height: 20,
                  ),
                ],
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    S .of(context).no_payment,//"Currently there is no payment methods",
                    style: TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        );
      }

      if (!_displaypromo) {
        /*if (_isPickup) {
          if (_isSwitch &&
              !_isLoyaltyToast &&
              _isLoayalty &&
              (double.parse(loyaltyPoints) > 0)) {
            amountPayable = (cartTotal - loyaltyAmount).roundToDouble();
          } else {
            amountPayable = cartTotal;
          }
        } else*/ {
          // else statement for _isPickup
          if (_isSwitch &&
              !_isLoyaltyToast &&
              _isLoayalty &&
              (double.parse(loyaltyPoints) > 0)) {
            amountPayable =
                (cartTotal + deliveryAmt - loyaltyAmount);//.roundToDouble();
          } else {
            amountPayable = (cartTotal + deliveryAmt);
          }
        }
      } else {
        //else statement for !_displaypromo
        /*  if (_isPickup) {
          if (_isSwitch &&
              !_isLoyaltyToast &&
              _isLoayalty &&
              (double.parse(loyaltyPoints) > 0)) {
            amountPayable =
                (cartTotal - double.parse(_savedamount) - loyaltyAmount)
                    .roundToDouble();
          } else {
            amountPayable = (cartTotal - double.parse(_savedamount));
          }
        } else*/ {
          // else statement for _isPickup
          if (_isSwitch && !_isLoyaltyToast && _isLoayalty && (double.parse(loyaltyPoints) > 0)) {
            amountPayable = (promomessage.toLowerCase() == 'cashback') ?
            (cartTotal + deliveryAmt - loyaltyAmount)
                :
            (cartTotal + deliveryAmt - double.parse(_savedamount) - loyaltyAmount);
            //.roundToDouble();
          } else {
            amountPayable = (promomessage.toLowerCase() == 'cashback') ?
            (cartTotal + deliveryAmt) :
            (cartTotal + deliveryAmt - double.parse(_savedamount));
          }
        }
      }

      return _isLoading
          ? Expanded(
        child: Center(
          child: PaymnetOption(),
        ),
      )
          : Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              IConstants.isEnterprise && Features.ismultivendor?
           Container(
             width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
          color: ColorCodes.whiteColor,
          ),
             child: Padding(
               padding: EdgeInsets.only(left:15, right: 15, top: 5, bottom: 5),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(S.of(context).select_payment_method,
                     style: TextStyle(
                         fontSize: 19,
                         color: ColorCodes.blackColor,
                         fontWeight: FontWeight.bold
                   ),),
                   Padding(
                     padding: const EdgeInsets.only(top:8.0,bottom: 8),
                     child: Row(
                       children: [
                         Text(S.of(context).item_total +" ",
                         style: TextStyle(
                             fontSize: 16,
                             color: ColorCodes.greyColor,
                             //fontWeight: FontWeight.bold
                         ),),
                         Text( Features.iscurrencyformatalign?
                         amountPayable.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) +
                             " " + IConstants.currencyFormat :
                         IConstants.currencyFormat +
                             " " +
                             amountPayable.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                             style:TextStyle(
                               fontSize: 16,
                               color: ColorCodes.greyColor,
                               //fontWeight: FontWeight.bold
                             )),
                         SizedBox(
                           height:15,
                           child: VerticalDivider(
                             color: ColorCodes.greyColor,
                           ),
                         ),

                         Text(CartCalculations.itemCount.toString() +" " + S.of(context).items,
                         style: TextStyle(
                             fontSize: 16,
                             color: ColorCodes.greyColor,
                             //fontWeight: FontWeight.bold
                         ),),
                       ],
                     ),
                   )

                 ],
               ),
             ),
        ):
                  SizedBox.shrink(),
              Container(
                color:  ColorCodes.whiteColor,
                height: 12,
              ),
              paymentMode(),
              Container(
                color:  ColorCodes.whiteColor,
                height: 15,
              ),
              paymentDetails(),
              Container(
                color:  ColorCodes.whiteColor,
                height: 15,
              ),
              paymentSelection(),
              // if (_isWeb)
              //   Footer(address: _address),
            ],
          ),
        ),
      );
    }

    return WillPopScope(
        onWillPop: () {
      // this is the block you need
      /* Navigator.pushNamedAndRemoveUntil(
            context, CartScreen.routeName, (route) => false);*/
     // removeToCart(0);
      //Navigator.of(context).pop();
          (Features.ismultivendor)?
          Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":""}):
          widget.fromScreen == "cartscreen"?
          Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":""}):
          widget.fromScreen == "pickupscreen" ?
          Navigation(context, name: Routename.PickupScreen, navigatore: NavigatoreTyp.Push) :
          Navigation(context, name:Routename.ConfirmOrder,navigatore: NavigatoreTyp.Push,
              parms:{"prev": "payment"});
          final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

            // Navigation(context, name:Routename.ConfirmOrder,navigatore: NavigatoreTyp.Push,
            //     parms:{"prev": "payment"});

      return Future.value(false);
    },
    child:Scaffold (
      appBar: ResponsiveLayout.isSmallScreen(context)
          ? IConstants.isEnterprise?gradientappbarmobile():gradientappbarlite()
          : PreferredSize(preferredSize: Size.fromHeight(0),child: SizedBox.shrink()),
      body: Column(
        children: [
          if (_isWeb && !ResponsiveLayout.isSmallScreen(context)) Header(false),
          // !_isWeb ? _bodyMobile() : _bodyWeb(),
          (_isWeb && !ResponsiveLayout.isSmallScreen(context)) ? _bodyWeb()! : _bodyMobile(),
          // if (_isWeb && !ResponsiveLayout.isLargeScreen(context)) _bodyMobile(),
        ],
      ),
      bottomNavigationBar:
      (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)) ? SizedBox.shrink() : Container(
        color: Colors.white,
        child: Padding(
            padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
            child: _buildBottomNavigationBar()
        ),
      ),
    ));
  }



}