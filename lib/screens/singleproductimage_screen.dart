import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grocbay/constants/features.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:provider/provider.dart';

import '../providers/itemslist.dart';
import '../providers/sellingitems.dart';
import '../assets/images.dart';
import '../assets/ColorCodes.dart';
import '../utils/prefUtils.dart';
import '../constants/IConstants.dart';

class SingleProductImageScreen extends StatefulWidget {
  static const routeName = '/singleproductimage-screen';
  @override
  _SingleProductImageScreenState createState() => _SingleProductImageScreenState();
}

class _SingleProductImageScreenState extends State<SingleProductImageScreen> {
  var cartempty = true;
  bool _isLoading = true;
  var singleitemData;
  var singleitemvar;
  var multiimage;
  bool _checkmembership = false;
  bool membershipdisplay = true;
  var margins;

  late String varmemberprice;
  late String varprice;
  late String varmrp;
  late String varid;
  late String varname;
  late String varstock;
  late String varminitem;
  late String varmaxitem;
  late bool discountDisplay;
  late bool memberpriceDisplay;
  late Color varcolor;
  String itemname = "";
  String itemimg = "";
  String itemdescription = "";
  String itemmanufact = "";
  String _displayimg = "";
  var notificationFor;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        if(PrefUtils.prefs!.getString("membership") == "1"){
          _checkmembership = true;
        } else {
          _checkmembership = false;
        }
      });
      final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      final itemid = routeArgs['itemid'];
      final fromScreen = routeArgs['fromScreen'];
      notificationFor = routeArgs['notificationFor'];
      print("from screen single....."+fromScreen.toString());
      print("from screen single...notification for.."+notificationFor.toString());
      await Provider.of<ItemsList>(context,listen: false).fetchSingleItems(itemid!, notificationFor).then((_) {
        setState(() {
          Provider.of<SellingItemsList>(context,listen: false).fetchNewItems(routeArgs['itemid'].toString()).then((_) {
            setState(() {
              _isLoading = false;
              singleitemData = Provider.of<ItemsList>(context,listen: false);
              singleitemvar = Provider.of<ItemsList>(context,listen: false).findByIdsingleitems(itemid,notificationFor);
              varmemberprice = singleitemvar[0].varmemberprice;
              varmrp = singleitemvar[0]._varmrp;
              varprice = singleitemvar[0].varprice;
              varid = singleitemvar[0].varid;
              varname = singleitemvar[0].varname;
              varstock = singleitemvar[0].varstock;
              varminitem = singleitemvar[0].varminitem;
              varmaxitem = singleitemvar[0].varmaxitem;
              varcolor = singleitemvar[0].varcolor;
              discountDisplay = singleitemvar[0].discountDisplay;
              memberpriceDisplay = singleitemvar[0].membershipDisplay;

              if (varmemberprice == '-' || varmemberprice == "0") {
                setState(() {
                  membershipdisplay = false;
                });
              } else {
                membershipdisplay = true;
              }

              if(_checkmembership) {
                if (varmemberprice.toString() == '-' || double.parse(varmemberprice) <= 0) {
                  if (double.parse(varmrp) <= 0 || double.parse(varprice) <= 0) {
                    margins = "0";
                  } else {
                    var difference = (double.parse(varmrp) - double.parse(varprice));
                    var profit = difference / double.parse(varmrp);
                    margins = profit * 100;


                    //discount price rounding
                    margins = num.parse(margins.toStringAsFixed(0));
                    margins = margins.toString();
                  }
                } else {
                  var difference = (double.parse(varmrp) - double.parse(varmemberprice));
                  var profit = difference / double.parse(varmrp);
                  margins = profit * 100;


                  //discount price rounding
                  margins = num.parse(margins.toStringAsFixed(0));
                  margins = margins.toString();
                }
              } else {
                if (double.parse(varmrp) <= 0 || double.parse(varprice) <= 0) {
                  margins = "0";
                } else {
                  var difference = (double.parse(varmrp) - double.parse(varprice));
                  var profit = difference / double.parse(varmrp);
                  margins = profit * 100;


                  //discount price rounding
                  margins = num.parse(margins.toStringAsFixed(0));
                  margins = margins.toString();
                }
              }


/*              if(double.parse(varprice) <= 0 || varprice.toString() == "" || double.parse(varprice) == double.parse(varmrp)){
                discountedPriceDisplay = false;
              } else {
                discountedPriceDisplay = true;
              }*/
              if(margins == "NaN") {
              } else {
                if (int.parse(margins) <= 0) {
                } else {
                }
              }

              itemname = singleitemData.singleitems[0].title;
              itemimg = singleitemData.singleitems[0].imageUrl;

              if(singleitemData.singleitems[0].description.toString() != "null" && singleitemData.singleitems[0].description.toString().length > 0) {
                itemdescription = singleitemData.singleitems[0].description;
              }
              if(singleitemData.singleitems[0].manufacturedesc.toString() != "null" && singleitemData.singleitems[0].manufacturedesc.toString().length > 0) {
                itemmanufact = singleitemData.singleitems[0].manufacturedesc;
              }

              multiimage = Provider.of<ItemsList>(context,listen: false).findByIdmulti(varid);
              _displayimg = multiimage[0].imageUrl;
            });
          });
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sellingitemData = Provider.of<SellingItemsList>(context,listen: false);
    if(sellingitemData.itemsnew.length <= 0) {
    } else {
    }

    return Scaffold(
      appBar: NewGradientAppBar(
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              ColorCodes.appbarColor,
              ColorCodes.appbarColor2
            ]
        ),
        elevation: (IConstants.isEnterprise)?0:1,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: ColorCodes.iconColor),
            onPressed: () => Navigator.of(context).pop()),
        title: Text(
            itemname,
          style: TextStyle(color: ColorCodes.iconColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: _isLoading ?
      Center(
        child: new CircularProgressIndicator(),
      ) :
      SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0,),
            PinchZoomImage(
              image: CachedNetworkImage(
                imageUrl: _displayimg,
                placeholder: (context, url) => Image.asset(Images.defaultProductImg),
                errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height-192,

                //fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20.0,),
            SizedBox(
              height: 70.0,
              child: new ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: multiimage.length,
                  itemBuilder: (_, i) =>
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _displayimg = multiimage[i].imageUrl;
                            for(int j = 0; j < multiimage.length; j++){
                              if(i == j) {
                                multiimage[j].varcolor = ColorCodes.darkthemeColor;
                              } else {
                                multiimage[j].varcolor = ColorCodes.lightgrey;
                              }
                            }
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(width: 5.0,),
                            Container(
                              padding: EdgeInsets.all(5.0),
                              width: 60.0,
                              height: 60.0,
                              margin: EdgeInsets.only(right: 5.0),
                              decoration: new BoxDecoration(
                                borderRadius: new BorderRadius.all(new Radius.circular(3.0)),
                                border: new Border.all(
                                  color: multiimage[i].varcolor,
                                  //width: 4.0,
                                ),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: multiimage[i].imageUrl,
                                width: 50.0,
                                height: 50.0,
                                placeholder: (context, url) => Image.asset(Images.defaultProductImg),
                                errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg),
                              ),
                            ),
                          ],
                        ),
                      )
              ),
            ),

          ],
        ),
      ),
    );
  }
}