import 'package:flutter/cupertino.dart';
import 'package:grocbay/constants/features.dart';
import 'package:grocbay/widgets/badge_discount.dart';
import 'package:grocbay/widgets/flutter_flow/flutter_flow_theme.dart';
import '../../assets/ColorCodes.dart';
import '../../assets/images.dart';
import '../../constants/IConstants.dart';
import '../../data/calculations.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

class VarintWidget extends StatefulWidget {
  Function? onTap;

  var singleitemvar;
  var varid;

  int i;
  int? groupvalue;

  bool? checkmargin = false;
  var varMarginList;
  var discountDisplay;
  bool? checkmembership;
  var memberpriceDisplay;

  VarintWidget({Key? key, this.onTap,this.singleitemvar,this.varid,required this.i,this.checkmargin,this.varMarginList,
  this. discountDisplay,
  this. checkmembership,
  this. memberpriceDisplay,
    this.groupvalue}) : super(key: key);

  @override
  _VarintWidgetState createState() => _VarintWidgetState();
}

class _VarintWidgetState extends State<VarintWidget> {
  String? radioButtonValue;

  // List<String> _varMarginList = List<String>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>setState((){
        widget.onTap!();
      }),
      child: Container(
       // height: 75,
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
          child: Container(
            decoration: BoxDecoration(
              color:Features.btobModule?widget.groupvalue == widget.i ? ColorCodes.mediumgren : ColorCodes.whiteColor:(widget.singleitemvar[widget.i].varcolor==ColorCodes.darkblue?Colors.white:Colors.white),
              borderRadius: Features.btobModule?BorderRadius.circular(5):BorderRadius.circular(10),
              border: Border.all(
                color: Features.btobModule?ColorCodes.greenColor:widget.singleitemvar[widget.i].varcolor,
                width: 1,
              ),
            ),
            child: Consumer<CartCalculations>(
              builder: (_, cart, ch) =>Align(
                alignment:
                Alignment.topLeft,
                child:  BadgeDiscount(
                  child: ch!,
                  value: widget.varMarginList[widget.i],
                  color: int.parse(widget.singleitemvar[widget.i].varstock) > 0?Theme.of(context).primaryColor:Colors.grey,
                ),
              ),child:  Padding(
              padding: EdgeInsetsDirectional.fromSTEB(5, 10, 5, 5),
              child: Column(
                children: [
                  SizedBox(height: 5,),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: 100,
                        decoration: BoxDecoration(
                          color: Color(0x00EEEEEE),
                        ),
                        child: Text(
                          Features.btobModule?(widget.singleitemvar[widget.i].varminitem + "-"+
                              widget.singleitemvar[widget.i].varmaxitem +" "+ widget.singleitemvar[widget.i].unit):
                          widget.singleitemvar[widget.i].varname+" "+ widget.singleitemvar[widget.i].unit,

                          style: FlutterFlowTheme.bodyText1.override(
                            fontFamily: 'Poppins',
                            color: int.parse(widget.singleitemvar[widget.i].varstock) > 0?ColorCodes.darkblue:Colors.grey
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            color: Color(0x00EEEEEE),
                          ),
                          child: displayPrice(
                              checkmembership: widget.checkmembership!,
                              discountDisplay: widget.singleitemvar[widget.i].discountDisplay,
                              memberpriceDisplay: widget.singleitemvar[widget.i].membershipDisplay,
                              varianrt: widget.singleitemvar[widget.i]),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Features.btobModule?
                            widget.groupvalue == widget.i ?
                            Container(
                              width: 18.0,
                              height: 18.0,
                              decoration: BoxDecoration(
                                color: ColorCodes.greenColor,
                                border: Border.all(
                                  color: ColorCodes.greenColor,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                margin: EdgeInsets.all(1.5),
                                decoration: BoxDecoration(
                                  color: ColorCodes.greenColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.check,
                                    color: ColorCodes.whiteColor,
                                    size: 12.0),
                              ),
                            )
                                : Icon(
                                Icons.radio_button_off_outlined,
                                color: ColorCodes.greenColor)
                                :
                            Icon(
                                (widget.varid == widget.singleitemvar[widget.i].varid)
                                    ? Icons.radio_button_checked_outlined
                                    : Icons.radio_button_off_outlined,
                                color: (int.parse(widget.singleitemvar[widget.i].varstock) <= 0)
                                    ? ColorCodes.grey
                                    : (widget.varid == widget.singleitemvar[widget.i].varid)
                                    ? ColorCodes.accentColor
                                    : ColorCodes.blackColor)
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget displayPrice({varianrt,discountDisplay,memberpriceDisplay, bool? checkmembership}){
  //varianrt=singleitemvar[i]
  return Column(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          checkmembership! ? Image.asset(
            Images.starImg,
          )
              :
          SizedBox.shrink(),
          Text(
            Features.iscurrencyformatalign?
            (checkmembership ? memberpriceDisplay ? varianrt.varmemberprice : varianrt.varprice : varianrt.varprice) + IConstants.currencyFormat :
              IConstants.currencyFormat + (checkmembership ? memberpriceDisplay ? varianrt.varmemberprice : varianrt.varprice : varianrt.varprice), style: new TextStyle(fontWeight: FontWeight.bold, color: int.parse(varianrt.varstock) > 0?ColorCodes.darkblue:Colors.grey, fontSize: 14.0)),
        ],
      ),
      if(discountDisplay || (checkmembership && memberpriceDisplay))
      Text(
        Features.iscurrencyformatalign?
        varianrt.varmrp + IConstants.currencyFormat:
          IConstants.currencyFormat + varianrt.varmrp, style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 10.0)),
    ],
  );
}
