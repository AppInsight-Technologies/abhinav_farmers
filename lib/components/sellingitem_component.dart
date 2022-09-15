import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login_web/flutter_facebook_login_web.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../models/newmodle/search_data.dart';
import '../../controller/mutations/cat_and_product_mutation.dart';
import '../../widgets/productWidget/item_badge.dart';
import '../../widgets/productWidget/item_variation.dart';
import 'package:sign_in_apple/apple_id_user.dart';
import 'package:sign_in_apple/sign_in_apple.dart';
import '../controller/mutations/cart_mutation.dart';
import '../controller/mutations/home_screen_mutation.dart';
import '../helper/custome_calculation.dart';
import '../models/VxModels/VxStore.dart';
import '../models/newmodle/cartModle.dart';
import '../models/newmodle/product_data.dart';
import '../models/newmodle/shoppingModel.dart';
import '../repository/authenticate/AuthRepo.dart';
import '../rought_genrator.dart';
import 'package:velocity_x/velocity_x.dart';
import '../constants/api.dart';
import '../generated/l10n.dart';
import '../constants/IConstants.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../screens/map_screen.dart';
import '../screens/membership_screen.dart';
import '../utils/ResponsiveLayout.dart';
import '../constants/features.dart';
import '../utils/prefUtils.dart';
import '../providers/branditems.dart';
import '../assets/images.dart';
import '../assets/ColorCodes.dart';
import 'package:http/http.dart' as http;

import '../widgets/custome_stepper.dart';
import '../widgets/shoppingList/dialogforitemCreateList.dart';
import '../widgets/shoppingList/dialogforshoppingCreateList.dart';
import 'login_web.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    //'https://www.googleapis.com/auth/contacts.readonly',
  ],
);
class SellingItemsv2 extends StatefulWidget {
  final String fromScreen;
  final String? seeallpress;
  final String? notid; //for not brand product screen
  final ItemData? itemdata;
  final StoreSearchData? storedsearchdata;


  Map<String, String>? returnparm;

  SellingItemsv2({Key? key,required this.fromScreen,this.seeallpress,
    this.itemdata,this.notid,this. returnparm,this.storedsearchdata}) : super(key: key);

  @override
  _SellingItemsv2State createState() => _SellingItemsv2State();
}

class _SellingItemsv2State extends State<SellingItemsv2> with Navigations{
  List<CartItem> productBox=[];
  int itemindex = 0;
  int varlength = 0;
  var itemvarData;
  var dialogdisplay = false;
  var _checkmembership = false;
  var colorRight = 0xff3d8d3c;
  var colorLeft = 0xff8abb50;
  Color? varcolor;
  var multiimage;
  String itemimg = "";

  //String? varid;
  String? varname;
  String? unit;
  String? varmrp;
  String? varprice;
  String? varmemberprice;
  String? varminitem;
  String? varmaxitem;
  int varLoyalty = 0;
  int varQty = 0;
  String? varstock;
  String? varimageurl;
  bool discountDisplay = false;
  bool? memberpriceDisplay;
  var margins;

  List variationdisplaydata = [];
  List variddata = [];
  List varnamedata = [];
  List unitdata =[];
  List varmrpdata = [];
  List varpricedata = [];
  List varmemberpricedata = [];
  List varminitemdata = [];
  List varmaxitemdata = [];
  List varLoyaltydata = [];
  List varQtyData = [];
  List varstockdata = [];
  List vardiscountdata = [];
  List discountDisplaydata = [];
  List memberpriceDisplaydata = [];

  List checkBoxdata = [];
  var containercolor = [];
  var textcolor = [];
  var iconcolor = [];

  bool checkskip = false;

  String photourl = "";
  String name = "";
  String phone = "";
  String apple = "";
  String email = "";
  String mobile = "";
  String tokenid = "";
  bool _isAvailable = false;
  Timer? _timer;
  int _timeRemaining = 30;
  StreamController<int>? _events;
  TextEditingController controller = TextEditingController();
  bool _showOtp = false;
  final TextEditingController firstnamecontroller = new TextEditingController();
  final TextEditingController lastnamecontroller = new TextEditingController();
  final _lnameFocusNode = FocusNode();
  String fn = "";
  String ln = "";
  String ea = "";
  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();
  FocusNode f4 = FocusNode();
  var addressitemsData;
  var deliveryslotData;
  var delChargeData;
  var timeslotsData;
  var timeslotsindex = "0";
  var otpvalue = "";

  String? otp1, otp2, otp3, otp4;
  final _form = GlobalKey<FormState>();
  var day, date, time = "10 AM - 1 PM";
  var addtype;
  var address;
  IconData? addressicon;
  DateTime? pickedDate;
  GroceStore store = VxState.store;
  int _groupValue = 0;
  int _count = 1;
  String _price = "";
  String _mrp = "";

  List<ShoppingListData> shoplistData=[];
  Auth _auth = Auth();

  @override
  void initState() {
    _events = new StreamController<int>.broadcast();
    _events!.add(30);
    pickedDate = DateTime.now();
    productBox = (VxState.store as GroceStore).CartItemList;
    Future.delayed(Duration.zero, () async {
      setState(() {
        if (store.userData.membership! == "1") {
          setState(() {
            _checkmembership = true;
          });
        } else {
          setState(() {
            _checkmembership = false;
          });
          for (int i = 0; i < productBox.length; i++) {
            if (productBox[i].mode == "1") {
              setState(() {
                _checkmembership = true;
              });
            }
          }
        }
        dialogdisplay = true;
      });

      if(Features.btobModule){
        if (productBox.where((element) => element.itemId == widget.itemdata!.id)
            .count() >= 1) {
          for (int i = 0; i < productBox.length; i++) {
            for(int j = 0 ; j < widget.itemdata!.priceVariation!.length; j++)
            {
              if ((int.parse(productBox.where((element) => element.itemId == widget.itemdata!.id).first.quantity.toString()) >=  int.parse(widget.itemdata!.priceVariation![j].minItem.toString())) && int.parse(productBox.where((element) => element.itemId == widget.itemdata!.id).first.quantity.toString()) <=  int.parse(widget.itemdata!.priceVariation![j].maxItem.toString())) {
                _groupValue = j;
            }
            }
          }
        }
      }

      if(Features.isShoppingList){
        shoplistData = (VxState.store as GroceStore).ShoppingList;
       /* Provider.of<BrandItemsList>(context,listen: false)
            .fetchShoppinglist()
            .then((_) {
          shoplistData =
              Provider.of<BrandItemsList>(context, listen: false);
        });*/
      }
    });
    setState(() {
      if (PrefUtils.prefs!.containsKey("LoginStatus")) {
        if (PrefUtils.prefs!.getString('LoginStatus') == "true") {
          PrefUtils.prefs!.setString('skip', "no");
          checkskip = false;
        } else {
          PrefUtils.prefs!.setString('skip', "yes");
          checkskip = true;
        }
      } else {
        PrefUtils.prefs!.setString('skip', "yes");
        checkskip = true;
      }
    });
    super.initState();
  }

  Future<void> _getprimarylocation() async {
    try {
      final response = await http.post(Api.getProfile, body: {
        // await keyword is used to wait to this operation is complete.
        "apiKey": PrefUtils.prefs!.getString('apiKey'),
        "branch" : PrefUtils.prefs!.getString("branch")
      });

      final responseJson = json.decode(utf8.decode(response.bodyBytes));

      final dataJson =
      json.encode(responseJson['data']); //fetching categories data
      final dataJsondecode = json.decode(dataJson);
      List data = []; //list for categories

      dataJsondecode.asMap().forEach((index, value) => data.add(dataJsondecode[
      index]
      as Map<String, dynamic>)); //store each category values in data list
      for (int i = 0; i < data.length; i++) {
        PrefUtils.prefs!.setString("deliverylocation", data[i]['area']);

        if (PrefUtils.prefs!.containsKey("deliverylocation")) {
          Navigator.of(context).pop();
          if (PrefUtils.prefs!.containsKey("fromcart")) {
            if (PrefUtils.prefs!.getString("fromcart") == "cart_screen") {
              PrefUtils.prefs!.remove("fromcart");
              Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,parms: {"afterlogin":"Ok"});
            } else {
              Navigation(context, navigatore: NavigatoreTyp.homenav);
            }
          } else {
            Navigation(context, navigatore: NavigatoreTyp.homenav);
          }
        } else {
          Navigator.of(context).pop();
          if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
            // _dialogforaddress(context);
            MapWeb(context);
          }
          else {
            Navigation(context, name: Routename.MapScreen,
                navigatore: NavigatoreTyp.Push);
          }
        }
      }
    } catch (error) {
      Navigator.of(context).pop();
      throw error;
    }
  }

  void initiateFacebookLogin() async {
    //web.......
    final facebookSignIn = FacebookLoginWeb();
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
    //app........
    
    switch (result.status) {
      case FacebookLoginStatus.error:
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: S .of(context).sign_in_failed,//"Sign in failed!",
            fontSize: MediaQuery.of(context).textScaleFactor *13,
            backgroundColor: ColorCodes.blackColor,
            textColor: ColorCodes.whiteColor);
        //onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.cancelledByUser:
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: S .of(context).sign_in_cancelledbyuser,//"Sign in cancelled by user!",
            fontSize: MediaQuery.of(context).textScaleFactor *13,
            backgroundColor: ColorCodes.blackColor,
            textColor: ColorCodes.whiteColor);
        //onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,picture,email&access_token=${token}');
        final profile = json.decode(graphResponse.body);

        PrefUtils.prefs!.setString("FBAccessToken", token);

        PrefUtils.prefs!.setString('FirstName', profile['first_name'].toString());
        PrefUtils.prefs!.setString('LastName', profile['last_name'].toString());
        PrefUtils.prefs!.setString('Email', profile['email'].toString());

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

      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      if (responseJson['type'].toString() == "old") {
        if (responseJson['data'] != "null") {
          final data = responseJson['data'] as Map<String, dynamic>;

          if (responseJson['status'].toString() == "true") {
            PrefUtils.prefs!.setString('apiKey', data['apiKey'].toString());
            PrefUtils.prefs!.setString('userID', data['userID'].toString());
            PrefUtils.prefs!.setString('membership', data['membership'].toString());
            PrefUtils.prefs!.setString("mobile", data['mobile'].toString());
            PrefUtils.prefs!.setString("latitude", data['latitude'].toString());
            PrefUtils.prefs!.setString("longitude", data['longitude'].toString());
          } else if (responseJson['status'].toString() == "false") {}
        }

        PrefUtils.prefs!.setString('LoginStatus', "true");
        setState(() {
          checkskip = false;
          name = store.userData.username!;
          if (PrefUtils.prefs!.getString('prevscreen') == 'signInAppleNoEmail') {
            email = "";
          } else {
            email = PrefUtils.prefs!.getString('Email').toString();
          }
          mobile = PrefUtils.prefs!.getString('Mobilenum')!;
          tokenid = PrefUtils.prefs!.getString('tokenid')!;

          if (PrefUtils.prefs!.getString('mobile') != null) {
            phone = PrefUtils.prefs!.getString('mobile')!;
          } else {
            phone = "";
          }
          if (PrefUtils.prefs!.getString('photoUrl') != null) {
            photourl = PrefUtils.prefs!.getString('photoUrl')!;
          } else {
            photourl = "";
          }
        });
        _getprimarylocation();
      } else {
        Navigator.of(context).pop();
        (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?signupUser():null;
      }
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

  Future<void> appleLogIn() async {
    PrefUtils.prefs!.setString('applesignin', "yes");
    _dialogforProcessing();
    PrefUtils.prefs!.setString('skip', "no");
    if (await SignInApple.canUseAppleSigin()) {
      SignInApple.handleAppleSignInCallBack(onCompleteWithSignIn: (AppleIdUser? appleidentifier) async {
        try {
          final response = await http.post(Api.emailLogin, body: {
            // await keyword is used to wait to this operation is complete.
            "email": appleidentifier!.mail,
            "tokenId": PrefUtils.prefs!.getString('tokenid'),
          });
          final responseJson = json.decode(response.body);
          if (responseJson['type'].toString() == "old") {
            if (responseJson['data'] != "null") {
              final data = responseJson['data'] as Map<String, dynamic>;

              if (responseJson['status'].toString() == "true") {
                PrefUtils.prefs!.setString('apiKey', data['apiKey'].toString());
                PrefUtils.prefs!.setString('membership', data['membership'].toString());
                PrefUtils.prefs!.setString("mobile", data['mobile'].toString());
                PrefUtils.prefs!.setString("latitude", data['latitude'].toString());
                PrefUtils.prefs!.setString("longitude", data['longitude'].toString());

                PrefUtils.prefs!.setString('name', data['name'].toString());
                PrefUtils.prefs!.setString('FirstName', data['name'].toString());
                PrefUtils.prefs!.setString('FirstName', data['username'].toString());
                PrefUtils.prefs!.setString('LastName', "");
                PrefUtils.prefs!.setString('Email', data['email'].toString());
                PrefUtils.prefs!.setString("photoUrl", "");
                PrefUtils.prefs!.setString('apple', data['apple'].toString());
              } else if (responseJson['status'].toString() == "false") {}
            }
            PrefUtils.prefs!.setString('LoginStatus', "true");
            _getprimarylocation();
          } else {
            PrefUtils.prefs!.setString('apple', appleidentifier.mail!);
            PrefUtils.prefs!.setString(
                'FirstName', appleidentifier.givenName!);
            PrefUtils.prefs!.setString(
                'LastName',appleidentifier.familyName!);
            PrefUtils.prefs!.setString("photoUrl", "");

            if (appleidentifier.mail.toString() == "null") {
              PrefUtils.prefs!.setString('prevscreen', "signInAppleNoEmail");
              Navigator.of(context).pop();
              Navigation(context, name:Routename.Login,navigatore: NavigatoreTyp.Push,
              qparms: {
                "prev": "signupSelectionScreen"
              });
            } else {
              PrefUtils.prefs!.setString('Email', appleidentifier.mail!);
              PrefUtils.prefs!.setString('prevscreen', "signInApple");
              checkusertype("signInApple");
            }
          }
        } catch (error) {
          Navigator.of(context).pop();
          throw error;
        }
      }, onCompleteWithError: (AppleSignInErrorCode code) async {
        var errorMsg = "unknown";
        switch (code) {
          case AppleSignInErrorCode.canceled:
            errorMsg = S .of(context).sign_in_cancelledbyuser;
            break;
          case AppleSignInErrorCode.failed:
            errorMsg =  S .of(context).sign_in_failed;
            break;
          case AppleSignInErrorCode.invalidResponse:
            errorMsg =S .of(context).apple_signin_not_available_forthis_device;
            break;
          case AppleSignInErrorCode.notHandled:
            errorMsg = S .of(context).apple_signin_not_available_forthis_device;
            break;
          case AppleSignInErrorCode.unknown:
            errorMsg = S .of(context).apple_signin_not_available_forthis_device;
            break;
        }
        Navigator.of(context).pop();
        if(Platform.isIOS)FocusManager.instance.primaryFocus!.unfocus();
        Fluttertoast.showToast(
            msg:errorMsg,//"Sign in failed!",
            fontSize: MediaQuery.of(context).textScaleFactor *13,
            backgroundColor: Colors.black87,
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.white);
      });
      SignInApple.clickAppleSignIn();
    } else {
      Navigator.of(context).pop();
      if(Platform.isIOS)FocusManager.instance.primaryFocus!.unfocus();
      Fluttertoast.showToast(
          msg: S .of(context).apple_signin_not_available_forthis_device,//"Apple SignIn is not available for your device!",
          fontSize: MediaQuery.of(context).textScaleFactor *13,
          backgroundColor: Colors.black87,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white);
    }
  }

  Future<void> otpCall() async {
    try {
      final response = await http.post(Api.resendOtpCall, body: {
        "resOtp": PrefUtils.prefs!.getString('Otp'),
        "mobileNumber": PrefUtils.prefs!.getString('Mobilenum'),
      });
    } catch (error) {
      throw error;
    }
  }

  Future<void> Otpin30sec() async {
    try {
      final response = await http.post(Api.resendOtp30, body: {
        "resOtp": PrefUtils.prefs!.getString('Otp'),
        "mobileNumber": PrefUtils.prefs!.getString('Mobilenum'),
      });
    } catch (error) {
      throw error;
    }
  }



  Future<void> _handleSignIn() async {
    PrefUtils.prefs!.setString('skip', "no");
    PrefUtils.prefs!.setString('applesignin', "no");
    try {
      final response = await _googleSignIn.signIn();
      response!.email.toString();
      response.displayName.toString();
      response.photoUrl.toString();

      PrefUtils.prefs!.setString('FirstName', response.displayName.toString());
      PrefUtils.prefs!.setString('LastName', "");
      PrefUtils.prefs!.setString('Email', response.email.toString());
      PrefUtils.prefs!.setString("photoUrl", response.photoUrl.toString());

      PrefUtils.prefs!.setString('prevscreen', "signingoogle");
      checkusertype("Googlesigin");
    } catch (error) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: S .of(context).sign_in_failed,//"Sign in failed!",
          fontSize: MediaQuery.of(context).textScaleFactor *13,
          backgroundColor: Colors.black87,
          textColor: Colors.white);
    }
  }
  _customToast() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              S .of(context).please_enter_valid_otp,//"Please enter a valid otp!!!"
            ),
          );
        });
  }

  addMobilenumToSF(String value) async {
    PrefUtils.prefs!.setString('Mobilenum', value);
  }

  _verifyOtp() async {
    if (controller.text == PrefUtils.prefs!.getString('Otp')) {
      if (PrefUtils.prefs!.getString('type') == "old") {
        PrefUtils.prefs!.setString('LoginStatus', "true");
        setState(() {
          checkskip = false;
          name = store.userData.username!;
          if (PrefUtils.prefs!.getString('prevscreen') == 'signInAppleNoEmail') {
            email = "";
          } else {
            email = PrefUtils.prefs!.getString('Email')!;
          }
          mobile = PrefUtils.prefs!.getString('Mobilenum')!;
          tokenid = PrefUtils.prefs!.getString('tokenid')!;

          if (PrefUtils.prefs!.getString('mobile') != null) {
            phone = PrefUtils.prefs!.getString('mobile')!;
          } else {
            phone = "";
          }
          if (PrefUtils.prefs!.getString('photoUrl') != null) {
            photourl = PrefUtils.prefs!.getString('photoUrl')!;
          } else {
            photourl = "";
          }
        });
        _getprimarylocation();
      } else {
        if (PrefUtils.prefs!.getString('prevscreen') == 'signingoogle' ||
            PrefUtils.prefs!.getString('prevscreen') == 'signupselectionscreen' ||
            PrefUtils.prefs!.getString('prevscreen') == 'signInAppleNoEmail' ||
            PrefUtils.prefs!.getString('prevscreen') == 'signInApple' ||
            PrefUtils.prefs!.getString('prevscreen') == 'signinfacebook') {
          return signupUser();
        } else {
          PrefUtils.prefs!.setString('prevscreen', "otpconfirmscreen");
          await Future.delayed(Duration(seconds: 2));
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          _dialogforAddInfo();
        }
      }
    } else {
      await Future.delayed(Duration(seconds: 2));
      Navigator.of(context).pop();
      _customToast();
    }
  }

  _saveAddInfoForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    } //it will check all validators
    _form.currentState!.save();
    _dialogforProcessing();
    if(PrefUtils.prefs!.getString('Email') == "" || PrefUtils.prefs!.getString('Email') == "null") {
      return SignupUser();
    } else {
      checkemail();
    }
  }
  Future<void> checkemail() async {
    // imp feature in adding async is the it automatically wrap into Future.
    try {

      final response = await http.post(Api.emailCheck, body: {
        // await keyword is used to wait to this operation is complete.
        "email": PrefUtils.prefs!.getString('Email'),
      });
      final responseJson = json.decode(response.body);

      if (responseJson['status'].toString() == "true") {
        if (responseJson['type'].toString() == "old") {
          Navigator.of(context).pop();
          (Vx.isWeb)?Navigator.of(context).pop():null;
           Fluttertoast.showToast(
              msg: S .of(context).email_exist,//"Email id already exists",
              fontSize: MediaQuery.of(context).textScaleFactor *13,
              backgroundColor: Colors.black87,
              textColor: Colors.white);
        } else if (responseJson['type'].toString() == "new") {
          return SignupUser();
        }
      } else {
         Fluttertoast.showToast(msg: S .of(context).something_went_wrong,//"Something went wrong!!!"
        );
      }
    } catch (error) {
      throw error;
    }
  }
  Future<void> signupUser() async {
    // imp feature in adding async is the it automatically wrap into Future.
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

    try {

      final response = await http.post(Api.register, body: {
        // await keyword is used to wait to this operation is complete.
        "username": name,
        "email": email,
        "mobileNumber": mobile,
        "path": apple,
        "tokenId": tokenid,
        "branch": PrefUtils.prefs!.getString('branch'),
        "signature":
        PrefUtils.prefs!.containsKey("signature") ? PrefUtils.prefs!.getString('signature') : "",
        "device": channel.toString(),
      });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      final data = responseJson['data'] as Map<String, dynamic>;

      if (responseJson['status'].toString() == "true") {
        PrefUtils.prefs!.setString('apiKey', data['apiKey'].toString());
        PrefUtils.prefs!.setString('userID', responseJson['userId'].toString());
        PrefUtils.prefs!.setString('membership', responseJson['membership'].toString());

        PrefUtils.prefs!.setString('LoginStatus', "true");
        setState(() {
          checkskip = false;
          name = store.userData.username!;
          if (PrefUtils.prefs!.getString('prevscreen') == 'signInAppleNoEmail') {
            email = "";
          } else {
            email = PrefUtils.prefs!.getString('Email').toString();
          }
          mobile = PrefUtils.prefs!.getString('Mobilenum')!;
          tokenid = PrefUtils.prefs!.getString('tokenid')!;

          if (PrefUtils.prefs!.getString('mobile') != null) {
            phone = PrefUtils.prefs!.getString('mobile')!;
          } else {
            phone = "";
          }
          if (PrefUtils.prefs!.getString('photoUrl') != null) {
            photourl = PrefUtils.prefs!.getString('photoUrl')!;
          } else {
            photourl = "";
          }
        });
        if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
          // _dialogforaddress(context);
          MapWeb(context);
        }
        else {
          Navigation(context, name: Routename.MapScreen,
              navigatore: NavigatoreTyp.Push);
        }
      } else if (responseJson['status'].toString() == "false") {}
    } catch (error) {
      throw error;
    }
  }

  Future<void> SignupUser() async {
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

    try {
      String apple = "";
      if (PrefUtils.prefs!.getString('applesignin') == "yes") {
        apple = PrefUtils.prefs!.getString('apple')!;
      } else {
        apple = "";
      }

      String name =
          PrefUtils.prefs!.getString('FirstName').toString() + " " + PrefUtils.prefs!.getString('LastName').toString();

      final response = await http.post(Api.register, body: {
        "username": name,
        "email": PrefUtils.prefs!.getString('Email'),
        "mobileNumber": PrefUtils.prefs!.containsKey("Mobilenum") ? PrefUtils.prefs!.getString('Mobilenum') : "",
        "path": apple,
        "tokenId": PrefUtils.prefs!.getString('tokenid'),
        "branch": PrefUtils.prefs!.getString('branch'),
        "signature":
        PrefUtils.prefs!.containsKey("signature") ? PrefUtils.prefs!.getString('signature') : "",
        "device": channel.toString(),
      });
      final responseJson = json.decode(response.body);

      if (responseJson['status'].toString() == "true") {
        final data = responseJson['data'] as Map<String, dynamic>;
        PrefUtils.prefs!.setString('apiKey', data['apiKey'].toString());
        PrefUtils.prefs!.setString('userID', responseJson['userId'].toString());
        PrefUtils.prefs!.setString('membership', responseJson['membership'].toString());
        PrefUtils.prefs!.setString("mobile", PrefUtils.prefs!.getString('Mobilenum')!);

        PrefUtils.prefs!.setString('LoginStatus', "true");
        setState(() {
          checkskip = false;
          name = store.userData.username!;
          if (PrefUtils.prefs!.getString('prevscreen') == 'signInAppleNoEmail') {
            email = "";
          } else {
            email = PrefUtils.prefs!.getString('Email').toString();
          }
          mobile = PrefUtils.prefs!.getString('Mobilenum')!;
          tokenid = PrefUtils.prefs!.getString('tokenid')!;

          if (PrefUtils.prefs!.getString('mobile') != null) {
            phone = PrefUtils.prefs!.getString('mobile')!;
          } else {
            phone = "";
          }
          if (PrefUtils.prefs!.getString('photoUrl') != null) {
            photourl = PrefUtils.prefs!.getString('photoUrl')!;
          } else {
            photourl = "";
          }
        });
        Navigator.of(context).pop();
        PrefUtils.prefs!.setString("formapscreen", "");
        if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
          // _dialogforaddress(context);
          MapWeb(context);
        }
        else {
          Navigation(context, name: Routename.MapScreen,
              navigatore: NavigatoreTyp.Push);
        }

      } else if (responseJson['status'].toString() == "false") {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: responseJson['data'].toString(),
            fontSize: MediaQuery.of(context).textScaleFactor *13,
            backgroundColor: Colors.black87,
            textColor: Colors.white);
      }
    } catch (error) {
      setState(() {});
      throw error;
    }
  }

  addFirstnameToSF(String value) async {
    PrefUtils.prefs!.setString('FirstName', value);
  }

  addLastnameToSF(String value) async {
    PrefUtils.prefs!.setString('LastName', value);
  }

  addEmailToSF(String value) async {
    PrefUtils.prefs!.setString('Email', value);
  }

  _dialogforAddInfo() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              child: Container(
                height: (Vx.isWeb && ResponsiveLayout.isSmallScreen(context))
                    ? MediaQuery.of(context).size.height
                    : MediaQuery.of(context).size.width / 3.3,
                width: (Vx.isWeb && ResponsiveLayout.isSmallScreen(context))
                    ? MediaQuery.of(context).size.width
                    : MediaQuery.of(context).size.width / 2.7,
                //padding: EdgeInsets.only(left: 30.0, right: 20.0),
                child: Column(children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    color: ColorCodes.lightGreyWebColor,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          S .of(context).add_info,//"Add your info",
                          style: TextStyle(
                              color: ColorCodes.mediumBlackColor,
                              fontSize: 20.0),
                        )),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 30.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Form(
                            key: _form,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 10),
                                Text(
                                  S .of(context).what_should_we_call_you,//'* What should we call you?',
                                  style: TextStyle(
                                      fontSize: 17, color: ColorCodes.lightBlack
                                  //Color(0xFF1D1D1D)
                                  ),
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  textAlign: TextAlign.left,
                                  controller: firstnamecontroller,
                                  decoration: InputDecoration(
                                    hintText: S.of(context).name,//'Name',
                                    hoverColor: ColorCodes.primaryColor,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                      BorderSide(color: Colors.grey),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                      BorderSide(color: ColorCodes.primaryColor),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                      BorderSide(color: ColorCodes.primaryColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                      BorderSide(color: ColorCodes.primaryColor),
                                    ),
                                  ),
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_lnameFocusNode);
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      setState(() {
                                        fn = "  Please Enter Name";
                                      });
                                      return '';
                                    }
                                    setState(() {
                                      fn = "";
                                    });
                                    return null;
                                  },
                                  onSaved: (value) {
                                    addFirstnameToSF(value!);
                                  },
                                ),
                                Text(
                                  fn,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(color: Colors.red),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  S .of(context).tell_us_your_email,//'Tell us your e-mail',
                                  style: TextStyle(
                                      fontSize: 17, color: ColorCodes.lightBlack
                                 // Color(0xFF1D1D1D)
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                TextFormField(
                                  textAlign: TextAlign.left,
                                  keyboardType: TextInputType.emailAddress,
                                  style: new TextStyle(
                                      decorationColor:
                                      Theme.of(context).primaryColor),
                                  decoration: InputDecoration(
                                    hintText: S.of(context).xyz_gmail,//'xyz@gmail.com',
                                    fillColor: ColorCodes.primaryColor,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                      BorderSide(color: Colors.grey),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                      BorderSide(color: ColorCodes.primaryColor),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                      BorderSide(color: ColorCodes.primaryColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide(
                                          color: ColorCodes.primaryColor, width: 1.2),
                                    ),
                                  ),
                                  validator: (value) {
                                    bool emailValid;
                                    if (value == "")
                                      emailValid = true;
                                    else
                                      emailValid = RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(value!);

                                    if (!emailValid) {
                                      setState(() {
                                        ea =
                                        S.of(context).please_enter_valid_email_address;//' Please enter a valid email address';
                                      });
                                      return '';
                                    }
                                    setState(() {
                                      ea = "";
                                    });
                                    return null; //it means user entered a valid input
                                  },
                                  onSaved: (value) {
                                    addEmailToSF(value!);
                                  },
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      ea,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                                Text(
                                  S .of(context).we_will_email,//' We\'ll email you as a reservation confirmation.',
                                  style: TextStyle(
                                      fontSize: 15.2, color: ColorCodes.emailColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //  Spacer(),
                      ],
                    ),
                  ),
                  Spacer(),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          _saveAddInfoForm();
                          _dialogforProcessing();
                        },
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
                              S .of(context).continue_button,//"CONTINUE",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Theme.of(context).buttonColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )),
                  ),
                ]),
              ),
            );
          });
        });
  }

  _dialogforOtp() async {
    return alertOtp(context);
  }
  _dialogforSignIn() {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              child: Container(
                height: (Vx.isWeb && ResponsiveLayout.isSmallScreen(context))
                    ? MediaQuery.of(context).size.height
                    : MediaQuery.of(context).size.width / 2.2,
                width: (Vx.isWeb && ResponsiveLayout.isSmallScreen(context))
                    ? MediaQuery.of(context).size.width
                    : MediaQuery.of(context).size.width / 3.0,
                //padding: EdgeInsets.only(left: 30.0, right: 20.0),
                child: Column(children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    color: ColorCodes.lightGreyWebColor,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          S .of(context).signin,//"Sign in",
                          style: TextStyle(
                              color: ColorCodes.mediumBlackColor,
                              fontSize: 20.0),
                        )),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 32.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 52,
                          margin: EdgeInsets.only(bottom: 8.0),
                          padding: EdgeInsets.only(
                              left: 10.0, top: 5.0, right: 5.0, bottom: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            border: Border.all(
                                width: 0.5, color: ColorCodes.borderColor),
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
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                      S .of(context).country_region,//"Country/Region",
                                      style: TextStyle(
                                        color: ColorCodes.darkgrey,
                                      )),
                                  Text(CountryPickerUtils.getCountryByPhoneCode(IConstants.countryCode.split('+')[1]).name + " (" + IConstants.countryCode + ")",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 52.0,
                          padding: EdgeInsets.only(
                              left: 10.0, top: 5.0, right: 5.0, bottom: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            border: Border.all(
                                width: 0.5, color: ColorCodes.borderColor),
                          ),
                          child: Row(
                            children: <Widget>[
                              Image.asset(Images.phoneImg),
                              SizedBox(
                                width: 14,
                              ),
                              Container(
                                  width:
                                  MediaQuery.of(context).size.width / 4.0,
                                  child: Form(
                                    key: _form,
                                    child: TextFormField(
                                      style: TextStyle(fontSize: 16.0),
                                      textAlign: TextAlign.left,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(12)
                                      ],
                                      cursorColor:
                                      Theme.of(context).primaryColor,
                                      keyboardType: TextInputType.number,
                                      autofocus: true,
                                      decoration: new InputDecoration.collapsed(
                                          hintText: S.of(context).enter_yor_mobile_number,//'Enter Your Mobile Number',
                                          hintStyle: TextStyle(
                                            color: Colors.black12,
                                          )),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return S.of(context).please_enter_phone_number;//'Please enter a Mobile number.';
                                        }
                                        return null; //it means user entered a valid input
                                      },
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
                            style: TextStyle(
                                fontSize: 13, color: ColorCodes.lightblack1),
                          ),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              PrefUtils.prefs!.setString('skip', "no");
                              PrefUtils.prefs!.setString('prevscreen', "mobilenumber");
                              // PrefUtils.prefs!.setString('Mobilenum', value);
                              _saveFormLogin();
                              _dialogforProcess();
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width / 1.2,
                              height: 32,
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(
                                  width: 1.0,
                                  color: ColorCodes.greenColor,
                                ),
                              ),
                              child: Text(
                                S .of(context).login_using_otp,//"LOGIN USING OTP",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0,
                                    color: ColorCodes.black),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60.0,
                          margin: EdgeInsets.only(top: 12.0, bottom: 32.0),
                          child: new RichText(
                            text: new TextSpan(
                              // Note: Styles for TextSpans must be explicitly defined.
                              // Child text spans will inherit styles from parent
                              style: new TextStyle(
                                fontSize: 13.0,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                new TextSpan(
                                  text: S .of(context).agreed_terms,//'By continuing you agree to the '
                                ),
                                new TextSpan(
                                    text: S .of(context).terms_of_service,//' terms of service',
                                    style:
                                    new TextStyle(color: ColorCodes.darkthemeColor),
                                    recognizer: new TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigation(context, name: Routename.Policy, navigatore: NavigatoreTyp.Push,parms: {"title": "Terms of Use"});
                                      }),
                                new TextSpan(text: S .of(context).and,//' and'
                                ),
                                new TextSpan(
                                    text: S .of(context).privacy_policy,//' Privacy Policy',
                                    style:
                                    new TextStyle(color: ColorCodes.darkthemeColor),
                                    recognizer: new TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigation(context, name: Routename.Policy, navigatore: NavigatoreTyp.Push,
                                            parms: {"title": "Privacy"});
                                      }),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  thickness: 0.5,
                                  color: ColorCodes.greyColor,
                                ),
                              ),
                              Container(
                                //padding: EdgeInsets.all(4.0),
                                width: 23.0,
                                height: 23.0,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ColorCodes.greyColor,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                    child: Text(
                                      S .of(context).or,//"OR",
                                      style: TextStyle(
                                          fontSize: 10.0, color: ColorCodes.greyColord),
                                    )),
                              ),
                              Expanded(
                                child: Divider(
                                  thickness: 0.5,
                                  color: ColorCodes.greyColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 28),
                              child: GestureDetector(
                                onTap: () {
                                  _dialogforProcessing();
                                  Navigator.of(context).pop();
                                  _handleSignIn();
                                },
                                child: Material(
                                  borderRadius: BorderRadius.circular(4.0),
                                  elevation: 2,
                                  shadowColor: Colors.grey,
                                  child: Container(

                                    padding: EdgeInsets.only(
                                        left: 10.0, right: 5.0,top:MediaQuery.of(context).size.height/130, bottom:MediaQuery.of(context).size.height/130),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0),),
                                    child:
                                    Padding(
                                      padding: const EdgeInsets.only(right:23.0,left:23,),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            SvgPicture.asset(Images.googleImg, width: 25, height: 25,),
                                            //Image.asset(Images.googleImg,width: 20,height: 40,),
                                            SizedBox(
                                              width: 14,
                                            ),
                                            Text(
                                              S .of(context).sign_in_with_google,//"Sign in with Google" , //"Sign in with Google",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: ColorCodes.signincolor),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/70, horizontal: 28),
                              child: GestureDetector(
                                onTap: () {
                                  _dialogforProcessing();
                                  Navigator.of(context).pop();
                                  facebooklogin();
                                },
                                child: Material(
                                  borderRadius: BorderRadius.circular(4.0),
                                  elevation: 2,
                                  shadowColor: Colors.grey,
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 10.0,  right: 5.0, top:MediaQuery.of(context).size.height/130, bottom:MediaQuery.of(context).size.height/130),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0),

                                      // border: Border.all(width: 0.5, color: Color(0xff4B4B4B)),
                                    ),
                                    child:
                                    Padding(
                                      padding: const EdgeInsets.only(right:23.0,left: 23),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            SvgPicture.asset(Images.facebookImg, width: 25, height: 25,),
                                            //Image.asset(Images.facebookImg,width: 20,height: 40,),
                                            SizedBox(
                                              width: 14,
                                            ),
                                            Text(
                                              S .of(context).sign_in_with_facebook,//"Sign in with Facebook" ,// "Sign in with Facebook",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: ColorCodes.signincolor),
                                            )
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
                                margin: EdgeInsets.symmetric(horizontal: 28),
                                child: GestureDetector(
                                  onTap: () {
                                    appleLogIn();
                                  },
                                  child: Material(
                                    borderRadius: BorderRadius.circular(4.0),
                                    elevation: 2,
                                    shadowColor: Colors.grey,
                                    child: Container(

                                      padding: EdgeInsets.only(
                                          left: 10.0, right: 5.0,top:MediaQuery.of(context).size.height/130, bottom:MediaQuery.of(context).size.height/130),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4.0),),
                                      child:
                                      Padding(
                                        padding: const EdgeInsets.only(right:23.0,left:23,),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              SvgPicture.asset(Images.appleImg, width: 25, height: 25,),
                                              //Image.asset(Images.appleImg, width: 20,height: 40,),
                                              SizedBox(
                                                width: 14,
                                              ),
                                              Text(
                                                S .of(context).signin_apple,//"Sign in with Apple"  , //"Sign in with Apple",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: ColorCodes.signincolor),
                                              )
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
                  ),
                ]),
              ),
            );
          });
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
  _dialogforProcess() {
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
  _saveFormLogin() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    } //it will check all validators
    _form.currentState!.save();
    Provider.of<BrandItemsList>(context,listen: false).LoginUser();
    await Future.delayed(Duration(seconds: 2));
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    _dialogforOtp();
  }
  void alertOtp(BuildContext ctx) {
    mobile = PrefUtils.prefs!.getString("Mobilenum")!;
    var alert = AlertDialog(
        contentPadding: EdgeInsets.all(0.0),
        content: StreamBuilder<int>(
            stream: _events!.stream,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              return Container(
                  height: (Vx.isWeb && ResponsiveLayout.isSmallScreen(context))
                      ? MediaQuery.of(context).size.height
                      : MediaQuery.of(context).size.width / 3,
                  width: (Vx.isWeb && ResponsiveLayout.isSmallScreen(context))
                      ? MediaQuery.of(context).size.width
                      : MediaQuery.of(context).size.width / 2.5,
                  child: Column(children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50.0,
                      padding: EdgeInsets.only(left: 20.0),
                      color: ColorCodes.lightGreyWebColor,
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            S .of(context).signup_otp,//"Signup using OTP",
                            style: TextStyle(
                                color: ColorCodes.mediumBlackColor,
                                fontSize: 20.0),
                          )),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 25.0),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                S .of(context).please_check_otp_sent_to_your_mobile_number,//'Please check OTP sent to your mobile number',
                                style: TextStyle(
                                    color: ColorCodes.lightblack,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0),

                                // textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(width: 20.0),
                                Text(
                                  IConstants.countryCode + '  $mobile',
                                  style: new TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: 16.0),
                                ),
                                SizedBox(width: 30.0),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    _dialogforSignIn();
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: ColorCodes.baseColordark, width: 1.5),
                                    ),
                                    child: Center(
                                        child: Text(
                                            S .of(context).change,//'Change',
                                            style: TextStyle(
                                                color: ColorCodes.black,
                                                fontSize: 13))),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                S .of(context).enter_otp,//'Enter OTP',
                                style: TextStyle(
                                    color: ColorCodes.greyColord, fontSize: 14),
                                //textAlign: TextAlign.left,
                              ),
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // Auto Sms
                                  Container(
                                      height: 40,
                                      //width: MediaQuery.of(context).size.width*80/100,
                                      width: (Vx.isWeb &&
                                          ResponsiveLayout.isSmallScreen(
                                              context))
                                          ? MediaQuery.of(context).size.width /
                                          2
                                          : MediaQuery.of(context).size.width /
                                          3,
                                      //padding: EdgeInsets.zero,
                                      child: PinFieldAutoFill(
                                          controller: controller,
                                          decoration: UnderlineDecoration(
                                              colorBuilder: FixedColorBuilder(
                                                  ColorCodes.greyColor)),
                                          onCodeChanged: (text) {
                                            otpvalue = text!;
                                            SchedulerBinding.instance!
                                                .addPostFrameCallback(
                                                    (_) => setState(() {}));
                                          },
                                          onCodeSubmitted: (text) {
                                            SchedulerBinding.instance!
                                                .addPostFrameCallback(
                                                    (_) => setState(() {
                                                  otpvalue = text;
                                                }));
                                          },
                                          codeLength: 4,
                                          currentCode: otpvalue)),
                                ]),
                            SizedBox(
                              height: 20,
                            ),
                            _showOtp
                                ? Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      height: 40,
                                      width: (Vx.isWeb &&
                                          ResponsiveLayout
                                              .isSmallScreen(context))
                                          ? MediaQuery.of(context)
                                          .size
                                          .width *
                                          50 /
                                          100
                                          : MediaQuery.of(context)
                                          .size
                                          .width *
                                          32 /
                                          100,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(6),
                                        border: Border.all(
                                            color: ColorCodes.borderdark,
                                            width: 1.5),
                                      ),
                                      child: Center(
                                          child: Text(
                                            S .of(context).resend_otp,//'Resend OTP'
                                          )),
                                    ),
                                  ),
                                  if(Features.callMeInsteadOTP)
                                    Container(
                                      height: 28,
                                      width: 28,
                                      margin: EdgeInsets.only(
                                          left: 20.0, right: 20.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(20),
                                        border: Border.all(
                                            color: ColorCodes.borderdark,
                                            width: 1.5),
                                      ),
                                      child: Center(
                                          child: Text(
                                            S .of(context).or,//'OR',
                                            style: TextStyle(fontSize: 10),
                                          )),
                                    ),
                                  if(Features.callMeInsteadOTP)
                                    _timeRemaining == 0
                                        ? MouseRegion(
                                      cursor:
                                      SystemMouseCursors.click,
                                      child: GestureDetector(
                                        behavior: HitTestBehavior
                                            .translucent,
                                        onTap: () {
                                          otpCall();
                                          _timeRemaining = 60;
                                        },
                                        child: Expanded(
                                          child: Container(
                                            height: 40,
                                            //width: MediaQuery.of(context).size.width*32/100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius
                                                  .circular(6),
                                              border: Border.all(
                                                  color: ColorCodes.primaryColor,
                                                  width: 1.5),
                                            ),

                                            child: Center(
                                                child: Text(
                                                  S .of(context).call_me_instead,//'Call me Instead'
                                                )),
                                          ),
                                        ),
                                      ),
                                    )
                                        : Expanded(
                                      child: Container(
                                        height: 40,
                                        //width: MediaQuery.of(context).size.width*32/100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(
                                              6),
                                          border: Border.all(
                                              color:
                                              ColorCodes.borderdark,
                                              width: 1.5),
                                        ),
                                        child: Center(
                                          child: RichText(
                                            text: TextSpan(
                                              children: <TextSpan>[
                                                new TextSpan(
                                                    text: S .of(context).call_in,//'Call in',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .black)),
                                                new TextSpan(
                                                  text:
                                                  ' 00:$_timeRemaining',
                                                  style: TextStyle(
                                                    color: ColorCodes.varcolorlight,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                ])
                                : Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                _timeRemaining == 0
                                    ? MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    behavior:
                                    HitTestBehavior.translucent,
                                    onTap: () {
                                      //  _showCall = true;
                                      _showOtp = true;
                                      _timeRemaining += 30;
                                      Otpin30sec();
                                    },
                                    child: Expanded(
                                      child: Container(
                                        height: 40,
                                        width: (Vx.isWeb &&
                                            ResponsiveLayout
                                                .isSmallScreen(
                                                context))
                                            ? MediaQuery.of(context)
                                            .size
                                            .width *
                                            30 /
                                            100
                                            : MediaQuery.of(context)
                                            .size
                                            .width *
                                            15 /
                                            100,
                                        //width: MediaQuery.of(context).size.width*32/100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(
                                              6),
                                          border: Border.all(
                                              color: ColorCodes.primaryColor,
                                              width: 1.5),
                                        ),
                                        child: Center(
                                            child:
                                            Text(S .of(context).resend_otp,//'Resend OTP'
                                            )),
                                      ),
                                    ),
                                  ),
                                )
                                    : Expanded(
                                  child: Container(
                                    height: 40,
                                    //width: MediaQuery.of(context).size.width*40/100,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(6),
                                      border: Border.all(
                                          color: ColorCodes.baseColordark,
                                          width: 1.5),
                                    ),
                                    child: Center(
                                      child: RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            new TextSpan(
                                                text:
                                                S .of(context).resend_otp_in,//'Resend Otp in',
                                                style: TextStyle(
                                                    color: Colors
                                                        .black)),
                                            new TextSpan(
                                              text:
                                              ' 00:$_timeRemaining',
                                              style: TextStyle(
                                                color: ColorCodes.varcolorlight,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if(Features.callMeInsteadOTP)
                                  Container(
                                    height: 28,
                                    width: 28,
                                    margin: EdgeInsets.only(
                                        left: 20.0, right: 20.0),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(20),
                                      border: Border.all(
                                          color: ColorCodes.borderdark,
                                          width: 1.5),
                                    ),
                                    child: Center(
                                        child: Text(
                                          S .of(context).or,//'OR',
                                          style: TextStyle(fontSize: 10),
                                        )),
                                  ),
                                if(Features.callMeInsteadOTP)
                                  Expanded(
                                    child: Container(
                                      height: 40,
                                      //width: MediaQuery.of(context).size.width*32/100,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(6),
                                        border: Border.all(
                                            color: ColorCodes.borderdark,
                                            width: 1.5),
                                      ),
                                      child: Center(
                                          child: Text(S .of(context).call_me_instead,//'Call me Instead'
                                          )),
                                    ),
                                  ),
                              ],
                            ),
                          ]),
                    ),
                    Spacer(),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            _verifyOtp();
                            _dialogforProcessing();
                          },
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
                                S .of(context).login,//"LOGIN",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Theme.of(context).buttonColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )),
                    ),
                  ]));
            }));
    _startTimer();
    showDialog(
        context: ctx,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return alert;
        });
  }
  void _startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      //setState(() {
      (_timeRemaining > 0) ? _timeRemaining-- : _timer!.cancel();
      //});
      _events!.add(_timeRemaining);
    });
  }



  addListnameToSF(String value) async {
    PrefUtils.prefs!.setString('list_name', value);
  }

  _saveFormTwo() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    } //it will check all validators
    _form.currentState!.save();
    Navigator.of(context).pop();
    _dialogforProceesing(context, S.current.creating_list);

    Provider.of<BrandItemsList>(context, listen: false).CreateShoppinglist().then((_) {
     /* Provider.of<BrandItemsList>(context, listen: false).fetchShoppinglist().then((_) {
        shoplistData = Provider.of<BrandItemsList>(context, listen: false);
        Navigator.of(context).pop();
        _dialogforShoppinglistTwo(context);
      });*/
      _auth.getuserProfile(onsucsess: (value){
        shoplistData = (VxState.store as GroceStore).ShoppingList;
        Navigator.of(context).pop();
        _dialogforShoppinglistTwo(context);
      },onerror: (){

      });
    });
  }

  additemtolistTwo() {
    final shoplistDataTwo = shoplistData;//Provider.of<BrandItemsList>(context, listen: false);
    _dialogforProceesing(context, "Add item to list...");
    for (int i = 0; i < shoplistDataTwo.length; i++) {
      //adding item to multiple list
      if (shoplistDataTwo[i].listcheckbox == true) {
        addtoshoppinglisttwo(i);
      }
    }
  }



  addtoshoppinglisttwo(i) async {
    final shoplistDataTwo = shoplistData;//Provider.of<BrandItemsList>(context, listen: false);
    final routeArgs =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final itemid = routeArgs['itemid'];

    Provider.of<BrandItemsList>(context, listen: false).AdditemtoShoppinglist(
        widget.itemdata!.id.toString(), widget.itemdata!.type == "1" ?widget.itemdata!.id.toString():widget.itemdata!.priceVariation![itemindex].id.toString(), shoplistDataTwo[i].id!,widget.itemdata!.type.toString()).then((_) {
      /*Provider.of<BrandItemsList>(context, listen: false).fetchShoppinglist().then((_) {
        shoplistData = Provider.of<BrandItemsList>(context, listen: false);
        Navigator.of(context).pop();
      });*/
      _auth.getuserProfile(onsucsess: (value){
        shoplistData = (VxState.store as GroceStore).ShoppingList;
        shoplistData[i].listcheckbox = false;
        Navigator.of(context).pop();
      },onerror: (){

      });
    });
  }


  _dialogforProceesing(BuildContext context, String text) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              child: Container(
                  width: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
                  height: 100.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(
                        width: 40.0,
                      ),
                      Text(text),
                    ],
                  )),
            );
          });
        });
  }


  _dialogforCreatelistTwo(BuildContext context, shoplistData) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              child: Container(
                  width: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
                  height: 250.0,
                  margin: EdgeInsets.only(
                      left: 20.0, top: 10.0, right: 10.0, bottom: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        S.current.create_shopping_list,
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Theme
                                .of(context)
                                .primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Form(
                        key: _form,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return S.current.please_enter_list_name;
                                }
                                return null; //it means user entered a valid input
                              },
                              onSaved: (value) {
                                addListnameToSF(value!);
                              },
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: S.current.shopping_list_name,
                                labelStyle: TextStyle(
                                    color: ColorCodes.primaryColor),
                                contentPadding: EdgeInsets.all(12),
                                hintText: S.of(context).monthly_grocery,//'ex: Monthly Grocery',
                                hintStyle: TextStyle(
                                    color: Colors.black12, fontSize: 10.0),
                                //prefixIcon: Icon(Icons.alternate_email, color: Theme.of(context).accentColor),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme
                                            .of(context)
                                            .focusColor
                                            .withOpacity(0.2))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme
                                            .of(context)
                                            .focusColor
                                            .withOpacity(0.5))),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme
                                            .of(context)
                                            .focusColor
                                            .withOpacity(0.2))),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          _saveFormTwo();
                        },
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          child: Center(
                              child: Text(
                                S.current.create_shopping_list,
                                textAlign: TextAlign.center,
                                style:
                                TextStyle(color: ColorCodes.whiteColor/*Theme
                                    .of(context)
                                    .buttonColor*/),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          child: Center(
                              child: Text(
                                S.current.cancel,
                                textAlign: TextAlign.center,
                                style:
                                TextStyle(color: ColorCodes.whiteColor),
                              )),
                        ),
                      ),
                    ],
                  )),
            );
          });
        });
  }

  _dialogforShoppinglistTwo(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          shoplistData = (VxState.store as GroceStore).ShoppingList;
          //final x = Provider.of<BrandItemsList>(context, listen: false);
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.0)),
                child: Container(
                  width: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                      left: 10.0, top: 20.0, right: 10.0, bottom: 30.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          S.current.add_to_list,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Theme
                                  .of(context)
                                  .primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        SizedBox(
                          child: new ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: shoplistData.length,
                            itemBuilder: (_, i) =>
                                Row(
                                  children: [
                                    Checkbox(
                                      checkColor: ColorCodes.primaryColor,
                                      activeColor: ColorCodes.whiteColor,
                                      value: shoplistData[i].listcheckbox,
                                      onChanged: ( bool? value) async {
                                        setState(() {
                                          /*x.itemsshoplist[i].listcheckbox*/ shoplistData[i].listcheckbox = value;
                                        });
                                      },
                                    ),
                                    Text(/*x.itemsshoplist[i].listname!*/shoplistData[i].name!,
                                        style: TextStyle(fontSize: 18.0)),
                                  ],
                                ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();

                            _dialogforCreatelistTwo(context, shoplistData);

                            for (int i = 0; i < shoplistData.length/*x.itemsshoplist.length*/; i++) {
                              /* x.itemsshoplist[i].listcheckbox*/ shoplistData[i].listcheckbox = false;
                            }
                          },
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 10.0,
                              ),
                              Icon(
                                Icons.add,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                S.current.create_new,
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 18.0),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            bool check = false;
                            for (int i = 0; i < /*x.itemsshoplist.length*/shoplistData.length; i++) {
                              if (/*x.itemsshoplist[i].listcheckbox!*/shoplistData[i].listcheckbox!)
                                setState(() {
                                  check = true;
                                });
                            }
                            if (check) {
                              Navigator.of(context).pop();
                              additemtolistTwo();
                            } else {
                              Fluttertoast.showToast(
                                  msg: S.current.please_select_atleastonelist,
                                  fontSize: MediaQuery.of(context).textScaleFactor *13,
                                  backgroundColor: Colors.black87,
                                  textColor: Colors.white);
                            }
                          },
                          child: Container(
                            width: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
                            // color: Theme.of(context).primaryColor,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: Theme
                                  .of(context)
                                  .primaryColor,
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                            child: Center(
                                child: Text(
                                  S.current.add,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme
                                          .of(context)
                                          .buttonColor),
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            for (int i = 0; i < shoplistData.length; i++) {
                              /*x.itemsshoplist[i].listcheckbox*/shoplistData[i].listcheckbox = false;
                            }
                          },
                          child: Container(
                            width: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
                            // color: Theme.of(context).primaryColor,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                            child: Center(
                                child: Text(
                                  S.current.cancel,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme
                                          .of(context)
                                          .buttonColor),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    bool _isStock = false;
    double deviceWidth = MediaQuery.of(context).size.width;
    int widgetsInRow = 2;
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    if (deviceWidth > 1200) {
      widgetsInRow = 5;
    } else if (deviceWidth > 768) {
      widgetsInRow = 3;
    }
    double aspectRatio =   (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
    (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 372:
    Features.btobModule?(deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 70 :
    (!Features.ismultivendor) ? (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 165 : (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 150;
    if (_checkmembership) {
      colorRight = 0xffffffff;
      colorLeft = 0xffffffff;
    } else {
      if (varmemberprice == '-' || varmemberprice == "0") {
        setState(() {
          colorRight = 0xffffffff;
          colorLeft = 0xffffffff;
        });
      } else {
        setState(() {
          colorRight = 0xff3d8d3c;
          colorLeft = 0xff8abb50;
        });
      }
    }
    setState(() {
      if(varstock!=null)
        if (int.parse(varstock!) <= 0) {
          _isStock = false;
        } else {
          _isStock = true;
        }
    });

    showoptions1() {
      if(VxState.store.userData.membership! == "1"){
        _checkmembership = true;
      } else {
        _checkmembership = false;
        for (int i = 0; i < productBox.length; i++) {
          if (productBox[i].mode == "1") {
            _checkmembership = true;
          }
        }
      }

      (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
      showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return  Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.0)),
                child: Container(
                  width: MediaQuery.of(context).size.width / 2.9,
                  //height: 200,
                  padding: EdgeInsets.fromLTRB(30, 20, 20, 20),
                  child:
                  (widget.fromScreen == "search_item_multivendor" && Features.ismultivendor)?
                  ItemVariation(searchdata: widget.storedsearchdata!,ismember: _checkmembership,selectedindex: itemindex,onselect: (i){
                    setState(() {
                      itemindex = i;
                      // Navigator.of(context).pop();
                    });
                  },fromscreen: "search_item_multivendor",):
                  ItemVariation(itemdata: widget.itemdata!,ismember: _checkmembership,selectedindex: itemindex,onselect: (i){
                    setState(() {
                      itemindex = i;
                      // Navigator.of(context).pop();
                    });
                  },),
                ),
              );
            });
          })
          .then((_) => setState(() { }))
          :showModalBottomSheet<dynamic>(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return

              (widget.fromScreen == "search_item_multivendor" && Features.ismultivendor)?
              ItemVariation(searchdata: widget.storedsearchdata!,ismember: _checkmembership,selectedindex: itemindex,onselect: (i){
                setState(() {
                  itemindex = i;
                  // Navigator.of(context).pop();
                });
              },fromscreen: "search_item_multivendor"):
              ItemVariation(itemdata: widget.itemdata!,ismember: _checkmembership,selectedindex: itemindex,onselect: (i){
              setState(() {
                itemindex = i;
                // Navigator.of(context).pop();
              });
            },);
          })
          .then((_) => setState(() { }));
    }

    double margins;
    if(widget.fromScreen == "search_item_multivendor" && Features.ismultivendor){
       margins = (widget.storedsearchdata!.type == "1") ? Calculate().getmargin(
          widget.storedsearchdata!.mrp,
          store.userData.membership! == "0" || store.userData.membership! == "2"
              ?
          widget.storedsearchdata!.discointDisplay! ? widget.storedsearchdata!.price : widget
              .storedsearchdata!.mrp
              : widget.storedsearchdata!.membershipDisplay! ? widget.storedsearchdata!
              .membershipPrice : widget.storedsearchdata!.price) :
      Calculate().getmargin(widget.storedsearchdata!.priceVariation![itemindex].mrp.toString(),
          store.userData.membership! == "0" || store.userData.membership! == "2"
              ?
          widget.storedsearchdata!.priceVariation![itemindex].discointDisplay! ? widget
              .storedsearchdata!.priceVariation![itemindex].price : widget.storedsearchdata!
              .priceVariation![itemindex].mrp
              : widget.storedsearchdata!.priceVariation![itemindex].membershipDisplay!
              ? widget.storedsearchdata!.priceVariation![itemindex].membershipPrice
              : widget.storedsearchdata!.priceVariation![itemindex].price);
    }
    else {
       margins = (widget.itemdata!.type == "1") ? Calculate().getmargin(
          widget.itemdata!.mrp,
          store.userData.membership! == "0" || store.userData.membership! == "2"
              ?
          widget.itemdata!.discointDisplay! ? widget.itemdata!.price : widget
              .itemdata!.mrp
              : widget.itemdata!.membershipDisplay! ? widget.itemdata!
              .membershipPrice : widget.itemdata!.price) :
      Calculate().getmargin(widget.itemdata!.priceVariation![itemindex].mrp,
          store.userData.membership! == "0" || store.userData.membership! == "2"
              ?
          widget.itemdata!.priceVariation![itemindex].discointDisplay! ? widget
              .itemdata!.priceVariation![itemindex].price : widget.itemdata!
              .priceVariation![itemindex].mrp
              : widget.itemdata!.priceVariation![itemindex].membershipDisplay!
              ? widget.itemdata!.priceVariation![itemindex].membershipPrice
              : widget.itemdata!.priceVariation![itemindex].price);
    }

    if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)) {

      if (store.userData.membership! =="1") {
        setState(() {
          _checkmembership = true;
        });
      } else {
        setState(() {
          _checkmembership = false;
        });
        for (int i = 0; i < productBox.length; i++) {
          if (productBox[i].mode == "1") {
            setState(() {
              _checkmembership = true;
            });
          }
        }
      }

      if(_checkmembership) { //Membered user
        if(widget.itemdata!.type == "1") {  //SingleSku item
          if (widget.itemdata!.membershipDisplay!) { //Eligible to display membership price
            _price = widget.itemdata!.membershipPrice!;
            _mrp = widget.itemdata!.mrp!;
          } else if (widget.itemdata!.discointDisplay!) { //Eligible to display discounted price
            _price = widget.itemdata!.price!;
            _mrp = widget.itemdata!.mrp!;
          } else { //Otherwise display mrp
            _price = widget.itemdata!.mrp!;
          }
        }
        else{ //multisku
          if (widget.itemdata!.priceVariation![Features.btobModule
              ? _groupValue
              : itemindex]
              .membershipDisplay!) { //Eligible to display membership price
            _price = widget.itemdata!.priceVariation![Features.btobModule
                ? _groupValue
                : itemindex].membershipPrice!;
            _mrp = widget.itemdata!.priceVariation![Features.btobModule
                ? _groupValue
                : itemindex].mrp!;
          } else if (widget.itemdata!.priceVariation![Features.btobModule
              ? _groupValue
              : itemindex]
              .discointDisplay!) { //Eligible to display discounted price
            _price = widget.itemdata!.priceVariation![Features.btobModule
                ? _groupValue
                : itemindex].price!;
            _mrp = widget.itemdata!.priceVariation![Features.btobModule
                ? _groupValue
                : itemindex].mrp!;
          } else { //Otherwise display mrp
            _price = widget.itemdata!.priceVariation![Features.btobModule
                ? _groupValue
                : itemindex].mrp!;
          }
        }
      } else { //Non membered user

        if(widget.itemdata!.type == "1") { //singlesku
          if(widget.itemdata!.discointDisplay!){ //Eligible to display discounted price
            _price = widget.itemdata!.price!;
            _mrp = widget.itemdata!.mrp!;
          } else { //Otherwise display mrp
            _price = widget.itemdata!.mrp!;
          }
        }
        else{ //multisku
          if(widget.itemdata!.priceVariation![Features.btobModule?_groupValue:itemindex].discointDisplay!){ //Eligible to display discounted price
            _price = widget.itemdata!.priceVariation![Features.btobModule?_groupValue:itemindex].price!;
            _mrp = widget.itemdata!.priceVariation![Features.btobModule?_groupValue:itemindex].mrp!;
          } else { //Otherwise display mrp
            _price = widget.itemdata!.priceVariation![Features.btobModule?_groupValue:itemindex].mrp!;
          }
        }

      }
      if(Features.iscurrencyformatalign) {
        _price = '${_price} ' + IConstants.currencyFormat;
        if(_mrp != "")
          _mrp = '${_mrp} ' + IConstants.currencyFormat;
      } else {
        _price = IConstants.currencyFormat + '${_price} ';
        if(_mrp != "")
          _mrp =  IConstants.currencyFormat + '${_mrp} ';
      }


      print("margins....selling item..."+margins.toString());

      return  widget.fromScreen == "search_item_multivendor" && Features.ismultivendor?
           widget.storedsearchdata!.type=="1"?Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),
          border: Border.all(color: ColorCodes.shimmercolor),
        ),
        margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0, right: 5),
        child: Column(
          children: [
            Stack(
              children: [
                ItemBadge(
                  outOfStock: widget.storedsearchdata!.stock!<=0?OutOfStock(singleproduct: false,):null,
                  child: Align(
                    alignment: Alignment.center,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          if(widget.fromScreen == "sellingitem_screen") {
                            Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid": widget.storedsearchdata!.id.toString(),"productId": widget.storedsearchdata!.id!});

                          }
                          else{
                            Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid": widget.storedsearchdata!.id.toString(),"productId": widget.storedsearchdata!.id!});
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10.0, bottom: 8.0),
                          child: CachedNetworkImage(
                            imageUrl: widget.storedsearchdata!.itemFeaturedImage,
                            errorWidget: (context, url, error) => Image.asset(
                              Images.defaultProductImg,
                              width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                              height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                            ),
                            placeholder: (context, url) => Image.asset(
                              Images.defaultProductImg,
                              width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                              height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                            ),
                            width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                            height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                            //  fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      if(margins > 0)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                3.0),
                            color: ColorCodes.primaryColor,//Color(0xff6CBB3C),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8, top:4, bottom: 4),
                            child: Text(
                              margins.toStringAsFixed(0) + S .of(context).off ,//"% OFF",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 9,
                                  color: ColorCodes.whiteColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      if(margins > 0)
                        Spacer(),

                      (widget.itemdata!.eligibleForExpress == "0")?
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              3.0),
                          border: Border.all(
                              color: ColorCodes.varcolor),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2, right: 2, top:4, bottom: 4),
                          child: Row(
                            children: [
                              Text(
                                S .of(context).express ,//"% OFF",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 9,
                                    color: ColorCodes.primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 2),
                              Image.asset(Images.express,
                                color: ColorCodes.primaryColor,
                                height: 11.0,
                                width: 11.0,),

                            ],
                          ),
                        ),
                      ) : SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(padding:EdgeInsets.only(left: 10),
                  child: Column(
                    children: [
                      Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      widget.storedsearchdata!.brand!,
                                      style: TextStyle(
                                          fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 12, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height:30,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        widget.storedsearchdata!.shop!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                widget.storedsearchdata!.location!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 12,
                                    ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Image.asset(Images.starimg,
                                        height: 12,
                                        width: 12,
                                        color: ColorCodes.darkthemeColor),
                                    SizedBox(width: 3,),
                                    Text(
                                      widget.storedsearchdata!.ratings!.toStringAsFixed(2),
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: ColorCodes.darkthemeColor),
                                    ),
                                    SizedBox(width: 15,),
                                    Icon(Icons.info, color: ColorCodes.lightGreyColor, size: 6),
                                    SizedBox(width: 15,),
                                    Text(
                                      widget.storedsearchdata!.distance!.toStringAsFixed(2) +
                                          /*" Km"*/S.of(context).km,
                                      style: TextStyle(
                                          fontSize: 11, color: ColorCodes.greyColord),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 40,
                                child: Text(
                                  widget.storedsearchdata!.itemName!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: ResponsiveLayout.isSmallScreen(context) ? 13 : ResponsiveLayout.isMediumScreen(context) ? 14 : 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              Container(
                                  child: Row(
                                    children: <Widget>[
                                       Row(
                                          children: <Widget>[
                                            if(Features.isMembership)
                                              _checkmembership?Container(
                                                width: 25.0,
                                                height: 25.0,
                                                child: Image.asset(
                                                  Images.starImg,
                                                ),
                                              ):SizedBox.shrink(),
                                            new RichText(
                                              text: new TextSpan(
                                                style: new TextStyle(
                                                  fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 14 : 15,
                                                  color: Colors.black,
                                                ),
                                                children: <TextSpan>[
//                            if(varmemberprice.toString() == varmrp.toString())
                                                  new TextSpan(
                                                      text: Features.iscurrencyformatalign?
                                                      '${_checkmembership?widget.storedsearchdata!.membershipPrice:widget.storedsearchdata!.price} ' + IConstants.currencyFormat:
                                                      IConstants.currencyFormat + '${_checkmembership?widget.storedsearchdata!.membershipPrice:widget.storedsearchdata!.price} ',
                                                      style: new TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black,
                                                        fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 14 : 15,)),
                                                  new TextSpan(
                                                      text: widget.storedsearchdata!.price!=widget.storedsearchdata!.mrp?
                                                      Features.iscurrencyformatalign?
                                                      '${widget.storedsearchdata!.mrp} ' + IConstants.currencyFormat:
                                                      IConstants.currencyFormat + '${widget.storedsearchdata!.mrp} ':"",
                                                      style: TextStyle(
                                                          decoration:
                                                          TextDecoration.lineThrough,
                                                          fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 14 : 15)),
                                                ],
                                              ),
                                            ),
                                          ]),
                                      if(widget.storedsearchdata!.eligibleForExpress == "0")
                                        Image.asset(Images.express,
                                          height: 20.0,
                                          width: 25.0,),
                                      Spacer(),
                                      if(Features.isLoyalty)
                                        if(double.parse(widget.storedsearchdata!.loyalty.toString()) > 0)
                                          Container(
                                            padding: EdgeInsets.only(right: 5),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Image.asset(Images.coinImg,
                                                  height: 15.0,
                                                  width: 20.0,),
                                                SizedBox(width: 4),
                                                Text(widget.storedsearchdata!.loyalty.toString()),
                                              ],
                                            ),
                                          ),
                                    ],
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              if(Features.netWeight && widget.storedsearchdata!.vegType == "fish")
                                Container(
                                  width: (MediaQuery
                                      .of(context)
                                      .size
                                      .width / 2) + 70,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            Features.iscurrencyformatalign?
                                            /*"Whole Uncut:"*/S.of(context).whole_uncut +" " +
                                                widget.storedsearchdata!.salePrice! + IConstants.currencyFormat +" / "+ /*"500 G"*/S.of(context).gram:
                                            /*"Whole Uncut:"*/S.of(context).whole_uncut +" "+ IConstants.currencyFormat +
                                                widget.storedsearchdata!.salePrice! +" / "+ /*"500 G"*/S.of(context).gram,
                                            style: new TextStyle( fontSize: ResponsiveLayout.isSmallScreen(context) ? 13 : ResponsiveLayout.isMediumScreen(context) ? 14 : 15, fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                      SizedBox(height: 3),
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: Text(/*"Gross Weight:"*/S.of(context).gross_weight +" "+
                                                    widget.storedsearchdata!.weight!,
                                                    style: new TextStyle( fontSize: ResponsiveLayout.isSmallScreen(context) ? 13 : ResponsiveLayout.isMediumScreen(context) ? 14 : 15, fontWeight: FontWeight.bold)
                                                ),
                                              ),
                                              Container(
                                                child: Text(/*"Net Weight:"*/S.of(context).net_weight +" "+
                                                    widget.storedsearchdata!.netWeight!,
                                                    style: new TextStyle( fontSize: ResponsiveLayout.isSmallScreen(context) ? 13 : ResponsiveLayout.isMediumScreen(context) ? 14 : 15, fontWeight: FontWeight.bold)
                                                ),
                                              ),

                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          )),
                      SizedBox(
                        width: 10,
                      ),

                    ],
                  ),
                ),
//                SizedBox(height: 10,),
                Column(
                  children: [
                    Container(
                      width: (MediaQuery.of(context).size.width / 2) + 40,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: (MediaQuery.of(context).size.width / 4) + 30,
                            padding: EdgeInsets.only(bottom: 10,left: 10,right: 10),
                            child:  Container(
                              decoration: BoxDecoration(
                                  color: ColorCodes.whiteColor,
                                  borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(2.0),
                                    topRight: const Radius.circular(2.0),
                                    bottomLeft: const Radius.circular(2.0),
                                    bottomRight: const Radius.circular(2.0),
                                  )),
                              height: 30,
                              width: (MediaQuery.of(context).size.width / 4) + 30,
                              padding: EdgeInsets.fromLTRB(5.0, 4.5, 0.0, 4.5),
                              child: SizedBox.shrink(),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),

                          if(ResponsiveLayout.isSmallScreen(context))
                            if(Features.isSubscription)
                              (widget.storedsearchdata!.eligibleForSubscription == "0")?
                              (widget.storedsearchdata!.stock!>=0)?
                              Container(
                                width: (widget.fromScreen == "brands_screen" || widget.fromScreen == "sellingitem_screen" || widget.fromScreen == "shoppinglistitem_screen" ||
                                    widget.fromScreen == "home_screen" ||widget.fromScreen == "searchitem_screen" || widget.fromScreen=="not_product_screen")?(MediaQuery.of(context).size.width / 5.8)+20:
                                (MediaQuery.of(context).size.width / 7.5)+20 ,

                                child: GestureDetector(
                                  onTap: () async {
                                    if(checkskip && Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                                      _dialogforSignIn();
                                    }
                                    else {
                                      (checkskip) ?
                                      Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push):
                                      Navigation(context, name: Routename.SubscribeScreen, navigatore: NavigatoreTyp.Push,
                                          qparms: {
                                            "itemid": widget.storedsearchdata!.id,
                                            "itemname": widget.storedsearchdata!.itemName,
                                            "itemimg": widget.storedsearchdata!.itemFeaturedImage,
                                            "varname": "",
                                            "varmrp":widget.storedsearchdata!.mrp,
                                            "varprice":  store.userData.membership! == "1" ? widget.storedsearchdata!.membershipPrice.toString() :widget.storedsearchdata!.discointDisplay! ?widget.storedsearchdata!.price.toString():widget.storedsearchdata!.mrp.toString(),
                                            "paymentMode": widget.storedsearchdata!.paymentMode,
                                            "cronTime": widget.storedsearchdata!.subscriptionSlot![0].cronTime,
                                            "name": widget.storedsearchdata!.subscriptionSlot![0].name,
                                            "varid":widget.storedsearchdata!.id,
                                            "brand": widget.storedsearchdata!.brand,
                                            "deliveriesarray": ( widget.fromScreen == "search_item_multivendor" && Features.ismultivendor)?widget.storedsearchdata!.subscriptionSlot![0].deliveries :widget.itemdata!.subscriptionSlot![0].deliveries,
                                            "daily":(  widget.fromScreen == "search_item_multivendor" && Features.ismultivendor)?widget.storedsearchdata!.subscriptionSlot![0].daily :widget.itemdata!.subscriptionSlot![0].daily,
                                            "dailyDays": (  widget.fromScreen == "search_item_multivendor" && Features.ismultivendor)?widget.storedsearchdata!.subscriptionSlot![0].dailyDays :widget.itemdata!.subscriptionSlot![0].dailyDays,
                                            "weekend": (  widget.fromScreen == "search_item_multivendor" && Features.ismultivendor)?widget.storedsearchdata!.subscriptionSlot![0].weekend :widget.itemdata!.subscriptionSlot![0].weekend,
                                            "weekendDays": (  widget.fromScreen == "search_item_multivendor" && Features.ismultivendor)?widget.storedsearchdata!.subscriptionSlot![0].weekendDays :widget.itemdata!.subscriptionSlot![0].weekendDays,
                                            "weekday": ( widget.fromScreen == "search_item_multivendor" && Features.ismultivendor)?widget.storedsearchdata!.subscriptionSlot![0].weekday :widget.itemdata!.subscriptionSlot![0].weekday,
                                            "weekdayDays": ( widget.fromScreen == "search_item_multivendor" && Features.ismultivendor)?widget.storedsearchdata!.subscriptionSlot![0].weekdayDays :widget.itemdata!.subscriptionSlot![0].weekdayDays,
                                            "custom": ( widget.fromScreen == "search_item_multivendor" && Features.ismultivendor)?widget.storedsearchdata!.subscriptionSlot![0].custom :widget.itemdata!.subscriptionSlot![0].custom,
                                            "alternativeDays":  ( widget.fromScreen == "search_item_multivendor" && Features.ismultivendor)?widget.storedsearchdata!.subscriptionSlot![0].alternativeDays :widget.itemdata!.subscriptionSlot![0].alternativeDays,
                                            "customDays": ( widget.fromScreen == "search_item_multivendor" && Features.ismultivendor)?widget.storedsearchdata!.subscriptionSlot![0].customDays :widget.itemdata!.subscriptionSlot![0].customDays,

                                          });
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      SizedBox(width: 10,),
                                      Container(
                                        // padding:EdgeInsets.only(left:55,right:55),
                                          height: 30.0,
                                          width: (widget.fromScreen == "brands_screen" || widget.fromScreen == "sellingitem_screen" || widget.fromScreen == "shoppinglistitem_screen" ||
                                              widget.fromScreen == "home_screen" ||widget.fromScreen == "search_item" || widget.fromScreen=="not_product_screen")?(MediaQuery.of(context).size.width / 5.8):
                                          (MediaQuery.of(context).size.width / 7.5) ,
                                          // width: (MediaQuery.of(context).size.width / 4) + 15,
                                          decoration: new BoxDecoration(
                                              border: Border.all(color: ColorCodes.primaryColor),
                                              color: ColorCodes.whiteColor,
                                              borderRadius: new BorderRadius.only(
                                                topLeft: const Radius.circular(2.0),
                                                topRight: const Radius.circular(2.0),
                                                bottomLeft: const Radius.circular(2.0),
                                                bottomRight: const Radius.circular(2.0),
                                              )),
                                          child:
                                          Center(
                                              child: Text(
                                                S.of(context).subscribe_caps,//'SUBSCRIBE',
                                                style: TextStyle(
                                                  color: ColorCodes.primaryColor,
                                                ),
                                                textAlign: TextAlign.center,
                                              ))
                                      ),
                                      SizedBox(width: 10,),
                                    ],
                                  ),
                                ),
                              ):
                              SizedBox(height: 30,):
                              SizedBox(height: 30,),
                          if(ResponsiveLayout.isSmallScreen(context))
                            if(Features.isSubscription)
                              SizedBox(
                                height: 10,
                              ),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                    child: CustomeStepper(searchstoredata:widget.storedsearchdata,from: "search_screen",checkmembership:_checkmembership,alignmnt: StepperAlignment.Vertical,height: (Features.isSubscription)?40:40,addon:(widget.storedsearchdata!.addon!.length > 0)?widget.storedsearchdata!.addon![0]:null,index:itemindex)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                !_checkmembership
                    ? widget.storedsearchdata!.membershipDisplay!
                    ? SizedBox(height: 12,)
                    : SizedBox(height: 12,)
                    : SizedBox(height: 12,),

                if(ResponsiveLayout.isSmallScreen(context))
                  if(Features.isMembership)
                    (widget.fromScreen == "brands_screen" || widget.fromScreen == "sellingitem_screen" || widget.fromScreen == "shoppinglistitem_screen" ||
                        widget.fromScreen == "home_screen" ||widget.fromScreen == "searchitem_screen" || widget.fromScreen=="not_product_screen")?
                    Container(
                      width: (MediaQuery.of(context).size.width / 4) + 30,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child:  !_checkmembership
                          ? widget.storedsearchdata!.membershipDisplay!
                          ? GestureDetector(
                        onTap: () {
                          if(!PrefUtils.prefs!.containsKey("apikey")) {
                            if (kIsWeb && !ResponsiveLayout.isSmallScreen(
                                context)) {
                              LoginWeb(context, result: (sucsess) {
                                if (sucsess) {
                                  Navigator.of(context).pop();
                                  Navigation(context, navigatore: NavigatoreTyp.homenav);
                                } else {
                                  Navigator.of(context).pop();
                                }
                              });
                            } else {
                              Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push);
                            }
                          }
                          else {
                            if (Vx.isWeb &&
                                !ResponsiveLayout.isSmallScreen(context)) {
                              MembershipInfo(context);
                            }
                            else {
                              Navigation(
                                  context, name: Routename.Membership,
                                  navigatore: NavigatoreTyp.Push);
                            }
                          }
                        },
                        child: Container(
                          height: 23,
                          decoration: BoxDecoration(color: ColorCodes.membershipColor),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(width: 10),
                              Image.asset(
                                Images.starImg,
                                height: 12,
                              ),
                              SizedBox(width: 2),
                              Text(
                                  Features.iscurrencyformatalign?
                                  widget.storedsearchdata!.membershipPrice.toString() +  IConstants.currencyFormat:
                                  IConstants.currencyFormat +
                                      widget.storedsearchdata!.membershipPrice.toString(),
                                  style: TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 11 : 12,)),
                              Spacer(),
                              Icon(
                                Icons.lock,
                                color: Colors.black,
                                size: 10,
                              ),
                              SizedBox(width: 2),
                              Icon(
                                Icons.arrow_forward_ios_sharp,
                                color: Colors.black,
                                size: 10,
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                        )
                      )
                          : SizedBox.shrink()
                          : SizedBox.shrink(),
                    )
                        :
                    Container(
                      width: (MediaQuery.of(context).size.width/5.2),
                      child: !_checkmembership
                          ? widget.storedsearchdata!.membershipDisplay!
                          ? GestureDetector(
                        onTap: () {
                          (checkskip &&Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
                          _dialogforSignIn() :
                          (checkskip && !Vx.isWeb)?
                          Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.PushReplacment)
                              :
                          (Vx.isWeb &&
                          !ResponsiveLayout.isSmallScreen(context)) ?
                          MembershipInfo(context):
                          Navigation(context, name: Routename.Membership, navigatore: NavigatoreTyp.Push);
                        },
                        child: Container(
                          height: 23,
                          width: (MediaQuery.of(context).size.width/5.2),

                          decoration:
                          BoxDecoration(color: ColorCodes.membershipColor),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(width: 10),
                              Image.asset(
                                Images.starImg,
                                height: 12,
                              ),
                              SizedBox(width: 2),
                              Text(
                                  Features.iscurrencyformatalign?
                                  widget.storedsearchdata!.membershipPrice.toString() + IConstants.currencyFormat:
                                  IConstants.currencyFormat +
                                      widget.storedsearchdata!.membershipPrice.toString(),
                                  style: TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 11 : 12, color: Colors.black)),
                              Spacer(),
                              Icon(
                                Icons.lock,
                                color: Colors.black,
                                size: 10,
                              ),
                              SizedBox(width: 2),
                              Icon(
                                Icons.arrow_forward_ios_sharp,
                                color: Colors.black,
                                size: 10,
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                        ),
                        //)



                      )
                          : SizedBox.shrink()
                          : SizedBox.shrink(),
                    )
              ],
            ),
          ],
        ),
      ):
      Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),
          border: Border.all(color: ColorCodes.shimmercolor),
        ),
        margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0, right: 5),
        child: Column(
          children: [
            ItemBadge(
              outOfStock: widget.storedsearchdata!.priceVariation![itemindex].stock!<=0?OutOfStock(singleproduct: false,):null,
              child: Align(
                alignment: Alignment.center,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      if(widget.fromScreen == "sellingitem_screen") {
                        Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid": widget.storedsearchdata!.priceVariation![itemindex].menuItemId.toString(),"productId": widget.storedsearchdata!.priceVariation![itemindex].menuItemId.toString()});
                      }
                      else{
                        Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid": widget.storedsearchdata!.priceVariation![itemindex].menuItemId.toString(),"productId": widget.storedsearchdata!.priceVariation![itemindex].menuItemId.toString()});
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 10.0, bottom: 8.0),
                      child: CachedNetworkImage(
                        imageUrl: widget.storedsearchdata!.priceVariation![itemindex].images!.length<=0?widget.storedsearchdata!.itemFeaturedImage:widget.storedsearchdata!.priceVariation![itemindex].images![0].image,
                        errorWidget: (context, url, error) => Image.asset(
                          Images.defaultProductImg,
                          width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                          height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                        ),
                        placeholder: (context, url) => Image.asset(
                          Images.defaultProductImg,
                          width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                          height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                        ),
                        width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                        height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                        //  fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(padding:EdgeInsets.only(left: 10),
                  child: Column(
                    children: [
                      Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height:30,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        widget.storedsearchdata!.shop!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          //fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                widget.storedsearchdata!.location!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 12,
                                    ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Image.asset(Images.starimg,
                                        height: 12,
                                        width: 12,
                                        color: ColorCodes.darkthemeColor),
                                    SizedBox(width: 3,),
                                    Text(
                                      widget.storedsearchdata!.ratings!.toStringAsFixed(2),
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: ColorCodes.darkthemeColor),
                                    ),
                                    SizedBox(width: 15,),
                                    Icon(Icons.info, color: ColorCodes.lightGreyColor, size: 6),
                                    SizedBox(width: 15,),
                                    Text(
                                      widget.storedsearchdata!.distance!.toStringAsFixed(2) +
                                          /*" Km"*/S.of(context).km,
                                      style: TextStyle(
                                          fontSize: 11, color: ColorCodes.greyColord),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 40,
                                      child: Text(
                                        widget.storedsearchdata!.itemName!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: ResponsiveLayout.isSmallScreen(context) ? 13 : ResponsiveLayout.isMediumScreen(context) ? 14 : 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Features.isSubscription && widget.storedsearchdata!.eligibleForSubscription=="0"?
                                  Container(
                                    height:40,
                                    width: 85,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left:0,right:5.0),
                                      child: CustomeStepper(priceVariation:widget.itemdata!.priceVariation![itemindex],itemdata: widget.itemdata,from:"item_screen",height: (Features.isSubscription)?40:40,issubscription: "Subscribe",addon:(widget.itemdata!.addon!.length > 0)?widget.itemdata!.addon![0]:null, index: itemindex),
                                    ),
                                  ):SizedBox.shrink(),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              Container(
                                  child: Row(
                                    children: <Widget>[
                                       Row(
                                          children: <Widget>[
                                            if(Features.isMembership)
                                              _checkmembership?Container(
                                                width: 25.0,
                                                height: 25.0,
                                                child: Image.asset(
                                                  Images.starImg,
                                                ),
                                              ):SizedBox.shrink(),
                                            new RichText(
                                              text: new TextSpan(
                                                style: new TextStyle(
                                                  fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 14 : 15,
                                                  color: Colors.black,
                                                ),
                                                children: <TextSpan>[
//                            if(varmemberprice.toString() == varmrp.toString())
                                                  new TextSpan(
                                                      text: Features.iscurrencyformatalign?
                                                      '${_checkmembership?widget.storedsearchdata!.priceVariation![itemindex].membershipPrice:widget.storedsearchdata!.priceVariation![itemindex].price} ' + IConstants.currencyFormat:
                                                      IConstants.currencyFormat + '${_checkmembership?widget.storedsearchdata!.priceVariation![itemindex].membershipPrice:widget.storedsearchdata!.priceVariation![itemindex].price} ',
                                                      style: new TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black,
                                                        fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 14 : 15,)),
                                                  new TextSpan(
                                                      text: widget.storedsearchdata!.priceVariation![itemindex].price!=widget.storedsearchdata!.priceVariation![itemindex].mrp?
                                                      Features.iscurrencyformatalign?
                                                      '${widget.storedsearchdata!.priceVariation![itemindex].mrp} ' + IConstants.currencyFormat:
                                                      IConstants.currencyFormat + '${widget.storedsearchdata!.priceVariation![itemindex].mrp} ':"",
                                                      style: TextStyle(
                                                          decoration:
                                                          TextDecoration.lineThrough,
                                                          fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 14 : 15)),
                                                ],
                                              ),
                                            ),
                                          ]),
                                      if(widget.storedsearchdata!.eligibleForExpress == "0")
                                        Image.asset(Images.express,
                                          height: 20.0,
                                          width: 25.0,),
                                      Spacer(),
                                      if(Features.isLoyalty)
                                        if(double.parse(widget.storedsearchdata!.priceVariation![itemindex].loyalty.toString()) > 0)
                                          Container(
                                            padding: EdgeInsets.only(right: 5),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Image.asset(Images.coinImg,
                                                  height: 15.0,
                                                  width: 20.0,),
                                                SizedBox(width: 4),
                                                Text(widget.storedsearchdata!.priceVariation![itemindex].loyalty.toString()),
                                              ],
                                            ),
                                          ),
                                    ],
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              if(Features.netWeight && widget.storedsearchdata!.vegType == "fish")
                                Container(
                                  width: (MediaQuery
                                      .of(context)
                                      .size
                                      .width / 2) + 70,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            Features.iscurrencyformatalign?
                                            /*"Whole Uncut:"*/S.of(context).whole_uncut +" " +
                                                widget.storedsearchdata!.salePrice! + IConstants.currencyFormat +" / "+ /*"500 G"*/S.of(context).gram:
                                            /*"Whole Uncut:"*/S.of(context).whole_uncut +" "+ IConstants.currencyFormat +
                                                widget.storedsearchdata!.salePrice! +" / "+ /*"500 G"*/S.of(context).gram,
                                            style: new TextStyle( fontSize: ResponsiveLayout.isSmallScreen(context) ? 13 : ResponsiveLayout.isMediumScreen(context) ? 14 : 15, fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                      SizedBox(height: 3),
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: Text(/*"Gross Weight:"*/S.of(context).gross_weight +" "+
                                                    widget.storedsearchdata!.priceVariation![itemindex].weight!,
                                                    style: new TextStyle( fontSize: ResponsiveLayout.isSmallScreen(context) ? 13 : ResponsiveLayout.isMediumScreen(context) ? 14 : 15, fontWeight: FontWeight.bold)
                                                ),
                                              ),
                                              Container(
                                                child: Text(/*"Net Weight:"*/S.of(context).net_weight +" "+
                                                    widget.storedsearchdata!.priceVariation![itemindex].netWeight!,
                                                    style: new TextStyle( fontSize: ResponsiveLayout.isSmallScreen(context) ? 13 : ResponsiveLayout.isMediumScreen(context) ? 14 : 15, fontWeight: FontWeight.bold)
                                                ),
                                              ),

                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),


                            ],
                          )),
                      SizedBox(
                        width: 10,
                      ),

                    ],
                  ),
                ),
//                SizedBox(height: 10,),
                Column(
                  children: [
                    Container(
                      width: (MediaQuery.of(context).size.width / 2) + 40,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: (MediaQuery.of(context).size.width / 4) + 30,
                            padding: EdgeInsets.only(bottom: 10,left: 10,right: 10),
                            child: ( widget.storedsearchdata!.priceVariation!.length > 1)
                                ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  //isweb
                                  // showoptions();
                                  showoptions1();
                                });

                              },
                              child: Container(
                                height: 30,
                                width: (MediaQuery.of(context).size.width / 4) + 30,
                                decoration: BoxDecoration(
                                    color: ColorCodes.varcolor,
                                    borderRadius: new BorderRadius.only(
                                      topLeft: const Radius.circular(2.0),
                                      bottomLeft: const Radius.circular(2.0),
                                      topRight: const Radius.circular(2.0),
                                      bottomRight: const Radius.circular(2.0),
                                    )),
                                child: Row(
                                  children: [
                                  Text(
                                      //"$varname"+" "+"$unit",
                                      "${widget.storedsearchdata!.priceVariation![itemindex].variationName}"+" "+"${widget.storedsearchdata!.priceVariation![itemindex].unit}",
                                      style:
                                      TextStyle(color: ColorCodes.darkgreen,fontWeight: FontWeight.bold),
                                    ),
                                    Spacer(),
                                    Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: ColorCodes.varcolor,
                                          borderRadius: new BorderRadius.only(
                                            topRight:
                                            const Radius.circular(2.0),
                                            bottomRight:
                                            const Radius.circular(2.0),
                                          )),
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        color:ColorCodes.darkgreen,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                                : Container(
                              decoration: BoxDecoration(
                                  color: ColorCodes.varcolor,
                                  borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(2.0),
                                    topRight: const Radius.circular(2.0),
                                    bottomLeft: const Radius.circular(2.0),
                                    bottomRight: const Radius.circular(2.0),
                                  )),
                              height: 30,
                              width: (MediaQuery.of(context).size.width / 4) + 30,
                              padding: EdgeInsets.fromLTRB(5.0, 4.5, 0.0, 4.5),
                              child: Text(
                                "${widget.storedsearchdata!.priceVariation![itemindex].variationName}"+" "+"${widget.storedsearchdata!.priceVariation![itemindex].unit}",
                                style:
                                TextStyle(color: ColorCodes.darkgreen,fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),

                          if(ResponsiveLayout.isSmallScreen(context))
                            if(Features.isSubscription)
                              (widget.storedsearchdata!.eligibleForSubscription == "0")?
                              (widget.storedsearchdata!.priceVariation![itemindex].stock!>=0)?
                              Container(
                                width: (widget.fromScreen == "brands_screen" || widget.fromScreen == "sellingitem_screen" || widget.fromScreen == "shoppinglistitem_screen" ||
                                    widget.fromScreen == "home_screen" ||widget.fromScreen == "searchitem_screen" || widget.fromScreen=="not_product_screen")?(MediaQuery.of(context).size.width / 5.8)+20:
                                (MediaQuery.of(context).size.width / 7.5)+20 ,

                                child: GestureDetector(
                                  onTap: () async {
                                    if(checkskip &&Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                                      _dialogforSignIn();
                                    }
                                    else {
                                      (checkskip) ?
                                      Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push):
                                      Navigation(context, name: Routename.SubscribeScreen, navigatore: NavigatoreTyp.Push,
                                          qparms: {
                                            "itemid": widget.storedsearchdata!.id,
                                            "itemname": widget.storedsearchdata!.itemName,
                                            "itemimg": widget.storedsearchdata!.itemFeaturedImage,
                                            "varname": widget.storedsearchdata!.priceVariation![itemindex].variationName!+widget.storedsearchdata!.priceVariation![itemindex].unit!,
                                            "varmrp":widget.storedsearchdata!.priceVariation![itemindex].mrp,
                                            "varprice":  store.userData.membership! == "1" ? widget.storedsearchdata!.priceVariation![itemindex].membershipPrice.toString() :widget.storedsearchdata!.priceVariation![itemindex].discointDisplay! ?widget.storedsearchdata!.priceVariation![itemindex].price.toString():widget.storedsearchdata!.priceVariation![itemindex].mrp.toString(),
                                            "paymentMode": widget.storedsearchdata!.paymentMode,
                                            "cronTime": widget.storedsearchdata!.subscriptionSlot![0].cronTime,
                                            "name": widget.storedsearchdata!.subscriptionSlot![0].name,
                                            "varid":widget.storedsearchdata!.priceVariation![itemindex].id,
                                            "brand": widget.storedsearchdata!.brand,
                                            "deliveriesarray": ( widget.fromScreen == "search_item_multivendor" && Features.ismultivendor)?widget.storedsearchdata!.subscriptionSlot![0].deliveries :widget.itemdata!.subscriptionSlot![0].deliveries,
                                            "daily":(  widget.fromScreen == "search_item_multivendor" && Features.ismultivendor)?widget.storedsearchdata!.subscriptionSlot![0].daily :widget.itemdata!.subscriptionSlot![0].daily,
                                            "dailyDays": (  widget.fromScreen == "search_item_multivendor" && Features.ismultivendor)?widget.storedsearchdata!.subscriptionSlot![0].dailyDays :widget.itemdata!.subscriptionSlot![0].dailyDays,
                                            "weekend": (  widget.fromScreen == "search_item_multivendor" && Features.ismultivendor)?widget.storedsearchdata!.subscriptionSlot![0].weekend :widget.itemdata!.subscriptionSlot![0].weekend,
                                            "weekendDays": (  widget.fromScreen == "search_item_multivendor" && Features.ismultivendor)?widget.storedsearchdata!.subscriptionSlot![0].weekendDays :widget.itemdata!.subscriptionSlot![0].weekendDays,
                                            "weekday": ( widget.fromScreen == "search_item_multivendor" && Features.ismultivendor)?widget.storedsearchdata!.subscriptionSlot![0].weekday :widget.itemdata!.subscriptionSlot![0].weekday,
                                            "weekdayDays": ( widget.fromScreen == "search_item_multivendor" && Features.ismultivendor)?widget.storedsearchdata!.subscriptionSlot![0].weekdayDays :widget.itemdata!.subscriptionSlot![0].weekdayDays,
                                            "custom": ( widget.fromScreen == "search_item_multivendor" && Features.ismultivendor)?widget.storedsearchdata!.subscriptionSlot![0].custom :widget.itemdata!.subscriptionSlot![0].custom,
                                            "alternativeDays": ( widget.fromScreen == "search_item_multivendor" && Features.ismultivendor)?widget.storedsearchdata!.subscriptionSlot![0].alternativeDays :widget.itemdata!.subscriptionSlot![0].alternativeDays,
                                            "customDays": ( widget.fromScreen == "search_item_multivendor" && Features.ismultivendor)?widget.storedsearchdata!.subscriptionSlot![0].customDays :widget.itemdata!.subscriptionSlot![0].customDays,});
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      SizedBox(width: 10,),
                                      Container(
                                        // padding:EdgeInsets.only(left:55,right:55),
                                          height: 30.0,
                                          width: (widget.fromScreen == "brands_screen" || widget.fromScreen == "sellingitem_screen" || widget.fromScreen == "shoppinglistitem_screen" ||
                                              widget.fromScreen == "home_screen" ||widget.fromScreen == "search_item" || widget.fromScreen=="not_product_screen")?(MediaQuery.of(context).size.width / 5.8):
                                          (MediaQuery.of(context).size.width / 7.5) ,
                                          // width: (MediaQuery.of(context).size.width / 4) + 15,
                                          decoration: new BoxDecoration(
                                              border: Border.all(color: ColorCodes.primaryColor),
                                              color: ColorCodes.whiteColor,
                                              borderRadius: new BorderRadius.only(
                                                topLeft: const Radius.circular(2.0),
                                                topRight: const Radius.circular(2.0),
                                                bottomLeft: const Radius.circular(2.0),
                                                bottomRight: const Radius.circular(2.0),
                                              )),
                                          child:
                                          Center(
                                              child: Text(
                                                S.of(context).subscribe_caps,//'SUBSCRIBE',
                                                style: TextStyle(
                                                  color: ColorCodes.primaryColor,
                                                ),
                                                textAlign: TextAlign.center,
                                              ))
                                      ),
                                      SizedBox(width: 10,),
                                    ],
                                  ),
                                ),
                              ):
                              SizedBox(height: 30,):
                              SizedBox(height: 30,),
                          if(ResponsiveLayout.isSmallScreen(context))
                            if(Features.isSubscription)
                              SizedBox(
                                height: 10,
                              ),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                    child: CustomeStepper(priceVariationSearch: widget.storedsearchdata!.priceVariation![itemindex],searchstoredata: widget.storedsearchdata,from: "search_screen",checkmembership:_checkmembership,alignmnt: StepperAlignment.Vertical,height: (Features.isSubscription)?40:40,addon:(widget.storedsearchdata!.addon!.length > 0)?widget.storedsearchdata!.addon![0]:null,index:itemindex)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                !_checkmembership
                    ? widget.storedsearchdata!.priceVariation![itemindex].membershipDisplay!
                    ? SizedBox(height: 12,)
                    : SizedBox(height: 12,)
                    : SizedBox(height: 12,),

                if(ResponsiveLayout.isSmallScreen(context))
                  if(Features.isMembership)
                    (widget.fromScreen == "brands_screen" || widget.fromScreen == "sellingitem_screen" || widget.fromScreen == "shoppinglistitem_screen" ||
                        widget.fromScreen == "home_screen" ||widget.fromScreen == "searchitem_screen" || widget.fromScreen=="not_product_screen")?
                    Container(
                      width: (MediaQuery.of(context).size.width / 4) + 30,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child:  !_checkmembership
                          ? widget.storedsearchdata!.priceVariation![itemindex].membershipDisplay!
                          ? GestureDetector(
                        onTap: () {
                          if(!PrefUtils.prefs!.containsKey("apikey")) {
                            if (kIsWeb && !ResponsiveLayout.isSmallScreen(
                                context)) {
                              LoginWeb(context, result: (sucsess) {
                                if (sucsess) {
                                  Navigator.of(context).pop();
                                  Navigation(context, navigatore: NavigatoreTyp.homenav);
                                } else {
                                  Navigator.of(context).pop();
                                }
                              });
                            } else {
                              Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push);
                            }
                          }
                          else {
                            if (Vx.isWeb &&
                                !ResponsiveLayout.isSmallScreen(context)) {
                              MembershipInfo(context);
                            }
                            else {
                              Navigation(context, name: Routename.Membership,
                                  navigatore: NavigatoreTyp.Push);
                            }
                          }
                        },
                        child: Container(
                          height: 23,
                          decoration: BoxDecoration(color: ColorCodes.membershipColor),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(width: 10),
                              Image.asset(
                                Images.starImg,
                                height: 12,
                              ),
                              SizedBox(width: 2),
                              Text(
                                  Features.iscurrencyformatalign?
                                  widget.storedsearchdata!.priceVariation![itemindex].membershipPrice.toString() +  IConstants.currencyFormat:
                                  IConstants.currencyFormat +
                                      widget.storedsearchdata!.priceVariation![itemindex].membershipPrice.toString(),
                                  style: TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 11 : 12,)),
                              Spacer(),
                              Icon(
                                Icons.lock,
                                color: Colors.black,
                                size: 10,
                              ),
                              SizedBox(width: 2),
                              Icon(
                                Icons.arrow_forward_ios_sharp,
                                color: Colors.black,
                                size: 10,
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                        ),
                        //)



                      )
                          : SizedBox.shrink()
                          : SizedBox.shrink(),
                    )
                        :
                    Container(
                      width: (MediaQuery.of(context).size.width/5.2),
                      child: !_checkmembership
                          ? widget.storedsearchdata!.priceVariation![itemindex].membershipDisplay!
                          ? GestureDetector(
                        onTap: () {
                          (checkskip &&Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
                          _dialogforSignIn() :
                          (checkskip && !Vx.isWeb)?
                          Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.PushReplacment)
                              :
                         (Vx.isWeb &&
                        !ResponsiveLayout.isSmallScreen(context)) ?
                        MembershipInfo(context):
                          Navigation(context, name: Routename.Membership, navigatore: NavigatoreTyp.Push);
                        },
                        child: Container(
                          height: 23,
                          width: (MediaQuery.of(context).size.width/5.2),
                          decoration:
                          BoxDecoration(color: ColorCodes.membershipColor),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(width: 10),
                              Image.asset(
                                Images.starImg,
                                height: 12,
                              ),
                              SizedBox(width: 2),
                              Text(
                                  Features.iscurrencyformatalign?
                                  widget.storedsearchdata!.priceVariation![itemindex].membershipPrice.toString() + IConstants.currencyFormat:
                                  IConstants.currencyFormat +
                                      widget.storedsearchdata!.priceVariation![itemindex].membershipPrice.toString(),
                                  style: TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 11 : 12, color: Colors.black)),
                              Spacer(),
                              Icon(
                                Icons.lock,
                                color: Colors.black,
                                size: 10,
                              ),
                              SizedBox(width: 2),
                              Icon(
                                Icons.arrow_forward_ios_sharp,
                                color: Colors.black,
                                size: 10,
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                        ),
                        //)



                      )
                          : SizedBox.shrink()
                          : SizedBox.shrink(),
                    )
              ],
            ),
          ],
        ),
      )
          :
      widget.itemdata!.type=="1"?Container(
        width: _checkmembership? 210:195.0,
        child:Container(
          margin: EdgeInsets.only(left: 10.0, top: 5.0, right: 2.0, bottom: 5.0),
          decoration: new BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[300]!,
                    blurRadius: 3.0,
                    offset: Offset(0.0, 0.50)),
              ],
              borderRadius: new BorderRadius.all(const Radius.circular(8.0),)),
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Column(
                children: [
                  SizedBox(height: 8,),
                  Stack(
                      children:[
                        ItemBadge(
                          outOfStock: widget.itemdata!.stock!<=0?OutOfStock(singleproduct: false,):null,
                          //badgeDiscount: BadgeDiscounts(value: margins.toStringAsFixed(0)),
                          child: Align(
                            alignment: Alignment.center,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid": widget.itemdata!.id.toString(),"productId": widget.itemdata!.id!});
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 10.0, bottom: 8.0),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.itemdata!.itemFeaturedImage,
                                    errorWidget: (context, url, error) => Image.asset(
                                      Images.defaultProductImg,
                                      width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                      height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                    ),
                                    placeholder: (context, url) => Image.asset(
                                      Images.defaultProductImg,
                                      width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                      height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                    ),
                                    width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                    height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              if(margins > 0)
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        3.0),
                                    color: ColorCodes.primaryColor,//Color(0xff6CBB3C),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8, right: 8, top:4, bottom: 4),
                                    child: Text(
                                      margins.toStringAsFixed(0) + S .of(context).off ,//"% OFF",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 9,
                                          color: ColorCodes.whiteColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              if(margins > 0)
                                Spacer(),

                              (widget.itemdata!.eligibleForExpress == "0")?
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      3.0),
                                  border: Border.all(
                                      color: ColorCodes.varcolor),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 2, right: 2, top:4, bottom: 4),
                                  child: Row(
                                    children: [
                                      Text(
                                        S .of(context).express ,//"% OFF",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 9,
                                            color: ColorCodes.primaryColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 2),
                                      Image.asset(Images.express,
                                        color: ColorCodes.primaryColor,
                                        height: 11.0,
                                        width: 11.0,),

                                    ],
                                  ),
                                ),
                              ) : SizedBox.shrink(),
                            ],
                          ),
                        ),
                        widget.itemdata!.eligibleForExpress=="0"?Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 5.0,left: 5,bottom: 5),
                            child: Container(
                              width: 46,
                              height: 17,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                border: Border.all(
                                    color: ColorCodes.varcolor),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left:2.0),
                                    child: Text(/*"Express"*/S.of(context).express,style: TextStyle(fontSize: 8,color: ColorCodes.primaryColor,fontWeight: FontWeight.w800),),
                                  ),
                                  Image.asset(Images.express,
                                    height: 15.0,
                                    width: 13.0,
                                    color: ColorCodes.primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ):SizedBox.shrink(),
                      ]

                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),

              Row(
                children: [
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Text(
                      widget.itemdata!.brand!,
                      style: TextStyle(
                          fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 13,
                          color: ColorCodes.lightGreyColor,fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Spacer(),
                  if(Features.isLoyalty)
                    if(double.parse(widget.itemdata!.loyalty.toString()) > 0)
                      Container(
                        height: 18,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(Images.coinImg,
                              height: 12.0,
                              width: 18.0,),
                            SizedBox(width: 2),
                            Text(widget.itemdata!.loyalty.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 11),),
                          ],
                        ),
                      ),
                ],
              ),
              SizedBox(height: 2,),
              Row(
                children: [
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      height: 35,
                      child: Text(
                        widget.itemdata!.itemName!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style:
                        TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Features.isSubscription && widget.itemdata!.eligibleForSubscription=="0"?
                  Container(
                    height:30,
                    width: 70,
                    child: Padding(
                      padding: const EdgeInsets.only(left:0,right:5.0),
                      child: CustomeStepper(fontSize: 9,itemdata: widget.itemdata!,from:"item_screen",height: (Features.isSubscription)?90:60,issubscription: "Subscribe",addon:(widget.itemdata!.addon!.length > 0)?widget.itemdata!.addon![0]:null, index: itemindex),
                    ),
                  ):SizedBox.shrink(),
                  SizedBox(
                    width: 5.0,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 10.0,
                  ),
                  (widget.itemdata!.singleshortNote.toString() == "0" || widget.itemdata!.singleshortNote.toString() == "") ?
                  SizedBox(height: 15) :
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(widget.itemdata!.singleshortNote.toString(),style: TextStyle(fontSize: 9,color: ColorCodes.emailColor,fontWeight: FontWeight.bold),),
                    ],
                  ),
                  SizedBox(width: 10)
                ],
              ),
              SizedBox(height:2),
              (Features.netWeight && widget.itemdata!.vegType == "fish")?
              Row(
                children: [
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    Features.iscurrencyformatalign?
                    /*"Whole Uncut:"*/S.of(context).whole_uncut +" " +
                        widget.itemdata!.salePrice! + IConstants.currencyFormat +" / "+ /*"500 G"*/S.of(context).gram:
                    /*"Whole Uncut:"*/S.of(context).whole_uncut +" "+ IConstants.currencyFormat +
                        widget.itemdata!.salePrice! +" / "+ /*"500 G"*/S.of(context).gram,
                    style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 11 : 11, fontWeight: FontWeight.bold),),
                  SizedBox(
                    width: 10.0,
                  ),
                ],
              ):SizedBox.shrink(),
              (Features.netWeight && widget.itemdata!.vegType == "fish")?
              SizedBox(
                height: 2,
              ) : SizedBox.shrink(),
              (Features.netWeight && widget.itemdata!.vegType == "fish")
                  ? Row(
                  children: [
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(/*"G Weight:"*/S.of(context).g_weight +" "+
                            widget.itemdata!.weight!,
                            style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 11 : 11, fontWeight: FontWeight.bold)
                        ),
                      ],
                    ),
                    SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(/*"N Weight:"*/S.of(context).n_weight +" "+
                            widget.itemdata!.netWeight!,
                            style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 11 : 11, fontWeight: FontWeight.bold)
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                  ]
              ):SizedBox.shrink(),
              (Features.netWeight && widget.itemdata!.vegType == "fish") ?
              SizedBox(height: 18,):SizedBox.shrink(),
              SizedBox(height:5),
              Padding(
                padding: const EdgeInsets.only(left:10,right:5.0),
                child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VxBuilder(
                          mutations: {ProductMutation,SetCartItem},
                          builder: (context,  box, _) {
                            if(VxState.store.userData.membership! == "1"){
                              _checkmembership = true;
                            } else {
                              _checkmembership = false;
                              for (int i = 0; i < productBox.length; i++) {
                                if (productBox[i].mode == "1") {
                                  _checkmembership = true;
                                }
                              }
                            }

                            String _price = "";
                            String _mrp = "";

                            /* if(_checkmembership) { //Membered user
                              if(widget.itemdata!.membershipDisplay!){ //Eligible to display membership price
                                _price = widget.itemdata!.membershipPrice!;
                                _mrp = widget.itemdata!.mrp!;
                              } else if(widget.itemdata!.discointDisplay!){ //Eligible to display discounted price
                                _price = widget.itemdata!.price!;
                                _mrp = widget.itemdata!.mrp!;
                              } else { //Otherwise display mrp
                                _price = widget.itemdata!.mrp!;
                              }
                            } else { //Non membered user
                              if(widget.itemdata!.discointDisplay!){ //Eligible to display discounted price
                                _price = widget.itemdata!.price!;
                                _mrp = widget.itemdata!.mrp!;
                              } else { //Otherwise display mrp
                                _price = widget.itemdata!.mrp!;
                              }
                            }
                            if(Features.iscurrencyformatalign) {
                              _price = '${_price} ' + IConstants.currencyFormat;
                              if(_mrp != "")
                                _mrp = '${_mrp} ' + IConstants.currencyFormat;
                            } else {
                              _price = IConstants.currencyFormat + '${_price} ';
                              if(_mrp != "")
                                _mrp =  IConstants.currencyFormat + '${_mrp} ';
                            }*/

                            if(_checkmembership) { //Membered user
                              if(widget.itemdata!.membershipDisplay!){ //Eligible to display membership price
                                _price = widget.itemdata!.membershipPrice!;
                                _mrp = widget.itemdata!.mrp!;
                              } else if(widget.itemdata!.discointDisplay!){ //Eligible to display discounted price
                                _price = widget.itemdata!.price!;
                                _mrp = widget.itemdata!.mrp!;
                              } else { //Otherwise display mrp
                                _price = widget.itemdata!.mrp!;
                              }
                            } else { //Non membered user
                              if(widget.itemdata!.discointDisplay!){ //Eligible to display discounted price
                                _price = widget.itemdata!.price!;
                                _mrp = widget.itemdata!.mrp!;
                              } else { //Otherwise display mrp
                                _price = widget.itemdata!.mrp!;
                              }
                            }
                            if(Features.iscurrencyformatalign) {
                              _price = '${_price} ' + IConstants.currencyFormat;
                              if(_mrp != "")
                                _mrp = '${_mrp} ' + IConstants.currencyFormat;
                            } else {
                              _price = IConstants.currencyFormat + '${_price} ';
                              if(_mrp != "")
                                _mrp =  IConstants.currencyFormat + '${_mrp} ';
                            }
                            return  Row(
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    new RichText(
                                      text: new TextSpan(
                                        style: new TextStyle(
                                          fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,
                                          color: Colors.black,
                                        ),
                                        children: <TextSpan>[
                                          new TextSpan(
                                              text: _price,
                                              style: new TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: _checkmembership?ColorCodes.greenColor:Colors.black,
                                                fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,)),
                                          new TextSpan(
                                              text: _mrp,
                                              style: TextStyle(
                                                  color: ColorCodes.emailColor,
                                                  decoration:
                                                  TextDecoration.lineThrough,
                                                  fontSize: ResponsiveLayout.isSmallScreen(context) ? 7 : ResponsiveLayout.isMediumScreen(context) ? 8 : 9)),
                                        ],
                                      ),
                                    ),
                                    _checkmembership?Text(/*"Membership Price"*/S.of(context).membership_price,style: TextStyle(color: ColorCodes.greenColor,fontSize:7),):SizedBox.shrink(),
                                  ],
                                ),
                                Spacer(),
                                _checkmembership ? widget.itemdata!.membershipDisplay! ?
                                Container(
                                  height: 20,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(width: 3.0, color: ColorCodes.darkgreen),
                                    ),
                                    color: ColorCodes.varcolor,
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(width: 3),
                                      Image.asset(
                                        Images.bottomnavMembershipImg,
                                        color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                                        width: 15,
                                        height: 10,),
                                      SizedBox(width: 2),
                                      Padding(
                                        padding: const EdgeInsets.only(top:4.0,bottom: 3),
                                        child: Text(
                                            Features.iscurrencyformatalign? /*"Savings"*/S.of(context).savings + " " +
                                                (double.parse(widget.itemdata!.mrp!) - double.parse(widget.itemdata!.membershipPrice!)).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + IConstants.currencyFormat: /*"Savings" */ S.of(context).savings  + " " +
                                                IConstants.currencyFormat +
                                                (double.parse(widget.itemdata!.mrp!) - double.parse(widget.itemdata!.membershipPrice!)).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                            style: TextStyle(fontSize: 9, color: ColorCodes.darkgreen,fontWeight: FontWeight.bold)),
                                      ),
                                      SizedBox(width: 5),
                                    ],
                                  ),
                                ):SizedBox.shrink()
                                    :
                                Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: VxBuilder(
                                    mutations: {SetCartItem,ProductMutation},
                                    builder: (context,  box, index) {
                                      return Column(
                                        children: [
                                          if(Features.isMembership && double.parse(widget.itemdata!.membershipPrice.toString()) > 0)
                                            Row(
                                              children: <Widget>[
                                                !_checkmembership
                                                    ? widget.itemdata!.membershipDisplay!
                                                    ? GestureDetector(
                                                  onTap: () {
                                                    if(!PrefUtils.prefs!.containsKey("apikey")) {
                                                      if (kIsWeb && !ResponsiveLayout.isSmallScreen(
                                                          context)) {
                                                        LoginWeb(context, result: (sucsess) {
                                                          if (sucsess) {
                                                            Navigator.of(context).pop();
                                                            Navigation(context, navigatore: NavigatoreTyp.homenav);
                                                          } else {
                                                            Navigator.of(context).pop();
                                                          }
                                                        });
                                                      } else {
                                                        Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push);
                                                      }
                                                    }
                                                    else{
                                                            if (Vx.isWeb &&
                                                            !ResponsiveLayout.isSmallScreen(context)) {
                                                            MembershipInfo(context);
                                                            }
                                                            else {
                                                              Navigation(
                                                                  context, name: Routename.Membership, navigatore: NavigatoreTyp.Push);
                                                            }
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 20,
                                                    padding: EdgeInsets.only(left: 2),
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        right: BorderSide(width: 3.0, color: ColorCodes.darkgreen),
                                                      ),
                                                      color: ColorCodes.varcolor,
                                                    ),
                                                    child: Row(
                                                      children: <Widget>[
                                                        SizedBox(width: 3),
                                                        Image.asset(
                                                          Images.bottomnavMembershipImg,
                                                          color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                                                          width: 14,
                                                          height: 8,),
                                                        SizedBox(width: 2),
                                                        Text(
                                                          // S .of(context).membership_price+ " " +//"Membership Price "
                                                            S.of(context).price + " ",
                                                            style: TextStyle(fontSize: 8.0,color: ColorCodes.darkgreen,fontWeight: FontWeight.bold)),
                                                        Text(
                                                          // S .of(context).membership_price+ " " +//"Membership Price "
                                                            Features.iscurrencyformatalign?
                                                            widget.itemdata!.membershipPrice.toString() + IConstants.currencyFormat:
                                                            IConstants.currencyFormat +
                                                                widget.itemdata!.membershipPrice.toString(),
                                                            style: TextStyle(fontSize: 8.0,color: ColorCodes.darkgreen,fontWeight: FontWeight.bold)),

                                                        SizedBox(width: 5),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                                    : SizedBox.shrink()
                                                    : SizedBox.shrink(),
                                              ],
                                            ),
                                          !_checkmembership
                                              ? widget.itemdata!.membershipDisplay!
                                              ? SizedBox(
                                            height:( Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?0:1,
                                          )
                                              : SizedBox(
                                            height:( Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?0:1,
                                          )
                                              : SizedBox(
                                            height:( Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?0:1,
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                      ],
                    )),
              ),
              SizedBox(height:5),
              Padding(
                padding: const EdgeInsets.only(left: 5.0,right: 5.0),
                child: Container(
                  height:40,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height:(Features.isSubscription)?40:40,
                        width: widget.fromScreen == "item_screen"? Features.isShoppingList ? _checkmembership?MediaQuery.of(context).size.width/11.5:MediaQuery.of(context).size.width/11.5 : _checkmembership?MediaQuery.of(context).size.width/8.5:MediaQuery.of(context).size.width/8.5:
                        Features.isShoppingList ? _checkmembership?MediaQuery.of(context).size.width/7.5:MediaQuery.of(context).size.width/7.5 : _checkmembership?MediaQuery.of(context).size.width/6:MediaQuery.of(context).size.width/6,
                        child: Padding(
                          padding: const EdgeInsets.only(left:5,right:5.0),
                          child: CustomeStepper(itemdata: widget.itemdata!,from:"item_screen",height: (Features.isSubscription)?90:60,addon:(widget.itemdata!.addon!.length > 0)?widget.itemdata!.addon![0]:null, index: itemindex,issubscription: "Add", ),
                        ),
                      ),
                      if(Features.isShoppingList)
                        SizedBox(width: 1,),
                      if(Features.isShoppingList)
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {

                         /*   if(!PrefUtils.prefs!.containsKey("apikey")) {
                              Navigation(context, name: Routename.SignUpScreen,
                                  navigatore: NavigatoreTyp.Push);
                            }
                            else {
                              final shoplistData = Provider.of<BrandItemsList>(context, listen: false);

                              if (shoplistData.itemsshoplist.length <= 0) {
                                _dialogforCreatelistTwo(context, shoplistData);
                              } else {
                                _dialogforShoppinglistTwo(context);
                              }
                            }*/
                            if(!PrefUtils.prefs!.containsKey("apikey")) {
                              if (kIsWeb && !ResponsiveLayout.isSmallScreen(
                                  context)) {
                                LoginWeb(context, result: (sucsess) {
                                  if (sucsess) {
                                    Navigator.of(context).pop();
                                    Navigation(context, navigatore: NavigatoreTyp.homenav);
                                  } else {
                                    Navigator.of(context).pop();
                                  }
                                });
                              } else {
                                Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push);
                              }
                            }
                            else {
                              //final shoplistData = Provider.of<BrandItemsList>(context, listen: false);

                              if (shoplistData.length <= 0) {
                                _dialogforCreatelistTwo(context, shoplistData);
                              } else {
                                _dialogforShoppinglistTwo(context);
                              }
                            }

                          },
                          child: Container(
                            height: 32,
                            padding: EdgeInsets.all(5),
                            decoration: new BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: ColorCodes.varcolor,
                              border: Border(
                                right: BorderSide(width: 1.0, color: ColorCodes.varcolor,),
                                left: BorderSide(width: 1.0, color: ColorCodes.varcolor,),
                                bottom: BorderSide(width: 1.0, color: ColorCodes.varcolor),
                                top: BorderSide(width: 1.0, color: ColorCodes.varcolor),
                              ),),
                            child: Image.asset(
                                Images.addToListImg,width: 20,height: 20,color: ColorCodes.primaryColor),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ):
      Container(
        margin: EdgeInsets.only(left: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?0:0.0, top: 5.0, right: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?5:2.0, bottom: 5.0),
        width: _checkmembership? 210:195.0,
        child:Container(
          margin: EdgeInsets.only(left: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?0:10.0, top: 5.0, right: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?10:2.0, bottom: 5.0),
          decoration: new BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[300]!,
                    blurRadius: 3.0,
                    offset: Offset(0.0, 0.50)),
              ],
              borderRadius: new BorderRadius.all(const Radius.circular(8.0),)),
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                children: [
                  SizedBox(height: 8,),
                  Stack(
                    children:[
                      Padding(
                        padding: const EdgeInsets.only(left:5.0),
                        child: ItemBadge(
                          outOfStock: widget.itemdata!.priceVariation![itemindex].stock! <= 0 ? OutOfStock(singleproduct: false,) : null,
                          //badgeDiscount: BadgeDiscounts(value: margins.toStringAsFixed(0)),
                          child: Align(
                            alignment: Alignment.center,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  if(widget.fromScreen =="Forget"){
                                    Navigation(context, navigatore: NavigatoreTyp.Pop);
                                    Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid": widget.itemdata!.priceVariation![itemindex].menuItemId.toString(),"productId": widget.itemdata!.priceVariation![itemindex].menuItemId.toString()});
                                  }else{
                                    Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid": widget.itemdata!.priceVariation![itemindex].menuItemId.toString(),"productId": widget.itemdata!.priceVariation![itemindex].menuItemId.toString()});
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 10.0, bottom: 8.0),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.itemdata!.priceVariation![itemindex].images!.length<=0?widget.itemdata!.itemFeaturedImage:widget.itemdata!.priceVariation![itemindex].images![0].image,
                                    errorWidget: (context, url, error) => Image.asset(
                                      Images.defaultProductImg,
                                      width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                      height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                    ),
                                    placeholder: (context, url) => Image.asset(
                                      Images.defaultProductImg,
                                      width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                      height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                    ),
                                    width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                    height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            if(margins > 0)
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      3.0),
                                  color: ColorCodes.primaryColor,//Color(0xff6CBB3C),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8, right: 8, top:4, bottom: 4),
                                  child: Text(
                                    margins.toStringAsFixed(0) + S .of(context).off ,//"% OFF",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 9,
                                        color: ColorCodes.whiteColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            if(margins > 0)
                              Spacer(),

                            (widget.itemdata!.eligibleForExpress == "0")?
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    3.0),
                                border: Border.all(
                                    color: ColorCodes.varcolor),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 2, right: 2, top:4, bottom: 4),
                                child: Row(
                                  children: [
                                    Text(
                                      S .of(context).express ,//"% OFF",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 9,
                                          color: ColorCodes.primaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 2),
                                    Image.asset(Images.express,
                                      color: ColorCodes.primaryColor,
                                      height: 11.0,
                                      width: 11.0,),

                                  ],
                                ),
                              ),
                            ) : SizedBox.shrink(),
                          ],
                        ),
                      ),
                      widget.itemdata!.eligibleForExpress == "0" ?Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 5.0,left: 5,bottom: 5),
                          child: Container(
                            width: 46,
                            height: 17,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(
                                  color: ColorCodes.varcolor),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left:2.0),
                                  child: Text(S.of(context).express,style: TextStyle(fontSize: 8,color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,fontWeight: FontWeight.w800),),
                                ),
                                Image.asset(Images.express,
                                  height: 15.0,
                                  width: 13.0,
                                  color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ):SizedBox.shrink(),
                    ],

                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),

              Row(
                children: [
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Text(
                      widget.itemdata!.brand!,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 13,
                          color: ColorCodes.lightGreyColor,fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  if(Features.btobModule)
                    SizedBox(
                      width: 10.0,
                    ),
                  if(Features.btobModule)
                    if(Features.isLoyalty)
                      if(double.parse(widget.itemdata!.priceVariation![itemindex].loyalty.toString()) > 0)
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(Images.coinImg,
                                height: 13.0,
                                width: 20.0,),
                              SizedBox(width: 2),
                              Text(widget.itemdata!.priceVariation![itemindex].loyalty.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),
                            ],
                          ),
                        ),
                  if(Features.isLoyalty)
                    Spacer(),
                  if(Features.isLoyalty)
                    if(double.parse(widget.itemdata!.priceVariation![itemindex].loyalty.toString()) > 0)
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(Images.coinImg,
                              height: 12.0,
                              width: 18.0,),
                            SizedBox(width: 2),
                            Text(widget.itemdata!.priceVariation![itemindex].loyalty.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 11),),
                          ],
                        ),
                      ),
                  SizedBox(
                    width: 10.0,
                  ),
                ],
              ),
              SizedBox(
                height: 2,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      height: 35,
                      child: Text(
                        widget.itemdata!.itemName!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style:
                        TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),

                  Features.isSubscription && widget.itemdata!.eligibleForSubscription=="0"?
                  Container(
                    height:30,
                    width: 70,
                    child: Padding(
                      padding: const EdgeInsets.only(left:0,right:5.0),
                      child: CustomeStepper(fontSize: 9,priceVariation:widget.itemdata!.priceVariation![itemindex],itemdata: widget.itemdata!,from:"item_screen",height: (Features.isSubscription)?90:60,issubscription: "Subscribe",addon:(widget.itemdata!.addon!.length > 0)?widget.itemdata!.addon![0]:null, index: itemindex),
                    ),
                  ):SizedBox.shrink(),
                  SizedBox(
                    width: 5.0,
                  ),
                ],
              ),
              (Features.netWeight && widget.itemdata!.vegType == "fish")?
              Row(
                children: [
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    Features.iscurrencyformatalign?
                    /*"Whole Uncut:"*/S.of(context).whole_uncut +" " +
                        widget.itemdata!.salePrice! + IConstants.currencyFormat +" / "+ /*"500 G"*/S.of(context).gram:
                    /*"Whole Uncut:"*/S.of(context).whole_uncut +" "+ IConstants.currencyFormat +
                        widget.itemdata!.salePrice! +" / "+ /*"500 G"*/S.of(context).gram,
                    style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 11 : 11, fontWeight: FontWeight.bold),),
                  SizedBox(
                    width: 10.0,
                  ),
                ],
              ):
              SizedBox.shrink(),
              (Features.netWeight && widget.itemdata!.vegType == "fish")?
              SizedBox(
                height: 2,
              ):
              SizedBox.shrink(),
              (Features.netWeight && widget.itemdata!.vegType == "fish")
                  ? Row(
                  children: [
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(/*"G Weight:"*/S.of(context).g_weight + " " + widget.itemdata!.priceVariation![itemindex].weight!,
                            style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 11 : 11, fontWeight: FontWeight.bold)
                        ),
                      ],
                    ),
                    SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(/*"N Weight:"*/S.of(context).n_weight + " " + widget.itemdata!.priceVariation![itemindex].netWeight!,
                            style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 11 : 11, fontWeight: FontWeight.bold)
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                  ]
              ) : SizedBox.shrink(),

              SizedBox(height: 2),
              ( widget.itemdata!.priceVariation!.length > 1)
                  ? Features.btobModule?
              Container(
                  child: SingleChildScrollView(
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: widget.itemdata!.priceVariation!.length,
                          itemBuilder: (_, i) {
                            return MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _groupValue = i;
                                  });
                                  if(productBox
                                      .where((element) =>
                                  element.itemId! == widget.itemdata!.id
                                  ).length >= 1) {
                                    cartcontroller.update((done) {
                                    }, price: widget.itemdata!.price.toString(),
                                        quantity: widget.itemdata!.priceVariation![i].minItem.toString(),
                                        type: widget.itemdata!.type,
                                        weight: (
                                            double.parse(widget.itemdata!.increament!)).toString(),
                                        var_id: widget.itemdata!.priceVariation![0].id.toString(),
                                        increament: widget.itemdata!.increament,
                                        cart_id: productBox
                                            .where((element) =>
                                        element.itemId! == widget.itemdata!.id
                                        ).first.parent_id.toString(),
                                        toppings: "",
                                        topping_id: "",
                                        item_id: widget.itemdata!.id!

                                    );
                                  }
                                  else {
                                    cartcontroller.addtoCart(itemdata: widget.itemdata!,
                                        onload: (isloading) {
                                        },
                                        topping_type: "",
                                        varid: widget.itemdata!.priceVariation![0].id,
                                        toppings: "",
                                        parent_id: "",
                                        newproduct: "0",
                                        toppingsList: [],
                                        itembody: widget.itemdata!.priceVariation![i],
                                        context: context);
                                  }
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Expanded(
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: _groupValue == i ? ColorCodes.mediumgren : ColorCodes.whiteColor,
                                            borderRadius: BorderRadius.circular(5.0),
                                            border: Border.all(
                                              color: ColorCodes.greenColor,
                                            ),
                                          ),
                                          height: 30,
                                          margin: EdgeInsets.only(bottom:5),
                                          padding: EdgeInsets.fromLTRB(5.0, 4.5, 0.0, 4.5),
                                          child:
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${widget.itemdata!.priceVariation![i].minItem}"+"-"+"${widget.itemdata!.priceVariation![i].maxItem}"+" "+"${widget.itemdata!.priceVariation![i].unit}",
                                                style: TextStyle(color: _groupValue == i?ColorCodes.darkgreen:ColorCodes.blackColor,fontWeight: FontWeight.bold,fontSize: 12),
                                              ),
                                              new RichText(
                                                text: new TextSpan(
                                                  style: new TextStyle(
                                                    fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,
                                                    color: _groupValue == i?ColorCodes.darkgreen:ColorCodes.blackColor,
                                                  ),
                                                  children: <TextSpan>[
                                                    new TextSpan(
                                                        text:  Features.iscurrencyformatalign?
                                                        '${_checkmembership?widget.itemdata!.priceVariation![i].membershipPrice:widget.itemdata!.priceVariation! [i].price} ' + IConstants.currencyFormat:
                                                        IConstants.currencyFormat + '${_checkmembership?widget.itemdata!.priceVariation![i].membershipPrice:widget.itemdata!.priceVariation![i].price} ',
                                                        style: new TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color:_checkmembership?_groupValue == i?ColorCodes.darkgreen:ColorCodes.blackColor: _groupValue == i?ColorCodes.darkgreen:ColorCodes.blackColor,
                                                          fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,)),
                                                    new TextSpan(
                                                        text: _checkmembership?
                                                        ( (widget.itemdata!.priceVariation![i].membershipPrice==widget.itemdata!.priceVariation![i].price)||(widget.itemdata!.priceVariation![i].membershipPrice==widget.itemdata!.priceVariation![i].mrp)) ?""
                                                            : widget.itemdata!.priceVariation![i].price!=widget.itemdata!.priceVariation![i].mrp?
                                                        Features.iscurrencyformatalign?
                                                        '${widget.itemdata!.priceVariation![i].mrp} ' + IConstants.currencyFormat:
                                                        IConstants.currencyFormat + '${widget.itemdata!.priceVariation![i].mrp} ':""
                                                            :widget.itemdata!.priceVariation![i].price!=widget.itemdata!.priceVariation![i].mrp?
                                                        Features.iscurrencyformatalign?
                                                        '${widget.itemdata!.priceVariation![i].mrp} ' + IConstants.currencyFormat:
                                                        IConstants.currencyFormat + '${widget.itemdata!.priceVariation![i].mrp} ':"",
                                                        style: TextStyle(
                                                          decoration:
                                                          TextDecoration.lineThrough,
                                                          fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 13,)),
                                                  ],
                                                ),
                                              ),

                                              _groupValue == i ?
                                              Container(
                                                width: 18.0,
                                                height: 18.0,
                                                padding: EdgeInsets.only(right:3),
                                                decoration: BoxDecoration(
                                                  color: ColorCodes.greenColor,
                                                  border: Border.all(
                                                    color: ColorCodes.greenColor,
                                                  ),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Container(
                                                  margin: EdgeInsets.all(1.5),
                                                  decoration: BoxDecoration(
                                                    color: ColorCodes.greenColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(Icons.check,
                                                      color: ColorCodes.whiteColor,
                                                      size: 12.0),
                                                ),
                                              )
                                                  :
                                              Icon(
                                                  Icons.radio_button_off_outlined,
                                                  color: ColorCodes.greenColor),
                                            ],
                                          )

                                      ),
                                    ),
                                    Spacer(),
                                    Text(widget.itemdata!.singleshortNote.toString(),style: TextStyle(fontSize: 9,color: ColorCodes.emailColor,fontWeight: FontWeight.bold),),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                      )
                  )
              )
                  :
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    showoptions1();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 10.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(2.0),
                              bottomLeft: const Radius.circular(2.0),
                            )),
                        height: 18,
                        padding: EdgeInsets.fromLTRB(0.0, 0, 5.0, 0),
                        child: Text(
                          "${widget.itemdata!.priceVariation![itemindex].variationName}" + " " + "${widget.itemdata!.priceVariation![itemindex].unit}",
                          style: TextStyle(color: ColorCodes.darkgreen, fontWeight: FontWeight.w600,fontSize: 12),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: ColorCodes.darkgreen,
                        size: 18,
                      ),
                      Spacer(),
                      Text(widget.itemdata!.singleshortNote.toString(),style: TextStyle(fontSize: 9,color: ColorCodes.emailColor,fontWeight: FontWeight.bold),),
                      SizedBox(
                        width: 10.0,
                      ),
                    ],
                  ),
                ),
              ) :
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(2.0),
                          topRight: const Radius.circular(2.0),
                          bottomLeft: const Radius.circular(2.0),
                          bottomRight: const Radius.circular(2.0),
                        )),
                    height: 18,
                    padding: EdgeInsets.fromLTRB(0.0, 0, 0.0, 0.0),
                    child: Text(
                      "${widget.itemdata!.priceVariation![itemindex].variationName}"+" "+"${widget.itemdata!.priceVariation![itemindex].unit}",
                      style: TextStyle(color: ColorCodes.darkgreen,fontWeight: FontWeight.w600,fontSize: 12),
                    ),
                  ),
                  Spacer(),
                  Expanded(child: Text(widget.itemdata!.singleshortNote.toString(),maxLines:1,overflow:TextOverflow.ellipsis,style: TextStyle(fontSize: 9,color: ColorCodes.emailColor,fontWeight: FontWeight.bold),)),
                  SizedBox(
                    width: 10.0,
                  ),
                ],
              ),
              SizedBox(height: 2,),
              if(!Features.btobModule)
                Padding(
                  padding: const EdgeInsets.only(left:10.0,right:10),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VxBuilder(
                          mutations: {ProductMutation,SetCartItem},
                          builder: (context,  box, _) {
                            if(VxState.store.userData.membership! == "1"){
                              _checkmembership = true;
                            } else {
                              _checkmembership = false;
                              for (int i = 0; i < productBox.length; i++) {
                                if (productBox[i].mode == "1") {
                                  _checkmembership = true;
                                }
                              }
                            }
                            String _price = "";
                            String _mrp = "";

                            if(_checkmembership) { //Membered user
                              if(widget.itemdata!.priceVariation![itemindex].membershipDisplay!){ //Eligible to display membership price
                                _price = widget.itemdata!.priceVariation![itemindex].membershipPrice!;
                                _mrp = widget.itemdata!.priceVariation![itemindex].mrp!;
                              } else if(widget.itemdata!.priceVariation![itemindex].discointDisplay!){ //Eligible to display discounted price
                                _price = widget.itemdata!.priceVariation![itemindex].price!;
                                _mrp = widget.itemdata!.priceVariation![itemindex].mrp!;
                              } else { //Otherwise display mrp
                                _price = widget.itemdata!.priceVariation![itemindex].mrp!;
                              }
                            } else { //Non membered user
                              if(widget.itemdata!.priceVariation![itemindex].discointDisplay!){ //Eligible to display discounted price
                                _price = widget.itemdata!.priceVariation![itemindex].price!;
                                _mrp = widget.itemdata!.priceVariation![itemindex].mrp!;
                              } else { //Otherwise display mrp
                                _price = widget.itemdata!.priceVariation![itemindex].mrp!;
                              }
                            }
                            if(Features.iscurrencyformatalign) {
                              _price = '${_price} ' + IConstants.currencyFormat;
                              if(_mrp != "")
                                _mrp = '${_mrp} ' + IConstants.currencyFormat;
                            } else {
                              _price = IConstants.currencyFormat + '${_price} ';
                              if(_mrp != "")
                                _mrp =  IConstants.currencyFormat + '${_mrp} ';
                            }
                            return  Row(
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    new RichText(
                                      text: new TextSpan(
                                        style: new TextStyle(
                                          fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,
                                          color: Colors.black,
                                        ),
                                        children: <TextSpan>[
                                          new TextSpan(
                                              text: _price,
                                              style: new TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color:_checkmembership?ColorCodes.greenColor: Colors.black,
                                                fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,)),
                                          new TextSpan(
                                              text: _mrp,
                                              style: TextStyle(
                                                color: ColorCodes.emailColor,
                                                decoration:
                                                TextDecoration.lineThrough,
                                                fontSize: ResponsiveLayout.isSmallScreen(context) ? 7 : ResponsiveLayout.isMediumScreen(context) ? 8 : 9,)),
                                        ],
                                      ),
                                    ),

                                    _checkmembership?Text(S.of(context).membership_price, style: TextStyle(color: ColorCodes.greenColor,fontSize: 7),):SizedBox.shrink(),
                                    SizedBox(height:5),
                                  ],
                                ),
                                Spacer(),
                                _checkmembership ? widget.itemdata!.priceVariation![Features.btobModule?_groupValue:itemindex].membershipDisplay! ?
                                Container(
                                  height: 20,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(width: 3.0, color: ColorCodes.darkgreen),
                                    ),
                                    color: ColorCodes.varcolor,
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(width: 3,),
                                      Image.asset(
                                        Images.bottomnavMembershipImg,
                                        color: ColorCodes.primaryColor,
                                        width: 15,
                                        height: 10,),
                                      SizedBox(width: 2),
                                      Text(/*"Savings "*/S.of(context).savings ,style: TextStyle(fontSize: 8.5, color: ColorCodes.darkgreen,fontWeight: FontWeight.bold)),
                                      Padding(
                                        padding: const EdgeInsets.only(top:4.0,bottom: 3),
                                        child: Text(
                                            Features.iscurrencyformatalign?
                                            (double.parse(widget.itemdata!.priceVariation![Features.btobModule?_groupValue:itemindex].mrp!) - double.parse(widget.itemdata!.priceVariation![Features.btobModule?_groupValue:itemindex].membershipPrice!)).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + IConstants.currencyFormat:
                                            IConstants.currencyFormat +
                                                (double.parse(widget.itemdata!.priceVariation![Features.btobModule?_groupValue:itemindex].mrp!) - double.parse(widget.itemdata!.priceVariation![Features.btobModule?_groupValue:itemindex].membershipPrice!)).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                            style: TextStyle(fontSize: 9, color: ColorCodes.darkgreen,fontWeight: FontWeight.bold)),
                                      ),


                                      SizedBox(width: 5),
                                    ],
                                  ),
                                ):SizedBox(height: 20,)
                                    :VxBuilder(
                                  mutations: {SetCartItem,ProductMutation},
                                  builder: (context,  box, index) {
                                    return Column(
                                      children: [
                                        if(Features.isMembership && double.parse(widget.itemdata!.priceVariation![Features.btobModule?_groupValue:itemindex].membershipPrice.toString()) > 0)
                                          Row(
                                            children: <Widget>[
                                              !_checkmembership
                                                  ? widget.itemdata!.priceVariation![Features.btobModule?_groupValue:itemindex].membershipDisplay!
                                                  ? GestureDetector(
                                                onTap: () {
                                                  if(!PrefUtils.prefs!.containsKey("apikey")) {
                                                    if (kIsWeb && !ResponsiveLayout.isSmallScreen(
                                                        context)) {
                                                      LoginWeb(context, result: (sucsess) {
                                                        if (sucsess) {
                                                          Navigator.of(context).pop();
                                                          Navigation(context, navigatore: NavigatoreTyp.homenav);
                                                        } else {
                                                          Navigator.of(context).pop();
                                                        }
                                                      });
                                                    } else {
                                                      Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push);
                                                    }
                                                  }
                                                  else{
                                                    if (Vx.isWeb &&
                                                    !ResponsiveLayout.isSmallScreen(context)) {
                                                    MembershipInfo(context);
                                                    }
                                                    else {
                                                      Navigation(context, name: Routename.Membership, navigatore: NavigatoreTyp
                                                          .Push);
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                  height: 19,
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      right: BorderSide(width: 3.0, color: ColorCodes.darkgreen),
                                                    ),
                                                    color: ColorCodes.varcolor,
                                                  ),
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(width: 3),
                                                      Image.asset(
                                                        Images.bottomnavMembershipImg,
                                                        color: ColorCodes.primaryColor,
                                                        width: 14,
                                                        height: 8,),
                                                      SizedBox(width: 2),
                                                      Text(
                                                        // S .of(context).membership_price+ " " +//"Membership Price "
                                                          S.of(context).price + " ",
                                                          style: TextStyle(fontSize: 8.0,color: ColorCodes.darkgreen,fontWeight: FontWeight.bold)),
                                                      Text(
                                                        // S .of(context).membership_price+ " " +//"Membership Price "
                                                          Features.iscurrencyformatalign?
                                                          widget.itemdata!.priceVariation![Features.btobModule?_groupValue:itemindex].membershipPrice.toString() + IConstants.currencyFormat:
                                                          IConstants.currencyFormat +
                                                              widget.itemdata!.priceVariation![Features.btobModule?_groupValue:itemindex].membershipPrice.toString(),
                                                          style: TextStyle(fontSize: 8.0, color: ColorCodes.darkgreen,fontWeight: FontWeight.bold)),

                                                      SizedBox(width: 5),
                                                    ],
                                                  ),

                                                ),
                                              )
                                                  : SizedBox.shrink()
                                                  : SizedBox.shrink(),
                                            ],
                                          ),
                                        !_checkmembership
                                            ? widget.itemdata!.priceVariation![Features.btobModule?_groupValue:itemindex].membershipDisplay!
                                            ? SizedBox(
                                          height:( Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?0:1,
                                        )
                                            : SizedBox(
                                          height:( Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?0:1,
                                        )
                                            : SizedBox(
                                          height:( Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?0:1,
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height:4),
              Features.btobModule ?
              Padding(
                padding: const EdgeInsets.only(left: 8.0,right: 8.0,),
                child: Container(
                  height:40,
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text(S.of(context).total,style: TextStyle(color: ColorCodes.blackColor)),
                          productBox
                              .where((element) =>
                          element.itemId == widget.itemdata!.id).length > 0?
                          Text( IConstants.currencyFormat + (double.parse(widget.itemdata!.priceVariation![_groupValue].price!) * _count).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                            style: TextStyle(
                                color: ColorCodes.greenColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                            ),): Text( IConstants.currencyFormat + (double.parse(widget.itemdata!.priceVariation![itemindex].price!)).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                            style: TextStyle(
                                color: ColorCodes.greenColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                            ),),

                        ],
                      ),
                      Container(
                        height:(Features.isSubscription)?40:40,
                        width: _checkmembership ? 180 : 110,
                        child: Padding(
                          padding: const EdgeInsets.only(left:10,right:5.0),
                          child: Features.btobModule?CustomeStepper(priceVariation:widget.itemdata!.priceVariation![itemindex],itemdata: widget.itemdata!,from:"selling_item",height: (Features.isSubscription)?90:40,issubscription: "Add",addon:(widget.itemdata!.addon!.length > 0)?widget.itemdata!.addon![0]:null, index: itemindex,groupvalue: _groupValue,onChange: (int value,int count){
                            setState(() {
                              _groupValue = value;
                              _count = count;
                            });
                          },):CustomeStepper(priceVariation:widget.itemdata!.priceVariation![itemindex],itemdata: widget.itemdata!,from:"selling_item",height: (Features.isSubscription)?90:40,issubscription: "Add",addon:(widget.itemdata!.addon!.length > 0)?widget.itemdata!.addon![0]:null, index: itemindex),
                        ),
                      ),
                    ],
                  ),
                ),
              ) :
              Padding(
                padding: const EdgeInsets.only(left: 5.0,right: 5.0),
                child: Container(
                  height:40,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height:(Features.isSubscription)?38:38,
                        width:  widget.fromScreen == "item_screen"? Features.isShoppingList ? _checkmembership?MediaQuery.of(context).size.width/11.5:MediaQuery.of(context).size.width/11.5 : _checkmembership?MediaQuery.of(context).size.width/8.5:MediaQuery.of(context).size.width/8.5:
                            Features.isShoppingList ? _checkmembership?MediaQuery.of(context).size.width/7.5:MediaQuery.of(context).size.width/7.5 : _checkmembership?MediaQuery.of(context).size.width/6:MediaQuery.of(context).size.width/6,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0,right: 5.0),
                          child: Features.btobModule?CustomeStepper(priceVariation:widget.itemdata!.priceVariation![itemindex],itemdata: widget.itemdata!,from:"selling_item",height: (Features.isSubscription)?90:40,issubscription: "Add",addon:(widget.itemdata!.addon!.length > 0)?widget.itemdata!.addon![0]:null, index: itemindex,groupvalue: _groupValue,onChange: (int value,int count){
                            setState(() {
                              _groupValue = value;
                              _count = count;
                            });
                          },):CustomeStepper(priceVariation:widget.itemdata!.priceVariation![itemindex],itemdata: widget.itemdata!,from:"selling_item",height: (Features.isSubscription)?90:40,issubscription: "Add",addon:(widget.itemdata!.addon!.length > 0)?widget.itemdata!.addon![0]:null, index: itemindex),
                        ),
                      ),
                      if(Features.isShoppingList)
                        SizedBox(width: 1,),
                      if(Features.isShoppingList)
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {

                            if(!PrefUtils.prefs!.containsKey("apikey")) {
                              if (kIsWeb && !ResponsiveLayout.isSmallScreen(
                                  context)) {
                                LoginWeb(context, result: (sucsess) {
                                  if (sucsess) {
                                    Navigator.of(context).pop();
                                    Navigation(context, navigatore: NavigatoreTyp.homenav);
                                  } else {
                                    Navigator.of(context).pop();
                                  }
                                });
                              } else {
                                Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push);
                              }
                            }
                            else {
                              //final shoplistData = Provider.of<BrandItemsList>(context, listen: false);

                              if (shoplistData.length <= 0) {
                                _dialogforCreatelistTwo(context, shoplistData);
                              } else {
                                _dialogforShoppinglistTwo(context);
                              }
                            }

                           /* if(!PrefUtils.prefs!.containsKey("apikey")) {
                              (Vx.isWeb)?
                              LoginWeb(context,result: (sucsess){
                                if(sucsess){
                                  Navigator.of(context).pop();
                                  HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
                                      PrefUtils.prefs!.getString("ftokenid"),
                                      branch: (VxState.store as GroceStore).userData.branch ?? "999",
                                      rows: "0");
                                  Navigation(context, navigatore: NavigatoreTyp.homenav);
                                  GoRouter.of(context).refresh();

                                }else{
                                  Navigator.of(context).pop();
                                }
                              })
                                  :Navigation(context, name: Routename.SignUpScreen,
                                  navigatore: NavigatoreTyp.Push);
                            }
                            else {
                              final shoplistData = Provider.of<BrandItemsList>(context, listen: false);

                              if (shoplistData.itemsshoplist.length <= 0) {
                                _dialogforCreatelistTwo(context, shoplistData);
                              } else {
                                _dialogforShoppinglistTwo(context);
                              }
                            }*/
                          },
                          child: Container(
                            height: 32,
                            padding: EdgeInsets.all(5),
                            decoration: new BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: ColorCodes.varcolor,
                              border: Border(
                                right: BorderSide(width: 1.0, color: ColorCodes.varcolor,),
                                left: BorderSide(width: 1.0, color: ColorCodes.varcolor,),
                                bottom: BorderSide(width: 1.0, color: ColorCodes.varcolor),
                                top: BorderSide(width: 1.0, color: ColorCodes.varcolor),
                              ),),
                            child: Image.asset(
                                Images.addToListImg,width: 20,height: 20,color: ColorCodes.primaryColor),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    else{


      if(_checkmembership) { //Membered user
        if(widget.itemdata!.type == "1") {  //SingleSku item
          if (widget.itemdata!.membershipDisplay!) { //Eligible to display membership price
            _price = widget.itemdata!.membershipPrice!;
            _mrp = widget.itemdata!.mrp!;
          } else if (widget.itemdata!.discointDisplay!) { //Eligible to display discounted price
            _price = widget.itemdata!.price!;
            _mrp = widget.itemdata!.mrp!;
          } else { //Otherwise display mrp
            _price = widget.itemdata!.mrp!;
          }
        }
        else{ //multisku
          if (widget.itemdata!.priceVariation![Features.btobModule
              ? _groupValue
              : itemindex]
              .membershipDisplay!) { //Eligible to display membership price
            _price = widget.itemdata!.priceVariation![Features.btobModule
                ? _groupValue
                : itemindex].membershipPrice!;
            _mrp = widget.itemdata!.priceVariation![Features.btobModule
                ? _groupValue
                : itemindex].mrp!;
          } else if (widget.itemdata!.priceVariation![Features.btobModule
              ? _groupValue
              : itemindex]
              .discointDisplay!) { //Eligible to display discounted price
            _price = widget.itemdata!.priceVariation![Features.btobModule
                ? _groupValue
                : itemindex].price!;
            _mrp = widget.itemdata!.priceVariation![Features.btobModule
                ? _groupValue
                : itemindex].mrp!;
          } else { //Otherwise display mrp
            _price = widget.itemdata!.priceVariation![Features.btobModule
                ? _groupValue
                : itemindex].mrp!;
          }
        }
      } else { //Non membered user

        if(widget.itemdata!.type == "1") { //singlesku
          if(widget.itemdata!.discointDisplay!){ //Eligible to display discounted price
            _price = widget.itemdata!.price!;
            _mrp = widget.itemdata!.mrp!;
          } else { //Otherwise display mrp
            _price = widget.itemdata!.mrp!;
          }
        }
        else{ //multisku
          if(widget.itemdata!.priceVariation![Features.btobModule?_groupValue:itemindex].discointDisplay!){ //Eligible to display discounted price
            _price = widget.itemdata!.priceVariation![Features.btobModule?_groupValue:itemindex].price!;
            _mrp = widget.itemdata!.priceVariation![Features.btobModule?_groupValue:itemindex].mrp!;
          } else { //Otherwise display mrp
            _price = widget.itemdata!.priceVariation![Features.btobModule?_groupValue:itemindex].mrp!;
          }
        }

      }
      if(Features.iscurrencyformatalign) {
        _price = '${double.parse(_price).toStringAsFixed(IConstants.decimaldigit)} ' + IConstants.currencyFormat;
        if(_mrp != "")
          _mrp = '${double.parse(_mrp).toStringAsFixed(IConstants.decimaldigit)} ' + IConstants.currencyFormat;
      } else {
        _price = IConstants.currencyFormat + '${double.parse(_price).toStringAsFixed(IConstants.decimaldigit)} ';
        if(_mrp != "")
          _mrp =  IConstants.currencyFormat + '${double.parse(_mrp).toStringAsFixed(IConstants.decimaldigit)} ';
      }

      return widget.fromScreen == "search_item_multivendor" && Features.ismultivendor?
      widget.storedsearchdata!.type=="1"?
      GestureDetector(
        onTap: (){
          if(widget.fromScreen == "sellingitem_screen") {
            if (widget.storedsearchdata!.stock !>= 0)
              Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid": widget.storedsearchdata!.priceVariation![itemindex].menuItemId.toString(),"productId": widget.storedsearchdata!.priceVariation![itemindex].menuItemId.toString()});
          }
          else{
            if (widget.storedsearchdata!.stock !>= 0)
              Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid": widget.storedsearchdata!.priceVariation![itemindex].menuItemId.toString(),"productId": widget.storedsearchdata!.priceVariation![itemindex].menuItemId.toString()});
            else
              Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid": widget.storedsearchdata!.priceVariation![itemindex].menuItemId.toString(),"productId": widget.storedsearchdata!.priceVariation![itemindex].menuItemId.toString()});
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(width: 2.0, color: ColorCodes.lightGreyWebColor),
            ),
          ),
          margin: (Features.ismultivendor)? EdgeInsets.only(left: 0.0,  bottom: 0.0, right: 0) : EdgeInsets.only(left: 5.0,  bottom: 0.0, right: 5),
          child: Row(
            children: [
              Container(
                width: (MediaQuery.of(context).size.width / 2) - 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ItemBadge(
                      outOfStock: widget.storedsearchdata!.stock!<=0?OutOfStock(singleproduct: false,):null,
                      child: Align(
                        alignment: Alignment.center,
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              if(widget.fromScreen == "sellingitem_screen") {
                                Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid": widget.storedsearchdata!.id.toString(),"productId": widget.storedsearchdata!.id!});
                              }
                              else{
                                Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid": widget.storedsearchdata!.id.toString(),"productId": widget.storedsearchdata!.id!});
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 4.0, bottom: 3.0),
                              child: CachedNetworkImage(
                                imageUrl: widget.storedsearchdata!.itemFeaturedImage,
                                errorWidget: (context, url, error) => Image.asset(
                                  Images.defaultProductImg,
                                  width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                  height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                ),
                                placeholder: (context, url) => Image.asset(
                                  Images.defaultProductImg,
                                  width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                  height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                ),
                                width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                height: ResponsiveLayout.isSmallScreen(context) ? 120 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                //  fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(width: 5,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: (MediaQuery
                        .of(context)
                        .size
                        .width / 1.6),
                    child: Row(
                      children: [
                        Container(
                            width: (MediaQuery
                                .of(context)
                                .size
                                .width / 2.6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5,),
                                 Container(
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          widget.storedsearchdata!.brand!,
                                          style: TextStyle(
                                              fontSize: 10, color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height:40,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          widget.storedsearchdata!.itemName!,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                            //fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                (widget.storedsearchdata!.singleshortNote != "")?
                                Container(
                                  height: 20,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(widget.storedsearchdata!.singleshortNote.toString(),style: TextStyle(fontSize: 12,color: ColorCodes.greyColor,),),
                                    ],
                                  ),
                                ):SizedBox.shrink(),
                                SizedBox(height: 5,),
                                Container(
                                    child: Row(
                                      children: <Widget>[
                                        if(Features.isMembership)
                                          _checkmembership?Container(
                                            width: 10.0,
                                            height: 9.0,
                                            margin: EdgeInsets.only(right: 3.0),
                                            child: Image.asset(
                                              Images.starImg,
                                              color: ColorCodes.starColor,
                                            ),
                                          ):SizedBox.shrink(),
                                        new RichText(
                                          text: new TextSpan(
                                            style: new TextStyle(
                                              fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 15 : 16,
                                              color: Colors.black,
                                            ),
                                            children: <TextSpan>[
//                            if(varmemberprice.toString() == varmrp.toString())
                                              new TextSpan(
                                                  text: Features.iscurrencyformatalign?
                                                  '${_checkmembership?widget.storedsearchdata!.membershipPrice:widget.storedsearchdata!.price} ' + IConstants.currencyFormat:
                                                  IConstants.currencyFormat + '${_checkmembership?widget.storedsearchdata!.membershipPrice:widget.storedsearchdata!.price} ',
                                                  style: new TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontSize: ResponsiveLayout.isSmallScreen(context) ? 15 : ResponsiveLayout.isMediumScreen(context) ? 15 : 16,)),
                                              new TextSpan(
                                                  text: widget.storedsearchdata!.price!=widget.storedsearchdata!.mrp?
                                                  Features.iscurrencyformatalign?
                                                  '${widget.storedsearchdata!.mrp} ' + IConstants.currencyFormat:
                                                  IConstants.currencyFormat + '${widget.storedsearchdata!.mrp} ':"",
                                                  style: TextStyle(
                                                    decoration:
                                                    TextDecoration.lineThrough,
                                                    fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,)),
                                            ],
                                          ),
                                        )
                                      ],
                                    )),

                                SizedBox(height: 8,),
                                VxBuilder(
                                  builder: (context,  box, index) {
                                    if(store.userData.membership! == "1"){
                                      _checkmembership = true;
                                    } else {
                                      _checkmembership = false;
                                      for (int i = 0; i < productBox.length; i++) {
                                        if (productBox[i].mode == "1") {
                                          _checkmembership = true;
                                        }
                                      }
                                    }
                                    return Column(
                                      children: [
                                        (Features.isMembership && double.parse(widget.storedsearchdata!.membershipPrice.toString()) > 0)?
                                        Row(
                                          children: [
                                            !_checkmembership
                                                ? widget.storedsearchdata!.membershipDisplay!
                                                ? GestureDetector(
                                              onTap: () {
                                                (checkskip &&Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
                                                LoginWeb(context,result: (sucsess){
                                                  if(sucsess){
                                                    Navigator.of(context).pop();
                                                    Navigation(context, navigatore: NavigatoreTyp.homenav);
                                                  }else{
                                                    Navigator.of(context).pop();
                                                  }
                                                })
                                                    :
                                                (checkskip && !Vx.isWeb)?
                                                Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.PushReplacment)
                                                    :
                                                 (Vx.isWeb &&
                                                !ResponsiveLayout.isSmallScreen(context)) ?
                                                MembershipInfo(context):
                                                Navigation(context, name: Routename.Membership, navigatore: NavigatoreTyp.Push);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(vertical: 5,),
                                                width: (MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width / 3) +
                                                    5,
                                                height:30,
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    left: BorderSide(width: 5.0, color: ColorCodes.darkgreen),
                                                    // bottom: BorderSide(width: 16.0, color: Colors.lightBlue.shade900),
                                                  ),
                                                  color: ColorCodes.varcolor,
                                                ),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    SizedBox(width: 2),
                                                    Text(
                                                        Features.iscurrencyformatalign?
                                                        widget.storedsearchdata!.membershipPrice.toString() + IConstants.currencyFormat:
                                                        IConstants.currencyFormat +
                                                            widget.storedsearchdata!.membershipPrice.toString()+" "+S.of(context).membership_price/*" Membership Price"*/,
                                                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 11 : 12,color: ColorCodes.greenColor)),
                                                  ],
                                                ),
                                              ),
                                            )
                                                : SizedBox.shrink()
                                                : SizedBox.shrink(),
                                          ],
                                        ):SizedBox(height: 30,),
                                      ],
                                    );
                                  }, mutations: {ProductMutation,SetCartItem},
                                ),
                              ],
                            )),
                        Container(
                            width: (MediaQuery
                                .of(context)
                                .size
                                .width / 4.5),
                            child: Column(
                              children: [
                                (widget.storedsearchdata!.eligibleForExpress == "0")?
                                Container(
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Image.asset(Images.express,
                                        height: 20.0,
                                        width: 25.0,),
                                    ],
                                  ),
                                ):SizedBox(height: 40,),
                                SizedBox(height: 8,),
                                Features.isSubscription && widget.storedsearchdata!.eligibleForSubscription=="0"?
                                Container(
                                  height:40,
                                  width: (MediaQuery.of(context).size.width/3)+5 ,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left:0,right:0.0),
                                    child: CustomeStepper(searchstoredata: widget.storedsearchdata,from:"search_screen",height: (Features.isSubscription)?40:40,issubscription: "Subscribe",addon:(widget.storedsearchdata!.addon!.length > 0)?widget.storedsearchdata!.addon![0]:null, index: itemindex),
                                  ),
                                ):SizedBox(height:40,),
                                SizedBox(
                                  height: 4.5,
                                ),
                                if(Features.isLoyalty)
                                  (double.parse(widget.storedsearchdata!.loyalty.toString()) > 0)?
                                  Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Image.asset(Images.coinImg,
                                          height: 15.0,
                                          width: 20.0,),
                                        SizedBox(width: 4),
                                        Text(widget.storedsearchdata!.loyalty.toString()),
                                      ],
                                    ),
                                  ):SizedBox(height: 10,),
                                SizedBox(height: 8,),
                                // SizedBox(height: 5,),
                                Container(
                                  height:40,
                                  width: (MediaQuery.of(context).size.width/3)+5 ,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left:0,right:0.0),
                                    child: CustomeStepper(searchstoredata: widget.storedsearchdata,from:"search_screen",height: (Features.isSubscription)?40:40,issubscription: "Add",addon:(widget.storedsearchdata!.addon!.length > 0)?widget.storedsearchdata!.addon![0]:null, index: itemindex),
                                  ),
                                ),

                              ],
                            )),
                      ],
                    ),
                  ),
                  if(Features.netWeight && widget.storedsearchdata!.vegType == "fish")
                    Container(
                      width: (MediaQuery
                          .of(context)
                          .size
                          .width / 2) + 70,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                Features.iscurrencyformatalign?
                                /*"Whole Uncut:"*/S.of(context).whole_uncut +" " +
                                    widget.storedsearchdata!.salePrice! + IConstants.currencyFormat +" / "+ /*"500 G"*/S.of(context).gram:
                                /*"Whole Uncut:"*/S.of(context).whole_uncut +" "+ IConstants.currencyFormat +
                                    widget.storedsearchdata!.salePrice! +" / "+ /*"500 G"*/S.of(context).gram,
                                style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 16, fontWeight: FontWeight.bold),),
                            ],
                          ),
                          SizedBox(height: 3),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Text(/*"Gross Weight:"*/S.of(context).gross_weight +" "+
                                        widget.storedsearchdata!.weight!,
                                        style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 16, fontWeight: FontWeight.bold)
                                    ),
                                  ),
                                  Container(
                                    child: Text(/*"Net Weight:"*/S.of(context).net_weight +" "+
                                        widget.storedsearchdata!.netWeight!,
                                        style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 16, fontWeight: FontWeight.bold)
                                    ),
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  Container(
                    width: (MediaQuery.of(context).size.width/2)+70,
                    child:   Row(
                      children: [
                        Container(
                          width: (MediaQuery.of(context).size.width /2) + 70,
                          child:
                          Row( mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: ColorCodes.whiteColor,
                                        borderRadius: new BorderRadius.only(
                                          topLeft:
                                          const Radius.circular(2.0),
                                          topRight:
                                          const Radius.circular(2.0),
                                          bottomLeft:
                                          const Radius.circular(2.0),
                                          bottomRight:
                                          const Radius.circular(2.0),
                                        )),
                                    height: 10,
                                    padding: EdgeInsets.fromLTRB(
                                        5.0, 4.5, 0.0, 4.5),
                                    child: SizedBox.shrink()
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ):
      GestureDetector(
        onTap: (){
          if(widget.fromScreen == "sellingitem_screen") {
            if (widget.storedsearchdata!.priceVariation![itemindex].stock !>= 0)
              Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid": widget.storedsearchdata!.priceVariation![itemindex].menuItemId.toString(),"productId": widget.storedsearchdata!.priceVariation![itemindex].menuItemId.toString()});
          }
          else{
            if (widget.storedsearchdata!.priceVariation![itemindex].stock !>= 0)
              Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid": widget.storedsearchdata!.priceVariation![itemindex].menuItemId.toString(),"productId": widget.storedsearchdata!.priceVariation![itemindex].menuItemId.toString()});
            else
              Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid": widget.storedsearchdata!.priceVariation![itemindex].menuItemId.toString(),"productId": widget.storedsearchdata!.priceVariation![itemindex].menuItemId.toString()});
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            border: (Features.ismultivendor)? Border(
              bottom: BorderSide(width: 0.0, color: Colors.transparent),
            ) : Border(
              bottom: BorderSide(width: 2.0, color: ColorCodes.lightGreyWebColor),
            ),
          ),
          margin: (Features.ismultivendor)? EdgeInsets.only(left: 0.0,  bottom: 0.0, right: 0) : EdgeInsets.only(left: 5.0,  bottom: 0.0, right: 5),
          child: Row(
            children: [
              Container(
                width: (MediaQuery
                    .of(context)
                    .size
                    .width / 2) - 100,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ItemBadge(
                      outOfStock: widget.storedsearchdata!.priceVariation![itemindex].stock!<=0?OutOfStock(singleproduct: false,):null,
                      child: Align(
                        alignment: Alignment.center,
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              if(widget.fromScreen == "sellingitem_screen") {
                                Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid": widget.storedsearchdata!.priceVariation![itemindex].menuItemId.toString(),"productId": widget.storedsearchdata!.priceVariation![itemindex].menuItemId.toString()});
                              }
                              else{
                                Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid": widget.storedsearchdata!.priceVariation![itemindex].menuItemId.toString(),"productId": widget.storedsearchdata!.priceVariation![itemindex].menuItemId.toString()});
                              }
                            },
                            child:  Stack(
                              children: [
                                if(margins > 0)
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(

                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            3.0),
                                        color: ColorCodes.greenColor,//Color(0xff6CBB3C),
                                      ),
                                      constraints: BoxConstraints(
                                        minWidth: 28,
                                        minHeight: 15,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left:5.0,right: 5,),
                                        child: Text(
                                          margins.toStringAsFixed(0) + S .of(context).off ,//"% OFF",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: ColorCodes.whiteColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                Container(
                                  margin: EdgeInsets.only(top: 15.0, bottom: 8.0),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.storedsearchdata!.priceVariation![itemindex].images!.length<=0?widget.storedsearchdata!.itemFeaturedImage:widget.storedsearchdata!.priceVariation![itemindex].images![0].image,
                                    errorWidget: (context, url, error) => Image.asset(
                                      Images.defaultProductImg,
                                      width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                      height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                    ),
                                    placeholder: (context, url) => Image.asset(
                                      Images.defaultProductImg,
                                      width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                      height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                    ),
                                    width: ResponsiveLayout.isSmallScreen(context) ? 115 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                    height: ResponsiveLayout.isSmallScreen(context) ? 120 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                    //  fit: BoxFit.fill,
                                  ),
                                ),
                              ],
                            ),

                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 5,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: Features.btobModule?(MediaQuery
                        .of(context)
                        .size
                        .width / 1.5):(MediaQuery
                        .of(context)
                        .size
                        .width / 1.6),
                    child: Row(
                      children: [
                        Container(
                            width: Features.btobModule?(MediaQuery
                                .of(context)
                                .size
                                .width / 1.5):(MediaQuery
                                .of(context)
                                .size
                                .width / 2.5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5,),
                                 Container(
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          widget.storedsearchdata!.brand!,
                                          style: TextStyle(
                                              fontSize: 10, color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height:40,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          widget.storedsearchdata!.itemName!,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                            //fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                widget.storedsearchdata!.priceVariation!.length > 1?
                                Features.btobModule?
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: (MediaQuery.of(context).size.width / 2) + 20,
                                      child:
                                      GridView.builder(
                                          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: widgetsInRow,
                                            crossAxisSpacing: 0,
                                            childAspectRatio: aspectRatio,
                                            mainAxisSpacing: 0,
                                          ),
                                          controller: new ScrollController(keepScrollOffset: false),
                                          shrinkWrap: true,
                                          itemCount: widget.storedsearchdata!.priceVariation!.length,
                                          itemBuilder: (_, i) {
                                            return
                                              GestureDetector(
                                                  behavior: HitTestBehavior.translucent,
                                                  onTap: () async {
                                                    setState(() {
                                                      _groupValue = i;
                                                    });
                                                    if(productBox
                                                        .where((element) =>
                                                    element.itemId! == widget.storedsearchdata!.id
                                                    ).length >= 1) {
                                                      cartcontroller.update((done) {
                                                      }, price: widget.storedsearchdata!.price.toString(),
                                                          quantity: widget.storedsearchdata!.priceVariation![i].minItem.toString(),
                                                          type: widget.storedsearchdata!.type,
                                                          weight: (
                                                              double.parse(widget.storedsearchdata!.increament!)).toString(),
                                                          var_id: widget.storedsearchdata!.priceVariation![0].id.toString(),
                                                          increament: widget.storedsearchdata!.increament,
                                                          cart_id: productBox
                                                              .where((element) =>
                                                          element.itemId! == widget.storedsearchdata!.id
                                                          ).first.parent_id.toString(),
                                                          toppings: "",
                                                          topping_id: "",
                                                          item_id: widget.storedsearchdata!.id!

                                                      );
                                                    }
                                                    else {
                                                      cartcontroller.addtoCart(storeSearchData: widget.storedsearchdata,
                                                          onload: (isloading) {
                                                          },
                                                          topping_type: "",
                                                          varid: widget.storedsearchdata!.priceVariation![0].id,
                                                          toppings: "",
                                                          parent_id: "",
                                                          newproduct: "0",
                                                          toppingsList: [],
                                                          itembodysearch:  widget.storedsearchdata!.priceVariation![i],
                                                          context: context);
                                                    }
                                                  },
                                                  child: Container(
                                                      height: 50,
                                                      width:90,
                                                      decoration: BoxDecoration(
                                                        color: _groupValue == i ? ColorCodes.mediumgren : ColorCodes.whiteColor,
                                                        borderRadius: BorderRadius.circular(5.0),
                                                        border: Border.all(
                                                          color: ColorCodes.greenColor,
                                                        ),
                                                      ),
                                                      margin: EdgeInsets.only(right: 10,bottom:2),
                                                      padding: EdgeInsets.only(right: 5,left:5),
                                                      child:

                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(
                                                                "${widget.storedsearchdata!.priceVariation![i].minItem}"+"-"+"${widget.storedsearchdata!.priceVariation![i].maxItem}"+" "+"${widget.storedsearchdata!.priceVariation![i].unit}",
                                                                style:
                                                                TextStyle(color: _groupValue == i ?ColorCodes.darkgreen:ColorCodes.blackColor,fontWeight: FontWeight.bold,fontSize: 12),),

                                                              _groupValue == i ?
                                                              Container(
                                                                width: 18.0,
                                                                height: 18.0,
                                                                margin: EdgeInsets.only(top:3),
                                                                decoration: BoxDecoration(
                                                                  color: ColorCodes.greenColor,
                                                                  border: Border.all(
                                                                    color: ColorCodes.greenColor,
                                                                  ),
                                                                  shape: BoxShape.circle,
                                                                ),
                                                                child: Container(
                                                                  margin: EdgeInsets.all(3),
                                                                  decoration: BoxDecoration(
                                                                    color: ColorCodes.greenColor,
                                                                    shape: BoxShape.circle,
                                                                  ),
                                                                  child: Icon(Icons.check,
                                                                      color: ColorCodes.whiteColor,
                                                                      size: 12.0),
                                                                ),
                                                              )
                                                                  :
                                                              Icon(
                                                                  Icons.radio_button_off_outlined,
                                                                  color: ColorCodes.greenColor),
                                                            ],
                                                          ),

                                                          if(Features.isMembership)
                                                            _checkmembership?Container(
                                                              width: 10.0,
                                                              height: 9.0,
                                                              margin: EdgeInsets.only(right: 3.0),
                                                              child: Image.asset(
                                                                Images.starImg,
                                                                color: ColorCodes.starColor,
                                                              ),
                                                            ):SizedBox.shrink(),
                                                          new RichText(
                                                            text: new TextSpan(
                                                              style: new TextStyle(
                                                                fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 12 : 12,
                                                                color: _groupValue == i ?ColorCodes.darkgreen:ColorCodes.blackColor,
                                                              ),
                                                              children: <TextSpan>[
//                            if(varmemberprice.toString() == varmrp.toString())
                                                                new TextSpan(
                                                                    text: Features.iscurrencyformatalign?
                                                                    '${_checkmembership?widget.storedsearchdata!.priceVariation![i].membershipPrice:widget.storedsearchdata!.priceVariation![i].price} ' + IConstants.currencyFormat:
                                                                    IConstants.currencyFormat + '${_checkmembership?widget.storedsearchdata!.priceVariation![i].membershipPrice:widget.storedsearchdata!.priceVariation![i].price} ',
                                                                    style: new TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                      color: _groupValue == i ?ColorCodes.darkgreen:ColorCodes.blackColor,
                                                                      fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 12 : 12,)),
                                                                new TextSpan(
                                                                    text: widget.storedsearchdata!.priceVariation![i].price!=widget.storedsearchdata!.priceVariation![i].mrp?
                                                                    Features.iscurrencyformatalign?
                                                                    '${widget.storedsearchdata!.priceVariation![i].mrp} ' + IConstants.currencyFormat:
                                                                    IConstants.currencyFormat + '${widget.storedsearchdata!.priceVariation![i].mrp} ':"",
                                                                    style: TextStyle(
                                                                      decoration:
                                                                      TextDecoration.lineThrough,
                                                                      fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,)),
                                                              ],
                                                            ),
                                                          )


                                                        ],)


                                                  )
                                              );

                                          })
                                    ),
                                    // )
                                  ],
                                ):
                                Container(
                                  width: (MediaQuery
                                      .of(context)
                                      .size
                                      .width / 3),
                                  child:   Row(
                                    children: [
                                      Container(
                                        width: (MediaQuery
                                            .of(context)
                                            .size
                                            .width /3),
                                        child: (widget.storedsearchdata!.priceVariation!.length > 1)
                                            ? GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              showoptions1();
                                            });
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 40,
                                                child: Text(
                                                  "${widget.storedsearchdata!.priceVariation![itemindex].variationName}"+" "+"${widget.storedsearchdata!.priceVariation![itemindex].unit}",
                                                  style:
                                                  TextStyle(color: ColorCodes.darkgreen,fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              //SizedBox(width: 10,),
                                              Icon(
                                                Icons.keyboard_arrow_down,
                                                color: ColorCodes.darkgreen,
                                                size: 20,
                                              ),
                                            ],
                                          ),
                                        )
                                            : Row( mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                height: 40,
                                                child: Text(
                                                  "${widget.storedsearchdata!.priceVariation![itemindex].variationName}"+" "+"${widget.storedsearchdata!.priceVariation![itemindex].unit}",
                                                  style: TextStyle(color: ColorCodes.greyColor,fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ):SizedBox.shrink(),
                                Container(
                                    child: Row(
                                      children: <Widget>[
                                        if(!Features.btobModule)
                                        if(Features.isMembership)
                                          _checkmembership?Container(
                                            width: 10.0,
                                            height: 9.0,
                                            margin: EdgeInsets.only(right: 3.0),
                                            child: Image.asset(
                                              Images.starImg,
                                              color: ColorCodes.starColor,
                                            ),
                                          ):SizedBox.shrink(),
                                        if(!Features.btobModule)
                                        new RichText(
                                          text: new TextSpan(
                                            style: new TextStyle(
                                              fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 15 : 16,
                                              color: Colors.black,
                                            ),
                                            children: <TextSpan>[
                                              new TextSpan(
                                                  text: Features.iscurrencyformatalign?
                                                  '${_checkmembership?widget.storedsearchdata!.priceVariation![itemindex].membershipPrice:widget.storedsearchdata!.priceVariation![itemindex].price} ' + IConstants.currencyFormat:
                                                  IConstants.currencyFormat + '${_checkmembership?widget.storedsearchdata!.priceVariation![itemindex].membershipPrice:widget.storedsearchdata!.priceVariation![itemindex].price} ',
                                                  style: new TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontSize: ResponsiveLayout.isSmallScreen(context) ? 15 : ResponsiveLayout.isMediumScreen(context) ? 15 : 16,)),
                                              new TextSpan(
                                                  text: widget.storedsearchdata!.priceVariation![itemindex].price!=widget.storedsearchdata!.priceVariation![itemindex].mrp?
                                                  Features.iscurrencyformatalign?
                                                  '${widget.storedsearchdata!.priceVariation![itemindex].mrp} ' + IConstants.currencyFormat:
                                                  IConstants.currencyFormat + '${widget.storedsearchdata!.priceVariation![itemindex].mrp} ':"",
                                                  style: TextStyle(
                                                    decoration:
                                                    TextDecoration.lineThrough,
                                                    fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,)),
                                            ],
                                          ),
                                        )

                                      ],
                                    )),
                                SizedBox(
                                  height: 8,
                                ),
                                Features.btobModule?
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Text(S.of(context).total,style: TextStyle(color: ColorCodes.blackColor)),
                                        productBox
                                            .where((element) =>
                                        element.itemId == widget.storedsearchdata!.id).length > 0?
                                        Text( IConstants.currencyFormat + (double.parse(widget.storedsearchdata!.priceVariation![_groupValue].price!) * _count).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                          style: TextStyle(
                                              color: ColorCodes.greenColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15
                                          ),): Text( IConstants.currencyFormat + (double.parse(widget.storedsearchdata!.priceVariation![itemindex].price!)).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                          style: TextStyle(
                                              color: ColorCodes.greenColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15
                                          ),),
                                      ],
                                    ),
                                    SizedBox(width:10),
                                    Container(
                                      height:40,
                                      width: (MediaQuery.of(context).size.width/3)+5 ,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left:0,right:0.0),
                                        child:
                                        CustomeStepper(priceVariationSearch:widget.storedsearchdata!.priceVariation![itemindex],searchstoredata: widget.storedsearchdata,from:"search_screen",height: (Features.isSubscription)?40:40,issubscription: "Add",addon:(widget.storedsearchdata!.addon!.length > 0)?widget.storedsearchdata!.addon![0]:null, index: itemindex,groupvalue: _groupValue,onChange: (int value,int count){
                                          setState(() {
                                            _groupValue = value;
                                            _count = count;
                                          });
                                        }),
                                      ),
                                    ),
                                  ],
                                ):SizedBox.shrink(),
                                VxBuilder(
                                  builder: (context, box, index) {
                                    if(store.userData.membership! == "1"){
                                      _checkmembership = true;
                                    } else {
                                      _checkmembership = false;
                                      for (int i = 0; i < productBox.length; i++) {
                                        if (productBox[i].mode == "1") {
                                          _checkmembership = true;
                                        }
                                      }
                                    }
                                    return Column(
                                      children: [
                                        if(Features.isMembership && double.parse(widget.storedsearchdata!.priceVariation![itemindex].membershipPrice.toString()) > 0)
                                          Row(
                                            children: [
                                              !_checkmembership
                                                  ? widget.storedsearchdata!.priceVariation![itemindex].membershipDisplay!
                                                  ? GestureDetector(
                                                onTap: () {
                                                  (checkskip &&Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
                                                  LoginWeb(context,result: (sucsess){
                                                    if(sucsess){
                                                      Navigator.of(context).pop();
                                                      Navigation(context, navigatore: NavigatoreTyp.homenav);
                                                    }else{
                                                      Navigator.of(context).pop();
                                                    }
                                                  })
                                                      :
                                                  (checkskip && !Vx.isWeb)?
                                                  Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.PushReplacment)
                                                      :
                                                   (Vx.isWeb &&
                                                  !ResponsiveLayout.isSmallScreen(context)) ?
                                                  MembershipInfo(context):
                                                  Navigation(context, name: Routename.Membership, navigatore: NavigatoreTyp.Push);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(vertical: 5,),
                                                  width: (MediaQuery.of(context).size.width / 3) + 5,
                                                  height:30,
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      left: BorderSide(width: 5.0, color: ColorCodes.darkgreen),
                                                    ),
                                                    color: ColorCodes.varcolor,
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      SizedBox(width: 2),
                                                      Text(
                                                          Features.iscurrencyformatalign?
                                                          widget.storedsearchdata!.priceVariation![itemindex].membershipPrice.toString() + IConstants.currencyFormat:
                                                          IConstants.currencyFormat +
                                                              widget.storedsearchdata!.priceVariation![itemindex].membershipPrice.toString() + /*" Membership Price"*/" "+S.of(context).membership_price,
                                                          style: TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 11 : 12,color: ColorCodes.greenColor,fontWeight: FontWeight.bold)),
                                                    ],
                                                  ),
                                                ),
                                              )
                                                  : SizedBox.shrink()
                                                  : SizedBox.shrink(),
                                            ],
                                          ),
                                      ],
                                    );
                                  }, mutations: {ProductMutation,SetCartItem},
                                ),
                              ],
                            )),
                        !Features.btobModule?
                        Container(
                            width: (MediaQuery
                                .of(context)
                                .size
                                .width / 4.5),
                            child: Column(
                              children: [
                                (widget.storedsearchdata!.eligibleForExpress == "0")?
                                Container(
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Image.asset(Images.express,
                                        height: 20.0,
                                        width: 25.0,),
                                    ],
                                  ),
                                ):SizedBox(height: 40,),
                                SizedBox(height: 8,),

                                Features.isSubscription && widget.storedsearchdata!.eligibleForSubscription=="0"?
                                Container(
                                  height:40,

                                  child: CustomeStepper(priceVariationSearch:widget.storedsearchdata!.priceVariation![itemindex],searchstoredata: widget.storedsearchdata,from:"search_screen",height: (Features.isSubscription)?40:40,issubscription: "Subscribe",addon:(widget.storedsearchdata!.addon!.length > 0)?widget.storedsearchdata!.addon![0]:null, index: itemindex),
                                ):SizedBox(height: 40,),


                                if(Features.isLoyalty)
                                  (double.parse(widget.storedsearchdata!.priceVariation![itemindex].loyalty.toString()) > 0)?
                                  Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Image.asset(Images.coinImg,
                                          height: 15.0,
                                          width: 20.0,),
                                        SizedBox(width: 4),
                                        Text(widget.storedsearchdata!.priceVariation![itemindex].loyalty.toString()),
                                      ],
                                    ),
                                  ):SizedBox(height: 10,),
                                SizedBox(height: 8,),
                                Container(
                                  height:40,
                                  width: (MediaQuery.of(context).size.width/3)+5 ,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left:0,right:0.0),
                                    child: CustomeStepper(priceVariationSearch: widget.storedsearchdata!.priceVariation![itemindex],searchstoredata:widget.storedsearchdata,from:"search_screen",height: (Features.isSubscription)?40:40,issubscription: "Add",addon:(widget.storedsearchdata!.addon!.length > 0)?widget.storedsearchdata!.addon![0]:null, index: itemindex),
                                  ),
                                )

                              ],
                            )):SizedBox.shrink(),
                      ],
                    ),
                  ),
                  if(Features.netWeight && widget.storedsearchdata!.vegType == "fish")
                    Container(
                      width: (MediaQuery
                          .of(context)
                          .size
                          .width / 2) + 70,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                Features.iscurrencyformatalign?
                                /*"Whole Uncut:"*/S.of(context).whole_uncut +" " +
                                    widget.storedsearchdata!.salePrice! + IConstants.currencyFormat +" / "+ /*"500 G"*/S.of(context).gram:
                                /*"Whole Uncut:"*/S.of(context).whole_uncut +" "+ IConstants.currencyFormat +
                                    widget.storedsearchdata!.salePrice! +" / "+ /*"500 G"*/S.of(context).gram,
                                style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 16, fontWeight: FontWeight.bold),),
                            ],
                          ),
                          SizedBox(height: 3),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Text(/*"Gross Weight:"*/S.of(context).gross_weight +" "+
                                        widget.storedsearchdata!.priceVariation![itemindex].weight!,
                                        style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 16, fontWeight: FontWeight.bold)
                                    ),
                                  ),
                                  Container(
                                    child: Text(/*"Net Weight:"*/ S.of(context).net_weight +" "+
                                        widget.storedsearchdata!.priceVariation![itemindex].netWeight!,
                                        style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 16, fontWeight: FontWeight.bold)
                                    ),
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  // SizedBox(height: 5,),


                ],
              ),
            ],
          ),
        ),
      ):


      widget.itemdata!.type=="1"?
      Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
             bottom: BorderSide(width: 2.0, color: ColorCodes.lightGreyWebColor),
          ),
        ),
        margin: EdgeInsets.only(left: 5.0, bottom: 0.0, right: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: (MediaQuery
                  .of(context)
                  .size
                  .width / 2) - 75,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      ItemBadge(
                        outOfStock: widget.itemdata!.stock!<=0?OutOfStock(singleproduct: false,):null,
                        child: Align(
                          alignment: Alignment.center,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                if(widget.fromScreen == "sellingitem_screen") {
                                  Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid": widget.itemdata!.id.toString(),"productId": widget.itemdata!.id!});
                                }
                                else{
                                  Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid": widget.itemdata!.id.toString(),"productId": widget.itemdata!.id!});
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 10.0, bottom: 8.0),
                                child: CachedNetworkImage(
                                  imageUrl: widget.itemdata!.itemFeaturedImage,
                                  errorWidget: (context, url, error) => Image.asset(
                                    Images.defaultProductImg,
                                    width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                    height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                  ),
                                  placeholder: (context, url) => Image.asset(
                                    Images.defaultProductImg,
                                    width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                    height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                  ),
                                  width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                  height: ResponsiveLayout.isSmallScreen(context) ? 120 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                  //  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            if(margins > 0)
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      3.0),
                                  color: ColorCodes.primaryColor,//Color(0xff6CBB3C),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8, right: 8, top:4, bottom: 4),
                                  child: Text(
                                    margins.toStringAsFixed(0) + S .of(context).off ,//"% OFF",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 9,
                                        color: ColorCodes.whiteColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            if(margins > 0)
                              Spacer(),

                            (widget.itemdata!.eligibleForExpress == "0")?
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    3.0),
                                border: Border.all(
                                    color: ColorCodes.varcolor),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 2, right: 2, top:4, bottom: 4),
                                child: Row(
                                  children: [
                                    Text(
                                      S .of(context).express ,//"% OFF",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 9,
                                          color: ColorCodes.primaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 2),
                                    Image.asset(Images.express,
                                      color: ColorCodes.primaryColor,
                                      height: 11.0,
                                      width: 11.0,),

                                  ],
                                ),
                              ),
                            ) : SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 5,),
            Column(
              mainAxisAlignment: Features.btobModule?MainAxisAlignment.start:MainAxisAlignment.center,
              children: [
                Container(
                  width: (MediaQuery.of(context).size.width / 2) + 55,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          width: (MediaQuery
                              .of(context)
                              .size
                              .width / 2.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        widget.itemdata!.brand!,
                                        style: TextStyle(
                                            fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 4,),
                              Container(
                                height:38,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        widget.itemdata!.itemName!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                          //fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 35,
                              ),
                              


                              Container(
                                  child: Row(
                                    children: <Widget>[
                                     /* if(Features.isMembership)
                                        _checkmembership?Container(
                                          width: 10.0,
                                          height: 9.0,
                                          margin: EdgeInsets.only(right: 3.0),
                                          child: Image.asset(
                                            Images.starImg,
                                            color: ColorCodes.starColor,
                                          ),
                                        ):SizedBox.shrink(),*/
                                      new RichText(
                                        text: new TextSpan(
                                          style: new TextStyle(
                                            fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 15 : 16,
                                            color: Colors.black,
                                          ),
                                          children: <TextSpan>[
//                            if(varmemberprice.toString() == varmrp.toString())
                                            new TextSpan(
                                                  text: _price,
                                                /*text: Features.iscurrencyformatalign?
                                                '${_checkmembership?widget.itemdata!.membershipPrice:widget.itemdata!.price} ' + IConstants.currencyFormat:
                                                IConstants.currencyFormat + '${_checkmembership?widget.itemdata!.membershipPrice:widget.itemdata!.price} ',*/
                                                style: new TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: _checkmembership?ColorCodes.primaryColor:Colors.black,
                                                  fontSize: ResponsiveLayout.isSmallScreen(context) ? 15 : ResponsiveLayout.isMediumScreen(context) ? 15 : 16,)),
                                            new TextSpan(
                                                    text: _mrp,
                                                /*text: widget.itemdata!.price!=widget.itemdata!.mrp?
                                                Features.iscurrencyformatalign?
                                                '${widget.itemdata!.mrp} ' + IConstants.currencyFormat:
                                                IConstants.currencyFormat + '${widget.itemdata!.mrp} ':"",*/
                                                style: TextStyle(
                                                  decoration:
                                                  TextDecoration.lineThrough,
                                                  fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,)),
                                          ],
                                        ),
                                      )
                                    ],
                                  )),
                              SizedBox(height: 4,),


                            ],
                          )),
                      Container(
                          width: (MediaQuery
                              .of(context)
                              .size
                              .width / 4.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if(Features.isLoyalty)
                                (double.parse(widget.itemdata!.loyalty.toString()) > 0)?
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Image.asset(Images.coinImg,
                                        height: 12.0,
                                        width: 15.0,),
                                      SizedBox(width: 2),
                                      Text(widget.itemdata!.loyalty.toString(),
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize:11),),
                                    ],
                                  ),
                                ):SizedBox(height: 10,),
                              SizedBox(height: 4,),
                              (Features.isSubscription && widget.itemdata!.eligibleForSubscription=="0")?
                              Container(
                                height:40,
                                width: (MediaQuery.of(context).size.width/3)+5 ,
                                child: Padding(
                                  padding: const EdgeInsets.only(left:0,right:0.0),
                                  child: CustomeStepper(itemdata: widget.itemdata,from:"selling_item",height: (Features.isSubscription)?40:40,issubscription: "Subscribe",addon:(widget.itemdata!.addon!.length > 0)?widget.itemdata!.addon![0]:null, index: itemindex),
                                ),
                              ):  SizedBox(height: 20,),
                              // SizedBox(
                              //   height: 4.5,
                              // ),

                              SizedBox(height: 10,),
                              (widget.itemdata!.singleshortNote != "" || widget.itemdata!.singleshortNote != "0")?
                              Container(
                                height: 20,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(widget.itemdata!.singleshortNote.toString(),
                                    overflow: TextOverflow.ellipsis,
//                                  maxLines: 1,
                                    style: TextStyle(fontSize: 10,color: ColorCodes.greyColor,),),
                                  ],
                                ),
                              ):SizedBox.shrink(),
                              if(widget.itemdata!.singleshortNote != "" || widget.itemdata!.singleshortNote != "0")SizedBox(height: 4,),
                              (!Features.btobModule)?
                              _checkmembership ? widget.itemdata!.membershipDisplay! ?
                              Container(
                                height: 20,
                                width:MediaQuery.of(context).size.width/4 ,
                                decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(width: 3.0, color: ColorCodes.darkgreen),
                                  ),
                                  color: ColorCodes.varcolor,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(width: 3,),
                                    Image.asset(
                                      Images.bottomnavMembershipImg,
                                      color: ColorCodes.primaryColor,
                                      width: 15,
                                      height: 10,),
                                    SizedBox(width: 3),
                                    Text(/*"Savings "*/S.of(context).savings ,style: TextStyle(fontSize: 10, color: ColorCodes.darkgreen,fontWeight: FontWeight.bold)),
                                    Padding(
                                      padding: const EdgeInsets.only(top:5.0,bottom:5),
                                      child: Text(
                                          Features.iscurrencyformatalign?
                                          (double.parse(widget.itemdata!.mrp!) - double.parse(widget.itemdata!.membershipPrice!)).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + IConstants.currencyFormat:
                                          IConstants.currencyFormat +
                                              (double.parse(widget.itemdata!.mrp!) - double.parse(widget.itemdata!.membershipPrice!)).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                          style: TextStyle(fontSize: 10, color: ColorCodes.darkgreen,fontWeight: FontWeight.bold)),
                                    ),


                                    SizedBox(width: 5),
                                  ],
                                ),
                              ):SizedBox(height: 20,):
                              VxBuilder(
                                // valueListenable: Hive.box<Product>(productBoxName).listenable(),
                                builder: (context, box, index) {
                                  if(store.userData.membership! == "1"){
                                    _checkmembership = true;
                                  } else {
                                    _checkmembership = false;
                                    for (int i = 0; i < productBox.length; i++) {
                                      if (productBox[i].mode == "1") {
                                        _checkmembership = true;
                                      }
                                    }
                                  }
                                  return Column(
                                    children: [
                                      (Features.isMembership && double.parse(widget.itemdata!.membershipPrice.toString()) > 0)?
                                      Row(
                                        children: [
                                          !_checkmembership
                                              ? widget.itemdata!.membershipDisplay!
                                              ? GestureDetector(
                                            onTap: () {
                                              (checkskip &&Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
                                              LoginWeb(context,result: (sucsess){
                                                if(sucsess){
                                                  Navigator.of(context).pop();
                                                  Navigation(context, navigatore: NavigatoreTyp.homenav);
                                                }else{
                                                  Navigator.of(context).pop();
                                                }
                                              })
                                                  :
                                              (checkskip && !Vx.isWeb)?
                                              Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.PushReplacment)
                                                  :
                                                 (Vx.isWeb &&
                                                !ResponsiveLayout.isSmallScreen(context)) ?
                                                MembershipInfo(context):
                                              Navigation(context, name: Routename.Membership, navigatore: NavigatoreTyp.Push);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(vertical: 5,),
                                              width: (MediaQuery.of(context).size.width / 4.5),
                                              height:22,
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  left: BorderSide(width: 3.0, color: ColorCodes.darkgreen),
                                                ),
                                                color: ColorCodes.varcolor,
                                              ),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  SizedBox(width: 2),
                                                  SizedBox(width: 2),
                                                  Image.asset(
                                                    Images.bottomnavMembershipImg,
                                                    color: ColorCodes.primaryColor,
                                                    width: 14,
                                                    height: 8,),
                                                  SizedBox(width: 3),
                                                  Text(
                                                    // S .of(context).membership_price+ " " +//"Membership Price "
                                                      S.of(context).price + " ",
                                                      style: TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 10 : 12,color: ColorCodes.darkgreen,fontWeight: FontWeight.bold)),
                                                  Text(
                                                      Features.iscurrencyformatalign?
                                                      widget.itemdata!.membershipPrice.toString() + IConstants.currencyFormat:
                                                      IConstants.currencyFormat +
                                                          widget.itemdata!.membershipPrice.toString(),
                                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 11 : 12,color: ColorCodes.greenColor)),

                                                ],
                                              ),
                                            ),
                                          )
                                              : SizedBox(height:22,)
                                              : SizedBox.shrink(),
                                        ],
                                      ):SizedBox(height: 10,),
                                    ],
                                  );
                                }, mutations: {ProductMutation,SetCartItem},
                              ) : SizedBox(height:25),

                            ],
                          )),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height:40,
                      width: (Features.isShoppingList) ?  (MediaQuery.of(context).size.width/2)+11 : (MediaQuery.of(context).size.width/1.6) ,
                      child: Padding(
                        padding: const EdgeInsets.only(left:0,right:0.0),
                        child: CustomeStepper(itemdata: widget.itemdata,from:"selling_item",height: (Features.isSubscription)?40:40,issubscription: "Add",addon:(widget.itemdata!.addon!.length > 0)?widget.itemdata!.addon![itemindex]:null, index: itemindex),
                      ),
                    ),
                    if(Features.isShoppingList)
                    SizedBox(width: 4,),
                    if(Features.isShoppingList)
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if(!PrefUtils.prefs!.containsKey("apikey")) {
                        Navigation(context, name: Routename.SignUpScreen,
                        navigatore: NavigatoreTyp.Push);
                        }
                        else {
                          //final shoplistData = Provider.of<BrandItemsList>(context, listen: false);

                          if (shoplistData.length <= 0) {
                            _dialogforCreatelistTwo(context, shoplistData);
                          } else {
                            _dialogforShoppinglistTwo(context);
                          }
                        }
                      },
                      child: Container(
                        height: 35,
                        padding: EdgeInsets.all(5),
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: ColorCodes.varcolor,
                          border: Border(
                            right: BorderSide(width: 1.0, color: ColorCodes.varcolor,),
                            left: BorderSide(width: 1.0, color: ColorCodes.varcolor,),
                            bottom: BorderSide(width: 1.0, color: ColorCodes.varcolor),
                            top: BorderSide(width: 1.0, color: ColorCodes.varcolor),
                          ),),
                        child: Image.asset(
                            Images.addToListImg,width: 20,height: 20,color: ColorCodes.primaryColor),
                      ),
                    )

                  ],
                ),
                (Features.netWeight && widget.itemdata!.vegType == "fish")?
                  Container(
                    width: (MediaQuery
                        .of(context)
                        .size
                        .width / 2) + 70,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              Features.iscurrencyformatalign?
                              /*"Whole Uncut:"*/S.of(context).whole_uncut +" " +
                                  widget.itemdata!.salePrice! + IConstants.currencyFormat +" / "+ /*"500 G"*/S.of(context).gram:
                              /*"Whole Uncut:"*/S.of(context).whole_uncut +" "+ IConstants.currencyFormat +
                                  widget.itemdata!.salePrice! +" / "+ /*"500 G"*/S.of(context).gram,
                              style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 16, fontWeight: FontWeight.bold),),
                          ],
                        ),
                        SizedBox(height: 3),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Text(/*"Gross Weight:"*/S.of(context).gross_weight +" "+
                                      widget.itemdata!.weight!,
                                      style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 16, fontWeight: FontWeight.bold)
                                  ),
                                ),
                                Container(
                                  child: Text(/*"Net Weight:"*/S.of(context).net_weight +" "+
                                      widget.itemdata!.netWeight!,
                                      style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 16, fontWeight: FontWeight.bold)
                                  ),
                                ),

                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ): SizedBox.shrink(),
              ],
            ),
          ],
        ),
      ):
      Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 2.0, color: ColorCodes.lightGreyWebColor),
          ),
        ),
        margin: EdgeInsets.only(left: 5.0, bottom: 0.0, right: 5),
        child: Row(
          children: [
            Container(
              width: (MediaQuery.of(context).size.width / 2) - 75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ItemBadge(
                    outOfStock: widget.itemdata!.priceVariation![itemindex].stock!<=0?OutOfStock(singleproduct: false,):null,
                    child: Align(
                      alignment: Alignment.center,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            if(widget.fromScreen == "sellingitem_screen") {
                              if (widget.itemdata!.priceVariation![itemindex].stock !>= 0)
                                Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid": widget.itemdata!.priceVariation![itemindex].menuItemId.toString(),"productId": widget.itemdata!.priceVariation![itemindex].menuItemId.toString()});
                            }
                            else{
                              if (widget.itemdata!.priceVariation![itemindex].stock !>= 0)
                                Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid": widget.itemdata!.priceVariation![itemindex].menuItemId.toString(),"productId": widget.itemdata!.priceVariation![itemindex].menuItemId.toString()});
                              else
                                Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid": widget.itemdata!.priceVariation![itemindex].menuItemId.toString(),"productId": widget.itemdata!.priceVariation![itemindex].menuItemId.toString()});
                            }
                          },
                          child:  Stack(
                              children: [

                                Container(
                                  margin: EdgeInsets.only(top: 15.0, bottom: 8.0),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.itemdata!.priceVariation![itemindex].images!.length<=0?widget.itemdata!.itemFeaturedImage:widget.itemdata!.priceVariation![itemindex].images![0].image,
                                    errorWidget: (context, url, error) => Image.asset(
                                      Images.defaultProductImg,
                                      width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                      height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                    ),
                                    placeholder: (context, url) => Image.asset(
                                      Images.defaultProductImg,
                                      width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                      height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                    ),
                                    width: ResponsiveLayout.isSmallScreen(context) ? 115 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                    height: ResponsiveLayout.isSmallScreen(context) ? 120 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                    //  fit: BoxFit.fill,
                                  ),
                                ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      children: [
                                        if(margins > 0)
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                3.0),
                                            color: ColorCodes.primaryColor,//Color(0xff6CBB3C),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 8, right: 8, top:4, bottom: 4),
                                            child: Text(
                                              margins.toStringAsFixed(0) + S .of(context).off ,//"% OFF",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 9,
                                                  color: ColorCodes.whiteColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        if(margins > 0)
                                Spacer(),

                                (widget.itemdata!.eligibleForExpress == "0")?
                                Container(

                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        3.0),
                                  border: Border.all(
                                      color: ColorCodes.varcolor),
                                ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 2, right: 2, top:4, bottom: 4),
                                    child: Row(
                                      children: [
                                        Text(
                                          S .of(context).express ,//"% OFF",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 9,
                                              color: ColorCodes.primaryColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: 2),
                                        Image.asset(Images.express,
                                          color: ColorCodes.primaryColor,
                                          height: 11.0,
                                          width: 11.0,),

                                      ],
                                    ),
                                  ),
                                ) : SizedBox.shrink(),
                                            ],
                                    ),
                                  ),
                              ],
                            ),

                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 5,),
            Column(
              mainAxisAlignment: Features.btobModule?MainAxisAlignment.start:MainAxisAlignment.center,
              children: [
                Container(
                  width: (MediaQuery.of(context).size.width / 2) + 55,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          width: Features.btobModule?(MediaQuery
                              .of(context)
                              .size
                              .width / 1.5):(MediaQuery
                              .of(context)
                              .size
                              .width / 2.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Features.btobModule?
                              Container(
                                height:20,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      widget.itemdata!.brand!,
                                      style: TextStyle(
                                          fontSize: 9, color: Colors.black),
                                    ),
                                    Features.btobModule?
                                    (widget.itemdata!.eligibleForExpress == "0")?
                                    Container(
                                      height: 20,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Image .asset(Images.express,
                                            height: 20.0,
                                            width: 25.0,),
                                        ],
                                      ),
                                    ):SizedBox.shrink():SizedBox.shrink(),
                                    if(Features.btobModule)
                                      SizedBox(width:MediaQuery.of(context).size.width*0.15),
                                    if(Features.btobModule)
                                      if(Features.isLoyalty)
                                        (double.parse(widget.itemdata!.priceVariation![itemindex].loyalty.toString()) > 0)?
                                        Container(
                                          height:15,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Image.asset(Images.coinImg,
                                                height: 15.0,
                                                width: 20.0,),
                                              SizedBox(width: 4),
                                              Text(widget.itemdata!.priceVariation![itemindex].loyalty.toString()),
                                            ],
                                          ),
                                        ):SizedBox.shrink(),
                                  ],
                                ),
                              ):
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        widget.itemdata!.brand!,
                                        style: TextStyle(
                                            fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              Container(
                                height:38,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        Features.btobModule?widget.itemdata!.itemName! + "-" + widget.itemdata!.priceVariation![0].variationName!:widget.itemdata!.itemName!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                          //fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              ( widget.itemdata!.priceVariation!.length > 1)?
                              Features.btobModule?
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: (MediaQuery
                                        .of(context)
                                        .size
                                        .width / 2)+20,
                                    child:
                                    GridView.builder(
                                        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: widgetsInRow,
                                          crossAxisSpacing: 0,
                                          childAspectRatio: aspectRatio,
                                          mainAxisSpacing: 0,
                                        ),
                                        controller: new ScrollController(keepScrollOffset: false),
                                        shrinkWrap: true,
                                        itemCount: widget.itemdata!.priceVariation!.length,
                                        itemBuilder: (_, i) {
                                          return GestureDetector(
                                              behavior: HitTestBehavior.translucent,
                                              onTap: () async {
                                                setState(() {
                                                  _groupValue = i;
                                                });
                                                if(productBox
                                                    .where((element) =>
                                                element.itemId! == widget.itemdata!.id
                                                ).length >= 1) {
                                                  cartcontroller.update((done) {
                                                  }, price: widget.itemdata!.price.toString(),
                                                      quantity: widget.itemdata!.priceVariation![i].minItem.toString(),
                                                      type: widget.itemdata!.type,
                                                      weight: (
                                                          double.parse(widget.itemdata!.increament!)).toString(),
                                                      var_id: widget.itemdata!.priceVariation![0].id.toString(),
                                                      increament: widget.itemdata!.increament,
                                                      cart_id: productBox
                                                          .where((element) =>
                                                      element.itemId! == widget.itemdata!.id
                                                      ).first.parent_id.toString(),
                                                      toppings: "",
                                                      topping_id: "",
                                                      item_id: widget.itemdata!.id!

                                                  );
                                                }
                                                else {
                                                  cartcontroller.addtoCart(itemdata: widget.itemdata,
                                                      onload: (isloading) {
                                                      },
                                                      topping_type: "",
                                                      varid: widget.itemdata!.priceVariation![0].id,
                                                      toppings: "",
                                                      parent_id: "",
                                                      newproduct: "0",
                                                      toppingsList: [],
                                                      itembody: widget.itemdata!.priceVariation![i],
                                                      context: context);
                                                }
                                              },
                                              child: Container(
                                                  height: 60,
                                                  width:90,
                                                  decoration: BoxDecoration(
                                                    color: _groupValue == i ? ColorCodes.mediumgren : ColorCodes.whiteColor,
                                                    borderRadius: BorderRadius.circular(5.0),
                                                    border: Border.all(
                                                      color: ColorCodes.greenColor,
                                                    ),
                                                  ),
                                                  margin: EdgeInsets.only(right: 10,bottom:2),
                                                  padding: EdgeInsets.only(right: 5,left:5),
                                                  child:

                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            "${widget.itemdata!.priceVariation![i].minItem}"+"-"+"${widget.itemdata!.priceVariation![i].maxItem}"+" "+"${widget.itemdata!.priceVariation![i].unit}",
                                                            style:
                                                            TextStyle(color: _groupValue == i ? ColorCodes.darkgreen :ColorCodes.blackColor,fontWeight: FontWeight.bold,fontSize: 10),),

                                                          _groupValue == i ?
                                                          Container(
                                                            width: 18.0,
                                                            height: 18.0,
                                                            //margin: EdgeInsets.only(top:3),
                                                            decoration: BoxDecoration(
                                                              color: ColorCodes.greenColor,
                                                              border: Border.all(
                                                                color: ColorCodes.greenColor,
                                                              ),
                                                              shape: BoxShape.circle,
                                                            ),
                                                            child: Container(
                                                              margin: EdgeInsets.all(3),
                                                              decoration: BoxDecoration(
                                                                color: ColorCodes.greenColor,
                                                                shape: BoxShape.circle,
                                                              ),
                                                              child: Icon(Icons.check,
                                                                  color: ColorCodes.whiteColor,
                                                                  size: 12.0),
                                                            ),
                                                          )
                                                              :
                                                          Icon(
                                                              Icons.radio_button_off_outlined,
                                                              color: ColorCodes.greenColor),
                                                        ],
                                                      ),

                                                      if(Features.isMembership)
                                                        _checkmembership?Container(
                                                          width: 10.0,
                                                          height: 9.0,
                                                          margin: EdgeInsets.only(right: 3.0),
                                                          child: Image.asset(
                                                            Images.starImg,
                                                            color: ColorCodes.starColor,
                                                          ),
                                                        ):SizedBox.shrink(),
                                                      new RichText(
                                                        text: new TextSpan(
                                                          style: new TextStyle(
                                                            fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 12 : 12,
                                                            color: _groupValue == i ? ColorCodes.darkgreen :ColorCodes.blackColor,
                                                          ),
                                                          children: <TextSpan>[
//                            if(varmemberprice.toString() == varmrp.toString())
                                                            new TextSpan(
                                                                text: Features.iscurrencyformatalign?
                                                                '${_checkmembership?widget.itemdata!.priceVariation![i].membershipPrice:widget.itemdata!.priceVariation![i].price} ' + IConstants.currencyFormat:
                                                                IConstants.currencyFormat + '${_checkmembership?widget.itemdata!.priceVariation![i].membershipPrice:widget.itemdata!.priceVariation![i].price} ',
                                                                style: new TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  color: _groupValue == i ? ColorCodes.darkgreen :ColorCodes.blackColor,
                                                                  fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 12 : 12,)),
                                                            new TextSpan(
                                                                text: widget.itemdata!.priceVariation![i].price!=widget.itemdata!.priceVariation![i].mrp?
                                                                Features.iscurrencyformatalign?
                                                                '${widget.itemdata!.priceVariation![i].mrp} ' + IConstants.currencyFormat:
                                                                IConstants.currencyFormat + '${widget.itemdata!.priceVariation![i].mrp} ':"",
                                                                style: TextStyle(
                                                                  decoration:
                                                                  TextDecoration.lineThrough,
                                                                  fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,)),
                                                          ],
                                                        ),
                                                      ),


                                                    ],)


                                              )
                                          );
                                        }),
                                  ),
                                  // )
                                ],
                              ):
                              Container(
                                width: (MediaQuery
                                    .of(context)
                                    .size
                                    .width / 3),
                                child:   Row(
                                  children: [
                                    Container(
                                      width: (MediaQuery
                                          .of(context)
                                          .size
                                          .width /3),
                                      child: (widget.itemdata!.priceVariation!.length > 1)
                                          ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            showoptions1();
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 20,
                                              child: Text(
                                                "${widget.itemdata!.priceVariation![itemindex].variationName}"+" "+"${widget.itemdata!.priceVariation![itemindex].unit}",
                                                style:
                                                TextStyle(color: ColorCodes.darkgreen,fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            //SizedBox(width: 10,),
                                            Icon(
                                              Icons.keyboard_arrow_down,
                                              color: ColorCodes.darkgreen,
                                                size: 20,
                                            ),
                                          ],
                                        ),
                                      )
                                          : Row( mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 40,
                                              child: Text(
                                                "${widget.itemdata!.priceVariation![itemindex].variationName}"+" "+"${widget.itemdata!.priceVariation![itemindex].unit}",
                                                style: TextStyle(color: ColorCodes.greyColor,fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ):SizedBox(height:20),
                              SizedBox(
                                height: 4,
                              ),


                              Container(
                                  child: Row(
                                    children: <Widget>[
                                      if(!Features.btobModule)
                                     /* if(Features.isMembership)
                                        _checkmembership?Container(
                                          width: 10.0,
                                          height: 9.0,
                                          margin: EdgeInsets.only(right: 3.0),
                                          child: Image.asset(
                                            Images.starImg,
                                            color: ColorCodes.starColor,
                                          ),
                                        ):SizedBox.shrink(),*/
                                      if(!Features.btobModule)
                                      new RichText(
                                        text: new TextSpan(
                                          style: new TextStyle(
                                            fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 15 : 16,
                                            color: Colors.black,
                                          ),
                                          children: <TextSpan>[
                                            new TextSpan(
                                                text: _price,
                                                  style: new TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: _checkmembership?ColorCodes.primaryColor:Colors.black,
                                                  fontSize: ResponsiveLayout.isSmallScreen(context) ? 15 : ResponsiveLayout.isMediumScreen(context) ? 15 : 16,)),
                                            new TextSpan(
                                                text: _mrp,
                                                style: TextStyle(
                                                  decoration:
                                                  TextDecoration.lineThrough,
                                                  fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,)),
                                          ],
                                        ),
                                      ),
                                      if(Features.btobModule)
                                        SizedBox(width:MediaQuery.of(context).size.width*0.15),
                                      if(Features.btobModule)
                                      VxBuilder(
                                        builder: (context, box, index) {
                                          if(store.userData.membership! == "1"){
                                            _checkmembership = true;
                                          } else {
                                            _checkmembership = false;
                                            for (int i = 0; i < productBox.length; i++) {
                                              if (productBox[i].mode == "1") {
                                                _checkmembership = true;
                                              }
                                            }
                                          }
                                          return Column(
                                            children: [
                                              if(Features.isMembership && double.parse(widget.itemdata!.priceVariation![Features.btobModule?_groupValue:itemindex].membershipPrice.toString()) > 0)
                                                Row(
                                                  children: [
                                                    !_checkmembership
                                                        ? widget.itemdata!.priceVariation![Features.btobModule?_groupValue:itemindex].membershipDisplay!
                                                        ? GestureDetector(
                                                      onTap: () {
                                                        (checkskip &&Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
                                                        // _dialogforSignIn() :
                                                        LoginWeb(context,result: (sucsess){
                                                          if(sucsess){
                                                            Navigator.of(context).pop();
                                                            Navigation(context, navigatore: NavigatoreTyp.homenav);
                                                          }else{
                                                            Navigator.of(context).pop();
                                                          }
                                                        })
                                                            :
                                                        (checkskip && !Vx.isWeb)?
                                                        Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.PushReplacment)
                                                            :
                                                         (Vx.isWeb &&
                                                        !ResponsiveLayout.isSmallScreen(context)) ?
                                                        MembershipInfo(context):
                                                        Navigation(context, name: Routename.Membership, navigatore: NavigatoreTyp.Push);
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.symmetric(vertical: 5,),
                                                        width: (MediaQuery
                                                            .of(context)
                                                            .size
                                                            .width / 3) +
                                                            5,
                                                        height:30,
                                                        decoration: BoxDecoration(
                                                          border: Border(
                                                            left: BorderSide(width: 5.0, color: ColorCodes.darkgreen),
                                                          ),
                                                          color: ColorCodes.varcolor,
                                                        ),
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: <Widget>[
                                                            SizedBox(width: 2),
                                                            Text(
                                                                Features.iscurrencyformatalign?
                                                                widget.itemdata!.priceVariation![Features.btobModule?_groupValue:itemindex].membershipPrice.toString() + IConstants.currencyFormat:
                                                                IConstants.currencyFormat +
                                                                    widget.itemdata!.priceVariation![Features.btobModule?_groupValue:itemindex].membershipPrice.toString() + /*" Membership Price"*/ " "+S.of(context).membership_price,
                                                                style: TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 10 : 12,color: ColorCodes.greenColor,fontWeight: FontWeight.bold)),

                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                        : SizedBox.shrink()
                                                        : SizedBox.shrink(),
                                                  ],
                                                ),

                                            ],
                                          );
                                        }, mutations: {ProductMutation,SetCartItem},
                                      ),
                                    ],
                                  )),

                              SizedBox(
                                height: 4,
                              ),
                                  //:SizedBox.shrink(),
                              Features.btobModule?
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Text(S.of(context).total,style: TextStyle(color: ColorCodes.blackColor)),
                                      productBox
                                          .where((element) =>
                                      element.itemId == widget.itemdata!.id).length > 0?
                                      Text( IConstants.currencyFormat + (double.parse(widget.itemdata!.priceVariation![_groupValue].price!) * _count).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                        style: TextStyle(
                                            color: ColorCodes.greenColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15
                                        ),): Text( IConstants.currencyFormat + (double.parse(widget.itemdata!.priceVariation![itemindex].price!)).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                        style: TextStyle(
                                            color: ColorCodes.greenColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15
                                        ),),


                                    ],
                                  ),
                                  SizedBox(width:10),
                                  Container(
                                    height:40,
                                    width: (MediaQuery.of(context).size.width/3)+5 ,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left:0,right:0.0),
                                      child: CustomeStepper(priceVariation:widget.itemdata!.priceVariation![itemindex],itemdata: widget.itemdata,from:"selling_item",height: (Features.isSubscription)?40:40,issubscription: "Add",addon:(widget.itemdata!.addon!.length > 0)?widget.itemdata!.addon![0]:null, index: itemindex,groupvalue: _groupValue,onChange: (int value,int count){
                                        setState(() {
                                          _groupValue = value;
                                          _count = count;
                                        });
                                      }),
                                    ),
                                  ),
                                ],
                              ):SizedBox.shrink(),
                            ],
                          )),
                      !Features.btobModule?
                      Spacer():SizedBox.shrink(),
                      !Features.btobModule?
                      Container(
                          width: (MediaQuery
                              .of(context)
                              .size
                              .width / 4.7),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if(Features.isLoyalty)
                                (double.parse(widget.itemdata!.priceVariation![itemindex].loyalty.toString()) > 0)?
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Image.asset(Images.coinImg,
                                        height: 12.0,
                                        width: 15.0,),
                                      SizedBox(width: 2),
                                      Text(widget.itemdata!.priceVariation![itemindex].loyalty.toString(),
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                    ],
                                  ),
                                ):SizedBox(height: 10,),
                              SizedBox(height: 4),
                              Features.isSubscription && widget.itemdata!.eligibleForSubscription=="0"?
                              Container(
                                height:40,
                                child: CustomeStepper(priceVariation:widget.itemdata!.priceVariation![itemindex],itemdata: widget.itemdata,from:"selling_item",height: (Features.isSubscription)?40:40,issubscription: "Subscribe",addon:(widget.itemdata!.addon!.length > 0)?widget.itemdata!.addon![0]:null, index: itemindex),
                              ):SizedBox(height: 40,),



                               SizedBox(height: 10,),
                              (widget.itemdata!.singleshortNote != "" || widget.itemdata!.singleshortNote != "0")?
                              Container(
                                height: 15,
                                width:85,
                                child: Text(widget.itemdata!.singleshortNote.toString(),
                                  overflow: TextOverflow.ellipsis,
                               maxLines: 1,
                                  style: TextStyle(fontSize: 10,color: ColorCodes.greyColor,),),
                              ):SizedBox.shrink(),
                              if(widget.itemdata!.singleshortNote != "" || widget.itemdata!.singleshortNote != "0")SizedBox(height: 4,),
                              (!Features.btobModule)?
                              _checkmembership ? widget.itemdata!.priceVariation![Features.btobModule?_groupValue:itemindex].membershipDisplay! ?
                              Container(
                                height: 20,
                                width:MediaQuery.of(context).size.width/4.5 ,
                                decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(width: 3.0, color: ColorCodes.darkgreen),
                                  ),
                                  color: ColorCodes.varcolor,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(width: 3,),
                                    Image.asset(
                                      Images.bottomnavMembershipImg,
                                      color: ColorCodes.primaryColor,
                                      width: 15,
                                      height: 10,),
                                    SizedBox(width: 3),
                                    Text(/*"Savings "*/S.of(context).savings ,style: TextStyle(fontSize: 10, color: ColorCodes.darkgreen,fontWeight: FontWeight.bold)),
                                    Padding(
                                      padding: const EdgeInsets.only(top:5.0,bottom:5),
                                      child: Text(
                                          Features.iscurrencyformatalign?
                                          (double.parse(widget.itemdata!.priceVariation![Features.btobModule?_groupValue:itemindex].mrp!) - double.parse(widget.itemdata!.priceVariation![Features.btobModule?_groupValue:itemindex].membershipPrice!)).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + IConstants.currencyFormat:
                                          IConstants.currencyFormat +
                                              (double.parse(widget.itemdata!.priceVariation![Features.btobModule?_groupValue:itemindex].mrp!) - double.parse(widget.itemdata!.priceVariation![Features.btobModule?_groupValue:itemindex].membershipPrice!)).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                          style: TextStyle(fontSize: 10, color: ColorCodes.darkgreen,fontWeight: FontWeight.bold)),
                                    ),


                                    SizedBox(width: 5),
                                  ],
                                ),
                              ):SizedBox(height: 20,):
                              VxBuilder(
                                // valueListenable: Hive.box<Product>(productBoxName).listenable(),
                                builder: (context, box, index) {
                                  if(store.userData.membership! == "1"){
                                    _checkmembership = true;
                                  } else {
                                    _checkmembership = false;
                                    for (int i = 0; i < productBox.length; i++) {
                                      if (productBox[i].mode == "1") {
                                        _checkmembership = true;
                                      }
                                    }
                                  }
                                  return Column(
                                    children: [
                                      if(Features.isMembership && double.parse(widget.itemdata!.priceVariation![Features.btobModule?_groupValue:itemindex].membershipPrice.toString()) > 0)
                                        Row(
                                          children: [
                                            !_checkmembership
                                                ? widget.itemdata!.priceVariation![Features.btobModule?_groupValue:itemindex].membershipDisplay!
                                                ? GestureDetector(
                                              onTap: () {
                                                (checkskip &&Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
                                                LoginWeb(context,result: (sucsess){
                                                  if(sucsess){
                                                    Navigator.of(context).pop();
                                                    Navigation(context, navigatore: NavigatoreTyp.homenav);
                                                  }else{
                                                    Navigator.of(context).pop();
                                                  }
                                                })
                                                    :
                                                (checkskip && !Vx.isWeb)?
                                                Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.PushReplacment)
                                                    :
                                                 (Vx.isWeb &&
                                                !ResponsiveLayout.isSmallScreen(context)) ?
                                                MembershipInfo(context):
                                                 Navigation(context, name: Routename.Membership, navigatore: NavigatoreTyp.Push);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(vertical: 5,),
                                                width: (MediaQuery.of(context).size.width / 4.7),
                                                height:22,
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    left: BorderSide(width: 3.0, color: ColorCodes.darkgreen),
                                                  ),
                                                  color: ColorCodes.varcolor,
                                                ),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    SizedBox(width: 2),
                                                    Image.asset(
                                                      Images.bottomnavMembershipImg,
                                                      color: ColorCodes.primaryColor,
                                                      width: 14,
                                                      height: 8,),
                                                    SizedBox(width: 3),
                                                    Text(
                                                      // S .of(context).membership_price+ " " +//"Membership Price "
                                                        S.of(context).price + " ",
                                                        style: TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 10 : 12,color: ColorCodes.darkgreen,fontWeight: FontWeight.bold)),
                                                    Text(
                                                        Features.iscurrencyformatalign?
                                                        widget.itemdata!.priceVariation![Features.btobModule?_groupValue:itemindex].membershipPrice.toString() + IConstants.currencyFormat:
                                                        IConstants.currencyFormat +
                                                            widget.itemdata!.priceVariation![Features.btobModule?_groupValue:itemindex].membershipPrice.toString(),
                                                        style: TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 10 : 12,color: ColorCodes.greenColor,fontWeight: FontWeight.bold)),

                                                  ],
                                                ),
                                              ),
                                            )
                                                : SizedBox.shrink()
                                                : SizedBox.shrink(),
                                          ],
                                        ),
                                    ],
                                  );
                                }, mutations: {ProductMutation,SetCartItem},
                              ): SizedBox(height:25),
                              SizedBox(
                                height: 4,
                              ),
                            ],
                          )):SizedBox.shrink(),
                    ],
                  ),
                ),
                SizedBox(height: 3),
                !Features.btobModule?
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height:40,
                      width:  (Features.isShoppingList) ?  (MediaQuery.of(context).size.width/2)+11 : (MediaQuery.of(context).size.width/1.6) ,
                      child: Padding(
                        padding: const EdgeInsets.only(left:0,right:0.0),
                        child: CustomeStepper(priceVariation:widget.itemdata!.priceVariation![itemindex],itemdata: widget.itemdata,from:"selling_item",height: (Features.isSubscription)?40:40,issubscription: "Add",addon:(widget.itemdata!.addon!.length > 0)?widget.itemdata!.addon![0]:null, index: itemindex),
                      ),
                    ),
                    if(Features.isShoppingList)
                    SizedBox(width: 5,),
                    if(Features.isShoppingList)
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if(!PrefUtils.prefs!.containsKey("apikey")) {
                      Navigation(context, name: Routename.SignUpScreen,
                      navigatore: NavigatoreTyp.Push);
                      }
                        else {
                          //final shoplistData = Provider.of<BrandItemsList>(context, listen: false);

                          if (shoplistData.length <= 0) {
                            _dialogforCreatelistTwo(context, shoplistData);
                          } else {
                            _dialogforShoppinglistTwo(context);
                          }
                        }
                      },
                      child: Container(
                        height: 35,
                        padding: EdgeInsets.all(5),
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: ColorCodes.varcolor,
                          border: Border(
                            right: BorderSide(width: 1.0, color: ColorCodes.varcolor,),
                            left: BorderSide(width: 1.0, color: ColorCodes.varcolor,),
                            bottom: BorderSide(width: 1.0, color: ColorCodes.varcolor),
                            top: BorderSide(width: 1.0, color: ColorCodes.varcolor),
                          ),),
                        child: Image.asset(
                            Images.addToListImg,width: 20,height: 20,color: ColorCodes.primaryColor),
                      ),
                    )
                  ],
                ):SizedBox.shrink(),
                if(Features.netWeight && widget.itemdata!.vegType == "fish")
                  Container(
                    width: (MediaQuery
                        .of(context)
                        .size
                        .width / 2) + 70,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              Features.iscurrencyformatalign?
                              /*"Whole Uncut:"*/S.of(context).whole_uncut +" " +
                                  widget.itemdata!.salePrice! + IConstants.currencyFormat +" / "+ /*"500 G"*/S.of(context).gram:
                              /*"Whole Uncut:"*/S.of(context).whole_uncut +" "+ IConstants.currencyFormat +
                                widget.itemdata!.salePrice! +" / "+ /*"500 G"*/S.of(context).gram,
                              style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 16, fontWeight: FontWeight.bold),),
                          ],
                        ),
                        SizedBox(height: 3),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Text(/*"Gross Weight:"*/S.of(context).gross_weight +" "+
                                      widget.itemdata!.priceVariation![itemindex].weight!,
                                      style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 16, fontWeight: FontWeight.bold)
                                  ),
                                ),
                                Container(
                                  child: Text(/*"Net Weight:"*/S.of(context).net_weight +" "+
                                      widget.itemdata!.priceVariation![itemindex].netWeight!,
                                      style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 16, fontWeight: FontWeight.bold)
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      );
    }
  }
}
