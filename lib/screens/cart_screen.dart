import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login_web/flutter_facebook_login_web.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocbay/components/ItemList/item_component.dart';
import 'package:grocbay/components/login_web.dart';
import 'package:grocbay/controller/mutations/cat_and_product_mutation.dart';
import 'package:grocbay/repository/authenticate/AuthRepo.dart';
import 'package:sign_in_apple/apple_id_user.dart';
import 'package:sign_in_apple/sign_in_apple.dart';
import '../../controller/mutations/address_mutation.dart';
import '../../controller/mutations/cart_mutation.dart';
import '../../controller/mutations/home_screen_mutation.dart';
import '../../controller/mutations/login.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/cartModle.dart';
import '../../models/newmodle/user.dart';
import '../../repository/cart/cart_repo.dart';
import '../../widgets/simmers/checkout_screen.dart';
import '../../widgets/simmers/singel_item_of_list_shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import '../models/newmodle/shoppingModel.dart';
import '../rought_genrator.dart';
import '../screens/sellingitem_screen.dart';
import '../constants/api.dart';
import '../generated/l10n.dart';
import '../models/cartItemsField.dart';
import '../providers/sellingitems.dart';
import '../screens/offer_screen.dart';
import '../services/firebaseAnaliticsService.dart';
import '../widgets/addresswidget/address_info.dart';
import '../widgets/bottom_navigation.dart';
import '../screens/searchitem_screen.dart';
import '../assets/ColorCodes.dart';
import '../assets/images.dart';
import '../constants/features.dart';
import '../widgets/simmers/item_list_shimmer.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/deliveryslotitems.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../screens/shoppinglist_screen.dart';
import '../screens/wallet_screen.dart';
import '../utils/ResponsiveLayout.dart';
import '../screens/login_screen.dart';
import '../screens/policy_screen.dart';

import '../main.dart';
import '../providers/branditems.dart';
import '../screens/confirmorder_screen.dart';
import '../screens/address_screen.dart';
import '../screens/signup_selection_screen.dart';
import '../screens/home_screen.dart';
import '../screens/pickup_screen.dart';
import '../widgets/cartitems_display.dart';
import '../data/calculations.dart';
import '../data/hiveDB.dart';
import '../constants/IConstants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'customer_support_screen.dart';
import 'map_screen.dart';
import 'membership_screen.dart';
import 'myorder_screen.dart';
import 'payment_screen.dart';
import '../utils/prefUtils.dart';
import '../providers/cartItems.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    //'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class CartScreen extends StatefulWidget {
  static const routeName = '/cart-screen';

 String afterlogin="";
  CartScreen(Map<String, String> params){
   this.afterlogin = params["afterlogin"]??"" ;
  }

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with SingleTickerProviderStateMixin,Navigations{
  double minorderamount = 0;
  double deliverycharge = 0;
  var addressitemsData;
  //var shoplistData;
  final _form = GlobalKey<FormState>();
  bool _checkmembership = false;
  int _groupValue = 1;
  int _groupCart =1;
  int _groupPick = 0;
  int _groupValueAdvance=1;
  bool _isLoading = true;
  bool _initialloading = true;
  bool _cartitemloaded = false;
  bool _cartdugestloaded = false;
  bool _isshow =true;
  List<String>? dateSplit;
  List<String>? pickSplit;
  bool visible= false;
  bool visiblestand= true;
  bool visibleexpress= false;
  var dividerSlot = ColorCodes.primaryColor;
  var dividerExpress = ColorCodes.whiteColor;

  var ContainerSlot = ColorCodes.varcolor;
  var ContainerExpress = ColorCodes.whiteColor;

  var selectedTimeSlot = ColorCodes.whiteColor;
  int position = 0;

  //pickup
  bool _checkStoreLoc = false;
  bool _isPickupSlots = false;
  DateTime? pickedDate;
  var pickuplocItem;
  var pickupTime;
  String selectTime = "";
  String selectDate = "";
  var times;
  int z=0;
  var pickupdelivery;
  var _message = TextEditingController();
  String deliverlocation = "";
  bool _loading = true;
  bool _Load=true;
  var _checkaddress = false;
  var addtype;
  var address;
  IconData? addressicon;
  var deliveryslotData;
  var delChargeData;
  var timeslotsData;
  bool _isChangeAddress = false;
  bool _slotsLoading = false;
  var _checkslots = false;
  bool _loadingDelCharge = true;
  int _index = 0;
  int _radioValue = 1;
  String _deliveryDurationExpress = "0.0 ";
  var day, date, time = "10 AM - 1 PM";
  bool _loadingSlots = true;
  String _minimumOrderAmountNoraml = "0.0";
  String _deliveryChargeNormal = "0.0";
  String _minimumOrderAmountPrime = "0.0";
  String _deliveryChargePrime = "0.0";
  String _minimumOrderAmountExpress = "0.0";
  String _deliveryChargeExpress = "0.0";
  var timeslotsindex = "0";
  List checkBoxdata = [];
  List titlecolor = [];
  List iconcolor = [];
  var _address = "";
  var otpvalue = "";
  // bool _slots =true;
  bool slots=false;
  MediaQueryData? queryData;
  double? wid;
  double? maxwid;
  String? countryName ;//= "${CountryPickerUtils.getCountryByPhoneCode(IConstants.countryCode.split('+')[1]).name}";
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
  final TextEditingController _mobilecontroller = new TextEditingController();
  final TextEditingController _referController = new TextEditingController();
  final _lnameFocusNode = FocusNode();
  String fn = "";
  String ln = "";
  String ea = "";
  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();
  FocusNode f4 = FocusNode();
   String confirmSwap ="";

  String? otp1, otp2, otp3, otp4;
  bool iphonex = false;

  int count=1;
  int countTime=1;

  bool timeComp=false;
  int maxTime=0;
  int maxDate=0;
  int? finalMax=0,MaxTimeFinal,difference=0;
  var checkmembership = false;
  String durType= "";
  String? mode;
  List<CartItem> something=[];//slot based delivery option 2
  List<CartItem> ExpressDetails=[];//Express delivery option 2
  Map<String, List<CartItem>>? newMap2;
  Map<String, List<CartItem>>? newMap3;


  List<CartItem> DefaultSlot=[];//slot based delivery option 1
  Map<String, List<CartItem>>? newMap;//DateBased delivery option 1
  Map<String, List<CartItem>>? newMap1;//TimeBased delivery option 1


  String? datecom;
  String? timecom;
  String? Date;


  double? deliveryChargeCalculation;
  int deliveryamount = 0;
  String delCharge = "0.0";
  String? deliverychargetextdefault;
  String? deliverychargetextSecond, deliverychargetextExpress, deliverychargetextSecDate,deliverychargetextSecTime;
  final DateTime now = DateTime.now();
  String? deliveryslot, deliveryexpress;

  double deliveryfinalslotdate=0.0;
  double deliveryfinalslotTime=0.0;

  double SecondDateTotal = 0.0;
  double deliverySlotamount = 0.0;
  double deliveryDateamount = 0.0;
  double deliveryTimeamount = 0.0;
  double deliveryExpressamount = 0.0;

  int Check = 0;
  BrandItemsList? offersData;
  bool _isDiscounted = true;
  bool _slots = false;
  bool _isUnavailable = false;
  UserData? addressdata;
  String channel = "";
  String _appletoken = "";
  bool isEmpty=/*(VxState.store as GroceStore).CartItemList.length<=0*/true;

  CartItemsFields cif = CartItemsFields();

  bool checkskip = !PrefUtils.prefs!.containsKey("apikey");

  UserData userdata = (VxState.store as GroceStore).userData;
  Future<CartFetch>? _futureitem ;

  List<CartItem> cartItemList = (VxState.store as GroceStore).CartItemList;
  GroceStore store = VxState.store;
  Auth _auth = Auth();
  String? deliverychargetext;
  double cartTotal = 0.0;
  String? membershipvx;// = (VxState.store as GroceStore).userData.membership!;
  double amountPayable = 0.0;
  bool _isunavailablepopup = false;
  bool _isAddToCart = false;
  List<ShoppingListData> shoplistData=[];

  @override
  void initState() {
    _events = new StreamController<int>.broadcast();
    _events!.add(30);
    pickedDate = DateTime.now();
    cartcontroller.fetch(onload: (onload){
      if(onload)
        setState((){
          _cartitemloaded = true;
        });
    });
    Future.delayed(Duration.zero, () async {
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

      if (PrefUtils.prefs!.getString('applesignin') == "yes") {
        _appletoken = PrefUtils.prefs!.getString('apple').toString();
      } else {
        _appletoken = "";
      }
      print("branch cart..."+PrefUtils.prefs!.getString("branch").toString());
      CartRepo().getSudgetstedCart().then(( CartFetch value) {
        setState(() {
          _futureitem = Future.value(value);
          _cartdugestloaded = true;
        });
      });
      debugPrint("hello..");
      VxState.watch(context, on: [SetCartItem]);
      if((VxState.store as GroceStore).CartItemList.length<=0){
        debugPrint("hello.. if....");
        //Features.ismultivendor && IConstants.isEnterprise?IConstants.storename= store.CartItemList.:"";
        setState(() {
          _isDiscounted = true;
          isEmpty=true;
        });
      }else{
        debugPrint("hello.. else....");

        setState(() {
          _isDiscounted = false;
          isEmpty=false;
        });
      }
      debugPrint("hello1..");
      membershipvx = (VxState.store as GroceStore).userData.membership!;
      countryName = "${CountryPickerUtils.getCountryByPhoneCode(IConstants.countryCode.split('+')[1]).name}";
     setState(() {
        //PrefUtils.prefs!.setString("deliverylocation", PrefUtils.prefs!.getString("restaurant_location")!);
        debugPrint("deliveryloaion..."+PrefUtils.prefs!.getString("deliverylocation").toString());
        deliverlocation = PrefUtils.prefs!.getString("deliverylocation")!;
        PrefUtils.prefs!.setString('fixtime', "");
        PrefUtils.prefs!.setString("fixdate", "");
        if (VxState.store.userData.membership == "1") {
          _checkmembership = true;
        } else {
          _checkmembership = false;
        }
        _isLoading = false;
        _isshow =false;

      });
      addressdata = (VxState.store as GroceStore).userData;
     // print("address length... cart initial...2"+addressdata!.billingAddress!.length.toString());
      if(!Vx.isWeb && PrefUtils.prefs!.containsKey("addressId"))await Provider.of<BrandItemsList>(context, listen: false).deliveryCharges(PrefUtils.prefs!.getString("addressId")!).then((_){
        setState(() {

          delChargeData = Provider.of<BrandItemsList>(context, listen: false);
          if (delChargeData.itemsDelCharges.length <= 0) {
            _loadingDelCharge = false;
          } else {
            _minimumOrderAmountNoraml =
                delChargeData.itemsDelCharges[0].minimumOrderAmountNoraml;
            _deliveryChargeNormal =
                delChargeData.itemsDelCharges[0].deliveryChargeNormal;
            _minimumOrderAmountPrime =
                delChargeData.itemsDelCharges[0].minimumOrderAmountPrime;
            _deliveryChargePrime =
                delChargeData.itemsDelCharges[0].deliveryChargePrime;
            _minimumOrderAmountExpress =
                delChargeData.itemsDelCharges[0].minimumOrderAmountExpress;
            _deliveryChargeExpress =
                delChargeData.itemsDelCharges[0].deliveryChargeExpress;
            _deliveryDurationExpress =
                delChargeData.itemsDelCharges[0].deliveryDurationExpress;
            _loadingDelCharge = false;
           }
        });
      });
      // await Provider.of<CartItems>(context, listen: false).fetchCartItems().then((_) {
      //   final cartItemsData = Provider.of<CartItems>(context,listen: false);
      //   _bloc.setCartItem(cartItemsData);
      //   setState(() {
      //     _isCartItem = false;
      //   });
      // });
      //print("address length... cart initial...1"+addressdata!.billingAddress!.length.toString());
///Do not remove this.. unless impliment Api 16-12-2020
//       Provider.of<BrandItemsList>(context,listen: false)
//           .fetchShoppinglist()
//           .then((_) {
//         shoplistData =
//             Provider.of<BrandItemsList>(context, listen: false);
//       });

      if(Features.isShoppingList){
        shoplistData = (VxState.store as GroceStore).ShoppingList;
      }
      //if(Vx.isWeb)checkLocation();

        print("address length... cart initial..."+addressdata!.billingAddress!.length.toString());
      if (addressdata!.billingAddress!=null&&addressdata!.billingAddress!.length > 0) {
          addtype = addressdata!.billingAddress![0].addressType;
          address = addressdata!.billingAddress![0].address;
          name = addressdata!.billingAddress![0].fullName!;
          addressicon = addressdata!.billingAddress![0].addressicon;
          PrefUtils.prefs!.setString(
              "addressId",
              addressdata!.billingAddress![0].id.toString());
         // calldeliverslots(addressdata.billingAddress[0].id.toString());
          deliveryCharge(addressdata!.billingAddress![0].id.toString());
          _checkaddress = true;
          checkLocation();
      } else {
        setState(() {
          _checkaddress = false;
        });
      }

      PrefUtils.prefs!.setString("latitude", (VxState.store as GroceStore).userData.billingAddress![0].lattitude!);
      PrefUtils.prefs!.setString("longitude", (VxState.store as GroceStore).userData.billingAddress![0].logingitude!);
      print("user billing address......"+(VxState.store as GroceStore).userData.billingAddress![0].lattitude!.toString()+"...."+(VxState.store as GroceStore).userData.billingAddress![0].logingitude!.toString());
      Provider.of<BrandItemsList>(context, listen: false).fetchPickupfromStore().then((_) {

        pickuplocItem = Provider.of<BrandItemsList>(context, listen: false);
        if (pickuplocItem.itemspickuploc.length > 0) {
          setState(() {
            _checkStoreLoc = true;
            _deliveryChargeNormal = pickuplocItem.itemspickuploc[0].deliveryChargeForRegularUser;
            _deliveryChargePrime = pickuplocItem.itemspickuploc[0].deliveryChargeForMembershipUser;
            Provider.of<DeliveryslotitemsList>(context, listen: false).fetchPickupslots(pickuplocItem.itemspickuploc[0].id).then((_) {
              pickupTime = Provider.of<DeliveryslotitemsList>(context, listen: false);
              for(int i = 0; i <pickupTime.itemsPickup.length; i++) {
                setState(() {
                  if(i == 0) {
                    pickupTime.itemsPickup[i].selectedColor = ColorCodes.mediumgren;
                    pickupTime.itemsPickup[i].isSelect = true;
                  } else {
                    pickupTime.itemsPickup[i].selectedColor = ColorCodes.whiteColor;
                    pickupTime.itemsPickup[i].isSelect = false;
                  }
                });
                final tagName = pickupTime.itemsPickup[i].date.toString();
                pickSplit = tagName.split(',');
              }
              if (pickupTime.itemsPickup.length > 0) {
                _isPickupSlots = true;
                selectTime = pickupTime.itemsPickup[0].time;
                selectDate = pickupTime.itemsPickup[0].date;
                setState(() {
                  _isLoading = false;
                });
              } else {
                setState(() {
                  _isLoading = false;
                  _isPickupSlots = false;
                });
              }
            });
          });
        } else {
          setState(() {
            _checkStoreLoc = false;
            _isLoading = false;
          });
        }
      });
      if (!Vx.isWeb) _listenotp();


      if(PrefUtils.prefs!.getString("referCodeDynamic") == "" || PrefUtils.prefs!.getString("referCodeDynamic") == null){
        _referController.text = "";
      }else{
        _referController.text = PrefUtils.prefs!.getString("referCodeDynamic")!;
      }

      BrandItemsList().GetRestaurantNew("acbjadgdj",()async {
        // PrimeryLocation().fetchPrimarylocation();
        if (!PrefUtils.prefs!.containsKey("deliverylocation")) {
          setState(() {
            countryName = CountryPickerUtils.getCountryByPhoneCode(IConstants.countryCode.split('+')[1]).name;
          });
        }
        if(IConstants.holyday =="1"){
          ShowpopupforHoliday();
        }
      });



    });
    Future.delayed(Duration.zero, () async {
      _address = PrefUtils.prefs!.getString("restaurant_address")!;
       /* if(Vx.isWeb) Provider.of<AddressItemsList>(context,listen: false).fetchAddress().then((_) {
          setState(() {
            addressitemsData = Provider.of<AddressItemsList>(context, listen: false);
            if (addressitemsData.items.length > 0) {
              _checkaddress = true;
              checkLocation();
            } else {
              _checkaddress = false;
              _loading = false;
            }
          });
        });*/

        //pickup screen



    });

    _googleSignIn.signInSilently();
    super.initState();
  }

  void _listenotp() async {
    await SmsAutoFill().listenForCode;
  }

  ShowpopupforHoliday() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(

          onWillPop: (){
            SystemNavigator.pop();
            return Future.value(false);
          },
          child: AlertDialog(
            title: Image.asset(
              Images.logoImg,
              height: 50,
              width: 138,
            ),
            content: Text(IConstants.holydayNote),
            actions: <Widget>[
              Vx.isWeb? SizedBox.shrink():FlatButton(
                child: Text(
                  S .of(context).ok,//'Ok'
                ),
                onPressed: () async {
                  SystemNavigator.pop();
                },
              ),
              FlatButton(
                child: Text(
                  S .of(context).change_location,//'Change'
                ),
                onPressed: () async {
                  PrefUtils.prefs!.setString("formapscreen", "homescreen");
                    if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                    // _dialogforaddress(context);
                    MapWeb(context);
                    }
                    else {
                      Navigation(context, name: Routename.MapScreen,
                          navigatore: NavigatoreTyp.Push);
                    }
                 // Navigator.of(context).pushNamed(MapScreen.routeName);
                },
              ),
            ],
          ),
        );
      },
    );
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
            /*  Navigator.of(context).pushNamedAndRemoveUntil(
                  CartScreen.routeName,
                  ModalRoute.withName(HomeScreen.routeName),arguments: {
                "afterlogin": ""
              });*/
              Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
            } else {
              Navigator.of(context).popUntil(ModalRoute.withName(
                HomeScreen.routeName,
              ));
            }
          } else {
            Navigator.of(context).pushNamed(
              HomeScreen.routeName,
            );
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
         // Navigator.of(context).pushReplacementNamed(MapScreen.routeName);
        }
      }
      //Navigator.of(context).pop();
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
    /*final facebookLogin = FacebookLogin();
    facebookLogin.loginBehavior = FacebookLoginBehavior.nativeWithFallback;
    final result = await facebookLogin.logIn(['email']);*/
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

  Future<void> facebooklogin() async {
    PrefUtils.prefs!.setString('skip', "no");
    PrefUtils.prefs!.setString('applesignin', "no");
    initiateFacebookLogin();
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
            Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
          }


        }
        else if(PrefUtils.prefs!.getString("isdelivering").toString()=="true"){


          Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);


        }
        else {
          PrefUtils.prefs!.setString("formapscreen", "homescreen");
          PrefUtils.prefs!.setString("latitude", PrefUtils.prefs!.getString("restaurant_lat")!);
          PrefUtils.prefs!.setString("longitude", PrefUtils.prefs!.getString("restaurant_long")!);
          PrefUtils.prefs!.setString("ismap", "true");
          PrefUtils.prefs!.setString("isdelivering", "true");
          Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
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
          Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.routeName, (route) => false);
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

  Future<void> otpCall() async {
    // imp feature in adding async is the it automatically wrap into Future.
    try {
      //SharedPreferences PrefUtils.prefs = await SharedPreferences.getInstance();

      final response = await http.post(Api.resendOtpCall, body: {
        // await keyword is used to wait to this operation is complete.
        "resOtp": PrefUtils.prefs!.getString('Otp'),
        "mobileNumber": PrefUtils.prefs!.getString('Mobilenum'),
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      throw error;
    }
  }

  Future<void> Otpin30sec() async {
    // imp feature in adding async is the it automatically wrap into Future.
    try {
      //   SharedPreferences PrefUtils.prefs = await SharedPreferences.getInstance();
      final response = await http.post(Api.resendOtp30, body: {
        // await keyword is used to wait to this operation is complete.
        "resOtp": PrefUtils.prefs!.getString('Otp'),
        "mobileNumber": PrefUtils.prefs!.getString('Mobilenum'),
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      throw error;
    }
  }

  Future<void> checkusertype(String prev) async {
    // imp feature in adding async is the it automatically wrap into Future.
    try {
      var response;
      if (prev == "signInApple") {
        response = await http.post(Api.emailLogin, body: {
          // await keyword is used to wait to this operation is complete.
          "email": PrefUtils.prefs!.getString('Email'),
          "tokenId": PrefUtils.prefs!.getString('tokenid'),
          "apple":PrefUtils. prefs!.getString('apple'),
        });
      } else {
        response = await http.post(Api.emailLogin, body: {
          // await keyword is used to wait to this operation is complete.
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
            // PrefUtils.prefs!.setString('userID', data['userID'].toString());
            PrefUtils.prefs!.setString('membership', data['membership'].toString());
            PrefUtils. prefs!.setString("mobile", data['mobile'].toString());
            PrefUtils.prefs!.setString("latitude", data['latitude'].toString());
            PrefUtils.prefs!.setString("longitude", data['longitude'].toString());
          } else if (responseJson['status'].toString() == "false") {}
        }

        PrefUtils.prefs!.setString('LoginStatus', "true");
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
          }*/
          name = store.userData.username!;
          //name = prefs.getString('FirstName') + " " + prefs.getString('LastName');
          if (PrefUtils.prefs!.getString('prevscreen') == 'signInAppleNoEmail') {
            email = "";
          } else {
            email = PrefUtils.prefs!.getString('Email')!;
          }
          mobile = PrefUtils.prefs!.getString('Mobilenum')!;
          tokenid = PrefUtils.prefs!.getString('tokenid')!;

          if (store.userData.mobileNumber != null) {
            phone =PrefUtils. prefs!.getString('mobile')!;
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
        _dialogforRefer(context);
        //SignupUser();
        //   Navigator.of(context).pop();
        /* Navigator.of(context).pushReplacementNamed(
          LoginScreen.routeName,
        );*/
      }
    } catch (error) {
      Navigator.of(context).pop();
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
                      TextField(
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
                          SignupUser();//SignupUser();
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

  Future<void> _handleSignIn() async {
    // prefs.setString('skip', "no");
    // prefs.setString('applesignin', "no");
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
          backgroundColor: Colors.black87,
          textColor: Colors.white);
    }
  }

  // Future<void> checkLocation() async {
  //   // imp feature in adding async is the it automatically wrap into Future.
  //   addressitemsData = Provider.of<AddressItemsList>(context, listen: false);
  //
  //   try {
  //     final response = await http.post(Api.checkLocation, body: {
  //       // await keyword is used to wait to this operation is complete.
  //       "lat":
  //       addressitemsData.items[0].userlat,
  //       "long":
  //       addressitemsData.items[0].userlong,
  //     });
  //
  //     //SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //     final responseJson = json.decode(utf8.decode(response.bodyBytes));
  //     if (responseJson['status'].toString() == "yes") {
  //       if (PrefUtils.prefs!.getString("branch") ==
  //           responseJson['branch'].toString()) {
  //         final routeArgs =
  //         ModalRoute
  //             .of(context)
  //             .settings
  //             .arguments as Map<String, String>;
  //
  //         final prev = routeArgs['prev'];
  //         if (prev == "address_screen") {
  //           _dialogforProcessing();
  //           cartCheck(
  //             PrefUtils.prefs!.getString("addressId"),
  //             addressitemsData.items[addressitemsData.items.length - 1].userid,
  //             addressitemsData
  //                 .items[addressitemsData.items.length - 1].useraddtype,
  //             addressitemsData
  //                 .items[0].useraddress,
  //             addressitemsData
  //                 .items[addressitemsData.items.length - 1].addressicon,
  //             addressitemsData.items[addressitemsData.items.length - 1].username,
  //           );
  //         } else {
  //           if (addressitemsData.items.length > 0) {
  //             _checkaddress = true;
  //             addtype = addressitemsData
  //                 .items[0].useraddtype;
  //             address = addressitemsData.items[0].useraddress;
  //             addressicon = addressitemsData
  //                 .items[0].addressicon;
  //             PrefUtils.prefs!.setString(
  //                 "addressId",
  //                 addressitemsData
  //                     .items[0].userid);
  //             calldeliverslots(addressitemsData
  //                 .items[0].userid);
  //             deliveryCharge(addressitemsData
  //                 .items[0].userid);
  //           } else {
  //             _checkaddress = false;
  //           }
  //         }
  //         } else {
  //         setState(() {
  //           _isChangeAddress = true;
  //           _loading = false;
  //           _slotsLoading = false;
  //         });
  //       }
  //     } else {
  //       setState(() {
  //         _isChangeAddress = true;
  //         _loading = false;
  //         _slotsLoading = false;
  //       });
  //     }
  //   } catch (error) {
  //     throw error;
  //   }
  // }

  Future<void> checkLocation() async {
    //addressitemsData = Provider.of<AddressItemsList>(context, listen: false);
    addressdata = (VxState.store as GroceStore).userData;
    try {
      final response = await http.post(IConstants.isEnterprise && Features.ismultivendor?Api.checkLocationmultivendor:Api.checkLocation, body: {
        "lat": /*addressitemsData.items[0].userlat*/(VxState.store as GroceStore).userData.billingAddress![0].lattitude,
        "long": (VxState.store as GroceStore).userData.billingAddress![0].logingitude,
        "branch": PrefUtils.prefs!.getString("branch"),
        "ref": IConstants.refIdForMultiVendor.toString(),
        "branchtype": IConstants.branchtype.toString(),
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();

      final responseJson = json.decode(response.body);

      if (responseJson['status'].toString() == "yes") {
        if (IConstants.isEnterprise && Features.ismultivendor?IConstants.refIdForMultiVendor == responseJson['ref'].toString():prefs.getString("branch") == responseJson['branch'].toString()) {
          final routeArgs =
          ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          final prev = routeArgs['prev'];
          if (prev == "address_screen") {
            _dialogforProcessing();
            cartCheck(
              /* prefs.getString("addressId"),
              addressitemsData.items[0].userid,
              addressitemsData
                  .items[0].useraddtype,

              addressitemsData.items[0].useraddress,
              addressitemsData
                  .items[0].addressicon,
              addressitemsData.items[0].username,*/
              prefs.getString("addressId")!,
              addressdata!.billingAddress![0].id.toString(),
              addressdata!.billingAddress![0].addressType!,
              addressdata!.billingAddress![0].address!,
              addressdata!.billingAddress![0].addressicon!,
              addressdata!.billingAddress![0].fullName,
            );
          } else {
            if (addressdata!.billingAddress!.length > 0) {
                _checkaddress = true;
                addtype = addressdata!.billingAddress![0].addressType;
                address = addressdata!.billingAddress![0].address;
                name = addressdata!.billingAddress![0].fullName!;
                addressicon = addressdata!.billingAddress![0].addressicon;
                prefs.setString(
                    "addressId",
                    addressdata!.billingAddress![0].id.toString());
                if(!Features.ismultivendor)calldeliverslots(addressdata!.billingAddress![0].id.toString());
                deliveryCharge(addressdata!.billingAddress![0].id.toString());
             // _Load=false;
            } else {
                _checkaddress = false;
            }
          }
        } else {
          setState(() {
            _isChangeAddress = true;
             _loading = false;
            _slotsLoading = false;
          });
        }
      } else {
        setState(() {
          _isChangeAddress = true;
           _loading = false;
          _slotsLoading = false;
        });
      }
    } catch (error) {
      throw error;
    }
  }



  Future<void> calldeliverslots(String addressid) async {
    Provider.of<DeliveryslotitemsList>(context,listen: false)
        .fetchDeliveryslots(addressid)
        .then((_) {
      deliveryslotData = Provider.of<DeliveryslotitemsList>(context, listen: false);

      for(int i = 0; i < deliveryslotData.items.length; i++) {
        setState(() {
          if(i == 0) {
            deliveryslotData.items[i].selectedColor = ColorCodes.mediumgren;
            deliveryslotData.items[i].isSelect = true;

          } else {
            deliveryslotData.items[i].selectedColor = ColorCodes.whiteColor;
            deliveryslotData.items[i].isSelect = false;
          }
        });
        final tagName = deliveryslotData.items[i].date.toString();
        dateSplit = tagName.split(',');
      }
      //  final timeData = Provider.of<DeliveryslotitemsList>(context, listen: false);
      // for(int i = 0; i < timeData.times.length; i++) {
      //   setState(() {
      //     if(i == 0) {
      //       timeData.times[i].selectedColor = ColorCodes.mediumBlueColor;
      //       timeData.times[i].isSelect = true;
      //     } else {
      //       timeData.times[i].selectedColor = ColorCodes.lightgrey;
      //       timeData.times[i].isSelect = false;
      //     }
      //   });
      // }
      setState(() {
        if (deliveryslotData.items.length <= 0) {
          _checkslots = false;
          _loadingSlots = false;
          _slotsLoading = false;
        } else {
          _checkslots = true;
          day = deliveryslotData.items[0].day;
          date = deliveryslotData.items[0].date;
          timeslotsData = Provider.of<DeliveryslotitemsList>(
            context,
            listen: false,
          ).findById(timeslotsindex);
          for (int j = 0; j < timeslotsData.length; j++) {

            setState(() {
              PrefUtils.prefs!.setString("fixdate", deliveryslotData.items[0].dateformat);
              if (timeslotsData[j].status == "1") {
                timeslotsData[j].selectedColor = Colors.grey;
                timeslotsData[j].isSelect = false;
                timeslotsData[j].textColor = Colors.grey;
              } else {

                timeslotsData[j].selectedColor = ColorCodes.whiteColor;
                timeslotsData[j].textColor = ColorCodes.blackColor;
                timeslotsData[j].isSelect = false;
                //  prefs.setString("fixdate", deliveryslotData.items[j].dateformat);
                // prefs.setString('fixtime', timeslotsData[j].time);
                // if (j== 0 && timeslotsData.times[j].status != "1") {
                //   timeslotsData.times[j].selectedColor = ColorCodes.mediumgren;
                //   timeslotsData.times[j].isSelect = true;
                //   timeslotsData[j].textColor = ColorCodes.greenColor;
                //   prefs.setString("fixdate", deliveryslotData.items[0].dateformat);
                //   prefs.setString('fixtime', timeslotsData[0].time);
                // } else {
                //    timeslotsData.times[j].selectedColor = ColorCodes.whiteColor;
                //    timeslotsData.times[j].isSelect = false;
                //   timeslotsData[j].textColor = ColorCodes.greenColor;
                // }

              }
            });
            _loadingSlots = false;
            _slotsLoading = false;
          }
          _loadingSlots = false;
          _slotsLoading = false;
        }
      });
    });
  }

  Future<void> deliveryCharge(String addressid) async {
    Provider.of<BrandItemsList>(context,listen: false).deliveryCharges(addressid).then((_) {
      setState(() {
        delChargeData = Provider.of<BrandItemsList>(context, listen: false);
        if (delChargeData.itemsDelCharges.length <= 0) {
          _loadingDelCharge = false;
        } else {

            _minimumOrderAmountNoraml =
                delChargeData.itemsDelCharges[0].minimumOrderAmountNoraml;
            _deliveryChargeNormal =
                delChargeData.itemsDelCharges[0].deliveryChargeNormal;
            _minimumOrderAmountPrime =
                delChargeData.itemsDelCharges[0].minimumOrderAmountPrime;
            _deliveryChargePrime =
                delChargeData.itemsDelCharges[0].deliveryChargePrime;
            _minimumOrderAmountExpress =
                delChargeData.itemsDelCharges[0].minimumOrderAmountExpress;
            _deliveryChargeExpress =
                delChargeData.itemsDelCharges[0].deliveryChargeExpress;
            _deliveryDurationExpress =
                delChargeData.itemsDelCharges[0].deliveryDurationExpress;
            _loadingDelCharge = false;
           }

      });
    });
  }
  Future<void> cartCheck(String prevAddressid, String addressid, String addressType, String adressSelected, IconData adressIcon,username) async {
    // imp feature in adding async is the it automatically wrap into Future.

    //SharedPreferences prefs = await SharedPreferences.getInstance();
    setDefaultAddress(addressid);
    String itemId = "";
    for (int i = 0; i < cartItemList.length; i++) {
      if (itemId == "") {
        itemId = cartItemList[i].itemId.toString();
      } else {
        itemId =
            itemId + "," + cartItemList[i].itemId.toString();
      }
    }

    var url = IConstants.isEnterprise && Features.ismultivendor?Api.cartCheckMultivendor + addressid + "/" + itemId + "/" + IConstants.refIdForMultiVendor.toString() + "/" + IConstants.branchtype.toString():Api.cartCheck + addressid + "/" + itemId;
    try {
      final response = await http.get(
        url,
      );

      final responseJson = json.decode(utf8.decode(response.bodyBytes));

      //if status = 0 for reset cart and status = 1 for default
      print("cart status....."+responseJson.toString());
      if (responseJson["status"].toString() == "1") {
        setState(() {
          //setDefaultAddress(addressid);
          _isChangeAddress = false;
          _checkaddress = true;
          _slotsLoading = true;
          PrefUtils.prefs!.setString("addressId", addressid);
          addtype = addressType;
          address = adressSelected;
          name = username;
          addressicon = adressIcon;
          if(!Features.ismultivendor)calldeliverslots(addressid);
          deliveryCharge(addressid);
        });
        Navigator.of(context).pop();
      } else {
        if(!Features.ismultivendor)
          {
            _dialogforAvailability(
              prevAddressid,
              addressid,
              addressType,
              adressSelected,
              adressIcon,
            );
          }
        else{
          Navigator.of(context).pop();
        }
      }
    } catch (error) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: S .of(context).something_went_wrong,//"Something went wrong!",
          fontSize: MediaQuery.of(context).textScaleFactor *13,
          backgroundColor: Colors.black87,
          textColor: Colors.white);
      throw error;
    }
  }
  void setDefaultAddress(String addressid) async {
    bool _addresscheck = false;
    AddressController addressController = AddressController();
    await addressController.setdefult(addressId: addressid,branch:PrefUtils.prefs!.getString('branch')??"4");
    /* Provider.of<AddressItemsList>(context,listen: false)
        .setDefaultAddress(addressid)
        .then((_) {
      *//*Provider.of<AddressItemsList>(context,listen: false).fetchAddress().then((_) {*//*
      setState(() {
        addressitemsData =
            Provider.of<AddressItemsList>(context, listen: false);
        if (addressitemsData.items.length <= 0) {
          _addresscheck = false;
          _isLoading = false;
        } else {
          _addresscheck = true;
          _isLoading = false;
        }
      });
    });*/
  }
  _dialogforAvailability(String prevAddOd, String addressId, String addressType, String adressSelected, IconData adressIcon) {
    String itemCount = "";
    itemCount = "   " + cartItemList.length.toString() + " " + "items";
    // bool _checkMembership = false;

    // if (PrefUtils.prefs!.getString("membership") == "1") {
    //   _checkMembership = true;
    // } else {
    //   _checkMembership = false;
    // }

    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              insetPadding: EdgeInsets.only(left: 20.0, right: 20.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              child: Container(
                  height: MediaQuery.of(context).size.height * 85 / 100,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      new RichText(
                        text: new TextSpan(
                          // Note: Styles for TextSpans must be explicitly defined.
                          // Child text spans will inherit styles from parent
                          style: new TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: S .of(context).Availability_Check,//"Availability Check",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0),
                            ),
                            new TextSpan(
                                text: itemCount,
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12.0)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        S .of(context).changing_area,//"Changing area",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12.0,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        S .of(context).product_price_availability,//"Product prices, availability and promos are area specific and may change accordingly. Confirm if you wish to continue.",
                        style: TextStyle(fontSize: 12.0),
                      ),
                      Spacer(),
                      SizedBox(
                        height: 5.0,
                      ),
                      Divider(),
                      SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 53.0,
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(
                              S .of(context).items,//"Items",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12.0),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 15.0,
                                ),
                                Text(
                                  S .of(context).reason, // "Reason",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0),
                                ),
                              ],
                            ),
                          ),
                          /*Expanded(
                                  flex: 2,
                                  child: Text("Price", style: TextStyle(fontWeight: FontWeight.bold),),),*/
                        ],
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Divider(),
                      VxBuilder(builder: (BuildContext context, store, VxStatus? status) {
                        final productBox = store!.CartItemList;
                       return SizedBox(
                          height: MediaQuery.of(context).size.height * 30 / 100,
                          child: new ListView.builder(
                            //physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: productBox.length,
                              itemBuilder: (_, i) => Row(
                                children: <Widget>[
                                  FadeInImage(
                                    image: NetworkImage(productBox[i].itemImage!),
                                    placeholder:
                                    AssetImage(Images.defaultProductImg),
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(
                                    width: 3.0,
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                            cartItemList[i]
                                                .itemName!,
                                            style: TextStyle(fontSize: 12.0)),
                                        SizedBox(
                                          height: 3.0,
                                        ),
                                        _checkmembership
                                            ? (cartItemList[i].membershipPrice == '-' ||
                                            cartItemList[i].membershipPrice == "0")
                                            ? (double.parse(cartItemList[i].price!) <=
                                            0 ||
                                            cartItemList[i].price
                                                .toString() ==
                                                "" ||
                                            cartItemList[i].price ==
                                                cartItemList[i].varMrp)
                                            ? Text(
                                          Features.iscurrencyformatalign?
                                          cartItemList[i].varMrp
                                                  .toString()+
                                                  " " +IConstants.currencyFormat :
                                            IConstants.currencyFormat +
                                                " " +
                                                cartItemList[i].varMrp
                                                    .toString(),
                                            style: TextStyle(fontSize: 12.0))
                                            : Text(
                                          Features.iscurrencyformatalign?
                                          cartItemList[i].price.toString() + " " + IConstants.currencyFormat:
                                            IConstants.currencyFormat + " " + cartItemList[i].price.toString(),
                                            style: TextStyle(fontSize: 12.0))
                                            : Text(Features.iscurrencyformatalign?
                                        cartItemList[i].membershipPrice! + " " + IConstants.currencyFormat:
                                            IConstants.currencyFormat + " " + cartItemList[i].membershipPrice!,
                                            style: TextStyle(fontSize: 12.0))
                                            : (double.parse(cartItemList[i].price!) <= 0 || cartItemList[i].price.toString() == "" || cartItemList[i].price == cartItemList[i].varMrp)
                                            ? Text(
                                          Features.iscurrencyformatalign?
                                          cartItemList[i].varMrp.toString() + " " + IConstants.currencyFormat :
                                            IConstants.currencyFormat + " " + cartItemList[i].varMrp.toString(),
                                            style: TextStyle(fontSize: 12.0))
                                            : Text(
                                          Features.iscurrencyformatalign?
                                          cartItemList[i].price.toString() + " " + IConstants.currencyFormat:
                                            IConstants.currencyFormat + " " + cartItemList[i].price.toString(), style: TextStyle(fontSize: 12.0))
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      flex: 4,
                                      child: Text(
                                          S .of(context).not_available,//"Not available",
                                          style: TextStyle(fontSize: 12.0))),
                                ],
                              )),
                        );
                      },mutations: {SetCartItem},
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Divider(),
                      SizedBox(
                        height: 20.0,
                      ),
                      new RichText(
                        text: new TextSpan(
                          // Note: Styles for TextSpans must be explicitly defined.
                          // Child text spans will inherit styles from parent
                          style: new TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                          ),
                          children: <TextSpan>[
                            new TextSpan(
                                text: S .of(context).note,//'Note: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            new TextSpan(
                              text:
                              S .of(context).by_clicking_confirm,//'By clicking on confirm, we will remove the unavailable items from your basket.',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: new Container(
                              width:
                              MediaQuery.of(context).size.width * 35 / 100,
                              height: 30.0,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey)),
                              child: new Center(
                                child: Text(
                                  S .of(context).cancel,
                                  //"CANCEL"
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          GestureDetector(
                            onTap: () async {
                              var com ="";
                              String val = "";
                              // for(int i = 0; i < cartItemList.length; i++){
                              //   val = val+com+cartItemList[i].itemId.toString();
                              //   com = ",";
                              // }
                              String item ="";
                              for(int i = 0; i < cartItemList.length; i++){
                                val = val+com+cartItemList[i].itemId.toString();

                                if(cartItemList[i].mode =="3"){
                                  item = item+com+cartItemList[i].itemId.toString();
                                }
                                com = ",";
                              }
                              confirmSwap = "confirmSwap";
                              Provider.of<CartItems>(context, listen: false).emptyCart().then((_) {
                              //  Hive.box<Product>(productBoxName).clear();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                //SharedPreferences prefs = await SharedPreferences.getInstance();
                                PrefUtils.prefs!.setString("formapscreen", "homescreen");
                                /*Navigator.of(context)
                                    .pushNamed(MapScreen.routeName,
                                  arguments: {
                                      "valnext": val.toString(),
                                    "moveNext": confirmSwap.toString()
                                  }
                                );*/
                              //  if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                                // _dialogforaddress(context);
                               // MapWeb(context,valnext: val.toString(),moveNext: confirmSwap.toString());
                                debugPrint("currentBranch...val..item.."+val+"...."+item);
                                  Navigation(context, name:Routename.NotAvailability,navigatore: NavigatoreTyp.Push,
                                      qparms: {
                                        "val" : val,
                                        "item": item,
                                        "currentbranch": PrefUtils.prefs!.getString("currentbranch"),

                                      });

                              });
                              final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);
                              for(int i = 0; i < sellingitemData.featuredVariation.length; i++) {
                                sellingitemData.featuredVariation[i].varQty = 0;
                              }

                              for (int i = 0; i < sellingitemData.itemspricevarOffer.length; i++) {
                                sellingitemData.itemspricevarOffer[i].varQty = 0;
                                break;
                              }
                              for(int i = 0; i < sellingitemData.itemspricevarSwap.length; i++) {
                                sellingitemData.itemspricevarSwap[i].varQty = 0;
                                break;
                              }

                              for(int i = 0; i < sellingitemData.discountedVariation.length; i++) {
                                sellingitemData.discountedVariation[i].varQty = 0;
                                break;
                              }

                            },
                            child: new Container(
                                height: 30.0,
                                width: MediaQuery.of(context).size.width *
                                    35 /
                                    100,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    border: Border.all(
                                      color: Theme.of(context).primaryColor,
                                    )),
                                child: new Center(
                                  child: Text(
                                    S .of(context).confirm,//"CONFIRM",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                    ],
                  )),
            );
          });
        });
  }

  addListnameToSF(String value) async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    PrefUtils.prefs!.setString('list_name', value);
  }

  _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    } //it will check all validators
    _form.currentState!.save();
    Navigator.of(context).pop();
    _dialogforProceesing(context, S .of(context).creating_list,);

    Provider.of<BrandItemsList>(context,listen: false).CreateShoppinglist().then((_) {
      /*Provider.of<BrandItemsList>(context,listen: false).fetchShoppinglist().then((_) {
        shoplistData = Provider.of<BrandItemsList>(context, listen: false);
        Navigator.of(context).pop();
        _dialogforShoppinglist(context);
      });*/

      _auth.getuserProfile(onsucsess: (value){
        shoplistData = (VxState.store as GroceStore).ShoppingList;
        Navigator.of(context).pop();
        _dialogforShoppinglist(context);
      },onerror: (){

      });
    });
  }

  _saveFormLogin() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    } //it will check all validators
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    Provider.of<BrandItemsList>(context,listen: false).LoginUser();
    await Future.delayed(Duration(seconds: 2));
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    _dialogforOtp();
  }

  Future<void> checkMobilenum() async {
    // imp feature in adding async is the it automatically wrap into Future.
    try {
      final response = await http.post(Api.mobileCheck, body: {
        // await keyword is used to wait to this operation is complete.
        "mobileNumber": PrefUtils.prefs!.getString('Mobilenum'),
      });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));

      if (responseJson['status'].toString() == "true") {
        if (responseJson['type'].toString() == "old") {
          Navigator.of(context).pop();
           Fluttertoast.showToast(msg: S .of(context).mobile_exists,//"Mobile number already exists!!!",
            fontSize: MediaQuery.of(context).textScaleFactor *13,);
        } else if (responseJson['type'].toString() == "new") {

          LoginUser();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          return alertOtpWeb(context);
        }
      } else {
         Fluttertoast.showToast(msg: S .of(context).something_went_wrong,//"Something went wrong!!!",
          fontSize: MediaQuery.of(context).textScaleFactor *13,);
      }
    } catch (error) {
      throw error;
    }
  }
  Future<void> LoginUser() async {
    // imp feature in adding async is the it automatically wrap into Future.
    try {
      final response = await http.post(Api.preRegister, body: {
        // await keyword is used to wait to this operation is complete.
        "mobileNumber": PrefUtils.prefs!.getString('Mobilenum'),
        "tokenId": PrefUtils.prefs!.getString('tokenid'),
        "signature" : PrefUtils.prefs!.containsKey("signature") ? PrefUtils.prefs!.getString('signature') : "",
        "branch" : PrefUtils.prefs!.getString("branch"),
      });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      print("response...login"+responseJson.toString());
      final data = responseJson['data'] as Map<String, dynamic>;

      if (responseJson['status'].toString() == "true") {
        fas.LogLogin();
        if(responseJson['type'].toString() == "new") {
          PrefUtils.prefs!.setString('Otp', data['otp'].toString());
          PrefUtils.prefs!.setString('type', responseJson['type'].toString());
        } else {
          PrefUtils.prefs!.setString('Otp', data['otp'].toString());
          PrefUtils.prefs!.setString('apiKey', data['apiKey'].toString());
          PrefUtils.prefs!.setString('userID', data['userID'].toString());
          PrefUtils.prefs!.setString('type', responseJson['type'].toString());
          PrefUtils.prefs!.setString('membership', data['membership'].toString());
          PrefUtils.prefs!.setString("mobile", data['mobile'].toString());
          PrefUtils.prefs!.setString("latitude", data['latitude'].toString());
          PrefUtils.prefs!.setString("longitude", data['longitude'].toString());
          PrefUtils.prefs!.setString('apple', data['apple'].toString());

          if (PrefUtils.prefs!.getString('prevscreen') != null) {
            if (PrefUtils.prefs!.getString('prevscreen') == 'signingoogle') {} else
            if (PrefUtils.prefs!.getString('prevscreen') == 'signinfacebook') {} else {
              PrefUtils.prefs!.setString('FirstName', data['name'].toString());
              PrefUtils.prefs!.setString('LastName', "");
              PrefUtils.prefs!.setString('Email', data['email'].toString());
              PrefUtils.prefs!.setString("photoUrl", "");
            }
          }
          await Provider.of<BrandItemsList>(navigatorKey.currentContext!,listen: false).userDetails();
//        Navigator.of(context).pushNamed(
//          OtpconfirmScreen.routeName,
//        );
        }
      } else if (responseJson['status'].toString() == "false") {}
    } catch (error) {
      throw error;
    }
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

  additemtolist(BuildContext context) {
    _dialogforProceesing(context, "Add item to list...");
    for (int i = 0; i < shoplistData.length; i++) {
      print("shopping list length....."+shoplistData.length.toString());
      //adding item to multiple list
      final cartItemList = (VxState.store as GroceStore).CartItemList;
      if (shoplistData[i].listcheckbox!) {
        for (int j = 0; j < cartItemList.length; j++) {
          Provider.of<BrandItemsList>(context,listen: false)
              .AdditemtoShoppinglist(
              cartItemList[j].itemId.toString(),
              cartItemList[j].varId.toString(),
              shoplistData[i].id!,
              cartItemList[j].type.toString())
              .then((_) {
           // Navigator.of(context).pop();
            print("navigateion add cart....");
            if (i == (shoplistData.length - 1) &&
                j == (cartItemList.length - 1)) {

              print("navigateion add cart....if");
              _auth.getuserProfile(onsucsess: (value){
                shoplistData = (VxState.store as GroceStore).ShoppingList;
                shoplistData[i].listcheckbox = false;
                Navigator.of(context).pop();
              },onerror: (){

              });

              for (int i = 0; i < shoplistData.length; i++) {
                shoplistData[i].listcheckbox = false;
              }
            }
          });
        }
      }
    }
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

  _dialogforCreatelist(BuildContext context) {
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
                        S .of(context).create_shopping_list,//'Create shopping list',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).primaryColor,
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
                                  return S .of(context).please_enter_list_name;//'Please enter a list name.';
                                }
                                return null; //it means user entered a valid input
                              },
                              onSaved: (value) {
                                addListnameToSF(value!);
                              },
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: S .of(context).shopping_list_name,//"Shopping list name",
                                labelStyle: TextStyle(
                                    color: ColorCodes.primaryColor,/*Theme.of(context).accentColor*/),
                                contentPadding: EdgeInsets.all(12),
                                hintText: 'ex: Monthly Grocery',
                                hintStyle: TextStyle(
                                    color: Colors.black12, fontSize: 10.0),
                                //prefixIcon: Icon(Icons.alternate_email, color: Theme.of(context).accentColor),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .focusColor
                                            .withOpacity(0.2))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .focusColor
                                            .withOpacity(0.5))),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
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
                          _saveForm();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          child: Center(
                              child: Text(
                                S .of(context).create_shopping_list,//'Create Shopping List',
                                textAlign: TextAlign.center,
                                style:
                                TextStyle(color: Theme.of(context).buttonColor),
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
                          width: MediaQuery.of(context).size.width,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          child: Center(
                              child: Text(
                                S .of(context).cancel,//'Cancel',
                                textAlign: TextAlign.center,
                                style:
                                TextStyle(color: Theme.of(context).buttonColor),
                              )),
                        ),
                      ),
                    ],
                  )),
            );
          });
        });
  }

  _dialogforShoppinglist(BuildContext contexts) {
    return showDialog(
        context: contexts,
        builder: (context) {
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
                          S .of(context).add_to_list,//'Add to list',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Theme.of(context).primaryColor,
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
                            itemBuilder: (_, i) => Row(
                              children: [
                                Checkbox(
                                  checkColor: ColorCodes.primaryColor,
                                  activeColor: ColorCodes.whiteColor,
                                  value: shoplistData[i].listcheckbox,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      shoplistData[i]
                                          .listcheckbox = value;
                                    });
                                  },
                                ),
                                Text(shoplistData[i].name!,
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
                            _dialogforCreatelist(context);
                            for (int i = 0;
                            i < shoplistData.length;
                            i++) {
                              shoplistData[i].listcheckbox =
                              false;
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
                                S .of(context).create_new,//"Create New",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 16.0),
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
                            for (int i = 0;
                            i < shoplistData.length;
                            i++) {
                              if (shoplistData[i].listcheckbox!)
                                setState(() {
                                  check = true;
                                });
                            }
                            if (check) {

                              Navigator.of(context).pop();
                              additemtolist(contexts);
                            } else {
                              Fluttertoast.showToast(
                                  msg: S .of(context).please_select_atleastonelist,//"Please select atleast one list!",
                                  fontSize: MediaQuery.of(context).textScaleFactor *13,
                                  backgroundColor: Colors.black87,
                                  textColor: Colors.white);
                            }
                          },
                          child: Container(
                            width: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                            child: Center(
                                child: Text(
                                  S .of(context).cart_add,//'Add',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.of(context).buttonColor),
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            for (int i = 0;
                            i < shoplistData.length;
                            i++) {
                              shoplistData[i].listcheckbox =
                              false;
                            }
                          },
                          child: Container(
                            width: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                            child: Center(
                                child: Text(
                                  S .of(context).cancel,//'Cancel',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.of(context).buttonColor),
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

  //login process
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

  Iterable<TimeOfDay> getTimes(
      TimeOfDay startTime, TimeOfDay endTime, Duration step) sync* {
    var hour = startTime.hour;
    var minute = startTime.minute;

    do {
      yield TimeOfDay(hour: hour, minute: minute);
      minute += step.inMinutes;
      while (minute >= 60) {
        minute -= 60;
        hour++;
      }
    } while (hour < endTime.hour ||
        (hour == endTime.hour && minute <= endTime.minute));
  }

  changeStore(String storeId) {
    _dialogforProcessing();
    Provider.of<DeliveryslotitemsList>(context,listen: false).fetchPickupslots(storeId).then((_) {
      setState(() {
        pickupTime = Provider.of<DeliveryslotitemsList>(context, listen: false);
        for(int i = 0; i < pickuplocItem.itemspickuploc.length; i++) {
          setState(() {
            if(i == 0) {
              pickuplocItem.itemspickuploc[i].selectedColor = ColorCodes.mediumgren;
              pickuplocItem.itemspickuploc[i].isSelect = true;
            } else {
              pickuplocItem.itemspickuploc[i].selectedColor = ColorCodes.whiteColor;
              pickuplocItem.itemspickuploc[i].isSelect = false;
            }
          });
        }
        for(int i = 0; i < pickupTime.itemsPickup.length; i++) {
          setState(() {
            if(i == 0) {
              pickupTime.itemsPickup[i].selectedColor = ColorCodes.mediumgren;
              pickupTime.itemsPickup[i].isSelect = true;
            } else {
              pickupTime.itemsPickup[i].selectedColor = ColorCodes.whiteColor;
              pickupTime.itemsPickup[i].isSelect = false;
            }
          });
        }
        if (pickupTime.itemsPickup.length > 0) {
          _isPickupSlots = true;
          selectTime = pickupTime.itemsPickup[0].time;
          selectDate = pickupTime.itemsPickup[0].date;
        } else {
          _isPickupSlots = false;
        }
      });
      Navigator.of(context).pop();
    });
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
                                      S .of(context).country_region,
                                      //"Country/Region",
                                      style: TextStyle(
                                        color: ColorCodes.greyColor,
                                      )),
                                  Text(countryName! + " (" + IConstants.countryCode + ")",
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
                                          hintText: S .of(context).enter_yor_mobile_number,//'Enter Your Mobile Number',
                                          hintStyle: TextStyle(
                                            color: Colors.black12,
                                          )),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return S .of(context).please_enter_phone_number;//'Please enter a Mobile number.';
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
                            S .of(context).we_will_call_or_text,// "We'll call or text you to confirm your number. Standard message data rates apply.",
                            style: TextStyle(
                                fontSize: 13, color: ColorCodes.mediumBlackWebColor),
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
                                    color: ColorCodes.blackColor),
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
                                        Navigation(context, name: Routename.Policy, navigatore: NavigatoreTyp.Push,
                                            parms: {"title": S.of(context).terms_of_use/*, "body" :IConstants.restaurantTerms*/});
                                      }),
                                new TextSpan(text: S .of(context).and//' and'
                                ),
                                new TextSpan(
                                    text: S .of(context).privacy_policy,//' Privacy Policy',
                                    style:
                                    new TextStyle(color: ColorCodes.darkthemeColor),
                                    recognizer: new TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigation(context, name: Routename.Policy, navigatore: NavigatoreTyp.Push,
                                            parms: {"title": S.of(context).privacy/*, "body" :PrefUtils.prefs!.getString("privacy").toString()*/});
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
                                  color:ColorCodes.greyColor,
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
                                          fontSize: 10.0, color: ColorCodes.greyColor),
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
                                            //SvgPicture.asset(Images.googleImg, width: 25, height: 25,),
                                            Image.asset(Images.googlewebImg,width: 20,height: 20,),
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

                                      // border: Border.all(width: 0.5, color: ColorCodes.borderColor),
                                    ),
                                    child:
                                    Padding(
                                      padding: const EdgeInsets.only(right:23.0,left: 23),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            // SvgPicture.asset(Images.facebookImg, width: 25, height: 25,),
                                            Image.asset(Images.facebookwebImg,width: 20,height: 20,),
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
                                              // Image.asset(Images.appleImg,width: 21,height: 21,),
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

  _dialogforMobileNumber() {
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
                child: Column(children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width ,
                      padding: EdgeInsets.only(left:10, right: 10),
                      margin: EdgeInsets.only(top: 40.0, bottom: 20.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text( S .of(context).please_enter_your_mobile,//'Please enter your mobile number',
                            style: TextStyle(color: ColorCodes.mediumBlackWebColor, fontWeight: FontWeight.bold, fontSize: 18),))),
                  Container(
                    width: MediaQuery.of(context).size.width / 3.5,
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
                            Text(countryName! + " (" + IConstants.countryCode + ")",
                                style: TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.bold))
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 3.5,
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
                            width: MediaQuery.of(context).size.width /3.5,
                            child: Form(
                              key: _form,
                              child: TextFormField(
                                style: TextStyle(fontSize: 16.0),
                                controller: _mobilecontroller,
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
                                /* onSaved: (value) {
                                  addMobilenumToSF(value);
                                },*/
                              ),
                            ))
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 3.5,
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

                                _dialogforProcessing();
                                PrefUtils.prefs!.setString("Mobilenum", _mobilecontroller.text);
                                //_saveFormWeb();
                                checkMobilenum();
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
          });
        });
  }

  addMobilenumToSF(String value) async {
    PrefUtils.prefs!.setString('Mobilenum', value);
  }

  addReferralToSF(String value)async{
    PrefUtils.prefs!.setString('referid', value);
  }

  _verifyOtp() async {
    //var otpval = otp1 + otp2 + otp3 + otp4;

    //SharedPreferences prefs = await SharedPreferences.getInstance();

    if (controller.text == PrefUtils.prefs!.getString('Otp')) {
      setState(() {
        _isLoading = true;
      });

      if (PrefUtils.prefs!.getString('type') == "old") {
        PrefUtils.prefs!.setString('LoginStatus', "true");
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
          }*/
          name = store.userData.username!;
          //name = PrefUtils.prefs!.getString('FirstName') + " " + PrefUtils.prefs!.getString('LastName');
          if (PrefUtils.prefs!.getString('prevscreen') == 'signInAppleNoEmail') {
            email = "";
          } else {
            email = PrefUtils.prefs!.getString('Email')!;
          }
          mobile = PrefUtils.prefs!.getString('Mobilenum')!;
          tokenid = PrefUtils.prefs!.getString('tokenid')!;

          if (store.userData.mobileNumber != null) {
            phone = store.userData.mobileNumber!;
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
      //_customToast("Please enter a valid otp!!!");
      return Fluttertoast.showToast(
          msg: S .of(context).please_enter_valid_otp,//"Please enter a valid otp!!!",
          fontSize: MediaQuery.of(context).textScaleFactor *13,
          backgroundColor: Colors.black87,
          textColor: Colors.white);
    }
  }
  _verifyOtpWeb() async{
    //var otpval = otp1 + otp2 + otp3 + otp4;

    //SharedPreferences prefs = await SharedPreferences.getInstance();

    if (controller.text == PrefUtils.prefs!.getString('Otp')) {
      setState(() {
        _isLoading = true;
      });
      verifynum();
    } else {
      await Future.delayed(Duration(seconds: 2));
      Navigator.of(context).pop();
      //_customToast("Please enter a valid otp!!!");
      return Fluttertoast.showToast(
          msg: S .of(context).please_enter_valid_otp,//"Please enter a valid otp!!!",
          fontSize: MediaQuery.of(context).textScaleFactor *13,
          backgroundColor: Colors.black87,
          textColor: Colors.white);
    }
  }

  _saveAddInfoForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    } //it will check all validators
    _form.currentState!.save();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    //checkemail();
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
      //SharedPreferences prefs = await SharedPreferences.getInstance();

      final response = await http.post(Api.emailCheck, body: {
        // await keyword is used to wait to this operation is complete.
        "email": PrefUtils.prefs!.getString('Email'),
      });
      final responseJson = json.decode(response.body);

      if (responseJson['status'].toString() == "true") {
        if (responseJson['type'].toString() == "old") {
          Navigator.of(context).pop();
          (Vx.isWeb)?Navigator.of(context).pop():null;
          //Fluttertoast.showToast(msg: 'Email id already exists!!!');
           Fluttertoast.showToast(
              msg: S .of(context).email_exist,//"Email id already exists",
              fontSize: MediaQuery.of(context).textScaleFactor *13,
              backgroundColor: Colors.black87,
              textColor: Colors.white);
        } else if (responseJson['type'].toString() == "new") {
          return SignupUser();
        }
      } else {
         Fluttertoast.showToast(msg: S .of(context).something_went_wrong//"Something went wrong!!!"
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
        "branch": PrefUtils.prefs!.getString('branch') /*'999'*/,
        "signature":
        PrefUtils.prefs!.containsKey("signature") ? PrefUtils.prefs!.getString('signature') : "",
        "referralid": _referController.text,
        "device": channel.toString(),

      });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      final data = responseJson['data'] as Map<String, dynamic>;

      if (responseJson['status'].toString() == "true") {
        PrefUtils.prefs!.setString('apiKey', data['apiKey'].toString());
        PrefUtils.prefs!.setString('userID', responseJson['userId'].toString());
        PrefUtils.prefs!.setString('membership', responseJson['membership'].toString());
        PrefUtils.prefs!.setString('referral', PrefUtils.prefs!.getString('referralCode')!);
        PrefUtils.prefs!.setString('referid', _referController.text);

        PrefUtils.prefs!.setString('LoginStatus', "true");
        setState(() {

        /*  if (PrefUtils.prefs!.getString('FirstName') != null) {
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
          name = store.userData.username!;
          //name = PrefUtils.prefs!.getString('FirstName') + " " + PrefUtils.prefs!.getString('LastName');
          if (PrefUtils.prefs!.getString('prevscreen') == 'signInAppleNoEmail') {
            email = "";
          } else {
            email = PrefUtils.prefs!.getString('Email')!;
          }
          mobile = PrefUtils.prefs!.getString('Mobilenum')!;
          tokenid = PrefUtils.prefs!.getString('tokenid')!;

          if (store.userData.mobileNumber != null) {
            phone = store.userData.mobileNumber!;
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
         /*Navigator.of(context).pushNamedAndRemoveUntil(
            MapScreen.routeName, ModalRoute.withName('/'));*/
      } else if (responseJson['status'].toString() == "false") {}
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      throw error;
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

        Navigator.of(context).pop();
        Navigator.of(context).pop();
        if (addressitemsData.items.length > 0) {
          Navigator.of(context).pushReplacementNamed(
              CartScreen.routeName,
              arguments: {
                "prev": "cart_screen",
                "afterlogin": ""});
        } else {
         /* Navigator.of(context).pushNamedAndRemoveUntil(
              AddressScreen.routeName,
              ModalRoute.withName(CartScreen.routeName), arguments: {
            'addresstype': "new",
            'addressid': "",
            'delieveryLocation': "",
            'latitude': "",
            'longitude': "",
            'branch': "",
            "afterlogin": ""
          });*/

          if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
            // _dialogforaddress(context);
            AddressWeb(context,
              addresstype: "new",
              addressid: "",
              delieveryLocation: "",
              latitude: "",
              longitude: "",
              branch: "",);
          }
          else {
            Navigation(context, name: Routename.AddressScreen,
                navigatore: NavigatoreTyp.Push,
                qparms: {
                  'addresstype': "new",
                  'addressid': "",
                  'delieveryLocation': "",
                  'latitude': "",
                  'longitude': "",
                  'branch': "",
                });
          }
          /*Navigator.of(context).pushNamed(
              AddressScreen.routeName,
              arguments: {
                'addresstype': "new",
                'addressid': "",
                'delieveryLocation': "",
                'latitude': "",
                'longitude': "",
                'branch': ""
              });*/
        }
        /*return  Navigator.of(context).pushReplacementNamed(
           ConfirmorderScreen.routeName,
           arguments: {
             "prev": "address_screen",
           });*/

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

  Future<void> SignupUser() async {
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
      String apple = "";
      if (PrefUtils.prefs!.getString('applesignin') == "yes") {
        apple = PrefUtils.prefs!.getString('apple')!;
      } else {
        apple = "";
      }

      String name =
          PrefUtils.prefs!.getString('FirstName').toString() + " " + PrefUtils.prefs!.getString('LastName').toString();

      final response = await http.post(Api.register, body: {
        // await keyword is used to wait to this operation is complete.
        "username": name,
        "email": PrefUtils.prefs!.getString('Email'),
        "mobileNumber": PrefUtils.prefs!.containsKey("Mobilenum") ? PrefUtils.prefs!.getString('Mobilenum') : "",
        "path": apple,
        "tokenId": PrefUtils.prefs!.getString('tokenid'),
        "branch": PrefUtils.prefs!.getString('branch'),
        "signature":
        PrefUtils.prefs!.containsKey("signature") ? PrefUtils.prefs!.getString('signature') : "",
        "referralid": _referController.text,
        "device": channel.toString(),
      });
      final responseJson = json.decode(response.body);

      if (responseJson['status'].toString() == "true") {
        final data = responseJson['data'] as Map<String, dynamic>;
        PrefUtils.prefs!.setString('apiKey', data['apiKey'].toString());
        PrefUtils.prefs!.setString('userID', responseJson['userId'].toString());
        PrefUtils.prefs!.setString('membership', responseJson['membership'].toString());
        PrefUtils.prefs!.setString("mobile", PrefUtils.prefs!.getString('Mobilenum')!);
        PrefUtils.prefs!.setString('referral', PrefUtils.prefs!.getString('referralCode')!);
        PrefUtils.prefs!.setString('referid', _referController.text);

        PrefUtils.prefs!.setString('LoginStatus', "true");
        setState(() {

          /*if (PrefUtils.prefs!.getString('FirstName') != null) {
            if (PrefUtils.prefs!.getString('LastName') != null) {
              name = PrefUtils.prefs!.getString('FirstName'.toString()) +
                  " " +
                  PrefUtils.prefs!.getString('LastName'.toString());
            } else {
              name = PrefUtils.prefs!.getString('FirstName'.toString());
            }
          } else {
            name = "";
          }*/
          name = store.userData.username!;
          //name = PrefUtils.prefs!.getString('FirstName') + " " + PrefUtils.prefs!.getString('LastName');
          if (PrefUtils.prefs!.getString('prevscreen') == 'signInAppleNoEmail') {
            email = "";
          } else {
            email = PrefUtils.prefs!.getString('Email'.toString())!;
          }
          mobile = PrefUtils.prefs!.getString('Mobilenum'.toString())!;
          tokenid = PrefUtils.prefs!.getString('tokenid')!;

          if (store.userData.mobileNumber != null) {
            phone = PrefUtils.prefs!.getString('mobile'.toString())!;
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
        //PrefUtils.prefs!.setString("fromcart", "cart_screen");
        //  Navigator.of(context).pushReplacementNamed(MapScreen.routeName);
        if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
          // _dialogforaddress(context);
          MapWeb(context);
        }
        else {
          Navigation(context, name: Routename.MapScreen,
              navigatore: NavigatoreTyp.Push);
        }
        /* return Navigator.pushNamedAndRemoveUntil(

            context, HomeScreen.routeName, (route) => false);*/

        /*Navigator.of(context).pushReplacementNamed(
          HomeScreen.routeName,
        );*/

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
    //  SharedPreferences prefs = await SharedPreferences.getInstance();
    PrefUtils.prefs!.setString('FirstName', value);
  }

  addLastnameToSF(String value) async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    PrefUtils.prefs!.setString('LastName', value);
  }

  addEmailToSF(String value) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
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
                    : MediaQuery.of(context).size.width / 3,
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
                                      fontSize: 17, color: ColorCodes.lightBlack),
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  textAlign: TextAlign.left,
                                  controller: firstnamecontroller,
                                  decoration: InputDecoration(
                                    hintText: S .of(context).name,//'Name',
                                    hoverColor: Colors.green,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                      BorderSide(color: Colors.grey),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                      BorderSide(color: Colors.green),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                      BorderSide(color: Colors.green),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                      BorderSide(color: Colors.green),
                                    ),
                                  ),
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_lnameFocusNode);
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
                                Text(
                                  fn,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(color: Colors.red),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  S .of(context).tell_us_your_email,//'Tell us your e-mail',
                                  style: TextStyle(
                                      fontSize: 17, color: ColorCodes.lightBlack),
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
                                    hintText: 'xyz@gmail.com',
                                    fillColor: Colors.green,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                      BorderSide(color: Colors.grey),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                      BorderSide(color: Colors.green),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                      BorderSide(color: Colors.green),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide(
                                          color: Colors.green, width: 1.2),
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

                                SizedBox(
                                  height: 15.0,
                                ),
                                if(Features.isReferEarn)
                                  Text(
                                    S .of(context).apply_referal_code,//'Apply referral Code',
                                    style: TextStyle(fontSize: 17, color: ColorCodes.lightBlack),
                                  ),
                                if(Features.isReferEarn)
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                if(Features.isReferEarn)
                                  TextFormField(
                                    controller: _referController,
                                    textAlign: TextAlign.left,
                                    style: new TextStyle(
                                        decorationColor: Theme.of(context).primaryColor),
                                    decoration: InputDecoration(
                                      hintText: S .of(context).refer_earn,//'Refer and Earn',
                                      fillColor: Colors.green,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(color: Colors.grey),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(color: Colors.green),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(color: Colors.green),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(color: Colors.green, width: 1.2),
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
                                if(Features.isReferEarn)
                                  SizedBox(
                                    height: 10.0,
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
                              S .of(context).continue_button,// "CONTINUE",
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
                            S .of(context).signup_otp, //"Signup using OTP",
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
                                    color: ColorCodes.mediumBlackWebColor,
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
                                                color: ColorCodes.blackColor,
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
                                    color: ColorCodes.greyColor, fontSize: 14),
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
                                          ResponsiveLayout.isSmallScreen(context))
                                          ? MediaQuery.of(context).size.width * 50 / 100 : MediaQuery.of(context).size.width * 32 / 100,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(6),
                                        border: Border.all(
                                            color: ColorCodes.greyColor,
                                            width: 1.5),
                                      ),
                                      child: Center(
                                          child: Text(
                                            S .of(context).resend_otp, //'Resend OTP'
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
                                          color: ColorCodes.greyColor,
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
                                                color: Colors.green,
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
                                            ColorCodes.greyColor,
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
                                                  color: ColorCodes.lightGreyColor,
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
                                              color: Colors.green,
                                              width: 1.5),
                                        ),
                                        child: Center(
                                            child:
                                            Text(
                                              S .of(context).resend_otp,//'Resend OTP'
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
                                                color: ColorCodes.lightGreyColor,
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
                                        color: ColorCodes.greyColor,
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
                                          color: ColorCodes.greyColor,
                                          width: 1.5),
                                    ),
                                    child: Center(
                                        child: Text(
                                          S .of(context).call_me_instead,//'Call me Instead'
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

  void alertOtpWeb(BuildContext ctx) {
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
                            S .of(context).signup_otp, //"Signup using OTP",
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
                                    color: ColorCodes.mediumBlackWebColor,
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
                                    _dialogforMobileNumber();
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
                                                color: ColorCodes.blackColor,
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
                                    color: ColorCodes.greyColor, fontSize: 14),
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
                                            color: ColorCodes.greyColor,
                                            width: 1.5),
                                      ),
                                      child: Center(
                                          child: Text(
                                            S .of(context).resend_otp, //'Resend OTP'
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
                                          color: ColorCodes.greyColor,
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
                                                color: Colors.green,
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
                                            ColorCodes.greyColor,
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
                                                  color: ColorCodes.lightGreyColor,
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
                                              color: Colors.green,
                                              width: 1.5),
                                        ),
                                        child: Center(
                                            child:
                                            Text(
                                              S .of(context).resend_otp,//'Resend OTP'
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
                                                color: ColorCodes.lightGreyColor,
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
                                        color: ColorCodes.greyColor,
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
                                          color: ColorCodes.greyColor,
                                          width: 1.5),
                                    ),
                                    child: Center(
                                        child: Text(
                                          S .of(context).call_me_instead,//'Call me Instead'
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

                            _verifyOtpWeb();
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

  @override
  Widget build(BuildContext context) {
    VxState.watch(context, on: [SetCartItem]);
    queryData = MediaQuery.of(context);
    wid = queryData!.size.width;
    maxwid = wid! * 0.90;

    Future<void> openMap(double latitude, double longitude) async {
      String googleUrl =
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
      if (await canLaunch(googleUrl)) {
        await launch(googleUrl);
      } else {
        throw 'Could not open the map.';
      }
    }

    if (!_isLoading) if (VxState.store.userData.membership == "1") {
      _checkmembership = true;
    } else {
      _checkmembership = false;
    }


    for (int i = 0; i < cartItemList.length; i++) {
      if (cartItemList[i].mode == "1") {
        _checkmembership = true;
      }
      if (Features.ismultivendor && IConstants.isEnterprise) {
        for (int i = 0; i <
            (VxState.store as GroceStore).CartItemList.length; i++) {
          IConstants.storename =
          (VxState.store as GroceStore).CartItemList[i].restaurantName!;
        }
      }
    }
    print("membership check.....cartscreen"+(VxState.store.userData.membership.toString()));
    print("cart check membership..."+_checkmembership.toString());
    print("group 2 pickup...."+_groupCart.toString());

    _buildBottomNavigationBar(List<CartItem> cartItemList) {

      for(int i=0;i<cartItemList.length;i++)
        if(cartItemList.length<=1 && cartItemList[i].mode=="1") {
          slots = true;
        }else if(cartItemList[i].mode=="1"){
          slots = true;
        }
      if(slots)
        return  BottomNaviagation(
          itemCount: (CartCalculations.itemCount).toString() + " " + S
              .of(context)
              .items,
          title: Features.ismultivendor && !_checkaddress?S.of(context).add_address:S
              .of(context)
              .proceed_to_pay,
          total: Features.ismultivendor?_checkmembership ? (IConstants.numberFormat == "1")
              ?(CartCalculations.totalMember + deliveryfinalslotdate)
              .toStringAsFixed(0):(CartCalculations.totalMember + deliveryfinalslotdate)
              .toStringAsFixed(IConstants.decimaldigit)
              :
          (IConstants.numberFormat == "1")
              ?(CartCalculations.total + deliveryfinalslotdate).toStringAsFixed(0):(CartCalculations.total + deliveryfinalslotdate).toStringAsFixed(IConstants.decimaldigit):
          _checkmembership ? (IConstants.numberFormat == "1")
              ?(CartCalculations.totalMember)
              .toStringAsFixed(0):(CartCalculations.totalMember)
              .toStringAsFixed(IConstants.decimaldigit)
              :
          (IConstants.numberFormat == "1")
              ?(CartCalculations.total).toStringAsFixed(0):(CartCalculations.total).toStringAsFixed(IConstants.decimaldigit),
          onPressed: () {
            /* Navigator.of(context)
                    .pushNamed(OfferScreen.routeName);*/
            setState(() {
              if(cartItemList.where((element) => double.parse(element.varStock!) == 0 || element.status == "1").count() >= 1 ){
                _isunavailablepopup = true;
              }
               else{
                 _isunavailablepopup = false;
                 debugPrint("1...");
              if (!PrefUtils.prefs!.containsKey("apikey")) {
                PrefUtils.prefs!.setString("fromcart", "cart_screen");
               /* Navigator.of(context).pushReplacementNamed(
                    SignupSelectionScreen.routeName);*/
                debugPrint("2...");
                Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.PushReplacment);
              } else {
                debugPrint("3...");
               if (_groupCart == 2) {
              Navigation(context, name: Routename.PickupScreen, navigatore: NavigatoreTyp.Push);
              }
               else if (_checkmembership && ((double.parse((CartCalculations.totalMember).toStringAsFixed(
                   (IConstants.numberFormat == "1")
                       ? 0 : IConstants.decimaldigit)) <
                   double.parse(IConstants.minimumOrderAmount)) && cartItemList.length != 1)) {
                   Fluttertoast.showToast(msg: S
                       .of(context)
                       .min_order_amount /*"Minimum order amount is "*/ +
                       double.parse(
                           IConstants.minimumOrderAmount).toStringAsFixed(
                           (IConstants.numberFormat == "1")
                               ? 0 : IConstants.decimaldigit),
                     backgroundColor: Colors.black87,
                     textColor: Colors.white,
                     fontSize: MediaQuery
                         .of(context)
                         .textScaleFactor * 13,);
               }
                 else if(Features.isOffers && !_checkmembership){
                 debugPrint("4...");
                  if (store.userData.mobileNumber !=
                      "null" && store.userData.mobileNumber
                      .toString() != " ") {
                    debugPrint("5...");
                    if(Features.ismultivendor) {
                      addressdata = (VxState.store as GroceStore).userData;
                      if (addressdata!.billingAddress!=null&&addressdata!.billingAddress!.length > 0) {
                        addtype = addressdata!.billingAddress![0].addressType;
                        address = addressdata!.billingAddress![0].address;
                        name = addressdata!.billingAddress![0].fullName!;
                        addressicon = addressdata!.billingAddress![0].addressicon;
                        PrefUtils.prefs!.setString(
                            "addressId",
                            addressdata!.billingAddress![0].id.toString());
                        // calldeliverslots(addressdata.billingAddress[0].id.toString());
                        deliveryCharge(addressdata!.billingAddress![0].id.toString());
                        _checkaddress = true;
                       // checkLocation();
                        Navigation(context, name: Routename.PaymentScreen, navigatore: NavigatoreTyp.Push,
                            qparms: {
                              'minimumOrderAmountNoraml': _minimumOrderAmountNoraml,
                              'deliveryChargeNormal': _deliveryChargeNormal,
                              'minimumOrderAmountPrime': _minimumOrderAmountPrime,
                              'deliveryChargePrime': _deliveryChargePrime,
                              'minimumOrderAmountExpress': _minimumOrderAmountExpress,
                              'deliveryChargeExpress': _deliveryChargeExpress,
                              'addressId': PrefUtils.prefs!.getString(
                                  "addressId"),
                              'deliveryType': Features.ismultivendor?"OptionTwo":(_groupValueAdvance == 1)
                                  ? "Default"
                                  : "OptionTwo",
                              'note': _message.text,
                              'deliveryCharge': (_groupValueAdvance == 1)
                                  ? deliveryfinalslotdate.toString()
                                  : deliveryfinalslotdate.toString(),
                              'deliveryDurationExpress': _deliveryDurationExpress,
                              'fromScreen':'',
                              'responsejson':"",
                            });
                      } else {
                        if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                          // _dialogforaddress(context);
                          AddressWeb(context,
                            addresstype: "new",
                            addressid: "",
                            delieveryLocation: "",
                            latitude: "",
                            longitude: "",
                            branch: "",);
                        }
                        else {
                          Navigation(context, name: Routename.AddressScreen,
                              navigatore: NavigatoreTyp.Push,
                              qparms: {
                                'addresstype': "new",
                                'addressid': "",
                                'delieveryLocation': "",
                                'latitude': "",
                                'longitude': "",
                                'branch': "",
                              });
                        }
                      }
                    }else {
                      debugPrint("6...");

                      if (_checkmembership  && cartItemList.length == 1) {
                        debugPrint("9...if");
                        addressdata = (VxState.store as GroceStore).userData;
                        if (addressdata!.billingAddress != null &&
                            addressdata!.billingAddress!.length > 0) {
                          addtype = addressdata!.billingAddress![0].addressType;
                          address = addressdata!.billingAddress![0].address;
                          name = addressdata!.billingAddress![0].fullName!;
                          addressicon = addressdata!.billingAddress![0]
                              .addressicon;
                          PrefUtils.prefs!.setString(
                              "addressId",
                              addressdata!.billingAddress![0].id.toString());
                          // calldeliverslots(addressdata.billingAddress[0].id.toString());
                          deliveryCharge(addressdata!.billingAddress![0].id
                              .toString());
                          _checkaddress = true;
                          // checkLocation();
                          Navigation(context, name: Routename.PaymentScreen,
                              navigatore: NavigatoreTyp.Push,
                              qparms: {
                                'minimumOrderAmountNoraml': _minimumOrderAmountNoraml,
                                'deliveryChargeNormal': _deliveryChargeNormal,
                                'minimumOrderAmountPrime': _minimumOrderAmountPrime,
                                'deliveryChargePrime': _deliveryChargePrime,
                                'minimumOrderAmountExpress': _minimumOrderAmountExpress,
                                'deliveryChargeExpress': _deliveryChargeExpress,
                                'addressId': PrefUtils.prefs!.getString(
                                    "addressId"),
                                'deliveryType': Features.ismultivendor
                                    ? "OptionTwo"
                                    : (_groupValueAdvance == 1)
                                    ? "Default"
                                    : "OptionTwo",
                                'note': _message.text,
                                'deliveryCharge': (_groupValueAdvance == 1)
                                    ? deliveryfinalslotdate.toString()
                                    : deliveryfinalslotdate.toString(),
                                'deliveryDurationExpress': _deliveryDurationExpress,
                                'fromScreen': 'cartscreen',
                                'responsejson': "",
                              });
                        }
                        else {
                          if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                            // _dialogforaddress(context);
                            AddressWeb(context,
                              addresstype: "new",
                              addressid: "",
                              delieveryLocation: "",
                              latitude: "",
                              longitude: "",
                              branch: "",);
                          }
                          else {
                            Navigation(context, name: Routename.AddressScreen,
                                navigatore: NavigatoreTyp.Push,
                                qparms: {
                                  'addresstype': "new",
                                  'addressid': "",
                                  'delieveryLocation': "",
                                  'latitude': "",
                                  'longitude': "",
                                  'branch': "",
                                });
                          }
                        }
                      }
                      else {
                        Navigation(context, name: Routename.OfferScreen,
                            navigatore: NavigatoreTyp.Push,
                            qparms: {
                              "_groupValue": _groupCart
                            });
                      }
                    }
                  }
                  else {
                    /*Navigator.of(context)
                        .pushNamed(LoginScreen.routeName, arguments: {
                      "prev": "cartScreen"
                    });*/
                    debugPrint("7...");
                    Navigation(context, name:Routename.Login,navigatore: NavigatoreTyp.Push,
                        qparms: {
                          "prev": "cartScreen"
                        });
                  }
                }
                else {
                 debugPrint("8...");
                  if (store.userData.mobileNumber.toString() !=
                      "null" && store.userData.mobileNumber
                      .toString() != "") {

                   /* Navigator.of(context).pushNamed(
                        ConfirmorderScreen.routeName,
                        arguments: {"prev": "cart_screen"});*/

                    if(Features.ismultivendor) {
                      addressdata = (VxState.store as GroceStore).userData;
                      if (addressdata!.billingAddress!=null&&addressdata!.billingAddress!.length > 0) {
                        addtype = addressdata!.billingAddress![0].addressType;
                        address = addressdata!.billingAddress![0].address;
                        name = addressdata!.billingAddress![0].fullName!;
                        addressicon = addressdata!.billingAddress![0].addressicon;
                        PrefUtils.prefs!.setString(
                            "addressId",
                            addressdata!.billingAddress![0].id.toString());
                        // calldeliverslots(addressdata.billingAddress[0].id.toString());
                        deliveryCharge(addressdata!.billingAddress![0].id.toString());
                        _checkaddress = true;
                       // checkLocation();
                        Navigation(context, name: Routename.PaymentScreen, navigatore: NavigatoreTyp.Push,
                            qparms: {
                              'minimumOrderAmountNoraml': _minimumOrderAmountNoraml,
                              'deliveryChargeNormal': _deliveryChargeNormal,
                              'minimumOrderAmountPrime': _minimumOrderAmountPrime,
                              'deliveryChargePrime': _deliveryChargePrime,
                              'minimumOrderAmountExpress': _minimumOrderAmountExpress,
                              'deliveryChargeExpress': _deliveryChargeExpress,
                              'addressId': PrefUtils.prefs!.getString(
                                  "addressId"),
                              'deliveryType': Features.ismultivendor?"OptionTwo":(_groupValueAdvance == 1)
                                  ? "Default"
                                  : "OptionTwo",
                              'note': _message.text,
                              'deliveryCharge': (_groupValueAdvance == 1)
                                  ? deliveryfinalslotdate.toString()
                                  : deliveryfinalslotdate.toString(),
                              'deliveryDurationExpress': _deliveryDurationExpress,
                              'fromScreen':'',
                              'responsejson':"",
                            });
                      } else {

                        if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                          // _dialogforaddress(context);
                          AddressWeb(context,
                            addresstype: "new",
                            addressid: "",
                            delieveryLocation: "",
                            latitude: "",
                            longitude: "",
                            branch: "",);
                        }
                        else {
                          Navigation(context, name: Routename.AddressScreen,
                              navigatore: NavigatoreTyp.Push,
                              qparms: {
                                'addresstype': "new",
                                'addressid': "",
                                'delieveryLocation': "",
                                'latitude': "",
                                'longitude': "",
                                'branch': "",
                              });
                          }

                      }
                    }else {
                      debugPrint("9...");
                      if (_checkmembership && cartItemList[0].mode == "1" && cartItemList.length == 1) {
                        debugPrint("9...if");
                        addressdata = (VxState.store as GroceStore).userData;
                        if (addressdata!.billingAddress != null &&
                            addressdata!.billingAddress!.length > 0) {
                          addtype = addressdata!.billingAddress![0].addressType;
                          address = addressdata!.billingAddress![0].address;
                          name = addressdata!.billingAddress![0].fullName!;
                          addressicon = addressdata!.billingAddress![0]
                              .addressicon;
                          PrefUtils.prefs!.setString(
                              "addressId",
                              addressdata!.billingAddress![0].id.toString());
                          // calldeliverslots(addressdata.billingAddress[0].id.toString());
                          deliveryCharge(addressdata!.billingAddress![0].id
                              .toString());
                          _checkaddress = true;
                          // checkLocation();
                          Navigation(context, name: Routename.PaymentScreen,
                              navigatore: NavigatoreTyp.Push,
                              qparms: {
                                'minimumOrderAmountNoraml': _minimumOrderAmountNoraml,
                                'deliveryChargeNormal': _deliveryChargeNormal,
                                'minimumOrderAmountPrime': _minimumOrderAmountPrime,
                                'deliveryChargePrime': _deliveryChargePrime,
                                'minimumOrderAmountExpress': _minimumOrderAmountExpress,
                                'deliveryChargeExpress': _deliveryChargeExpress,
                                'addressId': PrefUtils.prefs!.getString(
                                    "addressId"),
                                'deliveryType': Features.ismultivendor
                                    ? "OptionTwo"
                                    : (_groupValueAdvance == 1)
                                    ? "Default"
                                    : "OptionTwo",
                                'note': _message.text,
                                'deliveryCharge': (_groupValueAdvance == 1)
                                    ? deliveryfinalslotdate.toString()
                                    : deliveryfinalslotdate.toString(),
                                'deliveryDurationExpress': _deliveryDurationExpress,
                                'fromScreen': 'cartscreen',
                                'responsejson': "",
                              });
                        }
                        else {
                          if (Vx.isWeb &&
                              !ResponsiveLayout.isSmallScreen(context)) {
                            // _dialogforaddress(context);
                            AddressWeb(context,
                              addresstype: "new",
                              addressid: "",
                              delieveryLocation: "",
                              latitude: "",
                              longitude: "",
                              branch: "",);
                          }
                          else {
                            Navigation(context, name: Routename.AddressScreen,
                                navigatore: NavigatoreTyp.Push,
                                qparms: {
                                  'addresstype': "new",
                                  'addressid': "",
                                  'delieveryLocation': "",
                                  'latitude': "",
                                  'longitude': "",
                                  'branch': "",
                                });
                          }
                        }
                      }
                      else {
                        debugPrint("9...else");
                        Navigation(context, name: Routename.ConfirmOrder,
                            navigatore: NavigatoreTyp.Push,
                            parms: {"prev": "cart_screen"});
                      }
                    }



                    /*Features.ismultivendor?
                    Navigation(context, name: Routename.PaymentScreen, navigatore: NavigatoreTyp.Push,
                        qparms: {
                          'minimumOrderAmountNoraml': _minimumOrderAmountNoraml,
                          'deliveryChargeNormal': _deliveryChargeNormal,
                          'minimumOrderAmountPrime': _minimumOrderAmountPrime,
                          'deliveryChargePrime': _deliveryChargePrime,
                          'minimumOrderAmountExpress': _minimumOrderAmountExpress,
                          'deliveryChargeExpress': _deliveryChargeExpress,
                          'addressId': PrefUtils.prefs!.getString(
                              "addressId"),
                          'deliveryType': (_groupValueAdvance == 1)
                              ? "Default"
                              : "OptionTwo",
                          'note': _message.text,
                          'deliveryCharge': (_groupValueAdvance == 1)
                              ? delCharge.toString()
                              : delCharge.toString(),
                          'deliveryDurationExpress': _deliveryDurationExpress,
                          'fromScreen':'',
                          'responsejson':"",
                        }):
                    Navigation(context, name:Routename.ConfirmOrder,navigatore: NavigatoreTyp.Push,
                        parms:{"prev": "cart_screen"});*/
                  }
                  else {
                    /*Navigator.of(context)
                        .pushNamed(LoginScreen.routeName, arguments: {
                      "prev": "cartScreen"
                    });*/
                    debugPrint("10...");
                    Navigation(context, name:Routename.Login,navigatore: NavigatoreTyp.Push,
                        qparms: {
                          "prev": "cartScreen"
                        });
                  }
                }
              }
              }
            });
          },
        );
      return (_checkmembership
          ?
      (double.parse((CartCalculations.totalMember).toStringAsFixed(
          (IConstants.numberFormat == "1")
              ?0:IConstants.decimaldigit)) <
          double.parse(IConstants.minimumOrderAmount) || double.parse(
          (CartCalculations.totalMember).toStringAsFixed(
              (IConstants.numberFormat == "1")
                  ?0:IConstants.decimaldigit)) >
          double.parse(IConstants.maximumOrderAmount))
          :
      (double.parse(
          (CartCalculations.total).toStringAsFixed((IConstants.numberFormat == "1")
              ?0:IConstants.decimaldigit)) <
          double.parse(IConstants.minimumOrderAmount) || double.parse(
          (CartCalculations.total).toStringAsFixed((IConstants.numberFormat == "1")
              ?0:IConstants.decimaldigit)) >
          double.parse(IConstants.maximumOrderAmount)))
          ?
      BottomNaviagation(
        itemCount: (CartCalculations.itemCount).toString() + " " + S
            .of(context)
            .items,
        title: S
            .of(context)
            .proceed_to_pay,
        total: Features.ismultivendor?
        _checkmembership ? (CartCalculations.totalMember + deliveryfinalslotdate)
            .toStringAsFixed((IConstants.numberFormat == "1")
            ?0:IConstants.decimaldigit)
            :
        (CartCalculations.total + deliveryfinalslotdate).toStringAsFixed((IConstants.numberFormat == "1")
            ?0:IConstants.decimaldigit)
            :_checkmembership ? (CartCalculations.totalMember)
            .toStringAsFixed((IConstants.numberFormat == "1")
            ?0:IConstants.decimaldigit)
            :
        (CartCalculations.total).toStringAsFixed((IConstants.numberFormat == "1")
            ?0:IConstants.decimaldigit),
        onPressed: () {
          setState(() {
            if(cartItemList.where((element) => double.parse(element.varStock!) == 0 || element.status == "1").count() >= 1 ){
              _isunavailablepopup = true;
            }
            else {
            _isunavailablepopup = false;
              if (_checkmembership) {
                print("member.......");
                debugPrint("11...");
                if (double.parse((CartCalculations.totalMember).toStringAsFixed(
                    (IConstants.numberFormat == "1")
                        ? 0 : IConstants.decimaldigit)) <
                    double.parse(IConstants.minimumOrderAmount)) {
                  Fluttertoast.showToast(msg: S
                      .of(context)
                      .min_order_amount /*"Minimum order amount is "*/ +
                      double.parse(
                          IConstants.minimumOrderAmount).toStringAsFixed(
                          (IConstants.numberFormat == "1")
                              ? 0 : IConstants.decimaldigit),
                    backgroundColor: Colors.black87,
                    textColor: Colors.white,
                    fontSize: MediaQuery
                        .of(context)
                        .textScaleFactor * 13,);
                } else {
                  Fluttertoast.showToast(msg: S
                      .of(context)
                      .max_order_amount /*"Maximum order amount is "*/ +
                      IConstants
                          .maximumOrderAmount,
                    backgroundColor: Colors.black87,
                    textColor: Colors.white,
                    fontSize: MediaQuery
                        .of(context)
                        .textScaleFactor * 13,);
                }
              }
              else {
                print("member.......non");
                debugPrint("12...");
                if (double.parse((CartCalculations.total).toStringAsFixed(
                    IConstants.numberFormat == "1" ? 0 : IConstants
                        .decimaldigit)) <
                    double.parse(IConstants.minimumOrderAmount)) {
                  Fluttertoast.showToast(msg: S
                      .of(context)
                      .min_order_amount /*"Minimum order amount is "*/ +
                      double.parse(
                          IConstants.minimumOrderAmount).toStringAsFixed(
                          IConstants.numberFormat == "1" ? 0 : IConstants
                              .decimaldigit),
                    backgroundColor: Colors.black87,
                    textColor: Colors.white,
                    fontSize: MediaQuery
                        .of(context)
                        .textScaleFactor * 13,);
                } else {
                  Fluttertoast.showToast(msg: S
                      .of(context)
                      .max_order_amount /*"Maximum order amount is "*/ +
                      IConstants
                          .maximumOrderAmount,
                    backgroundColor: Colors.black87,
                    textColor: Colors.white,
                    fontSize: MediaQuery
                        .of(context)
                        .textScaleFactor * 13,);
                }
              }
            }
          });
        },
      ) :
      /*(_isDiscounted)? SizedBox.shrink():*/
      BottomNaviagation(
        itemCount: (CartCalculations.itemCount).toString() + " " + S
            .of(context)
            .items,
        title: Features.ismultivendor && !_checkaddress?S.of(context).add_address:S
            .of(context)
            .proceed_to_pay,
        total: Features.ismultivendor?
        _checkmembership ? (CartCalculations.totalMember + deliveryfinalslotdate)
            .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)
            :
        (CartCalculations.total + deliveryfinalslotdate).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit):
        _checkmembership ? (CartCalculations.totalMember)
            .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)
            :
        (CartCalculations.total).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
        onPressed: () {
          /* Navigator.of(context)
                    .pushNamed(OfferScreen.routeName);*/
          setState(() {

            if(cartItemList.where((element) => double.parse(element.varStock!) == 0 || element.status == "1").count() >= 1 ){
              _isunavailablepopup = true;
            }
            else {
              _isunavailablepopup = false;
              debugPrint("13...");
              if (!PrefUtils.prefs!.containsKey("apikey")) {
                debugPrint("14...");
                PrefUtils.prefs!.setString("fromcart", "cart_screen");
                /* Navigator.of(context).pushReplacementNamed(
                  SignupSelectionScreen.routeName);*/
                Navigation(context, name: Routename.SignUpScreen,
                    navigatore: NavigatoreTyp.Push);
              } else {
                debugPrint("15...");
                if (_groupCart == 2) {
                  /* Navigator.of(context)
                    .pushNamed(PickupScreen.routeName);*/
                  Navigation(context, name: Routename.PickupScreen,
                      navigatore: NavigatoreTyp.Push);
                }
                else if (Features.isOffers && !_checkmembership) {
                  debugPrint("16...");
                  if (store.userData.mobileNumber.toString() != "null" &&
                      store.userData.mobileNumber.toString() != "") {
                    /*  Navigator.of(context).pushNamed(
                            ConfirmorderScreen.routeName,
                            arguments: {"prev": "cart_screen"});*/
                    /* Navigator.of(context).pushReplacementNamed(
                      OfferScreen.routeName,
                      arguments: {"_groupValue": _groupCart});*/

                    if (Features.ismultivendor) {
                      addressdata = (VxState.store as GroceStore).userData;
                      if (addressdata!.billingAddress != null &&
                          addressdata!.billingAddress!.length > 0) {
                        addtype = addressdata!.billingAddress![0].addressType;
                        address = addressdata!.billingAddress![0].address;
                        name = addressdata!.billingAddress![0].fullName!;
                        addressicon = addressdata!.billingAddress![0]
                            .addressicon;
                        PrefUtils.prefs!.setString(
                            "addressId",
                            addressdata!.billingAddress![0].id.toString());
                        // calldeliverslots(addressdata.billingAddress[0].id.toString());
                        deliveryCharge(addressdata!.billingAddress![0].id
                            .toString());
                        _checkaddress = true;
                        //checkLocation();
                        Navigation(context, name: Routename.PaymentScreen,
                            navigatore: NavigatoreTyp.Push,
                            qparms: {
                              'minimumOrderAmountNoraml': _minimumOrderAmountNoraml,
                              'deliveryChargeNormal': _deliveryChargeNormal,
                              'minimumOrderAmountPrime': _minimumOrderAmountPrime,
                              'deliveryChargePrime': _deliveryChargePrime,
                              'minimumOrderAmountExpress': _minimumOrderAmountExpress,
                              'deliveryChargeExpress': _deliveryChargeExpress,
                              'addressId': PrefUtils.prefs!.getString(
                                  "addressId"),
                              'deliveryType': Features.ismultivendor
                                  ? "OptionTwo"
                                  : (_groupValueAdvance == 1)
                                  ? "Default"
                                  : "OptionTwo",
                              'note': _message.text,
                              'deliveryCharge': (_groupValueAdvance == 1)
                                  ? deliveryfinalslotdate.toString()
                                  : deliveryfinalslotdate.toString(),
                              'deliveryDurationExpress': _deliveryDurationExpress,
                              'fromScreen': '',
                              'responsejson': "",
                            });
                      } else {
                      if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                      // _dialogforaddress(context);
                      AddressWeb(context,
                        addresstype: "new",
                        addressid: "",
                        delieveryLocation: "",
                        latitude: "",
                        longitude: "",
                        branch: "",);
                      }
                      else {
                        Navigation(context, name: Routename.AddressScreen,
                            navigatore: NavigatoreTyp.Push,
                            qparms: {
                              'addresstype': "new",
                              'addressid': "",
                              'delieveryLocation': "",
                              'latitude': "",
                              'longitude': "",
                              'branch': "",
                            });
                        }
                      }
                    } else {
                      if (_checkmembership  && cartItemList.length == 1) {
                        debugPrint("9...if");
                        addressdata = (VxState.store as GroceStore).userData;
                        if (addressdata!.billingAddress != null &&
                            addressdata!.billingAddress!.length > 0) {
                          addtype = addressdata!.billingAddress![0].addressType;
                          address = addressdata!.billingAddress![0].address;
                          name = addressdata!.billingAddress![0].fullName!;
                          addressicon = addressdata!.billingAddress![0]
                              .addressicon;
                          PrefUtils.prefs!.setString(
                              "addressId",
                              addressdata!.billingAddress![0].id.toString());
                          // calldeliverslots(addressdata.billingAddress[0].id.toString());
                          deliveryCharge(addressdata!.billingAddress![0].id
                              .toString());
                          _checkaddress = true;
                          // checkLocation();
                          Navigation(context, name: Routename.PaymentScreen,
                              navigatore: NavigatoreTyp.Push,
                              qparms: {
                                'minimumOrderAmountNoraml': _minimumOrderAmountNoraml,
                                'deliveryChargeNormal': _deliveryChargeNormal,
                                'minimumOrderAmountPrime': _minimumOrderAmountPrime,
                                'deliveryChargePrime': _deliveryChargePrime,
                                'minimumOrderAmountExpress': _minimumOrderAmountExpress,
                                'deliveryChargeExpress': _deliveryChargeExpress,
                                'addressId': PrefUtils.prefs!.getString(
                                    "addressId"),
                                'deliveryType': Features.ismultivendor
                                    ? "OptionTwo"
                                    : (_groupValueAdvance == 1)
                                    ? "Default"
                                    : "OptionTwo",
                                'note': _message.text,
                                'deliveryCharge': (_groupValueAdvance == 1)
                                    ? deliveryfinalslotdate.toString()
                                    : deliveryfinalslotdate.toString(),
                                'deliveryDurationExpress': _deliveryDurationExpress,
                                'fromScreen': 'cartscreen',
                                'responsejson': "",
                              });
                        }
                        else {
                          if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                            AddressWeb(context,
                              addresstype: "new",
                              addressid: "",
                              delieveryLocation: "",
                              latitude: "",
                              longitude: "",
                              branch: "",);
                      }
                      else {
                          Navigation(context, name: Routename.AddressScreen,
                              navigatore: NavigatoreTyp.Push,
                              qparms: {
                                'addresstype': "new",
                                'addressid': "",
                                'delieveryLocation': "",
                                'latitude': "",
                                'longitude': "",
                                'branch': "",
                              });
                          }
                        }
                      }
                      else {
                        Navigation(context, name: Routename.OfferScreen,
                            navigatore: NavigatoreTyp.Push,
                            qparms: {
                              "_groupValue": _groupCart
                            });
                      }
                    }

                    /*
                  Features.ismultivendor?
                  Navigation(context, name: Routename.PaymentScreen, navigatore: NavigatoreTyp.Push,
                      qparms: {
                        'minimumOrderAmountNoraml': _minimumOrderAmountNoraml,
                        'deliveryChargeNormal': _deliveryChargeNormal,
                        'minimumOrderAmountPrime': _minimumOrderAmountPrime,
                        'deliveryChargePrime': _deliveryChargePrime,
                        'minimumOrderAmountExpress': _minimumOrderAmountExpress,
                        'deliveryChargeExpress': _deliveryChargeExpress,
                        'addressId': PrefUtils.prefs!.getString(
                            "addressId"),
                        'deliveryType': (_groupValueAdvance == 1)
                            ? "Default"
                            : "OptionTwo",
                        'note': _message.text,
                        'deliveryCharge': (_groupValueAdvance == 1)
                            ? delCharge.toString()
                            : delCharge.toString(),
                        'deliveryDurationExpress': _deliveryDurationExpress,
                        'fromScreen':'',
                        'responsejson':"",
                      }):
                  Navigation(context, name:Routename.OfferScreen,navigatore: NavigatoreTyp.Push,
                      qparms: {
                        "_groupValue": _groupCart
                      });*/
                  } else
                  if (VxState.store.userData.customerEngagementFlag! == "1") {
                    debugPrint("18...");
                    Navigation(context, name: Routename.OfferScreen,
                        navigatore: NavigatoreTyp.Push,
                        qparms: {
                          "_groupValue": _groupCart
                        });
                  }
                  else {
                    /* Navigator.of(context)
                      .pushNamed(LoginScreen.routeName, arguments: {
                    "prev": "cartScreen"
                  });*/
                    debugPrint("19...");
                    Navigation(context, name: Routename.Login,
                        navigatore: NavigatoreTyp.Push,
                        qparms: {
                          "prev": "cartScreen"
                        });
                  }
                }
                else {
                  debugPrint("20...");
                  if (store.userData.mobileNumber.toString() != "null" &&
                      store.userData.mobileNumber.toString() != "") {
                    /*  Navigator.of(context).pushNamed(
                      ConfirmorderScreen.routeName,
                      arguments: {"prev": "cart_screen"});*/
                    debugPrint("21...");
                    if (Features.ismultivendor) {
                      addressdata = (VxState.store as GroceStore).userData;
                      if (addressdata!.billingAddress != null &&
                          addressdata!.billingAddress!.length > 0) {
                        addtype = addressdata!.billingAddress![0].addressType;
                        address = addressdata!.billingAddress![0].address;
                        name = addressdata!.billingAddress![0].fullName!;
                        addressicon = addressdata!.billingAddress![0]
                            .addressicon;
                        PrefUtils.prefs!.setString(
                            "addressId",
                            addressdata!.billingAddress![0].id.toString());
                        // calldeliverslots(addressdata.billingAddress[0].id.toString());
                        deliveryCharge(addressdata!.billingAddress![0].id
                            .toString());
                        _checkaddress = true;
                        // checkLocation();
                        Navigation(context, name: Routename.PaymentScreen,
                            navigatore: NavigatoreTyp.Push,
                            qparms: {
                              'minimumOrderAmountNoraml': _minimumOrderAmountNoraml,
                              'deliveryChargeNormal': _deliveryChargeNormal,
                              'minimumOrderAmountPrime': _minimumOrderAmountPrime,
                              'deliveryChargePrime': _deliveryChargePrime,
                              'minimumOrderAmountExpress': _minimumOrderAmountExpress,
                              'deliveryChargeExpress': _deliveryChargeExpress,
                              'addressId': PrefUtils.prefs!.getString(
                                  "addressId"),
                              'deliveryType': Features.ismultivendor
                                  ? "OptionTwo"
                                  : (_groupValueAdvance == 1)
                                  ? "Default"
                                  : "OptionTwo",
                              'note': _message.text,
                              'deliveryCharge': (_groupValueAdvance == 1)
                                  ? deliveryfinalslotdate.toString()
                                  : deliveryfinalslotdate.toString(),
                              'deliveryDurationExpress': _deliveryDurationExpress,
                              'fromScreen': '',
                              'responsejson': "",
                            });
                      } else {
                        if (Vx.isWeb && !ResponsiveLayout.isSmallScreen(
                            context)) {
                          AddressWeb(context,
                            addresstype: "new",
                            addressid: "",
                            delieveryLocation: "",
                            latitude: "",
                            longitude: "",
                            branch: "",);
                        }
                        else {
                          Navigation(context, name: Routename.AddressScreen,
                              navigatore: NavigatoreTyp.Push,
                              qparms: {
                                'addresstype': "new",
                                'addressid': "",
                                'delieveryLocation': "",
                                'latitude': "",
                                'longitude': "",
                                'branch': "",
                              });
                        }
                      }
                    } else {
                      if (_checkmembership && cartItemList[0].mode == "1" && cartItemList.length == 1) {
                        debugPrint("9...if");
                        addressdata = (VxState.store as GroceStore).userData;
                        if (addressdata!.billingAddress != null &&
                            addressdata!.billingAddress!.length > 0) {
                          addtype = addressdata!.billingAddress![0].addressType;
                          address = addressdata!.billingAddress![0].address;
                          name = addressdata!.billingAddress![0].fullName!;
                          addressicon = addressdata!.billingAddress![0]
                              .addressicon;
                          PrefUtils.prefs!.setString(
                              "addressId",
                              addressdata!.billingAddress![0].id.toString());
                          // calldeliverslots(addressdata.billingAddress[0].id.toString());
                          deliveryCharge(addressdata!.billingAddress![0].id
                              .toString());
                          _checkaddress = true;
                          // checkLocation();
                          PrefUtils.prefs!.setString("isPickup", "no");
                          Navigation(context, name: Routename.PaymentScreen,
                              navigatore: NavigatoreTyp.Push,
                              qparms: {
                                'minimumOrderAmountNoraml': _minimumOrderAmountNoraml,
                                'deliveryChargeNormal': _deliveryChargeNormal,
                                'minimumOrderAmountPrime': _minimumOrderAmountPrime,
                                'deliveryChargePrime': _deliveryChargePrime,
                                'minimumOrderAmountExpress': _minimumOrderAmountExpress,
                                'deliveryChargeExpress': _deliveryChargeExpress,
                                'addressId': PrefUtils.prefs!.getString(
                                    "addressId"),
                                'deliveryType': Features.ismultivendor
                                    ? "OptionTwo"
                                    : (_groupValueAdvance == 1)
                                    ? "Default"
                                    : "OptionTwo",
                                'note': _message.text,
                                'deliveryCharge': (_groupValueAdvance == 1)
                                    ? deliveryfinalslotdate.toString()
                                    : deliveryfinalslotdate.toString(),
                                'deliveryDurationExpress': _deliveryDurationExpress,
                                'fromScreen': 'cartscreen',
                                'responsejson': "",
                              });
                        }
                        else {
                          if (Vx.isWeb &&
                              !ResponsiveLayout.isSmallScreen(context)) {
                            // _dialogforaddress(context);
                            AddressWeb(context,
                              addresstype: "new",
                              addressid: "",
                              delieveryLocation: "",
                              latitude: "",
                              longitude: "",
                              branch: "",);
                          }
                          else {
                            Navigation(context, name: Routename.AddressScreen,
                                navigatore: NavigatoreTyp.Push,
                                qparms: {
                                  'addresstype': "new",
                                  'addressid': "",
                                  'delieveryLocation': "",
                                  'latitude': "",
                                  'longitude': "",
                                  'branch': "",
                                });
                          }
                        }
                      }
                      else {
                        Navigation(context, name: Routename.ConfirmOrder,
                            navigatore: NavigatoreTyp.Push,
                            parms: {"prev": "cart_screen"});
                      }
                    }

                    /* Features.ismultivendor?
                  Navigation(context, name: Routename.PaymentScreen, navigatore: NavigatoreTyp.Push,
                      qparms: {
                        'minimumOrderAmountNoraml': _minimumOrderAmountNoraml,
                        'deliveryChargeNormal': _deliveryChargeNormal,
                        'minimumOrderAmountPrime': _minimumOrderAmountPrime,
                        'deliveryChargePrime': _deliveryChargePrime,
                        'minimumOrderAmountExpress': _minimumOrderAmountExpress,
                        'deliveryChargeExpress': _deliveryChargeExpress,
                        'addressId': PrefUtils.prefs!.getString(
                            "addressId"),
                        'deliveryType': (_groupValueAdvance == 1)
                            ? "Default"
                            : "OptionTwo",
                        'note': _message.text,
                        'deliveryCharge': (_groupValueAdvance == 1)
                            ? delCharge.toString()
                            : delCharge.toString(),
                        'deliveryDurationExpress': _deliveryDurationExpress,
                        'fromScreen':'',
                        'responsejson':"",
                      }):
                  Navigation(context, name:Routename.ConfirmOrder,navigatore: NavigatoreTyp.Push,
                      parms:{"prev": "cart_screen"});*/
                  }
                  else {
                    /* Navigator.of(context)
                      .pushNamed(LoginScreen.routeName, arguments: {
                    "prev": "cartScreen"
                  });*/
                    debugPrint("23...");
                    Navigation(context, name: Routename.Login,
                        navigatore: NavigatoreTyp.Push,
                        qparms: {
                          "prev": "cartScreen"
                        });
                  }
                }
              }
            }
          });
        },
      );
    }
    Widget paymentDetails() {
      String minOrdAmount = "0.0";
      String delCharge = "0.0";
      String minOrdAmountExpress = "0.0";
      String delChargeExpress = "0.0";
      double deliveryfinalexpressdate=0.0;
      double deliveryfinalexpressTime=0.0;
      double deliveryDateamount1 = 0.0;
      double deliveryTimeamount1 = 0.0;
      double finalSlotDelivery=0.0;
      double finalExpressDelivery=0.0;
      if (membershipvx == "1" ||_checkmembership) {
        cartTotal = CartCalculations.totalMember;
      } else {
        cartTotal = CartCalculations.total;
      }

      if (_radioValue == 1) {
        if (membershipvx == "1" || _checkmembership) {
          minOrdAmount = _minimumOrderAmountPrime;
          delCharge = _deliveryChargePrime;
        } else {
          minOrdAmount = _minimumOrderAmountExpress;
          delCharge = _deliveryChargeExpress;
        }
      } else {
        minOrdAmount = _minimumOrderAmountExpress;
        delCharge = _deliveryChargeExpress;
      }


      if (membershipvx == "1" ||_checkmembership) {
        if (CartCalculations.totalMember < double.parse(minOrdAmount)) {
          deliveryfinalslotdate = double.parse(delCharge);
          // deliveryDateamount1 = deliveryDateamount1+ deliveryfinalslotdate;
        } else {
          deliveryfinalslotdate = 0;
        }
      }
      else{

        if (CartCalculations.total < double.parse(minOrdAmount)) {
          deliveryfinalslotdate = double.parse(delCharge);
          // deliveryDateamount1 = deliveryDateamount1+ deliveryfinalslotdate;
        } else {
          deliveryfinalslotdate = 0;
        }
      }

      if(deliveryfinalslotdate == 0){
        deliverychargetext= "FREE";
      }else{
        deliverychargetext = Features.iscurrencyformatalign?
        double.parse(delCharge).toString() + " " + IConstants.currencyFormat:
        IConstants.currencyFormat + " " + double.parse(delCharge).toString();
      }
      amountPayable = (cartTotal + deliveryfinalslotdate);

      return Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: ColorCodes.whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: ColorCodes.grey.withOpacity(0.3),
                    spreadRadius: 4,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  )
                ]
            ),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                top: 15.0, left: 20.0, right: 20.0, bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S .of(context).payment_details,//"Your cart value",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: ColorCodes.emailColor,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10.0,
                ),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width:  MediaQuery.of(context).size.width / 2.3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Features.ismultivendor?S .of(context).item_total:  S .of(context).your_cart_value,//"Your cart value",
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: ColorCodes.emailColor,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            DottedLine(
                                dashColor: ColorCodes.lightgrey,
                                lineThickness: 1.0,
                                dashLength: 2.0,
                                dashRadius: 0.0,
                                dashGapLength: 1.0),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              Features.ismultivendor?S.of(context).delivery_fee:S .of(context).payment_delivery_charge,//"Delivery charges",
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: ColorCodes.emailColor,
                                  fontWeight: FontWeight.w500),

                            ),

                            SizedBox(
                              height: 5.0,
                            ),
                            DottedLine(
                                dashColor: ColorCodes.lightgrey,
                                lineThickness: 1.0,
                                dashLength: 2.0,
                                dashRadius: 0.0,
                                dashGapLength: 1.0),
                            SizedBox(
                              height: 5.0,
                            ),
                            if(!_checkmembership)
                              if ((CartCalculations.totalprice)  > 0)

                                Text(
                                  S .of(context).discount_applied,//"Discount applied:",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: Features.ismultivendor?ColorCodes.greenColor:ColorCodes.emailColor,
                                      fontWeight: FontWeight.w500),
                                ),
                            /*if ((Calculations.totalmrp - cartTotal) > 0)
                                SizedBox(
                                  height: 10.0,
                                ),*/
                            if(!_checkmembership)
                              if ((CartCalculations.totalprice) > 0)
                                SizedBox(
                                  height: 5.0,
                                ),
                            if(!_checkmembership)
                              if ((CartCalculations.totalprice) > 0)
                                DottedLine(
                                    dashColor: ColorCodes.lightgrey,
                                    lineThickness: 1.0,
                                    dashLength: 2.0,
                                    dashRadius: 0.0,
                                    dashGapLength: 1.0),
                            if(!_checkmembership)
                              if ((CartCalculations.totalprice) > 0)
                                SizedBox(
                                  height: 5.0,
                                ),
                            if(_checkmembership)
                              if((CartCalculations.totalMembersPrice /*- Calculations.totalprice*/) > 0)
                                Text(
                                  S .of(context).membership_savings,//"Membership savings:",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: ColorCodes.emailColor,
                                      fontWeight: FontWeight.w500),
                                ),
                            if(_checkmembership)
                              if((CartCalculations.totalMembersPrice /*- Calculations.totalprice*/) > 0)
                                SizedBox(
                                  height: 5.0,
                                ),
                            if(_checkmembership)
                              if((CartCalculations.totalMembersPrice /*- Calculations.totalprice*/) > 0)
                                DottedLine(
                                    dashColor: ColorCodes.lightgrey,
                                    lineThickness: 1.0,
                                    dashLength: 2.0,
                                    dashRadius: 0.0,
                                    dashGapLength: 1.0),
                            if(_checkmembership)
                              if((CartCalculations.totalMembersPrice /*- Calculations.totalprice*/) > 0)
                                SizedBox(
                                  height: 5.0,
                                ),

                            Text(
                              Features.ismultivendor?S.of(context).to_pay:S .of(context).amount_payable,//"Amount payable:",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: ColorCodes.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      /* Container(
                            child: VerticalDivider(
                                color: ColorCodes.greyColor)),*/
                      Container(
                        width:  MediaQuery.of(context).size.width / 4.7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              Features.iscurrencyformatalign?
                              membershipvx == "1" ||_checkmembership?
                              CartCalculations.totalMember.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)+
                                  " " + IConstants.currencyFormat:
                              CartCalculations.totalmrp.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)+
                                  " " + IConstants.currencyFormat :
                              membershipvx == "1" ||_checkmembership?
                              IConstants.currencyFormat +
                                  " " +
                                  CartCalculations.totalMember.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit):
                              IConstants.currencyFormat +
                                  " " +
                                  CartCalculations.totalmrp.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                              style: TextStyle(
                                  fontSize: 13.0,
                                  color: ColorCodes.blackColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            // if (!_isPickup)
                            Text(
                              deliverychargetext!,
                              style: TextStyle(
                                  fontSize: 13.0, color: ColorCodes.blackColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            // if (!_isPickup)
                            SizedBox(
                              height: 10.0,
                            ),
                            if(!_checkmembership)
                              if ((CartCalculations.totalprice) > 0)
                                Text(
                                  "- " +
                                      (CartCalculations.totalmrp - cartTotal)
                                          .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      color: Features.ismultivendor?ColorCodes.greenColor:ColorCodes.greyColor,
                                      fontWeight: FontWeight.bold),
                                ),
                            /*if ((Calculations.totalmrp - cartTotal) > 0)
                                SizedBox(
                                  height: 10.0,
                                ),*/
                            if(!_checkmembership)
                              if ((CartCalculations.totalprice) > 0)
                                SizedBox(
                                  height: 10.0,
                                ),
                            if(_checkmembership)
                              if((CartCalculations.totalMembersPrice /*- Calculations.totalprice*/) > 0)
                                Text(
                                  "-"+ (/*Calculations.totalprice -*/ CartCalculations.totalMembersPrice)
                                      .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      color: ColorCodes.blackColor,
                                      fontWeight: FontWeight.bold),
                                ),

                            if(_checkmembership)
                              if((CartCalculations.totalMembersPrice /*- Calculations.totalprice*/) > 0)
                                SizedBox(
                                  height: 10.0,
                                ),

                            Text(
                              Features.iscurrencyformatalign?
                              amountPayable.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) +
                                  " " + IConstants.currencyFormat :
                              IConstants.currencyFormat +
                                  " " +
                                  amountPayable.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                              style: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                  color: ColorCodes.primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                // Divider(
                //   color: ColorCodes.greyColor,
                //   thickness: 0.8,
                // ),


              ],
            ),
          ),
          /*if(Features.isOffers)
              if(offersData.offers.length > 0)
                _offers(),*/
          // (productBox.length == 1 && productBox.values.elementAt(0).mode == 1)
          //     ? SizedBox.shrink()
          //     :
          //     (Features.isPromocode)?
          //     !_checkpromo?
          // GestureDetector(
          //   behavior: HitTestBehavior.translucent,
          //   /*onTap: () {
          //     //_dialogforPromo(context);
          //   },*/
          //   child: Padding(
          //     padding: const EdgeInsets.only(left:20.0,right:20),
          //     child: Material(
          //       elevation: 1,
          //       child: Container(
          //         padding: EdgeInsets.only(left: 15),
          //         decoration: BoxDecoration(
          //           color: ColorCodes.whiteColor,
          //           borderRadius: BorderRadius.circular(6)
          //         ),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: <Widget>[
          //             Container(
          //               width: 170,
          //               child: TextField(
          //                 decoration: InputDecoration(
          //                     border: InputBorder.none,
          //                     hintText: S .of(context).enter_promo),//'Enter Promo Code'),
          //                 controller: myController,
          //                 onSubmitted: (String newVal) {
          //                   /*prefs.setString("promovalue", newVal);
          //                             setState(() {
          //                               _checkpromo = true;
          //                               _promocode = newVal;
          //                             });*/
          //                   setState(() {
          //                     _checkpromo = true;
          //                   });
          //                   checkPromo();
          //                 },),
          //             ),
          //             MouseRegion(
          //               cursor: SystemMouseCursors.click,
          //               child: GestureDetector(
          //                 onTap: () {
          //                   setState(() {
          //                     _checkpromo = true;
          //                   });
          //                   checkPromo();
          //                 },
          //                 child: Container(
          //                   width: 100.0,
          //                   height: 48.0,
          //                   decoration: BoxDecoration(
          //                     color: Theme.of(context).primaryColor,
          //                     borderRadius: BorderRadius.circular(4.0),
          //                   ),
          //                   child: Center(
          //                       child: Text(
          //                         S .of(context).apply,//'Apply',
          //                         textAlign: TextAlign.center,
          //                         style: TextStyle(color: Colors.white),
          //                       )),
          //                 ),
          //               ),
          //             ),
          //
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ):
          //     Center(
          //       child: CircularProgressIndicator(
          //         valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor,),
          //       ),
          //     ):SizedBox.shrink(),
          // (productBox.length == 1 && productBox.values.elementAt(0).mode == 1)
          //     ? SizedBox.shrink()
          //     :
          //
          // Padding(
          //   padding: const EdgeInsets.only(left:20.0,right:20.0),
          //       child: Divider(
          //       color: ColorCodes.whiteColor,
          //   //thickness: 2.5,
          // ),
          //     ),
        ],
      );
    }

    Widget confirmOrder() {
      VxState.watch(context, on: [SetCartItem]);
      for(int i=0;i<cartItemList.length;i++) {
        if (cartItemList.length <= 1 && cartItemList[i].mode == "1") {
          slots = true;
        } else if (cartItemList[i].mode == 1) {
          slots = true;
        }
      }
      //productBox = (VxState.store as GroceStore).CartItemList;
      double deliveryamount = 0.0;
      String minOrdAmount = "0.0";
      String delCharge = "0.0";
      String minOrdAmountExpress = "0.0";
      String delChargeExpress = "0.0";
      int count=1;
      int countTime=1;
      double deliveryfinalexpressdate=0.0;
      double deliveryfinalexpressTime=0.0;
      double deliveryDateamount1 = 0.0;
      double deliveryTimeamount1 = 0.0;
      double finalSlotDelivery=0.0;
      double finalExpressDelivery=0.0;
      String deliveryDurationExpress;
      double deviceWidth = MediaQuery.of(context).size.width;
      int widgetsInRow = 2;
      MediaQueryData queryData;
      queryData = MediaQuery.of(context);
      if (deviceWidth > 1200) {
        widgetsInRow = 2;
      } else if (deviceWidth > 768) {
        widgetsInRow = 2;
      }
      double aspectRatio =   (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
      (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 120
          : (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 120;
      final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      //deliveryDurationExpress = routeArgs["deliveryDurationExpress"]!;
      for(int i=0;i<cartItemList.length;i++)
        if(cartItemList.length == 1 && cartItemList[0].mode == 1){
          _deliveryChargeNormal="0";
          _deliveryChargeExpress="0";
          _deliveryChargePrime="0";
        }
      if (!_isshow) {
        if (_radioValue == 1) {
          if (_checkmembership) {
            minOrdAmount = _minimumOrderAmountPrime;
            delCharge = _deliveryChargePrime;
          } else {
            minOrdAmount = _minimumOrderAmountNoraml;
            delCharge = _deliveryChargeNormal;
          }
        } else {
          minOrdAmount = _minimumOrderAmountExpress;
          delCharge = _deliveryChargeExpress;
        }

        if (!_loadingSlots && !_loadingDelCharge) {
          _loading = false;
        }


        deliveryslotData = Provider.of<DeliveryslotitemsList>(context, listen: false);
        for(int i=0;i< cartItemList.length;i++) {
          durType = cartItemList[i].durationType!;
          mode = cartItemList[i].mode.toString();
        }


        something.clear();
        ExpressDetails.clear();
        DefaultSlot.clear();

        for(int i=0;i< cartItemList.length;i++) {
          if (cartItemList[i].varStock == "0" || cartItemList[i].status == "1") {
          }
          else {
            ////////Delivery Option Two

            if (((cartItemList[i].durationType == "" ||
                cartItemList[i].durationType == null) &&
                (cartItemList[i].eligibleForExpress == "1" ||
                    cartItemList[i].eligibleForExpress == "")) ||
                cartItemList[i].mode == "1") {
              something.add(cartItemList[i]);


              double SecondSlotTotal = 0.0;
              for (int i = 0; i < something.length; i++) {
                SecondSlotTotal = _checkmembership?something[i].type == "1"?
                SecondSlotTotal + (double.parse(
                    (double.parse(something[i].membershipPrice!) *
                        int.parse(something[i].weight!)).toString()))
                    :SecondSlotTotal + (double.parse(
                    (double.parse(something[i].membershipPrice!) *
                        int.parse(something[i].quantity!)).toString())):something[i].type == "1"?
                SecondSlotTotal + (double.parse(
                    (double.parse(something[i].price!) *
                        int.parse(something[i].weight!)).toString()))
                    : SecondSlotTotal + (double.parse(
                    (double.parse(something[i].price!) *
                        int.parse(something[i].quantity!)).toString()));

                if (SecondSlotTotal < double.parse(minOrdAmount)) {
                  deliverySlotamount = double.parse(delCharge);
                } else {
                  deliverySlotamount = 0;
                }
              }

              if (deliverySlotamount == 0) {
                deliverychargetextSecond = "FREE";
              } else {
                deliverychargetextSecond = Features.iscurrencyformatalign?
                deliverySlotamount.toString() + " " + IConstants.currencyFormat:
                IConstants.currencyFormat + " " +
                    deliverySlotamount.toString();
              }
            }
            else if (cartItemList[i].eligibleForExpress == "0") {
              ExpressDetails.add(cartItemList[i]);

              double SecondExpressTotal = 0.0;
              for (int i = 0; i < ExpressDetails.length; i++) {
                SecondExpressTotal = _checkmembership ?ExpressDetails[i].type == "1"?
                SecondExpressTotal + (double.parse(
                    (double.parse(ExpressDetails[i].membershipPrice!) *
                        int.parse(ExpressDetails[i].weight!)).toString())):
                SecondExpressTotal + (double.parse(
                    (double.parse(ExpressDetails[i].membershipPrice!) *
                        int.parse(ExpressDetails[i].quantity!)).toString())):ExpressDetails[i].type == "1"?
                SecondExpressTotal + (double.parse(
                    (double.parse(ExpressDetails[i].price!) *
                        int.parse(ExpressDetails[i].weight!)).toString()))
                    : SecondExpressTotal + (double.parse(
                    (double.parse(ExpressDetails[i].price!) *
                        int.parse(ExpressDetails[i].quantity!)).toString()));
                minOrdAmountExpress = _minimumOrderAmountExpress;
                delChargeExpress = _deliveryChargeExpress;
                if (SecondExpressTotal < double.parse(minOrdAmountExpress)) {
                  deliveryExpressamount = double.parse(delChargeExpress);
                } else {
                  deliveryExpressamount = 0;
                }
              }

              if (deliveryExpressamount == 0) {
                deliverychargetextExpress = "FREE";
              } else {
                deliverychargetextExpress = Features.iscurrencyformatalign?
                deliveryExpressamount.toString()  + " " + IConstants.currencyFormat:IConstants.currencyFormat + " " +
                    deliveryExpressamount.toString();
              }
            }
            else if (cartItemList[i].durationType == "0" &&
                (cartItemList[i].eligibleForExpress == "1" ||
                    cartItemList[i].eligibleForExpress == "" ||
                    cartItemList[i].eligibleForExpress == null)) {
              List<CartItem> dynamic1 = [];
              List<CartItem> finalList = [];
              dynamic1.clear();
              for (int i = 0; i < cartItemList.length; i++) {
                if(cartItemList[i].varStock == "0" || cartItemList[i].status == "1"){

                }else {
                  dynamic1.add(cartItemList[i]);
                }
                finalList = dynamic1.where((i) =>
                i.durationType == "0" &&
                    (i.eligibleForExpress == "1" || i.eligibleForExpress == ""))
                    .toList();
                newMap2 = groupBy(finalList, (obj) => obj.duration!);
              }
            }
            else if (cartItemList[i].durationType == "1" &&
                (cartItemList[i].eligibleForExpress == "1" ||
                    cartItemList[i].eligibleForExpress == "" ||
                    cartItemList[i].eligibleForExpress == null)) {
              List<CartItem> dynamicTime = [];
              List<CartItem> finalListTime = [];

              dynamicTime.clear();
              for (int i = 0; i < cartItemList.length; i++) {
                if(cartItemList[i].varStock == "0" || cartItemList[i].status == "1"){

                }else {
                  dynamicTime.add(cartItemList[i]);
                }
                // dynamicTime.add(cartItemList[i]);
                finalListTime = dynamicTime.where((i) =>
                i.durationType == "1" &&
                    (i.eligibleForExpress == "1" || i.eligibleForExpress == ""))
                    .toList();
                newMap3 = groupBy(finalListTime, (obj) => obj.duration!);
              }
            }

            ////////Default Delivery Option
            if ((cartItemList[i].durationType == "" ||
                cartItemList[i].durationType == null)) {
              if ((cartItemList[i].eligibleForExpress == "0" ||
                  cartItemList[i].eligibleForExpress == "1" ||
                  cartItemList[i].eligibleForExpress == "") ||
                  cartItemList[i].mode == "1") {
                DefaultSlot.add(cartItemList[i]);
                double DefaultTota1 = 0.0;

                for (int i = 0; i < DefaultSlot.length; i++) {
                  DefaultTota1 = _checkmembership ?DefaultSlot[i].type == "1"?
                  DefaultTota1 + (double.parse(
                      (double.parse(DefaultSlot[i].membershipPrice!) *
                          int.parse(DefaultSlot[i].weight!))
                          .toString())):
                  DefaultTota1 + (double.parse(
                      (double.parse(DefaultSlot[i].membershipPrice!) *
                          int.parse(DefaultSlot[i].quantity!))
                          .toString())):DefaultSlot[i].type == "1"?
                  DefaultTota1 + (double.parse(
                      (double.parse(DefaultSlot[i].price!) *
                          int.parse(DefaultSlot[i].weight!))
                          .toString()))
                      : DefaultTota1 + (double.parse(
                      (double.parse(DefaultSlot[i].price!) *
                          int.parse(DefaultSlot[i].quantity!))
                          .toString()));
                  if (DefaultTota1 < double.parse(minOrdAmount)) {
                    deliveryamount = double.parse(delCharge);
                  } else {
                    deliveryamount = 0;
                  }
                }

                if (deliveryamount == 0) {
                  deliverychargetextdefault = "FREE";
                } else {
                  deliverychargetextdefault =
                  Features.iscurrencyformatalign?
                  deliveryamount.toString()  + " " + IConstants.currencyFormat:
                  IConstants.currencyFormat + " " + deliveryamount.toString();
                }
              }
            }
            else if (cartItemList[i].durationType == "0") {
              // DateBasedDefault.add(productBox[i]);
              List<CartItem> dynamic1 = [];
              List<CartItem> finalList = [];

              dynamic1.clear();
              for (int i = 0; i < cartItemList.length; i++) {
                if(cartItemList[i].varStock == "0" || cartItemList[i].status == "1"){

                }else {
                  dynamic1.add(cartItemList[i]);
                }

                finalList = dynamic1.where((i) => i.durationType == "0").toList();
                newMap = groupBy(finalList, (obj) => obj.duration!);
              }
            }
            else if (cartItemList[i].durationType == "1") {
              //TimeBasedDefault.add(productBox[i]);
              List<CartItem> dynamicTime = [];
              List<CartItem> finalListTime = [];

              dynamicTime.clear();
              for (int i = 0; i < cartItemList.length; i++) {
                if(cartItemList[i].varStock == "0" || cartItemList[i].status == "1"){

                }else {
                  dynamicTime.add(cartItemList[i]);
                }

                finalListTime =
                    dynamicTime.where((i) => i.durationType == "1").toList();
                newMap1 = groupBy(finalListTime, (obj) => obj.duration!);
              }
            }
          }
        }
      }


      Widget handler(bool isSelected,status) {
        return (isSelected == true && status != "1")  ?
        Container(
          width: 20.0,
          height: 20.0,
          decoration: BoxDecoration(
            color: ColorCodes.whiteColor,
            border: Border.all(
              color: ColorCodes.greenColor,
            ),
            shape: BoxShape.circle,
          ),
          child: Container(
            margin: EdgeInsets.all(1.5),
            decoration: BoxDecoration(
              color:(status == "1")?ColorCodes.grey :ColorCodes.whiteColor,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check,
                color: (status == "1")?ColorCodes.grey:ColorCodes.greenColor,
                size: 15.0),
          ),
        )
            :
        Icon(
            Icons.radio_button_off_outlined,
            color: (status == "1")?ColorCodes.grey:ColorCodes.greenColor);


      }

      SelecttimeSlot(id, int i, date, String timeslotsindex) {
        timeslotsData = Provider.of<DeliveryslotitemsList>(
          context,
          listen: false,
        ).findById(timeslotsindex);

        return  GridView.builder(
          // separatorBuilder: (context, index) => SizedBox(height: 10,),
          physics:new NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widgetsInRow,
            crossAxisSpacing: 10,
            childAspectRatio: aspectRatio,
            mainAxisSpacing: 10,
          ),
          itemCount: timeslotsData.length,
          itemBuilder: (_, j) => GestureDetector(
            onTap: () async {
              for (int k = 0; k < timeslotsData.length; k++) {
                timeslotsData[k].isSelect = false;
                timeslotsData[k].selectedColor = Colors.transparent;

              }
              setState(() {
                if(timeslotsData[j].status == "1"){
                  PrefUtils.prefs!.setString("fixtime","");
                  Fluttertoast.showToast(
                    msg: S.of(context).Selected_Slot_full,//"Selected Slot is full",
                    fontSize: MediaQuery.of(context).textScaleFactor *13,);
                }else {
                  time = timeslotsData[j].time;
                  final timeData = Provider.of<DeliveryslotitemsList>(
                      context, listen: false);

                  // PrefUtils.prefs!.setString("fixdate", deliveryslotData.items[i].dateformat);
                  _index = (i == 0 && j == 0) ? 0 : _index + 1;
                  for (int i = 0; i < timeData.times.length; i++) {
                    timeData.times[i].isSelect = false;
                    timeslotsData[j].isSelect = false;
                    // timeData.times[i].isSelect = false;
                    if (((int.parse(id) + j).toString() ==
                        timeData.times[i].index) && timeslotsData[j].status != "1") {
                      setState(() {
                        timeslotsData[j].isSelect = true;
                        PrefUtils.prefs!.setString('fixtime', timeData.times[i].time!);
                      });
                      break;
                    } else {
                      setState(() {

                        timeslotsData[j].isSelect = false;
                        timeslotsData[j].selectedColor = Colors.transparent;
                      });
                    }
                  }
                }
              });

            },
            child: Container(
              height: 120,
              width: MediaQuery.of(context).size.width*0.18,
              decoration: BoxDecoration(
                color: timeslotsData[j].isSelect ?ColorCodes.varcolor:ColorCodes.whiteColor,
                border: Border.all(
                  color: timeslotsData[j].isSelect ? ColorCodes.primaryColor : ColorCodes.varcolor,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              // margin: EdgeInsets.only(left: 5.0, right: 5.0),
              //child: Container(
              //  padding: EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 20,),
                  Container(
                    child: Text(
                      timeslotsData[j].time,
                      style: TextStyle(color: (timeslotsData[j].status=="1")?ColorCodes.grey  :ColorCodes.greenColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Spacer(),
                  handler(timeslotsData[j].isSelect, timeslotsData[j].status),
                  SizedBox(width: 20,),
                ],
              ),
            ),
          ),
        );
      }
      Widget SelectDate(){
        //deliveryslotData.items[0].selectedColor=ColorCodes.mediumgren;
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Container(
              height: 88,
              width: double.infinity,
              child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      width: 10,
                    );
                  },
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  //physics: new AlwaysScrollableScrollPhysics(),
                  itemCount: deliveryslotData.items.length,
                  itemBuilder: (_, i)
                  {
                    final tagName = deliveryslotData.items[i].date.toString();
                    dateSplit = tagName.split(',');
                    return GestureDetector(
                      onTap: (){
                        setState(() {
                          position = i;
                          visible = true;
                          PrefUtils.prefs!.setString("fixdate", deliveryslotData.items[position].dateformat);
                          timeslotsindex = deliveryslotData.items[i].id;
                          timeslotsData = Provider.of<DeliveryslotitemsList>(context, listen: false,).findById(timeslotsindex);
                          for(int j=0;j<deliveryslotData.items.length;j++){
                            if(i==j){
                              deliveryslotData.items[j].selectedColor=ColorCodes.mediumgren;//Color(0xFF45B343);
                              deliveryslotData.items[j].isSelect = true;
                            }
                            else{
                              deliveryslotData.items[j].selectedColor=ColorCodes.whiteColor;
                              deliveryslotData.items[j].isSelect = false;
                            }
                          }
                          for(int j = 0; j < timeslotsData.length; j++){
                            if (timeslotsData[j].status == "1") {
                              setState(() {
                                timeslotsData[j].selectedColor =Colors.grey; //Color(0xFF45B343);
                                timeslotsData[j].isSelect = false;
                                timeslotsData[j].textColor = Colors.grey;

                              });
                            }else {
                              if (j == 0) {
                                timeslotsData[j].selectedColor =
                                    ColorCodes.mediumgren; //Color(0xFF45B343);
                                //this change for time slot color change
                                timeslotsData[j].isSelect = false;
                                PrefUtils.prefs!.setString('fixtime', "");
                              } else {
                                timeslotsData[j].isSelect = false;
                              }
                            }
                          }
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 60,
                            width: 50,

                            decoration: BoxDecoration(
                              color: deliveryslotData.items[i].isSelect ?ColorCodes.varcolor:ColorCodes.whiteColor,
                              border: Border.all(
                                color: ColorCodes.varcolor,
                              ),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Center(
                              child: Text(
                                  dateSplit![0].toUpperCase(),
                                  /*deliveryslotData.items[i].date,*/
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: ColorCodes.darkgreen)),
                            ),
                          ),
                          Padding(
                        padding: const EdgeInsets.only(top:2.0,left: 2,right:2),
                        child: Center(
                          child: Text(
                              dateSplit![1].toUpperCase(),
                              /* value2.toUpperCase(),*//*deliveryslotData.items[i].date,*/
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: ColorCodes.darkgreen)),
                        ),
                      ),
                        ],
                      ),
                    );
                  }),
            ),
            SizedBox(height: 10,),
            SelecttimeSlot(deliveryslotData.items[position].id, position, deliveryslotData.items[position].date,timeslotsindex)
          ],
        );
      }

      _dialogforDeleting() {
        return showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return StatefulBuilder(builder: (context, setState) {
                return AbsorbPointer(
                  child: WillPopScope(
                    onWillPop: (){
                      return Future.value(false);
                    },
                    child: Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0)),
                      child: Container(
                          width: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.20:MediaQuery.of(context).size.width,
                          // color: Theme.of(context).primaryColor,
                          height: 100.0,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircularProgressIndicator(),
                              SizedBox(
                                width: 40.0,
                              ),
                              Text(
                                  S .of(context).deleting
                              ),
                            ],
                          )),
                    ),
                  ),
                );
              });
            });
      }

      // incrementToCart(itemCount, int varIdb, String itemNameb, int itemId, String varName, int varMinItem, int varMaxItem, int varStock, double varMrp, int itemQty, double itemPrice, String membershipPrice, double itemActualprice, String itemImage, String veg_type, String type) async {
      //   // widget.isdbonprocess();
      //
      //   if (itemCount + 1 <= varMinItem) {
      //     itemCount = 0;
      //   }
      //   final s = await Provider.of<CartItems>(context, listen: false).
      //   updateCart(varIdb.toString(), itemCount.toString(), itemActualprice.toString()).then((_)
      //   async{
      //     if (itemCount + 1 == varMinItem) {
      //       for (int i = 0; i < productBox.values.length; i++) {
      //         if (cartItemList[i].mode == 1) {
      //           PrefUtils.prefs!.setString("membership", "0");
      //         }
      //         if (cartItemList[i].varId == varIdb) {
      //           productBox.deleteAt(i);
      //           Navigator.of(context).pop();
      //           Navigator.of(context).pop();
      //
      //           Navigator.of(context).pushNamed(CartScreen.routeName,
      //               arguments: {"prev": "home_screen",
      //                "afterlogin": ""});
      //           break;
      //         }
      //       }
      //       final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);
      //       for(int i = 0; i < sellingitemData.featuredVariation.length; i++) {
      //         if(sellingitemData.featuredVariation[i].varid == varIdb) {
      //           sellingitemData.featuredVariation[i].varQty = itemCount;
      //         }
      //       }
      //       for (int i = 0; i < sellingitemData.itemspricevarOffer.length; i++) {
      //         if (sellingitemData.itemspricevarOffer[i].varid == varIdb) {
      //           sellingitemData.itemspricevarOffer[i].varQty = itemCount;
      //           break;
      //         }
      //       }
      //       for(int i = 0; i < sellingitemData.itemspricevarSwap.length; i++) {
      //         if(sellingitemData.itemspricevarSwap[i].varid == varIdb) {
      //           sellingitemData.itemspricevarSwap[i].varQty = itemCount;
      //           break;
      //         }
      //       }
      //       for(int i = 0; i < sellingitemData.discountedVariation.length; i++) {
      //         if(sellingitemData.discountedVariation[i].varid == varIdb) {
      //           sellingitemData.discountedVariation[i].varQty = itemCount;
      //           break;
      //         }
      //       }
      //       _bloc.setFeaturedItem(sellingitemData);
      //
      //       final cartItemsData = Provider.of<CartItems>(context, listen: false);
      //       for(int i = 0; i < cartItemsData.items.length; i++) {
      //         if(cartItemsData.items[i].varId == varIdb) {
      //           cartItemsData.items[i].quantity = itemCount;
      //         }
      //       }
      //       _bloc.setCartItem(cartItemsData);
      //       Provider.of<CartItems>(context, listen: false).fetchCartItems().then((_) {
      //       });
      //     }
      //     else {
      //
      //       final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);
      //       for(int i = 0; i < sellingitemData.featuredVariation.length; i++) {
      //         if(sellingitemData.featuredVariation[i].varid == varIdb) {
      //           sellingitemData.featuredVariation[i].varQty = itemCount;
      //         }
      //       }
      //       _bloc.setFeaturedItem(sellingitemData);
      //       for (int i = 0; i < sellingitemData.itemspricevarOffer.length; i++) {
      //         if (sellingitemData.itemspricevarOffer[i].varid == varIdb) {
      //           sellingitemData.itemspricevarOffer[i].varQty = itemCount;
      //           break;
      //         }
      //       }
      //       for(int i = 0; i < sellingitemData.itemspricevarSwap.length; i++) {
      //         if(sellingitemData.itemspricevarSwap[i].varid == varIdb) {
      //           sellingitemData.itemspricevarSwap[i].varQty = itemCount;
      //           break;
      //         }
      //       }
      //       _bloc.setFeaturedItem(sellingitemData);
      //       for(int i = 0; i < sellingitemData.discountedVariation.length; i++) {
      //         if(sellingitemData.discountedVariation[i].varid == varIdb) {
      //           sellingitemData.discountedVariation[i].varQty = itemCount;
      //           break;
      //         }
      //       }
      //       _bloc.setFeaturedItem(sellingitemData);
      //
      //       final cartItemsData = Provider.of<CartItems>(context, listen: false);
      //       for(int i = 0; i < cartItemsData.items.length; i++) {
      //         if(cartItemsData.items[i].varId == varIdb) {
      //           cartItemsData.items[i].quantity = itemCount;
      //         }
      //       }
      //       _bloc.setCartItem(cartItemsData);
      //
      //       Product products = Product(
      //         itemId: itemId,
      //         varId: varIdb,
      //         varName: varName,
      //         varMinItem: varMinItem,
      //         varMaxItem: varMaxItem,
      //         varStock: varStock,
      //         varMrp: varMrp,
      //         itemName: itemNameb,
      //         itemQty: itemCount,
      //         itemPrice: itemPrice,
      //         membershipPrice: membershipPrice,
      //         itemActualprice:itemActualprice,
      //         itemImage: itemImage,
      //         membershipId: 0,
      //         mode: 0,
      //         veg_type: veg_type,
      //         type: type,
      //       );
      //
      //       var items = Hive.box<Product>(productBoxName);
      //
      //       for (int i = 0; i < items.length; i++) {
      //         if (Hive.box<Product>(productBoxName).values.elementAt(i).varId == varIdb) {
      //           Hive.box<Product>(productBoxName).putAt(i, products);
      //         }
      //       }
      //       Navigator.of(context).pop();
      //       Navigator.of(context).pop();
      //       Navigator.of(context).pushNamed(CartScreen.routeName,
      //           arguments: {"prev": "home_screen",
      //             "afterlogin": ""});
      //     }
      //
      //   });
      // }


      dialogforViewAllProductSecond(int count, String slot_based_delivery, int length) {

        showDialog(
          context: context,
          builder: (BuildContext context1) {
            return   Dialog(

              child: Container(
                width: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.30:MediaQuery.of(context).size.width,
                child: Stack(
                  // overflow: Overflow.visible,
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Column(
                              children: [
                                SizedBox(height: 10,),
                                Text(S .of(context).shipment+ " "+count.toString()+": " + slot_based_delivery,
                                  style: TextStyle(color: ColorCodes.blackColor, fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                SizedBox(height: 10,),
                                Text(length.toString()+" " + S .of(context).items,
                                  style: TextStyle(color: ColorCodes.greyColor, fontWeight: FontWeight.w400, fontSize: 14),
                                ),
                                SizedBox(height: 20,),

                              ],
                            ),
                          ),
                          if(something.length>0)
                            SizedBox(
                              child: new ListView.separated(
                                separatorBuilder: (context, index) => Divider(
                                  color: ColorCodes.lightGreyColor,
                                ),
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: something.length,
                                itemBuilder: (_, i) => Column(children: [
                                  Container(
                                    color: Colors.white,
                                    child: Card(

                                      elevation: 0,
                                      margin: EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          (cartItemList[i].mode == 1)
                                              ? Image.asset(
                                            Images.membershipImg,
                                            width: 80,
                                            height: 80,
                                            color: Theme.of(context).primaryColor,
                                          )
                                              :FadeInImage(
                                            image: NetworkImage(something[i].itemImage!),
                                            placeholder: AssetImage(
                                              Images.defaultProductImg,
                                            ),
                                            width: 30,
                                            height: 30,
                                            fit: BoxFit.cover,
                                          ),

                                          Expanded(
                                              child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    //SizedBox(height: 10,),

                                                    Container(
                                                      child: Text(
                                                        something[i].itemName!,
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.black54),
                                                      ),
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Container(
                                                      child: Text(
                                                        int.parse(something[i].quantity!).toString()+" * "+ something[i].varName.toString(),
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.w400,
                                                            color: Colors.grey),
                                                      ),
                                                    ),


                                                  ])),
                                          Container(
                                            child: Text(
                                              _checkmembership? (
                                                  Features.iscurrencyformatalign?
                                                  (double.parse(something[i].membershipPrice!) * int.parse(something[i].quantity!)).toString()  + " "+ IConstants.currencyFormat:
                                                  IConstants.currencyFormat + " "+(double.parse(something[i].membershipPrice!) * int.parse(something[i].quantity!)).toString()
                                              ):
                                              Features.iscurrencyformatalign?
                                              (int.parse(something[i].price!) * int.parse(something[i].quantity!)).toString()+ " "+ IConstants.currencyFormat:
                                              (IConstants.currencyFormat+ " "+(int.parse(something[i].price!) * int.parse(something[i].quantity!)).toString()),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            color: Colors.grey,
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              _dialogforDeleting();
                                              cartcontroller.update((done){
                                                // setState(() {
                                                //   _isAddToCart = !done;
                                                // });
                                              },quantity: "0",increament:something[i].increment,weight:"0",
                                                var_id: something[i].varId.toString(),price: int.parse(something[i].price!).toString(),
                                                cart_id: something[i].parent_id!,toppings: "",
                                                topping_id: "",);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: -5,
                      top: -5,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          setState(() {
                            Navigator.of(context).pop();
                          });
                        },
                        child: CircleAvatar(
                          radius: 14.0,
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.close, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );


      }
      dialogforViewAllProductExpress(int count, String express_delivery, int length) {

        showDialog(
          context: context,
          builder: (BuildContext context1) {
            return   Dialog(

              child: Container(
                width: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.30:MediaQuery.of(context).size.width,
                child: Stack(
                  // overflow: Overflow.visible,
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Column(
                              children: [
                                SizedBox(height: 10,),
                                Text(S .of(context).shipment+ " "+count.toString()+": " + express_delivery ,
                                  style: TextStyle(color: ColorCodes.blackColor, fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                SizedBox(height: 10,),
                                Text(length.toString()+" " + S .of(context).items,
                                  style: TextStyle(color: ColorCodes.greyColor, fontWeight: FontWeight.w400, fontSize: 14),
                                ),
                                SizedBox(height: 20,),

                              ],
                            ),
                          ),
                          if(ExpressDetails.length>0)
                            SizedBox(
                              child: new ListView.separated(
                                separatorBuilder: (context, index) => Divider(
                                  color: ColorCodes.lightGreyColor,
                                ),
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: ExpressDetails.length,
                                itemBuilder: (_, i) => Column(children: [
                                  Container(
                                    color: Colors.white,
                                    child: Card(

                                      elevation: 0,
                                      margin: EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          FadeInImage(
                                            image: NetworkImage(ExpressDetails[i].itemImage!),
                                            placeholder: AssetImage(
                                              Images.defaultProductImg,
                                            ),
                                            width: 30,
                                            height: 30,
                                            fit: BoxFit.cover,
                                          ),

                                          Expanded(
                                              child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    //SizedBox(height: 10,),

                                                    Container(
                                                      child: Text(
                                                        ExpressDetails[i].itemName!,
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.black54),
                                                      ),
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Container(
                                                      child: Text(
                                                        int.parse(ExpressDetails[i].quantity!).toString()+" * "+ ExpressDetails[i].varName.toString(),
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.w400,
                                                            color: Colors.grey),
                                                      ),
                                                    ),

                                                  ])),
                                          Container(
                                            child: Text(
                                              _checkmembership? (
                                                  Features.iscurrencyformatalign?
                                                  (double.parse(ExpressDetails[i].membershipPrice!) * int.parse(ExpressDetails[i].quantity!)).toString() + " "+ IConstants.currencyFormat:
                                                  IConstants.currencyFormat+ " "+(double.parse(ExpressDetails[i].membershipPrice!) * int.parse(ExpressDetails[i].quantity!)).toString()):
                                              Features.iscurrencyformatalign?
                                              (double.parse(ExpressDetails[i].price!) * int.parse(ExpressDetails[i].quantity!)).toString()+ " "+ (IConstants.currencyFormat) :
                                              (IConstants.currencyFormat+ " "+(double.parse(ExpressDetails[i].price!) * int.parse(ExpressDetails[i].quantity!)).toString()),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            color: Colors.grey,
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              _dialogforDeleting();
                                              cartcontroller.update((done){
                                                // setState(() {
                                                //   _isAddToCart = !done;
                                                // });
                                              },quantity: "0",increament:ExpressDetails[i].increment,weight:"0",
                                                var_id: ExpressDetails[i].varId.toString(),price: double.parse(ExpressDetails[i].price!).toString(),
                                                cart_id: ExpressDetails[i].parent_id!,toppings: "",
                                                topping_id: "",);


                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: -5,
                      top: -5,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          setState(() {
                            Navigator.of(context).pop();
                          });
                        },
                        child: CircleAvatar(
                          radius: 14.0,
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.close, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );


      }

      dialogforViewAllDateTimeProduct(List<CartItem> orderLinesDate, int count, String delivery_on, String date, int length) {

        showDialog(
          context: context,
          builder: (BuildContext context1) {

            return Dialog(
              /*shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0)),*/
              child: Container(
                width: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.30:MediaQuery.of(context).size.width,

                child: Stack(
                  // overflow: Overflow.visible,
                  children: [

                    SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Column(
                              children: [
                                SizedBox(height: 10,),
                                Text(S .of(context).shipment+ " "+count.toString()+": " + delivery_on +" "+ date,
                                  style: TextStyle(color: ColorCodes.blackColor, fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                SizedBox(height: 10,),
                                Text(length.toString()+" " + S .of(context).items,
                                  style: TextStyle(color: ColorCodes.greyColor, fontWeight: FontWeight.w400, fontSize: 14),
                                ),
                                SizedBox(height: 20,),
                                // Divider(thickness: 2, color: ColorCodes.greyColor,),
                                // SizedBox(height: 10,),
                              ],
                            ),
                          ),
                          if(orderLinesDate.length > 0)
                            SizedBox(
                              child: new ListView.separated(
                                separatorBuilder: (context, index) => Divider(
                                  color: ColorCodes.lightGreyColor,
                                ),
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: orderLinesDate.length,
                                itemBuilder: (_, i) =>
                                    Column(children: [
                                      Container(
                                        color: Colors.white,
                                        child: Card(

                                          elevation: 0,
                                          margin: EdgeInsets.all(5),
                                          child: Row(
                                            children: <Widget>[
                                              FadeInImage(
                                                image: NetworkImage(orderLinesDate.elementAt(i).itemImage!),
                                                placeholder: AssetImage(
                                                  Images.defaultProductImg,
                                                ),
                                                width: 30,
                                                height: 30,
                                                fit: BoxFit.cover,
                                              ),

                                              Expanded(
                                                  child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        //SizedBox(height: 10,),

                                                        Container(
                                                          child: Text(
                                                            orderLinesDate
                                                                .elementAt(i)
                                                                .itemName!,
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            maxLines: 2,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight: FontWeight
                                                                    .w600,
                                                                color: Colors.black54),
                                                          ),
                                                        ),
                                                        SizedBox(height: 5,),
                                                        Container(
                                                          child: Text(
                                                            orderLinesDate
                                                                .elementAt(i)
                                                                .quantity
                                                                .toString()+" * "+ orderLinesDate
                                                                .elementAt(i).varName
                                                                .toString(),
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight: FontWeight
                                                                    .w400,
                                                                color: Colors.grey),
                                                          ),
                                                        ),

                                                      ])),
                                              Container(
                                                child: Text(
                                                  _checkmembership? (
                                                      Features.iscurrencyformatalign?
                                                      (double.parse(orderLinesDate[i].membershipPrice!) * int.parse(orderLinesDate[i].quantity!)).toString()+ " "+IConstants.currencyFormat:
                                                      IConstants.currencyFormat+ " "+(double.parse(orderLinesDate[i].membershipPrice!) * int.parse(orderLinesDate[i].quantity!)).toString()):
                                                  (
                                                      Features.iscurrencyformatalign?
                                                      (double.parse(orderLinesDate[i].price!) * int.parse(orderLinesDate[i].quantity!)).toString() + " "+ IConstants.currencyFormat:
                                                      IConstants.currencyFormat+ " "+(double.parse(orderLinesDate[i].price!) * int.parse(orderLinesDate[i].quantity!)).toString()),
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight
                                                          .w400,
                                                      color: Colors.black),
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.delete),
                                                color: Colors.grey,
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  _dialogforDeleting();
                                                  cartcontroller.update((done){
                                                    // setState(() {
                                                    //   _isAddToCart = !done;
                                                    // });
                                                  },quantity: "0",increament:orderLinesDate[i].increment,weight:"0",
                                                    var_id: orderLinesDate[i].varId.toString(),price: double.parse(orderLinesDate[i].price!).toString(),
                                                    cart_id: orderLinesDate[i].parent_id!,
                                                    toppings: "",
                                                    topping_id: "",);

                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                    ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: -5,
                      top: -5,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: CircleAvatar(
                          radius: 14.0,
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.close, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }

      dialogforViewAllProductSlotExpress(int count, String slot_based_delivery, int length) {
        showDialog(
          context: context,
          builder: ( context) {

            return StatefulBuilder(
                builder: (context, setState1) {
                  return Dialog(
                    /* shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),*/
                    child: Container(
                      width: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width / 2.7:MediaQuery.of(context).size.width,
                      child: Stack(
                        // overflow: Overflow.visible,
                        children: [
                          SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(S .of(context).shipment+ " "+ count.toString(),
                                    style: TextStyle(color: ColorCodes.blackColor, fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                  SizedBox(height: 5,),
                                  Text(slot_based_delivery + " | " + length.toString()+" " + S .of(context).items,
                                    style: TextStyle(color: ColorCodes.blackColor, fontWeight: FontWeight.w400, fontSize: 13),
                                  ),
                                  SizedBox(height: 10,),
                                  if(DefaultSlot.length>0)
                                    SizedBox(
                                      child: new ListView.separated(
                                        separatorBuilder: (context, index) => Divider(color: ColorCodes.lightGreyWebColor, thickness: 1),
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: DefaultSlot.length,
                                        itemBuilder: (_, i) => Column(children: [
                                          Container(
                                            color: Colors.white,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                (cartItemList[i].mode == "1")
                                                    ? Image.asset(
                                                  Images.membershipImg,
                                                  width: 70,
                                                  height: 70,
                                                  color: Theme.of(context).primaryColor,
                                                )
                                                    : FadeInImage(
                                                  image: NetworkImage(DefaultSlot[i].itemImage!),
                                                  placeholder: AssetImage(
                                                    Images.defaultProductImg,
                                                  ),
                                                  width: 70,
                                                  height: 70,
                                                  fit: BoxFit.cover,
                                                ),

                                                Expanded(
                                                    child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          //SizedBox(height: 10,),

                                                          Container(
                                                            child: Text(
                                                              DefaultSlot[i].itemName!,
                                                              overflow: TextOverflow.ellipsis,
                                                              maxLines: 2,
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight: FontWeight.w600,
                                                                  color: ColorCodes.blackColor),
                                                            ),
                                                          ),
                                                          SizedBox(height: 5,),
                                                          Container(
                                                            child: Text(
                                                              int.parse(DefaultSlot[i].quantity!).toString() +" * "+ DefaultSlot[i].varName!,
                                                              overflow: TextOverflow.ellipsis,
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w400,
                                                                  color: Colors.grey),
                                                            ),
                                                          ),
                                                        ])),
                                                Column(
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(Icons.delete_forever, size: 18,),
                                                      color: ColorCodes.primaryColor,
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                        _dialogforDeleting();
                                                        cartcontroller.update((done){
                                                          // setState(() {
                                                          //   _isAddToCart = !done;
                                                          // });
                                                        },quantity: "0",increament:DefaultSlot[i].increment,weight:"0",var_id: DefaultSlot[i].varId.toString(),
                                                          price: double.parse(DefaultSlot[i].price!).toString(),
                                                          cart_id: DefaultSlot[i].parent_id!,
                                                          toppings: "",
                                                          topping_id: "",);
                                                      },
                                                    ),
                                                    SizedBox(height: 5),
                                                    Container(
                                                      child: Text(
                                                        _checkmembership? (
                                                            Features.iscurrencyformatalign?
                                                            (double.parse(DefaultSlot[i].membershipPrice!) * int.parse(DefaultSlot[i].quantity!)).toString() + " "+ IConstants.currencyFormat:
                                                            IConstants.currencyFormat+ " "+(double.parse(DefaultSlot[i].membershipPrice!) * int.parse(DefaultSlot[i].quantity!)).toString()):
                                                        (
                                                            Features.iscurrencyformatalign?
                                                            (double.parse(DefaultSlot[i].price!) * int.parse(DefaultSlot[i].quantity!)).toString() + " "+ IConstants.currencyFormat:
                                                            IConstants.currencyFormat+ " "+(double.parse(DefaultSlot[i].price!) * int.parse(DefaultSlot[i].quantity!)).toString()),
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.black),
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                              ],
                                            ),
                                          ),

                                        ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            right: -5,
                            top: -5,
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: CircleAvatar(
                                radius: 14.0,
                                backgroundColor: Colors.grey,
                                child: Icon(Icons.close, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
            );
          },
        );
      }


      /////default delivery option
      ShipmentfirstdateDelivery() {
        String deliverychargetextDate;
        int finalcount = count++;
        double defaultamountdate = 0.0;
        return (newMap != null)?
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: newMap!.length,
            itemBuilder: (_, i) {

              String minOrdAmount="0.0";
              if (_radioValue == 1) {
                if (_checkmembership) {
                  minOrdAmount = _minimumOrderAmountPrime;
                  delCharge = _deliveryChargePrime;
                } else {
                  minOrdAmount = _minimumOrderAmountNoraml;
                  delCharge = _deliveryChargeNormal;
                }

              } else {
                minOrdAmount = _minimumOrderAmountExpress;
                delCharge = _deliveryChargeExpress;
              }


              double DefaultDateTotal=0.0;
              String note="";
              for (int j = 0; j < newMap!.values.elementAt(i).length; j++) {

                DefaultDateTotal = _checkmembership?newMap!.values.elementAt(i)[j].type =="1"?
                DefaultDateTotal+(double.parse(
                    (double.parse(newMap!.values.elementAt(i)[j].membershipPrice!) *int.parse(newMap!.values.elementAt(i)[j].weight!)).toString())):
                DefaultDateTotal+(double.parse(
                    (double.parse(newMap!.values.elementAt(i)[j].membershipPrice!) *int.parse(newMap!.values.elementAt(i)[j].quantity!)).toString())):
                newMap!.values.elementAt(i)[j].type =="1"?
                    DefaultDateTotal+(double.parse(
                    (double.parse(newMap!.values.elementAt(i)[j].price!) * int.parse(newMap!.values.elementAt(i)[j].weight!)).toString())):
              DefaultDateTotal+(double.parse(
              (double.parse(newMap!.values.elementAt(i)[j].price!) * int.parse(newMap!.values.elementAt(i)[j].quantity!)).toString()));
                note= newMap!.values.elementAt(i)[j].note!;
              }
              if(DefaultDateTotal < double.parse(minOrdAmount)){
                deliveryfinalslotdate = double.parse(delCharge);
                deliveryDateamount1 = deliveryDateamount1+ deliveryfinalslotdate;
              }else{
                deliveryfinalslotdate = 0;
              }

              if(deliveryfinalslotdate == 0){
                deliverychargetextDate= "FREE";
              }else{
                deliverychargetextDate = Features.iscurrencyformatalign?
                double.parse(delCharge).toString() + " " + IConstants.currencyFormat:
                IConstants.currencyFormat + " " + double.parse(delCharge).toString();
              }
              if(DefaultDateTotal < double.parse(minOrdAmount)){
                defaultamountdate = double.parse(minOrdAmount) - DefaultDateTotal;

              }
              else{
                defaultamountdate = DefaultDateTotal - double.parse(minOrdAmount);
              }
              return Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        (newMap != null)?Text(
                          S .of(context).shipment +" "//"Shipment "
                              + (finalcount).toString(),
                          style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: ColorCodes.greyColor),
                        ):SizedBox.shrink(),
                        Text(S .of(context).delivery_on +" "//"Delivery on "
                            + newMap!.keys.elementAt(i).toString(), style: TextStyle(fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor
                        ),),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: (){
                            dialogforViewAllDateTimeProduct(newMap!.values.elementAt(i), finalcount,S .of(context).delivery_on,newMap!.keys.elementAt(i),newMap!.values.elementAt(i).length);
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 5,right: 5),
                            decoration: BoxDecoration(

                              //   borderRadius: BorderRadius.circular(3),
                                border: Border(
                                  top: BorderSide(width: 1.0, color: ColorCodes.darkgreen,),
                                  bottom: BorderSide(width: 1.0, color: ColorCodes.darkgreen,),
                                  left: BorderSide(width: 1.0, color: ColorCodes.darkgreen,),
                                  right: BorderSide(width: 1.0, color: ColorCodes.darkgreen,),
                                )
                            ),
                            height: 25,
                            child: Center(
                              child: Text(
                                S .of(context).view+" "//"View "
                                    + newMap!.values.elementAt(i).length.toString()+" "+S .of(context).items,//"Items",
                                style: TextStyle(
                                    color: ColorCodes.darkgreen,
                                    fontSize: 14
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(
                      children: [

                        Text(
                          S .of(context).delivery_charge,//"Delivery Charge: ",
                          style: TextStyle(
                              color: ColorCodes.greyColor,
                              fontSize: 10, fontWeight: FontWeight.w400
                          ),),
                        SizedBox(width: 2,),
                        Text(
                          deliverychargetextDate
                          ,style: TextStyle(
                          color: (deliverychargetextDate== "FREE")? ColorCodes.greenColor:
                          ColorCodes.greyColor,
                          fontSize: 10,
                        ),)
                        ,
                      ],
                    ),
                    SizedBox(height: 5,),
                    (note == "" || note == null)?
                    SizedBox.shrink()
                        :Row(
                      children: [

                        Text(
                          S .of(context).note,//"Note: ",
                          style: TextStyle(
                              color: ColorCodes.greyColor,
                              fontSize: 10, fontWeight: FontWeight.w400
                          ),),
                        SizedBox(width: 2,),
                        Text(
                          note
                          ,style: TextStyle(
                          color:ColorCodes.greyColor,
                          fontSize: 10,
                        ),)
                        ,
                      ],
                    ),
                    SizedBox(height: 5,),
                    ((DefaultSlot.length > 0) || newMap1 != null) ?
                    Divider(thickness: 1,color: ColorCodes.lightGreyColor,)
                        :SizedBox.shrink(),
                  ],
                ),
              );
            }
        ): SizedBox.shrink();
      }
      ShipmentfirsttimeDelivery() {
        String deliverychargetextTime;
        int finalcount = count++;
        double deliveryamounttext = 0.0;
        return (newMap1 != null)?
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: newMap1!.length,
            itemBuilder: (_, i)
            {

              String minOrdAmount="0.0";
              if (_radioValue == 1) {
                if (_checkmembership) {
                  minOrdAmount = _minimumOrderAmountPrime;
                  delCharge = _deliveryChargePrime;
                } else {
                  minOrdAmount = _minimumOrderAmountNoraml;
                  delCharge = _deliveryChargeNormal;
                }
              } else {
                minOrdAmount = _minimumOrderAmountExpress;
                delCharge = _deliveryChargeExpress;
              }

              String note="";
              double DefaultTimeTotal =0.0;
              for(int j = 0; j < newMap1!.values.elementAt(i).length; j++) {
                DefaultTimeTotal = _checkmembership?newMap1!.values.elementAt(i)[j].type =="1"?
                DefaultTimeTotal+(double.parse(
                    (double.parse(newMap1!.values.elementAt(i)[j].membershipPrice!) * int.parse(newMap1!.values.elementAt(i)[j].weight!)).toString())):
                DefaultTimeTotal+(double.parse(
                    (double.parse(newMap1!.values.elementAt(i)[j].membershipPrice!) * int.parse(newMap1!.values.elementAt(i)[j].quantity!)).toString())):
                newMap!.values.elementAt(i)[j].type =="1"?
                DefaultTimeTotal+(double.parse(
                    (double.parse(newMap1!.values.elementAt(i)[j].price!) * int.parse(newMap1!.values.elementAt(i)[j].weight!)).toString()))
                    :DefaultTimeTotal+(double.parse(
                    (double.parse(newMap1!.values.elementAt(i)[j].price!) * int.parse(newMap1!.values.elementAt(i)[j].quantity!)).toString()));
                note= newMap1!.values.elementAt(i)[j].note!;
              }
              if(DefaultTimeTotal < double.parse(minOrdAmount)){
                deliveryfinalslotTime = double.parse(delCharge);
                deliveryTimeamount1 = deliveryTimeamount1+ deliveryfinalslotTime;


              }else{
                deliveryfinalslotTime = 0;
              }
              if(deliveryfinalslotTime == 0){
                deliverychargetextTime= "FREE";
              }else{
                deliverychargetextTime = Features.iscurrencyformatalign?
                double.parse(delCharge).toString() + " " + IConstants.currencyFormat:
                IConstants.currencyFormat + " " + double.parse(delCharge).toString();
              }
              if(DefaultTimeTotal < double.parse(minOrdAmount)){
                deliveryamounttext = double.parse(minOrdAmount) - DefaultTimeTotal;

              }
              else{
                deliveryamounttext = DefaultTimeTotal - double.parse(minOrdAmount);
              }
              return Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        (newMap1 != null)?   Text(
                          S .of(context).shipment//"Shipment "
                              +" " + (finalcount).toString(),
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold,color: ColorCodes.greyColor),
                        ):SizedBox.shrink(),
                        Text( S .of(context).delivery_in+//Delivery in " +
                            " "  + newMap1!.keys.elementAt(i).toString() + S .of(context).hours,//" Hours",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600, color: ColorCodes.primaryColor)
                        ),

                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            dialogforViewAllDateTimeProduct(newMap1!.values.elementAt(i), finalcount,S .of(context).delivery_in,newMap1!.keys.elementAt(i),newMap1!.values.elementAt(i).length);
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    width: 1.0,
                                    color: ColorCodes.darkgreen,
                                  ),
                                  bottom: BorderSide(
                                    width: 1.0,
                                    color: ColorCodes.darkgreen,
                                  ),
                                  left: BorderSide(
                                    width: 1.0,
                                    color: ColorCodes.darkgreen,
                                  ),
                                  right: BorderSide(
                                    width: 1.0,
                                    color: ColorCodes.darkgreen,
                                  ),
                                )),
                            height: 25,
                            child: Center(
                              child: Text(
                                S .of(context).view +//"View "
                                    " " +
                                    newMap1!.values
                                        .elementAt(i)
                                        .length
                                        .toString() +
                                    " " +
                                    S .of(context).items,//"Items",
                                style: TextStyle(
                                    color: ColorCodes.darkgreen,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          S .of(context).delivery_charge,//"Delivery Charge: ",
                          style: TextStyle(
                              color: ColorCodes.greyColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          deliverychargetextTime,
                          style: TextStyle(
                            color: (deliverychargetextTime == "FREE")
                                ? ColorCodes.greenColor
                                : ColorCodes.greyColor,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 5,
                    ),
                    (note == "" || note == null)?
                    SizedBox.shrink()
                        : Row(
                      children: [

                        Text(
                          S .of(context).note,//"Note: ",
                          style: TextStyle(
                              color: ColorCodes.greyColor,
                              fontSize: 10, fontWeight: FontWeight.w400
                          ),),
                        SizedBox(width: 2,),
                        Text(
                          note
                          ,style: TextStyle(
                          color:ColorCodes.greyColor,
                          fontSize: 10,
                        ),)
                        ,
                      ],
                    ),
                    SizedBox(height: 5,),
                    (DefaultSlot.length > 0) ?  Divider(
                      thickness: 1,
                      color: ColorCodes.lightGreyColor,
                    ) :SizedBox.shrink(),
                  ],
                ),
              );
            })
            : SizedBox.shrink();
      }
      SlotBasedDeliveryShipment() {

        int finalcount= count++;
        return Column(
          children: [
            SizedBox(height: 5,),
            (Features.isSplit) ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S .of(context).shipment +" "//"Shipment "
                      +(finalcount).toString(),//Slot Based Delivery",
                  style: TextStyle(color: ColorCodes.blackColor,
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(S .of(context).slot_based_delivery,
                  style: TextStyle(fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: ColorCodes.primaryColor,
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: (){
                    dialogforViewAllProductSlotExpress(finalcount,S .of(context).slot_based_delivery,DefaultSlot.length);
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 5,right: 5),
                    decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 1.0, color: ColorCodes.darkgreen,),
                          bottom: BorderSide(width: 1.0, color: ColorCodes.darkgreen,),
                          left: BorderSide(width: 1.0, color: ColorCodes.darkgreen,),
                          right: BorderSide(width: 1.0, color: ColorCodes.darkgreen,),
                        )
                    ),
                    height: 25,
                    child: Center(
                      child: Text(
                        S .of(context).view//"View "
                            + " " + DefaultSlot.length.toString()+" "+
                            S .of(context).items,//"Items",
                        style: TextStyle(
                            color: ColorCodes.darkgreen,
                            fontSize: 14
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ) : SizedBox.shrink(),
            (Features.isSplit) ? Row(
              children: [

                Text(
                  S .of(context).delivery_charge,//"Delivery Charge: ",
                  style: TextStyle(
                      color: ColorCodes.greyColor,
                      fontSize: 10, fontWeight: FontWeight.w400
                  ),),
                SizedBox(width: 2,),
                Text(
                  deliverychargetextdefault!
                  ,style: TextStyle(
                  color: (deliverychargetextdefault == "FREE")? ColorCodes.greenColor:
                  ColorCodes.greyColor,
                  fontSize: 10,
                ),)
                ,
              ],
            ) : SizedBox.shrink(),
            (Features.isSplit) ? SizedBox(height: 10,) : SizedBox(height: 5,),
            /*Row(
                                     children: [
                                       // SizedBox(width: 30,),
                                       GestureDetector(
                                         behavior: HitTestBehavior.translucent,
                                         onTap: () {
                                           //slotBasedDelivery();
                                           SelectTimeSlot();
                                         },
                                         child: Container(

                                           width: MediaQuery.of(context).size.width *90/100,
                                           height: 30,
                                           decoration: BoxDecoration(
                                               color: Colors.white,
                                               borderRadius: BorderRadius.circular(3),
                                               border: Border(
                                                 top: BorderSide(width: 1.0, color: ColorCodes.greyColor,),
                                                 bottom: BorderSide(width: 1.0, color: ColorCodes.greyColor,),
                                                 left: BorderSide(width: 1.0, color: ColorCodes.greyColor,),
                                                 right: BorderSide(width: 1.0, color: ColorCodes.greyColor,),
                                               )
                                           ),
                                           child: Row(
                                             children: [
                                               SizedBox(width: 10,),
                                               Icon(
                                                 Icons.access_time,
                                                 color: ColorCodes.greyColor,
                                               ),
                                               SizedBox(width: 10,),
                                               Text(prefs.getString('fixtime',),textAlign:TextAlign.center,style: TextStyle(
                                                 color: ColorCodes.blackColor,

                                               ),),
                                               Spacer(),
                                               Icon(
                                                 Icons.arrow_drop_down,
                                                 color: ColorCodes.greyColor,
                                               ),
                                             ],
                                           ),
                                         ),
                                       )

                                     ],
                                   ),*/
            Row(
              children: [
                Text(
                  S .of(context).select_TimeSlot,//"Delivery Charge: ",
                  style: TextStyle(
                      color: ColorCodes.blackColor,
                      fontSize: 15, fontWeight: FontWeight.bold
                  ),),
              ],
            ),
            SizedBox(height: 5,),
            SelectDate(),
            SizedBox(height: 10,),
            //  Divider(thickness: 1,color: ColorCodes.lightGreyColor,),
          ],
        );
      }

      ////// delivery option 2
      ExpressDeliveryDetails(){

        int finalCount = countTime++;
        return  (ExpressDetails.length >0)?
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (ExpressDetails.length >0)?   Text(
                  S .of(context).shipment+ //"Shipment "
                      " " + (finalCount).toString() ,//Express Delivery",
                  style: TextStyle(color: ColorCodes.blackColor,
                      fontSize: 15, fontWeight: FontWeight.bold),
                ):SizedBox.shrink(),
                Text( S .of(context).express_delivery,
                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: ColorCodes.primaryColor)),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: (){
                    dialogforViewAllProductExpress(finalCount,S .of(context).express_delivery,ExpressDetails.length);
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 5,right: 5),
                    decoration: BoxDecoration(

                        border: Border(
                          top: BorderSide(width: 1.0, color: ColorCodes.greenColor,),
                          bottom: BorderSide(width: 1.0, color: ColorCodes.greenColor,),
                          left: BorderSide(width: 1.0, color: ColorCodes.greenColor,),
                          right: BorderSide(width: 1.0, color: ColorCodes.greenColor,),
                        )
                    ),
                    height: 25,
                    child: Center(
                      child: Text(
                        S .of(context).view//"View "
                            +" " + ExpressDetails.length.toString()+" "+
                            S .of(context).items,//"Items",
                        style: TextStyle(
                            color: ColorCodes.darkgreen,
                            fontSize: 14
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),
            SizedBox(height: 5,),
            Row(
              children: [

                Text(
                  S .of(context).delivery_charge//"Delivery Charge: "
                  ,style: TextStyle(
                    color: ColorCodes.greyColor,
                    fontSize: 10, fontWeight: FontWeight.w400
                ),),
                SizedBox(width: 2,),
                Text(
                  (deliverychargetextExpress)!
                  ,style: TextStyle(
                  color: (deliverychargetextExpress == "FREE")? ColorCodes.greenColor:
                  ColorCodes.greyColor,
                  fontSize: 10,
                ),)
                ,
              ],
            ),
            SizedBox(height: 10,),
            (newMap2 != null || newMap3 != null || something.length > 0)?
            Divider(thickness: 1,color: ColorCodes.lightGreyColor,):
            SizedBox.shrink()
          ],
        ):
        SizedBox.shrink();
      }
      ExpressSlotDeliveryDetails(){
        int standard= countTime++;
        return   Column(
          children: [
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S .of(context).shipment+
                      " " + (standard).toString() ,//Slot Based Delivery",
                  style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold, color: ColorCodes.greyColor),
                ),
                Text(
                  S .of(context).slot_based_delivery,
                  style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600, color: ColorCodes.primaryColor),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: (){
                    dialogforViewAllProductSecond(standard,S .of(context).slot_based_delivery,something.length);
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 5,right: 5),
                    decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 1.0, color: ColorCodes.darkgreen,),
                          bottom: BorderSide(width: 1.0, color: ColorCodes.darkgreen,),
                          left: BorderSide(width: 1.0, color: ColorCodes.darkgreen,),
                          right: BorderSide(width: 1.0, color: ColorCodes.darkgreen,),
                        )
                    ),
                    height: 25,
                    child: Center(
                      child: Text(
                        S .of(context).view//"View "
                            + " "  + something.length.toString()+" "+
                            S .of(context).items ,//"Items",
                        style: TextStyle(
                            color: ColorCodes.darkgreen,
                            fontSize: 14
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5,),
            Row(
              children: [

                Text(
                  S .of(context).delivery_charge,//"Delivery Charge: ",
                  style: TextStyle(
                      color: ColorCodes.greyColor,
                      fontSize: 10, fontWeight: FontWeight.w400
                  ),),
                SizedBox(width: 2,),
                Text(
                  deliverychargetextSecond!
                  ,style: TextStyle(
                  color: (deliverychargetextSecond == "FREE")? ColorCodes.greenColor:
                  ColorCodes.greyColor,
                  fontSize: 10,
                ),)
                ,
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Text(
                  S .of(context).select_TimeSlot,//"Delivery Charge: ",
                  style: TextStyle(

                      fontSize: 13, fontWeight: FontWeight.bold,color: ColorCodes.greyColor
                  ),),
              ],
            ),
            SizedBox(height: 5,),
            SelectDate(),
            SizedBox(height: 10,),
            //  Divider(thickness: 1,color: ColorCodes.lightGreyColor,),
          ],
        );
      }
      ShipmentTwoDelivery() {

        int finalCount=countTime++;
        return /*(newMap2.length > 0)?*/
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: newMap2!.length,
              itemBuilder: (ctx, i)
              {
                String minOrdAmount="0.0";
                if (_radioValue == 1) {
                  if (_checkmembership) {
                    minOrdAmount = _minimumOrderAmountPrime;
                    delCharge = _deliveryChargePrime;
                  } else {
                    minOrdAmount = _minimumOrderAmountNoraml;
                    delCharge = _deliveryChargeNormal;
                  }
                } else {
                  minOrdAmount = _minimumOrderAmountExpress;
                  delCharge = _deliveryChargeExpress;
                }

                String note ="";
                for (int j = 0; j < newMap2!.values.elementAt(i).length; j++) {
                  SecondDateTotal = _checkmembership?newMap2!.values.elementAt(i)[j].type =="1"?
                  SecondDateTotal + (double.parse(
                      (double.parse(newMap2!.values.elementAt(i)[j].membershipPrice!) *int.parse(newMap2!.values.elementAt(i)[j].weight!))
                          .toString())):
                  SecondDateTotal + (double.parse(
                      (double.parse(newMap2!.values.elementAt(i)[j].membershipPrice!) *int.parse(newMap2!.values.elementAt(i)[j].quantity!))
                          .toString())):newMap2!.values.elementAt(i)[j].type =="1"?
                  SecondDateTotal + (double.parse(
                      (double.parse(newMap2!.values.elementAt(i)[j].price!) *int.parse(newMap2!.values.elementAt(i)[j].weight!))
                          .toString()))
                      :SecondDateTotal + (double.parse(
                      (double.parse(newMap2!.values.elementAt(i)[j].price!) *int.parse(newMap2!.values.elementAt(i)[j].quantity!))
                          .toString()));
                  note= newMap2!.values.elementAt(i)[j].note!;
                }
                if (SecondDateTotal < double.parse(minOrdAmount)) {

                  deliveryDateamount = double.parse(delCharge);
                  deliveryfinalexpressdate = deliveryfinalexpressdate + deliveryDateamount ;
                } else {
                  deliveryDateamount = 0;
                }

                if (deliveryDateamount == 0) {
                  deliverychargetextSecDate = "FREE";
                } else {
                  deliverychargetextSecDate =
                  Features.iscurrencyformatalign?
                  deliveryDateamount.toString()  + " " + IConstants.currencyFormat:
                  IConstants.currencyFormat + " " + deliveryDateamount.toString();
                }
                return  Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            S .of(context).shipment+" "//"Shipment "
                                + (finalCount).toString() ,
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold,color: ColorCodes.greyColor),
                          ),
                          Text( S .of(context).delivery_on + " "//Delivery on " +
                              + newMap2!.keys.elementAt(i).toString(),
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600,color: ColorCodes.primaryColor),
                          ),

                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              dialogforViewAllDateTimeProduct(newMap2!.values.elementAt(i),finalCount,S .of(context).delivery_on,newMap2!.keys.elementAt(i),newMap2!.values.elementAt(i).length);
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              decoration: BoxDecoration(

                                  border: Border(
                                    top: BorderSide(
                                      width: 1.0,
                                      color: ColorCodes.darkgreen,
                                    ),
                                    bottom: BorderSide(
                                      width: 1.0,
                                      color: ColorCodes.darkgreen,
                                    ),
                                    left: BorderSide(
                                      width: 1.0,
                                      color: ColorCodes.darkgreen,
                                    ),
                                    right: BorderSide(
                                      width: 1.0,
                                      color: ColorCodes.darkgreen,
                                    ),
                                  )),
                              height: 25,
                              child: Center(
                                child: Text(
                                  S .of(context).view// "View "
                                      +" " + newMap2!.values
                                      .elementAt(i)
                                      .length
                                      .toString() +
                                      " " +
                                      S .of(context).items,//"Items",
                                  style: TextStyle(
                                      color: ColorCodes.darkgreen,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            S .of(context).delivery_charge,//"Delivery Charge: ",
                            style: TextStyle(
                                color: ColorCodes.greyColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            deliverychargetextSecDate!,
                            style: TextStyle(
                              color: (deliverychargetextSecDate == "FREE")
                                  ? ColorCodes.greenColor
                                  : ColorCodes.greyColor,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      (note == "" || note == null)?
                      SizedBox.shrink()
                          :Row(
                        children: [

                          Text(
                            S .of(context).note,//"Note: ",
                            style: TextStyle(
                                color: ColorCodes.greyColor,
                                fontSize: 10, fontWeight: FontWeight.w400
                            ),),
                          SizedBox(width: 2,),
                          Text(
                            note
                            ,style: TextStyle(
                            color:ColorCodes.greyColor,
                            fontSize: 10,
                          ),)
                          ,
                        ],
                      ),
                      SizedBox(height: 5,),
                      (newMap3 != null || something.length > 0) ?
                      Divider(
                        thickness: 1,
                        color: ColorCodes.lightGreyColor,
                      ):
                      SizedBox.shrink()
                    ],
                  ),
                );
              }) /*: SizedBox.shrink()*/;


      }
      ShipmentThreeDelivery() {
        int finalCount=countTime++;

        return /*(newMap3.length > 0)?*/
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: newMap3!.length,
              itemBuilder: (_, i)
              {

                String minOrdAmount="0.0";
                if (_radioValue == 1) {
                  if (_checkmembership) {
                    minOrdAmount = _minimumOrderAmountPrime;
                    delCharge = _deliveryChargePrime;
                  } else {
                    minOrdAmount = _minimumOrderAmountNoraml;
                    delCharge = _deliveryChargeNormal;
                  }
                } else {
                  minOrdAmount = _minimumOrderAmountExpress;
                  delCharge = _deliveryChargeExpress;
                }

                double SecondTimeTotal =0.0;
                String note ="";
                for (int j = 0; j < newMap3!.values.elementAt(i).length; j++) {

                  SecondTimeTotal =_checkmembership?newMap3!.values.elementAt(i)[j].type =="1"?
                  SecondTimeTotal+(double.parse(
                      (double.parse(newMap3!.values.elementAt(i)[j].membershipPrice!) * int.parse(newMap3!.values.elementAt(i)[j].weight!))
                          .toString())):
                  SecondTimeTotal+(double.parse(
                      (double.parse(newMap3!.values.elementAt(i)[j].membershipPrice!) * int.parse(newMap3!.values.elementAt(i)[j].quantity!))
                          .toString())):newMap3!.values.elementAt(i)[j].type =="1"?
                  SecondTimeTotal+(double.parse(
                      (double.parse(newMap3!.values.elementAt(i)[j].price!) * int.parse(newMap3!.values.elementAt(i)[j].weight!))
                          .toString()))
                      :SecondTimeTotal+(double.parse(
                      (double.parse(newMap3!.values.elementAt(i)[j].price!) * int.parse(newMap3!.values.elementAt(i)[j].quantity!))
                          .toString()));
                  note= newMap3!.values.elementAt(i)[j].note!;

                }
                if(SecondTimeTotal < double.parse(minOrdAmount)){
                  deliveryTimeamount = double.parse(delCharge);
                  deliveryfinalexpressTime = deliveryfinalexpressTime + (deliveryTimeamount ) ;
                }else{
                  deliveryTimeamount = 0;
                }

                if(deliveryTimeamount == 0){
                  deliverychargetextSecTime = "FREE";
                }else{
                  deliverychargetextSecTime = Features.iscurrencyformatalign?
                  deliveryTimeamount.toString() + " " + IConstants.currencyFormat:
                  IConstants.currencyFormat + " " + deliveryTimeamount.toString();
                }
                return  Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            S .of(context).shipment+ " "//"Shipment "
                                + (finalCount).toString() ,
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold,color: ColorCodes.greyColor),
                          ),
                          Text(S .of(context).delivery_in+ " "//Delivery in " +
                              + newMap3!.keys.elementAt(i).toString() +" Hours",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600,color: ColorCodes.primaryColor),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              dialogforViewAllDateTimeProduct(newMap3!.values.elementAt(i),finalCount,S .of(context).delivery_in,newMap3!.keys.elementAt(i),newMap3!.values.elementAt(i).length);
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              decoration: BoxDecoration(

                                  border: Border(
                                    top: BorderSide(
                                      width: 1.0,
                                      color: ColorCodes.darkgreen,
                                    ),
                                    bottom: BorderSide(
                                      width: 1.0,
                                      color: ColorCodes.darkgreen,
                                    ),
                                    left: BorderSide(
                                      width: 1.0,
                                      color: ColorCodes.darkgreen,
                                    ),
                                    right: BorderSide(
                                      width: 1.0,
                                      color: ColorCodes.darkgreen,
                                    ),
                                  )),
                              height: 25,
                              child: Center(
                                child: Text(
                                  S .of(context).view//"View "
                                      +" "  + newMap3!.values
                                      .elementAt(i)
                                      .length
                                      .toString() +
                                      " " +
                                      S .of(context).items,//"Items",
                                  style: TextStyle(
                                      color: ColorCodes.darkgreen,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            S .of(context).delivery_charge,//"Delivery Charge: ",
                            style: TextStyle(
                                color: ColorCodes.greyColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            deliverychargetextSecTime!,
                            style: TextStyle(
                              color: (deliverychargetextSecTime == "FREE")
                                  ? ColorCodes.greenColor
                                  : ColorCodes.greyColor,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      (note == "" || note == null)?
                      SizedBox.shrink()
                          : Row(
                        children: [

                          Text(
                            S .of(context).note//"Note: "
                            ,style: TextStyle(
                              color: ColorCodes.greyColor,
                              fontSize: 10, fontWeight: FontWeight.w400
                          ),),
                          SizedBox(width: 2,),
                          Text(
                            note
                            ,style: TextStyle(
                            color:ColorCodes.greyColor,
                            fontSize: 10,
                          ),)
                          ,
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      (something.length > 0) ?
                      Divider(
                        thickness: 1,
                        color: ColorCodes.lightGreyColor,
                      ):
                      SizedBox.shrink()
                    ],
                  ),
                );
              })/*: SizedBox.shrink()*/ ;
      }


      StandardDelivery() {

        return
          Column(
            children: [
              SizedBox(height: 5,),
              (newMap != null)? ShipmentfirstdateDelivery(): SizedBox.shrink(),
              SizedBox(height: 5,),
              (newMap1 != null)? ShipmentfirsttimeDelivery() :SizedBox.shrink(),
              SizedBox(height: 5,),

              (DefaultSlot.length > 0) ?
              SlotBasedDeliveryShipment():
              SizedBox.shrink(),


            ],
          );
      }

      ExpressDelivery() {
        return Container(
          color: ColorCodes.whiteColor,
          padding: EdgeInsets.only(left: 20,right: 20),
          child: Column(
            children: [
              SizedBox(height: 5,),
              (ExpressDetails.length >0)?ExpressDeliveryDetails():SizedBox.shrink(),
              (newMap2 != null)?ShipmentTwoDelivery():SizedBox.shrink(),
              (newMap3 != null)?ShipmentThreeDelivery():SizedBox.shrink(),

              (something.length > 0) ?
              ExpressSlotDeliveryDetails():
              SizedBox.shrink(),

            ],
          ),
        );

      }



      void _settingModalBottomSheet(context, String from) {
        showDialog(
            context: context,
            builder: (BuildContext bc) {
              return  VxBuilder(
                  mutations: {SetAddress,SetUserData},
                  builder: (ctx, store,VxStatus? state){
                    addressdata = store!.userData;
                    return Dialog(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                          decoration: BoxDecoration(
                              color: ColorCodes.whiteColor,
                              borderRadius: BorderRadius.all(Radius.circular(10.0))
                          ),
                        padding: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0, bottom: iphonex ? 16.0 : 0.0),
                        child: new Wrap(
                          children: <Widget>[
                            Container(
                              height: 30.0,
                              //color: ColorCodes.lightColor,
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    S .of(context).choose_delivery_address,//"Choose a delivery address",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            SizedBox(
                              child: new ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: /*addressitemsData.items.length*/addressdata!.billingAddress!.length,
                                itemBuilder: (_, i) => Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        String addsId = "";
                                        setState(() {
                                          addsId = PrefUtils.prefs!.getString("addressId")!;
                                          /* _slotsLoading = true;
                               prefs.setString("addressId", addressitemsData.items[i].userid);
                               addtype = addressitemsData.items[i].useraddtype;
                               address = addressitemsData.items[i].useraddress;
                               addressicon = addressitemsData.items[i].addressicon;
                               calldeliverslots(addressitemsData.items[i].userid);
                               deliveryCharge(addressitemsData.items[i].userid);*/
                                        });
                                        if (from == "selectAddress") {
                                          Navigator.of(context).pop();
                                          _dialogforProcessing();

                                          cartCheck(
                                              PrefUtils.prefs!.getString("addressId")!,
                                              addressdata!.billingAddress![i].id.toString(),
                                              addressdata!.billingAddress![i].addressType!,
                                              addressdata!.billingAddress![i].address!,
                                              addressdata!.billingAddress![i].addressicon!,
                                              addressdata!.billingAddress![i].fullName!
                                          );
                                          /*setState(() {
                                 _checkaddress = true;
                                 addtype = addressitemsData.items[i].useraddtype;
                                 address = addressitemsData.items[i].useraddress;
                                 addressicon = addressitemsData.items[i].addressicon;
                                 prefs.setString("addressId", addressitemsData.items[i].userid);
                                 _slotsLoading = true;
                                 _isChangeAddress = false;
                                 calldeliverslots(addressitemsData.items[i].userid);
                                 deliveryCharge(addressitemsData.items[i].userid);
                               });*/
                                        } else {
                                          Navigator.of(context).pop();
                                          if (addsId != /*addressitemsData.items[i].userid*/addressdata!.billingAddress![i].id) {
                                            /* _dialogforAvailability(
                                   addsId,
                                   addressitemsData.items[i].userid,
                                   addressitemsData.items[i].useraddtype,
                                   addressitemsData.items[i].useraddress,
                                   addressitemsData.items[i].addressicon,
                               );*/
                                            _dialogforProcessing();
                                            cartCheck(
                                                PrefUtils.prefs!.getString("addressId")!,
                                                addressdata!.billingAddress![i].id.toString(),
                                                addressdata!.billingAddress![i].addressType!,
                                                addressdata!.billingAddress![i].address!,
                                                addressdata!.billingAddress![i].addressicon!,
                                                addressdata!.billingAddress![i].fullName
                                            );
                                          } else {
                                            setState(() {
                                              _checkaddress = true;
                                              addtype =
                                                  addressdata!.billingAddress![i].addressType;
                                              address =
                                                  addressdata!.billingAddress![i].address;
                                              name = addressdata!.billingAddress![i].fullName!;
                                              addressicon =
                                                  addressdata!.billingAddress![i].addressicon;
                                              PrefUtils.prefs!.setString("addressId",
                                                  addressdata!.billingAddress![i].id.toString());
                                              //_slotsLoading = true;
                                              _isChangeAddress = false;
                                              //calldeliverslots(addressitemsData.items[i].userid);
                                              //deliveryCharge(addressitemsData.items[i].userid);
                                            });
                                          }
                                        }
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          Icon(addressdata!.billingAddress![i].addressicon),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 15.0,
                                                ),
                                                Text(
                                                  addressdata!.billingAddress![i].addressType!,
                                                  style: TextStyle(
                                                      color: ColorCodes.blackColor,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16.0),
                                                ),
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                                Text(
                                                  addressdata!.billingAddress![i].address!,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 13.0,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                Divider(
                                                  color: ColorCodes.lightgrey,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //Divider(color: Colors.black,),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  // Navigator.of(context).pop();
                                  // Navigator.of(context).pop();
                                  /*        Navigator.of(context)
                                      .pushReplacementNamed(AddressScreen.routeName, arguments: {
                                    'addresstype': "new",
                                    'addressid': "",
                                    'delieveryLocation': "",
                                    'latitude': "",
                                    'longitude': "",
                                    'branch': ""
                                  });*/
                                  if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                                  // _dialogforaddress(context);
                                  AddressWeb(context,
                                    addresstype: "new",
                                    addressid: "",
                                    delieveryLocation: "",
                                    latitude: "",
                                    longitude: "",
                                    branch: "",);
                                  }
                                  else {
                                    Navigation(
                                        context, name: Routename.AddressScreen,
                                        navigatore: NavigatoreTyp.Push,
                                        qparms: {
                                          'addresstype': "new",
                                          'addressid': "",
                                          'delieveryLocation': "",
                                          'latitude': "",
                                          'longitude': "",
                                          'branch': "",
                                        });
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 3.8,
                                  margin: EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    color: ColorCodes.primaryColor,
                                      borderRadius: BorderRadius.all(Radius.circular(5.0))
                                  ),
                                  padding: EdgeInsets.only(top: 13, bottom: 13),
                                  child: Center(
                                    child: Text(
                                      S .of(context).add_new_address,//"Add new Address",
                                      style: TextStyle(
                                          color: ColorCodes.whiteColor, fontSize: 16.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
              );
            });
      }

      Widget _deliveryTimeSlotText() {
        return Container(

          width: MediaQuery.of(context).size.width * 0.40,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          color: ColorCodes.lightGreyWebColor,
          child: Column(
            children: [
              Row(
                children: [
                  Image(
                    image: AssetImage(Images.scooterImg),
                    width: 30,
                    height: 30,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    S .of(context).delivery,//'Delivery',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                S .of(context).please_select_delivery_slot,//'Please select a time slot as per your convience. Your order will be delivered during the time slot.',
                style: TextStyle(
                  fontSize: 11,
                  color: ColorCodes.greyColor,
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        );
      }

      // (!_isChangeAddress)
      // !_slotsLoading
      // ? _checkslots

      return _initialloading
          ? Center(
        child: CheckOutShimmer(),
      )
          :
      (checkskip && !ResponsiveLayout.isSmallScreen(context))
          ?
      Column(
        children: [
          SizedBox(height: 50,),
          Container(
            width: MediaQuery.of(context).size.width * 0.40,
            height: 50,
            child: Container(
              // color: Theme.of(context).primaryColor,
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Column(children: <Widget>[

                Center(
                  child: Text(
                    S .of(context).not_yet_logged_in,// " You are not Logged in, Please Login to Continue with Proceed To Checkout",
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ]),
            ),
          ),
          SizedBox(
            height: 17,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.40,
            height: 50,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: (){
                  // _dialogforSignIn();
                  LoginWeb(context,result: (sucsess){
                    if(sucsess){
                      Navigator.of(context).pop();
                      /*Navigator.pushNamedAndRemoveUntil(
                          context,  CartScreen.routeName, (route) => false,arguments: {
                        "afterlogin": ""
                      });*/

                      Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":""});
                    }else{
                      Navigator.of(context).pop();
                    }
                  });
                },
                child: Container(
                  color: Theme.of(context).primaryColor,
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: Column(children: <Widget>[
                    SizedBox(
                      height: 17,
                    ),
                    Center(
                      child: Text(
                        S .of(context).proceed_to_pay,//'PROCEED TO CHECKOUT',
                        style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ]),
                ),
              ),
            ),
          ),
        ],
      ):
      /* _Load
          ? Center(
        child:CircularProgressIndicator()
       // CheckOutShimmer(), //CircularProgressIndicator( valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor,),

      ):*/Column(
        children: [
          if(!Features.ismultivendor)
          SizedBox(height: 20,),
          SingleChildScrollView(
              child: Container(
                width: Features.ismultivendor?MediaQuery.of(context).size.width:MediaQuery.of(context).size.width * 0.42,
                //height: MediaQuery.of(context).size.height,
                // color: ColorCodes.lightGreyColor,
                // padding: EdgeInsets.only(left: 10.0, top: 10.0, ),
                child: Column(
                  children: <Widget>[
                    !_isChangeAddress
                        ? _checkaddress
                        ? Column(
                          children: [
                            if(!Features.ismultivendor)
                            Container(
                              decoration: BoxDecoration(
                                color: ColorCodes.whiteColor,
                                borderRadius: BorderRadius.circular(5)),
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15),
                              child: Column(
                                children: [
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              S .of(context).select_delivery_address,//"Select delivery address",
                                              style: TextStyle(
                                                  fontWeight: (Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))? FontWeight.w900 : FontWeight.bold,
                                                  fontSize: (Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))? 18 : 16.0,
                                                  color: (Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))? ColorCodes.blackColor : ColorCodes.cartgreenColor),
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Column(
                                              children: [

                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    (addtype == "home")? Image.asset(Images.homeConfirm,
                                                      height: 22,
                                                      width: 22,
                                                      color: ColorCodes.blackColor,
                                                    ):(addtype == "Work")?Image.asset(Images.workConfirm,
                                                      height: 22,
                                                      width: 22,
                                                      color: ColorCodes.blackColor,
                                                    ):Image.asset(Images.otherConfirm,
                                                      height: 25,
                                                      width: 25,
                                                      color: ColorCodes.blackColor,
                                                    ),
                                                    SizedBox(width: 10,),
                                                    Text(
                                                      name,
                                                      style: TextStyle(
                                                        color: ColorCodes.blackColor,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 15.0,
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    GestureDetector(
                                                        behavior: HitTestBehavior.translucent,
                                                        onTap: () {
                                                          _settingModalBottomSheet(context, "change");
                                                        },
                                                        child: Container(

                                                          child: Text(
                                                            S .of(context).change_caps,//"CHANGE",
                                                            style: TextStyle(
                                                              //decoration: TextDecoration.underline,
                                                                decorationStyle:
                                                                TextDecorationStyle.dashed,
                                                                fontWeight: FontWeight.bold,
                                                                color: ColorCodes.blackColor,
                                                                fontSize: 15.0),
                                                          ),
                                                        )),
                                                    SizedBox(
                                                      width: 10.0,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5,),
                                            Container(
                                            height: 40,
                                              child: Row(
                                                children: [
                                                  SizedBox(width: 40,),
                                                  Flexible(

                                                    child: Text(
                                                      address,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                        letterSpacing: 1,
                                                        color: Colors.grey,
                                                        fontSize: 14.0,
                                                      ),
                                                    ),
                                                  ),

                                                  SizedBox(
                                                    width: 60.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                  ((double.parse(_minimumOrderAmountNoraml) > CartCalculations.total) && (double.parse(_minimumOrderAmountPrime) > CartCalculations.totalMember)) ?
                                  SizedBox(height: 83,) : SizedBox(height: 43,),
                                  ListTile(
                                    dense:true,
                                    contentPadding: EdgeInsets.only(left: 10.0),
                                    leading: Image.asset(Images.request,
                                      height: 30,
                                      width: 30,
                                        color: ColorCodes.blackColor,
                                    ),
                                    title: Transform(
                                      transform: Matrix4.translationValues(-16, 0.0, 0.0),
                                      child: TextField(
                                        controller: _message,
                                        decoration: InputDecoration.collapsed(
                                            hintText: !Features.ismultivendor?S .of(context).any_request:S.of(context).any_instruct_multivendor,//"Any request? We promise to pass it on",
                                            hintStyle: TextStyle(fontSize: 15.0, color: ColorCodes.blackColor, fontWeight: FontWeight.bold , letterSpacing: 1,),
                                            //contentPadding: EdgeInsets.all(16),
                                            //border: OutlineInputBorder(),
                                            fillColor: ColorCodes.lightGreyColor),
                                        //minLines: 3,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if(Features.ismultivendor)
                            SizedBox(
                              height:10,
                            ),
                            if(Features.ismultivendor)
                              paymentDetails(),
                            if(Features.ismultivendor)
                              Container(
                                decoration: BoxDecoration(
                                    color: ColorCodes.whiteColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: ColorCodes.grey.withOpacity(0.3),
                                        spreadRadius: 4,
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      )
                                    ]
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                child: Row(
                                  children: <Widget>[
                                    if(Features.ismultivendor)
                                      Image.asset(Images.addressmultivendor,
                                        height: 35,
                                        width: 30,
                                        color: ColorCodes.greenColor,
                                      ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[

                                          Row(
                                            children: [

                                              if(!Features.ismultivendor)
                                              (addtype == "home")? Image.asset(Images.homeConfirm,
                                                height: 30,
                                                width: 30,
                                                color: ColorCodes.blackColor,
                                              ):(addtype == "Work")?Image.asset(Images.workConfirm,
                                                height: 30,
                                                width: 30,
                                                color: ColorCodes.blackColor,
                                              ):Image.asset(Images.otherConfirm,
                                                height: 30,
                                                width: 30,
                                                color: ColorCodes.blackColor,
                                              ),
                                              SizedBox(width: 10,),

                                            ],
                                          ),
                                          SizedBox(
                                            height: 1.0,
                                          ),
                                          Column(
                                            children: [

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Features.ismultivendor?SizedBox(width: 10,):SizedBox(width: 40,),
                                                  Text(
                                                    Features.ismultivendor?addtype:S .of(context).select_delivery_address,//"Select delivery address",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16.0,
                                                        color: ColorCodes.blackColor),
                                                  ),
                                                  // Text(
                                                  //   name,
                                                  //   style: TextStyle(
                                                  //     color: ColorCodes.blackColor,
                                                  //     fontWeight: FontWeight.bold,
                                                  //     fontSize: 16.0,
                                                  //   ),
                                                  // ),
                                                  Spacer(),
                                                  GestureDetector(
                                                      behavior: HitTestBehavior.translucent,
                                                      onTap: () {
                                                        _settingModalBottomSheet(context, "change");
                                                      },
                                                      child: Container(

                                                        child: Text(
                                                          S .of(context).change_caps,//"CHANGE",
                                                          style: TextStyle(
                                                            //decoration: TextDecoration.underline,
                                                              decorationStyle:
                                                              TextDecorationStyle.dashed,
                                                              color: Features.ismultivendor?ColorCodes.greenColor:ColorCodes.mediumBlueColor,
                                                              fontSize: 13.0),
                                                        ),
                                                      )),
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5,),
                                          Row(
                                            children: [
                                              Features.ismultivendor?SizedBox(width: 10,):SizedBox(width: 40,),
                                              Flexible(

                                                child: Text(
                                                  address,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ),

                                              SizedBox(
                                                width: 60.0,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),

                          ],
                        )
                        : Column(
                      children: [
                        SizedBox(
                          height:10,
                        ),
                        if(Features.ismultivendor)
                          paymentDetails(),
                        if(!Features.ismultivendor)
                        Container(
                          width: Features.ismultivendor?MediaQuery.of(context).size.width:MediaQuery.of(context).size.width * 0.40,
                          height: 50,
                          child: Container(
                            // color: Theme.of(context).primaryColor,
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            margin: Features.ismultivendor?EdgeInsets.only(left:10,right:10):EdgeInsets.only(left:0,right:0),
                            child: Column(children: <Widget>[

                              Center(
                                child: Text(
                                  "You are not yet added delivery address, Please add address to continue.",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ]),
                          ),
                        ),
                        if(!Features.ismultivendor)
                        SizedBox(
                          height: 17,
                        ),

                        if(!Features.ismultivendor)
                        Container(
                          width: MediaQuery.of(context).size.width * 0.40,
                          height: 50,
                          child: FlatButton(

                            color: Theme.of(context).primaryColor,
                            textColor: Theme.of(context).buttonColor,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(3.0),
                            ),
                            onPressed: ()  {
                              /*       Navigator.of(context).pushReplacementNamed(
                                      AddressScreen.routeName,
                                      arguments: {
                                        'addresstype': "new",
                                        'addressid': "",
                                        'delieveryLocation': "",
                                        'latitude': "",
                                        'longitude': "",
                                        'branch': ""
                                      })*/

                              if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                              // _dialogforaddress(context);
                              AddressWeb(context,
                                addresstype: "new",
                                addressid: "",
                                delieveryLocation: "",
                                latitude: "",
                                longitude: "",
                                branch: "",);
                              }
                              else {
                              Navigation(context, name: Routename.AddressScreen, navigatore: NavigatoreTyp.Push,
                                  qparms: {
                                    'addresstype': "new",
                                    'addressid': "",
                                    'delieveryLocation': "",
                                    'latitude': "",
                                    'longitude': "",
                                    'branch': "",
                                  });
                              }
                            },
                            child: Text(
                              S .of(context).add_address,//'Add Address',
                              style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        if(!Features.ismultivendor)
                        SizedBox(height: 20,),
                        // SizedBox(height: 20,),
                        // ListTile(
                        //   dense:true,
                        //   contentPadding: EdgeInsets.only(left: 10.0),
                        //   leading: Image.asset(Images.request,
                        //     height: 30,
                        //     width: 30,
                        //   ),
                        //   title: Transform(
                        //     transform: Matrix4.translationValues(-16, 0.0, 0.0),
                        //     child: TextField(
                        //       controller: _message,
                        //       decoration: InputDecoration.collapsed(
                        //           hintText: S .of(context).any_request,//"Any request? We promise to pass it on",
                        //           hintStyle: TextStyle(fontSize: 12.0),
                        //           //contentPadding: EdgeInsets.all(16),
                        //           //border: OutlineInputBorder(),
                        //           fillColor: ColorCodes.lightGreyColor),
                        //       //minLines: 3,
                        //       maxLines: 1,
                        //     ),
                        //   ),
                        // ),
                      ],
                    )
                        : Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(5.0),
                            color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Icon(Icons.location_on),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 15.0,
                                          ),
                                          Text(
                                            S .of(context).your_in_new_location,//"You are in a new location!",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            deliverlocation,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        _settingModalBottomSheet(
                                            context, "selectAddress");
                                      },
                                      child: Container(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width *
                                            15 /
                                            100,
                                        margin: EdgeInsets.only(
                                            left: 10.0, right: 5.0, bottom: 10.0),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(5.0),
                                            border: Border(
                                              top: BorderSide(width: 1.0, color: Theme
                                                  .of(context)
                                                  .primaryColor,),
                                              bottom: BorderSide(
                                                width: 1.0, color: Theme
                                                  .of(context)
                                                  .primaryColor,),
                                              left: BorderSide(width: 1.0, color: Theme
                                                  .of(context)
                                                  .primaryColor,),
                                              right: BorderSide(width: 1.0, color: Theme
                                                  .of(context)
                                                  .primaryColor,),
                                            )),
                                        height: 40.0,
                                        child: Center(
                                          child: Text(
                                            S .of(context).select_address,//'Select Address',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color:
                                              Theme
                                                  .of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        /*       Navigator.of(context).pushNamed(
                                            AddressScreen.routeName,
                                            arguments: {
                                              'addresstype': "new",
                                              'addressid': "",
                                              'delieveryLocation': "",
                                              'latitude': "",
                                              'longitude': "",
                                              'branch': ""
                                            });*/
                                        if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                                        // _dialogforaddress(context);
                                        AddressWeb(context,
                                          addresstype: "new",
                                          addressid: "",
                                          delieveryLocation: "",
                                          latitude: "",
                                          longitude: "",
                                          branch: "",);
                                        }
                                        else {
                                          Navigation(context, name: Routename.AddressScreen,
                                              navigatore: NavigatoreTyp.Push,
                                              qparms: {
                                                'addresstype': "new",
                                                'addressid': "",
                                                'delieveryLocation': "",
                                                'latitude': "",
                                                'longitude': "",
                                                'branch': "",
                                              });
                                        }
                                      },
                                      child: Container(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width * 15 / 100,
                                        margin: EdgeInsets.only(
                                            left: 5.0, right: 10.0, bottom: 10.0),
                                        decoration: BoxDecoration(
                                            color: Theme
                                                .of(context)
                                                .primaryColor,
                                            borderRadius:
                                            BorderRadius.circular(5.0),
                                            border: Border(
                                              top: BorderSide(width: 1.0, color:
                                              Theme
                                                  .of(context)
                                                  .primaryColor,
                                              ),
                                              bottom: BorderSide(
                                                width: 1.0,
                                                color:
                                                Theme
                                                    .of(context)
                                                    .primaryColor,
                                              ),
                                              left: BorderSide(
                                                width: 1.0,
                                                color:
                                                Theme
                                                    .of(context)
                                                    .primaryColor,
                                              ),
                                              right: BorderSide(
                                                width: 1.0,
                                                color:
                                                Theme
                                                    .of(context)
                                                    .primaryColor,
                                              ),
                                            )),
                                        height: 40.0,
                                        child: Center(
                                          child: Text(
                                            S .of(context).add_address,//'Add Address',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          SizedBox(height: 20,),
                          ListTile(
                            dense:true,
                            contentPadding: EdgeInsets.only(left: 10.0),
                            leading: Image.asset(Images.request,
                              height: 30,
                              width: 30,
                            ),
                            title: Transform(
                              transform: Matrix4.translationValues(-16, 0.0, 0.0),
                              child: TextField(
                                controller: _message,
                                decoration: InputDecoration.collapsed(
                                    hintText: S .of(context).any_request,//"Any request? We promise to pass it on",
                                    hintStyle: TextStyle(fontSize: 12.0),
                                    //contentPadding: EdgeInsets.all(16),
                                    //border: OutlineInputBorder(),
                                    fillColor: ColorCodes.lightGreyColor),
                                //minLines: 3,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),

                    // Delivery time slot banner with text
                    // _deliveryTimeSlotText(),

                    if(!Features.ismultivendor)
                    if (!_isChangeAddress )
                      !_slotsLoading
                          ? _checkslots ?
                      /*(addressitemsData.items.length > 0)?*/
                      (CartCalculations.totalMember <= 0.00 && CartCalculations.total <= 0.00 && CartCalculations.totalMember <= 0 && CartCalculations.total <= 0)?
                      SizedBox.shrink():
                      VxBuilder(
                          mutations: {SetCartItem},
                          builder: (context, store, index) {
                            return Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  color: ColorCodes.whiteColor,
                                  borderRadius: BorderRadius.circular(5)
                              ),

                              child: Column(
                                children: [
                                  (ExpressDetails.length <= 0) ? SizedBox.shrink() :
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            visiblestand = true;
                                            visibleexpress = false;
                                            dividerSlot = ColorCodes.primaryColor;
                                            dividerExpress = ColorCodes.whiteColor;
                                            ContainerSlot = ColorCodes.varcolor;
                                            ContainerExpress = ColorCodes.whiteColor;
                                            _groupValueAdvance = 1;
                                          });
                                        },
                                        child: Container(
                                          height: 130,
                                          width: MediaQuery.of(context).size.width*0.19,
                                          decoration: BoxDecoration(
                                              color: ContainerSlot,
                                              border: Border(
                                                  top: BorderSide(
                                                      width: 1.0, color: ColorCodes.varcolor),
                                                left: BorderSide(
                                                    width: 1.0, color: ColorCodes.varcolor),
                                                right: BorderSide(
                                                    width: 1.0, color: ColorCodes.varcolor),
                                                bottom: BorderSide(
                                                    width: visiblestand ? 8.0 : 1.0, color: visiblestand ? dividerSlot : ColorCodes.varcolor),
                                              ),
                                          ),

                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            children: [
                                              Image.asset(Images.Standard,
                                                height: 60,
                                                width: 60,
                                                color: ColorCodes.greenColor,
                                              ),
                                              SizedBox(height: 10,),
                                              Text(S
                                                  .of(context)
                                                  .slot_based_delivery,
                                                style: TextStyle(fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: ColorCodes.cartgreenColor),
                                              ),
                                              SizedBox(height: 5,),
                                              Text(" \n ", textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                    color: ColorCodes.greyColor),),

                                            ],
                                          ),
                                        ),
                                      ),
                                      //Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            visibleexpress = true;
                                            visiblestand = false;
                                            dividerSlot = ColorCodes.whiteColor;
                                            dividerExpress = ColorCodes.primaryColor;
                                            ContainerSlot = ColorCodes.whiteColor;
                                            ContainerExpress = ColorCodes.varcolor;
                                            _groupValueAdvance = 2;
                                          });
                                        },
                                        child: Container(
                                          height: 130,
                                          width: MediaQuery.of(context).size.width*0.19,
                                          decoration: BoxDecoration(
                                              color: ContainerExpress,
                                              border: Border(
                                                top: BorderSide(
                                                    width: 1.0, color: ColorCodes.varcolor),
                                                left: BorderSide(
                                                    width: 1.0, color: ColorCodes.varcolor),
                                                right: BorderSide(
                                                    width: 1.0, color: ColorCodes.varcolor),
                                                bottom: BorderSide(
                                                    width: visibleexpress ? 8.0 : 1.0 , color: visibleexpress ? dividerExpress : ColorCodes.varcolor),
                                              )),

                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            children: [
                                              Image.asset(Images.express,
                                                height: 60,
                                                width: 60,
                                                color: ColorCodes.greenColor,
                                              ),
                                              SizedBox(height: 10,),
                                              Text(S
                                                  .of(context)
                                                  .express_delivery,
                                                style: TextStyle(fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: ColorCodes.cartgreenColor),
                                              ),
                                              SizedBox(height: 5,),
                                              Text(S
                                                  .of(context)
                                                  .delivery_in + " " +
                                                  _deliveryDurationExpress,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                    color: ColorCodes.greyColor),),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  //SizedBox(width: 20,),
                                  Visibility(
                                    visible: visiblestand,
                                    child: StandardDelivery(),
                                  ),
                                  (Features.isSplit) ? Visibility(
                                    visible: visibleexpress,
                                    child: ExpressDelivery(),
                                  ) : SizedBox.shrink(),
                                  SizedBox(height: 20,),
                                ],
                              ),
                            );
                          })
                          :  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 5.0,
                          ),
                          if(_checkaddress)
                            Text(
                              S .of(context).currently_no_slot,//"Currently there is no slots available",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            ),
                        ],
                      )
                          :Center(
                        child: CircularProgressIndicator(),
                      ),

                    if(!Features.ismultivendor)
                    /*(addressitemsData.items.length > 0)?*/_checkaddress?
                    (CartCalculations.totalMember <= 0.00 && CartCalculations.total <= 0.00 && CartCalculations.totalMember <= 0 && CartCalculations.total <= 0)?
                    SizedBox.shrink():
                    VxBuilder(
                      mutations: {ProductMutation},
                      builder: (context, boxes, index) {

                        final box = boxes.CartItemList;
                        for(int i=0;i<cartItemList.length;i++) {
                          if (cartItemList.length <= 1 && cartItemList[i].mode == "1") {
                            slots = true;
                          } else if (cartItemList[i].mode == 1) {
                            slots = true;
                          }
                        }
                        for (int i = 0; i < box.length; i++) {
                          if (box[i].mode == "1") {
                            _checkmembership = true;
                          }
                        }
                        print("check membership ....web..."+_checkmembership.toString());
                        isEmpty=CartCalculations.itemCount<=0;
                        if (box.isEmpty) return SizedBox.shrink();
                        if(slots==true) return MouseRegion(
                          child: InkWell(
                            onTap: () {
                              if (_isChangeAddress) {
                                Fluttertoast.showToast(
                                    msg: S .of(context).please_select_delivery_address,//"Please select delivery address!",
                                    fontSize: MediaQuery.of(context).textScaleFactor *13,
                                    backgroundColor: Colors.black87,
                                    textColor: Colors.white);
                              }
                              else if(PrefUtils.prefs!.getString('fixtime')! == "" && ((_groupValueAdvance==2 && something.length > 0 && Features.isSplit) || (_groupValueAdvance==1 && DefaultSlot.length > 0))){
                                debugPrint("Please select Time slot express..." );
                                Fluttertoast.showToast(
                                    msg:  S.of(context).pleasse_select_time_slot,//"Please select Time slot",
                                    fontSize: MediaQuery
                                        .of(context)
                                        .textScaleFactor * 13,
                                    backgroundColor: Colors.black87,
                                    textColor: Colors.white);
                              }else {
                                if (!_checkaddress) {
                                  Fluttertoast.showToast(
                                    msg: S .of(context).please_provide_address,//"Please provide a address",
                                    fontSize: MediaQuery.of(context).textScaleFactor *13,);
                                } else if(store.userData.mobileNumber.toString() == " " || store.userData.mobileNumber.toString() == "null"){
                                  _dialogforMobileNumber();
                                }else if((_groupValueAdvance == 1 ) || _groupValueAdvance == 2) {
                                  PrefUtils.prefs!.setString("isPickup", "no");
                                  finalSlotDelivery= deliveryamount + deliveryDateamount1 + deliveryTimeamount1;
                                  finalExpressDelivery= deliveryExpressamount + deliverySlotamount + deliveryfinalexpressdate + deliveryfinalexpressTime;

                                  for(int i=0;i<cartItemList.length;i++)
                                    if(cartItemList.length == 1 && cartItemList[0].mode == 1){
                                      _deliveryChargeNormal="0";
                                      _deliveryChargeExpress="0";
                                      _deliveryChargePrime="0";
                                    }
                                  if(Features.isOffers && !_checkmembership) {
                                    if (store.userData.mobileNumber !=
                                        "null" && store.userData.mobileNumber
                                        .toString() != "") {
                                      /* Navigator.of(context).pushReplacementNamed(
                                        OfferScreen.routeName,
                                        arguments: {
                                          'minimumOrderAmountNoraml': _minimumOrderAmountNoraml,
                                          'deliveryChargeNormal': _deliveryChargeNormal,
                                          'minimumOrderAmountPrime': _minimumOrderAmountPrime,
                                          'deliveryChargePrime': _deliveryChargePrime,
                                          'minimumOrderAmountExpress': _minimumOrderAmountExpress,
                                          'deliveryChargeExpress': _deliveryChargeExpress,
                                          'deliveryType': (_groupValueAdvance == 1)
                                              ? "Default"
                                              : "OptionTwo",
                                          'note': _message.text,
                                          'addressId': PrefUtils.prefs!.getString(
                                              "addressId").toString(),
                                          'deliveryCharge': (_groupValueAdvance ==
                                              1)
                                              ? finalSlotDelivery.toString()
                                              : finalExpressDelivery.toString(),
                                          // 'finalExpressDelivery':finalExpressDelivery.toString(),
                                          'deliveryDurationExpress': _deliveryDurationExpress,
                                          '_groupValue': _groupValue,
                                        });*/
                                      Navigation(context, name:Routename.OfferScreen,navigatore: NavigatoreTyp.Push,
                                          qparms: {
                                            'minimumOrderAmountNoraml': _minimumOrderAmountNoraml,
                                            'deliveryChargeNormal': _deliveryChargeNormal,
                                            'minimumOrderAmountPrime': _minimumOrderAmountPrime,
                                            'deliveryChargePrime': _deliveryChargePrime,
                                            'minimumOrderAmountExpress': _minimumOrderAmountExpress,
                                            'deliveryChargeExpress': _deliveryChargeExpress,
                                            'deliveryType': (_groupValueAdvance == 1)
                                                ? "Default"
                                                : "OptionTwo",
                                            'note': _message.text,
                                            'addressId': PrefUtils.prefs!.getString(
                                                "addressId").toString(),
                                            'deliveryCharge': (_groupValueAdvance ==
                                                1)
                                                ? finalSlotDelivery.toString()
                                                : finalExpressDelivery.toString(),
                                            // 'finalExpressDelivery':finalExpressDelivery.toString(),
                                            'deliveryDurationExpress': _deliveryDurationExpress,
                                            '_groupValue': _groupValue,
                                          });
                                    }else if(VxState.store.userData.customerEngagementFlag! =="1"){
                                      Navigation(context, name: Routename.OfferScreen,
                                          navigatore: NavigatoreTyp.Push,
                                          qparms: {
                                            'minimumOrderAmountNoraml': _minimumOrderAmountNoraml,
                                            'deliveryChargeNormal': _deliveryChargeNormal,
                                            'minimumOrderAmountPrime': _minimumOrderAmountPrime,
                                            'deliveryChargePrime': _deliveryChargePrime,
                                            'minimumOrderAmountExpress': _minimumOrderAmountExpress,
                                            'deliveryChargeExpress': _deliveryChargeExpress,
                                            'deliveryType': (_groupValueAdvance == 1)
                                                ? "Default"
                                                : "OptionTwo",
                                            'note': _message.text,
                                            'addressId': PrefUtils.prefs!.getString(
                                                "addressId").toString(),
                                            'deliveryCharge': (_groupValueAdvance ==
                                                1)
                                                ? finalSlotDelivery.toString()
                                                : finalExpressDelivery.toString(),
                                            // 'finalExpressDelivery':finalExpressDelivery.toString(),
                                            'deliveryDurationExpress': _deliveryDurationExpress,
                                            '_groupValue': _groupValue,
                                          });
                                    }
                                    else{
                                      _dialogforMobileNumber();
                                    }
                                  }else {
                                    if (store.userData.mobileNumber !=
                                        "null" && store.userData.mobileNumber
                                        .toString() != "") {
                                      /*       Navigator.of(context)
                                       .pushNamed(
                                       PaymentScreen.routeName, arguments: {
                                     'minimumOrderAmountNoraml': _minimumOrderAmountNoraml,
                                     'deliveryChargeNormal': _deliveryChargeNormal,
                                     'minimumOrderAmountPrime': _minimumOrderAmountPrime,
                                     'deliveryChargePrime': _deliveryChargePrime,
                                     'minimumOrderAmountExpress': _minimumOrderAmountExpress,
                                     'deliveryChargeExpress': _deliveryChargeExpress,
                                     'addressId': PrefUtils.prefs!.getString(
                                         "addressId"),
                                     'deliveryType': (_groupValueAdvance == 1)
                                         ? "Default"
                                         : "OptionTwo",
                                     'note': _message.text,
                                     'deliveryCharge': (_groupValueAdvance == 1)
                                         ? finalSlotDelivery.toString()
                                         : finalExpressDelivery.toString(),
                                     'deliveryDurationExpress': _deliveryDurationExpress,
                                   });*/
                                      Navigation(context, name: Routename.PaymentScreen, navigatore: NavigatoreTyp.Push,
                                          qparms: {
                                            'minimumOrderAmountNoraml': _minimumOrderAmountNoraml,
                                            'deliveryChargeNormal': _deliveryChargeNormal,
                                            'minimumOrderAmountPrime': _minimumOrderAmountPrime,
                                            'deliveryChargePrime': _deliveryChargePrime,
                                            'minimumOrderAmountExpress': _minimumOrderAmountExpress,
                                            'deliveryChargeExpress': _deliveryChargeExpress,
                                            'addressId': PrefUtils.prefs!.getString(
                                                "addressId"),
                                            'deliveryType': (_groupValueAdvance == 1)
                                                ? "Default"
                                                : "OptionTwo",
                                            'note': _message.text,
                                            'deliveryCharge': (_groupValueAdvance == 1)
                                                ? finalSlotDelivery.toString()
                                                : finalExpressDelivery.toString(),
                                            'deliveryDurationExpress': _deliveryDurationExpress,
                                            'fromScreen':'',
                                            'responsejson':"",
                                          });
                                    }
                                    else{
                                      _dialogforMobileNumber();
                                    }
                                  }

                                }
                              }
                            },
                            // child: Container(
                            //   width: MediaQuery.of(context).size.width,
                            //   color: _isChangeAddress
                            //       ? ColorCodes.greyColor
                            //       : Theme.of(context).primaryColor,
                            //   height: 50.0,
                            //   padding: EdgeInsets.symmetric(horizontal: 20),
                            //   child:
                            //   /* (addressitemsData.items.length > 0)?*/_checkaddress?
                            //   Container(
                            //     child: Center(
                            //       child: Row(
                            //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //         children: [
                            //           VxState.store.userData.membership! == "1" ||_checkmembership?
                            //           Features.iscurrencyformatalign?
                            //           Text('Total: ' +(CartCalculations.totalMember)
                            //               .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)+IConstants.currencyFormat,   style: TextStyle(
                            //               color: Colors.white,
                            //               fontWeight: FontWeight.bold),):
                            //           Text('Total: '+IConstants.currencyFormat +(CartCalculations.totalMember)
                            //               .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),   style: TextStyle(
                            //               color: Colors.white,
                            //               fontWeight: FontWeight.bold),):
                            //           Features.iscurrencyformatalign?
                            //           Text('Total: ' +(CartCalculations.total)
                            //               .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)+IConstants.currencyFormat,   style: TextStyle(
                            //               color: Colors.white,
                            //               fontWeight: FontWeight.bold),):
                            //           Text('Total: '+IConstants.currencyFormat +(CartCalculations.total)
                            //               .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),   style: TextStyle(
                            //               color: Colors.white,
                            //               fontWeight: FontWeight.bold),),
                            //           Text(
                            //             S .of(context).confirm_order,//'CONFIRM ORDER',
                            //             style: TextStyle(
                            //                 color: Colors.white,
                            //                 fontWeight: FontWeight.bold),
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //   ):  SizedBox.shrink(),
                            // ),
                           child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: _isChangeAddress
                                      ? ColorCodes.greyColor
                                      : Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              margin: EdgeInsets.only(top: 15),
                              child: Column(children: <Widget>[
                                Row(
                                  children: [
                                    SizedBox(width: 20),
                                    Image.asset(
                                      Images.bag, height: 30, width: 30, color: ColorCodes.whiteColor,
                                    ),
                                    SizedBox(width: 5,),
                                    Column(
                                      children: [
                                        Text((CartCalculations.itemCount).toString() + " " + S
                                            .of(context)
                                            .items,
                                            style: TextStyle( color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(height:5),
                                        VxState.store.userData.membership! == "1" ||_checkmembership ?
                                        Features.iscurrencyformatalign?
                                        Text('Total: ' +(CartCalculations.totalMember)
                                            .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) +IConstants.currencyFormat,   style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),):
                                        Text('Total: '+IConstants.currencyFormat +(CartCalculations.totalMember)
                                            .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),   style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),):
                                        Features.iscurrencyformatalign?
                                        Text('Total: ' +(CartCalculations.total)
                                            .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)+IConstants.currencyFormat,   style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),):
                                        Text('Total: '+IConstants.currencyFormat +(CartCalculations.total)
                                            .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),   style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                    Spacer(),
                                    Text(
                                      S .of(context).confirm_order,//'CONFIRM ORDER',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 20),
                                  ],
                                )
                              ]),
                            ),
                          ),
                        );
                        return    !_checkslots
                            ? _checkaddress ?
                        MouseRegion(
                          child: InkWell(
                            onTap: () => {
                              Fluttertoast.showToast(
                                msg:
                                S .of(context).currently_no_slot,//"currently there are no slots available",
                                fontSize: MediaQuery.of(context).textScaleFactor *13,),
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: ColorCodes.grey,
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              margin: EdgeInsets.only(top: 15),
                              child: Column(children: <Widget>[
                                Row(
                                  children: [
                                    SizedBox(width: 20),
                                    Image.asset(
                                      Images.bag, height: 30, width: 30, color: ColorCodes.whiteColor,
                                    ),
                                    SizedBox(width: 5,),
                                    Column(
                                      children: [
                                        Text((CartCalculations.itemCount).toString() + " " + S
                                            .of(context)
                                            .items,
                                            style: TextStyle( color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(height:5),
                                        VxState.store.userData.membership! == "1" ||_checkmembership ?
                                        Features.iscurrencyformatalign?
                                        Text('Total: ' +(CartCalculations.totalMember)
                                            .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) +IConstants.currencyFormat,   style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),):
                                        Text('Total: '+IConstants.currencyFormat +(CartCalculations.totalMember)
                                            .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),   style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),):
                                        Features.iscurrencyformatalign?
                                        Text('Total: ' +(CartCalculations.total)
                                            .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)+IConstants.currencyFormat,   style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),):
                                        Text('Total: '+IConstants.currencyFormat +(CartCalculations.total)
                                            .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),   style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                    Spacer(),
                                    Text(
                                      S .of(context).confirm_order,//'CONFIRM ORDER',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 20),
                                  ],
                                )
                              ]),
                            ),
                          ),
                        ):SizedBox.shrink()
                            :
                        (VxState.store.userData.membership! == "1" ||_checkmembership
                            ?
                        (double.parse((CartCalculations.totalMember).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)) < double.parse(IConstants.minimumOrderAmount) || double.parse((CartCalculations.totalMember).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)) > double.parse(IConstants.maximumOrderAmount))
                            :
                        (double.parse((CartCalculations.total).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)) < double.parse(IConstants.minimumOrderAmount) || double.parse((CartCalculations.total).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)) > double.parse(IConstants.maximumOrderAmount)))
                            ? GestureDetector(
                          onTap: () => {

                            if(VxState.store.userData.membership! == "1" ||_checkmembership) {
                              if(double.parse((CartCalculations.totalMember).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)) < double.parse(IConstants.minimumOrderAmount)) {
                                Features.iscurrencyformatalign?
                                Fluttertoast.showToast(msg: S .of(context).min_order_amount/*"Minimum order amount is "*/  + double.parse(IConstants.minimumOrderAmount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)+ IConstants.currencyFormat, backgroundColor: Colors.black87, textColor: Colors.white,
                                  fontSize: MediaQuery.of(context).textScaleFactor *13,):
                                Fluttertoast.showToast(msg: S .of(context).min_order_amount/*"Minimum order amount is "*/ + IConstants.currencyFormat + double.parse(IConstants.minimumOrderAmount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit), backgroundColor: Colors.black87, textColor: Colors.white,
                                  fontSize: MediaQuery.of(context).textScaleFactor *13,),
                              } else {
                                Features.iscurrencyformatalign?
                                Fluttertoast.showToast(msg: S .of(context).max_order_amount/*"Maximum order amount is "*/  + IConstants.maximumOrderAmount + IConstants.currencyFormat, backgroundColor: Colors.black87, textColor: Colors.white,
                                  fontSize:MediaQuery.of(context).textScaleFactor *13,):
                                Fluttertoast.showToast(msg: S .of(context).max_order_amount/*"Maximum order amount is "*/ + IConstants.currencyFormat + IConstants.maximumOrderAmount, backgroundColor: Colors.black87, textColor: Colors.white,
                                  fontSize:MediaQuery.of(context).textScaleFactor *13,),
                              }
                            } else {
                              if(double.parse((CartCalculations.total).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)) < double.parse(IConstants.minimumOrderAmount)) {
                                Features.iscurrencyformatalign?
                                Fluttertoast.showToast(msg: S .of(context).min_order_amount/*"Minimum order amount is "*/  + double.parse(IConstants.minimumOrderAmount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + IConstants.currencyFormat, backgroundColor: Colors.black87, textColor: Colors.white,
                                  fontSize:MediaQuery.of(context).textScaleFactor *13,):
                                Fluttertoast.showToast(msg: S .of(context).min_order_amount/*"Minimum order amount is "*/ + IConstants.currencyFormat + double.parse(IConstants.minimumOrderAmount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit), backgroundColor: Colors.black87, textColor: Colors.white,
                                  fontSize:MediaQuery.of(context).textScaleFactor *13,),
                              } else {
                                Features.iscurrencyformatalign?
                                Fluttertoast.showToast(msg: S .of(context).max_order_amount/*"Maximum order amount is "*/  + IConstants.maximumOrderAmount+ IConstants.currencyFormat, backgroundColor: Colors.black87, textColor: Colors.white,
                                  fontSize:MediaQuery.of(context).textScaleFactor *13,):
                                Fluttertoast.showToast(msg: S .of(context).max_order_amount/*"Maximum order amount is "*/ + IConstants.currencyFormat + IConstants.maximumOrderAmount, backgroundColor: Colors.black87, textColor: Colors.white,
                                  fontSize:MediaQuery.of(context).textScaleFactor *13,),
                              }
                            },

                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: ColorCodes.primaryColor,
                                borderRadius: BorderRadius.circular(5)
                            ),
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            margin: EdgeInsets.only(top: 15),
                            child: Column(children: <Widget>[
                              Row(
                                children: [
                                  SizedBox(width: 20),
                                  Image.asset(
                                    Images.bag, height: 30, width: 30, color: ColorCodes.whiteColor,
                                  ),
                                  SizedBox(width: 5,),
                                  Column(
                                    children: [
                                      Text((CartCalculations.itemCount).toString() + " " + S
                                          .of(context)
                                          .items,
                                      style: TextStyle( color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                      SizedBox(height:5),
                                      VxState.store.userData.membership! == "1" ||_checkmembership ?
                                      Features.iscurrencyformatalign?
                                      Text('Total: ' +(CartCalculations.totalMember)
                                          .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) +IConstants.currencyFormat,   style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),):
                                      Text('Total: '+IConstants.currencyFormat +(CartCalculations.totalMember)
                                          .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),   style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),):
                                      Features.iscurrencyformatalign?
                                      Text('Total: ' +(CartCalculations.total)
                                          .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)+IConstants.currencyFormat,   style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),):
                                      Text('Total: '+IConstants.currencyFormat +(CartCalculations.total)
                                          .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),   style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                  Spacer(),
                                  Text(
                                    S .of(context).confirm_order,//'CONFIRM ORDER',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 20),
                                ],
                              )
                            ]),
                          ),
                        ) :
                        _checkaddress?
                        MouseRegion(
                          child: InkWell(
                            onTap: () {
                              debugPrint("isSelected..."+PrefUtils.prefs!.getString('fixtime')!+"  "+PrefUtils.prefs!.getString("fixdate")!+"  "+something.length.toString()+"  "+_groupValueAdvance.toString());
                              if (_isChangeAddress) {
                                Fluttertoast.showToast(
                                    msg: S .of(context).please_select_delivery_address,//"Please select delivery address!",
                                    fontSize: MediaQuery.of(context).textScaleFactor *13,
                                    backgroundColor: Colors.black87,
                                    textColor: Colors.white);
                              } else if(PrefUtils.prefs!.getString('fixtime')! == "" && ((_groupValueAdvance==2 && something.length > 0 && Features.isSplit) || (_groupValueAdvance==1 && DefaultSlot.length > 0))){
                                debugPrint("Please select Time slot express..." );
                                Fluttertoast.showToast(
                                    msg: S.of(context).pleasse_select_time_slot,//"Please select Time slot",
                                    fontSize: MediaQuery
                                        .of(context)
                                        .textScaleFactor * 13,
                                    backgroundColor: Colors.black87,
                                    textColor: Colors.white);
                              }
                              else {
                                if (!_checkaddress) {
                                  Fluttertoast.showToast(
                                    msg: S .of(context).please_provide_address,//"Please provide a address",
                                    fontSize: MediaQuery.of(context).textScaleFactor *13,);
                                }else if(store.userData.mobileNumber.toString() == "" || store.userData.mobileNumber.toString() == "null"){
                                  _dialogforMobileNumber();
                                } else if((_groupValueAdvance == 1 ) || _groupValueAdvance == 2) {
                                  PrefUtils.prefs!.setString("isPickup", "no");
                                  finalSlotDelivery= deliveryamount + deliveryDateamount1 + deliveryTimeamount1;
                                  finalExpressDelivery= deliveryExpressamount + deliverySlotamount + deliveryfinalexpressdate + deliveryfinalexpressTime;

                                  final cartItemsData = Provider.of<CartItems>(context,listen: false);
                                  for(int i=0;i<cartItemList.length;i++)
                                    if(cartItemList.length == 1 && cartItemList[0].mode == 1){
                                      _deliveryChargeNormal="0";
                                      _deliveryChargeExpress="0";
                                      _deliveryChargePrime="0";
                                    }

                                  if(Features.isOffers && !_checkmembership) {
                                    if (store.userData.mobileNumber !=
                                        "null" && store.userData.mobileNumber
                                        .toString() != "") {
                                      /*  Navigator.of(context).pushReplacementNamed(
                                         OfferScreen.routeName,
                                         arguments: {
                                           'minimumOrderAmountNoraml': _minimumOrderAmountNoraml,
                                           'deliveryChargeNormal': _deliveryChargeNormal,
                                           'minimumOrderAmountPrime': _minimumOrderAmountPrime,
                                           'deliveryChargePrime': _deliveryChargePrime,
                                           'minimumOrderAmountExpress': _minimumOrderAmountExpress,
                                           'deliveryChargeExpress': _deliveryChargeExpress,
                                           'deliveryType': (_groupValueAdvance ==
                                               1) ? "Default" : "OptionTwo",
                                           'note': _message.text,
                                           'addressId': PrefUtils.prefs!
                                               .getString("addressId")
                                               .toString(),
                                           'deliveryCharge': (_groupValueAdvance ==
                                               1)
                                               ? finalSlotDelivery.toString()
                                               : finalExpressDelivery
                                               .toString(),
                                           // 'finalExpressDelivery':finalExpressDelivery.toString(),
                                           'deliveryDurationExpress': _deliveryDurationExpress,
                                           '_groupValue': _groupValue,
                                         });*/
                                      Navigation(context, name:Routename.OfferScreen,navigatore: NavigatoreTyp.Push,
                                          qparms: {
                                            'minimumOrderAmountNoraml': _minimumOrderAmountNoraml,
                                            'deliveryChargeNormal': _deliveryChargeNormal,
                                            'minimumOrderAmountPrime': _minimumOrderAmountPrime,
                                            'deliveryChargePrime': _deliveryChargePrime,
                                            'minimumOrderAmountExpress': _minimumOrderAmountExpress,
                                            'deliveryChargeExpress': _deliveryChargeExpress,
                                            'deliveryType': (_groupValueAdvance ==
                                                1) ? "Default" : "OptionTwo",
                                            'note': _message.text,
                                            'addressId': PrefUtils.prefs!
                                                .getString("addressId")
                                                .toString(),
                                            'deliveryCharge': (_groupValueAdvance ==
                                                1)
                                                ? finalSlotDelivery.toString()
                                                : finalExpressDelivery
                                                .toString(),
                                            // 'finalExpressDelivery':finalExpressDelivery.toString(),
                                            'deliveryDurationExpress': _deliveryDurationExpress,
                                            '_groupValue': _groupValue,
                                          });
                                    }else if(VxState.store.userData.customerEngagementFlag! =="1"){
                                      Navigation(context, name: Routename.OfferScreen,
                                          navigatore: NavigatoreTyp.Push,
                                          qparms: {
                                            'minimumOrderAmountNoraml': _minimumOrderAmountNoraml,
                                            'deliveryChargeNormal': _deliveryChargeNormal,
                                            'minimumOrderAmountPrime': _minimumOrderAmountPrime,
                                            'deliveryChargePrime': _deliveryChargePrime,
                                            'minimumOrderAmountExpress': _minimumOrderAmountExpress,
                                            'deliveryChargeExpress': _deliveryChargeExpress,
                                            'deliveryType': (_groupValueAdvance ==
                                                1) ? "Default" : "OptionTwo",
                                            'note': _message.text,
                                            'addressId': PrefUtils.prefs!
                                                .getString("addressId")
                                                .toString(),
                                            'deliveryCharge': (_groupValueAdvance ==
                                                1)
                                                ? finalSlotDelivery.toString()
                                                : finalExpressDelivery
                                                .toString(),
                                            // 'finalExpressDelivery':finalExpressDelivery.toString(),
                                            'deliveryDurationExpress': _deliveryDurationExpress,
                                            '_groupValue': _groupValue,
                                          });
                                    }
                                    else{
                                      _dialogforMobileNumber();
                                    }
                                  }else{

                                    if (store.userData.mobileNumber !=
                                        "null" && store.userData.mobileNumber
                                        .toString() != "") {

                                      /*        Navigator.of(context)
                                         .pushNamed(
                                         PaymentScreen.routeName, arguments: {
                                       'minimumOrderAmountNoraml': _minimumOrderAmountNoraml,
                                       'deliveryChargeNormal': _deliveryChargeNormal,
                                       'minimumOrderAmountPrime': _minimumOrderAmountPrime,
                                       'deliveryChargePrime': _deliveryChargePrime,
                                       'minimumOrderAmountExpress': _minimumOrderAmountExpress,
                                       'deliveryChargeExpress': _deliveryChargeExpress,
                                       'addressId': PrefUtils.prefs!.getString(
                                           "addressId"),
                                       'deliveryType': (_groupValueAdvance == 1)
                                           ? "Default"
                                           : "OptionTwo",
                                       'note': _message.text,
                                       'deliveryCharge': (_groupValueAdvance ==
                                           1)
                                           ? finalSlotDelivery.toString()
                                           : finalExpressDelivery.toString(),
                                       'deliveryDurationExpress': _deliveryDurationExpress,
                                     });*/
                                      Navigation(context, name: Routename.PaymentScreen, navigatore: NavigatoreTyp.Push,
                                          qparms: {
                                            'minimumOrderAmountNoraml': _minimumOrderAmountNoraml,
                                            'deliveryChargeNormal': _deliveryChargeNormal,
                                            'minimumOrderAmountPrime': _minimumOrderAmountPrime,
                                            'deliveryChargePrime': _deliveryChargePrime,
                                            'minimumOrderAmountExpress': _minimumOrderAmountExpress,
                                            'deliveryChargeExpress': _deliveryChargeExpress,
                                            'addressId': PrefUtils.prefs!.getString(
                                                "addressId"),
                                            'deliveryType': (_groupValueAdvance == 1)
                                                ? "Default"
                                                : "OptionTwo",
                                            'note': _message.text,
                                            'deliveryCharge': (_groupValueAdvance ==
                                                1)
                                                ? finalSlotDelivery.toString()
                                                : finalExpressDelivery.toString(),
                                            'deliveryDurationExpress': _deliveryDurationExpress,
                                            'fromScreen':'',
                                            'responsejson':"",
                                          });
                                    }
                                    else{
                                      _dialogforMobileNumber();
                                    }
                                  }
                                }
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: _isChangeAddress
                                      ? ColorCodes.greyColor
                                      : ColorCodes.primaryColor,
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              margin: EdgeInsets.only(top: 15),
                              child: Column(children: <Widget>[
                                Row(
                                  children: [
                                    SizedBox(width: 20),
                                    Image.asset(
                                      Images.bag, height: 30, width: 30, color: ColorCodes.whiteColor,
                                    ),
                                    SizedBox(width: 5,),
                                    Column(
                                      children: [
                                        Text((CartCalculations.itemCount).toString() + " " + S
                                            .of(context)
                                            .items,
                                            style: TextStyle( color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(height:5),
                                        VxState.store.userData.membership! == "1" ||_checkmembership ?
                                        Features.iscurrencyformatalign?
                                        Text('Total: ' +(CartCalculations.totalMember)
                                            .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) +IConstants.currencyFormat,   style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),):
                                        Text('Total: '+IConstants.currencyFormat +(CartCalculations.totalMember)
                                            .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),   style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),):
                                        Features.iscurrencyformatalign?
                                        Text('Total: ' +(CartCalculations.total)
                                            .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)+IConstants.currencyFormat,   style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),):
                                        Text('Total: '+IConstants.currencyFormat +(CartCalculations.total)
                                            .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),   style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                    Spacer(),
                                    Text(
                                      S .of(context).confirm_order,//'CONFIRM ORDER',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 20),
                                  ],
                                )
                              ]),
                            ),
                          ),
                        ):SizedBox.shrink();
                      }, /*mutations: {SetCartItem},*/
                    ):
                    SizedBox.shrink(),





                  ],
                ),
              )),
        ],
      );
    }



    updateCart(int qty,double weight,CartStatus cart,String varid,String increment){
      debugPrint("widget.snapshot.parent_id.toString()...."+cartItemList.where((element) => element.mode! == "1").first.parent_id.toString());
      switch(cart){
        case CartStatus.remove:
          cartcontroller.update((done){
            setState(() {
              _isAddToCart = !done;
            });
          },price: cartItemList.where((element) => element.mode! == "1").first.price!.toString(),quantity:"0",
            type: cartItemList.where((element) => element.mode! == "1").first.type!,
            weight:"0",var_id: varid,increament: increment,cart_id: cartItemList.where((element) => element.mode! == "1").first.parent_id!.toString(),toppings: "",
            topping_id: "", item_id: '',);
          // TODO: Handle this case.
          break;

      }
    }
    Widget cartScreen() {
      print("cart empty......");
if(_initialloading)
    return ItemListShimmer();
    return Column(
      children: [
        VxBuilder(mutations: {SetCartItem},builder: (context, store,state){
          final snapshot = store.CartItemList;
          switch(state){

            case VxStatus.none:
              // TODO: Handle this case.
              break;
            case VxStatus.loading:

              // TODO: Handle this case.
              break;
            case VxStatus.success:

              // TODO: Handle this case.
              break;
            case VxStatus.error:

              // TODO: Handle this case.
              break;
          }
          if(snapshot!=null){
            for(int i=0;i<snapshot.length;i++)
              if (snapshot.length<1) {
                if (snapshot[i].mode =="1") {
                  _slots = false;
                }
              } else {
                _slots = true;
              }
            print("cart empty......1");
            if(snapshot.length <= 0){
              if(Vx.isWeb && (!ResponsiveLayout.isLargeScreen(context)||!ResponsiveLayout.isMediumScreen(context)))
                return Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        Images.cartEmptyImg,
                        height: 200.0,
                      ),
                      Text(
                        S .of(context).cart_empty,//"Your cart is empty!",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).popUntil(ModalRoute.withName(
                            HomeScreen.routeName,
                          ));
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            padding: EdgeInsets.all(5),
                            height: 40.0,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(3.0),
                                border: Border(
                                  top: BorderSide(
                                      width: 1.0,
                                      color: Theme.of(context).primaryColor),
                                  bottom: BorderSide(
                                      width: 1.0,
                                      color: Theme.of(context).primaryColor),
                                  left: BorderSide(
                                      width: 1.0,
                                      color: Theme.of(context).primaryColor),
                                  right: BorderSide(
                                    width: 1.0,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                )),
                            child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    new Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15.0, 0.0, 10.0, 0.0),
                                      child: new Icon(
                                        Icons.shopping_cart_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      S .of(context).start_shopping,//'START SHOPPING',
                                      //textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ))),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                     // if (Vx.isWeb && (!ResponsiveLayout.isLargeScreen(context)||!ResponsiveLayout.isMediumScreen(context))) Footer(address: _address),
                    ],
                  ),
                );
              else
                return Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        Images.cartEmptyImg,
                        height: 200.0,
                      ),
                      Text(
                        S .of(context).cart_empty,//"Your cart is empty!",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).popUntil(ModalRoute.withName(
                            HomeScreen.routeName,
                          ));
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            padding: EdgeInsets.all(5),
                            height: 40.0,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(3.0),
                                border: Border(
                                  top: BorderSide(
                                      width: 1.0,
                                      color: Theme.of(context).primaryColor),
                                  bottom: BorderSide(
                                      width: 1.0,
                                      color: Theme.of(context).primaryColor),
                                  left: BorderSide(
                                      width: 1.0,
                                      color: Theme.of(context).primaryColor),
                                  right: BorderSide(
                                    width: 1.0,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                )),
                            child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    new Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15.0, 0.0, 10.0, 0.0),
                                      child: new Icon(
                                        Icons.shopping_cart_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      S .of(context).start_shopping,//'START SHOPPING',
                                      //textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ))),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      VxBuilder(
                        mutations: {HomeScreenController},
                        builder: (ctx, store, VxStatus? state) {

                          if(VxStatus.success==state) {
                            if (Vx.isWeb&&(!ResponsiveLayout.isLargeScreen(context)||!ResponsiveLayout.isMediumScreen(context))) return Footer(address: _address);
                            /*if (Vx.isWeb) return Footer(address: PrefUtils.prefs!
                          .getString("restaurant_address")!);*/
                          }
                          else if(state==VxStatus.none){
                            print("error loading screen");
                            if((VxState.store as GroceStore).homescreen.toJson().isEmpty) {
                              HomeScreenController(user: PrefUtils.prefs!.getString("apikey") ?? PrefUtils.prefs!.getString("ftokenid"), branch: PrefUtils.prefs!.getString("branch") ?? "999", rows: "0",);
                              return SizedBox.shrink();
                            }else{
                              if (Vx.isWeb&&(!ResponsiveLayout.isLargeScreen(context)||!ResponsiveLayout.isMediumScreen(context))) return Footer(address: _address);
                            }
                          }
                          return SizedBox.shrink();
                        },
                      )
                      //if (Vx.isWeb&&(!ResponsiveLayout.isLargeScreen(context)||!ResponsiveLayout.isMediumScreen(context))) Footer(address: _address),
                    ],
                  ),
                );
            }
            else  {
              // for (int i = 0; i < snapshot.length; i++)
                // if (snapshot[i].status == "1" || snapshot[i].quantity == "0") {
                //   Future.delayed(Duration.zero, () async {
                //     _isUnavailable = true;
                //   });
                // }
              print("cart empty......2");
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(_isUnavailable)
                    Container(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 15, bottom: 15),
                      child: Text(
                        S .of(context).product_unavailable,//"Products unavailable",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  // if((double.parse(_minimumOrderAmountNoraml) > CartCalculations.total) && (double.parse(_minimumOrderAmountPrime) > CartCalculations.totalMember))
                    (Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))?SizedBox(height:20):SizedBox.shrink(),
                  if((double.parse(_minimumOrderAmountNoraml) > CartCalculations.total) && (double.parse(_minimumOrderAmountPrime) > CartCalculations.totalMember))
                    (! _slots || (cartItemList.length == 1 && cartItemList.first.mode == "1")) ?SizedBox.shrink():
                    Container(
                      padding: EdgeInsets.only(left: 18,top: 10,right: 8, bottom: 10),
                      color: Colors.white,
                      height: 40,
                      width: (Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.43:MediaQuery.of(context).size.width,
                      child:Row(
                        children: [
                          Container(
                            height:40,
                            width:100,
                            decoration: BoxDecoration(
                              color: ColorCodes.varcolor,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Center(child:Text('FREE DELIVERY',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: ColorCodes.primaryColor),)),
                          ),
                          SizedBox(width:5),
                          (_checkmembership)?
                              Features.iscurrencyformatalign?
                              Text(S .of(context).Shop//'Shop '
                                  +" "+(double.parse(_minimumOrderAmountPrime) - CartCalculations.totalMember).toStringAsFixed((IConstants.numberFormat == "1")
                                  ?0:IConstants.decimaldigit)+" "+IConstants.currencyFormat+" "+S .of(context).more_to_get//' more to get free delivery',
                                ,maxLines:2,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),
                              ):
                          Text(S .of(context).Shop//'Shop '
                              +" "+IConstants.currencyFormat+" "+(double.parse(_minimumOrderAmountPrime) - CartCalculations.totalMember).toStringAsFixed((IConstants.numberFormat == "1")
                              ?0:IConstants.decimaldigit)+" "+S .of(context).more_to_get//' more to get free delivery',
                            ,maxLines:2,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),
                          )
                              :
                              Features.iscurrencyformatalign?
                              Text(S .of(context).Shop+" "+(double.parse(_minimumOrderAmountNoraml) - CartCalculations.total).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)+" "+IConstants.currencyFormat+" "+S .of(context).more_to_get//' more to get free delivery'
                                ,maxLines:2,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),):
                          Text(S .of(context).Shop+" "+IConstants.currencyFormat+" "+(double.parse(_minimumOrderAmountNoraml) - CartCalculations.total).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)+" "+S .of(context).more_to_get//' more to get free delivery'
                            ,maxLines:2,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),)
                        ],
                      ),
                    ),     //:SizedBox.shrink(),
                    if (Features.isPickupfromStore)
                      (Vx.isWeb && checkskip) ? SizedBox.shrink() : (_slots)
                          ?
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          width:(Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.43:MediaQuery.of(context).size.width,
                          padding: (Features.ismultivendor)? EdgeInsets.only(top:0, bottom: 15, right: 15, left: 15) : EdgeInsets.all(15),
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S .of(context).select_delivery_type,//'Select Delivery Type',
                                style: TextStyle(
                                    fontSize: (Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))? 18 : 16,
                                    color: !Features.ismultivendor? ColorCodes.blackColor: ColorCodes.blackColor,
                                    fontWeight: (Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))? FontWeight.w900 : FontWeight.bold),
                              ),
                              if(!Vx.isWeb&&ResponsiveLayout.isSmallScreen(context))
                              Text(
                                S .of(context).tap_to_select_one_delivery_mode,// 'Tap to select one of the delivery modes',
                                style: TextStyle(
                                  //color: Color(0xff949292),
                                    color: ColorCodes.primaryColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                height: 150,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  physics: NeverScrollableScrollPhysics(),
                                  // padding: EdgeInsets.all(5),
                                  children: [
                                    GestureDetector(
                                        onTap:(){
                                          setState(() {
                                            Check=0;
                                            _groupCart = 1;
                                          });
                                        },
                                        child: Container(
                                            height:130,
                                            width:(Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.20:MediaQuery.of(context).size.width/2.25,
                                            margin: EdgeInsets.only(right: 10),
                                            padding: EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color:Check==0?ColorCodes.varcolor:ColorCodes.whiteColor,
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color:ColorCodes.varcolor),
                                            ),
                                            child:Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Image.asset(
                                                            Images.homeImg,
                                                            width: (Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))? 22 : 18.0,
                                                            height: (Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))? 22 : 18.0,
                                                            color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor
                                                        ),
                                                        SizedBox(width: 5,),
                                                        Text(
                                                          S .of(context).home_delivery,// 'HOME DELIVERY',
                                                          style: TextStyle(
                                                            color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: (Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))? 16 : 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Check==0? Container(
                                                      width: 18.0,
                                                      height: 18.0,
                                                      decoration: BoxDecoration(
                                                        color: ColorCodes.whiteColor,
                                                        border: Border.all(
                                                          color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                                                        ),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Container(
                                                        margin: EdgeInsets.all(1.5),
                                                        decoration: BoxDecoration(
                                                          color: ColorCodes.whiteColor,
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: Icon(Icons.check,
                                                            color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                                                            size: 12.0),
                                                      ),
                                                    ):
                                                    Icon(
                                                      Icons.radio_button_off_outlined,
                                                      color: ColorCodes.greenColor,size: 18,),
                                                  ],
                                                ),
                                                SizedBox(height:10),
                                                SizedBox(
                                                  height: 50,
                                                  child: Text( S .of(context).also_address/*+" "+S .of(context).address_of_your_choice*/,
                                                    style: TextStyle(
                                                      color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                                                      fontSize: (Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))? 15 : 13,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height:25),
                                                // Text(
                                                //   S .of(context).delivery_charge_extra,//'DELIVERY CHARGES EXTRA',
                                                //   style: TextStyle(
                                                //     color:ColorCodes.primaryColor,
                                                //     fontWeight: FontWeight.bold,
                                                //     fontSize:12,
                                                //   ),
                                                // ),
                                              ],
                                            )
                                        )),

                                    if(Features.isMembership)
                                      ((snapshot.where((element) => element.mode! == "1").count() >= 1 ) && snapshot.length == 1)?
                                      SizedBox.shrink():
                                      GestureDetector(
                                          onTap:(){
                                            setState(() {
                                              Check=1;
                                              _groupCart = 2;
                                            });
                                          },
                                          child:Container(
                                              height:130,
                                              width:(Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.20:MediaQuery.of(context).size.width/2.25,
                                              margin: EdgeInsets.only(right: 10),
                                              padding: EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: Check==1?ColorCodes.varcolor:ColorCodes.whiteColor,
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(color:ColorCodes.varcolor),
                                              ),
                                              child:Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Image.asset(
                                                              Images.Person,
                                                              width: (Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))? 20 : 18.0,
                                                              height: (Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))? 20: 18.0,
                                                              color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor
                                                          ),
                                                          SizedBox(width: 5,),
                                                          Text(
                                                            S .of(context).self_pickup,//'SELF PICK UP',
                                                            style: TextStyle(
                                                              color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: (Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))? 16 : 12,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(width: 5,),
                                                      Check==1?Container(
                                                        width: 18.0,
                                                        height: 18.0,
                                                        decoration: BoxDecoration(
                                                          color: ColorCodes.whiteColor,
                                                          border: Border.all(
                                                            color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                                                          ),
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: Container(
                                                          margin: EdgeInsets.all(1.5),
                                                          decoration: BoxDecoration(
                                                            color: ColorCodes.whiteColor,
                                                            shape: BoxShape.circle,
                                                          ),
                                                          child: Icon(Icons.check,
                                                              color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                                                              size: 12.0),
                                                        ),
                                                      ): Icon(
                                                          Icons.radio_button_off_outlined,
                                                          color: ColorCodes.greenColor,size: 18),
                                                    ],
                                                  ),
                                                  SizedBox(height:10),
                                                  SizedBox(
                                                    height: 65,
                                                    child: Text( S .of(context).select_self_pickup_point/*+" "+ S .of(context).your_order_doorstep*/,
                                                      style: TextStyle(
                                                        color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                                                        fontSize: (Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))? 15 : 13,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height:8),
                                                  // Text(
                                                  //   S .of(context).free_delivery,//'DELIVERY FREE',
                                                  //   style: TextStyle(
                                                  //     color:ColorCodes.primaryColor,
                                                  //     fontWeight: FontWeight.bold,
                                                  //     fontSize:12,
                                                  //   ),
                                                  // ),
                                                ],
                                              )
                                          ))
                                  ],
                                ),
                              )
                            ],
                          )
                      ):SizedBox.shrink(),
                  Container(
                    width: (Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width * 43 :MediaQuery.of(context).size.width,
                    color:  (Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))? ColorCodes.greyColord : ColorCodes.whiteColor,
                    height: (Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))? 20 : 5,
                  ),
                    if(Features.isMembership)
                      (snapshot.where((element) => element.mode! == "1").count() >= 1 )?
                      Container(
                          height:100,
                          width:(Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width * 43:MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(right: 15,left:15),
                          padding: EdgeInsets.only(left:10,right:0,top:10,bottom:10),
                          decoration: BoxDecoration(
                            color:ColorCodes.varcolor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color:ColorCodes.varcolor),
                          ),
                          child:Row(
                            children: [
                              Container(
                                width:MediaQuery.of(context).size.width/1.6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    RichText(
                                        text: new TextSpan(
                                          children: <TextSpan>[
                                            new TextSpan(
                                              text:S.of(context).membership_applied + " ",// 'HOME DELIVERY',
                                              style: TextStyle(
                                                color: ColorCodes.primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize:18,
                                              ),
                                            ),
                                            /*new TextSpan(
                                              text: *//*"Save"*//*" "+S.of(context).membership_applied,// 'HOME DELIVERY',
                                              style: TextStyle(
                                                color: ColorCodes.blackColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize:12,
                                              ),
                                            ),*/

                                          ],
                                        )),
                                    SizedBox(height:10),
                                    Row(
                                      children: [
                                      (snapshot.where((element) => element.mode! == "1" ).first.price == (snapshot.where((element) => element.mode! == "1" ).first.varMrp) || double.parse((snapshot.where((element) => element.mode! == "1" ).first.price!)) <= 0)?
                                        new RichText(
                                          text: new TextSpan(
                                            style: new TextStyle(

                                            ),
                                            children: <TextSpan>[
                                              // new TextSpan(text: IConstants.APP_NAME + " ", style: TextStyle(color:ColorCodes.primaryColor,
                                              //   fontWeight: FontWeight.bold,
                                              //   fontSize:13,)),
                                              new TextSpan(text: "(" + (snapshot.where((element) => element.mode! == "1" ).first.varName!) +") ", style: TextStyle(color:ColorCodes.primaryColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize:12,)),
                                              new TextSpan(text: Features.iscurrencyformatalign?
                                              IConstants.numberFormat == "1"?' ' + (snapshot.where((element) => element.mode! == "1" ).first.price.toString()) + ' ' + IConstants.currencyFormat:' ' + (snapshot.where((element) => element.mode! == "1" ).first.price.toString()) + ' ' +  IConstants.currencyFormat:
                                              IConstants.numberFormat == "1"?IConstants.currencyFormat + ' ' +(snapshot.where((element) => element.mode! == "1" ).first.price.toString()):IConstants.currencyFormat + ' ' +(snapshot.where((element) => element.mode! == "1" ).first.price.toString()), style: TextStyle(color:ColorCodes.primaryColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize:12,)),
                                            // new TextSpan(text: Features.iscurrencyformatalign?
                                            // IConstants.numberFormat == "1"?' ' + (snapshot.where((element) => element.mode! == "1" ).first.varMrp.toString()) + ' ' + IConstants.currencyFormat:' ' + (snapshot.where((element) => element.mode! == "1" ).first.varMrp.toString()) + ' ' +  IConstants.currencyFormat:
                                            // IConstants.numberFormat == "1"?" "+IConstants.currencyFormat + ' ' +(snapshot.where((element) => element.mode! == "1" ).first.varMrp.toString()):" "+IConstants.currencyFormat + ' ' +(snapshot.where((element) => element.mode! == "1" ).first.varMrp.toString()), style: TextStyle(color:ColorCodes.greylight,
                                            // fontWeight: FontWeight.w500,
                                            //   decoration:TextDecoration.lineThrough,
                                            // fontSize:9,)),

                                            ],
                                          ),
                                        ):
                                        new RichText(
                                          text: new TextSpan(
                                            style: new TextStyle(
                                            ),
                                        children: <TextSpan>[
                                        // new TextSpan(text: IConstants.APP_NAME + " ", style: TextStyle(color:ColorCodes.primaryColor,
                                        //   fontWeight: FontWeight.bold,
                                        //   fontSize:13,)),
                                          new TextSpan(text: "(" + (snapshot.where((element) => element.mode! == "1" ).first.varName!) +") ", style: TextStyle(color:ColorCodes.primaryColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize:12,)),
                                          new TextSpan(text: Features.iscurrencyformatalign?
                                          IConstants.numberFormat == "1"?' ' + (snapshot.where((element) => element.mode! == "1" ).first.price.toString()) + ' ' + IConstants.currencyFormat:' ' + (snapshot.where((element) => element.mode! == "1" ).first.price.toString()) + ' ' +  IConstants.currencyFormat:
                                          IConstants.numberFormat == "1"?" "+IConstants.currencyFormat + ' ' +(snapshot.where((element) => element.mode! == "1" ).first.price.toString()):" "+IConstants.currencyFormat + ' ' +(snapshot.where((element) => element.mode! == "1" ).first.price.toString()), style: TextStyle(color:ColorCodes.primaryColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize:12,)),

                                        new TextSpan(text: Features.iscurrencyformatalign?
                                              IConstants.numberFormat == "1"?' ' + (snapshot.where((element) => element.mode! == "1" ).first.varMrp.toString()) + ' ' + IConstants.currencyFormat:' ' + (snapshot.where((element) => element.mode! == "1" ).first.varMrp.toString()) + ' ' +  IConstants.currencyFormat:
                                              IConstants.numberFormat == "1"?IConstants.currencyFormat + ' ' +(snapshot.where((element) => element.mode! == "1" ).first.varMrp.toString()):IConstants.currencyFormat + ' ' +(snapshot.where((element) => element.mode! == "1" ).first.varMrp.toString()), style: TextStyle(color:ColorCodes.greylight,
                                          fontWeight: FontWeight.w500,
                                          decoration:TextDecoration.lineThrough,
                                          fontSize:9,)),

                                            ],
                                          ),
                                        ),
                                        SizedBox(width:10),
                                        GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            updateCart(int.parse(snapshot.where((element) => element.mode! == "1").first.quantity!),double.parse(snapshot.where((element) => element.mode! == "1").first.weight!), CartStatus.remove, snapshot.where((element) => element.mode! == "1").first.varId!.toString(),snapshot.where((element) => element.mode! == "1").first.increment!.toString());
                                            if(snapshot.where((element) => element.mode! == "1") == "1"){
                                              PrefUtils.prefs!.setString("memberback", "no");
                                            }else{
                                              PrefUtils.prefs!.setString("memberback", "");
                                            }
                                            Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
                                          },
                                          child: Container(
                                            width:50,
                                            height:20,
                                            padding:EdgeInsets.only(left:5,right:5,top:3,bottom:3),
                                            decoration: BoxDecoration(
                                                color:ColorCodes.whiteColor,
                                                borderRadius: BorderRadius.circular(5),
                                                border:Border.all(
                                                  color: ColorCodes.whiteColor,
                                                )
                                            ),
                                            child:  Text(S.of(context).remove, style: TextStyle(
                                              color: ColorCodes.primaryColor,
                                              fontSize:10,
                                              fontWeight:FontWeight.bold
                                            ),),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height:10),
                                    GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        !PrefUtils.prefs!.containsKey("apikey")
                                            ?
                                        Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                                            :
                                           (Vx.isWeb &&
                                          !ResponsiveLayout.isSmallScreen(context)) ?
                                          MembershipInfo(context):
                                        Navigation(context, name: Routename.Membership, navigatore: NavigatoreTyp.Push);
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            S .of(context).change_plan ,
                                            style: TextStyle(
                                              color:ColorCodes.blackColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize:11,
                                            ),
                                          ),
                                          Icon(Icons.arrow_forward_ios_outlined, size: 13, color: ColorCodes.primaryColor,),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Image.asset(Images.cartmembershipImage,
                                width:80,
                                height:90
                              ),
                            ],
                          )
                      )
                  :
                      (double.parse(CartCalculations.totalMembersPrice.toString())).toStringAsFixed(0) != "0" ? Container(
                          height:130,
                          width:(Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width * 43 : MediaQuery.of(context).size.width,
                          margin: (Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))? EdgeInsets.only(left: 0, right: 20) : EdgeInsets.only(right: 15,left:15),
                          padding: EdgeInsets.only(left:10,right:0,top:10,bottom:10),
                          decoration: BoxDecoration(
                            color:ColorCodes.varcolor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color:ColorCodes.varcolor),
                          ),
                          child:Row(
                            children: [
                              Container(
                                width: (Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))? MediaQuery.of(context).size.width * 0.35 :MediaQuery.of(context).size.width/1.5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RichText(
                                        text: new TextSpan(
                                          children: <TextSpan>[
                                            /*new TextSpan(
                                              text:IConstants.APP_NAME + " ",// 'HOME DELIVERY',
                                              style: TextStyle(
                                                color: ColorCodes.primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize:15,
                                              ),
                                            ),*/
                                            new TextSpan(
                                              text: /*"Save"*/S.of(context).save_member,// 'HOME DELIVERY',
                                              style: TextStyle(
                                                color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize:17,
                                              ),
                                            ),
                                            new TextSpan(
                                              text: /*"Save"*/Features.iscurrencyformatalign?
                                              IConstants.numberFormat == "1"?' ' + (double.parse(CartCalculations.totalMembersPrice.toString())).toStringAsFixed(0) + '' + IConstants.currencyFormat:' ' + (double.parse(CartCalculations.totalMembersPrice.toString())).toStringAsFixed(IConstants.decimaldigit)  + '' +  IConstants.currencyFormat:
                                              IConstants.numberFormat == "1"?" "+ IConstants.currencyFormat + '' +(double.parse(CartCalculations.totalMembersPrice.toString())).toStringAsFixed(0):" "+ IConstants.currencyFormat + ''+ (double.parse(CartCalculations.totalMembersPrice.toString())).toStringAsFixed(IConstants.decimaldigit),// 'HOME DELIVERY',
                                              style: TextStyle(
                                                color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize:17,
                                              ),
                                            ),
                                            new TextSpan(
                                              text: " "+S .of(context).extra_order,// 'HOME DELIVERY',
                                              style: TextStyle(
                                                color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize:17,
                                              ),
                                            ),
                                            new TextSpan(
                                              text: S.of(context).on_order,
                                              style: TextStyle(
                                                color: ColorCodes.blackColor,
                                                fontWeight:  FontWeight.w600,
                                                fontSize:15,
                                              ),
                                            )
                                          ],
                                        )),
                                    /* Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      IConstants.APP_NAME + S .of(context).extra_order,// 'HOME DELIVERY',
                                      style: TextStyle(
                                        color: ColorCodes.primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize:18,
                                      ),
                                    ),

                                  ],
                                ),*/
                                    SizedBox(height:10),
                                    Text( S .of(context).savings_better/*+" "+S .of(context).address_of_your_choice*/,
                                      style: TextStyle(
                                        color: ColorCodes.blackColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height:10),


                                    Row(
                                      children: [
                                        new RichText(
                                          text: new TextSpan(
                                            style: new TextStyle(

                                            ),
                                            children: <TextSpan>[
                                              new TextSpan(text: S .of(context).browse_plan + " ", style: TextStyle(color:IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize:13,)),
                                              new TextSpan(text: Features.iscurrencyformatalign?
                                                  IConstants.numberFormat == "1"?' ' + (PrefUtils.prefs!.getString("membershipplansdiscount").toString()) + ' ' + IConstants.currencyFormat:' ' + PrefUtils.prefs!.getString("membershipplansdiscount").toString() + ' ' +  IConstants.currencyFormat:
                                                  IConstants.numberFormat == "1"?IConstants.currencyFormat + ' ' +PrefUtils.prefs!.getString("membershipplansdiscount").toString():IConstants.currencyFormat + ' ' +PrefUtils.prefs!.getString("membershipplansdiscount").toString(), style: TextStyle(color:IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize:12,)),
                                              new TextSpan(text: "/" + "month", style: TextStyle(color:IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize:12,)),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width:5),

                                      ],
                                    ),
                                    // Text(
                                    //   S .of(context).browse_plan + PrefUtils.prefs!.getString("membershipplansdiscount").toString(),//'DELIVERY CHARGES EXTRA',
                                    //   style: TextStyle(
                                    //     color:ColorCodes.primaryColor,
                                    //     fontWeight: FontWeight.bold,
                                    //     fontSize:13,
                                    //   ),
                                    // ),
                                    SizedBox(height:10),
                                    GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        !PrefUtils.prefs!.containsKey("apikey")
                                            ?
                                        Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                                            :
                                         (Vx.isWeb &&
                                        !ResponsiveLayout.isSmallScreen(context)) ?
                                        MembershipInfo(context):

                                        Navigation(context, name: Routename.Membership, navigatore: NavigatoreTyp.Push);
                                      },
                                      child: Container(
                                        width:35,
                                        height:25,
                                        decoration: BoxDecoration(
                                            color:ColorCodes.whiteColor,
                                            borderRadius: BorderRadius.circular(5),
                                            border:Border.all(
                                              color: ColorCodes.whiteColor,
                                            )
                                        ),
                                        child:  Icon(Icons.arrow_forward, size: 18, color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Image.asset(Images.cartmembershipImage,
                                  width:70,
                                  height:90
                              ),
                            ],
                          )
                      ):SizedBox.shrink(),


                  if(Features.isMembership)
                    (Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))? SizedBox(height: 20) : SizedBox(height:10),
                  if(_isunavailablepopup)
                  if(snapshot.length > 0)
                   snapshot.where((element) => double.parse(element.varStock!) == 0 || element.status == "1").count() >= 1 ?
                  Container(
                    height:30,
                    margin:EdgeInsets.only(right:15,left:15,bottom:10),
                    width:(Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.40:MediaQuery.of(context).size.width,
                    padding: (Features.ismultivendor)? EdgeInsets.only(top:0, bottom: 0, right: 15, left: 15) : EdgeInsets.only(right:5,left:5,top:5,bottom: 5),
                    decoration:BoxDecoration(
                      border: Border.all(
                        color: ColorCodes.light_red,
                      ),
                      borderRadius: BorderRadius.circular(5),
                      color: ColorCodes.light_red,
                    ),
                    child: Center(
                      child: Text(S.of(context).remove_outofstock,
                        style: TextStyle(fontSize: 11,color: ColorCodes.redColor,

                        ),),
                    ),
                  ):SizedBox.shrink(),

                  for(int i = 0; i < snapshot.length; i++)if(/*snapshot
                      [i].status == "0" &&*/
                      int.parse(snapshot[i].quantity??"0") > 0) //available products
                    Container(
                      width: (Vx.isWeb &&
                          !ResponsiveLayout.isSmallScreen(context))
                          ? MediaQuery
                          .of(context)
                          .size
                          .width * 0.43
                          : MediaQuery
                          .of(context)
                          .size
                          .width,
                      decoration: new BoxDecoration(
                        color: ColorCodes.appdrawerColor,
                      ),
                      child: SingleChildScrollView(
                        child: Container(
                          // elevation: 1,
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(12),
                          // ),
                          margin: EdgeInsets.only(
                              left: 0, right: 0, bottom: 2),
                          child: CartitemsDisplay(snapshot[i],),
                        ),
                      ),
                    ),
                  SizedBox(height: 10),
                  FutureBuilder<CartFetch>(
                    future: _futureitem, // async work
                    builder: (BuildContext context, AsyncSnapshot<CartFetch> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:

                          return SingelItemOfList();
                          // TODO: Handle this case.
                          break;
                        default:
                        // TODO: Handle this case.
                          if (snapshot.hasError)
                            return SizedBox.shrink();
                          else {
                            _isLoading = false;
                            return snapshot.data!.data!.length>0?
                            Container(
                              width: (Vx.isWeb &&
                                  !ResponsiveLayout.isSmallScreen(context))
                                  ? MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.43
                                  : MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              //padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
                              padding: EdgeInsets.only(top: 15.0,
                                  bottom: 10.0,
                                  left: (Vx.isWeb &&
                                      !ResponsiveLayout.isSmallScreen(context))
                                      ? 20
                                      : 0,
                                  right: (Vx.isWeb &&
                                      !ResponsiveLayout.isSmallScreen(context))
                                      ? 20
                                      : 0),
                              decoration: BoxDecoration(
                                color: /*Color(0xFFFFE8E8).withOpacity(0.7)*/ColorCodes
                                    .whiteColor,
                                borderRadius: BorderRadius.circular(5),
                              ),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Row(
                                    children: <Widget>[
                                      if(!Vx.isWeb&&ResponsiveLayout.isSmallScreen(context))
                                      SizedBox(
                                        width: 15.0,
                                      ),
                                      Text(
                                        snapshot.data!.label!,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: (Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))? ColorCodes.blackColor : Theme
                                                .of(context)
                                                .primaryColor,
                                            fontWeight: (Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))? FontWeight.w900 : FontWeight.bold),
                                      ),
                                      Spacer(),
                                      MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          onTap: () {
                                            /*      Navigator.of(context)
                    .pushNamed(
                    SellingitemScreen.routeName,
                    arguments: {
                      'seeallpress': "forget",
                      'title': snapshot.data!.label,
                    });*/
                                            Navigation(context, name: Routename.SellingItem, navigatore: NavigatoreTyp.Push,
                                                parms: {'seeallpress': "forget",
                                                   'title': snapshot.data!.label.toString()});
                                          },
                                          child: Text(
                                            S.of(context).view_all,// 'View All',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Theme
                                                    .of(context)
                                                    .primaryColor),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 25,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.0),
                                  SizedBox(
                                      height: ResponsiveLayout.isSmallScreen(
                                          context) ?
                                      (Features.isSubscription) ? 260 : 254 :
                                      ResponsiveLayout.isMediumScreen(context)
                                          ?
                                      (Features.isSubscription) ? 260 : 260
                                          : (Features.isSubscription)
                                          ? 292
                                          : 292,

                                      // height: (Vx.isWeb)?380:360,
                                      child: new ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data!.data!.length,
                                        itemBuilder: (_, i) =>
                                            Column(
                                              children: [
                                                Itemsv2(
                                                  "Forget",
                                                  snapshot.data!.data![i],
                                                  userdata,
                                                  //sellingitemData.items[i].brand,
                                                ),
                                              ],
                                            ),
                                      )),
                                ],
                              ),
                            ):SizedBox.shrink();
                          }
                          break;
                      }
                    },
                  ),

                  if(Features.ismultivendor)
                    confirmOrder()
                ],
              );
            }
          }
          else{
            return SizedBox.shrink();
          }
        },),

        //SizedBox(height: 10),
        // (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
        //     ? Container(
        //   width: MediaQuery
        //       .of(context)
        //       .size
        //       .width,
        //   height: 50,
        //   child: Row(
        //     children: <Widget>[
        //       (_checkmembership
        //           ?
        //       (double.parse(
        //           (CartCalculations.totalMember).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)) <
        //           double.parse(IConstants.minimumOrderAmount) || double.parse(
        //           (CartCalculations.totalMember).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)) >
        //           double.parse(IConstants.maximumOrderAmount))
        //           :
        //       (double.parse((CartCalculations.total).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)) <
        //           double.parse(IConstants.minimumOrderAmount) || double.parse(
        //           (CartCalculations.total).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)) > double.parse(IConstants.maximumOrderAmount)))
        //           ? GestureDetector(
        //         onTap: () =>
        //         {
        //           if(_checkmembership) {
        //             if(double.parse(
        //                 (CartCalculations.totalMember).toStringAsFixed(
        //                     IConstants.numberFormat == "1"?0:IConstants.decimaldigit)) < double.parse(IConstants.minimumOrderAmount)) {
        //               Features.iscurrencyformatalign?
        //               Fluttertoast.showToast(msg: S .of(context).min_order_amount/*"Minimum order amount is " */+ double.parse(IConstants.minimumOrderAmount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)+  IConstants.currencyFormat , backgroundColor: Colors.black87, textColor: Colors.white,
        //                 fontSize: MediaQuery.of(context).textScaleFactor *13,):
        //               Fluttertoast.showToast(msg: S .of(context).min_order_amount/*"Minimum order amount is " */+  IConstants.currencyFormat + double.parse(IConstants.minimumOrderAmount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit), backgroundColor: Colors.black87, textColor: Colors.white,
        //                 fontSize: MediaQuery.of(context).textScaleFactor *13,),
        //               /*_customToast("Minimum order amount is " +
        //                             IConstants.currencyFormat +
        //                             minimumOrderAmount.toStringAsFixed(IConstants.decimaldigit)),*/
        //             } else
        //               {
        //                 Features.iscurrencyformatalign?
        //                 Fluttertoast.showToast(msg: S .of(context).max_order_amount/*"Maximum order amount is "*/ + IConstants.maximumOrderAmount +  IConstants.currencyFormat , backgroundColor: Colors.black87, textColor: Colors.white,
        //                   fontSize:MediaQuery.of(context).textScaleFactor *13,):
        //                 Fluttertoast.showToast(msg: S .of(context).max_order_amount/*"Maximum order amount is "*/ +  IConstants.currencyFormat + IConstants.maximumOrderAmount, backgroundColor: Colors.black87, textColor: Colors.white,
        //                   fontSize:MediaQuery.of(context).textScaleFactor *13,),
        //                 /* _customToast("Maximum order amount is " +
        //                               IConstants.currencyFormat +
        //                               IConstants.maximumOrderAmount),*/
        //               }
        //           } else
        //             {
        //               if(double.parse(
        //                   (CartCalculations.total).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)) <
        //                   double.parse(IConstants.minimumOrderAmount)) {
        //                 Features.iscurrencyformatalign?
        //                 Fluttertoast.showToast(msg: S .of(context).min_order_amount/*"Minimum order amount is "*/ + double.parse(IConstants.minimumOrderAmount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) +  IConstants.currencyFormat , backgroundColor: Colors.black87, textColor: Colors.white,
        //                   fontSize:MediaQuery.of(context).textScaleFactor *13,):
        //                 Fluttertoast.showToast(msg: S .of(context).min_order_amount/*"Minimum order amount is "*/ +  IConstants.currencyFormat + double.parse(IConstants.minimumOrderAmount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit), backgroundColor: Colors.black87, textColor: Colors.white,
        //                   fontSize:MediaQuery.of(context).textScaleFactor *13,),
        //                 /*_customToast("Minimum order amount is " +
        //                               IConstants.currencyFormat +
        //                               minimumOrderAmount.toStringAsFixed(IConstants.decimaldigit)),*/
        //               } else
        //                 {
        //                   Features.iscurrencyformatalign?
        //                   Fluttertoast.showToast(msg: S .of(context).max_order_amount/*"Maximum order amount is "*/ + IConstants.maximumOrderAmount +  IConstants.currencyFormat , backgroundColor: Colors.black87, textColor: Colors.white,
        //                     fontSize:MediaQuery.of(context).textScaleFactor *13,):
        //                   Fluttertoast.showToast(msg: S .of(context).max_order_amount/*"Maximum order amount is "*/ +  IConstants.currencyFormat + IConstants.maximumOrderAmount, backgroundColor: Colors.black87, textColor: Colors.white,
        //                     fontSize:MediaQuery.of(context).textScaleFactor *13,),
        //                   /*_customToast("Maximum order amount is " +
        //                                 IConstants.currencyFormat +
        //                                 IConstants.maximumOrderAmount),*/
        //                 }
        //             },
        //         },
        //         child: Container(
        //           color: Theme
        //               .of(context)
        //               .primaryColor,
        //           width: MediaQuery
        //               .of(context)
        //               .size
        //               .width,
        //           height: 50,
        //           child: Column(children: <Widget>[
        //             SizedBox(
        //               height: 17,
        //             ),
        //             Center(
        //               child: Row(
        //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //                 children: [
        //                   _checkmembership ?
        //                       Features.iscurrencyformatalign?
        //                       Text('Total: ' +(CartCalculations.totalMember)
        //                           .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) +IConstants.currencyFormat,   style: TextStyle(
        //                           color: Colors.white,
        //                           fontWeight: FontWeight.bold),):
        //                   Text('Total: '+IConstants.currencyFormat +(CartCalculations.totalMember)
        //                       .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),   style: TextStyle(
        //                       color: Colors.white,
        //                       fontWeight: FontWeight.bold),):
        //                       Features.iscurrencyformatalign?
        //                       Text('Total: ' +(CartCalculations.total)
        //                           .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) +IConstants.currencyFormat,   style: TextStyle(
        //                           color: Colors.white,
        //                           fontWeight: FontWeight.bold),):
        //                   Text('Total: '+IConstants.currencyFormat +(CartCalculations.total)
        //                       .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),   style: TextStyle(
        //                       color: Colors.white,
        //                       fontWeight: FontWeight.bold),),
        //                   Text(
        //                     S .of(context).proceed_to_pay,//'PROCEED TO CHECKOUT',
        //                     style: TextStyle(
        //                         fontSize: 13.0,
        //                         color: Colors.white,
        //                         fontWeight: FontWeight.bold),
        //                   ),
        //                 ],
        //               ),
        //             )
        //           ]),
        //         ),
        //       )
        //           : _isDiscounted
        //           ? GestureDetector(
        //         child: Container(
        //           color: Colors.grey,
        //           width: MediaQuery
        //               .of(context)
        //               .size
        //               .width,
        //           height: 50,
        //           child: Column(children: <Widget>[
        //             SizedBox(
        //               height: 17,
        //             ),
        //             Center(
        //               child: Row(
        //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //                 children: [
        //                   _checkmembership ?
        //                       Features.iscurrencyformatalign?
        //                       Text('Total: '+(CartCalculations.totalMember)
        //                           .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) +IConstants.currencyFormat ,   style: TextStyle(
        //                           color: Colors.white,
        //                           fontWeight: FontWeight.bold),):
        //                   Text('Total: '+IConstants.currencyFormat +(CartCalculations.totalMember)
        //                       .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),   style: TextStyle(
        //                       color: Colors.white,
        //                       fontWeight: FontWeight.bold),):
        //                       Features.iscurrencyformatalign?
        //                       Text('Total: ' +(CartCalculations.total)
        //                           .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) +IConstants.currencyFormat,   style: TextStyle(
        //                           color: Colors.white,
        //                           fontWeight: FontWeight.bold),):
        //                   Text('Total: '+IConstants.currencyFormat +(CartCalculations.total)
        //                       .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),   style: TextStyle(
        //                       color: Colors.white,
        //                       fontWeight: FontWeight.bold),),
        //                   Text(
        //                     S .of(context).proceed_to_pay,//'PROCEED TO CHECKOUT',
        //                     style: TextStyle(
        //                         fontSize: 12.0,
        //                         color: Colors.white,
        //                         fontWeight: FontWeight.bold),
        //                   ),
        //                 ],
        //               ),
        //             )
        //           ]),
        //         ),
        //       )
        //           : GestureDetector(
        //         onTap: () =>
        //         {
        //           setState(() {
        //             if  (!PrefUtils.prefs!.containsKey("apikey")) {
        //               PrefUtils.prefs!.setString(
        //                   "fromcart", "cart_screen");
        //              /* Navigator.of(context)
        //                   .pushReplacementNamed(
        //                   SignupSelectionScreen
        //                       .routeName);*/
        //               Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push);
        //             } else {
        //               if (_groupCart == 2) {
        //                /* Navigator.of(context).pushNamed(
        //                     PickupScreen.routeName);*/
        //                 Navigation(context, name: Routename.PickupScreen, navigatore: NavigatoreTyp.Push);
        //               } else {
        //                 //PrefUtils.prefs!.setString('totalamount', totalAmount);
        //                 /*if (addressitemsData.items.length > 0) {*/
        //               /*  Navigator.of(context).pushNamed(
        //                     ConfirmorderScreen.routeName,
        //                     arguments: {
        //                       "prev": "cart_screen"
        //                     });*/
        //                 Navigation(context, name:Routename.ConfirmOrder,navigatore: NavigatoreTyp.Push,
        //                     parms:{"prev": "cart_screen"});
        //                 /*} else {
        //                       Navigator.of(context).pushNamed(
        //                           AddressScreen.routeName,
        //                           arguments: {
        //                             'addresstype': "new",
        //                             'addressid': "",
        //                             'delieveryLocation': "",
        //                             'latitude': "",
        //                             'longitude': "",
        //                             'branch': ""
        //                           });
        //                     }*/
        //               }
        //             }
        //           })
        //         },
        //         child: Container(
        //           color: Theme
        //               .of(context)
        //               .primaryColor,
        //           width: MediaQuery
        //               .of(context)
        //               .size
        //               .width,
        //           height: 50,
        //           child: Column(children: <Widget>[
        //             SizedBox(
        //               height: 17,
        //             ),
        //             Center(
        //               child: Row(
        //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //                 children: [
        //                   _checkmembership ?
        //                       Features.iscurrencyformatalign?
        //                       Text('Total: ' +(CartCalculations.totalMember)
        //                           .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)+IConstants.currencyFormat,   style: TextStyle(
        //                           color: Colors.white,
        //                           fontWeight: FontWeight.bold),):
        //                   Text('Total: '+IConstants.currencyFormat +(CartCalculations.totalMember)
        //                       .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),   style: TextStyle(
        //                       color: Colors.white,
        //                       fontWeight: FontWeight.bold),):
        //                       Features.iscurrencyformatalign?
        //                       Text('Total: ' +(CartCalculations.total)
        //                           .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) +IConstants.currencyFormat,   style: TextStyle(
        //                           color: Colors.white,
        //                           fontWeight: FontWeight.bold),):
        //                   Text('Total: '+IConstants.currencyFormat +(CartCalculations.total)
        //                       .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),   style: TextStyle(
        //                       color: Colors.white,
        //                       fontWeight: FontWeight.bold),),
        //                   Text(
        //                     S .of(context).proceed_to_pay,//'PROCEED TO CHECKOUT',
        //                     style: TextStyle(
        //                         fontSize: 12.0,
        //                         color: Colors.white,
        //                         fontWeight: FontWeight.bold),
        //                   ),
        //                 ],
        //               ),
        //             )
        //           ]),
        //         ),
        //       ),
        //     ],
        //   ),
        // )
        //     : SizedBox.shrink(),

      ],
    );

    }


    Widget pickUp() {
      double deviceWidth = MediaQuery.of(context).size.width;
      int widgetsInRow = 2;
      MediaQueryData queryData;
      queryData = MediaQuery.of(context);
      if (deviceWidth > 1200) {
        widgetsInRow = 2;
      } else if (deviceWidth > 768) {
        widgetsInRow = 2;
      }
      double aspectRatio =   (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
      (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 120
          : (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 120;
      Widget handler(bool isSelected) {
        return (isSelected == true)  ?
        Container(
          width: 20.0,
          height: 20.0,
          decoration: BoxDecoration(
            color: ColorCodes.whiteColor,
            border: Border.all(
              color: ColorCodes.greenColor,
            ),
            shape: BoxShape.circle,
          ),
          child: Container(
            margin: EdgeInsets.all(1.5),
            decoration: BoxDecoration(
              color: ColorCodes.whiteColor,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check,
                color: ColorCodes.greenColor,
                size: 15.0),
          ),
        )
            :
        Icon(
            Icons.radio_button_off_outlined,
            color: ColorCodes.greenColor);


      }

      SelecttimeSlot(int index) {
        pickupTime = Provider.of<DeliveryslotitemsList>(context, listen: false);

        return  GridView.builder(
          // separatorBuilder: (context, index) => SizedBox(height: 10,),
          physics:new NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widgetsInRow,
            crossAxisSpacing: 10,
            childAspectRatio: aspectRatio,
            mainAxisSpacing: 10,
          ),
          // separatorBuilder: (context, index) => SizedBox(height: 10,),
          itemCount: pickupTime.itemsPickup.length,
          itemBuilder: (_, j) => GestureDetector(
            onTap: () async {
              for(int k=0;k<pickupTime.itemsPickup.length;k++){
                pickupTime.itemsPickup[k].isSelect = false;
                pickupTime.itemsPickup[k].selectedColor = Colors.transparent;
              }
              setState(() {
                time = pickupTime.itemsPickup[j].time;
                final timeData = Provider.of<DeliveryslotitemsList>(context, listen: false);

                //PrefUtils.prefs!.setString("fixdate", pickupTime.itemsPickup[0].date);

                //_index = (i == 0 && j == 0) ? 0 : _index + 1;
                for(int i = 0; i < timeData.itemsPickup.length; i++) {
                  timeData.itemsPickup[i].isSelect = false;
                  pickupTime.itemsPickup[j].isSelect = false;
                  // timeData.times[i].isSelect = false;
                  if(j == i) {
                    setState(() {
                      timeData.itemsPickup[i].selectedColor = ColorCodes.primaryColor;
                      timeData.itemsPickup[i].isSelect = true;
                      pickupTime.itemsPickup[j].isSelect = true;
                      PrefUtils.prefs!.setString('fixtime', timeData.itemsPickup[i].time!);
                      selectTime = timeData.itemsPickup[i].time!;
                    });
                    break;
                  } else{
                    setState(() {
                      timeData.itemsPickup[i].selectedColor = ColorCodes.lightgrey;
                      timeData.itemsPickup[i].isSelect = false;
                      pickupTime.itemsPickup[j].isSelect = false;
                      pickupTime.itemsPickup[j].selectedColor = Colors.transparent;
                    });
                  }
                }

              });

            },
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color:  pickupTime.itemsPickup[j].isSelect ? ColorCodes.varcolor:ColorCodes.whiteColor,
                border: Border.all(
                  color: pickupTime.itemsPickup[j].isSelect ? ColorCodes.primaryColor : ColorCodes.varcolor,
                ),
                borderRadius: BorderRadius.circular(3),
              ),
              // margin: EdgeInsets.only(left: 5.0, right: 5.0),
              //child: Container(
              width: MediaQuery.of(context).size.width*0.18,
              //  padding: EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 20,),
                  Container(
                    child: Text(
                      pickupTime.itemsPickup[j].time,
                      style: TextStyle(color: ColorCodes.greenColor , fontSize:14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Spacer(),
                 // handler(pickupTime.itemsPickup[j].isSelect),
              (pickupTime.itemsPickup[j].isSelect == true)  ?
              Container(
                width: 20.0,
                height: 20.0,
                decoration: BoxDecoration(
                  color: ColorCodes.whiteColor,
                  border: Border.all(
                    color: ColorCodes.greenColor,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Container(
                  margin: EdgeInsets.all(1.5),
                  decoration: BoxDecoration(
                    color: ColorCodes.whiteColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check,
                      color: ColorCodes.greenColor,
                      size: 15.0),
                ),
              )
                  :
              Icon(
                  Icons.radio_button_off_outlined,
                  color: ColorCodes.greenColor),
                  SizedBox(width: 20,),
                ],
              ),
            ),
          ),
        );
      }

      return /*_ispicLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : */SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            !_checkStoreLoc
                ? Center(
              child: Container(
                width:MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 15, bottom: 15),
                padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                decoration: BoxDecoration(
                    color: ColorCodes.whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: ColorCodes.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      )
                    ]
                ),
                child: Text(
                  S .of(context).currently_no_store ,//"Currently there is no store address available",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            )
                :
            Container(
              width:MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 10, bottom: 15),
              padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
              decoration: BoxDecoration(
                  color: ColorCodes.whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: ColorCodes.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    )
                  ]
              ),
              child: Column(
                children: [
                  SizedBox(
                    child: new ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        color: ColorCodes.whiteColor,
                      ),
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: pickuplocItem.itemspickuploc.length,
                      itemBuilder: (_, i) => GestureDetector(
                        onTap: () {
                          if (_groupPick != i)
                            setState(() {
                              _groupPick = i;
                              changeStore(pickuplocItem.itemspickuploc[i].id);
                              _deliveryChargeNormal = pickuplocItem.itemspickuploc[i].deliveryChargeForRegularUser;
                              _deliveryChargePrime = pickuplocItem.itemspickuploc[i].deliveryChargeForMembershipUser;
                            });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _groupPick == i ? ColorCodes.varcolor : ColorCodes.whiteColor,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: ColorCodes.greenColor,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.only(right: 0.0),
                            title:  Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 15.0,
                                ),
                                Container(
                                  height: 35,
                                  width: 35,
                                  child: GestureDetector(
                                      onTap: () {
                                        openMap(
                                            pickuplocItem
                                                .itemspickuploc[i]
                                                .latitude,
                                            pickuplocItem
                                                .itemspickuploc[i]
                                                .longitude);
                                      },
                                      child: Image.asset(Images.pickup_point, height:25, width: 25, color: ColorCodes.mediumBlackColor)),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                    ),
                                    margin: EdgeInsets.only(bottom: 10.0),
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          pickuplocItem
                                              .itemspickuploc[i].name,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight:
                                              FontWeight.w900),
                                        ),
                                        SizedBox(
                                          height: 4.0,
                                        ),
                                        if (pickuplocItem
                                            .itemspickuploc[i].contact
                                            .toString() ==
                                            "")
                                          Text(
                                            pickuplocItem
                                                .itemspickuploc[i]
                                                .address,
                                            style: TextStyle(
                                                color: ColorCodes.greyColor,
                                                fontWeight:
                                                FontWeight.w300,
                                                fontSize: 12.0),
                                          )
                                        else
                                          Text(
                                            pickuplocItem
                                                .itemspickuploc[i]
                                                .address +
                                                "\n" +
                                                "Ph: " +
                                                pickuplocItem
                                                    .itemspickuploc[i]
                                                    .contact,
                                            style: TextStyle(
                                                color: ColorCodes.greyColor,
                                                fontWeight:
                                                FontWeight.w300,
                                                fontSize: 12.0),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                /* SizedBox(
                                                width: 10.0,
                                                height: 20.0,
                                                child:
                                                _myRadioButton(
                                                  value: i,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      _groupValue = newValue;
                                                    });
                                                    changeStore(pickuplocItem.itemspickuploc[i].id);
                                                    _deliveryChargeNormal = pickuplocItem.itemspickuploc[i].deliveryChargeForRegularUser;
                                                    _deliveryChargePrime = pickuplocItem.itemspickuploc[i].deliveryChargeForMembershipUser;

                                                  },
                                                ),
                                              ),*/
                                _groupPick == i ?
                                Container(
                                  width: 20.0,
                                  height: 20.0,
                                  decoration: BoxDecoration(
                                    color: ColorCodes.whiteColor,
                                    border: Border.all(
                                      color: ColorCodes.greenColor,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.all(1.5),
                                    decoration: BoxDecoration(
                                      color: ColorCodes.whiteColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.check,
                                        color: ColorCodes.greenColor,
                                        size: 15.0),
                                  ),
                                )
                                    :
                                Icon(
                                    Icons.radio_button_off_outlined,
                                    color: ColorCodes.greenColor),

                                SizedBox(
                                  width: 15.0,
                                ),
                              ],
                            ),
                          ),
                        ),

                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    width:MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top:10, bottom: 0),
                    //padding: EdgeInsets.only( right: 15, top: 15, bottom: 15),
                  /*  decoration: BoxDecoration(
                        color: ColorCodes.whiteColor,
                        boxShadow: [
                          BoxShadow(
                            color: ColorCodes.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          )
                        ]
                    ),*/
                    child: ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.only(left: 0.0),
                      leading: Image.asset(Images.request,
                        height: 30,
                        width: 30,
                      ),
                      title: Transform(
                        transform: Matrix4.translationValues(-16, 0.0, 0.0),
                        child: TextField(
                          controller: _message,
                          decoration: InputDecoration.collapsed(
                              hintText: S .of(context).any_request ,//"Any request? We promise to pass it on",
                              hintStyle: TextStyle(fontSize: 12.0),
                              //contentPadding: EdgeInsets.all(16),
                              //border: OutlineInputBorder(),
                              fillColor: ColorCodes.lightGreyColor),
                          //minLines: 3,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            _checkStoreLoc && _isPickupSlots
                ? Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 0, bottom: 0),
              padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
              decoration: BoxDecoration(
                  color: ColorCodes.whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: ColorCodes.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    )
                  ]
              ),
              child: Text(
                S .of(context).select_your_timeslot ,//"Select Your Time Slot",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                    FontWeight.w900),
              ),
            )
                : Container(),
            // Padding(
            //   padding: EdgeInsets.all(5),
            // ),
            _isPickupSlots && pickupTime.itemsPickup.length > 0
            //Container()
                ? Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 0, bottom: 10),
              padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
              decoration: BoxDecoration(
                  color: ColorCodes.whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: ColorCodes.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    )
                  ]
              ),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      // Container(
                      //   margin: EdgeInsets.only(left: 10.0),
                      //   child: Text(
                      //     S .of(context).date ,//'Date: ',
                      //     style: TextStyle(
                      //       fontWeight: FontWeight.w300,
                      //       fontSize: 15.0,
                      //       color: ColorCodes.blackColor,
                      //     ),
                      //   ),
                      // ),
                      Column(
                        children: [
                          Container(
                            height: 60,
                            width: 50,

                            decoration: BoxDecoration(
                              color: ColorCodes.varcolor,
                              border: Border.all(
                                color: ColorCodes.varcolor,
                              ),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Center(
                              child: Text(
                                  pickSplit![0].toUpperCase(),
                                  // pickupTime.itemsPickup[0].date,
                                  /*deliveryslotData.items[i].date,*/
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: ColorCodes.darkgreen)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:2.0,left: 2,right:2),
                            child: Center(
                              child: Text(
                                  pickSplit![1].toUpperCase(),
                                  /* value2.toUpperCase(),*//*deliveryslotData.items[i].date,*/
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: ColorCodes.darkgreen)),
                            ),
                          ),
                        ],
                      ),
                      /*Container(
                        height: 70,
                        width: 100,
                        decoration: BoxDecoration(
                          color: ColorCodes.mediumgren,
                          border: Border.all(
                            color: ColorCodes.lightgreen,
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Center(
                          child: Text(
                            pickupTime.itemsPickup[0].date,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: ColorCodes.darkgreen),
                          ),
                        ),
                      ),*/
                      // Spacer(),
                      // SizedBox(
                      //   width: 10.0,
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.only(top: 40),
                      // ),
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     Text('Select your pickup slot', style: TextStyle(
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.w700,
                  //     ),),
                  //   ],
                  // ),

                  SizedBox(height: 10,),
                  SelecttimeSlot(/*pickupTime.itemsPickup[position].id,*/ position)
                ],
              ),
            )
                : _checkStoreLoc
                ? Center(
              child: Container(
                margin: EdgeInsets.only(
                    left: 15.0, top: 30.0, bottom: 10.0, right: 10),
                child: Text(
                  S .of(context).currently_no_time_address ,//"Currently there is no slots available for this address",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            )
                : Container(),
            if(Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))
              (CartCalculations.totalMember <= 0.00 && CartCalculations.total <= 0.00 && CartCalculations.totalMember <= 0 && CartCalculations.total <= 0)?
              SizedBox.shrink():
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: ColorCodes.primaryColor,
                    borderRadius: BorderRadius.circular(5)
                ),
                padding: EdgeInsets.only(top: 10, bottom: 10),
                margin: EdgeInsets.only(top: 15),
                child: Column(children: <Widget>[
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Image.asset(
                        Images.bag, height: 30, width: 30, color: ColorCodes.whiteColor,
                      ),
                      SizedBox(width: 5,),
                      Column(
                        children: [
                          Text((CartCalculations.itemCount).toString() + " " + S
                              .of(context)
                              .items,
                              style: TextStyle( color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height:5),
                          VxState.store.userData.membership! == "1" ||_checkmembership ?
                          Features.iscurrencyformatalign?
                          Text('Total: ' +(CartCalculations.totalMember)
                              .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) +IConstants.currencyFormat,   style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),):
                          Text('Total: '+IConstants.currencyFormat +(CartCalculations.totalMember)
                              .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),   style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),):
                          Features.iscurrencyformatalign?
                          Text('Total: ' +(CartCalculations.total)
                              .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)+IConstants.currencyFormat,   style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),):
                          Text('Total: '+IConstants.currencyFormat +(CartCalculations.total)
                              .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),   style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),),
                        ],
                      ),
                      Spacer(),
                      Text(
                        S .of(context).confirm_order,//'CONFIRM ORDER',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 20),
                    ],
                  )
                ]),
              ),
          ],
        ),
      );
    }

    Widget bodyWeb() {


      VxState.watch(context, on: [SetCartItem]);
      if((VxState.store as GroceStore).CartItemList.length<=0){
        setState(() {
          isEmpty=true;
        });
      }else{
        setState(() {
          isEmpty=false;
        });
      }
      if(_cartitemloaded&&_cartdugestloaded){
        print("inside,,");
        _initialloading = false;
      }
     /* if (!_loadingSlots && !_loadingDelCharge ) {
        setState(() {
          _initialloading=false;
          // _loading = false;
          // _Load=false;
        });
      }*/
      return (isEmpty /*&& store.CartItemList.length<=0 */)?
      Expanded(
        child: SingleChildScrollView(
          child: Container(
            color: (Vx.isWeb) ? ColorCodes.greyColord : ColorCodes.whiteColor,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  Images.cartEmptyImg,
                  height: 200.0,
                ),
                Text(
                  S .of(context).cart_empty,//"Your cart is empty!",
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(
                  height: 20.0,
                ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigation(context,/*name: Routename.Home,*/ navigatore: NavigatoreTyp.homenav);
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        padding: EdgeInsets.all(5),
                        height: 40.0,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(3.0),
                            border: Border(
                              top: BorderSide(
                                  width: 1.0,
                                  color: Theme.of(context).primaryColor),
                              bottom: BorderSide(
                                  width: 1.0,
                                  color: Theme.of(context).primaryColor),
                              left: BorderSide(
                                  width: 1.0,
                                  color: Theme.of(context).primaryColor),
                              right: BorderSide(
                                width: 1.0,
                                color: Theme.of(context).primaryColor,
                              ),
                            )),
                        child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                new Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      15.0, 0.0, 10.0, 0.0),
                                  child: new Icon(
                                    Icons.shopping_cart_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  S .of(context).start_shopping,//'START SHOPPING',
                                  //textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ))),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                VxBuilder(
                  mutations: {HomeScreenController},
                  builder: (ctx, store, VxStatus? state) {

                    if(VxStatus.success==state) {
                      if (Vx.isWeb) return Footer(address: _address);
                      /*if (Vx.isWeb) return Footer(address: PrefUtils.prefs!
                          .getString("restaurant_address")!);*/
                    }
                    else if(state==VxStatus.none){
                      print("error loading screen");
                      if((VxState.store as GroceStore).homescreen.toJson().isEmpty) {
                        HomeScreenController(user: PrefUtils.prefs!.getString("apikey") ?? PrefUtils.prefs!.getString("ftokenid"), branch: PrefUtils.prefs!.getString("branch") ?? "999", rows: "0",);
                        return SizedBox.shrink();
                      }else{
                        if (Vx.isWeb) return Footer(address: _address);
                      }
                    }
                    return SizedBox.shrink();
                  },
                )

              ],
            ),
          ),
        ),
      )
          :Expanded(
        child: SingleChildScrollView(
          child: Container(
            color: (Vx.isWeb) ? ColorCodes.greyColord : ColorCodes.whiteColor,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _isLoading
                    ? Container(
                  height: 100,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
                /*: checkskip
                        ? Center(child: cartScreen())*/
                    : Align(
                  alignment: Alignment.center,
                  child: Container(
                    constraints: (Vx.isWeb &&
                        !ResponsiveLayout.isSmallScreen(
                            context))
                        ? BoxConstraints(maxWidth: maxwid!)
                        : null,
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(!Vx.isWeb)
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(child:
                        cartScreen()),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                            child: _groupCart == 2
                                ? pickUp()
                                : /*_loading
                                ? Container(
                              height: 200,
                              child: Center(
                                child:
                                CircularProgressIndicator(),
                              ),
                            )
                                :*/ confirmOrder()),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ),

                VxBuilder(
                  mutations: {HomeScreenController},
                  builder: (ctx, store, VxStatus? state) {

                    if(VxStatus.success==state) {
                      if (Vx.isWeb) return Footer(address: _address);
                      /*if (Vx.isWeb) return Footer(address: PrefUtils.prefs!
                            .getString("restaurant_address")!);*/
                    }
                    else if(state==VxStatus.none){
                      print("error loading screen");
                      if((VxState.store as GroceStore).homescreen.toJson().isEmpty) {
                        HomeScreenController(user: PrefUtils.prefs!.getString("apikey") ?? PrefUtils.prefs!.getString("ftokenid"), branch: PrefUtils.prefs!.getString("branch") ?? "999", rows: "0",);
                        return SizedBox.shrink();
                      }else{
                        if (Vx.isWeb) return Footer(address: _address);
                      }
                    }
                    return SizedBox.shrink();
                  },
                )
                //if (Vx.isWeb) Footer(address: _address),
                //Builder
              ],
            ),
          ),
        ),
      );
    }

    Widget bodyMobile() {
      VxState.watch(context, on: [SetCartItem]);
      if((VxState.store as GroceStore).CartItemList.length<=0){
        setState(() {
          isEmpty=true;
        });
      }else{
        setState(() {
          isEmpty=false;
        });
      }
if(_cartitemloaded&&_cartdugestloaded){
  _initialloading = false;
}
      return _initialloading?ItemListShimmer():
          Expanded(
        child: (isEmpty)?Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                Images.cartEmptyImg,
                height: 200.0,
              ),
              Text(
                S .of(context).cart_empty,//"Your cart is empty!",
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              GestureDetector(
                onTap: () {
                  Navigation(context, navigatore: NavigatoreTyp.homenav);
                  // Navigator.of(context).popUntil(ModalRoute.withName(
                  //   HomeScreen.routeName,
                  // ));
                },
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    padding: EdgeInsets.all(5),
                    height: 40.0,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(3.0),
                        border: Border(
                          top: BorderSide(
                              width: 1.0,
                              color: Theme.of(context).primaryColor),
                          bottom: BorderSide(
                              width: 1.0,
                              color: Theme.of(context).primaryColor),
                          left: BorderSide(
                              width: 1.0,
                              color: Theme.of(context).primaryColor),
                          right: BorderSide(
                            width: 1.0,
                            color: Theme.of(context).primaryColor,
                          ),
                        )),
                    child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            new Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  15.0, 0.0, 10.0, 0.0),
                              child: new Icon(
                                Icons.shopping_cart_outlined,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              S .of(context).start_shopping,//'START SHOPPING',
                              //textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ))),
              ),
              SizedBox(
                height: 10,
              ),
              VxBuilder(
                mutations: {HomeScreenController},
                builder: (ctx, store, VxStatus? state) {

                  if(VxStatus.success==state) {
                    if (Vx.isWeb) return Footer(address: _address);
                    /*if (Vx.isWeb) return Footer(address: PrefUtils.prefs!
                          .getString("restaurant_address")!);*/
                  }
                  else if(state==VxStatus.none){
                    print("error loading screen");
                    if((VxState.store as GroceStore).homescreen.toJson().isEmpty) {
                      HomeScreenController(user: PrefUtils.prefs!.getString("apikey") ?? PrefUtils.prefs!.getString("ftokenid"), branch: PrefUtils.prefs!.getString("branch") ?? "999", rows: "0",);
                      return SizedBox.shrink();
                    }else{
                      if (Vx.isWeb) return Footer(address: _address);
                    }
                  }
                  return SizedBox.shrink();
                },
              )
             // if (Vx.isWeb) Footer(address: _address),
            ],
          ),
        ):
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              cartScreen(),
              //  if (Vx.isWeb) Footer(address: _address),
              //Builder
            ],
          ),
        ),
      );
    }
 /*   void launchWhatsapp({required number,required message})async{
      String url ="whatsapp://send?phone=$number&text=$message";
      await canLaunch(url)?launch(url):print('can\'t open whatsapp');
    }*/

    void launchWhatsApp() async {
      String phone = /*"+918618320591"*/IConstants.secondaryMobile;
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
    shoplistData = shoplistData;//Provider.of<BrandItemsList>(context, listen: false);
    bottomNavigationbar() {
      return SingleChildScrollView(
        child: Container(
          height: 60,
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Spacer(),
              GestureDetector(
                onTap: () {
                  /*Navigator.of(context).pushReplacementNamed(
                    HomeScreen.routeName,
                  );*/
                  Navigator.of(context).popUntil(ModalRoute.withName(
                    HomeScreen.routeName,
                  ));
                },
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 7.0,
                    ),
                    CircleAvatar(
                      maxRadius: 11.0,
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.transparent,
                      child: Image.asset(
                        Images.homeImg,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                        S .of(context).home,//"Home",
                        style: TextStyle(
                            color: ColorCodes.greyColor, fontSize: 10.0)),
                  ],
                ),
              ),
              Spacer(),
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 7.0,
                  ),
                  CircleAvatar(
                    maxRadius: 11.0,
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    child: Image.asset(Images.categoriesImg,
                        color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                      S .of(context).categories,
                      //"Categories",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              if(Features.isWallet)
                Spacer(),
              if(Features.isWallet)
                GestureDetector(
                  onTap: () {
                    checkskip
                        ? /*Navigator.of(context).pushNamed(
                      SignupSelectionScreen.routeName,
                    )*/
                    Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                        :
                    /* Navigator.of(context).pushReplacementNamed(
                        WalletScreen.routeName,
                        arguments: {"type": "wallet"});*/
                    Navigation(context, name: Routename.Wallet, navigatore: NavigatoreTyp.PushReplacment,qparms: {
                      "type":"wallet",//Routename.Wallet.toString(),
                    });
                  },
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 7.0,
                      ),
                      CircleAvatar(
                        radius: 11.0,
                        backgroundColor: Colors.transparent,
                        child: Image.asset(Images.walletImg),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                          S .of(context).wallet,//"Wallet",
                          style: TextStyle(
                              color: ColorCodes.greyColor, fontSize: 10.0)),
                    ],
                  ),
                ),
              if(Features.isMembership)
                Spacer(),
              if(Features.isMembership)
                GestureDetector(
                  onTap: () {
                    checkskip
                        ? /*Navigator.of(context).pushNamed(
                      SignupSelectionScreen.routeName,
                    )*/
                    Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                        : /*Navigator.of(context).pushReplacementNamed(
                      MembershipScreen.routeName,
                    );*/
                       (Vx.isWeb &&
                      !ResponsiveLayout.isSmallScreen(context)) ?
                      MembershipInfo(context):
                    Navigation(context, name: Routename.Membership, navigatore: NavigatoreTyp.PushReplacment);
                  },
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 7.0,
                      ),
                      CircleAvatar(
                        radius: 11.0,
                        backgroundColor: Colors.transparent,
                        child: Image.asset(
                          Images.bottomnavMembershipImg,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                          S .of(context).membership,//"Membership",
                          style: TextStyle(
                              color: ColorCodes.greyColor, fontSize: 10.0)),
                    ],
                  ),
                ),

              if(!Features.isMembership)
                Spacer(),
              if(!Features.isMembership)
                GestureDetector(
                  onTap: () {
                    checkskip
                        ? /*Navigator.of(context).pushNamed(
                      SignupSelectionScreen.routeName,
                    )*/
                    Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                        : Navigator.of(context).pushReplacementNamed(
                      /*MyorderScreen.routeName,
                        arguments: {
                          "orderhistory": ""
                        }*/
                      Navigation(context, name:Routename.MyOrders,navigatore: NavigatoreTyp.Push,
                         /* parms: {
                        "orderhistory": ""
                      }*/)
                    );
                  },
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 7.0,
                      ),
                      CircleAvatar(
                        radius: 11.0,
                        backgroundColor: Colors.transparent,
                        child: Image.asset(
                          Images.shoppinglistsImg,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(S .of(context).my_orders,//"My Orders",
                          style: TextStyle(
                              color: ColorCodes.grey, fontSize: 10.0)),
                    ],
                  ),
                ),
              if(Features.isShoppingList)
                Spacer(),
              if(Features.isShoppingList)
                GestureDetector(
                  onTap: () {
                    checkskip
                        ? Navigator.of(context).pushNamed(
                      SignupSelectionScreen.routeName,
                    )
                        :
                   /* Navigator.of(context).pushReplacementNamed(
                      ShoppinglistScreen.routeName,
                    );*/
                    Navigation(context, name: Routename.Shoppinglist, navigatore: NavigatoreTyp.Push);
                  },
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 7.0,
                      ),
                      CircleAvatar(
                        radius: 11.0,
                        backgroundColor: Colors.transparent,
                        child: Image.asset(Images.shoppinglistsImg),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                          S .of(context).shopping_list,//"Shopping list",
                          style: TextStyle(
                              color: ColorCodes.greyColor, fontSize: 10.0)),
                    ],
                  ),
                ),
              if(!Features.isShoppingList)
                Spacer(),
              if(!Features.isShoppingList)
                GestureDetector(
                  onTap: () {
                    checkskip && Features.isLiveChat
                        ? Navigator.of(context).pushNamed(
                      SignupSelectionScreen.routeName,
                    )
                        : (Features.isLiveChat && Features.isWhatsapp)?
                    Navigator.of(context)
                        .pushNamed(CustomerSupportScreen.routeName, arguments: {
                      'name': name,
                      'email': email,
                      'photourl': photourl,
                      'phone': phone,
                    }):
                    (!Features.isLiveChat && !Features.isWhatsapp)?
                        Navigation(context, navigatore: NavigatoreTyp.Push,name: Routename.search)
                    // Navigator.of(context).pushNamed(SearchitemScreen.routeName)

                        :
                    Features.isWhatsapp?/*launchWhatsapp(number: IConstants.countryCode + IConstants.secondaryMobile, message:"I want to order Grocery")*/launchWhatsApp():
                    Navigator.of(context)
                        .pushNamed(CustomerSupportScreen.routeName, arguments: {
                      'name': name,
                      'email': email,
                      'photourl': photourl,
                      'phone': phone,
                    });
                  },
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 7.0,
                      ),
                      CircleAvatar(
                        radius: 11.0,
                        backgroundColor: Colors.transparent,
                        child: (!Features.isLiveChat && !Features.isWhatsapp)?
                        Icon(
                          Icons.search,
                          color: ColorCodes.lightgrey,
                        )
                            :
                        Image.asset(
                          Features.isLiveChat?Images.appCustomer: Images.whatsapp,
                          color: Features.isLiveChat?ColorCodes.lightgrey:null,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text((!Features.isLiveChat && !Features.isWhatsapp)?S .of(context).search:S .of(context).chat,
                          style: TextStyle(
                              color: ColorCodes.grey, fontSize: 10.0)),
                    ],
                  ),
                ),
              Spacer(),
            ],
          ),
        ),
      );
    }

    gradientappbarmobile() {
      final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      return AppBar(
        brightness: Brightness.dark,
        toolbarHeight: 60.0,
        elevation:  (IConstants.isEnterprise)?0:1,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: ColorCodes.iconColor),
            onPressed: () {
             // print("back screen confirm ..."+PrefUtils.prefs!.getString("confirmback").toString());
              if(widget.afterlogin == "" && PrefUtils.prefs!.getString("memberback") == "no"){
                debugPrint("after login...1");
                HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
                    PrefUtils.prefs!.getString("tokenid"),
                    branch: (VxState.store as GroceStore).userData.branch ?? "999",
                    rows: "0");
                PrefUtils.prefs!.setString("memberback", "");
                // Navigator.of(context).pop();
                Navigation(context, navigatore: NavigatoreTyp.Pop);
              }
              else if(widget.afterlogin == "" && PrefUtils.prefs!.getString("confirmback").toString() == "yes"){
                HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
                    PrefUtils.prefs!.getString("ftokenid"),
                    branch: (VxState.store as GroceStore).userData.branch ?? "999",
                    rows: "0");
                print("home,,,,1111111");
                //  Navigation(context, navigatore: NavigatoreTyp.Pop);
                IConstants.isEnterprise && Features.ismultivendor?
                Navigation(context, navigatore: NavigatoreTyp.Pop)
                /* Navigation(context,name: Routename.Home, navigatore: NavigatoreTyp.Push)*/:
                Navigation(context,/*name: Routename.Home,*/ navigatore: NavigatoreTyp.homenav);
              }
              else if(widget.afterlogin == "")
              {
                debugPrint("after login...2");

                //  Navigation(context, navigatore: NavigatoreTyp.Pop);
                HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
                    PrefUtils.prefs!.getString("tokenid"),
                    branch: (VxState.store as GroceStore).userData.branch ?? "999",
                    rows: "0");
                /*IConstants.isEnterprise && Features.ismultivendor?
                Navigation(context, navigatore: NavigatoreTyp.Pop)
                *//*Navigation(context,name: Routename.Home, navigatore: NavigatoreTyp.Push)*//*:*/
                Navigation(context,/*name: Routename.Home,*/ navigatore: NavigatoreTyp.homenav);

              }
              else if(widget.afterlogin == "yes" || widget.afterlogin == "No"){
                debugPrint("after login...3");
                HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
                    PrefUtils.prefs!.getString("tokenid"),
                    branch: (VxState.store as GroceStore).userData.branch ?? "999",
                    rows: "0");
                // Navigator.of(context).pop();
                Navigation(context, navigatore: NavigatoreTyp.Pop);
                // Navigator.pushNamedAndRemoveUntil(
                //     context, HomeScreen.routeName, (route) => false);
              }

              else{
                debugPrint("after login...4");
                HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
                    PrefUtils.prefs!.getString("ftokenid"),
                    branch: (VxState.store as GroceStore).userData.branch ?? "999",
                    rows: "0");
                print("home,,,,");
                Navigation(context, navigatore: NavigatoreTyp.Pop);
                IConstants.isEnterprise && Features.ismultivendor?
                Navigation(context, navigatore: NavigatoreTyp.Pop)
                /*Navigation(context,name: Routename.Home, navigatore: NavigatoreTyp.Push)*/:
                Navigation(context,/*name: Routename.Home,*/ navigatore: NavigatoreTyp.homenav);
                /*  Navigator.pushNamedAndRemoveUntil(
                    context, HomeScreen.routeName, (route) => false);*/

                // Navigator.of(context).pop();
              }
            }),
        title: Text(
            (IConstants.isEnterprise && Features.ismultivendor)?IConstants.storename.toString(): S .of(context).my_basket,// 'My Basket',
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
                  ])),
        ),
        actions: [
          if(IConstants.isEnterprise && !Features.ismultivendor)
          if(Features.isShoppingList)
            (checkskip) ? SizedBox.shrink() : MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    if (shoplistData.length <= 0) {
                      _dialogforCreatelist(context);
                    } else {
                      _dialogforShoppinglist(context);
                    }
                  },
                  child: Row(
                    children: [
                      Container(
                          height: 25,
                          child: Image.asset(
                            Images.addToListImg,width: 20,height: 20,color: IConstants.isEnterprise?ColorCodes.blackColor:ColorCodes.blackColor)),
                      SizedBox(
                        width: 10,
                      ),
                      // Text(
                      //   S .of(context).add_to_list,//'ADD TO LIST',
                      //   style: TextStyle(
                      //     color: IConstants.isEnterprise?ColorCodes.blackColor:ColorCodes.blackColor,
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: 13),
                      // ),
                      // SizedBox(
                      //   width: 20,
                      // ),
                    ],
                  ),
                )
            )
        ],
      );
    }

    return WillPopScope(
      onWillPop: () {
        final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
        // this is the block you need

       // /* if(widget.afterlogin == "" && PrefUtils.prefs!.getString("memberback") == "no"){
       //    debugPrint("after login...1");
       //    HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
       //        PrefUtils.prefs!.getString("tokenid"),
       //        branch: (VxState.store as GroceStore).userData.branch ?? "999",
       //        rows: "0");
       //    PrefUtils.prefs!.setString("memberback", "");
       //    // Navigator.of(context).pop();
       //    Navigation(context, navigatore: NavigatoreTyp.Pop);
       //  }
       //  else if(widget.afterlogin == "" && PrefUtils.prefs!.getString("confirmback").toString() == "yes"){
       //    HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
       //        PrefUtils.prefs!.getString("ftokenid"),
       //        branch: (VxState.store as GroceStore).userData.branch ?? "999",
       //        rows: "0");
       //    print("home,,,,1111111");
       //    //  Navigation(context, navigatore: NavigatoreTyp.Pop);
       //    IConstants.isEnterprise && Features.ismultivendor?
       //    Navigation(context, navigatore: NavigatoreTyp.Pop)
       //   *//* Navigation(context,name: Routename.Home, navigatore: NavigatoreTyp.Push)*//*:
       //    Navigation(context,*//*name: Routename.Home,*//* navigatore: NavigatoreTyp.homenav);
       //  }
       //  else if(widget.afterlogin == "")
       //  {
       //    debugPrint("after login...2");
       //
       //    //  Navigation(context, navigatore: NavigatoreTyp.Pop);
       //    HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
       //        PrefUtils.prefs!.getString("tokenid"),
       //        branch: (VxState.store as GroceStore).userData.branch ?? "999",
       //        rows: "0");
       //    IConstants.isEnterprise && Features.ismultivendor?
       //    Navigation(context, navigatore: NavigatoreTyp.Pop)
       //    *//*Navigation(context,name: Routename.Home, navigatore: NavigatoreTyp.Push)*//*:
       //    Navigation(context,*//*name: Routename.Home,*//* navigatore: NavigatoreTyp.homenav);
       //
       //  }
       //  else if(widget.afterlogin == "yes" || widget.afterlogin == "No"){
       //    debugPrint("after login...3");
       //    HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
       //        PrefUtils.prefs!.getString("tokenid"),
       //        branch: (VxState.store as GroceStore).userData.branch ?? "999",
       //        rows: "0");
       //    // Navigator.of(context).pop();
       //    Navigation(context, navigatore: NavigatoreTyp.Pop);
       //    // Navigator.pushNamedAndRemoveUntil(
       //    //     context, HomeScreen.routeName, (route) => false);
       //  }
       //
       //  else{
       //    debugPrint("after login...4");
       //    HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
       //        PrefUtils.prefs!.getString("ftokenid"),
       //        branch: (VxState.store as GroceStore).userData.branch ?? "999",
       //        rows: "0");
       //    print("home,,,,");
       //    Navigation(context, navigatore: NavigatoreTyp.Pop);
       //    IConstants.isEnterprise && Features.ismultivendor?
       //    Navigation(context, navigatore: NavigatoreTyp.Pop)
       //    *//*Navigation(context,name: Routename.Home, navigatore: NavigatoreTyp.Push)*//*:
       //    Navigation(context,*//*name: Routename.Home,*//* navigatore: NavigatoreTyp.homenav);
       //    *//*  Navigator.pushNamedAndRemoveUntil(
       //              context, HomeScreen.routeName, (route) => false);*//*
       //
       //    // Navigator.of(context).pop();
       //  }
       //  *//*if(widget.afterlogin == "" && PrefUtils.prefs!.getString("memberback") == "no"){
       //    HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
       //        PrefUtils.prefs!.getString("tokenid"),
       //        branch: (VxState.store as GroceStore).userData.branch ?? "999",
       //        rows: "0");
       //    PrefUtils.prefs!.setString("memberback", "");
       //   // Navigator.of(context).pop();
       //    Navigation(context, navigatore: NavigatoreTyp.Pop);
       //  }
       //  else if(widget.afterlogin == "" && PrefUtils.prefs!.getString("confirmback").toString() == "yes"){
       //    HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
       //        PrefUtils.prefs!.getString("ftokenid"),
       //        branch: (VxState.store as GroceStore).userData.branch ?? "999",
       //        rows: "0");
       //    print("home,,,,1111111");
       //    //  Navigation(context, navigatore: NavigatoreTyp.Pop);
       //    Navigation(context,*//**//*name: Routename.Home,*//**//* navigatore: NavigatoreTyp.homenav);
       //  }
       //  else if(widget.afterlogin == "")
       //  {
       //   // Navigator.of(context, rootNavigator: true).pop(context);
       //    if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
       //
       //      HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
       //          PrefUtils.prefs!.getString("ftokenid"),
       //          branch: (VxState.store as GroceStore).userData.branch ?? "999",
       //          rows: "0");
       //      Navigation(context, navigatore: NavigatoreTyp.homenav);
       //
       //    }
       //    else{
       //      Navigation(context, navigatore: NavigatoreTyp.Pop);
       //    }
       //    // Navigator.pushNamedAndRemoveUntil(
       //    //     context, HomeScreen.routeName, (route) => false);
       //  }else if(widget.afterlogin == "yes"){
       //    HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
       //        PrefUtils.prefs!.getString("tokenid"),
       //        branch: (VxState.store as GroceStore).userData.branch ?? "999",
       //        rows: "0");
       //  //  Navigator.of(context).pop();
       //    Navigation(context, navigatore: NavigatoreTyp.Pop);
       //  }
       //  else{
       //    HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
       //        PrefUtils.prefs!.getString("tokenid"),
       //        branch: (VxState.store as GroceStore).userData.branch ?? "999",
       //        rows: "0");
       //    // Navigator.pushNamedAndRemoveUntil(
       //    //     context, HomeScreen.routeName, (route) => false);
       // //   Navigator.of(context).pop();
       //    Navigation(context, navigatore: NavigatoreTyp.Pop);
       //  }*//*
       //  *//*Navigator.pushNamedAndRemoveUntil(
       //      context, HomeScreen.routeName, (route) => false);*/
        if(widget.afterlogin == "" && PrefUtils.prefs!.getString("memberback") == "no"){
          debugPrint("after login...1");
          HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
              PrefUtils.prefs!.getString("tokenid"),
              branch: (VxState.store as GroceStore).userData.branch ?? "999",
              rows: "0");
          PrefUtils.prefs!.setString("memberback", "");
          // Navigator.of(context).pop();
          Navigation(context, navigatore: NavigatoreTyp.Pop);
        }
        else if(widget.afterlogin == "" && PrefUtils.prefs!.getString("confirmback").toString() == "yes"){
          HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
              PrefUtils.prefs!.getString("ftokenid"),
              branch: (VxState.store as GroceStore).userData.branch ?? "999",
              rows: "0");
          print("home,,,,1111111");
          //  Navigation(context, navigatore: NavigatoreTyp.Pop);
          IConstants.isEnterprise && Features.ismultivendor?
          Navigation(context, navigatore: NavigatoreTyp.Pop)
          /* Navigation(context,name: Routename.Home, navigatore: NavigatoreTyp.Push)*/:
          Navigation(context,/*name: Routename.Home,*/ navigatore: NavigatoreTyp.homenav);
        }
        else if(widget.afterlogin == "")
        {
          debugPrint("after login...2");

          //  Navigation(context, navigatore: NavigatoreTyp.Pop);
          HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
              PrefUtils.prefs!.getString("tokenid"),
              branch: (VxState.store as GroceStore).userData.branch ?? "999",
              rows: "0");
          /*IConstants.isEnterprise && Features.ismultivendor?
                Navigation(context, navigatore: NavigatoreTyp.Pop)
                *//*Navigation(context,name: Routename.Home, navigatore: NavigatoreTyp.Push)*//*:*/
          Navigation(context,/*name: Routename.Home,*/ navigatore: NavigatoreTyp.homenav);

        }
        else if(widget.afterlogin == "yes" || widget.afterlogin == "No"){
          debugPrint("after login...3");
          HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
              PrefUtils.prefs!.getString("tokenid"),
              branch: (VxState.store as GroceStore).userData.branch ?? "999",
              rows: "0");
          // Navigator.of(context).pop();
          Navigation(context, navigatore: NavigatoreTyp.Pop);
          // Navigator.pushNamedAndRemoveUntil(
          //     context, HomeScreen.routeName, (route) => false);
        }

        else{
          debugPrint("after login...4");
          HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
              PrefUtils.prefs!.getString("ftokenid"),
              branch: (VxState.store as GroceStore).userData.branch ?? "999",
              rows: "0");
          print("home,,,,");
          Navigation(context, navigatore: NavigatoreTyp.Pop);
          IConstants.isEnterprise && Features.ismultivendor?
          Navigation(context, navigatore: NavigatoreTyp.Pop)
          /*Navigation(context,name: Routename.Home, navigatore: NavigatoreTyp.Push)*/:
          Navigation(context,/*name: Routename.Home,*/ navigatore: NavigatoreTyp.homenav);
          /*  Navigator.pushNamedAndRemoveUntil(
                    context, HomeScreen.routeName, (route) => false);*/

          // Navigator.of(context).pop();
        }
        return Future.value(false);
      },
      child: Scaffold(
        appBar: ResponsiveLayout.isSmallScreen(context)
            ? gradientappbarmobile()
            : null,
        backgroundColor: (Features.ismultivendor)? ColorCodes.whiteColor : ColorCodes.whiteColor,
        body: Column(
          children: [
            if (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)) Header(false),

            (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
                ? bodyWeb()
                : bodyMobile(),
          ],
        ),
        bottomNavigationBar: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
            ? SizedBox.shrink()
            : _initialloading?SizedBox.shrink():VxBuilder(
          builder: (context, box, index) {

            WidgetsBinding.instance!.addPostFrameCallback((_){
                isEmpty=CartCalculations.itemCount<=0;

              // setState((){
              //   isEmpty=CartCalculations.itemCount<=0;
              //   cartItemList = box.CartItemList;
              //   if(cartItemList.length>0){
              //     _isDiscounted = false;
              //   }else{
              //     _isDiscounted = true;
              //   }
              // });
            });
                return Container(
              color: Colors.white,
              child: Padding(
                  padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
                  child: (CartCalculations.totalMember <= 0.00 && CartCalculations.total <= 0.00 && CartCalculations.totalMember <= 0 && CartCalculations.total <= 0)?
                  SizedBox.shrink()
                      :
                  _buildBottomNavigationBar(box.CartItemList)
              ),
            );
          }, mutations: {SetCartItem},
        ),
      ),
    );
  }
  }
