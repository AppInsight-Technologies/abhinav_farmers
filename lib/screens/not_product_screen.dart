import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../components/sellingitem_component.dart';
import '../../constants/features.dart';
import '../../controller/mutations/cat_and_product_mutation.dart';
import '../../models/VxModels/VxStore.dart';
import '../../rought_genrator.dart';
import 'package:velocity_x/velocity_x.dart';
import '../widgets/bottom_navigation.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import '../generated/l10n.dart';
import 'package:provider/provider.dart';
import '../constants/IConstants.dart';
import '../providers/branditems.dart';
import '../providers/notificationitems.dart';
import '../data/calculations.dart';
import '../assets/ColorCodes.dart';
import '../utils/prefUtils.dart';

class NotProductScreen extends StatefulWidget {
  static const routeName = '/not-product-screen';

  Map<String, String> routeArgs;

  NotProductScreen(this.routeArgs);
  @override
  _NotProductScreenState createState() => _NotProductScreenState();
}

class _NotProductScreenState extends State<NotProductScreen> with Navigations{
  bool _isLoading = true;
  NotificationItemsList itemslistData = NotificationItemsList();
  bool _isInit = true;
  bool _checkmembership = false;
  bool iphonex = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      try {
        if (Platform.isIOS) {
          setState(() {
            iphonex = MediaQuery.of(context).size.height >= 812.0;
          });
        }
      } catch (e) {
      }
      setState(() {
        if(PrefUtils.prefs!.getString("membership") == "1"){
          _checkmembership = true;
        } else {
          _checkmembership = false;
        }
      });
      final productId = widget.routeArgs['productId'];
      if(widget.routeArgs['fromScreen'] == "ClickLink") {
        Provider.of<NotificationItemsList>(context,listen: false).updateNotificationStatus(widget.routeArgs['notificationId']!, "1" );
      } else {
        if(widget.routeArgs['notificationStatus'] == "0" || widget.routeArgs['notificationStatus'] == "2"){
          Provider.of<NotificationItemsList>(context,listen: false).updateNotificationStatus(widget.routeArgs['notificationId']!, "1" ).then((value){
          });
        }
      }
      ProductController().getcategoryitemlist(productId!).then((_){
        setState(() {
          _isLoading = false;
        });
      });
    });
  }

  @override
  didChangeDependencies() {
    if (_isInit){
      setState(() {
        _isLoading = true;
      });
      Provider.of<BrandItemsList>(context,listen: false).fetchShoppinglist();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    double deviceWidth = MediaQuery.of(context).size.width;
    int widgetsInRow = 1;

    if (deviceWidth > 1200) {
      widgetsInRow = 3;
    } else if (deviceWidth > 768) {
      widgetsInRow = 2;
    }
    double aspectRatio = (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 170;

    _buildBottomNavigationBar() {
      return VxBuilder(
        mutations: {ProductMutation},
        builder: (context, box, _) {
          if (box.userData!=null)
            return SizedBox.shrink();
          return BottomNaviagation(
            itemCount: CartCalculations.itemCount.toString() + " " + S .of(context).items,
            title: S .current.view_cart,
            total: _checkmembership ? (CartCalculations.totalMember).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)
                :
                (CartCalculations.total).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
            onPressed: (){
              Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
            },
          );
        },
      );
    }

    bool _isNotification = false;
    if(widget.routeArgs['fromScreen'] == "ClickLink") {
      _isNotification = false;
      Provider.of<NotificationItemsList>(context,listen: false).updateNotificationStatus(widget.routeArgs['notificationId']!, "1" );
    } else {
      _isNotification = true;
    }

    return _isNotification ?
    WillPopScope(
      onWillPop: (){
        if(widget.routeArgs['fromScreen'] == "ClickLink"){
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/home-screen', (Route<dynamic> route) => false);
        }
        else {
          Navigation(context, navigatore: NavigatoreTyp.PushReplacment,name: Routename.notify);
        }
        return Future.value(false);
      },
      child: Scaffold(
        appBar: NewGradientAppBar(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                ColorCodes.appbarColor,
                ColorCodes.appbarColor2
              ]
          ),
          elevation: (IConstants.isEnterprise)?0:1,
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: ColorCodes.iconColor),
              onPressed: () {
                if(widget.routeArgs['fromScreen'] == "ClickLink"){
                  Navigator.of(context).pop();
                }
                else {
                  Navigation(context, navigatore: NavigatoreTyp.PushReplacment,name: Routename.notify);
                }
              }
          ),
          title: Text(
            S .of(context).offers,//"Offers",
            style: TextStyle(color: ColorCodes.iconColor, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        body: VxBuilder(
          mutations: {ProductMutation},
          builder: (context, snapshot,state) {
            return _isLoading
                ? Center(
              child: CircularProgressIndicator(),
            )
                :
            GridView.builder(
                itemCount: snapshot.productlist.length,
                shrinkWrap: true,
                gridDelegate:
                new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widgetsInRow,
                  crossAxisSpacing: 3,
                  childAspectRatio: aspectRatio,
                  mainAxisSpacing: 3,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return SellingItemsv2(
                    fromScreen: "not_product_screen",
                    seeallpress: "",
                    itemdata: snapshot.productlist[index],
                    notid: "",
                    /*"not_product_screen",
                    "",
                    snapshot.productlist[index],
                    "",*/
                  );
                });
          }
        ),
        bottomNavigationBar:  Padding(
          padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
          child:_buildBottomNavigationBar(),
        ),
      ),
    )
        :
    WillPopScope(
      onWillPop: () { // this is the block you need
        if(widget.routeArgs['fromScreen'] == "ClickLink"){
          Navigation(context, navigatore: NavigatoreTyp.homenav);
        } else {
          Navigation(context, navigatore: NavigatoreTyp.PushReplacment,name: Routename.notify);
        }
        return Future.value(false);
      },
      child: Scaffold(
          appBar: NewGradientAppBar(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  ColorCodes.appbarColor,
                  ColorCodes.appbarColor2
                ]
            ),
            title: Text(
              S .of(context).offers, //"Offers",
            ),
          ),

          body:  VxBuilder(
              mutations: {ProductMutation},
              builder: (context, snapshot,state) {
                return _isLoading
                  ? Center(child: CircularProgressIndicator(),)
                  :
              GridView.builder(
                  itemCount: snapshot.productlist.length,
                  gridDelegate:
                  new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: widgetsInRow,
                    crossAxisSpacing: 3,
                    childAspectRatio: aspectRatio,
                    mainAxisSpacing: 3,
                  ),

                  itemBuilder: (BuildContext context, int index) {
                    return SellingItemsv2(
                      fromScreen: "not_product_screen",
                      seeallpress: "",
                      itemdata: snapshot.productlist[index],
                      notid: "",
                      /*"not_product_screen",
                      "",
                      snapshot.productlist[index],
                      "",*/
                    );
                  });
            }
          ),
        bottomNavigationBar:  Padding(
          padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
          child: _buildBottomNavigationBar(),
        ),
      ),

    );
  }
}