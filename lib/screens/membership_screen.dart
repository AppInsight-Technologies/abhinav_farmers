
import 'package:flutter/material.dart';
import 'package:grocbay/widgets/membershipWidget/membership_component.dart';
import '../rought_genrator.dart';

class MembershipInfo with Navigations{

  MembershipInfo(context,){
    _dialogformembership(context);
  }
  _dialogformembership(context) {
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
                    child: MembershipComponent()),
              ),
            );
          });
        }
    );

  }
}


class MembershipScreen extends StatefulWidget {
  static const routeName = '/membership-screen';

  @override
  _MembershipScreenState createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> with Navigations{

  @override
  void initState() {

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
     return MembershipComponent();
  }

}
