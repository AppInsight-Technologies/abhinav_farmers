import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grocbay/constants/features.dart';
import '../generated/l10n.dart';
import 'package:package_info/package_info.dart';
import '../constants/IConstants.dart';
import '../rought_genrator.dart';
import '../screens/policy_screen.dart';
import '../assets/ColorCodes.dart';
import '../utils/prefUtils.dart';

class PrivacyScreen extends StatefulWidget {
  static const routeName = '/privacy-screen';
  @override
  _PrivacyScreenState createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> with Navigations {
  bool _isLoading = true;
  late PackageInfo packageInfo;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: gradientappbarmobile(),
        backgroundColor: ColorCodes.baseColorlight,

        body: _isLoading ? Center(
          child: CircularProgressIndicator(),
        ) : SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 30.0,),
              if(PrefUtils.prefs!.getString("privacy") !="")
              GestureDetector(
                onTap: () async {
                  Navigation(context, name: Routename.Policy, navigatore: NavigatoreTyp.Push,
                      parms: {"title": S.of(context).privacy/*, "body" : PrefUtils.prefs!.getString("privacy").toString()*/});
                },
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 10.0,),
                    Text(
                      S .of(context).privacy
                      // "Privacy"
                      ,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_right, color: Colors.grey,),
                    SizedBox(width: 5.0,),
                  ],
                ),
              ),
              if(PrefUtils.prefs!.getString("privacy") !="")
              SizedBox(height: 5.0,),
              if(PrefUtils.prefs!.getString("privacy") !="")
              Divider(),
              if(IConstants.returnsPolicy !="")
              SizedBox(height: 5.0,),
              if(IConstants.returnsPolicy !="")
              GestureDetector(
                onTap: () async {
                  Navigation(context, name: Routename.Policy, navigatore: NavigatoreTyp.Push,
                      parms: {"title": S.of(context).returns/*, "body" : IConstants.returnsPolicy*/});
                },
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 10.0,),
                    Text(
                      S .of(context).returns
                      // "Return"
                      ,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_right, color: Colors.grey,),
                    SizedBox(width: 5.0,),
                  ],
                ),
              ),
              if(IConstants.returnsPolicy !="")
              SizedBox(height: 5.0,),
              if(IConstants.returnsPolicy !="")
              Divider(),
              if(IConstants.refundPolicy !="")
              SizedBox(height: 5.0,),
              if(IConstants.refundPolicy !="")
              GestureDetector(
                onTap: () async {
                  Navigation(context, name: Routename.Policy, navigatore: NavigatoreTyp.Push,
                      parms: {"title": S.of(context).refund/*, "body" : IConstants.refundPolicy*/});
                },
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 10.0,),
                    Text(
                        S .of(context).refund,
                     // "Refund"

                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_right, color: Colors.grey,),
                    SizedBox(width: 5.0,),
                  ],
                ),
              ),
              if(IConstants.refundPolicy !="")
              SizedBox(height: 5.0,),
              if(IConstants.refundPolicy !="")
              Divider(),
              if(IConstants.walletPolicy !="")
              SizedBox(height: 5.0,),
              if(IConstants.walletPolicy !="")
              GestureDetector(
                onTap: () async {
                  Navigation(context, name: Routename.Policy, navigatore: NavigatoreTyp.Push,
                      parms: {"title": S.of(context).wallet/*, "body" :IConstants.walletPolicy*/});
                },
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 10.0,),
                    Text(
                        S .of(context).wallet,
                      // "Wallet",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_right, color: Colors.grey,),
                    SizedBox(width: 5.0,),
                  ],
                ),
              ),
              if(IConstants.walletPolicy !="")
              SizedBox(height: 5.0,),
              if(IConstants.walletPolicy !="")
              Divider(),
              if(IConstants.restaurantTerms !="")
              SizedBox(height: 5.0,),
              if(IConstants.restaurantTerms !="")
              GestureDetector(
                onTap: () async {
                  Navigation(context, name: Routename.Policy, navigatore: NavigatoreTyp.Push,
                      parms: {"title": S.of(context).terms_of_use, /*"body" :IConstants.restaurantTerms*/});
                },
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 10.0,),
                    Text(
                        S .of(context).terms_of_service,
                      // "Terms of Use",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_right, color: Colors.grey,),
                    SizedBox(width: 5.0,),
                  ],
                ),
              ),
              if(IConstants.restaurantTerms !="")
              SizedBox(height: 5.0,),
              if(IConstants.restaurantTerms !="")
              Divider(),
              if(IConstants.restaurantTerms !="")
              SizedBox(height: 5.0,),
              Row(
                children: <Widget>[
                  SizedBox(width: 10.0,),
                  Text(S .of(context).app_version,
                    // "App version",

                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),

                ],
              ),
              SizedBox(height: 5.0,),
              Row(
                children: <Widget>[
                  SizedBox(width: 10.0,),
                  Text(
                    // S .of(context).v1_live,
                     S .of(context).version+ packageInfo.version + S .of(context).live,
                    //"Version " + packageInfo.version + " Live",
                    style: TextStyle(fontSize: 14.0),),
                ],
              ),
              SizedBox(height: 5.0,),
            ],
          ),
        )
    );
  }

  gradientappbarmobile() {
    return  AppBar(
      brightness: Brightness.dark,
      toolbarHeight: 60.0,
      elevation: (IConstants.isEnterprise)?0:1,
      automaticallyImplyLeading: false,
      leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorCodes.iconColor),
          onPressed: () async{
           Navigator.of(context).pop();
            //context.go('/');
           // Navigation(context, navigatore: NavigatoreTyp.homenav);
            // Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));

          }
      ),
      titleSpacing: 0,
      title: Text(
          S .of(context).privacy_others,
        // 'Privacy & Others',
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
                ]
            )
        ),
      ),
    );
  }
}
