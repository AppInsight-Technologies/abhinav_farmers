import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../constants/features.dart';
import '../models/VxModels/VxStore.dart';
import '../rought_genrator.dart';
import '../screens/otpconfirm_screen.dart';
import 'package:velocity_x/velocity_x.dart';
import '../constants/api.dart';
import '../generated/l10n.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import '../assets/ColorCodes.dart';
import '../utils/ResponsiveLayout.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../utils/prefUtils.dart';
import '../screens/home_screen.dart';
import '../constants/IConstants.dart';
import 'package:dio/dio.dart' as dio;


class EditScreenWeb with Navigations{
  EditScreenWeb(context){
    _dialogforedit(context);
  }
  _dialogforedit(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width/5,maxHeight: MediaQuery.of(context).size.height/1.5),
              //constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width/3,maxHeight: MediaQuery.of(context).size.height/2),
              child: AlertDialog(
                insetPadding: EdgeInsets.symmetric(horizontal: 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                content: Container(
                    width: MediaQuery.of(context).size.width/3,
                    height:  MediaQuery.of(context).size.height/1.6,
                    child: EditScreen(
                    )),
              ),
            );
          });
        }
    );

  }
}

class EditScreen extends StatefulWidget {
  static const routeName = '/edit-screen';

  @override
  EditScreenState createState() => EditScreenState();
}

class EditScreenState extends State<EditScreen> with Navigations{
  final _lnameFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  String fn = "";
  String ln = "";
  String ea = "";
  String mb = "";
  String on = "";
  String pn = "";
  String gs = "";
  var shop= "", gst = "", pincode = "";
  var name = "", email = "", phone = "",businessname = "", ownername = "",gstno = "",shopname = "";
  bool _isWeb = false;
  File? galleryFile;
  List<File> images = <File>[];
  final TextEditingController firstnamecontroller = new TextEditingController();
  final TextEditingController mobileNumberController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController businessnamecontroller = new TextEditingController();
  final TextEditingController _pincontroller = new TextEditingController();
  final TextEditingController _shopnamecontroller = new TextEditingController();
  final TextEditingController _gstcontroller = new TextEditingController();
  final TextEditingController _numberController = new TextEditingController();
  bool iphonex = false;
  GroceStore store = VxState.store;
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
    Future.delayed(Duration.zero, () async {
      try {
        if (Platform.isIOS) {
          setState(() {
            _isWeb = false;
            iphonex = MediaQuery
                .of(context)
                .size
                .height >= 812.0;
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
      setState(() {
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
        }
*/
        name = store.userData.username!;
        phone = store.userData.mobileNumber!;
        email = store.userData.email!;
        pincode = store.userData.pinCode??"";
        gstno = store.userData.gst??"";
        shopname = store.userData.shopName??"";
        gstno = store.userData.gst??"";

     /*   if (PrefUtils.prefs!.getString('mobile') != null) {
          phone = PrefUtils.prefs!.getString('mobile')!;
        } else {
          phone = "";
        }*/
      /*  if (PrefUtils.prefs!.getString('Email') != null) {
          email = PrefUtils.prefs!.getString('Email')!;
        } else {
          email = "";
        }*/
        firstnamecontroller.text = name;
        mobileNumberController.text = phone;
        emailController.text = email;
        _shopnamecontroller.text = shopname;
        _pincontroller.text = pincode;
        _gstcontroller.text = gstno;
        businessnamecontroller.text = name;
        print("edit nae....."+firstnamecontroller.text.toString()+"name..."+name.toString());

      });
    });
    super.initState();
  }
  Future<void> checkemail(String email) async {
    print("emailcheck....");
    try {
      final response = await http.post(Api.emailCheck, body: {
        "email": email,
      });
      final responseJson = json.decode(response.body);

      if (responseJson['status'].toString() == "true") {
        if (responseJson['type'].toString() == "old") {
          print("emailcheck....old");
          Navigator.of(context).pop();
          //Fluttertoast.showToast(msg: 'Email id already exists!!!');
          Fluttertoast.showToast(
              msg: S .of(context).email_exist,//"Email id already exists",
              fontSize: MediaQuery.of(context).textScaleFactor *13,
              backgroundColor: Colors.black87,
              textColor: Colors.white);;
        } else if (responseJson['type'].toString() == "new") {
          print("emailcheck....new");
          return UpdateProfile();
        }
      } else {
        Fluttertoast.showToast(msg: S .of(context).something_went_wrong,//"Something went wrong!!!"
        );
      }
    } catch (error) {
      throw error;
    }
  }


  Future<void> _getOtp(String mobile) async {
    try {
      final response = await http.post(Api.preRegister, body: {
        // await keyword is used to wait to this operation is complete.
        "mobileNumber": mobile,
        "tokenId": PrefUtils.prefs!.getString('ftokenid'),
        "signature": PrefUtils.prefs!.containsKey("signature") ? PrefUtils.prefs!.getString('signature') : "",
        "branch" : PrefUtils.prefs!.getString("branch"),
      });
      final responseJson = json.decode(response.body);
      print("respobse edit ..."+responseJson.toString());
      final data = responseJson['data'] as Map<String, dynamic>;


      if (responseJson['status'].toString() == "true") {
        if(responseJson['type'].toString() == "old") {
          Navigator.of(context).pop();
           Fluttertoast.showToast(msg:
          S .of(context).mobile_exists,
          // "Mobile Number already exists!",
            fontSize: MediaQuery.of(context).textScaleFactor *13,);
        } else {
          Navigator.of(context).pop();
          PrefUtils.prefs!.setString("userapikey", PrefUtils.prefs!.getString('apikey').toString());
          PrefUtils.prefs!.setString('Otp', data['otp'].toString());
          PrefUtils.prefs!.setString('Mobilenum',mobileNumberController.text);
          PrefUtils.prefs!.setBool('type',false);

          store.userData.mobileNumber = mobileNumberController.text;
          debugPrint("otp...edit apikey "+PrefUtils.prefs!.getString('userapikey')!);
          debugPrint("otp...edit apikey "+PrefUtils.prefs!.getString('apikey')!);
          debugPrint("otp...edit"+PrefUtils.prefs!.getString('Otp')!);

         /* Navigator.of(context).pushNamed(OtpconfirmScreen.routeName,
              arguments: {
               "prev":"editscreen",
                "firstName":firstnamecontroller.text,
                "mobileNum":mobileNumberController.text,
                "email":emailController.text,
              });*/

          Navigation(context, name: Routename.OtpConfirm, navigatore: NavigatoreTyp.Push,
              qparms: {
                "prev":"editscreen",
                "firstName":firstnamecontroller.text,
                "mobileNum":mobileNumberController.text,
                "email":emailController.text,
              });
        }
//        Navigator.of(context).pushNamed(
//          OtpconfirmScreen.routeName,
//        );

      } else if (responseJson['status'].toString() == "false") {}
    } catch (error) {
      throw error;
    }
  }

  Future<void> UpdateProfile() async {
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
        print("image length....."+_shopnamecontroller.text.toString());
      }
      try {
        final response = await http.post(Api.updateCustomerProfile, body: {
          "id": PrefUtils.prefs!.getString('apikey')!,
          "name": firstnamecontroller.text,
          "mobile": mobileNumberController.text,
          "email": emailController.text,
          "shop_name": _shopnamecontroller.text,
          "gst" : _numberController.text,
          "pincode" : _pincontroller.text,
          "image": path.length <=0 ?
          "":dio.MultipartFile.fromFileSync(images[0].path.toString()),
        });

        final responseJson = json.decode(utf8.decode(response.bodyBytes));
        if (responseJson["status"] == 200) {
          PrefUtils.prefs!.setString('FirstName', firstnamecontroller.text);
          PrefUtils.prefs!.setString('LastName', "");
          PrefUtils.prefs!.setString('mobile', mobileNumberController.text);
          PrefUtils.prefs!.setString('Email', emailController.text);

          store.userData.username = firstnamecontroller.text;
          store.userData.mobileNumber = mobileNumberController.text;
          store.userData.email = emailController.text;
          store.userData.gst = _gstcontroller.text;
          store.userData.shopName = _shopnamecontroller.text;
          store.userData.pinCode = _pincontroller.text;
          store.userData.username = businessnamecontroller.text;


          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigation(context, navigatore: NavigatoreTyp.homenav);
          //Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
        } else {
          Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg: S
                  .of(context)
                  .something_went_wrong,
              // "Something went wrong",
              fontSize: MediaQuery
                  .of(context)
                  .textScaleFactor * 13,
              backgroundColor: Colors.black87,
              textColor: Colors.white);
        }
      } catch (error) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: S
                .of(context)
                .something_went_wrong,
            // "Something went wrong",
            fontSize: MediaQuery
                .of(context)
                .textScaleFactor * 13,
            backgroundColor: Colors.black87,
            textColor: Colors.white);
        throw error;
      }
    }
    else {
      try {
        final response = await http.post(Api.updateCustomerProfile, body: {
          "id": PrefUtils.prefs!.getString('apikey'),
          "name": firstnamecontroller.text,
          "mobile": mobileNumberController.text,
          "email": emailController.text,
        });

        final responseJson = json.decode(utf8.decode(response.bodyBytes));
        if (responseJson["status"] == 200) {
          PrefUtils.prefs!.setString('FirstName', firstnamecontroller.text);
          PrefUtils.prefs!.setString('LastName', "");
          PrefUtils.prefs!.setString('mobile', mobileNumberController.text);
          PrefUtils.prefs!.setString('Email', emailController.text);

          store.userData.username = firstnamecontroller.text;
          store.userData.mobileNumber = mobileNumberController.text;
          store.userData.email = emailController.text;

          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigation(context, navigatore: NavigatoreTyp.homenav);
          //Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
        } else {
          Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg: S
                  .of(context)
                  .something_went_wrong,
              // "Something went wrong",
              fontSize: MediaQuery
                  .of(context)
                  .textScaleFactor * 13,
              backgroundColor: Colors.black87,
              textColor: Colors.white);
        }
      } catch (error) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: S
                .of(context)
                .something_went_wrong,
            // "Something went wrong",
            fontSize: MediaQuery
                .of(context)
                .textScaleFactor * 13,
            backgroundColor: Colors.black87,
            textColor: Colors.white);
        throw error;
      }
    }
  }

  @override
  void dispose() {
    firstnamecontroller.dispose();
    mobileNumberController.dispose();
    emailController.dispose();
    super.dispose();
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

  _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    } //it will check all validators
    _form.currentState!.save();

    if(mobileNumberController.text == /*PrefUtils.prefs!.getString("mobile")*/store.userData.mobileNumber!
    && emailController.text == store.userData.email) {
      _dialogforProcessing();
      UpdateProfile();
    } else {
      if(mobileNumberController.text != store.userData.mobileNumber){
        _dialogforProcessing();
        _getOtp(mobileNumberController.text);
      }
      else {
        _dialogforProcessing();
        checkemail(emailController.text);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: ResponsiveLayout.isSmallScreen(context) ?
      gradientappbarmobile() : null,
      backgroundColor: ColorCodes.whiteColor,
      body:  Column(
        children: <Widget>[
          // if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
          //   Header(false),
          (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?_bodyWeb():
          _body(),
        ],
      ),
      bottomNavigationBar: _isWeb ? SizedBox.shrink() : Padding(
        padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
        child:_bottomNavigationBar(),
      ),
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
              S .of(context).update_profile,
              // 'UPDATE PROFILE',
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

  _bodyWeb(){
    return Expanded(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50.0,
                  color: ColorCodes.whiteColor,
                  padding: EdgeInsets.only(left: 20.0,),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        S .of(context).edit_profile,//"Add your info",
                        style: TextStyle(
                            color: ColorCodes.blackColor,
                            fontSize: 20.0,fontWeight: FontWeight.bold),
                      )),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
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
                            // enabled: false,
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
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(_lnameFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                setState(() {
                                  fn = S.of(context).please_enter_name;//"  Please Enter Name";
                                });
                                return '';
                              }
                              setState(() {
                                fn = "";
                              });
                              return null;
                            },
                            onSaved: (value) {
                              //addshpNameTOSF(value);
                            },
                          ),
                        if(Features.btobModule)
                          Text(
                            fn,
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.red),
                          ),
                        if(Features.btobModule)
                          SizedBox(height: 10.0),
                        if(Features.btobModule)
                          Text(
                            S.of(context).mobile_number,
                            // 'Mobile number',
                            style: TextStyle(fontSize: 17, color: ColorCodes.lightBlack),
                          ),
                        if(Features.btobModule)
                          SizedBox(height: 10),
                        if(Features.btobModule)
                          TextFormField(
                            textAlign: TextAlign.left,
                            keyboardType: TextInputType.number,
                            controller: mobileNumberController,
                            style: new TextStyle(
                                decorationColor: Theme.of(context).primaryColor),
                            inputFormatters: [LengthLimitingTextInputFormatter(12)],
                            decoration: new InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding:
                              EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                              hintText: S.of(context).your_number,
                              fillColor: ColorCodes.lightGreyWebColor,
                              filled: true,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                setState(() {
                                  mb = S.of(context).please_enter_your_mobile;//"  Please enter number";
                                });
                                return '';
                              }
                              setState(() {
                                mb = "";
                              });
                              return null;
                            },
                            onSaved: (value) {
                              //addEmailToSF(value);
                            },
                          ),
                        if(Features.btobModule)
                          SizedBox(height: 5.0),
                        if(Features.btobModule)
                          Text(
                            mb,
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.red),
                          ),
                        if(Features.btobModule)
                          SizedBox(height: 10.0),
                        if(Features.btobModule)
                          Text(
                            S.of(context).tell_us_your_email,
                            // 'Tell us your e-mail',
                            style: TextStyle(fontSize: 17, color: ColorCodes.lightBlack),
                          ),
                        if(Features.btobModule)
                          SizedBox(
                            height: 10.0,
                          ),
                        if(Features.btobModule)
                          TextFormField(
                            // enabled: false,
                            textAlign: TextAlign.left,
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
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
                              hintText: S.of(context).xyz_gmail,//'xyz@gmail.com',
                              fillColor: ColorCodes.lightGreyWebColor,
                              filled: true,
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
                                  ea = S.of(context).please_enter_valid_email_address;//' Please enter a valid email address';
                                });
                                return '';
                              }
                              setState(() {
                                ea = "";
                              });
                              return null; //it means user entered a valid input
                            },
                            onSaved: (value) {
                              // addEmailToSF(value);
                            },
                          ),
                        if(Features.btobModule)
                          Text(
                            ea,
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.red),
                          ),
                        if(Features.btobModule)
                          Text(
                            S.of(context).owner_name,//"Owner Name",
                            // 'Mobile number',
                            style: TextStyle(fontSize: 17, color: ColorCodes.lightBlack),
                          ),
                        if(Features.btobModule)
                          SizedBox(height: 10),
                        if(Features.btobModule)
                          TextFormField(
                            //  enabled: false,
                            textAlign: TextAlign.left,
                            controller: _shopnamecontroller,
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
                              hintText: S.of(context).enter_owner_name,//'Enter Owner Name',
                              fillColor: ColorCodes.lightGreyWebColor,
                              filled: true,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                setState(() {
                                  on = S.of(context).please_enter_owner_name;//"  Please enter owner Name";
                                });
                                return '';
                              }
                              setState(() {
                                on = "";
                              });
                              return null;
                            },
                            onSaved: (value) {
                              //addEmailToSF(value);
                            },
                          ),
                        if(Features.btobModule)
                          SizedBox(height: 10.0),
                        if(Features.btobModule)
                          Text(
                            on,
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.red),
                          ),
                        if(Features.btobModule)
                          SizedBox(height: 5.0),
                        if(Features.btobModule)
                          Text(
                            S.of(context).pin_code,//'PinCode',
                            // 'Mobile number',
                            style: TextStyle(fontSize: 17, color: ColorCodes.lightBlack),
                          ),
                        if(Features.btobModule)
                          SizedBox(height: 10),
                        if(Features.btobModule)
                          TextFormField(
                            //  enabled: false,
                            textAlign: TextAlign.left,
                            keyboardType: TextInputType.number,
                            controller: _pincontroller,
                            style: new TextStyle(
                                decorationColor: Theme.of(context).primaryColor),
                            inputFormatters: [LengthLimitingTextInputFormatter(12)],
                            decoration: new InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding:
                              EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                              hintText:S.of(context).enter_pincode,//'Enter Pincode',
                              fillColor: ColorCodes.lightGreyWebColor,
                              filled: true,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                setState(() {
                                  pn = S.of(context).please_enter_pincode;//"  Please Pincode";
                                });
                                return '';
                              }
                              setState(() {
                                pn = "";
                              });
                              return null;
                            },
                            onSaved: (value) {
                              //addEmailToSF(value);
                            },
                          ),
                        if(Features.btobModule)
                          SizedBox(height: 10.0),
                        if(Features.btobModule)
                          Text(
                            pn,
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.red),
                          ),
                        if(Features.btobModule)
                          SizedBox(height: 5.0),
                        if(Features.btobModule)
                          Text(
                            S.of(context).gst_id,//'Gst Id',
                            // 'Mobile number',
                            style: TextStyle(fontSize: 17, color: ColorCodes.lightBlack),
                          ),
                        if(Features.btobModule)
                          SizedBox(height: 10),
                        if(Features.btobModule)
                          TextFormField(
                            // enabled: false,
                            textAlign: TextAlign.left,
                            keyboardType: TextInputType.number,
                            controller: _gstcontroller,
                            style: new TextStyle(
                                decorationColor: Theme.of(context).primaryColor),
                            inputFormatters: [LengthLimitingTextInputFormatter(12)],
                            decoration: new InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding:
                              EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                              hintText: S.of(context).enter_gst,//'Enter Gst No',
                              fillColor: ColorCodes.lightGreyWebColor,
                              filled: true,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                setState(() {
                                  gs = S.of(context).please_enter_gst;//"  Please Gst No";
                                });
                                return '';
                              }
                              setState(() {
                                gs = "";
                              });
                              return null;
                            },
                            onSaved: (value) {
                              //addEmailToSF(value);
                            },
                          ),
                        if(Features.btobModule)
                          SizedBox(height: 10.0),
                        if(Features.btobModule)
                          Text(
                            gs,
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.red),
                          ),


                        if(!Features.btobModule)
                          SizedBox(height: 10),
                        if(!Features.btobModule)

                          if(!Features.btobModule)
                            Container(
                              //height: MediaQuery.of(context).size.height / 15,//52.0,
                              child: TextFormField(
                                textAlign: TextAlign.left,
                                controller: firstnamecontroller,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(20.0),
                                  labelText: S .of(context).what_should_we_call_you,
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
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context).requestFocus(_lnameFocusNode);
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    setState(() {
                                      fn = S.of(context).please_enter_name;//"  Please enter name";
                                    });
                                    return '';
                                  }
                                  setState(() {
                                    fn = "";
                                  });
                                  return null;
                                },
                                onSaved: (value) {
                                  //addFirstnameToSF(value);
                                },
                              ),
                            ),
                        if(!Features.btobModule)
                          Text(
                            fn,
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.red),
                          ),
                        if(!Features.btobModule)
                          SizedBox(height: 10.0),

                        if(!Features.btobModule)
                          Container(
                            //height: MediaQuery.of(context).size.height / 15,//52.0,
                            child: TextFormField(
                              textAlign: TextAlign.left,
                              keyboardType: TextInputType.number,
                              controller: mobileNumberController,
                              style: new TextStyle(
                                  decorationColor: Theme.of(context).primaryColor),
                              inputFormatters: [LengthLimitingTextInputFormatter(12)],
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(20.0),
                                fillColor: ColorCodes.grey,
                                labelText: S .of(context).mobile_number,
                                labelStyle: TextStyle(
                                    color: ColorCodes.emailColor,
                                    fontSize: 16.0
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(3),
                                  borderSide: BorderSide(color: ColorCodes.grey),
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
                                  borderSide:
                                  BorderSide(color: ColorCodes.grey, width: 1.2),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  setState(() {
                                    mb = S.of(context).please_enter_your_mobile;//"  Please enter number";
                                  });
                                  return '';
                                }
                                setState(() {
                                  mb = "";
                                });
                                return null;
                              },
                              onSaved: (value) {
                                //addEmailToSF(value);
                              },
                            ),
                          ),
                        if(!Features.btobModule)
                          SizedBox(height: 10.0),
                        if(!Features.btobModule)
                          Text(
                            mb,
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.red),
                          ),
                        if(!Features.btobModule)
                          SizedBox(height: 10.0),
                        if(!Features.btobModule)
                          Container(
                           // height: MediaQuery.of(context).size.height / 15,//52.0,
                            child: TextFormField(
                              textAlign: TextAlign.left,
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              style: new TextStyle(
                                  decorationColor: Theme.of(context).primaryColor),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(20.0),
                                labelText: S.of(context).tell_us_your_email,
                                labelStyle: TextStyle(
                                    color: ColorCodes.emailColor,
                                    fontSize: 16.0
                                ),
                                fillColor: ColorCodes.grey,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(3),
                                  borderSide: BorderSide(color: ColorCodes.grey),
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
                                  borderSide:
                                  BorderSide(color: ColorCodes.grey, width: 1.2),
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
                                    ea = S.of(context).please_enter_valid_email_address;//' Please enter a valid email address';
                                  });
                                  return '';
                                }
                                setState(() {
                                  ea = "";
                                });
                                return null; //it means user entered a valid input
                              },
                              onSaved: (value) {
                                // addEmailToSF(value);
                              },
                            ),
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
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        _saveForm();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3.8,
                        height: 52,
                        margin: EdgeInsets.only(left:40,right:40,top:10),
                        padding: EdgeInsets.only(top:10,bottom: 10,left:50,right:50),
                        decoration: BoxDecoration(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            border: Border.all(
                              color: Theme
                                  .of(context)
                                  .primaryColor,
                            )),
                        child: Center(
                          child: Text(
                            S .of(context).update_profile,// "CONTINUE",
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Theme.of(context).buttonColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )),
                ),
                SizedBox(height: 10,),
                //if(_isWeb && ResponsiveLayout.isSmallScreen(context)) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
              ],

            ),
          ),
          Positioned(
            right: 10,
            top: 5,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.of(context).pop();
              },
              child: CircleAvatar(
                radius: 14.0,
                backgroundColor: ColorCodes.whiteColor,
                child: Icon(Icons.close, color: ColorCodes.black),
              ),
            ),
          ),
        ],
      ),
    );


  }

  _body(){
    return Expanded(
      child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 30.0),
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
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
                        // enabled: false,
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
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_lnameFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            setState(() {
                              fn = S.of(context).please_enter_name;//"  Please Enter Name";
                            });
                            return '';
                          }
                          setState(() {
                            fn = "";
                          });
                          return null;
                        },
                        onSaved: (value) {
                          //addshpNameTOSF(value);
                        },
                      ),
                      if(Features.btobModule)
                      Text(
                        fn,
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.red),
                      ),
                      if(Features.btobModule)
                      SizedBox(height: 10.0),
                      if(Features.btobModule)
                      Text(
                        S.of(context).mobile_number,
                        // 'Mobile number',
                        style: TextStyle(fontSize: 17, color: ColorCodes.lightBlack),
                      ),
                      if(Features.btobModule)
                      SizedBox(height: 10),
                      if(Features.btobModule)
                      TextFormField(
                        textAlign: TextAlign.left,
                        keyboardType: TextInputType.number,
                        controller: mobileNumberController,
                        style: new TextStyle(
                            decorationColor: Theme.of(context).primaryColor),
                        inputFormatters: [LengthLimitingTextInputFormatter(12)],
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding:
                          EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                          hintText: S.of(context).your_number,
                          fillColor: ColorCodes.lightGreyWebColor,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            setState(() {
                              mb = S.of(context).please_enter_your_mobile;//"  Please enter number";
                            });
                            return '';
                          }
                          setState(() {
                            mb = "";
                          });
                          return null;
                        },
                        onSaved: (value) {
                          //addEmailToSF(value);
                        },
                      ),
                      if(Features.btobModule)
                      SizedBox(height: 5.0),
                      if(Features.btobModule)
                      Text(
                        mb,
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.red),
                      ),
                      if(Features.btobModule)
                      SizedBox(height: 10.0),
                      if(Features.btobModule)
                      Text(
                        S.of(context).tell_us_your_email,
                        // 'Tell us your e-mail',
                        style: TextStyle(fontSize: 17, color: ColorCodes.lightBlack),
                      ),
                      if(Features.btobModule)
                      SizedBox(
                        height: 10.0,
                      ),
                      if(Features.btobModule)
                      TextFormField(
                        // enabled: false,
                        textAlign: TextAlign.left,
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
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
                          hintText: S.of(context).xyz_gmail,//'xyz@gmail.com',
                          fillColor: ColorCodes.lightGreyWebColor,
                          filled: true,
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
                              ea = S.of(context).please_enter_valid_email_address;//' Please enter a valid email address';
                            });
                            return '';
                          }
                          setState(() {
                            ea = "";
                          });
                          return null; //it means user entered a valid input
                        },
                        onSaved: (value) {
                          // addEmailToSF(value);
                        },
                      ),
                      if(Features.btobModule)
                      Text(
                        ea,
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.red),
                      ),
                      if(Features.btobModule)
                      Text(
                        S.of(context).owner_name,//"Owner Name",
                        // 'Mobile number',
                        style: TextStyle(fontSize: 17, color: ColorCodes.lightBlack),
                      ),
                      if(Features.btobModule)
                      SizedBox(height: 10),
                      if(Features.btobModule)
                      TextFormField(
                        //  enabled: false,
                        textAlign: TextAlign.left,
                        controller: _shopnamecontroller,
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
                          hintText: S.of(context).enter_owner_name,//'Enter Owner Name',
                          fillColor: ColorCodes.lightGreyWebColor,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            setState(() {
                              on = S.of(context).please_enter_owner_name;//"  Please enter owner Name";
                            });
                            return '';
                          }
                          setState(() {
                            on = "";
                          });
                          return null;
                        },
                        onSaved: (value) {
                          //addEmailToSF(value);
                        },
                      ),
                      if(Features.btobModule)
                      SizedBox(height: 10.0),
                      if(Features.btobModule)
                      Text(
                        on,
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.red),
                      ),
                      if(Features.btobModule)
                      SizedBox(height: 5.0),
                      if(Features.btobModule)
                      Text(
                        S.of(context).pin_code,//'PinCode',
                        // 'Mobile number',
                        style: TextStyle(fontSize: 17, color: ColorCodes.lightBlack),
                      ),
                      if(Features.btobModule)
                      SizedBox(height: 10),
                      if(Features.btobModule)
                      TextFormField(
                        //  enabled: false,
                        textAlign: TextAlign.left,
                        keyboardType: TextInputType.number,
                        controller: _pincontroller,
                        style: new TextStyle(
                            decorationColor: Theme.of(context).primaryColor),
                        inputFormatters: [LengthLimitingTextInputFormatter(12)],
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding:
                          EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                          hintText:S.of(context).enter_pincode,//'Enter Pincode',
                          fillColor: ColorCodes.lightGreyWebColor,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            setState(() {
                              pn = S.of(context).please_enter_pincode;//"  Please Pincode";
                            });
                            return '';
                          }
                          setState(() {
                            pn = "";
                          });
                          return null;
                        },
                        onSaved: (value) {
                          //addEmailToSF(value);
                        },
                      ),
                      if(Features.btobModule)
                      SizedBox(height: 10.0),
                      if(Features.btobModule)
                      Text(
                        pn,
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.red),
                      ),
                      if(Features.btobModule)
                      SizedBox(height: 5.0),
                      if(Features.btobModule)
                      Text(
                        S.of(context).gst_id,//'Gst Id',
                        // 'Mobile number',
                        style: TextStyle(fontSize: 17, color: ColorCodes.lightBlack),
                      ),
                      if(Features.btobModule)
                      SizedBox(height: 10),
                      if(Features.btobModule)
                      TextFormField(
                        // enabled: false,
                        textAlign: TextAlign.left,
                        keyboardType: TextInputType.number,
                        controller: _gstcontroller,
                        style: new TextStyle(
                            decorationColor: Theme.of(context).primaryColor),
                        inputFormatters: [LengthLimitingTextInputFormatter(12)],
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding:
                          EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                          hintText: S.of(context).enter_gst,//'Enter Gst No',
                          fillColor: ColorCodes.lightGreyWebColor,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            setState(() {
                              gs = S.of(context).please_enter_gst;//"  Please Gst No";
                            });
                            return '';
                          }
                          setState(() {
                            gs = "";
                          });
                          return null;
                        },
                        onSaved: (value) {
                          //addEmailToSF(value);
                        },
                      ),
                      if(Features.btobModule)
                      SizedBox(height: 10.0),
                      if(Features.btobModule)
                      Text(
                        gs,
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.red),
                      ),


                      if(!Features.btobModule)
                      SizedBox(height: 10),
                      if(!Features.btobModule)
                      // Text(
                      //   S .of(context).what_should_we_call_you,
                      //  // '* What should we call you?',
                      //   style: TextStyle(fontSize: 17, color: ColorCodes.lightBlack),
                      // ),
                      // if(!Features.btobModule)
                      // SizedBox(height: 10),
                      if(!Features.btobModule)
                      Container(
                        height: MediaQuery.of(context).size.height / 15,//52.0,
                        child: TextFormField(
                          textAlign: TextAlign.left,
                          controller: firstnamecontroller,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(20.0),
                            labelText: S .of(context).what_should_we_call_you,
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
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_lnameFocusNode);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              setState(() {
                                fn = S.of(context).please_enter_name;//"  Please enter name";
                              });
                              return '';
                            }
                            setState(() {
                              fn = "";
                            });
                            return null;
                          },
                          onSaved: (value) {
                            //addFirstnameToSF(value);
                          },
                        ),
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
                      //   S .of(context).mobile_number,
                      //   // 'Mobile number',
                      //   style: TextStyle(fontSize: 17, color: ColorCodes.lightBlack),
                      // ),
                      // if(!Features.btobModule)
                      // SizedBox(height: 10),
                      if(!Features.btobModule)
                      Container(
                        height: MediaQuery.of(context).size.height / 15,//52.0,
                        child: TextFormField(
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.number,
                          controller: mobileNumberController,
                          style: new TextStyle(
                              decorationColor: Theme.of(context).primaryColor),
                          inputFormatters: [LengthLimitingTextInputFormatter(12)],
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(20.0),
                            fillColor: ColorCodes.grey,
                            labelText: S .of(context).mobile_number,
                            labelStyle: TextStyle(
                                color: ColorCodes.emailColor,
                                fontSize: 16.0
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                              borderSide: BorderSide(color: ColorCodes.grey),
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
                              borderSide:
                              BorderSide(color: ColorCodes.grey, width: 1.2),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              setState(() {
                                mb = S.of(context).please_enter_your_mobile;//"  Please enter number";
                              });
                              return '';
                            }
                            setState(() {
                              mb = "";
                            });
                            return null;
                          },
                          onSaved: (value) {
                            //addEmailToSF(value);
                          },
                        ),
                      ),
                      if(!Features.btobModule)
                      SizedBox(height: 10.0),
                      if(!Features.btobModule)
                      Text(
                        mb,
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.red),
                      ),
                      if(!Features.btobModule)
                      SizedBox(height: 10.0),
                      // if(!Features.btobModule)
                      // Text(
                      //   S .of(context).tell_us_your_email,
                      //   // 'Tell us your e-mail',
                      //   style: TextStyle(fontSize: 17, color: ColorCodes.lightBlack),
                      // ),
                      // if(!Features.btobModule)
                      // SizedBox(
                      //   height: 10.0,
                      // ),
                      if(!Features.btobModule)
                      Container(
                        height: MediaQuery.of(context).size.height / 15,//52.0,
                        child: TextFormField(
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          style: new TextStyle(
                              decorationColor: Theme.of(context).primaryColor),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(20.0),
                            labelText: S.of(context).tell_us_your_email,
                            labelStyle: TextStyle(
                                color: ColorCodes.emailColor,
                                fontSize: 16.0
                            ),
                            fillColor: ColorCodes.grey,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                              borderSide: BorderSide(color: ColorCodes.grey),
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
                              borderSide:
                              BorderSide(color: ColorCodes.grey, width: 1.2),
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
                                ea = S.of(context).please_enter_valid_email_address;//' Please enter a valid email address';
                              });
                              return '';
                            }
                            setState(() {
                              ea = "";
                            });
                            return null; //it means user entered a valid input
                          },
                          onSaved: (value) {
                            // addEmailToSF(value);
                          },
                        ),
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
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              if(_isWeb)
                _bottomNavigationBar(),
              SizedBox(height: 30,),
              if(_isWeb && ResponsiveLayout.isSmallScreen(context)) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
            ],

          ),
        ),
    );


  }
gradientappbarmobile() {
  return  AppBar(
    brightness: Brightness.dark,
    toolbarHeight: 60.0,
    elevation: (IConstants.isEnterprise)?0:1,
    automaticallyImplyLeading: false,
    leading: IconButton(icon: Icon(Icons.arrow_back,size: 20, color: ColorCodes.iconColor),onPressed: ()=>
        Navigator.of(context).pop()),
    title: Text(
      S .of(context).edit_info,

      // 'Edit your info',
      style: TextStyle(color: ColorCodes.iconColor, fontWeight: FontWeight.bold, fontSize: 18),
    ),
    titleSpacing: 0,
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
