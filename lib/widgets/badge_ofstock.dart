import 'package:flutter/material.dart';
import 'package:grocbay/assets/images.dart';
import '../assets/ColorCodes.dart';
import '../generated/l10n.dart';

class BadgeOfStock extends StatelessWidget {
  const BadgeOfStock({
    Key? key,
    required this.child,
     this.value,
    required this.singleproduct,
    this.color,
  }) : super(key: key);

  final Widget child;
  final String? value;
  final Color? color;
  final bool singleproduct;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Align(
          alignment: Alignment.center,
          child: Container(

            padding: EdgeInsets.only(left: 2.0, right: 2.0, top:10.0,),
            // color: Theme.of(context).accentColor,
            // decoration: BoxDecoration(
            //   border: Border.all(color: Colors.grey),
            //   borderRadius: BorderRadius.circular(3.0),
            //   color: Theme.of(context).buttonColor,
            // ),
            // constraints: BoxConstraints(
            //   //maxWidth: singleproduct ? 5.0 : 30.0,
            //   minHeight: 20,
            // ),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                color: ColorCodes.varcolor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(S.of(context).out_of_stock, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorCodes.greenColor),),
                  ],
                ),
              )
              /*Image.asset(Images.outofStock,height:45,width: 310,),*/
            ),
          ),
        ),
      ],
    );
  }
}