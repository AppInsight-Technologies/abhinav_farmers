import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../assets/ColorCodes.dart';
import '../../models/newmodle/home_page_modle.dart';
import '../../utils/prefUtils.dart';
import '../components/login_web.dart';
import '../generated/l10n.dart';
import '../models/VxModels/VxStore.dart';
import '../models/newmodle/cartModle.dart';
import '../rought_genrator.dart';
import '../assets/images.dart';
import '../screens/membership_screen.dart';
import '../utils/ResponsiveLayout.dart';
import 'alert _dailog.dart';

class Advertise1Items extends StatefulWidget {
  BannerDetails allbanners;
  final String _isvertical;

  Advertise1Items(this.allbanners, this._isvertical);

  @override
  State<Advertise1Items> createState() => _Advertise1ItemsState();
}

class _Advertise1ItemsState extends State<Advertise1Items> with Navigations{
  bool surveyProductCart = false;
  List<CartItem> productBox=[];
  @override
  Widget build(BuildContext context) {
    productBox = (VxState.store as GroceStore).CartItemList;
    for (int i = 0; i < productBox.length; i++) {
      if (productBox[i].mode =="3") {
        surveyProductCart = true;
      }
    }
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
    Widget _mainbannerShimmer() {
      return Shimmer.fromColors(
          baseColor: ColorCodes.shimmerColor,
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

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async{
        debugPrint("widget.allbanners.bannerFor...."+widget.allbanners.bannerFor.toString());
          if (widget.allbanners.bannerFor == "1") {
            // Specific product
            Navigation(context, name:Routename.BannerProduct,navigatore: NavigatoreTyp.Push,
                qparms: {
                  "id" : widget.allbanners.data,
                  'type': "product"
                });
          }
          else if (widget.allbanners.bannerFor == "2") {
            //Category
            String subTitle = "Offers";
            Navigation(context, name: Routename.ItemScreen, navigatore: NavigatoreTyp.Push,
                qparms: {
                  'maincategory' : subTitle.toString(),
                  'catId' : widget.allbanners.data!,
                  'catTitle': subTitle.toString(),
                  'subcatId' : widget.allbanners.data!,
                  'indexvalue' : "0",
                  'prev' : "advertise"
                });
          }
          else if (widget.allbanners.bannerFor == "3") {
            String maincategory = "";
            String catid = "";
            String subTitle = "";
            String index = "";

            Navigation(context, name: Routename.ItemScreen, navigatore: NavigatoreTyp.Push,
                parms: {
                  'maincategory': maincategory,
                  'catId': catid,
                  'catTitle': subTitle,
                  'subcatId': widget.allbanners.data.toString(),
                  'indexvalue': index,
                  'prev': "advertise"
                });
          }
          else if(widget.allbanners.bannerFor == "5") {
            //brands
            Navigation(context, navigatore: NavigatoreTyp.Push,name: Routename.notifybrand,qparms:
            {
              'brandsId' : widget.allbanners.data,
              'fromScreen' : "Banner",
              'notificationId' : "",
              'notificationStatus': ""
            });
          }
          else if(widget.allbanners.bannerFor == "4") {
            //Subcategory and nested category
            Navigation(context, name:Routename.BannerProduct,navigatore: NavigatoreTyp.Push,
                qparms: {
                  'id' : widget.allbanners.data,
                  'type': "category"
                });
          }
          else if(widget.allbanners.bannerFor == "6") {
            //custom link
            String url = widget.allbanners.click_link!;
            if (canLaunch(url) != null)
              launch(url);
            else
              // can't launch url, there is some error
              throw "Could not launch $url";
          }
          else if(widget.allbanners.bannerFor == "7") {
            //Pages
            Navigation(context, name:Routename.Pages,navigatore: NavigatoreTyp.Push,
                parms:{  'id' : widget.allbanners.id.toString()});
          }else if(widget.allbanners.bannerFor == "17"){
            if(!Vx.isWeb) {
              PrefUtils.prefs!.containsKey("apikey") ?Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?
              LoginWeb(context, result: (sucsess) {
                if (sucsess) {
                  Navigator.of(context).pop();
                  Navigation(context, navigatore: NavigatoreTyp.homenav);
                } else {
                  Navigator.of(context).pop();
                }
              }):
              Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push) :
              Navigation(context, name: Routename.Refer, navigatore: NavigatoreTyp.Push);
            }
          }else if(widget.allbanners.bannerFor == "18"){
            PrefUtils.prefs!.containsKey("apikey") ?Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?
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
          }else if(widget.allbanners.bannerFor == "9"){
            !PrefUtils.prefs!.containsKey("apikey")
                ? Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?
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
          margin: widget._isvertical == "horizontal" ?
          EdgeInsets.only(left: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?0:10.0, right: 10.0, bottom: 5.0,top:5.0) :
          widget._isvertical =="home"?EdgeInsets.zero:
          EdgeInsets.only(left: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?0:5.0, bottom: 1.0,top:1.0),
          child: (widget._isvertical == "top") ?
          CachedNetworkImage(
            imageUrl: widget.allbanners.bannerImage, fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width / 2.5,
            errorWidget: (context, url, error) => Image.asset(Images.defaultSliderImg),
          )
              :
          (widget._isvertical == "bottom") ?
          CachedNetworkImage(
            imageUrl: widget.allbanners.bannerImage, fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width * 0.46,
            errorWidget: (context, url, error) => Image.asset(Images.defaultSliderImg, fit: BoxFit.fill,),
          )
              :widget._isvertical =="home"?
          CachedNetworkImage(
            imageUrl: widget.allbanners.bannerImage,
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width,
            placeholder: (context, url) => _mainbannerShimmer(),
            errorWidget: (context, url, error) => Image.asset(Images.defaultSliderImg),
          ):
          CachedNetworkImage(
            imageUrl: widget.allbanners.bannerImage,
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width,
            errorWidget: (context, url, error) => Image.asset(Images.defaultSliderImg),
          ),
        ),
      ),
    );
  }
}
