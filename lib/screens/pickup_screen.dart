import 'dart:io';
import 'dart:ui';

import 'package:grocbay/rought_genrator.dart';

import '../../constants/features.dart';

import '../controller/mutations/cart_mutation.dart';
import '../models/VxModels/VxStore.dart';
import '../models/newmodle/cartModle.dart';
import 'package:velocity_x/velocity_x.dart';

import '../generated/l10n.dart';
import '../assets/images.dart';
import '../widgets/bottom_navigation.dart';

import '../widgets/simmers/checkout_screen.dart';

import '../constants/IConstants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/branditems.dart';
import '../providers/deliveryslotitems.dart';
import '../screens/payment_screen.dart';
import '../assets/ColorCodes.dart';
import '../utils/ResponsiveLayout.dart';
import '../widgets/footer.dart';
import '../data/calculations.dart';
import '../utils/prefUtils.dart';
import 'cart_screen.dart';

class PickupScreen extends StatefulWidget {
  static const routeName = '/pickup-screen';

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> with Navigations{
  bool _isLoading = true;
  var pickuplocItem;
  var pickupTime;
  int _groupValue = 0;
  late DateTime pickedDate;
  String selectTime = "";
  String selectDate = "";
  var times;
  int position = 0;
  bool visible= false;
  int _index = 0;
  bool _checkStoreLoc = false;
  bool _isPickupSlots = false;
  double _cartTotal = 0.0;
  int z=0;
  bool _isWeb = false;
  var _message = TextEditingController();
  bool iphonex = false;
  String _deliveryChargeNormal = "0";
  String _deliveryChargePrime = "0";
  var pickupdelivery;
  var time = "10 AM - 1 PM";
  bool _checkmembership = false;
  List<CartItem> productBox=[];
  List<String>? dateSplit;

  @override
  void initState() {
    productBox = (VxState.store as GroceStore).CartItemList;
    pickedDate = DateTime.now();
    Future.delayed(Duration.zero, () async {
      //prefs = await SharedPreferences.getInstance();
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

      setState(() {
        if (PrefUtils.prefs!.getString("membership") == "1") {
          _cartTotal = CartCalculations.totalMember;
          _checkmembership = true;
        } else {
          _cartTotal = CartCalculations.total;
          _checkmembership = false;
        }

      });

      Provider.of<BrandItemsList>(context, listen: false).fetchPickupfromStore().then((_) {
        pickuplocItem = Provider.of<BrandItemsList>(context, listen: false);
        if (pickuplocItem.itemspickuploc.length > 0) {
          setState(() {
            _checkStoreLoc = true;
            _deliveryChargeNormal = pickuplocItem.itemspickuploc[0].deliveryChargeForRegularUser;
            _deliveryChargePrime = pickuplocItem.itemspickuploc[0].deliveryChargeForMembershipUser;
            Provider.of<DeliveryslotitemsList>(context, listen: false).fetchPickupslots(pickuplocItem.itemspickuploc[0].id).then((_) {
              pickupTime = Provider.of<DeliveryslotitemsList>(context, listen: false);
              for(int i = 0; i <pickupTime.itemsPickup.length; i++) {
                setState(() {
                  if(i == 0) {
                    pickupTime.itemsPickup[i].selectedColor = ColorCodes.mediumgren;
                    pickupTime.itemsPickup[i].isSelect = true;
                  } else {
                    pickupTime.itemsPickup[i].selectedColor = ColorCodes.whiteColor;
                    pickupTime.itemsPickup[i].isSelect = false;
                  }
                });
              }
              if (pickupTime.itemsPickup.length > 0) {
                final tagName = pickupTime.itemsPickup[0].date.toString();
                dateSplit = tagName.split(',');
                print("date arrya..."+dateSplit!.length.toString());
                for(var i=0;i<dateSplit!.length;i++) {
                  //for (var j = 0; j < dateSplit![i].length; j++) {
                  print("date split......"+dateSplit![i]);

                  print("date split......1...."+dateSplit![1]);
                  print("date split......2...."+dateSplit![0]);
                  // }
                }
               // debugPrint("position slot...."+deliveryslotData.items[position].id.toString()+"  "+position.toString());
                _isPickupSlots = true;
                selectTime = pickupTime.itemsPickup[0].time;
                selectDate = pickupTime.itemsPickup[0].date;
                setState(() {
                  _isLoading = false;
                });
              } else {
                setState(() {
                _isLoading = false;
                _isPickupSlots = false;
                });
              }
            });
          });
        } else {
          setState(() {
            _checkStoreLoc = false;
            _isLoading = false;
          });
        }
      });
      //Provider.of<BrandItemsList>(context,listen: false).fetchWalletBalance();
      //Provider.of<BrandItemsList>(context,listen: false).fetchPaymentMode();
    });
    super.initState();
  }

  _dialogforProcessing() {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AbsorbPointer(
              child: Container(
                color: Colors.transparent,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ),
            );
          });
        });
  }

  Iterable<TimeOfDay> getTimes(
      TimeOfDay startTime, TimeOfDay endTime, Duration step) sync* {
    var hour = startTime.hour;
    var minute = startTime.minute;

    do {
      yield TimeOfDay(hour: hour, minute: minute);
      minute += step.inMinutes;
      while (minute >= 60) {
        minute -= 60;
        hour++;
      }
    } while (hour < endTime.hour ||
        (hour == endTime.hour && minute <= endTime.minute));
  }

  changeStore(String storeId) {
    _dialogforProcessing();
    Provider.of<DeliveryslotitemsList>(context,listen: false)
        .fetchPickupslots(storeId)
        .then((_) {
      setState(() {
        pickupTime = Provider.of<DeliveryslotitemsList>(context, listen: false);
        for(int i = 0; i < pickuplocItem.itemspickuploc.length; i++) {
          setState(() {
            if(i == 0) {
              pickuplocItem.itemspickuploc[i].selectedColor = ColorCodes.mediumgren;
              pickuplocItem.itemspickuploc[i].isSelect = true;
            } else {
              pickuplocItem.itemspickuploc[i].selectedColor = ColorCodes.whiteColor;
              pickuplocItem.itemspickuploc[i].isSelect = false;
            }
          });
        }
        for(int i = 0; i < pickupTime.itemsPickup.length; i++) {
          setState(() {
            if(i == 0) {
              pickupTime.itemsPickup[i].selectedColor = ColorCodes.mediumgren;
              pickupTime.itemsPickup[i].isSelect = true;
            } else {
              pickupTime.itemsPickup[i].selectedColor = ColorCodes.whiteColor;
              pickupTime.itemsPickup[i].isSelect = false;
            }
          });
        }
        if (pickupTime.itemsPickup.length > 0) {
          _isPickupSlots = true;
          selectTime = pickupTime.itemsPickup[0].time;
          selectDate = pickupTime.itemsPickup[0].date;
        } else {
          _isPickupSlots = false;
        }
      });
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    _buildBottomNavigationBar() {
      return BottomNaviagation(
        itemCount: CartCalculations.itemCount.toString() + " " + S .of(context).items,
        title: S .current.confirm_order,
        adonamount: !_checkStoreLoc ? _checkmembership ? (double.parse(_deliveryChargePrime)).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)
            : (double.parse(_deliveryChargeNormal)).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) : _isPickupSlots ?
        _checkmembership ? ( double.parse(_deliveryChargePrime)).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) : ( double.parse(_deliveryChargeNormal)).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)
            : _checkmembership ? ( double.parse(_deliveryChargePrime)).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) : ( double.parse(_deliveryChargeNormal)).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),

        total:  !_checkStoreLoc ? _checkmembership ? (_cartTotal + double.parse(_deliveryChargePrime)).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)
            : (_cartTotal + double.parse(_deliveryChargeNormal)).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) : _isPickupSlots ?
        _checkmembership ? (_cartTotal + double.parse(_deliveryChargePrime)).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) : (_cartTotal + double.parse(_deliveryChargeNormal)).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)
            : _checkmembership ? (_cartTotal + double.parse(_deliveryChargePrime)).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) : (_cartTotal + double.parse(_deliveryChargeNormal)).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
        onPressed: (){
          setState(() {
            if(!_checkStoreLoc) {
              Fluttertoast.showToast(
                msg: S
                    .of(context)
                    .currently_no_store,
                //"currently there is no store address available",
                fontSize: MediaQuery
                    .of(context)
                    .textScaleFactor * 13,);
            }else{
              if(_isPickupSlots){
                PrefUtils.prefs!.setString("isPickup", "yes");
                PrefUtils.prefs!.setString('fixtime', selectTime);
                PrefUtils.prefs!.setString("fixdate", selectDate);
                PrefUtils.prefs!.setString("addressId", pickuplocItem.itemspickuploc[_groupValue].id.toString());
             /*   Navigator.of(context).pushNamed(PaymentScreen.routeName, arguments: {
                  'minimumOrderAmountNoraml': "0",
                  'deliveryChargeNormal': _deliveryChargeNormal,
                  'minimumOrderAmountPrime': "0",
                  'deliveryChargePrime': _deliveryChargePrime,
                  'minimumOrderAmountExpress': "0",
                  'deliveryChargeExpress': "0",
                  'deliveryType': "pickup",
                  'addressId': PrefUtils.prefs!.getString("addressId"),
                  'note': _message.text,
                  'deliveryCharge': _checkmembership ? _deliveryChargePrime : _deliveryChargeNormal,
                  'deliveryDurationExpress' : "0",
                });*/
                Navigation(context, name: Routename.PaymentScreen, navigatore: NavigatoreTyp.Push,
                    qparms: {
                      'minimumOrderAmountNoraml': "0",
                      'deliveryChargeNormal': _deliveryChargeNormal,
                      'minimumOrderAmountPrime': "0",
                      'deliveryChargePrime': _deliveryChargePrime,
                      'minimumOrderAmountExpress': "0",
                      'deliveryChargeExpress': "0",
                      'deliveryType': "pickup",
                      'addressId': PrefUtils.prefs!.getString("addressId"),
                      'note': _message.text,
                      'deliveryCharge': _checkmembership ? _deliveryChargePrime : _deliveryChargeNormal,
                      'deliveryDurationExpress' : "0",
                      'fromScreen':'pickupscreen',
                      'responsejson':"",
                    });
              }
              else{
                Fluttertoast.showToast(
                  msg:
                  S .of(context).currently_no_time_address ,//"currently there is no slots available for this address",
                  fontSize: MediaQuery.of(context).textScaleFactor *13,);
              }

            }

          });
        },
      );
      // Container(
      //   width: MediaQuery.of(context).size.width,
      //   height: 50.0,
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: <Widget>[
      //       !_checkStoreLoc
      //           ? GestureDetector(
      //               onTap: () => {
      //                 Fluttertoast.showToast(
      //                     msg: S .of(context).currently_no_store ,//"currently there is no store address available",
      //                   fontSize: MediaQuery.of(context).textScaleFactor *13,),
      //               },
      //               child: Row(
      //                 children: [
      //                   Container(
      //                     color:Colors.grey,
      //                     height: 50,
      //                     width: MediaQuery.of(context).size.width * 40 / 100,
      //                     child: Center(
      //                       child: _checkmembership?
      //                       Text(
      //                         S .of(context).total//'Total: '
      //                             +   IConstants.currencyFormat + " " + (_cartTotal + double.parse(_deliveryChargePrime)).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
      //                         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      //                         textAlign: TextAlign.center,
      //                       )
      //                       :Text(
      //                         S .of(context).total//'Total: '
      //                             +   IConstants.currencyFormat + " " + (_cartTotal + double.parse(_deliveryChargeNormal)).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
      //                               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      //                               textAlign: TextAlign.center,
      //                             ),
      //                     ),
      //                     ),
      //                   Container(
      //                    // padding: EdgeInsets.symmetric(horizontal: 30),
      //                     color: Colors.grey,
      //                     height: 50,
      //                     width: MediaQuery.of(context).size.width * 60 / 100,
      //                     child: Row(
      //                       mainAxisAlignment: MainAxisAlignment.center,
      //                       crossAxisAlignment: CrossAxisAlignment.center ,
      //                     children: [
      //                         Text(
      //                         S .of(context).confirm_order,//'CONFIRM ORDER',
      //                           style: TextStyle(
      //                               color: Colors.white,
      //                               fontWeight: FontWeight.bold),
      //                         ),
      //                         SizedBox(
      //                           width: 5,
      //                         ),
      //                         Icon(
      //                           Icons.arrow_right,
      //                           color: Colors.white,
      //                         )
      //                       ],
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             )
      //           : _isPickupSlots
      //               ? GestureDetector(
      //                   onTap: () {
      //                     PrefUtils.prefs!.setString("isPickup", "yes");
      //                     PrefUtils.prefs!.setString('fixtime', selectTime);
      //                     PrefUtils.prefs!.setString("fixdate", selectDate);
      //                     PrefUtils.prefs!.setString(
      //                         "addressId",
      //                         pickuplocItem.itemspickuploc[_groupValue].id
      //                             .toString());
      //                     Navigator.of(context)
      //                         .pushNamed(PaymentScreen.routeName, arguments: {
      //                       'minimumOrderAmountNoraml': "0",
      //                       'deliveryChargeNormal': _deliveryChargeNormal,
      //                       'minimumOrderAmountPrime': "0",
      //                       'deliveryChargePrime': _deliveryChargePrime,
      //                       'minimumOrderAmountExpress': "0",
      //                       'deliveryChargeExpress': "0",
      //                       'deliveryType': "pickup",
      //                       'note': _message.text,
      //                       'deliveryCharge': _checkmembership ? _deliveryChargePrime : _deliveryChargeNormal,
      //                       'deliveryDurationExpress' : "0",
      //                     });
      //                   },
      //                   child: Row(
      //                     children: [
      //                       Container(
      //                         color:Theme.of(context).primaryColor,
      //                         height: 50,
      //                         width: MediaQuery.of(context).size.width * 40 / 100,
      //                         child: Center(
      //                           child: _checkmembership?
      //                           Text(
      //                             S .of(context).total//'Total: '
      //                                 +   IConstants.currencyFormat + " " + (_cartTotal + double.parse(_deliveryChargePrime)).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
      //                             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      //                             textAlign: TextAlign.center,
      //                           )
      //                               :Text(
      //                             S .of(context).total//'Total: '
      //                                 +   IConstants.currencyFormat + " " + (_cartTotal + double.parse(_deliveryChargeNormal)).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
      //                             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      //                             textAlign: TextAlign.center,
      //                           ),
      //                         ),
      //                       ),
      //                       Container(
      //                         //padding: EdgeInsets.symmetric(horizontal: 30),
      //                         color:Theme.of(context).primaryColor,
      //                         height: 50,
      //                         width: MediaQuery.of(context).size.width * 60 / 100,
      //                         child: Row(
      //                           mainAxisAlignment: MainAxisAlignment.center,
      //                           crossAxisAlignment: CrossAxisAlignment.center ,
      //                           children: [
      //                             Text(
      //                             S .of(context).confirm_order ,//'CONFIRM ORDER',
      //                               style: TextStyle(
      //                                   color: Colors.white,
      //                                   fontWeight: FontWeight.bold),
      //
      //                             ),
      //                             SizedBox(
      //                               width: 5,
      //                             ),
      //                             Icon(
      //                               Icons.arrow_right,
      //                               color: Colors.white,
      //                             )
      //                           ],
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 )
      //               : GestureDetector(
      //                   onTap: () => {
      //                     Fluttertoast.showToast(
      //                         msg:
      //                         S .of(context).currently_no_time_address ,//"currently there is no slots available for this address",
      //                       fontSize: MediaQuery.of(context).textScaleFactor *13,),
      //                   },
      //                   child: Row(
      //                     children: [
      //                       Container(
      //                         color:Colors.grey,
      //                         height: 50,
      //                         width: MediaQuery.of(context).size.width * 40 / 100,
      //                         child: Center(
      //                           child: _checkmembership?
      //                           Text(
      //                             S .of(context).total//'Total: '
      //                                 +   IConstants.currencyFormat + " " + (_cartTotal + double.parse(_deliveryChargePrime)).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
      //                             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      //                             textAlign: TextAlign.center,
      //                           )
      //                               :Text(
      //                             S .of(context).total//'Total: '
      //                                 +   IConstants.currencyFormat + " " + (_cartTotal + double.parse(_deliveryChargeNormal)).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
      //                             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      //                             textAlign: TextAlign.center,
      //                           ),
      //                         ),
      //                       ),
      //                       Container(
      //                         //padding: EdgeInsets.symmetric(horizontal: 30),
      //                         color: Colors.grey,
      //                         height: 50,
      //                         width: MediaQuery.of(context).size.width * 60 / 100,
      //                         child: Row(
      //                           mainAxisAlignment: MainAxisAlignment.center,
      //                           crossAxisAlignment: CrossAxisAlignment.center ,
      //                           children: [
      //                             Text(
      //                               S .of(context).confirm_order ,//'CONFIRM ORDER',
      //                               style: TextStyle(
      //                                   color: Colors.white,
      //                                   fontWeight: FontWeight.bold),
      //                             ),
      //                             SizedBox(
      //                               width: 5,
      //                             ),
      //                             Icon(
      //                               Icons.arrow_right,
      //                               color: Colors.white,
      //                             )
      //                           ],
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 )
      //     ],
      //   ),
      // );
    }

    Future<void> openMap(double latitude, double longitude) async {
      String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
      if (await canLaunch(googleUrl)) {
        await launch(googleUrl);
      } else {
        throw  S .of(context).could_not_open_app ;//'Could not open the map.';
      }
    }

    return WillPopScope(
        onWillPop: () {
      // this is the block you need
      /* Navigator.pushNamedAndRemoveUntil(
            context, CartScreen.routeName, (route) => false);*/
      removeToCart();
     /* Navigator.of(context).pushReplacementNamed(CartScreen.routeName, arguments: {
        "afterlogin": ""
      });*/
     // Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
      Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":""});
     // Navigator.of(context).pop();

      return Future.value(false);
    },
    child:Scaffold(
      appBar: ResponsiveLayout.isSmallScreen(context)
          ?gradientappbarmobile():null,
      backgroundColor: ColorCodes.whiteColor,
      body: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?CartScreen({}):_isLoading
          ? Center(
              child: CheckOutShimmer(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  !_checkStoreLoc
                      ? Center(
                          child: Container(
                            width:MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(top: 15, bottom: 15),
                            padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                            decoration: BoxDecoration(
                                color: ColorCodes.whiteColor,
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: ColorCodes.grey.withOpacity(0.3),
                                //     spreadRadius: 1,
                                //     blurRadius: 5,
                                //     offset: Offset(0, 3),
                                //   )
                                // ]
                            ),
                            child: Text(
                              S .of(context).currently_no_store ,//"Currently there is no store address available",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        )
                      :
                   Container(
                     width:MediaQuery.of(context).size.width,
                     margin: EdgeInsets.only(top: 10, bottom: 5,left:15,right: 15),
                     padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
                     decoration: BoxDecoration(
                         color: ColorCodes.whiteColor,
                         // boxShadow: [
                         //   BoxShadow(
                         //     color: ColorCodes.grey.withOpacity(0.3),
                         //     spreadRadius: 1,
                         //     blurRadius: 5,
                         //     offset: Offset(0, 3),
                         //   )
                         // ]
                     ),
                      child: Column(
                          children: [
                            SizedBox(
                              child: new ListView.separated(
                                separatorBuilder: (context, index) => Divider(
                                  color: ColorCodes.whiteColor,
                                ),
                                padding: EdgeInsets.zero,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: pickuplocItem.itemspickuploc.length,
                                itemBuilder: (_, i) => GestureDetector(
                                  onTap: () {
                                    if (_groupValue != i)
                                      setState(() {
                                        _groupValue = i;
                                        changeStore(pickuplocItem.itemspickuploc[i].id);
                                        _deliveryChargeNormal = pickuplocItem.itemspickuploc[i].deliveryChargeForRegularUser;
                                        _deliveryChargePrime = pickuplocItem.itemspickuploc[i].deliveryChargeForMembershipUser;
                                      });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: _groupValue == i ? ColorCodes.varcolor : ColorCodes.whiteColor,
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                        color: ColorCodes.primaryColor,
                                      ),
                                    ),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.only(right: 0.0),
                                        title:  Row(
                                            children: <Widget>[
                                              SizedBox(
                                                width: 15.0,
                                              ),
                                              Container(
                                                height: 40,
                                                width: 40,
                                                child: GestureDetector(
                                                    onTap: () {
                                                      openMap(
                                                          pickuplocItem
                                                              .itemspickuploc[i]
                                                              .latitude,
                                                          pickuplocItem
                                                              .itemspickuploc[i]
                                                              .longitude);
                                                    },
                                                    child: Image.asset(Images.pickup_point, height:25, width: 25, color: ColorCodes.primaryColor)),
                                              ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                  ),
                                                  margin: EdgeInsets.only(bottom: 10.0),
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                        pickuplocItem
                                                            .itemspickuploc[i].name,
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w900,color: ColorCodes.primaryColor),
                                                      ),
                                                      SizedBox(
                                                        height: 4.0,
                                                      ),
                                                      if (pickuplocItem
                                                              .itemspickuploc[i].contact
                                                              .toString() ==
                                                          "")
                                                        Text(
                                                          pickuplocItem
                                                              .itemspickuploc[i]
                                                              .address,
                                                          style: TextStyle(
                                                              color: ColorCodes.primaryColor,//ColorCodes.greyColor,
                                                              fontWeight:
                                                                  FontWeight.w300,
                                                              fontSize: 12.0),
                                                        )
                                                      else
                                                        Text(
                                                          pickuplocItem
                                                                  .itemspickuploc[i]
                                                                  .address +
                                                              "\n" +
                                                              "Ph: " +
                                                              pickuplocItem
                                                                  .itemspickuploc[i]
                                                                  .contact,
                                                          style: TextStyle(
                                                            color: ColorCodes.primaryColor,//ColorCodes.greyColor,
                                                              fontWeight:
                                                                  FontWeight.w300,
                                                              fontSize: 12.0),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 20),
                                             /* SizedBox(
                                                width: 10.0,
                                                height: 20.0,
                                                child:
                                                _myRadioButton(
                                                  value: i,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      _groupValue = newValue;
                                                    });
                                                    changeStore(pickuplocItem.itemspickuploc[i].id);
                                                    _deliveryChargeNormal = pickuplocItem.itemspickuploc[i].deliveryChargeForRegularUser;
                                                    _deliveryChargePrime = pickuplocItem.itemspickuploc[i].deliveryChargeForMembershipUser;

                                                  },
                                                ),
                                              ),*/
                                              _groupValue == i ?
                                              Container(
                                                width: 20.0,
                                                height: 20.0,
                                                decoration: BoxDecoration(
                                                  color: ColorCodes.whiteColor,
                                                  border: Border.all(
                                                    color: ColorCodes.primaryColor,
                                                  ),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Container(
                                                  margin: EdgeInsets.all(1.5),
                                                  decoration: BoxDecoration(
                                                    color: ColorCodes.whiteColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(Icons.check,
                                                      color: ColorCodes.primaryColor,
                                                      size: 15.0),
                                                ),
                                              )
                                                  :
                                              Icon(
                                                  Icons.radio_button_off_outlined,
                                                  color: ColorCodes.primaryColor),

                                              SizedBox(
                                                width: 15.0,
                                              ),
                                            ],
                                          ),
                                      ),
                                    ),

                                ),
                              ),
                            ),
                            Container(
                              width:MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(top:15, bottom: 0),
                              //padding: EdgeInsets.only( right: 15, top: 15, bottom: 15),
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
                              ),*/
                              child: ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.only(left: 0.0),
                                leading: Image.asset(Images.request,
                                  height: 30,
                                  width: 30,
                                  color: ColorCodes.greenColor,
                                ),
                                title: Transform(
                                  transform: Matrix4.translationValues(-16, 0.0, 0.0),
                                  child: TextField(
                                    controller: _message,
                                    decoration: InputDecoration.collapsed(
                                        hintText: S .of(context).any_request ,//"Any request? We promise to pass it on",
                                        hintStyle: TextStyle(fontSize: 12.0),
                                        //contentPadding: EdgeInsets.all(16),
                                        //border: OutlineInputBorder(),
                                        fillColor: ColorCodes.lightGreyColor),
                                    //minLines: 3,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ),

                  _checkStoreLoc && _isPickupSlots
                      ? Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 0, bottom: 0),
                    padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        color: ColorCodes.whiteColor,
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: ColorCodes.grey.withOpacity(0.3),
                        //     spreadRadius: 1,
                        //     blurRadius: 5,
                        //     offset: Offset(0, 3),
                        //   )
                        // ]
                    ),
                          child: Text(
                            S .of(context).select_your_timeslot ,//"Select Your Time Slot",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                FontWeight.w900),
                          ),
                        )
                      : Container(),
                  // Padding(
                  //   padding: EdgeInsets.all(5),
                  // ),
                  _isPickupSlots && pickupTime.itemsPickup.length > 0
                      //Container()
                      ? Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 0, bottom: 10),
                    padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 10),
                    decoration: BoxDecoration(
                        color: ColorCodes.whiteColor,
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: ColorCodes.grey.withOpacity(0.3),
                        //     spreadRadius: 1,
                        //     blurRadius: 5,
                        //     offset: Offset(0, 3),
                        //   )
                        // ]
                    ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 50,
                                width: 40,

                                decoration: BoxDecoration(
                                  color: pickupTime.itemsPickup[0].isSelect ?ColorCodes.varcolor:ColorCodes.whiteColor,
                                  border: Border.all(
                                    color: ColorCodes.varcolor,
                                  ),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Center(
                                  child: Text(
                                      dateSplit![0].toUpperCase(),
                                      /* value1,*//*deliveryslotData.items[i].date,*/
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: ColorCodes.darkgreen)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top:2.0,left: 2,right:2),
                                child: Text(
                                    dateSplit![1].toUpperCase(),
                                    /* value2.toUpperCase(),*//*deliveryslotData.items[i].date,*/
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: ColorCodes.darkgreen)),
                              ),
                             /* Row(
                                children: <Widget>[
                                  // Container(
                                  //   margin: EdgeInsets.only(left: 10.0),
                                  //   child: Text(
                                  //     S .of(context).date ,//'Date: ',
                                  //     style: TextStyle(
                                  //       fontWeight: FontWeight.w300,
                                  //       fontSize: 15.0,
                                  //       color: ColorCodes.blackColor,
                                  //     ),
                                  //   ),
                                  // ),
                                  Container(
                                    height: 50,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: ColorCodes.varcolor,
                                      border: Border.all(
                                        color: ColorCodes.primaryColor,
                                      ),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: Center(
                                      child: Text(
                                       dateSplit[0],// pickupTime.itemsPickup[0].date,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: ColorCodes.primaryColor),
                                      ),
                                    ),
                                  ),
                                  // Spacer(),
                                  // SizedBox(
                                  //   width: 10.0,
                                  // ),
                                  // Padding(
                                  //   padding: EdgeInsets.only(top: 40),
                                  // ),
                                ],
                              ),*/
                              // Row(
                              //   children: [
                              //     Text('Select your pickup slot', style: TextStyle(
                              //       fontSize: 20,
                              //       fontWeight: FontWeight.w700,
                              //     ),),
                              //   ],
                              // ),

                              SizedBox(height: 10,),
                              SelecttimeSlot(/*pickupTime.itemsPickup[position].id,*/ position)
                            ],
                          ),
                        )
                      : _checkStoreLoc
                          ? Center(
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 15.0, top: 10.0, bottom: 10.0, right: 10),
                                child: Text(
                                  S .of(context).currently_no_time_address ,//"Currently there is no slots available for this address",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            )
                          : Container(),
                          if(_isWeb&&!ResponsiveLayout.isSmallScreen(context))
                          Container(
               width: MediaQuery.of(context).size.width,
              height: 50.0,
             child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
              !_checkStoreLoc
                ? GestureDetector(
                    onTap: () => {
                      Fluttertoast.showToast(
                          msg: S .of(context).currently_no_store ,//"currently there is no store address available",
                        fontSize: MediaQuery.of(context).textScaleFactor *13,),
                    },
                    child: Row(
                      children: [
                        Container(
                          color:Colors.grey,
                          height: 50,
                          width: MediaQuery.of(context).size.width * 40 / 100,
                          child: Center(
                            child:
                                Features.iscurrencyformatalign?
                                Text(
                                  S .of(context).total //'Total: '
                                      +   _cartTotal.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)  + " " +  IConstants.currencyFormat,
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ):
                            Text(
                              S .of(context).total //'Total: '
                                  +   IConstants.currencyFormat + " " + _cartTotal.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                          ),
                          ),
                        Container(
                         // padding: EdgeInsets.symmetric(horizontal: 30),
                          color: Colors.grey,
                          height: 50,
                          width: MediaQuery.of(context).size.width * 60 / 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center ,
                          children: [
                              Text(
                                S .of(context).confirm_order ,//'CONFIRM ORDER',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.arrow_right,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : _isPickupSlots
                    ? GestureDetector(
                        onTap: () {
                          PrefUtils.prefs!.setString("isPickup", "yes");
                          PrefUtils.prefs!.setString('fixtime', selectTime);
                          PrefUtils.prefs!.setString("fixdate", selectDate);
                          PrefUtils.prefs!.setString(
                              "addressId",
                              pickuplocItem.itemspickuploc[_groupValue].id
                                  .toString());

                 /*         Navigator.of(context)
                              .pushNamed(PaymentScreen.routeName, arguments: {
                            'minimumOrderAmountNoraml': "0",
                            'deliveryChargeNormal': _deliveryChargeNormal,
                            'minimumOrderAmountPrime': "0",
                            'deliveryChargePrime': _deliveryChargePrime,
                            'minimumOrderAmountExpress': "0",
                            'deliveryChargeExpress': "0",
                            'deliveryType': "pickup",
                            'addressId': PrefUtils.prefs!.getString("addressId"),
                            'note': _message.text,
                            'deliveryCharge': _checkmembership?_deliveryChargePrime:_deliveryChargeNormal,
                            'deliveryDurationExpress' : "0",
                          });*/
                          Navigation(context, name: Routename.PaymentScreen, navigatore: NavigatoreTyp.Push,
                              qparms: {
                                'minimumOrderAmountNoraml': "0",
                                'deliveryChargeNormal': _deliveryChargeNormal,
                                'minimumOrderAmountPrime': "0",
                                'deliveryChargePrime': _deliveryChargePrime,
                                'minimumOrderAmountExpress': "0",
                                'deliveryChargeExpress': "0",
                                'deliveryType': "pickup",
                                'addressId': PrefUtils.prefs!.getString("addressId"),
                                'note': _message.text,
                                'deliveryCharge': _checkmembership?_deliveryChargePrime:_deliveryChargeNormal,
                                'deliveryDurationExpress' : "0",
                                'fromScreen':'pickupscreen',
                                'responsejson':"",
                              });
                        },
                        child: Row(
                          children: [
                            Container(
                              color:Theme.of(context).primaryColor,
                              height: 50,
                              width: MediaQuery.of(context).size.width * 40 / 100,
                              child: Center(
                                child:
                                    Features.iscurrencyformatalign?
                                    Text(
                                      S .of(context).total //'Total: '
                                          +   _cartTotal.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)  + " " + IConstants.currencyFormat,
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ):
                                Text(
                                  S .of(context).total //'Total: '
                                      +   IConstants.currencyFormat + " " + _cartTotal.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Container(
                              //padding: EdgeInsets.symmetric(horizontal: 30),
                              color:Theme.of(context).primaryColor,
                              height: 50,
                              width: MediaQuery.of(context).size.width * 60 / 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center ,
                                children: [
                                  Text(
                                    S .of(context).confirm_order ,//'CONFIRM ORDER',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),

                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.arrow_right,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : GestureDetector(
                        onTap: () => {
                          Fluttertoast.showToast(
                              msg:
                              S .of(context).currently_no_time_address ,//"currently there is no slots available for this address",
                            fontSize: MediaQuery.of(context).textScaleFactor *13,),
                        },
                        child: Row(
                          children: [
                            Container(
                              color:Colors.grey,
                              height: 50,
                              width: MediaQuery.of(context).size.width * 40 / 100,
                              child: Center(
                                child:
                                    Features.iscurrencyformatalign?
                                    Text(
                                      S .of(context).total //'Total: '
                                          +   _cartTotal.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + " " + IConstants.currencyFormat,
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
                                      textAlign: TextAlign.center,
                                    ):
                                Text(
                                  S .of(context).total //'Total: '
                                      +   IConstants.currencyFormat + " " + _cartTotal.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Container(
                              //padding: EdgeInsets.symmetric(horizontal: 30),
                              color: Colors.grey,
                              height: 50,
                              width: MediaQuery.of(context).size.width * 60 / 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center ,
                                children: [
                                  Text(
                                    S .of(context).confirm_order ,//'CONFIRM ORDER',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.arrow_right,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
          ],
        ),
      ),
                          if (_isWeb)
                    Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
                ],
              ),
            ),
      bottomNavigationBar:  (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
          ? SizedBox.shrink() :Padding(
        padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
        child:_buildBottomNavigationBar(),
      ),
    ));
  }
  SelecttimeSlot(int index) {
    pickupTime = Provider.of<DeliveryslotitemsList>(context, listen: false);

    return  ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: 10,),
      physics:new NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: pickupTime.itemsPickup.length,
      itemBuilder: (_, j) => GestureDetector(
        onTap: () async {
          for(int k=0;k<pickupTime.itemsPickup.length;k++){
            pickupTime.itemsPickup[k].isSelect = false;
            pickupTime.itemsPickup[k].selectedColor = Colors.transparent;
          }
          setState(() {
            time = pickupTime.itemsPickup[j].time;
            final timeData = Provider.of<DeliveryslotitemsList>(context, listen: false);

            //PrefUtils.prefs!.setString("fixdate", pickupTime.itemsPickup[0].date);

            //_index = (i == 0 && j == 0) ? 0 : _index + 1;
            for(int i = 0; i < timeData.itemsPickup.length; i++) {
              timeData.itemsPickup[i].isSelect = false;
              pickupTime.itemsPickup[j].isSelect = false;
              // timeData.times[i].isSelect = false;
              if(j == i) {
                setState(() {
                  timeData.itemsPickup[i].selectedColor = ColorCodes.primaryColor;
                  timeData.itemsPickup[i].isSelect = true;
                  pickupTime.itemsPickup[j].isSelect = true;
                  PrefUtils.prefs!.setString('fixtime', timeData.itemsPickup[i].time!);
                  selectTime = timeData.itemsPickup[i].time!;
                });
                break;
              } else{
                setState(() {
                  timeData.itemsPickup[i].selectedColor = ColorCodes.lightgrey;
                  timeData.itemsPickup[i].isSelect = false;
                  pickupTime.itemsPickup[j].isSelect = false;
                  pickupTime.itemsPickup[j].selectedColor = Colors.transparent;
                });
              }
            }
          });

        },
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color:  pickupTime.itemsPickup[j].isSelect ? ColorCodes.varcolor:ColorCodes.whiteColor,
            border: Border.all(
              color: pickupTime.itemsPickup[j].isSelect ?ColorCodes.primaryColor:ColorCodes.varcolor,
            ),
            borderRadius: BorderRadius.circular(3),
          ),
          // margin: EdgeInsets.only(left: 5.0, right: 5.0),
          //child: Container(
          width: MediaQuery.of(context).size.width,
          //  padding: EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 20,),
              Container(
                child: Text(
                  pickupTime.itemsPickup[j].time,
                  style: TextStyle(color: ColorCodes.primaryColor , fontSize:14, fontWeight: FontWeight.bold),
                ),
              ),
              Spacer(),
              handler( pickupTime.itemsPickup[j].isSelect),
              SizedBox(width: 20,),
            ],
          ),
        ),
      ),
    );
  }

  // Widget SelectDate(){
  //   //deliveryslotData.items[0].selectedColor=ColorCodes.mediumgren;
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       SizedBox(height: 10,),
  //       Container(
  //         height: 70,
  //         width: double.infinity,
  //         child: ListView.separated(
  //             separatorBuilder: (BuildContext context, int index) {
  //               return SizedBox(
  //                 width: 10,
  //               );
  //             },
  //             shrinkWrap: true,
  //             scrollDirection: Axis.horizontal,
  //             //physics: new AlwaysScrollableScrollPhysics(),
  //             itemCount: pickupTime.itemsPickup.length,
  //             itemBuilder: (_, i)
  //             {
  //               // deliveryslotData.items[0].isSelect = true;
  //               return GestureDetector(
  //                 onTap: (){
  //                   setState(() {
  //                     position = i;
  //                     visible = true;
  //                     /*for(int j=0;j<deliveryslotData.items.length;j++){
  //                          deliveryslotData.items[j].selectedColor=ColorCodes.whiteColor;
  //                        }
  //                        deliveryslotData.items[i].selectedColor=ColorCodes.mediumgren;*/
  //
  //                     for(int j=0;j<pickupTime.itemsPickup.length;j++){
  //                       if(i==j){
  //                         pickupTime.itemsPickup[j].selectedColor=ColorCodes.mediumgren;//Color(0xFF45B343);
  //                         pickupTime.itemsPickup[j].isSelect = true;
  //                       }
  //                       else{
  //                         pickupTime.itemsPickup[j].selectedColor=ColorCodes.whiteColor;
  //                         pickupTime.itemsPickup[j].isSelect = false;
  //                       }
  //                     }
  //
  //                   });
  //                 },
  //                 child: Container(
  //                   height: 70,
  //                   width: 70,
  //
  //                   decoration: BoxDecoration(
  //                     color: pickupTime.itemsPickup[i].isSelect ?ColorCodes.mediumgren:ColorCodes.whiteColor,
  //                     border: Border.all(
  //                       color: ColorCodes.lightgreen,
  //                     ),
  //                     borderRadius: BorderRadius.circular(3),
  //                   ),
  //                   child: Center(
  //                     child: Text(
  //                         pickupTime.itemsPickup[i].date,
  //                         textAlign: TextAlign.center,
  //                         style: TextStyle(
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 16,
  //                             color: ColorCodes.darkgreen)),
  //                   ),
  //                 ),
  //               );
  //             }),
  //       ),
  //       SizedBox(height: 10,),
  //       SelecttimeSlot(pickupTime.itemsPickup[position].id, position, pickupTime.itemsPickup[position].date)
  //     ],
  //   );
  // }

  Widget handler(bool isSelected) {
    return (isSelected == true)  ?
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
          color: ColorCodes.whiteColor,
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
        color: ColorCodes.greenColor);


  }
  gradientappbarmobile() {
      return AppBar(
        brightness: Brightness.dark,
        toolbarHeight: 60.0,
        elevation: (IConstants.isEnterprise)?0:1,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: ColorCodes.iconColor),
            onPressed: () {
              removeToCart();
             // Navigator.of(context).pop();
            /*  Navigator.of(context).pushReplacementNamed(CartScreen.routeName, arguments: {
                "afterlogin": ""
              });*/
              Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":""});
            }),
        title: Text(
          S .of(context).select_pickup_point ,//'Checkout',
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
  removeToCart() async {
    late String itemId, varId, varName,
        varMinItem, varMaxItem, varLoyalty, varStock, varMrp, itemName, qty, price, membershipPrice, itemImage, veg_type, type,eligibleforexpress,delivery,duration,durationType,note;
    // widget.isdbonprocess();
    //  if (itemCount + 1 <= int.parse(widget.varminitem)) {
    productBox = (VxState.store as GroceStore).CartItemList;
    try {

      // }
      for (int i = 0; i < productBox.length; i++) {
        if (productBox[i].mode =="4") {
          itemId = productBox[i].itemId.toString();
          varId = productBox[i].varId.toString();
          varName = productBox[i].varName!;
          varMinItem = productBox[i].varMinItem.toString();
          varMaxItem = productBox[i].varMaxItem.toString();
          varLoyalty = productBox[i].itemLoyalty.toString();
          varStock = productBox[i].varStock.toString();
          varMrp = productBox[i].varMrp.toString();
          itemName = productBox[i].itemName!;
          price = productBox[i].price.toString();
          membershipPrice = productBox[i].membershipPrice.toString();
          itemImage = productBox[i].itemImage!;
          veg_type = productBox[i].vegType!;
          type = productBox[i].type!;
          eligibleforexpress = productBox[i].eligibleForExpress!;
          delivery = productBox[i].delivery!;
          duration = productBox[i].duration!;
          durationType = productBox[i].durationType!;
          note = productBox[i].note!;
          break;
        }
      }
      cartcontroller.update((done){
        // setState(() {
        //   _isAddToCart = !done;
        // });
      },price: double.parse(price).toString(),var_id:varId,quantity: "0",weight: "0", cart_id: "",toppings: "",
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
}