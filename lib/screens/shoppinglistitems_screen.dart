import 'package:grocbay/constants/features.dart';

import '../controller/mutations/cart_mutation.dart';
import '../models/VxModels/VxStore.dart';
import '../models/newmodle/product_data.dart';
import '../repository/fetchdata/shopping_list.dart';
import '../rought_genrator.dart';
import '../widgets/bottom_navigation.dart';
import '../components/sellingitem_component.dart';
import 'package:velocity_x/velocity_x.dart';

import '../generated/l10n.dart';

import '../widgets/simmers/item_list_shimmer.dart';

import '../constants/IConstants.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/branditems.dart';
import '../screens/cart_screen.dart';
import '../data/calculations.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../assets/ColorCodes.dart';
import '../utils/ResponsiveLayout.dart';
import '../utils/prefUtils.dart';
import 'shoppinglist_screen.dart';

class ShoppinglistitemsScreen extends StatefulWidget {
  static const routeName = '/shoppinglistitems-screen';
  Map<String,String> shoppinglistdata;
  ShoppinglistitemsScreen(this.shoppinglistdata);

  @override
  ShoppinglistitemsScreenState createState() => ShoppinglistitemsScreenState();
}

class ShoppinglistitemsScreenState extends State<ShoppinglistitemsScreen> with Navigations{
  bool _checkmembership = false;
  bool _isLoading = true;
  //SharedPreferences prefs;
  bool _isWeb = false;
  String shoppinglistname="";
  String id="";
  late ScrollController controller;
  late MediaQueryData queryData;
  late double wid;
  late double maxwid;
  bool iphonex = false;
  late Future<List<ItemData>> _future;
  var itemsData=[];
  @override
  void initState() {

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
      final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      id = widget.shoppinglistdata['id']!;
      ShoppingList().get(id).then((value) {
        setState(() {
          _future = Future.value(value);
          _isLoading = false;
        });
      });
      if (PrefUtils.prefs!.getString("membership") == "1") {
        _checkmembership = true;
      } else {
        _checkmembership = false;
      }


    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    id = widget.shoppinglistdata['id']!;
    shoppinglistname = widget.shoppinglistdata['name']!;


    return WillPopScope(
      onWillPop: (){
        _isWeb ?
        Navigation(context, name: Routename.Shoppinglist, navigatore: NavigatoreTyp.Push)
            :
        Navigator.of(context).pop();
        return Future.value(false);
      },
      child: Scaffold(
        appBar: ResponsiveLayout.isSmallScreen(context) ?
        gradientappbarmobile() : null,
        backgroundColor: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?ColorCodes.whiteColor :null,
        body: _isLoading ? _isWeb?Center(
          child: CircularProgressIndicator(),
        ):ItemListShimmer()
            :
        _body(),
        bottomNavigationBar:  _isWeb ? SizedBox.shrink() :Padding(
          padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
          child:_buildBottomNavigationBar(),
        ),
      ),
    );
  }
  _buildBottomNavigationBar() {
    return VxBuilder(
      mutations: {SetCartItem},
      // valueListenable: Hive.box<Product>(productBoxName).listenable(),
      builder: (context, store, index) {
        final box = (VxState.store as GroceStore).CartItemList;
        if (box.isEmpty) return SizedBox.shrink();
        return BottomNaviagation(
          itemCount: CartCalculations.itemCount.toString() + " " + S .of(context).items,
          title: S .current.view_cart,
          total: _checkmembership ? (IConstants.numberFormat == "1")
              ?(CartCalculations.totalMember).toStringAsFixed(0):(CartCalculations.totalMember).toStringAsFixed(IConstants.decimaldigit)
              :
          (IConstants.numberFormat == "1")
              ?(CartCalculations.total).toStringAsFixed(0):(CartCalculations.total).toStringAsFixed(IConstants.decimaldigit),
          onPressed: (){
            setState(() {
              Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
            });
          },
        );
      },
    );
  }

  _body(){

    double deviceWidth = MediaQuery.of(context).size.width;
    int widgetsInRow =(_isWeb && !ResponsiveLayout.isSmallScreen(context))?2:1;

    if (deviceWidth > 1200) {
      widgetsInRow = (_isWeb && !ResponsiveLayout.isSmallScreen(context))?5:1;
    }
    else if (deviceWidth > 768) {
      widgetsInRow = (_isWeb && !ResponsiveLayout.isSmallScreen(context))?3:1;
    }
    double aspectRatio =(_isWeb && !ResponsiveLayout.isSmallScreen(context))?
     (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 380:
        (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 170;
    queryData = MediaQuery.of(context);
    wid= queryData.size.width;
    maxwid=wid*0.90;
    return  SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
              Header(false),
            FutureBuilder<List<ItemData>>(
              future: _future,
              builder: (BuildContext context,AsyncSnapshot<List<ItemData>> snapshot){
                if(snapshot.data!=null)
                 itemsData = snapshot.data!;

                if(itemsData.isNotEmpty)
                return Expanded(
                  child: _isWeb?
                  SingleChildScrollView(
                      child:
                      Column(
                        children: [
                          Container(
                            constraints: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid):null,
                            height: _isWeb?MediaQuery.of(context).size.height*0.60
                                :MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            color: ColorCodes.whiteColor,
                            child: new GridView.builder(
                                itemCount: itemsData.length,
                                shrinkWrap: true,
                                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: widgetsInRow,
                                  crossAxisSpacing: 2,
                                  childAspectRatio: aspectRatio,
                                  mainAxisSpacing: 2,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  return SellingItemsv2(
                                    fromScreen: "shoppinglistitem_screen",
                                    seeallpress: "",
                                    itemdata: itemsData[index],
                                    notid: "",
                                  ) ;
                                }),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          //footer
                          if(_isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
                        ],
                      )
                  ) : Container(
                    width: MediaQuery.of(context).size.width,
                    color: ColorCodes.searchwebbackground,
                    child:  GridView.builder(
                        shrinkWrap: true,
                        itemCount: itemsData.length,
                        controller: new ScrollController(
                            keepScrollOffset: false),
                        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: widgetsInRow,
                          crossAxisSpacing: 2,
                          childAspectRatio: aspectRatio,
                          mainAxisSpacing: 2,
                        ),


                        itemBuilder: (BuildContext context, int index) {
                          return SellingItemsv2(
                            fromScreen: "shoppinglistitem_screen",
                            seeallpress: "",
                            itemdata: itemsData[index],
                            notid: "",
                          ) ;
                        }),
                  ),
                );
                else return SizedBox.shrink();
              },
            ),
          ],));
  }

  gradientappbarmobile() {
    return  AppBar(
      brightness: Brightness.dark,
      toolbarHeight: 60.0,
      elevation: (IConstants.isEnterprise)?0:1,
      automaticallyImplyLeading: false,
      leading: IconButton(icon: Icon(Icons.arrow_back, color: ColorCodes.iconColor),onPressed: ()=>Navigator.of(context).pop(),),
      title: Text(shoppinglistname,
        style: TextStyle(color: ColorCodes.iconColor,fontWeight: FontWeight.bold, fontSize: 18),),

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
}