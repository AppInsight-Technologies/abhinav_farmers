import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:url_launcher/url_launcher.dart';
import "package:http/http.dart" as http;
import '../constants/IConstants.dart';
import '../assets/images.dart';
import '../screens/membership_screen.dart';
import '../utils/ResponsiveLayout.dart';
import '../utils/prefUtils.dart';
import '../assets/ColorCodes.dart';
import '../constants/features.dart';
import '../../utils/in_app_update_review.dart';
import '../models/VxModels/VxStore.dart';
import '../rought_genrator.dart';
import '../generated/l10n.dart';
import 'CoustomeDailogs/slectlanguageDailogBox.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> with Navigations {
  GroceStore store = VxState.store;

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
//      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  void initState() {
    super.initState();
  }

  void launchWhatsapp({required number,required message})async{
    String url ="whatsapp://send?phone=$number&text=$message";
    await canLaunch(url)?launch(url):print('can\'t open whatsapp');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: ColorCodes.whiteColor,
              child: Column(
                children: [
                  SizedBox(
                    height: 50.0,
                  ),
                  !PrefUtils.prefs!.containsKey("apikey")
                      ?
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.PushReplacment);
                    },
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 20.0,
                        ),
                        Image.asset(Images.appLogin,
                            height: 25.0, width: 25.0),
                        SizedBox(
                          width: 15.0,
                        ),
                        Text(
                          S .of(context).login_register,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                       Spacer(),
                        Icon(Icons.keyboard_arrow_right,
                            color: ColorCodes.greyColor,
                            size: 30),
                        SizedBox(
                          width: 25.0,
                        ),
                      ],
                    ),
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(width: 5.0),
                      IconButton(
                        icon: Icon(Icons.keyboard_arrow_left,
                            color: ColorCodes.greyColor,
                            size: 30),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              store.userData.username??"",
                              maxLines: 2,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                            color: ColorCodes.blackColor),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              store.userData.mobileNumber?? "",
                              style: TextStyle(fontSize: 14.0, color: ColorCodes.blackColor),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              store.userData.email?? "",
                              style: TextStyle(fontSize: 14.0, color: ColorCodes.blackColor),
                            ),
                          ],
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigation(context, name: Routename.EditScreen, navigatore: NavigatoreTyp.Push);
                        },
                        child: Text(
                          S .of(context).edit,
                          style: TextStyle(
                              fontSize: 14,
                              color: ColorCodes.greyColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 5),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Container(
              color:  ColorCodes.appdrawerColor,
              height: 15,
            ),
            Container(
              color: ColorCodes.whiteColor,
              padding: EdgeInsets.only(left: 0, right: 10, top:10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigator.of(context).pop();
                       !PrefUtils.prefs!.containsKey("apikey")
                          ?
                       Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                          :
                       Navigation(context, name: Routename.Help, navigatore: NavigatoreTyp.Push);
                    },
                    child: Column(
                          children: <Widget>[
                            Image.asset(Images.appbar_help,
                                color:  !PrefUtils.prefs!.containsKey("apikey")
                                    ? ColorCodes.greyColor

                                    : IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                           
                                height: 20.0, width: 20.0),
                            SizedBox(height: 1),

                            Text(S .of(context).ordering_help,
                              //S .of(context).help,
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                  fontSize: 14,
                                  color:  !PrefUtils.prefs!.containsKey("apikey")
                                      ? ColorCodes.greyColor
                                      : ColorCodes.mediumBlackColor),
                            ),
                      ],
                    ),
                  ),
                      SizedBox(width: 15),
                  if((Features.ismultivendor && IConstants.isEnterprise)?Features.isWalletroot:Features.isWallet)
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                         !PrefUtils.prefs!.containsKey("apikey")
                            ?
                         Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                            :
                         Navigation(context, name: Routename.Wallet, navigatore: NavigatoreTyp.Push,
                             qparms: {
                           "type": "wallet",
                         });
                      },
                      child: Column(
                        children: <Widget>[
                          Image.asset(Images.walletImg,
                              color:  !PrefUtils.prefs!.containsKey("apikey")
                                  ? ColorCodes.greyColor

                                  : IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,

                              height: 20.0, width: 20.0),
                          SizedBox(
                            height: 1.0,
                          ),
                          Text(
                              S.of(context).wallet,//"Wallet",
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: !PrefUtils.prefs!.containsKey("apikey")
                                      ? ColorCodes.greyColor
                                      : ColorCodes.mediumBlackColor)),
                        ],
                      ),
                    ),
                  SizedBox(width: 15),
                  if((Features.ismultivendor && IConstants.isEnterprise)?Features.isLanguageModuleroot:Features.isLanguageModule)
                    if(store.language.languages.length > 1)
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          showDialog(context: context, builder: (BuildContext context) => LanguageselectDailog(context));
                        },
                        child: Column(
                          children: <Widget>[
                            Image.asset(Images.appBar_lang, width: 20, height: 20,
                                color:  !PrefUtils.prefs!.containsKey("apikey")
                                    ? ColorCodes.greyColor

                                    : IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor),
                          
                            SizedBox(height: 1),

                            Text(
                              S .current.language,
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: !PrefUtils.prefs!.containsKey("apikey")
                                      ? ColorCodes.greyColor
                                      : ColorCodes.mediumBlackColor),
                            ),
                          ],
                        ),
                      ),
                  // SizedBox(width: 5),

                ],
              ),
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              color: ColorCodes.appdrawerColor,
              padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
              child: Text(
                S .of(context).order_more,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: ColorCodes.blackColor,
                  )
              )
            ),

            Container(
                width: MediaQuery.of(context).size.width,
                color: ColorCodes.whiteColor,
                padding: EdgeInsets.only(left: 18, right: 20, top: 15, bottom: 15),
                child: Column(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                         !PrefUtils.prefs!.containsKey("apikey")
                            ?
                         Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                            :
                         Navigation(context, name:Routename.MyOrders,navigatore: NavigatoreTyp.Push,qparms: {
                           "orderhistory": null
                         });
                      },
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 5.0,
                          ),
                          Image.asset(Images.appbar_myorder, height: 18.0, width: 18.0,
                          color: ColorCodes.blackColor),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            S .of(context).my_orders,
                            style: TextStyle(
                                fontSize: 15,
                                color: !PrefUtils.prefs!.containsKey("apikey") ? ColorCodes.blackColor : ColorCodes.blackColor),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    if(Features.isSubscription)
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                           !PrefUtils.prefs!.containsKey("apikey")
                              ?
                           Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                              :
                           Navigation(context, name: Routename.MySubscription, navigatore: NavigatoreTyp.Push);
                        },
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 5.0,
                            ),
                            Image.asset(Images.appbar_subscription, height: 18.0, width: 18.0,
                                color: ColorCodes.blackColor),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              S .of(context).my_subscription,
                              style: TextStyle(
                                  fontSize: 15,
                                  color:  !PrefUtils.prefs!.containsKey("apikey") ? ColorCodes.blackColor : ColorCodes.blackColor),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    if(Features.isSubscription)
                    SizedBox(height: 15),
                    if(Features.isShoppingList)
                      GestureDetector(
                        onTap: () {
                           !PrefUtils.prefs!.containsKey("apikey")
                              ?
                           Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                              :
                           Navigation(context, name: Routename.Shoppinglist, navigatore: NavigatoreTyp.Push);
                        },
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 5.0,
                            ),
                            Image.asset(Images.appbar_shopping, height: 18.0, width: 18.0,
                                color:  ColorCodes.blackColor),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                                S.of(context).shopping_list,//"Shopping list",
                                style: TextStyle(
                                    color:  !PrefUtils.prefs!.containsKey("apikey") ?  ColorCodes.blackColor : ColorCodes.blackColor, fontSize: 15.0)),
                          ],
                        ),
                      ),
                    SizedBox(height: 15),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                         !PrefUtils.prefs!.containsKey("apikey")
                            ?
                         Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.PushReplacment)
                            :
                         Navigation(context, name: Routename.AddressBook, navigatore: NavigatoreTyp.Push);
                      },
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 5.0,
                          ),
                          Image.asset(Images.appbar_address, height: 18.0, width: 18.0,
                              color: ColorCodes.blackColor),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            S .of(context).address_book,
                            style: TextStyle(
                                fontSize: 15,
                                color:  !PrefUtils.prefs!.containsKey("apikey")
                                    ? ColorCodes.blackColor
                                    : ColorCodes.blackColor),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ],
                )
            ),
            if(PrefUtils.prefs!.getString('myreffer') != 'null' && ! !PrefUtils.prefs!.containsKey("apikey") && Features.isReferEarn)
            Container(
              color:  ColorCodes.appdrawerColor,
              height: 20,
            ),
            if(PrefUtils.prefs!.getString('myreffer') != 'null' && ! !PrefUtils.prefs!.containsKey("apikey") && Features.isReferEarn)
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigation(context, name:Routename.Refer,navigatore: NavigatoreTyp.Push);
                },
                child: Container(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 24.0,
                      ),
                      RichText(
                        text: new TextSpan(
                          children: <TextSpan>[
                            new TextSpan(
                              text:S .of(context).refer_and_earn,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400, color: ColorCodes.blackColor),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Image.asset(Images.appbar_refer, width: 30, height: 30),
                      SizedBox(
                        width: 25.0,
                      ),
                    ],
                  ),
                ),
              ) ,
            if(PrefUtils.prefs!.getString('myreffer') != 'null' && ! !PrefUtils.prefs!.containsKey("apikey") && Features.isReferEarn)
              Container(
                color:  ColorCodes.appdrawerColor,
                height: 20,
              ),
            (!Features.ismultivendor && Features.isMembership)?
            SizedBox(height: 15):SizedBox.shrink(),
            (!Features.ismultivendor && Features.isMembership)? GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                 !PrefUtils.prefs!.containsKey("apikey")
                    ?
                 Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                    :
                 (Vx.isWeb &&
                !ResponsiveLayout.isSmallScreen(context)) ?
                MembershipInfo(context):
                 Navigation(context, name: Routename.Membership, navigatore: NavigatoreTyp.Push);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ColorCodes.varcolor),
                  color: ColorCodes.varcolor,
                ),
                margin: EdgeInsets.only(right: 25, left: 20),
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      S .of(context).membership,
                      style: TextStyle(
                          fontSize: 18,
                          color:  !PrefUtils.prefs!.containsKey("apikey")
                              ? IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor
                              : IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor),
                    ),
                    Spacer(),
                    ! !PrefUtils.prefs!.containsKey("apikey") ?
                    (store.userData.membership! == "1") ?
                    Row(
                      children: [
                        Text(
                          S .of(context).active,
                          style: TextStyle(
                              fontSize: 15,
                              color:  IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor),
                        ),SizedBox(width: 5),
                        Container(
                          width: 20.0,
                          height: 20.0,
                          decoration: BoxDecoration(
                            color: ColorCodes.whiteColor,
                            border: Border.all(
                              color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            margin: EdgeInsets.all(1.5),
                            decoration: BoxDecoration(
                              color: ColorCodes.whiteColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.check,
                                color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                                size: 15.0),
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ) :
                    Row(
                      children: [
                        Text(
                          S .of(context).buy,
                          style: TextStyle(
                              fontSize: 15,
                              color:  IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor),
                         ),
                        SizedBox(width: 10),
                      ],
                    )
                        :
                    Row(
                      children: [
                        Text(
                        S.of(context).buy,
                          style: TextStyle(
                              fontSize: 15,
                              color:  IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ],
                ),
              ),
            )
                :
            SizedBox.shrink(),
            (Features.ismultivendor && Features.isMembershiproot)?
            SizedBox(height: 15):SizedBox.shrink(),
            (Features.ismultivendor && Features.isMembershiproot)? GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                !PrefUtils.prefs!.containsKey("apikey")
                    ?
                Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                    :
                (Vx.isWeb &&
                !ResponsiveLayout.isSmallScreen(context))?
                MembershipInfo(context):
                Navigation(context, name: Routename.Membership, navigatore: NavigatoreTyp.Push);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ColorCodes.lightBlueColor),
                  color: ColorCodes.lightBlueColor,
                ),
                margin: EdgeInsets.only(right: 25, left: 20),
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      S .of(context).membership,
                      style: TextStyle(
                          fontSize: 18,
                          color:  !PrefUtils.prefs!.containsKey("apikey")
                              ? IConstants.isEnterprise?ColorCodes.lightblue:ColorCodes.lightblue
                              : IConstants.isEnterprise?ColorCodes.lightblue:ColorCodes.lightblue),
                    ),
                    Spacer(),
                    ! !PrefUtils.prefs!.containsKey("apikey") ?
                    (store.userData.membership! == "1") ?
                    Row(
                      children: [
                        Text(
                          S .of(context).active,
                          style: TextStyle(
                              fontSize: 15,
                              color:  IConstants.isEnterprise?ColorCodes.lightblue:ColorCodes.lightblue),
                        ),SizedBox(width: 5),
                        Container(
                          width: 20.0,
                          height: 20.0,
                          decoration: BoxDecoration(
                            color: ColorCodes.whiteColor,
                            border: Border.all(
                              color: ColorCodes.greenColor,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            margin: EdgeInsets.all(1.5),
                            decoration: BoxDecoration(
                              color: ColorCodes.whiteColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.check,
                                color: ColorCodes.greenColor,
                                size: 15.0),
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ) :
                    Row(
                      children: [
                        Text(
                          S .of(context).buy,
                          style: TextStyle(
                              fontSize: 15,
                              color:  IConstants.isEnterprise?ColorCodes.lightblue:ColorCodes.lightblue),
                        ),
                        SizedBox(width: 10),
                      ],
                    ) : Row(
                      children: [
                        Text(
                          S .of(context).buy,
                          style: TextStyle(
                              fontSize: 15,
                              color:  IConstants.isEnterprise?ColorCodes.lightblue:ColorCodes.lightblue),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ],
                ),
              ),
            ):SizedBox.shrink(),

            (Features.isLoyalty)?SizedBox(height: 10):SizedBox.shrink(),
            (Features.isLoyalty)? GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                 !PrefUtils.prefs!.containsKey("apikey")
                    ?
                 Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                    :
                 Navigation(context, name: Routename.Loyalty, navigatore: NavigatoreTyp.Push);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ColorCodes.appdrawerColor),
                  color: ColorCodes.appdrawerColor,
                ),
                margin: EdgeInsets.only(right: 25, left: 20),
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      S .of(context).loyalty,
                      style: TextStyle(
                          fontSize: 18,
                          color:  !PrefUtils.prefs!.containsKey("apikey")
                              ? ColorCodes.blackColor
                              : ColorCodes.blackColor),
                    ),
                    Spacer(),
                     !PrefUtils.prefs!.containsKey("apikey")?
                    Text("0",
                      style: TextStyle(
                          color: ColorCodes.blackColor, fontSize: 16.0),
                    ) :
                    Text(PrefUtils.prefs!.containsKey("loyalty_balance") ? PrefUtils.prefs!.getString("loyalty_balance")! : "",
                      style: TextStyle(
                          color: ColorCodes.blackColor, fontSize: 16.0),
                    ),
                    SizedBox(width: 5),
                    Image.asset(
                      Images.coinImg,
                      height: 20.0,
                      width: 20.0,
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
            ):SizedBox.shrink(),
            SizedBox(height: 15),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigation(context, name: Routename.AboutUs, navigatore: NavigatoreTyp.Push);
              },
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 25.0,
                  ),
                  Container(
                      width: 150.0,
                      child: Row(
                        children: <Widget>[
                          Text(
                            S .of(context).about_us,
                            style: TextStyle(
                                fontSize: 15,
                                color: ColorCodes.blackColor),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            SizedBox(height: 15),
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigation(context, name: Routename.Privacy, navigatore: NavigatoreTyp.Push);
                },
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 25.0,
                    ),
                    Expanded(
                      child: Text(
                        S .of(context).privacy_others,
                        style: TextStyle(
                            fontSize: 15,
                            color: ColorCodes.blackColor),
                      ),
                    ),
                  ],
                ),
              ),
                SizedBox(height: 15),
            SizedBox(height: 15),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigation(context, navigatore: NavigatoreTyp.Push,name: Routename.Policy,
                    parms: {
                      'title' : "FAQ",
                    });
              },
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 25.0,
                  ),
                  Expanded(
                    child: Text(
                      S.of(context).faq,
                      style: TextStyle(
                          fontSize: 15,
                          color: ColorCodes.blackColor),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                try {
                  // if (Platform.isIOS) {
                  //   LaunchReview.launch(
                  //       writeReview: false, iOSAppId: IConstants.appleId);
                  // } else {
                  //   LaunchReview.launch();
                  // }
                  inappreview.requestReview();
                }catch(e){};
              },
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 25.0,
                  ),
                  Text(
                   /* !Vx.isAndroid && !Vx.isWeb
                        ? S .of(context).rate_us
                        :*/ S .of(context).rate_us,
                    style: TextStyle(
                        fontSize: 15, color: ColorCodes.blackColor),
                  ),
                  Spacer(),
                ],
              ),
            ),
            SizedBox(height: 15),
            if (! !PrefUtils.prefs!.containsKey("apikey"))
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  PrefUtils.prefs!.remove('LoginStatus');
                  PrefUtils.prefs!.remove("apikey");
                  store.CartItemList.clear();
                  store.homescreen.data = null;
                  if (PrefUtils.prefs!.getString('prevscreen') == 'signingoogle') {
                    PrefUtils.prefs!.setString("photoUrl", "");
                    await _googleSignIn.signOut();
                    String branch = PrefUtils.prefs!.getString("branch")!;
                    String tokenId = PrefUtils.prefs!.getString('tokenid')??"";
                    String _ftokenId = PrefUtils.prefs!.getString("ftokenid")!;
                    String _mapFetch = "null";
                    String _isDelivering = "false";
                    String defaultLocation = "null";
                    String deliverylocation = "null";
                    String _latitude = "null";
                    String _longitude = "null";
                    String currentdeliverylocation = IConstants
                        .currentdeliverylocation.value;
                    bool deliverystatus = PrefUtils.prefs!.getBool("deliverystatus")!;
                    if (PrefUtils.prefs!.containsKey("ismapfetch")) {
                      _mapFetch = PrefUtils.prefs!.getString("ismapfetch")!;
                    }
                    if (PrefUtils.prefs!.containsKey("isdelivering")) {
                      _isDelivering =
                          PrefUtils.prefs!.getString("isdelivering")!;
                    }
                    if (PrefUtils.prefs!.containsKey("defaultlocation")) {
                      defaultLocation =
                          PrefUtils.prefs!.getString("defaultlocation")!;
                    }
                    if (PrefUtils.prefs!.containsKey("deliverylocation")) {
                      deliverylocation =
                          PrefUtils.prefs!.getString("deliverylocation")!;
                    }
                    if (PrefUtils.prefs!.containsKey("latitude")) {
                      _latitude = PrefUtils.prefs!.getString("latitude")!;
                    }

                    if (PrefUtils.prefs!.containsKey("longitude")) {
                      _longitude = PrefUtils.prefs!.getString("longitude")!;
                    }
                    PrefUtils.prefs!.clear();
                    PrefUtils.prefs!.setBool('introduction', true);
                    PrefUtils.prefs!.setBool("welcomeSheet", true);
                    PrefUtils.prefs!.setString("branch", branch);
                    PrefUtils.prefs!.setString("tokenid", tokenId);
                    PrefUtils.prefs!.setString("ftokenid", _ftokenId);
                    PrefUtils.prefs!.setString("ismapfetch", _mapFetch);
                    PrefUtils.prefs!.setString("isdelivering", _isDelivering);
                    PrefUtils.prefs!.setString("defaultlocation", defaultLocation);
                    PrefUtils.prefs!.setString("deliverylocation", deliverylocation);
                    PrefUtils.prefs!.setString("longitude", _longitude);
                    PrefUtils.prefs!.setString("latitude", _latitude);
                    PrefUtils.prefs!.setBool("deliverystatus", deliverystatus);
                    IConstants.currentdeliverylocation.value = currentdeliverylocation;
                    Navigator.of(context).pop();
                    Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.homenav);
                  } else if (PrefUtils.prefs!.getString('prevscreen') == 'signinfacebook') {
                    PrefUtils.prefs!.getString("FBAccessToken");
                    var facebookSignIn = FacebookLogin();

                    final graphResponse = await http.delete(
                        'https://graph.facebook.com/v2.12/me/permissions/?access_token=${PrefUtils.prefs!.getString("FBAccessToken")}&httpMethod=DELETE&ref=logout&destroy=true');

                    PrefUtils.prefs!.setString("photoUrl", "");
                    await facebookSignIn.logOut().then((value) {
                      String branch = PrefUtils.prefs!.getString("branch")!;
                      String tokenId = PrefUtils.prefs!.getString('tokenid')??"";
                      String _ftokenId = PrefUtils.prefs!.getString("ftokenid")!;
                      String code = PrefUtils.prefs!.getString('referCodeDynamic')!;

                      String _mapFetch = "null";
                      String _isDelivering = "false";
                      String defaultLocation = "null";
                      String deliverylocation = "null";
                      String _latitude = "null";
                      String _longitude = "null";
                      String currentdeliverylocation = IConstants
                          .currentdeliverylocation.value;
                      bool deliverystatus = PrefUtils.prefs!.getBool("deliverystatus")!;
                      if (PrefUtils.prefs!.containsKey("ismapfetch")) {
                        _mapFetch = PrefUtils.prefs!.getString("ismapfetch")!;
                      }
                      if (PrefUtils.prefs!.containsKey("isdelivering")) {
                        _isDelivering = PrefUtils.prefs!.getString(
                            "isdelivering")!;
                      }
                      if (PrefUtils.prefs!.containsKey("defaultlocation")) {
                        defaultLocation = PrefUtils.prefs!.getString(
                            "defaultlocation")!;
                      }
                      if (PrefUtils.prefs!.containsKey("deliverylocation")) {
                        deliverylocation = PrefUtils.prefs!.getString(
                            "deliverylocation")!;
                      }
                      if (PrefUtils.prefs!.containsKey("latitude")) {
                        _latitude = PrefUtils.prefs!.getString("latitude")!;
                      }

                      if (PrefUtils.prefs!.containsKey("longitude")) {
                        _longitude = PrefUtils.prefs!.getString("longitude")!;
                      }

                      PrefUtils.prefs!.clear();
                      PrefUtils.prefs!.setBool('introduction', true);
                      PrefUtils.prefs!.setBool("welcomeSheet", true);
                      PrefUtils.prefs!.setString("branch", branch);
                      PrefUtils.prefs!.setString("tokenid", tokenId);
                      PrefUtils.prefs!.setString("ftokenid", _ftokenId);
                      PrefUtils.prefs!.setString("referCodeDynamic", code);
                      PrefUtils.prefs!.setString("ismapfetch", _mapFetch);
                      PrefUtils.prefs!.setString(
                          "isdelivering", _isDelivering);
                      PrefUtils.prefs!.setString(
                          "defaultlocation", defaultLocation);
                      PrefUtils.prefs!.setString(
                          "deliverylocation", deliverylocation);
                      PrefUtils.prefs!.setBool("deliverystatus", deliverystatus);
                      PrefUtils.prefs!.setString("longitude", _longitude);
                      PrefUtils.prefs!.setString("latitude", _latitude);
                      IConstants.currentdeliverylocation.value =
                          currentdeliverylocation;
                      Navigator.of(context).pop();
                      Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push);
                    });
                  } else {
                    String branch = PrefUtils.prefs!.getString("branch")!;
                    String tokenId = PrefUtils.prefs!.getString('tokenid')??"";
                    String _ftokenId = PrefUtils.prefs!.getString("ftokenid")!;
                    String _mapFetch = "null";
                    String _isDelivering = "false";
                    String defaultLocation = "null";
                    String deliverylocation = "null";
                    String _latitude = "null";
                    String _longitude = "null";
                    String currentdeliverylocation = IConstants.currentdeliverylocation.value;
                    bool deliverystatus = PrefUtils.prefs!.getBool("deliverystatus")!;
                    if (PrefUtils.prefs!.containsKey("ismapfetch")) {
                      _mapFetch = PrefUtils.prefs!.getString("ismapfetch")!;
                    }
                    if (PrefUtils.prefs!.containsKey("isdelivering")) {
                      _isDelivering =
                          PrefUtils.prefs!.getString("isdelivering")!;
                    }
                    if (PrefUtils.prefs!.containsKey("defaultlocation")) {
                      defaultLocation =
                          PrefUtils.prefs!.getString("defaultlocation")!;
                    }
                    if (PrefUtils.prefs!.containsKey("deliverylocation")) {
                      deliverylocation =
                          PrefUtils.prefs!.getString("deliverylocation")!;
                    }
                    if (PrefUtils.prefs!.containsKey("latitude")) {
                      _latitude = PrefUtils.prefs!.getString("latitude")!;
                    }
                    if (PrefUtils.prefs!.containsKey("longitude")) {
                      _longitude = PrefUtils.prefs!.getString("longitude")!;
                    }
                    PrefUtils.prefs!.clear();
                    PrefUtils.prefs!.setBool('introduction', true);
                    PrefUtils.prefs!.setBool("welcomeSheet", true);
                    PrefUtils.prefs!.setString("branch", branch);
                    PrefUtils.prefs!.setString("tokenid", tokenId);
                    PrefUtils.prefs!.setString("ftokenid", _ftokenId);
                    PrefUtils.prefs!.setString("ismapfetch", _mapFetch);
                    PrefUtils.prefs!.setString(
                        "isdelivering", _isDelivering);
                    PrefUtils.prefs!.setString(
                        "defaultlocation", defaultLocation);
                    PrefUtils.prefs!.setString(
                        "deliverylocation", deliverylocation);
                    PrefUtils.prefs!.setBool("deliverystatus", deliverystatus);
                    PrefUtils.prefs!.setString("longitude", _longitude);
                    PrefUtils.prefs!.setString("latitude", _latitude);
                    IConstants.currentdeliverylocation.value = currentdeliverylocation;
                    Navigator.of(context).pop();
                    Navigation(context, name:Routename.SignUpScreen,navigatore: NavigatoreTyp.Push);
                  }
                },
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 25.0,
                    ),
                    Text(
                      S .of(context).log_out,
                      style: TextStyle(
                          fontSize: 15, color: ColorCodes.blackColor),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
