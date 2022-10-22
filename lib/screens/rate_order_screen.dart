import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocbay/constants/features.dart';
import '../assets/ColorCodes.dart';
import '../assets/images.dart';
import '../constants/IConstants.dart';
import '../constants/api.dart';
import '../generated/l10n.dart';
import '../rought_genrator.dart';
import '../screens/myorder_screen.dart';
import '../utils/ResponsiveLayout.dart';
import '../utils/prefUtils.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import 'package:http/http.dart' as http;


class RateOrderScreen extends StatefulWidget {
 // const RateOrderScreen({ Key? key}) : super(key: key);
  static const routeName = '/rateorder-screen';
  Map<String,String> orderid;
  RateOrderScreen(this.orderid);

  @override
  _RateOrderScreenState createState() => _RateOrderScreenState();
}

class _RateOrderScreenState extends State<RateOrderScreen> with Navigations{
  var _isWeb = false;
  bool iphonex = false;
  double ratings = 3.0;
  String comment = S .current.good;//"Good";
  var orderid;
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      try {
        if (Platform.isIOS) {
          setState(() {
            _isWeb = false;
            iphonex = MediaQuery
                .of(context)
                .size
                .height >= 812.0;
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


      final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;

      orderid = widget.orderid['orderid'];
    });

    // TODO: implement initState
    super.initState();

  }


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {
        // this is the block you need
        Navigator.of(context).pop();
        return Future.value(false);
        /*Navigator.of(context).popUntil(ModalRoute.withName(
          HomeScreen.routeName));
        return Future.value(false);*/
      },
      child: Scaffold(
        appBar: ResponsiveLayout.isSmallScreen(context)
            ? gradientappbarmobile()
            : null,
        backgroundColor: ColorCodes.whiteColor,
        body: Column(
          children: <Widget>[
            if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
              Header(false),
            _body(),
          ],
        ),
      ),
    );


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


  Future<void> RateOrder(var rating) async {
    try {
      final response = await http.post(Api.addRatings, body: {
        // await keyword is used to wait to this operation is complete.
        "user": PrefUtils.prefs!.getString('apikey'),
        "order":widget.orderid,
        "star": rating.toString(),
        "comment": comment.toString(),
        "branch": PrefUtils.prefs!.getString('branch'),
      });
      final responseJson = json.decode(response.body);
      Navigator.pop(context);
      Navigator.pop(context);
      if (responseJson['status'].toString() == "200") {
        /*Navigator.of(context).pushReplacementNamed(
          MyorderScreen.routeName,
            arguments: {
              "orderhistory": ""
            }
        );*/
        Navigation(context, name:Routename.MyOrders,navigatore: NavigatoreTyp.Push,
        //     parms: {
        //   "orderhistory": ""
        // }
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
  _body(){
    return Expanded(
      child: SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(Images.starimage,height:300,),
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
              /*Padding(
                padding: _isWeb?EdgeInsets.symmetric(horizontal:700):EdgeInsets.symmetric(horizontal:120.0),
                child: Divider(color: ColorCodes.darkgreen,thickness: 2,),
              ),*/
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
                    setState(() {
                      comment = S .of(context).excellent;//"Excellent";
                    });

                  }
                  else if(ratings == 4){
                    setState(() {
                      comment = S .of(context).good;//"Good";
                    });

                  }
                  else if(ratings == 3){
                    setState(() {
                      comment = S .of(context).average;//"Average";
                    });

                  }
                  else if(ratings == 2){
                    setState(() {
                      comment = S .of(context).bad;//"Bad";
                    });
                  }
                  else if(ratings == 1){
                    setState(() {
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
                    RateOrder(ratings);
                    /*Navigator.of(context).pushReplacementNamed(
                        MyorderScreen.routeName);*/
                  },
                  child: Container(
                    height: 35,
                    width: _isWeb?MediaQuery.of(context).size.width/3:MediaQuery.of(context).size.width/1.5,
                    //color: ColorCodes.greenColor,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: ColorCodes.greenColor,
                      border: Border.all(
                          color: ColorCodes.greenColor),
                      // color: Theme.of(context).primaryColor
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
              if(_isWeb)
              SizedBox(
                height: 30.0,
              ),
              if (_isWeb)
                Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),

            ],
          ),
        ),
      ),
    ),)
      ;
  }
  gradientappbarmobile() {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: (IConstants.isEnterprise)?0:1,
      leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorCodes.iconColor),
          onPressed: () {
            Navigator.of(context).pop();
            /*SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/home-screen', (Route<dynamic> route) => false);
            });*/

            /* Navigator.of(context).popUntil(ModalRoute.withName(
                HomeScreen.routeName));*/

          }),
      titleSpacing: 0,
      title: Text(
        S .of(context).rate_order,
        style: TextStyle(color: ColorCodes.iconColor, fontWeight: FontWeight.bold, fontSize: 18),
      ),
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
}
