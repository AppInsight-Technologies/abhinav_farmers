import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../constants/features.dart';
import '../controller/mutations/cart_mutation.dart';
import '../data/calculations.dart';
import '../generated/l10n.dart';
import '../models/VxModels/VxStore.dart';
import 'package:velocity_x/velocity_x.dart';
import '../assets/ColorCodes.dart';
import '../assets/images.dart';
import '../constants/IConstants.dart';
import '../rought_genrator.dart';

class BottomNaviagation extends StatefulWidget {
  final String? itemCount;
  final String? title;
  String? total;
  final GestureTapCallback? onPressed;
  String adonamount;


  BottomNaviagation({Key? key, this.itemCount, this.title, this.total, this.onPressed,this.adonamount = "0"}) : super(key: key);
  @override
  _BottomNaviagationState createState() => _BottomNaviagationState();
}

class _BottomNaviagationState  extends State<BottomNaviagation> with Navigations {
  CartCalculation _calculation = CartCalculation();
  bool homeontapped = false;
  bool categoryontapped = false;
  @override
  Widget build(BuildContext context) {
    debugPrint("title...."+widget.title!+"  "+S .current.subscribe+"  "+widget.itemCount!+"  "+CartCalculations.itemCount.toString() + "toytal..."+widget.total.toString());
    return VxBuilder(
        mutations: {SetCartItem},
        builder: (context, store, state){
          if(((widget.title==S .current.subscribe.toUpperCase()  || widget.title == S .of(context).pause)?(widget.itemCount == "0")  : CartCalculations.itemCount>0) && (widget.itemCount != "1 Items") )
            return ((widget.title==S .current.subscribe.toUpperCase()  || widget.title == S .of(context).pause)?widget.itemCount:CartCalculations.itemCount.toString()) == "0"?
            // MouseRegion(
            //   cursor: SystemMouseCursors.click,
            //   child: Container(
            //     height: 80,
            //     padding: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10),
            //     color: ColorCodes.whiteColor,
            //     width: MediaQuery.of(context).size.width,
            //     child: GestureDetector(
            //       onTap: () {
            //         widget.onPressed!();
            //       },
            //       child: Container(
            //         padding: EdgeInsets.all(8),
            //         decoration: BoxDecoration(
            //           //color: ColorCodes.cyanColor,
            //           color: ColorCodes.accentColor,
            //           borderRadius: BorderRadius.circular(10),
            //         ),
            //         child: Row(
            //           children: <Widget>[
            //             Expanded(
            //               child: Align(
            //                 alignment: Alignment.centerLeft,
            //                 child: Container(
            //                   child: Text("",
            //                   ),
            //                 ),
            //               ),
            //             ),
            //             Expanded(
            //               child: Align(
            //                 alignment: Alignment.center,
            //                 child: Container(
            //                   child: Text(widget.title!,
            //                     style: TextStyle(
            //                       fontSize: 18,
            //
            //                       color: ColorCodes.whiteColor,
            //                       //color: ColorCodes.discount,
            //                       fontWeight: FontWeight.bold,
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ),
            //             Expanded(
            //                 child: Align(
            //                   alignment: Alignment.centerRight,
            //                   child: Container(
            //                     child:  Icon(Icons.keyboard_arrow_right_sharp, size: 35, color: ColorCodes.lightblue,),
            //                   ),
            //                 )),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // )
            //
            // 24 mantra changes
            //
            // 24 mantra design changes
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                height: 80,
                padding: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10),
                color: ColorCodes.whiteColor,
                width: MediaQuery.of(context).size.width,
                child: GestureDetector(
                  onTap: () {
                    widget.onPressed!();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
           //            Expanded(
           //              flex:1,
           //              child: Row(
           //                mainAxisAlignment: MainAxisAlignment.start,
           //                children: [
           //                  GestureDetector(
           //                    onTap: () {
           //                      setState(() {
           //                        homeontapped = true;
           //                        categoryontapped = false;
           //                      });
           //
           //                      Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);
           //
           //                    },
           //                    child: Column(
           //                      crossAxisAlignment: CrossAxisAlignment.start,
           //                      mainAxisAlignment: MainAxisAlignment.start,
           //                      children: <Widget>[
           //                        SizedBox(
           //                          height: 5.0,
           //                        ),
           //                        CircleAvatar(
           //                          radius: 13.0,
           //                          foregroundColor: Colors.white,
           //                          backgroundColor: Colors.transparent,
           //                          child: Image.asset(
           //                            Images.homeImg,
           //                            color: (homeontapped)?ColorCodes.primaryColor:ColorCodes.lightgrey,
           //                            width: 30,
           //                            height: 20,
           //                          ),
           //                        ),
           //                        SizedBox(
           //                          height: 0.0,
           //                        ),
           //                        Text(  S.of(context).home,
           //                            //  "Home",
           //                            style: TextStyle(
           //                                color:  (homeontapped)?ColorCodes.primaryColor:ColorCodes.lightgrey, fontSize: 10.0)),
           //                      ],
           //                    ),
           //                  ),
           //                  Padding(
           //                    padding: const EdgeInsets.only(left:8.0),
           //                    child: ValueListenableBuilder(
           //                        valueListenable: IConstants.currentdeliverylocation,
           //                        builder: (context, value, widget) {
           //                          return GestureDetector(
           //                            onTap: () {
           //                              if (value != S
           //                                  .of(context)
           //                                  .not_available_location)
           //                                /*Navigator.of(context).pushNamed(
           //   CategoryScreen.routeName,
           // );*/
           //                                categoryontapped = true;
           //                              homeontapped = false;
           //                              Navigation(context, name:Routename.Category, navigatore: NavigatoreTyp.Push);
           //                            },
           //                            child: Column(
           //                              children: <Widget>[
           //                                SizedBox(
           //                                  height: 5.0,
           //                                ),
           //                                CircleAvatar(
           //                                  radius: 13.0,
           //                                  backgroundColor: Colors.transparent,
           //                                  child: Image.asset(Images.categoriesImg,
           //                                    color: (categoryontapped)?ColorCodes.primaryColor:ColorCodes.lightgrey,
           //                                    width: 20,
           //                                    height: 30,),
           //                                ),
           //                                SizedBox(
           //                                  height: 0.0,
           //                                ),
           //                                Text(
           //                                    S
           //                                        .of(context)
           //                                        .categories, //"Categories",
           //                                    style: TextStyle(
           //                                        color: (categoryontapped)?ColorCodes.primaryColor:ColorCodes.lightgrey, fontSize: 10.0)),
           //                              ],
           //                            ),
           //                          );
           //                        }),
           //                  ),
           //                ],
           //              ),
           //            ),
                      Expanded(
                        flex:3,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            //color: ColorCodes.cyanColor,
                            color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              // Expanded(
                              //   child: Align(
                              //     alignment: Alignment.centerLeft,
                              //     child: Container(
                              //       child: Text("",
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    child: Text(widget.title!,
                                      style: TextStyle(
                                        fontSize: 17,

                                        color: ColorCodes.whiteColor,
                                        //color: ColorCodes.discount,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Expanded(
                              //     child: Align(
                              //       alignment: Alignment.centerRight,
                              //       child: Container(
                              //         child:  Icon(Icons.keyboard_arrow_right_sharp, size: 35, color: ColorCodes.lightblue,),
                              //       ),
                              //     )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )

                :MouseRegion(
              cursor: SystemMouseCursors.click,
              //grocbay design
              // child: Container(
              //   height: 80,
              //   padding: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10),
              //   color: ColorCodes.whiteColor,
              //   width: MediaQuery.of(context).size.width,
              //   child: GestureDetector(
              //     onTap: () {
              //       widget.onPressed!();
              //     },
              //     child: Container(
              //       padding: EdgeInsets.all(8),
              //       decoration: BoxDecoration(
              //         //color: ColorCodes.cyanColor,
              //         color: Features.ismultivendor?ColorCodes.greenColor:ColorCodes.lightBlueColor,
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       child: Row(
              //         children: <Widget>[
              //           Image.asset(
              //             Images.bag, height: 30, width: 30, color: IConstants.isEnterprise && Features.ismultivendor?ColorCodes.whiteColor:ColorCodes.lightblue,
              //           ),
              //           SizedBox(width: 5,),
              //           (_calculation.getTotal() == "0")? Text(_calculation.getItemCount(),  style: TextStyle(
              //             fontSize: 15,
              //             color: IConstants.isEnterprise && Features.ismultivendor?ColorCodes.whiteColor:ColorCodes.lightblue,
              //             fontWeight: FontWeight.w700,
              //           ),
              //           ):Column(
              //             mainAxisAlignment: (widget.total=="1")?MainAxisAlignment.center:MainAxisAlignment.start,
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text(_calculation.getItemCount(),  style: TextStyle(
              //                 fontSize: 15,
              //                 color: IConstants.isEnterprise && Features.ismultivendor?ColorCodes.whiteColor:ColorCodes.lightblue,
              //                 fontWeight: FontWeight.w700,
              //               ),
              //               ),
              //               SizedBox(height: 3,),
              //               (widget.total=="1")?SizedBox.shrink():
              //                   Features.ismultivendor?
              //                   Text(widget.title==S .current.proceed_pay?
              //                   Features.iscurrencyformatalign?widget.total !+ IConstants.currencyFormat:IConstants.currencyFormat+widget.total!:
              //                   Features.iscurrencyformatalign?
              //                   (IConstants.numberFormat == "1")?
              //                   (double.parse(widget.total !)+double.parse(widget.adonamount)).toStringAsFixed(0)+ IConstants.currencyFormat
              //                       :(double.parse(widget.total !)+double.parse(widget.adonamount)).toStringAsFixed(IConstants.decimaldigit) + IConstants.currencyFormat :
              //                   (IConstants.numberFormat == "1")?IConstants.currencyFormat +
              //                       (double.parse(widget.total !)+double.parse(widget.adonamount)).toStringAsFixed(0):IConstants.currencyFormat +
              //                       (double.parse(widget.total !)+double.parse(widget.adonamount)).toStringAsFixed(IConstants.decimaldigit),  style: TextStyle(
              //                     fontSize: 15,
              //                     color: IConstants.isEnterprise && Features.ismultivendor?ColorCodes.whiteColor:ColorCodes.lightblue,
              //                     fontWeight: FontWeight.bold,
              //                   ),):
              //               Text(widget.title==S .current.proceed_pay?
              //               Features.iscurrencyformatalign?widget.total !+ IConstants.currencyFormat:IConstants.currencyFormat+widget.total!:
              //                   Features.iscurrencyformatalign?
              //                   (IConstants.numberFormat == "1")?
              //                       (double.parse(_calculation.getTotal())+double.parse(widget.adonamount)).toStringAsFixed(0)+ IConstants.currencyFormat
              //                       :(double.parse(_calculation.getTotal())+double.parse(widget.adonamount)).toStringAsFixed(IConstants.decimaldigit) + IConstants.currencyFormat :
              //               (IConstants.numberFormat == "1")?IConstants.currencyFormat +
              //                  (double.parse(_calculation.getTotal())+double.parse(widget.adonamount)).toStringAsFixed(0):IConstants.currencyFormat +
              //                   (double.parse(_calculation.getTotal())+double.parse(widget.adonamount)).toStringAsFixed(IConstants.decimaldigit),  style: TextStyle(
              //                 fontSize: 15,
              //                 color: IConstants.isEnterprise && Features.ismultivendor?ColorCodes.whiteColor:ColorCodes.lightblue,
              //                 fontWeight: FontWeight.bold,
              //               ),),
              //             ],
              //           ),
              //           Spacer(),
              //           Text(widget.title!,
              //             style: TextStyle(
              //               fontSize: 18,
              //               color: IConstants.isEnterprise && Features.ismultivendor?ColorCodes.whiteColor:ColorCodes.lightblue,
              //               //color: ColorCodes.discount,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //           Icon(Icons.keyboard_arrow_right_sharp, size: 35, color: IConstants.isEnterprise && Features.ismultivendor?ColorCodes.whiteColor:ColorCodes.lightblue,),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),

              //.....24mantra related bottom navigation changes

              //24 mantra related changes
              child: Container(
                height: 80,
                padding: EdgeInsets.only(left: 5, top: 10, right: 5, bottom: 10),
                color: ColorCodes.whiteColor,
                width: MediaQuery.of(context).size.width,
                child: GestureDetector(
                  onTap: () {
                    widget.onPressed!();
                  },
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.start,

                        children: [
           //                Expanded(
           //                  flex:1,
           //                  child: Row(
           //                    mainAxisAlignment: MainAxisAlignment.start,
           //                    children: [
           //                      GestureDetector(
           //                        onTap: () {
           //                          setState(() {
           //                            homeontapped = true;
           //                            categoryontapped = false;
           //                          });
           //                          Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);
           //                        },
           //                        child: Column(
           //                          crossAxisAlignment: CrossAxisAlignment.start,
           //                          mainAxisAlignment: MainAxisAlignment.start,
           //                          children: <Widget>[
           //                            SizedBox(
           //                              height: 5.0,
           //                            ),
           //                            CircleAvatar(
           //                              radius: 13.0,
           //                              foregroundColor: Colors.white,
           //                              backgroundColor: Colors.transparent,
           //                              child: Image.asset(
           //                                Images.homeImg,
           //                                color: (homeontapped)?ColorCodes.primaryColor:ColorCodes.lightgrey,
           //                                width: 30,
           //                                height: 20,
           //                              ),
           //                            ),
           //                            SizedBox(
           //                              height: 0.0,
           //                            ),
           //                            Text(  S.of(context).home,
           //                                //  "Home",
           //                                style: TextStyle(
           //                                    color: (homeontapped)?ColorCodes.primaryColor:ColorCodes.lightgrey, fontSize: 10.0)),
           //                          ],
           //                        ),
           //                      ),
           //                      Padding(
           //                        padding: const EdgeInsets.only(left:8.0),
           //                        child: ValueListenableBuilder(
           //                            valueListenable: IConstants.currentdeliverylocation,
           //                            builder: (context, value, widget) {
           //                              return GestureDetector(
           //                                onTap: () {
           //                                  if (value != S
           //                                      .of(context)
           //                                      .not_available_location)
           //                                    /*Navigator.of(context).pushNamed(
           //   CategoryScreen.routeName,
           // );*/ setState(() {
           //                                    categoryontapped = true;
           //                                    homeontapped = false;
           //                                  });
           //                                  Navigation(context, name:Routename.Category, navigatore: NavigatoreTyp.Push);
           //                                },
           //                                child: Column(
           //                                  children: <Widget>[
           //                                    SizedBox(
           //                                      height: 5.0,
           //                                    ),
           //                                    CircleAvatar(
           //                                      radius: 13.0,
           //                                      backgroundColor: Colors.transparent,
           //                                      child: Image.asset(Images.categoriesImg,
           //                                        color: (categoryontapped)?ColorCodes.primaryColor:ColorCodes.lightgrey,
           //                                        width: 20,
           //                                        height: 30,),
           //                                    ),
           //                                    SizedBox(
           //                                      height: 0.0,
           //                                    ),
           //                                    Text(
           //                                        S
           //                                            .of(context)
           //                                            .categories, //"Categories",
           //                                        style: TextStyle(
           //                                            color: (categoryontapped)?ColorCodes.primaryColor:ColorCodes.lightgrey, fontSize: 10.0)),
           //                                  ],
           //                                ),
           //                              );
           //                            }),
           //                      ),
           //                    ],
           //                  ),
           //                ),
                          Expanded(
                            flex:3,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                //color: ColorCodes.cyanColor,
                                color: Features.ismultivendor?ColorCodes.greenColor:ColorCodes.varcolor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Image.asset(
                                    Images.bag, height: 30, width: 30, color: IConstants.isEnterprise && Features.ismultivendor?ColorCodes.whiteColor:IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                                  ),
                                  SizedBox(width: 5,),
                                  (_calculation.getTotal() == "0")? Text(_calculation.getItemCount(),  style: TextStyle(
                                    fontSize: 15,
                                    color: IConstants.isEnterprise && Features.ismultivendor?ColorCodes.whiteColor:IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  ):Column(
                                    mainAxisAlignment: (widget.total=="1")?MainAxisAlignment.center:MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(_calculation.getItemCount(),  style: TextStyle(
                                        fontSize: 15,
                                        color: IConstants.isEnterprise && Features.ismultivendor?ColorCodes.whiteColor:IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      ),
                                      SizedBox(height: 3,),
                                      (widget.total=="1")?SizedBox.shrink():
                                      Features.ismultivendor?
                                      Text(widget.title==S .current.proceed_pay?
                                      Features.iscurrencyformatalign?widget.total !+ IConstants.currencyFormat:IConstants.currencyFormat+widget.total!:
                                      Features.iscurrencyformatalign?
                                      (IConstants.numberFormat == "1")?
                                      (double.parse(widget.total !)+double.parse(widget.adonamount)).toStringAsFixed(0)+ IConstants.currencyFormat
                                          :(double.parse(widget.total !)+double.parse(widget.adonamount)).toStringAsFixed(IConstants.decimaldigit) + IConstants.currencyFormat :
                                      (IConstants.numberFormat == "1")?IConstants.currencyFormat +
                                          (double.parse(widget.total !)+double.parse(widget.adonamount)).toStringAsFixed(0):IConstants.currencyFormat +
                                          (double.parse(widget.total !)+double.parse(widget.adonamount)).toStringAsFixed(IConstants.decimaldigit),  style: TextStyle(
                                        fontSize: 15,
                                        color: IConstants.isEnterprise && Features.ismultivendor?ColorCodes.whiteColor:IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                                        fontWeight: FontWeight.bold,
                                      ),):
                                      Text(widget.title==S .current.proceed_pay?
                                      Features.iscurrencyformatalign?widget.total !+ IConstants.currencyFormat:IConstants.currencyFormat+widget.total!:
                                      Features.iscurrencyformatalign?
                                      (IConstants.numberFormat == "1")?
                                      (double.parse(_calculation.getTotal())+double.parse(widget.adonamount)).toStringAsFixed(0)+ IConstants.currencyFormat
                                          :(double.parse(_calculation.getTotal())+double.parse(widget.adonamount)).toStringAsFixed(IConstants.decimaldigit) + IConstants.currencyFormat :
                                      (IConstants.numberFormat == "1")?IConstants.currencyFormat +
                                          (double.parse(_calculation.getTotal())+double.parse(widget.adonamount)).toStringAsFixed(0):IConstants.currencyFormat +
                                          (double.parse(_calculation.getTotal())+double.parse(widget.adonamount)).toStringAsFixed(IConstants.decimaldigit),  style: TextStyle(
                                        fontSize: 15,
                                        color: IConstants.isEnterprise && Features.ismultivendor?ColorCodes.whiteColor:IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                    ],
                                  ),

                                  Spacer(),
                                  Text(widget.title!,
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: IConstants.isEnterprise && Features.ismultivendor?ColorCodes.whiteColor:IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                                      //color: ColorCodes.discount,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(Icons.keyboard_arrow_right_sharp, size: 35, color: IConstants.isEnterprise && Features.ismultivendor?ColorCodes.whiteColor:IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,),
                                ],
                              ),
                            ),
                          )

                        ],
                      )
                  ),




                ),
              ),


            );
          else if(widget.itemCount == "1 Items"){
            debugPrint("1 Items......");
            // return MouseRegion(
            //   cursor: SystemMouseCursors.click,
            //   child: Container(
            //     height: 80,
            //     padding: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10),
            //     color: ColorCodes.whiteColor,
            //     width: MediaQuery.of(context).size.width,
            //     child: GestureDetector(
            //       onTap: () {
            //         widget.onPressed!();
            //       },
            //       child: Container(
            //         padding: EdgeInsets.all(8),
            //         decoration: BoxDecoration(
            //           //color: ColorCodes.cyanColor,
            //           color: Features.ismultivendor?ColorCodes.greenColor:ColorCodes.lightBlueColor,
            //           borderRadius: BorderRadius.circular(10),
            //         ),
            //         child: Row(
            //           children: <Widget>[
            //             Image.asset(
            //               Images.bag, height: 30, width: 30, color: IConstants.isEnterprise && Features.ismultivendor?ColorCodes.whiteColor:ColorCodes.lightblue,
            //             ),
            //             SizedBox(width: 5,),
            //             Column(
            //               mainAxisAlignment: MainAxisAlignment.start,
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text("1 Items",  style: TextStyle(
            //                   fontSize: 15,
            //                   color: IConstants.isEnterprise && Features.ismultivendor?ColorCodes.whiteColor:ColorCodes.lightblue,
            //                   fontWeight: FontWeight.w700,
            //                 ),
            //                 ),
            //                 SizedBox(height: 3,),
            //                 Text(
            //                   Features.ismultivendor?
            //                   Features.iscurrencyformatalign?
            //                   widget.title==S .current.confirm_order?_calculation.getTotal(): widget.total!/*widget.total!*/ + IConstants.currencyFormat:
            //                   IConstants.currencyFormat +
            //                       (widget.title==S .current.confirm_order?_calculation.getTotal():widget.total!/*widget.total!*/):
            //                   Features.iscurrencyformatalign?
            //                   widget.title==S .current.confirm_order?_calculation.getTotal(): _calculation.getTotal()/*widget.total!*/ + IConstants.currencyFormat:
            //                   IConstants.currencyFormat +
            //                       (widget.title==S .current.confirm_order?_calculation.getTotal():_calculation.getTotal()/*widget.total!*/),  style: TextStyle(
            //                   fontSize: 15,
            //                   color: IConstants.isEnterprise && Features.ismultivendor?ColorCodes.whiteColor:ColorCodes.lightblue,
            //                   fontWeight: FontWeight.bold,
            //                 ),),
            //               ],
            //             ),
            //             Spacer(),
            //             Text(widget.title!,
            //               style: TextStyle(
            //                 fontSize: 18,
            //                 color: IConstants.isEnterprise && Features.ismultivendor?ColorCodes.whiteColor:ColorCodes.lightblue,
            //                 //color: ColorCodes.discount,
            //                 fontWeight: FontWeight.bold,
            //               ),
            //             ),
            //             Icon(Icons.keyboard_arrow_right_sharp, size: 35, color: IConstants.isEnterprise && Features.ismultivendor?ColorCodes.whiteColor:ColorCodes.lightblue,),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // );

            //24 mantra related chnages

            //24 mantra design chnages
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                height: 80,
                padding: EdgeInsets.only(left: 5, top: 10, right: 5, bottom: 10),
                color: ColorCodes.whiteColor,
                width: MediaQuery.of(context).size.width,
                child: GestureDetector(
                  onTap: () {
                    widget.onPressed!();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
           //            Expanded(
           //              flex:1,
           //              child: Row(
           //                mainAxisAlignment: MainAxisAlignment.start,
           //                children: [
           //                  GestureDetector(
           //                    onTap: () {
           //                      setState(() {
           //                        homeontapped = true;
           //                        categoryontapped = false;
           //                      });
           //                      Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);
           //                    },
           //                    child: Column(
           //                      crossAxisAlignment: CrossAxisAlignment.start,
           //                      mainAxisAlignment: MainAxisAlignment.start,
           //                      children: <Widget>[
           //                        SizedBox(
           //                          height: 5.0,
           //                        ),
           //                        CircleAvatar(
           //                          radius: 13.0,
           //                          foregroundColor: Colors.white,
           //                          backgroundColor: Colors.transparent,
           //                          child: Image.asset(
           //                            Images.homeImg,
           //                            color: (homeontapped)?ColorCodes.primaryColor:ColorCodes.lightgrey,
           //                            width: 30,
           //                            height: 20,
           //                          ),
           //                        ),
           //                        SizedBox(
           //                          height: 0.0,
           //                        ),
           //                        Text(  S.of(context).home,
           //                            //  "Home",
           //                            style: TextStyle(
           //                                color: (homeontapped)?ColorCodes.primaryColor:ColorCodes.lightgrey, fontSize: 10.0)),
           //                      ],
           //                    ),
           //                  ),
           //                  Padding(
           //                    padding: const EdgeInsets.only(left:8.0),
           //                    child: ValueListenableBuilder(
           //                        valueListenable: IConstants.currentdeliverylocation,
           //                        builder: (context, value, widget) {
           //                          return GestureDetector(
           //                            onTap: () {
           //                              if (value != S
           //                                  .of(context)
           //                                  .not_available_location)
           //                                /*Navigator.of(context).pushNamed(
           //   CategoryScreen.routeName,
           // );*/                           setState(() {
           //                                categoryontapped = true;
           //                                homeontapped = false;
           //                              });
           //                              Navigation(context, name:Routename.Category, navigatore: NavigatoreTyp.Push);
           //                            },
           //                            child: Column(
           //                              children: <Widget>[
           //                                SizedBox(
           //                                  height: 5.0,
           //                                ),
           //                                CircleAvatar(
           //                                  radius: 13.0,
           //                                  backgroundColor: Colors.transparent,
           //                                  child: Image.asset(Images.categoriesImg,
           //                                    color: (categoryontapped)?ColorCodes.primaryColor:ColorCodes.lightgrey,
           //                                    width: 20,
           //                                    height: 30,),
           //                                ),
           //                                SizedBox(
           //                                  height: 0.0,
           //                                ),
           //                                Text(
           //                                    S
           //                                        .of(context)
           //                                        .categories, //"Categories",
           //                                    style: TextStyle(
           //                                        color: (categoryontapped)?ColorCodes.primaryColor:ColorCodes.lightgrey, fontSize: 10.0)),
           //                              ],
           //                            ),
           //                          );
           //                        }),
           //                  ),
           //                ],
           //              ),
           //            ),
                      Expanded(
                        flex:3,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            //color: ColorCodes.cyanColor,
                            color: Features.ismultivendor?ColorCodes.greenColor:ColorCodes.varcolor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Image.asset(
                                Images.bag, height: 30, width: 30, color: IConstants.isEnterprise && Features.ismultivendor?ColorCodes.whiteColor:IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                              ),
                              SizedBox(width: 5,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(/*"1 Items"*/S.of(context).one_product,  style: TextStyle(
                                    fontSize: 15,
                                    color: IConstants.isEnterprise && Features.ismultivendor?ColorCodes.whiteColor:IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  ),
                                  SizedBox(height: 3,),
                                  Text(
                                    Features.ismultivendor?
                                    Features.iscurrencyformatalign?
                                    widget.title==S .current.confirm_order?_calculation.getTotal(): widget.total!/*widget.total!*/ + IConstants.currencyFormat:
                                    IConstants.currencyFormat +
                                        (widget.title==S .current.confirm_order?_calculation.getTotal():widget.total!/*widget.total!*/):
                                    Features.iscurrencyformatalign?
                                    widget.title==S .current.confirm_order?_calculation.getTotal(): /*_calculation.getTotal()*/widget.total! + IConstants.currencyFormat:
                                    IConstants.currencyFormat +
                                        (widget.title==S .current.confirm_order?_calculation.getTotal():/*_calculation.getTotal()*/widget.total!),  style: TextStyle(
                                    fontSize: 15,
                                    color: IConstants.isEnterprise && Features.ismultivendor?ColorCodes.whiteColor:IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                ],
                              ),
                              Spacer(),
                              Text(widget.title!,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: IConstants.isEnterprise && Features.ismultivendor?ColorCodes.whiteColor:IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                                  //color: ColorCodes.discount,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(Icons.keyboard_arrow_right_sharp, size: 35, color: IConstants.isEnterprise && Features.ismultivendor?ColorCodes.whiteColor:IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          else
            return  SizedBox.shrink();
        }
    );
  }
}
class CartCalculation{
  String getTotal(){
    print("cart calculation,..."+CartCalculations.checkmembership.toString());
    return CartCalculations.checkmembership ? (IConstants.numberFormat == "1")
        ?(CartCalculations.totalMember).toStringAsFixed(0):(CartCalculations.totalMember).toStringAsFixed(IConstants.decimaldigit)
        :
    (IConstants.numberFormat == "1")
        ?(CartCalculations.total).toStringAsFixed(0):(CartCalculations.total).toStringAsFixed(IConstants.decimaldigit);
  }
  String getItemCount() {
    return CartCalculations.itemCount.toString() + " " + S .current.items;
  }
}