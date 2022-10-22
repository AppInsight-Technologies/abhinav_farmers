import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grocbay/assets/ColorCodes.dart';
import 'package:grocbay/assets/images.dart';
import 'package:grocbay/constants/IConstants.dart';
import 'package:grocbay/constants/features.dart';
import 'package:grocbay/generated/l10n.dart';
import 'package:grocbay/utils/ResponsiveLayout.dart';
import 'package:grocbay/utils/prefUtils.dart';
import 'package:grocbay/widgets/footer.dart';
import 'package:grocbay/widgets/header.dart';

import '../rought_genrator.dart';

class PageNotFound extends StatefulWidget {
  static const routeName = '/pagesnotfoundscreen';
  const PageNotFound({Key? key}) : super(key: key);

  @override
  _PageNotFoundState createState() => _PageNotFoundState();
}

class _PageNotFoundState extends State<PageNotFound> with Navigations{

  bool _iscustomsupport = false;
  bool _isWeb =false;
  //SharedPreferences prefs;
  bool _isinternet = true;
  // bool _isloading = true;
  MediaQueryData? queryData;
  double? wid;
  double? maxwid;


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
              // Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
              return Future.value(false);
            }
        ),
        titleSpacing: 0,
        title:  Text(S.of(context).not_found_page,//"Page Not Found",
          style: TextStyle(color: ColorCodes.iconColor, fontWeight: FontWeight.bold, fontSize: 18),),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    ColorCodes.appbarColor,
                    ColorCodes.appbarColor2
                    /*ColorCodes.accentColor,
                    ColorCodes.primaryColor*/
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
      wid= queryData!.size.width;
      maxwid=wid!*0.90;
      return
      Expanded(
        child: SingleChildScrollView(
          child:
          Column(
            children: [
              Container(
                constraints: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid!):null,

                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Image.asset(
                      Images.notfoundpage,
                      height: 200.0,
                    ),
                    SizedBox(height: 20,),
                    Text(
                      S .of(context).page_not_found,//"Your cart is empty!",
                      style: TextStyle(fontSize: 25.0),
                    ),
                    SizedBox(height: 10,),
                    Text(
                      S .of(context).page_anymore,//"Your cart is empty!",
                      style: TextStyle(fontSize: 18.0,color: ColorCodes.greyColor),
                    ),
                    Text(
                      S .of(context).lets_back_home,//"Your cart is empty!",
                      style: TextStyle(fontSize: 18.0,
                          color: ColorCodes.greyColor),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        /*Navigator.of(context).popUntil(ModalRoute.withName(
                        HomeScreen.routeName,
                      ));*/
                        Navigation(context, navigatore: NavigatoreTyp.homenav);
                        GoRouter.of(context).refresh();
                      },
                      child: Container(
                          width: 250,
                          padding: EdgeInsets.all(5),
                          height: 50.0,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(3.0),
                              border: Border(
                                top: BorderSide(
                                    width: 1.0,
                                    color: Theme.of(context).primaryColor),
                                bottom: BorderSide(
                                    width: 1.0,
                                    color: Theme.of(context).primaryColor),
                                left: BorderSide(
                                    width: 1.0,
                                    color: Theme.of(context).primaryColor),
                                right: BorderSide(
                                  width: 1.0,
                                  color: Theme.of(context).primaryColor,
                                ),
                              )),
                          child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  /*new Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      15.0, 0.0, 10.0, 0.0),
                                  child: new Icon(
                                    Icons.shopping_cart_outlined,
                                    color: Colors.white,
                                  ),
                                ),*/
                                  Text(
                                    S .of(context).go_to_home,//'START SHOPPING',
                                    //textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ))),
                    ),
                    SizedBox(
                      height: 50,
                    ),

                  ],
                ),
              ),
              if(_isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
            ],
          ),
        ),
      );

    }

    return Scaffold(
      appBar: ResponsiveLayout.isSmallScreen(context) ?
      gradientappbarmobile() : null,
      backgroundColor: Theme
          .of(context)
          .backgroundColor,
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

