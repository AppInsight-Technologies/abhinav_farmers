import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../assets/ColorCodes.dart';
import '../../assets/images.dart';
import '../../constants/IConstants.dart';
import '../../constants/features.dart';
import '../../controller/mutations/address_mutation.dart';
import '../../controller/mutations/home_store_mutation.dart';
import '../../generated/l10n.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/home_page_modle.dart';
import '../../models/newmodle/home_store_modle.dart';
import '../../providers/advertise1items.dart';
import '../../providers/sellingitems.dart';
import '../../repository/authenticate/AuthRepo.dart';
import '../../rought_genrator.dart';
import '../../utils/ResponsiveLayout.dart';
import '../../utils/prefUtils.dart';
import '../../widgets/MultivendorOffersWidget.dart';
import '../../widgets/advertisemultivendor_items.dart';
import '../../widgets/StoreBottomNavigationWidget.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/carousel_slider_store.dart';
import '../../widgets/categoryOnemultivendor.dart';
import '../../widgets/footer.dart';
import '../../widgets/header.dart';
import '../../widgets/nearby_shop.dart';
import '../../widgets/simmers/home_screen_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../providers/branditems.dart';
import 'map_screen.dart';

class StoreScreen extends StatefulWidget {
  static const routeName = '/store-screen';
  const StoreScreen({Key? key}) : super(key: key);
  static  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> with Navigations {
  bool _isDelivering = true;
  bool iphonex = false;
  bool _isinternet = true;
  Future<OfferByCart>?  futureproducts ;
  String? title;
  bool _isWeb =false;
  final storedata = (VxState.store as GroceStore).homestore;
  DateTime? currentBackPressTime;

  @override
  void initState() {
    // TODO: implement initState
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
    });
  }
  Future<void> _refreshProducts(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {_isinternet = true;});
    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {_isinternet = true;});
    } else {
      Fluttertoast.showToast(
        msg: "No internet connection!!!", fontSize: MediaQuery
          .of(context)
          .textScaleFactor * 13,);
      setState(() {
        _isinternet = false;
      });
    }
    auth.getuserProfile(onsucsess: (value){
      HomeStoreScreenController(user: PrefUtils.prefs!.getString("apikey") ?? PrefUtils.prefs!.getString("ftokenid"),  lat: (VxState.store as GroceStore).userData.latitude??PrefUtils.prefs!.getString("latitude"),
          long: (VxState.store as GroceStore).userData.longitude??PrefUtils.prefs!.getString("longitude"));
    }, onerror: (){
    });
  }

  Widget Carousel(Home_Store storedata){
    return Container(
      padding: EdgeInsets.only(left: 15, right: 10),
      child: CarouselSliderStoreimage(fromScreen: "StoreScreen",homedata: storedata,),
    );
  }
  Widget Category(Home_Store storedata){
    return
      Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Column(
        children: [
          (storedata.data!.featuredCategoryTags!.length>0)?
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    storedata.data!.maincategoryTagsLabel!,//"Categories",
                    style: TextStyle(
                        fontSize: ResponsiveLayout.isSmallScreen(context)
                            ? 20.0
                            : 24.0,
                        color: ColorCodes.blackColor,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    storedata.data!.maincategoryTagssubLabel!,//"Eat what makes you happy",
                    style: TextStyle(
                        fontSize: ResponsiveLayout.isSmallScreen(context)
                            ? 15.0
                            : 16.0,
                        color: ColorCodes.grey,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Spacer(),
              if(Features.view_all)
                Text(
                  S.of(context).view_all, //'View All',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: ColorCodes.discount),
                ),
            ],
          ):SizedBox.shrink(),
          SizedBox(height: 10,),
          (storedata.data!.featuredTagsBanner!.length>0)?
          MouseRegion(
            cursor: MouseCursor.uncontrolled,
            child: SizedBox(
              height: 105,
              child: ListView.builder(
                  shrinkWrap: true,
                  controller: new ScrollController(keepScrollOffset: false),
                  itemCount: storedata.data!.featuredTagsBanner!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, i) =>
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            if (storedata.data!.featuredTagsBanner![i].bannerFor == "8") {
                              String prevbranch = PrefUtils.prefs!.getString("branch")!;
                              PrefUtils.prefs!.setString("prevbranch", prevbranch);
                              PrefUtils.prefs!.setString("branch",storedata.data!.featuredTagsBanner![i].stores!.toString());
                              GroceStore store = VxState.store;
                              store.homescreen.data = null;
                              IConstants.storename = storedata.data!.featuredTagsBanner![i].title.toString();
                              Navigation(context,name: Routename.Home,navigatore: NavigatoreTyp.Push,
                              );
                              BrandItemsList().GetRestaurantNew(PrefUtils.prefs!.getString("branch")!,()async {
                              });
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 5),
                            child:  Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  //padding: const EdgeInsets.only(left:20.0,right: 5.0,top: 5.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl: storedata.data!.featuredTagsBanner![i].bannerImage,
                                      placeholder: (context, url) =>    Shimmer.fromColors(
                                          baseColor: /*Color(0xffd3d3d3)*/ColorCodes.shimmerColor,
                                          highlightColor: /*Color(0xffeeeeee)*/ColorCodes.shimmerColor,
                                          child: Image.asset(Images.defaultCategoryImg))/*_horizontalshimmerslider()*/,
                                      errorWidget: (context, url, error) => Image.asset(Images.defaultCategoryImg),
                                      height: ResponsiveLayout.isSmallScreen(context)?105:120,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                ),
                              ],
                            ) ,
                            // )
                          ),
                        ),
                      )
              ),
            ),
          ): SizedBox.shrink(),
          (storedata.data!.featuredCategoryTags!.length>0)?
          CategoryOneMultiVendor(
              storedata):  SizedBox.shrink(),

        ],
      ),
    );
  }



  Widget loadhomeScreen() {
    final storedata = (VxState.store as GroceStore).homestore;

    if (storedata.data != null)
      return SingleChildScrollView(
          child: _isinternet
              ?
          VxBuilder(
              mutations: {SetPrimeryLocation},
              builder: (context, value, widget) {
                bool? deliverystatus = PrefUtils.prefs!.getBool("deliverystatus"); /*value.userData.delevrystatus??*/
                return !deliverystatus!?
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
                                S.of(context)
                                    .sorry_wedidnt_deliever +
                                    // "Sorry, we don't deliver in " +
                                    value.userData.area.toString()),
                          GestureDetector(
                            onTap: () {
                              PrefUtils.prefs!.setString(
                                  "formapscreen", "homescreen");
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
                                color: Theme
                                    .of(context)
                                    .accentColor,
                                borderRadius:
                                BorderRadius.circular(3.0),
                              ),
                              child: Center(
                                  child: Text(
                                    S
                                        .of(context)
                                        .change_location,
                                    //'Change Location',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white),
                                  )),
                            ),
                          ),
                          if (Vx.isWeb)Footer(
                            address: PrefUtils.prefs!.getString("restaurant_address")!,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                    :
                _isDelivering
                    ? storedata != null ?
                Column(
                    children: <Widget>[
                       Carousel(storedata),
                      SizedBox(height: 15,),
                      Category(storedata),
                      SizedBox(height: 20,),
                      _featuredItemMobile(storedata),
                      SizedBox(height: 15,),
                      advertisemultivendor(storedata),
                      SizedBox(height: 15,),
                      _allShopsNearBy(storedata)
                    ]
                )
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
                              S
                                  .of(context)
                                  .sorry_wedidnt_deliever +
                                  // "Sorry, we don't deliver in " +
                                  PrefUtils.prefs!.getString(
                                      "deliverylocation")!),
                          GestureDetector(
                            onTap: () {
                              PrefUtils.prefs!.setString(
                                  "formapscreen", "homescreen");
                              /* Navigator.of(context)
                                  .pushNamed(MapScreen.routeName);*/
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
                                color: Theme
                                    .of(context)
                                    .accentColor,
                                borderRadius:
                                BorderRadius.circular(3.0),
                              ),
                              child: Center(
                                  child: Text(
                                    S
                                        .of(context)
                                        .change_location,
                                    //'Change Location',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white),
                                  )),
                            ),
                          ),
                          if (Vx.isWeb)Footer(
                            address: PrefUtils.prefs!.getString(
                                "restaurant_address")!,
                          ),
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
                        S.of(context)
                            .sorry_wedidnt_deliever +
                            // "Sorry, we don't deliver in " +
                            PrefUtils.prefs!.getString(
                                "deliverylocation")!),
                    GestureDetector(
                      onTap: () {
                        PrefUtils.prefs!.setString(
                            "formapscreen", "homescreen");
                        /*Navigator.of(context)
                            .pushNamed(MapScreen.routeName);*/
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
                          color: Theme
                              .of(context)
                              .accentColor,
                          borderRadius:
                          BorderRadius.circular(3.0),
                        ),
                        child: Center(
                            child: Text(
                              S
                                  .of(context)
                                  .change_location, //'Change Location',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    ),
                    if (Vx.isWeb)Footer(
                      address: PrefUtils.prefs!.getString(
                          "restaurant_address")!,
                    ),
                  ],
                ),
              ),
            ),
          )

      );
    else {
      auth.getuserProfile(onsucsess: (value){
        HomeStoreScreenController(user: PrefUtils.prefs!.getString("apikey") ?? PrefUtils.prefs!.getString("ftokenid"),  lat: (VxState.store as GroceStore).userData.latitude??PrefUtils.prefs!.getString("latitude"),
            long: (VxState.store as GroceStore).userData.longitude??PrefUtils.prefs!.getString("longitude") );
      }, onerror: (){
      });
     // HomeStoreScreenController(user: PrefUtils.prefs!.getString("apikey") ?? PrefUtils.prefs!.getString("ftokenid"), lat: (VxState.store as GroceStore).userData.latitude,long: (VxState.store as GroceStore).userData.longitude );

      return (kIsWeb && !ResponsiveLayout.isSmallScreen(context))
          ? HomeScreenShimmer()
          : HomeScreenShimmer();
    }
  }



  // Widget loadhomeScreen() {
  //   double deviceWidth = MediaQuery.of(context).size.width;
  //   int widgetsInRow = 1;
  //   MediaQueryData queryData;
  //   queryData = MediaQuery.of(context);
  //   double wid= queryData.size.width;
  //   double maxwid=wid*0.90;
  //   if (deviceWidth > 1200) {
  //     widgetsInRow = 5;
  //   } else if (deviceWidth > 768) {
  //     widgetsInRow = 3;
  //   }
  //   // double aspectRatio = (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 160;
  //   double aspectRatio =   (_isWeb && !ResponsiveLayout.isSmallScreen(context))?
  //   (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 372:
  //   (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 115;
  //   final storedata = (VxState.store as GroceStore).homestore;
  //     return
  //       Column(
  //         children: <Widget>[
  //           Carousel(storedata),
  //           SizedBox(height: 15,),
  //           Category(),
  //           SizedBox(height: 15,),
  //           //_featuredItemMobile(storedata),
  //           SizedBox(height: 15,),
  //           // Align(
  //           //   alignment: Alignment.center,
  //           //   child: Container(
  //           //     child:
  //           //     FutureBuilder<OfferByCart> (
  //           //       future: futureproducts,
  //           //       builder: (BuildContext context, AsyncSnapshot<OfferByCart> snapshot){
  //           //         final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  //           //         final seeallpress = "featured";
  //           //         switch(snapshot.connectionState){
  //           //
  //           //           case ConnectionState.none:
  //           //             return SizedBox.shrink();
  //           //             // TODO: Handle this case.
  //           //             break;
  //           //           case ConnectionState.waiting:
  //           //             return (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
  //           //                 ? ItemListShimmerWeb()
  //           //                 : ItemListShimmer();
  //           //         // TODO: Handle this case.
  //           //           default:
  //           //
  //           //             if(snapshot.data!=null)
  //           //               return
  //           //                 Column(
  //           //                     children:[
  //           //                       Row(
  //           //                         children: <Widget>[
  //           //                           SizedBox(
  //           //                             width: 10.0,
  //           //                           ),
  //           //                           Text(
  //           //                             S.of(context).all_shop_nearby,
  //           //                             style: TextStyle(
  //           //                                 fontSize: ResponsiveLayout.isSmallScreen(context)
  //           //                                     ? 20.0
  //           //                                     : 23.0,
  //           //                                 color: ColorCodes.blackColor,
  //           //                                 fontWeight: FontWeight.bold),
  //           //                           ),
  //           //                           /*Spacer(),
  //           //                      MouseRegion(
  //           //                        cursor: SystemMouseCursors.click,
  //           //                        child: GestureDetector(
  //           //                          onTap: () {
  //           //                            *//*    Navigator.of(context)
  //           //               .pushNamed(SellingitemScreen.routeName, arguments: {
  //           //             'seeallpress': "featured",
  //           //             'title': storedata.data!.featuredByCart!.label,
  //           //           });*//*
  //           //                            Navigation(context, name: Routename.SellingItem, navigatore: NavigatoreTyp.Push,
  //           //                                parms: {"seeallpress": "featured",});
  //           //                          },
  //           //                          child: Text(
  //           //                            S
  //           //                                .of(context)
  //           //                                .view_all, //'View All',
  //           //                            textAlign: TextAlign.center,
  //           //                            style: TextStyle(
  //           //                                fontWeight: FontWeight.bold,
  //           //                                fontSize: 14,
  //           //                                color: Theme
  //           //                                    .of(context)
  //           //                                    .primaryColor),
  //           //                          ),
  //           //                        ),
  //           //                      ),
  //           //                      SizedBox(
  //           //                        width: 10,
  //           //                      ),*/
  //           //                         ],
  //           //                       ),
  //           //                       SizedBox(height: 8.0),
  //           //                       GridView.builder(
  //           //                           shrinkWrap: true,
  //           //                           itemCount:snapshot.data!.data!.length,
  //           //                           controller: new ScrollController(keepScrollOffset: false),
  //           //                           gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
  //           //                             /*crossAxisCount: 2,
  //           //                       childAspectRatio: 0.55,
  //           //                       crossAxisSpacing: 3,
  //           //                       mainAxisSpacing: 3,*/
  //           //                             crossAxisCount: widgetsInRow,
  //           //                             crossAxisSpacing: 3,
  //           //                             childAspectRatio: aspectRatio,
  //           //                             mainAxisSpacing: 3,
  //           //                           ),
  //           //                           itemBuilder: (BuildContext context, int index) {
  //           //                             return NearShop("sellingitem_screen","featured".toString(), snapshot.data!.data![index],"");
  //           //                             /* return SellingItems(
  //           //                      "sellingitem_screen",
  //           //                      snapshot.data.data[index].id,
  //           //                      snapshot.data.data[index].title,
  //           //                      snapshot.data.data[index].imageUrl,
  //           //                      snapshot.data.data[index].brand,
  //           //                      "",
  //           //                      snapshot.data.data[index].veg_type,
  //           //                      snapshot.data.data[index].type,
  //           //                      snapshot.data.data[index].eligible_for_express,
  //           //                      snapshot.data.data[index].delivery,
  //           //                      snapshot.data.data[index].duration,
  //           //                      snapshot.data.data[index].durationType,
  //           //                      snapshot.data.data[index].note,
  //           //                      snapshot.data.data[index].subscribe,
  //           //                      snapshot.data.data[index].paymentmode,
  //           //                      snapshot.data.data[index].cronTime,
  //           //                      snapshot.data.data[index].name,
  //           //
  //           //                    );*/
  //           //                           }),
  //           //                     ]
  //           //
  //           //                 );
  //           //             else
  //           //               return SizedBox.shrink();
  //           //         }
  //           //
  //           //       },
  //           //     ),
  //           //   ),
  //           //
  //           // ),
  //
  //           ]
  //     );
  //
  // }


  Widget advertisemultivendor(Home_Store homedata) {
    /* return StreamBuilder(
      stream: bloc.featuredAdsOne,
      builder: (context, AsyncSnapshot<List<BrandsFields>> snapshot) {*/

    /*  if (snapshot.hasData) {
          if (snapshot.data.isNotEmpty) {*/
    if (homedata.data!.featuredCategories1!.length > 0) {
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
          80;
      return GridView.builder(

        //scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widgetsInRow,
          crossAxisSpacing: 3,
          childAspectRatio: aspectRatio,

        ),
        shrinkWrap: true,
        controller: new ScrollController(keepScrollOffset: false),
        itemCount: homedata.data!.featuredCategories1!.length,
        itemBuilder: (_, i) =>
            AdvertiseMultivendorItems(
              isvertical: 'home',
              fromScreen: "store",
              allbanners: homedata.data!.featuredCategories1![i],
             /* "horizontal",
              "storeScreen",
              homedata.data!.featuredCategories1![i],*/
            ),
      );
    } else {
      return /*_sliderShimmer()*/SizedBox.shrink();
    }

  }

  _allShopsNearBy(Home_Store storedata){
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
    (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 120;
    final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);
      if(storedata.data!.nearestStores!.length > 0)
        return Container(
          padding: EdgeInsets.only(right: 15.0, left: 15.0,bottom: 60),
          color: /*Color(0xFFFFE8E8).withOpacity(0.7)*/Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                       S.of(context).all_shop_nearby,// "All Shops Nearby",
                        style: TextStyle(
                            fontSize: ResponsiveLayout.isSmallScreen(context)
                                ? 20.0
                                : 24.0,
                            color: ColorCodes.blackColor,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5,),
                      Text(
                        storedata.data!.featuredStoreLabelsub!,//"Big Savings on your Loved Eateries",
                        style: TextStyle(
                            fontSize: ResponsiveLayout.isSmallScreen(context)
                                ? 15.0
                                : 16.0,
                            color: ColorCodes.grey,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Spacer(),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        Navigation(context, name: Routename.StoreHome,
                            navigatore: NavigatoreTyp.Push,
                            qparms: {
                              "view_all":"near_stores"
                            });
                      },
                      child: Text(
                        S
                            .of(context)
                            .view_all, //'View All',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: ColorCodes.discount),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              SizedBox(height: 10.0),
                                    GridView.builder(
                                        shrinkWrap: true,
                                        itemCount:storedata.data!.nearestStores!.length,
                                        controller: new ScrollController(keepScrollOffset: false),
                                        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: widgetsInRow,
                                          crossAxisSpacing: 3,
                                          childAspectRatio: aspectRatio,
                                          mainAxisSpacing: 3,
                                        ),
                                        itemBuilder: (BuildContext context, int index) {
                                          return   NearShop(fromScreen: "homescreen",storedata: storedata.data!.nearestStores![index],);

                                            //NearShop("homescreen", storedata.data!.nearestStores![index],);

                                        }),

            ],
          ),
        );
      else return SizedBox.shrink();
  }
  _featuredItemMobile(Home_Store storedata) {
    if(storedata.data!.featuredStores!.length > 0)
      return Container(
        padding: EdgeInsets.only(right: 15.0, left: 15.0),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      storedata.data!.featuredStoreLabel!,
                      style: TextStyle(
                          fontSize: ResponsiveLayout.isSmallScreen(context) ? 20.0 : 24.0,
                          color: ColorCodes.blackColor,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      storedata.data!.featuredStoreLabelsub!,//"Big Savings on your Loved Eateries",
                      style: TextStyle(
                          fontSize: ResponsiveLayout.isSmallScreen(context) ? 15.0 : 16.0,
                          color: ColorCodes.grey,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Spacer(),
                if(Features.view_all)
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        Navigation(context, name: Routename.StoreHome,
                            navigatore: NavigatoreTyp.Push,
                            qparms: {
                              "view_all":"stores"
                            });
                      },
                      child: Text(
                        S.of(context).view_all, //'View All',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: ColorCodes.discount
                        ),
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
                height: ResponsiveLayout.isSmallScreen(context) ? 200: 250,
                child: new ListView.builder(
                  padding: EdgeInsets.only(right: 10),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: storedata.data!.featuredStores!.length,
                  itemBuilder: (_, i) {
                    return Column(
                        children: [
                          MultivendorOffers(
                            "home_screen",
                            storedata.data!.featuredStores![i],
                          ),
                        ]
                    );
                  },
                )),
          ],
        ),
      );
    else return SizedBox.shrink();
  }

  Widget _body() {
    return SingleChildScrollView(
      child: VxBuilder(
        mutations: {HomeStoreScreenController},
        builder: (ctx, store, VxStatus? state) {
          if(VxStatus.success == state)
            return loadhomeScreen();
          else if(state == VxStatus.none){
            if((VxState.store as GroceStore).homestore.toJson().isEmpty) {
              auth.getuserProfile(onerror: () {
               HomeStoreScreenController(user: PrefUtils.prefs!.getString("apikey") ?? PrefUtils.prefs!.getString("ftokenid"),  lat: (VxState.store as GroceStore).userData.latitude??PrefUtils.prefs!.getString("latitude"),
                                long: (VxState.store as GroceStore).userData.longitude??PrefUtils.prefs!.getString("longitude") );
              }, onsucsess: (value) {
                HomeStoreScreenController(user: PrefUtils.prefs!.getString("apikey") ?? PrefUtils.prefs!.getString("ftokenid"),  lat: (VxState.store as GroceStore).userData.latitude??PrefUtils.prefs!.getString("latitude"),
                    long: (VxState.store as GroceStore).userData.longitude??PrefUtils.prefs!.getString("longitude") );
              });
              return HomeScreenShimmer();
            }else{
              return loadhomeScreen();
            }
          }
          return HomeScreenShimmer();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    final sliderData = Provider.of<Advertise1ItemsList>(context, listen: false);
    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
        return Future.value(true);
      },
      child: Scaffold(
        key: StoreScreen.scaffoldKey,
        drawer: ResponsiveLayout.isSmallScreen(context) ? AppDrawer() : SizedBox.shrink(),
        backgroundColor: Colors.white,
        body: SafeArea(bottom: true,
          child: Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Header(true),
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
            width: MediaQuery.of(context).size.width,
            child: StoreBottomNavigation()),
      ),
    );
  }
}
