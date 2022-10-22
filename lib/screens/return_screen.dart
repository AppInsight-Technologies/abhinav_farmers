import 'dart:io';
import 'package:velocity_x/velocity_x.dart';

import '../../constants/features.dart';

import '../generated/l10n.dart';

import '../constants/IConstants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../providers/addressitems.dart';
import '../providers/myorderitems.dart';
import '../providers/deliveryslotitems.dart';
import '../assets/ColorCodes.dart';
import '../rought_genrator.dart';
import '../utils/ResponsiveLayout.dart';
import '../widgets/addresswidget/address_info.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../screens/address_screen.dart';
import '../screens/myorder_screen.dart';
import '../assets/images.dart';
import '../utils/prefUtils.dart';

class ReturnScreen extends StatefulWidget {
  static const routeName = '/return-screen';
  Map<String,String> params;
  ReturnScreen(this.params);
  @override
  ReturnScreenState createState() => ReturnScreenState();
}

class ReturnScreenState extends State<ReturnScreen> with Navigations{
  int _groupValue = 0;
  var _checkaddress = false;
  List popupItems = [];
  var addressitemsData;
  var deliveryslotData;
  var addtype;
  var address;
   IconData? addressicon;
  var _checkslots = false;
  var date, qty;
  var orderitemData;
  bool _isLoading = true;
  var box_color = ColorCodes.lightColor;
  bool _isWeb = false;
   MediaQueryData? queryData;
  bool _selectitem = false;
   double? wid;
   double? maxwid;
  bool w = true;
  bool x = false;
  bool y = false;
  bool z = false;
  var note = TextEditingController();
  bool _showCheck=false;
  var returntime=0;


  @override
  void initState() {
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
    note.text = "";
    Future.delayed(Duration.zero, () async {
      //prefs = await SharedPreferences.getInstance();

      final routeArgs =
          ModalRoute.of(context)!.settings.arguments as Map<String, String>;

      final orderid = widget.params['orderid'];
      final title = widget.params['title'];


      await Provider.of<AddressItemsList>(context,listen: false).fetchAddress().then((_) {
        addressitemsData = Provider.of<AddressItemsList>(context, listen: false);
      });
      Provider.of<MyorderList>(context,listen: false).Vieworders(orderid!).then((_) {
        setState(() {
          orderitemData = Provider.of<MyorderList>(
            context,
            listen: false,
          );
          for(int i=0;i<orderitemData.vieworder1.length;i++){
            if (orderitemData.vieworder1[i].deliveryOn != "") {
              DateTime today = new DateTime.now();
              DateTime orderAdd = DateTime.parse(
                  orderitemData.vieworder1[i].deliveryOn).add(Duration(
                  hours: int.parse(orderitemData.vieworder1[i].returnTime)));
              if ((orderAdd.isAtSameMomentAs(today) || orderAdd.isAfter(today)) &&
                  (orderitemData.vieworder[0].ostatus.toLowerCase() ==
                      "delivered" ||
                      orderitemData.vieworder[0].ostatus.toLowerCase() ==
                          "completed")) {
                if (orderitemData.vieworder1[i].returnTime != "")
                  setState(() {
                    _showCheck = true;
                  });
                if (orderitemData.vieworder1[i].returnTime == "0" ) {
                  setState(() {
                    _showCheck = false;
                  });
                } else {
                  setState(() {
                    _showCheck = false;
                  });
                }
              }
            }
          }
         /*
        //  returntime= orderitemData.vieworder1[0].returnTime;
        // int deliverytime=int.parse(orderitemData.vieworder1[0].deliveryOn);
        //  int del=int.parse(orderitemData.vieworder1[0].deliveryOn);
          DateTime today = new DateTime.now();
         // DateTime orderdate=orderitemData.vieworder1[0].deliveryOn;
          DateTime orderplustime =DateTime.parse(orderitemData.vieworder1[0].deliveryOn).add(Duration(hours:int.parse (orderitemData.vieworder1[0].returnTime)));
         DateTime fourtyDaysAgo =today.add(Duration(hours: 7));
          DateTime fiftyDaysAgo = today.subtract(new Duration(hours: 18));
          */
          _isLoading = false;
        });
      });

      setState(() {
//        PrefUtils.prefs!.setString("returning_reason", "");
        PrefUtils.prefs!.setString("returning_reason", "Quality not adequate");
      });
      addressitemsData = Provider.of<AddressItemsList>(context, listen: false);
      if (addressitemsData.items.length > 0) {
        _checkaddress = true;
        PrefUtils.prefs!.setString("addressId",
            addressitemsData.items[addressitemsData.items.length - 1].userid);
        addtype = addressitemsData
            .items[addressitemsData.items.length - 1].useraddtype;
        address = addressitemsData
            .items[addressitemsData.items.length - 1].useraddress;
        addressicon = addressitemsData
            .items[addressitemsData.items.length - 1].addressicon;
        calldeliverslots("1");
      } else {
        _checkaddress = false;
      }

    });
    super.initState();
  }

  Future<void> calldeliverslots(String addressid) async {
    Provider.of<DeliveryslotitemsList>(context,listen: false)
        .fetchDeliveryslots(PrefUtils.prefs!.getString("addressId")!)
        .then((_) {
      deliveryslotData =
          Provider.of<DeliveryslotitemsList>(context, listen: false);
      if (deliveryslotData.items.length <= 0) {

        setState(() {
          _isLoading = false;
          _checkslots = false;
        });

      } else {
        setState(() {
          _isLoading = false;
          _checkslots = true;
          date = deliveryslotData.items[0].dateformat;
          PrefUtils.prefs!.setString("fixdate", date);
        });

      }
    });
  }

  Widget _myRadioButton({ String? title,  int? value,  Function(int?)? onChanged}) {
    return RadioListTile<int>(
      controlAffinity: ListTileControlAffinity.trailing,
      value: value!,
      groupValue: _groupValue,
      onChanged: onChanged!,
      title: Text(title!),
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
    ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    final orderid = widget.params['orderid'];
    final title = widget.params['title'];

    final itemLeftCount = widget.params['itemLeftCount'];

    void _settingModalBottomSheet(context) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return SingleChildScrollView(
              child: Container(
                child: new Wrap(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50.0,
                      color: ColorCodes.lightColor,
                      child: Column(
                        children: <Widget>[
                          Spacer(),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 20.0,
                              ),
                              Text(
                                S .of(context).choose_pickup_address,//"Choose a pickup address",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      child: new ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: addressitemsData.items.length,
                        itemBuilder: (_, i) => Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isLoading = true;
                                  PrefUtils.prefs!.setString("addressId",
                                      addressitemsData.items[i].userid);
                                  addtype =
                                      addressitemsData.items[i].useraddtype;
                                  address =
                                      addressitemsData.items[i].useraddress;
                                  addressicon =
                                      addressitemsData.items[i].addressicon;
                                  calldeliverslots(
                                      addressitemsData.items[i].userid);
                                });

                               Navigator.of(context).pop();


                               /* Navigator.of(context).pushReplacementNamed(ReturnScreen.routeName, arguments: {
                                  'orderid': routeArgs['orderid'],
                                  'title':routeArgs['title'],
                                });*/

                              },
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Icon(addressitemsData.items[i].addressicon),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                        Text(
                                          addressitemsData.items[i].useraddtype,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          addressitemsData.items[i].useraddress,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Divider(
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 20.0),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //Divider(color: Colors.black,),
                    GestureDetector(
                      onTap: () {
                        PrefUtils.prefs!.setString("formapscreen", "returnscreen");
                      /*  Navigator.of(context)
                            .pushNamed(AddressScreen.routeName, arguments: {
                          'addresstype': "new",
                          'addressid': "",
                          'delieveryLocation': "",
                          'orderid': widget.params['orderid'],
                          'title':widget.params['title'],
                        });*/
            if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
            // _dialogforaddress(context);
            AddressWeb(context,
              addresstype: "new",
              addressid: "",
              delieveryLocation: "",
              orderid: widget.params['orderid'],
              title : widget.params['title'],);
            }
            else {
              Navigation(context, name: Routename.AddressScreen,
                  navigatore: NavigatoreTyp.Push,
                  qparms: {
                    'addresstype': "new",
                    'addressid': "",
                    'delieveryLocation': "",
                    'orderid': widget.params['orderid'],
                    'title': widget.params['title'],
                  });
            }
                      },
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10.0,
                          ),
                          Icon(
                            Icons.add,
                            color: Colors.orange,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 15.0,
                                ),
                                Text(
                                  S .of(context).add_new_address,//"Add new Address",
                                  style: TextStyle(
                                      color: Colors.orange, fontSize: 16.0),
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
            );
          });
    }

    _dialogforReturning(BuildContext context) {
      queryData = MediaQuery.of(context);
      wid= queryData!.size.width;
      maxwid=wid!*0.90;
      return showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.0)),
                child: Container(
                    height: 100.0,
                    width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        SizedBox(
                          width: 40.0,
                        ),
                        Text( S .of(context).processing,//'Processing...'
                        ),
                      ],
                    )),
              );
            });
          });
    }

    gradientappbarmobile() {
      return AppBar(
        brightness: Brightness.dark,
        toolbarHeight: 60.0,
          elevation: (IConstants.isEnterprise)?0:1,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color:ColorCodes.iconColor),
            onPressed: () => Navigator.of(context).pop()),
        title: Text(
          title!,
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
                  ])),
        ),
      );
    }
    Widget _bodyWeb(){

       Widget itemsExchange() {
      return Container(
        child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width - 20,
              alignment: Alignment.centerLeft,
              height: 50,
              child: Text( S .of(context).choose_item_to//"Choose Items to "
                  + title!,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              padding: EdgeInsets.all(10),
              child: new ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: int.parse(orderitemData.vieworder[0].itemsCount),
                  itemBuilder: (_, i) => Column(
                        children: [
                          Row(
                          children: <Widget>[
                            Container(
                                child: CachedNetworkImage(
                              imageUrl: orderitemData.vieworder1[i].itemImage,
                              placeholder: (context, url) => Image.asset(
                                Images.defaultProductImg,
                                width: 50,
                                height: 50,
                              ),
                                  errorWidget: (context, url, error) => Image.asset(
                                    Images.defaultProductImg,
                                    width: 50,
                                    height: 50,
                                  ),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width *0.30,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                          orderitemData
                                                  .vieworder1[i].itemname +
                                              " , " +
                                              orderitemData
                                                  .vieworder1[i].varname,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(fontSize: 12),
                                        )),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Features.iscurrencyformatalign?
                                  Text(
                                    S .of(context).price//"Price: "
                                         + double.parse(orderitemData.vieworder1[i].price).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + IConstants.currencyFormat,
                                    style: TextStyle(fontSize: 12),
                                  ):
                                  Text(
                                    S .of(context).price//"Price: "
                                        + IConstants.currencyFormat + double.parse(orderitemData.vieworder1[i].price).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Container(
                                    height: 30,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: PopupMenuButton(
                                      onSelected: (selectedValue) {
                                        setState(() {
                                          orderitemData.vieworder1[i]
                                              .qtychange = selectedValue;
//                                                        PrefUtils.prefs!.setString("fixdate", date);
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            S .of(context).qty +//"Qty: " +
                                                orderitemData
                                                    .vieworder1[i].qtychange,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          Icon(
                                            Icons.arrow_drop_down,
                                            size: 12,
                                          ),
                                        ],
                                      ),
                                      /*icon: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text("Qty: " + orderitemData.vieworder1[i].qtychange,style: TextStyle(fontSize: 12),),
                                                      Icon(Icons.arrow_drop_down,size: 12,),
                                                    ],
                                                  ),*/
                                      itemBuilder: (_) =>
                                          <PopupMenuItem<String>>[
                                        for (int j = int.parse(orderitemData
                                                .vieworder1[i].qty);
                                            j >= 1;
                                            j--)
                                          new PopupMenuItem<String>(
                                              child: Text(j.toString()),
                                              value: j.toString()),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            (_showCheck||orderitemData.vieworder1[i].returnTime!= "0")?
                            Checkbox(
                              value: orderitemData.vieworder1[i].checkboxval,
                              onChanged: (value) {
                                setState(() {
                                  orderitemData.vieworder1[i].checkboxval = value;
                                });
                              },
                            ):IconButton(onPressed: (){
                              Fluttertoast.showToast(msg: "$title " +S .of(context).option_expired//option expired for this product"
                              );
                            },
                                icon: Icon(Icons.check_box_outline_blank_sharp,size:22,color: Colors.grey[600],)),
                          ],
                            ),
                          Divider(),
                        ],
                      )),
            ),
//                              SizedBox(height: 10.0,),
          ],
        ),
      );
    }
       Widget proceed() {
      return Column(
        children: [
           Container(
                width: MediaQuery.of(context).size.width - 20,
                    alignment: Alignment.centerLeft,
                      height: 50,
                          child: Text( S .of(context).why_returning,//"Why are you returning this?",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
//                      SizedBox(height: 10.0,),
                        Container(
                          height: MediaQuery.of(context).size.height / 4,
                          decoration: BoxDecoration(
                              color: Theme.of(context).buttonColor),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          PrefUtils.prefs!.setString("returning_reason",
                                              "Quality not adequate");
                                          w = true;
                                          x = false;
                                          y = false;
                                          z = false;
                                        });
                                      },
                                      child: w
                                          ? Container(
                                              padding: EdgeInsets.all(10),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  12,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width*0.20,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                borderRadius:
                                                    new BorderRadius.all(
                                                        new Radius.circular(5.0)),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                S .of(context).qty_not_adequate,//"Quality not adequate",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )
                                          : Container(
                                              padding: EdgeInsets.all(10),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  12,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width*0.20,
                                              decoration: BoxDecoration(
                                                color: box_color,
                                                borderRadius:
                                                    new BorderRadius.all(
                                                        new Radius.circular(5.0)),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text( S .of(context).qty_not_adequate,//"Quality not adequate"
                                              ),
                                            ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                       child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            PrefUtils.prefs!.setString("returning_reason",
                                                "Wrong item was sent");
                                            w = false;
                                            x = true;
                                            y = false;
                                            z = false;
                                          });
                                        },
                                        child: x
                                            ? Container(
                                                padding: EdgeInsets.all(10),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    12,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width*0.20,
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  borderRadius: new BorderRadius
                                                          .all(
                                                      new Radius.circular(5.0)),
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  S .of(context).wrong_item_sent,// "Wrong item was sent",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              )
                                            : Container(
                                                padding: EdgeInsets.all(10),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    12,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width*0.20,
                                                decoration: BoxDecoration(
                                                  color: box_color,
                                                  borderRadius: new BorderRadius
                                                          .all(
                                                      new Radius.circular(5.0)),
                                                ),
                                                alignment: Alignment.center,
                                                child:
                                                    Text( S .of(context).wrong_item_sent,//"Wrong item was sent"
                                                    ),
                                              )),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                     child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          PrefUtils.prefs!.setString("returning_reason",
                                              "Item defective");
                                          w = false;
                                          x = false;
                                          y = true;
                                          z = false;
                                        });
                                      },
                                      child: y
                                          ? Container(
                                              padding: EdgeInsets.all(10),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  12,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *0.20,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                borderRadius:
                                                    new BorderRadius.all(
                                                        new Radius.circular(5.0)),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                S .of(context).item_defective,//"Item defective",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )
                                          : Container(
                                              padding: EdgeInsets.all(10),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  12,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width*0.20,
                                              decoration: BoxDecoration(
                                                color: box_color,
                                                borderRadius:
                                                    new BorderRadius.all(
                                                        new Radius.circular(5.0)),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text( S .of(context).item_defective,//"Item defective"
                                              ),
                                            ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          PrefUtils.prefs!.setString("returning_reason",
                                              "Product damaged");
                                          w = false;
                                          x = false;
                                          y = false;
                                          z = true;
                                        });
                                      },
                                      child: z
                                          ? Container(
                                              padding: EdgeInsets.all(10),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  12,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width*0.20,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                borderRadius:
                                                    new BorderRadius.all(
                                                        new Radius.circular(5.0)),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                S .of(context).product_damaged,//"Product damaged",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )
                                          : Container(
                                              padding: EdgeInsets.all(10),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  12,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width*0.20,
                                              decoration: BoxDecoration(
                                                color: box_color,
                                                borderRadius:
                                                    new BorderRadius.all(
                                                        new Radius.circular(5.0)),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text( S .of(context).product_damaged,//"Product damaged"
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
//                                        Text(PrefUtils.prefs!.getString('returning_reason')),
                            ],
                          ),
                        ),

                        Container(
                            width: MediaQuery.of(context).size.width - 20,
                            height: 50,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              S .of(context).pickup_address,//"Pickup address",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            )),
//                      SizedBox(height: 10.0,),
                        Container(
                          decoration: BoxDecoration(color: Colors.white),
                          child: Column(
                            children: [
                              _checkaddress
                                  ? Container(
                                      height: 80,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(10.0),
                                      color: Colors.white,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
//                            SizedBox(width: 10.0,),
                                          Expanded(
                                              child: Text(
                                            address,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600
                                            ),
                                          )),
                                          MouseRegion(
                                             cursor: SystemMouseCursors.click,
                                               child: GestureDetector(
                                                onTap: () {
                                                  _settingModalBottomSheet(
                                                      context);
                                                },
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      S .of(context).change_caps,//"CHANGE",
                                                      style: TextStyle(
                                                          color: Theme.of(context)
                                                              .primaryColor,
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      "---------",
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontSize: 14.0,
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ),
//                            SizedBox(width: 10.0,),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(10.0),
                                      color: Colors.white,
                                      child: Row(
                                        children: <Widget>[
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          Spacer(),
                                          FlatButton(
                                            color:
                                                Theme.of(context).primaryColor,
                                            textColor:
                                                Theme.of(context).buttonColor,
                                            shape: new RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      3.0),
                                            ),
                                            onPressed: ()  {
                                              PrefUtils.prefs!.setString("addressbook",
                                                  "returnscreen");
                                            /*  Navigator.of(context).pushNamed(
                                                  AddressScreen.routeName,
                                                  arguments: {
                                                    'addresstype': "new",
                                                    'addressid': "",
                                                    'delieveryLocation': "",
                                                    'orderid': widget.params['orderid'],
                                                    'title':widget.params['title'],
                                                  });*/
         if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
         // _dialogforaddress(context);
         AddressWeb(context,
           addresstype: "new",
           addressid: "",
           delieveryLocation: "",
           orderid: widget.params['orderid'],
           title: widget.params['title'],);
         }
         else {
           Navigation(context, name: Routename.AddressScreen,
               navigatore: NavigatoreTyp.Push,
               qparms: {
                 'addresstype': "new",
                 'addressid': "",
                 'delieveryLocation': "",
                 'orderid': widget.params['orderid'],
                 'title': widget.params['title'],
               });
         }
                                            },
                                            child: Text(
                                              S .of(context).add_address,// 'Add Address',
                                              style: TextStyle(fontSize: 12.0),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                        ],
                                      ),
                                    ),
                              Divider(),
                              ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.all(10.0),
                                leading: Image.asset(
                                  Images.shoppinglistsImg,
                                  width: 25.0,
                                  height: 35.0,
                                ),
                                title: Transform(
                                  transform:
                                      Matrix4.translationValues(-16, 0.0, 0.0),
                                  child: TextField(
                                    controller: note,
                                    decoration: InputDecoration.collapsed(
                                        hintText:
                                        S .of(context).any_store_request,//"Any store request? We will try our best to co-operate",
                                        hintStyle: TextStyle(fontSize: 12.0),
                                        //contentPadding: EdgeInsets.all(16),
                                        //border: OutlineInputBorder(),
                                        fillColor: ColorCodes.lightGreyColor),
                                    //minLines: 3,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

//                      SizedBox(height: 10.0,),
                        Container(

                          width: MediaQuery.of(context).size.width - 20,
                          height: 50,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            S .of(context).choose_date,//"Choose date",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )
                        ),
                        Container(
                          color : Colors.white,
                          child: Column(

                            children: [
//                            Text(PrefUtils.prefs!.getString('fixdate')),
                              _checkslots
                                  ? new ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: deliveryslotData.items.length,
                                      itemBuilder: (_, i) => Column(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.3,
                                                child: _myRadioButton(
                                                  title: deliveryslotData
                                                      .items[i].dateformat,
                                                  value: i,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      _groupValue = i;
                                                      date = deliveryslotData
                                                          .items[i].dateformat;
                                                      PrefUtils.prefs!.setString(
                                                          "fixdate", date);
                                                    });
                                                  },
                                                ),
                                              ),
//                                    Text(deliveryslotData.items[i].dateformat),
                                            ],
                                          ))

                                  : Container(
                                width: MediaQuery.of(context)
                                    .size
                                    .width /
                                    1.3,
                                    padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                                    child: Text(
                                      S .of(context).currently_no_slot,//"Currently there is no slots available",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                  ),

                              SizedBox(
                                height: 15,
                              )
                            ],
                          ),
                        ),

                        Row(
                          children: <Widget>[
                            Spacer(),
                            MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                onTap: () {
                                  List array = [];
                                   String? orderid;
                                   String? itemname;

                                  for (int i = 0;
                                      i <
                                          int.parse(orderitemData
                                              .vieworder[0].itemsCount);
                                      i++) {
                                    if (orderitemData.vieworder1[i].checkboxval) {
                                      setState(() {
                                        _selectitem = true;
                                        orderid = orderitemData
                                            .vieworder1[i].itemorderid;
                                        itemname = orderitemData
                                                .vieworder1[i].itemname +
                                            " - " +
                                            orderitemData.vieworder1[i].varname;
                                        //itemvar = orderitemData[i].varname;
                                      });
                                      var value = {};
//                                          value["\"itemId\""] = "\"" + orderitemData[i].itemid + "\"";
                                      value["\"itemId\""] = "\"" +
                                          orderitemData.vieworder1[i]
                                              .customerorderitemsid +
                                          "\"";
                                      value["\"qty\""] = "\"" +
                                          orderitemData.vieworder1[i].qty +
                                          "\"";
                                      //value["\"itemname\""] = "\"" + itemname + "\"";
                                      array.add(value.toString());
                                    }
                                  }
                                  if (_selectitem) {
                                    _dialogforReturning(context);
                                    Provider.of<MyorderList>(context,listen: false).ReturnItem(
                                        array.toString(), orderid!, itemname!).then((_) {
                                      Provider.of<MyorderList>(context,listen: false).Vieworders(orderid!).then((_) {
                                        setState(() {
                                          Navigator.of(context).pop();
                                          /*Navigator.of(context)
                                              .pushReplacementNamed(
                                            MyorderScreen.routeName,
                                              arguments: {
                                                "orderhistory": ""
                                              }
                                          );*/
                                          Navigation(context, name:Routename.MyOrders,navigatore: NavigatoreTyp.Push,
                                              /*parms: {
                                            "orderhistory": ""
                                          }*/);
                                        });
                                      });
                                    });
                                  }
                                  else if(addressitemsData.items.length <= 0){
                                    Fluttertoast.showToast(
                                      msg: S .of(context).please_add_delivery_address,//"Please select the item!!!",
                                      fontSize: MediaQuery.of(context).textScaleFactor *13);
                                  }
                                  else {
                                    Fluttertoast.showToast(
                                        msg: S .of(context).please_select_item,//"Please select the item!!!",
                                      fontSize: MediaQuery.of(context).textScaleFactor *13,);
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width*0.43,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  child: Center(
                                      child: Text(
                                        S .of(context).proceed,//'PROCEED',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  )),
                                ),
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
        ],
      );
    }
       queryData = MediaQuery.of(context);
       wid= queryData!.size.width;
       maxwid=wid!*0.90;
    return _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Expanded(
             child: SingleChildScrollView(
             child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                    child: Container(
                      constraints: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid!):null,

                      child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 20,),
                        Flexible(child: itemsExchange()),
                        SizedBox(width: 30,),
                        Flexible(child: proceed()),
                        SizedBox(width: 20,),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 10.0,),
              if (_isWeb)
                  Footer(
                      address: PrefUtils.prefs!.getString("restaurant_address")!),
              ],
            ),
            ),
          );
    }

    Widget _bodyMobile(){

       Widget itemsExchange() {
      return Container(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width - 20,
              alignment: Alignment.centerLeft,
              height: 50,
              child: Text( S .of(context).choose_item_to//"Choose Items to "
                  + title!,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(color: Colors.white),
              padding: EdgeInsets.all(10),
              child: new ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: int.parse(orderitemData.vieworder[0].itemsCount),
                  itemBuilder: (_, i) => Column(
                        children: [
                          Row(
                          children: <Widget>[
                            Container(
                                child: CachedNetworkImage(
                              imageUrl: orderitemData.vieworder1[i].itemImage,
                              placeholder: (context, url) => Image.asset(
                                Images.defaultProductImg,
                                width: 50,
                                height: 50,
                              ),
                                  errorWidget: (context, url, error) => Image.asset(
                                    Images.defaultProductImg,
                                    width: 50,
                                    height: 50,
                                  ),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width/2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                          orderitemData
                                                  .vieworder1[i].itemname +
                                              " , " +
                                              orderitemData
                                                  .vieworder1[i].varname,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(fontSize: 12),
                                        )),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Features.iscurrencyformatalign?
                                  Text(
                                    S .of(context).price//"Price: "
                                         +
                                        double.parse(orderitemData.vieworder1[i].price).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + IConstants.currencyFormat,
                                    style: TextStyle(fontSize: 12),
                                  ):
                                  Text(
                                    S .of(context).price//"Price: "
                                        + IConstants.currencyFormat +
                                        double.parse(orderitemData.vieworder1[i].price).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Container(
                                    height: 30,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: PopupMenuButton(
                                      onSelected: (selectedValue) {
                                        setState(() {
                                          orderitemData.vieworder1[i]
                                              .qtychange = selectedValue;
//                                                        PrefUtils.prefs!.setString("fixdate", date);
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            S .of(context).qty//"Qty: "
                                                + orderitemData
                                                    .vieworder1[i].qtychange,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          Icon(
                                            Icons.arrow_drop_down,
                                            size: 12,
                                          ),
                                        ],
                                      ),
                                      /*icon: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text("Qty: " + orderitemData.vieworder1[i].qtychange,style: TextStyle(fontSize: 12),),
                                                      Icon(Icons.arrow_drop_down,size: 12,),
                                                    ],
                                                  ),*/
                                      itemBuilder: (_) =>
                                          <PopupMenuItem<String>>[
                                        for (int j = int.parse(orderitemData
                                                .vieworder1[i].qty);
                                            j >= 1;
                                            j--)
                                          new PopupMenuItem<String>(
                                              child: Text(j.toString()),
                                              value: j.toString()),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            (_showCheck||orderitemData.vieworder1[i].returnTime!= "0")?
                            Checkbox(
                              value: orderitemData.vieworder1[i].checkboxval,
                              onChanged: (value) {
                                setState(() {
                                  orderitemData.vieworder1[i].checkboxval = value;
                                });
                              },
                            ):IconButton(onPressed: (){
                              Fluttertoast.showToast(msg: "$title " + S .of(context).option_expired);//option expired for this product");
                            },
                                icon: Icon(Icons.check_box_outline_blank_sharp,size:24,color: Colors.grey[600],))
                          ],
                            ),
                          Divider(),
                        ],
                      )),
            ),
//                              SizedBox(height: 10.0,),
          ],
        ),
      );
    }
       Widget proceed() {
      return Column(
        children: [
           Container(
                width: MediaQuery.of(context).size.width - 20,
                    alignment: Alignment.centerLeft,
                      height: 50,
                          child: Text( S .of(context).why_returning,//"Why are you returning this?",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
//                      SizedBox(height: 10.0,),
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(color: Colors.white),
                          height: MediaQuery.of(context).size.height / 4,
                          /*decoration: BoxDecoration(
                              color: Theme.of(context).buttonColor),*/
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        PrefUtils.prefs!.setString("returning_reason",
                                            "Quality not adequate");
                                        w = true;
                                        x = false;
                                        y = false;
                                        z = false;
                                      });
                                    },
                                    child: w
                                        ? Container(
                                            padding: EdgeInsets.all(10),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                12,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.4,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  new BorderRadius.all(
                                                      new Radius.circular(5.0)),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              S .of(context).quantity_adequate,//"Quality not adequate",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )
                                        : Container(
                                            padding: EdgeInsets.all(10),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                12,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.4,
                                            decoration: BoxDecoration(
                                              color: box_color,
                                              borderRadius:
                                                  new BorderRadius.all(
                                                      new Radius.circular(5.0)),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text( S .of(context).quantity_adequate,//"Quality not adequate"
                                            ),
                                          ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          PrefUtils.prefs!.setString("returning_reason",
                                              "Wrong item was sent");
                                          w = false;
                                          x = true;
                                          y = false;
                                          z = false;
                                        });
                                      },
                                      child: x
                                          ? Container(
                                              padding: EdgeInsets.all(10),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  12,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.4,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                borderRadius: new BorderRadius
                                                        .all(
                                                    new Radius.circular(5.0)),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                S .of(context).wrong_item_sent,//"Wrong item was sent",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )
                                          : Container(
                                              padding: EdgeInsets.all(10),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  12,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.4,
                                              decoration: BoxDecoration(
                                                color: box_color,
                                                borderRadius: new BorderRadius
                                                        .all(
                                                    new Radius.circular(5.0)),
                                              ),
                                              alignment: Alignment.center,
                                              child:
                                                  Text( S .of(context).wrong_item_sent,//"Wrong item was sent"
                                                  ),
                                            )),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        PrefUtils.prefs!.setString("returning_reason",
                                            "Item defective");
                                        w = false;
                                        x = false;
                                        y = true;
                                        z = false;
                                      });
                                    },
                                    child: y
                                        ? Container(
                                            padding: EdgeInsets.all(10),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                12,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.4,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  new BorderRadius.all(
                                                      new Radius.circular(5.0)),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              S .of(context).item_defective,//"Item defective",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )
                                        : Container(
                                            padding: EdgeInsets.all(10),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                12,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.4,
                                            decoration: BoxDecoration(
                                              color: box_color,
                                              borderRadius:
                                                  new BorderRadius.all(
                                                      new Radius.circular(5.0)),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              S .of(context).item_defective,//"Item defective"
                                            ),
                                          ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        PrefUtils.prefs!.setString("returning_reason",
                                            "Product damaged");
                                        w = false;
                                        x = false;
                                        y = false;
                                        z = true;
                                      });
                                    },
                                    child: z
                                        ? Container(
                                            padding: EdgeInsets.all(10),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                12,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.4,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  new BorderRadius.all(
                                                      new Radius.circular(5.0)),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              S .of(context).product_damaged,//"Product damaged",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )
                                        : Container(
                                            padding: EdgeInsets.all(10),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                12,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.4,
                                            decoration: BoxDecoration(
                                              color: box_color,
                                              borderRadius:
                                                  new BorderRadius.all(
                                                      new Radius.circular(5.0)),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              S .of(context).product_damaged,//"Product damaged"
                                            ),
                                          ),
                                  ),
                                ],
                              ),
//                                        Text(PrefUtils.prefs!.getString('returning_reason')),
                            ],
                          ),
                        ),

                        Container(
                            width: MediaQuery.of(context).size.width - 20,
                            height: 50,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              S .of(context).pickup_address,//"Pickup address",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            )),
//                      SizedBox(height: 10.0,),
                        Container(
                          decoration: BoxDecoration(color: Colors.white),
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            children: [
                              _checkaddress
                                  ? Container(
                                      height: 80,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(10.0),
                                      color: Colors.white,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
//                            SizedBox(width: 10.0,),
                                          Expanded(
                                              child: Text(
                                            address,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12.0,
                                            ),
                                          )),
                                          GestureDetector(
                                              onTap: () {
                                                _settingModalBottomSheet(
                                                    context);
                                              },
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    S .of(context).change_caps,//"CHANGE",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "---------",
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                ],
                                              )),
//                            SizedBox(width: 10.0,),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(10.0),
                                      color: Colors.white,
                                      child: Row(
                                        children: <Widget>[
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          Spacer(),
                                          FlatButton(
                                            color:
                                                Theme.of(context).primaryColor,
                                            textColor:
                                                Theme.of(context).buttonColor,
                                            shape: new RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      3.0),
                                            ),
                                            onPressed: ()  {
                                            PrefUtils.prefs!.setString("addressbook",
                                            "returnscreen");
                                            /*  Navigator.of(context).pushNamed(
                                                  AddressScreen.routeName,
                                                  arguments: {
                                                    'addresstype': "new",
                                                    'addressid': "",
                                                    'delieveryLocation': "",
                                                    'orderid': widget.params['orderid'],
                                                    'title':widget.params['title'],

                                                  });*/
         if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
         // _dialogforaddress(context);
         AddressWeb(context,
           addresstype: "new",
           addressid: "",
           delieveryLocation: "",
           orderid: widget.params['orderid'],
           title: widget.params['title'],);
         }
         else {
           Navigation(context, name: Routename.AddressScreen,
               navigatore: NavigatoreTyp.Push,
               qparms: {
                 'addresstype': "new",
                 'addressid': "",
                 'delieveryLocation': "",
                 'orderid': widget.params['orderid'],
                 'title': widget.params['title'],
               });
         }
                                            },
                                            child: Text(
                                              S .of(context).add_address,//'Add Address',
                                              style: TextStyle(fontSize: 12.0),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                        ],
                                      ),
                                    ),
                              Divider(),
                              ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.all(10.0),
                                leading: Image.asset(
                                  Images.shoppinglistsImg,
                                  width: 25.0,
                                  height: 35.0,
                                ),
                                title: Transform(
                                  transform:
                                      Matrix4.translationValues(-16, 0.0, 0.0),
                                  child: TextField(
                                    controller: note,
                                    decoration: InputDecoration.collapsed(
                                        hintText:
                                        S .of(context).any_store_request,//"Any store request? We will try our best to co-operate",
                                        hintStyle: TextStyle(fontSize: 12.0),
                                        //contentPadding: EdgeInsets.all(16),
                                        //border: OutlineInputBorder(),
                                        fillColor: ColorCodes.lightGreyColor),
                                    //minLines: 3,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

//                      SizedBox(height: 10.0,),
         (addressitemsData.items.length > 0 )?
                        Container(
                            width: MediaQuery.of(context).size.width - 20,
                            height: 50,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              S .of(context).choose_date,//'Choose date',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            )
                        ):SizedBox.shrink(),
         (addressitemsData.items.length > 0)?
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          decoration: BoxDecoration(color: Colors.white),
                          child: Column(
                            children: [
//                            Text(PrefUtils.prefs!.getString('fixdate')),
                              _checkslots
                                  ? new ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: deliveryslotData.items.length,
                                      itemBuilder: (_, i) => Column(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.2,
                                                child: _myRadioButton(
                                                  title: deliveryslotData
                                                      .items[i].dateformat,
                                                  value: i,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      _groupValue = i;
                                                      date = deliveryslotData
                                                          .items[i].dateformat;
                                                      PrefUtils.prefs!.setString(
                                                          "fixdate", date);
                                                    });
                                                  },
                                                ),
                                              ),
//                                    Text(deliveryslotData.items[i].dateformat),
                                            ],
                                          ))
                                  : Container(
                                    width: MediaQuery.of(context)
                                    .size
                                    .width /
                                    1.2,
                                    padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                                    child: Text(
                                S .of(context).currently_no_slot,//"Currently there is no slots available",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                  ),
                              SizedBox(
                                height: 15,
                              )
                            ],
                          ),
                        ):SizedBox.shrink(),

                        Row(
                          children: <Widget>[
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                addressitemsData = Provider.of<AddressItemsList>(context, listen: false);
                                List array = [];
                                 String? orderid;
                                 String? itemname;
                                bool _selectitem = false;
                                if(addressitemsData.items.length <= 0){

                                  Fluttertoast.showToast(
                                      msg: S .of(context).please_add_delivery_address,//"Please select the item!!!",
                                      fontSize: MediaQuery.of(context).textScaleFactor *13);
                                } else {
                                  for (int i = 0;
                                  i <
                                      int.parse(orderitemData
                                          .vieworder[0].itemsCount);
                                  i++) {
                                    if (orderitemData.vieworder1[i]
                                        .checkboxval) {
                                      setState(() {
                                        _selectitem = true;
                                        orderid = orderitemData
                                            .vieworder1[i].itemorderid;
                                        itemname = orderitemData
                                            .vieworder1[i].itemname +
                                            " - " +
                                            orderitemData.vieworder1[i].varname;
                                        //itemvar = orderitemData[i].varname;
                                      });
                                      var value = {};
//                                          value["\"itemId\""] = "\"" + orderitemData[i].itemid + "\"";
                                      value["\"itemId\""] = "\"" +
                                          orderitemData.vieworder1[i]
                                              .customerorderitemsid +
                                          "\"";
                                      value["\"qty\""] = "\"" +
                                          orderitemData.vieworder1[i].qty +
                                          "\"";
                                      //value["\"itemname\""] = "\"" + itemname + "\"";
                                      array.add(value.toString());
                                    }
                                  }
                                  if (_selectitem) {
                                    _dialogforReturning(context);
                                    Provider.of<MyorderList>(
                                        context, listen: false)
                                        .ReturnItem(
                                        array.toString(), orderid!, itemname!)
                                        .then((_) {
                                      Provider.of<MyorderList>(
                                          context, listen: false)
                                          .Vieworders(orderid!)
                                          .then((_) {
                                        setState(() {
                                          Navigator.of(context).pop();
                                         /* Navigator.of(context)
                                              .pushReplacementNamed(
                                            MyorderScreen.routeName,arguments: {
                                            "orderhistory": ""
                                          }
                                          );*/
                                          Navigation(context, name:Routename.MyOrders,navigatore: NavigatoreTyp.Push,
                                             /* parms: {
                                            "orderhistory": ""
                                          }*/);;
                                        });
                                      });
                                    });
                                  }


                                  else {
                                    Fluttertoast.showToast(
                                      msg: S
                                          .of(context)
                                          .please_select_item,
                                      //"Please select the item!!!",
                                      fontSize: MediaQuery
                                          .of(context)
                                          .textScaleFactor * 13,);
                                  }
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                ),
                                child: Center(
                                    child: Text(
                                      S .of(context).proceed,//'PROCEED',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                )),
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
        ],
      );
    }
    return _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Expanded(
             child: SingleChildScrollView(
             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                itemsExchange(),
                proceed(),
                SizedBox(height: 10.0,),
              if (_isWeb)
                  Footer(
                      address: PrefUtils.prefs!.getString("restaurant_address")!),
              ],
            ),
            ),
          );
    }

    

    return Scaffold(
      appBar: ResponsiveLayout.isSmallScreen(context)
          ? gradientappbarmobile()
          : null,
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          if (_isWeb && !ResponsiveLayout.isSmallScreen(context))
          Header(false),
          (_isWeb && !ResponsiveLayout.isSmallScreen(context))?_bodyWeb():_bodyMobile(),
        ],
      ),
    );
  }
}
