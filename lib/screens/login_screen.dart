import 'dart:convert';

import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocbay/constants/features.dart';
import '../constants/api.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

import '../generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:sms_autofill/sms_autofill.dart';

import '../constants/IConstants.dart';
import '../providers/branditems.dart';
import '../rought_genrator.dart';
import '../screens/otpconfirm_screen.dart';
import '../assets/images.dart';
import '../assets/ColorCodes.dart';
import '../utils/prefUtils.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-screen';

  String prev = "";
  Map<String,String>? loginscreen;

  LoginScreen(Map<String, String> params){
    this.loginscreen= params;
    this.prev = params["prev"]??"" ;

  }

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> with Navigations{
  final _form = GlobalKey<FormState>();
  late List<String> countrycodelist;
  String countryName = CountryPickerUtils.getCountryByPhoneCode(IConstants.countryCode.split('+')[1]).name;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      setState(() {
        countryName = CountryPickerUtils.getCountryByPhoneCode(IConstants.countryCode.split('+')[1]).name;
      });
    });
    super.initState();
  }

  addMobilenumToSF(String value) async {
    PrefUtils.prefs!.setString('Mobilenum', value);
  }

  _saveForm() async {
    final signcode = SmsAutoFill().getAppSignature;
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    } //it will check all validators
    _form.currentState!.save();

    if (PrefUtils.prefs!.getString('prevscreen') == "signingoogle" ||
        PrefUtils.prefs!.getString('prevscreen') == "signInApple" ||
        PrefUtils.prefs!.getString('prevscreen') == "signinfacebook") {
      checkMobilenum();
    } else {
      final signcode = await SmsAutoFill().getAppSignature;
      PrefUtils.prefs!.setString('signature', signcode);
      Provider.of<BrandItemsList>(context,listen: false).LoginUser();
      Navigator.of(context).pop();
      final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      return /*Navigator.of(context).pushNamed(
        OtpconfirmScreen.routeName,
          arguments: {
            "prev": routeArgs['prev'].toString(),
          }
      );*/
        Navigation(context, name: Routename.OtpConfirm, navigatore: NavigatoreTyp.Push,
            qparms: {
              "prev":/*routeArgs['prev'].toString()*/widget.prev,
            });
    }

//    return LoginUser();
  }

  Future<void> checkMobilenum() async {
    try {
      final response = await http.post(Api.mobileCheck, body: {
        "mobileNumber": PrefUtils.prefs!.getString('Mobilenum'),
      });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));

      if (responseJson['status'].toString() == "true") {
        if (responseJson['type'].toString() == "old") {
          Navigator.of(context).pop();
          Fluttertoast.showToast(msg: S .of(context).mobile_exists,//"Mobile number already exists!!!",
            fontSize: MediaQuery.of(context).textScaleFactor *13,);
        } else if (responseJson['type'].toString() == "new") {
          final signcode = await SmsAutoFill().getAppSignature;
          PrefUtils.prefs!.setString('signature', signcode);
          Provider.of<BrandItemsList>(context,listen: false).LoginUser();
         // Navigator.of(context).pop();
          final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          /* Navigator.of(context).pushNamed(
            OtpconfirmScreen.routeName,
              arguments: {
                "prev": routeArgs['prev'].toString(),
              }
          );*/
          Navigation(context, name: Routename.OtpConfirm, navigatore: NavigatoreTyp.Push,
              qparms: {
                "prev":widget.prev,//routeArgs['prev'].toString(),
              });
        }
      } else {
        Navigator.of(context).pop();
         Fluttertoast.showToast(msg: S .of(context).something_went_wrong,//"Something went wrong!!!",
          fontSize: MediaQuery.of(context).textScaleFactor *13,);
      }
    } catch (error) {
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      //systemNavigationBarColor:
      //  Theme.of(context).primaryColor, // navigation bar color
      statusBarColor: Theme.of(context).primaryColor, // status bar color
    ));
    countrycodelist = [IConstants.countryCode];
    _dialogforProcessing() {
      return showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return AbsorbPointer(
                child: Container(
                  color: Colors.transparent,
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                ),
              );
            });
          });
    }

    return Scaffold(
      appBar: NewGradientAppBar(
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              ColorCodes.appbarColor,
              ColorCodes.appbarColor2
            ]),
        elevation:  (IConstants.isEnterprise)?0:1,
        title: Text(
          S .of(context).signup,//'Signup',
          style: TextStyle(color: ColorCodes.iconColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color:ColorCodes.iconColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width / 1.2,
              margin: EdgeInsets.only(top: 40.0, bottom: 20.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text( S .of(context).please_enter_your_mobile,//'Please enter your mobile number',
                    style: TextStyle(color: ColorCodes.mediumBlackWebColor, fontWeight: FontWeight.bold, fontSize: 18),))),
          Container(
            width: MediaQuery.of(context).size.width / 1.2,
            height: 52,
            margin: EdgeInsets.only(bottom: 8.0),
            padding:
                EdgeInsets.only(left: 10.0, top: 5.0, right: 5.0, bottom: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(width: 0.5, color: ColorCodes.borderColor),
            ),
            child: Row(
              children: [
                Image.asset(
                  Images.countryImg,
                ),
                SizedBox(
                  width: 14,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                        S .of(context).country_region,//"Country/Region",
                        style: TextStyle(
                          color: ColorCodes.greyColor,
                        )),
                    Text(countryName + " (" + IConstants.countryCode + ")",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold))
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.2,
            height: 52.0,
            padding:
                EdgeInsets.only(left: 10.0, top: 5.0, right: 5.0, bottom: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(width: 0.5, color: ColorCodes.borderColor),
            ),
            child: Row(
              children: <Widget>[
                Image.asset(Images.phoneImg),
                SizedBox(
                  width: 14,
                ),
                Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Form(
                      key: _form,
                      child: TextFormField(
                        style: TextStyle(fontSize: 16.0),
                        textAlign: TextAlign.left,
                        inputFormatters: [LengthLimitingTextInputFormatter(12)],
                        cursorColor: Theme.of(context).primaryColor,
                        keyboardType: TextInputType.number,
                        //autofocus: true,
                        decoration: new InputDecoration.collapsed(
                            hintText: S .of(context).enter_yor_mobile_number,//'Enter Your Mobile Number',
                            hintStyle: TextStyle(
                              color: Colors.black12,
                            )),
                        validator: (value) {
                          String patttern = r'(^(?:[+0]9)?[0-9]{6,10}$)';
                          RegExp regExp = new RegExp(patttern);
                          if (value!.isEmpty) {
                            Navigator.of(context).pop();
                            return S .of(context).please_enter_phone_number;//'Please enter a Mobile number.';
                          } else if (!regExp.hasMatch(value)) {
                            Navigator.of(context).pop();
                            return S .of(context).valid_phone_number;//'Please enter valid mobile number';
                          }
                          return null;
                        }, //it means user entered a valid input
                        onSaved: (value) {
                          addMobilenumToSF(value!);
                        },
                      ),
                    ))
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.2,
            height: 60.0,
            margin: EdgeInsets.only(top: 8.0, bottom: 36.0),
            child: Text(
              S .of(context).we_will_call_or_text,//"We'll call or text you to confirm your number. Standard message data rates apply.",
              style: TextStyle(fontSize: 13, color: ColorCodes.mediumBlackWebColor),
            ),
          ),
          // This expands the row element vertically because it's inside a column
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                // This makes the blue container full width.
                Expanded(
                  child: GestureDetector(
                      onTap: () {
                        _saveForm();
                        _dialogforProcessing();
                      },
                      child: Container(
//                          padding: EdgeInsets.all(20),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                              )),
                          height: 60.0,
                          child: Center(
                            child: Text(
                              S .of(context).signup_otp,//"SIGNUP USING OTP",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Theme.of(context).buttonColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
