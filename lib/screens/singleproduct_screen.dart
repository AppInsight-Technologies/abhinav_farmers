// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:getflutter/components/carousel/gf_carousel.dart';
// import 'package:grocbay/helper/custome_checker.dart';
// import 'package:grocbay/models/SellingItemsModle.dart';
// import 'package:grocbay/models/sellingitemsfields.dart';
// import '../../screens/banner_product_screen.dart';
// import '../controller/mutations/cart_mutation.dart';
// import '../models/VxModels/VxStore.dart';
// import '../models/newmodle/cartModle.dart';
// import '../models/newmodle/product_data.dart' as pm;
// import '../repository/productandCategory/category_or_product.dart';
// import '../components/ItemList/item_component.dart';
// import '../components/login_web.dart';
// import '../rought_genrator.dart';
// import '../widgets/simmers/singel_item_of_list_shimmer.dart';
// import 'package:velocity_x/velocity_x.dart';
// import '../generated/l10n.dart';
// import '../components/varint_widget.dart';
// import '../screens/items_screen.dart';
// import '../screens/sellingitem_screen.dart';
// import '../screens/signup_selection_screen.dart';
// import '../screens/subscribe_screen.dart';
// import 'package:intl/intl.dart';
//
// import '../services/firebaseAnaliticsService.dart';
// import '../widgets/simmers/singel_item_screen_shimmer.dart';
// import 'dart:io';
// import 'package:share/share.dart';
// import 'package:provider/provider.dart';
// import 'package:readmore/readmore.dart';
//
// import '../screens/singleproductimage_screen.dart';
// import '../screens/cart_screen.dart';
// import '../screens/membership_screen.dart';
// import '../screens/searchitem_screen.dart';
// import '../providers/itemslist.dart';
// import '../providers/sellingitems.dart';
// import '../providers/branditems.dart';
// import '../constants/IConstants.dart';
// import '../widgets/badge_ofstock.dart';
// import '../data/calculations.dart';
// import '../widgets/badge.dart';
// import '../assets/images.dart';
// import '../widgets/header.dart';
// import '../utils/prefUtils.dart';
// import '../screens/home_screen.dart';
// import '../constants/features.dart';
// import '../assets/ColorCodes.dart';
// import '../data/hiveDB.dart';
// import '../utils/ResponsiveLayout.dart';
// import '../widgets/badge_discount.dart';
// import '../widgets/footer.dart';
// import 'dart:async';
// import 'package:flutter/services.dart';
// import 'brands_screen.dart';
//
// class SingleproductScreen extends StatefulWidget {
//   static const routeName = '/singleproduct-screen';
//
//   @override
//   _SingleproductScreenState createState() => _SingleproductScreenState();
// }
//
// class _SingleproductScreenState extends State<SingleproductScreen>
//     with TickerProviderStateMixin,Navigations {
//   bool _isLoading = true;
//   var singleitemData;
//   List<SellingItemsFields> singleitemvar =[];
//   var multiimage=[];
//   List<pm.ImageDate> varimage=[];
//   bool _isWeb = false;
//   bool _isIOS = false;
//   bool _checkmembership = false;
//   var _checkmargin = true;
//   var margins;
//   bool _isStock = false;
//   var shoplistData;
//   String dropdownValue = 'One';
//
//   late String varmemberprice;
//   late String varprice;
//   late double weight;
//   late double netWeight;
//   late String salePrice;
//   late String varmrp;
//   late String varid;
//   late String varname;
//   late String unit;
//   late String varstock;
//   late String varminitem;
//   late String varmaxitem;
//   late int varLoyalty;
//   late String type;
//   late String veg_type;
//   late int _varQty;
//   late bool discountDisplay;
//   late bool memberpriceDisplay;
//   late Color varcolor;
//   String itemname = "";
//   late String itemimg;
//   String itemdescription = "";
//   String itemmanufact = "";
//   bool _isdescription = false;
//   bool _ismanufacturer = false;
//   String _displayimg = "";
//   bool _similarProduct = false;
//   final _form = GlobalKey<FormState>();
//   late List<String> _varMarginList = <String>[];
//   final _key = GlobalKey<FormState>();
//
//   late List<Tab> tabList = [];
//   late TabController _tabController;
//
//   late MediaQueryData queryData;
//   late double wid;
//   late double maxwid;
//   bool _isAddToCart = false;
//   bool iphonex = false;
//   var currentDate;
//   bool _isNotify = false;
//   var itemid;
//   var fromScreen;
//   var seeallpress;
//   var notificationFor;
//   bool checkskip = false;
//   var mobilenum = "";
//   String phone = "";
//   String apple = "";
//   String email = "";
//   String mobile = "";
//   String tokenid = "";
//   String photourl = "";
//   int unreadCount = 0;
//   late StreamController<int> _events;
//   String ea = "";
//   var addressitemsData;
//   var deliveryslotData;
//   var delChargeData;
//   var timeslotsData;
//   var timeslotsindex = "0";
//   var otpvalue = "";
//
//   late String otp1, otp2, otp3, otp4;
//
//   var day, date, time = "10 AM - 1 PM";
//   var addtype;
//   var address;
//   late IconData addressicon;
//   late DateTime pickedDate;
//   GroceStore store = VxState.store;
//
//   late Future<ItemModle> _preduct;
//
//   List<CartItem> productBox = [];
//   int _groupValue = 0;
//
//   @override
//   void initState() {
//     _events = new StreamController<int>.broadcast();
//     _events.add(30);
//     productBox =(VxState.store as GroceStore).CartItemList;
//     if (_isdescription)
//       tabList.add(new Tab(
//         text: 'Description',
//       ));
//     if (_ismanufacturer)
//       tabList.add(new Tab(
//         text: 'Manufacturer Details',
//       ));
//     _tabController = new TabController(
//       vsync: this,
//       length: tabList.length,
//     );
//     Future.delayed(Duration.zero, () async {
//       try {
//         if (Platform.isIOS) {
//           setState(() {
//             _isWeb = false;
//             _isIOS = true;
//             iphonex = MediaQuery.of(context).size.height >= 812.0;
//           });
//         } else {
//           setState(() {
//             _isWeb = false;
//           });
//         }
//       } catch (e) {
//         setState(() {
//           _isWeb = true;
//         });
//       }
//       checkskip = !PrefUtils.prefs!.containsKey('apikey');
//
//       Provider.of<BrandItemsList>(context, listen: false).fetchShoppinglist().then((value) {
//         final shoplistData = Provider.of<BrandItemsList>(context, listen: false);
//       });
//       setState(() {
//         if(PrefUtils.prefs!.getString("membership") == "1"){
//           _checkmembership = true;
//         } else {
//           _checkmembership = false;
//           for (int i = 0; i < productBox.length; i++) {
//             if (productBox[i].mode == "1") {
//               _checkmembership = true;
//             }
//           }
//         }
//       });
//
//       final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//        itemid = routeArgs['itemid'];
//        fromScreen = routeArgs['fromScreen'];
//        seeallpress=routeArgs['seeallpress'];
//         notificationFor = routeArgs['notificationFor'];
//       _preduct = ProductRepo().getRecentProduct(routeArgs['itemid'].toString());
//       await Provider.of<ItemsList>(context, listen: false).fetchSingleItems(itemid,notificationFor).then((_) {
//         setState(() {
//
//           Provider.of<SellingItemsList>(context, listen: false)fetchSingleItems
//               .fetchNewItems(routeArgs['itemid'].toString())
//               .then((_) {
//                 setState(() {
//               _isLoading = false;
//               singleitemData = Provider.of<ItemsList>(context, listen: false);
//               singleitemvar = Provider.of<ItemsList>(context, listen: false).findByIdsingleitems(itemid,notificationFor);
//               varmemberprice = singleitemvar[0].varmemberprice!;
//               varmrp = singleitemvar[0].varmrp!;
//               fas.LogItemSelected(contentType: singleitemvar[0].varname!, itemId: routeArgs['itemid']);
//               varprice = singleitemvar[0].varprice!;
//               varid = singleitemvar[0].varid!;
//               varname = singleitemvar[0].varname!;
//               unit=singleitemvar[0].unit!;
//               weight=singleitemvar[0].weight!;
//               netWeight=singleitemvar[0].netWeight!;
//               varstock = singleitemvar[0].varstock!;
//               varminitem = singleitemvar[0].varminitem!;
//               varmaxitem = singleitemvar[0].varmaxitem!;
//               varLoyalty = singleitemvar[0].varLoyalty!;
//               _varQty = singleitemvar[0].varQty;
//               varcolor = singleitemvar[0].varcolor!;
//               discountDisplay = singleitemvar[0].discountDisplay!;
//               memberpriceDisplay = singleitemvar[0].membershipDisplay!;
//
//               /*if (varmemberprice == '-' || varmemberprice == "0") {
//                 setState(() {
//                   membershipdisplay = false;
//                 });
//               } else {
//                 membershipdisplay = true;
//               }*/
//
//               for(int i = 0; i < singleitemvar.length; i ++) {
//                 if (_checkmembership) {
//                   if (singleitemvar[i].varmemberprice.toString() == '-' || double.parse(singleitemvar[i].varmemberprice!) <= 0) {
//                     if (double.parse(singleitemvar[i].varmrp!) <= 0 ||
//                         double.parse(singleitemvar[i].varprice!) <= 0) {
//                       _varMarginList.add("0");
//                     } else {
//                       var difference = (double.parse(singleitemvar[i].varmrp!) - double.parse(singleitemvar[i].varprice!));
//                       var profit = difference / double.parse(singleitemvar[i].varmrp!);
//                       var margins;
//                       margins = profit * 100;
//
//                       //discount price rounding
//                       margins = num.parse(margins.toStringAsFixed(0));
//                       _varMarginList.add(margins.toString());
//                     }
//                   } else {
//                     var difference =
//                     (double.parse(singleitemvar[i].varmrp!) - double.parse(singleitemvar[i].varmemberprice!));
//                     var profit = difference / double.parse(singleitemvar[i].varmrp!);
//                     var margins;
//                     margins = profit * 100;
//
//                     //discount price rounding
//                     margins = num.parse(margins.toStringAsFixed(0));
//                     _varMarginList.add(margins.toString());
//                   }
//                 } else {
//                   if (double.parse(singleitemvar[i].varmrp!) <= 0 || double.parse(singleitemvar[i].varprice!) <= 0) {
//                     margins = "0";
//                   } else {
//                     var difference =
//                     (double.parse(singleitemvar[i].varmrp!) - double.parse(singleitemvar[i].varprice!));
//                     var profit = difference / double.parse(singleitemvar[i].varmrp!);
//                     var margins;
//                     margins = profit * 100;
//
//                     //discount price rounding
//                     margins = num.parse(margins.toStringAsFixed(0));
//                     _varMarginList.add(margins.toString());
//                   }
//                 }
//               }
//
//               if (_checkmembership) {
//                 if (varmemberprice.toString() == '-' ||
//                     double.parse(varmemberprice) <= 0) {
//                   if (double.parse(varmrp) <= 0 ||
//                       double.parse(varprice) <= 0) {
//                     margins = "0";
//                   } else {
//                     var difference =
//                     (double.parse(varmrp) - double.parse(varprice));
//                     var profit = difference / double.parse(varmrp);
//                     margins = profit * 100;
//
//                     //discount price rounding
//                     margins = num.parse(margins.toStringAsFixed(0));
//                     margins = margins.toString();
//                   }
//                 } else {
//                   var difference =
//                   (double.parse(varmrp) - double.parse(varmemberprice));
//                   var profit = difference / double.parse(varmrp);
//                   margins = profit * 100;
//
//                   //discount price rounding
//                   margins = num.parse(margins.toStringAsFixed(0));
//                   margins = margins.toString();
//                 }
//               } else {
//
//                 if (double.parse(varmrp) <= 0 || double.parse(varprice) <= 0) {
//                   margins = "0";
//                 } else {
//                   var difference =
//                   (double.parse(varmrp) - double.parse(varprice));
//                   var profit = difference / double.parse(varmrp);
//                   margins = profit * 100;
//
//                   //discount price rounding
//                   margins = num.parse(margins.toStringAsFixed(0));
//                   margins = margins.toString();
//                 }
//               }
//
//               /*              if(double.parse(varprice) <= 0 || varprice.toString() == "" || double.parse(varprice) == double.parse(varmrp)){
//                 discountedPriceDisplay = false;
//               } else {
//                 discountedPriceDisplay = true;
//               }*/
//
//               if (margins == "NaN") {
//                 _checkmargin = false;
//               } else {
//                 if (int.parse(margins) <= 0) {
//                   _checkmargin = false;
//                 } else {
//                   _checkmargin = true;
//                 }
//               }
//
//               if (int.parse(varstock) <= 0) {
//                 _isStock = false;
//               } else {
//                 _isStock = true;
//               }
//
//               itemname = singleitemData.singleitems[0].title;
//               itemimg = singleitemData.singleitems[0].imageUrl;
//               veg_type = singleitemData.singleitems[0].veg_type;
//               type = singleitemData.singleitems[0].type;
//               salePrice = singleitemData.singleitems[0].salePrice;
//
//               if (singleitemData.singleitems[0].description.toString() != "null" &&
//                   singleitemData.singleitems[0].description.toString().length > 0) {
//                 itemdescription = singleitemData.singleitems[0].description;
//                 _isdescription = true;
//               }
//               if (singleitemData.singleitems[0].manufacturedesc.toString() != "null" &&
//                   singleitemData.singleitems[0].manufacturedesc.toString().length > 0) {
//                 itemmanufact = singleitemData.singleitems[0].manufacturedesc;
//                 _ismanufacturer = true;
//               }
//
//               if(_isdescription)
//                 tabList.add(new Tab(
//                   text: 'Description',
//                 ));
//
//               if(_ismanufacturer)
//                 tabList.add(new Tab(
//                   text: 'Manufacturer Details',
//                 ));
//
//               _tabController = new TabController(
//                 vsync: this,
//                 length: tabList.length,
//               );
//
//               multiimage = Provider.of<ItemsList>(context, listen: false).findByIdmulti(varid);
//               _displayimg = multiimage[0].imageUrl;
//
//             });
//           });
//         });
//       });
//       final now = new DateTime.now();
//       currentDate = DateFormat('dd/MM/y').format(now);
//     });
//     super.initState();
//   }
//
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   _notifyMe() async {
//     setState(() {
//       _isNotify = true;
//     });
//     int resposne = await Provider.of<BrandItemsList>(context, listen: false).notifyMe(itemid,varid,type);
//     if(resposne == 200) {
//
//       //_isWeb?_Toast("You will be notified via SMS/Push notification, when the product is available"):
//       Fluttertoast.showToast(msg: S .current.you_will_notify ,
//           fontSize: MediaQuery.of(context).textScaleFactor *13,
//           backgroundColor:
//           Colors.black87,
//           textColor: Colors.white);
//       setState(() {
//         _isNotify = false;
//       });
//     } else {
//       Fluttertoast.showToast(msg: S .current.something_went_wrong ,
//           fontSize: MediaQuery.of(context).textScaleFactor *13,
//           backgroundColor:
//           Colors.black87,
//           textColor: Colors.white);
//       setState(() {
//         _isNotify = false;
//       });
//     }
//   }
//
//
//   _getPage(Tab tab) {
//     switch (tab.text) {
//       case 'Description':
//         return  (!ResponsiveLayout.isSmallScreen(context) && _isWeb)?
//         Text(
//           itemdescription,
//           style: TextStyle(color: ColorCodes.blackColor),
//         ):ReadMoreText(
//           itemdescription,
//           style: TextStyle(color: ColorCodes.blackColor),
//           trimLines: 2,
//           trimCollapsedText: '...Show more',
//           trimExpandedText: '...Show less',
//           colorClickableText: Theme
//               .of(context)
//               .primaryColor,
//         );
//       case 'Manufacturer Details':
//         return (!ResponsiveLayout.isSmallScreen(context) && _isWeb)?
//         Text(
//           itemmanufact,
//           style: TextStyle(color: ColorCodes.blackColor),
//         ):
//         ReadMoreText(
//           itemmanufact,
//           style: TextStyle(color: ColorCodes.blackColor),
//           trimLines: 2,
//           trimCollapsedText: '...Show more',
//           trimExpandedText: '...Show less',
//           colorClickableText: Theme
//               .of(context)
//               .primaryColor,
//         )
//         ;
//     }
//   }
//
//   addListnameToSF(String value) async {
//     PrefUtils.prefs!.setString('list_name', value);
//   }
//
//   _saveFormTwo() async {
//     final isValid = _form.currentState!.validate();
//     if (!isValid) {
//       return;
//     } //it will check all validators
//     _form.currentState!.save();
//     Navigator.of(context).pop();
//     _dialogforProceesing(context, S .current.creating_list);
//
//     Provider.of<BrandItemsList>(context, listen: false).CreateShoppinglist().then((_) {
//       Provider.of<BrandItemsList>(context, listen: false).fetchShoppinglist().then((_) {
//         shoplistData = Provider.of<BrandItemsList>(context, listen: false);
//         Navigator.of(context).pop();
//         _dialogforShoppinglistTwo(context);
//       });
//     });
//   }
//
//
//   additemtolistTwo() {
//     final shoplistDataTwo = Provider.of<BrandItemsList>(context, listen: false);
//     _dialogforProceesing(context, "Add item to list...");
//     for (int i = 0; i < shoplistDataTwo.itemsshoplist.length; i++) {
//       //adding item to multiple list
//       if (shoplistDataTwo.itemsshoplist[i].listcheckbox == true) {
//         addtoshoppinglisttwo(i);
//       }
//     }
//   }
//
//   addtoshoppinglisttwo(i) async {
//     final shoplistDataTwo = Provider.of<BrandItemsList>(context, listen: false);
//     final routeArgs =
//     ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//     final itemid = routeArgs['itemid'];
//
//     Provider.of<BrandItemsList>(context, listen: false).AdditemtoShoppinglist(
//         itemid.toString(), varid.toString(), shoplistDataTwo.itemsshoplist[i].listid!).then((_) {
//       Provider.of<BrandItemsList>(context, listen: false).fetchShoppinglist().then((_) {
//         shoplistData = Provider.of<BrandItemsList>(context, listen: false);
//         Navigator.of(context).pop();
//       });
//     });
//   }
//
//   _dialogforProceesing(BuildContext context, String text) {
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return StatefulBuilder(builder: (context, setState) {
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(3.0)),
//               child: Container(
//                   width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
//                   height: 100.0,
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       CircularProgressIndicator(),
//                       SizedBox(
//                         width: 40.0,
//                       ),
//                       Text(text),
//                     ],
//                   )),
//             );
//           });
//         });
//   }
//
//   _dialogforCreatelistTwo(BuildContext context, shoplistData) {
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return StatefulBuilder(builder: (context, setState) {
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(3.0)),
//               child: Container(
//                   width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
//                   height: 250.0,
//                   margin: EdgeInsets.only(
//                       left: 20.0, top: 10.0, right: 10.0, bottom: 20.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         S .current.create_shopping_list,
//                         style: TextStyle(
//                             fontSize: 16.0,
//                             color: Theme
//                                 .of(context)
//                                 .primaryColor,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       Spacer(),
//                       Form(
//                         key: _form,
//                         child: Column(
//                           children: <Widget>[
//                             TextFormField(
//                               validator: (value) {
//                                 if (value!.isEmpty) {
//                                   return S .current.please_enter_list_name;
//                                 }
//                                 return null; //it means user entered a valid input
//                               },
//                               onSaved: (value) {
//                                 addListnameToSF(value!);
//                               },
//                               autofocus: true,
//                               decoration: InputDecoration(
//                                 labelText: S .current.shopping_list_name,
//                                 labelStyle: TextStyle(
//                                     color: Theme
//                                         .of(context)
//                                         .accentColor),
//                                 contentPadding: EdgeInsets.all(12),
//                                 hintText: 'ex: Monthly Grocery',
//                                 hintStyle: TextStyle(
//                                     color: Colors.black12, fontSize: 10.0),
//                                 //prefixIcon: Icon(Icons.alternate_email, color: Theme.of(context).accentColor),
//                                 border: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: Theme
//                                             .of(context)
//                                             .focusColor
//                                             .withOpacity(0.2))),
//                                 focusedBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: Theme
//                                             .of(context)
//                                             .focusColor
//                                             .withOpacity(0.5))),
//                                 enabledBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: Theme
//                                             .of(context)
//                                             .focusColor
//                                             .withOpacity(0.2))),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Spacer(),
//                       GestureDetector(
//                         onTap: () {
//                           _saveFormTwo();
//                         },
//                         child: Container(
//                           width: MediaQuery
//                               .of(context)
//                               .size
//                               .width,
//                           height: 40.0,
//                           decoration: BoxDecoration(
//                             color: Theme
//                                 .of(context)
//                                 .primaryColor,
//                             borderRadius: BorderRadius.circular(3.0),
//                           ),
//                           child: Center(
//                               child: Text(
//                                 S .current.shopping_list_name,
//                                 textAlign: TextAlign.center,
//                                 style:
//                                 TextStyle(color: Theme
//                                     .of(context)
//                                     .buttonColor),
//                               )),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20.0,
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.of(context).pop();
//                         },
//                         child: Container(
//                           width: MediaQuery
//                               .of(context)
//                               .size
//                               .width,
//                           height: 40.0,
//                           decoration: BoxDecoration(
//                             color: Colors.black12,
//                             borderRadius: BorderRadius.circular(3.0),
//                           ),
//                           child: Center(
//                               child: Text(
//                                 S .current.cancel,
//                                 textAlign: TextAlign.center,
//                                 style:
//                                 TextStyle(color: Theme
//                                     .of(context)
//                                     .buttonColor),
//                               )),
//                         ),
//                       ),
//                     ],
//                   )),
//             );
//           });
//         });
//   }
//
//   _dialogforShoppinglistTwo(BuildContext context) {
//     return showDialog(
//         context: context,
//         builder: (context) {
//           final x = Provider.of<BrandItemsList>(context, listen: false);
//           return StatefulBuilder(builder: (context, setState) {
//             return Dialog(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(3.0)),
//                 child: Container(
//                   width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
//                   padding: EdgeInsets.only(
//                       left: 10.0, top: 20.0, right: 10.0, bottom: 30.0),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           S .current.add_to_list,
//                           style: TextStyle(
//                               fontSize: 16.0,
//                               color: Theme
//                                   .of(context)
//                                   .primaryColor,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(
//                           height: 20.0,
//                         ),
//                         SizedBox(
//                           child: new ListView.builder(
//                             physics: NeverScrollableScrollPhysics(),
//                             shrinkWrap: true,
//                             itemCount: x.itemsshoplist.length,
//                             itemBuilder: (_, i) =>
//                                 Row(
//                                   children: [
//                                     Checkbox(
//                                       value: x.itemsshoplist[i].listcheckbox,
//                                       onChanged: ( bool? value) async {
//                                         setState(() {
//                                           x.itemsshoplist[i].listcheckbox = value;
//                                         });
//                                       },
//                                     ),
//                                     Text(x.itemsshoplist[i].listname!,
//                                         style: TextStyle(fontSize: 18.0)),
//                                   ],
//                                 ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 10.0,
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.of(context).pop();
//
//                             _dialogforCreatelistTwo(context, shoplistData);
//
//                             for (int i = 0; i < x.itemsshoplist.length; i++) {
//                               x.itemsshoplist[i].listcheckbox = false;
//                             }
//                           },
//                           child: Row(
//                             children: <Widget>[
//                               SizedBox(
//                                 width: 10.0,
//                               ),
//                               Icon(
//                                 Icons.add,
//                                 color: Colors.grey,
//                               ),
//                               SizedBox(
//                                 width: 10.0,
//                               ),
//                               Text(
//                                 S .current.create_new,
//                                 style: TextStyle(
//                                     color: Colors.grey, fontSize: 18.0),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(
//                           height: 20.0,
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             bool check = false;
//                             for (int i = 0; i < x.itemsshoplist.length; i++) {
//                               if (x.itemsshoplist[i].listcheckbox!)
//                                 setState(() {
//                                   check = true;
//                                 });
//                             }
//                             if (check) {
//                               Navigator.of(context).pop();
//                               additemtolistTwo();
//                             } else {
//                               Fluttertoast.showToast(
//                                   msg: S .current.please_select_atleastonelist,
//                                   fontSize: MediaQuery.of(context).textScaleFactor *13,
//                                   backgroundColor: Colors.black87,
//                                   textColor: Colors.white);
//                             }
//                           },
//                           child: Container(
//                             width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
//                             // color: Theme.of(context).primaryColor,
//                             height: 40.0,
//                             decoration: BoxDecoration(
//                               color: Theme
//                                   .of(context)
//                                   .primaryColor,
//                               borderRadius: BorderRadius.circular(3.0),
//                             ),
//                             child: Center(
//                                 child: Text(
//                                   S .current.add,
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                       color: Theme
//                                           .of(context)
//                                           .buttonColor),
//                                 )),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 20.0,
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.of(context).pop();
//                             for (int i = 0; i < x.itemsshoplist.length; i++) {
//                               x.itemsshoplist[i].listcheckbox = false;
//                             }
//                           },
//                           child: Container(
//                             width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
//                             // color: Theme.of(context).primaryColor,
//                             height: 40.0,
//                             decoration: BoxDecoration(
//                               color: Colors.black12,
//                               borderRadius: BorderRadius.circular(3.0),
//                             ),
//                             child: Center(
//                                 child: Text(
//                                   S .current.cancel,
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                       color: Theme
//                                           .of(context)
//                                           .buttonColor),
//                                 )),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ));
//           });
//         });
//   }
//
//   Widget handler( int i) {
//     if (int.parse(singleitemvar[i].varstock!) <= 0) {
//       return (varid == singleitemvar[i].varid) ?
//       Icon(
//           Icons.radio_button_checked_outlined,
//           color: ColorCodes.grey)
//           :
//       Icon(
//           Icons.radio_button_off_outlined,
//           color: ColorCodes.grey);
//
//     } else {
//       return (varid == singleitemvar[i].varid) ?
//       Icon(
//           Icons.radio_button_checked_outlined,
//           color: ColorCodes.mediumBlueColor)
//           :
//       Icon(
//           Icons.radio_button_off_outlined,
//           color: ColorCodes.blackColor);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     queryData = MediaQuery.of(context);
//     wid= queryData.size.width;
//     maxwid=wid*0.90;
//     final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//     final itemid = routeArgs['itemid'];
//     final delivery = routeArgs['delivery'];
//     final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);
//     if (sellingitemData.itemsnew.length <= 0) {
//       _similarProduct = false;
//     } else {
//       _similarProduct = true;
//     }
//
//     addToCart(int _itemCount) async {
//       multiimage = Provider.of<ItemsList>(context, listen: false).findByIdmulti(varid);
//       _displayimg = multiimage[0].imageUrl;
//       if(singleitemvar.length<=1) {
//         itemimg = singleitemData.singleitems[0].imageUrl;
//       }else{
//         itemimg =_displayimg;
//       }
//      // varimage=List.from(_displ);
//       cartcontroller.addtoCart( pm.PriceVariation(id: varid,variationName: varname,unit:unit,minItem: varminitem,maxItem: varmaxitem,loyalty: 0,stock: double.parse(varstock),status: "",mrp: varmrp,price: varprice,membershipPrice: varmemberprice,membershipDisplay: memberpriceDisplay,images: [pm.ImageDate(image:itemimg)]),pm.ItemData(id: itemid,itemName: itemname,type: type,deliveryDuration: pm.DeliveryDurationData(),delivery: delivery), (onload){
//         setState(() {
//           _isAddToCart = onload;
//         });
//         setState(() {
//           // _isAddToCart = false;
//           _varQty = _itemCount;
//         });
//         final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);
//         for(int i = 0; i < sellingitemData.featuredVariation.length; i++) {
//           if(sellingitemData.featuredVariation[i].varid == varid) {
//             sellingitemData.featuredVariation[i].varQty = _itemCount;
//             break;
//           }
//         }
//         for(int i = 0; i < sellingitemData.discountedVariation.length; i++) {
//           if(sellingitemData.discountedVariation[i].varid == varid) {
//             sellingitemData.discountedVariation[i].varQty = _itemCount;
//             break;
//           }
//         }
//         for (int i = 0; i < sellingitemData.itemspricevarOffer.length; i++) {
//           if (sellingitemData.itemspricevarOffer[i].varid == varid) {
//             sellingitemData.itemspricevarOffer[i].varQty = _itemCount;
//             break;
//           }
//         }
//         for (int i = 0; i < sellingitemData.itemspricevarSwap.length; i++) {
//           if (sellingitemData.itemspricevarSwap[i].varid == varid) {
//             sellingitemData.itemspricevarSwap[i].varQty = _itemCount;
//             break;
//           }
//         }
//         for(int i = 0; i < sellingitemData.recentVariation.length; i++) {
//           if(sellingitemData.recentVariation[i].varid == varid) {
//             sellingitemData.recentVariation[i].varQty = _itemCount;
//             break;
//           }
//         }
//
//         for(int i = 0; i < singleitemvar.length; i++) {
//           if(singleitemvar[i].varid == varid) {
//             singleitemvar[i].varQty = _itemCount;
//             break;
//           }
//         }
//       });
//     }
//
//     _buildBottomNavigationBar() {
//       singleitemData = Provider.of<ItemsList>(context, listen: false);
//       return VxBuilder(
//         mutations: {SetCartItem},
//         builder: (context,GroceStore store, index) {
//           final box = (VxState.store as GroceStore).CartItemList;
//           return  Container(
//             width: MediaQuery
//                 .of(context)
//                 .size
//                 .width,
//             height: 60.0,
//             padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
//             child: (Features.isSubscription)?
//             Row(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: (singleitemData.singleitems[0].subscribe == "0")?MainAxisAlignment.start:MainAxisAlignment.center,
//               children: <Widget>[
//                 _isStock
//                     ? Expanded(
//                       child: Container(
//                   height: 60.0,
//                   // width: (singleitemData.singleitems[0].subscribe == "0")?(MediaQuery.of(context)
//                   //       .size
//                   //       .width /
//                   //       7) +
//                   //       90:(MediaQuery.of(context).size.width / 2) + 150,
//                   child: VxBuilder(
//                       mutations: {SetCartItem},
//                       // valueListenable: Hive.box<Product>(productBoxName).listenable(),
//                       builder: (context,GroceStore store, index) {
//                         final box = (VxState.store as GroceStore).CartItemList;
//                         if (box.where((element) => element.varId==varid).length <= 0  || int.parse(box.where((element) => element.varId==varid).first.quantity!) <= 0)
//                           return GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 _isAddToCart = true;
//                               });
//                               if (Features.btobModule?Check().isOutofStockSingleProduct(pm.PriceVariation(quantity: int.parse(varminitem),weight: weight.toString()), double.parse(singleitemvar.last.varmaxitem!),singleitemData.type, singleitemvar)
//                                   :Check().isOutofStockSingleProduct(pm.PriceVariation(quantity: int.parse(varminitem),weight: weight.toString()), double.parse(varmaxitem),singleitemData.type, singleitemvar)) {
//                                 Fluttertoast.showToast(
//                                     msg: S .of(context).sorry_outofstock,//"Sorry, Out of Stock!",
//                                     fontSize: MediaQuery.of(context).textScaleFactor *13, backgroundColor: Colors.black87, textColor: Colors.white);
//                               } else {
//                                 addToCart(int.parse(varminitem));
//                               }
//                              // if(Check().isOutofStockSingleProduct(pm.PriceVariation(quantity: int.parse(varminitem),weight: weight.toString()), singleitemvar.varmaxitem,singleitemData.type, singleitemvar))
//
//                             },
//                             child: Container(
//                               height: 30.0,
//                               width: (MediaQuery.of(context).size.width / 3) + 25,
//                               decoration: new BoxDecoration(
//                                   color: (Features.isSubscription)?Theme
//                                       .of(context)
//                                       .primaryColor :ColorCodes.greenColor,
//                                   borderRadius: new BorderRadius.only(
//                                     topLeft: const Radius.circular(3),
//                                     topRight: const Radius.circular(3),
//                                     bottomLeft: const Radius.circular(3),
//                                     bottomRight: const Radius.circular(3),
//                                   )),
//                               child: _isAddToCart ? Center(
//                                 child: SizedBox(
//                                     width: 20.0,
//                                     height: 20.0,
//                                     child: new CircularProgressIndicator(
//                                       strokeWidth: 2.0,
//                                       valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)),
//                               ) :(Features.isSubscription)? Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   /* SizedBox(
//                                                   width: 3,
//                                                 ),*/
//                                   Center(
//                                       child: Text(
//                                         S .current.buy_once,
//                                         style:
//                                         TextStyle(
//                                           color: ColorCodes.whiteColor,
//                                         ),
//                                         textAlign:
//                                         TextAlign
//                                             .center,
//                                       )),
//                                   /*  Spacer(),
//                                                 Container(
//                                                   decoration:
//                                                   BoxDecoration(
//                                                       color: Theme
//                                                           .of(context)
//                                                           .primaryColor,
//                                                       borderRadius:
//                                                       new BorderRadius.only(
//                                                         topLeft:
//                                                         const Radius.circular(2.0),
//                                                         bottomLeft:
//                                                         const Radius.circular(2.0),
//                                                         topRight:
//                                                         const Radius.circular(2.0),
//                                                         bottomRight:
//                                                         const Radius.circular(2.0),
//                                                       )),
//                                                   height: 30,
//                                                   width: 25,
//                                                   child: Icon(
//                                                     Icons.add,
//                                                     size: 12,
//                                                     color: Colors
//                                                         .white,
//                                                   ),
//                                                 ),*/
//                                 ],
//                               ): Row(
//                                 children: [
//                                   SizedBox(
//                                     width: 10,
//                                   ),
//                                   Center(
//                                       child: Text(
//                                         S .current.add,//'ADD',
//                                         style:
//                                         TextStyle(
//                                           color: Theme.of(
//                                               context)
//                                               .buttonColor,
//                                         ),
//                                         textAlign:
//                                         TextAlign
//                                             .center,
//                                       )),
//                                   Spacer(),
//                                   Container(
//                                     decoration:
//                                     BoxDecoration(
//                                         color: ColorCodes.greenColor,
//                                         borderRadius:
//                                         new BorderRadius.only(
//                                           topLeft:
//                                           const Radius.circular(2.0),
//                                           bottomLeft:
//                                           const Radius.circular(2.0),
//                                           topRight:
//                                           const Radius.circular(2.0),
//                                           bottomRight:
//                                           const Radius.circular(2.0),
//                                         )),
//                                     height: 50,
//                                     width: 25,
//                                     child: Icon(
//                                       Icons.add,
//                                       size: 12,
//                                       color: Colors
//                                           .white,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         else
//                           return Container(
//                             child: Row(
//                               children: <Widget>[
//                                 GestureDetector(
//                                   onTap: () async {
//                                     // setState(() {
//                                     //   _isAddToCart = true;
//                                     //   // incrementToCart(_varQty - 1);
//                                     // });
//                                     // VxRemoveCart(context, productBox: productBox, varQty: _varQty, varminitem: varminitem, isAddToCart: _isAddToCart, varid: varid, varprice: varprice, singleitemvar: singleitemvar, itemid: itemid, varname: varname, varmaxitem: varmaxitem, varLoyalty: varLoyalty, varstock: varstock, varmrp: varmrp, itemname: itemname, varmemberprice: varmemberprice, itemimg: itemimg, veg_type: veg_type, type: type, eligibleforexpress: eligibleforexpress, delivery: delivery, duration: duration, durationType: durationType);
//                                     if(int.parse(box.where((element) => element.varId==varid).first.quantity!) > 0)
//                                       cartcontroller.update((done){
//                                         setState(() {
//                                           _isAddToCart = !done;
//                                         });
//                                       },quantity: (int.parse(box.where((element) => element.varId==varid).first.quantity!)<= int.parse(varminitem))?"0":(int.parse(box.where((element) => element.varId==varid).first.quantity!) - 1).toString(),var_id: varid,price: memberpriceDisplay?varmemberprice:varprice);
//                                   },
//                                   child: (Features.isSubscription)?
//                                   Container(
//                                     //margin: EdgeInsets.all(6),
//                                       width: 40,
//                                       height: 60,
//                                       decoration:
//                                       new BoxDecoration(
//                                           color: Theme
//                                               .of(context)
//                                               .primaryColor,
//                                           border: Border
//                                               .all(
//                                             color: Theme
//                                                 .of(context)
//                                                 .primaryColor,
//                                           ),
//                                           borderRadius:
//                                           new BorderRadius.only(
//                                             bottomLeft:
//                                             const Radius.circular(3),
//                                             topLeft:
//                                             const Radius.circular(3),
//                                           )),
//                                       child: Center(
//                                         child: Text(
//                                           "-",
//                                           textAlign:
//                                           TextAlign
//                                               .center,
//                                           style:
//                                           TextStyle(
//                                             color:ColorCodes.whiteColor,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ))
//                                       :Container(
//                                       width: 30,
//                                       height: 30,
//                                       decoration:
//                                       new BoxDecoration(
//                                           border: Border
//                                               .all(
//                                             color: ColorCodes.greenColor,
//                                           ),
//                                           borderRadius:
//                                           new BorderRadius.only(
//                                             bottomLeft:
//                                             const Radius.circular(3.0),
//                                             topLeft:
//                                             const Radius.circular(3.0),
//                                           )),
//                                       child: Center(
//                                         child: Text(
//                                           "-",
//                                           textAlign:
//                                           TextAlign
//                                               .center,
//                                           style:
//                                           TextStyle(
//                                             color: ColorCodes.greenColor,
//                                           ),
//                                         ),
//                                       )),
//                                 ),
//                                 Expanded(
//                                   child: _isAddToCart ?
//                                   Container(
//                                     decoration: BoxDecoration(color: (Features.isSubscription)? ColorCodes.whiteColor:ColorCodes.greenColor,),
//                                     height: 60,
//
//                                     child: Center(
//                                       child: SizedBox(
//                                           width: 20.0,
//                                           height: 20.0,
//                                           child: new CircularProgressIndicator(
//                                             strokeWidth: 2.0,
//                                             valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),)),
//                                     ),
//                                   )
//                                       :
//                                   VxBuilder(
//                                       mutations: {SetCartItem},
//                                       // valueListenable: Hive.box<Product>(productBoxName).listenable(),
//                                       builder: (context,GroceStore store, index) {
//                                         final box = (VxState.store as GroceStore).CartItemList;
//
//                                         if (box.isEmpty) return SizedBox.shrink();
//                                         return  (Features.isSubscription)?
//                                         Container(
// //                                            width: 40,
//                                             decoration:
//                                             BoxDecoration(
//                                               color: /*Theme
//                                                   .of(context)
//                                                   .primaryColor*/ColorCodes.whiteColor,
//                                             ),
//                                             height: 60,
//                                             child: Center(
//                                               child: Text(
//                                                 box.where((element) => element.varId==varid).first.quantity!,
//                                                 textAlign:
//                                                 TextAlign
//                                                     .center,
//                                                 style:
//                                                 TextStyle(
//                                                   color: Theme
//                                                       .of(context)
//                                                       .primaryColor,
//                                                 ),
//                                               ),
//                                             ))
//                                             :Container(
// //                                            width: 40,
//                                             decoration:
//                                             BoxDecoration(
//                                               color: ColorCodes.greenColor,
//                                             ),
//                                             height: 60,
//                                             child: Center(
//                                               child: Text(
//                                                 box.where((element) => element.varId==varid).first.quantity!,
//                                                 textAlign:
//                                                 TextAlign
//                                                     .center,
//                                                 style:
//                                                 TextStyle(
//                                                   color: Theme
//                                                       .of(context)
//                                                       .buttonColor,
//                                                 ),
//                                               ),
//                                             ));
//                                       }),
//                                 ),
//                                 GestureDetector(
//                                   onTap: () {
//                                     if (int.parse(box.where((element) => element.varId==varid).first.quantity!) < int.parse(varstock)) {
//                                       if (int.parse(box.where((element) => element.varId==varid).first.quantity!) < int.parse(varmaxitem)) {
//                                         // setState(() {
//                                         //   _isAddToCart = true;
//                                         // });
//                                         // VxAddCart(context, productBox: productBox, varQty: _varQty, varminitem: varminitem, isAddToCart: _isAddToCart, varid: varid, varprice: varprice, singleitemvar: singleitemvar, itemid: itemid, varname: varname, varmaxitem: varmaxitem, varLoyalty: varLoyalty, varstock: varstock, varmrp: varmrp, itemname: itemname, varmemberprice: varmemberprice, itemimg: itemimg, veg_type: veg_type, type: type, eligibleforexpress: eligibleforexpress, delivery: delivery, duration: duration, durationType: durationType);
//                                         cartcontroller.update((done){
//                                           setState(() {
//                                             _isAddToCart = !done;
//                                           });
//                                         },quantity: (int.parse(box.where((element) => element.varId==varid).first.quantity!) + 1).toString(),var_id: varid,price: memberpriceDisplay?varmemberprice:varprice);
//                                         // incrementToCart(_varQty + 1);
//                                       } else {
//                                         Fluttertoast.showToast(
//                                             msg:
//                                             S .current.cant_add_more_item,
//                                             fontSize: MediaQuery.of(context).textScaleFactor *13,
//                                             backgroundColor:
//                                             Colors
//                                                 .black87,
//                                             textColor:
//                                             Colors.white);
//                                       }
//                                     } else {
//                                       Fluttertoast.showToast(msg: S .current.sorry_outofstock,  fontSize: MediaQuery.of(context).textScaleFactor *13,backgroundColor: Colors.black87, textColor: Colors.white);
//                                     }
//                                   },
//                                   child: (Features.isSubscription)?
//                                   Container(
//                                     //margin: EdgeInsets.only(right: 3),
//                                       width: 40,
//                                       height: 60,
//                                       decoration:
//                                       new BoxDecoration(
//                                           color: Theme
//                                               .of(context)
//                                               .primaryColor,
//                                           border: Border
//                                               .all(
//                                             color: Theme
//                                                 .of(context)
//                                                 .primaryColor,
//                                           ),
//                                           borderRadius:
//                                           new BorderRadius.only(
//                                             bottomRight:
//                                             const Radius.circular(3),
//                                             topRight:
//                                             const Radius.circular(3),
//                                           )),
//                                       child: Center(
//                                         child: Text(
//                                           "+",
//                                           textAlign:
//                                           TextAlign
//                                               .center,
//                                           style:
//                                           TextStyle(
//                                             color: ColorCodes.whiteColor,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ))
//                                       :Container(
//                                       width: 30,
//                                       height: 30,
//                                       decoration:
//                                       new BoxDecoration(
//                                           border: Border
//                                               .all(
//                                             color: ColorCodes.greenColor,
//                                           ),
//                                           borderRadius:
//                                           new BorderRadius.only(
//                                             bottomRight:
//                                             const Radius.circular(2.0),
//                                             topRight:
//                                             const Radius.circular(2.0),
//                                           )),
//                                       child: Center(
//                                         child: Text(
//                                           "+",
//                                           textAlign:
//                                           TextAlign
//                                               .center,
//                                           style:
//                                           TextStyle(
//                                             color: ColorCodes.greenColor,
//                                           ),
//                                         ),
//                                       )),
//                                 ),
//                               ],
//                             ),
//                           );
//                         /*try {
//                                               Product item = Hive.box<
//                                                   Product>(
//                                                   productBoxName)
//                                                   .values
//                                                   .firstWhere((value) =>
//                                               value.varId ==
//                                                   int.parse(varid));
//                                               return Container(
//                                                 child: Row(
//                                                   children: <Widget>[
//                                                     GestureDetector(
//                                                       onTap: () async {
//                                                         setState(() {
//                                                           _isAddToCart = true;
//                                                           incrementToCart(item.itemQty - 1);
//                                                         });
//                                                       },
//                                                       child: Container(
//                                                           width: 30,
//                                                           height: 30,
//                                                           decoration:
//                                                           new BoxDecoration(
//                                                               border: Border
//                                                                   .all(
//                                                                 color: ColorCodes.greenColor,
//                                                               ),
//                                                               borderRadius:
//                                                               new BorderRadius.only(
//                                                                 bottomLeft:
//                                                                 const Radius.circular(2.0),
//                                                                 topLeft:
//                                                                 const Radius.circular(2.0),
//                                                               )),
//                                                           child: Center(
//                                                             child: Text(
//                                                               "-",
//                                                               textAlign:
//                                                               TextAlign
//                                                                   .center,
//                                                               style:
//                                                               TextStyle(
//                                                                 color: ColorCodes.greenColor,
//                                                               ),
//                                                             ),
//                                                           )),
//                                                     ),
//                                                     Expanded(
//                                                       child: _isAddToCart ?
//                                                       Container(
//                                                         decoration: BoxDecoration(color: ColorCodes.greenColor,),
//                                                         height: 30,
//
//                                                         child: Center(
//                                                           child: SizedBox(
//                                                               width: 20.0,
//                                                               height: 20.0,
//                                                               child: new CircularProgressIndicator(
//                                                                 strokeWidth: 2.0,
//                                                                 valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)),
//                                                         ),
//                                                       )
//                                                           :
//                                                       Container(
// //                                            width: 40,
//                                                           decoration:
//                                                           BoxDecoration(
//                                                             color: ColorCodes.greenColor,
//                                                           ),
//                                                           height: 30,
//                                                           child: Center(
//                                                             child: Text(
//                                                               item.itemQty.toString(),
//                                                               textAlign:
//                                                               TextAlign
//                                                                   .center,
//                                                               style:
//                                                               TextStyle(
//                                                                 color: Theme.of(context)
//                                                                     .buttonColor,
//                                                               ),
//                                                             ),
//                                                           )),
//                                                     ),
//                                                     GestureDetector(
//                                                       onTap: () {
//                                                         if (item.itemQty < int.parse(varstock)) {
//                                                           if (item.itemQty < int.parse(varmaxitem)) {
//                                                             setState(() {
//                                                               _isAddToCart = true;
//                                                             });
//                                                             incrementToCart(item.itemQty + 1);
//                                                           } else {
//                                                             Fluttertoast.showToast(
//                                                                 msg:
//                                                                 "Sorry, you can\'t add more of this item!",
//                                                                 backgroundColor:
//                                                                 Colors
//                                                                     .black87,
//                                                                 textColor:
//                                                                 Colors.white);
//                                                           }
//                                                         } else {
//                                                           Fluttertoast.showToast(msg: "Sorry, Out of Stock!", backgroundColor: Colors.black87, textColor: Colors.white);
//                                                         }
//                                                       },
//                                                       child: Container(
//                                                           width: 30,
//                                                           height: 30,
//                                                           decoration:
//                                                           new BoxDecoration(
//                                                               border: Border
//                                                                   .all(
//                                                                 color: ColorCodes.greenColor,
//                                                               ),
//                                                               borderRadius:
//                                                               new BorderRadius.only(
//                                                                 bottomRight:
//                                                                 const Radius.circular(2.0),
//                                                                 topRight:
//                                                                 const Radius.circular(2.0),
//                                                               )),
//                                                           child: Center(
//                                                             child: Text(
//                                                               "+",
//                                                               textAlign:
//                                                               TextAlign
//                                                                   .center,
//                                                               style:
//                                                               TextStyle(
//                                                                 color: ColorCodes.greenColor,
//                                                               ),
//                                                             ),
//                                                           )),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               );
//                                             } catch (e) {
//                                               return GestureDetector(
//                                                 onTap: () {
//                                                   setState(() {
//                                                     _isAddToCart = true;
//                                                   });
//                                                   addToCart(int.parse(varminitem));
//                                                 },
//                                                 child: Container(
//                                                   height: 30.0,
//                                                   width: (MediaQuery.of(context).size.width / 4) + 15,
//                                                   decoration:
//                                                   new BoxDecoration(
//                                                       color: ColorCodes.greenColor,
//                                                       borderRadius:
//                                                       new BorderRadius
//                                                           .only(
//                                                         topLeft:
//                                                         const Radius.circular(
//                                                             2.0),
//                                                         topRight:
//                                                         const Radius.circular(
//                                                             2.0),
//                                                         bottomLeft:
//                                                         const Radius.circular(
//                                                             2.0),
//                                                         bottomRight:
//                                                         const Radius.circular(
//                                                             2.0),
//                                                       )),
//                                                   child: _isAddToCart ?
//                                                   Center(
//                                                     child: SizedBox(
//                                                         width: 20.0,
//                                                         height: 20.0,
//                                                         child: new CircularProgressIndicator(
//                                                           strokeWidth: 2.0,
//                                                           valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)),
//                                                   )
//                                                       :
//                                                   Row(
//                                                     children: [
//                                                       SizedBox(
//                                                         width: 10,
//                                                       ),
//                                                       Center(
//                                                           child: Text(
//                                                             S .current.add,//'ADD',
//                                                             style:
//                                                             TextStyle(
//                                                               color: Theme.of(
//                                                                   context)
//                                                                   .buttonColor,
//                                                             ),
//                                                             textAlign:
//                                                             TextAlign
//                                                                 .center,
//                                                           )),
//                                                       Spacer(),
//                                                       Container(
//                                                         decoration:
//                                                         BoxDecoration(
//                                                             color: Color(
//                                                                 0xff1BA130),
//                                                             borderRadius:
//                                                             new BorderRadius.only(
//                                                               topLeft:
//                                                               const Radius.circular(2.0),
//                                                               bottomLeft:
//                                                               const Radius.circular(2.0),
//                                                               topRight:
//                                                               const Radius.circular(2.0),
//                                                               bottomRight:
//                                                               const Radius.circular(2.0),
//                                                             )),
//                                                         height: 30,
//                                                         width: 25,
//                                                         child: Icon(
//                                                           Icons.add,
//                                                           size: 12,
//                                                           color: Colors
//                                                               .white,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               );
//                                             }*/
//                       },
//                   ),
//                 ),
//                     )
//                     : Expanded(
//                       child: GestureDetector(
//                   onTap: () {
//                       checkskip
//                           ? /*Navigator.of(context).pushNamed(
//                         SignupSelectionScreen.routeName,
//                       )*/
//                       Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
//                           : _notifyMe();
//                       // Fluttertoast.showToast(
//                       //     msg:  "You will be notified via SMS/Push notification, when the product is available" ,
//                       //     /*"Out Of Stock",*/
//                       //     fontSize: 12.0,
//                       //     backgroundColor:
//                       //     Colors.black87,
//                       //     textColor: Colors.white);
//                   },
//                   child: Container(
//                       height: 50.0,
//                       width:(MediaQuery.of(context).size.width / 2) + 130,
//                       decoration: new BoxDecoration(
//                           border: Border.all(
//                               color: (Features.isSubscription)?ColorCodes.primaryColor: ColorCodes.greenColor),
//                           color: (Features.isSubscription)?ColorCodes.primaryColor: ColorCodes.greenColor,
//                           borderRadius:
//                           new BorderRadius.only(
//                             topLeft: const Radius
//                                 .circular(2.0),
//                             topRight: const Radius
//                                 .circular(2.0),
//                             bottomLeft: const Radius
//                                 .circular(2.0),
//                             bottomRight:
//                             const Radius
//                                 .circular(2.0),
//                           )),
//                       child:
//                       _isNotify ?
//                       Center(
//                         child: SizedBox(
//                             width: 20.0,
//                             height: 20.0,
//                             child: new CircularProgressIndicator(
//                               strokeWidth: 2.0,
//                               valueColor: new AlwaysStoppedAnimation<
//                                   Color>(Colors.white),)),
//                       )
//                           :
//                       Row(
//                         children: [
//                           SizedBox(
//                             width: 40,
//                           ),
//                           Center(
//                               child: Text(
//                                 S .current.notify_me,
//                                 /* "ADD",*/
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w700,
//                                     color: Colors
//                                         .white ),
//                                 textAlign:
//                                 TextAlign.center,
//                               )),
//                           Spacer(),
//                           Container(
//                             decoration:
//                             BoxDecoration(
//                                 color: Colors
//                                     .black12,
//                                 borderRadius:
//                                 new BorderRadius
//                                     .only(
//                                   topRight:
//                                   const Radius
//                                       .circular(
//                                       2.0),
//                                   bottomRight:
//                                   const Radius
//                                       .circular(
//                                       2.0),
//                                 )),
//                             height: 50,
//                             width: 40,
//                             child: Icon(
//                               Icons.add,
//                               size: 12,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                   ),
//                 ),
//                     ),
//                 (singleitemData.singleitems[0].subscribe == "0")?SizedBox(width: 20,):SizedBox.shrink(),
//                 (Features.isSubscription)?
//                 (singleitemData.singleitems[0].subscribe == "0")?
//                 _isStock?
//                 MouseRegion(
//                   cursor: SystemMouseCursors.click,
//                   child: GestureDetector(
//                     onTap: () {
//                       if(checkskip &&_isWeb && !ResponsiveLayout.isSmallScreen(context)){
//                         //_dialogforSignIn();
//                         LoginWeb(context,result: (sucsess){
//                           if(sucsess){
//                             Navigator.of(context).pop();
//                             Navigator.pushNamedAndRemoveUntil(
//                                 context, HomeScreen.routeName, (route) => false);
//                           }else{
//                             Navigator.of(context).pop();
//                           }
//                         });
//                       }
//                       else {
//                         (checkskip) ?
//                         /*Navigator.of(context).pushNamed(
//                           SignupSelectionScreen.routeName,
//                         )*/
//                         Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push):
//                         Navigator.of(context).pushNamed(
//                             SubscribeScreen.routeName,
//                             arguments: {
//                               "itemid": singleitemData.singleitems[0].id,
//                               "itemname": singleitemData.singleitems[0].title,
//                               "itemimg": singleitemData.singleitems[0].imageUrl,
//                               "varname": varname+unit,
//                               "varmrp":varmrp,
//                               "varprice":  _checkmembership ? varmemberprice :discountDisplay ?varprice:varmrp,
//                               "paymentMode": singleitemData.singleitems[0].paymentmode,
//                               "cronTime": singleitemData.singleitems[0].cronTime,
//                               "name": singleitemData.singleitems[0].name,
//                               "varid": varid.toString(),
//                               "brand": singleitemData.singleitems[0].brand
//                             }
//                         );
//                       }
//                     },
//                     child: Container(
//                       height: 60.0,
//                       width: (MediaQuery.of(context)
//                           .size.width / 3) +35,
//                       decoration: new BoxDecoration(
//                           color: ColorCodes.whiteColor,
//                           border: Border.all(color: Theme
//                               .of(context)
//                               .primaryColor),
//                           borderRadius: new BorderRadius.only(
//                             topLeft: const Radius.circular(3),
//                             topRight:
//                             const Radius.circular(3),
//                             bottomLeft:
//                             const Radius.circular(3),
//                             bottomRight:
//                             const Radius.circular(3),
//                           )),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//
//                           Text(
//                             S .current.subscribe,
//                             style: TextStyle(
//                                 color: Theme.of(context)
//                                     .primaryColor,
//                                 fontWeight: FontWeight.bold),
//                             textAlign: TextAlign.center,
//                           ),
//                         ],
//                       ) ,
//                     ),
//                   ),
//                 ):
//                 SizedBox.shrink()
//                     :
//                 SizedBox.shrink():SizedBox.shrink(),
//               ],
//             ):
//             Row(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 _isStock
//                     ? Expanded(
//                       child: Container(
//                   //  padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
//                   decoration: new BoxDecoration(
//                       color: ColorCodes.lightBlueColor,
//                       borderRadius: BorderRadius.circular(10),
//                   ),
//                   height: 60.0,
//                   /*width:(_isWeb && ResponsiveLayout.isMediumScreen(context))?( MediaQuery.of(context)
//                         .size
//                         .width /
//                         2) +
//                         350:
//                   (_isWeb && ResponsiveLayout.isSmallScreen(context))?
//                   ( MediaQuery.of(context)
//                         .size
//                         .width /
//                         2) +
//                         210
//                   :
//                   ( MediaQuery.of(context)
//                         .size
//                         .width /
//                         2) +
//                         150
//           ,*/
//                   child: VxBuilder(
//                       mutations: {SetCartItem},
//                       // valueListenable: Hive.box<Product>(productBoxName).listenable(),
//                       builder: (context,GroceStore store, index) {
//                         final box = (VxState.store as GroceStore).CartItemList;
//                         if (box.where((element) => element.varId==varid).length <= 0  || int.parse(box.where((element) => element.varId==varid).first.quantity!) <= 0)
//                           return GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 _isAddToCart = true;
//                               });
//                               addToCart(int.parse(varminitem));
//                             },
//                             child: Container(
//                               //  padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
//                               height: 30.0,
//                               width:
//                               /*(_isWeb && ResponsiveLayout.isMediumScreen(context))?( MediaQuery.of(context)
//                                   .size
//                                   .width /
//                                   2) +
//                                   350:
//                               (_isWeb && ResponsiveLayout.isSmallScreen(context))?
//                               ( MediaQuery.of(context)
//                                   .size
//                                   .width /
//                                   2) +
//                                   210
//                                   :*/
//                               ( MediaQuery.of(context)
//                                   .size
//                                   .width /
//                                   2) +
//                                   150,
//                               decoration: new BoxDecoration(
//                                 color: (Features.isSubscription)?Theme
//                                     .of(context)
//                                     .primaryColor :ColorCodes.greenColor,
//                                 /* borderRadius: new BorderRadius.only(
//                                     topLeft: const Radius.circular(2.0),
//                                     topRight: const Radius.circular(2.0),
//                                     bottomLeft: const Radius.circular(2.0),
//                                     bottomRight: const Radius.circular(2.0),)
//                                   */
//                                 borderRadius: BorderRadius.circular(3),),
//                               child: _isAddToCart ?
//                               Center(
//                                 child: SizedBox(
//                                     width: 20.0,
//                                     height: 20.0,
//                                     child: new CircularProgressIndicator(
//                                       strokeWidth: 2.0,
//                                       valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)),
//                               )
//                                   :(Features.isSubscription)?Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   /* SizedBox(
//                                                   width: 3,
//                                                 ),*/
//                                   Center(
//                                       child: Text(
//                                         S .current.buy_once,
//                                         style:
//                                         TextStyle(
//                                           color: ColorCodes.whiteColor,
//                                         ),
//                                         textAlign:
//                                         TextAlign
//                                             .center,
//                                       )),
//                                   /*  Spacer(),
//                                                 Container(
//                                                   decoration:
//                                                   BoxDecoration(
//                                                       color: Theme
//                                                           .of(context)
//                                                           .primaryColor,
//                                                       borderRadius:
//                                                       new BorderRadius.only(
//                                                         topLeft:
//                                                         const Radius.circular(2.0),
//                                                         bottomLeft:
//                                                         const Radius.circular(2.0),
//                                                         topRight:
//                                                         const Radius.circular(2.0),
//                                                         bottomRight:
//                                                         const Radius.circular(2.0),
//                                                       )),
//                                                   height: 30,
//                                                   width: 25,
//                                                   child: Icon(
//                                                     Icons.add,
//                                                     size: 12,
//                                                     color: Colors
//                                                         .white,
//                                                   ),
//                                                 ),*/
//                                 ],
//                               ):
//                               Row(
//                                 // mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   SizedBox(
//                                     width: 40,
//                                   ),
//                                   Center(
//                                       child: Text(
//                                         S .current.add,//'ADD',
//                                         style:
//                                         TextStyle(
//                                           color: Theme.of(
//                                               context)
//                                               .buttonColor /*ColorCodes.lightblue*/,
//                                           fontSize: 18,
//                                         ),
//                                         textAlign:
//                                         TextAlign
//                                             .center,
//                                       )),
//                                   Spacer(),
//                                   Container(
//                                     decoration:
//                                     BoxDecoration(
//                                         color: ColorCodes.greenColor,
//                                         borderRadius:
//                                         new BorderRadius.only(
//                                           topLeft:
//                                           const Radius.circular(2),
//                                           bottomLeft:
//                                           const Radius.circular(2),
//                                           topRight:
//                                           const Radius.circular(3),
//                                           bottomRight:
//                                           const Radius.circular(3),
//                                         )),
//                                     height: 50,
//                                     width: 40,
//                                     child: Icon(
//                                       Icons.add,
//                                       size: 20,
//                                       color: Colors
//                                           .white,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         else
//                           return Container(
//                             child: Row(
//                               children: <Widget>[
//                                 GestureDetector(
//                                   onTap: () async {
//                                     // setState(() {
//                                     //   _isAddToCart = true;
//                                     //   incrementToCart(_varQty - 1);
//                                     // });
//                                     if(int.parse(box.where((element) => element.varId==varid).first.quantity!) > 0)
//                                       cartcontroller.update((done){
//                                         setState(() {
//                                           _isAddToCart = !done;
//                                         });
//                                       },quantity: (int.parse(box.where((element) => element.varId==varid).first.quantity!)<= int.parse(varminitem))?"0":(int.parse(box.where((element) => element.varId==varid).first.quantity!) - 1).toString(),var_id: varid,price: memberpriceDisplay?varmemberprice:varprice);
//
//                                     // VxRemoveCart(context, productBox: productBox, varQty: _varQty, varminitem: varminitem, isAddToCart: _isAddToCart, varid: varid, varprice: varprice, singleitemvar: singleitemvar, itemid: itemid, varname: varname, varmaxitem: varmaxitem, varLoyalty: varLoyalty, varstock: varstock, varmrp: varmrp, itemname: itemname, varmemberprice: varmemberprice, itemimg: itemimg, veg_type: veg_type, type: type, eligibleforexpress: eligibleforexpress, delivery: delivery, duration: duration, durationType: durationType);
//
//                                   },
//                                   child: (Features.isSubscription)?
//                                   Container(
//                                       width: 30,
//                                       height: 30,
//                                       decoration:
//                                       new BoxDecoration(
//                                           border: Border
//                                               .all(
//                                             color: Theme
//                                                 .of(context)
//                                                 .primaryColor,
//                                           ),
//                                           borderRadius:
//                                           new BorderRadius.only(
//                                             bottomLeft:
//                                             const Radius.circular(2.0),
//                                             topLeft:
//                                             const Radius.circular(2.0),
//                                           )),
//                                       child: Center(
//                                         child: Text(
//                                           "-",
//                                           textAlign:
//                                           TextAlign
//                                               .center,
//                                           style:
//                                           TextStyle(
//                                             color: Theme
//                                                 .of(context)
//                                                 .primaryColor,
//                                           ),
//                                         ),
//                                       ))
//                                       :Container(
//                                     //margin: EdgeInsets.fromLTRB(10, 5, 5, 5),
//                                       width: 50,
//                                       height: 60,
//                                       decoration:
//                                       new BoxDecoration(
//                                           color: ColorCodes.greenColor,
//                                           border: Border
//                                               .all(
//                                             color: ColorCodes.greenColor,
//                                             width: 2,
//                                           ),
//                                           borderRadius:
//                                           new BorderRadius.only(
//                                             bottomLeft:
//                                             const Radius.circular(3),
//                                             topLeft:
//                                             const Radius.circular(3),
//                                           )),
//                                       child: Center(
//                                         child: Text(
//                                           "-",
//                                           textAlign:
//                                           TextAlign
//                                               .center,
//                                           style:
//                                           TextStyle(
//                                               color: ColorCodes.whiteColor,
//                                               fontSize: 25,
//                                               fontWeight: FontWeight.bold
//                                           ),
//                                         ),
//                                       )),
//                                 ),
//                                 Expanded(
//                                   child: _isAddToCart ?
//                                   Container(
//                                     decoration: BoxDecoration(color: (Features.isSubscription)? Theme
//                                         .of(context)
//                                         .primaryColor:ColorCodes.whiteColor,),
//                                     height: 60,
//
//                                     child: Center(
//                                       child: SizedBox(
//                                           width: 20.0,
//                                           height: 20.0,
//                                           child: new CircularProgressIndicator(
//                                             strokeWidth: 2.0,
//                                             valueColor: new AlwaysStoppedAnimation<Color>(ColorCodes.greenColor),)),
//                                     ),
//                                   )
//                                       :
//                                   VxBuilder(
//                                       mutations: {SetCartItem},
//                                       // valueListenable: Hive.box<Product>(productBoxName).listenable(),
//                                       builder: (context,GroceStore store, index) {
//                                         final box = (VxState.store as GroceStore).CartItemList.where((element) => element.varId==varid);
//
//                                         if (box.isEmpty) return SizedBox.shrink();
//                                         return  (Features.isSubscription)?
//                                         Container(
// //                                            width: 40,
//                                             decoration:
//                                             BoxDecoration(
//                                               color: Theme
//                                                   .of(context)
//                                                   .primaryColor,
//                                             ),
//                                             height: 60,
//                                             child: Center(
//                                               child: Text(
//                                                 box.first.quantity.toString(),
//                                                 textAlign:
//                                                 TextAlign
//                                                     .center,
//                                                 style:
//                                                 TextStyle(
//                                                   color: ColorCodes.greenColor,
//                                                 ),
//                                               ),
//                                             ))
//                                             :Container(
// //                                            width: 40,
//                                             decoration:
//                                             BoxDecoration(
//                                               color: ColorCodes.whiteColor,
//                                             ),
//                                             height: 60,
//                                             child: Center(
//                                               child: Text(
//                                                 box.first.quantity.toString(),
//                                                 textAlign:
//                                                 TextAlign
//                                                     .center,
//                                                 style:
//                                                 TextStyle(
//                                                   color:ColorCodes.greenColor,
//                                                   fontSize: 20,
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                               ),
//                                             ));
//                                       }),
//                                 ),
//                                 GestureDetector(
//                                   onTap: () {
//                                     List<SellingItemsFields> list = [];
//                                     box.forEach((element) {
//                                       if(element.varId==varid) list.add(SellingItemsFields(weight: weight,varQty:int.parse(element.quantity!)));
//                                     });
//                                      if (Features.btobModule?Check().isOutofStockSingleProduct(pm.PriceVariation(quantity:(int.parse(box.where((element) => element.varId==varid).first.quantity!) ) ,weight: weight.toString()), double.parse(singleitemvar.last.varmaxitem!),type, list)
//                                         :Check().isOutofStockSingleProduct(pm.PriceVariation(quantity: (int.parse(box.where((element) => element.varId==varid).first.quantity!)) ,weight: weight.toString()), double.parse(varstock),type, list)) {
//                                       Fluttertoast.showToast(
//                                           msg: S .of(context).sorry_outofstock,//"Sorry, Out of Stock!",
//                                           fontSize: MediaQuery.of(context).textScaleFactor *13, backgroundColor: Colors.black87, textColor: Colors.white);
//                                     } else {
//                                       cartcontroller.update((done){
//                                         setState(() {
//                                           _isAddToCart = !done;
//                                         });
//                                       },quantity: (int.parse(box.where((element) => element.varId==varid).first.quantity!) +1).toString(),var_id: varid,price: memberpriceDisplay?varmemberprice:varprice);
//
//                                     }
//                                     // if (int.parse(box.first.quantity!) < int.parse(varstock)) {
//                                     //   if (int.parse(box.first.quantity!) < int.parse(varmaxitem)) {
//                                     //     // setState(() {
//                                     //     //   _isAddToCart = true;
//                                     //     // });
//                                     //
//                                     //     // VxAddCart(context, productBox: productBox, varQty: _varQty, varminitem: varminitem, isAddToCart: _isAddToCart, varid: varid, varprice: varprice, singleitemvar: singleitemvar, itemid: itemid, varname: varname, varmaxitem: varmaxitem, varLoyalty: varLoyalty, varstock: varstock, varmrp: varmrp, itemname: itemname, varmemberprice: varmemberprice, itemimg: itemimg, veg_type: veg_type, type: type, eligibleforexpress: eligibleforexpress, delivery: delivery, duration: duration, durationType: durationType);
//                                     //     // incrementToCart(_varQty + 1);
//                                     //   } else {
//                                     //     Fluttertoast.showToast(
//                                     //         msg:
//                                     //         S .current.cant_add_more_item,
//                                     //         fontSize: MediaQuery.of(context).textScaleFactor *13,
//                                     //         backgroundColor:
//                                     //         Colors
//                                     //             .black87,
//                                     //         textColor:
//                                     //         Colors.white);
//                                     //   }
//                                     // } else {
//                                     //   Fluttertoast.showToast(msg: S .current.sorry_outofstock,  fontSize: MediaQuery.of(context).textScaleFactor *13,backgroundColor: Colors.black87, textColor: Colors.white);
//                                     // }
//                                   },
//                                   child: (Features.isSubscription)?
//                                   Container(
//                                       width: 50,
//                                       height: 60,
//                                       decoration:
//                                       new BoxDecoration(
//                                           border: Border
//                                               .all(
//                                             color: Theme
//                                                 .of(context)
//                                                 .primaryColor,
//                                           ),
//                                           borderRadius:
//                                           new BorderRadius.only(
//                                             bottomRight:
//                                             const Radius.circular(2.0),
//                                             topRight:
//                                             const Radius.circular(2.0),
//                                           )),
//                                       child: Center(
//                                         child: Text(
//                                           "+",
//                                           textAlign:
//                                           TextAlign
//                                               .center,
//                                           style:
//                                           TextStyle(
//                                             color: Theme
//                                                 .of(context)
//                                                 .primaryColor,
//                                           ),
//                                         ),
//                                       ))
//                                       :Container(
//                                     //  margin: EdgeInsets.fromLTRB(5, 5, 10, 5),
//                                       width: 50,
//                                       height: 60,
//                                       decoration:
//                                       new BoxDecoration(
//                                         color:ColorCodes.greenColor,
//                                         border: Border
//                                             .all(
//                                           color: ColorCodes.greenColor,
//                                           width: 2,
//                                         ),
//                                         borderRadius:
//                                         new BorderRadius.only(
//                                           bottomRight:
//                                           const Radius.circular(3),
//                                           topRight:
//                                           const Radius.circular(3),
//                                         ),
//                                       ),
//                                       child: Center(
//                                         child: Text(
//                                           "+",
//                                           textAlign:
//                                           TextAlign
//                                               .center,
//                                           style:
//                                           TextStyle(
//                                               color: ColorCodes.whiteColor,
//                                               fontSize: 25,
//                                               fontWeight: FontWeight.bold
//                                           ),
//                                         ),
//                                       )),
//                                 ),
//                               ],
//                             ),
//                           );
//                         /*try {
//                                               Product item = Hive.box<
//                                                   Product>(
//                                                   productBoxName)
//                                                   .values
//                                                   .firstWhere((value) =>
//                                               value.varId ==
//                                                   int.parse(varid));
//                                               return Container(
//                                                 child: Row(
//                                                   children: <Widget>[
//                                                     GestureDetector(
//                                                       onTap: () async {
//                                                         setState(() {
//                                                           _isAddToCart = true;
//                                                           incrementToCart(item.itemQty - 1);
//                                                         });
//                                                       },
//                                                       child: Container(
//                                                           width: 30,
//                                                           height: 30,
//                                                           decoration:
//                                                           new BoxDecoration(
//                                                               border: Border
//                                                                   .all(
//                                                                 color: ColorCodes.greenColor,
//                                                               ),
//                                                               borderRadius:
//                                                               new BorderRadius.only(
//                                                                 bottomLeft:
//                                                                 const Radius.circular(2.0),
//                                                                 topLeft:
//                                                                 const Radius.circular(2.0),
//                                                               )),
//                                                           child: Center(
//                                                             child: Text(
//                                                               "-",
//                                                               textAlign:
//                                                               TextAlign
//                                                                   .center,
//                                                               style:
//                                                               TextStyle(
//                                                                 color: ColorCodes.greenColor,
//                                                               ),
//                                                             ),
//                                                           )),
//                                                     ),
//                                                     Expanded(
//                                                       child: _isAddToCart ?
//                                                       Container(
//                                                         decoration: BoxDecoration(color: ColorCodes.greenColor,),
//                                                         height: 30,
//
//                                                         child: Center(
//                                                           child: SizedBox(
//                                                               width: 20.0,
//                                                               height: 20.0,
//                                                               child: new CircularProgressIndicator(
//                                                                 strokeWidth: 2.0,
//                                                                 valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)),
//                                                         ),
//                                                       )
//                                                           :
//                                                       Container(
// //                                            width: 40,
//                                                           decoration:
//                                                           BoxDecoration(
//                                                             color: ColorCodes.greenColor,
//                                                           ),
//                                                           height: 30,
//                                                           child: Center(
//                                                             child: Text(
//                                                               item.itemQty.toString(),
//                                                               textAlign:
//                                                               TextAlign
//                                                                   .center,
//                                                               style:
//                                                               TextStyle(
//                                                                 color: Theme.of(context)
//                                                                     .buttonColor,
//                                                               ),
//                                                             ),
//                                                           )),
//                                                     ),
//                                                     GestureDetector(
//                                                       onTap: () {
//                                                         if (item.itemQty < int.parse(varstock)) {
//                                                           if (item.itemQty < int.parse(varmaxitem)) {
//                                                             setState(() {
//                                                               _isAddToCart = true;
//                                                             });
//                                                             incrementToCart(item.itemQty + 1);
//                                                           } else {
//                                                             Fluttertoast.showToast(
//                                                                 msg:
//                                                                 "Sorry, you can\'t add more of this item!",
//                                                                 backgroundColor:
//                                                                 Colors
//                                                                     .black87,
//                                                                 textColor:
//                                                                 Colors.white);
//                                                           }
//                                                         } else {
//                                                           Fluttertoast.showToast(msg: "Sorry, Out of Stock!", backgroundColor: Colors.black87, textColor: Colors.white);
//                                                         }
//                                                       },
//                                                       child: Container(
//                                                           width: 30,
//                                                           height: 30,
//                                                           decoration:
//                                                           new BoxDecoration(
//                                                               border: Border
//                                                                   .all(
//                                                                 color: ColorCodes.greenColor,
//                                                               ),
//                                                               borderRadius:
//                                                               new BorderRadius.only(
//                                                                 bottomRight:
//                                                                 const Radius.circular(2.0),
//                                                                 topRight:
//                                                                 const Radius.circular(2.0),
//                                                               )),
//                                                           child: Center(
//                                                             child: Text(
//                                                               "+",
//                                                               textAlign:
//                                                               TextAlign
//                                                                   .center,
//                                                               style:
//                                                               TextStyle(
//                                                                 color: ColorCodes.greenColor,
//                                                               ),
//                                                             ),
//                                                           )),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               );
//                                             } catch (e) {
//                                               return GestureDetector(
//                                                 onTap: () {
//                                                   setState(() {
//                                                     _isAddToCart = true;
//                                                   });
//                                                   addToCart(int.parse(varminitem));
//                                                 },
//                                                 child: Container(
//                                                   height: 30.0,
//                                                   width: (MediaQuery.of(context).size.width / 4) + 15,
//                                                   decoration:
//                                                   new BoxDecoration(
//                                                       color: ColorCodes.greenColor,
//                                                       borderRadius:
//                                                       new BorderRadius
//                                                           .only(
//                                                         topLeft:
//                                                         const Radius.circular(
//                                                             2.0),
//                                                         topRight:
//                                                         const Radius.circular(
//                                                             2.0),
//                                                         bottomLeft:
//                                                         const Radius.circular(
//                                                             2.0),
//                                                         bottomRight:
//                                                         const Radius.circular(
//                                                             2.0),
//                                                       )),
//                                                   child: _isAddToCart ?
//                                                   Center(
//                                                     child: SizedBox(
//                                                         width: 20.0,
//                                                         height: 20.0,
//                                                         child: new CircularProgressIndicator(
//                                                           strokeWidth: 2.0,
//                                                           valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)),
//                                                   )
//                                                       :
//                                                   Row(
//                                                     children: [
//                                                       SizedBox(
//                                                         width: 10,
//                                                       ),
//                                                       Center(
//                                                           child: Text(
//                                                             S .current.add,//'ADD',
//                                                             style:
//                                                             TextStyle(
//                                                               color: Theme.of(
//                                                                   context)
//                                                                   .buttonColor,
//                                                             ),
//                                                             textAlign:
//                                                             TextAlign
//                                                                 .center,
//                                                           )),
//                                                       Spacer(),
//                                                       Container(
//                                                         decoration:
//                                                         BoxDecoration(
//                                                             color: Color(
//                                                                 0xff1BA130),
//                                                             borderRadius:
//                                                             new BorderRadius.only(
//                                                               topLeft:
//                                                               const Radius.circular(2.0),
//                                                               bottomLeft:
//                                                               const Radius.circular(2.0),
//                                                               topRight:
//                                                               const Radius.circular(2.0),
//                                                               bottomRight:
//                                                               const Radius.circular(2.0),
//                                                             )),
//                                                         height: 30,
//                                                         width: 25,
//                                                         child: Icon(
//                                                           Icons.add,
//                                                           size: 12,
//                                                           color: Colors
//                                                               .white,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               );
//                                             }*/
//                       },
//                   ),
//                 ),
//                     )
//                     : Expanded(
//                       child: GestureDetector(
//                   onTap: () {
//                       checkskip
//                           ? /*Navigator.of(context).pushNamed(
//                         SignupSelectionScreen.routeName,
//                       )*/
//                       Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
//                           : _notifyMe();
//                       // Fluttertoast.showToast(
//                       //     msg:  "You will be notified via SMS/Push notification, when the product is available" ,
//                       //     /*"Out Of Stock",*/
//                       //     fontSize: 12.0,
//                       //     backgroundColor:
//                       //     Colors.black87,
//                       //     textColor: Colors.white);
//                   },
//                   child:
//                       Container(
//                         height: 60.0,
//                         width:(_isWeb && ResponsiveLayout.isMediumScreen(context))?( MediaQuery.of(context)
//                             .size
//                             .width /
//                             2) +
//                             400:
//                         (_isWeb && ResponsiveLayout.isSmallScreen(context))?
//                         ( MediaQuery.of(context)
//                             .size
//                             .width /
//                             2) +
//                             210
//                             :
//                         ( MediaQuery.of(context)
//                             .size
//                             .width /
//                             2) +
//                             150,
//                         //width: (MediaQuery.of(context).size.width / 2) + 150,
//                         decoration: new BoxDecoration(
//                             border: Border.all(
//                                 color:  (Features.isSubscription)?ColorCodes.primaryColor:ColorCodes.greenColor),
//                             color:  (Features.isSubscription)?ColorCodes.primaryColor:ColorCodes.greenColor,
//                             borderRadius:
//                             new BorderRadius.only(
//                               topLeft: const Radius
//                                   .circular(3.0),
//                               topRight: const Radius
//                                   .circular(3.0),
//                               bottomLeft: const Radius
//                                   .circular(3.0),
//                               bottomRight:
//                               const Radius
//                                   .circular(3.0),
//                             )),
//                         child:
//                         _isNotify ?
//                         Center(
//                           child: SizedBox(
//                               width: 20.0,
//                               height: 20.0,
//                               child: new CircularProgressIndicator(
//                                 strokeWidth: 2.0,
//                                 valueColor: new AlwaysStoppedAnimation<
//                                     Color>(Colors.white),)),
//                         )
//                             :
//                         Row(
//                           children: [
//                             SizedBox(
//                               width: 30,
//                             ),
//                             Center(
//                                 child: Text(
//                                   S .current.notify_me,
//                                   /* "ADD",*/
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w700,
//                                       color: Colors
//                                           .white ),
//                                   textAlign:
//                                   TextAlign.center,
//                                 )),
//                             Spacer(),
//                             Container(
//                               decoration:
//                               BoxDecoration(
//                                   color: Colors
//                                       .black12,
//                                   borderRadius:
//                                   new BorderRadius
//                                       .only(
//                                     topRight:
//                                     const Radius
//                                         .circular(
//                                         3.0),
//                                     bottomRight:
//                                     const Radius
//                                         .circular(
//                                         3.0),
//                                   )),
//                               height: 60,
//                               width: 40,
//                               child: Icon(
//                                 Icons.add,
//                                 size: 12,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//
//                 ),
//                     ),
//               ],
//             ),
//           );
//         },
//       );
//     }
//
//     Widget createHeaderForMobile() {
//       return Container(
//
//         height: 50,
//         width: MediaQuery
//             .of(context)
//             .size
//             .width,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.bottomLeft,
//             end: Alignment.topRight,
//             colors: [
//               ColorCodes.accentColor,
//               ColorCodes.primaryColor
//             ],
//           ),
//         ),
//         child: Row(
//           //mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Padding(padding: EdgeInsets.only(left: 30)),
//
//             GestureDetector(
//               behavior: HitTestBehavior.translucent,
//               child: Icon(
//                 Icons.keyboard_backspace,
//                 color: ColorCodes.menuColor,
//               ),
//               onTap: () {
//                 Navigator.of(context).popUntil(
//                     ModalRoute.withName(HomeScreen.routeName,));
//               },
//             ),
//
//             Padding(padding: EdgeInsets.only(left: 30)),
//
//             Text(itemname, style: TextStyle(
//               color: ColorCodes.menuColor,
//               fontSize: 21,
//               //fontWeight: FontWeight.bold,
//             ),),
//
//             Spacer(),
//
//             Container(
//               width: 25,
//               height: 25,
//               margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(100),
//                 color: Colors.white,
//               ),
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.of(context).pushNamed(
//                     SearchitemScreen.routeName,
//                   );
//                 },
//                 child: Icon(
//                   Icons.search,
//                   size: 20,
//                   color: Theme
//                       .of(context)
//                       .primaryColor,
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: 15,
//             ),
//             if(Features.isShare)
//               Container(
//                 width: 25,
//                 height: 25,
//                 margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(100),
//                   color: Colors.white,
//                 ),
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.of(context).pop();
//                     if (_isIOS) {
//                       Share.share(S .current.download_app +
//                           IConstants.APP_NAME +
//                           '${S .current.from_app_store} https://apps.apple.com/us/app/id' + IConstants.appleId);
//                     } else {
//                       Share.share(S .current.download_app +
//                           IConstants.APP_NAME +
//                           '${S .current.from_google_play_store} https://play.google.com/store/apps/details?id=' + IConstants.androidId);
//                     }
//                   },
//                   child: Icon(
//                     Icons.share_outlined,
//                     size: 20,
//                     color: Theme
//                         .of(context)
//                         .primaryColor,
//                   ),
//                 ),
//               ),
//             SizedBox(
//               width: 15,
//             ),
//             VxBuilder(
//               mutations: {SetCartItem},
//               // valueListenable: Hive.box<Product>(productBoxName).listenable(),
//               builder: (context,GroceStore store, index) {
//                 final box = (VxState.store as GroceStore).CartItemList;
//
//                 if (box.isEmpty)
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).pushNamed(CartScreen.routeName,arguments: {
//                         "after_login": ""
//                       });
//                     },
//                     child: Container(
//                       margin: EdgeInsets.only(top: 10, right: 10, bottom: 10),
//                       width: 25,
//                       height: 25,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(100),
//                           color: Theme.of(context).buttonColor),
//                       child: Icon(
//                         Icons.shopping_cart_outlined,
//                         size: 18,
//                         color: Theme.of(context).primaryColor,
//                       ),
//                     ),
//                   );
//
//
//                 return Consumer<CartCalculations>(
//                   builder: (_, cart, ch) => Badge(
//                     child: ch!,
//                     color: ColorCodes.darkgreen,
//                     value: CartCalculations.itemCount.toString(),
//                   ),
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).pushNamed(CartScreen.routeName,arguments: {
//                         "after_login": ""
//                       });
//                     },
//                     child: Container(
//                       margin: EdgeInsets.only(top: 10, right: 10, bottom: 10),
//                       width: 25,
//                       height: 25,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(100),
//                           color: Theme.of(context).buttonColor),
//                       child: Icon(
//                         Icons.shopping_cart_outlined,
//                         size: 18,
//                         color: Theme.of(context).primaryColor,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//             Padding(padding: EdgeInsets.only(right: 20)),
//           ],
//         ),
//       );
//     }
//
//     Widget _responsiveAppBar() {
//       if (ResponsiveLayout.isSmallScreen(context)) {
//         return createHeaderForMobile();
//       } else {
//         return Header(false);
//       }
//     }
//
//     Widget _firstHalfImage() {
//       return Container(
//         padding: EdgeInsets.only(left: 130, right: 130),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             !_isStock
//                 ? Consumer<CartCalculations>(
//               builder: (_, cart, ch) =>
//                   BadgeOfStock(
//                     child: ch!,
//                     value: margins,
//                     singleproduct: true,
//                   ),
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.of(context).pushNamed(
//                       SingleProductImageScreen.routeName,
//                       arguments: {
//                         "itemid": itemid,
//                         "itemname": itemname,
//                         "itemimg": itemimg,
//                         "fromScreen": fromScreen.toString() == "NotificationScreen"?"NotificationScreen":"",
//                         'notificationFor': notificationFor.toString(),
//                       });
//                 },
//                 child: Container(
//                   width: MediaQuery.of(context).size.width * 0.2,
//                   child: GFCarousel(
//                     autoPlay: true,
//                     viewportFraction: 1.0,
//                     height: 173,
//                     pagination: true,
//                     passiveIndicator: Colors.white,
//                     activeIndicator:
//                     Theme
//                         .of(context)
//                         .accentColor,
//                     autoPlayInterval: Duration(seconds: 8),
//                     items: <Widget>[
//                       for (var i = 0;
//                       i < multiimage.length;
//                       i++)
//                         Builder(
//                           builder: (BuildContext context) {
//                             return GestureDetector(
//                               onTap: () {},
//                               child: Container(
//                                   margin: EdgeInsets.symmetric(
//                                       horizontal: 5.0),
//                                   child: ClipRRect(
//                                       borderRadius:
//                                       BorderRadius.all(
//                                           Radius.circular(
//                                               5.0)),
//                                       child: CachedNetworkImage(
//                                           imageUrl: multiimage[i].imageUrl,
//                                           placeholder: (context, url) => Image.asset(Images.defaultProductImg),
//                                           errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg),
//                                           fit: BoxFit.fill))),
//                             );
//                           },
//                         )
//                     ],
//                   ),
//                 ),
//               ),
//             )
//                 : GestureDetector(
//               onTap: () {
//                 Navigator.of(context).pushNamed(
//                     SingleProductImageScreen.routeName,
//                     arguments: {
//                       "itemid": itemid,
//                       "itemname": itemname,
//                       "itemimg": itemimg,
//                       "fromScreen":fromScreen.toString() == "NotificationScreen"?"NotificationScreen":"",
//                       'notificationFor': notificationFor.toString(),
//                     });
//               },
//               child: Container(
//                 width: MediaQuery.of(context).size.width * 0.2,
//                 child: GFCarousel(
//                   autoPlay: true,
//                   viewportFraction: 1.0,
//                   height: 173,
//                   pagination: true,
//                   passiveIndicator: Colors.white,
//                   activeIndicator:
//                   Theme
//                       .of(context)
//                       .accentColor,
//                   autoPlayInterval: Duration(seconds: 8),
//                   items: <Widget>[
//                     for (var i = 0; i < multiimage.length; i++)
//                       Builder(
//                         builder: (BuildContext context) {
//                           return GestureDetector(
//                             onTap: () {},
//                             child: Container(
//                                 margin: EdgeInsets.symmetric(
//                                     horizontal: 5.0),
//                                 child: ClipRRect(
//                                     borderRadius:
//                                     BorderRadius.all(
//                                         Radius.circular(
//                                             5.0)),
//                                     child: CachedNetworkImage(
//                                       imageUrl: multiimage[i].imageUrl,
//                                       placeholder: (context, url) => Image.asset(Images.defaultProductImg),
//                                       errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg),
//                                       fit: BoxFit.fill,
//                                     )
//                                 )),
//                           );
//                         },
//                       )
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//
//     Widget _addButton() {
//       return Container(
//         //width: 500,
//         child: Column(
//           //crossAxisAlignment: CrossAxisAlignment.start,
//           //mainAxisAlignment: MainAxisAlignment.end,
//           children: [
// /*            SizedBox(
//               height: 10,
//             ),*/
//             (Features.isSubscription)?
//             (singleitemData.singleitems[0].subscribe == "0")?
//             _isStock?
//             MouseRegion(
//               cursor: SystemMouseCursors.click,
//               child: GestureDetector(
//                 onTap: () {
//                   if(checkskip &&_isWeb && !ResponsiveLayout.isSmallScreen(context)){
//                     //_dialogforSignIn();
//                     LoginWeb(context,result: (sucsess){
//                       if(sucsess){
//                         Navigator.of(context).pop();
//                         Navigator.pushNamedAndRemoveUntil(
//                             context, HomeScreen.routeName, (route) => false);
//                       }else{
//                         Navigator.of(context).pop();
//                       }
//                     });
//                   }
//                   else {
//                     (checkskip) ?
//                    /* Navigator.of(context).pushNamed(
//                       SignupSelectionScreen.routeName,
//                     )*/
//                     Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push):
//                     Navigator.of(context).pushNamed(
//                         SubscribeScreen.routeName,
//                         arguments: {
//                           "itemid": singleitemData.singleitems[0].id,
//                           "itemname": singleitemData.singleitems[0].title,
//                           "itemimg": singleitemData.singleitems[0].imageUrl,
//                           "varname": varname+unit,
//                           "varmrp":varmrp,
//                           "varprice":  _checkmembership ? varmemberprice :discountDisplay ?varprice:varmrp,
//                           "paymentMode": singleitemData.singleitems[0].paymentmode,
//                           "cronTime": singleitemData.singleitems[0].cronTime,
//                           "name": singleitemData.singleitems[0].name,
//                           "varid": varid.toString(),
//                           "brand": singleitemData.singleitems[0].brand
//                         }
//                     );
//                   }
//
//                 },
//                 child: Container(
//                   height: 30.0,
//                   width: (MediaQuery.of(context).size.width / 8.5),
//                   decoration: new BoxDecoration(
//                     border:Border.all(color: ColorCodes.primaryColor),
//                     color: ColorCodes.whiteColor,
//                       borderRadius: new BorderRadius.only(
//                         topLeft: const Radius.circular(2.0),
//                         topRight: const Radius.circular(2.0),
//                         bottomLeft: const Radius.circular(2.0),
//                         bottomRight: const Radius.circular(2.0),
//                       ),),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//
//                       Text(
//                         S .current.subscribe,
//                         style: TextStyle(
//                             color: ColorCodes.primaryColor,
//                             fontSize: 12, fontWeight: FontWeight.bold),
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ) ,
//                 ),
//               ),
//             ):
//             SizedBox(height: 30,)
//                 :
//             SizedBox(height: 30,):SizedBox.shrink(),
//             SizedBox(
//               height: 10,
//             ),
//             _isStock
//                 ? Container(
//               height: 30.0,
//               width: (MediaQuery.of(context).size.width / 8.5),
//               child: VxBuilder(
//                 mutations: {SetCartItem},
//                 builder: (context,GroceStore store, index) {
//                   final box = (VxState.store as GroceStore).CartItemList;
//                  // if (box.where((element) => element.varId==varid).length <= 0  || int.parse(box.where((element) => element.varId==varid).first.quantity) <= 0)
//                   if (box.where((element) => element.varId==varid).length <= 0  || int.parse(box.where((element) => element.varId==varid).first.quantity!) <= 0)
//                     return GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           _isAddToCart = true;
//                         });
//                         addToCart(int.parse(varminitem));
//                       },
//                       child: Container(
//                         height: 30.0,
//                         width: (MediaQuery.of(context).size.width / 4) + 15,
//                         decoration:
//                         new BoxDecoration(
//                             color: (Features.isSubscription)? ColorCodes.primaryColor:ColorCodes.greenColor,
//                             borderRadius:
//                             new BorderRadius
//                                 .only(
//                               topLeft:
//                               const Radius.circular(
//                                   2.0),
//                               topRight:
//                               const Radius.circular(
//                                   2.0),
//                               bottomLeft:
//                               const Radius.circular(
//                                   2.0),
//                               bottomRight:
//                               const Radius.circular(
//                                   2.0),
//                             )),
//                         child: _isAddToCart ?
//                         Center(
//                           child: SizedBox(
//                               width: 20.0,
//                               height: 20.0,
//                               child: new CircularProgressIndicator(
//                                 strokeWidth: 2.0,
//                                 valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)),
//                         )
//                             :
//                         (Features.isSubscription)?
//                         Center(
//                             child: Text(
//                               S .current.buy_once,
//                               style:
//                               TextStyle(
//                                 color: ColorCodes.whiteColor,
//                               ),
//                               textAlign:
//                               TextAlign
//                                   .center,
//                             )):
//                         Row(
//                           children: [
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Center(
//                                 child: Text(
//                                     S .current.add,//'ADD',
//                                   style:
//                                   TextStyle(
//                                     color: Theme
//                                         .of(
//                                         context)
//                                         .buttonColor,
//                                   ),
//                                   textAlign:
//                                   TextAlign
//                                       .center,
//                                 )),
//                             Spacer(),
//                             Container(
//                               decoration:
//                               BoxDecoration(
//                                   color:  ColorCodes.greenColor,
//                                   borderRadius:
//                                   new BorderRadius.only(
//                                     topLeft:
//                                     const Radius.circular(2.0),
//                                     bottomLeft:
//                                     const Radius.circular(2.0),
//                                     topRight:
//                                     const Radius.circular(2.0),
//                                     bottomRight:
//                                     const Radius.circular(2.0),
//                                   )),
//                               height: 50,
//                               width: 25,
//                               child: Icon(
//                                 Icons.add,
//                                 size: 12,
//                                 color: Colors
//                                     .white,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   else
//                     return Container(
//                       child: Row(
//                         children: <Widget>[
//                           GestureDetector(
//                             onTap: () async {
//                               // setState(() {
//                               //   _isAddToCart = true;
//                               //  // VxRemoveCart(context, productBox: productBox, varQty: _varQty, varminitem: varminitem, isAddToCart: _isAddToCart, varid: varid, varprice: varprice, singleitemvar: singleitemvar, itemid: itemid, varname: varname, varmaxitem: varmaxitem, varLoyalty: varLoyalty, varstock: varstock, varmrp: varmrp, itemname: itemname, varmemberprice: varmemberprice, itemimg: itemimg, veg_type: veg_type, type: type, eligibleforexpress: eligibleforexpress, delivery: delivery, duration: duration, durationType: durationType);
//                               // // cartcontroller.removecart();
//                               // //   incrementToCart(_varQty - 1);
//                               // });
//                               if(int.parse(box.where((element) => element.varId==varid).first.quantity!) > 0)
//                               cartcontroller.update((done){
//                                 setState(() {
//                                   _isAddToCart = !done;
//                                 });
//                               },quantity: (int.parse(box.where((element) => element.varId==varid).first.quantity!)<= int.parse(varminitem))?"0":(int.parse(box.where((element) => element.varId==varid).first.quantity!) - 1).toString(),var_id: varid,price: memberpriceDisplay?varmemberprice:varprice);
//
//                             },
//                             child: Container(
//                                 width: 30,
//                                 height: 30,
//                                 decoration:
//                                 new BoxDecoration(
//                                     border: Border
//                                         .all(
//                                       color: (Features.isSubscription)? ColorCodes.primaryColor:ColorCodes.greenColor,
//                                     ),
//                                     borderRadius:
//                                     new BorderRadius.only(
//                                       bottomLeft:
//                                       const Radius.circular(2.0),
//                                       topLeft:
//                                       const Radius.circular(2.0),
//                                     )),
//                                 child: Center(
//                                   child: Text(
//                                     "-",
//                                     textAlign:
//                                     TextAlign
//                                         .center,
//                                     style:
//                                     TextStyle(
//                                       color: (Features.isSubscription)? ColorCodes.blackColor:ColorCodes.primaryColor,
//                                     ),
//                                   ),
//                                 )),
//                           ),
//                           Expanded(
//                             child: _isAddToCart ?
//                             Container(
//                               decoration:
//                               BoxDecoration(
//                                 color: (Features.isSubscription)? ColorCodes.primaryColor:ColorCodes.greenColor,
//                               ),
//                               height: 30,
//                               child: Center(
//                                 child: SizedBox(
//                                     width: 20.0,
//                                     height: 20.0,
//                                     child: new CircularProgressIndicator(
//                                       strokeWidth: 2.0,
//                                       valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)),
//                               ),
//                             )
//                                 :
//                             Container(
//                                 decoration:
//                                 BoxDecoration(
//                                   color: (Features.isSubscription)? ColorCodes.primaryColor:ColorCodes.greenColor,
//                                 ),
//                                 height: 30,
//                                 child: Center(
//                                   child: Text(
//                                     box.where((element) => element.varId==varid).first.quantity.toString(),
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                       color: (Features.isSubscription)? ColorCodes.whiteColor:ColorCodes.whiteColor,
//                                     ),
//                                   ),
//                                 )),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               if (int.parse(box.where((element) => element.varId==varid).first.quantity!)  < int.parse(varstock)) {
//                                 if (int.parse(box.where((element) => element.varId==varid).first.quantity!)  < int.parse(varmaxitem)) {
//                                   // setState(() {
//                                   //   _isAddToCart = true;
//                                   // });
//                                   // // VxAddCart(context, productBox: productBox, varQty: _varQty, varminitem: varminitem, isAddToCart: _isAddToCart, varid: varid, varprice: varprice, singleitemvar: singleitemvar, itemid: itemid, varname: varname, varmaxitem: varmaxitem, varLoyalty: varLoyalty, varstock: varstock, varmrp: varmrp, itemname: itemname, varmemberprice: varmemberprice, itemimg: itemimg, veg_type: veg_type, type: type, eligibleforexpress: eligibleforexpress, delivery: delivery, duration: duration, durationType: durationType);
//                                   // incrementToCart(_varQty + 1);
//                                   cartcontroller.update((done){
//                                     setState(() {
//                                       _isAddToCart = !done;
//                                     });
//                                   },quantity: (int.parse(box.where((element) => element.varId==varid).first.quantity!) + 1).toString(),var_id: varid,price: memberpriceDisplay?varmemberprice:varprice);
//
//                                 } else {
//                                   Fluttertoast.showToast(
//                                       msg:  S .current.cant_add_more_item,
//                                       fontSize: MediaQuery.of(context).textScaleFactor *13,
//                                       backgroundColor: Colors.black87,
//                                       textColor: Colors.white);
//                                 }
//                               } else {
//                                 Fluttertoast.showToast(
//                                     msg:
//                                     S .current.sorry_outofstock,
//                                     fontSize: MediaQuery.of(context).textScaleFactor *13,
//                                     backgroundColor:
//                                     Colors
//                                         .black87,
//                                     textColor:
//                                     Colors
//                                         .white);
//                               }
//                             },
//                             child: Container(
//                                 width: 30,
//                                 height: 30,
//                                 decoration:
//                                 new BoxDecoration(
//                                     border: Border
//                                         .all(
//                                       color: (Features.isSubscription)? ColorCodes.primaryColor:ColorCodes.greenColor,
//                                     ),
//                                     borderRadius:
//                                     new BorderRadius.only(
//                                       bottomRight:
//                                       const Radius.circular(2.0),
//                                       topRight:
//                                       const Radius.circular(2.0),
//                                     )),
//                                 child: Center(
//                                   child: Text(
//                                     "+",
//                                     textAlign:
//                                     TextAlign
//                                         .center,
//                                     style:
//                                     TextStyle(
//                                       color: (Features.isSubscription)? ColorCodes.blackColor:ColorCodes.greenColor,
//                                     ),
//                                   ),
//                                 )),
//                           ),
//                         ],
//                       ),
//                     );
//
//
//                   /*try {
//                     Product item = Hive
//                         .box<
//                         Product>(
//                         productBoxName)
//                         .values
//                         .firstWhere((value) =>
//                     value.varId ==
//                         int.parse(varid));
//                     return Container(
//                       child: Row(
//                         children: <Widget>[
//                           GestureDetector(
//                             onTap: () async {
//                               setState(() {
//                                 _isAddToCart = true;
//                                 incrementToCart(item.itemQty - 1);
//                               });
//                             },
//                             child: Container(
//                                 width: 30,
//                                 height: 30,
//                                 decoration:
//                                 new BoxDecoration(
//                                     border: Border
//                                         .all(
//                                       color: ColorCodes.greenColor,
//                                     ),
//                                     borderRadius:
//                                     new BorderRadius.only(
//                                       bottomLeft:
//                                       const Radius.circular(2.0),
//                                       topLeft:
//                                       const Radius.circular(2.0),
//                                     )),
//                                 child: Center(
//                                   child: Text(
//                                     "-",
//                                     textAlign:
//                                     TextAlign
//                                         .center,
//                                     style:
//                                     TextStyle(
//                                       color: ColorCodes.greenColor,
//                                     ),
//                                   ),
//                                 )),
//                           ),
//                           Expanded(
//                             child: _isAddToCart ?
//                             Container(
//                               decoration:
//                               BoxDecoration(
//                                 color: ColorCodes.greenColor,
//                               ),
//                               height: 30,
//                               child: Center(
//                                 child: SizedBox(
//                                     width: 20.0,
//                                     height: 20.0,
//                                     child: new CircularProgressIndicator(
//                                       strokeWidth: 2.0,
//                                       valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)),
//                               ),
//                             )
//                                 :
//                             Container(
//                                 decoration:
//                                 BoxDecoration(
//                                   color: ColorCodes.greenColor,
//                                 ),
//                                 height: 30,
//                                 child: Center(
//                                   child: Text(
//                                     item.itemQty.toString(),
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                       color: Theme
//                                           .of(context)
//                                           .buttonColor,
//                                     ),
//                                   ),
//                                 )),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               if (item.itemQty < int.parse(varstock)) {
//                                 if (item.itemQty < int.parse(varmaxitem)) {
//                                   setState(() {
//                                     _isAddToCart = true;
//                                   });
//                                   incrementToCart(item.itemQty + 1);
//                                 } else {
//                                   Fluttertoast.showToast(
//                                       msg: "Sorry, you can\'t add more of this item!",
//                                       backgroundColor: Colors.black87,
//                                       textColor: Colors.white);
//                                 }
//                               } else {
//                                 Fluttertoast.showToast(
//                                     msg:
//                                     "Sorry, Out of Stock!",
//                                     backgroundColor:
//                                     Colors
//                                         .black87,
//                                     textColor:
//                                     Colors
//                                         .white);
//                               }
//                             },
//                             child: Container(
//                                 width: 30,
//                                 height: 30,
//                                 decoration:
//                                 new BoxDecoration(
//                                     border: Border
//                                         .all(
//                                       color: ColorCodes.greenColor,
//                                     ),
//                                     borderRadius:
//                                     new BorderRadius.only(
//                                       bottomRight:
//                                       const Radius.circular(2.0),
//                                       topRight:
//                                       const Radius.circular(2.0),
//                                     )),
//                                 child: Center(
//                                   child: Text(
//                                     "+",
//                                     textAlign:
//                                     TextAlign
//                                         .center,
//                                     style:
//                                     TextStyle(
//                                       color: ColorCodes.greenColor,
//                                     ),
//                                   ),
//                                 )),
//                           ),
//                         ],
//                       ),
//                     );
//                   } catch (e) {
//                     return GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           _isAddToCart = true;
//                         });
//                         addToCart(int.parse(varminitem));
//                       },
//                       child: Container(
//                         height: 30.0,
//                         width: 50,
//                         decoration:
//                         new BoxDecoration(
//                             color: ColorCodes.greenColor,
//                             borderRadius:
//                             new BorderRadius
//                                 .only(
//                               topLeft:
//                               const Radius.circular(
//                                   2.0),
//                               topRight:
//                               const Radius.circular(
//                                   2.0),
//                               bottomLeft:
//                               const Radius.circular(
//                                   2.0),
//                               bottomRight:
//                               const Radius.circular(
//                                   2.0),
//                             )),
//                         child: _isAddToCart ?
//                         Center(
//                           child: SizedBox(
//                               width: 20.0,
//                               height: 20.0,
//                               child: new CircularProgressIndicator(
//                                 strokeWidth: 2.0,
//                                 valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)),
//                         )
//                             :
//                         Row(
//                           children: [
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Center(
//                                 child: Text(
//                                   S .current.add,//'ADD',
//                                   style:
//                                   TextStyle(
//                                     color: Theme
//                                         .of(
//                                         context)
//                                         .buttonColor,
//                                   ),
//                                   textAlign:
//                                   TextAlign
//                                       .center,
//                                 )),
//                             Spacer(),
//                             Container(
//                               decoration:
//                               BoxDecoration(
//                                   color: Color(
//                                       0xff1BA130),
//                                   borderRadius:
//                                   new BorderRadius.only(
//                                     topLeft:
//                                     const Radius.circular(2.0),
//                                     bottomLeft:
//                                     const Radius.circular(2.0),
//                                     topRight:
//                                     const Radius.circular(2.0),
//                                     bottomRight:
//                                     const Radius.circular(2.0),
//                                   )),
//                               height: 30,
//                               width: 25,
//                               child: Icon(
//                                 Icons.add,
//                                 size: 12,
//                                 color: Colors
//                                     .white,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }*/
//                 },
//               ),
//             )
//                 : GestureDetector(
//               onTap: () {
//
//
//                 if(checkskip &&_isWeb && !ResponsiveLayout.isSmallScreen(context)){
//                   //_dialogforSignIn();
//                   LoginWeb(context,result: (sucsess){
//                     if(sucsess){
//                       Navigator.of(context).pop();
//                       Navigator.pushNamedAndRemoveUntil(
//                           context, HomeScreen.routeName, (route) => false);
//                     }else{
//                       Navigator.of(context).pop();
//                     }
//                   });
//                 }
//                 else {
//                   (checkskip ) ?
//                   /*Navigator.of(context).pushNamed(
//                     SignupSelectionScreen.routeName,
//                   )*/
//                   Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push):
//                   _notifyMe();
//                 }
//                /* checkskip
//                     ? Navigator.of(context).pushNamed(
//                   SignupSelectionScreen.routeName,
//                 )
//                     : _notifyMe();*/
//
//                 // Fluttertoast.showToast(
//                 //     msg: S .current.you_will_notify" ,
//                 //     /*"Out Of Stock",*/
//                 //     fontSize: 12.0,
//                 //     backgroundColor:
//                 //     Colors.black87,
//                 //     textColor: Colors.white);
//               },
//               child: Container(
//                 height: 30.0,
//                 //width: (MediaQuery.of(context).size.width / 4) + 15,
//                 width: 160,
//                 decoration: new BoxDecoration(
//                     border: Border.all(
//                         color: (Features.isSubscription)?ColorCodes.primaryColor:ColorCodes.greenColor),
//                     color: (Features.isSubscription)?ColorCodes.primaryColor:ColorCodes.greenColor,
//                     borderRadius:
//                     new BorderRadius.only(
//                       topLeft: const Radius
//                           .circular(2.0),
//                       topRight: const Radius
//                           .circular(2.0),
//                       bottomLeft: const Radius
//                           .circular(2.0),
//                       bottomRight:
//                       const Radius
//                           .circular(2.0),
//                     )),
//                 child:
//                 _isNotify ?
//                 Center(
//                   child: SizedBox(
//                       width: 20.0,
//                       height: 20.0,
//                       child: new CircularProgressIndicator(
//                         strokeWidth: 2.0,
//                         valueColor: new AlwaysStoppedAnimation<
//                             Color>(Colors.white),)),
//                 )
//                 :
//                 Row(
//                   children: [
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Center(
//                         child: Text(
//                           S .current.notify_me,
//                           /*"ADD",*/
//                           style: TextStyle(
//                             /*fontWeight: FontWeight.w700,*/
//                               color: Colors
//                                   .white /*Colors.black87*/),
//                           textAlign:
//                           TextAlign.center,
//                         )),
//                     Spacer(),
//                     Container(
//                       decoration:
//                       BoxDecoration(
//                           color: Colors
//                               .black12,
//                           borderRadius:
//                           new BorderRadius
//                               .only(
//                             topRight:
//                             const Radius
//                                 .circular(
//                                 2.0),
//                             bottomRight:
//                             const Radius
//                                 .circular(
//                                 2.0),
//                           )),
//                       height: 50,
//                       width: 25,
//                       child: Icon(
//                         Icons.add,
//                         size: 12,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//
//     _quantityPopup() {
//       return showDialog(
//           context: context,
//           builder: (context) {
//             return StatefulBuilder(builder: (context, setState) {
//               return Dialog(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(3.0)),
//                 child: Container(
//                   //height: 200,
//                   width: MediaQuery.of(context).size.width / 3.0,
//                   //padding: EdgeInsets.only(left: 30.0, right: 20.0),
//                   child: SingleChildScrollView(
//                     child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: <Widget>[
//                           Container(
//                             width: MediaQuery.of(context).size.width,
//                             height: 50.0,
//                             color: ColorCodes.lightGreyWebColor,
//                             padding: EdgeInsets.only(left: 20.0),
//                             child: Align(
//                                 alignment: Alignment.centerLeft,
//                                 child: Text(
//                                   S .current.select_your_quantity,
//                                   style: TextStyle(
//                                       color: ColorCodes.mediumBlackColor,
//                                       fontSize: 20.0),
//                                 )),
//                           ),
//                           SizedBox(height: 20),
//                           Container(
//                             padding: EdgeInsets.only(left: 10, right: 10),
//                             child: ListView.builder(
//                               shrinkWrap: true,
//                               physics: NeverScrollableScrollPhysics(),
//                               itemCount: singleitemvar.length,
//                               itemBuilder: (_, i) =>
//                                   GestureDetector(
//                                     onTap: () {
//                                       for (int k = 0;
//                                       k < singleitemvar.length;
//                                       k++) {
//                                         if (i == k) {
//                                           singleitemvar[k].varcolor =
//                                               ColorCodes.darkthemeColor;
//                                         } else {
//                                           singleitemvar[k].varcolor =
//                                               ColorCodes.lightgrey;
//                                         }
//                                         setState(() {
//                                           varmemberprice = singleitemvar[i].varmemberprice!;
//                                           varmrp = singleitemvar[i].varmrp!;
//                                           varprice = singleitemvar[i].varprice!;
//                                           varid = singleitemvar[i].varid!;
//                                           varname = singleitemvar[i].varname!;
//                                           unit =singleitemvar[i].unit!;
//                                           weight = singleitemvar[i].weight!;
//                                           netWeight = singleitemvar[i].netWeight!;
//                                           varstock = singleitemvar[i].varstock!;
//                                           varminitem = singleitemvar[i].varminitem!;
//                                           varmaxitem = singleitemvar[i].varmaxitem!;
//                                           varLoyalty = singleitemvar[i].varLoyalty!;
//                                           _varQty = singleitemvar[i].varQty;
//                                           varcolor = singleitemvar[i].varcolor!;
//                                           discountDisplay = singleitemvar[i].discountDisplay!;
//                                           memberpriceDisplay = singleitemvar[i].membershipDisplay!;
//
//                                           /*if (varmemberprice == '-' || varmemberprice == "0") {
//                                             setState(() {
//                                               membershipdisplay = false;
//                                             });
//                                           } else {
//                                             membershipdisplay = true;
//                                           }*/
//
//                                           if (_checkmembership) {
//                                             if (varmemberprice.toString() == '-' || double.parse(varmemberprice) <= 0) {
//                                               if (double.parse(varmrp) <= 0 || double.parse(varprice) <= 0) {
//                                                 margins = "0";
//                                               } else {
//                                                 var difference = (double.parse(varmrp) - double.parse(varprice));
//                                                 var profit = difference / double.parse(varmrp);
//                                                 margins = profit * 100;
//
//                                                 //discount price rounding
//                                                 margins = num.parse(margins.toStringAsFixed(0));
//                                                 margins = margins.toString();
//                                               }
//                                             } else {
//                                               var difference = (double.parse(varmrp) - double.parse(varmemberprice));
//                                               var profit = difference / double.parse(varmrp);
//                                               margins = profit * 100;
//
//                                               //discount price rounding
//                                               margins = num.parse(margins.toStringAsFixed(0));
//                                               margins = margins.toString();
//                                             }
//                                           } else {
//                                             if (double.parse(varmrp) <= 0 || double.parse(varprice) <= 0) {
//                                               margins = "0";
//                                             } else {
//                                               var difference = (double.parse(varmrp) - double.parse(varprice));
//                                               var profit = difference / double.parse(varmrp);
//                                               margins = profit * 100;
//
//                                               //discount price rounding
//                                               margins = num.parse(margins.toStringAsFixed(0));
//                                               margins = margins.toString();
//                                             }
//                                           }
//
//                                           if (margins == "NaN") {
//                                             _checkmargin = false;
//                                           } else {
//                                             if (int.parse(margins) <= 0) {
//                                               _checkmargin = false;
//                                             } else {
//                                               _checkmargin = true;
//                                             }
//                                           }
//                                           multiimage =
//                                               Provider.of<ItemsList>(context, listen: false)
//                                                   .findByIdmulti(varid);
//                                           _displayimg =
//                                               multiimage[0].imageUrl;
//                                           for (int j = 0;
//                                           j < multiimage.length;
//                                           j++) {
//                                             if (j == 0) {
//                                               multiimage[j].varcolor =
//                                                   ColorCodes.primaryColor;
//                                             } else {
//                                               multiimage[j].varcolor =
//                                                   ColorCodes.lightgrey;
//                                             }
//                                           }
//                                         });
//                                       }
//                                       setState(() {
//                                         if (int.parse(varstock) <= 0) {
//                                           _isStock = false;
//                                         } else {
//                                           _isStock = true;
//                                         }
//                                       });
//                                     },
//                                     child: Row(
//                                       children: <Widget>[
// //                                              Spacer(),
//                                         _checkmargin
//                                             ? Consumer<CartCalculations>(
//                                           builder: (_, cart, ch) =>
//                                               Align(
//                                                 alignment:
//                                                 Alignment.topLeft,
//                                                 child: BadgeDiscount(
//                                                   child: ch!,
//                                                   value: /*margins*/_varMarginList[i],
//                                                 ),
//                                               ),
//                                           child: Container(
//                                               padding: EdgeInsets.all(10.0),
//                                               // width: MediaQuery.of(context).size.width,
//                                               alignment: Alignment.center,
//                                               height: 60.0,
//                                               //width: 290,
//                                               margin: EdgeInsets.only(bottom: 10.0),
//                                               decoration:
//                                               BoxDecoration(
//                                                   color: ColorCodes.fill,
//                                                   borderRadius: BorderRadius.circular(
//                                                       5.0),
//                                                   border: Border(
//                                                     top: BorderSide(
//                                                         width: 1.0,
//                                                         color: singleitemvar[i].varcolor!),
//                                                     bottom: BorderSide(
//                                                         width: 1.0,
//                                                         color: singleitemvar[i].varcolor!),
//                                                     left: BorderSide(
//                                                         width: 1.0,
//                                                         color: singleitemvar[i].varcolor!),
//                                                     right: BorderSide(
//                                                         width: 1.0,
//                                                         color: singleitemvar[i].varcolor!),
//                                                   )),
//                                               child: Row(
//                                                 mainAxisAlignment:
//                                                 MainAxisAlignment
//                                                     .spaceBetween,
//                                                 children: [
//                                                   Text(
//                                                     singleitemvar[i]
//                                                         .varname!+" "+singleitemvar[i].unit!,
//                                                     textAlign:
//                                                     TextAlign
//                                                         .center,
//                                                     style: TextStyle(
//                                                       fontSize:
//                                                       14, /*color: singleitemvar[i].varcolor*/
//                                                     ),
//                                                   ),
//                                                   Container(
//                                                       child: Row(
//                                                         children: <
//                                                             Widget>[
//                                                           _checkmembership
//                                                               ? Row(
//                                                             mainAxisAlignment: MainAxisAlignment.center,
//                                                             crossAxisAlignment: CrossAxisAlignment.center,
//                                                             children: <
//                                                                 Widget>[
//                                                               memberpriceDisplay
//                                                                   ? Column(
//                                                                 children: [
//                                                                   Row(
//                                                                     children: [
//                                                                       Container(
//                                                                         width: 25.0,
//                                                                         height: 25.0,
//                                                                         child: Image
//                                                                             .asset(
//                                                                           Images
//                                                                               .starImg,
//                                                                         ),
//                                                                       ),
//                                                                       Text(
//                                                                         Features.iscurrencyformatalign?
//                                                                         singleitemvar[i].varmemberprice !+ IConstants.currencyFormat :
//                                                                           IConstants.currencyFormat + singleitemvar[i].varmemberprice!,
//                                                                           style: new TextStyle(
//                                                                               fontWeight: FontWeight
//                                                                                   .bold,
//                                                                               color: Colors
//                                                                                   .black,
//                                                                               fontSize: 14.0)),
//                                                                     ],
//                                                                   ),
//                                                                   Text(
//                                                                       Features.iscurrencyformatalign?
//                                                                       singleitemvar[i].varmrp !+ IConstants.currencyFormat:
//                                                                       IConstants.currencyFormat + singleitemvar[i].varmrp!,
//                                                                       style: TextStyle(
//                                                                           decoration: TextDecoration
//                                                                               .lineThrough,
//                                                                           color: Colors
//                                                                               .grey,
//                                                                           fontSize: 10.0)),
//                                                                 ],
//                                                               )
//                                                                   : Column(
//                                                                 children: [
//                                                                   Row(
//                                                                     children: [
//                                                                       Container(
//                                                                         width: 25.0,
//                                                                         height: 25.0,
//                                                                         child: Image
//                                                                             .asset(
//                                                                           Images
//                                                                               .starImg,
//                                                                         ),
//                                                                       ),
//                                                                       Text(
//                                                                         Features.iscurrencyformatalign?
//                                                                         singleitemvar[i].varprice !+ IConstants.currencyFormat:
//                                                                           IConstants.currencyFormat + singleitemvar[i].varprice!,
//                                                                           style: new TextStyle(
//                                                                               fontWeight: FontWeight.bold,
//                                                                               color: Colors.black,
//                                                                               fontSize: 14.0)
//                                                                           ),
//                                                                     ],
//                                                                   ),
//                                                                   if(discountDisplay)
//                                                                     Text(
//                                                                       Features.iscurrencyformatalign?
//                                                                       singleitemvar[i].varmrp !+ IConstants.currencyFormat :
//                                                                         IConstants.currencyFormat + singleitemvar[i].varmrp!,
//                                                                       style: TextStyle(
//                                                                           decoration: TextDecoration
//                                                                               .lineThrough,
//                                                                           color: Colors
//                                                                               .grey,
//                                                                           fontSize: 10.0)),
//                                                                 ],
//                                                               )
//
//                                                             ],
//                                                           )
//                                                               :/* discountDisplay
//                                                               ? */Column(
//                                                             mainAxisAlignment:
//                                                             MainAxisAlignment.center,
//                                                             crossAxisAlignment:
//                                                             CrossAxisAlignment.center,
//                                                             children: [
//                                                               Text(
//                                                                 Features.iscurrencyformatalign?
//                                                                     singleitemvar[i]
//                                                                         .varprice !+ IConstants.currencyFormat:
//                                                                   IConstants.currencyFormat +
//                                                                   singleitemvar[i]
//                                                                       .varprice!,
//                                                                   style: new TextStyle(
//                                                                       fontWeight: FontWeight
//                                                                           .bold,
//                                                                       color: Colors
//                                                                           .black,
//                                                                       fontSize: 14.0)),
//                                                               if(discountDisplay)
//                                                               Text(
//                                                                   Features.iscurrencyformatalign?
//                                                                   singleitemvar[i]
//                                                                           .varmrp! + IConstants.currencyFormat:
//                                                                   IConstants.currencyFormat +
//                                                                   singleitemvar[i]
//                                                                       .varmrp!,
//                                                                   style: TextStyle(
//                                                                       decoration: TextDecoration
//                                                                           .lineThrough,
//                                                                       color: Colors
//                                                                           .grey,
//                                                                       fontSize: 10.0)),
//                                                             ],
//                                                           )
//                                                              /* : Column(
//                                                             mainAxisAlignment:
//                                                             MainAxisAlignment.center,
//                                                             crossAxisAlignment:
//                                                             CrossAxisAlignment.center,
//                                                             children: [
//                                                               Text(IConstants.currencyFormat + singleitemvar[i].varmrp,
//                                                                   style: new TextStyle(
//                                                                       fontWeight: FontWeight
//                                                                           .bold,
//                                                                       color: Colors
//                                                                           .black,
//                                                                       fontSize: 14.0)),
//                                                             ],
//                                                           )*/
//                                                         ],
//                                                       )),
//                                                   Icon(
//                                                       Icons.radio_button_checked_outlined,
//                                                       color: singleitemvar[i].varcolor)
//                                                 ],
//                                               )),
//                                         )
//                                             : Container(
//                                             padding: EdgeInsets.all(10.0),
//                                             //width:290,
//                                             //height: 60.0,
//                                             alignment: Alignment.center,
//                                             margin: EdgeInsets.only(bottom: 10.0),
//                                             decoration: BoxDecoration(
//                                                 color: ColorCodes.fill,
//                                                 borderRadius: BorderRadius.circular(5.0),
//                                                 border: Border(
//                                                   top: BorderSide(
//                                                       width: 1.0,
//                                                       color: singleitemvar[i].varcolor!),
//                                                   bottom: BorderSide(
//                                                       width: 1.0,
//                                                       color: singleitemvar[i].varcolor!),
//                                                   left: BorderSide(
//                                                       width: 1.0,
//                                                       color:
//                                                       singleitemvar[
//                                                       i]
//                                                           .varcolor!),
//                                                   right: BorderSide(
//                                                       width: 1.0,
//                                                       color:
//                                                       singleitemvar[
//                                                       i]
//                                                           .varcolor!),
//                                                 )),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                               MainAxisAlignment
//                                                   .spaceBetween,
//                                               children: [
//                                                 Text(
//                                                   singleitemvar[i]
//                                                       .varname!+" "+singleitemvar[i].unit!,
//                                                   textAlign:
//                                                   TextAlign.center,
//                                                   style: TextStyle(
//                                                     fontSize:
//                                                     14, /*color: singleitemvar[i].varcolor*/
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                     child: Row(
//                                                       children: <Widget>[
//                                                         _checkmembership
//                                                             ? Row(
//                                                           mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .center,
//                                                           crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .center,
//                                                           children: <
//                                                               Widget>[
//                                                             memberpriceDisplay
//                                                                 ? Column(
//                                                               children: [
//                                                                 Row(
//                                                                   children: [
//                                                                     Container(
//                                                                       width: 25.0,
//                                                                       height: 25.0,
//                                                                       child: Image
//                                                                           .asset(
//                                                                         Images.starImg,
//                                                                       ),
//                                                                     ),
//                                                                     Text(
//                                                                       Features.iscurrencyformatalign?
//                                                                       singleitemvar[i].varmemberprice !+ IConstants.currencyFormat :
//                                                                         IConstants.currencyFormat + singleitemvar[i].varmemberprice!,
//                                                                         style: new TextStyle(
//                                                                             fontWeight: FontWeight
//                                                                                 .bold,
//                                                                             color: Colors
//                                                                                 .black,
//                                                                             fontSize: 14.0)),
//                                                                   ],
//                                                                 ),
//                                                                 Text(
//                                                                     Features.iscurrencyformatalign?
//                                                                     singleitemvar[i].varmrp !+ IConstants.currencyFormat:
//                                                                     IConstants.currencyFormat + singleitemvar[i].varmrp!,
//                                                                     style: TextStyle(
//                                                                         decoration: TextDecoration
//                                                                             .lineThrough,
//                                                                         color: Colors
//                                                                             .grey,
//                                                                         fontSize: 10.0)),
//                                                               ],
//                                                             )
//                                                                 : discountDisplay
//                                                                 ? Column(
//                                                               children: [
//                                                                 Row(
//                                                                   children: [
//                                                                     Container(
//                                                                       width: 25.0,
//                                                                       height: 25.0,
//                                                                       child: Image
//                                                                           .asset(
//                                                                         Images.starImg,
//                                                                       ),
//                                                                     ),
//                                                                     Text(
//                                                                       Features.iscurrencyformatalign?
//                                                                       singleitemvar[i]
//                                                                               .varprice !+ IConstants.currencyFormat:
//                                                                         IConstants.currencyFormat +
//                                                                             singleitemvar[i]
//                                                                                 .varprice!,
//                                                                         style: new TextStyle(
//                                                                             fontWeight: FontWeight
//                                                                                 .bold,
//                                                                             color: Colors
//                                                                                 .black,
//                                                                             fontSize: 14.0)),
//                                                                   ],
//                                                                 ),
//                                                                 Text(
//                                                                     Features.iscurrencyformatalign?
//                                                                     singleitemvar[i]
//                                                                             .varmrp !+  IConstants.currencyFormat:
//                                                                     IConstants.currencyFormat +
//                                                                     singleitemvar[i]
//                                                                         .varmrp!,
//                                                                     style: TextStyle(
//                                                                         decoration: TextDecoration
//                                                                             .lineThrough,
//                                                                         color: Colors
//                                                                             .grey,
//                                                                         fontSize: 10.0)),
//                                                               ],
//                                                             )
//                                                                 : Column(
//                                                               children: [
//                                                                 Row(
//                                                                   children: [
//                                                                     Container(
//                                                                       width: 25.0,
//                                                                       height: 25.0,
//                                                                       child: Image
//                                                                           .asset(
//                                                                         Images.starImg,
//                                                                       ),
//                                                                     ),
//                                                                     Text(
//                                                                       Features.iscurrencyformatalign?
//                                                                       singleitemvar[i]
//                                                                               .varmrp! + IConstants.currencyFormat:
//                                                                         IConstants.currencyFormat +
//                                                                             singleitemvar[i]
//                                                                                 .varmrp!,
//                                                                         style: new TextStyle(
//                                                                             fontWeight: FontWeight
//                                                                                 .bold,
//                                                                             color: Colors
//                                                                                 .black,
//                                                                             fontSize: 14.0)),
//                                                                   ],
//                                                                 ),
//                                                               ],
//                                                             )
//                                                           ],
//                                                         )
//                                                             : discountDisplay
//                                                             ? Column(
//                                                           mainAxisAlignment:
//                                                           MainAxisAlignment.center,
//                                                           crossAxisAlignment:
//                                                           CrossAxisAlignment.center,
//                                                           children: [
//                                                             Text(
//                                                               Features.iscurrencyformatalign?
//                                                               singleitemvar[i]
//                                                                       .varprice !+ IConstants.currencyFormat:
//                                                                 IConstants.currencyFormat +
//                                                                     singleitemvar[i]
//                                                                         .varprice!,
//                                                                 style: new TextStyle(
//                                                                     fontWeight: FontWeight
//                                                                         .bold,
//                                                                     color: Colors.black,
//                                                                     fontSize: 14.0)),
//                                                             Text(
//                                                               Features.iscurrencyformatalign?
//                                                               singleitemvar[i]
//                                                                       .varmrp !+  IConstants.currencyFormat:
//                                                                 IConstants.currencyFormat +
//                                                                     singleitemvar[i]
//                                                                         .varmrp!,
//                                                                 style: TextStyle(
//                                                                     decoration: TextDecoration
//                                                                         .lineThrough,
//                                                                     color: Colors.grey,
//                                                                     fontSize: 10.0)),
//                                                           ],
//                                                         )
//                                                             : Column(
//                                                           mainAxisAlignment:
//                                                           MainAxisAlignment.center,
//                                                           crossAxisAlignment:
//                                                           CrossAxisAlignment.center,
//                                                           children: [
//                                                             Text(
//                                                               Features.iscurrencyformatalign?
//                                                               singleitemvar[i].varmrp !+ IConstants.currencyFormat:
//                                                                 IConstants.currencyFormat + singleitemvar[i].varmrp!,
//                                                                 style: new TextStyle(
//                                                                     fontWeight: FontWeight
//                                                                         .bold,
//                                                                     color: Colors.black,
//                                                                     fontSize: 14.0)),
//                                                           ],
//                                                         )
//                                                       ],
//                                                     )),
//                                                 Icon(
//                                                     Icons
//                                                         .radio_button_checked_outlined,
//                                                     color:
//                                                     singleitemvar[i]
//                                                         .varcolor)
//                                               ],
//                                             ))
// //                                              Spacer(),
//                                       ],
//                                     ),
//                                   ),
//                             ),
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               _addButton(),
//                               SizedBox(width: 20),
//                             ],
//                           ),
//
//                           SizedBox(height: 20),
//                         ]),
//                   ),
//                 ),
//               );
//             });
//           });
//     }
//     productvariation(int i){
//       for (int k = 0;
//       k < singleitemvar.length;
//       k++) {
//         if (i == k) {
//           setState(() {
//             singleitemvar[k].varcolor =
//                 ColorCodes.darkthemeColor;
//           });
//         } else {
//           setState(() {
//             singleitemvar[k].varcolor =
//                 ColorCodes.blackColor;
//           });
//         }
//         setState(() {
//           varmemberprice =
//               singleitemvar[i]
//                   .varmemberprice!;
//           varmrp = singleitemvar[i].varmrp!;
//           varprice =
//               singleitemvar[i].varprice!;
//           varid = singleitemvar[i].varid!;
//           varname =
//               singleitemvar[i].varname!;
//           unit =singleitemvar[i].unit!;
//           weight = singleitemvar[i].weight!;
//           netWeight = singleitemvar[i].netWeight!;
//           varstock =
//               singleitemvar[i].varstock!;
//           varminitem =
//               singleitemvar[i].varminitem!;
//           varmaxitem =
//               singleitemvar[i].varmaxitem!;
//           varLoyalty =
//               singleitemvar[i].varLoyalty!;
//           _varQty = singleitemvar[i].varQty;
//           varcolor =
//               singleitemvar[i].varcolor!;
//           discountDisplay =
//               singleitemvar[i]
//                   .discountDisplay!;
//           memberpriceDisplay =
//               singleitemvar[i]
//                   .membershipDisplay!;
//
//           /*if (varmemberprice == '-' || varmemberprice == "0") {
//         setState(() {
//           membershipdisplay = false;
//         });
//       } else {
//         membershipdisplay = true;
//       }*/
//
//           if (_checkmembership) {
//             if (varmemberprice.toString() == '-' || double.parse(varmemberprice) <= 0) {
//               if (double.parse(varmrp) <= 0 || double.parse(varprice) <= 0) {
//                 margins = "0";
//               } else {
//                 var difference = (double.parse(varmrp) - double.parse(varprice));
//                 var profit = difference / double.parse(varmrp);
//                 margins = profit * 100;
//
//                 //discount price rounding
//                 margins = num.parse(margins.toStringAsFixed(0));
//                 margins = margins.toString();
//               }
//             } else {
//               var difference = (double.parse(varmrp) - double.parse(varmemberprice));
//               var profit = difference / double.parse(varmrp);
//               margins = profit * 100;
//
//               //discount price rounding
//               margins = num.parse(margins.toStringAsFixed(0));
//               margins = margins.toString();
//             }
//           } else {
//             if (double.parse(varmrp) <= 0 || double.parse(varprice) <= 0) {
//               margins = "0";
//             } else {
//               var difference = (double.parse(varmrp) - double.parse(varprice));
//               var profit = difference / double.parse(varmrp);
//               margins = profit * 100;
//
//               //discount price rounding
//               margins = num.parse(margins.toStringAsFixed(0));
//               margins = margins.toString();
//             }
//           }
//           if (margins == "NaN") {
//             _checkmargin = false;
//           } else {
//             if (int.parse(margins) <= 0) {
//               _checkmargin = false;
//             } else {
//               _checkmargin = true;
//             }
//           }
//           multiimage = Provider.of<ItemsList>(context, listen: false).findByIdmulti(varid);
//           _displayimg = multiimage[0].imageUrl;
//           for (int j = 0; j < multiimage.length; j++) {
//             if (j == 0) {
//               setState(() {
//                 multiimage[j].varcolor = ColorCodes.primaryColor;
//               });
//             } else {
//               setState(() {
//                 multiimage[j].varcolor = ColorCodes.lightgrey;
//               });
//             }
//           }
//         });
//       }
//       setState(() {
//         if (int.parse(varstock) <= 0) {
//           _isStock = false;
//         } else {
//           _isStock = true;
//         }
//       });
//     }
//
//     quantityPopup1() {
//        showDialog(
//           context: context,
//           builder: (context) {
//             return StatefulBuilder(builder: (context, setState) {
//               return Dialog(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(3.0)),
//                   child: Container(
//                     //height: 200,
//                     width: 800,
//                     //padding: EdgeInsets.only(left: 30.0, right: 20.0),
//                       child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: <Widget>[
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Container(
//                                   // width: MediaQuery.of(context).size.width,
//                                   height: 50.0,
//                                   //   color: ColorCodes.lightGreyWebColor,
//                                   padding: EdgeInsets.only(left: 20.0),
//                                   child: Align(
//                                       alignment: Alignment.centerLeft,
//                                       child: Text(
//                                         S .current.select_your_quantity,
//                                         style: TextStyle(
//                                             color: ColorCodes.mediumBlackColor,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 20.0),
//                                       )),
//                                 ),
//                                 MouseRegion(
//                                   cursor: SystemMouseCursors.click,
//                                   child: GestureDetector(
//                                       onTap: ()=> Navigator.pop(context),
//                                       child: Image(
//                                         height: 40,
//                                         width: 40,
//                                         image: AssetImage(Images.bottomsheetcancelImg),color: Colors.black,)),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 20),
//                             SingleChildScrollView(
//                               child: ListView.builder(
//                                 shrinkWrap: true,
//                                 scrollDirection: Axis.vertical,
//                                 physics: NeverScrollableScrollPhysics(),
//                                 itemCount: singleitemvar.length,
//                                 itemBuilder: (_, i) =>
//                                     GestureDetector(
//                                       onTap: () {
//                                         setState((){
//                                           productvariation(i);
//                                         });
//                                       },
//                                       child: Container(
//                                             padding: EdgeInsets.all(10.0),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                               MainAxisAlignment
//                                                   .spaceBetween,
//                                               children: [
//                                                 Row(
//                                                   mainAxisSize: MainAxisSize.max,
//                                                   children: [
//                                                     Text(
//                                                       singleitemvar[i]
//                                                           .varname!+" "+singleitemvar[i].unit!,
//                                                       textAlign:
//                                                       TextAlign.center,
//                                                       style: TextStyle(
//                                                           fontSize: 18.0,
//                                                           color:singleitemvar[i].varcolor,//Colors.black,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .bold/*color: singleitemvar[i].varcolor*/
//                                                       ),
//                                                     ),
//                                                     SizedBox(width: 3,),
//                                                     Text(
//                                                       "-",
//                                                       textAlign: TextAlign.center,
//                                                       style: TextStyle(
//                                                         fontSize:
//                                                         14, /*color: singleitemvar[i].varcolor*/
//                                                       ),
//                                                     ),
//                                                     SizedBox(width: 3,),
//                                                     Container(
//                                                         child: Row(
//                                                           children: <Widget>[
//                                                             _checkmembership
//                                                                 ? Row(
//                                                               mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .center,
//                                                               crossAxisAlignment:
//                                                               CrossAxisAlignment
//                                                                   .center,
//                                                               children: <
//                                                                   Widget>[
//                                                                 memberpriceDisplay
//                                                                     ? Row(
//                                                                   children: [
//                                                                     Row(
//                                                                       children: [
//                                                                         Container(
//                                                                           width: 25.0,
//                                                                           height: 25.0,
//                                                                           child: Image
//                                                                               .asset(
//                                                                             Images.starImg,
//                                                                           ),
//                                                                         ),
//                                                                         Text(
//                                                                           Features.iscurrencyformatalign?
//                                                                           singleitemvar[i]
//                                                                                   .varmemberprice !+ IConstants.currencyFormat:
//                                                                             IConstants.currencyFormat +
//                                                                                 singleitemvar[i]
//                                                                                     .varmemberprice!,
//                                                                             style: new TextStyle(
//                                                                                 fontWeight: FontWeight
//                                                                                     .bold,
//                                                                                 color: singleitemvar[i].varcolor,//Colors.black,
//                                                                                 fontSize: 14.0)),
//                                                                       ],
//                                                                     ),
//                                                                     SizedBox(width: 10,),
//                                                                     Text((singleitemvar[i]
//                                                                         .varprice != singleitemvar[i]
//                                                                         .varmrp)?
//                                                                         Features.iscurrencyformatalign?
//                                                                        singleitemvar[i]
//                                                                                 .varmrp !+  IConstants.currencyFormat:
//                                                                     IConstants.currencyFormat +
//                                                                         singleitemvar[i]
//                                                                             .varmrp! :"",
//                                                                         style: TextStyle(
//                                                                             decoration: TextDecoration
//                                                                                 .lineThrough,
//                                                                             color: singleitemvar[i].varcolor,//Colors.grey,
//                                                                             fontSize: 10.0)),
//                                                                   ],
//                                                                 )
//                                                                     : discountDisplay
//                                                                     ? Row(
//                                                                   children: [
//                                                                     Row(
//                                                                       children: [
//                                                                         Container(
//                                                                           width: 25.0,
//                                                                           height: 25.0,
//                                                                           child: Image
//                                                                               .asset(
//                                                                             Images.starImg,
//                                                                           ),
//                                                                         ),
//                                                                         Text(
//                                                                           Features.iscurrencyformatalign?
//                                                                           singleitemvar[i].varprice !+ IConstants.currencyFormat:
//                                                                             IConstants.currencyFormat + singleitemvar[i].varprice!,
//                                                                             style: new TextStyle(
//                                                                                 fontWeight: FontWeight
//                                                                                     .bold,
//                                                                                 color: singleitemvar[i].varcolor,//Colors.black,
//                                                                                 fontSize: 14.0)),
//                                                                       ],
//                                                                     ),
//                                                                     SizedBox(width: 10,),
//                                                                     Text((singleitemvar[i]
//                                                                         .varprice != singleitemvar[i]
//                                                                         .varmrp)?
//                                                                         Features.iscurrencyformatalign?
//                                                                        singleitemvar[i]
//                                                                                 .varmrp !+ IConstants.currencyFormat:
//                                                                     IConstants.currencyFormat +
//                                                                         singleitemvar[i]
//                                                                             .varmrp! :"",
//                                                                         style: TextStyle(
//                                                                             decoration: TextDecoration
//                                                                                 .lineThrough,
//                                                                             color: singleitemvar[i].varcolor,//Colors.grey,
//                                                                             fontSize: 14.0)),
//                                                                   ],
//                                                                 )
//                                                                     : Column(
//                                                                   children: [
//                                                                     Row(
//                                                                       children: [
//                                                                         Container(
//                                                                           width: 25.0,
//                                                                           height: 25.0,
//                                                                           child: Image
//                                                                               .asset(
//                                                                             Images.starImg,
//                                                                           ),
//                                                                         ),
//                                                                         Text(
//                                                                           Features.iscurrencyformatalign?
//                                                                           singleitemvar[i].varmrp !+ IConstants.currencyFormat:
//                                                                             IConstants.currencyFormat + singleitemvar[i].varmrp!,
//                                                                             style: new TextStyle(
//                                                                                 fontWeight: FontWeight.bold,
//                                                                                 color: singleitemvar[i].varcolor,//Colors.black,
//                                                                                 fontSize: 14.0)),
//                                                                       ],
//                                                                     ),
//                                                                   ],
//                                                                 )
//                                                               ],
//                                                             )
//                                                                 : discountDisplay
//                                                                 ? Row(
//                                                               mainAxisAlignment:
//                                                               MainAxisAlignment.center,
//                                                               crossAxisAlignment:
//                                                               CrossAxisAlignment.center,
//                                                               children: [
//                                                                 Text(
//                                                                   Features.iscurrencyformatalign?
//                                                                  singleitemvar[i]
//                                                                           .varprice !+  IConstants.currencyFormat:
//                                                                     IConstants.currencyFormat +
//                                                                         singleitemvar[i]
//                                                                             .varprice!,
//                                                                     style: new TextStyle(
//                                                                         fontWeight: FontWeight
//                                                                             .bold,
//                                                                         color: singleitemvar[i].varcolor,//Colors.black,
//                                                                         fontSize: 14.0)),
//                                                                 SizedBox(width: 10,),
//                                                                 Text( (singleitemvar[i]
//                                                                     .varprice != singleitemvar[i]
//                                                                     .varmrp)?
//                                                                     Features.iscurrencyformatalign?
//                                                                     singleitemvar[i]
//                                                                             .varmrp !+ IConstants.currencyFormat:
//                                                                     IConstants.currencyFormat +
//                                                                         singleitemvar[i]
//                                                                             .varmrp! :"",
//                                                                     style: TextStyle(
//                                                                         decoration: TextDecoration
//                                                                             .lineThrough,
//                                                                         color: singleitemvar[i].varcolor,//Colors.grey,
//                                                                         fontSize: 14.0)),
//                                                               ],
//                                                             )
//                                                                 : Column(
//                                                               mainAxisAlignment:
//                                                               MainAxisAlignment.center,
//                                                               crossAxisAlignment:
//                                                               CrossAxisAlignment.center,
//                                                               children: [
//                                                                 Text(
//                                                                   Features.iscurrencyformatalign?
//                                                                   singleitemvar[i]
//                                                                           .varmrp !+ IConstants.currencyFormat:
//                                                                     IConstants.currencyFormat +
//                                                                         singleitemvar[i]
//                                                                             .varmrp!,
//                                                                     style: new TextStyle(
//                                                                         fontWeight: FontWeight
//                                                                             .bold,
//                                                                         color: singleitemvar[i].varcolor,//Colors.black,
//                                                                         fontSize: 14.0)),
//                                                               ],
//                                                             )
//                                                           ],
//                                                         )),
//                                                   ],
//                                                 ),
//                                                 Container(
//                                                   child: handler(i),
//                                                 ),
//                                               ],
//                                             )),
//                                     ),
//                               ),
//                             ),
//                             (Features.isSubscription)?
//                             (singleitemData.singleitems[0].subscribe == "0")?
//                             _isStock?
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 MouseRegion(
//                                   cursor: SystemMouseCursors.click,
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       if(checkskip &&_isWeb && !ResponsiveLayout.isSmallScreen(context)){
//                                         //_dialogforSignIn();
//                                         LoginWeb(context,result: (sucsess){
//                                           if(sucsess){
//                                             Navigator.of(context).pop();
//                                             Navigator.pushNamedAndRemoveUntil(
//                                                 context, HomeScreen.routeName, (route) => false);
//                                           }else{
//                                             Navigator.of(context).pop();
//                                           }
//                                         });
//                                       }
//                                       else {
//                                         (checkskip) ?
//                                         /*Navigator.of(context).pushNamed(
//                                           SignupSelectionScreen.routeName,
//                                         )*/
//                                         Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push):
//                                         Navigator.of(context).pushNamed(
//                                             SubscribeScreen.routeName,
//                                             arguments: {
//                                               "itemid": singleitemData.singleitems[0].id,
//                                               "itemname": singleitemData.singleitems[0].title,
//                                               "itemimg": singleitemData.singleitems[0].imageUrl,
//                                               "varname": varname+unit,
//                                               "varmrp":varmrp,
//                                               "varprice":  _checkmembership ? varmemberprice :discountDisplay ?varprice:varmrp,
//                                               "paymentMode": singleitemData.singleitems[0].paymentmode,
//                                               "cronTime": singleitemData.singleitems[0].cronTime,
//                                               "name": singleitemData.singleitems[0].name,
//                                               "varid": varid.toString(),
//                                               "brand": singleitemData.singleitems[0].brand
//                                             }
//                                         );
//                                       }
//                                     },
//                                     child: Container(
//                                       height: 30.0,
//                                       width: (MediaQuery.of(context)
//                                           .size.width / 4) +15,
//                                       decoration: new BoxDecoration(
//                                           border: Border.all(color: ColorCodes.primaryColor),
//                                           color: ColorCodes.whiteColor,
//                                           borderRadius: new BorderRadius.only(
//                                             topLeft: const Radius.circular(2.0),
//                                             topRight: const Radius.circular(2.0),
//                                             bottomLeft: const Radius.circular(2.0),
//                                             bottomRight: const Radius.circular(2.0),
//                                           )),
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                         children: [
//
//                                           Text(
//                                             S .current.subscribe,
//                                             style: TextStyle(
//                                                 color:ColorCodes.primaryColor,
//                                                 fontSize: 12, fontWeight: FontWeight.bold),
//                                             textAlign: TextAlign.center,
//                                           ),
//                                         ],
//                                       ) ,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(width: 20),
//                               ],
//                             ):
//                             SizedBox(height: 30,)
//                                 :
//                             SizedBox(height: 30,):SizedBox.shrink(),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                // _addButton1(),
//
//                                 Container(
//                                   child: Column(
//                                     children: [
//                                       _isStock
//                                           ? Container(
//                                         height: 40.0,
//                                         width: (MediaQuery.of(context).size.width / 4) + 15,
//                                         child:VxBuilder(
//                                           mutations: {SetCartItem},
//                                           // valueListenable: Hive.box<Product>(productBoxName).listenable(),
//                                           builder: (context,GroceStore store, index) {
//                                             final box = (VxState.store as GroceStore).CartItemList;
//                                            // if (box.where((element) => element.varId==varid).length <= 0  || int.parse(box.where((element) => element.varId==varid).first.quantity) <= 0)
//                                             if (box.where((element) => element.varId==varid).length <= 0  || int.parse(box.where((element) => element.varId==varid).first.quantity!) <= 0)
//                                               return GestureDetector(
//                                                 onTap: () {
//                                                   setState(() {
//                                                     _isAddToCart = true;
//                                                   });
//                                                   addToCart(int.parse(varminitem));
//                                                 },
//                                                 child: Container(
//                                                   height: 30.0,
//                                                   width: (MediaQuery.of(context).size.width / 4) + 15,
//                                                   decoration:
//                                                   new BoxDecoration(
//                                                       color: (Features.isSubscription)?ColorCodes.primaryColor :ColorCodes.primaryColor,
//                                                       borderRadius:
//                                                       new BorderRadius
//                                                           .only(
//                                                         topLeft:
//                                                         const Radius.circular(
//                                                             2.0),
//                                                         topRight:
//                                                         const Radius.circular(
//                                                             2.0),
//                                                         bottomLeft:
//                                                         const Radius.circular(
//                                                             2.0),
//                                                         bottomRight:
//                                                         const Radius.circular(
//                                                             2.0),
//                                                       )),
//                                                   child: _isAddToCart ?
//                                                   Center(
//                                                     child: SizedBox(
//                                                         width: 20.0,
//                                                         height: 20.0,
//                                                         child: new CircularProgressIndicator(
//                                                           strokeWidth: 2.0,
//                                                           valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)),
//                                                   )
//                                                       :
//                                                   (Features.isSubscription)?
//                                                   Row(
//                                                     mainAxisAlignment: MainAxisAlignment.center,
//                                                     crossAxisAlignment: CrossAxisAlignment.center,
//                                                     children: [
//                                                       Text(
//                                                         S .current.buy_once,
//                                                         style:
//                                                         TextStyle(
//                                                           color: ColorCodes.whiteColor,
//                                                         ),
//                                                         textAlign:
//                                                         TextAlign
//                                                             .center,
//                                                       ),
//                                                     ],
//                                                   )
//                                                   :Row(
//                                                     children: [
//                                                       SizedBox(
//                                                         width: 10,
//                                                       ),
//                                                       Center(
//                                                           child: Text(
//                                                             S .current.add,
//                                                             style:
//                                                             TextStyle(
//                                                               color: Theme
//                                                                   .of(
//                                                                   context)
//                                                                   .buttonColor,
//                                                             ),
//                                                             textAlign:
//                                                             TextAlign
//                                                                 .center,
//                                                           )),
//                                                       Spacer(),
//                                                       Container(
//                                                         decoration:
//                                                         BoxDecoration(
//                                                             color: ColorCodes.primaryColor,
//                                                             borderRadius:
//                                                             new BorderRadius.only(
//                                                               topLeft:
//                                                               const Radius.circular(2.0),
//                                                               bottomLeft:
//                                                               const Radius.circular(2.0),
//                                                               topRight:
//                                                               const Radius.circular(2.0),
//                                                               bottomRight:
//                                                               const Radius.circular(2.0),
//                                                             )),
//                                                         height: 50,
//                                                         width: 25,
//                                                         child: Icon(
//                                                           Icons.add,
//                                                           size: 12,
//                                                           color: Colors
//                                                               .white,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               );
//                                             else
//                                               return Container(
//                                                 child: Row(
//                                                   children: <Widget>[
//                                                     GestureDetector(
//                                                       onTap: () async {
//                                                         // setState(() {
//                                                         //   _isAddToCart = true;
//                                                         //   incrementToCart(_varQty - 1);
//                                                         // });
//                                                         // VxRemoveCart(context, productBox: productBox, varQty: _varQty, varminitem: varminitem, isAddToCart: _isAddToCart, varid: varid, varprice: varprice, singleitemvar: singleitemvar, itemid: itemid, varname: varname, varmaxitem: varmaxitem, varLoyalty: varLoyalty, varstock: varstock, varmrp: varmrp, itemname: itemname, varmemberprice: varmemberprice, itemimg: itemimg, veg_type: veg_type, type: type, eligibleforexpress: eligibleforexpress, delivery: delivery, duration: duration, durationType: durationType);
//                                                         if(int.parse(box.where((element) => element.varId==varid).first.quantity!) > 0)
//                                                         cartcontroller.update((done){
//                                                           setState(() {
//                                                             _isAddToCart = !done;
//                                                           });
//                                                         },quantity: (int.parse(box.where((element) => element.varId==varid).first.quantity!)<= int.parse(varminitem))?"0":(int.parse(box.where((element) => element.varId==varid).first.quantity!) - 1).toString(),var_id: varid,price: memberpriceDisplay?varmemberprice:varprice);
//
//                                                       },
//                                                       child: Container(
//                                                           width: 30,
//                                                           height: 30,
//                                                           decoration:
//                                                           new BoxDecoration(
//                                                               border: Border
//                                                                   .all(
//                                                                 color:(Features.isSubscription)?ColorCodes.primaryColor : ColorCodes.primaryColor,
//                                                               ),
//                                                               borderRadius:
//                                                               new BorderRadius.only(
//                                                                 bottomLeft:
//                                                                 const Radius.circular(2.0),
//                                                                 topLeft:
//                                                                 const Radius.circular(2.0),
//                                                               )),
//                                                           child: Center(
//                                                             child: Text(
//                                                               "-",
//                                                               textAlign:
//                                                               TextAlign
//                                                                   .center,
//                                                               style:
//                                                               TextStyle(
//                                                                 color: (Features.isSubscription)?ColorCodes.blackColor :ColorCodes.primaryColor,
//                                                               ),
//                                                             ),
//                                                           )),
//                                                     ),
//                                                     Expanded(
//                                                       child: _isAddToCart ?
//                                                       Container(
//                                                         decoration:
//                                                         BoxDecoration(
//                                                           color: (Features.isSubscription)?ColorCodes.primaryColor :ColorCodes.primaryColor,
//                                                         ),
//                                                         height: 30,
//                                                         child: Center(
//                                                           child: SizedBox(
//                                                               width: 20.0,
//                                                               height: 20.0,
//                                                               child: new CircularProgressIndicator(
//                                                                 strokeWidth: 2.0,
//                                                                 valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)),
//                                                         ),
//                                                       )
//                                                           :
//                                                       Container(
//                                                           decoration:
//                                                           BoxDecoration(
//                                                             color: (Features.isSubscription)?ColorCodes.primaryColor :ColorCodes.primaryColor,
//                                                           ),
//                                                           height: 30,
//                                                           child: Center(
//                                                             child: Text(
//
//                                                               box.where((element) => element.varId==varid).first.quantity.toString(), // _varQty.toString(),
//
//                                                               textAlign: TextAlign.center,
//                                                               style: TextStyle(
//                                                                 color: (Features.isSubscription)?ColorCodes.whiteColor :Theme
//                                                                     .of(context)
//                                                                     .buttonColor,
//                                                               ),
//                                                             ),
//                                                           )),
//                                                     ),
//                                                     GestureDetector(
//                                                       onTap: () {
//                                                         if (int.parse(box.where((element) => element.varId==varid).first.quantity!)  < int.parse(varstock)) {
//                                                           if (int.parse(box.where((element) => element.varId==varid).first.quantity!)  < int.parse(varmaxitem)) {
//                                                             // setState(() {
//                                                             //   _isAddToCart = true;
//                                                             // });
//                                                             // // VxAddCart(context, productBox: productBox, varQty: _varQty, varminitem: varminitem, isAddToCart: _isAddToCart, varid: varid, varprice: varprice, singleitemvar: singleitemvar, itemid: itemid, varname: varname, varmaxitem: varmaxitem, varLoyalty: varLoyalty, varstock: varstock, varmrp: varmrp, itemname: itemname, varmemberprice: varmemberprice, itemimg: itemimg, veg_type: veg_type, type: type, eligibleforexpress: eligibleforexpress, delivery: delivery, duration: duration, durationType: durationType);
//                                                             // incrementToCart(_varQty + 1);
//                                                             cartcontroller.update((done){
//                                                               setState(() {
//                                                                 _isAddToCart = !done;
//                                                               });
//                                                             },quantity: (int.parse(box.where((element)  => element.varId==varid).first.quantity!) + 1).toString(),var_id: varid,price: memberpriceDisplay?varmemberprice:varprice);
//
//                                                           } else {
//                                                             Fluttertoast.showToast(
//                                                                 msg:  S .current.cant_add_more_item,
//                                                                 fontSize: MediaQuery.of(context).textScaleFactor *13,
//                                                                 backgroundColor: Colors.black87,
//                                                                 textColor: Colors.white);
//                                                           }
//                                                         } else {
//                                                           Fluttertoast.showToast(
//                                                               msg:
//                                                               S .current.sorry_outofstock,
//                                                               fontSize: MediaQuery.of(context).textScaleFactor *13,
//                                                               backgroundColor:
//                                                               Colors
//                                                                   .black87,
//                                                               textColor:
//                                                               Colors
//                                                                   .white);
//                                                         }
//                                                       },
//                                                       child: Container(
//                                                           width: 30,
//                                                           height: 30,
//                                                           decoration:
//                                                           new BoxDecoration(
//                                                               border: Border
//                                                                   .all(
//                                                                 color:(Features.isSubscription)?ColorCodes.primaryColor :ColorCodes.primaryColor,
//                                                               ),
//                                                               borderRadius:
//                                                               new BorderRadius.only(
//                                                                 bottomRight:
//                                                                 const Radius.circular(2.0),
//                                                                 topRight:
//                                                                 const Radius.circular(2.0),
//                                                               )),
//                                                           child: Center(
//                                                             child: Text(
//                                                               "+",
//                                                               textAlign:
//                                                               TextAlign
//                                                                   .center,
//                                                               style:
//                                                               TextStyle(
//                                                                 color: (Features.isSubscription)?ColorCodes.blackColor :ColorCodes.primaryColor,
//                                                               ),
//                                                             ),
//                                                           )),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               );
//                                           },
//                                         ),
//                                       )
//                                           : GestureDetector(
//                                         onTap: () {
//                                           checkskip
//                                               ?/* Navigator.of(context).pushNamed(
//                                             SignupSelectionScreen.routeName,
//                                           )*/
//                                           Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
//                                               : _notifyMe();
//                                           // Fluttertoast.showToast(
//                                           //     msg: "You will be notified via SMS/Push notification, when the product is available" ,
//                                           //     /*"Out Of Stock",*/
//                                           //     fontSize: 12.0,
//                                           //     backgroundColor:
//                                           //     Colors.black87,
//                                           //     textColor: Colors.white);
//                                         },
//                                         child: Container(
//                                           height: 40.0,
//                                           width: (MediaQuery.of(context).size.width / 4) + 15,
//                                           // width: 160,
//                                           decoration: new BoxDecoration(
//                                               border: Border.all(
//                                                   color: (Features.isSubscription)?ColorCodes.primaryColor:ColorCodes.greenColor),
//                                               color: (Features.isSubscription)?ColorCodes.primaryColor:ColorCodes.greenColor,
//                                               borderRadius:
//                                               new BorderRadius.only(
//                                                 topLeft: const Radius
//                                                     .circular(2.0),
//                                                 topRight: const Radius
//                                                     .circular(2.0),
//                                                 bottomLeft: const Radius
//                                                     .circular(2.0),
//                                                 bottomRight:
//                                                 const Radius
//                                                     .circular(2.0),
//                                               )),
//                                           child:
//                                           _isNotify ?
//                                           Center(
//                                             child: SizedBox(
//                                                 width: 20.0,
//                                                 height: 20.0,
//                                                 child: new CircularProgressIndicator(
//                                                   strokeWidth: 2.0,
//                                                   valueColor: new AlwaysStoppedAnimation<
//                                                       Color>(Colors.white),)),
//                                           )
//                                               :
//                                           Row(
//                                             children: [
//                                               SizedBox(
//                                                 width: 10,
//                                               ),
//                                               Center(
//                                                   child: Text(
//                                                     S .current.notify_me,
//                                                     /*"ADD",*/
//                                                     style: TextStyle(
//                                                       /*fontWeight: FontWeight.w700,*/
//                                                         color: Colors
//                                                             .white /*Colors.black87*/),
//                                                     textAlign:
//                                                     TextAlign.center,
//                                                   )),
//                                               Spacer(),
//                                               Container(
//                                                 decoration:
//                                                 BoxDecoration(
//                                                     color: Colors
//                                                         .black12,
//                                                     borderRadius:
//                                                     new BorderRadius
//                                                         .only(
//                                                       topRight:
//                                                       const Radius
//                                                           .circular(
//                                                           2.0),
//                                                       bottomRight:
//                                                       const Radius
//                                                           .circular(
//                                                           2.0),
//                                                     )),
//                                                 height: 50,
//                                                 width: 25,
//                                                 child: Icon(
//                                                   Icons.add,
//                                                   size: 12,
//                                                   color: Colors.white,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(width: 20),
//                               ],
//                             ),
//
//                             SizedBox(height: 20),
//                           ]),
//
//                   ));
//             });
//
//          })
//           .then((_) => setState(() {
//         singleitemData.clear();
//         singleitemvar.clear();
//       }));
//     }
//
//     Widget webBody() {
//       return SafeArea(
//         child: _isLoading
//             ? Center(
//           child: new CircularProgressIndicator(),
//         )
//             : Column(
//           children: [
//             _responsiveAppBar(),
//
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Container(
//                   child: Column(
//                     //crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       SizedBox(
//                         height: 20.0,
//                       ),
//                       Container(
//                         height: 340,
//                         width: MediaQuery.of(context).size.width,
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//
//                             _firstHalfImage(),
//
//                             // Top half
//                             Container(
//                               padding: EdgeInsets.only(right: 10),
//                               width: MediaQuery.of(context).size.width / 2,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: <Widget>[
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         singleitemData.singleitems[0].brand,
//                                         style: TextStyle(
//                                             fontSize: 20,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       //Spacer(),
//                                       //Padding(padding: EdgeInsets.only(left: 500)),
//                                       if (_checkmargin)
//                                         Container(
//                                           width: 88,
//                                           height: 25,
//                                           margin: EdgeInsets.only(left: 5.0),
//                                           padding: EdgeInsets.all(3.0),
//                                           // color: Theme.of(context).accentColor,
//                                           /*decoration: BoxDecoration(
//                                             borderRadius:
//                                             BorderRadius.circular(3.0),
//                                             color: ColorCodes.greenColor,
//                                           ),*/
//                                           /*constraints: BoxConstraints(
//                                             minWidth: 38,
//                                             minHeight: 18,
//                                           ),*/
//                                           child: Text(
//                                             margins + S .current.off,
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                                 fontSize: 14,
//                                                 color: ColorCodes.greenColor,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ),
//                                     ],
//                                   ),
//
//                                   Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: <Widget>[
//                                       Padding(padding: EdgeInsets.only(top: 10)),
//                                       Text(
//                                         singleitemData.singleitems[0].title,
//                                         style: TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 20.0,
//                                       ),
//                                       _checkmembership
//                                           ? Row(
//                                         children: <Widget>[
//                                           memberpriceDisplay
//                                               ? Column(
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment
//                                                 .start,
//                                             children: [
//                                               Row(
//                                                 children: [
//                                                   Text(
//                                                     Features.iscurrencyformatalign?
//                                                     '$varmemberprice ' + IConstants.currencyFormat:
//                                                       IConstants.currencyFormat +
//                                                       '$varmemberprice ',
//                                                       style: new TextStyle(
//                                                           fontWeight: FontWeight.bold,
//                                                           fontSize: 20.0)),
//                                                   SizedBox(width:5),
//                                                   Text(
//                                                     Features.iscurrencyformatalign?
//                                                     '$varmrp ' + IConstants.currencyFormat:
//                                                       IConstants.currencyFormat +
//                                                       '$varmrp ',
//                                                       style: new TextStyle(
//                                                           fontWeight: FontWeight.bold,
//                                                           fontSize: 20.0)),
//                                                 ],
//                                               )
//                                               /*    new RichText(
//                                                 text: new TextSpan(
//                                                     style: new TextStyle(
//                                                       fontSize:
//                                                       14.0,
//                                                       color:
//                                                       Colors.black,
//                                                     ),
//                                                     children: <TextSpan>[
//                                                       new TextSpan(
//                                                           text:
//                                                           S .current.product_mrp,
//                                                           style:
//                                                           new TextStyle(fontSize: 16.0)),
//                                                       new TextSpan(
//                                                           text: IConstants.currencyFormat +
//                                                               '$varmrp ',
//                                                           style: new TextStyle(
//                                                               fontWeight: FontWeight.bold,
//                                                               fontSize: 16.0))
//                                                     ])),
//                                             Row(
//                                               children: [
//                                                 Container(
//                                                   width: 25.0,
//                                                   height: 25.0,
//                                                   child: Image
//                                                       .asset(
//                                                     Images.starImg,
//                                                   ),
//                                                 ),
//                                                 new RichText(
//                                                     text: new TextSpan(
//                                                         style: new TextStyle(
//                                                           fontSize:
//                                                           14.0,
//                                                           color:
//                                                           Colors.black,
//                                                         ),
//                                                         children: <TextSpan>[
//                                                           new TextSpan(
//                                                               text:
//                                                               S .current.selling_price,
//                                                               style:
//                                                               new TextStyle(fontSize: 16.0)),
//                                                           new TextSpan(
//                                                               text: IConstants.currencyFormat +
//                                                                   '$varmemberprice ',
//                                                               style: new TextStyle(
//                                                                   fontWeight: FontWeight.bold,
//                                                                   fontSize: 16.0))
//                                                         ])),
//                                               ],
//                                             ),*/
//                                             ],
//                                           )
//                                               : discountDisplay
//                                               ? Column(
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment
//                                                 .start,
//                                             children: [
//                                               Row(
//                                                 children: [
//                                                   Text(
//                                                     Features.iscurrencyformatalign?
//                                                     '$varprice ' + IConstants.currencyFormat:
//                                                       IConstants.currencyFormat + '$varprice ',
//                                                       style: new TextStyle(
//                                                           fontWeight: FontWeight.bold,
//                                                           fontSize: 20.0)),
//                                                   SizedBox(width:5),
//                                                   Text(
//                                                     Features.iscurrencyformatalign?
//                                                     '$varmrp ' + IConstants.currencyFormat:
//                                                       IConstants.currencyFormat +
//                                                       '$varmrp ',
//                                                       style: new TextStyle(
//                                                           decoration: TextDecoration.lineThrough,
//                                                           color: Colors.grey,
//                                                           fontSize: 18.0)),
//                                                 ],
//                                               ),
//                                               /*  new RichText(
//                                                 text: new TextSpan(
//                                                     style: new TextStyle(
//                                                       fontSize:
//                                                       14.0,
//                                                       color:
//                                                       Colors.black,
//                                                     ),
//                                                     children: <TextSpan>[
//                                                       new TextSpan(
//                                                           text:
//                                                           S .current.product_mrp,
//                                                           style:
//                                                           new TextStyle(fontSize: 16.0)),
//                                                       new TextSpan(
//                                                           text: IConstants.currencyFormat +
//                                                               '$varmrp ',
//                                                           style: TextStyle(
//                                                               decoration: TextDecoration.lineThrough,
//                                                               fontSize: 12,
//                                                               color: Colors.grey))
//                                                     ])),
//                                             Row(
//                                               children: [
//                                                 Container(
//                                                   width:
//                                                   25.0,
//                                                   height:
//                                                   25.0,
//                                                   child: Image
//                                                       .asset(
//                                                     Images.starImg,
//                                                   ),
//                                                 ),
//                                                 Text(
//                                                     IConstants.currencyFormat + '$varprice ',
//                                                     style: new TextStyle(
//                                                         fontWeight:
//                                                         FontWeight.bold,
//                                                         fontSize: 16.0)),
//                                               ],
//                                             ),*/
//                                             ],
//                                           )
//                                               : Row(
//                                             children: [
//                                                 Container(
//                                               width: 25.0,
//                                               height: 25.0,
//                                               child: Image
//                                                   .asset(
//                                                 Images.starImg,
//                                               ),
//                                             ),
//                                               Text(
//                                                 Features.iscurrencyformatalign?
//                                                 '$varmrp ' + IConstants.currencyFormat:
//                                                   IConstants.currencyFormat +
//                                                   '$varmrp ',
//                                                   style: new TextStyle(
//                                                     // decoration: TextDecoration.lineThrough,
//                                                       fontWeight: FontWeight.bold,
//                                                       fontSize: 20.0)),
//                                               /*  new RichText(
//                                                 text: new TextSpan(
//                                                     style: new TextStyle(
//                                                       fontSize:
//                                                       14.0,
//                                                       color:
//                                                       Colors.black,
//                                                     ),
//                                                     children: <TextSpan>[
//                                                       new TextSpan(
//                                                           text:
//                                                           S .current.selling_price,
//                                                           style:
//                                                           new TextStyle(fontSize: 16.0)),
//                                                       new TextSpan(
//                                                           text: IConstants.currencyFormat +
//                                                               '$varmrp ',
//                                                           style: new TextStyle(
//                                                               fontWeight: FontWeight.bold,
//                                                               fontSize: 16.0))
//                                                     ])),*/
//                                             ],
//                                           )
//                                         ],
//                                       )
//                                           : discountDisplay
//                                           ? Column(
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment
//                                             .start,
//                                         children: [
//                                           Row(
//                                             children: [
//                                               Text(
//                                                 Features.iscurrencyformatalign?
//                                                 '$varprice ' + IConstants.currencyFormat:
//                                                   IConstants.currencyFormat + '$varprice ',
//                                                   style: new TextStyle(
//                                                       fontWeight: FontWeight.bold,
//                                                       fontSize: 20.0)),
//                                               SizedBox(width:5),
//                                               Text(
//                                                 Features.iscurrencyformatalign?
//                                                 '$varmrp ' +IConstants.currencyFormat:
//                                                   IConstants.currencyFormat +
//                                                   '$varmrp ',
//                                                   style: new TextStyle(
//                                                       decoration: TextDecoration.lineThrough,
//                                                       color: Colors.grey,
//                                                       fontSize: 18.0)),
//                                             ],
//                                           ),
//                                           /* new RichText(
//                                             text: new TextSpan(
//                                                 style:
//                                                 new TextStyle(
//                                                   fontSize: 14.0,
//                                                   color: Colors
//                                                       .black,
//                                                 ),
//                                                 children: <
//                                                     TextSpan>[
//                                                   new TextSpan(
//                                                       text:
//                                                       S .current.product_mrp,
//                                                       style: new TextStyle(
//                                                           fontSize:
//                                                           16.0)),
//                                                   new TextSpan(
//                                                       text: IConstants.currencyFormat + ' $varmrp ',
//                                                       style: TextStyle(
//                                                           decoration:
//                                                           TextDecoration
//                                                               .lineThrough,
//                                                           fontSize:
//                                                           12,
//                                                           color: Colors
//                                                               .grey))
//                                                 ])),
//                                         new RichText(
//                                             text: new TextSpan(
//                                                 style:
//                                                 new TextStyle(
//                                                   fontSize: 14.0,
//                                                   color: Colors
//                                                       .black,
//                                                 ),
//                                                 children: <
//                                                     TextSpan>[
//                                                   new TextSpan(
//                                                       text:
//                                                       S .current.selling_price,
//                                                       style: new TextStyle(
//                                                           fontSize:
//                                                           16.0)),
//                                                   new TextSpan(
//                                                       text: IConstants.currencyFormat +
//                                                           ' $varprice  ',
//                                                       style: new TextStyle(
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .bold,
//                                                           fontSize:
//                                                           16.0))
//                                                 ])),*/
//                                         ],
//                                       )
//                                           :       Row(
//                                         children: [
//                                           Text(
//                                             Features.iscurrencyformatalign?
//                                             '$varmrp ' + IConstants.currencyFormat:
//                                               IConstants.currencyFormat +
//                                               '$varmrp ',
//                                               style: new TextStyle(
//                                                   fontWeight:
//                                                   FontWeight
//                                                       .bold,
//                                                   fontSize: 20.0)),
//                                         ],
//                                       ),
//                                       Text(
//                                         S .current.inclusive_of_all_tax,
//                                         style: TextStyle(
//                                             fontSize: 12, color: Colors.grey),
//                                       ),
//
//                                     ],
//                                   ),
//                                   SizedBox(height: 5,),
//                                   singleitemData.singleitems[0].eligible_for_express == "0" ?
//                                   Align(
//                                     alignment: Alignment.topRight,
//                                     child: Image.asset(Images.express,
//                                       height: 20.0,
//                                       width: 25.0,
//                                     ),
//                                   ):
//                                   SizedBox.shrink(),
//                                   if(Features.netWeight && veg_type == "fish")
//                                     SizedBox(height: 10.0),
//                                   if(Features.netWeight && veg_type == "fish")
//                                     Container(
//                                       child: Text(
//                                         Features.iscurrencyformatalign?
//                                         "Whole Uncut:" +" "+
//                                             '$salePrice ' + IConstants.currencyFormat +" / "+ "500 G" :
//                                           "Whole Uncut:" +" "+ IConstants.currencyFormat +
//                                           '$salePrice ' +" / "+ "500 G",
//                                           style: new TextStyle(
//                                               fontWeight:
//                                               FontWeight
//                                                   .bold,
//                                               fontSize: 16.0)
//                                       ),
//                                     ),
//                                   if(Features.netWeight && veg_type == "fish")
//                                     SizedBox(height: 10.0),
//                                   if(Features.netWeight && veg_type == "fish")
//                                     Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Column(
//                                             children: [
//                                               Container(
//                                                 // width:
//                                                 // MediaQuery.of(context).size.width / 2.1,
//                                                 child: Text("Gross Weight:" +" "+
//                                                     '$weight ',
//                                                     style: new TextStyle(
//                                                         fontWeight:
//                                                         FontWeight
//                                                             .bold,
//                                                         fontSize: 16.0)
//                                                 ),),
//                                             ],
//                                           ),
//                                           Column(
//                                             crossAxisAlignment: CrossAxisAlignment.end,
//                                             children: [
//                                               Container(
//                                                 // width:
//                                                 // MediaQuery.of(context).size.width / 2.1,
//                                                 child: Text("Net Weight:" +" "+
//                                                     '$netWeight ',
//                                                     style: new TextStyle(
//                                                         fontWeight:
//                                                         FontWeight
//                                                             .bold,
//                                                         fontSize: 16.0)
//                                                 ),),
//                                             ],
//                                           )
//                                         ]
//                                     ),
//                                   Container(
//                                     padding: EdgeInsets.only(top: 20),
//                                     width: MediaQuery.of(context).size.width / 1.7,
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         /*  SizedBox(
//                                               height: 10,
//                                           ),*/
//                                         GestureDetector(
//                                           onTap: () {
//                                             setState(() {
//                                               (_isWeb)? quantityPopup1():_quantityPopup();
//                                             });
//                                           },
//                                           child:
//                                           Container(
//                                             width: 200,
//                                             child: Row(
//
//                                               children: [
//                                                 SizedBox(
//                                                   height: 10.0,
//                                                 ),
//                                                 Expanded(
//                                                   child: Container(
//                                                     decoration: BoxDecoration(
//                                                        // border: Border.all(color: ColorCodes.greenColor,),
//                                                         color: ColorCodes.varcolor,
//                                                         borderRadius: new BorderRadius.only(
//                                                           topLeft: const Radius.circular(2.0),
//                                                           bottomLeft: const Radius.circular(2.0),
//                                                         )),
//                                                     height: 30,
//                                                     padding: EdgeInsets.fromLTRB(5.0, 4.5, 5.0, 4.5),
//                                                     child: Text(
//                                                       "$varname"+" "+"$unit",
//                                                       style: TextStyle(color: ColorCodes.darkgreen,fontWeight: FontWeight.bold),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   height: 30,
//                                                   decoration: BoxDecoration(
//                                                       color: ColorCodes.varcolor,
//                                                       borderRadius: new BorderRadius.only(
//                                                         topRight: const Radius.circular(2.0),
//                                                         bottomRight: const Radius.circular(2.0),
//                                                       )),
//                                                   child: Icon(
//                                                     Icons.keyboard_arrow_down,
//                                                     color: ColorCodes.darkgreen,
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 10.0,
//                                                 ),
//
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//
//
//                                         //SizedBox(width: 300),
//
//                                         //Spacer(),
//
//                                         _addButton(),
//
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(height: 20),
//                                   if(Features.isMembership)
//                                     Row(
//                                       children: [
//                                         !_checkmembership
//                                             ? memberpriceDisplay
//                                             ? GestureDetector(
//                                           onTap: () {
//                                             (checkskip &&_isWeb && !ResponsiveLayout.isSmallScreen(context))?
//                                            // _dialogforSignIn()
//                                             LoginWeb(context,result: (sucsess){
//                                               if(sucsess){
//                                                 Navigator.of(context).pop();
//                                                 Navigator.pushNamedAndRemoveUntil(
//                                                     context, HomeScreen.routeName, (route) => false);
//                                               }else{
//                                                 Navigator.of(context).pop();
//                                               }
//                                             })
//                                                 :
//                                             (checkskip && !_isWeb)?
//                                            /* Navigator.of(context).pushReplacementNamed(
//                                                 SignupSelectionScreen.routeName)*/
//                                             Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.PushReplacment)
//                                                 :/*Navigator.of(context).pushNamed(
//                                               MembershipScreen.routeName,
//                                             );*/
//                                             Navigation(context, name: Routename.Membership, navigatore: NavigatoreTyp.Push);
//                                           },
//                                           child: Container(
//                                             height: 35,
//                                             //width: (MediaQuery.of(context).size.width / 2 ),
//                                             width: MediaQuery.of(context).size.width / 2.03,
//                                             decoration: BoxDecoration(
//                                                 color: ColorCodes.membershipColor),
//                                             child: Row(
//                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                               children: <Widget>[
//                                                 Container(
//                                                   child: Row(
//                                                     children: [
//                                                       SizedBox(width: 10),
//                                                       Image.asset(
//                                                         Images.starImg,
//                                                         height: 12,
//                                                       ),
//                                                       // SizedBox(width: 4),
//                                                       // Text(S .current.membership_price,
//                                                       //     style: TextStyle(
//                                                       //         fontSize: 16.0)
//                                                       // ),
//                                                       SizedBox(width: 30),
//                                                       Text(
//                                                           //S .of(context).membership_price + " "//"Membership Price "
//                                                               Features.iscurrencyformatalign?
//                                                               varmemberprice + IConstants.currencyFormat:
//                                                               IConstants.currencyFormat +
//                                                               varmemberprice,
//                                                           style: TextStyle(
//                                                               color: ColorCodes.blackColor,
//                                                               fontSize: 16.0,
//                                                               fontWeight: FontWeight.normal)),
//                                                     ],
//                                                   ),
//                                                 ),
//
//                                                 //Spacer(),
//                                                 Container(
//                                                   child: Row(
//                                                       children: [
//                                                         Icon(
//                                                           Icons.lock,
//                                                           color: Colors.black,
//                                                           size: 12,
//                                                         ),
//                                                         SizedBox(width: 10),
//                                                         Text(S .current.unlock,
//                                                             style: TextStyle(
//                                                                 color: ColorCodes.blackColor,
//                                                                 fontSize: 16.0)),
//                                                         SizedBox(width: 10),
//                                                         Icon(
//                                                           Icons
//                                                               .arrow_forward_ios_sharp,
//                                                           color: Colors.black,
//                                                           size: 12,
//                                                         ),
//                                                         SizedBox(width: 10),
//                                                       ]
//                                                   ),
//                                                 ),
//
//                                               ],
//                                             ),
//                                           ),
//                                         )
//                                             : SizedBox.shrink()
//                                             : SizedBox.shrink(),
//                                       ],
//                                     ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       SizedBox(
//                         height: 10.0,
//                       ),
//                       Divider(
//                         thickness: 1.0,
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       if (_isdescription || _ismanufacturer)
//
//                       //child: new
//                         Padding(
//                           padding: const EdgeInsets.only(bottom: 10.0, left: 30, right: 30),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   new Container(
//                                     width: 500,
//                                     child: new TabBar(
//                                         controller: _tabController,
//                                         labelColor: Colors.black,
//                                         labelStyle: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 16,
//                                         ),
//                                         indicatorColor: Colors.black,
//                                         indicatorSize: TabBarIndicatorSize.tab,
//                                         tabs: tabList),
//                                   ),
//                                   if(Features.isShoppingList)
//                                     (PrefUtils.prefs!.containsKey("apikey"))?
//                                     Container(
//                                     child: Row(
//                                       children: [
//                                         MouseRegion(
//                                           cursor: SystemMouseCursors.click,
//                                           child: GestureDetector(
//                                             behavior: HitTestBehavior.opaque,
//                                             onTap: () {
//                                               final shoplistData = Provider.of<BrandItemsList>(context, listen: false);
//
//                                               if (shoplistData.itemsshoplist.length <= 0) {
//                                                 _dialogforCreatelistTwo(context, shoplistData);
//                                               } else {
//                                                 _dialogforShoppinglistTwo(context);
//                                               }
//                                             },
//                                             child: Row(
//                                               children: [
//                                                 Image.asset(
//                                                     Images.addToListImg,width: 25,height: 25,color: ColorCodes.mediumBlackColor),
//                                                 SizedBox(width: 5),
//                                                 Text(S .current.add_to_list, style: TextStyle(
//                                                     fontSize: 16, color: ColorCodes.mediumBlackColor,
//                                                     fontWeight: FontWeight.bold),),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         if(Features.isShare)
//                                         GestureDetector(
//                                           behavior: HitTestBehavior.translucent,
//                                           onTap: () {
//                                             Navigator.of(context).pop();
//                                             if (_isIOS) {
//                                               Share.share(S .current.download_app +
//                                                   IConstants.APP_NAME +
//                                                   '${S .current.from_app_store} https://apps.apple.com/us/app/id' + IConstants.appleId);
//                                             } else {
//                                               Share.share(S .current.download_app +
//                                                   IConstants.APP_NAME +
//                                                   '${S .current.from_google_play_store}https://play.google.com/store/apps/details?id=' + IConstants.androidId);
//                                             }
//                                           },
//                                           child: Row(
//                                             children: <Widget>[
//                                               SizedBox(
//                                                 width: 20.0,
//                                               ),
//                                               Icon(Icons.share, color: Colors.grey, size: 26),
//                                               SizedBox(
//                                                 width: 15.0,
//                                               ),
//                                               Text(
//                                                 S .current.share,
//                                                 style: TextStyle(
//                                                     fontSize: 20, color: ColorCodes.mediumBlackColor,
//                                                     fontWeight: FontWeight.bold),
//                                               ),
//                                               //Spacer(),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ):
//                                    SizedBox.shrink(),
//
//                                 ],
//                               ),
//
//                               Container(
//                                 height: 150,
//                                 padding: EdgeInsets.all(8),
//                                 child: new TabBarView(
//                                   controller: _tabController,
//                                   children:[... tabList.map((Tab? tab){
//                                     return _getPage(tab!);
//                                   }).toList()],
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       //),
//                       SizedBox(
//                         height: 5.0,
//                       ),
//
//
//
//
//                       Container(
//                         margin: EdgeInsets.only(
//                             left: 10, top: 20, right: 10, bottom: 20),
//                         child: Column(
//                           children: <Widget>[
//
//                             _similarProduct
//                                 ? Container(
//                               child: Column(
//                                 children: <Widget>[
//                                   new Row(
//                                     children: <Widget>[
//                                       SizedBox(
//                                         width: 5.0,
//                                       ),
//                                       Text(
//                                         sellingitemData.newitemname,
//                                         style: TextStyle(
//                                             fontSize: 20.0,
//                                             color: Theme
//                                                 .of(context)
//                                                 .primaryColor,
//                                             fontWeight:
//                                             FontWeight.bold),
//                                       ),
//                                       Spacer(),
//                                       SizedBox(
//                                         width: 10,
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(height: 10.0),
//                                   new Row(
//                                     children: <Widget>[
//                                       Expanded(
//                                           child: SizedBox(
//                                             height: 380.0,
//                                             child: new ListView.builder(
//                                               shrinkWrap: true,
//                                               scrollDirection:
//                                               Axis.horizontal,
//                                               itemCount: sellingitemData
//                                                   .itemsnew.length,
//                                               itemBuilder: (_, i) =>
//                                                   Column(
//                                                     children: [
//                                                       Items(
//                                                         "singleproduct_screen",
//                                                         sellingitemData.itemsnew[i].id!,
//                                                         sellingitemData.itemsnew[i].title!,
//                                                         sellingitemData.itemsnew[i].imageUrl!,
//                                                         sellingitemData.itemsnew[i].brand!,
//                                                         sellingitemData.itemsnew[i].veg_type!,
//                                                         sellingitemData.itemsnew[i].type!,
//                                                         sellingitemData.itemsnew[i].eligible_for_express!,
//                                                         sellingitemData.itemsnew[i].delivery!,
//                                                         sellingitemData.itemsnew[i].duration!,
//                                                         sellingitemData.itemsnew[i].durationType!,
//                                                         sellingitemData.itemsnew[i].note!,
//                                                         sellingitemData.itemsnew[i].subscribe!,
//                                                         sellingitemData.itemsnew[i].paymentmode!,
//                                                         sellingitemData.itemsnew[i].cronTime!,
//                                                         sellingitemData.itemsnew[i].name!,
//
//                                                       ),
//                                                     ],
//                                                   ),
//                                             ),
//                                           )),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             )
//                                 : Container(),
//                           ],
//                         ),
//                       ),
//                       //if (ResponsiveLayout.isSmallScreen(context) || ResponsiveLayout.isMediumScreen(context) || ResponsiveLayout.isLargeScreen(context))
//                       // _footer(),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//
//     Widget mobileBody() {
//       return SafeArea(
//         child: _isLoading
//             ? Center(
//           child: SingelItemScreenShimmer(),
//         )
//             : Column(
//           children: [
//             //ResponsiveLayout.isLargeScreen(context) ? _appBar() : Header(),
//             // _responsiveAppBar(),
//             //Header(),
//          /*   if (ResponsiveLayout.isSmallScreen(context))
//               Container(
//                   decoration: BoxDecoration(
//                     boxShadow: <BoxShadow>[
//                       BoxShadow(
//                           color: Colors.black54,
//                           blurRadius: 15.0,
//                           offset: Offset(0.0, 0.75))
//                     ],
//                     color: Theme.of(context).buttonColor,
//                   ),
//                   width: MediaQuery.of(context).size.width,
//                   padding: EdgeInsets.all(1.0),
//                   margin: EdgeInsets.only(
//                       left: 0.0, top: 0.0, right: 0.0, bottom: 0.0),
//                   height: 36,
//                   child: Row(children: [
//                     // IconButton(icon: Icon(Icons.location_on,size:18,color: Colors.black,)),
//                     SizedBox(
//                       width: 6,
//                     ),
//                     CircleAvatar(
//                         radius: 12.0,
//                         backgroundColor: Colors.transparent,
//                         child: Icon(Icons.location_on,
//                             color: Theme.of(context).primaryColor,
//                             size: (18))),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Expanded(
//                       child:  Text(
//                         (_deliverlocation!=null)?_deliverlocation:"",
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                             color: ColorCodes.deliveryLocation,
//                             fontSize: 16.0,
//                             fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     GestureDetector(
//                         onTap: () async {
//                           PrefUtils.prefs!.setString("formapscreen", "homescreen");
//                           Navigator.of(context)
//                               .pushNamed(MapScreen.routeName);
//                         },
//                         child: Text(
//                           S .current.change,
//                           style: TextStyle(
//                               color: Theme.of(context).primaryColor,
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold),
//                         )),
//                     SizedBox(
//                       width: 10,
//                     )
//                   ])),*/
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: <Widget>[
//                     SizedBox(
//                       height: 20.0,
//                     ),
//                     !_isStock
//                         ? Consumer<CartCalculations>(
//                       builder: (_, cart, ch) => BadgeOfStock(
//                         child: ch!,
//                         value: margins,
//                         singleproduct: true,
//                       ),
//                       child: GestureDetector(
//                         onTap: () {
//                           Navigator.of(context).pushNamed(
//                               SingleProductImageScreen.routeName,
//                               arguments: {
//                                 "itemid": itemid,
//                                 "itemname": itemname,
//                                 "itemimg": itemimg,
//                                 "fromScreen":fromScreen.toString() == "NotificationScreen"?"NotificationScreen":"",
//                                 'notificationFor': notificationFor.toString(),
//                               });
//                         },
//                         child: GFCarousel(
//                           autoPlay: true,
//                           viewportFraction: 1.0,
//                           height: 173,
//                           pagination: true,
//                           passiveIndicator: Colors.white,
//                           activeIndicator:
//                           Theme.of(context).accentColor,
//                           autoPlayInterval: Duration(seconds: 8),
//                           items: <Widget>[
//                             for (var i = 0;
//                             i < multiimage.length;
//                             i++)
//                               Builder(
//                                 builder: (BuildContext context) {
//                                   return GestureDetector(
//                                     onTap: () {},
//                                     child: Container(
//                                         color: Colors.white,
//                                         margin: EdgeInsets.symmetric(
//                                             horizontal: 5.0),
//                                         child: ClipRRect(
//                                             borderRadius:
//                                             BorderRadius.all(
//                                                 Radius.circular(
//                                                     5.0)),
//                                             child: /*Row(
//                                               mainAxisAlignment: MainAxisAlignment.center,
//                                               children: [
//                                                 if(singleitemData.singleitems[0].eligible_for_express == "0")
//                                                   Align(
//                                                       alignment: Alignment.topLeft,
//                                                       child: Image.asset(Images.express,
//                                                         height: 30.0,
//                                                         width: 30.0,)
//                                                   ),*/
//                                                 CachedNetworkImage(
//                                                     imageUrl: multiimage[i].imageUrl,
//                                                     placeholder: (context, url) => Image.asset(Images.defaultProductImg),
//                                                     errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg),
//                                                     fit: BoxFit.fill),
//                                               /*],
//                                             )*/
//                                         )),
//                                   );
//                                 },
//                               )
//                           ],
//                         ),
//                       ),
//                     )
//                         : GestureDetector(
//                       onTap: () {
//                         Navigator.of(context).pushNamed(
//                             SingleProductImageScreen.routeName,
//                             arguments: {
//                               "itemid": itemid,
//                               "itemname": itemname,
//                               "itemimg": itemimg,
//                               "fromScreen":fromScreen.toString() == "NotificationScreen"?"NotificationScreen":"",
//                               'notificationFor': notificationFor.toString(),
//                             });
//                       },
//                       child: GFCarousel(
//                         autoPlay: true,
//                         viewportFraction: 1.0,
//                         height: 180,
//                         pagination: true,
//                         passiveIndicator: Colors.white,
//                         activeIndicator:
//                         Theme.of(context).accentColor,
//                         autoPlayInterval: Duration(seconds: 8),
//                         items: <Widget>[
//                           for (var i = 0; i < multiimage.length; i++)
//                             Builder(
//                               builder: (BuildContext context) {
//                                 return GestureDetector(
//                                   onTap: () {},
//                                   child: /*Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       if(singleitemData.singleitems[0].eligible_for_express == "0")
//                                         Align(
//                                             alignment: Alignment.topLeft,
//                                             child: Image.asset(Images.express,
//                                               height: 20.0,
//                                               width: 20.0,)
//                                         ),*/
//                                       Container(
//                                         color: Colors.white,
//                                           margin: EdgeInsets.symmetric(
//                                               horizontal: 5.0),
//                                           child: ClipRRect(
//                                               borderRadius:
//                                               BorderRadius.all(
//                                                   Radius.circular(
//                                                       5.0)),
//                                               child: CachedNetworkImage(
//                                                   imageUrl: multiimage[i].imageUrl,
//                                                   placeholder: (context, url) => Image.asset(Images.defaultProductImg),
//                                                   errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg),
//                                                   fit: BoxFit.fill))),
//                                     /*],
//                                   ),*/
//                                 );
//                               },
//                             )
//                         ],
//                       ),
//                     ),
//                     Container(
//                       margin: EdgeInsets.only(
//                           left: 10.0, top: 20.0, right: 10.0, bottom: 20.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Row(
//                             children: [
//                               Text(
//                                 singleitemData.singleitems[0].brand,
//                                 style: TextStyle(
//                                     fontSize: 12,
//                                 ),
//                               ),
//                               Spacer(),
//                               if (_checkmargin)
//                                 Container(
//                                   //margin: EdgeInsets.only(right:5.0),
//                                   padding: EdgeInsets.all(3.0),
//                                   // color: Theme.of(context).accentColor,
//                                   decoration: BoxDecoration(
//                                     borderRadius:
//                                     BorderRadius.circular(3.0),
//                                     color: /*Color(0xff6CBB3C)*/Colors.transparent,
//                                   ),
//                                   constraints: BoxConstraints(
//                                     minWidth: 28,
//                                     minHeight: 18,
//                                   ),
//                                   child: Text(
//                                     margins + S .current.off,
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                         fontSize: 14,
//                                         color:ColorCodes.darkgreen,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                           SizedBox(
//                             height: 5.0,
//                           ),
//                           Row(
//                             children: [
//                               Container(
//                                 width:
//                                 MediaQuery.of(context).size.width / 2 +
//                                     40,
//                                 child: Column(
//                                   crossAxisAlignment:
//                                   CrossAxisAlignment.start,
//                                   children: <Widget>[
//                                     Text(
//                                       singleitemData.singleitems[0].title,
//                                       maxLines: 2,
//                                       style: TextStyle(
//                                         fontSize: 17,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 10.0,
//                                     ),
//                                     _checkmembership
//                                         ? Row(
//                                       children: <Widget>[
//                                         memberpriceDisplay
//                                             ? Column(
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment
//                                               .start,
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   Features.iscurrencyformatalign?
//                                                   '$varmemberprice ' + IConstants.currencyFormat:
//                                                     IConstants.currencyFormat +
//                                                     '$varmemberprice ',
//                                                     style: new TextStyle(
//                                                         fontWeight: FontWeight.bold,
//                                                         fontSize: 16.0)),
//                                                 Text(
//                                                   Features.iscurrencyformatalign?
//                                                   '$varmrp ' + IConstants.currencyFormat:
//                                                     IConstants.currencyFormat +
//                                                     '$varmrp ',
//                                                     style: new TextStyle(
//                                                         fontWeight: FontWeight.bold,
//                                                         fontSize: 16.0)),
//                                               ],
//                                             )
//                                         /*    new RichText(
//                                                 text: new TextSpan(
//                                                     style: new TextStyle(
//                                                       fontSize:
//                                                       14.0,
//                                                       color:
//                                                       Colors.black,
//                                                     ),
//                                                     children: <TextSpan>[
//                                                       new TextSpan(
//                                                           text:
//                                                           S .current.product_mrp,
//                                                           style:
//                                                           new TextStyle(fontSize: 16.0)),
//                                                       new TextSpan(
//                                                           text: IConstants.currencyFormat +
//                                                               '$varmrp ',
//                                                           style: new TextStyle(
//                                                               fontWeight: FontWeight.bold,
//                                                               fontSize: 16.0))
//                                                     ])),
//                                             Row(
//                                               children: [
//                                                 Container(
//                                                   width: 25.0,
//                                                   height: 25.0,
//                                                   child: Image
//                                                       .asset(
//                                                     Images.starImg,
//                                                   ),
//                                                 ),
//                                                 new RichText(
//                                                     text: new TextSpan(
//                                                         style: new TextStyle(
//                                                           fontSize:
//                                                           14.0,
//                                                           color:
//                                                           Colors.black,
//                                                         ),
//                                                         children: <TextSpan>[
//                                                           new TextSpan(
//                                                               text:
//                                                               S .current.selling_price,
//                                                               style:
//                                                               new TextStyle(fontSize: 16.0)),
//                                                           new TextSpan(
//                                                               text: IConstants.currencyFormat +
//                                                                   '$varmemberprice ',
//                                                               style: new TextStyle(
//                                                                   fontWeight: FontWeight.bold,
//                                                                   fontSize: 16.0))
//                                                         ])),
//                                               ],
//                                             ),*/
//                                           ],
//                                         )
//                                             : discountDisplay
//                                             ? Column(
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment
//                                               .start,
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   Features.iscurrencyformatalign?
//                                                   '$varprice ' + IConstants.currencyFormat:
//                                                     IConstants.currencyFormat + '$varprice ',
//                                                     style: new TextStyle(
//                                                         fontWeight: FontWeight.bold,
//                                                         fontSize: 16.0)),
//                                                 Text(
//                                                   Features.iscurrencyformatalign?
//                                                   '$varmrp ' + IConstants.currencyFormat:
//                                                     IConstants.currencyFormat +
//                                                     '$varmrp ',
//                                                     style: new TextStyle(
//                                                         decoration: TextDecoration.lineThrough,
//                                                         color: Colors.grey,
//                                                         fontSize: 14.0)),
//                                               ],
//                                             ),
//                                           /*  new RichText(
//                                                 text: new TextSpan(
//                                                     style: new TextStyle(
//                                                       fontSize:
//                                                       14.0,
//                                                       color:
//                                                       Colors.black,
//                                                     ),
//                                                     children: <TextSpan>[
//                                                       new TextSpan(
//                                                           text:
//                                                           S .current.product_mrp,
//                                                           style:
//                                                           new TextStyle(fontSize: 16.0)),
//                                                       new TextSpan(
//                                                           text: IConstants.currencyFormat +
//                                                               '$varmrp ',
//                                                           style: TextStyle(
//                                                               decoration: TextDecoration.lineThrough,
//                                                               fontSize: 12,
//                                                               color: Colors.grey))
//                                                     ])),
//                                             Row(
//                                               children: [
//                                                 Container(
//                                                   width:
//                                                   25.0,
//                                                   height:
//                                                   25.0,
//                                                   child: Image
//                                                       .asset(
//                                                     Images.starImg,
//                                                   ),
//                                                 ),
//                                                 Text(
//                                                     IConstants.currencyFormat + '$varprice ',
//                                                     style: new TextStyle(
//                                                         fontWeight:
//                                                         FontWeight.bold,
//                                                         fontSize: 16.0)),
//                                               ],
//                                             ),*/
//                                           ],
//                                         )
//                                             : Row(
//                                           children: [
//                                           /*  Container(
//                                               width: 25.0,
//                                               height: 25.0,
//                                               child: Image
//                                                   .asset(
//                                                 Images.starImg,
//                                               ),
//                                             ),*/
//                                             Text(
//                                               Features.iscurrencyformatalign?
//                                               '$varmrp ' + IConstants.currencyFormat:
//                                                 IConstants.currencyFormat +
//                                                 '$varmrp ',
//                                                 style: new TextStyle(
//                                                    // decoration: TextDecoration.lineThrough,
//                                                     fontWeight: FontWeight.bold,
//                                                     fontSize: 16.0)),
//                                           /*  new RichText(
//                                                 text: new TextSpan(
//                                                     style: new TextStyle(
//                                                       fontSize:
//                                                       14.0,
//                                                       color:
//                                                       Colors.black,
//                                                     ),
//                                                     children: <TextSpan>[
//                                                       new TextSpan(
//                                                           text:
//                                                           S .current.selling_price,
//                                                           style:
//                                                           new TextStyle(fontSize: 16.0)),
//                                                       new TextSpan(
//                                                           text: IConstants.currencyFormat +
//                                                               '$varmrp ',
//                                                           style: new TextStyle(
//                                                               fontWeight: FontWeight.bold,
//                                                               fontSize: 16.0))
//                                                     ])),*/
//                                           ],
//                                         )
//                                       ],
//                                     )
//                                         : discountDisplay
//                                         ? Column(
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment
//                                           .start,
//                                       children: [
//                                         Row(
//                                           children: [
//                                             Text(
//                                               Features.iscurrencyformatalign?
//                                               '$varprice ' + IConstants.currencyFormat:
//                                                 IConstants.currencyFormat + '$varprice ',
//                                                 style: new TextStyle(
//                                                     fontWeight: FontWeight.bold,
//                                                     fontSize: 16.0)),
//                                             Text(
//                                               Features.iscurrencyformatalign?
//                                               '$varmrp ' + IConstants.currencyFormat:
//                                                 IConstants.currencyFormat +
//                                                 '$varmrp ',
//                                                 style: new TextStyle(
//                                                     decoration: TextDecoration.lineThrough,
//                                                     color: Colors.grey,
//                                                     fontSize: 14.0)),
//                                           ],
//                                         ),
//                                        /* new RichText(
//                                             text: new TextSpan(
//                                                 style:
//                                                 new TextStyle(
//                                                   fontSize: 14.0,
//                                                   color: Colors
//                                                       .black,
//                                                 ),
//                                                 children: <
//                                                     TextSpan>[
//                                                   new TextSpan(
//                                                       text:
//                                                       S .current.product_mrp,
//                                                       style: new TextStyle(
//                                                           fontSize:
//                                                           16.0)),
//                                                   new TextSpan(
//                                                       text: IConstants.currencyFormat + ' $varmrp ',
//                                                       style: TextStyle(
//                                                           decoration:
//                                                           TextDecoration
//                                                               .lineThrough,
//                                                           fontSize:
//                                                           12,
//                                                           color: Colors
//                                                               .grey))
//                                                 ])),
//                                         new RichText(
//                                             text: new TextSpan(
//                                                 style:
//                                                 new TextStyle(
//                                                   fontSize: 14.0,
//                                                   color: Colors
//                                                       .black,
//                                                 ),
//                                                 children: <
//                                                     TextSpan>[
//                                                   new TextSpan(
//                                                       text:
//                                                       S .current.selling_price,
//                                                       style: new TextStyle(
//                                                           fontSize:
//                                                           16.0)),
//                                                   new TextSpan(
//                                                       text: IConstants.currencyFormat +
//                                                           ' $varprice  ',
//                                                       style: new TextStyle(
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .bold,
//                                                           fontSize:
//                                                           16.0))
//                                                 ])),*/
//                                       ],
//                                     )
//                                         :       Row(
//                                       children: [
//                                         Text(
//                                           Features.iscurrencyformatalign?
//                                           '$varmrp ' + IConstants.currencyFormat:
//                                             IConstants.currencyFormat +
//                                             '$varmrp ',
//                                             style: new TextStyle(
//                                                 fontWeight:
//                                                 FontWeight
//                                                     .bold,
//                                                 fontSize: 16.0)),
//                                       ],
//                                     ),
//                                   /*  new RichText(
//                                         text: new TextSpan(
//                                             style: new TextStyle(
//                                               fontSize: 14.0,
//                                               color: Colors.black,
//                                             ),
//                                             children: <TextSpan>[
//                                               new TextSpan(
//                                                   text:
//                                                   S .current.selling_price,
//                                                   style:
//                                                   new TextStyle(
//                                                       fontSize:
//                                                       16.0)),
//                                               new TextSpan(
//                                                   text:
//                                                   IConstants.currencyFormat +
//                                                       '$varmrp ',
//                                                   style: new TextStyle(
//                                                       fontWeight:
//                                                       FontWeight
//                                                           .bold,
//                                                       fontSize: 16.0))
//                                             ])),*/
//                                     Text(
//                                       S .current.inclusive_of_all_tax,
//                                       style: TextStyle(
//                                           fontSize: 8, color: Colors.grey),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 2 -
//                                         60,
//                                     child: Column(
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.end,
//                                       mainAxisAlignment: MainAxisAlignment.end,
//                                       children: [
//
//                                         if(Features.isLoyalty)
//                                           if(double.parse(varLoyalty.toString()) > 0)
//                                             Container(
//                                               child: Row(
//                                                 mainAxisAlignment: MainAxisAlignment.end,
//                                                 children: [
//                                                   Image.asset(Images.coinImg,
//                                                     height: 15.0,
//                                                     width: 20.0,),
//                                                   SizedBox(width: 4),
//                                                   Text(varLoyalty.toString()),
//                                                 ],
//                                               ),
//                                             ),
//                                         SizedBox(
//                                           height: 10,
//                                         ),
//                                         SizedBox(
//                                           height: 10,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   (singleitemData.singleitems[0].eligible_for_express == "0") ?
//                                   Image.asset(Images.express,
//                                     height: 20.0,
//                                     width: 25.0,):
//                                   SizedBox.shrink(),
//                                 ],
//                               )
//                             ],
//                           ),
//                          // SizedBox(height: 5,),
//                           if(Features.netWeight && veg_type == "fish")
//                             SizedBox(height: 10.0),
//                           if(Features.netWeight && veg_type == "fish")
//                             Container(
//                               child: Text(
//                                 Features.iscurrencyformatalign?
//                                 "Whole Uncut:" +" "+ '$salePrice ' + IConstants.currencyFormat +" / "+ "500 G":
//                                   "Whole Uncut:" +" "+ IConstants.currencyFormat +
//                                   '$salePrice ' +" / "+ "500 G",
//                                   style: new TextStyle(
//                                       fontWeight:
//                                       FontWeight
//                                           .bold,
//                                       fontSize: 16.0)
//                               ),
//                             ),
//                           if(Features.netWeight && veg_type == "fish")
//                             SizedBox(height: 10.0),
//                           if(Features.netWeight && veg_type == "fish")
//                             Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Column(
//                                     children: [
//                                       Container(
//                                         // width:
//                                         // MediaQuery.of(context).size.width / 2.1,
//                                         child: Text("Gross Weight:" +" "+
//                                             '$weight ',
//                                             style: new TextStyle(
//                                                 fontWeight:
//                                                 FontWeight
//                                                     .bold,
//                                                 fontSize: 16.0)
//                                         ),),
//                                     ],
//                                   ),
//                                   Column(
//                                     crossAxisAlignment: CrossAxisAlignment.end,
//                                     children: [
//                                       Container(
//                                         // width:
//                                         // MediaQuery.of(context).size.width / 2.1,
//                                         child: Text("Net Weight:" +" "+
//                                             '$netWeight ',
//                                             style: new TextStyle(
//                                                 fontWeight:
//                                                 FontWeight
//                                                     .bold,
//                                                 fontSize: 16.0)
//                                         ),),
//                                     ],
//                                   )
//                                 ]
//                             ),
//                           SizedBox(height: 10,),
// //                           Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                             children: [
// //                               _isStock
// //                                   ? Container(
// //                                 height: 30.0,
// //                                 width: (MediaQuery.of(context)
// //                                     .size
// //                                     .width /
// //                                     3) +
// //                                     25,
// //                                 child: ValueListenableBuilder(
// //                                   valueListenable:
// //                                   Hive.box<Product>(
// //                                       productBoxName)
// //                                       .listenable(),
// //                                   builder: (context,
// //                                       Box<Product> box, _) {
// //                                     if (_varQty <= 0)
// //                                       return GestureDetector(
// //                                         onTap: () {
// //                                           setState(() {
// //                                             _isAddToCart = true;
// //                                           });
// //                                           addToCart(int.parse(varminitem));
// //                                         },
// //                                         child: Container(
// //                                           height: 30.0,
// //                                           width: (MediaQuery.of(context).size.width / 3) + 25,
// //                                           decoration: new BoxDecoration(
// //                                               color: (Features.isSubscription)?Theme
// //                                                   .of(context)
// //                                                   .primaryColor :ColorCodes.greenColor,
// //                                               borderRadius: new BorderRadius.only(
// //                                                 topLeft: const Radius.circular(2.0),
// //                                                 topRight: const Radius.circular(2.0),
// //                                                 bottomLeft: const Radius.circular(2.0),
// //                                                 bottomRight: const Radius.circular(2.0),
// //                                               )),
// //                                           child: _isAddToCart ?
// //                                           Center(
// //                                             child: SizedBox(
// //                                                 width: 20.0,
// //                                                 height: 20.0,
// //                                                 child: new CircularProgressIndicator(
// //                                                   strokeWidth: 2.0,
// //                                                   valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)),
// //                                           )
// //                                               :(Features.isSubscription)?Row(
// //                                             mainAxisAlignment: MainAxisAlignment.center,
// //                                             children: [
// //                                              /* SizedBox(
// //                                                 width: 3,
// //                                               ),*/
// //                                               Center(
// //                                                   child: Text(
// //                                                     S .current.buy_once,
// //                                                     style:
// //                                                     TextStyle(
// //                                                       color: ColorCodes.whiteColor,
// //                                                     ),
// //                                                     textAlign:
// //                                                     TextAlign
// //                                                         .center,
// //                                                   )),
// //                                             /*  Spacer(),
// //                                               Container(
// //                                                 decoration:
// //                                                 BoxDecoration(
// //                                                     color: Theme
// //                                                         .of(context)
// //                                                         .primaryColor,
// //                                                     borderRadius:
// //                                                     new BorderRadius.only(
// //                                                       topLeft:
// //                                                       const Radius.circular(2.0),
// //                                                       bottomLeft:
// //                                                       const Radius.circular(2.0),
// //                                                       topRight:
// //                                                       const Radius.circular(2.0),
// //                                                       bottomRight:
// //                                                       const Radius.circular(2.0),
// //                                                     )),
// //                                                 height: 30,
// //                                                 width: 25,
// //                                                 child: Icon(
// //                                                   Icons.add,
// //                                                   size: 12,
// //                                                   color: Colors
// //                                                       .white,
// //                                                 ),
// //                                               ),*/
// //                                             ],
// //                                           ):
// //                                           Row(
// //                                             children: [
// //                                               SizedBox(
// //                                                 width: 10,
// //                                               ),
// //                                               Center(
// //                                                   child: Text(
// //                                                     S .current.add,//'ADD',
// //                                                     style:
// //                                                     TextStyle(
// //                                                       color: Theme.of(
// //                                                           context)
// //                                                           .buttonColor,
// //                                                     ),
// //                                                     textAlign:
// //                                                     TextAlign
// //                                                         .center,
// //                                                   )),
// //                                               Spacer(),
// //                                               Container(
// //                                                 decoration:
// //                                                 BoxDecoration(
// //                                                     color: Color(
// //                                                         0xff1BA130),
// //                                                     borderRadius:
// //                                                     new BorderRadius.only(
// //                                                       topLeft:
// //                                                       const Radius.circular(2.0),
// //                                                       bottomLeft:
// //                                                       const Radius.circular(2.0),
// //                                                       topRight:
// //                                                       const Radius.circular(2.0),
// //                                                       bottomRight:
// //                                                       const Radius.circular(2.0),
// //                                                     )),
// //                                                 height: 50,
// //                                                 width: 25,
// //                                                 child: Icon(
// //                                                   Icons.add,
// //                                                   size: 12,
// //                                                   color: Colors
// //                                                       .white,
// //                                                 ),
// //                                               ),
// //                                             ],
// //                                           ),
// //                                         ),
// //                                       );
// //                                     else
// //                                       return Container(
// //                                         child: Row(
// //                                           children: <Widget>[
// //                                             GestureDetector(
// //                                               onTap: () async {
// //                                                 setState(() {
// //                                                   _isAddToCart = true;
// //                                                   incrementToCart(_varQty - 1);
// //                                                 });
// //                                                 // VxRemoveCart(context, productBox: productBox, varQty: _varQty, varminitem: varminitem, isAddToCart: _isAddToCart, varid: varid, varprice: varprice, singleitemvar: singleitemvar, itemid: itemid, varname: varname, varmaxitem: varmaxitem, varLoyalty: varLoyalty, varstock: varstock, varmrp: varmrp, itemname: itemname, varmemberprice: varmemberprice, itemimg: itemimg, veg_type: veg_type, type: type, eligibleforexpress: eligibleforexpress, delivery: delivery, duration: duration, durationType: durationType);
// //
// //                                               },
// //                                               child: (Features.isSubscription)?
// //                                               Container(
// //                                                   width: 30,
// //                                                   height: 30,
// //                                                   decoration:
// //                                                   new BoxDecoration(
// //                                                       border: Border
// //                                                           .all(
// //                                                         color: Theme
// //                                                             .of(context)
// //                                                             .primaryColor,
// //                                                       ),
// //                                                       borderRadius:
// //                                                       new BorderRadius.only(
// //                                                         bottomLeft:
// //                                                         const Radius.circular(2.0),
// //                                                         topLeft:
// //                                                         const Radius.circular(2.0),
// //                                                       )),
// //                                                   child: Center(
// //                                                     child: Text(
// //                                                       "-",
// //                                                       textAlign:
// //                                                       TextAlign
// //                                                           .center,
// //                                                       style:
// //                                                       TextStyle(
// //                                                         color: Theme
// //                                                             .of(context)
// //                                                             .primaryColor,
// //                                                       ),
// //                                                     ),
// //                                                   ))
// //                                                   :Container(
// //                                                   width: 30,
// //                                                   height: 30,
// //                                                   decoration:
// //                                                   new BoxDecoration(
// //                                                       border: Border
// //                                                           .all(
// //                                                         color: ColorCodes.greenColor,
// //                                                       ),
// //                                                       borderRadius:
// //                                                       new BorderRadius.only(
// //                                                         bottomLeft:
// //                                                         const Radius.circular(2.0),
// //                                                         topLeft:
// //                                                         const Radius.circular(2.0),
// //                                                       )),
// //                                                   child: Center(
// //                                                     child: Text(
// //                                                       "-",
// //                                                       textAlign:
// //                                                       TextAlign
// //                                                           .center,
// //                                                       style:
// //                                                       TextStyle(
// //                                                         color: ColorCodes.greenColor,
// //                                                       ),
// //                                                     ),
// //                                                   )),
// //                                             ),
// //                                             Expanded(
// //                                               child: _isAddToCart ?
// //                                               Container(
// //                                                 decoration: BoxDecoration(color: (Features.isSubscription)? Theme
// //                                                     .of(context)
// //                                                     .primaryColor:ColorCodes.greenColor,),
// //                                                 height: 30,
// //
// //                                                 child: Center(
// //                                                   child: SizedBox(
// //                                                       width: 20.0,
// //                                                       height: 20.0,
// //                                                       child: new CircularProgressIndicator(
// //                                                         strokeWidth: 2.0,
// //                                                         valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)),
// //                                                 ),
// //                                               )
// //                                                   :
// //                                               ValueListenableBuilder(
// //                                                   valueListenable: Hive.box<Product>(productBoxName).listenable(),
// //                                                   builder: (context, Box<Product> box, index) {
// //                                                     if (box.values.isEmpty) return SizedBox.shrink();
// //                                                     return  (Features.isSubscription)?
// //                                                     Container(
// // //                                            width: 40,
// //                                                         decoration:
// //                                                         BoxDecoration(
// //                                                           color: Theme
// //                                                               .of(context)
// //                                                               .primaryColor,
// //                                                         ),
// //                                                         height: 30,
// //                                                         child: Center(
// //                                                           child: Text(
// //                                                             _varQty.toString(),
// //                                                             textAlign:
// //                                                             TextAlign
// //                                                                 .center,
// //                                                             style:
// //                                                             TextStyle(
// //                                                               color: ColorCodes.whiteColor,
// //                                                             ),
// //                                                           ),
// //                                                         ))
// //                                                         :Container(
// // //                                            width: 40,
// //                                                         decoration:
// //                                                         BoxDecoration(
// //                                                           color: ColorCodes.greenColor,
// //                                                         ),
// //                                                         height: 30,
// //                                                         child: Center(
// //                                                           child: Text(
// //                                                             _varQty.toString(),
// //                                                             textAlign:
// //                                                             TextAlign
// //                                                                 .center,
// //                                                             style:
// //                                                             TextStyle(
// //                                                               color: Theme
// //                                                                   .of(context)
// //                                                                   .buttonColor,
// //                                                             ),
// //                                                           ),
// //                                                         ));
// //                                                   }),
// //                                             ),
// //                                             GestureDetector(
// //                                               onTap: () {
// //                                                 if (_varQty < int.parse(varstock)) {
// //                                                   if (_varQty < int.parse(varmaxitem)) {
// //                                                     setState(() {
// //                                                       _isAddToCart = true;
// //                                                     });
// //                                                     // VxAddCart(context, productBox: productBox, varQty: _varQty, varminitem: varminitem, isAddToCart: _isAddToCart, varid: varid, varprice: varprice, singleitemvar: singleitemvar, itemid: itemid, varname: varname, varmaxitem: varmaxitem, varLoyalty: varLoyalty, varstock: varstock, varmrp: varmrp, itemname: itemname, varmemberprice: varmemberprice, itemimg: itemimg, veg_type: veg_type, type: type, eligibleforexpress: eligibleforexpress, delivery: delivery, duration: duration, durationType: durationType);
// //                                                     incrementToCart(_varQty + 1);
// //                                                   } else {
// //                                                     Fluttertoast.showToast(
// //                                                         msg:
// //                                                         S .current.cant_add_more_item,
// //                                                         fontSize: MediaQuery.of(context).textScaleFactor *13,
// //                                                         backgroundColor:
// //                                                         Colors
// //                                                             .black87,
// //                                                         textColor:
// //                                                         Colors.white);
// //                                                   }
// //                                                 } else {
// //                                                   Fluttertoast.showToast(msg: S .current.sorry_outofstock,  fontSize: MediaQuery.of(context).textScaleFactor *13,backgroundColor: Colors.black87, textColor: Colors.white);
// //                                                 }
// //                                               },
// //                                               child: (Features.isSubscription)?
// //                                               Container(
// //                                                   width: 30,
// //                                                   height: 30,
// //                                                   decoration:
// //                                                   new BoxDecoration(
// //                                                       border: Border
// //                                                           .all(
// //                                                         color: Theme
// //                                                             .of(context)
// //                                                             .primaryColor,
// //                                                       ),
// //                                                       borderRadius:
// //                                                       new BorderRadius.only(
// //                                                         bottomRight:
// //                                                         const Radius.circular(2.0),
// //                                                         topRight:
// //                                                         const Radius.circular(2.0),
// //                                                       )),
// //                                                   child: Center(
// //                                                     child: Text(
// //                                                       "+",
// //                                                       textAlign:
// //                                                       TextAlign
// //                                                           .center,
// //                                                       style:
// //                                                       TextStyle(
// //                                                         color: Theme
// //                                                             .of(context)
// //                                                             .primaryColor,
// //                                                       ),
// //                                                     ),
// //                                                   ))
// //                                                   :Container(
// //                                                   width: 30,
// //                                                   height: 30,
// //                                                   decoration:
// //                                                   new BoxDecoration(
// //                                                       border: Border
// //                                                           .all(
// //                                                         color: ColorCodes.greenColor,
// //                                                       ),
// //                                                       borderRadius:
// //                                                       new BorderRadius.only(
// //                                                         bottomRight:
// //                                                         const Radius.circular(2.0),
// //                                                         topRight:
// //                                                         const Radius.circular(2.0),
// //                                                       )),
// //                                                   child: Center(
// //                                                     child: Text(
// //                                                       "+",
// //                                                       textAlign:
// //                                                       TextAlign
// //                                                           .center,
// //                                                       style:
// //                                                       TextStyle(
// //                                                         color: ColorCodes.greenColor,
// //                                                       ),
// //                                                     ),
// //                                                   )),
// //                                             ),
// //                                           ],
// //                                         ),
// //                                       );
// //
// //
// //                                     /*try {
// //                                             Product item = Hive.box<
// //                                                 Product>(
// //                                                 productBoxName)
// //                                                 .values
// //                                                 .firstWhere((value) =>
// //                                             value.varId ==
// //                                                 int.parse(varid));
// //                                             return Container(
// //                                               child: Row(
// //                                                 children: <Widget>[
// //                                                   GestureDetector(
// //                                                     onTap: () async {
// //                                                       setState(() {
// //                                                         _isAddToCart = true;
// //                                                         incrementToCart(item.itemQty - 1);
// //                                                       });
// //                                                     },
// //                                                     child: Container(
// //                                                         width: 30,
// //                                                         height: 30,
// //                                                         decoration:
// //                                                         new BoxDecoration(
// //                                                             border: Border
// //                                                                 .all(
// //                                                               color: ColorCodes.greenColor,
// //                                                             ),
// //                                                             borderRadius:
// //                                                             new BorderRadius.only(
// //                                                               bottomLeft:
// //                                                               const Radius.circular(2.0),
// //                                                               topLeft:
// //                                                               const Radius.circular(2.0),
// //                                                             )),
// //                                                         child: Center(
// //                                                           child: Text(
// //                                                             "-",
// //                                                             textAlign:
// //                                                             TextAlign
// //                                                                 .center,
// //                                                             style:
// //                                                             TextStyle(
// //                                                               color: ColorCodes.greenColor,
// //                                                             ),
// //                                                           ),
// //                                                         )),
// //                                                   ),
// //                                                   Expanded(
// //                                                     child: _isAddToCart ?
// //                                                     Container(
// //                                                       decoration: BoxDecoration(color: ColorCodes.greenColor,),
// //                                                       height: 30,
// //
// //                                                       child: Center(
// //                                                         child: SizedBox(
// //                                                             width: 20.0,
// //                                                             height: 20.0,
// //                                                             child: new CircularProgressIndicator(
// //                                                               strokeWidth: 2.0,
// //                                                               valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)),
// //                                                       ),
// //                                                     )
// //                                                         :
// //                                                     Container(
// // //                                            width: 40,
// //                                                         decoration:
// //                                                         BoxDecoration(
// //                                                           color: ColorCodes.greenColor,
// //                                                         ),
// //                                                         height: 30,
// //                                                         child: Center(
// //                                                           child: Text(
// //                                                             item.itemQty.toString(),
// //                                                             textAlign:
// //                                                             TextAlign
// //                                                                 .center,
// //                                                             style:
// //                                                             TextStyle(
// //                                                               color: Theme.of(context)
// //                                                                   .buttonColor,
// //                                                             ),
// //                                                           ),
// //                                                         )),
// //                                                   ),
// //                                                   GestureDetector(
// //                                                     onTap: () {
// //                                                       if (item.itemQty < int.parse(varstock)) {
// //                                                         if (item.itemQty < int.parse(varmaxitem)) {
// //                                                           setState(() {
// //                                                             _isAddToCart = true;
// //                                                           });
// //                                                           incrementToCart(item.itemQty + 1);
// //                                                         } else {
// //                                                           Fluttertoast.showToast(
// //                                                               msg:
// //                                                               "Sorry, you can\'t add more of this item!",
// //                                                               backgroundColor:
// //                                                               Colors
// //                                                                   .black87,
// //                                                               textColor:
// //                                                               Colors.white);
// //                                                         }
// //                                                       } else {
// //                                                         Fluttertoast.showToast(msg: "Sorry, Out of Stock!", backgroundColor: Colors.black87, textColor: Colors.white);
// //                                                       }
// //                                                     },
// //                                                     child: Container(
// //                                                         width: 30,
// //                                                         height: 30,
// //                                                         decoration:
// //                                                         new BoxDecoration(
// //                                                             border: Border
// //                                                                 .all(
// //                                                               color: ColorCodes.greenColor,
// //                                                             ),
// //                                                             borderRadius:
// //                                                             new BorderRadius.only(
// //                                                               bottomRight:
// //                                                               const Radius.circular(2.0),
// //                                                               topRight:
// //                                                               const Radius.circular(2.0),
// //                                                             )),
// //                                                         child: Center(
// //                                                           child: Text(
// //                                                             "+",
// //                                                             textAlign:
// //                                                             TextAlign
// //                                                                 .center,
// //                                                             style:
// //                                                             TextStyle(
// //                                                               color: ColorCodes.greenColor,
// //                                                             ),
// //                                                           ),
// //                                                         )),
// //                                                   ),
// //                                                 ],
// //                                               ),
// //                                             );
// //                                           } catch (e) {
// //                                             return GestureDetector(
// //                                               onTap: () {
// //                                                 setState(() {
// //                                                   _isAddToCart = true;
// //                                                 });
// //                                                 addToCart(int.parse(varminitem));
// //                                               },
// //                                               child: Container(
// //                                                 height: 30.0,
// //                                                 width: (MediaQuery.of(context).size.width / 4) + 15,
// //                                                 decoration:
// //                                                 new BoxDecoration(
// //                                                     color: ColorCodes.greenColor,
// //                                                     borderRadius:
// //                                                     new BorderRadius
// //                                                         .only(
// //                                                       topLeft:
// //                                                       const Radius.circular(
// //                                                           2.0),
// //                                                       topRight:
// //                                                       const Radius.circular(
// //                                                           2.0),
// //                                                       bottomLeft:
// //                                                       const Radius.circular(
// //                                                           2.0),
// //                                                       bottomRight:
// //                                                       const Radius.circular(
// //                                                           2.0),
// //                                                     )),
// //                                                 child: _isAddToCart ?
// //                                                 Center(
// //                                                   child: SizedBox(
// //                                                       width: 20.0,
// //                                                       height: 20.0,
// //                                                       child: new CircularProgressIndicator(
// //                                                         strokeWidth: 2.0,
// //                                                         valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)),
// //                                                 )
// //                                                     :
// //                                                 Row(
// //                                                   children: [
// //                                                     SizedBox(
// //                                                       width: 10,
// //                                                     ),
// //                                                     Center(
// //                                                         child: Text(
// //                                                           S .current.add,//'ADD',
// //                                                           style:
// //                                                           TextStyle(
// //                                                             color: Theme.of(
// //                                                                 context)
// //                                                                 .buttonColor,
// //                                                           ),
// //                                                           textAlign:
// //                                                           TextAlign
// //                                                               .center,
// //                                                         )),
// //                                                     Spacer(),
// //                                                     Container(
// //                                                       decoration:
// //                                                       BoxDecoration(
// //                                                           color: Color(
// //                                                               0xff1BA130),
// //                                                           borderRadius:
// //                                                           new BorderRadius.only(
// //                                                             topLeft:
// //                                                             const Radius.circular(2.0),
// //                                                             bottomLeft:
// //                                                             const Radius.circular(2.0),
// //                                                             topRight:
// //                                                             const Radius.circular(2.0),
// //                                                             bottomRight:
// //                                                             const Radius.circular(2.0),
// //                                                           )),
// //                                                       height: 30,
// //                                                       width: 25,
// //                                                       child: Icon(
// //                                                         Icons.add,
// //                                                         size: 12,
// //                                                         color: Colors
// //                                                             .white,
// //                                                       ),
// //                                                     ),
// //                                                   ],
// //                                                 ),
// //                                               ),
// //                                             );
// //                                           }*/
// //                                   },
// //                                 ),
// //                               )
// //                                   : GestureDetector(
// //                                 onTap: () {
// //                                   checkskip
// //                                       ? Navigator.of(context).pushNamed(
// //                                     SignupSelectionScreen.routeName,
// //                                   )
// //                                       : _notifyMe();
// //                                   // Fluttertoast.showToast(
// //                                   //     msg:  "You will be notified via SMS/Push notification, when the product is available" ,
// //                                   //     /*"Out Of Stock",*/
// //                                   //     fontSize: 12.0,
// //                                   //     backgroundColor:
// //                                   //     Colors.black87,
// //                                   //     textColor: Colors.white);
// //                                 },
// //                                 child: Container(
// //                                   height: 30.0,
// //                                   width: (MediaQuery.of(context).size.width / 4) + 15,
// //                                   decoration: new BoxDecoration(
// //                                       border: Border.all(
// //                                           color: Colors.grey),
// //                                       color: Colors.grey,
// //                                       borderRadius:
// //                                       new BorderRadius.only(
// //                                         topLeft: const Radius
// //                                             .circular(2.0),
// //                                         topRight: const Radius
// //                                             .circular(2.0),
// //                                         bottomLeft: const Radius
// //                                             .circular(2.0),
// //                                         bottomRight:
// //                                         const Radius
// //                                             .circular(2.0),
// //                                       )),
// //                                   child:
// //                                   _isNotify ?
// //                                   Center(
// //                                     child: SizedBox(
// //                                         width: 20.0,
// //                                         height: 20.0,
// //                                         child: new CircularProgressIndicator(
// //                                           strokeWidth: 2.0,
// //                                           valueColor: new AlwaysStoppedAnimation<
// //                                               Color>(Colors.white),)),
// //                                   )
// //                                       :
// //                                   Row(
// //                                     children: [
// //                                       SizedBox(
// //                                         width: 10,
// //                                       ),
// //                                       Center(
// //                                           child: Text(
// //                                             S .current.notify_me,
// //                                             /* "ADD",*/
// //                                             style: TextStyle(
// //                                                 fontWeight: FontWeight.w700,
// //                                                 color: Colors
// //                                                     .white ),
// //                                             textAlign:
// //                                             TextAlign.center,
// //                                           )),
// //                                       Spacer(),
// //                                       Container(
// //                                         decoration:
// //                                         BoxDecoration(
// //                                             color: Colors
// //                                                 .black12,
// //                                             borderRadius:
// //                                             new BorderRadius
// //                                                 .only(
// //                                               topRight:
// //                                               const Radius
// //                                                   .circular(
// //                                                   2.0),
// //                                               bottomRight:
// //                                               const Radius
// //                                                   .circular(
// //                                                   2.0),
// //                                             )),
// //                                         height: 50,
// //                                         width: 25,
// //                                         child: Icon(
// //                                           Icons.add,
// //                                           size: 12,
// //                                           color: Colors.white,
// //                                         ),
// //                                       ),
// //                                     ],
// //                                   ),
// //                                 ),
// //                               ),
// //                               (Features.isSubscription)?
// //                               (singleitemData.singleitems[0].subscribe == "0")?
// //                               _isStock?
// //                               MouseRegion(
// //                                 cursor: SystemMouseCursors.click,
// //                                 child: GestureDetector(
// //                                   onTap: () {
// //                                     if(checkskip &&_isWeb && !ResponsiveLayout.isSmallScreen(context)){
// //                                       _dialogforSignIn();
// //                                     }
// //                                     else {
// //                                       (checkskip) ?
// //                                       Navigator.of(context).pushNamed(
// //                                         SignupSelectionScreen.routeName,
// //                                       ) :
// //                                       Navigator.of(context).pushNamed(
// //                                           SubscribeScreen.routeName,
// //                                           arguments: {
// //                                             "itemid": singleitemData.singleitems[0].id,
// //                                             "itemname": singleitemData.singleitems[0].title,
// //                                             "itemimg": singleitemData.singleitems[0].imageUrl,
// //                                             "varname": varname+unit,
// //                                             "varmrp":varmrp,
// //                                             "varprice":  _checkmembership ? varmemberprice :discountDisplay ?varprice:varmrp,
// //                                             "paymentMode": singleitemData.singleitems[0].paymentmode,
// //                                             "cronTime": singleitemData.singleitems[0].cronTime,
// //                                             "name": singleitemData.singleitems[0].name,
// //                                             "varid": varid.toString(),
// //                                             "brand": singleitemData.singleitems[0].brand
// //                                           }
// //                                       );
// //                                     }
// //                                   },
// //                                   child: Container(
// //                                     height: 30.0,
// //                                     width: (MediaQuery.of(context)
// //                                         .size.width / 3) +25,
// //                                     decoration: new BoxDecoration(
// //                                         color: ColorCodes.whiteColor,
// //                                         border: Border.all(color: Theme
// //                                             .of(context)
// //                                             .primaryColor),
// //                                         borderRadius: new BorderRadius.only(
// //                                           topLeft: const Radius.circular(2.0),
// //                                           topRight:
// //                                           const Radius.circular(2.0),
// //                                           bottomLeft:
// //                                           const Radius.circular(2.0),
// //                                           bottomRight:
// //                                           const Radius.circular(2.0),
// //                                         )),
// //                                     child: Row(
// //                                       mainAxisAlignment: MainAxisAlignment.center,
// //                                       crossAxisAlignment: CrossAxisAlignment.center,
// //                                       children: [
// //
// //                                         Text(
// //                                           S .current.subscribe,
// //                                           style: TextStyle(
// //                                               color: Theme.of(context)
// //                                                   .primaryColor,
// //                                               fontSize: 12, fontWeight: FontWeight.bold),
// //                                           textAlign: TextAlign.center,
// //                                         ),
// //                                       ],
// //                                     ) ,
// //                                   ),
// //                                 ),
// //                               ):
// //                               SizedBox(height: 30,)
// //                                   :
// //                               SizedBox(height: 30,):SizedBox.shrink(),
// //                             ],
// //                           ),
//                           !_checkmembership
//                               ? memberpriceDisplay
//                               ? SizedBox(
//                             height: 10,
//                           )
//                               : SizedBox(
//                             height: 1,
//                           )
//                               : SizedBox(
//                             height: 1,
//                           ),
//                           if(Features.isMembership)
//                             Row(
//                               children: [
//                                 !_checkmembership
//                                     ? memberpriceDisplay
//                                     ? GestureDetector(
//                                   onTap: () {
//                                     (checkskip &&_isWeb && !ResponsiveLayout.isSmallScreen(context))?
//                                    // _dialogforSignIn()
//                                     LoginWeb(context,result: (sucsess){
//                                       if(sucsess){
//                                         Navigator.of(context).pop();
//                                         Navigator.pushNamedAndRemoveUntil(
//                                             context, HomeScreen.routeName, (route) => false);
//                                       }else{
//                                         Navigator.of(context).pop();
//                                       }
//                                     })
//                                         :
//                                     (checkskip && !_isWeb)?
//                                     Navigator.of(context).pushReplacementNamed(
//                                         SignupSelectionScreen.routeName)
//                                         :/*Navigator.of(context).pushNamed(
//                                       MembershipScreen.routeName,
//                                     );*/
//                                     Navigation(context, name: Routename.Membership, navigatore: NavigatoreTyp.Push);
//                                   },
//                                   child: Container(
//                                     height: 35,
//                                     width: (MediaQuery.of(context)
//                                         .size
//                                         .width) -
//                                         20,
//                                     decoration: BoxDecoration(
//                                         color: ColorCodes.fill),
//                                     child: Row(
// //                        mainAxisAlignment: MainAxisAlignment.center,
//                                       children: <Widget>[
//                                         SizedBox(width: 10),
//                                         Image.asset(
//                                           Images.starImg,
//                                           height: 12,
//                                         ),
//                                         SizedBox(width: 4),
//                                         // Text(S .current.membership_price+":"+" ",
//                                         //     style: TextStyle(
//                                         //         fontSize: 12.0)),
//                                         Text(
//                                           Features.iscurrencyformatalign?
//                                           varmemberprice + IConstants.currencyFormat:
//                                             IConstants.currencyFormat +
//                                             varmemberprice,
//                                             style: TextStyle(
//                                                 color: Theme.of(
//                                                     context)
//                                                     .primaryColor,
//                                                 fontSize: 12.0,
//                                                 )),
//                                         Spacer(),
//                                         Icon(
//                                           Icons.lock,
//                                           color: Colors.black,
//                                           size: 12,
//                                         ),
//                                         SizedBox(width: 2),
//                                         Icon(
//                                           Icons
//                                               .arrow_forward_ios_sharp,
//                                           color: Colors.black,
//                                           size: 12,
//                                         ),
//                                         SizedBox(width: 10),
//                                       ],
//                                     ),
//                                   ),
//                                 )
//                                     : SizedBox.shrink()
//                                     : SizedBox.shrink(),
//                               ],
//                             ),
//                           SizedBox(
//                             height: 20.0,
//                           ),
//                           Text(
//                             S .current.pack_size,
//                             style: TextStyle(
//                               fontSize: 14,
//                             ),
//                           ),
//                           SizedBox(
//                             height: 10.0,
//                           ),
//                           new ListView.builder(
//                             shrinkWrap: true,
//                             physics: NeverScrollableScrollPhysics(),
//                             itemCount: singleitemvar.length,
//                             itemBuilder: (_, i) => VarintWidget(
//                               onTap:(){
//                                 if(Features.btobModule){
//
//                                    // setState(() async {
//
//                                       var varIdold = varid;
//                                       var varminitemold = varminitem;
//                                       var varpriceold = varprice;
//                                       var varmemberpriceold = varmemberprice;
//                                       if (int.parse(singleitemvar[i].varstock!) > 0) {
//                                         for (int k = 0; k <
//                                             singleitemvar.length; k++) {
//
//                                           if (i == k) {
//                                             singleitemvar[k].varcolor =
//                                                 ColorCodes.darkthemeColor;
//                                           } else {
//                                             singleitemvar[k].varcolor =
//                                                 ColorCodes.lightgrey;
//                                           }
//                                           setState(() {
//                                             if(_groupValue != i)
//                                               _groupValue = i;
//                                             varmemberprice =
//                                                 singleitemvar[i].varmemberprice!;
//                                             varmrp = singleitemvar[i].varmrp!;
//                                             varprice = singleitemvar[i].varprice!;
//                                             varid = singleitemvar[i].varid!;
//                                             varname = singleitemvar[i].varname!;
//                                             unit = singleitemvar[i].unit!;
//                                             varstock = singleitemvar[i].varstock!;
//                                             varminitem = singleitemvar[i].varminitem!;
//                                             varmaxitem = singleitemvar[i].varmaxitem!;
//                                             varLoyalty = singleitemvar[i].varLoyalty!;
//                                             _varQty = singleitemvar[i].varQty;
//                                             varcolor = singleitemvar[i].varcolor!;
//                                             discountDisplay =
//                                                 singleitemvar[i].discountDisplay!;
//                                             memberpriceDisplay =
//                                                 singleitemvar[i].membershipDisplay!;
//
//                                             /*if (varmemberprice == '-' || varmemberprice == "0") {
//                                       setState(() {
//                                         membershipdisplay = false;
//                                       });
//                                     } else {
//                                       membershipdisplay = true;
//                                     }*/
//
//                                             if (_checkmembership) {
//                                               if (varmemberprice.toString() == '-' ||
//                                                   double.parse(varmemberprice) <= 0) {
//                                                 if (double.parse(varmrp) <= 0 ||
//                                                     double.parse(varprice) <= 0) {
//                                                   margins = "0";
//                                                 } else {
//                                                   var difference = (double.parse(
//                                                       varmrp) -
//                                                       double.parse(varprice));
//                                                   var profit = difference /
//                                                       double.parse(varmrp);
//                                                   margins = profit * 100;
//
//                                                   //discount price rounding
//                                                   margins = num.parse(
//                                                       margins.toStringAsFixed(0));
//                                                   margins = margins.toString();
//                                                 }
//                                               } else {
//                                                 var difference = (double.parse(
//                                                     varmrp) -
//                                                     double.parse(varmemberprice));
//                                                 var profit = difference /
//                                                     double.parse(varmrp);
//                                                 margins = profit * 100;
//
//                                                 //discount price rounding
//                                                 margins = num.parse(
//                                                     margins.toStringAsFixed(0));
//                                                 margins = margins.toString();
//                                               }
//                                             } else {
//                                               if (double.parse(varmrp) <= 0 ||
//                                                   double.parse(varprice) <= 0) {
//                                                 margins = "0";
//                                               } else {
//                                                 var difference = (double.parse(
//                                                     varmrp) - double.parse(varprice));
//                                                 var profit = difference /
//                                                     double.parse(varmrp);
//                                                 margins = profit * 100;
//
//                                                 //discount price rounding
//                                                 margins = num.parse(
//                                                     margins.toStringAsFixed(0));
//                                                 margins = margins.toString();
//                                               }
//                                             }
//
//                                             if (margins == "NaN") {
//                                               _checkmargin = false;
//                                             } else {
//                                               if (int.parse(margins) <= 0) {
//                                                 _checkmargin = false;
//                                               } else {
//                                                 _checkmargin = true;
//                                               }
//                                             }
//                                             multiimage = Provider.of<ItemsList>(
//                                                 context, listen: false).findByIdmulti(
//                                                 varid);
//                                             _displayimg = multiimage[0].imageUrl;
//                                             for (int j = 0; j <
//                                                 multiimage.length; j++) {
//                                               if (j == 0) {
//                                                 multiimage[j].varcolor =
//                                                     ColorCodes.primaryColor;
//                                               } else {
//                                                 multiimage[j].varcolor =
//                                                     ColorCodes.lightgrey;
//                                               }
//                                             }
//                                           });
//                                         }
//                                         setState(() {
//                                           if (int.parse(varstock) <= 0) {
//                                             _isStock = false;
//                                           } else {
//                                             _isStock = true;
//                                           }
//                                         });
//
//
//                                         setState(() {
//                                           _isAddToCart = true;
//                                         });
//                                         /*for (int i = 0; i < productBox.values.length; i++) {
//                                           if (productBox.values
//                                               .elementAt(i)
//                                               .varId == int.parse(varid)) {
//                                             productBox.deleteAt(i);
//                                             final s = await Provider.of<CartItems>(
//                                                 context, listen: false).updateCart(
//                                                 varIdold, "0", varpriceold).then((_) async {
//                                               setState(() {
//                                                 //_isAddToCart = true;
//                                                 _varQty =
//                                                     int.parse(
//                                                         singleitemvar[i].varminitem);
//                                               });
//                                             });
//                                             break;
//                                           }
//                                         }*/
//                                         final box = (VxState.store as GroceStore).CartItemList.where((element) => element.varId==varid);
//                                         /*if(int.parse((VxState.store as GroceStore).CartItemList.where((element) {
//                                           return element.varId==varid;
//                                           orElse: () => print('No matching element.');
//                                         }).first.quantity) > 0) {*/
//                                           (VxState.store as GroceStore).CartItemList.removeWhere((element) => element.varId==varid);
//                                           cartcontroller.update((done) {
//                                             setState(() {
//                                               _isAddToCart = !done;
//                                               _varQty =
//                                                   int.parse(
//                                                       singleitemvar[i].varminitem!);
//                                             });
//                                           }, quantity: (/*int.parse(
//                                               (VxState.store as GroceStore)
//                                                   .CartItemList
//                                                   .where((element) =>
//                                               element.varId == varid)
//                                                   .first
//                                                   .quantity)*/_varQty).toString(),
//                                               var_id: varIdold,
//                                               price: memberpriceDisplay
//                                                   ? varmemberpriceold
//                                                   : varpriceold);
//                                        // }
//
//
//
//                                        /* if(int.parse((VxState.store as GroceStore).CartItemList.where((element) => element.varId==varid).first.quantity) >  int.parse((VxState.store as GroceStore).CartItemList.where((element) => element.varId==varid).first.varMinItem)) {
//                                           (VxState.store as GroceStore).CartItemList.removeWhere((element) => element.varId==varIdold);
//
//                                           cartcontroller.addtoCart( PriceVariation(id: varid,variationName: varname,unit:unit,minItem: singleitemvar[i].varminitem,maxItem: varmaxitem,loyalty: 0,stock: int.parse(varstock),status: "",mrp: varmrp,price: varprice,membershipPrice: varmemberprice,membershipDisplay: memberpriceDisplay,images: [ImageDate(image:itemimg)]),ItemData(id: itemid,itemName: itemname,type: type,deliveryDuration: DeliveryDurationData(),delivery: delivery), (onload) {
//                                             setState(() {
//                                               _isAddToCart = onload;
//                                               _varQty =
//                                                   int.parse(
//                                                       singleitemvar[i].varminitem);
//                                             });
//                                           });
//                                         }
//                                         else{
//                                           (VxState.store as GroceStore).CartItemList.removeWhere((element) => element.varId==varIdold);
//                                           cartcontroller.update((done) {
//                                             setState(() {
//                                               _isAddToCart = !done;
//                                               _varQty =
//                                                   int.parse(
//                                                       singleitemvar[i].varminitem);
//                                             });
//                                           }, quantity: (int.parse(
//                                               (VxState.store as GroceStore)
//                                                   .CartItemList
//                                                   .where((element) =>
//                                               element.varId == varid)
//                                                   .first
//                                                   .quantity) - 1).toString(),
//                                               var_id: varIdold,
//                                               price: memberpriceDisplay
//                                                   ? varmemberpriceold
//                                                   : varpriceold);
//                                         }*/
//
//                                       }
//                                       else {
//                                         //if (int.parse(varstock) <= 0) {
//                                         Fluttertoast.showToast(
//                                             msg: S .current.sorry_outofstock,
//                                             fontSize: MediaQuery
//                                                 .of(context)
//                                                 .textScaleFactor * 13,
//                                             backgroundColor: Colors.black87,
//                                             textColor: Colors.white);
//                                         // }
//                                       }
//                                    // });
//                                 }
//                                 else {
//                                   if (int.parse(singleitemvar[i].varstock!) >
//                                       0) {
//                                     for (int k = 0; k <
//                                         singleitemvar.length; k++) {
//                                       if (i == k) {
//                                         singleitemvar[k].varcolor =
//                                             ColorCodes.darkthemeColor;
//                                       } else {
//                                         singleitemvar[k].varcolor =
//                                             ColorCodes.lightgrey;
//                                       }
//                                       setState(() {
//                                         varmemberprice =
//                                             singleitemvar[i].varmemberprice!;
//                                         varmrp = singleitemvar[i].varmrp!;
//                                         varprice = singleitemvar[i].varprice!;
//                                         varid = singleitemvar[i].varid!;
//                                         varname = singleitemvar[i].varname!;
//                                         unit = singleitemvar[i].unit!;
//                                         weight = singleitemvar[i].weight!;
//                                         netWeight = singleitemvar[i].netWeight!;
//                                         varstock = singleitemvar[i].varstock!;
//                                         varminitem =
//                                             singleitemvar[i].varminitem!;
//                                         varmaxitem =
//                                             singleitemvar[i].varmaxitem!;
//                                         varLoyalty =
//                                             singleitemvar[i].varLoyalty!;
//                                         _varQty = singleitemvar[i].varQty;
//                                         varcolor = singleitemvar[i].varcolor!;
//                                         discountDisplay =
//                                             singleitemvar[i].discountDisplay!;
//                                         memberpriceDisplay =
//                                             singleitemvar[i].membershipDisplay!;
//
//                                         /*if (varmemberprice == '-' || varmemberprice == "0") {
//                                       setState(() {
//                                         membershipdisplay = false;
//                                       });
//                                     } else {
//                                       membershipdisplay = true;
//                                     }*/
//
//                                         if (_checkmembership) {
//                                           if (varmemberprice.toString() ==
//                                               '-' ||
//                                               double.parse(varmemberprice) <=
//                                                   0) {
//                                             if (double.parse(varmrp) <= 0 ||
//                                                 double.parse(varprice) <= 0) {
//                                               margins = "0";
//                                             } else {
//                                               var difference = (double.parse(
//                                                   varmrp) -
//                                                   double.parse(varprice));
//                                               var profit = difference /
//                                                   double.parse(varmrp);
//                                               margins = profit * 100;
//
//                                               //discount price rounding
//                                               margins = num.parse(
//                                                   margins.toStringAsFixed(0));
//                                               margins = margins.toString();
//                                             }
//                                           } else {
//                                             var difference = (double.parse(
//                                                 varmrp) -
//                                                 double.parse(varmemberprice));
//                                             var profit = difference /
//                                                 double.parse(varmrp);
//                                             margins = profit * 100;
//
//                                             //discount price rounding
//                                             margins = num.parse(
//                                                 margins.toStringAsFixed(0));
//                                             margins = margins.toString();
//                                           }
//                                         } else {
//                                           if (double.parse(varmrp) <= 0 ||
//                                               double.parse(varprice) <= 0) {
//                                             margins = "0";
//                                           } else {
//                                             var difference = (double.parse(
//                                                 varmrp) -
//                                                 double.parse(varprice));
//                                             var profit = difference /
//                                                 double.parse(varmrp);
//                                             margins = profit * 100;
//
//                                             //discount price rounding
//                                             margins = num.parse(
//                                                 margins.toStringAsFixed(0));
//                                             margins = margins.toString();
//                                           }
//                                         }
//
//                                         if (margins == "NaN") {
//                                           _checkmargin = false;
//                                         } else {
//                                           if (int.parse(margins) <= 0) {
//                                             _checkmargin = false;
//                                           } else {
//                                             _checkmargin = true;
//                                           }
//                                         }
//                                         multiimage = Provider.of<ItemsList>(
//                                             context, listen: false)
//                                             .findByIdmulti(varid);
//                                         _displayimg = multiimage[0].imageUrl;
//                                         for (int j = 0; j <
//                                             multiimage.length; j++) {
//                                           if (j == 0) {
//                                             multiimage[j].varcolor =
//                                                 ColorCodes.primaryColor;
//                                           } else {
//                                             multiimage[j].varcolor =
//                                                 ColorCodes.lightgrey;
//                                           }
//                                         }
//                                       });
//                                     }
//                                     setState(() {
//                                       if (int.parse(varstock) <= 0) {
//                                         _isStock = false;
//                                       } else {
//                                         _isStock = true;
//                                       }
//                                     });
//                                   }
//                                   else {
//                                     //if (int.parse(varstock) <= 0) {
//                                     Fluttertoast.showToast(
//                                         msg: S .current.sorry_outofstock,
//                                         fontSize: MediaQuery
//                                             .of(context)
//                                             .textScaleFactor * 13,
//                                         backgroundColor: Colors.black87,
//                                         textColor: Colors.white);
//                                     // }
//                                   }
//                                 }
//                             },
//                               i: i,groupvalue:_groupValue,singleitemvar: singleitemvar,varid: varid,checkmargin: _checkmargin,varMarginList: _varMarginList, checkmembership: _checkmembership,discountDisplay: discountDisplay,memberpriceDisplay: memberpriceDisplay,
//                             ),
//                           ),
//                           SizedBox(
//                             height: 10.0,
//                           ),
//                           /*  Divider(
//                             thickness: 1.0,
//                           ),*/
//                           if (_isdescription || _ismanufacturer)
//                             Padding(
//                               padding: const EdgeInsets.all(1.0),
//                               child: new Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: <Widget>[
//                                   new Container(
//                                     child: new TabBar(
//                                         controller: _tabController,
//                                         labelColor: Colors.black,
//                                         indicatorColor: Colors.black,
//                                         indicatorSize:
//                                         TabBarIndicatorSize.tab,
//                                         labelPadding: EdgeInsets.only(right: 30,left: 0),
//                                         tabs: tabList),
//                                   ),
//                                   Container(
//                                     height: 160,
//                                     padding: EdgeInsets.all(8),
//                                     child: new TabBarView(
//                                       controller: _tabController,
//                                       children: [...tabList.map((Tab tab) {
//                                         return _getPage(tab);
//                                       }).toList()],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           SizedBox(
//                             height: 5.0,
//                           ),
//                           Row(
//                             children: [
//                               SizedBox(width: 10),
//                               /*  GestureDetector(
//                                 behavior: HitTestBehavior.opaque,
//                                 onTap: () {
//                                   final shoplistData =
//                                   Provider.of<BrandItemsList>(context,
//                                       listen: false);
//
//                                   if (shoplistData.itemsshoplist.length <=
//                                       0) {
//                                     _dialogforCreatelistTwo(
//                                         context, shoplistData);
//                                     //_dialogforShoppinglist(context);
//                                   } else {
//                                     _dialogforShoppinglistTwo(context);
//                                   }
//                                 },
//                                 child: Row(
//                                   children: [
//                                     Icon(
//                                       Icons.list_alt_outlined,
//                                       color: Colors.grey,
//                                     ),
//                                     SizedBox(width: 5),
//                                     Text("ADD TO LIST"),
//                                   ],
//                                 ),
//                               ),*/
//                               //     child: Icon(
//                               //       Icons.list_alt_outlined,
//                               //       color: Colors.grey,
//                               //     )),
//                               // SizedBox(width: 5),
//                               // Text("ADD TO LIST"),
//                              /* Spacer(),
//                               if(Features.isShare)
//                                 GestureDetector(
//                                     onTap: () {
//                                       Navigator.of(context).pop();
//                                       if (_isIOS) {
//                                         Share.share(S .current.download_app+
//                                             IConstants.APP_NAME +
//                                             '${S .current.from_app_store} https://apps.apple.com/us/app/id' + IConstants.appleId);
//                                       } else {
//                                         Share.share(S .current.download_app +
//                                             IConstants.APP_NAME +
//                                             '${S .current.from_google_play_store} https://play.google.com/store/apps/details?id=' + IConstants.androidId);
//                                       }
//                                     },
//                                     child: Icon(
//                                       Icons.share_outlined,
//                                       color: Colors.grey,
//                                     )),
//                               if(Features.isShare) SizedBox(width: 5),
//                               if(Features.isShare) Text(S .current.share),
//                               SizedBox(width: 10),*/
//                             ],
//                           ),
//                           SizedBox(
//                             height: 20.0,
//                           ),
//                           /*     Divider(
//                             thickness: 5,
//                           ),*/
//                           _similarProduct
//                               ? Container(
//                             child: Column(
//                               children: <Widget>[
//                                 new Row(
//                                   children: <Widget>[
//                                     SizedBox(
//                                       width: 5.0,
//                                     ),
//                                     Text(
//                                       sellingitemData.newitemname,
//                                       style: TextStyle(
//                                           fontSize: 20.0,
//                                           color: Theme.of(context)
//                                               .primaryColor,
//                                           fontWeight:
//                                           FontWeight.bold),
//                                     ),
//                                     Spacer(),
//                                     SizedBox(
//                                       width: 10,
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 10.0),
//                                 FutureBuilder<ItemModle>(
//                                   key: _key,
//                                   future: _preduct, // async work
//                                   builder: (BuildContext context, AsyncSnapshot<ItemModle> snapshot) {
//                                     switch (snapshot.connectionState) {
//
//                                       case ConnectionState.waiting:
//                                         return SingelItemOfList();
//                                         // TODO: Handle this case.
//                                         break;
//                                       default:
//                                       // TODO: Handle this case.
//                                         if (snapshot.hasError)
//                                           return SizedBox.shrink();
//                                         else
//                                           return Container(
//                                             width: (Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.40:MediaQuery.of(context).size.width,
//                                             //padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
//                                             padding: EdgeInsets.only(top: 15.0, bottom: 10.0,left:(Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))?20:0,right: (Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))?20:0 ),
//                                             color: /*Color(0xFFFFE8E8).withOpacity(0.7)*/ColorCodes.whiteColor,
//                                             child: Column(
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               children: <Widget>[
//                                                 SizedBox(
//                                                     height: ResponsiveLayout.isSmallScreen(context) ?
//                                                     (Features.isSubscription)?392:310 :
//                                                     ResponsiveLayout.isMediumScreen(context) ?
//                                                     (Features.isSubscription)?350:360 : (Features.isSubscription)?380:380,
//
//                                                     // height: (Vx.isWeb)?380:360,
//                                                     child: new ListView.builder(
//                                                       shrinkWrap: true,
//                                                       scrollDirection: Axis.horizontal,
//                                                       itemCount: snapshot.data!.data!.length,
//                                                       itemBuilder: (_, i) => Column(
//                                                         children: [
//                                                           Itemsv2(
//                                                             "Forget",
//                                                             snapshot.data!.data![i],
//                                                             (VxState.store as GroceStore).userData,
//                                                             //sellingitemData.items[i].brand,
//                                                           ),  /* Itemsv2(
//                                                             "Forget",
//                                                             snapshot.data.data[i],
//                                                             (VxState.store as GroceStore).userData,
//                                                             //sellingitemData.items[i].brand,
//                                                           ),*/
//                                                         ],
//                                                       ),
//                                                     )),
//                                               ],
//                                             ),
//                                           );
//                                         break;
//                                     }
//                                   },
//                                 ),
//                               ],
//                             ),
//                           )
//                               : Container(),
//                         ],
//                       ),
//                     ),
//                     // footer comes here
//                     if(_isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//
//     Widget mainBody() {
//       if (ResponsiveLayout.isSmallScreen(context)) {
//         return mobileBody();
//       } else {
//         return webBody();
//       }
//     }
//
//     return Scaffold(
//       appBar: ResponsiveLayout.isSmallScreen(context) ?
//       AppBarMobile(routeArgs,sellingitemData) : null,
//       backgroundColor: Colors.white,
//       body:WillPopScope(
//           onWillPop: () async{
//             final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//            var title;
//            if(seeallpress=="featured"){
//              title =(VxState.store as GroceStore).homescreen.data!.featuredByCart!.label;
//            }else if(seeallpress=="offers"){
//              title =(VxState.store as GroceStore).homescreen.data!.offerByCart!.label;
//            }else if(seeallpress=="discount"){
//              title =(VxState.store as GroceStore).homescreen.data!.discountByCart!.label;
//            }
//             switch(fromScreen){
//               case "sellingitem_screen":
//                 Navigator.of(context)
//                   .pushReplacementNamed(SellingitemScreen.routeName, arguments: {
//                 'seeallpress': seeallpress,
//                 'title': title,
//               });
//                 return false;
//                 break;
//               case "not_product_screen":
//                 final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//                 Navigator.of(context).pushReplacementNamed(
//                     BannerProductScreen.routeName,
//                     arguments: {
//                       "id" : routeArgs['notid'],
//                       'type': seeallpress
//                     }
//                 );
//                 break;
//               case "item_screen":
//                 if(seeallpress == "category") {
//                   Navigator.of(context).pushReplacementNamed(
//                       BannerProductScreen.routeName,
//                       arguments: {
//                         "id" : routeArgs['notid'],
//                         'type': seeallpress
//                       }
//                   );
//                 }else{
//                  /* Navigator.of(context).pushReplacementNamed(
//                       ItemsScreen.routeName, arguments: {
//                     'maincategory': routeArgs['maincategory'],
//                     'catId': routeArgs['catId'],
//                     'catTitle': routeArgs['catTitle'],
//                     'subcatId': routeArgs['subcatId'],
//                     'indexvalue': routeArgs['indexvalue'],
//                     'prev': routeArgs['prev'],
//                   });*/
//
//                   Navigation(context, name: Routename.ItemScreen, navigatore: NavigatoreTyp.PushReplacment,
//                       parms: {
//                         'maincategory': routeArgs['maincategory'],
//                         'catId': routeArgs['catId'],
//                         'catTitle': routeArgs['catTitle'],
//                         'subcatId': routeArgs['subcatId'],
//                         'indexvalue': routeArgs['indexvalue'],
//                         'prev': routeArgs['prev'],
//                       });
//
//                 }
//                 break;
//               case "search_item" :
//               Navigator.of(context).pop();
//                 break;
//               case "brands_screen":
//             Navigator.of(context).pushReplacementNamed(BrandsScreen.routeName, arguments: {
//             "indexvalue":routeArgs['indexvalue'],
//             "brandId":routeArgs['brandId'],
//             });
//                 break;
//               case "searchitem_screen":
//                 Navigator.of(context).pop();
//                 break;
//               case "sellingitem_screen":
//                 Navigator.of(context).pop();
//
//                 break;
//               case "shoppinglistitem_screen":
//                 break;
//               case "offers" :
//                 Navigator.of(context).popUntil(ModalRoute.withName(
//                     HomeScreen.routeName));
//                 break;
//               case "home_screen" :
//                 Navigator.of(context).pop();
//                 break;
//               case "Discount" :
//                 Navigator.of(context).popUntil(ModalRoute.withName(
//                     HomeScreen.routeName));
//                 break;
//             }
//             return true;
//           },
//           child: mainBody()),
//       bottomNavigationBar:(_isWeb && !ResponsiveLayout.isSmallScreen(context)) ? SizedBox.shrink():
//       Container(
//         color: Colors.white,
//         child: Padding(
//           padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
//           child:_buildBottomNavigationBar(),
//         ),
//       ),
//     );
//   }
//
//   AppBarMobile(Map<String, dynamic> routeArgs, SellingItemsList sellingitemData){
//     return  AppBar(
//       toolbarHeight: 55.0,
//       elevation: (IConstants.isEnterprise)?0:1,
//       automaticallyImplyLeading: false,
//       title: Text(itemname,style: TextStyle(color: ColorCodes.menuColor),),
//       leading: IconButton(
//         icon: Icon(Icons.arrow_back, color:ColorCodes.menuColor),
//         onPressed: () {
//           var title;
//           if(seeallpress=="featured"){
//             title =(VxState.store as GroceStore).homescreen.data!.featuredByCart!.label;
//           }else if(seeallpress=="offers"){
//             title =(VxState.store as GroceStore).homescreen.data!.offerByCart!.label;
//           }else if(seeallpress=="discount"){
//             title =(VxState.store as GroceStore).homescreen.data!.discountByCart!.label;
//           }
//           switch(fromScreen){
//             case "sellingitem_screen":
//               Navigator.of(context)
//                   .pushReplacementNamed(SellingitemScreen.routeName, arguments: {
//                 'seeallpress': seeallpress,
//                 'title': title,
//               });
//             /*  Navigator.of(context).pushReplacementNamed(ItemsScreen.routeName, arguments: {
//                 'maincategory': routeArgs['maincategory'],
//                 'catId':  routeArgs['catId'],
//                 'catTitle':  routeArgs['catTitle'],
//                 'subcatId':  routeArgs['subcatId'],
//                 'indexvalue': routeArgs['indexvalue'],
//                 'prev': routeArgs['prev'],
//               });*/
//
//               break;
//             case "not_product_screen":
//              // Navigator.of(context).pop();
//               final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//               final type = routeArgs['type'];
//               final id = routeArgs['id'].toString();
//               Navigator.of(context).pushReplacementNamed(
//                   BannerProductScreen.routeName,
//                   arguments: {
//                     "id" : routeArgs['notid'],
//                     'type': seeallpress
//                   }
//               );
//               break;
//             case "item_screen":
//               if(seeallpress == "category") {
//                 Navigator.of(context).pushReplacementNamed(
//                     BannerProductScreen.routeName,
//                     arguments: {
//                       "id" : routeArgs['notid'],
//                       'type': seeallpress
//                     }
//                 );
//               }else{
//                 /*Navigator.of(context).pushReplacementNamed(
//                     ItemsScreen.routeName, arguments: {
//                   'maincategory': routeArgs['maincategory'],
//                   'catId': routeArgs['catId'],
//                   'catTitle': routeArgs['catTitle'],
//                   'subcatId': routeArgs['subcatId'],
//                   'indexvalue': routeArgs['indexvalue'],
//                   'prev': routeArgs['prev'],
//                 });*/
//                 Navigation(context, name: Routename.ItemScreen, navigatore: NavigatoreTyp.PushReplacment,
//                     parms: {
//                       'maincategory': routeArgs['maincategory'],
//                       'catId': routeArgs['catId'],
//                       'catTitle': routeArgs['catTitle'],
//                       'subcatId': routeArgs['subcatId'],
//                       'indexvalue': routeArgs['indexvalue'],
//                       'prev': routeArgs['prev'],
//                     });
//               }
//               break;
//             case "brands_screen":
//               Navigator.of(context).pushReplacementNamed(BrandsScreen.routeName, arguments: {
//                 "indexvalue":routeArgs['indexvalue'],
//                 "brandId":routeArgs['brandId'],
//               });
//               break;
//             case "searchitem_screen":
//               Navigator.of(context).pop();
//               break;
//             case "sellingitem_screen":
//               Navigator.of(context)
//                   .pushReplacementNamed(SellingitemScreen.routeName, arguments: {
//                 'seeallpress': seeallpress,
//                 'title': title,
//               });
//               break;
//             case "shoppinglistitem_screen":
//               Navigator.of(context).pop();
//               break;
//             case "home_screen" :
//               Navigator.of(context).pop();
//               break;
//             case "search_item" :
//               // Navigator.of(context).pushNamed(SearchitemScreen.routeName);
//              Navigator.of(context).pop();
//               break;
//             case "featured"  :
//               Navigator.of(context)
//                   .pushReplacementNamed(SellingitemScreen.routeName, arguments: {
//                 'seeallpress': "featured",
//                 'title': (VxState.store as GroceStore).homescreen.data!.featuredByCart!.label
//               });
//               break;
//             case "offers" :
//               Navigator.of(context).pop();
//               break;
//             case "home_screen" :
//               Navigator.of(context).pop();
//               break;
//             case "Discount" :
//               Navigator.of(context).pop();
//               break;
//             case "singleproduct_screen" :
//               Navigator.of(context).pop();
//               break;
//             case "Forget" :
//               Navigator.of(context).pop();
//               break;
//             case "NotificationScreen":
//               Navigator.of(context).pop();
//               break;
//           }
//
//           // Navigator.of(context).pop();
//         },
//       ),
//       actions: [
//         // Container(
//         //   width: 25,
//         //   height: 25,
//         //   margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
//         //   decoration: BoxDecoration(
//         //     borderRadius: BorderRadius.circular(100),
//         //    // color: Colors.white,
//         //   ),
//         //   child: GestureDetector(
//         //     onTap: () {
//         //       Navigator.of(context).pushNamed(
//         //         SearchitemScreen.routeName,
//         //       );
//         //     },
//         //     child: Icon(
//         //       Icons.search,
//         //       size: 20,
//         //       color: Colors.white,
//         //     ),
//         //   ),
//         // ),
//         // SizedBox(
//         //   width: 15,
//         // ),
//         if(Features.isShare)
//           Container(
//             width: 25,
//             height: 25,
//             margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(100),
//              // color: Colors.white,
//             ),
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.of(context).pop();
//                 if (_isIOS) {
//                   Share.share(S .current.download_app +
//                       IConstants.APP_NAME +
//                       '${S .current.from_app_store} https://apps.apple.com/us/app/id' + IConstants.appleId);
//                 } else {
//                   Share.share(S .current.download_app +
//                       IConstants.APP_NAME +
//                       '${S .current.from_google_play_store} https://play.google.com/store/apps/details?id=' + IConstants.androidId);
//                 }
//               },
//               child: Icon(
//                 Icons.share_outlined,
//                 size: 20,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         if(Features.isShare)
//         SizedBox(width: 15,),
//         if(Features.isShoppingList)
//           (PrefUtils.prefs!.containsKey("apikey"))?
//           Container(
//           width: 25,
//           height: 25,
//           margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(100),
//            // color: Colors.white,
//           ),
//           child: GestureDetector(
//             onTap: () {
//               final shoplistData = Provider.of<BrandItemsList>(context, listen: false);
//
//               if (shoplistData.itemsshoplist.length <= 0) {
//                 _dialogforCreatelistTwo(context, shoplistData);
//               } else {
//                 _dialogforShoppinglistTwo(context);
//               }
//             },
//             child: /*Icon(
//               Icons.add,
//               size: 18,
//               color: Theme
//                   .of(context)
//                   .primaryColor,
//             )*/Image.asset(
//               Images.addToListImg,width: 25,height: 25,color: Colors.white),
//           ),
//         ):
//         SizedBox.shrink(),
//         if(Features.isShoppingList)
//         SizedBox(
//           width: 15,
//         ),
//         VxBuilder(
//           mutations: {SetCartItem},
//           // valueListenable: Hive.box<Product>(productBoxName).listenable(),
//           builder: (context,GroceStore store, index) {
//             final box = (VxState.store as GroceStore).CartItemList;
//
//             if (box.isEmpty)
//               return GestureDetector(
//                 onTap: () {
//                    Navigator.of(context).pushNamed(CartScreen.routeName,arguments: {
//                      "after_login": ""
//                    });
//                 },
//                 child: Container(
//                   margin: EdgeInsets.only(top: 15, right: 10, bottom: 15),
//                   width: 28,
//                   height: 28,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(100),
//                      /* color: Theme.of(context).buttonColor*/),
//                   child:   Image.asset(
//                     Images.header_cart,
//                     height: 28,
//                     width: 28,
//                     color: Colors.white,
//                   ),
//                 ),
//               );
//
//
//             return Consumer<CartCalculations>(
//               builder: (_, cart, ch) => Badge(
//                 child: ch!,
//                 color:  ColorCodes.greenColor,
//                 value: CartCalculations.itemCount.toString(),
//               ),
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.of(context).pushNamed(CartScreen.routeName,arguments: {
//                     "after_login": ""
//                   });
//                 },
//                 child: Container(
//                   margin: EdgeInsets.only(top: 15, right: 10, bottom: 15),
//                   width: 28,
//                   height: 28,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(100),
//                      /* color: Theme.of(context).buttonColor*/),
//                   child: Image.asset(
//                     Images.header_cart,
//                     height: 28,
//                     width: 28,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//         SizedBox(width: 10,)
//       ],
//       flexibleSpace: Container(
//         decoration: BoxDecoration(
//             gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: <Color>[
//                   ColorCodes.accentColor,
//                   ColorCodes.primaryColor
//                 ])
//         ),
//       ),
//     );
//   }
// }
