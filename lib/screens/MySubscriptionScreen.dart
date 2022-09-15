import 'dart:io';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../constants/features.dart';
import '../../controller/mutations/UpcomingSubscription_mutation.dart';
import '../../models/newmodle/subscription_data.dart';
import '../../rought_genrator.dart';
import '../../widgets/upcomingsubscription_display.dart';
import 'package:velocity_x/velocity_x.dart';
import '../generated/l10n.dart';
import '../models/VxModels/VxStore.dart';
import '../models/newmodle/SubscriptionPromoplan.dart';
import '../models/newmodle/upcomingsubscription.dart';
import '../widgets/simmers/loyality_wallet_shimmer.dart';
import '../widgets/simmers/order_screen_shimmer.dart';
import '../assets/ColorCodes.dart';
import '../assets/images.dart';

import '../constants/IConstants.dart';
import '../providers/myorderitems.dart';
import '../screens/home_screen.dart';

import '../utils/ResponsiveLayout.dart';
import '../utils/prefUtils.dart';
import '../widgets/footer.dart';

import '../widgets/header.dart';
import '../widgets/mysubscription_display.dart';
import 'package:provider/provider.dart';


class MySubscriptionScreen extends StatefulWidget {
  static const routeName = '/mysubscription-screen';
  @override
  _MySubscriptionScreenState createState() => _MySubscriptionScreenState();
}

class _MySubscriptionScreenState extends State<MySubscriptionScreen> with Navigations{

  var totalamount;
  var totlamount;
  var _isLoading = true;
  bool _isUpcomingLoading = true;
  var _checkorders = false;
  var _checkupcomingorders = false;
  var _isWeb= false;
  int _selectedIndex = 0;
 // var subscriptiondate;
  List<UpcomingSubscription> subscriptiondate=[];


  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      try {
        if (Platform.isIOS) {
          setState(() {
            _isWeb = false;

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
      Provider.of<MyorderList>(context, listen: false).GetSubscriptionorders().then((_) async {
       debugPrint("GetSubscriptionorders...");
        setState(() {
          debugPrint("GetSubscriptionorders.. loading....");
          _isLoading = false;
        });
      });

      if(Features.issubscriptionbox)
        UpcomingSunscriptionController(user: !(PrefUtils.prefs!.containsKey("apikey")) ? PrefUtils.prefs!
            .getString("tokenid") ! : PrefUtils.prefs!.getString('apikey')!,languageid: IConstants.languageId, branch: PrefUtils.prefs!.getString("branch"),ref: IConstants.refIdForMultiVendor.toString());
      /*Provider.of<MyorderList>(context, listen: false).GetUpcomingSubscriptionorders().then((_) async {
        debugPrint("GetSubscriptionorders...");
        setState(() {
          debugPrint("GetSubscriptionorders.. loading....");
         // _isLoading = false;
        });
      });*/
    });

    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    gradientappbarmobile() {
      return  AppBar(
        brightness: Brightness.dark,
        toolbarHeight: 60.0,
        backgroundColor: ColorCodes.whiteColor,
        elevation: (IConstants.isEnterprise)?0:1,

        automaticallyImplyLeading: false,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: ColorCodes.iconColor),onPressed: () {
          SchedulerBinding.instance?.addPostFrameCallback((_) {
           /* Navigator.of(context).pushNamedAndRemoveUntil(
                '/home-screen', (Route<dynamic> route) => false);*/
            Navigation(context, navigatore: NavigatoreTyp.homenav);
          });
        } ),
        title: Text(S .of(context).my_subscription,//'My Subscription',
          style: TextStyle(color: ColorCodes.iconColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        titleSpacing: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    ColorCodes.appbarColor,
                    ColorCodes.appbarColor2
                  ]
              )
          ),
        ),
      );
    }

    return  WillPopScope(
      onWillPop: () { // this is the block you need
        Navigation(context, navigatore: NavigatoreTyp.homenav);
        return Future.value(false);

      },
      child: Scaffold(
        appBar: ResponsiveLayout.isSmallScreen(context) ?
        gradientappbarmobile() : null,
        backgroundColor: ColorCodes.whiteColor,
            //.of(context)
           // .backgroundColor,
        body:  SingleChildScrollView(
          child: Column(
            children: <Widget>[
              if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
                Header(false),
              Features.issubscriptionbox?
              _bodyUpcomingSubscription():
              _body(),
            ],
          ),
        ),
        //),
      ),
    );

  }
  _bodyUpcomingSubscription(){
   return Column(
     children: [
       Padding(
         padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
         child: Row(
           children: [
             GestureDetector(
               onTap: (){
                 setState(() {
                   _selectedIndex = 0;
                 });
               },
               child: Container(
                 width: MediaQuery.of(context).size.width/2.3,
                 height: 40,
                 padding: EdgeInsets.only(left: 0.0, top: 5.0, right: 5.0, bottom: 5.0),
                 margin: EdgeInsets.only(left: 0.0, top: 5.0, right: 0.0, bottom: 5.0),
                 decoration: new BoxDecoration(
                     color: _selectedIndex == 0 ? ColorCodes.varcolor:ColorCodes.whiteColor,
                     border: Border.all(color: _selectedIndex == 0 ? ColorCodes.varcolor:ColorCodes.whiteColor),
                     borderRadius: new BorderRadius.all(
                       const Radius.circular(0.0),)),
                 child: Center(
                   child: Text(S.of(context).upcoming_order,
                     maxLines: 2,
                     style:
                     TextStyle(
                         color: _selectedIndex == 0 ? ColorCodes.primaryColor:ColorCodes.blackColor,
                         fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 13 : 15, fontWeight: FontWeight.bold),
                   ),
                 ),
               ),
             ),
             Spacer(),
             GestureDetector(
               onTap: (){
                 setState(() {
                   _selectedIndex = 1;
                 });
               },
               child: Container(
                 height: 40,
                 width: MediaQuery.of(context).size.width/2.3,
                 padding: EdgeInsets.only(left: 0.0, top: 5.0, right: 5.0, bottom: 5.0),
                 margin: EdgeInsets.only(left: 0.0, top: 5.0, right: 0.0, bottom: 5.0),
                 decoration: new BoxDecoration(
                     color:_selectedIndex == 1 ? ColorCodes.varcolor:ColorCodes.whiteColor,
                     border: Border.all(color: _selectedIndex == 1 ? ColorCodes.varcolor:ColorCodes.whiteColor),
                     borderRadius: new BorderRadius.all(
                       const Radius.circular(0.0),)),
                 child: Center(
                   child: Text(S.of(context).active_subscription,
                     maxLines: 2,
                     style:
                     TextStyle(
                         color: _selectedIndex == 1? ColorCodes.stepperColor:ColorCodes.blackColor,
                         fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 13 : 15, fontWeight: FontWeight.bold),
                   ),
                 ),
               ),
             ),
           ],
         ),
       ),

       (_selectedIndex == 0)?
       VxBuilder(
           mutations: {UpcomingSunscriptionController},
           builder: (ctx,store,VxStatus? state) {
             if (VxStatus.success == state){
               _isUpcomingLoading = false;
               return loaddescriptionBox();}
             else if (state == VxStatus.none) {
               if ((VxState.store as GroceStore)
                   .subscriptionBoxData.toJson().isEmpty) {
                 _isUpcomingLoading = false;
                 UpcomingSunscriptionController(user: !(PrefUtils.prefs!.containsKey("apikey")) ? PrefUtils.prefs!
                     .getString("tokenid") ! : PrefUtils.prefs!.getString('apikey')!,languageid: IConstants.languageId, branch: PrefUtils.prefs!.getString("branch"),ref: IConstants.refIdForMultiVendor.toString());

                 return (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
                     ? OrderScreenShimmer(): OrderScreenShimmer();

               }
               else {
                 //_isUpcomingLoading = false;
                 return loaddescriptionBox();
               }

             }
             return (Vx.isWeb &&
                 !ResponsiveLayout.isSmallScreen(context))
                 ? OrderScreenShimmer() : OrderScreenShimmer();
           }):
           Container(
             width: MediaQuery.of(context).size.width,
             child: _body(),
           ),
     ],
   );

  }
  loaddescriptionBox(){
    subscriptiondate = (VxState.store as GroceStore).upcomingsubscriptionlist;
    return _isUpcomingLoading?
        OrderScreenShimmer()
    :
    subscriptiondate.length <= 0?
        EmptyOrder():

    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
           // scrollDirection: Axis.vertical,
            controller: new ScrollController(keepScrollOffset: false),
            itemCount: subscriptiondate.length,
            itemBuilder: (_, i) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0,top: 10,left: 5),
                    child: Text(subscriptiondate[i].date!,
                      maxLines: 2,
                      style:
                      TextStyle(
                          color: ColorCodes.blackColor,
                          fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 13 : 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    //scrollDirection: Axis.vertical,
                    controller: new ScrollController(keepScrollOffset: false),
                    itemCount: subscriptiondate[i].data!.length,
                    itemBuilder: (_, j) {
                      return UpcomingSubscriptionDisplay(
                        subscriptiondate[i].data![j].itemName!,
                        subscriptiondate[i].data![j].itemFeaturedImage!,
                        subscriptiondate[i].data![j].quantity!,
                        subscriptiondate[i].data![j].type == "1"?
                        subscriptiondate[i].data![j].unit! :
                        subscriptiondate[i].data![j].priceVariation![0].unit!
                      );
                    },
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top:10.0,left: 5),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: 10, right: 10, bottom: 10),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: ColorCodes.primaryColor)

                          ),
                          // color: Theme.of(context).buttonColor),
                          child: GestureDetector(
                            onTap: () {
                            },
                            child:
                            Icon(Icons.add, color: ColorCodes.primaryColor,),
                          ),
                        ),
                        Text(S.of(context).add_item,
                          maxLines: 2,
                          style:
                          TextStyle(
                              color: ColorCodes.primaryColor,
                              fontSize: ResponsiveLayout.isSmallScreen(context) ? 15 : ResponsiveLayout.isMediumScreen(context) ? 15 : 15, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),

                ],
              );
            },
          ),

        ],
      ),
    );
  }
  _body(){
    final mysubscriptionData = Provider.of<MyorderList>(context, listen: false);
    if (mysubscriptionData.itemssub.length <= 0) {
      _checkorders = false;
    } else {
      _checkorders = true;
    }

    return _checkorders
        ? SingleChildScrollView(
          child: Column(
            children: <Widget>[
              if (mysubscriptionData.itemssub.length>0)
                _isLoading
                    ?  Center(
                  child: OrderScreenShimmer(),
                )
                    :
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    color: Colors.white,
                    //  constraints: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid):null,
                    padding: EdgeInsets.only(left:(_isWeb && !ResponsiveLayout.isSmallScreen(context))?18 : 0.0,right: (_isWeb&& !ResponsiveLayout.isSmallScreen(context)) ? 18 : 0.0),
                    child: SizedBox(
                      child: ListView.separated(
                          separatorBuilder: (context, index) => SizedBox(height: 5,) ,/*Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                            child: DottedLine(
                                dashColor: ColorCodes.lightgrey,
                                lineThickness: 1.0,
                                dashLength: 2.0,
                                dashRadius: 0.0,
                                dashGapLength: 1.0),
                          ),*/
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: mysubscriptionData.itemssub.length,
                        itemBuilder: (_, i)
                        {
                          debugPrint("variation name..."+mysubscriptionData.itemssub[i].variation_name.toString());
                                           return Column(
                                              children: [
                                                MysubscriptionDisply(
                                                    mysubscriptionData
                                                        .itemssub[i].subid!,
                                                    mysubscriptionData
                                                        .itemssub[i].userid!,
                                                    mysubscriptionData
                                                        .itemssub[i].varid!,
                                                    mysubscriptionData
                                                        .itemssub[i].createdtime!,
                                                    mysubscriptionData
                                                        .itemssub[i].quantity!,
                                                    mysubscriptionData
                                                        .itemssub[i].delivery!,
                                                    mysubscriptionData
                                                        .itemssub[i].startdate!,
                                                    mysubscriptionData
                                                        .itemssub[i].enddate!,
                                                    mysubscriptionData
                                                        .itemssub[i].addres!,
                                                    mysubscriptionData
                                                        .itemssub[i].addressid!,
                                                    mysubscriptionData
                                                        .itemssub[i].addresstype!,
                                                    mysubscriptionData
                                                        .itemssub[i].amount!,
                                                    mysubscriptionData
                                                        .itemssub[i].branch!,
                                                    mysubscriptionData
                                                        .itemssub[i].slot!,
                                                    mysubscriptionData
                                                        .itemssub[i].paymenttype!,
                                                    mysubscriptionData
                                                        .itemssub[i].crontime!,
                                                    mysubscriptionData
                                                        .itemssub[i].status!,
                                                    mysubscriptionData
                                                        .itemssub[i].channel!,
                                                    mysubscriptionData
                                                        .itemssub[i].type!,
                                                    mysubscriptionData
                                                        .itemssub[i].name!,
                                                    mysubscriptionData
                                                        .itemssub[i].image!,
                                                    mysubscriptionData.itemssub[i]
                                                        .variation_name!),

                                              ],
                                            );
                                          }),
                    ),
                  ),
                ),
              SizedBox(
                height: 40.0,
              ),
              if (_isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
            ],
          ),
        )
        : SingleChildScrollView(
          child: Container(
            color: ColorCodes.whiteColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _isLoading
                    ? Center(
                  child: OrderScreenShimmer(),
                )
                    :
                EmptyOrder(),
                if (_isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
              ],
            ),
          ),

        );

  }

  Widget EmptyOrder() {
    return Container(
      color: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?Colors.white:null,
        height:MediaQuery.of(context).size.height/1.5,
      child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 100,),
            Image.asset(Images.myorderImg),
            Text(S .of(context).no_active_subscription_yet,//"No active subscription yet",
              style: TextStyle(fontSize: 16.0),),
            SizedBox(height: 10.0,),
            Text(S .of(context).start_subscription_doorstep,//"Start a subscription now to get grocery deliveries to your doorstep.",
              maxLines:2 ,style: TextStyle(fontSize: 12,color: Colors.grey),),
            SizedBox(height: 20.0,),
            GestureDetector(
              onTap: () {
             //   Navigation(context, navigatore: NavigatoreTyp.homenav);
                Navigation(context, navigatore: NavigatoreTyp.Push,name: Routename.search);
                //Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
              },
              child: Container(
                width: 120.0,
                height: 40.0,
                decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(3.0),
                    border: Border(
                      top: BorderSide(width: 1.0, color: Theme.of(context).primaryColor),
                      bottom: BorderSide(width: 1.0, color: Theme.of(context).primaryColor),
                      left: BorderSide(width: 1.0, color: Theme.of(context).primaryColor),
                      right: BorderSide(width: 1.0, color: Theme.of(context).primaryColor,),
                    )),
                child: Center(
                    child: Text(S .of(context).start_subscription,//'Start Subscription',
                      textAlign: TextAlign.center, style: TextStyle(color: Colors.white),)),
              ),
            ),
          ],
        ),
    );

  }
}
