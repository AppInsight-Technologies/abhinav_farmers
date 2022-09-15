import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../assets/ColorCodes.dart';
import '../../constants/IConstants.dart';
import '../../utils/ResponsiveLayout.dart';

import '../assets/images.dart';
import '../models/newmodle/subscription_data.dart';
import '../rought_genrator.dart';
import '../utils/prefUtils.dart';
import '../widgets/header.dart';

class SubscriptionBox  extends StatefulWidget{
  @override
  _SubscriptionBoxState createState() => _SubscriptionBoxState();
}
class _SubscriptionBoxState extends State<SubscriptionBox> with Navigations {
  bool _isWeb =false;
  bool iphonex = false;
  late Future<List<Subscription>> _subscription = Future.value([]);
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      //  productBoxSub = Hive.box<Subscription>(productBoxNameSub);
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
      subscriptionApibox.getSubsctiptionBox(ParamBodyDatabox(type: "all", branch: PrefUtils.prefs!.getString("branch"), languageid: IConstants.languageId, user: !(PrefUtils.prefs!.containsKey("apikey")) ? PrefUtils.prefs!.getString("tokenid") !: PrefUtils.prefs!.getString('apikey')!)).then((value){
        setState(() {
          _subscription = Future.value(value);
        });
      });
      });
      super.initState();
  }
  @override
  Widget build(BuildContext context) {
    gradientappbarmobile() {
      return  AppBar(
        brightness: Brightness.dark,
        toolbarHeight: 60.0,

        elevation: (IConstants.isEnterprise)?0:1,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: ColorCodes.iconColor),
            onPressed: () async {
              // Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
              Navigation(context, navigatore: NavigatoreTyp.homenav);
              // Navigator.of(context).pop();
              return Future.value(false);
            }
        ),
        titleSpacing: 0,
        title: Text("All Subscription Box",
          style: TextStyle(color: ColorCodes.iconColor),),
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
    return WillPopScope(
      onWillPop: (){
        Navigation(context, navigatore: NavigatoreTyp.homenav);
        // Navigator.of(context).pop();
        return Future.value(false);
      },
      child: Scaffold (
        appBar: ResponsiveLayout.isSmallScreen(context) ?
        gradientappbarmobile() : null,
        backgroundColor:  ColorCodes.whiteColor,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
                Header(false),
              _body(),
            ],
          ),
        ),
        // bottomNavigationBar:(_isWeb && !ResponsiveLayout.isSmallScreen(context))?SizedBox.shrink(): bottomNavigationbar(),
      ),
    );
  }
  _body(){
    return Container(
      padding: EdgeInsets.all(10),
      child:  FutureBuilder<List<Subscription>>(
          future: _subscription,
          builder: (BuildContext context,
              AsyncSnapshot<List<Subscription>> snapshot) {
            final promoData = snapshot.data;

            return (promoData != null && promoData.length > 0) ?
            new ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: promoData.length,
              itemBuilder: (_, i) {
                return GestureDetector(
                  onTap: () {
                    if(PrefUtils.prefs!.containsKey("apikey") == false){
                      /*Navigator.of(context).pushNamed(
                        SignupSelectionScreen.routeName,
                      )*/
                      Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push);
                    }else {
                      if (promoData[i].subscriptionType == "0") {
                        Navigation(context,
                            name: Routename.SubscribeDescription,
                            navigatore: NavigatoreTyp.Push,
                            qparms: {
                              "index": i,
                            });
                      }else{
                        Navigation(context,
                            name: Routename.SubscribeScreen,
                            navigatore: NavigatoreTyp.Push,
                            qparms: {
                              "itemid": promoData[i].id,
                              "index": i,
                              //"items": promoData[i].boxProducts,
                              "fromScreen": "home",
                              "addressid": "",
                              "useraddtype": "",
                              "startDate": "",
                              "endDate": "",
                              "itemCount": "",
                              "deliveries": "",
                              "total": "",
                              "schedule": "",
                              "itemimg": "",
                              "itemname": "",
                              "varprice": "",
                              "varname": "",
                              "address": "",
                              "paymentMode": "",
                              "cronTime": "",
                              "name": "",
                              "varid": "",
                              "varmrp": "",
                              "brand": "",
                              "deliveriesarray": "",
                              "daily": "",
                              "dailyDays": "",
                              "weekend": "",
                              "weekendDays": "",
                              "weekday": "",
                              "weekdayDays": "",
                              "custom": "",
                              "customDays": "",
                              "subscriptionType": promoData[i].subscriptionType
                            });
                      }
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
                    margin: EdgeInsets.only(left: 10.0, top: 5.0, right: 10.0, bottom: 5.0),
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        //border: Border.all(color: Colors.black26),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[300]!,
                              blurRadius: 10.0,
                              offset: Offset(0.0, 0.50)),
                        ],
                        borderRadius: new BorderRadius.all(
                          const Radius.circular(8.0),)),
                    child: Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl: promoData[i].featuredImage!, fit: BoxFit.fill,
                          width: MediaQuery.of(context).size.width,
                          errorWidget: (context, url, error) => Image.asset(Images.defaultSliderImg),
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: Text(promoData[i].boxName!,
                                maxLines: 2,
                                style:
                                TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 16 : ResponsiveLayout.isMediumScreen(context) ? 13 : 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(IConstants.currencyFormat + "" + promoData[i].boxPrice!,
                              maxLines: 2,
                              style:
                              TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 16 : ResponsiveLayout.isMediumScreen(context) ? 13 : 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            )

                :
            SizedBox.shrink();
          }
      ),
    );

  }

}