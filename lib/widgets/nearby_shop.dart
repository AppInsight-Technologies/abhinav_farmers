import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocbay/assets/ColorCodes.dart';
import 'package:grocbay/assets/images.dart';
import 'package:grocbay/controller/mutations/home_screen_mutation.dart';
import 'package:grocbay/models/VxModels/VxStore.dart';
import 'package:grocbay/models/newmodle/home_page_modle.dart';
import 'package:grocbay/models/newmodle/home_store_modle.dart';
import 'package:grocbay/models/newmodle/product_data.dart';
import 'package:grocbay/models/newmodle/store_data.dart';
import 'package:grocbay/providers/branditems.dart';
import 'package:grocbay/utils/ResponsiveLayout.dart';
import 'package:grocbay/utils/prefUtils.dart';
import 'package:grocbay/widgets/productWidget/item_badge.dart';
import 'package:velocity_x/velocity_x.dart';

import '../constants/IConstants.dart';
import '../generated/l10n.dart';
import '../rought_genrator.dart';

class NearShop extends StatefulWidget {
  final NearestStores? storedata;
  Store_Data? stores;
  final String fromScreen;

  NearShop({Key? key,required this.fromScreen,this.storedata,this.stores}) : super(key: key);
 // NearShop(this._fromScreen,[this.storedata,this.stores]);

  @override
  State<NearShop> createState() => _NearShopState();
}

class _NearShopState extends State<NearShop> with Navigations{
  var _isLoading = true;

  bool _isWeb =false;

  MediaQueryData? queryData;
  int itemindex = 0;
  bool iphonex = false;

  bool _checkmembership = false;

  Future<OfferByCart>?  futureproducts ;

  String? title;

  @override
  Widget build(BuildContext context) {
    //print("offer text..."+widget.storedata!.offerText.toString());
    //print("offer text... from screen"+widget.fromScreen.toString());
    if(widget.fromScreen == "storescreen"){
      return  GestureDetector(
        onTap: () {
          String prevbranch = PrefUtils.prefs!.getString("branch")!;
          PrefUtils.prefs!.setString("prevbranch", prevbranch);
          print("store tap..."+prevbranch.toString()+"....."+PrefUtils.prefs!.getString("prevbranch")!);
          PrefUtils.prefs!.setString("branch",widget.stores!.id!.toString());
          GroceStore store = VxState.store;
          store.homescreen.data = null;
          IConstants.storename = widget.stores!.restaurantName.toString();
          Navigation(context,name: Routename.Home,navigatore: NavigatoreTyp.Push,
              qparms: {
                "title":widget.stores!.restaurantName.toString(),
                "distance":widget.stores!.distance!.toStringAsFixed(2),
                "restloc":widget.stores!.restaurantLocation!.toString(),
                "ratings":widget.stores!.ratings!.toStringAsFixed(2),
                "product_count":widget.stores!.menuItemCount.toString(),
              });
          BrandItemsList().GetRestaurantNew(PrefUtils.prefs!.getString("branch")!,()async {
            // PrimeryLocation().fetchPrimarylocation();
            /*HomeScreenController(user: PrefUtils.prefs!.getString("apikey") ??
                PrefUtils.prefs!.getString("tokenid"),
              branch: PrefUtils.prefs!.getString("branch") ?? "999",
              rows: "0",);*/

          });
        },
        child: Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          width: MediaQuery
              .of(context)
              .size
              .width,
          decoration: BoxDecoration(
            color: Colors.white,
            /*borderRadius: BorderRadius.circular(2),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[400]!,
                blurRadius: 10.0,
                offset: Offset(0.0, 0.50)),
          ],*/
            // border: Border.all(color: Color(0xFFCFCFCF)),
          ),
          margin: EdgeInsets.only(
              left: 5.0, top: 1.0, /*bottom: 5.0,*/ right: 5),
          child: Row(
            children: [
              Container(
                width: (MediaQuery
                    .of(context)
                    .size
                    .width / 2) - 70,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child:
                      GestureDetector(
                        child: Container(
                          // margin: EdgeInsets.only(top: 10.0, bottom: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            child: CachedNetworkImage(
                              imageUrl: widget.stores!.iconImage,
                              errorWidget: (context, url, error) =>
                                  Image.asset(
                                    Images.defaultProductImg,
                                    width: ResponsiveLayout.isSmallScreen(
                                        context) ? 120 : ResponsiveLayout
                                        .isMediumScreen(context) ? 120 : 120,
                                    height: ResponsiveLayout.isSmallScreen(
                                        context) ? 111 : ResponsiveLayout
                                        .isMediumScreen(context) ? 111 : 111,
                                  ),
                              placeholder: (context, url) =>
                                  Image.asset(
                                    Images.defaultProductImg,
                                    width: ResponsiveLayout.isSmallScreen(
                                        context) ? 120 : ResponsiveLayout
                                        .isMediumScreen(context) ? 120 : 120,
                                    height: ResponsiveLayout.isSmallScreen(
                                        context) ? 111 : ResponsiveLayout
                                        .isMediumScreen(context) ? 111 : 111,
                                  ),
                              width: ResponsiveLayout.isSmallScreen(context)
                                  ? 120
                                  : ResponsiveLayout.isMediumScreen(context)
                                  ? 120
                                  : 120,
                              height: ResponsiveLayout.isSmallScreen(context)
                                  ? 111
                                  : ResponsiveLayout.isMediumScreen(context)
                                  ? 111
                                  : 111,
                              //  fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              Container(
                width: (MediaQuery
                    .of(context)
                    .size
                    .width / 2) + 25,
                margin: EdgeInsets.only(left: 5.0, top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              widget.stores!.restaurantName!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: ResponsiveLayout.isSmallScreen(
                                      context)
                                      ? 17.0
                                      : 20.0,
                                  color: ColorCodes.blackColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              widget.stores!.restaurantLocation!,
                              style: TextStyle(
                                  fontSize: 11, color: ColorCodes.greyColord),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 7,
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Image.asset(Images.starimg,
                              height: 12,
                              width: 12,
                              color: ColorCodes.darkthemeColor),
                          SizedBox(width: 3,),
                          Text(
                            widget.stores!.ratings!.toStringAsFixed(2),
                            style: TextStyle(
                                fontSize: 11,
                                color: ColorCodes.darkthemeColor),
                          ),
                          SizedBox(width: 15,),
                          Icon(Icons.info, color: ColorCodes.lightGreyColor, size: 6),
                          SizedBox(width: 15,),
                          Text(
                            widget.stores!.distance!.toStringAsFixed(2) +
                                /*" Km"*/S.of(context).km,
                            style: TextStyle(
                                fontSize: 11, color: ColorCodes.greyColord),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 7,
                    ),
                    // Container(
                    //   child: Row(
                    //     children: <Widget>[
                    //       Image.asset(Images.starimg,
                    //           height: 13,
                    //           width: 13,
                    //           color: ColorCodes.darkthemeColor),
                    //       SizedBox(width: 3,),
                    //       Text(
                    //         widget.stores!.ratings!.toStringAsFixed(2),
                    //         style: TextStyle(
                    //             fontSize: 12,
                    //             color: ColorCodes.darkthemeColor),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(height: 7,),
                    (widget.stores!.offerText.toString() == "" ||
                        widget.stores!.offerText.toString() == "null") ?
                    SizedBox.shrink() :
                    Container(
                      //height:30,
                      child: Row(
                        children: [
                          Image.asset(
                            Images.home_offer,
                            height: 16,
                            width: 16,
                            color: ColorCodes.darkthemeColor,
                          ),
                          SizedBox(width: 3),
                          Text(
                              widget.stores!.offerText!,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: ColorCodes.darkthemeColor,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                    )


                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    else {
      return
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            String prevbranch = PrefUtils.prefs!.getString("branch")!;
            PrefUtils.prefs!.setString("prevbranch", prevbranch);
            print("store tap..."+prevbranch.toString()+"....."+PrefUtils.prefs!.getString("prevbranch")!);
            PrefUtils.prefs!.setString("branch",widget.storedata!.id!.toString());
            GroceStore store = VxState.store;
            store.homescreen.data = null;
            IConstants.storename = widget.storedata!.restaurantName.toString();
            Navigation(context,name: Routename.Home,navigatore: NavigatoreTyp.Push,
                qparms: {
                  "title":widget.storedata!.restaurantName.toString(),
                  "distance":widget.storedata!.distance!.toStringAsFixed(2),
                  "restloc":widget.storedata!.restaurantLocation!.toString(),
                  "ratings":widget.storedata!.ratings!.toStringAsFixed(2),
                  "product_count":widget.storedata!.menuItemCount.toString(),
                });

            BrandItemsList().GetRestaurantNew(PrefUtils.prefs!.getString("branch")!,()async {
              // PrimeryLocation().fetchPrimarylocation();

             /* HomeScreenController(user: PrefUtils.prefs!.getString("apikey") ??
                  PrefUtils.prefs!.getString("tokenid"),
                branch: PrefUtils.prefs!.getString("branch") ?? "999",
                rows: "0",);*/
            });
          },
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            decoration: BoxDecoration(
              color: Colors.white,
              /*borderRadius: BorderRadius.circular(2),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[400]!,
                blurRadius: 10.0,
                offset: Offset(0.0, 0.50)),
          ],*/
              // border: Border.all(color: Color(0xFFCFCFCF)),
            ),
            margin: EdgeInsets.only(
                left: 5.0, top: 1.0, /*bottom: 5.0,*/ right: 0),
            child: Row(
              children: [
                Container(
                  width: (MediaQuery
                      .of(context)
                      .size
                      .width / 2) - 70,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child:
                        Container(
                          // margin: EdgeInsets.only(top: 10.0, bottom: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            child: CachedNetworkImage(
                              imageUrl: widget.storedata!.iconImage,
                              errorWidget: (context, url, error) =>
                                  Image.asset(
                                    Images.defaultProductImg,
                                    width: ResponsiveLayout.isSmallScreen(
                                        context) ? 120 : ResponsiveLayout
                                        .isMediumScreen(context) ? 120 : 120,
                                    height: ResponsiveLayout.isSmallScreen(
                                        context) ? 111 : ResponsiveLayout
                                        .isMediumScreen(context) ? 111 : 111,
                                  ),
                              placeholder: (context, url) =>
                                  Image.asset(
                                    Images.defaultProductImg,
                                    width: ResponsiveLayout.isSmallScreen(
                                        context) ? 120 : ResponsiveLayout
                                        .isMediumScreen(context) ? 120 : 120,
                                    height: ResponsiveLayout.isSmallScreen(
                                        context) ? 111 : ResponsiveLayout
                                        .isMediumScreen(context) ? 111 : 111,
                                  ),
                              width: ResponsiveLayout.isSmallScreen(context)
                                  ? 120
                                  : ResponsiveLayout.isMediumScreen(context)
                                  ? 120
                                  : 120,
                              height: ResponsiveLayout.isSmallScreen(context)
                                  ? 111
                                  : ResponsiveLayout.isMediumScreen(context)
                                  ? 111
                                  : 111,
                              //  fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                Container(
                  width: (MediaQuery
                      .of(context)
                      .size
                      .width / 2) + 25,
                  margin: EdgeInsets.only(left: 5.0, top: 5),
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                widget.storedata!.restaurantName!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: ResponsiveLayout.isSmallScreen(
                                        context)
                                        ? 17.0
                                        : 20.0,
                                    color: ColorCodes.blackColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                widget.storedata!.restaurantLocation!,
                                style: TextStyle(
                                    fontSize: 11, color: ColorCodes.greyColord),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 7,
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Image.asset(Images.starimg,
                                height: 12,
                                width: 12,
                                color: ColorCodes.darkthemeColor),
                            SizedBox(width: 3,),
                            Text(
                              widget.storedata!.ratings!.toStringAsFixed(2),
                              style: TextStyle(
                                  fontSize: 11,
                                  color: ColorCodes.darkthemeColor),
                            ),
                            SizedBox(width: 15,),
                            Icon(Icons.info, color: ColorCodes.lightGreyColor, size: 6),
                            SizedBox(width: 15,),
                            Text(
                              widget.storedata!.distance!.toStringAsFixed(2) +
                                  /*" Km"*/S.of(context).km,
                              style: TextStyle(
                                  fontSize: 11, color: ColorCodes.greyColord),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      // Container(
                      //   child: Row(
                      //     children: <Widget>[
                      //       Image.asset(Images.starimg,
                      //           height: 12,
                      //           width: 12,
                      //           color: ColorCodes.darkthemeColor),
                      //       SizedBox(width: 3,),
                      //       Expanded(
                      //         child: Text(
                      //           widget.storedata!.ratings!.toStringAsFixed(2),
                      //           style: TextStyle(
                      //               fontSize: 11,
                      //               color: ColorCodes.darkthemeColor),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(height: 7,),
                      (widget.storedata!.offerText.toString() == "" ||
                          widget.storedata!.offerText.toString() == "null") ?
                      SizedBox.shrink() :
                      Container(
                        //height:30,
                        child: Row(
                          children: [
                            Image.asset(
                              Images.home_offer,
                              height: 16,
                              width: 16,
                              color: ColorCodes.darkthemeColor,
                            ),
                            SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                  widget.storedata!.offerText!,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: ColorCodes.darkthemeColor,
                                      fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                      )


                    ],
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }
}
