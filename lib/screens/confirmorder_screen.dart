import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import '../../screens/address_screen.dart';
import '../../rought_genrator.dart';
import '../controller/mutations/address_mutation.dart';
import '../controller/mutations/cart_mutation.dart';
import '../controller/mutations/login.dart';
import '../models/VxModels/VxStore.dart';
import '../models/newmodle/cartModle.dart';
import '../models/newmodle/user.dart';
import '../screens/home_screen.dart';
import 'package:velocity_x/velocity_x.dart';
import '../constants/api.dart';
import '../constants/features.dart';
import '../data/calculations.dart';
import '../generated/l10n.dart';
import '../providers/sellingitems.dart';
import '../widgets/addresswidget/address_info.dart';
import '../widgets/bottom_navigation.dart';
import '../utils/ResponsiveLayout.dart';
import '../providers/cartItems.dart';
import '../utils/prefUtils.dart';
import '../widgets/simmers/checkout_screen.dart';
import '../constants/IConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import '../main.dart';
import '../providers/branditems.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../assets/ColorCodes.dart';
import '../data/hiveDB.dart';
import '../screens/map_screen.dart';
import '../providers/deliveryslotitems.dart';
import '../assets/images.dart';
import 'package:http/http.dart' as http;

class ConfirmorderScreen extends StatefulWidget {
  static const routeName = '/confirmorder-screen';

  Map<String,String> prev;
  ConfirmorderScreen(this.prev);
  @override
  _ConfirmorderScreenState createState() => _ConfirmorderScreenState();
}

class _ConfirmorderScreenState extends State<ConfirmorderScreen>
    with SingleTickerProviderStateMixin, Navigations {
  var addressitemsData;
  var deliveryslotData;
  var delChargeData;
  var timeslotsData;
  var boxwidth = 1.0;
  SharedPreferences? prefs;
  int position = 0;
  var totlamount;
  var mobilenum;
  var width = 1.0;
  var addtype;
  String address = "";
  String name = "";
  IconData? addressicon;
  var day, date, time = "10 AM - 1 PM";
  var _checkaddress = false;
  var _loading = true;
  bool _loadingSlots = true;
  bool _loadingDelCharge = true;
  var timeslotsindex = "0";
  var _checkslots = false;
  bool _slotsLoading = false;
  bool _checkmembership = false;
  var _message = TextEditingController();
  int _radioValue = 1;
  bool _isLoading = true;
  bool isSelected = true;
  bool _isChangeAddress = false;

  String _minimumOrderAmountNoraml = "0.0";
  String _deliveryChargeNormal = "0";
  String _minimumOrderAmountPrime = "0.0";
  String _deliveryChargePrime = "0";
  String _minimumOrderAmountExpress = "0.0";
  String _deliveryChargeExpress = "0";
  String _deliveryDurationExpress = "0.0 ";
  String deliverlocation = "";
  String? deliverychargetext;
  String? value;
 // Box<Product> productBox;
  List checkBoxdata = [];
  List titlecolor = [];
  List iconcolor = [];
  int _index = 0;
  int? _count;
  String confirmSwap ="";
  bool iphonex = false;
  bool _isWeb = false;
  TabController? _tabController;
  var value1;
  var value2;
  var value3;

  List<String>? dateSplit;

  bool timeComp=false;
  int maxTime=0;
  int maxDate=0;
  int? finalMax=0,MaxTimeFinal,difference=0;
  var checkmembership = false;
  String durType= "";
  String? mode;
 /* List<Product> something=[];//slot based delivery option 2
  List<Product> ExpressDetails=[];//Express delivery option 2
  Map<String, List<Product>> newMap2;
  Map<String, List<Product>> newMap3;
  int standard;

  List<Product> DefaultSlot=[];//slot based delivery option 1
  Map<String, List<Product>> newMap;//DateBased delivery option 1
  Map<String, List<Product>> newMap1;//TimeBased delivery option 1*/
  List<CartItem> something=[];//slot based delivery option 2
  List<CartItem> ExpressDetails=[];//Express delivery option 2
  Map<String, List<CartItem>>? newMap2;
  Map<String, List<CartItem>>? newMap3;


  List<CartItem> DefaultSlot=[];//slot based delivery option 1
  Map<String, List<CartItem>>? newMap;//DateBased delivery option 1
  Map<String, List<CartItem>>? newMap1;//TimeBased delivery option 1
  
  bool visible= false;
  bool visiblestand= true;
  bool visibleexpress= false;
  var dividerSlot = ColorCodes.primaryColor;
  var dividerExpress = ColorCodes.whiteColor;

  var ContainerSlot = ColorCodes.varcolor;
  var ContainerExpress = ColorCodes.whiteColor;

  var selectedTimeSlot = ColorCodes.whiteColor;

  String? datecom;
  String? timecom;
  String? Date;
  int _groupValue = 1;
  int _groupValueTime = 1;
  double? deliveryChargeCalculation;
  double deliveryamount = 0.0;
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

  UserData? addressdata;
  List<CartItem> productBox=[];
  List parts = [];

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);

    Future.delayed(Duration.zero, () async {
      prefs = await SharedPreferences.getInstance();
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
        deliverlocation = prefs!.getString("deliverylocation")! ;
        prefs!.setString('fixtime', "");
        prefs!.setString("fixdate", "");
        if ((VxState.store as GroceStore).userData.membership=="1") {
          _checkmembership = true;
        } else {
          _checkmembership = false;
        }
        _isLoading = false;
      });
      final cartItemList =(VxState.store as GroceStore).CartItemList;
      for (int i = 0; i < cartItemList.length; i++) {
        if (cartItemList[i].mode == "1") {
          _checkmembership = true;
        }
      }
     /* await Provider.of<CartItems>(context, listen: false).fetchCartItems().then((_) {
        final cartItemsData = Provider.of<CartItems>(context,listen: false);
        _bloc.setCartItem(cartItemsData);

      });*/

      addressdata =(VxState.store as GroceStore).userData;
      if(addressdata!.billingAddress!.length>0){
        addtype = addressdata!.billingAddress![0].addressType;
        address = addressdata!.billingAddress![0].address!;
        name = addressdata!.billingAddress![0].fullName!;
        addressicon = addressdata!.billingAddress![0].addressicon;
        prefs!.setString(
            "addressId",
            addressdata!.billingAddress![0].id.toString());
       // calldeliverslots(addressdata.billingAddress[0].id.toString());
        deliveryCharge(addressdata!.billingAddress![0].id.toString());
        _checkaddress = true;
        checkLocation("init");
      }else{
      /*  Navigator.of(context).pushReplacementNamed(
            AddressScreen.routeName,
            arguments: {
              'addresstype': "new",
              'addressid': "",
              'delieveryLocation': "",//prefs.getString("restaurant_location"),
              'latitude': "",//prefs.getString("restaurant_lat"),
              'longitude': "",//prefs.getString("restaurant_long"),
              'branch': "",//prefs.getString("branch"),
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
      }
/*      Provider.of<AddressItemsList>(context, listen: false,).fetchAddress().then((_) {
        setState(() {
          addressitemsData = Provider.of<AddressItemsList>(context, listen: false);
          if (addressitemsData.items.length > 0) {
            _checkaddress = true;
            checkLocation();
          } else {
            Navigator.of(context).pushReplacementNamed(
                AddressScreen.routeName,
                arguments: {
                  'addresstype': "new",
                  'addressid': "",
                  'delieveryLocation': "",//prefs.getString("restaurant_location"),
                  'latitude': "",//prefs.getString("restaurant_lat"),
                  'longitude': "",//prefs.getString("restaurant_long"),
                  'branch': "",//prefs.getString("branch"),
                });
          }
        });
      });*/
      /*Provider.of<AddressItemsList>(context,listen: false).fetchAddress().then((_) {
        addressitemsData =
            Provider.of<AddressItemsList>(context, listen: false);
        if (addressitemsData.items.length > 0) {
          _checkaddress = true;
          addtype = addressitemsData
              .items[addressitemsData.items.length - 1].useraddtype;
          address = addressitemsData
              .items[addressitemsData.items.length - 1].useraddress;
          addressicon = addressitemsData
              .items[addressitemsData.items.length - 1].addressicon;
          prefs.setString("addressId",
              addressitemsData.items[addressitemsData.items.length - 1].userid);
          calldeliverslots(
              addressitemsData.items[addressitemsData.items.length - 1].userid);
          deliveryCharge(
              addressitemsData.items[addressitemsData.items.length - 1].userid);
        } else {
          _checkaddress = false;
        }
      });*/

      /* Provider.of<AddressItemsList>(context,listen: false).fetchAddress().then((_) {
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
      });
*/
      //checkLocation();
      //Provider.of<BrandItemsList>(context,listen: false).fetchWalletBalance();
      //Provider.of<BrandItemsList>(context,listen: false).fetchPaymentMode();
    });
    super.initState();
  }

  Future<void> checkLocation(String fromscreen) async {
    //addressitemsData = Provider.of<AddressItemsList>(context, listen: false);
    addressdata = (VxState.store as GroceStore).userData;
    try {
      final response = await http.post(Api.checkLocationmultivendor,
          body: {
        "lat": /*addressitemsData.items[0].userlat*/(VxState.store as GroceStore).userData.billingAddress![0].lattitude,
        "long": (VxState.store as GroceStore).userData.billingAddress![0].logingitude,
        "branch": PrefUtils.prefs!.getString("branch"),
        "ref": IConstants.refIdForMultiVendor.toString(),
        "branchtype": IConstants.branchtype.toString(),
      });

    //  SharedPreferences prefs = await SharedPreferences.getInstance();

      final responseJson = json.decode(response.body);

      if (responseJson['status'].toString() == "yes") {

        debugPrint("responseJson['branch'].toString()......"+responseJson.toString()+ "\n" +responseJson['branch'].toString());
        if(fromscreen == "nonavailability"){
          _dialogforAvailability(
            PrefUtils.prefs!.getString("addressId")!,
            addressdata!.billingAddress![0].id.toString(),
            addressdata!.billingAddress![0].addressType!,
            addressdata!.billingAddress![0].address!,
            addressdata!.billingAddress![0].addressicon!,
              responseJson['branch'].toString()
          );
        }else {
          if (PrefUtils.prefs!.getString("branch") == responseJson['branch'].toString()) {
            final routeArgs =
            ModalRoute
                .of(context)!
                .settings
                .arguments as Map<String, String>;
            PrefUtils.prefs!.setString(
                "currentbranch", responseJson['branch'].toString());
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
                PrefUtils.prefs!.getString("addressId")!,
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
                address = addressdata!.billingAddress![0].address!;
                name = addressdata!.billingAddress![0].fullName!;
                addressicon = addressdata!.billingAddress![0].addressicon;
                PrefUtils.prefs!.setString(
                    "addressId",
                    addressdata!.billingAddress![0].id.toString());
                calldeliverslots(addressdata!.billingAddress![0].id.toString());
                deliveryCharge(addressdata!.billingAddress![0].id.toString());
              } else {
                _checkaddress = false;
              }
            }
          }
          else {
            setState(() {
              _isChangeAddress = true;
              _loading = false;
              _slotsLoading = false;
            });
          }
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
            deliveryslotData.items[i].selectedColor = ColorCodes.varcolor;
            deliveryslotData.items[i].isSelect = true;

          } else {
            deliveryslotData.items[i].selectedColor = ColorCodes.whiteColor;
            deliveryslotData.items[i].isSelect = false;
          }
        });

        final tagName = deliveryslotData.items[i].date.toString();
        dateSplit = tagName.split(',');
      }
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
              prefs!.setString("fixdate", deliveryslotData.items[0].dateformat);
              if (timeslotsData[j].status == "1") {
              timeslotsData[j].selectedColor = Colors.grey;
              timeslotsData[j].isSelect = false;
              timeslotsData[j].textColor = Colors.grey;
              isSelected = true;

            } else {

                timeslotsData[j].selectedColor = ColorCodes.whiteColor;
                timeslotsData[j].textColor = ColorCodes.blackColor;
                timeslotsData[j].isSelect = false;

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
          _minimumOrderAmountNoraml = delChargeData.itemsDelCharges[0].minimumOrderAmountNoraml;
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


  // Widget _myRadioButton({int value, Function onChanged}) {
  //   //prefs.setString('fixtime', timeslotsData[_groupValue].time);
  //
  //   return Radio(
  //     activeColor: Theme.of(context).primaryColor,
  //     value: value,
  //     groupValue: _groupValue,
  //     onChanged: onChanged,
  //   );
  // }

  void setDefaultAddress(String addressid) async {
    bool _addresscheck = false;
    AddressController addressController = AddressController();
    await addressController.setdefult(addressId: addressid,branch:PrefUtils.prefs!.getString('branch'));
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
  Future<void> cartCheck(String prevAddressid, String addressid,
      String addressType, String adressSelected, IconData adressIcon, username,) async {
    // imp feature in adding async is the it automatically wrap into Future.
    setDefaultAddress(addressid);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String itemId = "";
    for (int i = 0; i < productBox.length; i++) {
      if (itemId == "") {
        itemId = productBox[i].itemId.toString();
      } else {
        itemId =
            itemId + "," + productBox[i].itemId.toString();
      }
    }

    var url = Api.cartCheck + addressid + "/" + itemId;
    try {
      final response = await http.get(
        url,
      );

      final responseJson = json.decode(response.body);
            debugPrint("rehsjx..."+responseJson.toString());
      //if status = 0 for reset cart and status = 1 for default
      if (responseJson["status"].toString() == "1") {
        setState(() {
          setDefaultAddress(addressid);
          _isChangeAddress = false;
          _checkaddress = true;
          _slotsLoading = true;
          prefs.setString("addressId", addressid);
          addtype = addressType;
          address = adressSelected;
          name = username;
          addressicon = adressIcon;
          calldeliverslots(addressid);
          deliveryCharge(addressid);
        });
        Navigator.of(context).pop();
      } else {
        checkLocation("nonavailability");


        /*Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routeName,
            ModalRoute.withName(HomeScreen.routeName));*/
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
  _dialogforDeleting() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AbsorbPointer(
              child: WillPopScope(
                onWillPop: (){
                  if(widget.prev["prev"].toString() == "cart_screen") {
                    PrefUtils.prefs!.setString("confirmback", "yes");
                    Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":""});
                  }
                  else{
                    // Navigation(context, navigatore: NavigatoreTyp.Pop);
                    Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":""});
                  }
                  return Future.value(false);
                },
                child: Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0)),
                  child: Container(
                      width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.20:MediaQuery.of(context).size.width,
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

  _dialogforAvailability(String prevAddOd, String addressId, String addressType,
      String adressSelected, IconData adressIcon, String currentbranch,) {
    String itemCount = "";
    itemCount = "   " + productBox.length.toString() + " " + "items";
    bool _checkMembership = false;

    if (prefs!.getString("membership") == "1") {
      _checkMembership = true;
    } else {
      _checkMembership = false;
    }

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
                        S .of(context).changing_area, // "Changing area",
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
                                  S .of(context).reason,//"Reason",
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
                      SizedBox(
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
                                          productBox[i].itemName!,
                                          style: TextStyle(fontSize: 12.0)),
                                      SizedBox(
                                        height: 3.0,
                                      ),
                                      _checkmembership
                                          ? (productBox[i]
                                          .membershipPrice ==
                                          '-' ||
                                          productBox[i]
                                              .membershipPrice ==
                                              "0")
                                          ? (double.parse(productBox[i].price!) <=
                                          0 ||
                                          productBox[i]
                                              .price
                                              .toString() ==
                                              "" ||
                                          productBox[i]
                                              .price ==
                                              productBox[i]
                                                  .varMrp)
                                          ? Text(
                                          Features.iscurrencyformatalign?
                                              productBox[i]
                                                  .varMrp
                                                  .toString() +
                                                  " " + IConstants.currencyFormat:
                                          IConstants.currencyFormat +
                                              " " +
                                              productBox[i]
                                                  .varMrp
                                                  .toString(),
                                          style: TextStyle(fontSize: 12.0))
                                          : Text(Features.iscurrencyformatalign?productBox[i].price.toString() + " " + IConstants.currencyFormat
                                              :IConstants.currencyFormat + " " + productBox[i].price.toString(),
                                          style: TextStyle(fontSize: 12.0))
                                          : Text(
                                        Features.iscurrencyformatalign?
                                        productBox[i].membershipPrice! + " " + IConstants.currencyFormat:
                                          IConstants.currencyFormat + " " + productBox[i].membershipPrice!,
                                          style: TextStyle(fontSize: 12.0))
                                          : (double.parse(productBox[i].price!) <= 0 || productBox[i].price.toString() == "" || productBox[i].price == productBox[i].varMrp)
                                          ? Text(Features.iscurrencyformatalign?
                                      productBox[i].varMrp.toString() + " " + IConstants.currencyFormat
                                              :IConstants.currencyFormat + " " + productBox[i].varMrp.toString(),
                                          style: TextStyle(fontSize: 12.0))
                                          : Text(
                                        Features.iscurrencyformatalign?productBox[i].price.toString()  + " " + IConstants.currencyFormat:
                                          IConstants.currencyFormat + " " + productBox[i].price.toString(), style: TextStyle(fontSize: 12.0))
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
                                  S .of(context).cancel, //"CANCEL"
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
                            /*  for(int i = 0; i < productBox.length; i++){
                                val = val+com+productBox[i].itemId.toString();
                                com = ",";
                              }*/
                              String item ="";
                              for(int i = 0; i < productBox.length; i++){
                                val = val+com+productBox[i].itemId.toString();
                                debugPrint("kbvcvb..."+item.toString());
                                if(productBox[i].mode =="3"){
                                  item = item+com+productBox[i].itemId.toString();
                                }
                                com = ",";
                              }
                              confirmSwap = "confirmSwap";
                              Provider.of<CartItems>(context, listen: false).emptyCart().then((_) {
                               // Hive.box<Product>(productBoxName).clear();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                PrefUtils.prefs!.setString("formapscreen", "homescreen");
                                // Navigator.of(context).pushNamed(MapScreen.routeName,
                                //     arguments: {
                                //       "valnext": val.toString(),
                                //       "moveNext": confirmSwap.toString(),
                                //
                                //     });
                              //  debugPrint("cvbnm,..."+PrefUtils.prefs!.getString("currentbranch")!);
                                Navigation(context, name:Routename.NotAvailability,navigatore: NavigatoreTyp.Push,
                                    qparms: {
                                      "val" : val,
                                      "item": item,
                                      "currentbranch":  currentbranch,

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

                              final cartItemsData = Provider.of<CartItems>(context, listen: false);
                              for(int i = 0; i < cartItemsData.items.length; i++) {
                                cartItemsData.items[i].itemQty = 0;
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
  SelecttimeSlot(id, int i, date, String timeslotsindex) {
    timeslotsData = Provider.of<DeliveryslotitemsList>(
      context,
      listen: false,
    ).findById(timeslotsindex);
    return  ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: 10,),
      physics:new NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: timeslotsData.length,
      itemBuilder: (_, j)
      {
       return GestureDetector(
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

             _index = (i == 0 && j == 0) ? 0 : _index + 1;
             for (int i = 0; i < timeData.times.length; i++) {
               timeData.times[i].isSelect = false;
               timeslotsData[j].isSelect = false;
               if (((int.parse(id) + j).toString() ==
                   timeData.times[i].index) && timeslotsData[j].status != "1") {
                 setState(() {
                   isSelected = false;
                   timeslotsData[j].isSelect = true;
                   prefs!.setString('fixtime', timeData.times[i].time!);
                 });
                 break;
               } else {
                 setState(() {
                   isSelected = true;
                   timeslotsData[j].isSelect = false;
                   timeslotsData[j].selectedColor = Colors.transparent;
                 });
               }
             }
           }
          });
        },
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: timeslotsData[j].isSelect ?ColorCodes.varcolor:ColorCodes.whiteColor,
            border: Border.all(
              color: timeslotsData[j].isSelect ?ColorCodes.primaryColor:ColorCodes.varcolor,
            ),
            borderRadius: BorderRadius.circular(3),
          ),
          // margin: EdgeInsets.only(left: 5.0, right: 5.0),
          //child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          //  padding: EdgeInsets.symmetric(horizontal: 40),
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 20,),
              Container(
                child: Text(
                  timeslotsData[j].time,
                  style: TextStyle(color: (timeslotsData[j].status=="1")?ColorCodes.grey  :ColorCodes.greenColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Spacer(),
              handler(timeslotsData[j].isSelect, timeslotsData[j].status),
              SizedBox(width: 20,),
            ],
          ),
        ),
       );
      }
    );
  }
  Widget SelectDate(){

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10,),
        Container(
          height: 78,
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
                              isSelected = true;
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
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        width: 40,

                        decoration: BoxDecoration(
                          color: deliveryslotData.items[i].isSelect ?ColorCodes.varcolor:ColorCodes.whiteColor,
                          border: Border.all(
                            color: deliveryslotData.items[i].isSelect ?ColorCodes.varcolor:ColorCodes.varcolor,
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Center(
                          child: Text(
                              dateSplit![0].toUpperCase(),
                             /* value1,*//*deliveryslotData.items[i].date,*/
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
  @override
  Widget build(BuildContext context) {
VxState.watch(context, on: [SetCartItem]);
    // final cartItemsData = Provider.of<CartItems>(context,listen: false);
    productBox = (VxState.store as GroceStore).CartItemList;

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

    int count=1;
    int countTime=1;

    for(int i=0;i<productBox.length;i++)
      if(productBox.length == 1 && productBox[0].mode == "1"){
        _deliveryChargeNormal="0";
        _deliveryChargeExpress="0";
        _deliveryChargePrime="0";
      }
    if (!_isLoading) {
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
      for(int i=0;i< productBox.length;i++) {
        durType = productBox[i].durationType!;
        mode = productBox[i].mode.toString();
      }


      something.clear();
      ExpressDetails.clear();
      DefaultSlot.clear();

      for(int i=0;i< productBox.length;i++) {

        if (productBox[i].varStock == "0" || productBox[i].status == "1") {

        }
        else {
          if ((productBox[i].durationType == "" ||
              productBox[i].durationType == null) ) {
            if ((productBox[i].eligibleForExpress == "0" ||
                productBox[i].eligibleForExpress == "1" ||
                productBox[i].eligibleForExpress == "") ||
                productBox[i].mode == "1") {
              DefaultSlot.add(productBox[i]);
              double DefaultTota1 = 0.0;
              bool toppingsdefault = false;
              for (int i = 0; i < DefaultSlot.length; i++) {
                if(DefaultSlot[i].toppings_data!.length > 0){
                  toppingsdefault = true;
                }
                DefaultTota1 = _checkmembership ?DefaultSlot[i].type=="1"?
                DefaultTota1 + (double.parse(
                    (double.parse(DefaultSlot[i].membershipPrice!) *
                        double.parse(DefaultSlot[i].weight!))
                        .toString()))
               : DefaultTota1 + (double.parse(
                    (double.parse(DefaultSlot[i].membershipPrice!) *
                        int.parse(DefaultSlot[i].quantity!))
                        .toString()))
                    : DefaultSlot[i].type=="1"?DefaultTota1 + (double.parse(
                    (double.parse(DefaultSlot[i].price!) *
                        double.parse(DefaultSlot[i].weight!))
                        .toString())) :DefaultTota1 + (double.parse(
                    (double.parse(DefaultSlot[i].price!) *
                        int.parse(DefaultSlot[i].quantity!))
                        .toString()));

              }
              if(toppingsdefault) {
                for (int k = 0; k < DefaultSlot.length; k++) {
                  for (int j = 0; j < DefaultSlot[k].toppings_data!.length; j++) {
                    DefaultSlot[k].type=="1"?
                    DefaultTota1 = DefaultTota1+ (double.parse(DefaultSlot[k].toppings_data![j].price!) * double.parse(DefaultSlot[k].weight!))
                    :DefaultTota1 = DefaultTota1+ double.parse(DefaultSlot[k].toppings_data![j].price! *  int.parse(DefaultSlot[k].quantity!));
                  }
                }
              }else{
                DefaultTota1 = DefaultTota1;
              }
              if (DefaultTota1 < double.parse(minOrdAmount)) {
                deliveryamount = double.parse(delCharge);
              } else {
                deliveryamount = 0;
              }

              if (deliveryamount == 0) {
                deliverychargetextdefault = "FREE";
              } else {
                deliverychargetextdefault =
                    Features.iscurrencyformatalign?
                    deliveryamount.toString() + " " + IConstants.currencyFormat:
                    IConstants.currencyFormat + " " + deliveryamount.toString();
              }
            }
          }
          else if (productBox[i].durationType == "0" ) {
            List<CartItem> dynamic1 = [];
            List<CartItem> finalList = [];

            dynamic1.clear();
            for (int i = 0; i < productBox.length; i++) {
              if((productBox[i].varStock == "0" || productBox[i].status == "1")){
              }else{
                dynamic1.add(productBox[i]);
              }
              finalList = dynamic1.where((i) => i.durationType == "0" ).toList();
              newMap = groupBy(finalList, (obj) => obj.duration!);
            }
          }
          else if (productBox[i].durationType == "1" ) {
            List<CartItem> dynamicTime = [];
            List<CartItem> finalListTime = [];

            dynamicTime.clear();
            for (int i = 0; i < productBox.length; i++) {
              if((productBox[i].varStock == "0" || productBox[i].status == "1")){
              }else{
                dynamicTime.add(productBox[i]);
              }
              finalListTime =
                  dynamicTime.where((i) => i.durationType == "1").toList();
              newMap1 = groupBy(finalListTime, (obj) => obj.duration!);
            }
          }

          ////////Delivery Option Two
          if (((productBox[i].durationType == "" ||
              productBox[i].durationType == null) &&
              (productBox[i].eligibleForExpress == "1" ||
                  productBox[i].eligibleForExpress == "")) ||
              productBox[i].mode == "1") {
            something.add(productBox[i]);


            double SecondSlotTotal = 0.0;
            bool toppingsSecondSlot = false;
            for (int i = 0; i < something.length; i++) {
              if(something[i].toppings_data!.length > 0){
                toppingsSecondSlot = true;
              }
              SecondSlotTotal = _checkmembership
                  ? something[i].type == "1"?
              SecondSlotTotal + (double.parse(
                  (double.parse(something[i].membershipPrice!) *
                      double.parse(something[i].weight!)).toString()))
                  :
              SecondSlotTotal + (double.parse(
                  (double.parse(something[i].membershipPrice!) *
                      int.parse(something[i].quantity!)).toString()))
                  : something[i].type == "1"?
              SecondSlotTotal + (double.parse(
                  (double.parse(something[i].price!) *
                      double.parse(something[i].weight!)).toString()))
              :SecondSlotTotal + (double.parse(
                  (double.parse(something[i].price!) *
                      int.parse(something[i].quantity!)).toString()));
            }

            if(toppingsSecondSlot) {
              for (int k = 0; k < something.length; k++) {
                for (int j = 0; j <
                    something[k].toppings_data!.length; j++) {
                  something[k].type == "1"?
                  SecondSlotTotal = SecondSlotTotal+ (double.parse(something[k].toppings_data![j].price!) * double.parse(something[k].weight!))
                      :
                  SecondSlotTotal = SecondSlotTotal+ double.parse(something[k].toppings_data![j].price! * int.parse(something[k].quantity!));
                }
              }
            }else{
              SecondSlotTotal = SecondSlotTotal;
            }

            if (SecondSlotTotal < double.parse(minOrdAmount)) {
              deliverySlotamount = double.parse(delCharge);
            } else {
              deliverySlotamount = 0;
            }

            if (deliverySlotamount == 0) {
              deliverychargetextSecond = "FREE";
            } else {
              deliverychargetextSecond = Features.iscurrencyformatalign?
              deliverySlotamount.toString() + " " + IConstants.currencyFormat :
              IConstants.currencyFormat + " " +
                  deliverySlotamount.toString();
            }
          }
          else if (productBox[i].eligibleForExpress == "0") {
            ExpressDetails.add(productBox[i]);

            double SecondExpressTotal = 0.0;
            bool toppingsSecondExpress = false;
            for (int i = 0; i < ExpressDetails.length; i++) {
              if(ExpressDetails[i].toppings_data!.length > 0){
                toppingsSecondExpress = true;
              }
              SecondExpressTotal = _checkmembership ?ExpressDetails[i].type == "1"?
              SecondExpressTotal + (double.parse(
                  (double.parse(ExpressDetails[i].membershipPrice!) *
                      double.parse(ExpressDetails[i].weight!)).toString()))
                  :
              SecondExpressTotal + (double.parse(
                  (double.parse(ExpressDetails[i].membershipPrice!) *
                      int.parse(ExpressDetails[i].quantity!)).toString()))
                  : ExpressDetails[i].type == "1"?
              SecondExpressTotal + (double.parse(
                  (double.parse(ExpressDetails[i].price!) *
                      double.parse(ExpressDetails[i].weight!)).toString()))
              :SecondExpressTotal + (double.parse(
                  (double.parse(ExpressDetails[i].price!) *
                      int.parse(ExpressDetails[i].quantity!)).toString()));
            }

            if(toppingsSecondExpress) {
              for (int k = 0; k < ExpressDetails.length; k++) {
                for (int j = 0; j < ExpressDetails[k].toppings_data!.length; j++) {
                  ExpressDetails[k].type == "1"?
                  SecondExpressTotal = SecondExpressTotal+ (double.parse(ExpressDetails[k].toppings_data![j].price!) * double.parse(ExpressDetails[k].weight!))
                  :SecondExpressTotal = SecondExpressTotal+ double.parse(ExpressDetails[k].toppings_data![j].price! * int.parse(ExpressDetails[k].quantity!));
                }
              }
            }else{
              SecondExpressTotal = SecondExpressTotal;
            }

            minOrdAmountExpress = _minimumOrderAmountExpress;
            delChargeExpress = _deliveryChargeExpress;
            if (SecondExpressTotal < double.parse(minOrdAmountExpress)) {
              deliveryExpressamount = double.parse(delChargeExpress);
            } else {
              deliveryExpressamount = 0;
            }

            if (deliveryExpressamount == 0) {
              deliverychargetextExpress = "FREE";
            } else {
              deliverychargetextExpress = Features.iscurrencyformatalign?
             deliveryExpressamount.toString() + " " + IConstants.currencyFormat :
              IConstants.currencyFormat + " " +
                  deliveryExpressamount.toString();
            }
          }
          else if (productBox[i].durationType == "0" &&
              (productBox[i].eligibleForExpress == "1" ||
                  productBox[i].eligibleForExpress == "" ||
                  productBox[i].eligibleForExpress == null)) {
            List<CartItem> dynamic1 = [];
            List<CartItem> finalList = [];
            dynamic1.clear();
            for (int i = 0; i < productBox.length; i++) {
              if((productBox[i].varStock == "0" || productBox[i].status == "1")){
              }else{
                dynamic1.add(productBox[i]);
              }

              finalList = dynamic1.where((i) =>
              i.durationType == "0" &&
                  (i.eligibleForExpress == "1" || i.eligibleForExpress == ""))
                  .toList();
              newMap2 = groupBy(finalList, (obj) => obj.duration!);
            }
          }
          else if (productBox[i].durationType == "1" &&
              (productBox[i].eligibleForExpress == "1" ||
                  productBox[i].eligibleForExpress == "" ||
                  productBox[i].eligibleForExpress == null)) {
            List<CartItem> dynamicTime = [];
            List<CartItem> finalListTime = [];

            dynamicTime.clear();
            for (int i = 0; i < productBox.length; i++) {
              if((productBox[i].varStock == "0" || productBox[i].status == "1")){
              }else{
                dynamicTime.add(productBox[i]);
              }
             // dynamicTime.add(productBox[i]);
              finalListTime = dynamicTime.where((i) =>
              i.durationType == "1" &&
                  (i.eligibleForExpress == "1" || i.eligibleForExpress == ""))
                  .toList();
              newMap3 = groupBy(finalListTime, (obj) => obj.duration!);
            }
          }


        }

      }
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

            bool Toppingsdefaultdate = false;
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
                 if(newMap!.values.elementAt(i)[j].toppings_data!.length > 0){
                   Toppingsdefaultdate = true;
                 }
              DefaultDateTotal = _checkmembership?newMap!.values.elementAt(i)[j].type == "1"?
              DefaultDateTotal+(double.parse(
                  (double.parse(newMap!.values.elementAt(i)[j].membershipPrice!) *double.parse(newMap!.values.elementAt(i)[j].weight!)).toString()))
                  :
              DefaultDateTotal+(double.parse(
                  (double.parse(newMap!.values.elementAt(i)[j].membershipPrice!) *int.parse(newMap!.values.elementAt(i)[j].quantity!)).toString()))
                  :newMap!.values.elementAt(i)[j].type == "1"?
              DefaultDateTotal+(double.parse(
                  (double.parse(newMap!.values.elementAt(i)[j].price!) * double.parse(newMap!.values.elementAt(i)[j].weight!)).toString()))
            : DefaultDateTotal+(double.parse(
                  (double.parse(newMap!.values.elementAt(i)[j].price!) * int.parse(newMap!.values.elementAt(i)[j].quantity!)).toString()));
              note= newMap!.values.elementAt(i)[j].note!;
            }
            if(Toppingsdefaultdate){
              for (int k = 0; k < newMap!.values.elementAt(i).length; k++) {
                for (int l = 0; l <
                    newMap!.values.elementAt(i)[k].toppings_data!.length; l++) {
                  newMap!.values.elementAt(i)[k].type == "1"?
                  DefaultDateTotal = DefaultDateTotal+ (double.parse(newMap!.values.elementAt(i)[k].toppings_data![l].price!) * double.parse(newMap!.values.elementAt(i)[k].weight!))

                  :DefaultDateTotal = DefaultDateTotal+ double.parse(newMap!.values.elementAt(i)[k].toppings_data![l].price! * int.parse(newMap!.values.elementAt(i)[k].quantity!));
                }
              }
            }else{
              DefaultDateTotal = DefaultDateTotal;
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
                      ),),
                      // (deliverychargetextDate != "FREE") ?
                      // SimpleTooltip(
                      //   maxHeight: MediaQuery.of(context).size.width * 24.7/100,
                      //   borderColor: Theme.of(context).primaryColor,
                      //   tooltipTap: ()
                      //   {
                      //     setState(() {
                      //       _showDeliveryinfo = !_showDeliveryinfo;
                      //     }
                      //     );
                      //   },
                      //   hideOnTooltipTap: true,
                      //   show:_showDeliveryinfo ,
                      //   tooltipDirection: TooltipDirection.down,
                      //   ballonPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      //   child:
                      //   IconButton(
                      //     padding: EdgeInsets.all(0),
                      //     icon:Icon(Icons.help_outline,size: 15,),
                      //     onPressed: (){
                      //       setState(() {
                      //         _showDeliveryinfo = !_showDeliveryinfo;
                      //         _showDeliveryinfo1 = false;
                      //         _showDeliveryinfo2 = false;
                      //       }
                      //       );
                      //     },
                      //   ),
                      //   content: Container(child:Column(children:[
                      //     _checkmembership ? Text(S .of(context).Shop + " "//'Shop '
                      //         +IConstants.currencyFormat+ " "+ defaultamountdate.toStringAsFixed(IConstants.decimaldigit) + " " + S .of(context).more_to_get,//' more to get free delivery',
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.w500,
                      //           color:Colors.black,
                      //           fontStyle: FontStyle.normal,
                      //           fontSize: 12,
                      //           decoration: TextDecoration.none
                      //       ),
                      //     )
                      //         :
                      //     Text(S .of(context).Shop + " "//'Shop '
                      //         +IConstants.currencyFormat+ " " + defaultamountdate.toStringAsFixed(IConstants.decimaldigit)+ " " + S .of(context).more_to_get,//' more to get free delivery',
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.w500,
                      //           color:Colors.black,
                      //           fontStyle: FontStyle.normal,
                      //           fontSize: 12,
                      //           decoration: TextDecoration.none
                      //       ),
                      //     ),
                      //     SizedBox(height: 3,),
                      //     GestureDetector(onTap:()
                      //     {
                      //       /*Navigator.of(context).pushNamed(
                      //                       CategoryScreen.routeName,
                      //                     );*/
                      //       /*Navigator.of(context).pushNamedAndRemoveUntil(
                      //                     '/home-screen', (Route<dynamic> route) => false);*/
                      //       Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
                      //
                      //     },
                      //         child: Center(
                      //           child:Text(S .of(context).Shop_more,//'Shop more',
                      //             style: TextStyle(color:Color(0xffff3333),fontSize: 12,fontWeight: FontWeight.w500,decoration: TextDecoration.none),),))])),
                      //   arrowTipDistance: 2,
                      //   minimumOutSidePadding: 10,
                      //   arrowLength: 8,
                      // )
                      //     :
                      // SimpleTooltip(
                      //
                      //   ballonPadding: EdgeInsets.symmetric(vertical: 3,horizontal: 5),
                      //   tooltipTap: (){
                      //     setState(() {
                      //       _showDeliveryinfo = !_showDeliveryinfo;
                      //       _showDeliveryinfo1 = false;
                      //       _showDeliveryinfo2 = false;
                      //     });
                      //   },
                      //   //animationDuration: Duration(seconds: 3),
                      //   hideOnTooltipTap: true,
                      //   show:_showDeliveryinfo ,
                      //   arrowTipDistance: 0,
                      //   arrowLength: 5,
                      //   tooltipDirection: TooltipDirection.down,
                      //   child: IconButton(
                      //
                      //     padding: EdgeInsets.all(0),
                      //     icon:Icon(
                      //       Icons.help_outline,
                      //       size: 15,
                      //
                      //     ),onPressed: (){
                      //     setState(() {
                      //       _showDeliveryinfo = !_showDeliveryinfo;
                      //       _showDeliveryinfo1 = false;
                      //       _showDeliveryinfo2 = false;
                      //     });
                      //   },),
                      //   content: Text(
                      //     S .of(context).Yay,
                      //     //'Yay!Free Delivery',
                      //     style: TextStyle(
                      //       fontSize: 12,
                      //       color: Colors.black54,
                      //       decoration: TextDecoration.none,
                      //     ),
                      //   ),
                      //   borderColor: Theme.of(context).primaryColor,
                      // ),
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
            bool Toppingsdefaulttime = false;
            debugPrint("jhgfx...."+newMap1!.values.elementAt(i).length.toString());
            for(int j = 0; j < newMap1!.values.elementAt(i).length; j++) {
              if(newMap1!.values.elementAt(i)[j].toppings_data!.length > 0){
                Toppingsdefaulttime = true;
              }
              debugPrint("kjhgfnb..."+newMap1!.values.elementAt(i)[j].membershipPrice!+"...."+newMap1!.values.elementAt(i)[j].weight!);
              DefaultTimeTotal = _checkmembership?newMap1!.values.elementAt(i)[j].type == "1"?
              DefaultTimeTotal+(double.parse(
                  (double.parse(newMap1!.values.elementAt(i)[j].membershipPrice!) * double.parse(newMap1!.values.elementAt(i)[j].weight!)).toString()))
                  :
              DefaultTimeTotal+(double.parse(
                  (double.parse(newMap1!.values.elementAt(i)[j].membershipPrice!) * int.parse(newMap1!.values.elementAt(i)[j].quantity!)).toString()))
                  :newMap1!.values.elementAt(i)[j].type == "1"?
              DefaultTimeTotal+(double.parse(
                  (double.parse(newMap1!.values.elementAt(i)[j].price!) * double.parse(newMap1!.values.elementAt(i)[j].weight!)).toString()))
              :DefaultTimeTotal+(double.parse(
                  (double.parse(newMap1!.values.elementAt(i)[j].price!) * int.parse(newMap1!.values.elementAt(i)[j].quantity!)).toString()));
              note= newMap1!.values.elementAt(i)[j].note!;
            }
            debugPrint("DefaultTimeTotal...."+DefaultTimeTotal.toString());
            if(Toppingsdefaulttime){
              for (int k = 0; k < newMap1!.values.elementAt(i).length; k++) {
                for (int l = 0; l <
                    newMap1!.values.elementAt(i)[k].toppings_data!.length; l++) {
                  newMap1!.values.elementAt(i)[k].type == "1"?
                  DefaultTimeTotal = DefaultTimeTotal+ (double.parse(newMap1!.values.elementAt(i)[k].toppings_data![l].price!) * double.parse(newMap1!.values.elementAt(i)[k].weight!))
                 : DefaultTimeTotal = DefaultTimeTotal+ double.parse(newMap1!.values.elementAt(i)[k].toppings_data![l].price! * int.parse(newMap1!.values.elementAt(i)[k].quantity!));
                }
              }
            }else{
              DefaultTimeTotal = DefaultTimeTotal;
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
                      // Text( S .of(context).delivery_in+//Delivery in " +
                      //     " "  + newMap1!.keys.elementAt(i).toString() + S .of(context).hours,//" Hours",
                      //     style: TextStyle(
                      //         fontSize: 13, fontWeight: FontWeight.w600, color: ColorCodes.primaryColor)
                      // ),

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
                      // (deliverychargetextTime != "FREE") ?
                      // SimpleTooltip(
                      //   maxHeight: MediaQuery.of(context).size.width * 24.7/100,
                      //   borderColor: Theme.of(context).primaryColor,
                      //   tooltipTap: ()
                      //   {
                      //     setState(() {
                      //       _showDeliveryinfo1 = !_showDeliveryinfo1;
                      //       _showDeliveryinfo = false;
                      //       _showDeliveryinfo2 = false;
                      //     }
                      //     );
                      //   },
                      //   hideOnTooltipTap: true,
                      //   show:_showDeliveryinfo1 ,
                      //   tooltipDirection: TooltipDirection.down,
                      //   ballonPadding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                      //   child:
                      //   IconButton(
                      //     padding: EdgeInsets.all(0),
                      //     icon:Icon(Icons.help_outline,size: 15,),
                      //     onPressed: (){
                      //       setState(() {
                      //         _showDeliveryinfo1 = !_showDeliveryinfo1;
                      //         _showDeliveryinfo = false;
                      //         _showDeliveryinfo2 = false;
                      //       }
                      //       );
                      //     },
                      //   ),
                      //   content: Container(
                      //       child:Column(
                      //           children:[
                      //     _checkmembership ? Text(S .of(context).Shop + " "//'Shop '
                      //         +IConstants.currencyFormat + " "+ deliveryamounttext.toStringAsFixed(IConstants.decimaldigit) + " " + S .of(context).more_to_get,//' more to get free delivery',
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.w500,
                      //           color:Colors.black,
                      //           fontStyle: FontStyle.normal,
                      //           fontSize: 12,
                      //           decoration: TextDecoration.none
                      //       ),
                      //     )
                      //         :
                      //     Text(S .of(context).Shop + " "//'Shop '
                      //         + IConstants.currencyFormat+ deliveryamounttext.toStringAsFixed(IConstants.decimaldigit)+ " " + S .of(context).more_to_get,//' more to get free delivery',
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.w500,
                      //           color:Colors.black,
                      //           fontStyle: FontStyle.normal,
                      //           fontSize: 12,
                      //           decoration: TextDecoration.none
                      //       ),
                      //     ),
                      //     SizedBox(height: 3,),
                      //     GestureDetector(onTap:()
                      //     {
                      //       /*Navigator.of(context).pushNamed(
                      //                       CategoryScreen.routeName,
                      //                     );*/
                      //       /*Navigator.of(context).pushNamedAndRemoveUntil(
                      //                     '/home-screen', (Route<dynamic> route) => false);*/
                      //       Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
                      //
                      //     },
                      //         child: Center(
                      //           child:Text(S .of(context).Shop_more,//'Shop more',
                      //             style: TextStyle(color:Color(0xffff3333),fontSize: 12,fontWeight: FontWeight.w500,decoration: TextDecoration.none),),))])),
                      //   arrowTipDistance: 2,
                      //   minimumOutSidePadding: 10,
                      //   arrowLength: 8,
                      // )
                      //     :
                      // SimpleTooltip(
                      //
                      //   ballonPadding: EdgeInsets.symmetric(vertical: 3,horizontal: 5),
                      //   tooltipTap: (){
                      //     setState(() {
                      //       _showDeliveryinfo1 = !_showDeliveryinfo1;
                      //       _showDeliveryinfo = false;
                      //       _showDeliveryinfo2 = false;
                      //     });
                      //   },
                      //   //animationDuration: Duration(seconds: 3),
                      //   hideOnTooltipTap: true,
                      //   show:_showDeliveryinfo1 ,
                      //   arrowTipDistance: 0,
                      //   arrowLength: 5,
                      //   tooltipDirection: TooltipDirection.down,
                      //   child: IconButton(
                      //
                      //     padding: EdgeInsets.all(0),
                      //     icon:Icon(
                      //       Icons.help_outline,
                      //       size: 15,
                      //
                      //     ),onPressed: (){
                      //     setState(() {
                      //       _showDeliveryinfo1 = !_showDeliveryinfo1;
                      //       _showDeliveryinfo = false;
                      //       _showDeliveryinfo2 = false;
                      //     });
                      //   },),
                      //   content: Text(
                      //     S .of(context).Yay,
                      //     //'Yay!Free Delivery',
                      //     style: TextStyle(
                      //       fontSize: 12,
                      //       color: Colors.black54,
                      //       decoration: TextDecoration.none,
                      //     ),
                      //   ),
                      //   borderColor: Theme.of(context).primaryColor,
                      // )
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
                            color: ColorCodes.blackColor,
                            fontSize: 10, fontWeight: FontWeight.bold
                        ),),
                      SizedBox(width: 2,),
                      Text(
                        note
                        ,style: TextStyle(
                        color:ColorCodes.blackColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold
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
                style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: ColorCodes.blackColor),
              ),
              Text(S .of(context).slot_based_delivery,
                style: TextStyle(fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor
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
              ),),
              // (deliverychargetextdefault != "FREE") ?
              // SimpleTooltip(
              //   maxHeight: MediaQuery.of(context).size.width * 24.7/100,
              //   borderColor: Theme.of(context).primaryColor,
              //   tooltipTap: ()
              //   {
              //     setState(() {
              //       _showDeliveryinfo1 = !_showDeliveryinfo1;
              //       _showDeliveryinfo = false;
              //       _showDeliveryinfo2 = false;
              //     }
              //     );
              //   },
              //   hideOnTooltipTap: true,
              //   show:_showDeliveryinfo1 ,
              //   tooltipDirection: TooltipDirection.down,
              //   ballonPadding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
              //   child:
              //   IconButton(
              //     padding: EdgeInsets.all(0),
              //     icon:Icon(Icons.help_outline,size: 15,),
              //     onPressed: (){
              //       setState(() {
              //         _showDeliveryinfo1 = !_showDeliveryinfo1;
              //         _showDeliveryinfo = false;
              //         _showDeliveryinfo2 = false;
              //       }
              //       );
              //     },
              //   ),
              //   content: Container(
              //       child:Column(
              //           children:[
              //             _checkmembership ? Text(S .of(context).Shop + " "//'Shop '
              //                 +IConstants.currencyFormat + " "+ deliveryamounttext.toStringAsFixed(IConstants.decimaldigit) + " " + S .of(context).more_to_get,//' more to get free delivery',
              //               style: TextStyle(
              //                   fontWeight: FontWeight.w500,
              //                   color:Colors.black,
              //                   fontStyle: FontStyle.normal,
              //                   fontSize: 12,
              //                   decoration: TextDecoration.none
              //               ),
              //             )
              //                 :
              //             Text(S .of(context).Shop + " "//'Shop '
              //                 + IConstants.currencyFormat+ deliveryamounttext.toStringAsFixed(IConstants.decimaldigit)+ " " + S .of(context).more_to_get,//' more to get free delivery',
              //               style: TextStyle(
              //                   fontWeight: FontWeight.w500,
              //                   color:Colors.black,
              //                   fontStyle: FontStyle.normal,
              //                   fontSize: 12,
              //                   decoration: TextDecoration.none
              //               ),
              //             ),
              //             SizedBox(height: 3,),
              //             GestureDetector(onTap:()
              //             {
              //               /*Navigator.of(context).pushNamed(
              //                               CategoryScreen.routeName,
              //                             );*/
              //               /*Navigator.of(context).pushNamedAndRemoveUntil(
              //                             '/home-screen', (Route<dynamic> route) => false);*/
              //               Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
              //
              //             },
              //                 child: Center(
              //                   child:Text(S .of(context).Shop_more,//'Shop more',
              //                     style: TextStyle(color:Color(0xffff3333),fontSize: 12,fontWeight: FontWeight.w500,decoration: TextDecoration.none),),))])),
              //   arrowTipDistance: 2,
              //   minimumOutSidePadding: 10,
              //   arrowLength: 8,
              // )
              //     :
              // SimpleTooltip(
              //
              //   ballonPadding: EdgeInsets.symmetric(vertical: 3,horizontal: 5),
              //   tooltipTap: (){
              //     setState(() {
              //       _showDeliveryinfo1 = !_showDeliveryinfo1;
              //       _showDeliveryinfo = false;
              //       _showDeliveryinfo2 = false;
              //     });
              //   },
              //   //animationDuration: Duration(seconds: 3),
              //   hideOnTooltipTap: true,
              //   show:_showDeliveryinfo1 ,
              //   arrowTipDistance: 0,
              //   arrowLength: 5,
              //   tooltipDirection: TooltipDirection.down,
              //   child: IconButton(
              //
              //     padding: EdgeInsets.all(0),
              //     icon:Icon(
              //       Icons.help_outline,
              //       size: 15,
              //
              //     ),onPressed: (){
              //     setState(() {
              //       _showDeliveryinfo1 = !_showDeliveryinfo1;
              //       _showDeliveryinfo = false;
              //       _showDeliveryinfo2 = false;
              //     });
              //   },),
              //   content: Text(
              //     S .of(context).Yay,
              //     //'Yay!Free Delivery',
              //     style: TextStyle(
              //       fontSize: 12,
              //       color: Colors.black54,
              //       decoration: TextDecoration.none,
              //     ),
              //   ),
              //   borderColor: Theme.of(context).primaryColor,
              // ),
            ],
          ) : SizedBox.shrink(),
          (Features.isSplit) ? SizedBox(height: 15,) : SizedBox(height: 5,),
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
                    fontSize: 13, fontWeight: FontWeight.bold
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
                style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold, color: ColorCodes.greyColor),
              ):SizedBox.shrink(),
              Text( S .of(context).express_delivery,
                  style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600,color: ColorCodes.primaryColor)),
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
              ),),
              // (deliverychargetextTime != "FREE") ?
              // SimpleTooltip(
              //   maxHeight: MediaQuery.of(context).size.width * 24.7/100,
              //   borderColor: Theme.of(context).primaryColor,
              //   tooltipTap: ()
              //   {
              //     setState(() {
              //       _showDeliveryinfo1 = !_showDeliveryinfo1;
              //       _showDeliveryinfo = false;
              //       _showDeliveryinfo2 = false;
              //     }
              //     );
              //   },
              //   hideOnTooltipTap: true,
              //   show:_showDeliveryinfo1 ,
              //   tooltipDirection: TooltipDirection.down,
              //   ballonPadding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
              //   child:
              //   IconButton(
              //     padding: EdgeInsets.all(0),
              //     icon:Icon(Icons.help_outline,size: 15,),
              //     onPressed: (){
              //       setState(() {
              //         _showDeliveryinfo1 = !_showDeliveryinfo1;
              //         _showDeliveryinfo = false;
              //         _showDeliveryinfo2 = false;
              //       }
              //       );
              //     },
              //   ),
              //   content: Container(
              //       child:Column(
              //           children:[
              //             _checkmembership ? Text(S .of(context).Shop + " "//'Shop '
              //                 +IConstants.currencyFormat + " "+ deliveryamounttext.toStringAsFixed(IConstants.decimaldigit) + " " + S .of(context).more_to_get,//' more to get free delivery',
              //               style: TextStyle(
              //                   fontWeight: FontWeight.w500,
              //                   color:Colors.black,
              //                   fontStyle: FontStyle.normal,
              //                   fontSize: 12,
              //                   decoration: TextDecoration.none
              //               ),
              //             )
              //                 :
              //             Text(S .of(context).Shop + " "//'Shop '
              //                 + IConstants.currencyFormat+ deliveryamounttext.toStringAsFixed(IConstants.decimaldigit)+ " " + S .of(context).more_to_get,//' more to get free delivery',
              //               style: TextStyle(
              //                   fontWeight: FontWeight.w500,
              //                   color:Colors.black,
              //                   fontStyle: FontStyle.normal,
              //                   fontSize: 12,
              //                   decoration: TextDecoration.none
              //               ),
              //             ),
              //             SizedBox(height: 3,),
              //             GestureDetector(onTap:()
              //             {
              //               /*Navigator.of(context).pushNamed(
              //                               CategoryScreen.routeName,
              //                             );*/
              //               /*Navigator.of(context).pushNamedAndRemoveUntil(
              //                             '/home-screen', (Route<dynamic> route) => false);*/
              //               Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
              //
              //             },
              //                 child: Center(
              //                   child:Text(S .of(context).Shop_more,//'Shop more',
              //                     style: TextStyle(color:Color(0xffff3333),fontSize: 12,fontWeight: FontWeight.w500,decoration: TextDecoration.none),),))])),
              //   arrowTipDistance: 2,
              //   minimumOutSidePadding: 10,
              //   arrowLength: 8,
              // )
              //     :
              // SimpleTooltip(
              //
              //   ballonPadding: EdgeInsets.symmetric(vertical: 3,horizontal: 5),
              //   tooltipTap: (){
              //     setState(() {
              //       _showDeliveryinfo1 = !_showDeliveryinfo1;
              //       _showDeliveryinfo = false;
              //       _showDeliveryinfo2 = false;
              //     });
              //   },
              //   //animationDuration: Duration(seconds: 3),
              //   hideOnTooltipTap: true,
              //   show:_showDeliveryinfo1 ,
              //   arrowTipDistance: 0,
              //   arrowLength: 5,
              //   tooltipDirection: TooltipDirection.down,
              //   child: IconButton(
              //
              //     padding: EdgeInsets.all(0),
              //     icon:Icon(
              //       Icons.help_outline,
              //       size: 15,
              //
              //     ),onPressed: (){
              //     setState(() {
              //       _showDeliveryinfo1 = !_showDeliveryinfo1;
              //       _showDeliveryinfo = false;
              //       _showDeliveryinfo2 = false;
              //     });
              //   },),
              //   content: Text(
              //     S .of(context).Yay,
              //     //'Yay!Free Delivery',
              //     style: TextStyle(
              //       fontSize: 12,
              //       color: Colors.black54,
              //       decoration: TextDecoration.none,
              //     ),
              //   ),
              //   borderColor: Theme.of(context).primaryColor,
              // )
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
              ),),
              // (deliverychargetextTime != "FREE") ?
              // SimpleTooltip(
              //   maxHeight: MediaQuery.of(context).size.width * 24.7/100,
              //   borderColor: Theme.of(context).primaryColor,
              //   tooltipTap: ()
              //   {
              //     setState(() {
              //       _showDeliveryinfo1 = !_showDeliveryinfo1;
              //       _showDeliveryinfo = false;
              //       _showDeliveryinfo2 = false;
              //     }
              //     );
              //   },
              //   hideOnTooltipTap: true,
              //   show:_showDeliveryinfo1 ,
              //   tooltipDirection: TooltipDirection.down,
              //   ballonPadding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
              //   child:
              //   IconButton(
              //     padding: EdgeInsets.all(0),
              //     icon:Icon(Icons.help_outline,size: 15,),
              //     onPressed: (){
              //       setState(() {
              //         _showDeliveryinfo1 = !_showDeliveryinfo1;
              //         _showDeliveryinfo = false;
              //         _showDeliveryinfo2 = false;
              //       }
              //       );
              //     },
              //   ),
              //   content: Container(
              //       child:Column(
              //           children:[
              //             _checkmembership ? Text(S .of(context).Shop + " "//'Shop '
              //                 +IConstants.currencyFormat + " "+ deliveryamounttext.toStringAsFixed(IConstants.decimaldigit) + " " + S .of(context).more_to_get,//' more to get free delivery',
              //               style: TextStyle(
              //                   fontWeight: FontWeight.w500,
              //                   color:Colors.black,
              //                   fontStyle: FontStyle.normal,
              //                   fontSize: 12,
              //                   decoration: TextDecoration.none
              //               ),
              //             )
              //                 :
              //             Text(S .of(context).Shop + " "//'Shop '
              //                 + IConstants.currencyFormat+ deliveryamounttext.toStringAsFixed(IConstants.decimaldigit)+ " " + S .of(context).more_to_get,//' more to get free delivery',
              //               style: TextStyle(
              //                   fontWeight: FontWeight.w500,
              //                   color:Colors.black,
              //                   fontStyle: FontStyle.normal,
              //                   fontSize: 12,
              //                   decoration: TextDecoration.none
              //               ),
              //             ),
              //             SizedBox(height: 3,),
              //             GestureDetector(onTap:()
              //             {
              //               /*Navigator.of(context).pushNamed(
              //                               CategoryScreen.routeName,
              //                             );*/
              //               /*Navigator.of(context).pushNamedAndRemoveUntil(
              //                             '/home-screen', (Route<dynamic> route) => false);*/
              //               Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
              //
              //             },
              //                 child: Center(
              //                   child:Text(S .of(context).Shop_more,//'Shop more',
              //                     style: TextStyle(color:Color(0xffff3333),fontSize: 12,fontWeight: FontWeight.w500,decoration: TextDecoration.none),),))])),
              //   arrowTipDistance: 2,
              //   minimumOutSidePadding: 10,
              //   arrowLength: 8,
              // )
              //     :
              // SimpleTooltip(
              //
              //   ballonPadding: EdgeInsets.symmetric(vertical: 3,horizontal: 5),
              //   tooltipTap: (){
              //     setState(() {
              //       _showDeliveryinfo1 = !_showDeliveryinfo1;
              //       _showDeliveryinfo = false;
              //       _showDeliveryinfo2 = false;
              //     });
              //   },
              //   //animationDuration: Duration(seconds: 3),
              //   hideOnTooltipTap: true,
              //   show:_showDeliveryinfo1 ,
              //   arrowTipDistance: 0,
              //   arrowLength: 5,
              //   tooltipDirection: TooltipDirection.down,
              //   child: IconButton(
              //
              //     padding: EdgeInsets.all(0),
              //     icon:Icon(
              //       Icons.help_outline,
              //       size: 15,
              //
              //     ),onPressed: (){
              //     setState(() {
              //       _showDeliveryinfo1 = !_showDeliveryinfo1;
              //       _showDeliveryinfo = false;
              //       _showDeliveryinfo2 = false;
              //     });
              //   },),
              //   content: Text(
              //     S .of(context).Yay,
              //     //'Yay!Free Delivery',
              //     style: TextStyle(
              //       fontSize: 12,
              //       color: Colors.black54,
              //       decoration: TextDecoration.none,
              //     ),
              //   ),
              //   borderColor: Theme.of(context).primaryColor,
              // )
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
              bool Toppingsexpressdate = false;
              for (int j = 0; j < newMap2!.values.elementAt(i).length; j++) {
                if(newMap2!.values.elementAt(i)[j].toppings_data!.length > 0){
                  Toppingsexpressdate = true;
                }
                SecondDateTotal = _checkmembership?newMap2!.values.elementAt(i)[j].type =="1"?
                SecondDateTotal + (double.parse(
                    (double.parse(newMap2!.values.elementAt(i)[j].membershipPrice!) *double.parse(newMap2!.values.elementAt(i)[j].weight!))
                        .toString()))
               : SecondDateTotal + (double.parse(
                    (double.parse(newMap2!.values.elementAt(i)[j].membershipPrice!) *int.parse(newMap2!.values.elementAt(i)[j].quantity!))
                        .toString()))
                    :newMap2!.values.elementAt(i)[j].type =="1"?
                SecondDateTotal + (double.parse(
                    (double.parse(newMap2!.values.elementAt(i)[j].price!) *double.parse(newMap2!.values.elementAt(i)[j].weight!))
                        .toString()))
                :SecondDateTotal + (double.parse(
                    (double.parse(newMap2!.values.elementAt(i)[j].price!) *int.parse(newMap2!.values.elementAt(i)[j].quantity!))
                        .toString()));
                note= newMap2!.values.elementAt(i)[j].note!;
              }
              if(Toppingsexpressdate){
                for (int k = 0; k < newMap2!.values.elementAt(i).length; k++) {
                  for (int l = 0; l <
                      newMap2!.values.elementAt(i)[k].toppings_data!.length; l++) {
                    newMap2!.values.elementAt(i)[k].type =="1"?
                    SecondDateTotal = SecondDateTotal+( double.parse(newMap2!.values.elementAt(i)[k].toppings_data![l].price!) * double.parse(newMap2!.values.elementAt(i)[k].weight!))
                   : SecondDateTotal = SecondDateTotal+ double.parse(newMap2!.values.elementAt(i)[k].toppings_data![l].price! * int.parse(newMap2!.values.elementAt(i)[k].quantity!));
                  }
                }
              }else{
                SecondDateTotal = SecondDateTotal;
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
                deliveryDateamount.toString() + " " + IConstants.currencyFormat:
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
                        // (deliverychargetextTime != "FREE") ?
                        // SimpleTooltip(
                        //   maxHeight: MediaQuery.of(context).size.width * 24.7/100,
                        //   borderColor: Theme.of(context).primaryColor,
                        //   tooltipTap: ()
                        //   {
                        //     setState(() {
                        //       _showDeliveryinfo1 = !_showDeliveryinfo1;
                        //       _showDeliveryinfo = false;
                        //       _showDeliveryinfo2 = false;
                        //     }
                        //     );
                        //   },
                        //   hideOnTooltipTap: true,
                        //   show:_showDeliveryinfo1 ,
                        //   tooltipDirection: TooltipDirection.down,
                        //   ballonPadding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                        //   child:
                        //   IconButton(
                        //     padding: EdgeInsets.all(0),
                        //     icon:Icon(Icons.help_outline,size: 15,),
                        //     onPressed: (){
                        //       setState(() {
                        //         _showDeliveryinfo1 = !_showDeliveryinfo1;
                        //         _showDeliveryinfo = false;
                        //         _showDeliveryinfo2 = false;
                        //       }
                        //       );
                        //     },
                        //   ),
                        //   content: Container(
                        //       child:Column(
                        //           children:[
                        //             _checkmembership ? Text(S .of(context).Shop + " "//'Shop '
                        //                 +IConstants.currencyFormat + " "+ deliveryamounttext.toStringAsFixed(IConstants.decimaldigit) + " " + S .of(context).more_to_get,//' more to get free delivery',
                        //               style: TextStyle(
                        //                   fontWeight: FontWeight.w500,
                        //                   color:Colors.black,
                        //                   fontStyle: FontStyle.normal,
                        //                   fontSize: 12,
                        //                   decoration: TextDecoration.none
                        //               ),
                        //             )
                        //                 :
                        //             Text(S .of(context).Shop + " "//'Shop '
                        //                 + IConstants.currencyFormat+ deliveryamounttext.toStringAsFixed(IConstants.decimaldigit)+ " " + S .of(context).more_to_get,//' more to get free delivery',
                        //               style: TextStyle(
                        //                   fontWeight: FontWeight.w500,
                        //                   color:Colors.black,
                        //                   fontStyle: FontStyle.normal,
                        //                   fontSize: 12,
                        //                   decoration: TextDecoration.none
                        //               ),
                        //             ),
                        //             SizedBox(height: 3,),
                        //             GestureDetector(onTap:()
                        //             {
                        //               /*Navigator.of(context).pushNamed(
                        //                     CategoryScreen.routeName,
                        //                   );*/
                        //               /*Navigator.of(context).pushNamedAndRemoveUntil(
                        //                   '/home-screen', (Route<dynamic> route) => false);*/
                        //               Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
                        //
                        //             },
                        //                 child: Center(
                        //                   child:Text(S .of(context).Shop_more,//'Shop more',
                        //                     style: TextStyle(color:Color(0xffff3333),fontSize: 12,fontWeight: FontWeight.w500,decoration: TextDecoration.none),),))])),
                        //   arrowTipDistance: 2,
                        //   minimumOutSidePadding: 10,
                        //   arrowLength: 8,
                        // )
                        //     :
                        // SimpleTooltip(
                        //
                        //   ballonPadding: EdgeInsets.symmetric(vertical: 3,horizontal: 5),
                        //   tooltipTap: (){
                        //     setState(() {
                        //       _showDeliveryinfo1 = !_showDeliveryinfo1;
                        //       _showDeliveryinfo = false;
                        //       _showDeliveryinfo2 = false;
                        //     });
                        //   },
                        //   //animationDuration: Duration(seconds: 3),
                        //   hideOnTooltipTap: true,
                        //   show:_showDeliveryinfo1 ,
                        //   arrowTipDistance: 0,
                        //   arrowLength: 5,
                        //   tooltipDirection: TooltipDirection.down,
                        //   child: IconButton(
                        //
                        //     padding: EdgeInsets.all(0),
                        //     icon:Icon(
                        //       Icons.help_outline,
                        //       size: 15,
                        //
                        //     ),onPressed: (){
                        //     setState(() {
                        //       _showDeliveryinfo1 = !_showDeliveryinfo1;
                        //       _showDeliveryinfo = false;
                        //       _showDeliveryinfo2 = false;
                        //     });
                        //   },),
                        //   content: Text(
                        //     S .of(context).Yay,
                        //     //'Yay!Free Delivery',
                        //     style: TextStyle(
                        //       fontSize: 12,
                        //       color: Colors.black54,
                        //       decoration: TextDecoration.none,
                        //     ),
                        //   ),
                        //   borderColor: Theme.of(context).primaryColor,
                        // )
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
              bool Toppingsexpresstime = false;
              for (int j = 0; j < newMap3!.values.elementAt(i).length; j++) {
                if(newMap3!.values.elementAt(i)[j].toppings_data!.length > 0){
                  Toppingsexpresstime = true;
                }
                SecondTimeTotal =_checkmembership? newMap3!.values.elementAt(i)[j].type == "1"?
                SecondTimeTotal+(double.parse(
                    (double.parse(newMap3!.values.elementAt(i)[j].membershipPrice!) * double.parse(newMap3!.values.elementAt(i)[j].weight!))
                        .toString()))
               : SecondTimeTotal+(double.parse(
                    (double.parse(newMap3!.values.elementAt(i)[j].membershipPrice!) * int.parse(newMap3!.values.elementAt(i)[j].quantity!))
                        .toString()))
                    :newMap3!.values.elementAt(i)[j].type == "1"?
                SecondTimeTotal+(double.parse(
                    (double.parse(newMap3!.values.elementAt(i)[j].price!) * double.parse(newMap3!.values.elementAt(i)[j].weight!))
                        .toString())):
                SecondTimeTotal+(double.parse(
                    (double.parse(newMap3!.values.elementAt(i)[j].price!) * int.parse(newMap3!.values.elementAt(i)[j].quantity!))
                        .toString()));
                note= newMap3!.values.elementAt(i)[j].note!;

              }
              if(Toppingsexpresstime){
                for (int k = 0; k < newMap3!.values.elementAt(i).length; k++) {
                  for (int l = 0; l <
                      newMap3!.values.elementAt(i)[k].toppings_data!.length; l++) {
                    newMap3!.values.elementAt(i)[k].type == "1"?
                    SecondTimeTotal = SecondTimeTotal+ (double.parse(newMap3!.values.elementAt(i)[k].toppings_data![l].price!) * double.parse(newMap3!.values.elementAt(i)[k].weight!))
                    :SecondTimeTotal = SecondTimeTotal+ double.parse(newMap3!.values.elementAt(i)[k].toppings_data![l].price! * int.parse(newMap3!.values.elementAt(i)[k].quantity!));
                  }
                }
              }else{
                SecondTimeTotal = SecondTimeTotal;
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
                        // (deliverychargetextTime != "FREE") ?
                        // SimpleTooltip(
                        //   maxHeight: MediaQuery.of(context).size.width * 24.7/100,
                        //   borderColor: Theme.of(context).primaryColor,
                        //   tooltipTap: ()
                        //   {
                        //     setState(() {
                        //       _showDeliveryinfo1 = !_showDeliveryinfo1;
                        //       _showDeliveryinfo = false;
                        //       _showDeliveryinfo2 = false;
                        //     }
                        //     );
                        //   },
                        //   hideOnTooltipTap: true,
                        //   show:_showDeliveryinfo1 ,
                        //   tooltipDirection: TooltipDirection.down,
                        //   ballonPadding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                        //   child:
                        //   IconButton(
                        //     padding: EdgeInsets.all(0),
                        //     icon:Icon(Icons.help_outline,size: 15,),
                        //     onPressed: (){
                        //       setState(() {
                        //         _showDeliveryinfo1 = !_showDeliveryinfo1;
                        //         _showDeliveryinfo = false;
                        //         _showDeliveryinfo2 = false;
                        //       }
                        //       );
                        //     },
                        //   ),
                        //   content: Container(
                        //       child:Column(
                        //           children:[
                        //             _checkmembership ? Text(S .of(context).Shop + " "//'Shop '
                        //                 +IConstants.currencyFormat + " "+ deliveryamounttext.toStringAsFixed(IConstants.decimaldigit) + " " + S .of(context).more_to_get,//' more to get free delivery',
                        //               style: TextStyle(
                        //                   fontWeight: FontWeight.w500,
                        //                   color:Colors.black,
                        //                   fontStyle: FontStyle.normal,
                        //                   fontSize: 12,
                        //                   decoration: TextDecoration.none
                        //               ),
                        //             )
                        //                 :
                        //             Text(S .of(context).Shop + " "//'Shop '
                        //                 + IConstants.currencyFormat+ deliveryamounttext.toStringAsFixed(IConstants.decimaldigit)+ " " + S .of(context).more_to_get,//' more to get free delivery',
                        //               style: TextStyle(
                        //                   fontWeight: FontWeight.w500,
                        //                   color:Colors.black,
                        //                   fontStyle: FontStyle.normal,
                        //                   fontSize: 12,
                        //                   decoration: TextDecoration.none
                        //               ),
                        //             ),
                        //             SizedBox(height: 3,),
                        //             GestureDetector(onTap:()
                        //             {
                        //               /*Navigator.of(context).pushNamed(
                        //                     CategoryScreen.routeName,
                        //                   );*/
                        //               /*Navigator.of(context).pushNamedAndRemoveUntil(
                        //                   '/home-screen', (Route<dynamic> route) => false);*/
                        //               Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
                        //
                        //             },
                        //                 child: Center(
                        //                   child:Text(S .of(context).Shop_more,//'Shop more',
                        //                     style: TextStyle(color:Color(0xffff3333),fontSize: 12,fontWeight: FontWeight.w500,decoration: TextDecoration.none),),))])),
                        //   arrowTipDistance: 2,
                        //   minimumOutSidePadding: 10,
                        //   arrowLength: 8,
                        // )
                        //     :
                        // SimpleTooltip(
                        //
                        //   ballonPadding: EdgeInsets.symmetric(vertical: 3,horizontal: 5),
                        //   tooltipTap: (){
                        //     setState(() {
                        //       _showDeliveryinfo1 = !_showDeliveryinfo1;
                        //       _showDeliveryinfo = false;
                        //       _showDeliveryinfo2 = false;
                        //     });
                        //   },
                        //   //animationDuration: Duration(seconds: 3),
                        //   hideOnTooltipTap: true,
                        //   show:_showDeliveryinfo1 ,
                        //   arrowTipDistance: 0,
                        //   arrowLength: 5,
                        //   tooltipDirection: TooltipDirection.down,
                        //   child: IconButton(
                        //
                        //     padding: EdgeInsets.all(0),
                        //     icon:Icon(
                        //       Icons.help_outline,
                        //       size: 15,
                        //
                        //     ),onPressed: (){
                        //     setState(() {
                        //       _showDeliveryinfo1 = !_showDeliveryinfo1;
                        //       _showDeliveryinfo = false;
                        //       _showDeliveryinfo2 = false;
                        //     });
                        //   },),
                        //   content: Text(
                        //     S .of(context).Yay,
                        //     //'Yay!Free Delivery',
                        //     style: TextStyle(
                        //       fontSize: 12,
                        //       color: Colors.black54,
                        //       decoration: TextDecoration.none,
                        //     ),
                        //   ),
                        //   borderColor: Theme.of(context).primaryColor,
                        // )
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


    Widget _deliveryTimeSlotText() {
      return Container(
        //height: MediaQuery.of(context).size.height * 0.11,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        color: ColorCodes.searchwebbackground,
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

    _buildBottomNavigationBar() {

      return _isLoading
          ? null
          : !_checkslots
          ? /*GestureDetector(
        onTap: () => {
          Fluttertoast.showToast(
              msg: S .of(context).currently_no_slot,//"currently there are no slots available",
            fontSize: MediaQuery.of(context).textScaleFactor *13,),
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.grey,
          height: 50.0,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child:
          Center(
            child: Text(
                S .of(context).confirm_order,//'CONFIRM ORDER',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),

          ),
        ),
      )*/
      BottomNaviagation(
        itemCount: CartCalculations.itemCount.toString() + " " + S .of(context).items,
        title: S .current.confirm_order,
        total: "1",/*(_groupValue == 1)?
        _checkmembership
            ?
            (Calculations.totalMember + finalSlotDelivery)
                .toStringAsFixed(IConstants.decimaldigit)
            :
            (Calculations.total + finalSlotDelivery).toStringAsFixed(IConstants.decimaldigit)
            :
        _checkmembership
            ?
            (Calculations.totalMember + finalExpressDelivery)
                .toStringAsFixed(IConstants.decimaldigit)
            :
            (Calculations.total + finalExpressDelivery).toStringAsFixed(IConstants.decimaldigit),*/
        onPressed: (){
          setState(() {
            Fluttertoast.showToast(
              msg: S .of(context).currently_no_slot,//"currently there are no slots available",
              fontSize: MediaQuery.of(context).textScaleFactor *13,);
          });
        },
      )
          : /*GestureDetector(
        onTap: () {
          if (_isChangeAddress) {
            Fluttertoast.showToast(
                msg: S .of(context).please_select_delivery_address,//"Please select delivery address!",
                fontSize: MediaQuery.of(context).textScaleFactor *13,
                backgroundColor: Colors.black87,
                textColor: Colors.white);
          } else {
            if (!_checkaddress) {
              Fluttertoast.showToast(msg: S .of(context).please_provide_address,//"Please provide a address",
                fontSize: MediaQuery.of(context).textScaleFactor *13,);
            }   else if((_groupValue == 1 ) || _groupValue == 2){

              prefs.setString("isPickup", "no");
              finalSlotDelivery=  deliveryamount + deliveryDateamount1 + deliveryTimeamount1;
              finalExpressDelivery= deliveryExpressamount + deliverySlotamount + deliveryfinalexpressdate + deliveryfinalexpressTime;

              final cartItemsData = Provider.of<CartItems>(context,listen: false);
              for(int i=0;i<cartItemsData.items.length;i++)
                if(cartItemsData.items.length == 1 && cartItemsData.items[0].mode == 1){
                  _deliveryChargeNormal="0";
                  _deliveryChargeExpress="0";
                  _deliveryChargePrime="0";
                }
              Navigator.of(context)
                  .pushNamed(PaymentScreen.routeName, arguments: {
                'minimumOrderAmountNoraml': _minimumOrderAmountNoraml,
                'deliveryChargeNormal': _deliveryChargeNormal,
                'minimumOrderAmountPrime': _minimumOrderAmountPrime,
                'deliveryChargePrime': _deliveryChargePrime,
                'minimumOrderAmountExpress': _minimumOrderAmountExpress,
                'deliveryChargeExpress': _deliveryChargeExpress,
                'deliveryType': (_groupValue == 1) ? "Default" : "OptionTwo",
                'note': _message.text,
                'deliveryCharge': (_groupValue == 1)? finalSlotDelivery.toString():finalExpressDelivery.toString(),
                'deliveryDurationExpress' : _deliveryDurationExpress,
              });
            }else {
              Fluttertoast.showToast(msg: S .of(context).pleasse_select_time_slot,  fontSize: MediaQuery.of(context).textScaleFactor *13,backgroundColor: Colors.black87, textColor: Colors.white);
            }
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: _isChangeAddress
              ? ColorCodes.greyColor
              : Theme.of(context).primaryColor,
          height: 50.0,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child:
          Center(
            child: Text(
              S .of(context).confirm_order,//'CONFIRM ORDER',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          )

        ),
      );*/
      BottomNaviagation(
        itemCount: CartCalculations.itemCount.toString() + " " + S .of(context).items,
        title: S .current.confirm_order,
        total: "1",
        onPressed: (){
          setState(() {
            if (_isChangeAddress) {
              Fluttertoast.showToast(
                  msg: S .of(context).please_select_delivery_address,//"Please select delivery address!",
                  fontSize: MediaQuery.of(context).textScaleFactor *13,
                  backgroundColor: Colors.black87,
                  textColor: Colors.white);
            }
            else if(PrefUtils.prefs!.getString('fixtime')! == "" && ((_groupValue==2 && something.length > 0 && Features.isSplit) || (_groupValue==1 && DefaultSlot.length > 0))){
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
                Fluttertoast.showToast(msg: S .of(context).please_provide_address,//"Please provide a address",
                  fontSize: MediaQuery.of(context).textScaleFactor *13,);
              }
              else if((_groupValue == 1 ) || _groupValue == 2){
                final cartItemsData = Provider.of<CartItems>(context,listen: false);
            final cartItemList =(VxState.store as GroceStore).CartItemList;
                if ((VxState.store as GroceStore).userData.membership=="1") {
                  _checkmembership = true;
                } else {
                  _checkmembership = false;
                }
                for (int i = 0; i < cartItemList.length; i++) {
                  if (cartItemList[i].mode == "1") {
                    _checkmembership = true;
                  }
                }

                if (_checkmembership) {
                    if (cartItemsData.items.length == 1 && cartItemsData.items[0].mode == 1) {
                      Navigation(context, name: Routename.PaymentScreen, navigatore: NavigatoreTyp.Push,
                          qparms: {
                            'minimumOrderAmountNoraml': _minimumOrderAmountNoraml,
                            'deliveryChargeNormal': _deliveryChargeNormal,
                            'minimumOrderAmountPrime': _minimumOrderAmountPrime,
                            'deliveryChargePrime': _deliveryChargePrime,
                            'minimumOrderAmountExpress': _minimumOrderAmountExpress,
                            'deliveryChargeExpress': _deliveryChargeExpress,
                            'deliveryType': (_groupValue == 1) ? "Default" : "OptionTwo",
                            'addressId': PrefUtils.prefs!.getString("addressId"),
                            'note': _message.text,
                            'deliveryCharge': (_groupValue == 1)? finalSlotDelivery.toString():finalExpressDelivery.toString(),
                            'deliveryDurationExpress' : _deliveryDurationExpress,
                            'fromScreen':'',
                            'responsejson':"",
                          });
                    }
                    else if ((double.parse((CartCalculations.totalMember).toStringAsFixed(
                        (IConstants.numberFormat == "1")
                            ?0:IConstants.decimaldigit)) <
                        double.parse(IConstants.minimumOrderAmount)) && cartItemList.length != 1){
                      dialogforMinimumOrder();
                    }

                    else{
                      prefs!.setString("isPickup", "no");
                      finalSlotDelivery=  deliveryamount + deliveryDateamount1 + deliveryTimeamount1;
                      finalExpressDelivery= deliveryExpressamount + deliverySlotamount + deliveryfinalexpressdate + deliveryfinalexpressTime;


                      final cartItemsData = Provider.of<CartItems>(context,listen: false);
                      for(int i=0;i<cartItemsData.items.length;i++)
                        if(cartItemsData.items.length == 1 && cartItemsData.items[0].mode == 1){
                          _deliveryChargeNormal="0";
                          _deliveryChargeExpress="0";
                          _deliveryChargePrime="0";
                        }
                      Navigation(context, name: Routename.PaymentScreen, navigatore: NavigatoreTyp.Push,
                          qparms: {
                            'minimumOrderAmountNoraml': _minimumOrderAmountNoraml,
                            'deliveryChargeNormal': _deliveryChargeNormal,
                            'minimumOrderAmountPrime': _minimumOrderAmountPrime,
                            'deliveryChargePrime': _deliveryChargePrime,
                            'minimumOrderAmountExpress': _minimumOrderAmountExpress,
                            'deliveryChargeExpress': _deliveryChargeExpress,
                            'deliveryType': (_groupValue == 1) ? "Default" : "OptionTwo",
                            'addressId': PrefUtils.prefs!.getString("addressId"),
                            'note': _message.text,
                            'deliveryCharge': (_groupValue == 1)? finalSlotDelivery.toString():finalExpressDelivery.toString(),
                            'deliveryDurationExpress' : _deliveryDurationExpress,
                            'fromScreen':'',
                            'responsejson':"",
                      });
                    }
                  }
                  else
                  {
                    if (cartItemsData.items.length == 1 && cartItemsData.items[0].mode == 1) {
                      Navigation(context, name: Routename.PaymentScreen, navigatore: NavigatoreTyp.Push,
                          qparms: {
                            'minimumOrderAmountNoraml': _minimumOrderAmountNoraml,
                            'deliveryChargeNormal': _deliveryChargeNormal,
                            'minimumOrderAmountPrime': _minimumOrderAmountPrime,
                            'deliveryChargePrime': _deliveryChargePrime,
                            'minimumOrderAmountExpress': _minimumOrderAmountExpress,
                            'deliveryChargeExpress': _deliveryChargeExpress,
                            'deliveryType': (_groupValue == 1) ? "Default" : "OptionTwo",
                            'addressId': PrefUtils.prefs!.getString("addressId"),
                            'note': _message.text,
                            'deliveryCharge': (_groupValue == 1)? finalSlotDelivery.toString():finalExpressDelivery.toString(),
                            'deliveryDurationExpress' : _deliveryDurationExpress,
                            'fromScreen':'',
                            'responsejson':"",
                          });
                    }
                    else if (double.parse((CartCalculations.total).toStringAsFixed(
                        IConstants.numberFormat == "1"?0:IConstants.decimaldigit)) <
                        double.parse(IConstants.minimumOrderAmount)) {
                      dialogforMinimumOrder();
                    }else{
                      prefs!.setString("isPickup", "no");
                      finalSlotDelivery=  deliveryamount + deliveryDateamount1 + deliveryTimeamount1;
                      finalExpressDelivery= deliveryExpressamount + deliverySlotamount + deliveryfinalexpressdate + deliveryfinalexpressTime;

                      final cartItemsData = Provider.of<CartItems>(context,listen: false);
                      for(int i=0;i<cartItemsData.items.length;i++)
                        if(cartItemsData.items.length == 1 && cartItemsData.items[0].mode == 1){
                          _deliveryChargeNormal="0";
                          _deliveryChargeExpress="0";
                          _deliveryChargePrime="0";
                        }
                 /*     Navigator.of(context)
                          .pushNamed(PaymentScreen.routeName, arguments: {
                        'minimumOrderAmountNoraml': _minimumOrderAmountNoraml,
                        'deliveryChargeNormal': _deliveryChargeNormal,
                        'minimumOrderAmountPrime': _minimumOrderAmountPrime,
                        'deliveryChargePrime': _deliveryChargePrime,
                        'minimumOrderAmountExpress': _minimumOrderAmountExpress,
                        'deliveryChargeExpress': _deliveryChargeExpress,
                        'deliveryType': (_groupValue == 1) ? "Default" : "OptionTwo",
                        'addressId': PrefUtils.prefs!.getString("addressId"),
                        'note': _message.text,
                        'deliveryCharge': (_groupValue == 1)? finalSlotDelivery.toString():finalExpressDelivery.toString(),
                        'deliveryDurationExpress' : _deliveryDurationExpress,
                      });*/
                      Navigation(context, name: Routename.PaymentScreen, navigatore: NavigatoreTyp.Push,
                          qparms: {
                            'minimumOrderAmountNoraml': _minimumOrderAmountNoraml,
                            'deliveryChargeNormal': _deliveryChargeNormal,
                            'minimumOrderAmountPrime': _minimumOrderAmountPrime,
                            'deliveryChargePrime': _deliveryChargePrime,
                            'minimumOrderAmountExpress': _minimumOrderAmountExpress,
                            'deliveryChargeExpress': _deliveryChargeExpress,
                            'deliveryType': (_groupValue == 1) ? "Default" : "OptionTwo",
                            'addressId': PrefUtils.prefs!.getString("addressId"),
                            'note': _message.text,
                            'deliveryCharge': (_groupValue == 1)? finalSlotDelivery.toString():finalExpressDelivery.toString(),
                            'deliveryDurationExpress' : _deliveryDurationExpress,
                            'fromScreen':'',
                            'responsejson':"",
                          });
                    }
                  }
              }
              // else {
              //   Fluttertoast.showToast(msg: S .of(context).pleasse_select_time_slot,  fontSize: MediaQuery.of(context).textScaleFactor *13,backgroundColor: Colors.black87, textColor: Colors.white);
              // }
            }
          });
        },
      );
    }


    void _settingModalBottomSheet(context, String from) {
      showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0),topRight: Radius.circular(15.0)),
          ),
          context: context,
          builder: (BuildContext bc) {
            return VxBuilder(
                mutations: {SetAddress,SetUserData},
                builder: (ctx, store,VxStatus? state) {
                addressdata = store!.userData;

                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter state) {
                      return SingleChildScrollView(
                          child: InkWell(
                              onTap: () {},
                              child: Container(
                                  margin:
                                  EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                  child: Column(
                                      //mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:[
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 0,top: 10),
                                          child: Container(
                                            child: Text(
                                                                S .of(context).choose_delivery_address,//"Choose a delivery address",
                                                                style: TextStyle(
                                                                    fontSize: 18.0,
                                                                    fontWeight: FontWeight.bold),
                                                              ),
                                          ),
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
                                                      addsId = prefs!.getString("addressId")!;
                                                    });
                                                    if (from == "selectAddress") {
                                                      Navigator.of(context).pop();
                                                      _dialogforProcessing();

                                                      cartCheck(
                                                          prefs!.getString("addressId")!,
                                                          addressdata!.billingAddress![i].id.toString(),
                                                          addressdata!.billingAddress![i].addressType!,
                                                          addressdata!.billingAddress![i].address!,
                                                          addressdata!.billingAddress![i].addressicon!,
                                                          addressdata!.billingAddress![i].fullName,

                                                      );

                                                    } else {
                                                      Navigator.of(context).pop();
                                                      if (addsId != /*addressitemsData.items[i].userid*/addressdata!.billingAddress![i].id) {
                                                        _dialogforProcessing();
                                                        cartCheck(
                                                            prefs!.getString("addressId")!,
                                                            addressdata!.billingAddress![i].id.toString(),
                                                            addressdata!.billingAddress![i].addressType!,
                                                            addressdata!.billingAddress![i].address!,
                                                            addressdata!.billingAddress![i].addressicon!,
                                                            addressdata!.billingAddress![i].fullName,

                                                        );
                                                      } else {
                                                        setState(() {
                                                          _checkaddress = true;
                                                          addtype =
                                                              addressdata!.billingAddress![i].addressType;
                                                          address =
                                                          addressdata!.billingAddress![i].address!;
                                                          name = addressdata!.billingAddress![i].fullName!;
                                                          addressicon =
                                                              addressdata!.billingAddress![i].addressicon;
                                                          prefs!.setString("addressId",
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
                                                      SizedBox(
                                                        width: 10.0,
                                                      ),
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
                                                                  color: ColorCodes.blackColor/*Theme.of(context)
                                                                      .primaryColor*/,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 14.0),
                                                            ),
                                                            SizedBox(
                                                              height: 5.0,
                                                            ),
                                                            Text(
                                                              addressdata!.billingAddress![i].address!,
                                                              style: TextStyle(
                                                                color: Colors.grey,
                                                                fontSize: 12.0,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10.0,
                                                            ),
                                                            Divider(
                                                              color: Colors.grey,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(width: 20.0),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        GestureDetector(
                                          onTap: () async {
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
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom:5.0),
                                            child: Container(
                                                width: MediaQuery.of(context).size.width,
                                                height: 50.0,
                                                margin: EdgeInsets.only(
                                                  left: 10.0, top: 5.0, right: 10.0, ),
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context).primaryColor,
                                                    borderRadius: BorderRadius.circular(12.0),
                                                    border: Border(
                                                      top: BorderSide(width: 1.0, color: Theme.of(context).primaryColor,),
                                                      bottom: BorderSide(width: 1.0, color: Theme.of(context).primaryColor,),
                                                      left: BorderSide(width: 1.0, color: Theme.of(context).primaryColor,),
                                                      right: BorderSide(width: 1.0, color: Theme.of(context).primaryColor,),
                                                    )),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                S .of(context).add_new_address,//'Save & Proceed',
                                                      style: TextStyle(
                                                          color: Colors.white, fontSize: 18.0),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        ),
                                        // GestureDetector(
                                        //   onTap: () {
                                        //     Navigation(context, name: Routename.AddressScreen, navigatore: NavigatoreTyp.Push,
                                        //         qparms: {
                                        //           'addresstype': "new",
                                        //           'addressid': "",
                                        //           'delieveryLocation': "",
                                        //           'latitude': "",
                                        //           'longitude': "",
                                        //           'branch': "",
                                        //         });
                                        //   },
                                        //   child: Row(
                                        //     children: <Widget>[
                                        //       SizedBox(
                                        //         width: 10.0,
                                        //       ),
                                        //       Icon(
                                        //         Icons.add,
                                        //         color: Colors.orange,
                                        //       ),
                                        //       SizedBox(
                                        //         width: 10.0,
                                        //       ),
                                        //       Expanded(
                                        //         child: Column(
                                        //           crossAxisAlignment: CrossAxisAlignment.start,
                                        //           children: <Widget>[
                                        //             SizedBox(
                                        //               height: 15.0,
                                        //             ),
                                        //             Text(
                                        //               S .of(context).add_new_address,//"Add new Address",
                                        //               style: TextStyle(
                                        //                   color: Colors.orange, fontSize: 16.0),
                                        //             ),
                                        //             SizedBox(
                                        //               height: 15.0,
                                        //             ),
                                        //           ],
                                        //         ),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                     ]
                                      ))));
                    });
              }
            );
          });
    }

    StandardDelivery() {

      return
        Container(
          color: ColorCodes.whiteColor,
          padding: EdgeInsets.only(left: 20,right: 20),
          child: Column(
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
          ),
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

    /*SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xff95552b),
      //statusBarIconBrightness: Brightness.dark,//or set color with: Color(0xFF0000FF)
    ));*/
    return WillPopScope(
      onWillPop: () {
        // this is the block you need
        /* Navigator.pushNamedAndRemoveUntil(
            context, CartScreen.routeName, (route) => false);*/
        removeToCart();
        // Navigator.of(context).pop();
       /* Navigator.of(context).pushReplacementNamed(CartScreen.routeName,arguments: {
          "afterlogin": ""
        });*/
        //Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
        //Navigation(context, navigatore: NavigatoreTyp.Pop);
        if(widget.prev["prev"].toString() == "cart_screen") {
          PrefUtils.prefs!.setString("confirmback", "yes");
          Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":""});
        }
        else{
          // Navigation(context, navigatore: NavigatoreTyp.Pop);
          Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":""});
        }
        return Future.value(false);
      },
      child: Scaffold(
        appBar: (_checkaddress)?
        gradientappbarmobile():null,
        backgroundColor: ColorCodes.whiteColor,
        body: _loading
            ? Center(
          child:
          CheckOutShimmer(), //CircularProgressIndicator( valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor,),

        )
            :
        SingleChildScrollView(
          child: Container(
            // height: MediaQuery.of(context).size.height,
            color: ColorCodes.whiteColor,
            // padding: EdgeInsets.only(left: 10.0, top: 10.0, ),
            child: Column(
              children: <Widget>[
                SizedBox(height: 15,),
                !_isChangeAddress?
                _checkaddress
                    ?
                //   Card(
                  // elevation: 5,
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(2),
                  // ),
                  // child:
                  Column(
                    children: [
                      Container(
                        color: ColorCodes.whiteColor,
                        padding: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      // (addtype == "home")? Image.asset(Images.homeConfirm,
                                      //   height: 30,
                                      //   width: 30,
                                      //   color: ColorCodes.greenColor,
                                      // ):(addtype == "Work")?Image.asset(Images.workConfirm,
                                      //   height: 30,
                                      //   width: 30,
                                      //   color: ColorCodes.greenColor,
                                      // ):Image.asset(Images.otherConfirm,
                                      //   height: 30,
                                      //   width: 30,
                                      //   color: ColorCodes.greenColor,
                                      // ),
                                      // SizedBox(width: 10,),
                                      Text(
                                        S .of(context).select_delivery_address,//"Select delivery address",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                            color: ColorCodes.blackColor),
                                      ),
                                    ],
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
                                          //SizedBox(width: 40,),
                                          (addtype == "home")? Image.asset(Images.homeConfirm,
                                            height: 25,
                                            width: 30,
                                            color: ColorCodes.greenColor,
                                          ):(addtype == "Work")?Image.asset(Images.workConfirm,
                                            height: 25,
                                            width: 30,
                                            color: ColorCodes.greenColor,
                                          ):Image.asset(Images.otherConfirm,
                                            height: 25,
                                            width: 30,
                                            color: ColorCodes.greenColor,
                                          ),
                                          SizedBox(width: 10,),
                                          Expanded(
                                            child: Text(
                                              name,
                                              style: TextStyle(
                                                color: ColorCodes.blackColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0,
                                              ),
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
                                                      fontSize: 13.0),
                                                ),
                                              )),
                                        ],
                                      ),
                                      //  Spacer(),

                                      // SizedBox(width: 40,),

                                    ],
                                  ),
                                  SizedBox(height: 3,),
                                  Row(
                                    children: [
                                      SizedBox(width: 40,),
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
                      SizedBox(height: 10,),
                      ListTile(
                        dense:true,
                        contentPadding: EdgeInsets.only(left: 10.0),
                        leading: Image.asset(Images.request,
                          height: 30,
                          width: 30,
                          color: ColorCodes.greenColor,
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
                  )
                //)
                   :
                //     Card(
                //   elevation: 5,
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(2),
                //   ),
                //   child:
                  Column(
                    children: [
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 5.0,
                          ),
                          Spacer(),
                          FlatButton(
                            color: Theme.of(context).primaryColor,
                            textColor: Theme.of(context).buttonColor,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(3.0),
                            ),
                            onPressed: () {
                     /*         Navigator.of(context).pushReplacementNamed(
                                  AddressScreen.routeName,
                                  arguments: {
                                    'addresstype': "new",
                                    'addressid': "",
                                    'delieveryLocation': "",
                                    'latitude': "",
                                    'longitude': "",
                                    'branch': ""
                                  })*/
                              PrefUtils.prefs!.setString("addressbook", "confirmorder");
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
                            child: Text(
                              S .of(context).add_address,//'Add Address',
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                        ],
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
                  )
                //)
                    :
                // Card(
                //   elevation: 5,
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(2),
                //   ),
                //   child:
                  Column(
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
                                        43 /
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
                                /*    Navigator.of(context).pushReplacementNamed(
                                        AddressScreen.routeName,
                                        arguments: {
                                          'addresstype': "new",
                                          'addressid': "",
                                          'delieveryLocation': "",
                                          'latitude': "",
                                          'longitude': "",
                                          'branch': ""
                                        });*/
                                    PrefUtils.prefs!.setString("addressbook", "confirmorder");
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
                                      Navigation(context,
                                          name: Routename.AddressScreen,
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
                                        .width * 43 / 100,
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
                //),
                SizedBox(
                  height: 10.0,
                ),

                Container(
                  height:5,
                  color: ColorCodes.backgroundcolor,
                ),
                //SizedBox(height: 8.0,),
                /*  Divider(
                  color: ColorCodes.lightGreyColor,
                ),*/
                //SizedBox(height: 8.0,),


                // Delivery time slot banner with text
                //  _deliveryTimeSlotText(),

                if (!_isChangeAddress)
                  !_slotsLoading
                      ? _checkslots?
                  //  ? Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  //    crossAxisAlignment: CrossAxisAlignment.start,
                  //    children: <Widget>[
                  // VxBuilder(
                  // mutations: {SetCartItem},
                  //    builder: (context,store,state){

                       // Card(
                       //   elevation: 5,
                       //   child:
                         Column(
                           children: [
                             SizedBox(height: 20,),
                             (ExpressDetails.length <= 0)?  SizedBox.shrink(): Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 SizedBox(width: 5,),
                                 GestureDetector(
                                   onTap: (){
                                     setState(() {
                                       visiblestand = true;
                                       visibleexpress = false;
                                       dividerSlot = ColorCodes.primaryColor;
                                       dividerExpress = ColorCodes.whiteColor;
                                       ContainerSlot = ColorCodes.varcolor;
                                       ContainerExpress = ColorCodes.whiteColor;
                                       _groupValue = 1;
                                     });

                                   },
                                   child: Card(
                                     child: Container(
                                       height: 160,
                                       width: 160,
                                       decoration: BoxDecoration(
                                           color: ContainerSlot,
                                           border: Border(
                                             bottom: BorderSide(width: 3.0, color: dividerSlot),
                                           )),

                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         crossAxisAlignment: CrossAxisAlignment.center,
                                         children: [
                                           Image.asset(Images.Standard,
                                             height: 40,
                                             width: 40,
                                             color: ColorCodes.greenColor,
                                           ),
                                           SizedBox(height: 10,),
                                           Text(S .of(context).slot_based_delivery,
                                             style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: ColorCodes.cartgreenColor),
                                           ),
                                           SizedBox(height: 5,),
                                           Text(" \n ",textAlign: TextAlign.center, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: ColorCodes.greyColor),),

                                         ],
                                       ),
                                     ),
                                   ),
                                 ),
                                 //Spacer(),
                                 GestureDetector(
                                   onTap: (){
                                     setState(() {
                                       visibleexpress = true;
                                       visiblestand = false;
                                       dividerSlot = ColorCodes.whiteColor;
                                       dividerExpress = ColorCodes.primaryColor;
                                       ContainerSlot = ColorCodes.whiteColor;
                                       ContainerExpress = ColorCodes.varcolor;
                                       _groupValue = 2;
                                     });

                                   },
                                   child: Card(
                                     child:  Container(
                                       height: 160,
                                       width: 160,
                                       decoration: BoxDecoration(
                                           color: ContainerExpress,
                                           border: Border(
                                             bottom: BorderSide(width: 3.0, color: dividerExpress),
                                           )),

                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         crossAxisAlignment: CrossAxisAlignment.center,
                                         children: [
                                           Image.asset(Images.express,
                                             height: 40,
                                             width: 40,
                                             color: ColorCodes.greenColor,
                                           ),
                                           SizedBox(height: 10,),
                                           Text(S .of(context).express_delivery,
                                             style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: ColorCodes.cartgreenColor),
                                           ),
                                           SizedBox(height: 5,),
                                           Text(S .of(context).delivery_in+" "+_deliveryDurationExpress, textAlign: TextAlign.center,style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: ColorCodes.greyColor),),
                                         ],
                                       ),
                                     ),
                                   ),
                                 ),
                                 SizedBox(width: 5,),
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
                         )

                       //)
                  //    },
                  // )
                  /* GestureDetector(
                           behavior: HitTestBehavior.translucent,
                           onTap: () {
                             setState(() {
                               _groupValue = 1;
                             });
                           },
                           child: ListTile(
                             dense: true,
                             leading:  Container(
                               child: _myRadioButton(
                                 value: 1,
                                 onChanged: (newValue) {
                                   setState(() {
                                     _groupValue = newValue;
                                   });
                                 },
                               ),
                             ),
                             contentPadding: EdgeInsets.all(0.0),
                             title:  Row(
                               children: [
                                 Container(
                                   width: MediaQuery.of(context).size.width * 50 /100,
                                   child: Text(
                                   S .of(context).slot_based_delivery,//'Slot Based Delivery',
                                       style: TextStyle(
                                           color: ColorCodes.blackColor,
                                           fontSize: 16, fontWeight: FontWeight.bold
                                       )
                                   ),
                                 ),

                               ],
                             ),
                           ),
                         ),
                         (_groupValue == 1)?
                         Container(
                           color: ColorCodes.whiteColor,
                           padding: EdgeInsets.only(left: 20,right: 20),
                           child: Column(
                             children: [
                               SizedBox(height: 5,),
                               (DefaultSlot.length > 0) ?
                               Column(
                                 children: [
                                   SizedBox(height: 5,),
                                   Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [
                                          Text(
                                         S .of(context).shipment +" "//"Shipment "
                                             +(count++).toString(),//Slot Based Delivery",
                                         style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),
                                       ),
                                       Text(S .of(context).slot_based_delivery,
                                         style: TextStyle(fontSize: 14,
                                             fontWeight: FontWeight.w400,
                                             color: Theme.of(context).primaryColor
                                         ),
                                       ),
                                       GestureDetector(
                                         behavior: HitTestBehavior.translucent,
                                         onTap: (){
                                           dialogforViewAllProductDefaultSlot();
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
                                   ),
                                   Row(
                                     children: [

                                       Text(
                                         S .of(context).delivery_charge,//"Delivery Charge: ",
                                         style: TextStyle(
                                             color: ColorCodes.blackColor,
                                             fontSize: 10, fontWeight: FontWeight.w400
                                         ),),
                                       SizedBox(width: 2,),
                                       Text(
                                         deliverychargetextdefault
                                         ,style: TextStyle(
                                         color: (deliverychargetextdefault == "FREE")? ColorCodes.blackColor:
                                         ColorCodes.blackColor,
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

                                             fontSize: 14, fontWeight: FontWeight.w400
                                         ),),
                                     ],
                                   ),
                                   SizedBox(height: 5,),
                                   SelectDate(),
                                   SizedBox(height: 5,),
                                   Divider(thickness: 1,color: ColorCodes.greyColor,),
                                 ],
                               ):
                               SizedBox.shrink(),


                               ShipmentfirstdateDelivery(),

                               ShipmentfirsttimeDelivery(),
                               SizedBox(height: 10,),

                             ],
                           ),
                         )
                             :SizedBox.shrink(),
                         (ExpressDetails.length >0)?
                         GestureDetector(
                           behavior: HitTestBehavior.translucent,
                           onTap: () {
                             setState(() {

                               _groupValue = 2;

                             });
                           },
                           child: ListTile(
                             dense: true,
                             contentPadding: EdgeInsets.all(0.0),
                             leading: Container(
                               child: _myRadioButton(
                                 value: 2,
                                 onChanged: (newValue) {
                                   setState(() {
                                     _groupValue = newValue;
                                   });
                                 },
                               ),
                             ),
                             title:
                             Row(
                               children: [
                                 Container(

                                   child: Text(
                                      S .of(context).express_delivery,//'Express Delivery',
                                       style: TextStyle(
                                           color: ColorCodes.blackColor,
                                           fontSize: 16, fontWeight: FontWeight.bold
                                       )
                                   ),
                                 ),

                               ],
                             ),
                           ),
                         ) : SizedBox.shrink(),
                         (_groupValue == 2)?
                         Container(
                           color: ColorCodes.searchwebbackground,
                           padding: EdgeInsets.only(left: 20,right: 20),
                           child: Column(
                             children: [
                               SizedBox(height: 5,),
                               (something.length > 0) ?
                               Column(
                                 children: [
                                   SizedBox(height: 5,),
                                   Row(
                                     children: [
                                        Text(
                                         S .of(context).shipment//"Shipment "
                                             + (countTime++).toString()+": "+ S .of(context).slot_based_delivery,//Slot Based Delivery",
                                         style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),
                                       ),
                                       Spacer(),
                                       GestureDetector(
                                         behavior: HitTestBehavior.translucent,
                                         onTap: (){
                                           dialogforViewAllProductSecond();
                                         },
                                         child: Container(
                                           padding: EdgeInsets.only(left: 5,right: 5),
                                           decoration: BoxDecoration(
                                               color: Color(0xffEBECF0),
                                               borderRadius: BorderRadius.circular(3),
                                               border: Border(
                                                 top: BorderSide(width: 1.0, color: ColorCodes.greyColor,),
                                                 bottom: BorderSide(width: 1.0, color: ColorCodes.greyColor,),
                                                 left: BorderSide(width: 1.0, color: ColorCodes.greyColor,),
                                                 right: BorderSide(width: 1.0, color: ColorCodes.greyColor,),
                                               )
                                           ),
                                           height: 20,
                                           child: Center(
                                             child: Text(
                                               S .of(context).view//"View "
                                                   + something.length.toString()+" "+
                                                   S .of(context).items ,//"Items",
                                               style: TextStyle(
                                                   color: ColorCodes.blackColor,
                                                   fontSize: 11
                                               ),
                                             ),
                                           ),
                                         ),
                                       ),
                                     ],
                                   ),
                                   SizedBox(height: 10,),
                                   Row(
                                     children: [
                                       Text(
                                         S .of(context).select_TimeSlot,//"Delivery Charge: ",
                                         style: TextStyle(

                                             fontSize: 14, fontWeight: FontWeight.w400
                                         ),),
                                     ],
                                   ),
                                   SizedBox(height: 5,),
                                   SelectDate(),
                                   SizedBox(height: 5,),
                                   Divider(thickness: 1,color: ColorCodes.greyColor,),
                                   Row(
                                     children: [

                                       Text(
                                        S .of(context).delivery_charge,//"Delivery Charge: ",
                                         style: TextStyle(
                                           color: ColorCodes.blackColor,
                                           fontSize: 10, fontWeight: FontWeight.w400
                                       ),),
                                       SizedBox(width: 2,),
                                       Text(
                                         deliverychargetextSecond
                                         ,style: TextStyle(
                                         color: (deliverychargetextSecond == "FREE")? ColorCodes.blackColor:
                                         ColorCodes.blackColor,
                                         fontSize: 10,
                                       ),)
                                       ,
                                     ],
                                   ),
                                   SizedBox(height: 10,),
                                 ],
                               ):
                               SizedBox.shrink(),
                               Divider(thickness: 1,color: ColorCodes.greyColor,),
                               (ExpressDetails.length >0)?
                               Column(
                                 children: [
                                   Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [
                                       (ExpressDetails.length >0)?   Text(
                                         S .of(context).shipment//"Shipment "
                                             + (countTime++).toString() ,//Express Delivery",
                                         style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),
                                       ):SizedBox.shrink(),
                                     Text( S .of(context).express_delivery,
                                         style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: ColorCodes.primaryColor)),
                                       GestureDetector(
                                         behavior: HitTestBehavior.translucent,
                                         onTap: (){
                                           dialogforViewAllProductExpress();
                                         },
                                         child: Container(
                                           padding: EdgeInsets.only(left: 5,right: 5),
                                           decoration: BoxDecoration(
                                               color: Color(0xffEBECF0),
                                               borderRadius: BorderRadius.circular(3),
                                               border: Border(
                                                 top: BorderSide(width: 1.0, color: ColorCodes.darkgreen,),
                                                 bottom: BorderSide(width: 1.0, color: ColorCodes.darkgreen,),
                                                 left: BorderSide(width: 1.0, color: ColorCodes.darkgreen,),
                                                 right: BorderSide(width: 1.0, color: ColorCodes.darkgreen,),
                                               )
                                           ),
                                           height: 20,
                                           child: Center(
                                             child: Text(
                                               S .of(context).view//"View "
                                                   + ExpressDetails.length.toString()+" "+
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
                                           color: ColorCodes.blackColor,
                                           fontSize: 10, fontWeight: FontWeight.w400
                                       ),),
                                       SizedBox(width: 2,),
                                       Text(
                                         (deliverychargetextExpress)
                                         ,style: TextStyle(
                                         color: (deliverychargetextExpress == "FREE")? ColorCodes.blackColor:
                                         ColorCodes.blackColor,
                                         fontSize: 10,
                                       ),)
                                       ,
                                     ],
                                   ),
                                   SizedBox(height: 10,),
                                   Divider(thickness: 1,color: ColorCodes.greyColor,),
                                 ],
                               ):
                               SizedBox.shrink(),

                               (newMap2 != null)?ShipmentTwoDelivery():SizedBox.shrink(),
                               (newMap3 != null)?ShipmentThreeDelivery():SizedBox.shrink(),

                             ],
                           ),
                         )
                             :SizedBox.shrink(),*/
                  //
                  //   ],
                  // )
                      : Row(
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
                      : Center(
                    child: CircularProgressIndicator(),
                  )
              ],
            ),
          ),
        ),

        bottomNavigationBar:(_checkaddress && !_loading)? (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)) ? SizedBox.shrink() :Container(
          color: Colors.white,
          child: Padding(
              padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
              child: _buildBottomNavigationBar()
          ),
        ):null,
      ),
    );

  }
/*Widget _customScroll(){
  NestedScrollView(
    physics: NeverScrollableScrollPhysics(),
    headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
      return <Widget>[
        SliverAppBar(
            pinned: false,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            expandedHeight: MediaQuery.of(context).size.height*0.4,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  !_isChangeAddress
                      ? _checkaddress
                      ? Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Select delivery address",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: ColorCodes.blackColor),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                address,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 40.0,
                        ),
                        GestureDetector(
                            onTap: () {
                              _settingModalBottomSheet(
                                  context, "change");
                            },
                            child: Text(
                              "CHANGE",
                              style: TextStyle(
                                //decoration: TextDecoration.underline,
                                  decorationStyle:
                                  TextDecorationStyle.dashed,
                                  color: ColorCodes.mediumBlueColor,
                                  fontSize: 12.0),
                            )),
                        SizedBox(
                          width: 10.0,
                        ),
                      ],
                    ),
                  )
                      : Row(
                    children: <Widget>[
                      SizedBox(
                        width: 5.0,
                      ),
                      Spacer(),
                      FlatButton(
                        color: Theme
                            .of(context)
                            .primaryColor,
                        textColor: Theme
                            .of(context)
                            .buttonColor,
                        shape: new RoundedRectangleBorder(
                          borderRadius:
                          new BorderRadius.circular(3.0),
                        ),
                        onPressed: () =>
                        {
                          Navigator.of(context).pushNamed(
                              AddressScreen.routeName,
                              arguments: {
                                'addresstype': "new",
                                'addressid': "",
                              })
                        },
                        child: Text(
                          'Add Address',
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                    ],
                  )
                      : Container(
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
                                    "You are in a new location!",
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
                                    43 /
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
                                          .accentColor,),
                                      bottom: BorderSide(
                                        width: 1.0, color: Theme
                                          .of(context)
                                          .accentColor,),
                                      left: BorderSide(width: 1.0, color: Theme
                                          .of(context)
                                          .accentColor,),
                                      right: BorderSide(width: 1.0, color: Theme
                                          .of(context)
                                          .accentColor,),
                                    )),
                                height: 40.0,
                                child: Center(
                                  child: Text(
                                    'Select Address',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color:
                                      Theme
                                          .of(context)
                                          .accentColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pushNamed(
                                    AddressScreen.routeName,
                                    arguments: {
                                      'addresstype': "new",
                                      'addressid': "",
                                      'delieveryLocation': "",
                                      'latitude': "",
                                      'longitude': "",
                                      'branch': ""
                                    });
                              },
                              child: Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 43 / 100,
                                margin: EdgeInsets.only(
                                    left: 5.0, right: 10.0, bottom: 10.0),
                                decoration: BoxDecoration(
                                    color: Theme
                                        .of(context)
                                        .accentColor,
                                    borderRadius:
                                    BorderRadius.circular(5.0),
                                    border: Border(
                                      top: BorderSide(width: 1.0, color:
                                      Theme
                                          .of(context)
                                          .accentColor,
                                      ),
                                      bottom: BorderSide(
                                        width: 1.0,
                                        color:
                                        Theme
                                            .of(context)
                                            .accentColor,
                                      ),Opacity(opacity: 0.0,child: Container(
                      height: 2,
                      child: TabBar(
                        controller: _tabController,
                        labelColor: ColorCodes.whiteColor,
                        indicatorColor: ColorCodes.whiteColor,
                        unselectedLabelColor:
                        ColorCodes.whiteColor,
                        labelStyle: TextStyle(
                          fontSize: 0,
                          fontWeight: FontWeight.bold,
                        ),
                        tabs: [
                          Tab(text: 'SLOT BASED DELIVERY'),
                          Tab(
                            text: 'EXPRESS DELIVERY',
                          ),
                        ],
                      ),
                    ),),

                                      left: BorderSide(
                                        width: 1.0,
                                        color:
                                        Theme
                                            .of(context)
                                            .accentColor,
                                      ),
                                      right: BorderSide(
                                        width: 1.0,
                                        color:
                                        Theme
                                            .of(context)
                                            .accentColor,
                                      ),
                                    )),
                                height: 40.0,
                                child: Center(
                                  child: Text(
                                    'Add Address',
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
                  SizedBox(
                    height: 10.0,
                  ),
                  //SizedBox(height: 8.0,),
                  Divider(
                    color: ColorCodes.lightGreyColor,
                  ),
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.only(left: 10.0),
                    leading: Icon(Icons.list_alt_outlined,
                        color: ColorCodes.lightGreyColor),
                    title: Transform(
                      transform: Matrix4.translationValues(-16, 0.0, 0.0),
                      child: TextField(
                        controller: _message,
                        decoration: InputDecoration.collapsed(
                            hintText: "Any request? We promise to pass it on",
                            hintStyle: TextStyle(fontSize: 12.0),
                            fillColor:  ColorCodes.lightGreyColor),
                        //minLines: 3,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),

                  // Delivery time slot banner with text
                  _deliveryTimeSlotText(),
                ],
              ),
            ),

            bottom: TabBar(
              physics: NeverScrollableScrollPhysics(),
              indicatorColor: Colors.white,
              labelColor: Colors.black,
              unselectedLabelColor:
              ColorCodes.lightGreyColor,
              labelStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              tabs: [
                Tab(text: 'SLOT BASED DELIVERY'),
                Tab(text: 'EXPRESS DELIVERY',),

              ],
              controller: _tabController,
            )
        )
      ];
    },
    body: NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        //this is for removing scroll glow of listview
        overscroll.disallowGlow();
      },
      child: Container(
        height: MediaQuery
            .of(context)
            .size
            .height*0.5,
        color: ColorCodes.whiteColor,
        child: Column(
          children: <Widget>[
            if (!_isChangeAddress)
              !_slotsLoading
                  ? _checkslots
                  ? Expanded(
                child: Column(
                  children: <Widget>[
                    Opacity(opacity: 0.0,child: Container(
                      height: 2,
                      child: TabBar(
                        controller: _tabController,
                        labelColor: ColorCodes.whiteColor,
                        indicatorColor: ColorCodes.whiteColor,
                        unselectedLabelColor:
                        ColorCodes.whiteColor,
                        labelStyle: TextStyle(
                          fontSize: 0,
                          fontWeight: FontWeight.bold,
                        ),
                        tabs: [
                          Tab(text: 'SLOT BASED DELIVERY'),
                          Tab(
                            text: 'EXPRESS DELIVERY',
                          ),
                        ],
                      ),
                    ),),

                    Expanded(
                      child:
                      TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _tabController,
                        children: [
                          slotBasedDelivery(),
                          expressDelivery(),
                        ],
                      ),
                    ),
                  ],
                ),
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    "Currently there is no slots available",
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )
                  : Center(
                child: CircularProgressIndicator(),
              )
          ],
        ),
      ),
    ),

  ),
}*/
//******************************* new listview design**********
/*  Widget slotBasedDelivery() {
    int index = 0;

    return


      Container(

          child:
          NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              //this is for removing scroll glow of listview
              overscroll.disallowGlow();
            },
            child:  ListView.builder(
                shrinkWrap: true,
                physics: new AlwaysScrollableScrollPhysics(),

                //physics: NeverScrollableScrollPhysics(),
                //controller: _controller,
                // physics: NeverScrollableScrollPhysics(),
                itemCount: deliveryslotData.items.length,
                //shrinkWrap: true,
                itemBuilder: (_, i) => Column(
                  children: [
                    Container(
                      color: ColorCodes.slotTab,
                      height: 50,
                      child: Container(
                        color: ColorCodes.slotTab,
                        margin: EdgeInsets.only(left: 45, right: 68),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 18,
                            ),
                            SizedBox(width: 10),
                            Container(
                              child: Text(deliveryslotData.items[i].date,
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                            ),

                            //Spacer(flex: 1,)
                          ],
                        ),
                      ),
                    ),

                    timeSlot(deliveryslotData.items[i].id, i,),
                    // if ( i < deliveryslotData.items.length ) Divider(
                    //   color: Colors.black,
                    // ),
                  ],
                )),

          )



      );
  }*/

/*  Widget timeSlot(String id, int i) {
    timeslotsData = Provider.of<DeliveryslotitemsList>(
      context,
      listen: false,
    ).findById(id);

    return new ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: ColorCodes.lightGreyColor,
      ),
      physics:new NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: timeslotsData.length,
      itemBuilder: (_, j) => GestureDetector(
        onTap: () async {

          setState(() {

            time = timeslotsData[j].time;

            final timeData = Provider.of<DeliveryslotitemsList>(context, listen: false);
            prefs.setString("fixdate", deliveryslotData.items[i].dateformat);


            _index = (i == 0 && j == 0) ? 0 : _index + 1;
            for(int i = 0; i < timeData.times.length; i++) {

              setState(() {
                if((int.parse(id) + j).toString() == timeData.times[i].index) {
                  timeData.times[i].selectedColor = Color(0xFF2966A2);
                  timeData.times[i].isSelect = true;
                  prefs.setString('fixtime', timeData.times[i].time);
                } else {
                  timeData.times[i].selectedColor = ColorCodes.lightgrey;
                  timeData.times[i].isSelect = false;
                }
              });
            }

          });
        },
        child: Container(
          height: 40,
          color: Colors.white,
          margin: EdgeInsets.only(left: 5.0, right: 5.0),
          //child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.45,
                child: Text(
                  timeslotsData[j].time,
                  style: TextStyle(color: timeslotsData[j].selectedColor, fontWeight: timeslotsData[j].isSelect ? FontWeight.bold : FontWeight.normal),
                ),
              ),
              SizedBox(width: 40),
              timeslotsData[j].isSelect ?
              Icon(Icons.check, color: timeslotsData[j].selectedColor) : Icon(Icons.check, color: Colors.transparent),

            ],
          ),
        ),
      ),
    );
  }*/

  //******************** new code tab bar express delivery *************

  Widget expressDelivery() {
    return /*GestureDetector(
      onTap: () {
        setState(() {
        });
      },
      child: */Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            height: 50,
            width: 300,
            decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                )),
            child: Center(child: Text(_deliveryDurationExpress, style: TextStyle(color: ColorCodes.blackColor, fontWeight: FontWeight.bold))),
          ) /*:
            Container(
              height: 50,
              width: 300,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: ColorCodes.lightGreyColor,
                    width: 1.2,
                  )),
              child: Center(child: Text(_deliveryDurationExpress)),
            )*/
        ],
      ),
      // ),
    );
  }

  // Widget dialogforViewAllProduct1() {
  //   for(int i=0;i<productBox.length;i++)
  //     showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return Container(
  //           width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))
  //               ? MediaQuery.of(context).size.width * 0.40
  //               : MediaQuery.of(context).size.width,
  //           decoration: new BoxDecoration(
  //             boxShadow: [
  //               //background color of box
  //               BoxShadow(
  //                 color: ColorCodes.lightGreyColor,
  //                 blurRadius: 25.0, // soften the shadow
  //                 spreadRadius: 5.0, //extend the shadow
  //                 offset: Offset(15.0, // Move to right 10  horizontally
  //                   15.0, // Move to bottom 10 Vertically
  //                 ),
  //               )
  //             ],
  //           ),
  //           child: Card(
  //             shape: RoundedRectangleBorder(
  //               side:
  //               BorderSide(color: ColorCodes.lightGreyColor, width: 1),
  //             ),
  //             margin: EdgeInsets.only(left: 12, right: 12, bottom: 12),
  //             child: Text( productBox[i]
  //                 .itemName!,
  //                 style: TextStyle(fontSize: 12.0)),
  //           ),
  //         );
  //       },
  //     );
  //
  // }

  int currentTime() {

    var now = DateTime.now();
    return now.hour;

  }


  dialogforViewAllProductSecond(int count, String slot_based_delivery, int length) {

    /*showDialog(
      context: context,
      builder: (BuildContext context1) {
       return VxBuilder(mutations: {SetCartItem},
          builder: (context,GroceStore store,state) {
           // something =store.CartItemList;
          return Dialog(

            child: Stack(
              overflow: Overflow.visible,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: [
                            SizedBox(height: 10,),
                            Text(S
                                .of(context)
                                .shipment + " " + count.toString() + ": " +
                                slot_based_delivery,
                              style: TextStyle(color: ColorCodes.blackColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            SizedBox(height: 10,),
                            Text(length.toString() + " " + S
                                .of(context)
                                .items,
                              style: TextStyle(color: ColorCodes.greyColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14),
                            ),
                            SizedBox(height: 20,),

                          ],
                        ),
                      ),
                      if(something.length > 0)
                        SizedBox(
                          child: new ListView.separated(
                            separatorBuilder: (context, index) =>
                                Divider(
                                  color: ColorCodes.lightGreyColor,
                                ),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: something.length,
                            itemBuilder: (_, i) =>
                            (int.parse(something[i].quantity!)>0)?
                                Column(children: [
                                  Container(
                                    color: Colors.white,
                                    child: Card(

                                      elevation: 0,
                                      margin: EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: <Widget>[
                                          (productBox[i].mode == "1")
                                              ? Image.asset(
                                            Images.membershipImg,
                                            width: 80,
                                            height: 80,
                                            color: Theme
                                                .of(context)
                                                .primaryColor,
                                          )
                                              : FadeInImage(
                                            image: NetworkImage(
                                                something[i].itemImage!),
                                            placeholder: AssetImage(
                                              Images.defaultProductImg,
                                            ),
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          ),

                                          Expanded(
                                              child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  mainAxisSize: MainAxisSize
                                                      .min,
                                                  children: [
                                                    //SizedBox(height: 10,),

                                                    Container(
                                                      child: Text(
                                                        something[i].itemName!,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight: FontWeight
                                                                .w600,
                                                            color: Colors
                                                                .black54),
                                                      ),
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Container(
                                                      child: Text(
                                                        something[i].quantity
                                                            .toString() +
                                                            " * " +
                                                            something[i].varName
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
                                              _checkmembership ?
                                              Features.iscurrencyformatalign?
                                              ((double.parse(something[i]
                                                          .membershipPrice!) *
                                                          int.parse(something[i]
                                                              .quantity!))
                                                          .toString()  + " " + IConstants
                                                  .currencyFormat):
                                              (IConstants
                                                  .currencyFormat + " " +
                                                  (double.parse(something[i]
                                                      .membershipPrice!) *
                                                      int.parse(something[i]
                                                          .quantity!))
                                                      .toString()) :
                                              Features.iscurrencyformatalign?
                                              ((double.parse(something[i].price!) *
                                                      int.parse(something[i]
                                                          .quantity!))
                                                      .toString() + " " + IConstants.currencyFormat):
                                              (IConstants.currencyFormat + " " +
                                                  (double.parse(something[i].price!) *
                                                      int.parse(something[i]
                                                          .quantity!))
                                                      .toString()),
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
                                              // _dialogforDeleting();
                                              _updateCart(0, CartStatus.remove,
                                                  something[i].varId.toString(),
                                                  something[i].price.toString(),
                                                something[i].increment.toString(),
                                              );
                                              *//* incrementToCart(0,something[i].varId,something[i].itemName ,something[i].itemId,something[i].varName,something[i].varMinItem
                                            ,something[i].varMaxItem,something[i].varStock,something[i].varMrp,something[i].quantity,something[i].price,
                                            something[i].membershipPrice,something[i].itemActualprice,something[i].itemImage,something[i].veg_type,something[i].type);*//*


                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                                ):SizedBox.shrink(),
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
          );
        });
      },
    );*/


    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0),topRight: Radius.circular(15.0)),
        ),
        context: context,
        builder: (BuildContext bc) {
          return VxBuilder(mutations: {SetCartItem},
              builder: (context,store,state) {
                //  DefaultSlot=store.CartItemList;
                return Stack(
                  //overflow: Overflow.visible,
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10,),
                                  Text(S
                                      .of(context)
                                      .shipment + " " + count.toString() ,

                                    style: TextStyle(color: ColorCodes.blackColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  SizedBox(height: 10,),
                                  IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        Text( slot_based_delivery ,
                                          style: TextStyle(color: ColorCodes.blackColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15),
                                        ),
                                        VerticalDivider(color: ColorCodes.blackColor,
                                          thickness: 2,),
                                        Text( length.toString() + " " + S
                                            .of(context)
                                            .items,
                                          style: TextStyle(color: ColorCodes.blackColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  // Divider(thickness: 2, color: ColorCodes.greyColor,),
                                  //SizedBox(height: 10,),
                                ],
                              ),
                            ),
                          ),
                          if(something.length > 0)
                            SizedBox(
                              child: new ListView.separated(
                                separatorBuilder: (context, index) =>
                                    Divider(
                                      color: ColorCodes.lightGreyColor,
                                    ),
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: something.length,
                                itemBuilder: (_, i) =>
                                (int.parse(something[i].quantity!)>0)?
                                Column(children: [
                                  Container(
                                    color: Colors.white,
                                    child: Card(
                                      /* shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        side: new BorderSide(color: ColorCodes.primaryColor, width: 1.0),
                                      ),*/
                                      elevation: 0,
                                      margin: EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: <Widget>[
                                          (productBox[i].mode == "1")
                                              ? Image.asset(
                                            Images.membershipImg,
                                            width: 80,
                                            height: 80,
                                            color: Theme
                                                .of(context)
                                                .primaryColor,
                                          )
                                              : FadeInImage(
                                            image: NetworkImage(
                                                something[i].itemImage!),
                                            placeholder: AssetImage(
                                              Images.defaultProductImg,
                                            ),
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          ),

                                          Expanded(
                                              child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  mainAxisSize: MainAxisSize
                                                      .min,
                                                  children: [
                                                    //SizedBox(height: 10,),

                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left:5.0),
                                                            child: Container(
                                                              child: Text(
                                                                something[i]
                                                                    .itemName!,
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                                maxLines: 2,
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontWeight: FontWeight
                                                                        .w600,
                                                                    color: ColorCodes.blackColor),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        // Spacer(),
                                                        IconButton(
                                                          icon: Image.asset(
                                                            Images.Delete,
                                                            height: 22.0,
                                                            color: ColorCodes.primaryColor,
                                                          ),//Icon(Icons.delete_outline,color: ColorCodes.primaryColor,),
                                                          color: Colors.grey,
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                            // _dialogforDeleting();
                                                            _updateCart(0, CartStatus.remove,
                                                              something[i].varId
                                                                  .toString(),
                                                              something[i].price
                                                                  .toString(),
                                                              something[i].increment.toString(),
                                                              productBox
                                                                  .where((element) =>
                                                              element.id! == something[i].id
                                                              ).first.parent_id.toString(),

                                                            );
                                                            /*  incrementToCart(0,DefaultSlot[i].varId,DefaultSlot[i].itemName ,DefaultSlot[i].itemId,DefaultSlot[i].varName,DefaultSlot[i].varMinItem
                                                ,DefaultSlot[i].varMaxItem,DefaultSlot[i].varStock,DefaultSlot[i].varMrp,DefaultSlot[i].quantity,DefaultSlot[i].price,
                                                DefaultSlot[i].membershipPrice,DefaultSlot[i].itemActualprice,DefaultSlot[i].itemImage,DefaultSlot[i].veg_type,DefaultSlot[i].type);
*/

                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(left:5.0),
                                                          child: Container(
                                                            child: Text(

                                                              something[i].type == "1"?
                                                              something[i]
                                                                  .varName! +
                                                                  " * " +
                                                                  something[i]
                                                                      .weight
                                                                      .toString()
                                                                  :something[i]
                                                                  .varName! +
                                                                  " * " +
                                                                  something[i]
                                                                      .quantity
                                                                      .toString()

                                                              ,
                                                              overflow: TextOverflow
                                                                  .ellipsis,
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight
                                                                      .w400,
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ),
                                                        ),
                                                        Spacer(),

                                                        RichText(
                                                            text: new TextSpan(
                                                              children: <TextSpan>[
                                                                new TextSpan(
                                                                  text:_checkmembership ?
                                                                  Features.iscurrencyformatalign?
                                                                  something[i].type == "1"?
                                                                  ((double.parse(something[i]
                                                                      .membershipPrice!) *
                                                                      double.parse(something[i]
                                                                          .weight!))
                                                                      .toString() + " " + IConstants
                                                                      .currencyFormat):
                                                                  ((double.parse(something[i]
                                                                      .membershipPrice!) *
                                                                      int.parse(something[i]
                                                                          .quantity!))
                                                                      .toString() + " " + IConstants
                                                                      .currencyFormat):
                                                                  something[i].type == "1"?
                                                                  (IConstants
                                                                      .currencyFormat + " " +
                                                                      (double.parse(something[i]
                                                                          .membershipPrice!) *
                                                                          double.parse(something[i]
                                                                              .weight!))
                                                                          .toString()):
                                                                  (IConstants
                                                                      .currencyFormat + " " +
                                                                      (double.parse(something[i]
                                                                          .membershipPrice!) *
                                                                          int.parse(something[i]
                                                                              .quantity!))
                                                                          .toString()) :
                                                                  Features.iscurrencyformatalign?
                                                                  something[i].type == "1"?
                                                                  ((double.parse(something[i].price!)*
                                                                      double.parse(something[i]
                                                                          .weight!))
                                                                      .toString()+
                                                                      " " + IConstants.currencyFormat):
                                                                  ((double.parse(something[i].price!)*
                                                                      int.parse(something[i]
                                                                          .quantity!))
                                                                      .toString()+
                                                                      " " + IConstants.currencyFormat):
                                                                  something[i].type == "1"?
                                                                  (IConstants.currencyFormat +
                                                                      " " +
                                                                      (double.parse(something[i].price!)*
                                                                          double.parse(something[i]
                                                                              .weight!))
                                                                          .toString()):
                                                                  (IConstants.currencyFormat +
                                                                      " " +
                                                                      (double.parse(something[i].price!)*
                                                                          int.parse(something[i]
                                                                              .quantity!))
                                                                          .toString()) ,// 'HOME DELIVERY',
                                                                  style: TextStyle(
                                                                    color: ColorCodes.blackColor,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize:13,
                                                                  ),
                                                                ),
                                                                new TextSpan(
                                                                  text: _checkmembership ?
                                                                  Features.iscurrencyformatalign?
                                                                  something[i].type == "1"?
                                                                  ((double.parse(something[i]
                                                                      .varMrp!) *
                                                                      double.parse(something[i]
                                                                          .weight!))
                                                                      .toString() + " " + IConstants
                                                                      .currencyFormat):
                                                                  ((double.parse(something[i]
                                                                      .varMrp!) *
                                                                      int.parse(something[i]
                                                                          .quantity!))
                                                                      .toString() + " " + IConstants
                                                                      .currencyFormat):
                                                                  something[i].type == "1"?
                                                                  (IConstants
                                                                      .currencyFormat + " " +
                                                                      (double.parse(something[i]
                                                                          .varMrp!) *
                                                                          double.parse(something[i]
                                                                              .weight!))
                                                                          .toString())
                                                                      :
                                                                  (IConstants
                                                                      .currencyFormat + " " +
                                                                      (double.parse(something[i]
                                                                          .varMrp!) *
                                                                          int.parse(something[i]
                                                                              .quantity!))
                                                                          .toString()) :
                                                                  Features.iscurrencyformatalign?
                                                                  something[i].type == "1"?
                                                                  ((double.parse(something[i].varMrp!)*
                                                                      double.parse(something[i]
                                                                          .weight!))
                                                                      .toString()+
                                                                      " " + IConstants.currencyFormat):
                                                                  ((double.parse(something[i].varMrp!)*
                                                                      int.parse(something[i]
                                                                          .quantity!))
                                                                      .toString()+
                                                                      " " + IConstants.currencyFormat):
                                                                  something[i].type == "1"?
                                                                  (IConstants.currencyFormat +
                                                                      " " +
                                                                      (double.parse(something[i].varMrp!)*
                                                                          double.parse(something[i]
                                                                              .weight!))
                                                                          .toString())

                                                                      :(IConstants.currencyFormat +
                                                                      " " +
                                                                      (double.parse(something[i].varMrp!)*
                                                                          int.parse(something[i]
                                                                              .quantity!))
                                                                          .toString()) ,// 'HOME DELIVERY',
                                                                  style: TextStyle(
                                                                    color: ColorCodes.greyColor,
                                                                    // fontWeight: FontWeight.bold,
                                                                    fontSize:9,
                                                                    decoration:TextDecoration.lineThrough,

                                                                  ),
                                                                ),
                                                              ],
                                                            )),


                                                        /*Container(
                                                          child: Text(
                                                            _checkmembership ?
                                                            Features.iscurrencyformatalign?
                                                            ((double.parse(DefaultSlot[i]
                                                                .membershipPrice!) *
                                                                int.parse(DefaultSlot[i]
                                                                    .quantity!))
                                                                .toString() + " " + IConstants
                                                                .currencyFormat):
                                                            (IConstants
                                                                .currencyFormat + " " +
                                                                (double.parse(DefaultSlot[i]
                                                                    .membershipPrice!) *
                                                                    int.parse(DefaultSlot[i]
                                                                        .quantity!))
                                                                    .toString()) :
                                                            Features.iscurrencyformatalign?
                                                            ((double.parse(DefaultSlot[i].price!)*
                                                                int.parse(DefaultSlot[i]
                                                                    .quantity!))
                                                                .toString()+
                                                                " " + IConstants.currencyFormat):
                                                            (IConstants.currencyFormat +
                                                                " " +
                                                                (double.parse(DefaultSlot[i].price!)*
                                                                    int.parse(DefaultSlot[i]
                                                                        .quantity!))
                                                                    .toString()),
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight: FontWeight.w600,
                                                                color: Colors.black),
                                                          ),
                                                        ),*/
                                                      ],
                                                    ),
                                                  ])),



                                        ],
                                      ),
                                    ),
                                  )
                                ],
                                ):SizedBox.shrink(),
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
                );
              });
        });



  }
  dialogforViewAllProductExpress(int count, String express_delivery, int length) {

    /*showDialog(
      context: context,
      builder: (BuildContext context1) {
        return VxBuilder(mutations: {SetCartItem},
          builder: (context,GroceStore store,state) {
           // ExpressDetails =store.CartItemList;
          return Dialog(

            child: Stack(
              overflow: Overflow.visible,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: [
                            SizedBox(height: 10,),
                            Text(S
                                .of(context)
                                .shipment + " " + count.toString() + ": " +
                                express_delivery,
                              style: TextStyle(color: ColorCodes.blackColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            SizedBox(height: 10,),
                            Text(length.toString() + " " + S
                                .of(context)
                                .items,
                              style: TextStyle(color: ColorCodes.greyColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14),
                            ),
                            SizedBox(height: 20,),

                          ],
                        ),
                      ),
                      if(ExpressDetails.length > 0)
                        SizedBox(
                          child: new ListView.separated(
                            separatorBuilder: (context, index) =>
                                Divider(
                                  color: ColorCodes.lightGreyColor,
                                ),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: ExpressDetails.length,
                            itemBuilder: (_, i) =>
                                (int.parse(ExpressDetails[i].quantity!)>0)?
                                Column(children: [
                                  Container(
                                    color: Colors.white,
                                    child: Card(

                                      elevation: 0,
                                      margin: EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: <Widget>[
                                          FadeInImage(
                                            image: NetworkImage(
                                                ExpressDetails[i].itemImage!),
                                            placeholder: AssetImage(
                                              Images.defaultProductImg,
                                            ),
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          ),

                                          Expanded(
                                              child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  mainAxisSize: MainAxisSize
                                                      .min,
                                                  children: [
                                                    //SizedBox(height: 10,),

                                                    Container(
                                                      child: Text(
                                                        ExpressDetails[i]
                                                            .itemName!,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight: FontWeight
                                                                .w600,
                                                            color: Colors
                                                                .black54),
                                                      ),
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Container(
                                                      child: Text(
                                                        ExpressDetails[i]
                                                            .quantity
                                                            .toString() +
                                                            " * " +
                                                            ExpressDetails[i]
                                                                .varName
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
                                              _checkmembership ? Features.iscurrencyformatalign?
                                              ((double.parse(
                                                      ExpressDetails[i]
                                                          .membershipPrice!) *
                                                      int.parse(
                                                          ExpressDetails[i]
                                                              .quantity!))
                                                      .toString() + " " + IConstants
                                                      .currencyFormat):
                                              (IConstants
                                                  .currencyFormat + " " +
                                                  (double.parse(
                                                      ExpressDetails[i]
                                                          .membershipPrice!) *
                                                      int.parse(
                                                          ExpressDetails[i]
                                                              .quantity!))
                                                      .toString()) :
                                              Features.iscurrencyformatalign?
                                              ((double.parse(ExpressDetails[i].price!)*
                                                      int.parse(
                                                          ExpressDetails[i]
                                                              .quantity!))
                                                      .toString() + " " + IConstants.currencyFormat):
                                              (IConstants.currencyFormat + " " +
                                                  (double.parse(ExpressDetails[i].price!)*
                                                      int.parse(
                                                          ExpressDetails[i]
                                                              .quantity!))
                                                      .toString()),
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
                                               // _dialogforDeleting();
                                              _updateCart(0, CartStatus.remove,
                                                  ExpressDetails[i].varId
                                                      .toString(),
                                                  ExpressDetails[i].price
                                                      .toString(),
                                                ExpressDetails[i].increment.toString(),
                                              );
                                              *//*  incrementToCart(0,ExpressDetails[i].varId,ExpressDetails[i].itemName ,ExpressDetails[i].itemId,ExpressDetails[i].varName,ExpressDetails[i].varMinItem
                                            ,ExpressDetails[i].varMaxItem,ExpressDetails[i].varStock,ExpressDetails[i].varMrp,ExpressDetails[i].quantity,ExpressDetails[i].price,
                                            ExpressDetails[i].membershipPrice,ExpressDetails[i].itemActualprice,ExpressDetails[i].itemImage,ExpressDetails[i].veg_type,ExpressDetails[i].type);
*//*

                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                                ):SizedBox.shrink(),
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
          );
        });
      },
    );*/



    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0),topRight: Radius.circular(15.0)),
        ),
        context: context,
        builder: (BuildContext bc) {
          return VxBuilder(mutations: {SetCartItem},
              builder: (context,store,state) {
                //  DefaultSlot=store.CartItemList;
                return Stack(
                  //overflow: Overflow.visible,
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10,),
                                  Text(S
                                      .of(context)
                                      .shipment + " " + count.toString() ,

                                    style: TextStyle(color: ColorCodes.blackColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  SizedBox(height: 10,),
                                  IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        Text( express_delivery ,
                                          style: TextStyle(color: ColorCodes.blackColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15),
                                        ),
                                        VerticalDivider(color: ColorCodes.blackColor,
                                          thickness: 2,),
                                        Text( length.toString() + " " + S
                                            .of(context)
                                            .items,
                                          style: TextStyle(color: ColorCodes.blackColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  // Divider(thickness: 2, color: ColorCodes.greyColor,),
                                  //SizedBox(height: 10,),
                                ],
                              ),
                            ),
                          ),
                          if(ExpressDetails.length > 0)
                            SizedBox(
                              child: new ListView.separated(
                                separatorBuilder: (context, index) =>
                                    Divider(
                                      color: ColorCodes.lightGreyColor,
                                    ),
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: ExpressDetails.length,
                                itemBuilder: (_, i) =>
                                (int.parse(ExpressDetails[i].quantity!)>0)?
                                Column(children: [
                                  Container(
                                    color: Colors.white,
                                    child: Card(
                                      /* shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        side: new BorderSide(color: ColorCodes.primaryColor, width: 1.0),
                                      ),*/
                                      elevation: 0,
                                      margin: EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: <Widget>[
                                          (productBox[i].mode == "1")
                                              ? Image.asset(
                                            Images.membershipImg,
                                            width: 80,
                                            height: 80,
                                            color: Theme
                                                .of(context)
                                                .primaryColor,
                                          )
                                              : FadeInImage(
                                            image: NetworkImage(
                                                ExpressDetails[i].itemImage!),
                                            placeholder: AssetImage(
                                              Images.defaultProductImg,
                                            ),
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          ),

                                          Expanded(
                                              child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  mainAxisSize: MainAxisSize
                                                      .min,
                                                  children: [
                                                    //SizedBox(height: 10,),

                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left:5.0),
                                                            child: Container(
                                                              child: Text(
                                                                ExpressDetails[i]
                                                                    .itemName!,
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                                maxLines: 2,
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontWeight: FontWeight
                                                                        .w600,
                                                                    color: ColorCodes.blackColor),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        // Spacer(),
                                                        IconButton(
                                                          icon: Image.asset(
                                                            Images.Delete,
                                                            height: 22.0,
                                                            color: ColorCodes.primaryColor,
                                                          ),//Icon(Icons.delete_outline,color: ColorCodes.primaryColor,),
                                                          color: Colors.grey,
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                            // _dialogforDeleting();
                                                            _updateCart(0, CartStatus.remove,
                                                              ExpressDetails[i].varId
                                                                  .toString(),
                                                              ExpressDetails[i].price
                                                                  .toString(),
                                                              ExpressDetails[i].increment.toString(),
                                                              productBox
                                                                  .where((element) =>
                                                              element.id! == ExpressDetails[i].id
                                                              ).first.parent_id.toString(),

                                                            );
                                                            /*  incrementToCart(0,DefaultSlot[i].varId,DefaultSlot[i].itemName ,DefaultSlot[i].itemId,DefaultSlot[i].varName,DefaultSlot[i].varMinItem
                                                ,DefaultSlot[i].varMaxItem,DefaultSlot[i].varStock,DefaultSlot[i].varMrp,DefaultSlot[i].quantity,DefaultSlot[i].price,
                                                DefaultSlot[i].membershipPrice,DefaultSlot[i].itemActualprice,DefaultSlot[i].itemImage,DefaultSlot[i].veg_type,DefaultSlot[i].type);
*/

                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(left:5.0),
                                                          child: Container(
                                                            child: Text(

                                                              ExpressDetails[i].type == "1"?
                                                              ExpressDetails[i]
                                                                  .varName! +
                                                                  " * " +
                                                                  ExpressDetails[i]
                                                                      .weight
                                                                      .toString()
                                                                  :ExpressDetails[i]
                                                                  .varName! +
                                                                  " * " +
                                                                  ExpressDetails[i]
                                                                      .quantity
                                                                      .toString()

                                                              ,
                                                              overflow: TextOverflow
                                                                  .ellipsis,
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight
                                                                      .w400,
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ),
                                                        ),
                                                        Spacer(),

                                                        RichText(
                                                            text: new TextSpan(
                                                              children: <TextSpan>[
                                                                new TextSpan(
                                                                  text:_checkmembership ?
                                                                  Features.iscurrencyformatalign?
                                                                  ExpressDetails[i].type == "1"?
                                                                  ((double.parse(ExpressDetails[i]
                                                                      .membershipPrice!) *
                                                                      double.parse(ExpressDetails[i]
                                                                          .weight!))
                                                                      .toString() + " " + IConstants
                                                                      .currencyFormat):
                                                                  ((double.parse(ExpressDetails[i]
                                                                      .membershipPrice!) *
                                                                      int.parse(ExpressDetails[i]
                                                                          .quantity!))
                                                                      .toString() + " " + IConstants
                                                                      .currencyFormat):   ExpressDetails[i].type == "1"?
                                                                  (IConstants
                                                                      .currencyFormat + " " +
                                                                      (double.parse(ExpressDetails[i]
                                                                          .membershipPrice!) *
                                                                          double.parse(ExpressDetails[i]
                                                                              .weight!))
                                                                          .toString())

                                                                      :(IConstants
                                                                      .currencyFormat + " " +
                                                                      (double.parse(ExpressDetails[i]
                                                                          .membershipPrice!) *
                                                                          int.parse(ExpressDetails[i]
                                                                              .quantity!))
                                                                          .toString()) :
                                                                  Features.iscurrencyformatalign?
                                                                  ExpressDetails[i].type == "1"?
                                                                  ((double.parse(ExpressDetails[i].price!)*
                                                                      double.parse(ExpressDetails[i]
                                                                          .weight!))
                                                                      .toString()+
                                                                      " " + IConstants.currencyFormat):
                                                                  ((double.parse(ExpressDetails[i].price!)*
                                                                      int.parse(ExpressDetails[i]
                                                                          .quantity!))
                                                                      .toString()+
                                                                      " " + IConstants.currencyFormat):
                                                                  ExpressDetails[i].type == "1"?
                                                                  (IConstants.currencyFormat +
                                                                      " " +
                                                                      (double.parse(ExpressDetails[i].price!)*
                                                                          double.parse(ExpressDetails[i]
                                                                              .weight!))
                                                                          .toString())
                                                                      :(IConstants.currencyFormat +
                                                                      " " +
                                                                      (double.parse(ExpressDetails[i].price!)*
                                                                          int.parse(ExpressDetails[i]
                                                                              .quantity!))
                                                                          .toString()) ,// 'HOME DELIVERY',
                                                                  style: TextStyle(
                                                                    color: ColorCodes.blackColor,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize:13,
                                                                  ),
                                                                ),
                                                                new TextSpan(
                                                                  text: _checkmembership ?
                                                                  Features.iscurrencyformatalign?ExpressDetails[i].type == "1"?
                                                                  ((double.parse(ExpressDetails[i]
                                                                      .varMrp!) *
                                                                      double.parse(ExpressDetails[i]
                                                                          .weight!))
                                                                      .toString() + " " + IConstants
                                                                      .currencyFormat)
                                                                      :((double.parse(ExpressDetails[i]
                                                                      .varMrp!) *
                                                                      int.parse(ExpressDetails[i]
                                                                          .quantity!))
                                                                      .toString() + " " + IConstants
                                                                      .currencyFormat):ExpressDetails[i].type == "1"?
                                                                  (IConstants
                                                                      .currencyFormat + " " +
                                                                      (double.parse(ExpressDetails[i]
                                                                          .varMrp!) *
                                                                          double.parse(ExpressDetails[i]
                                                                              .weight!))
                                                                          .toString()):
                                                                  (IConstants
                                                                      .currencyFormat + " " +
                                                                      (double.parse(ExpressDetails[i]
                                                                          .varMrp!) *
                                                                          int.parse(ExpressDetails[i]
                                                                              .quantity!))
                                                                          .toString()) :
                                                                  Features.iscurrencyformatalign?ExpressDetails[i].type == "1"?
                                                                  ((double.parse(ExpressDetails[i].varMrp!)*
                                                                      double.parse(ExpressDetails[i]
                                                                          .weight!))
                                                                      .toString()+
                                                                      " " + IConstants.currencyFormat):
                                                                  ((double.parse(ExpressDetails[i].varMrp!)*
                                                                      int.parse(ExpressDetails[i]
                                                                          .quantity!))
                                                                      .toString()+
                                                                      " " + IConstants.currencyFormat):
                                                                  ExpressDetails[i].type == "1"?
                                                                  (IConstants.currencyFormat +
                                                                      " " +
                                                                      (double.parse(ExpressDetails[i].varMrp!)*
                                                                          double.parse(ExpressDetails[i]
                                                                              .weight!))
                                                                          .toString()):
                                                                  (IConstants.currencyFormat +
                                                                      " " +
                                                                      (double.parse(ExpressDetails[i].varMrp!)*
                                                                          int.parse(ExpressDetails[i]
                                                                              .quantity!))
                                                                          .toString()) ,// 'HOME DELIVERY',
                                                                  style: TextStyle(
                                                                    color: ColorCodes.greyColor,
                                                                    // fontWeight: FontWeight.bold,
                                                                    fontSize:9,
                                                                    decoration:TextDecoration.lineThrough,

                                                                  ),
                                                                ),
                                                              ],
                                                            )),


                                                        /*Container(
                                                          child: Text(
                                                            _checkmembership ?
                                                            Features.iscurrencyformatalign?
                                                            ((double.parse(DefaultSlot[i]
                                                                .membershipPrice!) *
                                                                int.parse(DefaultSlot[i]
                                                                    .quantity!))
                                                                .toString() + " " + IConstants
                                                                .currencyFormat):
                                                            (IConstants
                                                                .currencyFormat + " " +
                                                                (double.parse(DefaultSlot[i]
                                                                    .membershipPrice!) *
                                                                    int.parse(DefaultSlot[i]
                                                                        .quantity!))
                                                                    .toString()) :
                                                            Features.iscurrencyformatalign?
                                                            ((double.parse(DefaultSlot[i].price!)*
                                                                int.parse(DefaultSlot[i]
                                                                    .quantity!))
                                                                .toString()+
                                                                " " + IConstants.currencyFormat):
                                                            (IConstants.currencyFormat +
                                                                " " +
                                                                (double.parse(DefaultSlot[i].price!)*
                                                                    int.parse(DefaultSlot[i]
                                                                        .quantity!))
                                                                    .toString()),
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight: FontWeight.w600,
                                                                color: Colors.black),
                                                          ),
                                                        ),*/
                                                      ],
                                                    ),
                                                  ])),



                                        ],
                                      ),
                                    ),
                                  )
                                ],
                                ):SizedBox.shrink(),
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
                );
              });
        });


  }

  dialogforViewAllDateTimeProduct(List<CartItem> orderLinesDate, int count, String delivery_on, String date, int length) {

    /*showDialog(
      context: context,
      builder: (BuildContext context1) {
      return  VxBuilder(mutations: {SetCartItem},
          builder: (context,GroceStore store,state) {
           //  orderLinesDate =store.CartItemList;
        return Dialog(
          *//*shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0)),*//*
          child: Stack(
            overflow: Overflow.visible,
            children: [

              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: [
                          SizedBox(height: 10,),
                          Text(S
                              .of(context)
                              .shipment + " " + count.toString() + ": " +
                              delivery_on + " " + date,
                            style: TextStyle(color: ColorCodes.blackColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          SizedBox(height: 10,),
                          Text(length.toString() + " " + S
                              .of(context)
                              .items,
                            style: TextStyle(color: ColorCodes.greyColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
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
                          separatorBuilder: (context, index) =>
                              Divider(
                                color: ColorCodes.lightGreyColor,
                              ),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: orderLinesDate.length,
                          itemBuilder: (_, i) =>
                          (int.parse(orderLinesDate[i].quantity!)>0)?
                              Column(children: [
                                Container(
                                  color: Colors.white,
                                  child: Card(

                                    elevation: 0,
                                    margin: EdgeInsets.all(5),
                                    child: Row(
                                      children: <Widget>[
                                        FadeInImage(
                                          image: NetworkImage(orderLinesDate[i]
                                              .itemImage!),
                                          placeholder: AssetImage(
                                            Images.defaultProductImg,
                                          ),
                                          width: 80,
                                          height: 80,
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
                                                      orderLinesDate[i]
                                                          .itemName!,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight
                                                              .w600,
                                                          color: Colors
                                                              .black54),
                                                    ),
                                                  ),
                                                  SizedBox(height: 5,),
                                                  Container(
                                                    child: Text(
                                                      orderLinesDate[i]
                                                          .quantity
                                                          .toString() + " * " +
                                                          orderLinesDate[i]
                                                              .varName
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
                                            _checkmembership
                                                ?
                                            Features.iscurrencyformatalign?
                                            ((double.parse(
                                                orderLinesDate[i]
                                                    .membershipPrice!) *
                                                int.parse(orderLinesDate[i]
                                                    .quantity!)).toString() +
                                                " " + IConstants.currencyFormat):
                                            (IConstants.currencyFormat +
                                                " " + (double.parse(
                                                orderLinesDate[i]
                                                    .membershipPrice!) *
                                                int.parse(orderLinesDate[i]
                                                    .quantity!)).toString())
                                                :
                                                Features.iscurrencyformatalign?
                                                ((double.parse(orderLinesDate[i].price!) *
                                                        int.parse(orderLinesDate[i]
                                                            .quantity!)).toString() + " " + IConstants.currencyFormat):
                                            (IConstants.currencyFormat + " " +
                                                (double.parse(orderLinesDate[i].price!) *
                                                    int.parse(orderLinesDate[i]
                                                        .quantity!)).toString()),
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
                                             // _dialogforDeleting();
                                            _updateCart(0, CartStatus.remove,
                                                orderLinesDate[i].varId
                                                    .toString(),
                                                orderLinesDate[i].price
                                                    .toString(),
                                              orderLinesDate[i].increment.toString(),
                                            );
                                            *//* incrementToCart(0,orderLinesDate[i].varId,orderLinesDate[i].itemName,orderLinesDate[i].itemId,orderLinesDate[i].varName,orderLinesDate[i].varMinItem
                                                ,orderLinesDate[i].varMaxItem,orderLinesDate[i].varStock,orderLinesDate[i].varMrp,orderLinesDate[i].quantity,orderLinesDate[i].price,
                                                orderLinesDate[i].membershipPrice,orderLinesDate[i].itemActualprice,orderLinesDate[i].itemImage,orderLinesDate[i].veg_type,orderLinesDate[i].type);
*//*
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                              ):SizedBox.shrink(),
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
        );
      });
      },
    );*/

    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0),topRight: Radius.circular(15.0)),
        ),
        context: context,
        builder: (BuildContext bc) {
          return VxBuilder(mutations: {SetCartItem},
              builder: (context,store,state) {
                //  DefaultSlot=store.CartItemList;
                return Stack(
                  //overflow: Overflow.visible,
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10,),
                                  Text(S
                                      .of(context)
                                      .shipment + " " + count.toString() ,

                                    style: TextStyle(color: ColorCodes.blackColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  SizedBox(height: 10,),
                                  IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        Text( delivery_on + " "+ date ,
                                          style: TextStyle(color: ColorCodes.blackColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15),
                                        ),
                                        VerticalDivider(color: ColorCodes.blackColor,
                                          thickness: 2,),
                                        Text( length.toString() + " " + S
                                            .of(context)
                                            .items,
                                          style: TextStyle(color: ColorCodes.blackColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  // Divider(thickness: 2, color: ColorCodes.greyColor,),
                                  //SizedBox(height: 10,),
                                ],
                              ),
                            ),
                          ),
                          if(orderLinesDate.length > 0)
                            SizedBox(
                              child: new ListView.separated(
                                separatorBuilder: (context, index) =>
                                    Divider(
                                      color: ColorCodes.lightGreyColor,
                                    ),
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: orderLinesDate.length,
                                itemBuilder: (_, i) =>
                                (int.parse(orderLinesDate[i].quantity!)>0)?
                                Column(children: [
                                  Container(
                                    color: Colors.white,
                                    child: Card(
                                      /* shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        side: new BorderSide(color: ColorCodes.primaryColor, width: 1.0),
                                      ),*/
                                      elevation: 0,
                                      margin: EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: <Widget>[
                                          (productBox[i].mode == "1")
                                              ? Image.asset(
                                            Images.membershipImg,
                                            width: 80,
                                            height: 80,
                                            color: Theme
                                                .of(context)
                                                .primaryColor,
                                          )
                                              : FadeInImage(
                                            image: NetworkImage(
                                                orderLinesDate[i].itemImage!),
                                            placeholder: AssetImage(
                                              Images.defaultProductImg,
                                            ),
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          ),

                                          Expanded(
                                              child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  mainAxisSize: MainAxisSize
                                                      .min,
                                                  children: [
                                                    //SizedBox(height: 10,),

                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left:5.0),
                                                            child: Container(
                                                              child: Text(
                                                                orderLinesDate[i]
                                                                    .itemName!,
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                                maxLines: 2,
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontWeight: FontWeight
                                                                        .w600,
                                                                    color: ColorCodes.blackColor),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        // Spacer(),
                                                        IconButton(
                                                          icon: Image.asset(
                                                            Images.Delete,
                                                            height: 22.0,
                                                            color: ColorCodes.primaryColor,
                                                          ),//Icon(Icons.delete_outline,color: ColorCodes.primaryColor,),
                                                          color: Colors.grey,
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                            // _dialogforDeleting();
                                                            _updateCart(0, CartStatus.remove,
                                                              orderLinesDate[i].varId
                                                                  .toString(),
                                                              orderLinesDate[i].price
                                                                  .toString(),
                                                              orderLinesDate[i].increment.toString(),
                                                              productBox
                                                                  .where((element) =>
                                                              element.id! == orderLinesDate[i].id
                                                              ).first.parent_id.toString(),

                                                            );
                                                            /*  incrementToCart(0,DefaultSlot[i].varId,DefaultSlot[i].itemName ,DefaultSlot[i].itemId,DefaultSlot[i].varName,DefaultSlot[i].varMinItem
                                                ,DefaultSlot[i].varMaxItem,DefaultSlot[i].varStock,DefaultSlot[i].varMrp,DefaultSlot[i].quantity,DefaultSlot[i].price,
                                                DefaultSlot[i].membershipPrice,DefaultSlot[i].itemActualprice,DefaultSlot[i].itemImage,DefaultSlot[i].veg_type,DefaultSlot[i].type);
*/

                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(left:5.0),
                                                          child: Container(
                                                            child: Text(
                                                              orderLinesDate[i].type == "1"?
                                                              orderLinesDate[i]
                                                                  .varName! +
                                                                  " * " +
                                                                  orderLinesDate[i]
                                                                      .weight
                                                                      .toString()
                                                                  :orderLinesDate[i]
                                                                  .varName! +
                                                                  " * " +
                                                                  orderLinesDate[i]
                                                                      .quantity
                                                                      .toString()

                                                              ,
                                                              overflow: TextOverflow
                                                                  .ellipsis,
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight
                                                                      .w400,
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ),
                                                        ),
                                                        Spacer(),

                                                        RichText(
                                                            text: new TextSpan(
                                                              children: <TextSpan>[
                                                                new TextSpan(
                                                                  text:_checkmembership ?
                                                                  Features.iscurrencyformatalign?orderLinesDate[i].type == "1"?
                                                                  ((double.parse(orderLinesDate[i]
                                                                      .membershipPrice!) *
                                                                      double.parse(orderLinesDate[i]
                                                                          .weight!))
                                                                      .toString() + " " + IConstants
                                                                      .currencyFormat):
                                                                  ((double.parse(orderLinesDate[i]
                                                                      .membershipPrice!) *
                                                                      int.parse(orderLinesDate[i]
                                                                          .quantity!))
                                                                      .toString() + " " + IConstants
                                                                      .currencyFormat):
                                                                  orderLinesDate[i].type == "1"?
                                                                  (IConstants
                                                                      .currencyFormat + " " +
                                                                      (double.parse(orderLinesDate[i]
                                                                          .membershipPrice!) *
                                                                          double.parse(orderLinesDate[i]
                                                                              .weight!))
                                                                          .toString()):
                                                                  (IConstants
                                                                      .currencyFormat + " " +
                                                                      (double.parse(orderLinesDate[i]
                                                                          .membershipPrice!) *
                                                                          int.parse(orderLinesDate[i]
                                                                              .quantity!))
                                                                          .toString()) :
                                                                  Features.iscurrencyformatalign?orderLinesDate[i].type == "1"?
                                                                  ((double.parse(orderLinesDate[i].price!)*
                                                                      double.parse(orderLinesDate[i]
                                                                          .weight!))
                                                                      .toString()+
                                                                      " " + IConstants.currencyFormat):
                                                                  ((double.parse(orderLinesDate[i].price!)*
                                                                      int.parse(orderLinesDate[i]
                                                                          .quantity!))
                                                                      .toString()+
                                                                      " " + IConstants.currencyFormat):
                                                                  orderLinesDate[i].type == "1"?
                                                                  (IConstants.currencyFormat +
                                                                      " " +
                                                                      (double.parse(orderLinesDate[i].price!)*
                                                                          double.parse(orderLinesDate[i]
                                                                              .weight!))
                                                                          .toString())
                                                                      :
                                                                  (IConstants.currencyFormat +
                                                                      " " +
                                                                      (double.parse(orderLinesDate[i].price!)*
                                                                          int.parse(orderLinesDate[i]
                                                                              .quantity!))
                                                                          .toString()) ,// 'HOME DELIVERY',
                                                                  style: TextStyle(
                                                                    color: ColorCodes.blackColor,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize:13,
                                                                  ),
                                                                ),
                                                                new TextSpan(
                                                                  text: _checkmembership ?
                                                                  Features.iscurrencyformatalign? orderLinesDate[i].type == "1"?
                                                                  ((double.parse(orderLinesDate[i]
                                                                      .varMrp!) *
                                                                      double.parse(orderLinesDate[i]
                                                                          .weight!))
                                                                      .toString() + " " + IConstants
                                                                      .currencyFormat):
                                                                  ((double.parse(orderLinesDate[i]
                                                                      .varMrp!) *
                                                                      int.parse(orderLinesDate[i]
                                                                          .quantity!))
                                                                      .toString() + " " + IConstants
                                                                      .currencyFormat):orderLinesDate[i].type == "1"?
                                                                  (IConstants
                                                                      .currencyFormat + " " +
                                                                      (double.parse(orderLinesDate[i]
                                                                          .varMrp!) *
                                                                          double.parse(orderLinesDate[i]
                                                                              .weight!))
                                                                          .toString()):
                                                                  (IConstants
                                                                      .currencyFormat + " " +
                                                                      (double.parse(orderLinesDate[i]
                                                                          .varMrp!) *
                                                                          int.parse(orderLinesDate[i]
                                                                              .quantity!))
                                                                          .toString()) :
                                                                  Features.iscurrencyformatalign?orderLinesDate[i].type == "1"?
                                                                  ((double.parse(orderLinesDate[i].varMrp!)*
                                                                      double.parse(orderLinesDate[i]
                                                                          .weight!))
                                                                      .toString()+
                                                                      " " + IConstants.currencyFormat):
                                                                  ((double.parse(orderLinesDate[i].varMrp!)*
                                                                      int.parse(orderLinesDate[i]
                                                                          .quantity!))
                                                                      .toString()+
                                                                      " " + IConstants.currencyFormat):orderLinesDate[i].type == "1"?
                                                                  (IConstants.currencyFormat +
                                                                      " " +
                                                                      (double.parse(orderLinesDate[i].varMrp!)*
                                                                          double.parse(orderLinesDate[i]
                                                                              .weight!))
                                                                          .toString()):
                                                                  (IConstants.currencyFormat +
                                                                      " " +
                                                                      (double.parse(orderLinesDate[i].varMrp!)*
                                                                          int.parse(orderLinesDate[i]
                                                                              .quantity!))
                                                                          .toString()) ,// 'HOME DELIVERY',
                                                                  style: TextStyle(
                                                                    color: ColorCodes.greyColor,
                                                                    // fontWeight: FontWeight.bold,
                                                                    fontSize:9,
                                                                    decoration:TextDecoration.lineThrough,

                                                                  ),
                                                                ),
                                                              ],
                                                            )),


                                                        /*Container(
                                                          child: Text(
                                                            _checkmembership ?
                                                            Features.iscurrencyformatalign?
                                                            ((double.parse(DefaultSlot[i]
                                                                .membershipPrice!) *
                                                                int.parse(DefaultSlot[i]
                                                                    .quantity!))
                                                                .toString() + " " + IConstants
                                                                .currencyFormat):
                                                            (IConstants
                                                                .currencyFormat + " " +
                                                                (double.parse(DefaultSlot[i]
                                                                    .membershipPrice!) *
                                                                    int.parse(DefaultSlot[i]
                                                                        .quantity!))
                                                                    .toString()) :
                                                            Features.iscurrencyformatalign?
                                                            ((double.parse(DefaultSlot[i].price!)*
                                                                int.parse(DefaultSlot[i]
                                                                    .quantity!))
                                                                .toString()+
                                                                " " + IConstants.currencyFormat):
                                                            (IConstants.currencyFormat +
                                                                " " +
                                                                (double.parse(DefaultSlot[i].price!)*
                                                                    int.parse(DefaultSlot[i]
                                                                        .quantity!))
                                                                    .toString()),
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight: FontWeight.w600,
                                                                color: Colors.black),
                                                          ),
                                                        ),*/
                                                      ],
                                                    ),
                                                  ])),



                                        ],
                                      ),
                                    ),
                                  )
                                ],
                                ):SizedBox.shrink(),
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
                );
              });
        });
  }
  dialogforViewAllProductSlotExpress(int count, String slot_based_delivery, int length) {
    /* showDialog(
      context: context,
      builder: ( context){
      return
        VxBuilder(mutations: {SetCartItem},
          builder: (context,GroceStore store,state) {
          //  DefaultSlot=store.CartItemList;
            return Dialog(
              *//* shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),*//*
              child: Stack(
                overflow: Overflow.visible,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Column(
                            children: [
                              SizedBox(height: 10,),
                              Text(S
                                  .of(context)
                                  .shipment + " " + count.toString() + ": " +
                                  slot_based_delivery,
                                style: TextStyle(color: ColorCodes.blackColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              SizedBox(height: 10,),
                              Text(length.toString() + " " + S
                                  .of(context)
                                  .items,
                                style: TextStyle(color: ColorCodes.greyColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                              SizedBox(height: 20,),
                              // Divider(thickness: 2, color: ColorCodes.greyColor,),
                              //SizedBox(height: 10,),
                            ],
                          ),
                        ),
                        if(DefaultSlot.length > 0)
                          SizedBox(
                            child: new ListView.separated(
                              separatorBuilder: (context, index) =>
                                  Divider(
                                    color: ColorCodes.lightGreyColor,
                                  ),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: DefaultSlot.length,
                              itemBuilder: (_, i) =>
            (int.parse(DefaultSlot[i].quantity!)>0)?
                                  Column(children: [
                                    Container(
                                      color: Colors.white,
                                      child: Card(
                                        *//* shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4),
                                          side: new BorderSide(color: ColorCodes.primaryColor, width: 1.0),
                                        ),*//*
                                        elevation: 0,
                                        margin: EdgeInsets.all(5),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: <Widget>[
                                            (productBox[i].mode == "1")
                                                ? Image.asset(
                                              Images.membershipImg,
                                              width: 80,
                                              height: 80,
                                              color: Theme
                                                  .of(context)
                                                  .primaryColor,
                                            )
                                                : FadeInImage(
                                              image: NetworkImage(
                                                  DefaultSlot[i].itemImage!),
                                              placeholder: AssetImage(
                                                Images.defaultProductImg,
                                              ),
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            ),

                                            Expanded(
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .start,
                                                    mainAxisSize: MainAxisSize
                                                        .min,
                                                    children: [
                                                      //SizedBox(height: 10,),

                                                      Container(
                                                        child: Text(
                                                          DefaultSlot[i]
                                                              .itemName!,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight: FontWeight
                                                                  .w600,
                                                              color: Colors
                                                                  .black54),
                                                        ),
                                                      ),
                                                      SizedBox(height: 5,),
                                                      Container(
                                                        child: Text(
                                                          DefaultSlot[i]
                                                              .quantity
                                                              .toString() +
                                                              " * " +
                                                              DefaultSlot[i]
                                                                  .varName!,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight
                                                                  .w400,
                                                              color: Colors
                                                                  .grey),
                                                        ),
                                                      ),
                                                    ])),
                                            Container(
                                              child: Text(
                                                _checkmembership ?
                                                Features.iscurrencyformatalign?
                                                ((double.parse(DefaultSlot[i]
                                                        .membershipPrice!) *
                                                        int.parse(DefaultSlot[i]
                                                            .quantity!))
                                                        .toString() + " " + IConstants
                                                        .currencyFormat):
                                                (IConstants
                                                    .currencyFormat + " " +
                                                    (double.parse(DefaultSlot[i]
                                                        .membershipPrice!) *
                                                        int.parse(DefaultSlot[i]
                                                            .quantity!))
                                                        .toString()) :
                                                    Features.iscurrencyformatalign?
                                                    ((double.parse(DefaultSlot[i].price!)*
                                                            int.parse(DefaultSlot[i]
                                                                .quantity!))
                                                            .toString()+
                                                        " " + IConstants.currencyFormat):
                                                (IConstants.currencyFormat +
                                                    " " +
                                                    (double.parse(DefaultSlot[i].price!)*
                                                        int.parse(DefaultSlot[i]
                                                            .quantity!))
                                                        .toString()),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black),
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.delete),
                                              color: Colors.grey,
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                // _dialogforDeleting();
                                                _updateCart(0, CartStatus.remove,
                                                    DefaultSlot[i].varId
                                                        .toString(),
                                                    DefaultSlot[i].price
                                                        .toString(),
                                                  DefaultSlot[i].increment.toString(),
                                                );
                                                *//*  incrementToCart(0,DefaultSlot[i].varId,DefaultSlot[i].itemName ,DefaultSlot[i].itemId,DefaultSlot[i].varName,DefaultSlot[i].varMinItem
                                                  ,DefaultSlot[i].varMaxItem,DefaultSlot[i].varStock,DefaultSlot[i].varMrp,DefaultSlot[i].quantity,DefaultSlot[i].price,
                                                  DefaultSlot[i].membershipPrice,DefaultSlot[i].itemActualprice,DefaultSlot[i].itemImage,DefaultSlot[i].veg_type,DefaultSlot[i].type);
*//*

                                              },
                                            ),

                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                  ):SizedBox.shrink(),
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
            );
          });
    });*/


    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0),topRight: Radius.circular(15.0)),
        ),
        context: context,
        builder: (BuildContext bc) {
          return VxBuilder(mutations: {SetCartItem},
              builder: (context,store,state) {
                //  DefaultSlot=store.CartItemList;
                return Stack(
                  //overflow: Overflow.visible,
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10,),
                                  Text(S
                                      .of(context)
                                      .shipment + " " + count.toString() ,

                                    style: TextStyle(color: ColorCodes.blackColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  SizedBox(height: 10,),
                                  IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        Text( slot_based_delivery ,
                                          style: TextStyle(color: ColorCodes.blackColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15),
                                        ),
                                        VerticalDivider(color: ColorCodes.blackColor,
                                          thickness: 2,),
                                        Text( length.toString() + " " + S
                                            .of(context)
                                            .items,
                                          style: TextStyle(color: ColorCodes.blackColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  // Divider(thickness: 2, color: ColorCodes.greyColor,),
                                  //SizedBox(height: 10,),
                                ],
                              ),
                            ),
                          ),
                          if(DefaultSlot.length > 0)
                            SizedBox(
                              child: new ListView.separated(
                                separatorBuilder: (context, index) =>
                                    Divider(
                                      color: ColorCodes.lightGreyColor,
                                    ),
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: DefaultSlot.length,
                                itemBuilder: (_, i) =>
                                (int.parse(DefaultSlot[i].quantity!)>0)?
                                Column(children: [
                                  Container(
                                    color: Colors.white,
                                    child: Card(
                                      /* shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        side: new BorderSide(color: ColorCodes.primaryColor, width: 1.0),
                                      ),*/
                                      elevation: 0,
                                      margin: EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: <Widget>[
                                          (productBox[i].mode == "1")
                                              ? Image.asset(
                                            Images.membershipImg,
                                            width: 80,
                                            height: 80,
                                            color: Theme
                                                .of(context)
                                                .primaryColor,
                                          )
                                              : FadeInImage(
                                            image: NetworkImage(
                                                DefaultSlot[i].itemImage!),
                                            placeholder: AssetImage(
                                              Images.defaultProductImg,
                                            ),
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          ),

                                          Expanded(
                                              child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  mainAxisSize: MainAxisSize
                                                      .min,
                                                  children: [
                                                    //SizedBox(height: 10,),

                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left:5.0),
                                                            child: Container(
                                                              child: Text(
                                                                DefaultSlot[i]
                                                                    .itemName!,
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                                maxLines: 2,
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontWeight: FontWeight
                                                                        .w600,
                                                                    color: ColorCodes.blackColor),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        // Spacer(),
                                                        IconButton(
                                                          icon: Image.asset(
                                                            Images.Delete,
                                                            height: 22.0,
                                                            color: ColorCodes.primaryColor,
                                                          ),//Icon(Icons.delete_outline,color: ColorCodes.primaryColor,),
                                                          color: Colors.grey,
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                            _updateCart(0, CartStatus.remove,
                                                              DefaultSlot[i].varId
                                                                  .toString(),
                                                              DefaultSlot[i].price
                                                                  .toString(),
                                                              DefaultSlot[i].increment.toString(),

                                                              productBox
                                                                  .where((element) =>
                                                              element.id! == DefaultSlot[i].id
                                                              ).first.parent_id.toString(),
                                                            );
                                                            /*  incrementToCart(0,DefaultSlot[i].varId,DefaultSlot[i].itemName ,DefaultSlot[i].itemId,DefaultSlot[i].varName,DefaultSlot[i].varMinItem
                                                ,DefaultSlot[i].varMaxItem,DefaultSlot[i].varStock,DefaultSlot[i].varMrp,DefaultSlot[i].quantity,DefaultSlot[i].price,
                                                DefaultSlot[i].membershipPrice,DefaultSlot[i].itemActualprice,DefaultSlot[i].itemImage,DefaultSlot[i].veg_type,DefaultSlot[i].type);
*/

                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(left:5.0),
                                                          child: Container(
                                                            child: Text(
                                                              DefaultSlot[i].type == "1"?
                                                              DefaultSlot[i]
                                                                  .varName! +
                                                                  " * " +
                                                                  DefaultSlot[i]
                                                                      .weight
                                                                      .toString()
                                                                  :DefaultSlot[i]
                                                                  .varName! +
                                                                  " * " +
                                                                  DefaultSlot[i]
                                                                      .quantity
                                                                      .toString()

                                                              ,
                                                              overflow: TextOverflow
                                                                  .ellipsis,
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight
                                                                      .w400,
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ),
                                                        ),
                                                        Spacer(),

                                                        RichText(
                                                            text: new TextSpan(
                                                              children: <TextSpan>[
                                                                new TextSpan(
                                                                  text:_checkmembership ?
                                                                  Features.iscurrencyformatalign?DefaultSlot[i].type == "1"?
                                                                  ((double.parse(DefaultSlot[i]
                                                                      .membershipPrice!) *
                                                                      double.parse(DefaultSlot[i]
                                                                          .weight!))
                                                                      .toString() + " " + IConstants
                                                                      .currencyFormat):
                                                                  ((double.parse(DefaultSlot[i]
                                                                      .membershipPrice!) *
                                                                      int.parse(DefaultSlot[i]
                                                                          .quantity!))
                                                                      .toString() + " " + IConstants
                                                                      .currencyFormat):DefaultSlot[i].type == "1"?
                                                                  (IConstants
                                                                      .currencyFormat + " " +
                                                                      (double.parse(DefaultSlot[i]
                                                                          .membershipPrice!) *
                                                                          double.parse(DefaultSlot[i]
                                                                              .weight!))
                                                                          .toString())

                                                                      :(IConstants
                                                                      .currencyFormat + " " +
                                                                      (double.parse(DefaultSlot[i]
                                                                          .membershipPrice!) *
                                                                          int.parse(DefaultSlot[i]
                                                                              .quantity!))
                                                                          .toString()) :
                                                                  Features.iscurrencyformatalign?
                                                                  DefaultSlot[i].type == "1"?
                                                                  ((double.parse(DefaultSlot[i].price!)*
                                                                      double.parse(DefaultSlot[i]
                                                                          .weight!))
                                                                      .toString()+
                                                                      " " + IConstants.currencyFormat):
                                                                  ((double.parse(DefaultSlot[i].price!)*
                                                                      int.parse(DefaultSlot[i]
                                                                          .quantity!))
                                                                      .toString()+
                                                                      " " + IConstants.currencyFormat):
                                                                  DefaultSlot[i].type == "1"?
                                                                  (IConstants.currencyFormat +
                                                                      " " +
                                                                      (double.parse(DefaultSlot[i].price!)*
                                                                          double.parse(DefaultSlot[i]
                                                                              .weight!))
                                                                          .toString())
                                                                      :(IConstants.currencyFormat +
                                                                      " " +
                                                                      (double.parse(DefaultSlot[i].price!)*
                                                                          int.parse(DefaultSlot[i]
                                                                              .quantity!))
                                                                          .toString()) ,// 'HOME DELIVERY',
                                                                  style: TextStyle(
                                                                    color: ColorCodes.blackColor,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize:13,
                                                                  ),
                                                                ),
                                                                new TextSpan(
                                                                  text: _checkmembership ?
                                                                  Features.iscurrencyformatalign?DefaultSlot[i].type == "1"?
                                                                  ((double.parse(DefaultSlot[i]
                                                                      .varMrp!) *
                                                                      double.parse(DefaultSlot[i]
                                                                          .weight!))
                                                                      .toString() + " " + IConstants
                                                                      .currencyFormat):
                                                                  ((double.parse(DefaultSlot[i]
                                                                      .varMrp!) *
                                                                      int.parse(DefaultSlot[i]
                                                                          .quantity!))
                                                                      .toString() + " " + IConstants
                                                                      .currencyFormat):DefaultSlot[i].type == "1"?
                                                                  (IConstants
                                                                      .currencyFormat + " " +
                                                                      (double.parse(DefaultSlot[i]
                                                                          .varMrp!) *
                                                                          double.parse(DefaultSlot[i]
                                                                              .weight!))
                                                                          .toString()):
                                                                  (IConstants
                                                                      .currencyFormat + " " +
                                                                      (double.parse(DefaultSlot[i]
                                                                          .varMrp!) *
                                                                          int.parse(DefaultSlot[i]
                                                                              .quantity!))
                                                                          .toString()) :
                                                                  Features.iscurrencyformatalign?DefaultSlot[i].type == "1"?
                                                                  ((double.parse(DefaultSlot[i].varMrp!)*
                                                                      double.parse(DefaultSlot[i]
                                                                          .weight!))
                                                                      .toString()+
                                                                      " " + IConstants.currencyFormat):
                                                                  ((double.parse(DefaultSlot[i].varMrp!)*
                                                                      int.parse(DefaultSlot[i]
                                                                          .quantity!))
                                                                      .toString()+
                                                                      " " + IConstants.currencyFormat):DefaultSlot[i].type == "1"?
                                                                  (IConstants.currencyFormat +
                                                                      " " +
                                                                      (double.parse(DefaultSlot[i].varMrp!)*
                                                                          double.parse(DefaultSlot[i]
                                                                              .weight!))
                                                                          .toString()):
                                                                  (IConstants.currencyFormat +
                                                                      " " +
                                                                      (double.parse(DefaultSlot[i].varMrp!)*
                                                                          int.parse(DefaultSlot[i]
                                                                              .quantity!))
                                                                          .toString()) ,// 'HOME DELIVERY',
                                                                  style: TextStyle(
                                                                    color: ColorCodes.greyColor,
                                                                    // fontWeight: FontWeight.bold,
                                                                    fontSize:9,
                                                                    decoration:TextDecoration.lineThrough,

                                                                  ),
                                                                ),
                                                              ],
                                                            )),


                                                        /*Container(
                                                          child: Text(
                                                            _checkmembership ?
                                                            Features.iscurrencyformatalign?
                                                            ((double.parse(DefaultSlot[i]
                                                                .membershipPrice!) *
                                                                int.parse(DefaultSlot[i]
                                                                    .quantity!))
                                                                .toString() + " " + IConstants
                                                                .currencyFormat):
                                                            (IConstants
                                                                .currencyFormat + " " +
                                                                (double.parse(DefaultSlot[i]
                                                                    .membershipPrice!) *
                                                                    int.parse(DefaultSlot[i]
                                                                        .quantity!))
                                                                    .toString()) :
                                                            Features.iscurrencyformatalign?
                                                            ((double.parse(DefaultSlot[i].price!)*
                                                                int.parse(DefaultSlot[i]
                                                                    .quantity!))
                                                                .toString()+
                                                                " " + IConstants.currencyFormat):
                                                            (IConstants.currencyFormat +
                                                                " " +
                                                                (double.parse(DefaultSlot[i].price!)*
                                                                    int.parse(DefaultSlot[i]
                                                                        .quantity!))
                                                                    .toString()),
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight: FontWeight.w600,
                                                                color: Colors.black),
                                                          ),
                                                        ),*/
                                                      ],
                                                    ),
                                                  ])),



                                        ],
                                      ),
                                    ),
                                  )
                                ],
                                ):SizedBox.shrink(),
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
                );
              });
        });
  }

  gradientappbarmobile() {
    return  AppBar(
      brightness: Brightness.dark,
      toolbarHeight: 60.0,
      elevation:  (IConstants.isEnterprise)?0:1,
      automaticallyImplyLeading: false,
      leading: IconButton(
          icon: Icon(Icons.arrow_back, color:ColorCodes.iconColor),
          onPressed: () async{
            removeToCart();
            // Navigator.of(context).pop();
            /*Navigator.of(context).pushReplacementNamed(CartScreen.routeName,arguments: {
              "afterlogin": ""
            });*/
            if(widget.prev["prev"].toString() == "cart_screen") {
              PrefUtils.prefs!.setString("confirmback", "yes");
              Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":""});
            }
            else{
             // Navigation(context, navigatore: NavigatoreTyp.Pop);
              Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":""});
            }
           // Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin": ""});

            // Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
            return Future.value(false);
          }
      ),
      titleSpacing: 0,
      title: Text(
        S .of(context).checkout,//'Checkout',
          style: TextStyle(color: ColorCodes.iconColor, fontWeight: FontWeight.bold, fontSize: 18)
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
  removeToCart() async {
    String? itemId, varId, varName,
        varMinItem, varMaxItem, varLoyalty, varStock, varMrp, itemName, qty, price, membershipPrice, itemImage, veg_type, type,eligibleforexpress,delivery,duration,durationType,note;
    // widget.isdbonprocess();
    //  if (itemCount + 1 <= int.parse(widget.varminitem)) {
    productBox = (VxState.store as GroceStore).CartItemList;
    try {
      for (int i = 0; i < productBox.length; i++) {
        if (productBox[i].mode =="4") {
          itemId = productBox[i]
              .itemId
              .toString();
          varId = productBox[i]
              .varId
              .toString();
          varName = productBox[i]
              .varName!;
          varMinItem = productBox[i]
              .varMinItem
              .toString();
          varMaxItem = productBox[i]
              .varMaxItem
              .toString();
          varLoyalty = productBox[i]
              .itemLoyalty
              .toString();
          varStock = productBox[i]
              .varStock
              .toString();
          varMrp = productBox[i]
              .varMrp
              .toString();
          itemName = productBox[i]
              .itemName!;
          price = productBox[i]
              .price
              .toString();
          membershipPrice = productBox[i]
              .membershipPrice
              .toString();
          itemImage = productBox[i]
              .itemImage!;
          veg_type = productBox[i]
              .vegType!;
          type = productBox[i]
              .type!;
          eligibleforexpress = productBox[i]
              .eligibleForExpress!;
          delivery = productBox[i]
              .delivery!;
          duration = productBox[i]
              .duration!;
          durationType = productBox[i]
              .durationType!;
          note = productBox[i]
              .note!;
          break;
        }
      }
      cartcontroller.update((done){
      },price: double.parse(price!).toString(),var_id:varId!,quantity: "0",weight: "0",cart_id: "",toppings: "",
        topping_id: "",);
    }catch(e){

    }
  }
  _updateCart(int qty,CartStatus cart,String varid,String price,String increment, String cart_id) {
    switch (cart) {
      case CartStatus.increment:
        cartcontroller.update((done){
        },price: price.toString(),
            quantity: (qty + 1).toString(),
            weight: (qty + 1).toString(),
            var_id: varid,
          increament: increment,
          cart_id: cart_id,
          toppings: "",
          topping_id: "",
        );
        // TODO: Handle this case.
        break;
      case CartStatus.remove:
        cartcontroller.update((done){
          if(productBox.length <= 0){
            Navigation(context, navigatore: NavigatoreTyp.homenav);
          }else{
            Navigation(context, name:Routename.ConfirmOrder,navigatore: NavigatoreTyp.Push,
                parms:{"prev": "cart_screen"});
          }
        },price: price.toString(), quantity: "0",weight: "0", var_id: varid,increament: increment, cart_id: cart_id,toppings: "",
          topping_id: "",);

        // TODO: Handle this case.
        break;
      case CartStatus.decrement:
        cartcontroller.update((done){
          // setState(() {
          //   _isAddToCart = !done;
          // });
        },price: price.toString(),
            quantity: (qty - 1).toString(),
            weight: (qty-1).toString(),
            var_id: varid,increament: increment, cart_id: cart_id,toppings: "",
          topping_id: "",);
        // TODO: Handle this case.
        break;
    }
  }
  /*incrementToCart(itemCount, int varIdb, String itemNameb, int itemId, String varName, int varMinItem, int varMaxItem, int varStock, double varMrp, int quantity, double price, String membershipPrice, double itemActualprice, String itemImage, String veg_type, String type) async {
    // widget.isdbonprocess();

    if (itemCount + 1 <= varMinItem) {
      itemCount = 0;
    }
    final s = await Provider.of<CartItems>(context, listen: false).
    updateCart(varIdb.toString(), itemCount.toString(), itemActualprice.toString()).then((_)
    async{
      if (itemCount + 1 == varMinItem) {
        for (int i = 0; i < productBox.values.length; i++) {
          if (productBox[i].mode == 1) {
            PrefUtils.prefs!.setString("membership", "0");
          }
          if (productBox[i].varId == varIdb) {
            productBox.deleteAt(i);
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(
                ConfirmorderScreen.routeName,
                arguments: {"prev": "cart_screen",
                });
            break;
          }
        }
        final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);
        for(int i = 0; i < sellingitemData.featuredVariation.length; i++) {
          if(sellingitemData.featuredVariation[i].varid == varIdb) {
            sellingitemData.featuredVariation[i].varQty = itemCount;
          }
        }
        for (int i = 0; i < sellingitemData.itemspricevarOffer.length; i++) {
          if (sellingitemData.itemspricevarOffer[i].varid == varIdb) {
            sellingitemData.itemspricevarOffer[i].varQty = itemCount;
            break;
          }
        }
        for(int i = 0; i < sellingitemData.itemspricevarSwap.length; i++) {
          if(sellingitemData.itemspricevarSwap[i].varid == varIdb) {
            sellingitemData.itemspricevarSwap[i].varQty = itemCount;
            break;
          }
        }
        for(int i = 0; i < sellingitemData.discountedVariation.length; i++) {
          if(sellingitemData.discountedVariation[i].varid == varIdb) {
            sellingitemData.discountedVariation[i].varQty = itemCount;
            break;
          }
        }
        _bloc.setFeaturedItem(sellingitemData);

        final cartItemsData = Provider.of<CartItems>(context, listen: false);
        for(int i = 0; i < cartItemsData.items.length; i++) {
          if(cartItemsData.items[i].varId == varIdb) {
            cartItemsData.items[i].quantity = itemCount;
          }
        }
        _bloc.setCartItem(cartItemsData);
        Provider.of<CartItems>(context, listen: false).fetchCartItems().then((_) {
          setState(() {
            // _isAddToCart = false;
          });
        });
      }
      else {
        final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);
        for(int i = 0; i < sellingitemData.featuredVariation.length; i++) {
          if(sellingitemData.featuredVariation[i].varid == varIdb) {
            sellingitemData.featuredVariation[i].varQty = itemCount;
          }
        }
        _bloc.setFeaturedItem(sellingitemData);
        for (int i = 0; i < sellingitemData.itemspricevarOffer.length; i++) {
          if (sellingitemData.itemspricevarOffer[i].varid == varIdb) {
            sellingitemData.itemspricevarOffer[i].varQty = itemCount;
            break;
          }
        }
        for(int i = 0; i < sellingitemData.itemspricevarSwap.length; i++) {
          if(sellingitemData.itemspricevarSwap[i].varid == varIdb) {
            sellingitemData.itemspricevarSwap[i].varQty = itemCount;
            break;
          }
        }
        _bloc.setFeaturedItem(sellingitemData);
        for(int i = 0; i < sellingitemData.discountedVariation.length; i++) {
          if(sellingitemData.discountedVariation[i].varid == varIdb) {
            sellingitemData.discountedVariation[i].varQty = itemCount;
            break;
          }
        }
        _bloc.setFeaturedItem(sellingitemData);

        final cartItemsData = Provider.of<CartItems>(context, listen: false);
        for(int i = 0; i < cartItemsData.items.length; i++) {
          if(cartItemsData.items[i].varId == varIdb) {
            cartItemsData.items[i].quantity = itemCount;
          }
        }
        _bloc.setCartItem(cartItemsData);

        setState(() {
          // _isAddToCart = false;
        });
        Product products = Product(
          itemId: itemId,
          varId: varIdb,
          varName: varName,
          varMinItem: varMinItem,
          varMaxItem: varMaxItem,
          varStock: varStock,
          varMrp: varMrp,
          itemName: itemNameb,
          quantity: itemCount,
          price: price,
          membershipPrice: membershipPrice,
          itemActualprice:itemActualprice,
          itemImage: itemImage,
          membershipId: 0,
          mode: 0,
          veg_type: veg_type,
          type: type,
        );

        var items = Hive.box<Product>(productBoxName);

        for (int i = 0; i < items.length; i++) {
          if (Hive.box<Product>(productBoxName).values.elementAt(i).varId == varIdb) {
            Hive.box<Product>(productBoxName).putAt(i, products);
          }
        }
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(
            ConfirmorderScreen.routeName,
            arguments: {"prev": "cart_screen",
            });
      }

    });
  }
 */


  Widget handler(bool isSelected, status) {
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
  /*Widget _myRadioButtonTime({int value, Function onChanged}) {
    //prefs.setString('fixtime', timeslotsData[_groupValue].time);

    return Radio(
      activeColor: Theme.of(context).primaryColor,
      value: value,
      groupValue: _groupValueTime,
      onChanged: onChanged,
    );
  }*/

   dialogforMinimumOrder() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: (){
         /*   Navigator.of(context).pushReplacementNamed(CartScreen.routeName,arguments: {
              "afterlogin": ""
            });*/
           // Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
            if(widget.prev["prev"].toString() == "cart_screen") {
              PrefUtils.prefs!.setString("confirmback", "yes");
              Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":""});
            }
            else{
              // Navigation(context, navigatore: NavigatoreTyp.Pop);
              Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":""});
            }
            return Future.value(false);
          },
          child: AlertDialog(
            title: Image.asset(
              Images.logoImg,
              height: 50,
              width: 138,
            ),
            content: Text(S
                .of(context)
                .min_order_amount +" "+
                double.parse(
                    IConstants.minimumOrderAmount).toStringAsFixed(
                    (IConstants.numberFormat == "1")
                        ?0:IConstants.decimaldigit)),
            actions: <Widget>[
              Vx.isWeb? SizedBox.shrink():FlatButton(
                child: Text(
                  S .of(context).continue_shopping,//'Ok'
                  style: TextStyle(
                    color: ColorCodes.primaryColor,
                    fontSize: 14
                  ),
                ),
                onPressed: () async {
                  Navigation(context, navigatore: NavigatoreTyp.homenav);
                },
              ),
            ],
          ),
        );
      },
    );
  }

}