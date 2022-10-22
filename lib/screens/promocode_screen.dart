import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../assets/ColorCodes.dart';
import '../assets/images.dart';
import '../constants/IConstants.dart';
import '../constants/api.dart';
import '../data/calculations.dart';
import '../generated/l10n.dart';
import '../models/VxModels/VxStore.dart';
import '../models/newmodle/cartModle.dart';
import '../models/newmodle/product_data.dart';
import '../providers/myorderitems.dart';

import '../rought_genrator.dart';

import '../utils/ResponsiveLayout.dart';
import '../utils/prefUtils.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../widgets/promocode_component.dart';
import '../widgets/simmers/item_list_shimmer.dart';

import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;


class PromocodeWeb with Navigations{

  String? minimumOrderAmountNoraml="";
  String? deliveryChargeNormal ="";
  String? minimumOrderAmountPrime = "";
  String? deliveryChargePrime = "";
  String? minimumOrderAmountExpress ="";
  String? deliveryChargeExpress = "";
  String? deliveryType = "";
  String? addressId = "";
  String? note = "";
  String? deliveryCharge = "";
  String? deliveryDurationExpress = "";
  String? deliveryAmt = "";
  Map<String, String>? params1;
  PromocodeWeb(context,{this.minimumOrderAmountNoraml,this.deliveryChargeNormal,this.minimumOrderAmountPrime,this.deliveryChargePrime,
    this.minimumOrderAmountExpress,this.deliveryChargeExpress,this.deliveryType,this.addressId,this.note,
  this.deliveryCharge,this.deliveryDurationExpress,this.deliveryAmt,this.params1}){
    _dialogforpromo(context);
  }
  _dialogforpromo(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width/3,maxHeight: MediaQuery.of(context).size.height/2),
              child: AlertDialog(
                insetPadding: EdgeInsets.symmetric(horizontal: 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                content: Container(
                    width: MediaQuery.of(context).size.width/3,
                    height:  MediaQuery.of(context).size.height/1.2,
                    child: PromocodeComponent(
                      minimumOrderAmountNoraml ,
                      deliveryChargeNormal,
                      minimumOrderAmountPrime ,
                      deliveryChargePrime ,
                     minimumOrderAmountExpress ,
                      deliveryChargeExpress ,
                      deliveryType,
                      addressId ,
                      note ,
                      deliveryCharge ,
                      deliveryDurationExpress ,
                      deliveryAmt,
                      params1,
                    )),
              ),
            );
          });
        }
    );

  }
}

class PromocodeScreen extends StatefulWidget{
  static const routeName = '/promocode-screen';

  String? minimumOrderAmountNoraml="";
  String? deliveryChargeNormal ="";
  String? minimumOrderAmountPrime = "";
  String? deliveryChargePrime = "";
  String? minimumOrderAmountExpress ="";
  String? deliveryChargeExpress = "";
  String? deliveryType = "";
  String? addressId = "";
  String? note = "";
  String? deliveryCharge = "";
  String? deliveryDurationExpress = "";
 String? deliveryAmt = "";
  Map<String, String>? params1;
  // PromocodeScreen(context,{this.minimumOrderAmountNoraml,this.deliveryChargeNormal,this.minimumOrderAmountPrime,this.deliveryChargePrime,
  //   this.minimumOrderAmountExpress,this.deliveryChargeExpress,this.deliveryType,this.addressId,this.note,
  //   this.deliveryCharge,this.deliveryDurationExpress,this.deliveryAmt,this.params1}){}
  PromocodeScreen(Map<String, String> params){
    this.params1= params;
    this.minimumOrderAmountNoraml = params["minimumOrderAmountNoraml"]??"" ;
    this.deliveryChargeNormal = params["deliveryChargeNormal"]??"";
    this.minimumOrderAmountPrime = params["minimumOrderAmountPrime"]??"";
    this.deliveryChargePrime = params["deliveryChargePrime"]??"";
    this.minimumOrderAmountExpress = params["minimumOrderAmountExpress"]??"";
    this.deliveryChargeExpress = params["deliveryChargeExpress"]??"";
    this.deliveryType = params["deliveryType"]??"";
    this.addressId = params["addressId"]??"";
    this.note = params["note"]??"";
    this.deliveryCharge = params["deliveryCharge"]??"";
    this.deliveryDurationExpress = params["deliveryDurationExpress"]??"";
    this.deliveryAmt = params["deliveryAmt"]??"";
  }
  @override
  PromocodeScreenState createState() => PromocodeScreenState();
}

class PromocodeScreenState extends State<PromocodeScreen>
    with SingleTickerProviderStateMixin, Navigations{
  bool _isLoading = true;
  bool _isWeb = false;
  bool iphonex = false;
  var promocodeData;
  late double maxwid;
  late double wid;
  late MediaQueryData queryData;
  late Future<List<Promocode>> _future = Future.value([]);
  late Future<List<Promocode>> _futureNonavailable =  Future.value([]);
  final TextEditingController promocontroller = new TextEditingController();
  //  String promocontroller = "";
  String? membershipvx=(VxState.store as GroceStore).userData.membership;
  List<CartItem> productBox=[];
  late String promovarprice;
  double deliveryAmt = 0;
  var promoData;
  var promoDataanavilable;

  @override
  void initState() {
    productBox = (VxState.store as GroceStore).CartItemList;
    Future.delayed(Duration.zero, () async {
      //prefs = await SharedPreferences.getInstance();

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
      /* Provider.of<MyorderList>(context,listen: false).GetPromoCode().then((_) {
        promocodeData = Provider.of<MyorderList>(context, listen: false);
        setState(() {
          _isLoading = false;
        });
      });*/
      debugPrint("promodata...."+widget.toString());
      MyorderList().GetPromoCode().then((value) {
        debugPrint("promodata...."+promoData.toString());
        setState(() {
          _future = Future.value(value);
          _isLoading = false;
        });
      });

      MyorderList().GetNonapplicableCoupon().then((value) {

        debugPrint("promoDataanavilable...."+promoDataanavilable.toString());
        setState(() {
          _futureNonavailable = Future.value(value);
          _isLoading = false;
        });
      });

    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
       return PromocodeComponent(
         widget.minimumOrderAmountNoraml ,
         widget.deliveryChargeNormal,
         widget.minimumOrderAmountPrime ,
         widget.deliveryChargePrime ,
         widget.minimumOrderAmountExpress ,
         widget.deliveryChargeExpress ,
         widget.deliveryType,
         widget.addressId ,
         widget.note ,
         widget.deliveryCharge ,
         widget.deliveryDurationExpress ,
         widget.deliveryAmt,
         widget.params1,
       );
  }

}