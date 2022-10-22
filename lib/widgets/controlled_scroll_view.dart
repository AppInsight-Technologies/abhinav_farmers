import 'package:flutter/material.dart';

class ControlledScrollView extends StatelessWidget {
  Widget child;
  Function? onRightClick;
  Function? onLeftClick;

  var lbtnval ;

  var rbtnval = false;

  ControlledScrollView({Key? key,required this.child,this.onLeftClick,this.onRightClick,  this.controller, this. lbtnval, this. rbtnval= false}) : super(key: key);

  ScrollController? controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      child: Stack(
        // fit: StackFit.expand,
        children:[
          Container(
            //  padding: EdgeInsets.symmetric(horizontal: 60),
              child: child),


          // if( lbtnval) ElevatedButton(
          //     onPressed: () {
          //       onLeftClick();
          //     },
          //   /*  child: Icon(Icons.arrow_back_ios, color: Colors.black),
          //     style: ElevatedButton.styleFrom(
          //       // shape: CircleBorder(),
          //       padding: EdgeInsets.all(22),
          //       primary: Colors.white, // <-- Button color
          //       onPrimary: Colors.white, //lash color
          //     ),*/
          //   ),
          // if( rbtnval) ElevatedButton(
          // onPressed: () {
          //   onRightClick();
          // },
          //     //child:
          // // Icon(Icons.arrow_forward_ios, color: Colors.black),
          // //   style: ElevatedButton.styleFrom(
          // //     // shape: CircleBorder(),
          // //
          // //     padding: EdgeInsets.all(22),
          // //     primary: Colors.white, // <-- Button color
          // //     onPrimary: Colors.white, // <-- Splash color
          // //   )
          //
          // ),
        ],
      ),
    );
  }
}
