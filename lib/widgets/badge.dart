import 'dart:io';

import 'package:flutter/material.dart';
import '../utils/ResponsiveLayout.dart';

class Badge extends StatefulWidget {
  const Badge({
    Key? key,
    required this.child,
    required this.value,
    this.color,
  }) : super(key: key);

  final Widget child;
  final String value;
  final Color? color;

  @override
  _BadgeState createState() => _BadgeState();
}

class _BadgeState extends State<Badge> {
   bool _isWeb = false;

  @override
  void initState() {
    try {
      if (Platform.isIOS) {
        setState(() {
          _isWeb = false;
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
  }

  @override
  Widget build(BuildContext context) {

    return (_isWeb && !ResponsiveLayout.isSmallScreen(context)) ? Stack(
     // alignment: Alignment.center,
      //overflow: Overflow.visible,
      children: [
        widget.child,
        Positioned(
         // right: 0,
        //  top: -8,
          top:2,
          right: 1,
          child: Container(
            padding: EdgeInsets.all(2.0),
            // color: Theme.of(context).accentColor,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9.0),
              color: widget.color != null ? widget.color : Colors.green,
            ),
            constraints: BoxConstraints(
              minWidth: 17,
              minHeight: 17,
            ),
            child: Center(
              child: Text(
                widget.value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 9,
                  color: Theme.of(context).buttonColor,
                ),
              ),
            ),
          ),
        )
      ],
    ) : Stack(
      // alignment: Alignment.center,
      //overflow: Overflow.visible,
      children: [
        widget.child,
        if(widget.value!="0")
        Positioned(
          // right: 0,
          //  top: -8,
          top:6,
          right: 5,
          child: Container(
            padding: EdgeInsets.all(2.0),
            // color: Theme.of(context).accentColor,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9.0),
              color: widget.color != null ? widget.color : Colors.green,
            ),
            constraints: BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Center(
              child: Text(
                widget.value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).buttonColor,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}