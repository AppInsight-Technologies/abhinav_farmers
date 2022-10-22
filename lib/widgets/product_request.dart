import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/velocity_x.dart';

import '../assets/ColorCodes.dart';
import '../constants/IConstants.dart';
import '../constants/features.dart';
import '../generated/l10n.dart';
import '../models/newmodle/suggestion_box.dart';
import '../utils/prefUtils.dart';

class productRequest extends StatefulWidget {

  productRequest({Key? key}) : super(key: key);
  @override
  productRequestState createState() => productRequestState();
}

class productRequestState extends State<productRequest> {
  final TextEditingController searchnamecontroller = new TextEditingController();
  late Future<SuggestionBox> _suggestionbox = Future.value();
  @override
  Widget build(BuildContext context) {
     return Wrap(
      children: [
        Container(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(S.of(context).request_a_product, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
              SizedBox(height: 7,),
              Text(S.of(context).we_at + " " + IConstants.APP_NAME + " " + S.of(context).strive_to_bring),
              SizedBox(height: 20,),
              Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: TextFormField(
                  textAlign: TextAlign.left,
                  controller: searchnamecontroller,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(20.0),
                    labelText: S .of(context).type_your_answer,
                    labelStyle: TextStyle(
                        color: ColorCodes.emailColor,
                        fontSize: 16.0
                    ),
                    hoverColor: ColorCodes.grey,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                      borderSide: BorderSide(color: ColorCodes.grey,),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                      borderSide: BorderSide(color: ColorCodes.grey),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                      borderSide: BorderSide(color: ColorCodes.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                      borderSide: BorderSide(color: ColorCodes.grey),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  SuggestionApi.getSuggeationBox(
                      ParamBodyData(
                  branch:PrefUtils.prefs!.getString("branch"), ref: IConstants.refIdForMultiVendor,customerId: PrefUtils.prefs!.getString("apikey"),
    customerName: VxState.store.userData.username, mobileNumber: VxState.store.userData.mobileNumber, suggestion: searchnamecontroller.text)).then((value){
                    _suggestionbox = Future.value(value);
                    _suggestionbox.then((value) {
                      Navigator.pop(context);
                      if(value.status == 200) {
                        Fluttertoast.showToast(
                            msg: S.of(context).your_suggestion_sent,
                            //"Sorry, you can\'t add more of this item!",
                            fontSize: MediaQuery
                                .of(context)
                                .textScaleFactor * 13,
                            backgroundColor: Colors.black87,
                            textColor: Colors.white);
                      }
                    });
                  });

                },
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                      color: ColorCodes.primaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(child: Text(S.of(context).submit, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: ColorCodes.whiteColor),))
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}