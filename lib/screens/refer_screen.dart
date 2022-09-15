
import 'dart:io';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import '../../constants/features.dart';
import '../../models/VxModels/VxStore.dart';
import 'package:velocity_x/velocity_x.dart';
import '../generated/l10n.dart';
import '../rought_genrator.dart';
import '../widgets/simmers/loyality_wallet_shimmer.dart';

import '../assets/images.dart';

import '../assets/ColorCodes.dart';

import '../constants/IConstants.dart';
import '../providers/branditems.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReferEarn extends StatefulWidget {
  static const routeName = '/refer_screen';
  @override
  _ReferEarnState createState() => _ReferEarnState();
}

class _ReferEarnState extends State<ReferEarn> with Navigations  {
  var image;
  bool _loading = true;
  String referalCode = " ";
  String referalCount = " ";
  String referalEarning = " ";
  bool iphonex = false;
  bool _isWeb = false;
   Uri? dynamicUrl;
  GroceStore store = VxState.store;

  @override
  void initState() {
    super.initState();
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
      referalCode = store.userData.myref!;
      print("referal code..."+referalCode.toString());
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // referalCode= prefs.getString('myreffer');
    /*  List<Application> apps = await DeviceApps.getInstalledApplications(
          onlyAppsWithLaunchIntent: true, includeSystemApps: true);*/
      await Provider.of<BrandItemsList>(context,listen: false).ReferEarn().then((_) {
        final referData = Provider.of<BrandItemsList>(context,listen: false);
           image = referData.referEarn.imageUrl;
           referalCount = referData.referEarn.referral_count.toString();
           referalEarning = referData.referEarn.earning_amount.toString();
           setState(() {
             _loading =false;
           });
           print("refre count..."+referalCount.toString());
           print("refer earn"+referalEarning.toString());

      });
      createReferralLink(referalCode);
    });
  }
   showBottom(){
     return showModalBottomSheet(
         context: context,
         builder: (BuildContext context) {
           return SafeArea(
             child: Container(
               width: double.infinity,
               color: Colors.white,
               child: Column(
                 children: [
                   Text(
                       S .of(context).invite
                 //'Invite'
                 ),
                 ],
               ),
             ),
           );
        }
     );
  }
  Future<String> createReferralLink(String referralCode) async {
    final DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
      uriPrefix: 'https://gbay.page.link',
      link: Uri.parse('https://referandearn.com/refer?code=$referralCode'),
      androidParameters: AndroidParameters(
        packageName: IConstants.androidId,
      ),
      iosParameters: IOSParameters(
          bundleId: IConstants.androidId,
          appStoreId: IConstants.appleId
      )
      /* socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Refer A Friend',
        description: 'Refer and earn',
        imageUrl: Uri.parse(
            'https://www.insperity.com/wp-content/uploads/Referral-_Program1200x600.png'),
      ),*/
    );

    final ShortDynamicLink shortLink =
    await (await FirebaseDynamicLinks.instance).buildShortLink(dynamicLinkParameters);
    dynamicUrl = shortLink.shortUrl;
    debugPrint("refer..........earn.......");
    print(dynamicUrl);
    return dynamicUrl.toString();
  }

  @override
  Widget build(BuildContext context) {
    final referData = Provider.of<BrandItemsList>(context,listen: false);
    return Scaffold(
      backgroundColor: ColorCodes.whiteColor,
      appBar:AppBar(
        backgroundColor: ColorCodes.whiteColor,
        toolbarHeight: 55.0,
        elevation: (IConstants.isEnterprise)?0:1,
        automaticallyImplyLeading: false,
        leading: IconButton(icon: Icon(Icons.arrow_back,size: 20, color: ColorCodes.iconColor),onPressed: ()=>
            Navigator.of(context).pop()),
          title: Text(
            S .of(context).refer_earn,
            // "Refer And Earn",
            style: TextStyle(color: ColorCodes.iconColor, fontWeight: FontWeight.bold, fontSize: 18,
            ),
          ),
        ),
      body: _loading? Center(
        child: LoyalityorWalletShimmer(),
      ):
      SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40,),
              Container(
                padding: EdgeInsets.only(left: 15, right: 15, top: 30, bottom: 30),
                decoration: BoxDecoration(
                  color: ColorCodes.varcolor,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          referalCount.toString(),style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color:IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor),),
                        SizedBox(height: 10,),
                        Text(
                        S .of(context).referer_count
                          // "Referral count"
                              ,style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                      ],
                    ),
                    Spacer(),
                    Features.iscurrencyformatalign?
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                           double.parse(referalEarning.toString()).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + IConstants.currencyFormat ,style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor)),
                        SizedBox(height: 10,),
                        Text(
                            S .of(context).your_earning,
                                // "Your Earnings"
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                      ],
                    ):
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            IConstants.currencyFormat + " " + double.parse(referalEarning.toString()).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor)),
                        SizedBox(height: 10,),
                        Text(
                            S .of(context).your_earning
                            // "Your Earnings"
                            ,style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();

                  Navigation(context, name: Routename.Policy, navigatore: NavigatoreTyp.Push,parms: {"title":"Refer"/*, "body" :prefs.getString("refer").toString()*/});
                },
                child: Image.network(
                  image,
                  errorBuilder: (context, url, error) => Image.asset(Images.defaultSliderImg),
                  width: MediaQuery.of(context).size.width,
                //  fit: BoxFit.fill,
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  Share.share('Download ' +
                      IConstants.APP_NAME +
                      ' from Google Play Store and use my referral code ('+ referalCode +')'+" "+dynamicUrl.toString());
                },
                child: Container(
                  margin: EdgeInsets.only(left: 3, right: 3),
                  padding: EdgeInsets.only(left: 15, right: 15, top: 30, bottom: 30),
                  decoration: BoxDecoration(
                    color: ColorCodes.whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S .of(context).your_code
                            // "Referral count"
                            ,style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          Text(
                            referalCode
                            // "Referral count"
                            ,style: TextStyle(fontSize: 20, color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor, fontWeight: FontWeight.bold),),
                        ],
                      ),
                      Center(
                        child: Container(
                          height: 50,
                          width: 50,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: ColorCodes.varcolor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(Icons.share, color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor),
                        ),
                      )
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
      // bottomNavigationBar: _loading ? SizedBox.shrink() :
      // Padding(
      //     padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
      //     child:GestureDetector(
      //   onTap: (){
      //      Share.share('Download ' +
      //               IConstants.APP_NAME +
      //               ' from Google Play Store and use my referral code ('+ referalCode +')'+" "+dynamicUrl.toString());
      //   },
      //   child: Container(
      //     color: Theme.of(context).primaryColor,
      //     height: 60,
      //     width: MediaQuery.of(context).size.width,
      //     padding: EdgeInsets.symmetric(horizontal: 10),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         Center(child: RichText(
      //                   text: new TextSpan(
      //                     children: <TextSpan>[
      //                       new TextSpan(
      //                           text:S .of(context).your_code +": ",
      //                           // 'Your Code:  ',
      //                         style: TextStyle(
      //                           fontWeight: FontWeight.w600,
      //                             fontSize: 17, color: ColorCodes.whiteColor),
      //                           ),
      //                       new TextSpan(
      //                           text: referalCode ,
      //                         style: TextStyle(
      //                             fontWeight: FontWeight.bold,
      //                             fontSize: 18, color: ColorCodes.whiteColor ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),),
      //         Center(
      //           child: Container(
      //             height: 30,
      //             width: 70,
      //             decoration: BoxDecoration(
      //               color: Colors.white,
      //               borderRadius: BorderRadius.circular(6),
      //             ),
      //             child: Center(child: Text(
      //              S .of(context).invite,
      //               // 'Invite',
      //               style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor),)),
      //           ),
      //         )
      //       ],
      //     ),
      //   ),
      // ),
      // ),
    );
  }
}
