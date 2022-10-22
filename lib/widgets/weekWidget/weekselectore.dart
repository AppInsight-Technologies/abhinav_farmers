import 'dart:io';

import 'package:flutter/material.dart';
import '../../assets/ColorCodes.dart';
import '../../generated/l10n.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/weekmodels.dart';
import 'package:velocity_x/velocity_x.dart';

class WeekSelector extends StatefulWidget {
  WeekSelector({Key? key,this.onclick,required this.daily,required this.dailyDays,required this.weekend,required this.weekendDays,required this.weekday,required this.weekdayDays,required this.custom,required this.alternativeDays, required this.customDays, required this.paymentMode, required this.selectedDate}) : super(key: key);
  Function(List<Weeks>,String)? onclick;
  String daily="";
  String dailyDays="";
  String weekend="";
  String weekendDays="";
  String weekday="";
  String weekdayDays="";
  String custom="";
  String alternativeDays="";
  String customDays="";
  String paymentMode = "";
  DateTime selectedDate;

  @override
  _WeekSelectorState createState() => _WeekSelectorState();
}

class _WeekSelectorState extends State<WeekSelector> {
  final List<Weeks> weekslist = Weeks().getweeks();
  var _daily = Colors.transparent;
  var _weekdays = Colors.transparent;
  var _weekends = Colors.transparent;
  var _custom = Colors.transparent;
  var _alternativeDays = Colors.transparent;
  double _dailyWidth = 1.0;
  double _weekdaysWidth = 1.0;
  double _weekendsWidth = 1.0;
  double _customWidth = 1.0;
   bool isSelected = true;
  String type="";
  bool _isWeb =false;
  bool iphonex = false;
  List dailydayslist = [];
  List weekendlist = [];
  List weekdayslist = [];


  List customlist = [];
  bool customselection = false;
  bool alternativeDaysSelection = false;
  final double spacerWidth = 15;
   List<Map> data = [];
@override
  void initState() {
  customlist.clear();
  print(widget.selectedDate.day);
  if(widget.daily == "0" && widget.weekday == "0" && widget.weekend == "0" && widget.custom == "0"  && widget.alternativeDays == "1"){
    int weekDay = widget.selectedDate.weekday;
    alternativeDaysSelection = true;
    for(int i=0; i< weekslist.length;i++){

    }

  }if(widget.daily == "0" && widget.weekday == "0" && widget.weekend == "0" && widget.custom == "1" && widget.alternativeDays == "0"){
    customselection = true;
  }else if(widget.daily == "1" && widget.weekday == "0" && widget.weekend == "0" && widget.custom == "0" && widget.alternativeDays == "0"){
    for(int i=0; i<weekslist.length;i++)
        weekslist[i].isselected = true;
  }else if(widget.daily == "0" && widget.weekday == "1" && widget.weekend == "0" && widget.custom == "0" && widget.alternativeDays == "0"){
    for(int i=0; i< weekslist.length;i++)weekslist[i].isselected = false;
    for(int i=0; i< weekslist.length-2;i++)
       weekslist[i].isselected = true;
  }else if(widget.daily == "0" && widget.weekday == "0" && widget.weekend == "1" && widget.custom == "0" && widget.alternativeDays == "0"){
    for(int i=0; i< weekslist.length;i++)weekslist[i].isselected = false;
    for(int i=0; i< weekslist.length-2;i++)weekslist[i].isselected = false;
    for(int i=0; i<weekslist.length;i++) {
      weekslist [5].isselected = true;
      weekslist[6].isselected = true;
    }
  }else if(widget.daily == "0" && widget.weekday == "1" &&( widget.weekend == "1" || widget.weekend == "0") && (widget.custom == "1" || widget.custom == "0") ){
    for(int i=0; i< weekslist.length;i++)weekslist[i].isselected = false;
    for(int i=0; i< weekslist.length-2;i++)
      weekslist[i].isselected = true;
  }else if(widget.daily == "0" && widget.weekday == "0" && widget.weekend == "1" && (widget.custom == "1" || widget.custom == "0")){
    for(int i=0; i< weekslist.length;i++)weekslist[i].isselected = false;
    for(int i=0; i< weekslist.length-2;i++)weekslist[i].isselected = false;
    for(int i=0; i<weekslist.length;i++) {
      weekslist [5].isselected = true;
      weekslist[6].isselected = true;
    }
  }

  if(widget.custom != "0")
    customlist.addAll(widget.customDays.split(","));

  data = List.generate(customlist.length,
          (index) => {'id': index, 'name': customlist[index], 'isSelected': false});
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
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

    dailydayslist.clear();
    if(widget.daily != "0")
      dailydayslist.addAll(widget.dailyDays.split(","));
    debugPrint("dailydayslist..."+dailydayslist.toString());

    weekdayslist.clear();
    if(widget.weekday != "0")
      weekdayslist.addAll(widget.weekdayDays.split(","));
    debugPrint("dailydayslist...1"+weekdayslist.toString());

    weekendlist.clear();
    if(widget.weekend != "0")
      weekendlist.addAll(widget.weekendDays.split(","));
    debugPrint("dailydayslist...2"+weekendlist.toString());




    debugPrint("dailydayslist...3"+customlist.toString()+"..."+customlist.length.toString());

    String activelang =  ( VxState.store as GroceStore).language.language.code!;
    return Container(
      width: MediaQuery.of(context).size.width,
     height: widget.paymentMode == "0" ? (!alternativeDaysSelection ? 140: 140-50) : (!alternativeDaysSelection ? 165 : 165 - 50),
      //height: widget.paymentMode == "0" ? 140: 165,
      child: Column(
        children: [
          widget.paymentMode != "0"?
          Container(
            padding: EdgeInsets.only(left: 10,right: 10,bottom: 5,top: 5),
            width: MediaQuery.of(context).size.width,
            height: 45,
            decoration: BoxDecoration(
              color: Color(0xffFFE4E4),
              border: Border.all(color: ColorCodes.mediumgren),
              borderRadius: BorderRadius.all(Radius.circular(3)),
            ),
            child: Center(
              child: Text(S.of(context).wallet_message ,
                maxLines: 2,
                style:TextStyle(fontSize: 12,color: ColorCodes.redColor),),
            ),
          ):SizedBox.shrink(),
          Row(
            children: [

            /*  Text(
                S .of(context).repeat,//"Repeat",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(width: 10,),*/
              Text(
                type,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              /*Spacer(),
                              Icon(Icons.arrow_forward_ios, color: Colors.black,size: 10,),
                              SizedBox(width: 12,),*/
            ],
          ),
          SizedBox(height: 10,),
          Container(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
               // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if(widget.daily == "1")
                    GestureDetector(
                    onTap: (){

                      for(int i=0; i<weekslist.length;i++)
                      setState((){
                        weekslist[i].isselected = true;
                        type= S .current.daily;
                        widget.onclick!(weekslist,type);
                      });
                      _daily = ColorCodes.varcolor;
                       _dailyWidth = 2.0;
                       _weekdaysWidth = 1.0;
                       _weekendsWidth = 1.0;
                      _weekdays = Colors.white;
                      _weekends = Colors.white;
                      _custom= Colors.white;
                      _alternativeDays = Colors.white;
                      customselection = false;
                      alternativeDaysSelection = false;
                      debugPrint("hihihi.."+weekslist.toList.toString());
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 10,right: 10),
                   //   width: _isWeb ? MediaQuery.of(context).size.width/7 :MediaQuery.of(context).size.width/3.5 ,
                      height: (activelang == "en") ? 40 :70,
                     // color: _daily,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide( color: ColorCodes.varcolor,width: _dailyWidth),
                          bottom: BorderSide(  color: ColorCodes.varcolor,width: _dailyWidth),
                          left: BorderSide(  color: ColorCodes.varcolor,width: _dailyWidth),
                          right: BorderSide(  color: ColorCodes.varcolor,width: _dailyWidth),
                        ),
                        color: _daily,
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                      ),
                      child: Center(child: Text(
                          S .of(context).daily,//"Daily"
                        style: TextStyle(
                            color: ColorCodes.greenColor,
                            fontWeight: FontWeight.bold
                        ),
                      )),
                    ),
                  ),
                  if(widget.daily == "1")
                    SizedBox(width: spacerWidth),
                  if(widget.weekday == "1")
                  GestureDetector(
                    onTap: (){
                      //debugPrint("hello..."+"  "+(weekslist.length-2).toString());

                      for(int i=0; i< weekslist.length;i++)weekslist[i].isselected = false;
                      for(int i=0; i< weekslist.length-2;i++)
                        setState((){
                          type= S .current.weekdays;

                          weekslist[i].isselected = true;
                          debugPrint("hello..."+weekslist[i].toString());
                        });
                      widget.onclick!(weekslist,type);
                      _daily = Colors.white;
                      _weekdays = ColorCodes.varcolor;
                      _weekends = Colors.white;
                      _custom= Colors.white;
                      _alternativeDays = Colors.white;
                       _dailyWidth = 1.0;
                       _weekdaysWidth = 2.0;
                       _weekendsWidth = 1.0;
                      customselection = false;
                      alternativeDaysSelection = false;
                    },
                    child: Container(
                  //    width: (activelang == "en") ?  _isWeb ? MediaQuery.of(context).size.width/7 :MediaQuery.of(context).size.width/3.5:90,
                      height: (activelang == "en") ? 40 :70,
                     // color: _weekdays,
                      padding: EdgeInsets.only(left: 10,right: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(  color: ColorCodes.varcolor,width: _weekdaysWidth),
                          bottom: BorderSide(  color: ColorCodes.varcolor,width: _weekdaysWidth),
                          left: BorderSide(  color: ColorCodes.varcolor,width: _weekdaysWidth),
                          right: BorderSide(  color: ColorCodes.varcolor,width: _weekdaysWidth),
                        ),
                        color: _weekdays,
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                      ),
                      child: Center(child: Text(
                        S .of(context).weekdays,//"Weekdays"
                        style: TextStyle(
                            color: ColorCodes.greenColor,
                            fontWeight: FontWeight.bold
                        ),
                      )),
                    ),
                  ),
                  if(widget.weekday == "1")
                  //Spacer(),
                    SizedBox(width: spacerWidth),
                  if(widget.weekend == "1")
                  GestureDetector(
                    onTap: (){
                      for(int i=0; i< weekslist.length;i++)weekslist[i].isselected = false;
                      for(int i=0; i< weekslist.length-2;i++)weekslist[i].isselected = false;
                      for(int i=0; i<weekslist.length;i++)
                        setState((){
                          weekslist [5].isselected = true;
                          weekslist[6].isselected = true;
                          type= S .current.weekends;

                        });
                      widget.onclick!(weekslist,type);
                      _daily = Colors.white;
                      _weekdays = Colors.white;
                      _weekends = ColorCodes.varcolor;
                      _custom= Colors.white;
                      _alternativeDays = Colors.white;
                      _dailyWidth = 1.0;
                       _weekdaysWidth = 1.0;
                       _weekendsWidth = 2.0;
                      customselection = false;
                      alternativeDaysSelection = false;
                    },
                    child: Container(
                    // width:(activelang == "en") ?_isWeb ? MediaQuery.of(context).size.width/7 : MediaQuery.of(context).size.width/3.5 :90,
                     height: (activelang == "en") ? 40 :70,
                      padding: EdgeInsets.only(left: 2,right: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(  color: ColorCodes.varcolor,width: _weekendsWidth),
                          bottom: BorderSide(  color: ColorCodes.varcolor,width: _weekendsWidth),
                          left: BorderSide(  color: ColorCodes.varcolor,width: _weekendsWidth),
                          right: BorderSide(  color: ColorCodes.varcolor,width: _weekendsWidth),

                        ),
                        color: _weekends,
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                      ),
                    //  color: _weekends,
                      child: Center(child: Text(
                        S .of(context).weekends,//"Weekends"
                        style: TextStyle(
                          color: ColorCodes.greenColor,
                          fontWeight: FontWeight.bold
                        ),
                      )),
                    ),
                  ),
                  if(widget.weekend == "1")
                    SizedBox(width: spacerWidth),
                  if(widget.custom == "1")
                    GestureDetector(
                      onTap: (){
                        for(int i=0; i< weekslist.length;i++)weekslist[i].isselected = false;
                        for(int i=0; i< weekslist.length-2;i++)weekslist[i].isselected = false;
                        weekslist  [5].isselected = false;
                        weekslist[6].isselected = false;
                       // for(int i=0; i<weekslist.length;i++)
                          setState((){
                           /* customlist[i].isselected = true;
                            customlist[i].isselected = true;*/
                            customselection = true;
                            type= S .current.custom;

                          });
                        widget.onclick!(weekslist,type);
                        _daily = Colors.white;
                        _weekdays = Colors.white;
                        _weekends = Colors.white;
                        _custom = ColorCodes.varcolor;
                        _alternativeDays = Colors.white;
                        _dailyWidth = 1.0;
                        _weekdaysWidth = 1.0;
                        _weekendsWidth = 1.0;
                        _customWidth = 2.0;
                        alternativeDaysSelection = false;
                      },
                      child: Container(
                        height: (activelang == "en") ? 40 :70,
                        padding: EdgeInsets.only(left: 10,right: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(  color: ColorCodes.varcolor,width: _customWidth),
                            bottom: BorderSide(  color: ColorCodes.varcolor,width: _customWidth),
                            left: BorderSide(  color: ColorCodes.varcolor,width: _customWidth),
                            right: BorderSide(  color: ColorCodes.varcolor,width: _customWidth),

                          ),
                          color: _custom,
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                        ),
                        //  color: _weekends,
                        child: Center(child: Text(
                          S .of(context).custom,
                          style: TextStyle(
                              color: ColorCodes.greenColor,
                              fontWeight: FontWeight.bold
                          ),
                        )),
                      ),
                    ),
                  if(widget.custom == "1")
                    SizedBox(width: spacerWidth),
                 if(widget.alternativeDays == "1")
                  GestureDetector(
                    onTap: (){
                      for(int i=0; i< weekslist.length;i++)weekslist[i].isselected = false;
                      for(int i=0; i< weekslist.length-2;i++)weekslist[i].isselected = false;
                      weekslist[5].isselected = false;
                      weekslist[6].isselected = false;
                      setState((){
                        alternativeDaysSelection = true;
                        type= S .of(context).alternative;

                      });
                      widget.onclick!(weekslist,type);
                      _daily = Colors.white;
                      _weekdays = Colors.white;
                      _weekends = Colors.white;
                      _custom  = Colors.white;
                      _alternativeDays = ColorCodes.varcolor;
                      customselection = false;
                      _dailyWidth = 1.0;
                      _weekdaysWidth = 1.0;
                      _weekendsWidth = 1.0;
                      _customWidth = 2.0;
                    },
                    child: Container(
                      height: (activelang == "en") ? 40 :70,
                      padding: EdgeInsets.only(left: 10,right: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(  color: ColorCodes.varcolor,width: _customWidth),
                          bottom: BorderSide(  color: ColorCodes.varcolor,width: _customWidth),
                          left: BorderSide(  color: ColorCodes.varcolor,width: _customWidth),
                          right: BorderSide(  color: ColorCodes.varcolor,width: _customWidth),

                        ),
                        color: _alternativeDays,
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                      ),
                      //  color: _weekends,
                      child: Center(child: Text(
                       S .of(context).alternative,
                        style: TextStyle(
                            color: ColorCodes.greenColor,
                            fontWeight: FontWeight.bold
                        ),
                      )),
                    ),
                  ),
                  if(widget.alternativeDays == "1")
                    SizedBox(width: spacerWidth),

                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          (customselection == true)?
          Container(
            //padding: EdgeInsets.only(left: 10),
            // width:45,
            height: 30,
            child:ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.all(0.0),
              itemCount: /*customlist.length*/data.length,
              itemBuilder: (_, i)
              {
                debugPrint("i........"+data[i].toString());
                           return    GestureDetector(
                             onTap: () {
                               setState(() {
                                 data[i]['isSelected'] = !data[i]['isSelected'];
                               });
                               if(data[i]['name'].toString() == "mon"){
                                 weekslist[0].isselected = true;
                               }else if(data[i]['name'].toString() == "tue"){
                                 weekslist[1].isselected = true;
                               }else if(data[i]['name'].toString() == "wed"){
                                 weekslist[2].isselected = true;
                               }else if(data[i]['name'].toString() == "thu"){
                                 weekslist[3].isselected = true;
                               }else if(data[i]['name'].toString() == "fri"){
                                 weekslist[4].isselected = true;
                               }else if(data[i]['name'].toString() == "sat"){
                                 weekslist[5].isselected = true;
                               }else if(data[i]['name'].toString() == "sun"){
                                 weekslist[6].isselected = true;

                               }

                               widget.onclick!(weekslist,S .of(context).custom);
                               debugPrint("weekslist[i]..."+weekslist.toString());
                             },
                             child: Container(
                               margin: EdgeInsets.only(left: 10,right: 10),
                                width:45,
                               height: 30,
                               decoration: BoxDecoration(
                                 color: data[i]['isSelected'] == true?ColorCodes.varcolor:Colors.transparent,
                                 border: Border.all(color:data[i]['isSelected'] == true? ColorCodes.varcolor: ColorCodes.varcolor),
                                 borderRadius: BorderRadius.all(Radius.circular(3)),
                               ),  child: Center(
                                        child: Text(
                                          data[i]['name'],
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: ColorCodes.greenColor),
                                    ))),
                           );
                            }),

          ):
         alternativeDaysSelection ? SizedBox.shrink(): Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             // SizedBox(width: 20,),

              ...weekslist.map((e) {
             return   (widget.daily == "1")?
             Container(
               //padding: EdgeInsets.only(left: 10),
               width:45,
               height: 30,
               decoration: BoxDecoration(
                 color: e.isselected?ColorCodes.varcolor:Colors.transparent,
                 border: Border.all(color:e.isselected? ColorCodes.varcolor: ColorCodes.varcolor),
                 borderRadius: BorderRadius.all(Radius.circular(3)),
               ),
               child: Center(child: Text(e.weekname,style:TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: ColorCodes.greenColor),)),
             )
                    :(widget.weekend == "1")?
             Container(
               //padding: EdgeInsets.only(left: 10),
               width:45,
               height: 30,
               decoration: BoxDecoration(
                 color: e.isselected?ColorCodes.varcolor:Colors.transparent,
                 border: Border.all(color:e.isselected? ColorCodes.varcolor: ColorCodes.varcolor),
                 borderRadius: BorderRadius.all(Radius.circular(3)),
               ),
               child: Center(child: Text(e.weekname,style:TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: ColorCodes.greenColor),)),
             )
                    :(widget.weekday == "1")?
             Container(
               //padding: EdgeInsets.only(left: 10),
               width:45,
               height: 30,
               decoration: BoxDecoration(
                 color: e.isselected?ColorCodes.varcolor:Colors.transparent,
                 border: Border.all(color:e.isselected? ColorCodes.varcolor: ColorCodes.varcolor),
                 borderRadius: BorderRadius.all(Radius.circular(3)),
               ),
               child: Center(child: Text(e.weekname,style:TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: ColorCodes.greenColor),)),
             )

                    :SizedBox.shrink();
                }),
              // (widget.daily == "1")?
              // ListView.builder(
              //     shrinkWrap: true,
              //     //scrollDirection: Axis.vertical,
              //     physics: AlwaysScrollableScrollPhysics(),
              //     itemCount: dailydayslist.length,
              //     itemBuilder: (_, i) {
              //       return  Container(
              //         //padding: EdgeInsets.only(left: 10),
              //         width:45,
              //         height: 30,
              //         decoration: BoxDecoration(
              //           color: /*e.isselected?*/ColorCodes.mediumgren/*:Colors.transparent*/,
              //           border: Border.all(color:/*e.isselected?*/ ColorCodes.mediumgren/*: ColorCodes.mediumgren*/),
              //           borderRadius: BorderRadius.all(Radius.circular(3)),
              //         ),
              //         child: Center(child: Text(dailydayslist[i],style:TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: ColorCodes.greenColor),)),
              //       );
              //     }):(widget.weekday == "1")?
              // ListView.builder(
              //     shrinkWrap: true,
              //    // scrollDirection: Axis.vertical,
              //     physics: AlwaysScrollableScrollPhysics(),
              //     itemCount: weekdayslist.length,
              //     itemBuilder: (_, i) {
              //       return  Container(
              //         //padding: EdgeInsets.only(left: 10),
              //         width:45,
              //         height: 30,
              //         decoration: BoxDecoration(
              //           color: /*e.isselected?*/ColorCodes.mediumgren/*:Colors.transparent*/,
              //           border: Border.all(color:/*e.isselected?*/ ColorCodes.mediumgren/*: ColorCodes.mediumgren*/),
              //           borderRadius: BorderRadius.all(Radius.circular(3)),
              //         ),
              //         child: Center(child: Text(weekdayslist[i],style:TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: ColorCodes.greenColor),)),
              //       );
              //     }):(widget.weekend == "1")?
              // ListView.builder(
              //     shrinkWrap: true,
              //    // scrollDirection: Axis.vertical,
              //     physics: AlwaysScrollableScrollPhysics(),
              //     itemCount: weekendlist.length,
              //     itemBuilder: (_, i) {
              //       return  Container(
              //         //padding: EdgeInsets.only(left: 10),
              //         width:45,
              //         height: 30,
              //         decoration: BoxDecoration(
              //           color: /*e.isselected?*/ColorCodes.mediumgren/*:Colors.transparent*/,
              //           border: Border.all(color:/*e.isselected?*/ ColorCodes.mediumgren/*: ColorCodes.mediumgren*/),
              //           borderRadius: BorderRadius.all(Radius.circular(3)),
              //         ),
              //         child: Center(child: Text(weekendlist[i],style:TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: ColorCodes.greenColor),)),
              //       );
              //     }):
              // Container(
              //   width:45,
              //   height: 30,
              //   child: ListView.builder(
              //       shrinkWrap: true,
              //       scrollDirection: Axis.vertical,
              //       physics: AlwaysScrollableScrollPhysics(),
              //       itemCount: customlist.length,
              //       itemBuilder: (_, i) {
              //         debugPrint("customlist[i]..."+customlist[i].toString()+"...."+customlist.length.toString());
              //         return  Container(
              //           //padding: EdgeInsets.only(left: 10),
              //           width:45,
              //           height: 30,
              //           decoration: BoxDecoration(
              //             color: /*e.isselected?*/ColorCodes.mediumgren/*:Colors.transparent*/,
              //             border: Border.all(color:/*e.isselected?*/ ColorCodes.mediumgren/*: ColorCodes.mediumgren*/),
              //             borderRadius: BorderRadius.all(Radius.circular(3)),
              //           ),
              //           child: Center(child: Text(customlist[i],style:TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: ColorCodes.greenColor),)),
              //         );
              //       }),
              // )

            ],
          ),

        ],
      ),
    );

  }
}
