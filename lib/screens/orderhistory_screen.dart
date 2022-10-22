
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../widgets/orderwidget/OrderHistoryComponent.dart';
import '../rought_genrator.dart';



class OrderhistoryWeb with Navigations{
  String? orderid = "";
  String? fromscreen = "";
  String? orderstattus = "";
  Map<String, String>? orderhistory;
  String? notificationId = "";
  String? notificationStatus = "";
  OrderhistoryWeb(context,{this.orderhistory,this.orderid,this.fromscreen,this.orderstattus,this.notificationStatus,this.notificationId}){
    _dialogfororderhistory(context);
  }
  _dialogfororderhistory(context) {
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
                    child: OrderHistoryComponent(orderid,fromscreen,orderstattus,notificationId,notificationStatus)),
              ),
            );
          });
        }
    );

  }
}

class OrderhistoryScreen extends StatefulWidget {
  static const routeName = '/orderhistory-screen';
  String? orderid = "";
  String? fromscreen = "";
  String? orderstattus = "";
  Map<String, String>? orderhistory;
  String? notificationId = "";
  String? notificationStatus = "";

  OrderhistoryScreen(Map<String, String> params){
    this.orderhistory= params;
    this.orderid = params["orderid"]??"" ;
    this.fromscreen = params["fromScreen"]??"";
    this.orderstattus = params["orderstattus"]??"";
    this.notificationId = params["notificationId"]??"";
    this.notificationStatus = params["notificationStatus"]??"";
  }

  @override
  _OrderhistoryScreenState createState() => _OrderhistoryScreenState();
}

class _OrderhistoryScreenState extends State<OrderhistoryScreen>
    with Navigations {
  @override
  Widget build(BuildContext context) {
    return OrderHistoryComponent(widget.orderid, widget.fromscreen, widget.orderstattus, widget.notificationId, widget.notificationStatus);
  }

}
