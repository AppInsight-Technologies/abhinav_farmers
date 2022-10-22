import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:grocbay/constants/features.dart';
import 'package:grocbay/controller/mutations/address_mutation.dart';
import 'package:grocbay/controller/mutations/home_screen_mutation.dart';
import 'package:grocbay/controller/mutations/home_store_mutation.dart';
import 'package:grocbay/models/VxModels/VxStore.dart';
import 'package:grocbay/widgets/simmers/home_screen_shimmer.dart';
import 'package:velocity_x/velocity_x.dart';
import '../generated/l10n.dart';
import '../rought_genrator.dart';
import '../utils/prefUtils.dart';
import '../screens/refer_screen.dart';
import '../utils/ResponsiveLayout.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';
import '../assets/ColorCodes.dart';
import '../screens/about_screen.dart';
import '../screens/privacy_screen.dart';
import '../constants/IConstants.dart';
import 'dart:io';

class PolicyScreen extends StatefulWidget {
  static const routeName = '/policy-screen';

  Map<String,String> params;
  PolicyScreen(this.params);
  @override
  _PolicyScreenState createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> with Navigations {
  bool _iscontactus = false;
  bool _isWeb =false;
  late MediaQueryData queryData;
  late double wid;
  late double maxwid;

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final title = widget.params['title'];
    //final body = widget.params['body'];
    String body = "";

    if(title == "Refer") {
      body = PrefUtils.prefs!.getString("refer")!;
    } else if(title == S .of(context).term_and_condition) {
      body = IConstants.restaurantTerms;
    } else if(title == S .of(context).privacy || title == S .of(context).privacy_policy) {
      body = PrefUtils.prefs!.getString("privacy")!;
    } else if(title == S .of(context).returns) {
      body = IConstants.returnsPolicy;
    } else if(title == S .of(context).refund) {
      body = IConstants.refundPolicy;
    } else if(title == S .of(context).about_us) {
      body = PrefUtils.prefs!.getString("description")!;
    } else if(title == S .of(context).terms_of_use || title == S .of(context).terms_of_service) {
      body = IConstants.restaurantTerms;
    } else if(title == S .of(context).wallet) {
      body = IConstants.walletPolicy;
    }else if(title == S .of(context).faq){
      body = IConstants.faquestions;
    }
print("titlede" + title.toString());
    if(title == "Contact Us") {
      _iscontactus = true;
    } else {
      _iscontactus = false;
    }
    
    gradientappbarmobile() {
      return  AppBar(
        brightness: Brightness.dark,
        toolbarHeight: 60.0,
        elevation: (IConstants.isEnterprise)?0:1,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: ColorCodes.iconColor),
            onPressed: () async {
              if(title == "Contact Us" || title == "About Us") {
                /*Navigator.of(context).popUntil(
                    ModalRoute.withName(AboutScreen.routeName,));*/
                Features.ismultivendor ? Navigation(context, navigatore: NavigatoreTyp.homenav) :
                Navigation(context, name: Routename.AboutUs, navigatore: NavigatoreTyp.Push);
              }else if(title == "Refer" ){
                /*Navigator.of(context).popUntil(
                    ModalRoute.withName(ReferEarn.routeName,));*/
                Navigation(context, name:Routename.Refer,navigatore: NavigatoreTyp.homenav
                );
              }else if(title == "Privacy"){
               /* Navigator.of(context).popUntil(
                    ModalRoute.withName(PrivacyScreen.routeName,));*/
                Navigation(context, name: Routename.Privacy, navigatore: NavigatoreTyp.Push);
              }
              else{
                Navigator.of(context).pop();
              }
              return Future.value(false);
            }
        ),
        titleSpacing: 0,
        title: Text(title!,
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
    _body() {
       /*_isloading ?
      Center(
        child: CircularProgressIndicator(),
      ) :*/
      queryData = MediaQuery.of(context);
      wid= queryData.size.width;
      maxwid=wid*0.90;
     return Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                constraints: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid):null,

                child: Column(
                  children: <Widget>[
                    _iscontactus ?
                    Column(
                      children: <Widget>[
                        SizedBox(height: 10.0,),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 10.0,),
                            Text(
                                S .of(context).business_name,
                              // "Business Name",
                              style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),),
                          ],
                        ),
                        SizedBox(height: 5.0,),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 10.0,),
                            Text((Features.ismultivendor && IConstants.isEnterprise) ? IConstants.restaurantName : IConstants.APP_NAME, style: TextStyle(fontSize: 14.0),),
                          ],
                        ),
                        SizedBox(height: 10.0,),
                        Divider(),
                        SizedBox(height: 10.0,),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 10.0,),
                            Text(
                              S .of(context).address,
                              // "Address",
                              style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0),),
                          ],
                        ),
                        SizedBox(height: 5.0,),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 10.0,),
                            Expanded(child: Text(
                              PrefUtils.prefs!.getString("restaurant_address")!, style: TextStyle(fontSize: 14.0),)),
                          ],
                        ),
                        SizedBox(height: 10.0,),
                        Divider(),
                        SizedBox(height: 10.0,),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 10.0,),
                            Text(
                                S .of(context).contactnumber,
                              // "Contact Number",
                              style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0),),
                          ],
                        ),
                        SizedBox(height: 5.0,),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 10.0,),
                            Text((Features.ismultivendor) ?IConstants.primaryMobileroot : IConstants.primaryMobile, style: TextStyle(fontSize: 14.0),),
                          ],
                        ),
                        SizedBox(height: 10.0,),
                        Divider(),
                        SizedBox(height: 10.0,),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 10.0,),
                            Text(
                              S .of(context).email,
                              // "Email",
                              style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0),),
                          ],
                        ),
                        SizedBox(height: 5.0,),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 10.0,),
                            Text((Features.ismultivendor) ?IConstants.primaryEmailroot : IConstants.primaryEmail.toUpperCase(), style: TextStyle(fontSize: 14.0),),
                          ],
                        ),
                        SizedBox(height: 5.0,),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 10.0,),
                            Text(IConstants.secondaryEmail, style: TextStyle(fontSize: 14.0),),
                          ],
                        ),
                        SizedBox(height: 10.0,),
                        Divider(),
                      ],
                    )
                        :
                    Row(
                      children: <Widget>[
                        Vx.isWeb?SizedBox.shrink(): SizedBox(width: 5.0,),
//                  Expanded(child: Text(privacy)),
                       Vx.isWeb?
                       MediaQuery(
                         data: MediaQuery.of(context).copyWith(
                             textScaleFactor: 1.0),
                         child: Expanded(
                           child: Html(data: body,
                             shrinkWrap: true,
                             style: {
                               "span": Style(
                                 fontSize: FontSize(14.0),
                                 fontWeight: FontWeight.normal,
                               )
                             },
                           ),
                         ),
                       )
                        :Expanded(
                            child: MediaQuery(
                              data: MediaQuery.of(context).copyWith(
                                  textScaleFactor: 1.0),
                              child: Html(data: body,
                                style: {
                                  "span": Style(
                                    fontSize: FontSize(12.0),
                                    fontWeight: FontWeight.normal,
                                  )
                                },
                              ),
                            )
                        ),
                        // SizedBox(width: 5.0,),
                      ],
                    ),



                  ],
                ),
              ),
              VxBuilder(
                mutations: (Features.ismultivendor) ? {HomeStoreScreenController} : {HomeScreenController},
                builder: (ctx, store, VxStatus? state) {

                  if(VxStatus.success==state) {
                    if (Vx.isWeb) return Footer(address: PrefUtils.prefs!
                        .getString("restaurant_address")!);
                  }
                  else if(state==VxStatus.none){
                    print("error loading screen");
                    if((VxState.store as GroceStore).homescreen.toJson().isEmpty) {
                      (Features.ismultivendor) ? HomeStoreScreenController(user: PrefUtils.prefs!.getString("apikey") ?? PrefUtils.prefs!.getString("ftokenid"), lat: (VxState.store as GroceStore).userData.latitude??PrefUtils.prefs!.getString("latitude"),
                          long: (VxState.store as GroceStore).userData.longitude??PrefUtils.prefs!.getString("longitude")) :
                      HomeScreenController(user: PrefUtils.prefs!.getString("apikey") ?? PrefUtils.prefs!.getString("ftokenid"), branch: PrefUtils.prefs!.getString("branch") ?? "999", rows: "0",);
                      return SizedBox.shrink();
                    }else{
                      if(Vx.isWeb)return Footer(address: PrefUtils.prefs!.getString("restaurant_address")!);
                    }
                  }
                  return SizedBox.shrink();
                },
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: ResponsiveLayout.isSmallScreen(context) ?
      gradientappbarmobile() : null,
      backgroundColor: ColorCodes.whiteColor,
      body: Column(
        children: <Widget>[
          if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
            Header(false),
          _body(),
        ],
      ),
    );
  }
}
