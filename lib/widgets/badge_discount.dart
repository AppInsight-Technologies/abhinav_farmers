import 'package:flutter/material.dart';
import '../assets/ColorCodes.dart';
import '../generated/l10n.dart';

class BadgeDiscount extends StatelessWidget {
  const BadgeDiscount({
    Key? key,
    required this.child,
    required this.value,
    this.color,
  }) : super(key: key);

  final Widget child;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          left: 0,
          top: 0,
          child: value!="0"?Container(
            padding: EdgeInsets.all(3.0),
            // color: Theme.of(context).accentColor,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(5.0),
              ),
              color: /*color??Theme.of(context).primaryColor*/Colors.transparent,
            ),
            constraints: BoxConstraints(
              minWidth: 26,
              minHeight: 16,
            ),
            child: Text(
              value + S .of(context).off,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  color: /*Theme.of(context).buttonColor*/ColorCodes.darkgreen,
                  fontWeight: FontWeight.bold
              ),
            ),
          ):SizedBox.shrink(),
        )
      ],
    );
  }
}