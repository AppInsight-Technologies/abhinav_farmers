import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grocbay/assets/ColorCodes.dart';
import 'package:grocbay/models/newmodle/home_page_modle.dart';
import 'package:grocbay/models/newmodle/home_store_modle.dart';
import 'package:grocbay/models/newmodle/store_banner.dart';
import 'package:grocbay/utils/prefUtils.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

import '../providers/categoryitems.dart';
import '../rought_genrator.dart';
import '../screens/items_screen.dart';
import '../screens/subcategory_screen.dart';
import '../screens/not_brand_screen.dart';
import '../screens/banner_product_screen.dart';
import '../screens/pages_screen.dart';
import '../assets/images.dart';

class AdvertiseMultivendorItems extends StatelessWidget with Navigations{
  FeaturedCategories1? allbanners;
  final String isvertical;
  String fromScreen= "";
  OfferBanner? storeofferbanner;
  AdvertiseMultivendorItems({Key? key,required this.isvertical,required this.fromScreen,this.allbanners,this.storeofferbanner}) : super(key: key);
 // AdvertiseMultivendorItems(this._isvertical,this._fromScreen,[this.allbanners,this.storeofferbanner]);


  @override
  Widget build(BuildContext context) {
    Widget _mainbannerShimmer() {
      return /*_isWeb ?
      SizedBox.shrink()
          :*/
        Shimmer.fromColors(
            baseColor: /*ColorCodes.baseColor*/ColorCodes.shimmerColor,
            highlightColor: ColorCodes.shimmerColor,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 10.0,
                ),
                new Container(
                  padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                  height: 80.0,
                  width: MediaQuery.of(context).size.width - 20.0,
                  color: Colors.white,
                ),
              ],
            ));
    }

    if(fromScreen == "storeHome"){
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () async{
          },
          child: Container(
            margin: isvertical == "horizontal" ?
            EdgeInsets.only(left: 7.0, right: 1.0, bottom: 5.0,top:15.0) :
            isvertical =="home"?EdgeInsets.only(left: 15.0, bottom: 5.0,top:5.0,right:15):
            EdgeInsets.only(left: 10.0, bottom: 5.0,top:5.0),
            child: (isvertical == "top") ?
            CachedNetworkImage(
              imageUrl: storeofferbanner!.bannerImage, fit: BoxFit.fill,
              // height: 350,
              width: MediaQuery.of(context).size.width * 0.5,
              //placeholder: (context, url) => Image.asset(Images.defaultSliderImg),
              errorWidget: (context, url, error) => Image.asset(Images.defaultSliderImg),
            )
                :
            (isvertical == "bottom") ?
            CachedNetworkImage(
              imageUrl: storeofferbanner!.bannerImage, fit: BoxFit.fill,
              width: MediaQuery.of(context).size.width * 0.46,
              //placeholder: (context, url) => Image.asset(Images.defaultSliderImg),
              errorWidget: (context, url, error) => Image.asset(Images.defaultSliderImg, fit: BoxFit.fill,),
            )
                :isvertical =="home"?
            CachedNetworkImage(
              imageUrl: storeofferbanner!.bannerImage,
              fit: BoxFit.fill,
              width: MediaQuery.of(context).size.width,
              //height: MediaQuery.of(context).size.height*0.28,
              placeholder: (context, url) => /*Image.asset(Images.defaultSliderImg)*/_mainbannerShimmer(),
              errorWidget: (context, url, error) => Image.asset(Images.defaultSliderImg),
            ):
            CachedNetworkImage(
              imageUrl: storeofferbanner!.bannerImage,
              fit: BoxFit.fill,
              width: isvertical == "horizontal" ?MediaQuery.of(context).size.width / 2.5 : MediaQuery.of(context).size.width,
              //placeholder: (context, url) => Image.asset(Images.defaultSliderImg),
              errorWidget: (context, url, error) => Image.asset(Images.defaultSliderImg),
            ),
          ),
        ),
      );
    }
    else {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () async {
          },
          child: Container(
            margin: isvertical == "horizontal" ?
            EdgeInsets.only(left: 15.0, right: 15.0, bottom: 5.0, top: 5.0) :
            isvertical == "home" ? EdgeInsets.only(
                left: 15.0, bottom: 5.0, top: 5.0, right: 15) :
            EdgeInsets.only(left: 10.0, bottom: 5.0, top: 5.0),
            child: (isvertical == "top") ?
            CachedNetworkImage(
              imageUrl: allbanners!.bannerImage,
              fit: BoxFit.fill,
              // height: 350,
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.5,
              //placeholder: (context, url) => Image.asset(Images.defaultSliderImg),
              errorWidget: (context, url, error) =>
                  Image.asset(Images.defaultSliderImg),
            )
                :
            (isvertical == "bottom") ?
            CachedNetworkImage(
              imageUrl: allbanners!.bannerImage,
              fit: BoxFit.fill,
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.46,
              //placeholder: (context, url) => Image.asset(Images.defaultSliderImg),
              errorWidget: (context, url, error) =>
                  Image.asset(Images.defaultSliderImg, fit: BoxFit.fill,),
            )
                : isvertical == "home" ?
            CachedNetworkImage(
              imageUrl: allbanners!.bannerImage,
              fit: BoxFit.fill,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              //height: MediaQuery.of(context).size.height*0.28,
              placeholder: (context,
                  url) => /*Image.asset(Images.defaultSliderImg)*/_mainbannerShimmer(),
              errorWidget: (context, url, error) =>
                  Image.asset(Images.defaultSliderImg),
            ) :
            CachedNetworkImage(
              imageUrl: allbanners!.bannerImage,
              fit: BoxFit.fill,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              //placeholder: (context, url) => Image.asset(Images.defaultSliderImg),
              errorWidget: (context, url, error) =>
                  Image.asset(Images.defaultSliderImg),
            ),
          ),
        ),
      );
    }
  }
}
