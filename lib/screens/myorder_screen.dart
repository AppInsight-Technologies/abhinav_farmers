import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import '../../constants/features.dart';
import 'package:velocity_x/velocity_x.dart';
import '../generated/l10n.dart';
import '../models/myordersfields.dart';
import '../rought_genrator.dart';
import '../widgets/simmers/order_screen_shimmer.dart';
import 'package:provider/provider.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../utils/ResponsiveLayout.dart';
import '../providers/myorderitems.dart';
import '../widgets/myorder_display.dart';
import '../assets/images.dart';
import '../assets/ColorCodes.dart';
import '../utils/prefUtils.dart';
import '../constants/IConstants.dart';

class MyorderScreen extends StatefulWidget {
  static const routeName = '/myorder-screen';
  String orderhistory  = "";
  Map<String,String>? myorder;

  MyorderScreen(Map<String, String> params){
    this.myorder= params;
    this.orderhistory = params["orderhistory"]??"" ;
  }
  @override
  _MyorderScreenState createState() => _MyorderScreenState();
}

class _MyorderScreenState extends State<MyorderScreen> with Navigations{
  var totalamount;
  var totlamount;
  var _isLoading = true;
  var _checkorders = false;
  MediaQueryData? queryData;
  double? wid;
  double? maxwid;
  bool iphonex = false;
  int startItem = 0;
  var myorderData;
  bool endOfProduct = false;
  var load = true;
  bool _isOnScroll = false;
  Map<String, List<MyordersFields>>? groupByDate;
  List<List<MyordersFields>> myorders =[] ;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      endOfProduct = false;
      load = true;
      _checkorders = false;
      startItem = 0;
      Provider.of<MyorderList>(context, listen: false).GetSplitorders(startItem.toString(),"initialy").then((_) async {
        setState(() {
          myorderData = Provider.of<MyorderList>(context, listen: false);
           groupByDate = groupBy(myorderData.items, (obj) => obj.reference_id!);
          groupByDate!.forEach((date, list) {
            // Group
            myorders.add(list);
            // day section divider
          });

          startItem = myorderData.items.length;
          if (myorderData.items.length <= 0) {
            _checkorders = false;
          } else {
            _checkorders = true;
          }
          _isLoading = false;
          load = false;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    wid= queryData!.size.width;
    maxwid=wid!*0.90;
    return WillPopScope(
      onWillPop: () {
        if(widget.orderhistory == "orderhistoryScreen"){
        if (Vx.isWeb ) {
          Navigation(context, navigatore: NavigatoreTyp.homenav);
        }
         else{
          Navigation(context, navigatore: NavigatoreTyp.homenav);
        }
        }else if(widget.orderhistory  == "web"){
          Navigation(context, navigatore: NavigatoreTyp.homenav);
        }else{
         if (Vx.isWeb ){
           Navigation(context, navigatore: NavigatoreTyp.homenav);
         }
         else{
           Navigation(context, navigatore: NavigatoreTyp.homenav);
         }
        }
        return Future.value(false);
      },
      child: Scaffold(
        appBar: ResponsiveLayout.isSmallScreen(context)
            ? gradientappbarmobile()
            : null,
        backgroundColor: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?ColorCodes.greyColord:ColorCodes.whiteColor,
        body: Column(
          children: <Widget>[
            if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
              Header(false),
              _body(),
          ],
        ),
      ),
    );
  }

  _body() {
    return _checkorders
        ? Flexible(
      fit: FlexFit.loose,
      child: NotificationListener<
          ScrollNotification>(
        // ignore: missing_return
        onNotification:
            (ScrollNotification scrollInfo) {
          if (!endOfProduct) if (!_isOnScroll && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            setState(() {
              _isOnScroll = true;
            });
            Provider.of<MyorderList>(context, listen: false).GetSplitorders(startItem.toString(), "scrolling").then((_) {
              setState(() {
                myorders.clear();
                myorderData = Provider.of<MyorderList>(context, listen: false);

                int enditem = myorderData.items.length;

                startItem = myorders.length +1;
                groupByDate = groupBy(myorderData.items, (obj) => obj.reference_id!);
                groupByDate!.forEach((date, list) {
                  myorders.add(list);
                });
                startItem = myorderData.items.length;
                if (myorders.length <= 0) {
                  _checkorders = false;
                } else {
                  _checkorders = true;
                }
                if (PrefUtils.prefs!
                    .getBool("endOfOrder")!) {
                  _isOnScroll = false;
                  endOfProduct = true;
                } else {
                  _isOnScroll = false;
                  endOfProduct = false;
                }
              });
            });
            setState(() {
              _isLoading = true;
            });
          }
          return true;
        },

        child: SingleChildScrollView(
              child: Container(
                  constraints: (Vx.isWeb &&
                      !ResponsiveLayout.isSmallScreen(context))
                      ? BoxConstraints(maxWidth: maxwid!)
                      : null,
                child: Column(
                  children: <Widget>[
                     if (myorderData.items.length > 0)
                      Column(
                            children: [
                              Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    padding: EdgeInsets.only(left:(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?0 : 0.0,right: (Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context)) ? 0 : 0.0),

                                    child: SizedBox(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        controller: new ScrollController(keepScrollOffset:false),
                                        itemCount: myorders.length,
                                        itemBuilder: (_, i) => MyorderDisplay( myorders[i]),
                                      ),
                                    ),
                                  ),
                                ),

                            ],
                          ),

                    if (endOfProduct)
                      Container(

                        decoration: BoxDecoration(
                          color: Colors.black12,
                        ),
                        margin: EdgeInsets.only(top: 10.0),
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Text(
                          S .of(context).thats_all, // "That's all folks!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),

                    if(!Vx.isWeb) Container(
                      height: _isOnScroll ? 50 : 0,
                      child: Center(
                        child: new CircularProgressIndicator(),
                      ),
                    ),

                    SizedBox(
                      height: 20.0,
                    ),
                    if (Vx.isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
                  ],
                ),
              ),
            ),
          )
    )
        : Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    constraints: (Vx.isWeb &&
                        !ResponsiveLayout.isSmallScreen(context))
                        ? BoxConstraints(maxWidth: maxwid!)
                        : null,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _isLoading
                      ? (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))? Center(
                          child:OrderScreenShimmer(),
                        ): Center(
                          child: OrderScreenShimmer(),
                        )
                        :
                        EmptyOrder(),
                        if (Vx.isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
                      ],
                    ),
                  ),
                ),
              );
  }

  Widget EmptyOrder() {
    return Column(
      children: [
        Image.asset(Images.myorderImg),
        Text(
          S .of(context).start_shopping,
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          S .of(context).lets_get_you_started,
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(
          height: 20.0,
        ),
        GestureDetector(
          onTap: () {
            Navigation(context, navigatore: NavigatoreTyp.homenav);
          },
          child: Container(
            width: 120.0,
            height: 40.0,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(3.0),
                border: Border(
                  top: BorderSide(
                      width: 1.0, color: Theme.of(context).primaryColor),
                  bottom: BorderSide(
                      width: 1.0, color: Theme.of(context).primaryColor),
                  left: BorderSide(
                      width: 1.0, color: Theme.of(context).primaryColor),
                  right: BorderSide(
                    width: 1.0,
                    color: Theme.of(context).primaryColor,
                  ),
                )),
            child: Center(
                child: Text(
                  S .of(context).start_shopping,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                )),
          ),
        ),
      ],
    );
  }

  gradientappbarmobile() {
    final routeArgs =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: (IConstants.isEnterprise)?0:1,
      leading: IconButton(
          icon: Icon(Icons.arrow_back, color: IConstants.isEnterprise && !Features.ismultivendor && !Features.isWebTrail?ColorCodes.menuColor:ColorCodes.iconColor),
          onPressed: () async {
            // this is the block you need
            if(widget.orderhistory  == "orderhistoryScreen"){
              if (Vx.isWeb ) {
                Navigation(context, navigatore: NavigatoreTyp.homenav);
              }
              else{
                Navigator.of(context).pop();
              }
            }else if(widget.orderhistory == "web"){
              Navigator.of(context).pop();
            }else{
              if (Vx.isWeb ){
                Navigation(context, navigatore: NavigatoreTyp.homenav);
              }
              else{
                Navigator.of(context).pop();
              }

            }
            return Future.value(false);
          }),
      titleSpacing: 0,
      title: Text(
        S .of(context).my_orders,
        style: TextStyle(color: ColorCodes.iconColor, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  ColorCodes.appbarColor,
                  ColorCodes.appbarColor2
                ])),
      ),
    );
  }
}
