import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:getflutter/components/carousel/gf_carousel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../constants/features.dart';
import '../../utils/prefUtils.dart';
import '../../models/newmodle/home_page_modle.dart';
import '../assets/ColorCodes.dart';
import '../components/login_web.dart';
import '../generated/l10n.dart';
import '../models/VxModels/VxStore.dart';
import '../models/newmodle/cartModle.dart';
import '../rought_genrator.dart';
import '../screens/membership_screen.dart';
import '../utils/ResponsiveLayout.dart';
import '../widgets/SliderShimmer.dart';
import '../assets/images.dart';
import 'alert _dailog.dart';

class CarouselSliderimage extends StatefulWidget {
  HomePageData homedata;
  final String _istestimonial;
  CarouselSliderimage(this.homedata,this._istestimonial);

  @override
  _CarouselSliderimageState createState() => _CarouselSliderimageState();
}

class _CarouselSliderimageState extends State<CarouselSliderimage> with Navigations{
  bool surveyProductCart = false;
  List<CartItem> productBox=[];

  Showpopupformsg(String msg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async{
            return Future.value(true);
          },
          child: AlertDialog(
            title: Image.asset(
              Images.logoImg,
              height: 50,
              width: 138,
            ),
            content: Text(msg),
            actions: <Widget>[
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: (){
                Navigator.pop(context);
                Navigation(context, navigatore: NavigatoreTyp.homenav);
              },
              child: Container(
                height: 40,
                  width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: ColorCodes.whiteColor,
                  border: Border.all(
                      color: ColorCodes.greenColor),

                ),
                  child: Center(
                    child: Text(
                      S.of(context).ok,textAlign: TextAlign.center, //'Ok'
                    ),
                  ),

                ),
            ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Platform platform;
    productBox = (VxState.store as GroceStore).CartItemList;
    for (int i = 0; i < productBox.length; i++) {
      if (productBox[i].mode =="3") {
        surveyProductCart = true;
      }
    }
    return
      widget._istestimonial == "testimonial" ?
      widget.homedata.data!.testimonials!.length > 0 ?
      GFCarousel(
        autoPlay: true,
        viewportFraction: 1.0,
        height: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?380.0:182,
        pagination: true,
        passiveIndicator: Colors.white,
        activeIndicator: Theme.of(context).accentColor,
        autoPlayInterval: Duration(seconds: 8),
        items: [
          for (var i = 0; i < widget.homedata.data!.testimonials!.length; i++)
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                },
                child: Container(
                  padding: Features.ismultivendor?EdgeInsets.only(left:15,right:15):EdgeInsets.only(left:0,right:0,top:5),
                  color: ColorCodes.whiteColor,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: CachedNetworkImage(
                        imageUrl: widget.homedata.data!.testimonials![i].bannerImage,
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
      ) : SizedBox.shrink()/*Image.asset(Images.defaultSliderImg)*/:
      widget.homedata.data!.mainslider!.length > 0 ?
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
                debugPrint("widget.allbanners.bannerFor....CAROUSEL"+widget.homedata.data!.mainslider![i].bannerFor.toString());
                if(widget.homedata.data!.mainslider![i].bannerFor == "1" ) {
                  // Specific product
                  Navigation(context, name:Routename.BannerProduct,navigatore: NavigatoreTyp.Push,
                      qparms: {
                        "id" : widget.homedata.data!.mainslider![i].data,
                        'type': "product",
                      });
                } else if(widget.homedata.data!.mainslider![i].bannerFor  == "2") {
                  //Category
                  String subTitle = "Offers";
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
                } else if(widget.homedata.data!.mainslider![i].bannerFor == "4") {
                  //Subcategory and nested category
                  Navigation(context, name:Routename.BannerProduct,navigatore: NavigatoreTyp.Push,
                      qparms: {
                        'id' : widget.homedata.data!.mainslider![i].data,
                        'type': "category"
                      });
                } else if(widget.homedata.data!.mainslider![i].bannerFor == "6") {
                  String url = widget.homedata.data!.mainslider![i].click_link!;
                  if (canLaunch(url) != null)
                    launch(url);
                  else
                    // can't launch url, there is some error
                    throw "Could not launch $url";
                } else if(widget.homedata.data!.mainslider![i].bannerFor == "7") {
                  //Pages
                  Navigation(context, name:Routename.Pages,navigatore: NavigatoreTyp.Push,
                      parms:{ 'id' : widget.homedata.data!.mainslider![i].id.toString()});
                }else if(widget.homedata.data!.mainslider![i].bannerFor == "17"){
                  if(!Vx.isWeb) {
                    !PrefUtils.prefs!.containsKey("apikey") ?Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?
                    LoginWeb(context, result: (sucsess) {
                      if (sucsess) {
                        Navigator.of(context).pop();
                        Navigation(context, navigatore: NavigatoreTyp.homenav);
                      } else {
                        Navigator.of(context).pop();
                      }
                    }):
                    Navigation(context, name: Routename.SignUpScreen,
                        navigatore: NavigatoreTyp.Push) :
                    Navigation(context, name: Routename.Refer,
                        navigatore: NavigatoreTyp.Push);
                  }
                }else if(widget.homedata.data!.mainslider![i].bannerFor == "18"){
                  !PrefUtils.prefs!.containsKey("apikey") ?Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?
                  LoginWeb(context, result: (sucsess) {
                    if (sucsess) {
                      Navigator.of(context).pop();
                      Navigation(context, navigatore: NavigatoreTyp.homenav);
                    } else {
                      Navigator.of(context).pop();
                    }
                  }):
                  Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push) :
                   (Vx.isWeb &&
                      !ResponsiveLayout.isSmallScreen(context))?
                    MembershipInfo(context):
                  Navigation(context, name: Routename.Membership, navigatore: NavigatoreTyp.Push);
                }
                else if(widget.homedata.data!.mainslider![i].bannerFor == "9"){
                  !PrefUtils.prefs!.containsKey("apikey")
                      ?Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?
                  LoginWeb(context, result: (sucsess) {
                    if (sucsess) {
                      Navigator.of(context).pop();
                      Navigation(context, navigatore: NavigatoreTyp.homenav);
                    } else {
                      Navigator.of(context).pop();
                    }
                  }):
                  Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push):
                  (VxState.store.userData.customerEngagementFlag! =="2")?
                  Showpopupformsg(/*"You have already taken Survey"*/S.of(context).already_taken_survey)
                  :surveyProductCart?
                  Showpopupformsg(/*"You have already taken Survey and selected Free product"*/S.of(context).survey_free)
                      :
                  Navigation(context, name: Routename.CustomerEngagementScreen, navigatore: NavigatoreTyp.Push);
                }
              },
              child: Container(
                padding: Features.ismultivendor?EdgeInsets.only(left:15,right:15):EdgeInsets.only(left:0,right:0),
                color: ColorCodes.whiteColor,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
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