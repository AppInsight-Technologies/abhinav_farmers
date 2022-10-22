import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:getflutter/components/carousel/gf_carousel.dart';
import 'package:grocbay/models/newmodle/home_page_modle.dart';
import 'package:grocbay/utils/prefUtils.dart';
import 'package:velocity_x/velocity_x.dart';
import '../assets/ColorCodes.dart';
import '../providers/advertise1items.dart';
import '../rought_genrator.dart';
import '../screens/membership_screen.dart';
import '../screens/singleproduct_screen.dart';
import '../screens/items_screen.dart';
import '../providers/categoryitems.dart';
import '../screens/subcategory_screen.dart';
import 'package:provider/provider.dart';
import '../assets/images.dart';
import '../screens/banner_product_screen.dart';
import '../screens/not_brand_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/ResponsiveLayout.dart';

class WebsiteSlider extends StatefulWidget {
  HomePageData homedata;

  WebsiteSlider(this.homedata);


  @override
  _WebsiteSliderState createState() => _WebsiteSliderState();
}

class _WebsiteSliderState extends State<WebsiteSlider> with Navigations{
  var _carauselslider = false;

  @override
  Widget build(BuildContext context) {

    // if() {
    //   _carauselslider = true;
    // } else {
    //   _carauselslider = false;
    // }

    return widget.homedata.data!=null&&widget.homedata.data!.wesiteslider!.length > 0 ?  GFCarousel(
      autoPlay: true,
      viewportFraction: 1.0,
      height: 300.0,
      aspectRatio: 1,
      pagination: true,
      passiveIndicator: Colors.white,
      activeIndicator: Theme.of(context).accentColor,
      autoPlayInterval: Duration(seconds: 8),
//        initialPage: 0,
//        enableInfiniteScroll: true,
//        reverse: false,
//        autoPlay: true,
//        autoPlayInterval: Duration(seconds: 3),
//        autoPlayAnimationDuration: Duration(milliseconds: 800),
//        pauseAutoPlayOnTouch: Duration(seconds: 10),
//        enlargeCenterPage: true,
//        scrollDirection: Axis.horizontal,
      items: <Widget>[
        for (var i = 0; i < widget.homedata.data!.wesiteslider!.length; i++)
          Builder(
            builder: (BuildContext context) {
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    if (widget.homedata.data!.wesiteslider![i].bannerFor == "1") {
                     /* Navigator.of(context).pushNamed(
                          BannerProductScreen.routeName,
                          arguments: {
                            "id" : widget.homedata.data!.wesiteslider![i].data,
                            'type': "product"
                          }
                      );*/
                      Navigation(context, name:Routename.BannerProduct,navigatore: NavigatoreTyp.Push,
                          qparms: {
                            "id" : widget.homedata.data!.wesiteslider![i].data,
                            'type': "product"
                          });
                    } else if (widget.homedata.data!.wesiteslider![i].bannerFor == "2") {
                      //Category

                      final categoriesData = Provider.of<CategoriesItemsList>(context, listen: false);
                      String cattitle = "";
                      for (int j = 0; j < categoriesData.items.length; j++) {
                        if (widget.homedata.data!.wesiteslider![i].data == categoriesData.items[j].catid) {
                          cattitle = categoriesData.items[j].title!;
                        }
                      }
                   /*   Navigator.of(context)
                          .pushNamed(SubcategoryScreen.routeName, arguments: {
                        'catId': widget.homedata.data!.wesiteslider![i].data ,
                        'catTitle': cattitle,
                      });*/
                      Navigation(context, name:Routename.SubcategoryScreen,navigatore: NavigatoreTyp.Push,
                          parms:{
                            'catId': widget.homedata.data!.wesiteslider![i].data.toString(),
                            'catTitle': cattitle,
                          });
                    } else if (widget.homedata.data!.wesiteslider![i].bannerFor == "3") {
                      String maincategory = "";
                      String catid = "";
                      String subTitle = "";
                      String index = "";

                     /* Navigator.of(context).pushNamed(ItemsScreen.routeName, arguments: {
                        'maincategory': maincategory,
                        'catId': catid,
                        'catTitle': subTitle,
                        'subcatId': widget.homedata.data!.wesiteslider![i].data,
                        'indexvalue': index,
                        'prev': "advertise"

                      });*/
                      Navigation(context, name: Routename.ItemScreen, navigatore: NavigatoreTyp.PushReplacment,
                          parms: {
                            'maincategory': maincategory,
                            'catId': catid,
                            'catTitle': subTitle,
                            'subcatId': widget.homedata.data!.wesiteslider![i].data.toString(),
                            'indexvalue': index,
                            'prev': "advertise"
                          });
                    } else if(widget.homedata.data!.wesiteslider![i].bannerFor == "5") {
                      //brands
                      Navigation(context, navigatore: NavigatoreTyp.Push,name: Routename.notifyProduct,qparms:
                      {
                        'brandsId' : widget.homedata.data!.wesiteslider![i].data,
                        'fromScreen' : "Banner",
                        'notificationId' : "",
                        'notificationStatus': ""
                      });
                      // Navigator.of(context).pushNamed(NotBrandScreen.routeName,
                      //     arguments: {
                      //       'brandsId' : widget.homedata.data!.wesiteslider![i].data,
                      //       'fromScreen' : "Banner",
                      //       'notificationId' : "",
                      //       'notificationStatus': ""
                      //     }
                      // );
                    } else if(widget.homedata.data!.wesiteslider![i].bannerFor == "4") {
                      //Subcategory and nested category
                      /*Navigator.of(context).pushNamed(BannerProductScreen.routeName,
                          arguments: {
                            'id' : widget.homedata.data!.wesiteslider![i].data,
                            'type': "category"
                          }
                      );*/
                      Navigation(context, name:Routename.BannerProduct,navigatore: NavigatoreTyp.Push,
                          qparms: {
                            'id' : widget.homedata.data!.wesiteslider![i].data,
                            'type': "category"
                          });
                    } else if(widget.homedata.data!.wesiteslider![i].bannerFor == "6") {
                      String url = widget.homedata.data!.wesiteslider![i].click_link!;
                      if (canLaunch(url) != null)
                        launch(url);
                      else
                        // can't launch url, there is some error
                        throw "Could not launch $url";
                    } else if(widget.homedata.data!.wesiteslider![i].bannerFor == "17"){
                      if(!Vx.isWeb) {
                        PrefUtils.prefs!.containsKey("apikey") ?
                        Navigation(context, name: Routename.SignUpScreen,
                            navigatore: NavigatoreTyp.Push) :
                        Navigation(context, name: Routename.Refer,
                            navigatore: NavigatoreTyp.Push);
                      }
                    }else if(widget.homedata.data!.wesiteslider![i].bannerFor == "18"){
                      PrefUtils.prefs!.containsKey("apikey") ?
                      Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push) :
                      (Vx.isWeb &&
                          !ResponsiveLayout.isSmallScreen(context))?
                        MembershipInfo(context):
                      Navigation(context, name: Routename.Membership, navigatore: NavigatoreTyp.Push);
                    }
                  },
                  child: Container(

                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorCodes.whiteColor,
                      ),
                      child: CachedNetworkImage(
                          imageUrl: widget.homedata.data!.wesiteslider![i].bannerImage,
                          errorWidget: (context, url, error) => Image.asset(Images.defaultSliderImg),
                          placeholder: (context, url) => Image.asset(Images.defaultSliderImg),
                          fit: BoxFit.fill)
                  ),
                ),
              );
            },
          )
      ],
    ) : Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorCodes.whiteColor,
      ),
        width: MediaQuery.of(context).size.width,
        height: 400,
        child:  Image.asset(Images.defaultSliderImg,fit: BoxFit.fill),
    );
  }
}
