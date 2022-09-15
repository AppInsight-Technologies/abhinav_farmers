import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../assets/images.dart';
import '../controller/mutations/login.dart';
import '../models/VxModels/VxStore.dart';
import '../models/newmodle/user.dart';
import '../repository/authenticate/AuthRepo.dart';
import 'package:velocity_x/velocity_x.dart';
import '../constants/api.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:http/http.dart' as http;
import  'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../generated/l10n.dart';
import '../rought_genrator.dart';
import '../services/firebaseAnaliticsService.dart';
import '../constants/features.dart';
import '../constants/IConstants.dart';
import '../assets/ColorCodes.dart';
import '../utils/prefUtils.dart';
import 'login_screen.dart';


class SignupScreen extends StatefulWidget {
  static const routeName = '/signup-screen';

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> with Navigations{
  final _lnameFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  String fn = "";
  String ln = "";
  String ea = "";
  String referAndEarn = "";

  final TextEditingController businessnamecontroller = new TextEditingController();
  final TextEditingController firstnamecontroller = new TextEditingController();
  final TextEditingController lastnamecontroller = new TextEditingController();
  final TextEditingController _referController = new TextEditingController();
  final TextEditingController _numberController = new TextEditingController();
  final TextEditingController _shopnamecontroller = new TextEditingController();
  final TextEditingController _pincontroller = new TextEditingController();
  bool iphonex = false;
  GroceStore store = VxState.store;
  File? galleryFile;
  List<File> images = <File>[];
  List uploadlist = [];
  @override
  void initState() {
    fas.setScreenName("Register");

    Future.delayed(Duration.zero, () async {
      try {
        if (Platform.isIOS) {
          setState(() {
            iphonex = MediaQuery.of(context).size.height >= 812.0;
          });
        } else {
          setState(() {
          });
        }
      } catch (e) {
        setState(() {
        });
      }

      PrefUtils.prefs!.setString("Email", "");
      if(PrefUtils.prefs!.getString("referCodeDynamic") == "" || PrefUtils.prefs!.getString("referCodeDynamic") == null){
        _referController.text = "";
      }else{
        _referController.text = PrefUtils.prefs!.getString("referCodeDynamic")!;
      }
    });

    super.initState();
  }
  addEmailToSF(String value) async {
    PrefUtils.prefs!.setString('Email', value);
  }

  addGStnumberTOSF(String value) async{
    PrefUtils.prefs!.setString('GST', value);
  }
  addshpNameTOSF(String value) async{
    PrefUtils.prefs!.setString('ShopName', value);
  }
  addpinTOSF(String value) async{
    PrefUtils.prefs!.setString('Pincode', value);
  }
  Future<void> checkemail() async {
    try {
      final response = await http.post(Api.emailCheck, body: {
        "email": PrefUtils.prefs!.getString('Email'),
      });
      final responseJson = json.decode(response.body);

      if (responseJson['status'].toString() == "true") {
        if (responseJson['type'].toString() == "old") {
          Navigator.of(context).pop();
          //Fluttertoast.showToast(msg: 'Email id already exists!!!');
          Fluttertoast.showToast(
              msg: S .of(context).email_exist,//"Email id already exists",
              fontSize: MediaQuery.of(context).textScaleFactor *13,
              backgroundColor: Colors.black87,
              textColor: Colors.white);;
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
      if(PrefUtils.prefs!.containsKey("applesignin"))
        if (PrefUtils.prefs!.getString('applesignin') == "yes") {
          apple = PrefUtils.prefs!.getString('apple')!;
        } else {
          apple = "";
        }

      String name/*= PrefUtils.prefs!.getString('FirstName') + " " + PrefUtils.prefs!.getString('LastName')*/;

     /* if (PrefUtils.prefs!.getString('FirstName') != null) {
        if (PrefUtils.prefs!.getString('LastName') != null) {
          name = PrefUtils.prefs!.getString('FirstName') +
              " " +
              PrefUtils.prefs!.getString('LastName');
        } else {
          name = PrefUtils.prefs!.getString('FirstName');
        }
      } else {
        name = "";
      }*/
      //name = store.userData.username!;

     /* final response = await http.post(Api.register, body: {
        // await keyword is used to wait to this operation is complete.
        "username": name,
        "email": PrefUtils.prefs!.getString('Email'),
        "mobileNumber": PrefUtils.prefs!.getString('Mobilenum'),
        "path": apple,
        "tokenId": PrefUtils.prefs!.getString('tokenid'),
        "branch": PrefUtils.prefs!.getString('branch'),
        "signature" : PrefUtils.prefs!.containsKey("signature") ? PrefUtils.prefs!.getString('signature') : "",
        "referralid": _referController.text,
        "device": channel.toString(),
       // "referralid": _referController.text,
      });
      final responseJson = json.decode(response.body);

      if (responseJson['status'].toString() == "true") {
        fas.LogSignUp();
        final data = responseJson['data'] as Map<String, dynamic>;
        PrefUtils.prefs!.setString('apiKey', data['apiKey'].toString());
        PrefUtils.prefs!.setString('userID', responseJson['userId'].toString());
        PrefUtils.prefs!.setString('membership', responseJson['membership'].toString());
        PrefUtils.prefs!.setString("mobile", PrefUtils.prefs!.getString('Mobilenum')!);
        PrefUtils.prefs!.setString('referral', PrefUtils.prefs!.getString('referralCode')!);
        PrefUtils.prefs!.setString('LoginStatus', "true");
        PrefUtils.prefs!.setString('referid', _referController.text);
       *//* Navigator.of(context).pop();

        return Navigator.of(context).pushReplacementNamed(
          LocationScreen.routeName,
        );*//*


        if(responseJson['type'].toString() == "old"){
          Navigator.of(context).pop();
          *//*Navigator.of(context).pushNamedAndRemoveUntil(
              HomeScreen.routeName, ModalRoute.withName('/'));*//*
          Navigation(context, navigatore: NavigatoreTyp.homenav);
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
            //Navigator.of(context).pop();

            PrefUtils.prefs!.setString("latitude", PrefUtils.prefs!.getString("restaurant_lat")!);
            PrefUtils.prefs!.setString("longitude", PrefUtils.prefs!.getString("restaurant_long")!);
            PrefUtils.prefs!.setString("ismap", "true");
            PrefUtils.prefs!.setString("isdelivering", "true");
            addprimarylocation();
            //prefs.setString("formapscreen", "homescreen");
            //Navigator.of(context).pushReplacementNamed(MapScreen.routeName);
            *//* Navigator.of(context).pushReplacementNamed(
              LocationScreen.routeName,
            );*//*
          }
          // Navigator.of(context).pop();
          // return Navigator.of(context).pushNamedAndRemoveUntil(
          //     LocationScreen.routeName, ModalRoute.withName('/'));
        }



        *//*Navigator.of(context).pushReplacementNamed(
          HomeScreen.routeName,
        );*//*

      } else if (responseJson['status'].toString() == "false") {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: responseJson['data'].toString(),
            fontSize: MediaQuery.of(context).textScaleFactor *13,
            backgroundColor: Colors.black87,
            textColor: Colors.white);
      }*/
if(Features.btobModule){
  String _imagePath = "";
  List path = [];
  for(int i = 0; i < images.length; i++) {
    print("image length....."+images.length.toString());
    if(i == 0) {
      path.add(dio.MultipartFile.fromFileSync(images[i].path.toString()));
      _imagePath = images[i].path.toString();

    } else {
      path.add(dio.MultipartFile.fromFileSync(images[i].path.toString()));
      _imagePath = _imagePath + "," + images[i].path.toString();
    }
    print("image length....."+path.toString());
  }

print("signup data..."+{
  "username": _shopnamecontroller.text,
  "email": PrefUtils.prefs!.getString('Email'),
  "mobileNumber": PrefUtils.prefs!.getString('Mobilenum'),
  "path": apple,
  "tokenId": PrefUtils.prefs!.getString('tokenid'),
  "branch": PrefUtils.prefs!.getString('branch'),
  "signature" : PrefUtils.prefs!.containsKey("signature") ? PrefUtils.prefs!.getString('signature') : "",
  "referralid": _referController.text,
  "type":PrefUtils.prefs!.getBool('type'),
  "shop_name":businessnamecontroller.text,//PrefUtils.prefs.getString('shopName'),
  "gst": _numberController.text,//PrefUtils.prefs.getString('gst'),
  "pincode": _pincontroller.text,//PrefUtils.prefs.getString('pincode'),
  if(path.length >0)'image': dio.MultipartFile.fromFileSync(images[0].path.toString()),
  "device": channel.toString(),
}.toString());
  var map = dio.FormData.fromMap({
    "username": _shopnamecontroller.text,
    "email": PrefUtils.prefs!.getString('Email'),
    "mobileNumber": PrefUtils.prefs!.getString('Mobilenum'),
    "path": apple,
    "tokenId": PrefUtils.prefs!.getString('tokenid'),
    "branch": PrefUtils.prefs!.getString('branch'),
    "signature" : PrefUtils.prefs!.containsKey("signature") ? PrefUtils.prefs!.getString('signature') : "",
    "referralid": _referController.text,
    "type":PrefUtils.prefs!.getBool('type'),
    "shop_name":businessnamecontroller.text,//PrefUtils.prefs.getString('shopName'),
    "gst": _numberController.text,//PrefUtils.prefs.getString('gst'),
    "pincode": _pincontroller.text,//PrefUtils.prefs.getString('pincode'),
    if(path.length >0)'image': dio.MultipartFile.fromFileSync(images[0].path.toString()),
    "device": channel.toString(),
  });
  dio.Dio dios;
  dio.BaseOptions options = dio.BaseOptions(
    baseUrl: IConstants.API_PATH,
    connectTimeout: 30000,
    receiveTimeout: 30000,
  );

  dios = dio.Dio(options);
  final response = await dios.post("customer/register-b2b", data: map);
  print("btob module register"+response.toString());
  //final regresp = json.decode(await api.Posturl("customer/register-b2b"));
  final responseEncode = json.encode(response.data);
  final responseJson = json.decode(responseEncode);
  debugPrint("status.." + responseJson["status"].toString());
  if (responseJson["status"]) {
    PrefUtils.prefs!.setString('LoginStatus', "true");
    PrefUtils.prefs!.setString("apikey", responseJson["userId"].toString());
    auth.getuserProfile(onsucsess: (UserData response){
        fas.LogSignUp();
        PrefUtils.prefs!.setString('apiKey', response.apiKey!);
        PrefUtils.prefs!.setString('userID', response.id!);
        PrefUtils.prefs!.setString('membership', response.membership!);
        PrefUtils.prefs!.setString(
            "mobile", PrefUtils.prefs!.getString('Mobilenum')!);
        PrefUtils.prefs!.setString(
            'referral', PrefUtils.prefs!.getString('referralCode') ?? "");
        PrefUtils.prefs!.setString('LoginStatus', "true");
        PrefUtils.prefs!.setString('referid', _referController.text);
        PrefUtils.prefs!.setString('shop_name',businessnamecontroller.text);
        PrefUtils.prefs!.setString('gst',_numberController.text);
        PrefUtils.prefs!.setString('pincode',_pincontroller.text);
        /* Navigator.of(context).pop();

            return Navigator.of(context).pushReplacementNamed(
              LocationScreen.routeName,
            );*/

        if (PrefUtils.prefs!.getString("ismap").toString() == "true") {
          if (PrefUtils.prefs!.getString("fromcart").toString() == "cart_screen") {
            Navigation(
                context, name: Routename.Login, navigatore: NavigatoreTyp.Push);
          }
          else {
            debugPrint("homenav....1");
            Navigation(context, navigatore: NavigatoreTyp.homenav);
          }
        }
        else if (PrefUtils.prefs!.getString("isdelivering").toString() == "true") {
          debugPrint("homenav....2");
          Navigation(context, navigatore: NavigatoreTyp.homenav);
        }
        else {
          PrefUtils.prefs!.setString("formapscreen", "homescreen");
          PrefUtils.prefs!.setString(
              "latitude", PrefUtils.prefs!.getString("restaurant_lat")!);
          PrefUtils.prefs!.setString(
              "longitude", PrefUtils.prefs!.getString("restaurant_long")!);
          PrefUtils.prefs!.setString("ismap", "true");
          PrefUtils.prefs!.setString("isdelivering", "true");
          debugPrint("homenav....3");
          Navigation(context, navigatore: NavigatoreTyp.homenav);
        }

    }, onerror: (message){
  Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: message.toString(),
            fontSize: MediaQuery
                .of(context)
                .textScaleFactor * 13,
            backgroundColor: Colors.black87,
            textColor: Colors.white);
    });

  } else {

    Navigator.of(context).pop();
    Fluttertoast.showToast(
        msg: responseJson["data"].toString(),
        fontSize: MediaQuery
            .of(context)
            .textScaleFactor * 13,
        backgroundColor: Colors.black87,
        textColor: Colors.white);

  }



  // print("signup data..... register......"+{
  //   "username": PrefUtils.prefs!.getString('FirstName'),
  //     "email": (PrefUtils.prefs!.getString('Email') ?? ""),
  //     "branch": PrefUtils.prefs!.getString("branch"),
  //     "tokenId": PrefUtils.prefs!.getString("ftokenid"),
  //     "guestUserId": PrefUtils.prefs!.getString("tokenid"),
  //     "device": channel.toString(),
  //     "referralid": (_referController.text),
  //     "path": apple.toString(),
  //     "ref": IConstants.isEnterprise && Features.ismultivendor ? IConstants
  //         .refIdForMultiVendor.toString() : "",
  //     "branchtype": IConstants.isEnterprise && Features.ismultivendor ? IConstants
  //         .branchtype.toString() : "",
  //     "mobileNumber": PrefUtils.prefs!.getString('Mobilenum'),
  //     "gst":  PrefUtils.prefs!.getString('GST'),
  //     "shopname": PrefUtils.prefs!.getString('ShopName'),
  //     "pincode": PrefUtils.prefs!.getString('Pincode'),
  //     // image: PrefUtils.prefs!.getString('GST'),
  //     "image": (path.length >0)?path:"",
  // }.toString());
  // userappauth.register(data: RegisterAuthBodyParm(
  //     username: PrefUtils.prefs!.getString('FirstName'),
  //     email: (PrefUtils.prefs!.getString('Email') ?? ""),
  //     branch: PrefUtils.prefs!.getString("branch"),
  //     tokenId: PrefUtils.prefs!.getString("ftokenid"),
  //     guestUserId: PrefUtils.prefs!.getString("tokenid"),
  //     device: channel.toString(),
  //     referralid: (_referController.text),
  //     path: apple.toString(),
  //     ref: IConstants.isEnterprise && Features.ismultivendor ? IConstants
  //         .refIdForMultiVendor.toString() : "",
  //     branchtype: IConstants.isEnterprise && Features.ismultivendor ? IConstants
  //         .branchtype.toString() : "",
  //     mobileNumber: PrefUtils.prefs!.getString('Mobilenum'),
  //   gst:  PrefUtils.prefs!.getString('GST'),
  //   shopname: PrefUtils.prefs!.getString('ShopName'),
  //   pincode: PrefUtils.prefs!.getString('Pincode'),
  //  // image: PrefUtils.prefs!.getString('GST'),
  //     image: (path.length >0)?path.toString():"",
  //
  // ), onSucsess: (UserData response) {
  //   fas.LogSignUp();
  //   PrefUtils.prefs!.setString('apiKey', response.apiKey!);
  //   PrefUtils.prefs!.setString('userID', response.id!);
  //   PrefUtils.prefs!.setString('membership', response.membership!);
  //   PrefUtils.prefs!.setString(
  //       "mobile", PrefUtils.prefs!.getString('Mobilenum')!);
  //   PrefUtils.prefs!.setString(
  //       'referral', PrefUtils.prefs!.getString('referralCode') ?? "");
  //   PrefUtils.prefs!.setString('LoginStatus', "true");
  //   PrefUtils.prefs!.setString('referid', _referController.text);
  //   PrefUtils.prefs!.setString('shop_name',businessnamecontroller.text);
  //   PrefUtils.prefs!.setString('gst',_numberController.text);
  //   PrefUtils.prefs!.setString('pincode',_pincontroller.text);
  //   /* Navigator.of(context).pop();
  //
  //       return Navigator.of(context).pushReplacementNamed(
  //         LocationScreen.routeName,
  //       );*/
  //
  //   if (PrefUtils.prefs!.getString("ismap").toString() == "true") {
  //     if (PrefUtils.prefs!.getString("fromcart").toString() == "cart_screen") {
  //       Navigation(
  //           context, name: Routename.Login, navigatore: NavigatoreTyp.Push);
  //     }
  //     else {
  //       debugPrint("homenav....1");
  //       Navigation(context, navigatore: NavigatoreTyp.homenav);
  //     }
  //   }
  //   else if (PrefUtils.prefs!.getString("isdelivering").toString() == "true") {
  //     debugPrint("homenav....2");
  //     Navigation(context, navigatore: NavigatoreTyp.homenav);
  //   }
  //   else {
  //     PrefUtils.prefs!.setString("formapscreen", "homescreen");
  //     PrefUtils.prefs!.setString(
  //         "latitude", PrefUtils.prefs!.getString("restaurant_lat")!);
  //     PrefUtils.prefs!.setString(
  //         "longitude", PrefUtils.prefs!.getString("restaurant_long")!);
  //     PrefUtils.prefs!.setString("ismap", "true");
  //     PrefUtils.prefs!.setString("isdelivering", "true");
  //     debugPrint("homenav....3");
  //     Navigation(context, navigatore: NavigatoreTyp.homenav);
  //   }
  // }, onerror: (message) {
  //   Navigator.of(context).pop();
  //   Fluttertoast.showToast(
  //       msg: message.toString(),
  //       fontSize: MediaQuery
  //           .of(context)
  //           .textScaleFactor * 13,
  //       backgroundColor: Colors.black87,
  //       textColor: Colors.white);
  // });
}
else {
  userappauth.register(data: RegisterAuthBodyParm(
      username: PrefUtils.prefs!.getString('FirstName'),
      email: (PrefUtils.prefs!.getString('Email') ?? ""),
      branch: PrefUtils.prefs!.getString("branch"),
      tokenId: PrefUtils.prefs!.getString("ftokenid"),
      guestUserId: PrefUtils.prefs!.getString("tokenid"),
      device: channel.toString(),
      referralid: (_referController.text),
      path: apple.toString(),
      ref: IConstants.isEnterprise && Features.ismultivendor ? IConstants
          .refIdForMultiVendor.toString() : IConstants
          .refIdForMultiVendor.toString(),
      branchtype: IConstants.isEnterprise && Features.ismultivendor ? IConstants
          .branchtype.toString() : IConstants
          .branchtype.toString(),
      mobileNumber: PrefUtils.prefs!.getString('Mobilenum'),
    shopname: "",
    pincode: "",
    gst: "",
    image: "",
    language_code: IConstants.languageId,

  ), onSucsess: (UserData response) {
    fas.LogSignUp();
    auth.getuserProfile(onsucsess: (UserData response){
    PrefUtils.prefs!.setString('apiKey', response.apiKey!);
    PrefUtils.prefs!.setString('userID', response.id!);
    PrefUtils.prefs!.setString('membership', response.membership!);
    PrefUtils.prefs!.setString(
        "mobile", PrefUtils.prefs!.getString('Mobilenum')!);
    PrefUtils.prefs!.setString(
        'referral', PrefUtils.prefs!.getString('referralCode') ?? "");
    PrefUtils.prefs!.setString('LoginStatus', "true");
    PrefUtils.prefs!.setString('referid', _referController.text);
    /* Navigator.of(context).pop();

        return Navigator.of(context).pushReplacementNamed(
          LocationScreen.routeName,
        );*/

    if (PrefUtils.prefs!.getString("ismap").toString() == "true") {
      if (PrefUtils.prefs!.getString("fromcart").toString() == "cart_screen") {
        Navigation(
            context, name: Routename.Login, navigatore: NavigatoreTyp.Push);
      }
      else {
        debugPrint("homenav....1");
        Navigation(context, navigatore: NavigatoreTyp.homenav);
      }
    }
    else if (PrefUtils.prefs!.getString("isdelivering").toString() == "true") {
      debugPrint("homenav....2");
      Navigation(context, navigatore: NavigatoreTyp.homenav);
    }
    else {
      PrefUtils.prefs!.setString("formapscreen", "homescreen");
      PrefUtils.prefs!.setString(
          "latitude", PrefUtils.prefs!.getString("restaurant_lat")!);
      PrefUtils.prefs!.setString(
          "longitude", PrefUtils.prefs!.getString("restaurant_long")!);
      PrefUtils.prefs!.setString("ismap", "true");
      PrefUtils.prefs!.setString("isdelivering", "true");
      debugPrint("homenav....3");
      Navigation(context, navigatore: NavigatoreTyp.homenav);
    }
    }, onerror: (message){
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: message.toString(),
          fontSize: MediaQuery
              .of(context)
              .textScaleFactor * 13,
          backgroundColor: Colors.black87,
          textColor: Colors.white);
    });
  }, onerror: (message) {
    Navigator.of(context).pop();
    Fluttertoast.showToast(
        msg: message.toString(),
        fontSize: MediaQuery
            .of(context)
            .textScaleFactor * 13,
        backgroundColor: Colors.black87,
        textColor: Colors.white);
  });
}
    } catch (error) {
      setState(() {});
      throw error;
    }
  }

  Future<void> addprimarylocation() async {

    var url = IConstants.API_PATH + 'add-primary-location';
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
debugPrint("add primary...."+{
  // await keyword is used to wait to this operation is complete.
  "id": PrefUtils.prefs!.getString("userID"),
  "latitude": PrefUtils.prefs!.getString("latitude"),
  "longitude":PrefUtils.prefs!.getString("longitude"),
  "area": IConstants.deliverylocationmain.value.toString(),
  "branch": PrefUtils.prefs!.getString('branch'),
  "ref": IConstants.refIdForMultiVendor,
  "branchtype": IConstants.branchtype.toString(),
}.toString());
      final response = await http.post(url, body: {
        // await keyword is used to wait to this operation is complete.
        "id": PrefUtils.prefs!.getString("userID"),
        "latitude": PrefUtils.prefs!.getString("latitude"),
        "longitude":PrefUtils.prefs!.getString("longitude"),
        "area": IConstants.deliverylocationmain.value.toString(),
        "branch": PrefUtils.prefs!.getString('branch'),
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
            debugPrint("homenav....4");
            Navigation(context, navigatore: NavigatoreTyp.homenav);
            //Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
          }


        }
        else if(PrefUtils.prefs!.getString("isdelivering").toString()=="true"){
          debugPrint("homenav....5");
          Navigation(context, navigatore: NavigatoreTyp.homenav);
          //Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);


        }
        else {
          debugPrint("homenav....6");
          PrefUtils.prefs!.setString("formapscreen", "homescreen");
          PrefUtils.prefs!.setString("latitude", PrefUtils.prefs!.getString("restaurant_lat")!);
          PrefUtils.prefs!.setString("longitude", PrefUtils.prefs!.getString("restaurant_long")!);
          PrefUtils.prefs!.setString("ismap", "true");
          PrefUtils.prefs!.setString("isdelivering", "true");
          Navigation(context, navigatore: NavigatoreTyp.homenav);
          //Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);

        }
      }
    } catch (error) {
      Navigator.of(context).pop();
      throw error;
    }
  }

  addFirstnameToSF(String value) async {
    PrefUtils.prefs!.setString('FirstName', value);
  }
  addReferralToSF(String value)async{
    PrefUtils.prefs!.setString('referid', value);
  }
  addLastnameToSF(String value) async {
    PrefUtils.prefs!.setString('LastName', value);
  }
  _saveForm() async {
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

      String apple = "";
      if(PrefUtils.prefs!.containsKey("applesignin"))
        if (PrefUtils.prefs!.getString('applesignin') == "yes") {
          apple = PrefUtils.prefs!.getString('apple')!;
        } else {
          apple = "";
        }

      final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    } //it will check all validators
    _form.currentState!.save();
    _dialogforProcessing();
     if(PrefUtils.prefs!.getString('Email') == "" || PrefUtils.prefs!.getString('Email') == "null") {
      //return SignupUser();
    print("signup data..."+{
      "username": PrefUtils.prefs!.getString('FirstName'),
      "email": (PrefUtils.prefs!.getString('Email')??""),
      "branch": PrefUtils.prefs!.getString("branch"),
      "tokenId":PrefUtils.prefs!.getString("ftokenid"),
      "guestUserId":PrefUtils.prefs!.getString("tokenid"),
      "device":channel.toString(),
      "referralid":(_referController.text),
      "path": apple.toString(),
      "mobileNumber": PrefUtils.prefs!.getString('Mobilenum')

    }.toString());

       SignupUser();
     }
     else {
       checkemail();
    }
  }

  imageSelectorGallery()async {

    galleryFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
    );
    images.add(galleryFile!);
    setState(() {});

  }
  displayImages(){
    return GridView.count(
      crossAxisCount: 1,
      children: List.generate(images.length, (index) {
        return Container(
          margin: EdgeInsets.all(5.0),
          child: Stack(children: <Widget>[
            Container(
              height: 150,
              width: 200,
              child: Image.file(images[index],fit: BoxFit.fill,),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    images.removeAt(index);
                  });
                },
                child: Icon(
                  Icons.cancel,
                ),
              ),
            ),
          ],),
        );

      }),
    );
  }

  _bottomNavigationBar() {
    return SingleChildScrollView(

        child: GestureDetector(
          onTap: () {
            _saveForm();
          },
          child: Container(
            margin: EdgeInsets.all(20),
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).primaryColor
            ),
            child: Center(
              child: Text(
                S .of(context).continue_button,//'CONTINUE',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ),

    );
  }

  @override
  Widget build(BuildContext context) {
   /* if(PrefUtils.prefs!.getString("referCodeDynamic") == " " || PrefUtils.prefs!.getString("referCodeDynamic") == null){
      _referController.text = "";
    }else{
      _referController.text = PrefUtils.prefs!.getString("referCodeDynamic");
    }*/

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      //systemNavigationBarColor:
      //  Theme.of(context).primaryColor, // navigation bar color
      statusBarColor: Theme.of(context).primaryColor, // status bar color
    ));
    return WillPopScope(
      onWillPop: () async{
        debugPrint("homenav....7");
        Navigation(context, navigatore: NavigatoreTyp.homenav);
        return false;
      },
      child: Scaffold(
        appBar: NewGradientAppBar(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                ColorCodes.appbarColor,
                ColorCodes.appbarColor2
              ]),
          title: Text( S .of(context).add_info,//'Add your info',
            style: TextStyle(color: ColorCodes.iconColor, fontWeight: FontWeight.bold, fontSize: 18),),
          elevation: (IConstants.isEnterprise)?0:1,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: ColorCodes.iconColor),
            onPressed: () {
             /* Navigator.of(context).pop();
              Navigator.of(context).pop();*/
              debugPrint("homenav....8");
              Navigation(context, navigatore: NavigatoreTyp.homenav);
            },
          ),
        ),
        body: SingleChildScrollView(
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
                      if(Features.btobModule)
                      SizedBox(height: 10),
                      if(Features.btobModule)
                      Text(
                        S.of(context).business_name,//"Business Name",
                        //S.of(context).what_should_we_call_you,//'* What should we call you?',
                        style: TextStyle(fontSize: 17, color: ColorCodes.blackColor),
                      ),
                      if(Features.btobModule)
                      SizedBox(height: 10),
                      if(Features.btobModule)
                      TextFormField(
                        textAlign: TextAlign.left,
                        controller: businessnamecontroller,
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding:
                          EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                          hintText:  S.of(context).enter_business_name,//'Enter Business Name',//'Name',
                          fillColor: ColorCodes.lightGreyWebColor,
                          filled: true,

                        ),
                        /*  onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_lnameFocusNode);
                      },*/

                        onSaved: (value) {
                          addshpNameTOSF(value!);
                        },
                      ),
                      if(Features.btobModule)
                      SizedBox(height: 10),
                      if(Features.btobModule)
                      Text(
                        S.of(context).owner_name,//"Owner Name",
                        //S.of(context).what_should_we_call_you,//'* What should we call you?',
                        style: TextStyle(fontSize: 17, color: ColorCodes.blackColor),
                      ),
                      if(Features.btobModule)
                      SizedBox(height: 10),
                      if(Features.btobModule)
                      TextFormField(
                        textAlign: TextAlign.left,
                        controller: _shopnamecontroller,
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding:
                          EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                          hintText:  S.of(context).enter_owner_name,//'Enter Owner Name',//'Name',
                          fillColor: ColorCodes.lightGreyWebColor,
                          filled: true,
                        ),
                        /* onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_lnameFocusNode);
                      },*/

                        onSaved: (value) {
                          addFirstnameToSF(value!);
                        },
                      ),
                      if(Features.btobModule)
                      SizedBox(height: 10.0),
                      if(Features.btobModule)
                      Text(
                        S.of(context).pin_code,//"Pincode",
                        //S.of(context).what_should_we_call_you,//'* What should we call you?',
                        style: TextStyle(fontSize: 17, color: ColorCodes.blackColor),
                      ),
                      if(Features.btobModule)
                      SizedBox(height: 10),
                      if(Features.btobModule)
                      TextFormField(
                        textAlign: TextAlign.left,
                        controller: _pincontroller,
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding:
                          EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                          hintText:  S.of(context).enter_pincode,//'Enter Pincode',//'Name',
                          fillColor: ColorCodes.lightGreyWebColor,
                          filled: true,

                        ),
                        /* onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_lnameFocusNode);
                      },*/

                        onSaved: (value) {
                          addpinTOSF(value!);
                        },
                      ),
                      if(Features.btobModule)
                      Text(
                        fn,
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.red),
                      ),




                      if(!Features.btobModule)
                      SizedBox(height: 10),
                      // if(!Features.btobModule)
                      // Text(
                      //   S .of(context).what_should_we_call_you,//'* What should we call you?',
                      //   style: TextStyle(fontSize: 17, color: ColorCodes.lightBlack),
                      // ),
                      // if(!Features.btobModule)
                      // SizedBox(height: 10),
                      if(!Features.btobModule)
                      TextFormField(
                        textAlign: TextAlign.left,
                        controller: firstnamecontroller,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: S.of(context).what_should_we_call_you,
                          labelStyle: TextStyle(
                              color: ColorCodes.emailColor,
                              fontSize: 16.0
                          ),
                          hintText:  S .of(context).name,//'Name',
                          hoverColor: ColorCodes.emailColor,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: ColorCodes.emailColor),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: ColorCodes.emailColor),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: ColorCodes.emailColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: ColorCodes.emailColor),
                          ),
                        ),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_lnameFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            setState(() {
                              fn = S .of(context).please_enter_name;//"  Please Enter Name";
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
                      if(!Features.btobModule)
                      Text(
                        fn,
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.red),
                      ),
                      if(!Features.btobModule)
                      SizedBox(height: 10.0),
                      // if(!Features.btobModule)
                      // Text(
                      //   S .of(context).tell_us_your_email,//'Tell us your e-mail',
                      //   style: TextStyle(fontSize: 17, color: ColorCodes.lightBlack),
                      // ),
                      // if(!Features.btobModule)
                      // SizedBox(
                      //   height: 10.0,
                      // ),
                      if(!Features.btobModule)
                      TextFormField(
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: S.of(context).tell_us_your_email,
                          labelStyle: TextStyle(
                              color: ColorCodes.emailColor,
                              fontSize: 16.0
                          ),
                          hintText: S.of(context).xyz_gmail,//'xyz@gmail.com',
                          fillColor: ColorCodes.emailColor,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: ColorCodes.emailColor),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: ColorCodes.emailColor),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: ColorCodes.emailColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: ColorCodes.emailColor, width: 1.2),
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
                              ea = S .of(context).please_enter_valid_email_address;//' Please enter a valid email address';
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
                      if(!Features.btobModule)
                      Row(
                        children: <Widget>[
                          Text(
                            ea,
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                      // if(!Features.btobModule)
                      // Text(
                      //   S .of(context).we_will_email,//' We\'ll email you as a reservation confirmation.',
                      //   style: TextStyle(fontSize: 15.2, color: ColorCodes.emailColor),
                      // ),
                      // if(!Features.btobModule)
                      // SizedBox(
                      //   height: 15.0,
                      // ),
                     // if(Features.isReferEarn)
                     //  Text(
                     //    S .of(context).apply_referal_code,//'Apply referral Code',
                     //    style: TextStyle(fontSize: 17, color: ColorCodes.lightBlack),
                     //  ),
                     //  if(Features.isReferEarn)
                      SizedBox(
                        height: 10.0,
                      ),
                      if(Features.isReferEarn)
                      TextFormField(
                        style: TextStyle(fontWeight: FontWeight.bold),
                        controller: _referController,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          labelText: S .of(context).apply_referal_code,
                          labelStyle: TextStyle(
                              color: ColorCodes.emailColor,
                              fontSize: 16.0
                          ),
                          hintText: S .of(context).refer_earn,//'Refer and Earn',
                          fillColor: ColorCodes.emailColor,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: ColorCodes.emailColor),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: ColorCodes.emailColor),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: ColorCodes.emailColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: ColorCodes.emailColor, width: 1.2),
                          ),
                        ),
                       /*  validator: (value) {
                          bool emailValid;
                          if (value == "")
                            emailValid = true;
                          else
                            emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value);

                          if (!emailValid) {
                            setState(() {
                              ea = ' Please enter a valid email address';
                            });
                            return '';
                          }
                          setState(() {
                            ea = "";
                          });
                          return null; //it means user entered a valid input
                        },*/
                        onSaved: (value) {
                          addReferralToSF(value!);
                        },
                      ),

                      if(Features.btobModule)
                      SizedBox(
                        height: 10.0,
                      ),
                      if(Features.btobModule)
                        Text(S.of(context).gst_id,//"Gst Id",
                          /* S.of(context).id,*///'Apply referral Code',
                          style: TextStyle(fontSize: 17, color: ColorCodes.lightBlack),
                        ),
                      if(Features.btobModule)
                        SizedBox(
                          height: 10.0,
                        ),
                      if(Features.btobModule)
                        TextFormField(
                          controller: _numberController,
                          textAlign: TextAlign.left,
                          style: new TextStyle(
                              decorationColor: Theme.of(context).primaryColor),
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding:
                            EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                            hintText: /*S.of(context).gst_id,*/ /*"Enter Gst No"*/S.of(context).enter_gst,
                            fillColor: ColorCodes.lightGreyWebColor,
                            filled: true,

                          ),
                          onSaved: (value) {
                            addGStnumberTOSF(value!);
                          },
                        ),
                      if(Features.btobModule)
                        SizedBox(height:15),
                      if(Features.btobModule)
                        Column(
                          children: [
                            Center(
                                child: Text(S.of(context).upload_document,//"Upload document for KYC Verification ",
                                    style: TextStyle(
                                        color: ColorCodes.blackColor, fontSize: 18.0, fontWeight: FontWeight.bold))
                            ),
                            Center( child:Text(S.of(context).gstn,//"(GSTN/PanCard/Udyog/Aadhar Documents)",
                                style: TextStyle(
                                    color: ColorCodes.blackColor, fontSize: 12.0, fontWeight: FontWeight.bold))
                            ),
                          ],
                        ),
                      if(Features.btobModule)
                        SizedBox(height:10),
                      if(Features.btobModule)
                        Center(
                          child: DottedBorder(
                            padding: EdgeInsets.zero,
                            color: ColorCodes.mediumBlueColor,
                            //strokeWidth: 1,
                            dashPattern: [3.0],
                            child: Container(
                              padding: EdgeInsets.only(left: 6.0, right: 6.0),
                              height: 150.0,
                              width:250,
                              color: ColorCodes.whiteColor,
                              child: (images.length>0)?displayImages(): GestureDetector(
                                onTap: () {
                                  imageSelectorGallery();
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(Images.documentImg, height:30.0, width: 30.0),
                                    SizedBox(height:10),
                                    Text(
                                      S.of(context).upload_file_localdrive,//"Upload file from the local drive ",
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          color: ColorCodes.lightGreyColor,
                                          fontWeight: FontWeight.bold),
                                    ),

                                  ],
                                ),
                              ),

                            ),
                          ),
                        ),

                      SizedBox(height: 20,),
                      GestureDetector(
                        onTap: () {
                          launch("tel: " + IConstants.primaryMobile);
                        },
                        child: Row(
                          children: [
                            Text(S.of(context).need_help,//"Need Help ? ",
                              /* S.of(context).id,*///'Apply referral Code',
                              style: TextStyle(fontSize: 14, color: ColorCodes.lightBlack),
                            ),
                            // SizedBox(width:),

                            Text(S.of(context).call_us,//" Call Us",
                              /* S.of(context).id,*///'Apply referral Code',
                              style: TextStyle(fontSize: 14, color: ColorCodes.lightblue),
                            ),

                          ],
                        ),
                      ),

                      SizedBox(height: 20,),
                    ],
                  ),
                ),
              ),


/*            GestureDetector(
                onTap: () {
                  _saveForm();
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  color: Color(0xFF2966A2),
                  child: Center(
                    child: Text(
                      'CONTINUE',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              )*/
            ],
          ),
        ),
        bottomNavigationBar:  Padding(
          padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
          child: _bottomNavigationBar(),
        ),
      ),
    );
  }


}
