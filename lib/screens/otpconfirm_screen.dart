import 'dart:convert';
import 'dart:async'; // for Timer class
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocbay/models/newmodle/user.dart';
import 'package:grocbay/repository/authenticate/AuthRepo.dart';
import '../../controller/mutations/cart_mutation.dart';
import '../../controller/mutations/home_screen_mutation.dart';
import '../../models/VxModels/VxStore.dart';
import 'package:velocity_x/velocity_x.dart';
import '../assets/images.dart';
import '../constants/features.dart';
import '../constants/api.dart';
import '../generated/l10n.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../rought_genrator.dart';
import '../constants/IConstants.dart';
import '../assets/ColorCodes.dart';
import '../utils/ResponsiveLayout.dart';
import '../utils/prefUtils.dart';
import '../providers/addressitems.dart';

class OtpconfirmScreen extends StatefulWidget {
  static const routeName = '/otp-confirm';
  String prev="";
  String signupSelectionScreen="";
  String firstName="";
  String mobileNum="";
  String email="";

  OtpconfirmScreen(Map<String, String> params){
    this.prev = params["prev"]??"" ;
    this.signupSelectionScreen = params["signupSelectionScreen"]??"";
    this.firstName = params["firstName"]??"";
    this.mobileNum = params["mobileNum"]??"";
    this.email = params["email"]??"";
  }

  @override
  OtpconfirmScreenState createState() => OtpconfirmScreenState();
}

class OtpconfirmScreenState extends State<OtpconfirmScreen> with Navigations{
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  int _timeRemaining = 30;
  Timer? _timer;
  var mobilenum = "";
  TextEditingController controller = TextEditingController();
  var otpvalue = "";
  bool _showOtp = false;
  var addressitemsData;
  bool iphonex = false;
  GroceStore store = VxState.store;

  _getmobilenum() async {
    mobilenum = PrefUtils.prefs!.getString('Mobilenum')!;
  }

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    _getmobilenum();
    Future.delayed(Duration.zero, () async {
      try {
        if (Platform.isIOS) {
          setState(() {
            iphonex = MediaQuery.of(context).size.height >= 812.0;
          });
        }
      } catch (e) {
      }
      setState(() {
        addressitemsData = Provider.of<AddressItemsList>(context, listen: false);
      });
    });
    super.initState();
    _listenotp();
  }

  void _listenotp() async {
    await SmsAutoFill().listenForCode;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _getTime() {
    setState(() {
      _timeRemaining == 0 ? _timeRemaining = 0 : _timeRemaining--;
    });
  }

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

  _verifyOtp(String otpvalue) async {
    if (otpvalue ==  PrefUtils.prefs!.getString('Otp')) {
      if(widget.prev == "cartScreen") {
        verifynum();
      } else {
        if (!PrefUtils.prefs!.getBool('type')!) {
          PrefUtils.prefs!.setString('LoginStatus', "true");
          PrefUtils.prefs!.setString('skip', "no");
          PrefUtils.prefs!.setString('apikey', PrefUtils.prefs!.getString("userapikey").toString());
          PrefUtils.prefs!.remove("userapikey");
          debugPrint("wsedrgfth..."+PrefUtils.prefs!.getString("userapikey").toString());
          auth.getuserProfile(onsucsess: (value) {
             AuthData(code: 200,
                messege: "Login Success",
                status: true,
                data: SocialAuthUser(newuser: false, id: PrefUtils.prefs!.getString('apikey').toString()));
             SetCartItem(CartTask.fetch,onloade: (value){
             });
          }, onerror: (){

          });
          if (PrefUtils.prefs!.getString("fromcart") == "cart_screen") {
            PrefUtils.prefs!.remove("fromcart");
            Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.PushReplacment,qparms: {"afterlogin":"AftercartScreen"});
          }else {
            SchedulerBinding.instance!.addPostFrameCallback((_) {
              auth.getuserProfile(onsucsess: (value){
                HomeScreenController(user: PrefUtils.prefs!.getString("apikey") ??
                    PrefUtils.prefs!.getString("ftokenid"),
                  branch: PrefUtils.prefs!.getString("branch") ?? "999",
                  rows: "0",);
                Navigation(context, navigatore: NavigatoreTyp.homenav);
              }, onerror: (){
              });
            });
          }
        } else {
          PrefUtils.prefs!.setString('prevscreen', "otpconfirmscreen");
          PrefUtils.prefs!.setString('skip', "no");
          Navigation(context,name:Routename.SignUp, navigatore: NavigatoreTyp.Push);
        }
      }
    } else {
      Navigator.of(context).pop();
      if(Platform.isIOS)FocusManager.instance.primaryFocus!.unfocus();
      return Fluttertoast.showToast(msg: S .of(context).please_enter_valid_otp,//"Please enter a valid otp!!!",
      gravity: ToastGravity.BOTTOM,
      fontSize: MediaQuery.of(context).textScaleFactor *13,
      );
    }
  }

  Future<void> verifynum() async {
    try {
      final response = await http.post(Api.updateMobileNumber, body: {
        // await keyword is used to wait to this operation is complete.
        "id":PrefUtils.prefs!.getString('apikey'),
        "mobile":PrefUtils.prefs!.getString('Mobilenum'),

      });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      if (responseJson['status'].toString() == "200") {
        PrefUtils.prefs!.setString('mobile',PrefUtils.prefs!.getString('Mobilenum')!);
        store.userData.mobileNumber = PrefUtils.prefs!.getString('Mobilenum');
        cartcontroller.fetch(onload: (onload) {
          if(onload){

            auth.getuserProfile(onsucsess: (value) {
              AuthData(code: 200,
                  messege: "Login Success",
                  status: true,
                  data: SocialAuthUser(newuser: false, id: value.id));
            }, onerror: () {

            });
            HomeScreenController(branch: PrefUtils.prefs!.getString("branch") ?? "999", user: PrefUtils.prefs!.getString("tokenid"));
            Navigator.of(context).pop();

            if (addressitemsData.items.length > 0) {
              Navigation(context, name:Routename.ConfirmOrder,navigatore: NavigatoreTyp.Push,
                  parms:{"prev": "address_screen"});
            } else {
              PrefUtils.prefs!.setString("confirmback", "yes");
              Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,
                  qparms: {
                    "afterlogin":""
                  });
            }
          }
        });
      }
      else{
        Navigator.of(context).pop();
         Fluttertoast.showToast(msg: responseJson['data'], fontSize: MediaQuery.of(context).textScaleFactor *13,);
      }
    }
    catch (error) {
      throw error;
    }

  }

  Future<void> Otpin30sec() async {
    // imp feature in adding async is the it automatically wrap into Future.
    try {
      final response = await http.post(Api.resendOtp30, body: {
        // await keyword is used to wait to this operation is complete.
        "resOtp": PrefUtils.prefs!.getString('Otp'),
        "mobileNumber": PrefUtils.prefs!.getString('Mobilenum'),
      });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
    } catch (error) {
      throw error;
    }
  }

  Future<void> otpCall() async {
    // imp feature in adding async is the it automatically wrap into Future.
    try {
      final response = await http.post(Api.resendOtpCall, body: {
        // await keyword is used to wait to this operation is complete.
        "resOtp": PrefUtils.prefs!.getString('Otp'),
        "mobileNumber": PrefUtils.prefs!.getString('Mobilenum'),
      });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
    } catch (error) {
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    IConstants.isEnterprise?  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: ColorCodes.primaryColor,
    )) :
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.grey,
    ));

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: ResponsiveLayout.isSmallScreen(context) ?
        gradientappbarmobile() : null,
        backgroundColor: ColorCodes.whiteColor,
        body:
        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 50.0),
              Container(
                width: MediaQuery.of(context).size.width,
                child:  GestureDetector(
                  onTap: () {
                    Navigation(context, name:Routename.SignUpScreen,navigatore: NavigatoreTyp.Push);
                  },
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      S .of(context).code_sent + " " + IConstants.countryCode + '  $mobilenum',//'Please check OTP sent to your mobile number',
                      style: TextStyle(
                          color: ColorCodes.emailColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0),
                    ),
                    SizedBox(width: 5,),
                    Image.asset(Images.editNumber, width: 15, height: 15,),
                  ],
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 98 / 100,
                    padding: EdgeInsets.only(left: 20.0,right:20),
                    child: PinFieldAutoFill(
                      autoFocus: true,
                      controller: controller,
                      decoration: UnderlineDecoration(
                          textStyle: TextStyle(fontSize: 18, color: ColorCodes.blackColor),
                          colorBuilder: FixedColorBuilder(ColorCodes.emailColor)),
                      onCodeChanged: (text) {
                        otpvalue = text!;
                        SchedulerBinding.instance!.addPostFrameCallback((_) => setState(() {

                        }));
                        if(text.length == 4) {
                          _dialogforProcessing();
                          _verifyOtp(otpvalue);
                        }
                      },
                      onCodeSubmitted: (text) {
                        SchedulerBinding.instance!
                            .addPostFrameCallback((_) => setState(() {
                                  otpvalue = text;
                                }));
                      },
                      codeLength: 4,
                      currentCode: otpvalue,
                    ))
              ]),
              SizedBox(
                height: 35,
              ),

              // new Resend OTP buttons

              _showOtp
                  ? Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                            Text(
                              S .of(context).resend_otp,//'Resend OTP',
                              style: TextStyle(color: ColorCodes.emailColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0),
                              textAlign: TextAlign.center,
                            ),
                          if(Features.callMeInsteadOTP)
                            Spacer(),
                            if(Features.callMeInsteadOTP)
                            _timeRemaining == 0
                                ? GestureDetector(
                                    onTap: () {
                                      otpCall();
                                      _timeRemaining = 60;
                                    },
                                    child: Text(
                                      S .of(context).call_me_instead,//'Call me Instead',
                                      style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                    ),
                                  )
                                : RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      new TextSpan(
                                          text: S .of(context).call_in,//'Call in',
                                          style:
                                              TextStyle(color: ColorCodes.emailColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.0)),
                                      new TextSpan(
                                        text: ' 00:$_timeRemaining',
                                        style: TextStyle(
                                          color: ColorCodes.lightGreyColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                          ]),
                  )
                  : Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _timeRemaining == 0
                              ? GestureDetector(
                                  onTap: () {
                                    _showOtp = true;
                                    _timeRemaining += 30;
                                    Otpin30sec();
                                  },
                                  child: Text(
                                    S .of(context).resend_otp,//'Resend OTP',
                                    textAlign: TextAlign.center,
                                     style: TextStyle(color: ColorCodes.emailColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0)
                                  ),
                                )
                              : RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: <TextSpan>[
                                    new TextSpan(
                                        text: S .of(context).resend_otp_in,//'Resend Otp in',
                                        style:
                                            TextStyle(color: ColorCodes.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.0)),
                                    new TextSpan(

                                      text: ' 00:$_timeRemaining',
                                      style: TextStyle(
                                        color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          if(Features.callMeInsteadOTP)
                          Spacer(),
                          if(Features.callMeInsteadOTP)
                          Text(S .of(context).call_me_instead,//'Call me Instead',
                            style: TextStyle(fontSize: 15, color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor, fontWeight: FontWeight.w700),),
                        ],
                      ),
                  ),
            ]),
      ),
    );
  }

  gradientappbarmobile() {
    return  AppBar(
      brightness: Brightness.dark,
      toolbarHeight: 60.0,
      elevation: (IConstants.isEnterprise)?0:1,
      automaticallyImplyLeading: false,
      leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorCodes.iconColor),
          onPressed: () async {
            Navigator.of(context).pop();
            return Future.value(false);
          }
      ),
      titleSpacing: 0,
      title: Text(
        S .of(context).verify_phone,//'Signup using OTP',
        style: TextStyle(color: ColorCodes.iconColor, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  ColorCodes.appbarColor,
                  ColorCodes.appbarColor2
                ]
            )
        ),
      ),
    );
  }
}