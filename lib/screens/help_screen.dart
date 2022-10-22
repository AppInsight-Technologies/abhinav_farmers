import 'package:flutter/material.dart';
import 'package:grocbay/models/VxModels/VxStore.dart';
import 'package:velocity_x/velocity_x.dart';
import '../generated/l10n.dart';
import '../constants/features.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

import '../rought_genrator.dart';
import '../widgets/header.dart';
import '../assets/ColorCodes.dart';
import '../constants/IConstants.dart';
import '../screens/customer_support_screen.dart';
import '../utils/prefUtils.dart';
import '../utils/ResponsiveLayout.dart';
import '../widgets/footer.dart';


class HelpScreen extends StatefulWidget {
  static const routeName = '/help-screen';
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> with Navigations{
  bool _isLoading = true;
  //SharedPreferences prefs;
  bool _isWeb = false;
  var _address = "";
  MediaQueryData? queryData;
  double? wid;
  double? maxwid;
  var name = "", email = "", photourl = "", phone = "";
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
      //prefs = await SharedPreferences.getInstance();
      setState(() {
        _isLoading = false;
       /* if (PrefUtils.prefs!.getString('FirstName') != null) {
          if (PrefUtils.prefs!.getString('LastName') != null) {
            name =  PrefUtils.prefs!.getString('FirstName') + " " + PrefUtils.prefs!.getString('LastName');
          } else {
            name =  PrefUtils.prefs!.getString('FirstName');
          }
        } else {
          name = "";
        }*/
        name = store.userData.username!;
        if (PrefUtils.prefs!.getString('Email') != null) {
          email = PrefUtils.prefs!.getString('Email')!;
        } else {
          email = "";
        }

        if (PrefUtils.prefs!.getString('mobile') != null) {
          phone = PrefUtils.prefs!.getString('mobile')!;
        } else {
          phone = "";
        }

      /*  if (PrefUtils.prefs!.getString('photoUrl') != null) {
          photourl = PrefUtils.prefs!.getString('photoUrl')!;
        } else {
          photourl = "";
        }*/
        photourl = store.userData.path!;
      });
    });
    //initPlatformState();
    super.initState();
  }

  /*Future<void> initPlatformState() async {
    SharedPreferences PrefUtils.prefs = await SharedPreferences.getInstance();
    String firstname = PrefUtils.prefs!.getString("FirstName");
    String lastname = PrefUtils.prefs!.getString("LastName");
    String email = PrefUtils.prefs!.getString("Email");
    String countrycode = IConstants.countryCode;
    String phone = PrefUtils.prefs!.getString("mobile");

    var response = await FlutterFreshchat.init(
      appID: "80f986ff-2694-4894-b0c5-5daa836fef5c",
      appKey: "b1f41ae0-f004-43c2-a0a1-79cb4e03658a",
      cameraEnabled: true,
      gallerySelectionEnabled: false,
      teamMemberInfoVisible: false,
      responseExpectationEnabled: false,
      showNotificationBanner: true,
    );
    FreshchatUser user = FreshchatUser.initail();
    user.email = email;
    user.firstName = firstname;
    user.lastName = lastname;
    user.phoneCountryCode = countrycode;
    user.phone = phone;

    await FlutterFreshchat.updateUserInfo(user: user);
    // Custom properties can be set by creating a Map<String, String>
    Map<String, String> customProperties = Map<String, String>();
    customProperties["loggedIn"] = "true";

    await FlutterFreshchat.updateUserInfo(user: user, customProperties: customProperties);



    //await FlutterFreshchat.updateUserInfo(user: FreshchatUser);
  }*/

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    wid= queryData!.size.width;
    maxwid=wid!*0.70;
    return  Scaffold(
      appBar: ResponsiveLayout.isSmallScreen(context) ?
      gradientappbarmobile() : null,
      backgroundColor: ColorCodes.whiteColor,
      body:Column(
        children: <Widget>[
          if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
            Header(false),
          _body(),
        ],
      ),
    );
  }
  _body(){
    return _isWeb?_bodyweb():
    _bodymobile();
  }
/*  void launchWhatsapp({required number,required message})async{
    String url ="whatsapp://send?phone=$number&text=$message";
    await canLaunch(url)?launch(url):print('can\'t open whatsapp');
  }*/
  void launchWhatsApp() async {
    String phone = /*"+918618320591"*/(Features.ismultivendor) ? IConstants.secondaryMobileroot : IConstants.secondaryMobile;
    debugPrint("Whatsapp . .. . . .. . .");
    String url() {
      if (Platform.isIOS) {
        debugPrint("Whatsapp1 . .. . . .. . .");
        return "whatsapp://wa.me/$phone/?text=${Uri.parse('I want to order Grocery')}";
      } else {
        return "whatsapp://send?phone=$phone&text=${Uri.parse('I want to order Grocery')}";
        const url = "https://wa.me/?text=YourTextHere";

      }
    }
    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }
  _bodymobile(){
    return    _isLoading ?
    Center(
      child: CircularProgressIndicator(),
    ) :
    Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 30.0,),
            if(Features.isLiveChat)
            GestureDetector(
              onTap: () async {
                //var response = await FlutterFreshchat.showConversations();
              /*  Navigator.of(context).pushNamed(
                    CustomerSupportScreen.routeName,
                    arguments: {
                      'name' : name,
                      'email' : email,
                      'photourl': photourl,
                      'phone' : phone,
                    }
                );*/
                Navigation(context, name:Routename.CustomerSupport,navigatore: NavigatoreTyp.Push,
                   /* parms:{'photourl': photourl}*/);
              },
              child: Row(
                children: <Widget>[
                  SizedBox(width: 10.0,),
                  Text(
                    S .of(context).chat,
                    // "Chat",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                  Spacer(),
                  Icon(Icons.keyboard_arrow_right, color: Colors.grey,),
                  SizedBox(width: 5.0,),
                ],
              ),
            ),
            if(Features.isLiveChat)
            SizedBox(height: 5.0,),
            if(Features.isLiveChat)
            Divider(),

            if(Features.isWhatsapp)
              GestureDetector(
                onTap: () async {
                  //var response = await FlutterFreshchat.showConversations();
                  // Navigator.of(context).pushNamed(
                  //     CustomerSupportScreen.routeName,
                  //     arguments: {
                  //       'name' : name,
                  //       'email' : email,
                  //       'photourl': photourl,
                  //       'phone' : phone,
                  //     }
                  // );

                //  launchWhatsapp(number: IConstants.countryCode + IConstants.secondaryMobile, message:"I want to order Grocery");
                  launchWhatsApp();
                },
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 10.0,),
                    Text(
                      S .of(context).whatsapp_chat,
                      // "Whatsapp Chat",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_right, color: Colors.grey,),
                    SizedBox(width: 5.0,),
                  ],
                ),
              ),
            if(Features.isWhatsapp)
              SizedBox(height: 5.0,),
            if(Features.isWhatsapp)
              Divider(),

            SizedBox(height: 5.0,),
            Row(
              children: <Widget>[
                SizedBox(width: 10.0,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      S .of(context).call,
                      // "Call",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                    SizedBox(height: 5.0,),
                    Text(IConstants.primaryMobile, style: TextStyle(fontSize: 14.0),),
                  ],
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    launch("tel: " + IConstants.primaryMobile);
                  },
                  child: Icon(Icons.call, color: Theme.of(context).primaryColor, size: 30.0,),
                ),
                SizedBox(width: 10.0,),
              ],
            ),
            SizedBox(height: 5.0,),
            Divider(),
            SizedBox(height: 5.0,),
            Row(
              children: <Widget>[
                SizedBox(width: 10.0,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      S .of(context).email,
                      // "Email",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                    SizedBox(height: 5.0,),
                    Text(IConstants.primaryEmail, style: TextStyle(fontSize: 14.0),),
                    SizedBox(height: 5.0,),
                    Text(IConstants.secondaryEmail, style: TextStyle(fontSize: 14.0),),
                  ],
                ),
                SizedBox(width: 5.0,),

              ],
            ),
            if(_isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
          ],
        ),
      ),
    );


  }
  _bodyweb(){
    return    Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              constraints: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid!):null,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 30.0,),
                  GestureDetector(
                    onTap: () async {
                      //var response = await FlutterFreshchat.showConversations();
                    /*  Navigator.of(context).pushNamed(
                          CustomerSupportScreen.routeName,
                          arguments: {
                            'name' : name,
                            'email' : email,
                            'photourl': photourl,
                            'phone' : phone,
                          }
                      );*/
                      Navigation(context, name:Routename.CustomerSupport,navigatore: NavigatoreTyp.Push,
                          /*parms:{'photourl': photourl}*/);
                    },
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 10.0,),
                        Text(
                          S .of(context).chat,
                          // "Chat",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                        Spacer(),
                        Icon(Icons.keyboard_arrow_right, color: Colors.grey,),
                        SizedBox(width: 5.0,),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.0,),
                  Divider(),
                  SizedBox(height: 5.0,),
                  Row(
                    children: <Widget>[
                      SizedBox(width: 10.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            S .of(context).call,
                            // "Call",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                          SizedBox(height: 5.0,),
                          Text(IConstants.primaryMobile, style: TextStyle(fontSize: 14.0),),
                        ],
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          launch("tel: " + IConstants.primaryMobile);
                        },
                        child: Icon(Icons.call, color: Theme.of(context).primaryColor, size: 30.0,),
                      ),
                      SizedBox(width: 10.0,),
                    ],
                  ),
                  SizedBox(height: 5.0,),
                  Divider(),
                  SizedBox(height: 5.0,),
                  Row(
                    children: <Widget>[
                      SizedBox(width: 10.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            S .of(context).email,
                            // "Email",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                          SizedBox(height: 5.0,),
                          Text(IConstants.primaryEmail, style: TextStyle(fontSize: 14.0),),
                          SizedBox(height: 5.0,),
                          Text(IConstants.secondaryEmail, style: TextStyle(fontSize: 14.0),),
                        ],
                      ),
                      SizedBox(height: 30,),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30,),
            if(_isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!)
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
        S .of(context).help,
        // 'Help',
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
