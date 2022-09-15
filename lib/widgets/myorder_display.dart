import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../repository/authenticate/AuthRepo.dart';
import 'package:velocity_x/velocity_x.dart';
import '../constants/api.dart';
import '../constants/features.dart';
import '../generated/l10n.dart';
import '../models/myordersfields.dart';
import '../rought_genrator.dart';
import '../screens/rate_order_screen.dart';
import '../screens/orderhistory_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../providers/addressitems.dart';
import '../screens/return_screen.dart';
import '../screens/address_screen.dart';
import '../constants/IConstants.dart';
import '../screens/myorder_screen.dart';
import '../assets/images.dart';
import '../utils/ResponsiveLayout.dart';
import '../utils/prefUtils.dart';
import '../assets/ColorCodes.dart';
import 'addresswidget/address_info.dart';


extension StringCasingExtension on String {
  String toCapitalized() => this.length > 0 ?'${this[0].toUpperCase()}${this.substring(1)}':'';
  String get toTitleCase => this.replaceAll(RegExp(' +'), ' ').split(" ").map((str) => str.toCapitalized()).join(" ");
}


class MyorderDisplay extends StatefulWidget {
  // final int refer_id;
  List<MyordersFields> splitorder;

  MyorderDisplay(
      this.splitorder,
  );

  @override
  _MyorderDisplayState createState() => _MyorderDisplayState();
}


class _MyorderDisplayState extends State<MyorderDisplay> with Navigations{
  bool _showreorder = false;
  bool _showCancelled = false;
  bool _showReturn = false;
  int _groupValue = -1;
  var _message = TextEditingController();
  var _comment = TextEditingController();
  var _isWeb = false;
  int itemleftcount = 0;
  bool _rateorder = false;
  double ratings = 3.0;
  int? splitlength;
  List<List<MyordersFields>> myorders =[] ;
  String comment = S .current.good;

  @override
  void initState() {
    try {
      if (Platform.isIOS) {
        setState(() {
          _isWeb = false;
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

    Future.delayed(Duration.zero, () async {
      _message.text = "";
      _comment.text = "";


    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double orderamount = 0.0;
double totalamount = 0.0;

    Future<void> RateOrder(var rating,String orderid) async {
      try {
        final response = await http.post(Api.addRatings, body: {
          // await keyword is used to wait to this operation is complete.
          "user": PrefUtils.prefs!.getString('apikey'),
          "order":orderid.toString(),
          "star": rating.toString(),
          "comment": comment.toString(),
          "branch": PrefUtils.prefs!.getString('branch'),
        });
        final responseJson = json.decode(response.body);
        Navigator.pop(context);
        Navigator.pop(context);
        if (responseJson['status'].toString() == "200") {
          Navigation(context, name:Routename.MyOrders,navigatore: NavigatoreTyp.Push,
          );
        } else {
          Fluttertoast.showToast(msg: S .current.something_went_wrong, fontSize: MediaQuery.of(context).textScaleFactor *13,);
        }
      } catch (error) {
        Navigator.pop(context);

        Fluttertoast.showToast(msg: S .current.something_went_wrong, fontSize: MediaQuery.of(context).textScaleFactor *13,);
        throw error;
      }
    }

    _dialogforProcessing(){
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

    showModalRateOrder( BuildContext context , setState,String orderid ) {
      (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
      showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return ConstrainedBox(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width/4),
                child: AlertDialog(
                  insetPadding: EdgeInsets.symmetric(horizontal: 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  content: Wrap(
                    children: [
                      StatefulBuilder(builder: (context, setState1) {
                        return
                          SingleChildScrollView(
                            child: Container(
                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width/4),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(Images.starimage,height:200,),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        S .of(context).rate_your_order,
                                        style: TextStyle(fontSize: 16.0,color: ColorCodes.blackColor),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),

                                      SizedBox(
                                        height: 15.0,
                                      ),
                                      Text(
                                        S .of(context).refund_orderid+ " : " + orderid.toString(),
                                        style: TextStyle(fontSize: 20.0,color: ColorCodes.blackColor,fontWeight: FontWeight.bold),
                                      ),

                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      RatingBar.builder(

                                        initialRating: ratings,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 30,
                                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star_rate,
                                          color: ColorCodes.primaryColor,
                                        ),

                                        onRatingUpdate: (rating) {
                                          ratings = rating;
                                          if(ratings == 5){
                                            setState1(() {
                                              comment = S .of(context).excellent;//"Excellent";
                                            });

                                          }
                                          else if(ratings == 4){
                                            setState1(() {
                                              comment = S .of(context).good;//"Good";
                                            });

                                          }
                                          else if(ratings == 3){
                                            setState1(() {
                                              comment = S .of(context).average;//"Average";
                                            });

                                          }
                                          else if(ratings == 2){
                                            setState1(() {
                                              comment = S .of(context).bad;//"Bad";
                                            });
                                          }
                                          else if(ratings == 1){
                                            setState1(() {
                                              comment = S .of(context).verybad;//"Very Bad";
                                            });
                                          }
                                        },
                                      ),

                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        comment,
                                        style: TextStyle(fontSize: 18.0,color: ColorCodes.blackColor),
                                      ),
                                      SizedBox(
                                        height: 30.0,
                                      ),
                                      MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          onTap: () {
                                            _dialogforProcessing();
                                            RateOrder(ratings,orderid.toString());
                                          },
                                          child: Container(
                                            height: 50,
                                            width: MediaQuery.of(context).size.width,
                                            //color: ColorCodes.greenColor,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: ColorCodes.greenColor,
                                              border: Border.all(
                                                  color: ColorCodes.greenColor),
                                            ),
                                            child: Center(
                                                child: Text(
                                                  S .of(context).rate_order.toUpperCase(),
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: ColorCodes
                                                        .whiteColor, //Theme.of(context).buttonColor,
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                      }),
                    ],
                  ),
                ),
              );
            });
          }
      )
          :
      showModalBottomSheet<dynamic>(
          isScrollControlled: true,
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius. only(topLeft: Radius. circular(15.0), topRight: Radius. circular(15.0)),
          ),
          builder: (context1) {
            return Wrap(
              children: [
                StatefulBuilder(builder: (context, setState1) {
                  return
                    SingleChildScrollView(
                      child: Container(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(Images.starimage,height:200,),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  S .of(context).rate_your_order,
                                  style: TextStyle(fontSize: 18.0,color: ColorCodes.blackColor),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  S .of(context).refund_orderid+ " : " + orderid.toString(),
                                  style: TextStyle(fontSize: 20.0,color: ColorCodes.blackColor,fontWeight: FontWeight.bold),
                                ),

                                SizedBox(
                                  height: 10.0,
                                ),
                                RatingBar.builder(

                                  initialRating: ratings,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 30,
                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star_rate,
                                    color: ColorCodes.primaryColor,
                                  ),

                                  onRatingUpdate: (rating) {
                                    ratings = rating;
                                    if(ratings == 5){
                                      setState1(() {
                                        comment = S .of(context).excellent;//"Excellent";
                                      });

                                    }
                                    else if(ratings == 4){
                                      setState1(() {
                                        comment = S .of(context).good;//"Good";
                                      });

                                    }
                                    else if(ratings == 3){
                                      setState1(() {
                                        comment = S .of(context).average;//"Average";
                                      });

                                    }
                                    else if(ratings == 2){
                                      setState1(() {
                                        comment = S .of(context).bad;//"Bad";
                                      });
                                    }
                                    else if(ratings == 1){
                                      setState1(() {
                                        comment = S .of(context).verybad;//"Very Bad";
                                      });
                                    }
                                  },
                                ),

                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  comment,
                                  style: TextStyle(fontSize: 18.0,color: ColorCodes.blackColor),
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () {
                                      _dialogforProcessing();
                                      RateOrder(ratings,orderid.toString());
                                    },
                                    child: Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width,
                                      //color: ColorCodes.greenColor,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: ColorCodes.greenColor,
                                        border: Border.all(
                                            color: ColorCodes.greenColor),
                                      ),
                                      child: Center(
                                          child: Text(
                                            S .of(context).rate_order.toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: ColorCodes
                                                  .whiteColor, //Theme.of(context).buttonColor,
                                            ),
                                          )),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                }),
              ],
            );
          });
    }
return Column(
  children: [
    Container(
      color: ColorCodes.whiteColor,
      margin: EdgeInsets.only(left: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?0:10,right: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?0:10,top: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?20:10),

      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
              ...widget.splitorder.map((e)
              {
                if (e.ostatus!.toLowerCase() == "received" ||
                    e.ostatus!.toLowerCase() == "ready") {
                  _showreorder = true;
                  _showCancelled = true;
                } else if (e.ostatus!.toLowerCase() == "delivered" ||
                    e.ostatus!.toLowerCase() == "completed") {
                  setState(() {
                    _showreorder = true;
                    _rateorder = true;
                    _showReturn = true;

                  });
                }
                if(e.itemodelcharge !=0){
                  orderamount= double.parse(e.itemoactualamount!) +
                      double.parse(e.itemodelcharge!) - e.loyalty!
                      - double.parse(e.totalDiscount!) + double.parse(e.dueamount!);
                }
                else{
                  orderamount= double.parse(e.itemoactualamount!) - e.loyalty!
                      - double.parse(e.totalDiscount!) + double.parse(e.dueamount!);
                }

                totalamount = totalamount + orderamount;
                itemleftcount = int.parse(e.itemLeftCount!) + 1;

                Widget membershipImage() {
                  if (e.extraAmount == "888") {
                    return Container(
                      width: 75,
                      child: Column(
                        children: [
                          Image.asset(Images.membershipImg,
                            color: Theme.of(context).primaryColor,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container(
                      width: 75,
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            imageUrl: e.itemImage,
                            placeholder: (context, url) => Image.asset(
                              Images.defaultProductImg,
                              width: 75,
                              height: 75,
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              Images.defaultProductImg,
                              width: 75,
                              height: 75,
                            ),
                            width: 75,
                            height: 75,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    );
                  }
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

                Future<void> cancelOrder() async {
                  try {
                    debugPrint("respo....body"+{
                      "id": e.oid,
                      "note": _message.text,
                      "branch": PrefUtils.prefs!.getString('branch'),
                    }.toString());
                    final response = await http.post(Api.cancelOrder, body: {
                      "id": e.oid,
                      "note": _message.text,
                      "branch": PrefUtils.prefs!.getString('branch'),
                    });
                    final responseJson = json.decode(response.body);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    if (responseJson['status'].toString() == "200") {
                      auth.getuserProfile(onsucsess: (value){
                      }, onerror: (){
                      });
                      Navigator.pop(context);
                      Navigation(context, name:Routename.MyOrders,navigatore: NavigatoreTyp.Push,);

                    } else {
                       Fluttertoast.showToast(msg: S .current.something_went_wrong, fontSize: MediaQuery.of(context).textScaleFactor *13,);
                    }
                  } catch (error) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Fluttertoast.showToast(msg: S .current.something_went_wrong, fontSize: MediaQuery.of(context).textScaleFactor *13,);
                    throw error;
                  }
                }

                Widget _myRadioButton({String? title, int? value, required Function(int?) onChanged}) {
                  final addressitemsData =
                  Provider.of<AddressItemsList>(context, listen: false);

                  if (_groupValue == 0) {
                    PrefUtils.prefs!.setString("return_type", "0"); // 0 => Return
                    Future.delayed(Duration.zero, () async {
                      Navigator.pop(context);
                      _groupValue = -1;

                      if (addressitemsData.items.length > 0) {
                        Navigation(context, name:Routename.Return,navigatore: NavigatoreTyp.Push,
                            parms: {
                              'orderid':e.oid!,
                            });
                      } else {
              PrefUtils.prefs!.setString("addressbook", "myorderdisplay");
              if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
              AddressWeb(context,
                addresstype: "new",
                addressid: "",
                delieveryLocation: "",);
              }
              else {
              Navigation(context, name: Routename.AddressScreen, navigatore: NavigatoreTyp.Push,
                  qparms: {
                  'addresstype': "new",
                  'addressid': "",
                  'delieveryLocation': "",
                  });
                }
              }
                    });
                  } else if (_groupValue == 1) {
                    PrefUtils.prefs!.setString("return_type", "1"); // 1 => Exchange
                    Future.delayed(Duration.zero, () async {
                      Navigator.pop(context);
                      _groupValue = -1;
                      if (addressitemsData.items.length > 0) {
                        Navigation(context, name:Routename.Return,navigatore: NavigatoreTyp.Push,
                            parms: {
                              'orderid':e.oid!,
                            });
                      } else {
                        PrefUtils.prefs!.setString(
                            "addressbook", "myorderdisplay");
                        if (Vx.isWeb &&
                            !ResponsiveLayout.isSmallScreen(context)) {
                          // _dialogforaddress(context);
                          AddressWeb(context,
                            addresstype: "new",
                            addressid: "",
                            delieveryLocation: "",
                            orderid: e.oid,
                          );
                        }
                        else {
                          Navigation(context, name: Routename.AddressScreen,
                              navigatore: NavigatoreTyp.Push,
                              qparms: {
                                'addresstype': "new",
                                'addressid': "",
                                'delieveryLocation': "",
                                'orderid': e.oid,
                              });
                        }
                      }
                    });
                  }

                  return RadioListTile<int>(
                    activeColor: Theme.of(context).primaryColor,
                    value: value!,
                    groupValue: _groupValue,
                    onChanged: onChanged,
                    title: Text(title!),
                  );
                }

                _dialogforCancel(BuildContext context) {

                 return (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
                  showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width/3),
                            child: AlertDialog(
                              insetPadding: EdgeInsets.symmetric(horizontal: 40),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              content: Wrap(
                                children: [
                                  StatefulBuilder(builder: (context, setState1) {
                                    return
                                      SingleChildScrollView(
                                        child: Container(
                                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width/3),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Text(  S .of(context).ordered_ID
                                                  // "Order ID: "
                                                  + e.oid!,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0),
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              TextField(
                                                controller: _message,
                                                decoration: InputDecoration(
                                                  hintText:
                                                  S .of(context).reason_optionla,
                                                  //"Reasons (Optional)",
                                                  contentPadding: EdgeInsets.all(16),
                                                  border: OutlineInputBorder(),
                                                ),
                                                minLines: 3,
                                                maxLines: 5,
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              GestureDetector(
                                                onTap: (){
                                                  _dialogforProcessing();
                                                  cancelOrder();
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(left: 50,right: 50,top:30),
                                                  height: 50,
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)),
                                                    color: Theme.of(context).primaryColor,),
                                                  width: MediaQuery.of(context).size.width,
                                                  child: Center(
                                                    child: Text(  S .of(context).next,
                                                      //"Next",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ),
                                      );
                                  }),
                                ],
                              ),
                            ),
                          );
                        });
                      }
                  )
                      :
                   showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.0)),
                            child: Container(
                                width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.40:MediaQuery.of(context).size.width,
                                height: 250.0,
                                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(  S .of(context).ordered_ID
                                        // "Order ID: "
                                        + e.oid!,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    TextField(
                                      controller: _message,
                                      decoration: InputDecoration(
                                        hintText:
                                        S .of(context).reason_optionla,
                                        //"Reasons (Optional)",
                                        contentPadding: EdgeInsets.all(16),
                                        border: OutlineInputBorder(),
                                      ),
                                      minLines: 3,
                                      maxLines: 5,
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    FlatButton(
                                      onPressed: () {
                                        _dialogforProcessing();
                                        cancelOrder();
                                      },
                                      child: Text(  S .of(context).next,
                                        //"Next",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ],
                                )),
                          );
                        });
                      });
                }

               return Padding(
                 padding:  EdgeInsets.symmetric(
                     vertical: 8.0, horizontal: 16),
                 child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Text(
                            S .of(context).refund_orderid + ": ",
                            style: TextStyle(
                                color: ColorCodes.greenColor,
                                //Theme.of(context).primaryColor,
                                fontSize: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?16:14.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "#" + e.oid!,
                            style: TextStyle(
                                color: ColorCodes.greenColor,
                                //Theme.of(context).primaryColor,
                                fontSize: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?16:14.0,
                                fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          (e.orderType!.toLowerCase() == "pickup")
                              ? Row(
                            children: [
                              Text(
                                  e.ostatus
                                      !.toLowerCase()
                                      .toCapitalized(),
                                  style: TextStyle(
                                      color: ColorCodes.greyColor,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold)),
                            ],
                          )
                              : (e.returnStatus == "" ||
                              e.returnStatus == "null")
                              ?

                          //
                          (e.ostatus == "CANCELLED")
                              ? Text(
                              e.ostatus
                                  !.toLowerCase()
                                  .toCapitalized(),
                              style: TextStyle(
                                  color: ColorCodes.redColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold))
                              : Row(
                            children: [
                              Text(
                                  e.ostatus
                                      !.toLowerCase()
                                      .toCapitalized(),
                                  style: TextStyle(
                                      color: ColorCodes
                                          .greyColor,
                                      fontSize: 14.0,
                                      fontWeight:
                                      FontWeight.bold)),
                              SizedBox(
                                width: 5,
                              ),
                              if (e.ostatus!.toLowerCase() ==
                                  "delivered" ||
                                  e.ostatus!.toLowerCase() ==
                                      "completed")
                                Image.asset(Images.delivered,
                                    height: 25.0,
                                    width: 25.0),
                              if (e.ostatus!.toLowerCase() ==
                                  "received")
                                Image.asset(Images.received,
                                    height: 25.0,
                                    width: 25.0),
                              if (e.ostatus!.toLowerCase() ==
                                  "dispatched" ||
                                  e.ostatus!.toLowerCase() ==
                                      "out for delivery")
                                Image.asset(
                                    Images.outdelivery,
                                    height: 25.0,
                                    width: 25.0),
                            ],
                          )
                              : Text(e.returnStatus!.toUpperCase(),
                              style: TextStyle(
                                  color: ColorCodes.redColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),

                      SizedBox(
                        height: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?5:10,
                      ),

                      Row(
                        children: [
                          Text(
                            //"+ " +
                            itemleftcount.toString() +
                                " " +
                                S .of(context).items,
                            //   " more items",
                            style: TextStyle(color: ColorCodes.greyColor),
                          ),
                          Spacer(),
                          if (e.orderType == "express")
                            Row(
                              children: [
                                Text(
                                  e.orderType!.toCapitalized(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: ColorCodes.greyColor),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Image.asset(Images.expressdelivery,
                                    height: 25.0, width: 25.0),
                              ],
                            ),
                        ],
                      ),
                      SizedBox(
                        height: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?5:10,
                      ),
                      Text(
                        Features.iscurrencyformatalign?
                        orderamount.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + ' ' + IConstants.currencyFormat:
                      IConstants.currencyFormat + ' ' + orderamount.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ColorCodes.greyColor),
                      ),

                      SizedBox(
                        height: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?5:10,
                      ),
                      (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
                      Row(
                        children: [
                          Text(
                                      (e.paymentType == "cod".toLowerCase()
                                          ? S .of(context).cash_delivery
                                          : e.paymentType!.toCapitalized()),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: ColorCodes.greyColor),
                                    ),
                           Spacer(),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                if (e.odelivery == "DELIVERY ON") {
                                } else {}
                                if(_isWeb){
                                  (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
                                      OrderhistoryWeb(context,orderid: e.oid,orderstattus: e.ostatus,fromscreen: "webmyOrders")
                                      :
                                  Navigation(context, name:Routename.OrderHistory,navigatore: NavigatoreTyp.Push,
                                      qparms: {
                                        'orderid': e.oid!,
                                        'orderStatus': e.ostatus!,
                                        'fromScreen': "webmyOrders",
                                      });

                                }else{
                                  debugPrint("e.oid!.....1.."+e.oid!);
                                  Navigation(context, name:Routename.OrderHistory,navigatore: NavigatoreTyp.Push,
                                      qparms: {
                                        'orderid': e.oid!,
                                        'orderStatus': e.ostatus!,
                                        'fromScreen': "myOrders",
                                      });
                                }

                              },
                              child: Container(
                                height: 35,
                                child: Row(
                                  children: [
                                    Text(
                                      S .of(context).view_details_order,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: ColorCodes
                                            .greenColor, //Theme.of(context).buttonColor,
                                      ),
                                    ),
                                    SizedBox(width:5),
                                    Icon(Icons.arrow_forward_ios_outlined,color: ColorCodes.primaryColor,size: 15,),

                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ):
                      Text(
                        (e.paymentType == "cod".toLowerCase()
                            ? S .of(context).cash_delivery
                            : e.paymentType!.toCapitalized()),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ColorCodes.greyColor),
                      ),

                      SizedBox(
                        height: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?5:10,
                      ),
                      DottedLine(
                        dashColor: ColorCodes.lightGreyColor,
                      ),
                      if (e.ostatus == "CANCELLED")
                        SizedBox(
                          height: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?5:10,
                        ),
                      if (e.ostatus != "CANCELLED")
                        SizedBox(
                          height: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?5:10,
                        ),
                      if (e.ostatus != "CANCELLED")
                        Row(
                          children: [
                            Text(
                              S .of(context).scheduled_delivery, //widget.odelivery,
                              style: TextStyle(
                                  color: ColorCodes.greyColor,
                                  //Theme.of(context).primaryColor,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              e.odate!,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  color: ColorCodes.darkGrey,
                                  //Theme.of(context).primaryColor,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              e.odeltime!,
                              style: TextStyle(
                                  color: ColorCodes.darkGrey,
                                  //Theme.of(context).primaryColor,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)) Spacer(),

                            (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
                            (e.ostatus!.toLowerCase() == "received" ||
                                e.ostatus!.toLowerCase() == "ready")
                                ? Row(
                              children: [
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () {
                                      _dialogforCancel(context);
                                    },
                                    child: Container(
                                      //width: 140.0,
                                      height: 35.0,
                                      margin: EdgeInsets.only(top: 5.0),
                                      child: Center(
                                          child: Text(
                                            S .of(context).cancel_order,
                                            /*'Re-order',*/
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: ColorCodes.primaryColor,
                                                fontWeight:
                                                FontWeight.bold),
                                          )),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,)
                              ],
                            )
                                :
                            Features.isRateOrderModule?
                            (e.ostatus!.toLowerCase() == "delivered" ||
                                e.ostatus!.toLowerCase() == "completed")
                                ? Row(
                              children: [
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () {
                                      showModalRateOrder(context, setState,e.oid!);
                                    },
                                    child: Container(
                                      //width: 140.0,
                                      height: 35.0,
                                      margin:
                                      EdgeInsets.only(top: 5.0),

                                      child: Center(
                                          child: Text(
                                            S .of(context).rate_order,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: ColorCodes.primaryColor,// color: Theme.of(context)
                                                //     .primaryColor,
                                                fontWeight:
                                                FontWeight.bold),
                                          )),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,)
                              ],
                            )
                                : SizedBox.shrink()
                                :SizedBox.shrink():SizedBox.shrink(),
                          ],
                        ),
                      if(ResponsiveLayout.isSmallScreen(context))
                      if (e.ostatus != "CANCELLED")
                        SizedBox(
                          height: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?5:20,
                        ),
                      if(ResponsiveLayout.isSmallScreen(context))
                      Row(
                        children: [

                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                if (e.odelivery == "DELIVERY ON") {
                                } else {}
                                if(_isWeb){
                                  Navigation(context, name:Routename.OrderHistory,navigatore: NavigatoreTyp.Push,
                                      qparms: {
                                        'orderid': e.oid!,
                                        'orderStatus': e.ostatus!,
                                        'fromScreen': "webmyOrders",
                                      });

                                }else{
                                  debugPrint("e.oid!.....2.."+e.oid!);
                                  Navigation(context, name:Routename.OrderHistory,navigatore: NavigatoreTyp.Push,
                                      qparms: {
                                        'orderid': e.oid!,
                                        'orderStatus': e.ostatus!,
                                        'fromScreen': "myOrders",
                                      });
                                }

                              },
                              child: Container(
                                height: 35,
                                width: 125,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  border: Border.all(
                                      color: ColorCodes.greenColor),
                                ),
                                child: Center(
                                    child: Text(
                                      S .of(context).view_details_order,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: ColorCodes
                                            .greenColor, //Theme.of(context).buttonColor,
                                      ),
                                    )),
                              ),
                            ),
                          ),
                          Spacer(),
                          
                          (e.ostatus!.toLowerCase() == "received" ||
                              e.ostatus!.toLowerCase() == "ready")
                              ? Row(
                            children: [
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    _dialogforCancel(context);
                                  },
                                  child: Container(
                                    width: 140.0,
                                    height: 35.0,
                                    margin: EdgeInsets.only(top: 5.0),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(
                                            3.0),
                                        border: Border(
                                          top: BorderSide(
                                            width: 1.0,
                                            color: ColorCodes.blackColor,
                                          ),
                                          bottom: BorderSide(
                                            width: 1.0,
                                            color: ColorCodes.blackColor,
                                          ),
                                          left: BorderSide(
                                            width: 1.0,
                                            color: ColorCodes.blackColor,
                                          ),
                                          right: BorderSide(
                                            width: 1.0,
                                            color: ColorCodes.blackColor,
                                          ),
                                        )),
                                    child: Center(
                                        child: Text(
                                          S .of(context).cancel_order,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: ColorCodes.blackColor,
                                              // color: Theme.of(context)
                                              //     .primaryColor,
                                              fontWeight:
                                              FontWeight.bold),
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          )
                              :
                          Features.isRateOrderModule?
                            (e.ostatus!.toLowerCase() == "delivered" ||
                              e.ostatus!.toLowerCase() == "completed")
                              ? Row(
                            children: [
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    showModalRateOrder(context, setState,e.oid!);
                                  },
                                  child: Container(
                                    width: 140.0,
                                    height: 35.0,
                                    margin:
                                    EdgeInsets.only(top: 5.0),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(
                                            3.0),
                                        border: Border(
                                          top: BorderSide(
                                            width: 1.0,
                                            color:ColorCodes.badgecolor,
                                          ),
                                          bottom: BorderSide(
                                            width: 1.0,
                                            color:ColorCodes.badgecolor,
                                          ),
                                          left: BorderSide(
                                            width: 1.0,
                                            color:ColorCodes.badgecolor,
                                          ),
                                          right: BorderSide(
                                            width: 1.0,
                                            color:ColorCodes.badgecolor,
                                          ),
                                        )),
                                    child: Center(
                                        child: Text(
                                          S .of(context).rate_order,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: ColorCodes.badgecolor,// color: Theme.of(context)
                                              //     .primaryColor,
                                              fontWeight:
                                              FontWeight.bold),
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          )
                              : SizedBox.shrink()
                          :SizedBox.shrink(),
                        ],
                      ),
                      if(ResponsiveLayout.isSmallScreen(context))
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
               );
              }).toList(),

            ],),
          ),
          if(widget.splitorder.length >1)
          SizedBox(height:10),
          if(widget.splitorder.length >1)
          Container(
            color: ColorCodes.whiteColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    S .of(context).total_order_amount + ": ",
                    style: TextStyle(
                        color: ColorCodes.greenColor,
                        //Theme.of(context).primaryColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    Features.iscurrencyformatalign?
                     totalamount.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + ' ' + IConstants.currencyFormat:
                    IConstants.currencyFormat + ' ' + totalamount.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                    style: TextStyle(
                        color: ColorCodes.greenColor,
                        //Theme.of(context).primaryColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),

                ],
              ),
            ),
          ),
          if(ResponsiveLayout.isSmallScreen(context))
          Divider(),
        ],
      ),
    )

  ],
);


  }
}
