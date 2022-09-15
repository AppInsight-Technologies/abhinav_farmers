import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/carousel/gf_carousel.dart';
import 'package:grocbay/assets/ColorCodes.dart';
import 'package:grocbay/assets/images.dart';
import 'package:grocbay/models/newmodle/home_page_modle.dart';
import 'package:grocbay/rought_genrator.dart';
import 'package:grocbay/utils/prefUtils.dart';
import 'package:grocbay/widgets/SliderShimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

import '../screens/membership_screen.dart';
import '../utils/ResponsiveLayout.dart';

class Multivendorslider extends StatefulWidget {
  var _carauselslider = true;
  bool? isweb;
  HomePageData homedata;
  Multivendorslider(this.homedata);

  @override
  _MultivendorsliderState createState() => _MultivendorsliderState();
}

class _MultivendorsliderState extends State<Multivendorslider> with Navigations {
  @override
  Widget build(BuildContext context) {
    return widget.homedata.data!.mainslider!.length > 0 ?
    GFCarousel(
      autoPlay: true,
      viewportFraction: 1.0,
      height: 182,
      pagination: true,
      passiveIndicator: Colors.white,
      activeIndicator: Theme.of(context).accentColor,
      autoPlayInterval: Duration(seconds: 8),
      items: [
        for (var i = 0; i < widget.homedata.data!.mainslider!.length; i++)
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                if(widget.homedata.data!.mainslider![i].bannerFor == "1" ) {
                  debugPrint("notbanner."+widget.homedata.data!.mainslider![i].data.toString());
                  // Specific product
                  /* Navigator.of(context).pushNamed(
                      BannerProductScreen.routeName,
                      arguments: {
                        "id" : widget.homedata.data!.mainslider![i].data,
                        'type': "product",
                      }
                  );*/
                  Navigation(context, name:Routename.BannerProduct,navigatore: NavigatoreTyp.Push,
                      qparms: {
                        "id" : widget.homedata.data!.mainslider![i].data,
                        'type': "product",
                      });

                } else if(widget.homedata.data!.mainslider![i].bannerFor  == "2") {
                  //Category

                  // final categoriesData = Provider.of<CategoriesItemsList>(context, listen: false);
                  String cattitle = "";
                  /*    for(int j = 0; j < widget.homedata.data.mainslider.results.length; j++) {
                          // if(bannerData.items[i].banner_data == categoriesData.items[j].catid) {
                          //   cattitle = categoriesData.items[j].title;
                          // }
                        }*/
                  /*    Navigator.of(context).pushNamed(
                      SubcategoryScreen.routeName,
                      arguments: {
                        'catId' : widget.homedata.data.mainslider[i].data,
                        'catTitle': cattitle,
                      }
                  );*/
                  String subTitle = "";
                  debugPrint("ssppp.."+widget.homedata.data!.mainslider![i].data.toString());
                  /*Navigator.of(context).pushNamed(ItemsScreen.routeName,
                      arguments: {
                        'maincategory' : subTitle.toString(),
                        'catId' : widget.homedata.data!.mainslider![i].data,
                        'catTitle': subTitle.toString(),
                        'subcatId' : widget.homedata.data!.mainslider![i].data,
                        'indexvalue' : "0",
                        'prev' : "carousel"
                      });*/
                  Navigation(context, name: Routename.ItemScreen, navigatore: NavigatoreTyp.Push,
                      qparms: {
                        'maincategory' : subTitle.toString(),
                        'catId' : widget.homedata.data!.mainslider![i].data!,
                        'catTitle': subTitle.toString(),
                        'subcatId' : widget.homedata.data!.mainslider![i].data!,
                        'indexvalue' : "0",
                        'prev' : "carousel"
                      });
                } else if(widget.homedata.data!.mainslider![i].bannerFor == "3") {
                  //subcategory

                  String subTitle = "";
                  debugPrint("ssppp11.."+widget.homedata.data!.mainslider![i].data.toString());
                  /*Navigator.of(context).pushNamed(ItemsScreen.routeName,
                      arguments: {
                        'maincategory' : subTitle.toString(),
                        'catId' : widget.homedata.data!.mainslider![i].data,
                        'catTitle': subTitle.toString(),
                        'subcatId' : widget.homedata.data!.mainslider![i].data,
                        'indexvalue' : "0",
                        'prev' : "carousel"
                      }
                  );*/

                  Navigation(context, name: Routename.ItemScreen, navigatore: NavigatoreTyp.Push,
                      qparms: {
                        'maincategory' : subTitle.toString(),
                        'catId' : widget.homedata.data!.mainslider![i].data!,
                        'catTitle': subTitle.toString(),
                        'subcatId' : widget.homedata.data!.mainslider![i].data!,
                        'indexvalue' : "0",
                        'prev' : "carousel"
                      });
                } else if(widget.homedata.data!.mainslider![i].bannerFor == "5") {
                  //brands
                  Navigation(context, navigatore: NavigatoreTyp.Push,name: Routename.notifybrand,qparms:
                  {
                    'brandsId' : widget.homedata.data!.mainslider![i].data.toString(),
                    'fromScreen' : "Banner",
                    'notificationId' : "",
                    'notificationStatus': ""
                  });
                  // Navigator.of(context).pushNamed(NotBrandScreen.routeName,
                  //     arguments: {
                  //       'brandsId' : widget.homedata.data!.mainslider![i].data.toString(),
                  //       'fromScreen' : "Banner",
                  //       'notificationId' : "",
                  //       'notificationStatus': ""
                  //     }
                  // );
                } else if(widget.homedata.data!.mainslider![i].bannerFor == "4") {
                  //Subcategory and nested category
                  /* Navigator.of(context).pushNamed(BannerProductScreen.routeName,
                      arguments: {
                        'id' : widget.homedata.data!.mainslider![i].data,
                        'type': "category"
                      }
                  );*/
                  Navigation(context, name:Routename.BannerProduct,navigatore: NavigatoreTyp.Push,
                      qparms: {
                        'id' : widget.homedata.data!.mainslider![i].data,
                        'type': "category"
                      });
                } else if(widget.homedata.data!.mainslider![i].bannerFor == "6") {
                  debugPrint("custom link.."+ widget.homedata.data!.mainslider![i].click_link.toString());
                  String url = widget.homedata.data!.mainslider![i].click_link!;
                  if (canLaunch(url) != null)
                    launch(url);
                  else
                    // can't launch url, there is some error
                    throw "Could not launch $url";
                } else if(widget.homedata.data!.mainslider![i].bannerFor == "7") {
                  //Pages
                  /* Navigator.of(context).pushNamed(PagesScreen.routeName,
                      arguments: {
                        'id' : widget.homedata.data!.mainslider![i].id,
                      }
                  );*/
                  Navigation(context, name:Routename.Pages,navigatore: NavigatoreTyp.Push,
                      parms:{ 'id' : widget.homedata.data!.mainslider![i].id.toString()});
                }else if(widget.homedata.data!.mainslider![i].bannerFor == "17"){
                  if(!Vx.isWeb) {
                    !PrefUtils.prefs!.containsKey("apikey") ?
                    Navigation(context, name: Routename.SignUpScreen,
                        navigatore: NavigatoreTyp.Push) :
                    Navigation(context, name: Routename.Refer,
                        navigatore: NavigatoreTyp.Push);
                  }
                }else if(widget.homedata.data!.mainslider![i].bannerFor == "18"){
                  !PrefUtils.prefs!.containsKey("apikey") ?
                  Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push) :
                  (Vx.isWeb &&
                      !ResponsiveLayout.isSmallScreen(context))?
                    MembershipInfo(context):
                  Navigation(context, name: Routename.Membership, navigatore: NavigatoreTyp.Push);
                }
              },
              child: Container(
                color: ColorCodes.whiteColor,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: CachedNetworkImage(
                      imageUrl: widget.homedata.data!.mainslider![i].bannerImage,
                      placeholder: (context, url) {
                        return SliderShimmer().sliderShimmer(context, height: 180);
                      },
                      errorWidget: (context, url, error) => Image.asset(Images.defaultSliderImg),
                      fit: BoxFit.fitWidth),
                ),
              ),
            ),
          ),
      ],
    ) : Image.asset(Images.defaultSliderImg);
  }
}
