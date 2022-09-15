import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../assets/ColorCodes.dart';
import '../../constants/features.dart';
import 'package:provider/provider.dart';
import '../constants/api.dart';
import '../generated/l10n.dart';
import '../constants/IConstants.dart';
import '../assets/images.dart';
import '../providers/myorderitems.dart';
import 'package:http/http.dart' as http;

import '../utils/prefUtils.dart';

class OrderhistoryDisplay extends StatefulWidget {
  final String itemname;
  final String varname;
  final String price;
  final String qty;
  final String subtotal;
  final String submrp;
  final String itemImage;
  final String extraAmount;
  final String toppings;
  final String itemId;
  final String parent_id;
 // final String titemId;
  List toppingsDetails;
  final String ostatus;
  OrderhistoryDisplay(
      this.itemname,
      this.varname,
      this.price,
      this.qty,
      this.subtotal,
      this.itemImage,
      this.extraAmount,
      this.toppings,
      this.itemId,
    this.parent_id,
   // this.titemId,
      this.toppingsDetails,
      this.ostatus,
      this.submrp
      );

  @override
  _OrderhistoryDisplayState createState() => _OrderhistoryDisplayState();
}

class _OrderhistoryDisplayState extends State<OrderhistoryDisplay> {
  var extraAmount;
  var orderitemData;
  List ToppingsDetails = [];
  double toppingsTotal = 0;
  String itemName = "";
  String quantity = "";
  String itemId = "";
  String price = "";
  String tparentid = "";
  String comment = S .current.good;
  double ratings = 3.0;
  String cn = "";
  final TextEditingController commentController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    orderitemData = Provider.of<MyorderList>(context, listen: false,);
    if(widget.toppingsDetails.length > 0){
      ToppingsDetails.clear();
      for(int j = 0; j < widget.toppingsDetails.length; j++) {
          itemName  = orderitemData.toppingsdata[j].titemName;
          quantity  = orderitemData.toppingsdata[j].tquantity;
          itemId  = orderitemData.toppingsdata[j].titemId;
          price  = orderitemData.toppingsdata[j].tprice;
          tparentid = orderitemData.toppingsdata[j].tparent_id;
          if(widget.toppingsDetails.length > 0 && widget.parent_id == widget.toppingsDetails[j].tparent_id)
              toppingsTotal = toppingsTotal + double.parse(price);

      }
    }


    return Container(
      padding: EdgeInsets.only(top:5,bottom: 5),
      decoration: BoxDecoration(color: Theme.of(context).buttonColor),
      child:
        Row(
          children: [
            Container(
                child:widget.extraAmount == "888"? Image.asset(Images.membershipImg,
                  color: Theme.of(context).primaryColor,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ): CachedNetworkImage(
                  imageUrl: widget.itemImage,
                  placeholder: (context, url) => Image.asset(Images.defaultProductImg,
                    width: 50,
                    height: 50,),
                  errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg,
                    width: 50,
                    height: 50,),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width/2,
                  child: Row(
                    children: [
                      Text(
                        widget.itemname,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
                SizedBox(height: 5,),
                Text(widget.varname + " * " + widget.qty, style: TextStyle(color: ColorCodes.skygrey,fontSize: 11),),
                SizedBox(height: 5,),
                Container(
                  width: MediaQuery.of(context).size.width/2,
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.toppingsDetails.length,
                      itemBuilder: (_, i) {
                        return  (widget.toppingsDetails.length > 0 && widget.parent_id == widget.toppingsDetails[i].tparent_id)  ?Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.toppingsDetails[i].titemName, style: TextStyle(fontSize: 11,
                                color: ColorCodes.greyColor),),
                            SizedBox(height: 3,)
                          ],
                        ):SizedBox.shrink();
                      }),
                ),
              ],
            ),
            Spacer(),
            Column(
              children: [

                RichText(
                    text: new TextSpan(
                      children: <TextSpan>[
                        new TextSpan(
                          text:Features.iscurrencyformatalign?(double.parse(widget.subtotal) + toppingsTotal).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + " " + IConstants.currencyFormat:
                                IConstants.currencyFormat + " " +(double.parse(widget.subtotal) + toppingsTotal).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) ,// 'HOME DELIVERY',
                          style: TextStyle(
                            color: ColorCodes.blackColor,
                            fontWeight: FontWeight.bold,
                            fontSize:13,
                          ),
                        ),
                      ],
                    )),
              ],
            ),
        ],
        ),

    );
  }



}