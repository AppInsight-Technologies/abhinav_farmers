import 'package:flutter/material.dart';
import '../../rought_genrator.dart';
import '../widgets/WalletWidget/wallet_component.dart';


class WalletWeb with Navigations{
  Map<String, String>? wallet;
  String? type = "";
  String? fromScreen = "";
  WalletWeb(context,{this.wallet,this.type,this.fromScreen}){
    _dialogforwallet(context);
  }
  _dialogforwallet(context) {
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
                    child: WalletComponent(type,fromScreen,)),
              ),
            );
          });
        }
    );

  }
}

class WalletScreen extends StatefulWidget {
  static const routeName = '/wallet-screen';
  Map<String, String>? wallet;
  String? type = "";
  String? fromScreen = "";
  WalletScreen(Map<String, String> params){
    this.wallet= params;
    this.type = params["type"]??"" ;
    this.fromScreen = params["fromScreen"]??"";
  }
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> with Navigations{

  @override
  Widget build(BuildContext context) {
    return WalletComponent(widget.type, widget.fromScreen);
  }
}
