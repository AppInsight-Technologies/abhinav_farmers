import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
//web
import 'package:flutter_facebook_login_web/flutter_facebook_login_web.dart';
//app
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../controller/mutations/cart_mutation.dart';
import '../../models/VxModels/VxStore.dart';
import '../../constants/IConstants.dart';
import '../../constants/features.dart';
import '../../generated/l10n.dart';
import 'package:sign_in_apple/apple_id_user.dart';
import 'package:sign_in_apple/sign_in_apple.dart';
import '../../controller/mutations/login.dart';
import '../../models/newmodle/user.dart';
import '../../repository/api.dart';
import '../../utils/prefUtils.dart';
import "package:http/http.dart" as http;
import 'package:sms_autofill/sms_autofill.dart';
import 'package:dio/dio.dart';
import 'package:velocity_x/velocity_x.dart';
GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email', /*'https://www.googleapis.com/auth/contacts.readonly',*/
  ],
);
class Auth {
  var _authresponse;

  Future<AuthData> facebookLogin(returns) async {
    //web
    final facebookSignIn = FacebookLoginWeb();
    final result = await facebookSignIn.logIn(['email']);
//app
//      final _facebookLogin = FacebookLogin();
//
//     _facebookLogin.loginBehavior =
//     Platform.isIOS ? FacebookLoginBehavior.webViewOnly : FacebookLoginBehavior
//         .nativeWithFallback;
    //   final result = await _facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
      //APP
      //     final response = await http.get(
      //         'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,picture,email&access_token=${result
      //             .accessToken.token}');
      //
      //     Map<String, dynamic> map = json.decode(response.body);
      //
      //     _isnewUser(map["email"]).then((value) {
      //       _authresponse = returns(AuthData(code: response.statusCode,
      //           messege: "Login Success",
      //           status: true,
      //           data: SocialAuthUser.fromJson(SocialAuthUser.fromJson(map).toJson(newuser: value.type=="old"?false:true,id: value.apikey))));
      //     });

      // web

        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,picture,email&access_token=${token}');
        Map<String, dynamic> map = json.decode(graphResponse.body);
        _isnewUser(map["email"]).then((value) {
          _authresponse = returns(AuthData(code: graphResponse.statusCode,
              messege: "Login Success",
              status: true,
              data: SocialAuthUser.fromJson(SocialAuthUser.fromJson(map).toJson(newuser: value.type=="old"?false:true,id: value.apikey))));
        });
        // TODO: Handle this case.
        break;
      case FacebookLoginStatus.cancelledByUser:
        _authresponse = returns(AuthData(
            code: 200, messege: "Login Canceled by User", status: false));
        // TODO: Handle this case.
        break;
      case FacebookLoginStatus.error:
        _authresponse = returns(
            AuthData(code: 200, messege: result.errorMessage, status: false));
        // TODO: Handle this case.
        break;
    }
    return Future.value(_authresponse);
  }

  Future<AuthData> googleLogin(returns) async {
    final response = await _googleSignIn.signIn();
    response!.authentication.then((value) {
      _isnewUser(response.email).then((value) =>
          returns(AuthData(code: 200,
              messege: "Login Success",
              status: true,
              data: SocialAuthUser(email: response.email,
                  firstName: response.displayName,
                  id: value.apikey,
                  lastName: "",
                  name: response.displayName,
                  picture: Picture(data: Data(url: response.photoUrl)),
                  newuser: value.type=="old"?false:true))));

    }).onError((error, stackTrace) {
      _authresponse = AuthData(code: 200, messege: error.toString(), status: false);
      returns(_authresponse);
    });
    return Future.value(_authresponse);
  }

  Future<AuthData?> phoneNumberAuth(mobile, Function(LoginData, AuthData) otp) async {
    Api api = Api();
    api.body = {
      "mobileNumber": mobile,
      "signature": Vx.isWeb ? "" : await SmsAutoFill().getAppSignature,
      "tokenId": PrefUtils.prefs!.getString('ftokenid').toString(),
      "branch": IConstants.isEnterprise && Features.ismultivendor?IConstants.refIdForMultiVendor:PrefUtils.prefs!.getString("branch")!,
      "language_code" : IConstants.languageId,
    };
    final response = json.decode(
        await api.Posturl("customer/pre-register"));
    print("sdfgbnm...."+response["type"].toString()+"oypppp.."+response["data"]["otp"].toString());
    PrefUtils.prefs!.setString("typenew",  response["type"].toString());
    if (response["type"] == "new") {
      PrefUtils.prefs!.remove("userapikey");
      PrefUtils.prefs!.setString("Otp", response["data"]["otp"].toString());
      _authresponse = AuthData(code: 200,
          messege: "Login Success",
          status: true,
          data: SocialAuthUser(newuser: true));
      otp(LoginData.fromJson(response["data"]), _authresponse);
    } else {
      if(Vx.isWeb){
        PrefUtils.prefs!.setString("apikey", response["userID"].toString());
        PrefUtils.prefs!.setString("userapikey", response["userID"].toString());
        getuserProfile(onsucsess: (value) {
          _authresponse = AuthData(code: 200,
              messege: "Login Success",
              status: true,
              data: SocialAuthUser(newuser: false, id: value.id));
          otp(LoginData.fromJson(response["data"]), _authresponse);
        }, onerror: (){

        });
      }
      else {
        PrefUtils.prefs!.setString("userapikey", response["userID"].toString());
        PrefUtils.prefs!.setString("Otp", response["data"]["otp"].toString());
        PrefUtils.prefs!.setBool('type', false);
      }

    }
  }


  ioslogin(Function(AuthData) returns,Function(String) errors)async {
    PrefUtils.prefs!.setString('applesignin', "yes");
    PrefUtils.prefs!.setString('skip', "no");
    if (await SignInApple.canUseAppleSigin()) {
      SignInApple.handleAppleSignInCallBack(onCompleteWithSignIn: (AppleIdUser? appleidentifier) async {

        _isnewUserApple(appleidentifier!.userIdentifier).then((value) => returns(AuthData(code: 200,
            messege: "Login Success",
            status: true,
            data: SocialAuthUser(email:appleidentifier.mail!,
                firstName: appleidentifier.familyName!,
                id: value.apikey,
                lastName: "",
                name: appleidentifier.name!,
                picture: Picture(data: Data(url:"")),
                newuser: value.type=="old"?false:true))));

      }, onCompleteWithError: (AppleSignInErrorCode code) async {
        var errorMsg = "unknown";
        switch (code) {
          case AppleSignInErrorCode.canceled:
            errorMsg = S.current.sign_in_cancelledbyuser;
            break;
          case AppleSignInErrorCode.failed:
            errorMsg =  S.current.sign_in_failed;
            break;
          case AppleSignInErrorCode.invalidResponse:
            errorMsg =S.current.apple_signin_not_available_forthis_device;
            break;
          case AppleSignInErrorCode.notHandled:
            errorMsg = S.current.apple_signin_not_available_forthis_device;
            break;
          case AppleSignInErrorCode.unknown:
            errorMsg = S.current.apple_signin_not_available_forthis_device;
            break;
        }
        errors(errorMsg);
      });
      SignInApple.clickAppleSignIn();
    } else {
      errors(S.current.apple_signin_not_available_forthis_device);
    }
  }


  userRegister(RegisterAuthBodyParm body, { required Function onSucsess, onError}) async {
    if(Features.btobModule){
      var map = FormData.fromMap({
        "username": body.username,
        "email": body.email,
        "mobileNumber": body.mobileNumber,
        "path": body.path,
        "tokenId": body.tokenId,
        "branch": body.branch,
        "signature" : PrefUtils.prefs!.containsKey("signature") ? PrefUtils.prefs!.getString('signature') : "",
        "referralid": body.referralid,
        "type":PrefUtils.prefs!.getBool('type'),
        "shop_name":body.shopname,
        "gst": body.gst,
        "pincode": body.pincode,
        if(body.image!.length >0)'image': body.image,
        "device": body.device,
      });
      Dio dio;
      BaseOptions options = BaseOptions(
        baseUrl: IConstants.API_PATH,
        connectTimeout: 30000,
        receiveTimeout: 30000,
      );

      dio = Dio(options);
      final response = await dio.post("customer/register-b2b", data: map);
      final responseEncode = json.encode(response.data);
      final responseJson = json.decode(responseEncode);
      if (responseJson["status"]) {
        PrefUtils.prefs!.setString('LoginStatus', "true");
        PrefUtils.prefs!.setString("apikey", responseJson["userId"].toString());
        getuserProfile(onsucsess: (UserData data) => onSucsess(data),
            onerror: (messege) => onError(messege));
      } else {
        onError(responseJson["data"]);
      }
    }
    else {
      debugPrint("new user.....dd...");
      Api api = Api();
      api.body = body.toJson();
      debugPrint("new user.....ff...");
      final regresp = json.decode(await api.Posturl("customer/register"));
      debugPrint("new user.....gg...");
      debugPrint("new user.....ee..."+regresp.toString());
      if (regresp["status"]) {
        PrefUtils.prefs!.setString('LoginStatus', "true");
        PrefUtils.prefs!.setString("apikey", regresp["userId"].toString());
        getuserProfile(onsucsess: (UserData data) => onSucsess(data),
            onerror: (messege) => onError(messege));
      } else {
        onError(regresp["data"]);
      }
    }
  }

  getuserProfile({required Function(UserData) onsucsess,required onerror}) async {
    if(PrefUtils.prefs!.containsKey("type") && PrefUtils.prefs!.getBool('type')! == false && PrefUtils.prefs!.getString('LoginStatus') == "true") {
      if (PrefUtils.prefs!.containsKey("apikey")) {
        Api api = Api();

        final resp = UserModle.fromJson(json.decode(await api.Geturl(
            "customer/get-profile?apiKey=${PrefUtils.prefs!.getString(
                "apikey")}&branchtype=${ IConstants.branchtype.toString()}&branch=${PrefUtils.prefs!.getString("branch")}&ref=${ IConstants.refIdForMultiVendor}"
        )));
        if (resp.status!) {
          final response = UserModle(status: resp.status,
              notificationCount: resp.notificationCount,
              shoppingList: resp.shoppingList,
              prepaid: resp.prepaid,
              data: [
                UserData.fromJson(resp.data!.first.toJson(
                    branch: PrefUtils.prefs!.getString("branch")))
              ]);
          SetUserData(response);
          onsucsess(UserData.fromJson(resp.data![0].toJson(
              branch: PrefUtils.prefs!.getString("branch"))));
        } else {
          api.body = {
            "token": PrefUtils.prefs!.getString("ftokenid")!,
            "device": "android",
            "branchtype": IConstants.branchtype.toString(),
            "ref": IConstants.refIdForMultiVendor ,
          };
          var response = json.decode(await api.Posturl(
              "customer/register/guest/user", isv2: false));
          PrefUtils.prefs!.setString(
              "tokenid", response["guestUserId"]);
          PrefUtils.prefs!.setString(
              "latitude", response["restaurantLat"]);
          PrefUtils.prefs!.setString(
              "longitude", response["restaurantLong"]);
          PrefUtils.prefs!.setBool("deliverystatus", true);
          onerror();
        }
      }
      else {
        Api api = Api();

        api.body = {
          "token": PrefUtils.prefs!.getString("ftokenid")!,
          "device": "android",
          "branchtype": IConstants.branchtype.toString() ,
          "ref":  IConstants.refIdForMultiVendor ,
        };
        var response = json.decode(await api.Posturl(
            "customer/register/guest/user", isv2: false));
        PrefUtils.prefs!.setString(
            "tokenid", response["guestUserId"]);
        PrefUtils.prefs!.setString(
            "latitude", response["restaurantLat"]);
        PrefUtils.prefs!.setString(
            "longitude", response["restaurantLong"]);
        PrefUtils.prefs!.setBool("deliverystatus", true);
        onerror();
      }
    }
    else{
      if (PrefUtils.prefs!.containsKey("apikey")) {
        Api api = Api();

        final resp = UserModle.fromJson(json.decode(await api.Geturl(
          // (Features.ismultivendor && IConstants.isEnterprise) ?
            "customer/get-profile?apiKey=${PrefUtils.prefs!.getString(
                "apikey")}&branchtype=${IConstants.branchtype.toString()}&branch=${PrefUtils.prefs!.getString("branch")}&ref=${IConstants.refIdForMultiVendor}")));
        // : "customer/get-profile?apiKey=${PrefUtils.prefs!.getString(
        // "apikey")}&branch=${PrefUtils.prefs!.getString("branch")}")));
        if (resp.status!) {
          final response = UserModle(status: resp.status,
              notificationCount: resp.notificationCount,
              prepaid: resp.prepaid,
              shoppingList: resp.shoppingList,
              data: [
                UserData.fromJson(resp.data!.first.toJson(
                    branch: PrefUtils.prefs!.getString("branch")))
              ]);
          SetUserData(response);
          onsucsess(UserData.fromJson(resp.data![0].toJson(
              branch: PrefUtils.prefs!.getString("branch"))));
        } else {
          api.body = {
            "token": PrefUtils.prefs!.getString("ftokenid")!,
            "device": "android"
          };
          PrefUtils.prefs!.setString(
              "tokenid", json.decode(await api.Posturl(
              "customer/register/guest/user", isv2: false))["guestUserId"]);
          onerror();
        }
      }
      else {
        Api api = Api();

        api.body = {
          "token": PrefUtils.prefs!.getString("ftokenid")!,
          "device": "android",
          "branchtype": IConstants.branchtype.toString() ,
          "ref": IConstants.refIdForMultiVendor ,
        };
        var response = json.decode(await api.Posturl(
            "customer/register/guest/user", isv2: false));
        PrefUtils.prefs!.setString(
            "tokenid", response["guestUserId"]);
        PrefUtils.prefs!.setString(
            "latitude", response["restaurantLat"]);
        PrefUtils.prefs!.setString(
            "longitude", response["restaurantLong"]);
        PrefUtils.prefs!.setBool("deliverystatus", true);
        onerror();
      }
    }
  }

  Future<String> getuserNotificationCount(apikey) async {
    Api api = Api();
    return Future.value(json.decode(await api.Geturl(
        "customer/get-profile?apiKey=$apikey&branch=${PrefUtils.prefs!.getString("branch")}"))["notification_count"]);
  }

  Future<EmailResponse> _isnewUser(String email) async {
    Api api = Api();
    api.body = {
      "email": email,
      "tokenId": PrefUtils.prefs!.getString('ftokenid')!,
    };
    var _url = await api.Posturl("customer/email-login");
    var value = EmailResponse.fromJson(json.decode(_url));
    if(value.status! && value.type == "old"){
      PrefUtils.prefs!.setString("apikey", value.apikey!);
      GroceStore store = VxState.store;
      store.homescreen.data = null;
      getuserProfile(onsucsess: (UserData ) {
        SetCartItem(CartTask.fetch ,onloade: (value){});
      }, onerror: {
      });
    }
    return value;
  }
  Future<EmailResponse> _isnewUserApple(String appleid) async {
    Api api = Api();
    api.body = {
      "email":appleid,
      "tokenId":PrefUtils.prefs!.getString("ftokenid")!
    };
    return EmailResponse.fromJson(json.decode(
        await api.Posturl("customer/email-login")));
  }
}
class EmailResponse {
  bool? status;
  String? type;
  String? apikey;

  EmailResponse({required this.status, required this.type, required this.apikey});

  EmailResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    type = json['type'];
    apikey = json['apikey'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['type'] = this.type;
    data['apikey'] = this.apikey;
    return data;
  }
}

final auth = Auth();
class AuthData {
  bool? status;
  String? messege;
  int? code;
  SocialAuthUser? data;

  AuthData({required this.status, required this.messege, required this.code, this.data});

  AuthData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    messege = json['messege'];
    code = json['code'];
    data = json['data'] != null ? new SocialAuthUser.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['messege'] = this.messege;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
class RegisterAuthBodyParm {
  String? username;
  String? email;
  String? path;
  String? tokenId;
  String? guestUserId;
  String? branch;
  String? referralid;
  String? device;
  String? mobileNumber;
  String? ref;
  String? branchtype;
  String? shopname;
  String? pincode;
  String? gst;
  String? image;
  String? language_code;

  RegisterAuthBodyParm(
      {required this.username,
        required this.email,
        required this.path,
        required this.guestUserId,
        required this.tokenId,
        required this.branch,
        required this.referralid,
        required this.mobileNumber,
        required this.device,
        required this.ref,
        required this.branchtype,
        this.shopname,
        this.pincode,
        this.gst,
        this.image,
        this.language_code,
      });

  RegisterAuthBodyParm.fromJson(Map<String, String> json) {
    username = json['username'];
    email = json['email'];
    path = json['path'];
    tokenId = json['tokenId'];
    guestUserId = json['guestUserId'];
    branch = json['branch'];
    referralid = json['referralid'];
    device = json['device'];
    mobileNumber = json['mobileNumber'];
    ref = json['ref'];
    branchtype = json['branchtype'];
    shopname = json['shop_name'] ??"";
    pincode = json['pincode']??"";
    gst = json['gst']??"";
    image = json['image']??"";
    language_code = json['language_code']??"";
  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['username'] = this.username!;
    data['email'] = this.email!;
    data['path'] = this.path!;
    data['guestUserId'] = this.guestUserId!;
    data['tokenId'] = this.tokenId!;
    data['branch'] = this.branch!;
    data['referralid'] = this.referralid!;
    data['device'] = this.device!;
    data['mobileNumber'] = this.mobileNumber!;
    data['ref'] = this.ref!;
    data['branchtype'] = this.branchtype!;
    data['shop_name'] = this.shopname.toString();
    data['pincode'] = this.pincode.toString();
    data['gst'] = this.gst.toString();
    data['image'] = this.image.toString();
    data['language_code'] = this.language_code!;
    return data;
  }
}
class LoginData {
  int? otp;
  int? apiKey;

  LoginData({this.otp,this.apiKey});

  LoginData.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
    apiKey = json['apiKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otp'] = this.otp;
    data['apiKey'] = this.apiKey;
    return data;
  }
}