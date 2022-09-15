
// app...............................


import '../rought_genrator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../widgets/addresswidget/address_info.dart';



class AddressWeb with Navigations{
  String? addresstype;
  String? addressid="";
  String? delieveryLocation="";
  String? latitude="";
  String? longitude="";
  String? branch="";
  String? houseNo="";
  String? apartment="";
  String? street="";
  String? landmark="";
  String? area="";
  String? pincode="";
  String? orderid= "";
  String? title= "";
  String? itemid="";
  String? itemname ="";
  String? itemimg ="";
  String? varname ="";
  String? varmrp = "";
  String? varprice="";
  String? paymentMode="";
  String? cronTime="";
  String? name="";
  String? varid="";
  String? brand="";
  String? deliveriesarry ="";
  String? daily="";
  String? dailyDays="";
  String? weekend="";
  String? weekendDays="";
  String? weekday="";
  String? weekdayDays="";
  String? custom="";
  String? alternativeDays="";
  String? customDays="";
  String? weight="";
  AddressWeb(context,{Function(bool)? result,this.addresstype,this.addressid,this.delieveryLocation,this.latitude,
    this.longitude,this.branch,this.houseNo,this.apartment,this.street,this.landmark,this.area,this.pincode,
    this.orderid,this.title,this.itemid,this.itemname,this.itemimg,this.varname,this.varmrp,this.varprice,this.paymentMode,
    this.cronTime,this.name,this.varid,this.brand,this.deliveriesarry,this.daily,this.dailyDays,this.weekday,this.weekend,
    this.weekendDays,this.weekdayDays,this.custom,this.alternativeDays,this.customDays,this.weight}){
    _dialogforAddress(context);
  }
  _dialogforAddress(context) {
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
                    child: AddressInfo(addressid,addresstype,delieveryLocation,
                      latitude,  longitude, branch,area,title, varid, name,
                       apartment, brand,cronTime, custom, customDays, daily,
                      dailyDays, deliveriesarry, houseNo, itemid,itemimg,
                       itemname, landmark, orderid,paymentMode,pincode,
                      street,varmrp, varname,varprice, weekday, weekdayDays,
                       weekend,weekendDays,weight, alternativeDays
                    )),
              ),
            );
          });
        }
    );

  }
}



class AddressScreen extends StatefulWidget {
  static const routeName = '/address-screen';


  String addresstype="";
  String addressid="";
  String delieveryLocation="";
  String latitude="";
  String longitude="";
  String branch="";
  String houseNo="";
  String apartment="";
  String street="";
  String landmark="";
  String area="";
  String pincode="";
  String orderid= "";
  String title= "";
  String itemid="";
  String itemname ="";
  String itemimg ="";
  String varname ="";
  String varmrp = "";
  String varprice="";
  String paymentMode="";
  String cronTime="";
  String name="";
  String varid="";
  String brand="";
  String deliveriesarry ="";
  String daily="";
  String dailyDays="";
  String weekend="";
  String weekendDays="";
  String weekday="";
  String weekdayDays="";
  String custom="";
  String alternativeDays="";
  String customDays="";
  String weight="";

  AddressScreen(Map<String, String> params){
    this.addresstype = params["addresstype"]??"" ;
    this.addressid = params["addressid"]??"";
    this.delieveryLocation = params["delieveryLocation"]??"";
    this.latitude = params["latitude"]??"";
    this.longitude = params["longitude"]??"";
    this.branch = params["branch"]??"";
    this.houseNo = params["houseNo"]??"";
    this.apartment = params["apartment"]??"";
    this.street = params["street"]??"";
    this.landmark = params["landmark"]??"";
    this.area = params["area"]??"";
    this.pincode = params["pincode"]??"";
    this.orderid = params["orderid"]??"";
    this.title = params["title"]??"";
    this.itemid = params["itemid"]??"" ;
    this.itemname= params["itemname"]??"";
    this.itemimg= params["itemimg"]??"";
    this.varname= params["varname"]??"";
    this.varmrp= params["varmrp"]??"";
    this.varprice= params["varprice"]??"";
    this.paymentMode= params["paymentMode"]??"";
    this.cronTime= params["cronTime"]??"";
    this.name= params["name"]??"";
    this.varid= params["varid"]??"";
    this.brand= params["brand"]??"";
    this.deliveriesarry= params["deliveriesarray"]??"";
    this.daily= params["daily"]??"";
    this.dailyDays= params["dailyDays"]??"";
    this.weekend= params["weekend"]??"";
    this.weekendDays= params["weekendDays"]??"";
    this.weekday= params["weekday"]??"";
    this.weekdayDays= params["weekdayDays"]??"";
    this.custom= params["custom"]??"";
    this.alternativeDays= params["alternativeDays"]??"";
    this.customDays= params["customDays"]??"";
    this.weight= params["weight"]??"";
  }
  @override
  _AddressScreenState createState() => _AddressScreenState();

}

class _AddressScreenState extends State<AddressScreen> with Navigations{


  @override
  Widget build(BuildContext context) {
    return AddressInfo(widget.addresstype, widget.addressid, widget.delieveryLocation, widget.latitude, widget.longitude, widget.branch, widget.houseNo, widget.apartment, widget.street, widget.landmark, widget.area, widget.pincode, widget.orderid, widget.title, widget.itemid, widget.itemname, widget.itemimg, widget.varname, widget.varmrp, widget.varprice, widget.paymentMode, widget.cronTime, widget.name, widget.varid, widget.brand, widget.deliveriesarry, widget.daily, widget.dailyDays, widget.weekday, widget.weekend, widget.weekendDays, widget.weekdayDays, widget.custom, widget.customDays,widget.weight, widget.alternativeDays);

  }

}
