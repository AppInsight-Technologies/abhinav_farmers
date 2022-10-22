import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:grocbay/assets/ColorCodes.dart';
import 'package:grocbay/assets/images.dart';
import 'package:grocbay/constants/IConstants.dart';
import 'package:grocbay/constants/features.dart';
import 'package:grocbay/controller/mutations/home_screen_mutation.dart';
import 'package:grocbay/generated/l10n.dart';
import 'package:grocbay/models/newmodle/home_page_modle.dart';
import 'package:grocbay/models/newmodle/home_store_modle.dart';
import 'package:grocbay/models/newmodle/product_data.dart';
import 'package:grocbay/models/newmodle/user.dart';
import 'package:grocbay/providers/branditems.dart';
import 'package:grocbay/utils/ResponsiveLayout.dart';
import 'package:grocbay/utils/prefUtils.dart';
import 'package:velocity_x/velocity_x.dart';

import '../models/VxModels/VxStore.dart';
import '../rought_genrator.dart';
import 'flutter_flow/flutter_flow_theme.dart';

class MultivendorOffers extends StatefulWidget {
  final FeaturedStores homedata;
  final String _fromScreen;
  MultivendorOffers(this._fromScreen,this.homedata);


  @override
  _MultivendorOffersState createState() => _MultivendorOffersState();
}

class _MultivendorOffersState extends State<MultivendorOffers> with Navigations{
  var namesSplit;
  var joined;
  @override
  void initState() {
    // TODO: implement initState


    final input = widget.homedata.categoryData.toString();//'[name 1, name2, name3, ...]';
    final removedBrackets = input.substring(1, input.length - 1);
    final parts = removedBrackets.split(', ');
    joined = parts.map((part) => "$part").join(', ');

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        String prevbranch = PrefUtils.prefs!.getString("branch")!;
        PrefUtils.prefs!.setString("prevbranch", prevbranch);
        print("store tap..."+prevbranch.toString()+"....."+PrefUtils.prefs!.getString("prevbranch")!);
        PrefUtils.prefs!.setString("branch",widget.homedata.id!.toString());
        print("store tap...branch"+widget.homedata.id!.toString()+"....."+PrefUtils.prefs!.getString("branch")!);
        GroceStore store = VxState.store;
        store.homescreen.data = null;
        IConstants.storename = widget.homedata.restaurantName.toString();
        Navigation(context,name: Routename.Home,navigatore: NavigatoreTyp.Push,
            qparms: {
              "title":widget.homedata.restaurantName.toString(),
              "distance":widget.homedata.distance!.toStringAsFixed(2),
              "restloc":widget.homedata.restaurantLocation!.toString(),
              "ratings":widget.homedata.ratings!.toStringAsFixed(2),
              "product_count":widget.homedata.menuItemCount.toString(),
            });

        print("store tap...branch"+prevbranch.toString()+"....."+PrefUtils.prefs!.getString("branch")!);

        BrandItemsList().GetRestaurantNew(PrefUtils.prefs!.getString("branch")!,()async {
          // PrimeryLocation().fetchPrimarylocation();
         /* HomeScreenController(user: PrefUtils.prefs!.getString("apikey") ??
              PrefUtils.prefs!.getString("tokenid"),
            branch: PrefUtils.prefs!.getString("branch") ?? "999",
            rows: "0",);*/
        });

      },
      child: Container(
        width: 180,
        padding: const EdgeInsets.only(right: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           ClipRRect(
             borderRadius:BorderRadius.all(Radius.circular(10.0)),
             child: CachedNetworkImage(
               imageUrl: widget.homedata.bannerImage,
               errorWidget: (context, url, error) => Image.asset(
                 Images.defaultProductImg,
                 width: ResponsiveLayout.isSmallScreen(context) ? 165 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                 height: ResponsiveLayout.isSmallScreen(context) ? 120 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
               ),
               placeholder: (context, url) => Image.asset(
                 Images.defaultProductImg,
                 width: ResponsiveLayout.isSmallScreen(context) ? 165 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                 height: ResponsiveLayout.isSmallScreen(context) ? 120 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
               ),
               width: ResponsiveLayout.isSmallScreen(context) ? 165 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
               height: ResponsiveLayout.isSmallScreen(context) ? 120 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
               //  fit: BoxFit.fill,
             ),
           ),

            SizedBox(height: 5,),
            Text(widget.homedata.restaurantName.toString(),
                overflow: TextOverflow.visible,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: ResponsiveLayout.isSmallScreen(context)?19.0:18.0,
                  color: ColorCodes.blackColor,

                )),
            SizedBox(height: 5,),
            Text(
             joined.toString() /*widget.homedata.categoryData.toString()*/,//"Big Savings on your Loved Eateries",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: ResponsiveLayout.isSmallScreen(context)
                      ? 12.0
                      : 16.0,
                  color: ColorCodes.grey,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8,),
            Container(
              width: 150,
              child: Row(
                children: [
                  Image.asset(Images.starimg,
                  height: 15, width: 15,color: ColorCodes.darkthemeColor),
                  SizedBox(width: 3,),
                  Text(
                    double.parse(widget.homedata.ratings.toString()).toStringAsFixed(2),//"3.9",
                    style: TextStyle(
                      color: ColorCodes.darkthemeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),),
                  Spacer(),
                  Text(/*"25 Min" + " " + "|" + " " +*/ widget.homedata.distance!.toStringAsFixed(2) +/*" Km"*/S.of(context).km,
                  style: TextStyle(
                    color: ColorCodes.darkthemeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),)

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
