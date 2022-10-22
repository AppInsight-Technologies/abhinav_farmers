import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../assets/ColorCodes.dart';
import '../../assets/images.dart';
import '../../constants/IConstants.dart';
import '../../constants/features.dart';
import '../../controller/mutations/home_screen_mutation.dart';
import '../../controller/payment/payment_contoller.dart';
import '../../generated/l10n.dart';
import '../../models/VxModels/VxStore.dart';
import '../../providers/branditems.dart';
import '../../repository/authenticate/AuthRepo.dart';
import '../../rought_genrator.dart';
import '../../screens/customer_support_screen.dart';
import '../../screens/membership_screen.dart';
import '../../utils/ResponsiveLayout.dart';
import '../../utils/prefUtils.dart';
import '../StoreBottomNavigationWidget.dart';
import '../simmers/loyality_wallet_shimmer.dart';


class WalletComponent extends StatefulWidget {
  Map<String, String>? wallet;
  String? type = "";
  String? fromScreen = "";
   WalletComponent(this.type,this.fromScreen);

  @override
  State<WalletComponent> createState() => _WalletComponentState();
}

class _WalletComponentState extends State<WalletComponent> with Navigations{
  bool _isloading = true;
  bool _iswalletbalance = true;
  bool _iswalletlogs = true;
  var walletbalance = "0";
  bool notransaction = true;
  bool checkskip = false;
  var _address = "";
  late MediaQueryData queryData;
  late double wid;
  late double maxwid;
  String? screen= "";
  bool iphonex = false;
  var photourl = "";
  GroceStore store = VxState.store;
  TextEditingController? moneycontroller;
  String? money="";
  bool amount100selected = false;
  bool amount500selected = false;
  bool amount1000selected = false;
  bool amount2000selected = false;
  final payment = Payment();

  @override
  void initState() {
    moneycontroller = new TextEditingController();
    Future.delayed(Duration.zero, () async {
      _address = PrefUtils.prefs!.getString("restaurant_address")!;
      setState(() {
        if (!PrefUtils.prefs!.containsKey("apikey")) {
          checkskip = true;
        } else {
          checkskip = false;
        }
      });

      setState(() {
        _iswalletbalance = false;
        auth.getuserProfile(onsucsess: (value){
          HomeScreenController(user: PrefUtils.prefs!.getString("apikey") ?? PrefUtils.prefs!.getString("tokenid"),
            branch: PrefUtils.prefs!.getString("branch") ?? "999", rows: "0",);
          if (widget.type == "wallet")
            setState(() {
              walletbalance = (VxState.store as GroceStore).prepaid.prepaid.toString();
            });
          else if (widget.type == "subscribedwallet")
            setState(() {
              walletbalance = (VxState.store as GroceStore).prepaid.subscriptionPrepaid.toString();
            });
          else
            setState(() {
              walletbalance = (VxState.store as GroceStore).prepaid.loyalty.toString();
            });

        }, onerror: (){
        });

      });
      Provider.of<BrandItemsList>(context,listen: false).fetchWalletLogs(widget.type.toString()).then((_) {
        setState(() {
          _iswalletlogs = false;
        });
      });
      moneycontroller = TextEditingController(text: "");
    });
    super.initState();
  }

  void launchWhatsApp() async {
    String phone = IConstants.secondaryMobile;
    String url() {
      if (Platform.isIOS) {
        return "whatsapp://wa.me/$phone/?text=${Uri.parse('I want to order Grocery')}";
      } else {
        return "whatsapp://send?phone=$phone&text=${Uri.parse('I want to order Grocery')}";
      }
    }
    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }
  @override
  Widget build(BuildContext context) {

    bottomNavigationbar() {
      return SingleChildScrollView(
        child: Container(
          height: 65,
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: ColorCodes.primaryColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigation(context, navigatore: NavigatoreTyp.homenav);
                },
                child: Container(
                  width: 60,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 8.0,
                      ),
                      CircleAvatar(
                        maxRadius: 13.0,
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.transparent,
                        child: Image.asset(
                          Images.homeImg,
                          color: ColorCodes.whiteColor,
                          width: 30,
                          height: 25,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(S .of(context).home,
                          style: TextStyle(
                              color: ColorCodes.whiteColor, fontSize: 10.0)),
                      SizedBox(
                        height: 8.0,
                      ),
                    ],
                  ),
                ),
              ),
              if(Features.isCategory)
                Spacer(),
              if(Features.isCategory)
                GestureDetector(
                  onTap: () {
                    Navigation(context, name:Routename.Category, navigatore: NavigatoreTyp.Push);
                  },
                  child: Container(
                    width: 60,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 8.0,
                        ),
                        CircleAvatar(
                          radius: 13.0,
                          backgroundColor: Colors.transparent,
                          child: Image.asset(Images.categoriesImg,
                            color: ColorCodes.whiteColor,
                            width: 20,
                            height: 25,),

                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(S .of(context).categories,
                            style: TextStyle(
                                color: ColorCodes.whiteColor, fontSize: 10.0)),
                        SizedBox(
                          height: 8.0,
                        ),
                      ],
                    ),
                  ),
                ),
              if(Features.isWallet)
                Spacer(),
              if(Features.isWallet)
                Container(
                  width: 60,
                  child: Column(
                    children: <Widget>[

                      SizedBox(
                        height: 8.0,
                      ),
                      CircleAvatar(
                          maxRadius: 13.0,
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.transparent,
                          child: Image.asset(Images.walletImg,
                            //  color: ColorCodes.greenColor,
                            color:IConstants.isEnterprise?ColorCodes.badgecolor:ColorCodes.maphome,
                            width: 20,
                            height: 25,)
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text((widget.type == "wallet") ? S .of(context).wallet : S .of(context).loyalty,
                          style: TextStyle(
                              color:IConstants.isEnterprise?ColorCodes.badgecolor:ColorCodes.maphome,
                              //color: ColorCodes.greenColor,
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 8.0,
                      ),
                    ],
                  ),
                ),
              if(Features.isMembership)
                Spacer(),
              if(Features.isMembership)
                GestureDetector(
                  onTap: () {
                    checkskip
                        ?
                    Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                        :
                      (Vx.isWeb &&
                      !ResponsiveLayout.isSmallScreen(context))?
                      MembershipInfo(context):
                    Navigation(context, name: Routename.Membership, navigatore: NavigatoreTyp.Push);
                  },
                  child: Container(
                    width: 60,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 8.0,
                        ),
                        CircleAvatar(
                          radius: 13.0,
                          backgroundColor: Colors.transparent,
                          child: Image.asset(
                            Images.bottomnavMembershipImg,
                            color: ColorCodes.whiteColor,
                            width: 20,
                            height: 25,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(S .of(context).membership,
                            style: TextStyle(
                                color: ColorCodes.whiteColor, fontSize: 10.0)),
                        SizedBox(
                          height: 8.0,
                        ),
                      ],
                    ),
                  ),
                ),
              if(!Features.isMembership)
                Spacer(),
              if(!Features.isMembership)
                GestureDetector(
                  onTap: () {
                    checkskip
                        ?
                    Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                        :
                    Navigation(context, name:Routename.MyOrders,navigatore: NavigatoreTyp.Push);
                  },
                  child: Container(
                    width: 60,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 8.0,
                        ),
                        CircleAvatar(
                          radius: 13.0,
                          backgroundColor: Colors.transparent,
                          child: Image.asset(
                            Images.bag,
                            color: ColorCodes.whiteColor,
                            width: 20,
                            height: 25,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(S .of(context).my_orders,
                            style: TextStyle(
                                color: ColorCodes.whiteColor, fontSize: 10.0)),
                        SizedBox(
                          height: 8.0,
                        ),
                      ],
                    ),
                  ),
                ),
              if(Features.isShoppingList)
                Spacer(flex: 1),
              if(Features.isShoppingList)
                GestureDetector(
                  onTap: () {
                    checkskip
                        ?
                    Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                        :
                    Navigation(context, name: Routename.Shoppinglist, navigatore: NavigatoreTyp.Push);
                  },
                  child: Container(
                    width: 60,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 8.0,
                        ),
                        CircleAvatar(
                          radius: 13.0,
                          backgroundColor: Colors.transparent,
                          child: Image.asset(Images.shoppinglistsImg,
                            width: 18,
                            height: 25,
                            color: ColorCodes.whiteColor,),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(S .of(context).shopping_list,
                            style: TextStyle(
                                color: ColorCodes.whiteColor, fontSize: 10.0)),
                        SizedBox(
                          height: 8.0,
                        ),
                      ],
                    ),
                  ),
                ),
              if(!Features.isShoppingList)
                Spacer(),
              if(!Features.isShoppingList)
                GestureDetector(
                  onTap: () {
                    checkskip && Features.isLiveChat
                        ?
                    Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                        : (Features.isLiveChat && Features.isWhatsapp)?
                    Navigator.of(context).pushNamed(CustomerSupportScreen.routeName, arguments: {
                      'name': store.userData.username!,
                      'email': store.userData.email!,
                      'photourl': photourl,
                      'phone': store.userData.mobileNumber,
                    }):
                    (!Features.isLiveChat && !Features.isWhatsapp)?
                    Navigation(context, navigatore: NavigatoreTyp.Push,name: Routename.search):
                    Features.isWhatsapp?launchWhatsApp():
                    Navigator.of(context)
                        .pushNamed(CustomerSupportScreen.routeName, arguments: {
                      'name': store.userData.username!,
                      'email': store.userData.email!,
                      'photourl': photourl,
                      'phone': store.userData.mobileNumber,
                    });
                  },
                  child: Container(
                    width: 60,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 8.0,
                        ),
                        CircleAvatar(
                          radius: 13.0,
                          backgroundColor: Colors.transparent,
                          child: (!Features.isLiveChat && !Features.isWhatsapp)?
                          Icon(
                            Icons.search,
                            color: ColorCodes.whiteColor,
                          )
                              :
                          Image.asset(
                            Features.isLiveChat?Images.chat: Images.whatsapp,
                            width: 20,
                            height: 25,
                            color: Features.isLiveChat?ColorCodes.whiteColor:ColorCodes.whiteColor,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text((!Features.isLiveChat && !Features.isWhatsapp)? S .of(context).search : S .of(context).chat,
                            style: TextStyle(
                                color: ColorCodes.whiteColor, fontSize: 10.0)),
                        SizedBox(
                          height: 8.0,
                        ),
                      ],
                    ),
                  ),
                ),
              Spacer(),
            ],
          ),
        ),
      );
    }

    if (!_iswalletbalance && !_iswalletlogs) {
      _isloading = false;
    }
    final walletData = Provider.of<BrandItemsList>(context,listen: false);
    if (walletData.itemswallet.length <= 0) {
      notransaction = true;
    } else {
      notransaction = false;
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
              if (screen=="pushNotification")
              {
                Navigation(context, navigatore: NavigatoreTyp.homenav);
              }
              else if(screen == "notification"){
                Navigation(context, navigatore: NavigatoreTyp.homenav);
                return Future.value(false);
              }
              else {
                Navigation(context, navigatore: NavigatoreTyp.homenav);
              }
              return Future.value(false);
            }
        ),
        titleSpacing: 0,
        title: Text((widget.type == "wallet") ? S .of(context).wallet :(widget.type == "subscribedwallet")? S .of(context).wallet :S .of(context).loyalty,
          style: TextStyle(color: ColorCodes.iconColor, fontWeight: FontWeight.bold, fontSize: 18),),
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
    Widget _bodyMobile(){
      return Scaffold(
        backgroundColor: Colors.white,
        body:
        SingleChildScrollView(
            child:Column(
              children: [
                _isloading
                    ? (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))? Center(
                  child: LoyalityorWalletShimmer(),
                ): Center(
                  child: LoyalityorWalletShimmer(),
                )
                    : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Container(
                        margin: EdgeInsets.only(
                            left: 15.0, bottom: 10.0, right: 15.0,top: 10),
                        padding: EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(3.0),
                          //border: Border.all(width: 0.0, color: ColorCodes.whiteColor),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                (widget.type == "wallet")
                                    ?
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      Images.WalletNewImg,
                                      width: 60,
                                      height: 90,
                                    ),
                                    SizedBox(width: 20,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          S .of(context).wallet_balance,
                                          style: TextStyle(
                                            fontSize: 13.0,
                                            color: ColorCodes.emailColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 3,),
                                        Text(
                                          Features.iscurrencyformatalign?
                                          double.parse(/*walletbalance*/(VxState.store as GroceStore).prepaid.prepaid.toString()).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + " " + IConstants.currencyFormat:
                                          IConstants.currencyFormat + " " + double.parse(/*walletbalance*/(VxState.store as GroceStore).prepaid.prepaid.toString()).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    )

                                  ],
                                )
                                    : (widget.type == "subscribedwallet")
                                    ?
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      Images.WalletNewImg,
                                      width: 80,
                                      height: 90,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          S .of(context).wallet_balance,
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: ColorCodes.greyColor,
                                          ),
                                        ),
                                        Text(
                                          Features.iscurrencyformatalign?
                                          double.parse(/*walletbalance*/(VxState.store as GroceStore).prepaid.subscriptionPrepaid.toString()).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + " " + IConstants.currencyFormat:
                                          IConstants.currencyFormat + " " + double.parse(/*walletbalance*/(VxState.store as GroceStore).prepaid.subscriptionPrepaid.toString()).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 25.0,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    )

                                  ],
                                )
                                    :Row(
                                  children: <Widget>[
                                    Image.asset(
                                      Images.coinImg,
                                      width: 35.0,
                                      height: 35.0,
                                      alignment: Alignment.center,
                                    ),

                                    SizedBox(
                                      width: 15.0,
                                    ),
                                    (widget.type == "wallet" || widget.type == "subscribedwallet")
                                        ? SizedBox.shrink()
                                        : Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          S .of(context).available_points,
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: ColorCodes.emailColor,
                                          ),
                                        ),
                                        SizedBox(height: 2,),
                                        Text(
                                          double.parse(/*walletbalance*/(VxState.store as GroceStore).prepaid.loyalty.toString()).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                          style: TextStyle(
                                              fontSize: 28.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 100.0,
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                      if(widget.type == 'wallet' || widget.type == "subscibedwallet")Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(S.of(context).add_money,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 16),),
                      ),
                      if (widget.type == 'wallet' || widget.type == "subscibedwallet")Container(
                          margin: EdgeInsets.only(left: 15, right: 15, bottom: 20.0),
                          padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3.0),
                            //border: Border.all(width: 0.0, color: ColorCodes.whiteColor),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: Offset(0, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          child:Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: moneycontroller,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(fontWeight: FontWeight.normal,color:Colors.grey),
                                    hintText: Features.iscurrencyformatalign?
                                    double.parse(/*walletbalance*/(VxState.store as GroceStore).prepaid.prepaid.toString()).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + " " + IConstants.currencyFormat:
                                    IConstants.currencyFormat + " " + double.parse(/*walletbalance*/(VxState.store as GroceStore).prepaid.prepaid.toString()).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      money = value;
                                      amount100selected = false;
                                      amount500selected = false;
                                      amount1000selected = false;
                                      amount2000selected = false;
                                    });

                                  },
                                ),
                              ),
                              Row(
                                children: [

                                  Padding(
                                    padding: const EdgeInsets.only(left:4.0,right:4.0),
                                    child: GestureDetector(onTap: (){
                                      setState(() {
                                        amount100selected = true;
                                        amount500selected = false;
                                        amount1000selected = false;
                                        amount2000selected = false;
                                        money="100";
                                        moneycontroller!.text = money!;
                                      });
                                    },

                                        child:  Container(
                                          padding:EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                              color:amount100selected==true?ColorCodes.varcolor:Colors.white,
                                              border: Border.all(color:amount100selected==true?ColorCodes.primaryColor:Colors.grey.shade200 )
                                          ),

                                          child: Text(
                                            "+"+IConstants.currencyFormat + "100",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left:4.0,right:4.0),
                                    child: GestureDetector(onTap: (){
                                      setState(() {
                                        amount100selected = false;
                                        amount500selected = true;
                                        amount1000selected = false;
                                        amount2000selected = false;
                                        money="500";
                                        moneycontroller!.text = money!;
                                      });
                                    },
                                        child:  Container(
                                          padding:const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                              color:amount500selected==true ?ColorCodes.varcolor:Colors.white,
                                              border: Border.all(color:amount500selected==true ?ColorCodes.primaryColor:Colors.grey.shade200 )
                                          ),
                                          child: Text(
                                            "+"+IConstants.currencyFormat + "500",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left:4.0,right:4.0),
                                    child: GestureDetector(onTap: (){
                                      setState(() {
                                        amount100selected = false;
                                        amount500selected = false;
                                        amount1000selected = true;
                                        amount2000selected = false;
                                        money="1000";
                                        moneycontroller!.text = money!;

                                      });
                                    },
                                        child:   Container(
                                          padding:EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                              color:amount1000selected==true?ColorCodes.varcolor:Colors.white,
                                              border: Border.all(color:amount1000selected==true ?ColorCodes.primaryColor:Colors.grey.shade200 )
                                          ),
                                          child: Text(
                                            "+"+IConstants.currencyFormat + "1000",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left:4.0,right:4.0),
                                    child: GestureDetector(onTap: (){
                                      setState(() {
                                        amount100selected = false;
                                        amount500selected = false;
                                        amount1000selected = false;
                                        amount2000selected = true;
                                        money="2000";
                                        moneycontroller!.text = money!;
                                      });
                                    },
                                        child:   Container(
                                          padding:EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                              color:amount2000selected ?ColorCodes.varcolor:Colors.white,
                                              border: Border.all(color:amount2000selected==true ?ColorCodes.primaryColor:Colors.grey.shade200 )
                                          ),
                                          child: Text(
                                            "+"+IConstants.currencyFormat + "2000",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                    ),
                                  )

                                ],
                              ),
                              Container(
                                height: 60,
                                padding:EdgeInsets.all(8.0),
                                width:MediaQuery.of(context).size.width,
                                child: MaterialButton(onPressed: ()async {
                                  if(money.toString() == "" || money.toString() == null || money.toString() == "0"){
                                    Fluttertoast.showToast(
                                        msg: "Please add the amount",//"Sign in failed!",
                                        fontSize: 12,
                                        backgroundColor: ColorCodes.blackColor,
                                        textColor: ColorCodes.whiteColor);
                                  }
                                  else{
                                    var timestamp;
                                    timestamp = new DateTime.now().microsecondsSinceEpoch;
                                    await payment.startPaytmTransaction(context, false,
                                        orderId:timestamp.toString(),
                                        username: PrefUtils.prefs!.getString('userID'),
                                        amount: money,
                                        routeArgs: /* routeArgs*/null,
                                        prev: "WalletScreen"
                                    );
                                  }
                                },
                                    color: ColorCodes.primaryColor,
                                    child:Text(S.of(context).add_money,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                              )

                            ],
                          )
                      ),
                      notransaction
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Align(
                            child: Image.asset(
                              (widget.type == 'wallet' || widget.type == "subscibedwallet")?Images.walletTransImg
                                  :Images.loyaltyImg,
                              width: 232.0,
                              height: 168.0,
                              alignment: Alignment.center,
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            S .of(context).there_is_no_transaction,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 19.0,
                                color: ColorCodes.greyColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                          :SizedBox(
                          height: MediaQuery.of(context).size.height/1.5,
                          child:new ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: walletData.itemswallet.length,
                            itemBuilder: (_, i) => Container(
                              padding:EdgeInsets.all(8.0),
                              color:Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 10.0,
                                      ),

                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            walletData.itemswallet[i].title!,
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Text(
                                            //new DateFormat.yMMMMd('en_US').format(new DateFormat("yyyy-MM-dd", "en_US").parse( walletData.itemswallet[i].date!)).toString() + " | " + walletData.itemswallet[i].time!,
                                            DateFormat.yMMMMd('en_US').format(DateFormat("dd-MM-yyyy", "en_US").parse( walletData.itemswallet[i].date!)).toString() + " | " + walletData.itemswallet[i].time!,

                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                          )

                                        ],
                                      ),
                                      Spacer(),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[


                                          Text(
                                              walletData.itemswallet[i].amount!,
                                              style: TextStyle(color:ColorCodes.primaryColor,fontWeight: FontWeight.bold,fontSize: 18)
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          (widget.type == "wallet")
                                              ?
                                          SizedBox.shrink()
                                              :
                                          Text(
                                            S .of(context).total_points +
                                                double.parse(walletData.itemswallet[i]
                                                    .closingbalance!).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 12.0),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 10.0,
                                        top: 10.0,
                                        right: 10.0,
                                        bottom: 10.0),
                                    child: Text(
                                      walletData.itemswallet[i].note!,
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 12.0),
                                    ),
                                  ),
                                  Divider(
                                    color: ColorCodes.emailColor,
                                  ),
                                ],
                              ),
                            ),
                          )
                      ) ,
                    ]
                )
              ],
            )
        ),
      );


    }
    Widget  _bodyWeb(){
      return Expanded(
          child: SingleChildScrollView(
              child:Container(
                color: ColorCodes.whiteColor,
                child: Column(
                  children: [
                    _isloading
                        ? (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))? Center(
                      child: LoyalityorWalletShimmer(),
                    ): Center(
                      child: LoyalityorWalletShimmer(),
                    )
                        : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          Container(
                            margin: EdgeInsets.only(
                                left: 15.0, bottom: 10.0, right: 15.0,top: 10),
                            padding: EdgeInsets.only(left: 20, right: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3.0),
                              //border: Border.all(width: 0.0, color: ColorCodes.whiteColor),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: Offset(0, 1), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    (widget.type == "wallet")
                                        ?
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          Images.WalletNewImg,
                                          width: 60,
                                          height: 90,
                                        ),
                                        SizedBox(width: 20,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              S .of(context).wallet_balance,
                                              style: TextStyle(
                                                fontSize: 13.0,
                                                color: ColorCodes.emailColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 3,),
                                            Text(
                                              Features.iscurrencyformatalign?
                                              double.parse(/*walletbalance*/(VxState.store as GroceStore).prepaid.prepaid.toString()).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + " " + IConstants.currencyFormat:
                                              IConstants.currencyFormat + " " + double.parse(/*walletbalance*/(VxState.store as GroceStore).prepaid.prepaid.toString()).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 22.0,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        )

                                      ],
                                    )
                                        : (widget.type == "subscribedwallet")
                                        ?
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          Images.WalletNewImg,
                                          width: 80,
                                          height: 90,
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              S .of(context).wallet_balance,
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                color: ColorCodes.greyColor,
                                              ),
                                            ),
                                            Text(
                                              Features.iscurrencyformatalign?
                                              double.parse(/*walletbalance*/(VxState.store as GroceStore).prepaid.subscriptionPrepaid.toString()).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + " " + IConstants.currencyFormat:
                                              IConstants.currencyFormat + " " + double.parse(/*walletbalance*/(VxState.store as GroceStore).prepaid.subscriptionPrepaid.toString()).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 25.0,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        )

                                      ],
                                    )
                                        :Row(
                                      children: <Widget>[
                                        Image.asset(
                                          Images.coinImg,
                                          width: 35.0,
                                          height: 35.0,
                                          alignment: Alignment.center,
                                        ),

                                        SizedBox(
                                          width: 15.0,
                                        ),
                                        (widget.type == "wallet" || widget.type == "subscribedwallet")
                                            ? SizedBox.shrink()
                                            : Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              S .of(context).available_points,
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: ColorCodes.emailColor,
                                              ),
                                            ),
                                            SizedBox(height: 2,),
                                            Text(
                                              double.parse(/*walletbalance*/(VxState.store as GroceStore).prepaid.loyalty.toString()).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                              style: TextStyle(
                                                  fontSize: 28.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 100.0,
                                ),
                                Divider(),
                              ],
                            ),
                          ),
                          if(widget.type == 'wallet' || widget.type == "subscibedwallet")Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(S.of(context).add_money,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 16),),
                          ),
                          if (widget.type == 'wallet' || widget.type == "subscibedwallet")Container(
                              margin: EdgeInsets.only(left: 15, right: 15, bottom: 20.0),
                              padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(3.0),
                                //border: Border.all(width: 0.0, color: ColorCodes.whiteColor),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: Offset(0, 1), // changes position of shadow
                                  ),
                                ],
                              ),
                              child:Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: moneycontroller,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintStyle: TextStyle(fontWeight: FontWeight.normal,color:Colors.grey),
                                        hintText: Features.iscurrencyformatalign?
                                        double.parse(/*walletbalance*/(VxState.store as GroceStore).prepaid.prepaid.toString()).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + " " + IConstants.currencyFormat:
                                        IConstants.currencyFormat + " " + double.parse(/*walletbalance*/(VxState.store as GroceStore).prepaid.prepaid.toString()).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                      ),
                                      onChanged: (value){
                                        setState(() {
                                          money = value;
                                          amount100selected = false;
                                          amount500selected = false;
                                          amount1000selected = false;
                                          amount2000selected = false;
                                        });

                                      },
                                    ),
                                  ),
                                  Row(
                                    children: [

                                      Padding(
                                        padding: const EdgeInsets.only(left:4.0,right:4.0),
                                        child: GestureDetector(onTap: (){
                                          setState(() {
                                            amount100selected = true;
                                            amount500selected = false;
                                            amount1000selected = false;
                                            amount2000selected = false;
                                            money="100";
                                            moneycontroller!.text = money!;
                                          });
                                        },

                                            child:  Container(
                                              padding:EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                  color:amount100selected==true?ColorCodes.varcolor:Colors.white,
                                                  border: Border.all(color:amount100selected==true?ColorCodes.primaryColor:Colors.grey.shade200 )
                                              ),

                                              child: Text(
                                                "+"+IConstants.currencyFormat + "100",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 13.0,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            )
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left:4.0,right:4.0),
                                        child: GestureDetector(onTap: (){
                                          setState(() {
                                            amount100selected = false;
                                            amount500selected = true;
                                            amount1000selected = false;
                                            amount2000selected = false;
                                            money="500";
                                            moneycontroller!.text = money!;
                                          });
                                        },
                                            child:  Container(
                                              padding:const EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                  color:amount500selected==true ?ColorCodes.varcolor:Colors.white,
                                                  border: Border.all(color:amount500selected==true ?ColorCodes.primaryColor:Colors.grey.shade200 )
                                              ),
                                              child: Text(
                                                "+"+IConstants.currencyFormat + "500",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 13.0,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            )
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left:4.0,right:4.0),
                                        child: GestureDetector(onTap: (){
                                          setState(() {
                                            amount100selected = false;
                                            amount500selected = false;
                                            amount1000selected = true;
                                            amount2000selected = false;
                                            money="1000";
                                            moneycontroller!.text = money!;

                                          });
                                        },
                                            child:   Container(
                                              padding:EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                  color:amount1000selected==true?ColorCodes.varcolor:Colors.white,
                                                  border: Border.all(color:amount1000selected==true ?ColorCodes.primaryColor:Colors.grey.shade200 )
                                              ),
                                              child: Text(
                                                "+"+IConstants.currencyFormat + "1000",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 13.0,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            )
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left:4.0,right:4.0),
                                        child: GestureDetector(onTap: (){
                                          setState(() {
                                            amount100selected = false;
                                            amount500selected = false;
                                            amount1000selected = false;
                                            amount2000selected = true;
                                            money="2000";
                                            moneycontroller!.text = money!;
                                          });
                                        },
                                            child:   Container(
                                              padding:EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                  color:amount2000selected ?ColorCodes.varcolor:Colors.white,
                                                  border: Border.all(color:amount2000selected==true ?ColorCodes.primaryColor:Colors.grey.shade200 )
                                              ),
                                              child: Text(
                                                "+"+IConstants.currencyFormat + "2000",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 13.0,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            )
                                        ),
                                      )

                                    ],
                                  ),
                                  Container(
                                    height: 60,
                                    padding:EdgeInsets.all(8.0),
                                    width:MediaQuery.of(context).size.width,
                                    child: MaterialButton(onPressed: ()async {
                                      if(money.toString() == "" || money.toString() == null || money.toString() == "0"){
                                        Fluttertoast.showToast(
                                            msg: "Please add the amount",//"Sign in failed!",
                                            fontSize: 12,
                                            backgroundColor: ColorCodes.blackColor,
                                            textColor: ColorCodes.whiteColor);
                                      }
                                      else{
                                        var timestamp;
                                        timestamp = new DateTime.now().microsecondsSinceEpoch;
                                        await payment.startPaytmTransaction(context, false,
                                            orderId:timestamp.toString(),
                                            username: PrefUtils.prefs!.getString('userID'),
                                            amount: money,
                                            routeArgs: /* routeArgs*/null,
                                            prev: "WalletScreen"
                                        );
                                      }
                                    },
                                        color: ColorCodes.primaryColor,
                                        child:Text(S.of(context).add_money,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                                  )

                                ],
                              )
                          ),
                          notransaction
                              ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Align(
                                child: Image.asset(
                                  (widget.type == 'wallet' || widget.type == "subscibedwallet")?Images.walletTransImg
                                      :Images.loyaltyImg,
                                  width: 232.0,
                                  height: 168.0,
                                  alignment: Alignment.center,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                S .of(context).there_is_no_transaction,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 19.0,
                                    color: ColorCodes.greyColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                              :SizedBox(
                              height: MediaQuery.of(context).size.height/1.5,
                              child:new ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: walletData.itemswallet.length,
                                itemBuilder: (_, i) => Container(
                                  padding:EdgeInsets.all(8.0),
                                  color:Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: <Widget>[
                                          SizedBox(
                                            width: 10.0,
                                          ),

                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                walletData.itemswallet[i].title!,
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Text(
                                                //new DateFormat.yMMMMd('en_US').format(new DateFormat("yyyy-MM-dd", "en_US").parse( walletData.itemswallet[i].date!)).toString() + " | " + walletData.itemswallet[i].time!,
                                                DateFormat.yMMMMd('en_US').format(DateFormat("dd-MM-yyyy", "en_US").parse( walletData.itemswallet[i].date!)).toString() + " | " + walletData.itemswallet[i].time!,

                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                              )

                                            ],
                                          ),
                                          Spacer(),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: <Widget>[


                                              Text(
                                                  walletData.itemswallet[i].amount!,
                                                  style: TextStyle(color:ColorCodes.primaryColor,fontWeight: FontWeight.bold,fontSize: 18)
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              (widget.type == "wallet")
                                                  ?
                                              SizedBox.shrink()
                                                  :
                                              Text(
                                                S .of(context).total_points +
                                                    double.parse(walletData.itemswallet[i]
                                                        .closingbalance!).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 12.0),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 10.0,
                                            top: 10.0,
                                            right: 10.0,
                                            bottom: 10.0),
                                        child: Text(
                                          walletData.itemswallet[i].note!,
                                          style: TextStyle(
                                              color: Colors.black54, fontSize: 12.0),
                                        ),
                                      ),
                                      Divider(
                                        color: ColorCodes.emailColor,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                          ) ,
                        ]
                    )
                  ],
                ),
              )
          )
      );
    }
    return WillPopScope(
      onWillPop: (){
        if (screen == "pushNotification")
        {
          Navigation(context, navigatore: NavigatoreTyp.homenav);
        }
        else if(screen == "notification"){
          Navigation(context, navigatore: NavigatoreTyp.PushReplacment,name: Routename.notify);
          return Future.value(false);
        } else {
          if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
            Navigator.of(context).pop();
          }else{
            Navigation(context, navigatore: NavigatoreTyp.Pop);
          }

        }
        return Future.value(false);
      },
      child: Scaffold(
        appBar: ResponsiveLayout.isSmallScreen(context) ?
        gradientappbarmobile() : null,
        backgroundColor: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?ColorCodes.whiteColor:Theme.of(context).backgroundColor,
        body: Column(
          children: <Widget>[
            // if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
            //   Header(false),
            Vx.isWeb? _bodyWeb() : Flexible(child: _bodyMobile()),
          ],
        ),
        bottomNavigationBar:  Vx.isWeb ? SizedBox.shrink() :
        Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
            child: (Features.ismultivendor) ?  StoreBottomNavigation() : bottomNavigationbar(),
          ),
        ),
      ),
    );
  }
}
