import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:getflutter/components/carousel/gf_carousel.dart';
import 'package:grocbay/models/newmodle/home_store_modle.dart';
import 'package:grocbay/models/newmodle/store_banner.dart';
import 'package:grocbay/utils/prefUtils.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../models/newmodle/home_page_modle.dart';
import '../assets/ColorCodes.dart';
import 'package:url_launcher/url_launcher.dart';
import '../rought_genrator.dart';
import '../screens/banner_product_screen.dart';
import '../screens/items_screen.dart';
import '../screens/not_brand_screen.dart';
import '../screens/pages_screen.dart';
import '../widgets/SliderShimmer.dart';
import '../assets/images.dart';

class CarouselSliderStoreimage extends StatefulWidget {
  var _carauselslider = true;
  bool? isweb;
  Home_Store? homedata;
  String fromScreen= "";
  StoreOfferbanner? storeofferbanner;
  CarouselSliderStoreimage({Key? key,required this.fromScreen,this.homedata,this.storeofferbanner}) : super(key: key);
  //CarouselSliderStoreimage(this._fromScreen,[this.homedata,this.storeofferbanner]);
  @override
  _CarouselSliderimageStoreState createState() => _CarouselSliderimageStoreState();
}

class _CarouselSliderimageStoreState extends State<CarouselSliderStoreimage> with Navigations{


  @override
  Widget build(BuildContext context) {
    // Platform platform;
  /*  print("home store length...data " +
        widget.homedata!.data!.mainslider!.length.toString());*/
    if (widget.fromScreen == "StoreHome") {
      return
        widget.storeofferbanner!.data!.rootBanner!.length > 0 ?
        GFCarousel(
          autoPlay: true,
          viewportFraction: 1.0,
          height: 157,
          pagination: true,
          passiveIndicator: Colors.white,
          activeIndicator: ColorCodes.greenColor,
          autoPlayInterval: Duration(seconds: 8),
          items: [
            for (var i = 0; i < widget.storeofferbanner!.data!.rootBanner!.length; i++)
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {

                  },
                  child: Container(
                    color: ColorCodes.whiteColor,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      child: CachedNetworkImage(
                          imageUrl: widget.storeofferbanner!.data!.rootBanner![i]
                              .bannerImage,
                          placeholder: (context, url) {
                            return SliderShimmer().sliderShimmer(
                                context, height: 180);
                          },
                          errorWidget: (context, url, error) =>
                              Image.asset(Images.defaultSliderImg),
                          fit: BoxFit.fitWidth),
                    ),
                  ),
                ),
              ),
          ],
        ) : Image.asset(Images.defaultSliderImg);
    }
    else {
      return
        widget.homedata!.data!.categorymainslider!.length > 0 ?
        GFCarousel(
          autoPlay: true,
          viewportFraction: 1.0,
          height: 157,
          pagination: true,
          passiveIndicator: Colors.white,
          activeIndicator: ColorCodes.greenColor,
          autoPlayInterval: Duration(seconds: 8),
          items: [
            for (var i = 0; i < widget.homedata!.data!.categorymainslider!.length; i++)
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    if (widget.homedata!.data!.categorymainslider![i].bannerFor ==
                        "8") {
                      Navigation(context, name: Routename.StoreHome,
                          navigatore: NavigatoreTyp.Push,
                          qparms: {
                            "store_id": widget.homedata!.data!.categorymainslider![i]
                                .stores
                          });
                    }
                  },
                  child: Container(
                    color: ColorCodes.whiteColor,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      child: CachedNetworkImage(
                          imageUrl: widget.homedata!.data!.categorymainslider![i]
                              .bannerImage,
                          placeholder: (context, url) {
                            return SliderShimmer().sliderShimmer(
                                context, height: 180);
                          },
                          errorWidget: (context, url, error) =>
                              Image.asset(Images.defaultSliderImg),
                          fit: BoxFit.fitWidth),
                    ),
                  ),
                ),
              ),
          ],
        ) : Image.asset(Images.defaultSliderImg);
    }
  }
}