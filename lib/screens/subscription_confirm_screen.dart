import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:grocbay/constants/features.dart';
import 'package:intl/intl.dart';
import '../../models/VxModels/VxStore.dart';
import 'package:velocity_x/velocity_x.dart';
import '../rought_genrator.dart';
import '../screens/View_Subscription_Details.dart';
import '../constants/api.dart';
import '../assets/ColorCodes.dart';
import '../constants/IConstants.dart';
import '../screens/MySubscriptionScreen.dart';
import '../screens/home_screen.dart';
import '../utils/ResponsiveLayout.dart';
import '../utils/prefUtils.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../widgets/simmers/orderconfirmation_shimmer.dart';
import 'package:http/http.dart' as http;
import '../generated/l10n.dart';

class SubscriptionConfirmScreen extends StatefulWidget {
  static const routeName = '/subscriptionconfirm-screen';

  Map<String,String> params;
  SubscriptionConfirmScreen(this.params);
  @override
  _SubscriptionConfirmScreenState createState() => _SubscriptionConfirmScreenState();
}

class _SubscriptionConfirmScreenState extends State<SubscriptionConfirmScreen> with Navigations {

  bool _issubscriptionstatus = true;
  bool _isLoading = true;
  bool _isWeb = false;
  bool iphonex = false;
  var name = "";
  var subid = "";
  late MediaQueryData queryData;
  late double wid;
  late double maxwid;
  GroceStore store = VxState.store;
  @override
  void initState() {

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

      final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      final subscriptionstatus = /*routeArgs['orderstatus']*/widget.params['orderstatus'];
      subid = /*routeArgs['sorderId']!*/widget.params['sorderId']!;
      if(subscriptionstatus == "success"){
          setState(() {
            _issubscriptionstatus = true;
            _isLoading = false;
          });

      } else {
        final orderId = /*routeArgs['sorderId']*/widget.params['sorderId'];
        paymentStatus(orderId!);
      }
      setState(() {
        /*if (PrefUtils.prefs!.getString('FirstName') != null) {
          if (PrefUtils.prefs!.getString('LastName') != null) {
            name = PrefUtils.prefs!.getString('FirstName') +
                " " +
                PrefUtils.prefs!.getString('LastName');
          } else {
            name = PrefUtils.prefs!.getString('FirstName');
          }
        } else {
          name = "";
        }*/
        name = store.userData.username!;
      });
    });
    super.initState();
  }
  Future<void> paymentStatus(String orderId) async { // imp feature in adding async is the it automatically wrap into Future.

    var url = Api.getSubscriptionPaymentStatus + orderId;
    try {
      final response = await http.get(url,);
      final responseJson = json.decode(response.body);
      if(responseJson['status'].toString() == "1") {
        PrefUtils.prefs!.remove("subscriptionorderId");

          setState(() {
            _issubscriptionstatus = true;
            _isLoading = false;
          });

      } else {
        setState(() {
          _issubscriptionstatus = false;
          _isLoading = false;
        });

      }
    } catch (error) {
      throw error;
    }
  }
  @override
  Widget build(BuildContext context) {

    gradientappbarmobile() {
      return  AppBar(
        brightness: Brightness.dark,
        toolbarHeight: 60.0,
        elevation: (IConstants.isEnterprise)?0:1,

        automaticallyImplyLeading: false,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: ColorCodes.iconColor),onPressed: () {
          SchedulerBinding.instance!.addPostFrameCallback((_) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/home-screen', (Route<dynamic> route) => false);
          });

        } ),
        title: Text(S .current.subscription_confirmation,
            style: TextStyle(color: ColorCodes.iconColor, fontWeight: FontWeight.bold, fontSize: 18)
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
                  ]
              )
          ),
        ),
      );
    }

    return WillPopScope(

    onWillPop: () { // this is the block you need
        Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
        return Future.value(false);
      },
      child: Scaffold(
       /* appBar: ResponsiveLayout.isSmallScreen(context) ?
        gradientappbarmobile() : null,*/
        backgroundColor: ColorCodes.lightGreyWebColor,
        body:Column(
          children: <Widget>[
            if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
              Header(false),
            _body(),
          ],
        ),
       /* bottomNavigationBar:  _isWeb ? SizedBox.shrink() :Container(
          color: Colors.white,
          child: Padding(
              padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
              child: _buildBottomNavigationBar()
          ),
        ),*/
      ),
    );
  }

  _buildBottomNavigationBar() {
    return SingleChildScrollView(
      child: Container(
        width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.20:MediaQuery.of(context).size.width,
        color: Theme.of(context).primaryColor,
        height: 50.0,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
              onTap: () {
              //  Navigator.of(context).pushReplacementNamed(MySubscriptionScreen.routeName);
                Navigation(context, name: Routename.MySubscription, navigatore: NavigatoreTyp.Push);
              },
              child: Align(
                  alignment: Alignment.center,
                  child: Text(S .current.check_your_subscription, style: TextStyle(color: Theme.of(context).buttonColor),))),
        ),
      ),
    );
  }
  _body(){
    return _isWeb?_bodyweb():
    _bodymobile();
  }
  _bodymobile() {
    return _isLoading ?
    Center(
      child: OrderConfirmationShimmer(),//CircularProgressIndicator(),
    )
        :
    Expanded(
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 37),
              Container(

                height:MediaQuery.of(context).size.height/2.5,
                color: ColorCodes.varcolor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _issubscriptionstatus ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Icon(
                            Icons.check_circle, color: ColorCodes.primaryColor, size: 50,),
                        ),
                      )
                          :
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Icon(Icons.cancel, color: Colors.red, size: 50.0),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        S .of(context).hi//'Thank You for Choosing '
                            + name + ',',
                        style: TextStyle(fontSize: 20.0, color: ColorCodes.primaryColor),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 20),
                      _issubscriptionstatus ? Text(
                        S .current.your_subscription_will_start_from + (DateFormat("dd-MM-yyyy").format(DateTime.parse(PrefUtils.prefs!.getString("startDate")!)).toString()),
                        style: TextStyle(fontSize: 25.0, color: ColorCodes.primaryColor),
                        // textAlign: TextAlign.center,
                      ):
                      Text(
                        S .current.subscription_canceled,
                        style: TextStyle(fontSize: 25.0, color: ColorCodes.primaryColor),
                        // textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            S .of(context).order + "#" +subid,
                            style: TextStyle(fontSize: 16 , color: ColorCodes.primaryColor),
                          ),

                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: (){
                        /*  Navigator.of(context).pushNamed(
                              ViewSubscriptionDetails.routeName,
                              arguments: {
                                'orderid': subid,
                                "fromScreen" : "subscConfirmation",
                              });*/
                          Navigation(context, name:Routename.ViewSubscriptionDetails,navigatore: NavigatoreTyp.Push,
                              qparms: {
                                'orderid': subid,
                                "fromScreen" : "subscConfirmation",
                              });

                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width ,
                          // height: 32,
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                              width: 1.0,
                              color: ColorCodes.greenColor,
                            ),
                          ),
                          child: Text(
                            S .of(context).view_details,//"LOGIN USING OTP",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                color: ColorCodes.greenColor),
                          ),
                        ),
                      ),


                    ],
                  ),
                ),
              ),
              if(_isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
            ]
        ),
      ),

    );
  }

  _bodyweb() {
    queryData = MediaQuery.of(context);
    wid= queryData.size.width;
    maxwid=wid*0.90;
    return     Expanded(
      child: SingleChildScrollView(
        child:  Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //SizedBox(height: 37),
                Container(
                  height:MediaQuery.of(context).size.height/2,
                  width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
                  color: ColorCodes.ordergreen,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _issubscriptionstatus ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Icon(
                              Icons.check_circle, color: ColorCodes.whiteColor, size: 50,),
                          ),
                        )
                            :
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Icon(Icons.cancel, color: Colors.red, size: 50.0),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          S .of(context).hi//'Thank You for Choosing '
                              + name + ',',
                          style: TextStyle(fontSize: 20.0, color: ColorCodes.whiteColor),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 20),
                        _issubscriptionstatus ? Text(
                          S .current.your_subscription_will_start_from + PrefUtils.prefs!.getString("startDate")!,
                          style: TextStyle(fontSize: 25.0, color: ColorCodes.whiteColor),
                          // textAlign: TextAlign.center,
                        ):
                        Text(
                          S .current.subscription_canceled,
                          style: TextStyle(fontSize: 25.0, color: ColorCodes.whiteColor),
                          // textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              S .of(context).order + "#" +subid,
                              style: TextStyle(fontSize: 16 , color: ColorCodes.whiteColor),
                            ),

                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (){
                            /*Navigator.of(context).pushNamed(
                                ViewSubscriptionDetails.routeName,
                                arguments: {
                                  'orderid': subid,
                                  "fromScreen" : "subscConfirmation",
                                });*/
                            Navigation(context, name:Routename.ViewSubscriptionDetails,navigatore: NavigatoreTyp.Push,
                                qparms: {
                                  'orderid': subid,
                                  "fromScreen" : "subscConfirmation",
                                });
                          },
                          child: Container(
                              width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
                            // height: 32,
                            padding: EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                width: 1.0,
                                color: ColorCodes.greenColor,
                              ),
                            ),
                            child: Text(
                              S .of(context).view_details,//"LOGIN USING OTP",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                  color: ColorCodes.greenColor),
                            ),
                          ),
                        ),


                      ],
                    ),
                  ),
                ),
                if(_isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
              ]
          ),
        ),
      ),
    );
  }

}
