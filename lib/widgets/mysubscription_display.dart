import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grocbay/constants/features.dart';
import 'package:intl/intl.dart';
import 'package:flutter/src/widgets/will_pop_scope.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../constants/api.dart';
import '../generated/l10n.dart';
import '../assets/ColorCodes.dart';
import '../rought_genrator.dart';
import '../screens/MySubscriptionScreen.dart';
import '../screens/View_Subscription_Details.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../providers/myorderitems.dart';
import '../constants/IConstants.dart';
import '../assets/images.dart';
import '../utils/ResponsiveLayout.dart';
import '../utils/prefUtils.dart';
import 'bottom_navigation.dart';

class MysubscriptionDisply extends StatefulWidget {
  final String subid;
  final String userid;
  final String varid;
  final String createdtime;
  final String quantity;
  final String delivery;
  final String startdate;
  final String enddate;
  final String addres;
  final String  addressid;
  final String addresstype;
  final String amount;
  final String branch;
  final String slot;
  final String paymenttype;
  final String crontime;
  final String status;
  final String channel;
  final String type;
  final String name;
  final String image;
  final String variation_name;

  MysubscriptionDisply(
      this.subid,
      this.userid,
      this.varid,
      this.createdtime,
      this.quantity,
      this.delivery,
      this.startdate,
      this.enddate,
      this.addres,
      this.addressid,
      this.addresstype,
      this.amount,
      this.branch,
      this.slot,
      this.paymenttype,
      this.crontime,
      this.status,
      this.channel,
      this.type,
      this.name,
      this.image,
      this.variation_name,
      );


  @override
  _MysubscriptionDisplyState createState() => _MysubscriptionDisplyState();

}


class _MysubscriptionDisplyState extends State<MysubscriptionDisply> with Navigations {

  var _message = TextEditingController();
  var _isWeb = false;
  var subscriptionitemsData;
  final TextEditingController datecontroller = new TextEditingController();
  final TextEditingController datecontroller1 = new TextEditingController();

  final now = new DateTime.now();
  DateTime? _selectedDate;
  DateTime? _selectedDate1 ;
  String? enddatestart;

  bool _isLoading = true;
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
    });

    super.initState();
  }

  Future<void> deleteSubscription (String subscriptionid,context) async{
    debugPrint("subscriptionid...."+subscriptionid.toString());
    try {
      final response = await http.post(Api.removeSubscription, body: {
        "id": subscriptionid,
      });

      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      Navigator.pop(context);
      if (responseJson['status'].toString() == "200") {
      /*  Navigator.of(context).pushReplacementNamed(
          MySubscriptionScreen.routeName,
        );*/
        Navigation(context, name: Routename.MySubscription, navigatore: NavigatoreTyp.Push,);
      } else {
        Fluttertoast.showToast(msg: S .current.something_went_wrong, fontSize: MediaQuery.of(context).textScaleFactor *13,);
      }
    } catch (error) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: S .current.something_went_wrong, fontSize: MediaQuery.of(context).textScaleFactor *13,);
      throw error;
    }
  }

  ShowpopupforResume(String date) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: (){
            SystemNavigator.pop();
            return Future.value(false);
          },
          child: AlertDialog(
            title: Image.asset(
              Images.logoImg,
              height: 50,
              width: 138,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(S .of(context).Resumemsg +" "+ date,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  S .of(context).ok,
                  style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: ColorCodes.greenColor),
                ),
                onPressed: () async {
                 // Navigator.of(context).pushReplacementNamed(MySubscriptionScreen.routeName);
                  Navigation(context, name: Routename.MySubscription, navigatore: NavigatoreTyp.Push);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> ResumeSubscription (String subscriptionid) async{
    final now = new DateTime.now();
    final date = DateFormat("yyyy-MM-dd").format(now);
    try {
    debugPrint("resume...."+{
      "paused_date": PrefUtils.prefs!.getString('pauseStartDate'),
      "user": PrefUtils.prefs!.getString('apikey'),
      "id": subscriptionid,
      "date": date,
      "resumeddate":date,
      "hihi":widget.startdate
    }.toString());
      final response = await http.post(Api.resumeSubscription, body: {
        "paused_date": widget.startdate,
        "user": PrefUtils.prefs!.getString('apikey'),
        "id": subscriptionid,
        "date": date,
       "resumeddate":date,
      });

      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      debugPrint("resume...."+responseJson.toString());
      //Navigator.pop(context);
      if (responseJson['status'].toString() == "200") {
       // Fluttertoast.showToast(msg: S .current.Resumemsg, fontSize: MediaQuery.of(context).textScaleFactor *13,);
        ShowpopupforResume(DateFormat("dd-MM-yyyy").format(now));
      } else {
        Fluttertoast.showToast(msg: S .current.something_went_wrong, fontSize: MediaQuery.of(context).textScaleFactor *13,);
      }
    } catch (error) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: S .current.something_went_wrong, fontSize: MediaQuery.of(context).textScaleFactor *13,);
      throw error;
    }
  }

  ShowpopupforPause() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: (){
            SystemNavigator.pop();
            return Future.value(false);
          },
          child: AlertDialog(
              title: Image.asset(
                Images.logoImg,
                height: 50,
                width: 138,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                      child: Text(S .of(context).pauseTitle,
                        style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: ColorCodes.greenColor),)
                  ),
                  SizedBox(height: 10,),
                  Center(
                    child: Text(S .of(context).pauseNote,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
              actions: <Widget>[
               FlatButton(
                  child: Text(
                    S .of(context).ok,
                    style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: ColorCodes.greenColor),
                  ),
                  onPressed: () async {
                   // Navigator.of(context).pushReplacementNamed(MySubscriptionScreen.routeName);
                    Navigation(context, name: Routename.MySubscription, navigatore: NavigatoreTyp.Push);
                  },
                ),
              ],
            ),
        );
      },
    );
  }

  Future<void> pauseSubscription(String subId, String date,String enddate,context) async {
    debugPrint("date...."+date);
    PrefUtils.prefs!.setString('pauseStartDate',date);
    try {
      final response = await http.post(Api.pauseSubscription, body: {
        "id": subId,
        "date": date,
        "user": PrefUtils.prefs!.getString('apikey'),
        "enddate": enddate,
      });
      debugPrint("response...."+{
        "id": subId,
        "date": date,
        "user": PrefUtils.prefs!.getString('apikey'),
        "enddate": enddate,
      }.toString());
      final responseJson = json.decode(response.body);

      Navigator.pop(context);
      if (responseJson['status'].toString() == "200") {
        ShowpopupforPause();
        // Navigator.of(context).pushReplacementNamed(MySubscriptionScreen.routeName);
      } else {
        Fluttertoast.showToast(msg: S .of(context).something_went_wrong,//"Something went wrong!!!",
          fontSize: MediaQuery.of(context).textScaleFactor *13,);
      }
    } catch (error) {

      Navigator.pop(context);
      Fluttertoast.showToast(msg: S .of(context).something_went_wrong,//"Something went wrong!!!",
        fontSize: MediaQuery.of(context).textScaleFactor *13,);
      throw error;
    }
  }


  _dialogforDeleteSubscription(BuildContext context, String subscriptionid) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              child: Container(
                  width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.40:MediaQuery.of(context).size.width,
                  height: 100.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Text(
                          S .of(context).are_you_want_delete_subscription,//'Are you sure you want to delete this Subscription?',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: <Widget>[
                          Spacer(),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop(true);
                              },
                              child: Text(
                                S .of(context).no,//'NO',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 14.0),
                              )),
                          SizedBox(
                            width: 20.0,
                          ),
                          GestureDetector(
                              onTap: () {
                                deleteSubscription(subscriptionid,context);
                              },
                              child: Text(
                                S .of(context).yes,//'YES',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 14.0),
                              )),
                          SizedBox(
                            width: 20.0,
                          ),
                        ],
                      )
                    ],
                  )),
            );
          });
        });




  }

  @override
  Widget build(BuildContext context) {
    final orderitemData = Provider.of<MyorderList>(
      context,
      listen: false,
    ).findBySubId(widget.subid);

    debugPrint("_PauseSubsciption...1");
    Widget membershipImage() {
        return Container(
          width: 75,
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: IConstants.BaseDomain  +  widget.image,
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

    Widget _PauseSubsciption(BuildContext context) {
      debugPrint("_PauseSubsciption...");
      debugPrint("difference..."+DateFormat("yyyy-MM-dd").parse(widget.startdate).difference(DateTime.now()).inDays.toString());
      if(DateFormat("yyyy-MM-dd").parse(widget.startdate).difference(DateTime.now()).inDays >= 0){
        _selectedDate = DateFormat("yyyy-MM-dd").parse(widget.startdate);
      }else{
        _selectedDate = DateTime.now().add(Duration(days: 1));
      }

      enddatestart = _selectedDate.toString();
      debugPrint("end..."+enddatestart!);

      _selectedDate1 = DateFormat("yyyy-MM-dd").parse(enddatestart!);


      debugPrint("_selectedDate1..."+_selectedDate.toString()+"   "+widget.startdate+"  "+enddatestart!);
    //  _selectedDate1 = DateFormat("yyyy-MM-dd").parse(_selectedDate);
      debugPrint("_selectedDate...."+_selectedDate.toString());
      datecontroller.text = DateFormat("dd-MM-yyyy").format(_selectedDate!);
      debugPrint("date cont....."+datecontroller.text);
      datecontroller1.text = DateFormat("dd-MM-yyyy").format(_selectedDate1!);
      return StatefulBuilder(
          builder: (context, setState1)
        {
          return SingleChildScrollView(
          child: Container(
           // color: ColorCodes.lightGreyWebColor,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(height: 20,),
                Container(
                  width: MediaQuery.of(context).size.width - 20,
                  //decoration: BoxDecoration(color: Theme.of(context).buttonColor),
                  //color: ColorCodes.lightGreyWebColor,
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Center(
                        child: Container(
                          width: 80,
                          child: CachedNetworkImage(
                            imageUrl: IConstants.BaseDomain + widget.image,
                            placeholder: (context, url) => Image.asset(
                              Images.defaultProductImg,
                              width: 80,
                              height: 80,
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              Images.defaultProductImg,
                              width: 80,
                              height: 80,
                            ),
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                //SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.name,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        Features.iscurrencyformatalign?
                                        double.parse(widget.amount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + " " + IConstants.currencyFormat:
                                        IConstants.currencyFormat + " " + double.parse(widget.amount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.variation_name,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: ColorCodes.primaryColor),
                                      ),
                                    ),


                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),


                              ])),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15,right: 15),
                  width: MediaQuery.of(context).size.width - 20,
                  //height: 50,
                 // alignment: Alignment.centerLeft,
                  child: Text(S .of(context).Pause_Subscription,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: ColorCodes.greenColor)),
                ),

                Container(
                  width: MediaQuery.of(context).size.width - 20,
                 // height:30,
                 // alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 15,right: 15,top: 5),
                  child: Text(S .of(context).All_Subscription,//"Select Dates",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,color: ColorCodes.grey)),
                ),
                SizedBox(height: 20,),
                Container(
                  width: MediaQuery.of(context).size.width - 20,
                  padding: EdgeInsets.only(left: 15,right: 10),
                 // color: ColorCodes.lightGreyWebColor,
                 // decoration: BoxDecoration(color: Theme.of(context).buttonColor),
                 // padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Icon(Icons.calendar_today_outlined, color: ColorCodes.blackColor,size: 20,),
                              SizedBox(width: 12,),
                              Container(
                                  child: Text(S .of(context).select_dates,//"From Date",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: ColorCodes.blackColor,
                                    ),)
                              ),
                            ],
                          ),

                          SizedBox(height: 20,),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: (){
                              _selectDate(setState1,widget.startdate);
                            },
                            child: Row(
                             // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(S .of(context).from_dates,//"From Date",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: ColorCodes.blackColor,
                                  ),),
                                Spacer(),
                                Text(
                                  DateFormat("dd-MM-yyyy").format(_selectedDate!), style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: ColorCodes.greenColor,
                                ),),
                                 SizedBox(width: 10,),
                                 Icon(Icons.arrow_forward_ios, color: ColorCodes.greenColor,size: 20,),
                                 SizedBox(width: 12,)
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          DottedLine(dashColor: ColorCodes.greylight),
                          SizedBox(height: 10),

                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: (){
                              _selectDate1(setState1,DateFormat("dd-MM-yyyy").format(_selectedDate1!));
                            },
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(S .of(context).to_date,//"From Date",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: ColorCodes.blackColor,
                                  ),),
                                Spacer(),
                                Text(
                                  DateFormat("dd-MM-yyyy").format(_selectedDate1!), style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: ColorCodes.greenColor,
                                ),),
                                SizedBox(width: 10,),
                                Icon(Icons.arrow_forward_ios, color: ColorCodes.greenColor,size: 20,),
                                SizedBox(width: 12,)
                              ],
                            ),
                          ),
                          SizedBox(height: 5,),
                        ],
                      ),
                    ],
                  ),
                ),
                BottomNaviagation(
                  itemCount: "0",
                  title: S .of(context).pause,
                  total: "0",
                  onPressed: (){
                    setState(() {
                      pauseSubscription(widget.subid,DateFormat("yyyy-MM-dd").format(_selectedDate!),DateFormat("yyyy-MM-dd").format(_selectedDate1!),context);
                    });
                  },
                ),
          //       Container(
          //       width: MediaQuery.of(context).size.width,
          //     height: 54.0,
          //     child: Row(
          //       children: <Widget>[
          //
          //         GestureDetector(
          //           onTap: (){
          //             pauseSubscription(widget.subid,DateFormat("yyyy-MM-dd").format(_selectedDate),context);
          //           },
          //           child: Container (
          //             color: Theme.of(context).primaryColor,
          //             height: 54,
          //             width: MediaQuery.of(context).size.width * 100 / 100,
          //             child: Column(
          //                 children: <Widget>[
          //                   SizedBox(
          //                     height: 10,
          //                   ),
          //                   Center(
          //                       child: Text(
          //                           S .of(context).pause_subscription,//"Pause Subscription",
          //                           style: TextStyle(
          //                               color: Colors.white,
          //                               fontWeight: FontWeight.bold),
          //                           textAlign: TextAlign.center)),
          //                   SizedBox(
          //                     height: 10,
          //                   ),
          //                 ]
          //             ),
          //           ),
          //         ),
          //
          //       ],
          //     )
          // ),
              ],
            ),
          ),
        );
        }
      );
    }

    return Container(
      margin: EdgeInsets.all(12),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Column(
          children: <Widget>[

            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                membershipImage(),
                SizedBox(
                  width: 10,
                ),
                (ResponsiveLayout.isSmallScreen(context) || ResponsiveLayout.isMediumScreen(context)) ?
                Container(
                  width: MediaQuery.of(context).size.width - 141,
                  child: Column(
                    children: [
                      Row(
                       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Container(
                              width: MediaQuery.of(context).size.width - 200,
                              child: Text(
                                widget.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Text(
                            widget.type,
                            style: TextStyle(
                                color: ColorCodes.badgecolor,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                          ),

                          // Text(
                          //   widget.type,
                          //   style: TextStyle(
                          //       color: ColorCodes.badgecolor,
                          //       fontSize: 14.0,
                          //       fontWeight: FontWeight.bold),
                          // ),
                          // MouseRegion(
                          //   cursor: SystemMouseCursors.click,
                          //   child: GestureDetector(
                          //     behavior: HitTestBehavior.translucent,
                          //     onTap: () {
                          //       showModalBottomSheet<dynamic>(
                          //           isScrollControlled: true,
                          //           context: context,
                          //           //backgroundColor: ColorCodes.lightGreyWebColor,
                          //           shape: RoundedRectangleBorder(
                          //             borderRadius: BorderRadius. only(topLeft: Radius. circular(30.0), topRight: Radius. circular(30.0)),
                          //           ),
                          //           builder: (context) {
                          //             return _PauseSubsciption(context);
                          //           });
                          //       /*showBottomSheet(context: context, builder: (context){
                          //         return _PauseSubsciption();
                          //       });*/
                          //       // Navigator.of(context).pushReplacementNamed(
                          //       //     PauseSubscriptionScreen.routeName,
                          //       //     arguments: {
                          //       //       'orderid': widget.subid,
                          //       //       'image': IConstants.API_IMAGE + '/items/images/' + widget.image,
                          //       //       'name': widget.name,
                          //       //       'quantity': widget.quantity,
                          //       //       'price': widget.amount
                          //       //     }
                          //       // );
                          //     },
                          //     child: Center(
                          //       child: Row(
                          //         mainAxisAlignment: MainAxisAlignment.start,
                          //
                          //         children: [
                          //           Text(
                          //             S .of(context).pause,//'Pause',
                          //             textAlign: TextAlign.center,
                          //             style: TextStyle(
                          //                 fontSize: 14,
                          //                 color: ColorCodes.indigo,
                          //                 fontWeight: FontWeight.bold),
                          //           ),
                          //           SizedBox(width: 10,),
                          //           Icon( Icons.pause_circle_outline,
                          //             color: ColorCodes.indigo,),
                          //
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.variation_name,
                                style: TextStyle(color: ColorCodes.greenColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Features.iscurrencyformatalign?
                                double.parse(widget.amount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + ' ' + IConstants.currencyFormat:
                                IConstants.currencyFormat + ' ' + double.parse(widget.amount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Spacer(),
                          (widget.status == "3")?
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,

                                children: [

                                  Text(
                                    S .of(context).expired,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: ColorCodes.orangeColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ):
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                _dialogforDeleteSubscription( context, widget.subid);
                              },
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,

                                  children: [

                                    Text(
                                      S .of(context).subscription_delete,//'Delete',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: ColorCodes.blackColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 10,),
                                    Icon( Icons.delete_outlined,
                                      color: ColorCodes.orangeColor,),

                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ):
                Container(
                  width: MediaQuery.of(context).size.width - 230,
                  child: Column(
                    children: [
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Container(
                              width: MediaQuery.of(context).size.width - 200,
                              child: Text(
                                widget.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          (widget.status == "1")?
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                // _dialogforResumeSubscription( context, widget.subid);
                                ResumeSubscription(widget.subid);

                              },
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,

                                  children: [
                                    Text(
                                      S .of(context).resume,//'resume',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: ColorCodes.indigo,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 10,),
                                    Icon( Icons.play_circle_fill,
                                      color: ColorCodes.indigo,),

                                  ],
                                ),
                              ),
                            ),
                          ):
                          (widget.status == "4")?
                          Text(
                              S .of(context).failure,
                              style: TextStyle(
                                  color: ColorCodes.greyColor,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold)):
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                showModalBottomSheet<dynamic>(
                                    isScrollControlled: true,
                                    context: context,
                                    //backgroundColor: ColorCodes.lightGreyWebColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius. only(topLeft: Radius. circular(30.0), topRight: Radius. circular(30.0)),
                                    ),
                                    builder: (context) {
                                      return _PauseSubsciption(context);
                                    });
                                /*showBottomSheet(context: context, builder: (context){
                                  return _PauseSubsciption();
                                });*/
                                // Navigator.of(context).pushReplacementNamed(
                                //     PauseSubscriptionScreen.routeName,
                                //     arguments: {
                                //       'orderid': widget.subid,
                                //       'image': IConstants.API_IMAGE + '/items/images/' + widget.image,
                                //       'name': widget.name,
                                //       'quantity': widget.quantity,
                                //       'price': widget.amount
                                //     }
                                // );
                              },
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,

                                  children: [
                                    Text(
                                      S .of(context).pause,//'Pause',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: ColorCodes.indigo,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 10,),
                                    Icon( Icons.pause_circle_outline,
                                      color: ColorCodes.indigo,),

                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.variation_name,
                                style: TextStyle(color: ColorCodes.greenColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Features.iscurrencyformatalign?
                                double.parse(widget.amount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + ' ' + IConstants.currencyFormat:
                                IConstants.currencyFormat + ' ' + double.parse(widget.amount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Spacer(),
                          (widget.status == "3")?
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,

                                children: [

                                  Text(
                                    S .of(context).expired,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: ColorCodes.orangeColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ):
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                _dialogforDeleteSubscription( context, widget.subid);
                              },
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,

                                  children: [

                                    Text(
                                      S .of(context).subscription_delete,//'Delete',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: ColorCodes.orangeColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 10,),
                                    Icon( Icons.delete_outlined,
                                      color: ColorCodes.orangeColor,),

                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            /*SizedBox(
              height: 10,
            ),

            Divider(
              color: Color(0xffA9A9A9),
            ),*/
            SizedBox(
              height: 10,
            ),
            Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                   /*  Row(
                      children: [
                        MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed(
                              PauseSubscriptionScreen.routeName,
                              arguments: {
                                'orderid': widget.subid,
                                'image': IConstants.API_IMAGE + '/items/images/' + widget.image,
                                'name': widget.name,
                                'quantity': widget.quantity,
                                'price': widget.amount
                              }
                          );
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,

                            children: [
                              Icon( Icons.pause_circle_outline,
                                color: ColorCodes.grey,),
                              SizedBox(width: 10,),
                              Text(
                                S .of(context).pause,//'Pause',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: ColorCodes.blackColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                ),
                        Spacer(),
                        MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  _dialogforDeleteSubscription( context, widget.subid);
                                },
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,

                                    children: [
                                      Icon( Icons.delete,
                                        color: ColorCodes.grey,),
                                      SizedBox(width: 10,),
                                      Text(
                                        S .of(context).subscription_delete,//'Delete',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: ColorCodes.blackColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        ),
                        (_isWeb && !ResponsiveLayout.isSmallScreen(context))?
                        SizedBox(width: 40,):
                            SizedBox.shrink()
              ],
            ),*/
                     SizedBox(height: 13,),
                     Row(
                       children: [
                         GestureDetector(
                           behavior: HitTestBehavior.translucent,
                           onTap: () {
                           /*  Navigator.of(context).pushNamed(
                                 ViewSubscriptionDetails.routeName,
                                 arguments: {
                                   'orderid': widget.subid,
                                   "fromScreen" : "",
                                 });*/
                             Navigation(context, name:Routename.ViewSubscriptionDetails,navigatore: NavigatoreTyp.Push,
                                 qparms: {
                                   'orderid': widget.subid,
                                   "fromScreen" : "",
                                 });
                           },
                           child: Container(
                             padding: EdgeInsets.only(left: 3,right: 3),
                             height: 50,
                             width: MediaQuery.of(context).size.width/2.5,
                             decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(3),
                                 border:
                                 Border.all(color: ColorCodes.greenColor),
                               /*  color: Theme.of(context).primaryColorColorCodes.whiteColor*/),
                             child: Center(
                               child: Text(
                                 S .of(context).view_details_order,//"View Subscription Details",
                                 textAlign: TextAlign.center,
                                 //maxLines: 2,
                                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: ColorCodes.greenColor,),
                               ),
                             ),
                            ),



                         ),
                         Spacer(),

                         (widget.status == "1")?
                         MouseRegion(
                           cursor: SystemMouseCursors.click,
                           child: GestureDetector(
                             behavior: HitTestBehavior.translucent,
                             onTap: () {
                               // _dialogforResumeSubscription( context, widget.subid);
                               ResumeSubscription(widget.subid);

                             },
                             child: Container(
                               padding: EdgeInsets.only(left: 3,right: 3),
                               height: 50,
                               width: MediaQuery.of(context).size.width/2.5,
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(3),
                                 border:
                                 Border.all(color: ColorCodes.badgecolor),
                                 /*  color: Theme.of(context).primaryColorColorCodes.whiteColor*/),
                               child: Center(
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.center,

                                   children: [
                                     Text(
                                       S .of(context).resume,//'resume',
                                       textAlign: TextAlign.center,
                                       style: TextStyle(
                                           fontSize: 14,
                                           color: ColorCodes.badgecolor,
                                           fontWeight: FontWeight.bold),
                                     ),
                                     SizedBox(width: 10,),
                                     Icon( Icons.play_circle_fill,
                                       color: ColorCodes.badgecolor,),

                                   ],
                                 ),
                               ),
                             ),
                           ),
                         ):
                         (widget.status == "4")?
                         Container(
                           padding: EdgeInsets.only(left: 3,right: 3),
                           height: 50,
                           width: MediaQuery.of(context).size.width/2.5,
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(3),
                             border:
                             Border.all(color: ColorCodes.redColor),
                             /*  color: Theme.of(context).primaryColorColorCodes.whiteColor*/),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Text(
                                   S .of(context).failure,
                                   style: TextStyle(
                                       color: ColorCodes.redColor,
                                       fontSize: 14.0,
                                       fontWeight: FontWeight.bold)),
                             ],
                           ),
                         ):
                         GestureDetector(
                           behavior: HitTestBehavior.translucent,
                           onTap: () {
                             showModalBottomSheet<dynamic>(
                                 isScrollControlled: true,
                                 context: context,
                                 //backgroundColor: ColorCodes.lightGreyWebColor,
                                 shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius. only(topLeft: Radius. circular(30.0), topRight: Radius. circular(30.0)),
                                 ),
                                 builder: (context) {
                                   return _PauseSubsciption(context);
                                 });
                           },
                           child: Container(
                             padding: EdgeInsets.only(left: 3,right: 3),
                             height: 50,
                              width: MediaQuery.of(context).size.width/2.5,
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(3),
                               border:
                               Border.all(color: ColorCodes.greenColor),
                               /*  color: Theme.of(context).primaryColorColorCodes.whiteColor*/),
                             child: Center(
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.center,

                                 children: [
                                   Text(
                                     S .of(context).pause,//'Pause',
                                     textAlign: TextAlign.center,
                                     style: TextStyle(
                                         fontSize: 14,
                                         color: ColorCodes.primaryColor,
                                         fontWeight: FontWeight.bold),
                                   ),
                                   SizedBox(width: 10,),
                                   Icon( Icons.pause,
                                     color: ColorCodes.primaryColor,),

                                 ],
                               ),
                             ),
                           ),



                         ),
                       ],
                     ),

                   ],
                 ),

          ],
        ),
      ),
    );



  }

  Future<void> _selectDate(setState, String startdate) async {
    var now = new DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: (DateFormat("yyyy-MM-dd").parse(widget.startdate).difference(DateTime.now()).inDays >= 0) ?DateFormat("yyyy-MM-dd").parse(startdate) : DateTime.now().add(Duration(days: 1)),
      firstDate: (DateFormat("yyyy-MM-dd").parse(widget.startdate).difference(DateTime.now()).inDays >= 0) ?DateFormat("yyyy-MM-dd").parse(startdate) : DateTime.now().add(Duration(days: 1)),
      lastDate: new DateTime(now.year, now.month + 10, now.day),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor:  Theme.of(context).accentColor,//Head background
            accentColor: Theme.of(context).accentColor,//selection color
          ),// This will change to light theme.
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        _selectedDate1 = picked;
        datecontroller
          ..text = DateFormat("dd-MM-yyyy").format(_selectedDate!)
          ..selection = TextSelection.fromPosition(TextPosition(
              offset: datecontroller.text.length,
              affinity: TextAffinity.upstream));
      });
  }

  Future<void> _selectDate1(setState, String startdate) async {
    var now = new DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:_selectedDate1! ,
      firstDate: _selectedDate1!,
      lastDate: new DateTime(now.year, now.month + 10, now.day),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor:  Theme.of(context).accentColor,//Head background
            accentColor: Theme.of(context).accentColor,//selection color
          ),// This will change to light theme.
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate1)
      setState(() {
        _selectedDate1 = picked;
        datecontroller1
          ..text = DateFormat("dd-MM-yyyy").format(_selectedDate1!)
          ..selection = TextSelection.fromPosition(TextPosition(
              offset: datecontroller1.text.length,
              affinity: TextAffinity.upstream));
      });
  }

}
