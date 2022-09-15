import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:country_pickers/utils/utils.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../models/newmodle/country_code.dart';
import '../../utils/facebook_app_events.dart';
import 'package:sign_in_apple/sign_in_apple.dart';
import '../controller/mutations/login.dart';
import '../models/VxModels/VxStore.dart';
import '../models/newmodle/user.dart';
import '../repository/authenticate/AuthRepo.dart';
import 'package:velocity_x/velocity_x.dart';
import '../constants/features.dart';
import '../constants/api.dart';
import '../generated/l10n.dart';
import '../rought_genrator.dart';
import '../services/firebaseAnaliticsService.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import "package:http/http.dart" as http;
import '../constants/IConstants.dart';
import '../providers/branditems.dart';
import '../handler/firebase_notification_handler.dart';
import '../assets/ColorCodes.dart';
import '../assets/images.dart';
import '../utils/prefUtils.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    //'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class SignupSelectionScreen extends StatefulWidget {
  static const routeName = '/signupselection-screen';

  @override
  SignupSelectionScreenState createState() => SignupSelectionScreenState();
}

class SignupSelectionScreenState extends State<SignupSelectionScreen> with Navigations{
  bool _isAvailable = false;
  final _form = GlobalKey<FormState>();
  String? countryName;// = "${CountryPickerUtils.getCountryByPhoneCode(IConstants.countryCode.split('+')[1]).name}";
  bool _isLoading = false;
  bool _isWeb = true;
  int count = 0;
  final TextEditingController _referController = new TextEditingController();
  final TextEditingController _countryController = new TextEditingController();
  String _appletoken = "";
  String channel = "";
  String OTP = "";
  GroceStore store = VxState.store;
  Auth _auth = Auth();
  String _countrycode = "91";
  String _currencycode= "₹";
  List<CountryCodes> countryList =[];

  @override
  void initState() {
    fas.setScreenName("Login");
    print("hello");
    Future.delayed(Duration.zero, () async {
      countryName = "${CountryPickerUtils.getCountryByPhoneCode(IConstants.countryCode.split('+')[1]).name}";
      CountryCodes().loadCountryCodeData().then((value) {
        setState(() {
          value.sort((a,b)=> int.parse(a.dialCode.toString()).compareTo(int.parse(b.dialCode.toString())));
          countryList= value;
        });
      });
      try {
        if (Platform.isIOS) {
        //  SignInApple.clickAppleSignIn();
          // SignInApple.onCredentialRevoked.listen((_) {});
          if (await SignInApple.canUseAppleSigin()) {
            setState(() {
              _isAvailable = true;
            });
          } else {
            setState(() {
              _isAvailable = false;
            });
          }
          channel = "IOS";
        }else{
          channel = "Android";
        }
      } catch (e) {
        channel = "Web";
      }

      if(PrefUtils.prefs!.getString("referCodeDynamic") == "" || PrefUtils.prefs!.getString("referCodeDynamic") == null){
        _referController.text = "";
      }else{
        _referController.text = PrefUtils.prefs!.getString("referCodeDynamic")!;
      }
      if (PrefUtils.prefs!.getString('applesignin') == "yes") {
        _appletoken = PrefUtils.prefs!.getString('apple').toString();
      } else {
        _appletoken = "";
      }
      setState(() {
        countryName = CountryPickerUtils.getCountryByPhoneCode(IConstants.countryCode.split('+')[1]).name;
        PrefUtils.prefs!.setString("skip", "no");
      });
      await new FirebaseNotifications().setUpFirebase;
      // await Provider.of<BrandItemsList>(context, listen: false).GetRestaurant().then((_) {
      //   if (!PrefUtils.prefs!.containsKey("deliverylocation")) {
      //     PrefUtils.prefs!.setString(
      //         "deliverylocation", PrefUtils.prefs!.getString("restaurant_location")!);
      //     PrefUtils.prefs!.setString("latitude", PrefUtils.prefs!.getString("restaurant_lat")!);
      //     PrefUtils.prefs!.setString("longitude", PrefUtils.prefs!.getString("restaurant_long")!);
      //   }
      // });
      BrandItemsList().GetRestaurantNew("acbjadgdj",()async {
        if (!PrefUtils.prefs!.containsKey("deliverylocation")) {
          PrefUtils.prefs!.setString(
              "deliverylocation", PrefUtils.prefs!.getString("restaurant_location")!);
          PrefUtils.prefs!.setString("latitude", PrefUtils.prefs!.getString("restaurant_lat")!);
          PrefUtils.prefs!.setString("longitude", PrefUtils.prefs!.getString("restaurant_long")!);
        }
      });
      handleDynamicLink();// only create the future once.
      _countryController.text = countryName! + " (" + IConstants.countryCode + ")";
    });
    super.initState();
    _googleSignIn.signInSilently();

  }

  addReferToSF(String value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('referid', value);
  }

  addMobilenumToSF(String value) async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    PrefUtils.prefs!.setString('Mobilenum', value);
  }

  handleDynamicLink() async {

    await FirebaseDynamicLinks.instance.getInitialLink();
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
    dynamicLinks.onLink.listen((event) {
      dynamicLinks.getDynamicLink(event.link).then((value) {
        handleSuccessLinking(value!);
      });
    });

    /*  FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData data) async {

    }, onError: (OnLinkErrorException error) async {
    });*/

  }

  void handleSuccessLinking(PendingDynamicLinkData data) {
    final Uri? deepLink = data.link;
    if (deepLink != null) {
      var isRefer = deepLink.pathSegments.contains('refer');
      if (isRefer) {
        var code = deepLink.queryParameters['code'];

        PrefUtils.prefs!.setString("referCodeDynamic", code!);
      }
    }
  }

  _saveForm() async {
    var shouldAbsorb = true;

    //final signcode = SmsAutoFill().getAppSignature;
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    } //it will check all validators
    _form.currentState!.save();
    //LoginUser();
    //final logindata =
    setState(() {
      PrefUtils.prefs!.setString('countrycode', _countrycode);
      if(_currencycode!=null) {
        PrefUtils.prefs!.setString('currency_formate', _currencycode);
      }
      if(_currencycode==""||_currencycode==null) {
        IConstants.currencyFormat = PrefUtils.prefs!.getString('currency_formate').toString();
      }
    });
    if(!_isWeb) {
      final signcode = await SmsAutoFill().getAppSignature;
      PrefUtils.prefs!.setString('signature', signcode);
    }

    //  Provider.of<BrandItemsList>(context, listen: false).LoginUser();
    setState(() {
      if(IConstants.countryCheck) {
        if (_currencycode == "" || _currencycode == null) {
          IConstants.currencyFormat = _currencycode.toString();
        }
      }
    });
    userappauth.login(AuthPlatform.phone,data: {"mobile":(IConstants.countryCheck)?PrefUtils.prefs!.getString('countrycode').toString()+PrefUtils.prefs!.getString('Mobilenum').toString():PrefUtils.prefs!.getString('Mobilenum').toString()},
        onSucsess: (SocialAuthUser value,LoginData otp){
          // PrefUtils.prefs!.setString('Otp', otp.otp.toString());
          //PrefUtils.prefs!.setString('apikey', value.id!);
          PrefUtils.prefs!.setString('Otp', otp.otp.toString());
          PrefUtils.prefs!.setString('apikey', value.id!);
          PrefUtils.prefs!.setBool('type',value.newuser!);
        });
    setState(() {
      _isLoading = false;
    });
    return Navigation(context, name: Routename.OtpConfirm, navigatore: NavigatoreTyp.Push,
        qparms: {
          "prev":"signupSelectionScreen"});
    /*Navigator.of(context).pushNamed(OtpconfirmScreen.routeName,
        arguments: {
          "prev": "signupSelectionScreen",
        });*/
  }

  Future<void> checkMobilenum() async {
    try {
      final response = await http.post(Api.mobileCheck, body: {
        "mobileNumber": PrefUtils.prefs!.getString('Mobilenum'),
      });
      final responseJson = json.decode(response.body);

      if (responseJson['status'].toString() == "true") {
        if (responseJson['type'].toString() == "old") {
          Fluttertoast.showToast(msg: S .of(context).mobile_exists,//"Mobile number already exists!!!",
            fontSize: MediaQuery.of(context).textScaleFactor *13,);
        } else if (responseJson['type'].toString() == "new") {
          if(!_isWeb){
            final signcode = await SmsAutoFill().getAppSignature;
            PrefUtils.prefs!.setString('signature', signcode);
            Provider.of<BrandItemsList>(context, listen: false).LoginUser();
            /*Navigator.of(context).pushNamed(
                OtpconfirmScreen.routeName,
                arguments: {
                  "prev": "signupSelectionScreen",
                }
            );*/
            Navigation(context, name: Routename.OtpConfirm, navigatore: NavigatoreTyp.Push,qparms: {"signupSelectionScreen":"signupSelectionScreen"});
          }
        }
      } else {
        Fluttertoast.showToast(msg: S .of(context).something_went_wrong,//"Something went wrong!!!",
          fontSize: MediaQuery.of(context).textScaleFactor *13,);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> _handleSignIn() async {
    // PrefUtils.prefs!.setString('skip', "no");
    // PrefUtils.prefs!.setString('applesignin', "no");
    //  try {
    // final response = await _googleSignIn.signIn();
    // response.email.toString();
    // response.displayName.toString();
    // response.photoUrl.toString();
    //
    // PrefUtils.prefs!.setString('FirstName', response.displayName.toString());
    // PrefUtils.prefs!.setString('LastName', "");
    // PrefUtils.prefs!.setString('Email', response.email.toString());
    // PrefUtils.prefs!.setString("photoUrl", response.photoUrl.toString());

    PrefUtils.prefs!.setString('prevscreen', "signingoogle");
    //checkusertype("Googlesigin");
    userappauth.login(AuthPlatform.google,onSucsess: (SocialAuthUser value,_){
      if(value.newuser!){
        userappauth.register(data:RegisterAuthBodyParm(
          username: value.name,
          email: value.email,
          branch: PrefUtils.prefs!.getString("branch"),
          tokenId:PrefUtils.prefs!.getString("ftokenid"),
          guestUserId:PrefUtils.prefs!.getString("tokenid"),
          device:channel,
          referralid:_referController.text,
          path: _appletoken ,
          mobileNumber: ((PrefUtils.prefs!.getString('Mobilenum'))??""),
          ref: IConstants.refIdForMultiVendor.toString(),
          branchtype:IConstants.branchtype.toString(),
          language_code: IConstants.languageId,
        ),onSucsess: (UserData response){
          //  PrefUtils.prefs!.setString('FirstName', response.username);
          //  PrefUtils.prefs!.setString('LastName', "");
          //  PrefUtils.prefs!.setString('Email', response.email);

          /* Navigator.pushNamedAndRemoveUntil(
                context, HomeScreen.routeName, (route) => false);*/


          if (PrefUtils.prefs!.getString("ismap").toString() == "true") {
            addprimarylocation();
          }
          else if (PrefUtils.prefs!.getString("isdelivering").toString() == "true") {
            // Navigator.of(context).pop();
            addprimarylocation();
          }
          else {
            //Navigator.of(context).pop();

            PrefUtils.prefs!.setString("latitude", PrefUtils.prefs!.getString("restaurant_lat")!);
            PrefUtils.prefs!.setString("longitude", PrefUtils.prefs!.getString("restaurant_long")!);
            PrefUtils.prefs!.setString("ismap", "true");
            PrefUtils.prefs!.setString("isdelivering", "true");
            addprimarylocation();
            //prefs.setString("formapscreen", "homescreen");
            //Navigator.of(context).pushReplacementNamed(MapScreen.routeName);
            /* Navigator.of(context).pushReplacementNamed(
              LocationScreen.routeName,
            );*/
          }
        },onerror: (message){
          Navigator.of(context).pop();
          Fluttertoast.showToast(msg: message);
        });
      }
      else{
        PrefUtils.prefs!.setString('LoginStatus', "true");
        PrefUtils.prefs!.setString("apikey",value.id!);
        _auth.getuserProfile(onsucsess: (value){

        },onerror: (){

        });
        /* Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.routeName, (route) => false);*/
        Navigation(context, /*name: Routename.Home,*/ navigatore: NavigatoreTyp.homenav);
        /*Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.routeName, (route) => false);*/
        ///navigatev to home page
      }

    },onerror:(message){
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: message);
    });
    // } catch (error) {
    //   Navigator.of(context).pop();
    //   if(Platform.isIOS)FocusManager.instance.primaryFocus.unfocus();
    //   Fluttertoast.showToast(
    //       msg: S .of(context).sign_in_failed,//"Sign in failed!",
    //       fontSize: MediaQuery.of(context).textScaleFactor *13,
    //       gravity: ToastGravity.BOTTOM,
    //       backgroundColor: Colors.black87,
    //       textColor: Colors.white);
    // }
  }

  void initiateFacebookLogin() async {
    final facebookLogin = FacebookLogin();
    facebookLogin.loginBehavior =  Platform.isIOS ? FacebookLoginBehavior.webViewOnly : FacebookLoginBehavior.nativeOnly;//FacebookLoginBehavior.webViewOnly; facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    final result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.error:
        // if(Features.isfacebookappevent)
        //   FaceBookAppEvents.facebookAppEvents.logEvent(name: "fb_login");
        Navigator.of(context).pop();
        if(Platform.isIOS)FocusManager.instance.primaryFocus!.unfocus();
        Fluttertoast.showToast(
            msg: S .of(context).sign_in_failed,//"Sign in failed!",
            fontSize: MediaQuery.of(context).textScaleFactor *13,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black87,
            textColor: Colors.white);
        //onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.cancelledByUser:
        Navigator.of(context).pop();
        if(Platform.isIOS)FocusManager.instance.primaryFocus!.unfocus();
        Fluttertoast.showToast(
            msg: S .of(context).sign_in_cancelledbyuser,//"Sign in cancelled by user!",
            fontSize: MediaQuery.of(context).textScaleFactor *13,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black87,
            textColor: Colors.white);
        //onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.loggedIn:
        // if(Features.isfacebookappevent)
        //   FaceBookAppEvents.facebookAppEvents.logEvent(name: "fb_login");
        final token = result.accessToken.token;
        result.accessToken.userId;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,picture,email&access_token=${token}');
        final profile = json.decode(graphResponse.body);
        PrefUtils.prefs!.setString("FBAccessToken", token);

        PrefUtils.prefs!.setString('FirstName', profile['first_name'].toString());
        PrefUtils.prefs!.setString('LastName', profile['last_name'].toString());
        profile['email'].toString() != "null" ?PrefUtils.prefs!.setString('Email', profile['email'].toString()):PrefUtils.prefs!.setString('Email',"");
        final pictureencode = json.encode(profile['picture']);
        final picturedecode = json.decode(pictureencode);

        final dataencode = json.encode(picturedecode['data']);
        final datadecode = json.decode(dataencode);

        PrefUtils.prefs!.setString("photoUrl", datadecode['url'].toString());

        PrefUtils.prefs!.setString('prevscreen', "signinfacebook");
        checkusertype("Facebooksigin");
        //onLoginStatusChanged(true);
        break;
    }
  }

  Future<void> checkusertype(String prev) async {
    try {
      var response;
      if (prev == "signInApple") {
        response = await http.post(Api.emailLogin, body: {
          "email": PrefUtils.prefs!.getString('Email'),
          "tokenId": PrefUtils.prefs!.getString('tokenid'),
          "apple": PrefUtils.prefs!.getString('apple'),
        });
      } else {
        response = await http.post(Api.emailLogin, body: {
          "email": PrefUtils.prefs!.getString('Email'),
          "tokenId": PrefUtils.prefs!.getString('tokenid'),
        });
      }

      final responseJson = json.decode(response.body);
      if (responseJson['type'].toString() == "old") {
        if (responseJson['data'] != "null") {
          final data = responseJson['data'] as Map<String, dynamic>;

          if (responseJson['status'].toString() == "true") {
            PrefUtils.prefs!.setString('apiKey', data['apiKey'].toString());
            // PrefUtils.prefs!.setString('userID', data['userID'].toString());
            PrefUtils.prefs!.setString('membership', data['membership'].toString());
            PrefUtils.prefs!.setString("mobile", data['mobile'].toString());
            PrefUtils.prefs!.setString("latitude", data['latitude'].toString());
            PrefUtils.prefs!.setString("longitude", data['longitude'].toString());
          } else if (responseJson['status'].toString() == "false") {}
        }

        PrefUtils.prefs!.setString('LoginStatus', "true");
        _getprimarylocation();
      } else {
        Features.isReferEarn?_dialogforRefer(context):SignupUser();
        // Navigator.of(context).pop();
        //SignupUser();
        /*  Navigator.of(context).pushNamed(
          LoginScreen.routeName,
        );*/
      }
    } catch (error) {
      Navigator.of(context).pop();
      if(Platform.isIOS)FocusManager.instance.primaryFocus!.unfocus();
      Fluttertoast.showToast(msg: S .of(context).something_went_wrong,//'Something Went Wrong..',
        fontSize: MediaQuery.of(context).textScaleFactor *13,gravity: ToastGravity.BOTTOM,);
      throw error;
    }
  }

  _dialogforRefer(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              child: Container(
                  height: 200.0,
                  width:200,
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        S .of(context).refer_earn,//"Refer And Earn",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        controller: _referController,
                        decoration: InputDecoration(
                          hintText: S .of(context).refer_earn,//"Refer and Earn (optional)",//"Reasons (Optional)",
                          contentPadding: EdgeInsets.all(16),
                          border: OutlineInputBorder(),
                        ),
                        minLines: 2,
                        maxLines: 2,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      FlatButton(
                        onPressed: () {
                          _dialogforProcessing();
                          SignupUser();
                        },
                        child: Text(
                          S .of(context).next ,//translate('forconvience.Next'), // "Next",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  )),
            );
          });
        });
  }

  Future<void> SignupUser() async {
    String _appletoken = "";
    String _name = "";
    String _email = "";
    String _mobile = "";
    String _tokenid = "";
    String channel = "";
    try {
      if (Platform.isIOS) {
        channel = "IOS";
      } else {
        channel = "Android";
      }
    } catch (e) {
      channel = "Web";
    }

    if (PrefUtils.prefs!.getString('applesignin') == "yes") {
      _appletoken = PrefUtils.prefs!.getString('apple')!;
    } else {
      _appletoken = "";
    }
    /* if (PrefUtils.prefs!.getString('FirstName') != null) {
      if (PrefUtils.prefs!.getString('LastName') != null) {
        _name = PrefUtils.prefs!.getString('FirstName') +
            " " +
            PrefUtils.prefs!.getString('LastName');
      } else {
        _name = PrefUtils.prefs!.getString('FirstName');
      }
    } else {
      _name = "";
    }*/
    _name = store.userData.username!;
    if (PrefUtils.prefs!.getString('prevscreen') == 'signInAppleNoEmail') {
      _email = "";
    } else {
      _email = PrefUtils.prefs!.getString('Email')!;
    }
    _tokenid = PrefUtils.prefs!.getString('tokenid')!;
    try {
      final response = await http.post(Api.register, body: {
        // await keyword is used to wait to this operation is complete.
        "username": _name,
        "email": _email,
        "mobileNumber": _mobile,
        "path": _appletoken,
        "tokenId": _tokenid,
        "branch": PrefUtils.prefs!.getString('branch') /*'999'*/,
        "referralid": _referController.text,//(PrefUtils.prefs!.getString("referCodeDynamic") == "" || PrefUtils.prefs!.getString("referCodeDynamic") == null)? "": PrefUtils.prefs!.getString("referCodeDynamic"),
        "device": channel.toString(),
      });
      final responseJson = json.decode(response.body);
      final data = responseJson['data'] as Map<String, dynamic>;
      if (responseJson['status'].toString() == "true") {
        PrefUtils.prefs!.setString('apiKey', data['apiKey'].toString());
        // PrefUtils.prefs!.setString('userID', responseJson['userId'].toString());
        PrefUtils.prefs!.setString('membership', responseJson['membership'].toString());
        PrefUtils.prefs!.setString('referral', PrefUtils.prefs!.getString('referralCode')!);
        PrefUtils.prefs!.setString('referid', _referController.text);
        PrefUtils.prefs!.setString('LoginStatus', "true");
        /*  Navigator.of(context).pop();
        return Navigator.of(context).pushNamedAndRemoveUntil(
            LocationScreen.routeName, ModalRoute.withName('/'));*/
        /*Navigator.of(context).pushReplacementNamed(
        LocationScreen.routeName,);*/

        if(responseJson['type'].toString() == "old"){
          Navigator.of(context).pop();
          /* Navigator.of(context).pushNamedAndRemoveUntil(
              HomeScreen.routeName, ModalRoute.withName('/'));*/
          Navigation(context, /*name: Routename.Home,*/ navigatore: NavigatoreTyp.homenav);
        }
        else{
          if (PrefUtils.prefs!.getString("ismap").toString() == "true") {
            addprimarylocation();
          }
          else if (PrefUtils.prefs!.getString("isdelivering").toString() == "true") {
            // Navigator.of(context).pop();
            addprimarylocation();
          }
          else {
            Navigator.of(context).pop();

            PrefUtils.prefs!.setString("latitude", PrefUtils.prefs!.getString("restaurant_lat")!);
            PrefUtils.prefs!.setString("longitude", PrefUtils.prefs!.getString("restaurant_long")!);
            PrefUtils.prefs!.setString("ismap", "true");
            PrefUtils.prefs!.setString("isdelivering", "true");
            addprimarylocation();
            //prefs.setString("formapscreen", "homescreen");
            //Navigator.of(context).pushReplacementNamed(MapScreen.routeName);
            /* Navigator.of(context).pushReplacementNamed(
              LocationScreen.routeName,
            );*/
          }
          // Navigator.of(context).pop();
          // return Navigator.of(context).pushNamedAndRemoveUntil(
          //     LocationScreen.routeName, ModalRoute.withName('/'));
        }

      } else if (responseJson['status'].toString() == "false") {
        Navigator.of(context).pop();
        if(Platform.isIOS)FocusManager.instance.primaryFocus!.unfocus();
        Fluttertoast.showToast(msg: S .of(context).something_went_wrong,//'Something Went Wrong..',
          fontSize: MediaQuery.of(context).textScaleFactor *13,gravity: ToastGravity.BOTTOM,);
      }
    } catch (error) {
      Navigator.of(context).pop();
      if(Platform.isIOS)FocusManager.instance.primaryFocus!.unfocus();
      Fluttertoast.showToast(msg: S .of(context).something_went_wrong,//'Something Went Wrong..',
        fontSize: MediaQuery.of(context).textScaleFactor *13,gravity: ToastGravity.BOTTOM,);
      throw error;
    }
  }

  Future<void> addprimarylocation() async {

    var url = IConstants.API_PATH + 'add-primary-location';
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(url, body: {
        // await keyword is used to wait to this operation is complete.
        "id": PrefUtils.prefs!.containsKey("apikey")? PrefUtils.prefs!.getString("apikey"): PrefUtils.prefs!.getString("ftokenid"),
        "latitude": PrefUtils.prefs!.getString("latitude"),
        "longitude":PrefUtils.prefs!.getString("longitude"),
        "area": IConstants.deliverylocationmain.value.toString(),
        "branch": PrefUtils.prefs!.getString('branch'),
        "ref": IConstants.isEnterprise && Features.ismultivendor ? IConstants.refIdForMultiVendor : IConstants.refIdForMultiVendor,
        "branchtype": IConstants.isEnterprise && Features.ismultivendor ? IConstants.branchtype.toString() : IConstants.branchtype.toString(),
      });
      final responseJson = json.decode(response.body);
      if (responseJson["data"].toString() == "true") {
        if(PrefUtils.prefs!.getString("ismap").toString()=="true") {
          if(PrefUtils.prefs!.getString("fromcart").toString()=="cart_screen"){
            // Navigator.of(context).pop();
            /*Navigator.of(context)
                .pushNamed(LoginScreen.routeName,);*/
            Navigation(context, name:Routename.Login,navigatore: NavigatoreTyp.Push);

          }
          else{
            /* Navigator.of(context).pop();
            return Navigator.of(context).pushReplacementNamed(
              HomeScreen.routeName,
            );*/
            /*Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);*/
            Navigation(context, /*name: Routename.Home,*/ navigatore: NavigatoreTyp.homenav);
            GoRouter.of(context).refresh();
          }


        }
        else if(PrefUtils.prefs!.getString("isdelivering").toString()=="true"){


          /*Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);*/
          Navigation(context, /*name: Routename.Home,*/ navigatore: NavigatoreTyp.homenav);
          GoRouter.of(context).refresh();

        }
        else {
          PrefUtils.prefs!.setString("formapscreen", "homescreen");
          PrefUtils.prefs!.setString("latitude", PrefUtils.prefs!.getString("restaurant_lat")!);
          PrefUtils.prefs!.setString("longitude", PrefUtils.prefs!.getString("restaurant_long")!);
          PrefUtils.prefs!.setString("ismap", "true");
          PrefUtils.prefs!.setString("isdelivering", "true");
          //Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
          Navigation(context, /*name: Routename.Home,*/ navigatore: NavigatoreTyp.homenav);
          GoRouter.of(context).refresh();
          //Navigator.of(context).pushReplacementNamed(MapScreen.routeName);
          /* Navigator.of(context).pushReplacementNamed(
            LocationScreen.routeName,
          );*/
        }
      }
    } catch (error) {
      Navigator.of(context).pop();
      throw error;
    }
  }

  Future<void> _getprimarylocation() async {
    try {
      final response = await http.post(Api.getProfile, body: {
        "apiKey": PrefUtils.prefs!.getString('apiKey'),
        "branch" : PrefUtils.prefs!.getString("branch")
      });

      final responseJson = json.decode(response.body);

      final dataJson =
      json.encode(responseJson['data']); //fetching categories data
      final dataJsondecode = json.decode(dataJson);
      List data = []; //list for categories

      dataJsondecode.asMap().forEach((index, value) => data.add(dataJsondecode[
      index]
      as Map<String, dynamic>)); //store each category values in data list
      for (int i = 0; i < data.length; i++) {
        PrefUtils.prefs!.setString("deliverylocation", data[i]['area']);
        PrefUtils.prefs!.setString("branch", data[i]['branch']);
        if (PrefUtils.prefs!.containsKey("deliverylocation")) {
          Navigator.of(context).pop();
          if (PrefUtils.prefs!.containsKey("fromcart")) {
            if (PrefUtils.prefs!.getString("fromcart") == "cart_screen") {
              PrefUtils.prefs!.remove("fromcart");
              /* Navigator.of(context).pushNamedAndRemoveUntil(
                  CartScreen.routeName,
                  ModalRoute.withName(HomeScreen.routeName), arguments: {
                "afterlogin": ""
              });*/

              Navigation(context, /*name: Routename.Home*/ navigatore: NavigatoreTyp.homenav,parms: {"afterlogin":"afterlogin"});

            } else {
              //Navigator.of(context).pushReplacementNamed(HomeScreen.routeName,);
              /*Navigator.pushNamedAndRemoveUntil(
                  context, HomeScreen.routeName, (route) => false);*/
              Navigation(context, /*name: Routename.Home,*/ navigatore: NavigatoreTyp.homenav);
            }
          } else {
            //Navigator.of(context).pushReplacementNamed(HomeScreen.routeName,);
            /* Navigator.pushNamedAndRemoveUntil(
                context, HomeScreen.routeName, (route) => false);*/
            Navigation(context, /*name: Routename.Home,*/ navigatore: NavigatoreTyp.homenav);
          }
        } else {



          if(PrefUtils.prefs!.getString("ismap").toString()=="true") {
            if(PrefUtils.prefs!.getString("fromcart").toString()=="cart_screen"){
              // Navigator.of(context).pop();
              /* Navigator.of(context)
                  .pushNamed(LoginScreen.routeName,);*/
              Navigation(context, name:Routename.Login,navigatore: NavigatoreTyp.Push);

            }
            else{
              /* Navigator.of(context).pop();
            return Navigator.of(context).pushReplacementNamed(
              HomeScreen.routeName,
            );*/
              // Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
              Navigation(context, /*name: Routename.Home,*/ navigatore: NavigatoreTyp.homenav);
            }


          }
          else if(PrefUtils.prefs!.getString("isdelivering").toString()=="true"){


            //Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
            Navigation(context, /*name: Routename.Home,*/ navigatore: NavigatoreTyp.homenav);


          }
          else {
            PrefUtils.prefs!.setString("formapscreen", "homescreen");
            PrefUtils.prefs!.setString("latitude", PrefUtils.prefs!.getString("restaurant_lat")!);
            PrefUtils.prefs!.setString("longitude", PrefUtils.prefs!.getString("restaurant_long")!);
            PrefUtils.prefs!.setString("ismap", "true");
            PrefUtils.prefs!.setString("isdelivering", "true");
            //Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
            Navigation(context, /*name: Routename.Home,*/ navigatore: NavigatoreTyp.homenav);
            //Navigator.of(context).pushReplacementNamed(MapScreen.routeName);
            /* Navigator.of(context).pushReplacementNamed(
              LocationScreen.routeName,
            );*/
          }
          /*Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed(
            LocationScreen.routeName,
          );*/



        }
      }
      //Navigator.of(context).pop();
    } catch (error) {
      Navigator.of(context).pop();
      throw error;
    }
  }

  Future<void> facebooklogin() async {
    PrefUtils.prefs!.setString('skip', "no");
    PrefUtils.prefs!.setString('applesignin', "no");
    initiateFacebookLogin();
  }

  bool skip() {
    PrefUtils.prefs!.setString('skip', "yes");
    PrefUtils.prefs!.setString('applesignin', "no");
    if (PrefUtils.prefs!.containsKey("deliverylocation")) {
      if (PrefUtils.prefs!.getString("deliverylocation") != "") {
        if (PrefUtils.prefs!.containsKey("fromcart")) {
          if (PrefUtils.prefs!.getString("fromcart") == "cart_screen") {
            PrefUtils.prefs!.remove("fromcart");
            /*    Navigator.of(context).pushReplacementNamed(
              CartScreen.routeName, arguments: {
              "afterlogin": ""
            }
            );*/
            Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
          } else {
            /*Navigator.of(context).pushReplacementNamed(
              HomeScreen.routeName,);*/
            /*Navigator.pushNamedAndRemoveUntil(
                context, HomeScreen.routeName, (route) => false);*/
            Navigation(context, navigatore: NavigatoreTyp.homenav);

          }
        }
        else {
          /*Navigator.of(context).pushReplacementNamed(
            HomeScreen.routeName,);*/
          /* Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.routeName, (route) => false);*/
          Navigation(context, navigatore: NavigatoreTyp.homenav);
          GoRouter.of(context).refresh();
        }
      } else {

        if (PrefUtils.prefs!.getString("ismap").toString() == "true") {
          addprimarylocation();
        }
        else if (PrefUtils.prefs!.getString("isdelivering").toString() == "true") {
          // Navigator.of(context).pop();
          addprimarylocation();
        }
        else {
          Navigator.of(context).pop();

          PrefUtils.prefs!.setString("latitude", PrefUtils.prefs!.getString("restaurant_lat")!);
          PrefUtils.prefs!.setString("longitude", PrefUtils.prefs!.getString("restaurant_long")!);
          PrefUtils.prefs!.setString("ismap", "true");
          PrefUtils.prefs!.setString("isdelivering", "true");
          addprimarylocation();
          //prefs.setString("formapscreen", "homescreen");
          //Navigator.of(context).pushReplacementNamed(MapScreen.routeName);
          /* Navigator.of(context).pushReplacementNamed(
              LocationScreen.routeName,
            );*/
        }

        /* Navigator.of(context).pushNamed(
          LocationScreen.routeName,
        );*/
      }
    } else {
      /*Navigator.of(context).pushNamedAndRemoveUntil(
        HomeScreen.routeName,(route) => false);

*/
      Navigation(context, /*name: Routename.Home,*/ navigatore: NavigatoreTyp.homenav);
      // pop()
          ;
    }
    return true;
  }

  Future<void> appleLogIn() async {
    PrefUtils.prefs!.setString('applesignin', "yes");
    _dialogforProcessing();
    PrefUtils.prefs!.setString('skip', "no");

    userappauth.login(AuthPlatform.ios,onSucsess: (SocialAuthUser value,_){
      if(value.newuser!){
        userappauth.register(data:RegisterAuthBodyParm(
          username: value.name,
          email: value.email,
          branch: PrefUtils.prefs!.getString("branch"),
          tokenId:PrefUtils.prefs!.getString("ftokenid"),
          guestUserId:PrefUtils.prefs!.getString("tokenid"),
          device:channel,
          referralid:_referController.text,
          path: _appletoken ,
          mobileNumber: ((PrefUtils.prefs!.getString('Mobilenum'))??""),
          ref: IConstants.refIdForMultiVendor.toString(),
          branchtype: IConstants.branchtype.toString(),
          language_code: IConstants.languageId,
        ),onSucsess: (UserData response){
          //  PrefUtils.prefs!.setString('FirstName', response.username);
          //  PrefUtils.prefs!.setString('LastName', "");
          //  PrefUtils.prefs!.setString('Email', response.email);

          /* Navigator.pushNamedAndRemoveUntil(
                context, HomeScreen.routeName, (route) => false);*/


          if (PrefUtils.prefs!.getString("ismap").toString() == "true") {
            addprimarylocation();
          }
          else if (PrefUtils.prefs!.getString("isdelivering").toString() == "true") {
            // Navigator.of(context).pop();
            addprimarylocation();
          }
          else {
            //Navigator.of(context).pop();

            PrefUtils.prefs!.setString("latitude", PrefUtils.prefs!.getString("restaurant_lat")!);
            PrefUtils.prefs!.setString("longitude", PrefUtils.prefs!.getString("restaurant_long")!);
            PrefUtils.prefs!.setString("ismap", "true");
            PrefUtils.prefs!.setString("isdelivering", "true");
            addprimarylocation();
            //prefs.setString("formapscreen", "homescreen");
            //Navigator.of(context).pushReplacementNamed(MapScreen.routeName);
            /* Navigator.of(context).pushReplacementNamed(
              LocationScreen.routeName,
            );*/
          }
        },onerror: (message){
          Navigator.of(context).pop();
          Fluttertoast.showToast(msg: message);
        });
      }
      else{
        PrefUtils.prefs!.setString("apikey",value.id!);
        _auth.getuserProfile(onsucsess: (value){
          /*Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.routeName, (route) => false);*/
          Navigation(context, /*name: Routename.Home, */navigatore: NavigatoreTyp.homenav);
        },onerror: (){

        });

        /*Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.routeName, (route) => false);*/
        ///navigatev to home page
      }

    },onerror:(message){
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: message);
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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      //systemNavigationBarColor:
      //  Theme.of(context).primaryColor, // navigation bar color
      statusBarColor: ColorCodes.whiteColor, // status bar color
    ));
    IConstants.isEnterprise? SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      //systemNavigationBarColor:
      //  Theme.of(context).primaryColor, // navigation bar color
      statusBarColor: ColorCodes.primaryColor, // status bar color
    )):
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.grey,
    ));
    debugPrint("country code and countryname"+IConstants.countryCode + countryName.toString());
    return WillPopScope(
      onWillPop: () async {
        skip();
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child:
          SingleChildScrollView(
            child: Column(children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: <Widget>[
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      skip();
                    },
                    child: Container(
                      width: 60.0,
                      height: 30.0,
                      margin: EdgeInsets.only(right: 20.0),
                      child: Center(
                          child: Text(
                            S .of(context).skip,//'SKIP',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: ColorCodes.mediumBlackWebColor),
                          )),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    height: 80,
                    margin: EdgeInsets.only(
                        left: 30.0, top: 30.0, right: 30.0, bottom: 10.0),
                    width: MediaQuery.of(context).size.width - 80,
                    child: Center(
                      child: Image.asset(
                        Images.logoImg,
                        width: 200,
                        // height: 200.0,
                      ),
                    ),
                  ),
                ],
              ),
              (IConstants.countryCheck)?
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: MediaQuery.of(context).size.height / 14,
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.only(
                    left: 10.0, top: 5.0, right: 5.0, bottom: 3.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  border: Border.all(width: 0.5, color: ColorCodes.emailColor),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      Images.countryImg, color: ColorCodes.blackColor,
                    ),
                    SizedBox(
                      width: 14,
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(S .of(context).country_region,//"Country/Region",
                            style: TextStyle(
                              color: ColorCodes.blackColor,
                            )),
                        Expanded(
                          child: Container(
                            width: 245,
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton<String>(
                                  value: _countrycode,
                                  iconSize: 30,
                                  icon: (null),
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                  ),
                                  onChanged: (String? newvalue){
                                    countryList.forEach((element) {
                                      if(element.dialCode!.trim().toString() == newvalue)
                                        setState(() {
                                          _countrycode = newvalue!.trim().toString();
                                          _currencycode = element.currency_format.toString();
                                        });
                                    });
                                  },
                                  items: countryList.map((item) {
                                    return DropdownMenuItem(
                                      child: Text(item.dialCode.toString(),style: TextStyle(color: ColorCodes.blackColor),),
                                      value: item.dialCode!.trim().toString(),
                                    );
                                  }).toList(),
                                ),
                              ),),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
                        :
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: MediaQuery.of(context).size.height / 15,
                      child: TextFormField(
                          readOnly: true,
                        // controller: name,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(12)
                        ],
                        cursorColor: ColorCodes.emailColor,//Theme.of(context).primaryColor,
                        keyboardType: TextInputType.number,
                        controller:_countryController,
                        //style: TextStyle(fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                            prefixIcon: Image.asset(Images.countryImg, color: ColorCodes.blackColor),
                            hintText: countryName! + " (" + IConstants.countryCode + ")",
                            hintStyle: TextStyle(
                              color: ColorCodes.blackColor, fontWeight: FontWeight.w800,

                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                color: ColorCodes.emailColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                color: ColorCodes.emailColor,
                                // width: 1.0,
                              ),
                            ),
                            labelText: S .of(context).country_region,
                            labelStyle: TextStyle(
                                color: ColorCodes.blackColor,
                                fontSize: 16.0
                            ),
                            errorStyle: TextStyle(
                                color: Colors.black
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )
                        ), //it means user entered a valid input
                      ),
                    ),
                    //     : Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //
                    //     Text(
                    //         S .of(context).country_region,//"Country/Region",
                    //         style: TextStyle(
                    //           color: ColorCodes.greyColor,
                    //         )),
                    //     Text(countryName! + " (" + IConstants.countryCode + ")",
                    //         style: TextStyle(
                    //             color: Colors.black, fontWeight: FontWeight.bold))
                    //   ],
                    // ),
                    /*Spacer(),
                        Row(
                          children: [
                            Icon(Icons.keyboard_arrow_down),
                          ],
                        ),*/



              SizedBox(height: 20,),
              Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                 // height: MediaQuery.of(context).size.height / 15,//52.0,
                  child:
                  Form(
                      key: _form,
                      child:
                      TextFormField(
                        // controller: name,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(12)
                          ],
                          cursorColor: ColorCodes.emailColor,//Theme.of(context).primaryColor,
                          keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            contentPadding:
                            EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                            prefixIcon: Image.asset(Images.phoneImg, color: ColorCodes.blackColor),
                            hintText: S .of(context).enter_yor_mobile_number,
                          hintStyle: TextStyle(
                                    color: ColorCodes.blackColor,

                                  ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                color: ColorCodes.emailColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                color: ColorCodes.emailColor,
                               // width: 1.0,
                              ),
                            ),
                            labelText: S.of(context).mobile_number,
                            labelStyle: TextStyle(
                              color: ColorCodes.blackColor,
                                fontSize: 16.0
                            ),
                            errorStyle: TextStyle(
                                color: Colors.black
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                            )
                        ),
                          validator: (value) {
                            String patttern = r'(^(?:[+0]9)?[0-9]{6,10}$)';
                            RegExp regExp = new RegExp(patttern);
                            if (value!.isEmpty) {
                              return S .of(context).please_enter_phone_number;//'Please enter a Mobile number.';
                            } else if (!regExp.hasMatch(value)) {
                              return S .of(context).valid_phone_number;//'Please enter valid mobile number';
                            }
                            return null;
                          }, //it means user entered a valid input

                          onSaved: (value) {
                            addMobilenumToSF(value!);
                          },
                      )

                  )),
              // Container(
              //   width: MediaQuery.of(context).size.width / 1.2,
              //   height: MediaQuery.of(context).size.height / 15,//52.0,
              //   /*padding: EdgeInsets.only(
              //       left: 10.0, top: 0.0, right: 0.0, bottom: 0.0),*/
              //   padding: EdgeInsets.only(
              //       left: 10.0, top: 5.0, right: 5.0, bottom: 5.0),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(4.0),
              //     border: Border.all(width: 0.5, color: ColorCodes.borderColor),
              //   ),
              //   child: Row(
              //     children: <Widget>[
              //       Image.asset(Images.phoneImg),
              //       SizedBox(
              //         width: 14,
              //       ),
              //       Container(
              //           width: MediaQuery.of(context).size.width*0.67,
              //           child:
              //           Form(
              //             key: _form,
              //             child:

              //             // TextFormField(
              //             //   style: TextStyle(fontSize: 16.0),
              //             //   //textAlign: TextAlign.left,
              //             //   inputFormatters: [
              //             //     LengthLimitingTextInputFormatter(12)
              //             //   ],
              //             //   cursorColor: Theme.of(context).primaryColor,
              //             //   keyboardType: TextInputType.number,
              //             //   //autofocus: true,
              //             //   decoration: new InputDecoration.collapsed(
              //             //       hintText: S .of(context).enter_yor_mobile_number,//'Enter Your Mobile Number',
              //             //
              //             //       hintStyle: TextStyle(
              //             //         color: Colors.black12,
              //             //
              //             //       )),
              //             //   validator: (value) {
              //             //     String patttern = r'(^(?:[+0]9)?[0-9]{6,10}$)';
              //             //     RegExp regExp = new RegExp(patttern);
              //             //     if (value!.isEmpty) {
              //             //       return S .of(context).please_enter_phone_number;//'Please enter a Mobile number.';
              //             //     } else if (!regExp.hasMatch(value)) {
              //             //       return S .of(context).valid_phone_number;//'Please enter valid mobile number';
              //             //     }
              //             //     return null;
              //             //   }, //it means user entered a valid input
              //             //
              //             //   onSaved: (value) {
              //             //     addMobilenumToSF(value!);
              //             //   },
              //             // ),
              //           ))
              //     ],
              //   ),
              // ),
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: MediaQuery.of(context).size.height / 30,//20.0,
                margin: EdgeInsets.only(top: 8.0, bottom: 36.0),
                child: Text(
                  S .of(context).we_will_call_text_signup,//"We'll call or text you to confirm your number.",
                  style: TextStyle(fontSize: 13, color: IConstants.isEnterprise? ColorCodes.blackColor:ColorCodes.liteColor),
                ),
              ),
              GestureDetector(
                onTap: () {
                  //  _enabled ? _onTap:
                  // clikform();
                  //   _dialogforProcessing();
                  setState(() {
                    _isLoading = true;
                    count + 1;
                  });
                  _isLoading
                      ? CircularProgressIndicator()
                      : PrefUtils.prefs!.setString('skip', "no");
                  PrefUtils.prefs!.setString('prevscreen', "mobilenumber");

                  _saveForm();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  // height: 32,
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: ColorCodes.primaryColor,
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      width: 1.0,
                      color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                    ),
                  ),
                  child: Text(
                    S .of(context).login_using_otp,//"LOGIN USING OTP",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: IConstants.isEnterprise? ColorCodes.whiteColor:ColorCodes.liteColor
                      //color: Color(0xd2000631)
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: MediaQuery.of(context).size.height / 22,//30.0,
                margin: EdgeInsets.only(top: 12.0, bottom: 32.0),
                child: new RichText(
                  text: new TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: new TextStyle(
                      fontSize: 13.0,
                      color: IConstants.isEnterprise? ColorCodes.blackColor:ColorCodes.liteColor,//Colors.black,
                    ),
                    children: <TextSpan>[
                      new TextSpan(text: S .of(context).agreed_terms,//'By continuing you agree to the '
                      ),
                      new TextSpan(
                          text: S .of(context).terms_of_service,//' terms of service',
                          style: new TextStyle(color:IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,fontWeight: FontWeight.bold),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              Navigation(context, name: Routename.Policy, navigatore: NavigatoreTyp.Push,parms: {"title":"Terms of Service"/*, "body" :IConstants.restaurantTerms*/});
                            }),
                      new TextSpan(text: S .of(context).and,//' and'
                      ),
                      new TextSpan(
                          text: S .of(context).privacy_policy,//' Privacy Policy',
                          style: new TextStyle(color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,fontWeight: FontWeight.bold),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              Navigation(context, name: Routename.Policy, navigatore: NavigatoreTyp.Push,parms: {"title":"Privacy Policy"/*, "body" :PrefUtils.prefs!.getString("privacy").toString()*/});
                            }),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/45,left: 28.0,right:28,bottom:MediaQuery.of(context).size.height/45),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Expanded(
                        //   child: Divider(
                        //     thickness: 0.5,
                        //     color: ColorCodes.whiteColor,
                        //   ),
                        // ),
                        Container(
                          //padding: EdgeInsets.all(4.0),
                          width: 23.0,
                          height: 23.0,
                          child: Center(
                              child: Text(
                                S .of(context).or,//"OR" , //"OR",
                                style:
                                TextStyle(fontSize: 13.0, color: ColorCodes.emailColor),
                              )),
                        ),
                        // Expanded(
                        //   child: Divider(
                        //     thickness: 0.5,
                        //     color: ColorCodes.whiteColor,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      if(Features.issignintruecaller)
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        child: GestureDetector(
                          onTap: () {
                            _dialogforProcessing();
                            //_handleSignIn();

                          },
                          child: Material(
                            borderRadius: BorderRadius.circular(4.0),
                            // elevation: 2,
                            // shadowColor: Colors.grey,
                            child: Container(

                              padding: EdgeInsets.only(
                                /*left: 10.0, right: 5.0,*/top:10, bottom:10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                border: Border.all(width: 0.5, color: ColorCodes.emailColor),),
                              child:
                              Padding(
                                padding: EdgeInsets.only(right:MediaQuery.of(context).size.width/10,//30.0,
                                  left:MediaQuery.of(context).size.width/12,),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[

                                      Expanded(
                                        child: Text(
                                          S .of(context).signin_truecaller,//'Sign in with google     ' , //"Sign in with Google",
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          style: TextStyle(fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: ColorCodes.signincolor),
                                        ),
                                      ),
                                      SvgPicture.asset(Images.googleImg, width: 25, height: 25,),
                                      //Image.asset(Images.googleImg,width: 20,height: 30,),
                                      SizedBox(
                                        width: 14,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if(Features.issignintruecaller)
                      SizedBox(height: 15,),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        width:MediaQuery.of(context).size.width,
                        // margin: EdgeInsets.only(left: 15),
                        child: GestureDetector(
                          onTap: () {
                            _dialogforProcessing();
                            _handleSignIn();

                          },
                          child: Material(
                            borderRadius: BorderRadius.circular(4.0),
                            // elevation: 2,
                            // shadowColor: Colors.grey,
                            child: Container(

                              padding: EdgeInsets.only(
                                /*left: 10.0, right: 5.0,*/top:10, bottom:10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                border: Border.all(width: 0.5, color: ColorCodes.emailColor),),
                              child:
                              Padding(
                                padding: EdgeInsets.only(right:10,//30.0,
                                  left:10,),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SvgPicture.asset(Images.googleImg, width: 25, height: 25,),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      S .of(context).sign_in_with_google,//'Sign in with google     ' , //"Sign in with Google",
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: TextStyle(fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: ColorCodes.signincolor),
                                    ),
                                    //Image.asset(Images.googleImg,width: 20,height: 30,),
                                    /*SizedBox(
                                      width: 14,
                                    ),*/
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15,),
                      Container(
                        width:MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        child: GestureDetector(
                          onTap: () {
                            _dialogforProcessing();
                            // facebooklogin();
                            // if(Features.isfacebookappevent)
                            //   FaceBookAppEvents.facebookAppEvents.logEvent(name: "fb_login");
                            userappauth.login(AuthPlatform.facebook,onSucsess: (SocialAuthUser value,_){
                              //  PrefUtils.prefs!.setString('skip', "no");
                              //  PrefUtils.prefs!.setString('applesignin', "no");
                              if(value.newuser!){
                                userappauth.register(data:RegisterAuthBodyParm(
                                  username: value.name,
                                  email: value.email,
                                  branch: PrefUtils.prefs!.getString("branch"),
                                  tokenId:PrefUtils.prefs!.getString("ftokenid"),
                                  guestUserId:PrefUtils.prefs!.getString("ftokenid"),
                                  device:channel,
                                  referralid:_referController.text,
                                  path: _appletoken, mobileNumber: '' ,
                                  ref: IConstants.refIdForMultiVendor.toString(),
                                  branchtype: IConstants.branchtype.toString(),
                                  language_code: IConstants.languageId,
                                  //mobileNumber: PrefUtils.prefs!.getString('Mobilenum')
                                ),onSucsess: (UserData response){
                                  // PrefUtils.prefs!.setString('FirstName', response.username);
                                  //  PrefUtils.prefs!.setString('LastName', "");
                                  //  PrefUtils.prefs!.setString('Email', response.email);

                                  /*Navigator.pushNamedAndRemoveUntil(
                                  context, HomeScreen.routeName, (route) => false);*/
                                  Navigation(context, /*name: Routename.Home,*/ navigatore: NavigatoreTyp.homenav);
                                },onerror: (message){
                                  Navigator.of(context).pop();
                                  Fluttertoast.showToast(msg: message);
                                });
                              }else{
                                PrefUtils.prefs!.setString('LoginStatus', "true");
                                PrefUtils.prefs!.setString("apikey",value.id!);
                                _auth.getuserProfile(onsucsess: (value){

                                },onerror: (){

                                });
                                /*Navigator.pushNamedAndRemoveUntil(
                                context, HomeScreen.routeName, (route) => false);*/
                                Navigation(context, /*name: Routename.Home,*/ navigatore: NavigatoreTyp.homenav);
                                ///navigatev to home page
                              }

                            },onerror:(message){
                              Navigator.of(context).pop();
                              Fluttertoast.showToast(msg: message);
                            });
                          },
                          child: Material(
                            borderRadius: BorderRadius.circular(4.0),
                            // elevation: 2,
                            // shadowColor: Colors.grey,
                            child: Container(
                              padding: EdgeInsets.only(
                                /*left: 10.0, right: 5.0,*/top:10, bottom:10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                border: Border.all(width: 0.5, color: ColorCodes.emailColor),),
                              child:
                              Padding(
                                padding: EdgeInsets.only(/*right:10,*///MediaQuery.of(context).size.width/10,//30.0,
                                  left:10,/*MediaQuery.of(context).size.width/12,*/),
                                child: Center(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SvgPicture.asset(Images.facebookImg, width: 25, height: 25,),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        S .of(context).sign_in_with_facebook,//"Sign in with Facebook" ,// "Sign in with Facebook",
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        style: TextStyle(fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: ColorCodes.signincolor),
                                      ),
                                      // Image.asset(Images.facebookImg,width: 20,height: 30,),
                                      // SizedBox(
                                      //   width: 14,
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      if (_isAvailable)
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 28,vertical: 15),
                          child: GestureDetector(
                            onTap: () {
                              appleLogIn();
                            },
                            child: Material(
                              borderRadius: BorderRadius.circular(4.0),
                              // elevation: 2,
                              // shadowColor: Colors.grey,
                              child: Container(
                                padding: EdgeInsets.only(
                                  /*left: 10.0, right: 5.0,*/top:10, bottom:10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.0),
                                  border: Border.all(width: 0.5, color: ColorCodes.emailColor),),
                                child:
                                Padding(
                                  padding: EdgeInsets.only(/*right:10,*///MediaQuery.of(context).size.width/10,//30.0,
                                    left:10,/*MediaQuery.of(context).size.width/12,*/),
                                  child: Center(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        SvgPicture.asset(Images.appleImg, width: 25, height: 25,),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          S .of(context).signin_apple,//"Sign in with Facebook" ,// "Sign in with Facebook",
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          style: TextStyle(fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: ColorCodes.signincolor),
                                        ),
                                        // Image.asset(Images.facebookImg,width: 20,height: 30,),
                                        // SizedBox(
                                        //   width: 14,
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                ],
              ),
              SizedBox(
                height: 10.0,
              )
            ]),
          ),
        ),
      ),
    );
  }
}
