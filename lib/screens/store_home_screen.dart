import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grocbay/assets/ColorCodes.dart';
import 'package:grocbay/assets/images.dart';
import 'package:grocbay/constants/IConstants.dart';
import 'package:grocbay/constants/features.dart';
import 'package:grocbay/controller/mutations/categorystore_mutation.dart';
import 'package:grocbay/controller/mutations/home_screen_mutation.dart';
import 'package:grocbay/controller/mutations/home_store_mutation.dart';
import 'package:grocbay/controller/mutations/store_mutation.dart';
import 'package:grocbay/generated/l10n.dart';
import 'package:grocbay/models/VxModels/VxStore.dart';
import 'package:grocbay/models/newmodle/home_page_modle.dart';
import 'package:grocbay/models/newmodle/home_store_modle.dart';
import 'package:grocbay/models/newmodle/store_banner.dart';
import 'package:grocbay/models/newmodle/store_data.dart';
import 'package:grocbay/repository/authenticate/AuthRepo.dart';
import 'package:grocbay/repository/fetchdata/view_all_product.dart';
import 'package:grocbay/repository/fetchdata/view_all_store.dart';
import 'package:grocbay/repository/productandCategory/category_or_product.dart';
import 'package:grocbay/screens/profile_screen.dart';
import 'package:grocbay/screens/store_screen.dart';
import 'package:grocbay/utils/ResponsiveLayout.dart';
import 'package:grocbay/utils/prefUtils.dart';
import 'package:grocbay/widgets/CarouselSliderimageWidget.dart';
import 'package:grocbay/widgets/StoreBottomNavigationWidget.dart';
import 'package:grocbay/widgets/advertise1_items.dart';
import 'package:grocbay/widgets/advertisemultivendor_items.dart';
import 'package:grocbay/widgets/carousel_slider_store.dart';
import 'package:grocbay/widgets/header.dart';
import 'package:grocbay/widgets/nearby_shop.dart';
import 'package:grocbay/widgets/simmers/ItemWeb_shimmer.dart';
import 'package:grocbay/widgets/simmers/home_screen_shimmer.dart';
import 'package:grocbay/widgets/simmers/item_list_shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

import '../rought_genrator.dart';
import '../widgets/app_drawer.dart';
import 'customer_support_screen.dart';
import 'membership_screen.dart';

class StoreHomeScreen extends StatefulWidget {
  static const routeName = '/store-home-screen';
  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  Map<String, String>? storehome;
  String storeid = "";
  String fromScreen = "";
  String viewall = "";
  StoreHomeScreen({Key? key,Map<String, String>? params}){
    this.storehome = params;
    this.storeid = params!["store_id"]??"" ;
    this.fromScreen = params["fromScreen"]??"" ;
    this.viewall = params["view_all"]??"" ;
  }

  @override
  _StoreHomeScreenState createState() => _StoreHomeScreenState();
}

class _StoreHomeScreenState extends State<StoreHomeScreen> with Navigations{
  bool _isDelivering = true;
  bool iphonex = false;
  var name = "",
      email = "",
      photourl = "",
      phone = "";
  var _carauselslider = false;
  Future<StoreData>?  futureproducts ;
//StoreData? storedata;
final storedata = (VxState.store as GroceStore).storedata;
  int count =0;
  final storesdata = (VxState.store as GroceStore).homestore;
  var _isLoading = true;
  bool _isWeb =false;
  MediaQueryData? queryData;
  bool _checkmembership = false;
  String? title;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState

    Future.delayed(Duration.zero, () async {
     print("store id....store home..."+widget.storeid.toString()+"...."+widget.viewall.toString());
     if(widget.fromScreen == "Category"){
       CategoryStoreScreenController(id: widget.storeid.toString(),
           lat: (VxState.store as GroceStore).userData.latitude??PrefUtils.prefs!.getString("latitude"),
           long: (VxState.store as GroceStore).userData.longitude??PrefUtils.prefs!.getString("longitude"));
     }
     else if(widget.viewall == "near_stores"){
       futureproducts =  viewStores.getData(ViewStoreOf.nearby_store,
           status: (onloadcompleate){
         setState(() {
           CategoryStoreScreenController(id: widget.storeid.toString(),
               lat: (VxState.store as GroceStore).userData.latitude??PrefUtils.prefs!.getString("latitude"),
               long: (VxState.store as GroceStore).userData.longitude??PrefUtils.prefs!.getString("longitude"));
           _isLoading = !onloadcompleate;

           //title =  (VxState.store as GroceStore).homescreen.data!.featuredByCart!.label;
         });
       });
     }
     else if(widget.viewall == "stores"){
       futureproducts =  viewStores.getData(ViewStoreOf.stores,status: (onloadcompleate){
         setState(() {
           _isLoading = !onloadcompleate;
           //title =  (VxState.store as GroceStore).homescreen.data!.featuredByCart!.label;
         });
       });
     }
     else {
       print("widget stioresid..."+widget.storeid.toString());
       StoreController(ids: widget.storeid,
           lat: (VxState.store as GroceStore).userData.latitude??PrefUtils.prefs!.getString("latitude"),
           long: (VxState.store as GroceStore).userData.longitude??PrefUtils.prefs!.getString("longitude"));
     }
      /*  StoreController storeController = StoreController();
        await storeController.fetchstore(lat: (VxState.store as GroceStore).userData.latitude.toString(), long: (VxState.store as GroceStore).userData.longitude.toString(), ids: widget.storeid);*/
       //storedata =  ProductRepo().getStore(widget._varid.toString(),"","");

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
      int _nestedIndex = 0;
      setState(() {
        if (PrefUtils.prefs!.getString("membership") == "1") {
          _checkmembership = true;
        } else {
          _checkmembership = false;
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {

   return Scaffold (
     key: StoreHomeScreen.scaffoldKey,
     drawer: ResponsiveLayout.isSmallScreen(context) ? Features.ismultivendor?ProfileScreen():AppDrawer() : SizedBox.shrink(),
      appBar: ResponsiveLayout.isSmallScreen(context) ?
      gradientappbarmobile() : null,
      backgroundColor: /*Theme
          .of(context)
          .backgroundColor*/ColorCodes.whiteColor,
      body: Column(
        children: <Widget>[
          if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
            Header(false),
          (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))? _bodyWeb():Flexible(child: _bodyMobile()),

        ],
      ),
      // bottomNavigationBar:(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?SizedBox.shrink(): bottomNavigationbar(),
     floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
     floatingActionButton: Container(

         width: MediaQuery.of(context).size.width,

         child: StoreBottomNavigation()),
    );
  }

  void launchWhatsApp() async {
    String phone = /*"+918618320591"*/IConstants.secondaryMobile;
    debugPrint("Whatsapp . .. . . .. . .");
    String url() {
      if (Platform.isIOS) {
        debugPrint("Whatsapp1 . .. . . .. . .");
        return "whatsapp://wa.me/$phone/?text=${Uri.parse('I want to order Grocery')}";
      } else {
        return "whatsapp://send?phone=$phone&text=${Uri.parse('I want to order Grocery')}";
        const url = "https://wa.me/?text=YourTextHere";

      }
    }
    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  bottomNavigationbar() {
    return _isDelivering
        ? SingleChildScrollView(
      child: Container(
        height: 60,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Spacer(),
            Column(
              children: <Widget>[
                SizedBox(
                  height: 7.0,
                ),
                CircleAvatar(
                  radius: 13.0,
                  // minRadius: 50,
                  // maxRadius: 50,
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.transparent,
                  child: Image.asset(Images.homeImg,
                    //  color:ColorCodes.greenColor,
                    color: IConstants.isEnterprise?ColorCodes.primaryColor:ColorCodes.maphome,

                    width: 50,
                    height: 30,
                  ),

                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                    S.of(context).home,
                    // "Home",
                    style: TextStyle(
                        color: IConstants.isEnterprise?ColorCodes.primaryColor:ColorCodes.maphome,
                        //  color: ColorCodes.greenColor,
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            Spacer(),
            ValueListenableBuilder(
                valueListenable: IConstants.currentdeliverylocation,
                builder: (context, value, widget) {
                  return GestureDetector(
                    onTap: () {
                      if (value != S
                          .of(context)
                          .not_available_location)
                        /*Navigator.of(context).pushNamed(
                            CategoryScreen.routeName,
                          );*/
                        Navigation(context, name:Routename.Category, navigatore: NavigatoreTyp.Push);
                    },
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 7.0,
                        ),
                        CircleAvatar(
                          radius: 13.0,
                          backgroundColor: Colors.transparent,
                          child: Image.asset(Images.categoriesImg,
                            color: ColorCodes.lightgrey,
                            width: 50,
                            height: 30,),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                            S
                                .of(context)
                                .categories, //"Categories",
                            style: TextStyle(
                                color: ColorCodes.grey, fontSize: 10.0)),
                      ],
                    ),
                  );
                }),
            if(Features.isWalletroot)
              Spacer(),
            if(Features.isWalletroot)
              ValueListenableBuilder(
                  valueListenable: IConstants.currentdeliverylocation,
                  builder: (context, value, widget) {
                    return GestureDetector(
                      onTap: () {
                        if (value != S
                            .of(context)
                            .not_available_location)
                          !PrefUtils.prefs!.containsKey("apikey")
                              ? /*Navigator.of(context).pushNamed(
                              SignupSelectionScreen.routeName,
                            )*/
                          Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push) :
                          Navigation(context, name: Routename.Wallet, navigatore: NavigatoreTyp.Push,
                              qparms: {"type": "wallet"} );
                        /*Navigator.of(context).pushNamed(
                                WalletScreen.routeName,
                                arguments: {"type": "wallet"});*/
                      },
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 7.0,
                          ),
                          CircleAvatar(
                            radius: 13.0,
                            backgroundColor: Colors.transparent,
                            child: Image.asset(Images.walletImg,
                              color: ColorCodes.lightgrey,
                              width: 50,
                              height: 30,),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                              S .of(context)
                                  .wallet, //"Wallet",
                              style: TextStyle(
                                  color: ColorCodes.grey, fontSize: 10.0)),
                        ],
                      ),
                    );
                  }),

            if(Features.isMembershiproot)
              Spacer(),
            if(Features.isMembershiproot)
              ValueListenableBuilder(
                  valueListenable: IConstants.currentdeliverylocation,
                  builder: (context, value, widget) {
                    return GestureDetector(
                      onTap: () {
                        if (value != S
                            .of(context)
                            .not_available_location)
                          !PrefUtils.prefs!.containsKey("apikey")
                              ? /*Navigator.of(context).pushNamed(
                              SignupSelectionScreen.routeName,
                            )*/
                          Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                              : /*Navigator.of(context).pushNamed(
                              MembershipScreen.routeName,
                            );*/
                           (Vx.isWeb &&
                          !ResponsiveLayout.isSmallScreen(context)) ?
                          MembershipInfo(context):
                          Navigation(context, name: Routename.Membership, navigatore: NavigatoreTyp.Push);
                      },
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 7.0,
                          ),
                          CircleAvatar(
                            radius: 13.0,
                            backgroundColor: Colors.transparent,
                            child: Image.asset(
                              Images.bottomnavMembershipImg,
                              color: ColorCodes.lightgrey,
                              width: 50,
                              height: 30,),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                              S.of(context).membership, //"Membership",
                              style: TextStyle(
                                  color: ColorCodes.grey, fontSize: 10.0)),
                        ],
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
                              ? /*Navigator.of(context).pushNamed(
                              SignupSelectionScreen.routeName,
                            )*/
                          Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                              : /*Navigator.of(context).pushNamed(
                                MyorderScreen.routeName, arguments: {
                              "orderhistory": ""
                            }
                            );*/
                          Navigation(context, name:Routename.MyOrders,navigatore: NavigatoreTyp.Push,
                            /*parms: {
                              "orderhistory": ""
                            }*/);
                      },
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 7.0,
                          ),
                          CircleAvatar(
                            radius: 13.0,
                            backgroundColor: Colors.transparent,
                            child: Image.asset(
                              Images.bag,
                              color: ColorCodes.lightgrey,
                              width: 50,
                              height: 30,),
                          ),

                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                              S
                                  .of(context)
                                  .my_orders, //"My Orders",
                              style: TextStyle(
                                  color: ColorCodes.grey, fontSize: 10.0)),
                        ],
                      ),
                    );
                  }),
            if(Features.isShoppingList)
              Spacer(flex: 1),
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
                              ? /*Navigator.of(context).pushNamed(
                              SignupSelectionScreen.routeName,
                            )*/
                          Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                              :
                          /*Navigator.of(context).pushNamed(
                              ShoppinglistScreen.routeName,
                            );*/
                          Navigation(context, name: Routename.Shoppinglist, navigatore: NavigatoreTyp.Push);
                      },
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 7.0,
                          ),
                          CircleAvatar(
                            radius: 13.0,
                            backgroundColor: Colors.transparent,
                            child: Image.asset(Images.shoppinglistsImg,
                              color: ColorCodes.lightgrey,
                              width: 50,
                              height: 30,),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                              S
                                  .of(context)
                                  .shopping_list, //"Shopping list",
                              style: TextStyle(
                                  color: ColorCodes.grey, fontSize: 10.0)),
                        ],
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
                              ? /*Navigator.of(context).pushNamed(
                              SignupSelectionScreen.routeName,
                            )*/
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
                          Features.isWhatsapp ?/* launchWhatsapp(
                                number: IConstants.countryCode +
                                    IConstants.secondaryMobile,
                                message: "I want to order Grocery") */launchWhatsApp():
                          Navigator.of(context)
                              .pushNamed(
                              CustomerSupportScreen.routeName, arguments: {
                            'name': name,
                            'email': email,
                            'photourl': photourl,
                            'phone': phone,
                          });
                      },
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 7.0,
                          ),
                          CircleAvatar(
                            radius: 13.0,
                            backgroundColor: Colors.transparent,
                            child: (!Features.isLiveChat &&
                                !Features.isWhatsapp) ?
                            Icon(
                              Icons.search,
                              color: ColorCodes.lightgrey,

                            )
                                :
                            Image.asset(
                              Features.isLiveChat ? Images.chat : Images
                                  .whatsapp,
                              width: 50,
                              height: 30,
                              color: Features.isLiveChat ? ColorCodes
                                  .lightgrey : null,

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
                                  color: ColorCodes.grey, fontSize: 10.0)),
                        ],
                      ),
                    );
                  }),
            Spacer(
              flex: 1,
            ),
          ],
        ),
      ),
    )
        : SingleChildScrollView(child: Container());
  }
  _bodyWeb(){
    return ;
  }
  _bodyMobile(){

    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

   return SingleChildScrollView(
      child:
      VxBuilder(
           mutations: {StoreController,CategoryStoreScreenController},
           builder: (ctx, store,VxStatus? state) {
             if(VxStatus.success==state)
               return
                 Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [

                   ValueListenableBuilder(
                       valueListenable: IConstants.currentdeliverylocation,
                       builder: (context, value, widget) {
                         return Container(
                           height: 40,
                           width: MediaQuery
                               .of(context)
                               .size
                               .width,
                           //color: ColorCodes.grey,
                           decoration: BoxDecoration(
                               color: ColorCodes.backgroundcolor,
                               borderRadius: BorderRadius.circular(10),
                               border: Border.all(
                                   color: ColorCodes.backgroundcolor)
                           ),
                           //width: MediaQuery.of(context).size.width,
                           margin: EdgeInsets.symmetric(
                               horizontal: 10, vertical: 10),
                           padding: EdgeInsets.only(left: 7, right: 10),

                           child: IntrinsicHeight(
                             child:
                             Row(
                               children: [
                                 GestureDetector(
                                   behavior: HitTestBehavior.translucent,
                                   onTap: () {
                                     // if (_isDelivering)
                                     /*Navigation(
                                         context, navigatore: NavigatoreTyp.Push,
                                         name: Routename.search);*/
                                     Navigation(context, navigatore: NavigatoreTyp.Push,name: Routename.SearchStore);
                                   },
                                   child: Container(
                                     //width: MediaQuery.of(context).size.width * 1.2,
                                     child: Row(
                                       //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       children: [
                                         Icon(
                                             Icons.search,
                                             color: ColorCodes.blackColor,
                                             size: 25
                                         ),
                                         SizedBox(width: 5),
                                         Text(
                                           S.current.search_store_prouct,
                                           //" Search From 10,000+ products",
                                           style: TextStyle(
                                             color: ColorCodes.grey,
                                             fontSize: 13.0,
                                             fontWeight: FontWeight.w600,
                                           ),
                                         ),
                                         //SizedBox(width: MediaQuery.of(context).size.width),

                                       ],
                                     ),
                                   ),
                                 )
                               ],
                             ),
                           ),
                         );
                       }),
                   if (ResponsiveLayout.isSmallScreen(context)) Carousel(store!.storeofferbanner,store.homestore),
                   //if(Features.isCarousel) if (ResponsiveLayout.isSmallScreen(context)) CarouselSliderimage(storesdata),
                   if(!Vx.isWeb)(store!.storeofferbanner != "")?advertisemultivendor(store.homestore, store.storeofferbanner):SizedBox.shrink(),

                   loadHome(store!.storedata),

                   SizedBox(height: 60),

                 ],
               );
             else if(state==VxStatus.none){
               print("error loading screen");
               if((VxState.store as GroceStore).storedata.toJson().isEmpty || (VxState.store as GroceStore).categoryStore.toJson().isEmpty ||(VxState.store as GroceStore).storeofferbanner.toJson().isEmpty) {
                 auth.getuserProfile(onerror: () {
                   HomeStoreScreenController(user: PrefUtils.prefs!.getString("apikey") ?? PrefUtils.prefs!.getString("ftokenid"),  lat: (VxState.store as GroceStore).userData.latitude??PrefUtils.prefs!.getString("latitude"),
                       long: (VxState.store as GroceStore).userData.longitude??PrefUtils.prefs!.getString("longitude") );
                   if(widget.fromScreen == "Category"){
                     CategoryStoreScreenController(id: widget.storeid.toString(),
                         lat: (VxState.store as GroceStore).userData.latitude??PrefUtils.prefs!.getString("latitude"),
                         long: (VxState.store as GroceStore).userData.longitude??PrefUtils.prefs!.getString("longitude"));
                   }
                   else if(widget.viewall == "near_stores"){
                     futureproducts =  viewStores.getData(ViewStoreOf.nearby_store,
                         status: (onloadcompleate){
                           setState(() {
                             CategoryStoreScreenController(id: widget.storeid.toString(),
                                 lat: (VxState.store as GroceStore).userData.latitude??PrefUtils.prefs!.getString("latitude"),
                                 long: (VxState.store as GroceStore).userData.longitude??PrefUtils.prefs!.getString("longitude"));
                             _isLoading = !onloadcompleate;

                             //title =  (VxState.store as GroceStore).homescreen.data!.featuredByCart!.label;
                           });
                         });
                   }
                 }, onsucsess: (value) {
                   HomeStoreScreenController(user: PrefUtils.prefs!.getString("apikey") ?? PrefUtils.prefs!.getString("ftokenid"),  lat: (VxState.store as GroceStore).userData.latitude??PrefUtils.prefs!.getString("latitude"),
                       long: (VxState.store as GroceStore).userData.longitude??PrefUtils.prefs!.getString("longitude") );
                   if(widget.fromScreen == "Category"){
                     CategoryStoreScreenController(id: widget.storeid.toString(),
                         lat: (VxState.store as GroceStore).userData.latitude??PrefUtils.prefs!.getString("latitude"),
                         long: (VxState.store as GroceStore).userData.longitude??PrefUtils.prefs!.getString("longitude"));
                   }
                   else if(widget.viewall == "near_stores"){
                     futureproducts =  viewStores.getData(ViewStoreOf.nearby_store,
                         status: (onloadcompleate){
                           setState(() {
                             CategoryStoreScreenController(id: widget.storeid.toString(),
                                 lat: (VxState.store as GroceStore).userData.latitude??PrefUtils.prefs!.getString("latitude"),
                                 long: (VxState.store as GroceStore).userData.longitude??PrefUtils.prefs!.getString("longitude"));
                             _isLoading = !onloadcompleate;

                             //title =  (VxState.store as GroceStore).homescreen.data!.featuredByCart!.label;
                           });
                         });
                   }
                 });

                 //HomeScreenController(user: PrefUtils.prefs!.getString("apikey") ?? PrefUtils.prefs!.getString("ftokenid"), branch: PrefUtils.prefs!.getString("branch") ?? "999", rows: "0",);
                 return HomeScreenShimmer();
               }else{
                 return loadHomeScreen();
               }
             }
             return HomeScreenShimmer();


           }),
   );
  }
  Widget loadHomeScreen(){
    final storedata = (VxState.store as GroceStore).storedata;
    final storedatabanner = (VxState.store as GroceStore).storeofferbanner;
    final categorydata = (VxState.store as GroceStore).categoryStore;

    if(storedata.data!= null /*|| storedatabanner.data!.offerBanner!.isNotEmpty*/) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          ValueListenableBuilder(
              valueListenable: IConstants.currentdeliverylocation,
              builder: (context, value, widget) {
                return Container(
                  height: 40,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  //color: ColorCodes.grey,
                  decoration: BoxDecoration(
                      color: ColorCodes.backgroundcolor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: ColorCodes.backgroundcolor)
                  ),
                  //width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(
                      horizontal: 10, vertical: 10),
                  padding: EdgeInsets.only(left: 7, right: 10),

                  child: IntrinsicHeight(
                    child:
                    Row(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            // if (_isDelivering)
                            /*Navigation(
                                         context, navigatore: NavigatoreTyp.Push,
                                         name: Routename.search);*/
                            Navigation(context, navigatore: NavigatoreTyp.Push,
                                name: Routename.SearchStore);
                          },
                          child: Container(
                            //width: MediaQuery.of(context).size.width * 1.2,
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                    Icons.search,
                                    color: ColorCodes.blackColor,
                                    size: 25
                                ),
                                SizedBox(width: 5),
                                Text(
                                  S.current.search_store_prouct,
                                  //" Search From 10,000+ products",
                                  style: TextStyle(
                                    color: ColorCodes.grey,
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                //SizedBox(width: MediaQuery.of(context).size.width),

                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
          if (ResponsiveLayout.isSmallScreen(context)) Carousel(
              storedatabanner, storesdata),
          //if(Features.isCarousel) if (ResponsiveLayout.isSmallScreen(context)) CarouselSliderimage(storesdata),
          if(!Vx.isWeb)(storedatabanner != "") ? advertisemultivendor(
              storesdata, storedatabanner) : SizedBox.shrink(),

          loadHome(storedata),

          SizedBox(height: 60),

        ],
      );
    }
    else{
      auth.getuserProfile(onerror: () {
        HomeStoreScreenController(user: PrefUtils.prefs!.getString("apikey") ?? PrefUtils.prefs!.getString("ftokenid"),  lat: (VxState.store as GroceStore).userData.latitude??PrefUtils.prefs!.getString("latitude"),
            long: (VxState.store as GroceStore).userData.longitude??PrefUtils.prefs!.getString("longitude") );
        if(widget.fromScreen == "Category"){
          CategoryStoreScreenController(id: widget.storeid.toString(),
              lat: (VxState.store as GroceStore).userData.latitude??PrefUtils.prefs!.getString("latitude"),
              long: (VxState.store as GroceStore).userData.longitude??PrefUtils.prefs!.getString("longitude"));
        }
        else if(widget.viewall == "near_stores"){
          futureproducts =  viewStores.getData(ViewStoreOf.nearby_store,
              status: (onloadcompleate){
                setState(() {
                  CategoryStoreScreenController(id: widget.storeid.toString(),
                      lat: (VxState.store as GroceStore).userData.latitude??PrefUtils.prefs!.getString("latitude"),
                      long: (VxState.store as GroceStore).userData.longitude??PrefUtils.prefs!.getString("longitude"));
                  _isLoading = !onloadcompleate;

                  //title =  (VxState.store as GroceStore).homescreen.data!.featuredByCart!.label;
                });
              });
        }
      }, onsucsess: (value) {
        HomeStoreScreenController(user: PrefUtils.prefs!.getString("apikey") ?? PrefUtils.prefs!.getString("ftokenid"),  lat: (VxState.store as GroceStore).userData.latitude??PrefUtils.prefs!.getString("latitude"),
            long: (VxState.store as GroceStore).userData.longitude??PrefUtils.prefs!.getString("longitude") );
        if(widget.fromScreen == "Category"){
          CategoryStoreScreenController(id: widget.storeid.toString(),
              lat: (VxState.store as GroceStore).userData.latitude??PrefUtils.prefs!.getString("latitude"),
              long: (VxState.store as GroceStore).userData.longitude??PrefUtils.prefs!.getString("longitude"));
        }
        else if(widget.viewall == "near_stores"){
          futureproducts =  viewStores.getData(ViewStoreOf.nearby_store,
              status: (onloadcompleate){
                setState(() {
                  CategoryStoreScreenController(id: widget.storeid.toString(),
                      lat: (VxState.store as GroceStore).userData.latitude??PrefUtils.prefs!.getString("latitude"),
                      long: (VxState.store as GroceStore).userData.longitude??PrefUtils.prefs!.getString("longitude"));
                  _isLoading = !onloadcompleate;

                  //title =  (VxState.store as GroceStore).homescreen.data!.featuredByCart!.label;
                });
              });
        }
      });
      return HomeScreenShimmer();
    }
  }

  Widget loadHome(StoreData storedata){
    double deviceWidth = MediaQuery.of(context).size.width;
    int widgetsInRow = 1;
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    double wid= queryData.size.width;
    double maxwid=wid*0.90;
    if (deviceWidth > 1200) {
      widgetsInRow = 5;
    } else if (deviceWidth > 768) {
      widgetsInRow = 3;
    }
    // double aspectRatio = (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 160;
    double aspectRatio =   (_isWeb && !ResponsiveLayout.isSmallScreen(context))?
    (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 372:
    (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 115;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(!Vx.isWeb)
          widget.viewall == "near_stores" || widget.viewall == "stores"?
          FutureBuilder<StoreData> (
            future: futureproducts,
            builder: (BuildContext context, AsyncSnapshot<StoreData> snapshot){
              final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
              final seeallpress = widget.viewall;
              switch(snapshot.connectionState){

                case ConnectionState.none:
                  return SizedBox.shrink();
                  // TODO: Handle this case.
                  break;
                case ConnectionState.waiting:
                  return (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
                      ? ItemListShimmerWeb()
                      : ItemListShimmer();
              // TODO: Handle this case.
                default:
                //print("selling.."+snapshot.data!.data!.length.toString());
                  if(snapshot.data!=null)
                    return
                      Padding(
                        padding: const EdgeInsets.only(bottom:50.0,top: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if(snapshot.data!.data!.length>0)
                            Container(
                              padding: EdgeInsets.only(left: 15, right: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    S.of(context).all_shop_nearby,//"All Shops Nearby",//"Categories",
                                    style: TextStyle(
                                        fontSize: ResponsiveLayout.isSmallScreen(context)
                                            ? 20.0
                                            : 24.0,
                                        color: ColorCodes.blackColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5,),
                                  Text(
                                    S.of(context).nearby_shop,//"Nearby Stores",//"Eat what makes you happy",
                                    style: TextStyle(
                                        fontSize: ResponsiveLayout.isSmallScreen(context)
                                            ? 15.0
                                            : 16.0,
                                        color: ColorCodes.grey,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            if(snapshot.data!.data!.length>0)
                            SizedBox(height: 10,),
                            GridView.builder(
                              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: widgetsInRow,
                                  crossAxisSpacing: 4,
                                  childAspectRatio: aspectRatio

                              ),
                              shrinkWrap: true,
                              controller: new ScrollController(keepScrollOffset: false),
                              itemCount: snapshot.data!.data!.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (_, i) =>
                                  Column(
                                    children: [
                                      NearShop(fromScreen: "storescreen",stores:  snapshot.data!.data![i],),
                                      //NearShop("storescreen",store.homestore.data!.nearestStores![i],store.storedata.data![i])
                                    ],
                                  ),
                            ),
                          ],
                        ),
                      );
                  else
                    return SizedBox.shrink();
              }

            },
          ):
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom:10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if(storedata.data!.length>0)
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).all_shop_nearby,//"All Shops Nearby",//"Categories",
                        style: TextStyle(
                            fontSize: ResponsiveLayout.isSmallScreen(context)
                                ? 20.0
                                : 24.0,
                            color: ColorCodes.blackColor,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5,),
                      Text(
                        S.of(context).nearby_shop,//"Nearby Stores",//"Eat what makes you happy",
                        style: TextStyle(
                            fontSize: ResponsiveLayout.isSmallScreen(context)
                                ? 15.0
                                : 16.0,
                            color: ColorCodes.grey,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                if(storedata.data!.length>0)
                SizedBox(height: 10,),
                GridView.builder(
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: widgetsInRow,
                      crossAxisSpacing: 4,
                      childAspectRatio: aspectRatio

                  ),
                  shrinkWrap: true,
                  controller: new ScrollController(keepScrollOffset: false),
                  itemCount: storedata.data!.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (_, i) =>
                      Column(
                        children: [
                          NearShop(fromScreen: "storescreen",stores:storedata.data![i],),
                          //NearShop("storescreen",store.homestore.data!.nearestStores![i],store.storedata.data![i])
                        ],
                      ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget Carousel(StoreOfferbanner storeoffbanner, Home_Store storehomedata){
    return Container(
      padding: EdgeInsets.only(left: 15, right: 10),
      child: CarouselSliderStoreimage(fromScreen: "StoreHome",storeofferbanner: storeoffbanner,)
     // CarouselSliderStoreimage("StoreHome",storehomedata,storeoffbanner),
    );
  }

  Widget advertisemultivendor(Home_Store homedata,StoreOfferbanner? storeoffbanner) {
    return (storeoffbanner!.data!.offerBanner!.length > 0) ? Container(
      padding: EdgeInsets.only(left: 10),
      child: Row(
        children: <Widget>[
          Expanded(
              child: SizedBox(
                height: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?350:110.0,
                child: new ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.all(0.0),
                  itemCount: storeoffbanner.data!.offerBanner!.length,
                  itemBuilder: (_, i) =>
                      Column(
                        children: [
                          AdvertiseMultivendorItems(isvertical: 'horizontal',
                          fromScreen: "storeHome",
                          storeofferbanner: storeoffbanner.data!.offerBanner![i],
                        ),
                        ],
                      ),
                ),
              )),
        ],
      ),
    ) : SizedBox.shrink();
  }

  gradientappbarmobile() {
    return  AppBar(
      brightness: Brightness.dark,
      toolbarHeight: 60.0,

      elevation: (IConstants.isEnterprise)?0:1,
      automaticallyImplyLeading: false,
      leading: IconButton(
          icon: Icon(Icons.arrow_back, color:IConstants.isEnterprise && !Features.ismultivendor?IConstants.isEnterprise && !Features.isWebTrail?ColorCodes.menuColor:ColorCodes.iconColor:ColorCodes.iconColor),
          onPressed: () async {

            Navigation(context, navigatore: NavigatoreTyp.homenav);

            return Future.value(false);
          }

      ),
      titleSpacing: 0,
      /*title: Text( S .of(context).wallet,
        style: TextStyle(color: IConstants.isEnterprise && !Features.ismultivendor?IConstants.isEnterprise && !Features.isWebTrail?ColorCodes.menuColor:ColorCodes.iconColor:ColorCodes.iconColor),),*/
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  IConstants.isEnterprise && !Features.ismultivendor?
                  IConstants.isEnterprise && !Features.isWebTrail?ColorCodes.accentColor:ColorCodes.appbarColor:ColorCodes.appbarColor,
                  IConstants.isEnterprise && !Features.ismultivendor?
                  IConstants.isEnterprise && !Features.isWebTrail?ColorCodes.primaryColor:ColorCodes.appbarColor:ColorCodes.appbarColor
                  /*   ColorCodes.accentColor,
                    ColorCodes.primaryColor*/
                ]
            )
        ),
      ),
    );
  }
}
