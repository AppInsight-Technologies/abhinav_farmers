import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../controller/mutations/cart_mutation.dart';
import '../../repository/authenticate/AuthRepo.dart';
import '../../widgets/bottom_navigation.dart';
import '../../rought_genrator.dart';
import '../../controller/mutations/address_mutation.dart';
import '../../widgets/simmers/HomeScreenShimmerweb.dart';
import '../controller/mutations/home_screen_mutation.dart';
import '../models/VxModels/VxStore.dart';
import '../models/newmodle/home_page_modle.dart';
import '../models/newmodle/subscription_data.dart';
import '../models/newmodle/user.dart';
import '../components/ItemList/item_component.dart';
import '../rought_genrator.dart';
import '../widgets/product_request.dart';
import '../widgets/simmers/home_screen_shimmer.dart';
import 'package:velocity_x/velocity_x.dart';
import '../generated/l10n.dart';
import '../widgets/websiteSmallbanner.dart';
import '../screens/customer_support_screen.dart';
import '../widgets/CarouselSliderimageWidget.dart';
import '../utils/ResponsiveLayout.dart';
import '../widgets/categoryOne.dart';
import '../widgets/categoryThree.dart';
import '../widgets/expandable_categories.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../widgets/websiteSlider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/app_drawer.dart';
import '../widgets/brands_items.dart';
import '../widgets/advertise1_items.dart';
import '../constants/features.dart';
import '../widgets/floatbuttonbadge.dart';
import '../providers/advertise1items.dart';
import '../assets/images.dart';
import '../constants/IConstants.dart';
import '../assets/ColorCodes.dart';
import '../widgets/categoryTwo.dart';
import '../data/calculations.dart';
import '../utils/prefUtils.dart';
import 'map_screen.dart';
import 'membership_screen.dart';

enum SingingCharacter { english, arabic }
class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';
 static  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String? title;
  Map<String, String>? homedata;
  HomeScreen({Key? key,this.homedata}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with Navigations{
  var _address = "";
  bool iphonex = false;
  bool _isDelivering = true;
  bool _isinternet = true;
  var _carauselslider = false;

  late MediaQueryData queryData;
  late double wid;
  late double maxwid;

  var name = "",
      email = "",
      photourl = "",
      phone = "";
  int count =0;

  DateTime? currentBackPressTime;
   Future<List<Subscription>>? _subscription = Future.value([]);
  Future<void> _refreshProducts(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {_isinternet = true;});
    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {_isinternet = true;});
    } else {
      Fluttertoast.showToast(
        msg: S.of(context).no_internet/*"No internet connection!!!"*/, fontSize: MediaQuery
          .of(context)
          .textScaleFactor * 13,);
      setState(() {
        _isinternet = false;
      });
    }

    auth.getuserProfile(onsucsess: (value){
      HomeScreenController(user: PrefUtils.prefs!.getString("apikey") ??
          PrefUtils.prefs!.getString("tokenid"),
          branch: PrefUtils.prefs!.getString("branch") ?? "999",
          rows: "0",
          lat:(Features.ismultivendor) ? (VxState.store as GroceStore).userData.latitude??PrefUtils.prefs!.getString("latitude"):"" ,
          long: (Features.ismultivendor) ? (VxState.store as GroceStore).userData.longitude??PrefUtils.prefs!.getString("longitude"): "", branchtype: (Features.ismultivendor) ? IConstants.branchtype : "");
    }, onerror: (){
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      if(IConstants.holyday == "1") {
        ShowpopupforHoliday();
      }
      if(PrefUtils.prefs!.containsKey("typenew")) {
        // if(Vx.isWeb){
        //   debugPrint("mnbvcxcvb..." + PrefUtils.prefs!.getString("typenew")! +
        //       "......." + VxState.store.userData.membership.toString());
        //   auth.getuserProfile(onsucsess: (value){
        //     if (PrefUtils.prefs!.getString("typenew") == "new" && VxState.store.userData.membership == "1") {
        //       dialogForFreemembership();
        //     }
        //   },onerror: (message){
        //     Navigator.of(context).pop();
        //     Fluttertoast.showToast(msg: message);
        //   });
        //
        // }else {
        if(!Vx.isWeb) {
          debugPrint("mnbvcxcvb..." + PrefUtils.prefs!.getString("typenew")! +
              "......." + VxState.store.userData.membership.toString());
          if (PrefUtils.prefs!.getString("typenew") == "new" &&
              VxState.store.userData.membership == "1") {
            dialogForFreemembership();
          }
        }
       // }
      }
    });
    if(Features.issubscriptionbox)
    subscriptionApibox.getSubsctiptionBox(ParamBodyDatabox(type: "all", branch: PrefUtils.prefs!.getString("branch"), languageid: IConstants.languageId, user: !(PrefUtils.prefs!.containsKey("apikey")) ? PrefUtils.prefs!.getString("tokenid") !: PrefUtils.prefs!.getString('apikey')!,subscription_type: "Flexible", subscription_id: "")).then((value){
      setState(() {
        _subscription = Future.value(value);
      });
    });
    super.initState();
  }

  Widget _bannerMain1(HomePageData homedata) {
    if (homedata.data!.mainslideradd != null)
      if (homedata.data!.mainslideradd!.length >= 0) {
        _carauselslider = true;
      } else {
        _carauselslider = false;
      }

    return (PrefUtils.prefs!.containsKey("apikey") && VxState.store.userData.customerEngagementFlag! == "2")?SizedBox.shrink() :_carauselslider ? Row(
      children: <Widget>[
        Expanded(
            child: SizedBox(
              child: new ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                itemCount: homedata.data!.mainslideradd!.length,
                itemBuilder: (_, i) =>
                    Column(
                      children: [
                        Advertise1Items(
                          homedata.data!.mainslideradd![i],
                          "home",
                        ),
                      ],
                    ),
              ),
            )),
      ],
    ) : SizedBox.shrink();
  }


  Widget SubscriprtionBox(HomePageData homedata) {
    return Column(
        children: [
          Container(
            padding: EdgeInsets.only(
                left: 10.0, right: 5.0, bottom: 8.0),
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Text(
                  S.of(context).choose_sub_box,//"Choose Your Subscription Box",
                  //"For Your Convenience",
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme
                          .of(context)
                          .primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                GestureDetector(
                  onTap: (){
                    //Navigation(context, name:Routename.SubscriptionBoxScreen,navigatore: NavigatoreTyp.Push,);
                  },
                  child: Text(/*"View All"*/S.of(context).view_all, style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold),),
                ),
                SizedBox(width: 5),
              ],
            ),
          ),
          SizedBox(height: 5,),
          FutureBuilder<List<Subscription>>(
              future: _subscription,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Subscription>> snapshot) {
                final promoData = snapshot.data;
                print("promodata ...length..."+promoData!.length.toString());

                if(promoData != null && promoData.length > 0) {
                  double deviceWidth = MediaQuery
                      .of(context)
                      .size
                      .width;
                  int widgetsInRow = (Vx.isWeb &&
                      !ResponsiveLayout.isSmallScreen(context)) ? 1 : 2;
                  if (deviceWidth > 1200) {
                    widgetsInRow = 4;
                  } else if (deviceWidth < 768) {
                    widgetsInRow = 2;
                  }
                  double aspectRatio = (Vx.isWeb &&
                      !ResponsiveLayout.isSmallScreen(context)) ?
                  (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow /
                      350  :
                  (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow /
                      120;
                  return GridView.builder(
                    shrinkWrap: true,
                    controller: new ScrollController(keepScrollOffset: false),
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: widgetsInRow,
                      crossAxisSpacing: 3,
                      childAspectRatio: aspectRatio,
                      mainAxisSpacing: 3,
                    ),
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
                            // if (promoData[i].subscriptionType == "0") {
                            // Navigation(context,
                            //     name: Routename.SubscribeDescription,
                            //     navigatore: NavigatoreTyp.Push,
                            //     qparms: {
                            //       "index": i,
                            //       "subscription_id":promoData[i].id.toString(),
                            //     });
                            // }

                              Navigation(context,
                                  name: Routename.SubscribeScreen,
                                  navigatore: NavigatoreTyp.Push,
                                  qparms: {
                                    "box_name":promoData[i].boxName,
                                    "box_price":promoData[i].boxPrice,
                                    "box_count":promoData[i].boxCount,
                                    "box_desc":promoData[i].subscriptionboxDescription,
                                    "box_image":promoData[i].featuredImage,
                                    "itemid": promoData[i].id,
                                    "index": i,
                                    //"items": promoData[i].boxProducts,
                                    "fromScreen": "subscriptionbox",
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
                                    "cronTime": promoData[i].subscriptionSlot![0].cronTime,
                                    "name": promoData[i].subscriptionSlot![0].name,
                                    "varid": "",
                                    "varmrp": "",
                                    "brand": "",
                                    "deliveriesarray": promoData[i].subscriptionSlot![0].deliveries,
                                    "daily": promoData[i].subscriptionSlot![0].daily,
                                    "dailyDays": promoData[i].subscriptionSlot![0].dailyDays,
                                    "weekend": promoData[i].subscriptionSlot![0].weekend,
                                    "weekendDays": promoData[i].subscriptionSlot![0].weekendDays,
                                    "weekday": promoData[i].subscriptionSlot![0].weekday,
                                    "weekdayDays": promoData[i].subscriptionSlot![0].weekdayDays,
                                    "custom": promoData[i].subscriptionSlot![0].custom,
                                    "customDays":promoData[i].subscriptionSlot![0].customDays,
                                    "subscriptionType": promoData[i].subscriptionType
                                  });

                          }
                        },
                        child: Container(
                          width: 190,
                          padding: EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0, bottom: 5.0),
                          margin: EdgeInsets.only(left: 8.0, top: 5.0, right: 2.0, bottom: 5.0),
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
                                imageUrl: promoData[i].featuredImage!, //fit: BoxFit.fitWidth,
                                height: ResponsiveLayout.isSmallScreen(context)?80:100,
                                width: ResponsiveLayout.isSmallScreen(context)?170:170,
                                errorWidget: (context, url, error) => Image.asset(Images.defaultSliderImg),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(promoData[i].boxName!,
                                      maxLines: 2,
                                      style:
                                      TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 13 : 15, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(IConstants.currencyFormat + "" + promoData[i].boxPrice!,
                                    maxLines: 2,
                                    style:
                                    TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 13 : 15, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }else {
                  return SizedBox.shrink();
                }
              }
          )
        ]
    );
  }

   _advertiseCategoryOne(homedata) {
    if (Features.isAdsCategoryOne)
      return (homedata.data.featuredCategories1.length > 0) ? Container(
        padding: EdgeInsets.only(left: 10),
        child: Row(
          children: <Widget>[
            Expanded(
                child: SizedBox(
                  height: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))? !Features.ismultivendor ? 130:135.0 : 86,
                  child: new ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.all(0.0),
                    itemCount: homedata.data.featuredCategories1.length,
                    itemBuilder: (_, i) =>
                        Column(
                          children: [Advertise1Items(
                            homedata.data.featuredCategories1[i],
                            "top",),
                          ],
                        ),
                  ),
                )),
          ],
        ),
      ) : SizedBox.shrink();
  }

   _featuredItemweb(HomePageData homedata) {
    if (Features.isSellingItems)
      if(homedata.data!.featuredByCart!.data!.length>0)
      return Container(
        padding: EdgeInsets.only(top: 15.0,
            bottom: 10.0,
        ),
        color: ColorCodes.whiteColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              children: <Widget>[
                SizedBox(
                  width: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?0:10.0,
                ),
                Text(
                  homedata.data!.featuredByCart!.label!,
                  style: TextStyle(
                      fontSize: ResponsiveLayout.isSmallScreen(context)
                          ? 18.0
                          : 24.0,
                      color:  (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
                      ColorCodes.blackColor:Theme
                          .of(context)
                          .primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      Navigation(context, name: Routename.SellingItem, navigatore: NavigatoreTyp.Push,
                          parms: {"seeallpress": "featured",
                            'title': homedata.data!.featuredByCart!.label!,});
                    },
                    child: Text(
                      S.of(context).view_all, //'View All',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: ColorCodes.blackColor/*Theme.of(context).primaryColor*/),
                    ),
                  ),
                ),
                SizedBox(
                  width: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?0:10,
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                        height: ResponsiveLayout.isSmallScreen(context)?Features.btobModule?420:
                             (Features.isSubscription) ? 296 : 286
                            : ResponsiveLayout.isMediumScreen(context)
                            ? Features.btobModule?420:(Features.isSubscription) ? 250 : 250
                            : Features.btobModule?430:(Features.isSubscription) ? 290 : 271,

                        child: MouseRegion(
                          cursor: MouseCursor.defer,
                          child: new ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: homedata.data!.featuredByCart!.data!.length,
                              itemBuilder: (_, i) {
                                return Column(
                                  children: [
                                    Itemsv2(
                                      "home_screen",
                                      homedata.data!.featuredByCart!.data![i],
                                      homedata.data!.customerDetails!.length > 0
                                          ? homedata.data!.customerDetails!.first
                                          : UserData(membership: "0"),
                                    ),
                                  ],
                                );
                              }
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
      else return SizedBox.shrink();
  }

//continue
   _featuredItemMobile(HomePageData homedata) {
    if (Features.isSellingItems)
      if(homedata.data!.featuredByCart!.data!.length > 0)
      return Container(
        padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              children: <Widget>[
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  homedata.data!.featuredByCart!.label!,
                  style: TextStyle(
                      fontSize: ResponsiveLayout.isSmallScreen(context)?18.0:24.0,
                      fontWeight: FontWeight.w900,
                      color: /*Theme.of(context).primaryColor*/Colors.black),
                ),
                Spacer(),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      Navigation(context, name: Routename.SellingItem, navigatore: NavigatoreTyp.Push,
                          parms: {"seeallpress": "featured",
                            'title': homedata.data!.featuredByCart!.label!});
                    },
                    child: Text(
                      S.of(context).view_all, //'View All',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: ColorCodes.blackColor/*Theme.of(context).primaryColor*/),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            SizedBox(height: 10.0),
            SizedBox(
                height: ResponsiveLayout.isSmallScreen(context) ?
                Features.btobModule?420:(Features
                    .isSubscription) ? 270 : 260 : ResponsiveLayout
                    .isMediumScreen(context) ?
                Features.btobModule?410:(Features.isSubscription)
                    ? 240
                    : 225 : Features.btobModule?420:(Features.isSubscription) ? 240 : 225,

                child: new ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: homedata.data!.featuredByCart!.data!.length,
                  itemBuilder: (_, i) {
                    return Column(
                      children: [
                        Itemsv2(
                          "home_screen",
                          homedata.data!.featuredByCart!.data![i],
                          homedata.data!.customerDetails!.length > 0 ? homedata.data!.customerDetails!.first :
                          UserData(membership: "0"),
                        ),
                      ],
                    );
                  },
                )),
          ],
        ),
      );
      else return SizedBox.shrink();
  }

  Widget _featuredAdsOne(HomePageData homedata) {
    if (homedata.data!.featureditems1!.length > 0) {
      double deviceWidth = MediaQuery.of(context).size.width;
      int widgetsInRow = (Vx.isWeb &&
          !ResponsiveLayout.isSmallScreen(context)) ? 1 : 2;
      if (deviceWidth > 1200) {
        widgetsInRow = 2;
      } else if (deviceWidth < 768) {
        widgetsInRow = 1;
      }
      double aspectRatio = (Vx.isWeb &&
          !ResponsiveLayout.isSmallScreen(context)) ?
      (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow /
          350 :
      (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow /
          170;
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widgetsInRow,
          crossAxisSpacing: 3,
          childAspectRatio: aspectRatio,
        ),
        shrinkWrap: true,
        controller: new ScrollController(keepScrollOffset: false),
        itemCount: homedata.data!.featureditems1!.length,
        itemBuilder: (_, i) =>
            Advertise1Items(
              homedata.data!.featureditems1![i],
              "horizontal",
            ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

   _featuredAdsTwo(HomePageData homedata) {
    if (Features.isAdsCategoryTwo)
      if (homedata.data!.featuredCategories2!.length > 0) {
        double deviceWidth = MediaQuery
            .of(context)
            .size
            .width;
        int widgetsInRow = (Vx.isWeb &&
            !ResponsiveLayout.isSmallScreen(context)) ? 1 : 2;
        if (deviceWidth > 1200) {
          widgetsInRow = 2;
        } else if (deviceWidth < 768) {
          widgetsInRow = 1;
        }
        double aspectRatio = (Vx.isWeb &&
            !ResponsiveLayout.isSmallScreen(context)) ?
        (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow /
            350 :
        (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow /
            170;
        return GridView.builder(
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widgetsInRow,
              crossAxisSpacing: 4,
              childAspectRatio: aspectRatio

          ),
          shrinkWrap: true,
          controller: new ScrollController(keepScrollOffset: false),
          itemCount: homedata.data!.featuredCategories2!.length,
          padding: EdgeInsets.zero,
          itemBuilder: (_, i) =>
              Column(
                children: [
                  Advertise1Items(
                    homedata.data!.featuredCategories2![i],
                    "horizontal",
                  ),
                ],
              ),
        );
      }
      else
        return SizedBox.shrink();
  }

  Widget _categoryThree(HomePageData homedata) {
    if (Features.isCategoryThree)
      return CategoryThree(homedata); else
      return SizedBox.shrink();
  }

   _featuredAdsVertical(HomePageData homedata) {
    if (Features.isVerticalSlider)
        if (homedata.data!.verticalSlider!.length > 0)
          return new SizedBox(
            height: 290.0,
            child: new ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: homedata.data!.verticalSlider!.length,
              itemBuilder: (_, i) =>
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Advertise1Items(
                        homedata.data!.verticalSlider![i],
                        "bottom"),
                  ),
            ),
          );
        else
          return SizedBox.shrink();
    else
      SizedBox.shrink();
  }

  Widget _featuredAdsThree(HomePageData homedata) {
    if (Features.isFeatureAdsThree)
      if (homedata.data!.featuredCategories3!.length > 0) {
        double deviceWidth = MediaQuery.of(context).size.width;
        int widgetsInRow = (Vx.isWeb &&
            !ResponsiveLayout.isSmallScreen(context)) ? 1 : 2;
        if (deviceWidth > 1200) {
          widgetsInRow = 2;
        } else if (deviceWidth < 768) {
          widgetsInRow = 1;
        }
        double aspectRatio = (Vx.isWeb &&
            !ResponsiveLayout.isSmallScreen(context)) ?
        (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 350
            :
        (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 170;
        return GridView.builder(
          shrinkWrap: true,
          controller: new ScrollController(keepScrollOffset: false),
          gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widgetsInRow,
              crossAxisSpacing: 4,
              childAspectRatio: aspectRatio
          ),
          itemCount: homedata.data!.featuredCategories3!.length,
          padding: EdgeInsets.zero,
          itemBuilder: (_, i) =>
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Column(
                  children: [
                    Advertise1Items(
                      homedata.data!.featuredCategories3![i],
                      "horizontal",
                    ),
                  ],
                ),
              ),
        );
      }
    return SizedBox.shrink();
  }

   _category(HomePageData homedata) {
    if (Features.isCategory) return Container(
      padding: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
          ? EdgeInsets.only(left: 20, right: 20)
          : null,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
                left: 10.0, top: 10.0, right: 10.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                S.of(context).explore_by_cat, //"Explore by Category",
                style: TextStyle(
                    fontSize: ResponsiveLayout.isSmallScreen(context)?18.0:24.0,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).primaryColor),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          //TODO:Expandable Cat Bloc
          ExpansionCategory(homedata),
        ],
      ),
    );
  }

  Widget _categoryweb(HomePageData homedata) {
    return Container(

      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
                left: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
                    ?0:10.0, top: 10.0, right: 10.0, bottom: 3.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                S.of(context).explore_by_cat, //"Explore by Category",
                style: TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 18.0 : 24.0,
                    color:  (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
                    ColorCodes.blackColor:Theme
                        .of(context)
                        .primaryColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          ExpansionCategory(homedata),
        ],
      ),
    );
  }

   _brands(HomePageData homedata) {
    if (!Features.ismultivendor && Features.isBrands)
      if (homedata.data!.allBrands!.length > 0)
        return Container(
          color: Colors.white,
          width: MediaQuery
              .of(context)
              .size
              .width,
          padding: EdgeInsets.only(
              left: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
                  ?0:10.0, top: 10.0, right: 10.0, bottom: 10.0),
          child: Container(
            padding:
            (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
                ? EdgeInsets.only(left: 0, right: 20)
                : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  S
                      .of(context)
                      .shop_by_brands, //"Shop by Brands",
                  style: TextStyle(
                      fontSize: ResponsiveLayout.isSmallScreen(context)?18.0:24.0,
                      fontWeight: FontWeight.w900,
                    color:  (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
                    ColorCodes.blackColor:Theme
                        .of(context)
                        .primaryColor,),
                ),
                SizedBox(
                  height: 5.0,
                ),
                SizedBox(
                  height: 70,
                  child: new ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: homedata.data!.allBrands!.length,
                    itemBuilder: (_, i) =>
                        Column(
                          children: [
                            BrandsItems(
                              homedata.data!.allBrands![i],
                              i,
                            ),
                          ],
                        ),
                  ),
                ),
              ],
            ),
          ),
        );
      else
        return SizedBox.shrink();
  }

  Widget _discountItem(HomePageData homedata) {
    if (homedata.data!.discountByCart!.data!.length > 0) {
      return Container(
        padding: EdgeInsets.only(top: 15.0,
            bottom: 10.0,
        ),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              children: <Widget>[
                SizedBox(
                  width: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
                      ?0:10.0,
                ),
                Text(
                  homedata.data!.discountByCart!.label!,
                  style: TextStyle(
                      fontSize: ResponsiveLayout.isSmallScreen(context)?18.0:24.0,
                      fontWeight: FontWeight.w900,
                    color:  (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
                    ColorCodes.blackColor:/*Theme
                        .of(context)
                        .primaryColor*/ColorCodes.blackColor,),
                ),
                Spacer(),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      Navigation(context, name: Routename.SellingItem, navigatore: NavigatoreTyp.Push,
                          parms: {"seeallpress": "discount",
                            'title': homedata.data!.discountByCart!.label!});
                    },
                    child: Text(
                      S.of(context).view_all, //'View All',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: ColorCodes.blackColor,/*Theme.of(context).primaryColor*/),
                    ),
                  ),
                ),
                SizedBox(
                  width: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
                      ?0:10,
                ),
              ],
            ),
            SizedBox(height: 8.0),
            SizedBox(
                height: ResponsiveLayout.isSmallScreen(context) ? Features.btobModule?420:(Features
                    .isSubscription) ? 268 : 256 : ResponsiveLayout
                    .isMediumScreen(context) ? Features.btobModule?420:(Features.isSubscription)
                    ? 230
                    : 230 : Features.btobModule?410:(Features.isSubscription) ? 290 : 261,
                child: new ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: homedata.data!.discountByCart!.data!.length,
                  itemBuilder: (_, i) {
                    return Column(
                      children: [
                        Itemsv2(
                          "Discount",
                          homedata.data!.discountByCart!.data![i],
                          homedata.data!.customerDetails!.length > 0 ? homedata
                              .data!.customerDetails!.first : UserData(
                              membership: "0"),
                        ),
                      ],
                    );
                  },
                )),
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _offersItem(HomePageData homedata) {
    if (homedata.data!.offerByCart!.data!.length > 0) {
      return Container(
        padding: EdgeInsets.only(top: 15.0,
            bottom: 10.0,
            left: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)) ? 20 : 0,
            right: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)) ? 20 : 0),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              children: <Widget>[
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  homedata.data!.offerByCart!.label!,
                  style: TextStyle(
                      fontSize: ResponsiveLayout.isSmallScreen(context)
                          ? 18.0
                          : 24.0,
                      color: Theme
                          .of(context)
                          .primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      Navigation(context, name: Routename.SellingItem, navigatore: NavigatoreTyp.Push,
                          parms: {"seeallpress": "offers",
                            'title': homedata.data!.offerByCart!.label!,});
                    },
                    child: Text(
                      S
                          .of(context)
                          .view_all, //'View All',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Theme
                              .of(context)
                              .primaryColor),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            SizedBox(height: 8.0),
            SizedBox(
                height: ResponsiveLayout.isSmallScreen(context) ?
                Features.btobModule?420
                    :(Features.isSubscription) ? 296 : 286
                    : ResponsiveLayout.isMediumScreen(context) ?
                (Features.isSubscription) ? 260
                    : 260
                    : Features.btobModule?420
                    :(Features.isSubscription) ? 280
                    : 270,
                child: new ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: homedata.data!.offerByCart!.data!.length,
                  itemBuilder: (_, i) {
                    return Column(
                      children: [
                        Itemsv2(
                          "offers",
                          homedata.data!.offerByCart!.data![i],
                          homedata.data!.customerDetails!.length > 0 ? homedata
                              .data!.customerDetails!.first : UserData(
                              membership: "0"),
                        ),
                      ],
                    );
                  },
                )),
          ],
        ),
      );
    }
    else {
      return SizedBox.shrink();
    }
  }

  Widget _footer(HomePageData homedata) {
    if (homedata.data!.footerImage!.length > 0) {
      return GestureDetector(
        onTap: () {
          if(Features.suggestproduct)
          !PrefUtils.prefs!.containsKey("apikey")
                ?
            Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push) :
          showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0),topRight: Radius.circular(15.0)),
            ),
            context: context,
            builder: ( context) {
              return productRequest();
            },
          );
        },
        child: new ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          itemCount: homedata.data!.footerImage!.length,
          itemBuilder: (_, i) =>
              Container(
                child: CachedNetworkImage(
                  imageUrl: homedata.data!.footerImage![i].bannerImage,
                  fit: BoxFit.fill,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  placeholder: (context, url) =>
                      Image.asset(Images.defaultSliderImg),
                  errorWidget: (context, url, error) =>
                      Image.asset(Images.defaultSliderImg),
                ),
              ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _body() {
    return VxBuilder(
      mutations: {HomeScreenController,SetPrimeryLocation},
      builder: (ctx, store, VxStatus? state) {
       if(VxStatus.success == state)
         return loadhomeScreen();
       else if(state == VxStatus.none){
         if((VxState.store as GroceStore).homescreen.toJson().isEmpty) {
           HomeScreenController(user: PrefUtils.prefs!.getString("apikey") ??
               PrefUtils.prefs!.getString("tokenid"),
               branch: PrefUtils.prefs!.getString("branch") ?? "999",
               rows: "0",  lat:(Features.ismultivendor) ? (VxState.store as GroceStore).userData.latitude??PrefUtils.prefs!.getString("latitude"):"" ,
               long: (Features.ismultivendor) ? (VxState.store as GroceStore).userData.longitude??PrefUtils.prefs!.getString("longitude"): "", branchtype: (Features.ismultivendor) ? IConstants.branchtype : "");
            return (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
               ? HomeScreenShimmerWeb(): HomeScreenShimmer();
          }else{
           return loadhomeScreen();
         }
       }
         return (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
             ? HomeScreenShimmerWeb():HomeScreenShimmer();
      },
    );
  }

  void launchWhatsApp() async {
    String phone = IConstants.secondaryMobile;
     String url() {
      if (Platform.isIOS) {
        return "whatsapp://wa.me/$phone/?text=${Uri.parse('I want to order Grocery')}";
      } else {
        return "whatsapp://send?phone=$phone&text=${Uri.parse('I want to order Grocery')}";
      }
    }
    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    IConstants.isEnterprise ? SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: ColorCodes
              .primaryColor, // status bar color
        )) :
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.grey,
    ));
    queryData = MediaQuery.of(context);
    wid= queryData.size.width;
    maxwid=wid*0.90;

    bottomNavigationbar() {
      return _isDelivering
          ? SingleChildScrollView(
        child: Container(
          height: 65,
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: ColorCodes.primaryColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],
           // shape: BoxShape.circle,
          ),
          // decoration: ShapeDecoration(
          //     color: ColorCodes.whiteColor,
          //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(15.0),topLeft:Radius.circular(15.0)))
          // ),

          child: Row(
            children: <Widget>[
              Spacer(),
              Container(
                width: 50,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 8.0,
                    ),
                    CircleAvatar(
                      radius: 13.0,
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.transparent,
                      child: Image.asset(Images.homeImg,
                        color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome,
                        width: 30,
                        height: 25,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                        S.of(context).home, // "Home",
                        style: TextStyle(
                            color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome,
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 8.0,
                    ),
                  ],
                ),
              ),
              if(Features.isCategory)
              Spacer(),
              if(Features.isCategory)
              ValueListenableBuilder(
                  valueListenable: IConstants.currentdeliverylocation,
                  builder: (context, value, widget) {
                    return GestureDetector(
                      onTap: () {
                        if (value != S.of(context).not_available_location)
                        Navigation(context, name:Routename.Category, navigatore: NavigatoreTyp.Push);
                      },
                      child: Container(
                        width: 60,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 8.0,
                            ),
                            CircleAvatar(
                              radius: 13.0,
                              backgroundColor: Colors.transparent,
                              child: Image.asset(Images.categoriesImg,
                                color: ColorCodes.whiteColor,
                                width: 20,
                                height: 25,),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                                S
                                    .of(context)
                                    .categories, //"Categories",
                                style: TextStyle(
                                    color: ColorCodes.whiteColor, fontSize: 10.0)),
                            SizedBox(
                              height: 8.0,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              if(Features.isWallet)
                Spacer(),
              if(Features.isWallet)
                ValueListenableBuilder(
                    valueListenable: IConstants.currentdeliverylocation,
                    builder: (context, value, widget) {
                      return GestureDetector(
                        onTap: () {
                          if (value != S
                              .of(context)
                              .not_available_location)
                            !PrefUtils.prefs!.containsKey("apikey")
                                ?
                            Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push) :
                            Navigation(context, name: Routename.Wallet, navigatore: NavigatoreTyp.Push,
                            qparms: {"type": "wallet"} );
                        },
                        child:  Container(
                          width: 60,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 8.0,
                              ),
                              // (PrefUtils.prefs!.containsKey("apikey")) ?((VxState.store as GroceStore).prepaid.prepaid.toString() != null || (VxState.store as GroceStore).prepaid.prepaid.toString() != "null" || (VxState.store as GroceStore).prepaid.prepaid.toString() != "")?Text(
                              //   Features.iscurrencyformatalign?
                              //   (VxState.store as GroceStore).prepaid.prepaid!.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + " " + IConstants.currencyFormat:
                              //   IConstants.currencyFormat + " " + (VxState.store as GroceStore).prepaid.prepaid!.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                              //   style: TextStyle(
                              //       color: ColorCodes.greenColor,
                              //       fontSize: 10.0,
                              //       fontWeight: FontWeight.bold
                              //   ),
                              // ):
                              // SizedBox(
                              //   height: 10.0,
                              // ):
                              // SizedBox(
                              //   height: 10.0,
                              // ),
                              CircleAvatar(
                                radius: 13.0,
                                backgroundColor: Colors.transparent,
                                child: Image.asset(Images.walletImg,
                                  color: ColorCodes.whiteColor,
                                  width: 20,
                                  height: 25,),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text( S.of(context).wallet, //"Wallet",
                                  style: TextStyle(
                                      color: ColorCodes.whiteColor, fontSize: 10.0)),
                              SizedBox(
                                height: 8.0,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              if(Features.isMembership)
                Spacer(),
              if(Features.isMembership)
                ValueListenableBuilder(
                    valueListenable: IConstants.currentdeliverylocation,
                    builder: (context, value, widget) {
                      return GestureDetector(
                        onTap: () {
                          if (value != S
                              .of(context)
                              .not_available_location)
                            !PrefUtils.prefs!.containsKey("apikey")
                                ?
                            Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                                : (Vx.isWeb &&
                                  !ResponsiveLayout.isSmallScreen(context)) ?
                                  MembershipInfo(context):
                            Navigation(context, name: Routename.Membership, navigatore: NavigatoreTyp.Push);
                        },
                        child: Container(
                          width: 60,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 8.0,
                              ),
                              CircleAvatar(
                                radius: 13.0,
                                backgroundColor: Colors.transparent,
                                child: Image.asset(
                                  Images.bottomnavMembershipImg,
                                  color: ColorCodes.whiteColor,
                                    width: 20,
                                    height: 25,),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                  S.of(context).membership, //"Membership",
                                  style: TextStyle(
                                      color: ColorCodes.whiteColor, fontSize: 10.0)),
                              SizedBox(
                                height: 8.0,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              if(!Features.isMembership)
                Spacer(),
              if(!Features.isMembership)
                ValueListenableBuilder(
                    valueListenable: IConstants.currentdeliverylocation,
                    builder: (context, value, widget) {
                      return GestureDetector(
                        onTap: () {
                          if (value != S
                              .of(context)
                              .not_available_location)
                            !PrefUtils.prefs!.containsKey("apikey")
                                ?
                            Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                                :
                            Navigation(context, name:Routename.MyOrders,navigatore: NavigatoreTyp.Push);
                        },
                        child: Container(
                          width: 60,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 8.0,
                              ),
                              CircleAvatar(
                                radius: 13.0,
                                backgroundColor: Colors.transparent,
                                child: Image.asset(
                                  Images.bag,
                                  color: ColorCodes.whiteColor,
                                  width: 20,
                                  height: 25,),
                              ),

                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                  S.of(context).my_orders, //"My Orders",
                                  style: TextStyle(
                                      color: ColorCodes.whiteColor, fontSize: 10.0)),
                              SizedBox(
                                height: 8.0,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              if(Features.isShoppingList)
                Spacer(),
              if(Features.isShoppingList)
                ValueListenableBuilder(
                    valueListenable: IConstants.currentdeliverylocation,
                    builder: (context, value, widget) {
                      return GestureDetector(
                        onTap: () {
                          if (value != S
                              .of(context)
                              .not_available_location)
                            !PrefUtils.prefs!.containsKey("apikey")
                                ?
                            Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                                :
                            Navigation(context, name: Routename.Shoppinglist, navigatore: NavigatoreTyp.Push);
                        },
                        child: Container(
                          width: 60,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 8.0,
                              ),
                              CircleAvatar(
                                radius: 13.0,
                                backgroundColor: Colors.transparent,
                                child: Image.asset(Images.shoppinglistsImg,
                                  color: ColorCodes.whiteColor,
                                  width: 18,
                                  height: 25,),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                  S.of(context).shopping_list, //"Shopping list",
                                  style: TextStyle(
                                      color: ColorCodes.whiteColor, fontSize: 10.0)),
                              SizedBox(
                                height: 8.0,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              if(!Features.isShoppingList)
                Spacer(),
              if(!Features.isShoppingList)
                ValueListenableBuilder(
                    valueListenable: IConstants.currentdeliverylocation,
                    builder: (context, value, widget) {
                      return GestureDetector(
                        onTap: () {
                          if (value != S
                              .of(context)
                              .not_available_location)
                            !PrefUtils.prefs!.containsKey("apikey") &&
                                Features.isLiveChat
                                ?
                            Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                                : (Features.isLiveChat && Features.isWhatsapp) ?
                            Navigator.of(context)
                                .pushNamed(
                                CustomerSupportScreen.routeName, arguments: {
                              'name': name,
                              'email': email,
                              'photourl': photourl,
                              'phone': phone,
                            }) :
                            (!Features.isLiveChat && !Features.isWhatsapp) ?
                            Navigation(context, navigatore: NavigatoreTyp.Push,name: Routename.search)

                                :
                            Features.isWhatsapp ? launchWhatsApp():
                            Navigator.of(context).pushNamed(CustomerSupportScreen.routeName, arguments: {
                              'name': name,
                              'email': email,
                              'photourl': photourl,
                              'phone': phone,
                            });
                        },
                        child: Container(
                          width: 60,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 8.0,
                              ),
                              CircleAvatar(
                                radius: 13.0,
                                backgroundColor: Colors.transparent,
                                child: (!Features.isLiveChat &&
                                    !Features.isWhatsapp) ?
                                Icon(
                                  Icons.search,
                                  color: ColorCodes.whiteColor,

                                )
                                    :
                                Image.asset(
                                  Features.isLiveChat ? Images.chat : Images
                                      .whatsapp,
                                  width: 20,
                                  height: 25,
                                  color: Features.isLiveChat ? ColorCodes
                                      .whiteColor : ColorCodes.whiteColor,

                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text((!Features.isLiveChat && !Features.isWhatsapp)
                                  ? S
                                  .of(context)
                                  .search
                                  : S
                                  .of(context)
                                  .chat,
                                  style: TextStyle(
                                      color: ColorCodes.whiteColor, fontSize: 10.0)),
                              SizedBox(
                                height: 8.0,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              Spacer(),
            ],
          ),
        ),
      )
          : SingleChildScrollView(child: Container());
    }

    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    final sliderData = Provider.of<Advertise1ItemsList>(context, listen: false);
    return WillPopScope(
      onWillPop: () {
        Features.ismultivendor?Navigator.of(context).pop():
        SystemNavigator.pop();
        return Future.value(true);
      },
      child: Scaffold(
        key: HomeScreen.scaffoldKey,
        drawer: Features.ismultivendor?SizedBox.shrink():ResponsiveLayout.isSmallScreen(context) ? AppDrawer() : SizedBox.shrink(),
        backgroundColor:/* Colors.white */ ColorCodes.primaryColor,
        body: SafeArea(bottom: true,
          child: Container(
              // constraints: (Vx.isWeb &&
              //     !ResponsiveLayout.isSmallScreen(context))
              //     ? BoxConstraints(maxWidth: maxwid)
              //     : null,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Features.ismultivendor ?
                  SizedBox.shrink() :Header(true) ,
                  if (sliderData.websiteItems.length <= 0) SizedBox(height: 5),
                  Expanded(
                    child: Vx.isWeb ? Align(child: _body()) : RefreshIndicator(
                      onRefresh: () => _refreshProducts(context),
                      child: _body(),
                    ),
                  ),
                ],
              )
          ),
        ),
        bottomNavigationBar: Vx.isWeb ? SizedBox.shrink() :
        Features.ismultivendor?_buildBottomNavigationBar():
        Container(
          color: Colors.white,
          child: Padding(
              padding: EdgeInsets.only(left: 0.0,
                  top: 0.0,
                  right: 0.0,
                  bottom: iphonex ? 16.0 : 0.0),
              child: bottomNavigationbar()
          ),
        ),
        floatingActionButton: Vx.isWeb
            ? SizedBox.shrink()
            : Features.ismultivendor?SizedBox.shrink()
            :
        Container(
          padding: EdgeInsets.only(
            left: MediaQuery
                .of(context)
                .size
                .width - 80,
            bottom: 80,
          ),
          child: customfloatingbutton(),
        ),
      ),
    );
  }

  MultivendorHeader(HomePageData homedata){
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: 10, bottom: 2, right: 15, left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.arrow_back, color: ColorCodes.blackColor)
                ),
              SizedBox(width: 10,),
              Text(homedata.data!.restaurantName.toString(),//"Grocery Store",
                style: TextStyle(
                    fontSize: ResponsiveLayout.isSmallScreen(context)  ? 20.0 : 24.0,
                    color: ColorCodes.blackColor,
                    fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: ColorCodes.checkmarginColor,
                border: Border.all(
                color: ColorCodes.checkmarginColor),
                ),
                child: Row(
                  children: <Widget>[
                    Image.asset(Images.starimg,
                        height: 13,
                        width: 13,
                        color: ColorCodes.whiteColor),
                    SizedBox(width: 3,),
                    Text(
                      (double.parse(homedata.data!.ratings.toString()).toStringAsFixed(2)).toString(),
                      style: TextStyle(
                          fontSize: 11,
                          color: ColorCodes.whiteColor),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Container(
            padding: EdgeInsets.only(left: 37, top: 3),
            child: Text(homedata.data!.restaurantLocation.toString(),//"Vidyarathna Nagar",
            style: TextStyle(fontWeight: FontWeight.bold,
              fontSize: 13, color: ColorCodes.grey, ),),
          ),
          SizedBox(height: 10,),
          Container(
              height: 45,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: ColorCodes.lightGreyWebColor,
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: ColorCodes.lightGreyWebColor)
              ),
              padding: EdgeInsets.only(left: 7,right: 10),
              child: IntrinsicHeight(
                child:
                Row(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Navigation(context, navigatore: NavigatoreTyp.Push,name: Routename.search);
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Icon(
                                Icons.search,
                                color: ColorCodes.blackColor,
                                size: 28
                            ),
                            SizedBox(width: 5),
                            Text(
                             S.of(context).search_for_item,// "Search for an item",//" Search From 10,000+ products",
                              style: TextStyle(
                                color: ColorCodes.grey,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          SizedBox(height: 5,),
        ],
      ),
    );
  }

  _buildBottomNavigationBar() {
    return VxBuilder(
      mutations: {SetCartItem},
      builder: (context, store, index) {
        final box = (VxState.store as GroceStore).CartItemList;
        if (box.isEmpty) return SizedBox.shrink();
        return BottomNaviagation(
          itemCount: CartCalculations.itemCount.toString() + " " + S .of(context).items,
          title: S .current.view_cart,
          total: PrefUtils.prefs!.getString("membership") == "1" ? (CartCalculations.totalMember).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)
              :
          (CartCalculations.total).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
          onPressed: (){
            Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
          },
        );
      },
    );
  }

  customfloatingbutton() {
    return ValueListenableBuilder(
        valueListenable: IConstants.currentdeliverylocation,
        builder: (context, value, widget){return VxBuilder(
          builder: (context, box, index) {
            if (CartCalculations.itemCount <= 0)
      return GestureDetector(
        onTap: () {

          Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
        },
        child: Container(
          margin: EdgeInsets.only(left: 80.0, top: 80.0, bottom: 10.0),
          width: 50,
          height: 50,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Theme
                .of(context)
                .primaryColor,
          ),
          child: GestureDetector(
            onTap: () {
              Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
            },
            child: Image.asset(
              Images.fcartImg,
              height: 12,
              fit: BoxFit.contain,
            ),
          ),
        ),
      );
            return Consumer<CartCalculations>(
              builder: (_, cart, ch) =>
                  FloatButtonBadge(
                    child: ch!,
                    color: ColorCodes.badgecolor,//Colors.green,
                    value: CartCalculations.itemCount.toString(),
                  ),
              child: GestureDetector(
                onTap: () {

                  Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
                },
                child: Container(
                  width: 50,
                  height: 50,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Theme
                        .of(context)
                        .primaryColor,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
                    },
                    child: Image.asset(
                      Images.fcartImg,
                      height: 12,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            );
          },mutations: {SetCartItem},
        );});
  }

  ShowpopupforHoliday() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async{
             DateTime now = DateTime.now();
             if (currentBackPressTime == null ||
                 now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
               currentBackPressTime = now;
               Fluttertoast.showToast(
                 msg: S.of(context).press_again_exit/*"Press Again to Exit!"*/, fontSize: MediaQuery
                   .of(context)
                   .textScaleFactor * 13,);
               return Future.value(false);
             }
             return Future.value(true);
          },
          child: AlertDialog(
            title: Image.asset(
              Images.logoImg,
              height: 50,
              width: 138,
            ),
            content: Text(IConstants.holydayNote),
            actions: <Widget>[
              Vx.isWeb ? SizedBox.shrink() : FlatButton(
                child: Text(
                  S.of(context).ok, //'Ok'
                ),
                onPressed: () async {
                  SystemNavigator.pop();
                },
              ),
              FlatButton(
                child: Text(
                  S.of(context).change_location, //'Change'
                ),
                onPressed: () async {
                  PrefUtils.prefs!.setString("formapscreen", "homescreen");
                    if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                    // _dialogforaddress(context);
                    MapWeb(context);
                    }
                    else {
                      Navigation(context, name: Routename.MapScreen,
                          navigatore: NavigatoreTyp.Push);
                    }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  ShowPopupforbanner() {
    final bannerpopup = Provider.of<Advertise1ItemsList>(context, listen: false);
    setState(() {
      count++;
    });
    PrefUtils.prefs!.setString("descriptionCount", count.toString());
    showDialog(
      context: context,
      barrierDismissible: (Vx.isWeb) ? true : false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            Navigator.of(context).pop();
            return Future.value(false);
          },
          child:
          Center(
            child: Container(
              height: 250,
              width: 300,

              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      bannerpopup.popupbanner[0].imageUrl!, height: 250,
                      width: 300,
                      fit: BoxFit.fill,),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Align(
                      alignment: Alignment.topRight,
                      child: CircleAvatar(
                        radius: 14.0,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.close, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),

            ),
          ),
        );
      },
    );
  }

  Widget loadhomeScreen() {
    final homedata = (VxState.store as GroceStore).homescreen;

    if (homedata.data != null)
      return SingleChildScrollView(
        child: Column(
          children: [
            Container(
              constraints: (Vx.isWeb &&
                  !ResponsiveLayout.isSmallScreen(context))
                  ? BoxConstraints(maxWidth: maxwid)
                  : null,
              child: SingleChildScrollView(
                  child: _isinternet
                      ?
                  VxBuilder(
                      mutations: {SetPrimeryLocation},
                      builder: (context,value, widget) {
                        return !value.userData.delevrystatus! ?
                        SingleChildScrollView(
                          child: Center(
                            child: Container(
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(
                                          left: 80.0, right: 80.0),
                                      width:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .width,
                                      height: 200.0,
                                      child: new Image.asset(
                                          Images.notDeliveringImg)),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  if(value.userData.area!=null)
                                  Text(
                                      S.of(context).sorry_wedidnt_deliever + // "Sorry, we don't deliver in " +
                                          value.userData.area.toString()),
                                  GestureDetector(
                                    onTap: () {
                                      PrefUtils.prefs!.setString("formapscreen", "homescreen");
                                    if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                                    // _dialogforaddress(context);
                                    MapWeb(context);
                                    }
                                    else {
                                      Navigation(
                                          context, name: Routename.MapScreen,
                                          navigatore: NavigatoreTyp.Push);
                                      }
                                    },
                                    child: Container(
                                      width: 100.0,
                                      height: 40.0,
                                      margin: EdgeInsets.only(top: 20.0),
                                      decoration: BoxDecoration(
                                        color: ColorCodes.primaryColor,
                                        // color: Theme
                                        //     .of(context)
                                        //     .accentColor,
                                        borderRadius:
                                        BorderRadius.circular(3.0),
                                      ),
                                      child: Center(
                                          child: Text(
                                            S.of(context).change_location, //'Change Location',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white),
                                          )),
                                    ),
                                  ),
                                  // if (Vx.isWeb)Footer(
                                  //   address: PrefUtils.prefs!.getString("restaurant_address")!,
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        )
                            :
                        _isDelivering
                            ? homedata != null ?
                        Column(
                          children: [
                            Features.ismultivendor ? MultivendorHeader(homedata) : SizedBox.shrink(),
                            if (!PrefUtils.prefs!.containsKey("apikey") && !Vx.isWeb)(Features.isMembership && !Features.ismultivendor) ?
                            Container(
                              height: 35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: Colors.green),
                              width: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
                                  ? MediaQuery.of(context).size.width * 0.20 : MediaQuery.of(context).size.width,
                              margin: EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  SizedBox(width: 10),
                                  Text(S .of(context).get_membership_and_other, //"Get membership & other benefits",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                      onTap: () {
                                        Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push);
                                      },
                                      child: Text(
                                        S.of(context).login_register, //"LOGIN / REGISTER",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  SizedBox(width: 10),
                                ],
                              ),
                            ) : SizedBox.shrink(),
                            if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))_bannerMain1(homedata),
                            if(Features.isWebsiteSlider) if(Vx.isWeb &&
                                !ResponsiveLayout.isSmallScreen(
                                    context)) WebsiteSlider(homedata),
                            if(Vx.isWeb && !ResponsiveLayout.isLargeScreen(
                                context))_bannerMain1(homedata),
                            if(!Vx.isWeb)_bannerMain1(homedata),
                            if(!Features.ismultivendor)SizedBox(height: 4),
                            if(Features.isCarousel) if (ResponsiveLayout.isSmallScreen(context)) Container(
                                margin: EdgeInsets.only(left: 10.0,right: 10.0,),
                                child: CarouselSliderimage(homedata,"mainslider")),
                            //TODO: Pending Mutation Intigration
                            if (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)) WebsiteSmallbanner(homedata),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                //TODO:Category one mutation i pending due its linked with another page
                                if(Features.isCategoryOne)Column(
                                  crossAxisAlignment:CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?0.0:10.0, right: 10.0,),
                                      padding: EdgeInsets.only(top: 10, bottom: 5),
                                      child:
                                      Features.ismultivendor ?
                                      SizedBox.shrink() :
                                      (homedata.data!.categoryLabel! !=" ")?
                                      Text(
                                        homedata.data!.categoryLabel!,
                                        style: TextStyle(
                                            fontSize: ResponsiveLayout.isSmallScreen(context)?18.0:24.0,
                                            fontWeight: FontWeight.w900,
                                          color:  (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
                                          ColorCodes.blackColor:ColorCodes.primaryColor,),
                                      ) : SizedBox.shrink(),
                                    ),
                                    Container(
                               margin: EdgeInsets.only(left: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?0.0:10.0, right: 10.0,),
                                      child: CategoryOne(
                                          homedata),
                                    ),

                                  ],
                                ),
                                if(Features.isCategoryOne)
                                SizedBox(
                                  height: 5,
                                ),

                                if(Features.issubscriptionbox)
                                  SubscriprtionBox(homedata),
                                if(Features.issubscriptionbox)
                                  SizedBox(
                                    height: 5,
                                  ),
                                if(Features.isAdsCategoryOne)
                                  _advertiseCategoryOne(homedata),
                                // if(!Features.ismultivendor && Features.isBulkUpload)(MediaQuery
                                //     .of(context)
                                //     .size
                                //     .width <= 600) ?
                                // Container(
                                //     width: MediaQuery
                                //         .of(context)
                                //         .size
                                //         .width,
                                //     padding: EdgeInsets.only(
                                //         left: 10.0, right: 10.0, bottom: 8.0),
                                //     child: Text(
                                //       S.of(context).for_your_convenience, //"For Your Convenience",
                                //       style: TextStyle(
                                //           fontSize: 18,
                                //           color: Theme.of(context).primaryColor,
                                //           fontWeight: FontWeight.bold),
                                //     )
                                // )
                                //     :
                                // SizedBox.shrink(),
                                // if(!Features.ismultivendor && Features.isBulkUpload)(MediaQuery
                                //     .of(context)
                                //     .size
                                //     .width <= 600) ? Container(
                                //   width: MediaQuery.of(context).size
                                //       .width,
                                //   margin: EdgeInsets.only(left: 10.0,
                                //       top: 8.0,
                                //       right: 10.0,
                                //       bottom: 15.0),
                                //   child: Row(
                                //     children: [
                                //       GestureDetector(
                                //         onTap: () {
                                //           !PrefUtils.prefs!.containsKey(
                                //               "apikey") ?
                                //           Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                                //               :
                                //               Navigation(context, name: Routename.MultipleImagePicker, navigatore:  NavigatoreTyp.Push);
                                //         },
                                //         child: Image.asset(
                                //           Images.bulkImg,
                                //           width: (MediaQuery
                                //               .of(context)
                                //               .size
                                //               .width / 2) - 15,
                                //         ),
                                //
                                //       ),
                                //       SizedBox(width: 10),
                                //       GestureDetector(
                                //         onTap: () {
                                //           launch("tel: " +
                                //               IConstants.primaryMobile);
                                //         },
                                //         child: Image.asset(
                                //           Images.supportImg,
                                //           width: (MediaQuery
                                //               .of(context)
                                //               .size
                                //               .width / 2) - 15,
                                //         ),
                                //       )
                                //
                                //     ],
                                //   ),
                                // ) : SizedBox.shrink(),

                                if(!Features.ismultivendor && Features.isBulkUpload)(MediaQuery
                                    .of(context)
                                    .size
                                    .width <= 600) ? Container(
                                  width: MediaQuery.of(context).size
                                      .width,
                                  margin: EdgeInsets.only(left: 10.0,
                                      top: 8.0,
                                      right: 10.0,
                                      bottom: 15.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            !PrefUtils.prefs!.containsKey(
                                                "apikey") ?
                                            Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                                                :
                                            Navigation(context, name: Routename.MultipleImagePicker, navigatore:  NavigatoreTyp.Push);
                                          },
                                          child: Container(
                                              margin: EdgeInsets.only(right: 5,left:5),
                                              padding: EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 15),
                                              decoration: BoxDecoration(
                                                color: ColorCodes.varcolor,
                                                borderRadius: BorderRadius.all(
                                                    const Radius.circular(5.0)
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(S.of(context).bulk, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor)),
                                                      Spacer(),
                                                      Image.asset(
                                                        Images.bulkImage,
                                                        height: 22,
                                                        color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 2,),
                                                  Text(S.of(context).order_quick, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor)),
                                                ]
                                              )
                                            ),
                                          ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            launch("tel: " +
                                                IConstants.primaryMobile);
                                          },
                                            child: Container(
                                              margin: EdgeInsets.only(left: 7),
                                              padding: EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 15),
                                              decoration: BoxDecoration(
                                                color: ColorCodes.supportbg,
                                                borderRadius: BorderRadius.all(
                                                    const Radius.circular(5.0)
                                                ),
                                              ),
                                              child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(S.of(context).support, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor)),
                                                        Spacer(),
                                                        Image.asset(
                                                          Images.supportImage,
                                                          height: 22,
                                                          color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 2,),
                                                    Text(S.of(context).get_in_touch, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor)),
                                                  ]
                                              ),
                                            ),

                                        ),
                                      )
                                    ],
                                  ),
                                ) : SizedBox.shrink(),



                                if(Features.istestimonial) if (ResponsiveLayout.isSmallScreen(context)) CarouselSliderimage(homedata,"testimonial"),//_testimonialAds(homedata),
                                if(Features.isSellingItems) Vx.isWeb
                                      ? _featuredItemweb(homedata)
                                      : _featuredItemMobile(homedata),
                                if(Features
                                    .isAdsItemsOne) // Advertisement for Featured Items 1_featuredAdsOne(),
                                  _featuredAdsOne(homedata),
                                if(Features.isCategory)
                                  (Vx.isWeb)
                                      ? _categoryweb(homedata)
                                      : _category(homedata),
                                if(Features.isCategoryTwo)
                                  Container(margin: EdgeInsets.only(left:(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
                                      ?0: 10.0, right: 10.0),
                                      child: CategoryTwo(homedata)),
                                  if(Features.isCategoryThree)
                                    _categoryThree(homedata),
                                if(Features.isVerticalSlider)
                                  _featuredAdsVertical(homedata),
                                if(Features.isFeatureAdsThree)
                                  _featuredAdsThree(homedata),
                                if(Features.isOffersForHomepage)
                                  _offersItem(homedata),
                                //Categories
                                SizedBox(
                                  height: 5,
                                ),
                                if(Features.isAdsCategoryTwo)
                                  _featuredAdsTwo(homedata),
                                // Brands items

                                if(!Features.ismultivendor && Features.isBrands)
                                  _brands(homedata),
                                if(Features.isDiscountItems)
                                  _discountItem(homedata),
                              ],
                            ),
                            if(Features.isFooter)
                              if (!Vx.isWeb)
                                _footer(homedata),
                           // if (Vx.isWeb) Footer(address: _address),
                          ],)
                            : SizedBox.shrink() :
                        SingleChildScrollView(
                          child: Center(
                            child: Container(
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(
                                          left: 80.0, right: 80.0),
                                      width:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .width,
                                      height: 200.0,
                                      child: new Image.asset(
                                          Images.notDeliveringImg)),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                      S.of(context).sorry_wedidnt_deliever + // "Sorry, we don't deliver in " +
                                          PrefUtils.prefs!.getString("deliverylocation")!),
                                  GestureDetector(
                                    onTap: () {
                                      PrefUtils.prefs!.setString("formapscreen", "homescreen");
                                    if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                                    // _dialogforaddress(context);
                                    MapWeb(context);
                                    }
                                    else {
                                      Navigation(
                                          context, name: Routename.MapScreen,
                                          navigatore: NavigatoreTyp.Push);
                                        }
                                    },
                                    child: Container(
                                      width: 100.0,
                                      height: 40.0,
                                      margin: EdgeInsets.only(top: 20.0),
                                      decoration: BoxDecoration(
                                        color: ColorCodes.primaryColor,
                                        // color: Theme
                                        //     .of(context)
                                        //     .accentColor,
                                        borderRadius:
                                        BorderRadius.circular(3.0),
                                      ),
                                      child: Center(
                                          child: Text(
                                            S.of(context).change_location, //'Change Location',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.white),
                                          )),
                                    ),
                                  ),
                                  // if (Vx.isWeb)Footer(address: PrefUtils.prefs!.getString(
                                  //       "restaurant_address")!,
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }) :
                  SingleChildScrollView(
                    child: Center(
                      child: Container(
                        height: MediaQuery
                            .of(context)
                            .size
                            .width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(
                                    left: 80.0, right: 80.0),
                                width:
                                MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                height: 200.0,
                                child: new Image.asset(
                                    Images.notDeliveringImg)),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                                S.of(context).sorry_wedidnt_deliever + // "Sorry, we don't deliver in " +
                                    PrefUtils.prefs!.getString("deliverylocation")!),
                            GestureDetector(
                              onTap: () {
                                PrefUtils.prefs!.setString("formapscreen", "homescreen");
                            if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                            // _dialogforaddress(context);
                            MapWeb(context);
                            }
                            else {
                              Navigation(context, name: Routename.MapScreen,
                                  navigatore: NavigatoreTyp.Push);
                                }
                              },
                              child: Container(
                                width: 100.0,
                                height: 40.0,
                                margin: EdgeInsets.only(top: 20.0),
                                decoration: BoxDecoration(
                                  color: ColorCodes.primaryColor,//Theme.of(context).accentColor,
                                  borderRadius:
                                  BorderRadius.circular(3.0),
                                ),
                                child: Center(
                                    child: Text(
                                      S.of(context).change_location, //'Change Location',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    )),
                              ),
                            ),
                            // if (Vx.isWeb)
                            //   Footer(address: PrefUtils.prefs!.getString("restaurant_address")!,),
                          ],
                        ),
                      ),
                    ),
                  )
              ),
            ),
            if (Vx.isWeb)Footer(
              address: PrefUtils.prefs!.getString("restaurant_address")!,
            ),
          ],
        ),
      );
    else {
      HomeScreenController(user: PrefUtils.prefs!.getString("apikey") ??
          PrefUtils.prefs!.getString("tokenid"),
        branch: PrefUtils.prefs!.getString("branch") ?? "999",
        rows: "0",  lat:(Features.ismultivendor) ? (VxState.store as GroceStore).userData.latitude??PrefUtils.prefs!.getString("latitude"):"" ,
          long: (Features.ismultivendor) ? (VxState.store as GroceStore).userData.longitude??PrefUtils.prefs!.getString("longitude"): "", branchtype: (Features.ismultivendor) ? IConstants.branchtype : "");
      return (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
          ? HomeScreenShimmerWeb()
          : HomeScreenShimmer();
    }
  }

  dialogForFreemembership (){
    PrefUtils.prefs!.setString("typenew","");
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Image.asset(
            Images.logoImg,
            height: 50,
            width: 138,
          ),
          content:
          Container(
            height:80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(S.of(context).eligible_membership,//"You are eligible for 3 month free membership",
                  style: TextStyle(
                    color: Colors.black, fontSize: 16,
                  ), ),
                SizedBox(height:10),
                Text(
                  S.of(context).yay,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: ColorCodes.primaryColor),),
              ],
            ),
          ),
        );
      },
    );
  }
}