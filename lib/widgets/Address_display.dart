import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../assets/ColorCodes.dart';
import '../assets/images.dart';
import '../constants/IConstants.dart';
import '../constants/api.dart';
import '../constants/features.dart';
import '../controller/mutations/address_mutation.dart';
import '../controller/mutations/home_screen_mutation.dart';
import '../generated/l10n.dart';
import '../models/VxModels/VxStore.dart';
import '../models/newmodle/cartModle.dart';
import '../providers/cartItems.dart';
import '../repository/address_repo.dart';
import '../repository/authenticate/AuthRepo.dart';
import '../screens/address_screen.dart';
import '../screens/addressbook_screen.dart';
import '../utils/ResponsiveLayout.dart';
import '../utils/prefUtils.dart';
import '../rought_genrator.dart';
import 'package:http/http.dart' as http;

class AddressDisplay extends StatefulWidget{
  BuildContext? context;
  int? i;
  String? billingAddressId;
  String? fromscreen;
  AddressDisplay( {Key? key,this.context, this.i,this.billingAddressId, this.fromscreen}) : super(key: key);
  @override
  State<AddressDisplay> createState() => _AddressDisplayState();
}

class _AddressDisplayState extends State<AddressDisplay> with Navigations{
  var addressdata;
  var deliverylocation;
  String? currentBranch;
  List<CartItem> productBox=[];
  String confirmSwap="";
  @override
  void initState() {

    productBox = (VxState.store as GroceStore).CartItemList;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return printAddress();
  }
  _dialogforDeleting(context,{builder}) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          builder(context);
          return StatefulBuilder(builder: (context, setState) {
            return AbsorbPointer(
              child: WillPopScope(
                onWillPop: (){
                  return Future.value(true);
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
  _dialogforDeleteAdd(BuildContext context, String addressid) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              child: Container(
                  width: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.25:MediaQuery.of(context).size.width,
                  height: 100.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Text(
                          S .of(context).are_sure_delete,//'Are you sure you want to delete this address?',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: <Widget>[
                          Spacer(),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop(true);
                              },
                              child: Text(
                                S .of(context).no,//'NO',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 14.0),
                              )),
                          SizedBox(
                            width: 20.0,
                          ),
                          GestureDetector(
                              onTap: () async{
                                var ctx ;
                                Navigator.of(context).pop();
                                _dialogforDeleting(context,builder: (context){
                                  ctx = context;
                                });
                                //deleteaddress(addressid);
                                AddressController addressController = AddressController();

                                await addressController.remove(addressId: addressid, apiKey: (VxState.store as GroceStore).userData.id!, branch:PrefUtils.prefs!.getString('branch')!);
                                Navigator.of(ctx).pop();
                              },
                              child: Text(
                                S .of(context).yes,//'YES',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 14.0),
                              )),
                          SizedBox(
                            width: 20.0,
                          ),
                        ],
                      )
                    ],
                  )),
            );
          });
        });
  }

  Future<void> checkLocation(String adressSelected) async {
    var url =Api.checkLocationmultivendor;

    debugPrint("sdfgb..."+url.toString());
    try {
      final response = await http.post(url, body: {
        "lat":(VxState.store as GroceStore).userData.billingAddress![0].lattitude,
        "long": (VxState.store as GroceStore).userData.billingAddress![0].logingitude,
        "branch": PrefUtils.prefs!.getString("branch"),
        "ref": IConstants.refIdForMultiVendor.toString(),
        "branchtype": IConstants.branchtype.toString(),
      });

      final responseJson = json.decode(response.body);
      debugPrint("hgfd...."+responseJson.toString());

      if (responseJson['status'].toString() == "yes") {
        PrefUtils.prefs!.setString('defaultlocation', "true");
        PrefUtils.prefs!.setString("isdelivering","true");
        currentBranch = responseJson['branch'].toString();
        print("current branch...."+currentBranch.toString() +"///"+PrefUtils.prefs!.getString("branch").toString());
        if(PrefUtils.prefs!.getString("branch") == responseJson['branch'].toString()) {
          (VxState.store as GroceStore).userData.branch = PrefUtils.prefs!.getString('branch');
          debugPrint("before set..."+ (VxState.store as GroceStore).userData.area!+"...."+adressSelected);
          (VxState.store as GroceStore).userData.area = adressSelected;
          debugPrint("after set..."+ (VxState.store as GroceStore).userData.area!);
          (VxState.store as GroceStore).userData.delevrystatus = responseJson["status"].toString() == "yes"?true:false;

          IConstants.deliverylocationmain.value = adressSelected;
          IConstants.currentdeliverylocation.value = S .of(widget.context!).location_available;

          print("delivery location map....."+IConstants.deliverylocationmain.value.toString());
          if (PrefUtils.prefs!.getString("formapscreen") == "addressscreen") {

            final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
            Navigator.of(context).pop();
            Navigation(context, name: Routename.AddressScreen, navigatore: NavigatoreTyp.Push,
                qparms: {
                  'addresstype': "new",
                  'addressid': "",
                  'delieveryLocation': addressdata.billingAddress[0].address.toString(),
                  'latitude':  (VxState.store as GroceStore).userData.billingAddress![0].lattitude,
                  'longitude': (VxState.store as GroceStore).userData.billingAddress![0].logingitude,
                  'branch': responseJson['branch'].toString(),
                  'houseNo' : routeArgs['houseNo'],
                  'apartment' : routeArgs['apartment'],
                  'street' :  routeArgs['street'],
                  'landmark' : routeArgs['landmark'],
                  'area' : routeArgs['area'],
                  'pincode' : routeArgs['pincode'],
                });
          }
          else {
            PrefUtils.prefs!.setString('branch', responseJson['branch'].toString());
            PrefUtils.prefs!.setString('deliverylocation', adressSelected);
            PrefUtils.prefs!.setString("latitude", (VxState.store as GroceStore).userData.billingAddress![0].lattitude.toString());
            PrefUtils.prefs!.setString("longitude",(VxState.store as GroceStore).userData.billingAddress![0].logingitude.toString());
            if (PrefUtils.prefs!.getString("skip") == "no") {
              addprimarylocation("","","");
            } else {
              debugPrint("same..."+addressdata.billingAddress[0].address.toString());

              Navigator.of(context).pop();
              if (PrefUtils.prefs!.getString("formapscreen") == "" ||
                  PrefUtils.prefs!.getString("formapscreen") == "homescreen") {
                if (PrefUtils.prefs!.containsKey("fromcart")) {
                  if (PrefUtils.prefs!.getString("fromcart") == "cart_screen") {
                    PrefUtils.prefs!.remove("fromcart");
                    debugPrint("cart....17");

                    Navigation(context,name: Routename.MapScreen, navigatore: NavigatoreTyp.Push);
                    debugPrint("cart....18");
                    Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
                  } else {
                    debugPrint("location 1 . . . . .");
                    Navigation(context, navigatore: NavigatoreTyp.homenav);
                  }
                } else {
                  debugPrint("location 2 . . . . .");
                  HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
                      PrefUtils.prefs!.getString("tokenid"),
                      branch: (VxState.store as GroceStore).userData.branch ?? "999",
                      rows: "0");
                  Navigation(context, navigatore: NavigatoreTyp.homenav);
                }
              }
            }
          }
        } else {

          IConstants.deliverylocationmain.value = adressSelected;
          IConstants.currentdeliverylocation.value = S .of(widget.context!).location_available;
            if (productBox.length > 0) {
              debugPrint("nbvhfddbd....");//Suppose cart is not empty
              _dialogforAvailability(
                  PrefUtils.prefs!.getString("branch")!,
                  responseJson['branch'].toString(),
                  PrefUtils.prefs!.getString("deliverylocation")!,
                  PrefUtils.prefs!.getString("latitude")!,
                  PrefUtils.prefs!.getString("longitude")!);
            } else {
              debugPrint("nbvhfddbd....1...");
              (VxState.store as GroceStore).userData.branch = PrefUtils.prefs!.getString('branch');
              debugPrint("before set...1.."+ (VxState.store as GroceStore).userData.area!+"...."+adressSelected);
              (VxState.store as GroceStore).userData.area = adressSelected;
              debugPrint("after set...1.."+ (VxState.store as GroceStore).userData.area!);
              (VxState.store as GroceStore).userData.delevrystatus = responseJson["status"].toString() == "yes"?true:false;

              PrefUtils.prefs!.setString('branch', responseJson['branch'].toString());
              PrefUtils.prefs!.setString('deliverylocation', adressSelected);
              PrefUtils.prefs!.setString("latitude", (VxState.store as GroceStore).userData.billingAddress![0].lattitude.toString());
              PrefUtils.prefs!.setString("longitude", (VxState.store as GroceStore).userData.billingAddress![0].logingitude.toString());
              if (PrefUtils.prefs!.getString("skip") == "no") {
                addprimarylocation("","","");
              } else {

                Navigator.of(context).pop();
                if (PrefUtils.prefs!.getString("formapscreen") == "" ||
                    PrefUtils.prefs!.getString("formapscreen") == "homescreen") {
                  if (PrefUtils.prefs!.containsKey("fromcart")) {
                    if (PrefUtils.prefs!.getString("fromcart") == "cart_screen") {
                      PrefUtils.prefs!.remove("fromcart");
                      debugPrint("cart....19");
                      Navigation(context,name: Routename.MapScreen, navigatore: NavigatoreTyp.Push);
                      debugPrint("cart....20");
                      Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
                    } else {
                      debugPrint("location 3 . . . . .");
                      //Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                      Navigation(context, navigatore: NavigatoreTyp.homenav);
                    }
                  } else {
                    debugPrint("location 4 . . . . .");
                    HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
                        PrefUtils.prefs!.getString("tokenid"),
                        branch: (VxState.store as GroceStore).userData.branch ?? "999",
                        rows: "0");
                    Navigation(context, navigatore: NavigatoreTyp.homenav);
                  }
                } else if (PrefUtils.prefs!.getString("formapscreen") == "addressscreen") {
                  Navigation(context, name: Routename.AddressScreen, navigatore: NavigatoreTyp.Push,
                      qparms: {
                        'addresstype': "new",
                        'addressid': "",
                      });
                }
              }
            }

        }
      } else {
        Navigator.of(context).pop();
        PrefUtils.prefs!.setString("isdelivering","false");
        IConstants.currentdeliverylocation.value = S .of(widget.context!).not_available_location;
       // showInSnackBar();
      }
     } catch (error) {
       throw error;
     }
  }



  _dialogforAvailability(String prevBranch, String currentBranch, String deliveryLocation, String latitude, String longitude) async {
    String itemCount = "";
    itemCount = "   " + productBox.length.toString() + " " + S .of(widget.context!).items;//"items"
    var similarlistData;
    var _checkitem = false;
    bool _checkMembership = false;

    if(PrefUtils.prefs!.getString("membership") == "1"){
      _checkMembership = true;
    } else {
      _checkMembership = false;
    }

    return showDialog(context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState) {
                return Dialog(
                  insetPadding: EdgeInsets.only(left: 20.0, right: 20.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0)
                  ),
                  child: Container(
                      height: MediaQuery.of(context).size.height * 85 / 100,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 10.0,),
                          new RichText(
                            text: new TextSpan(
                              // Note: Styles for TextSpans must be explicitly defined.
                              // Child text spans will inherit styles from parent
                              style: new TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                              children: <TextSpan>[
                                TextSpan(text: S .of(widget.context!).Availability_Check,//"Availability Check",
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16.0),),
                                new TextSpan(text: itemCount, style: TextStyle(color: Colors.grey, fontSize: 12.0)
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.0,),
                          Text(S .of(widget.context!).changing_area,//"Changing area",
                            style: TextStyle(color: Colors.red, fontSize: 12.0,),),
                          SizedBox(height: 10.0,),
                          Text(S .of(widget.context!).product_price_availability,
                            style: TextStyle(fontSize: 12.0),),
                          Spacer(),
                          SizedBox(height: 5.0,),
                          Divider(),
                          SizedBox(height: 5.0,),

                          Row(
                            children: <Widget>[
                              Container(
                                width: 53.0,
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(S .of(widget.context!).items,//"Items",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),),),

                              Expanded(
                                flex: 4,
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(width: 15.0,),
                                    Text(S .of(widget.context!).reason,//"Reason",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.0,),
                          Divider(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 30 / 100,
                            child: new ListView.builder(
                              //physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: productBox.length,
                                itemBuilder: (_, i)
                                {

                                  return Column(
                                    children: [
                                      Row(
                                        children: <Widget>[
                                          FadeInImage(
                                            image: NetworkImage(productBox[i].itemImage!),
                                            placeholder: AssetImage(
                                                Images.defaultProductImg),
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
                                                    (productBox[i].itemName!),
                                                    style:
                                                    TextStyle(fontSize: 12.0)),
                                                SizedBox(
                                                  height: 3.0,
                                                ),
                                                _checkMembership
                                                    ? productBox[i].membershipPrice ==
                                                    '-' ||
                                                    (productBox[i]
                                                        .membershipPrice ==
                                                        "0")
                                                    ? (double.parse(productBox[i].price!)) <= 0 ||
                                                    (double.parse(productBox[i].price!).toString() ==
                                                        "" ||
                                                        productBox[i].price ==
                                                            productBox[i].varMrp)
                                                    ? Text(
                                                    Features.iscurrencyformatalign?
                                                    productBox[i].varMrp.toString() + " " + IConstants.currencyFormat:
                                                    IConstants.currencyFormat + " " + productBox[i].varMrp.toString(),
                                                    style: TextStyle(
                                                        fontSize: 12.0))
                                                    : Text(
                                                    Features.iscurrencyformatalign?
                                                    productBox[i].price
                                                        .toString() +
                                                        " " + IConstants.currencyFormat :
                                                    IConstants.currencyFormat +
                                                        " " +
                                                        productBox[i].price
                                                            .toString(),
                                                    style: TextStyle(fontSize: 12.0))
                                                    : Text(
                                                    Features.iscurrencyformatalign?productBox[i].membershipPrice! + " " + IConstants.currencyFormat:
                                                    IConstants.currencyFormat + " " + productBox[i].membershipPrice!, style: TextStyle(fontSize: 12.0))
                                                    : (double.parse(productBox[i].price.toString()) <= 0 || productBox[i].price.toString() == "" || productBox[i].price == productBox[i].varMrp)
                                                    ? Text(
                                                    Features.iscurrencyformatalign?
                                                    productBox[i].varMrp! + " " +IConstants.currencyFormat :
                                                    IConstants.currencyFormat + " " + productBox[i].varMrp.toString(), style: TextStyle(fontSize: 12.0))
                                                    : Text(Features.iscurrencyformatalign?
                                                productBox[i].price.toString() + " " + IConstants.currencyFormat :IConstants.currencyFormat + " " + productBox[i].price.toString(), style: TextStyle(fontSize: 12.0))
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                              flex: 4,
                                              child: Text(
                                                  S
                                                      .of(widget.context!)
                                                      .not_available, //"Not available",
                                                  style:
                                                  TextStyle(fontSize: 12.0))),
                                        ],
                                      ),

                                    ],
                                  );
                                }),
                          ),
                          SizedBox(height: 10.0,),
                          Divider(),
                          SizedBox(height: 20.0,),
                          new RichText(
                            text: new TextSpan(
                              // Note: Styles for TextSpans must be explicitly defined.
                              // Child text spans will inherit styles from parent
                              style: new TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                              children: <TextSpan>[
                                new TextSpan(text: S .of(widget.context!).note,//'Note: ',
                                    style: TextStyle(fontWeight: FontWeight.bold, )),
                                new TextSpan(text: S .of(widget.context!).by_clicking_confirm,//'By clicking on confirm, we will remove the unavailable items from your basket.',
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  if (PrefUtils.prefs!.getString("formapscreen") == "" ||
                                      PrefUtils.prefs!.getString("formapscreen") == "homescreen") {
                                    if (PrefUtils.prefs!.containsKey("fromcart")) {
                                      if (PrefUtils.prefs!.getString("fromcart") == "cart_screen") {
                                        PrefUtils.prefs!.remove("fromcart");
                                        debugPrint("cart....21");
                                        Navigation(context,name: Routename.MapScreen, navigatore: NavigatoreTyp.Push);
                                        debugPrint("cart....22");
                                        Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
                                      } else {
                                        debugPrint("location 5 . . . . .");
                                        Navigation(context, navigatore: NavigatoreTyp.homenav);
                                      }
                                    } else {
                                      debugPrint("location 6 . . . . .");
                                      Navigation(context, navigatore: NavigatoreTyp.homenav);
                                    }
                                  } else if (PrefUtils.prefs!.getString("formapscreen") == "addressscreen") {

                                    Navigation(context, name: Routename.AddressScreen, navigatore: NavigatoreTyp.Push,
                                        qparms: {
                                          'addresstype': "new",
                                          'addressid': "",
                                        });
                                  }                               },
                                child: new Container(
                                  width: MediaQuery.of(context).size.width * 35 / 100,
                                  height: 30.0,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey)
                                  ),
                                  child: new Center(
                                    child: Text(S .of(widget.context!).map_cancel,//"CANCEL"
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20.0,),
                              GestureDetector(
                                onTap: () async {
                                  (VxState.store as GroceStore).userData.branch = PrefUtils.prefs!.getString('branch');
                                  (VxState.store as GroceStore).userData.area = addressdata.billingAddress[0].address.toString();


                                  PrefUtils.prefs!.setString('branch', currentBranch);
                                  PrefUtils.prefs!.setString('deliverylocation', addressdata.billingAddress[0].address.toString());
                                  PrefUtils.prefs!.setString("latitude", addressdata.billingAddress[0].lattitude.toString());
                                  PrefUtils.prefs!.setString("longitude", addressdata.billingAddress[0].logingitude.toString());

                                  if (PrefUtils.prefs!.getString("skip") == "no") {
                                    var com ="";
                                    String val = "";
                                    String item ="";
                                    for(int i = 0; i < productBox.length; i++){
                                      val = val+com+productBox[i].itemId.toString();
                                      if(productBox[i].mode == "3"){
                                        item = item +com+productBox[i].itemId.toString();
                                      }
                                      debugPrint("var id.. ${productBox[i].varId.toString()}");
                                      com = ",";
                                    }
                                    debugPrint("val... $val");
                                    Provider.of<CartItems>(context, listen: false).emptyCart().then((_) {

                                      setState(() {
                                        confirmSwap = "confirmSwap";
                                        debugPrint("confirmSwap..ss"+confirmSwap);
                                      });
                                      addprimarylocation(currentBranch,val,item);
                                    });

                                  } else {
                                    var com ="";
                                    String val = "";
                                    String item = "";
                                    for(int i = 0; i < productBox.length; i++){
                                      val = val+com+productBox[i].itemId.toString();
                                      if(productBox[i].mode == "3"){
                                        item = item +com+productBox[i].itemId.toString();
                                      }
                                      debugPrint("var id.. ${productBox[i].varId.toString()}");
                                      com = ",";
                                    }
                                    debugPrint("val... $val");
                                    Provider.of<CartItems>(context, listen: false).emptyCart().then((_) {

                                      try {
                                        if (Platform.isIOS || Platform.isAndroid) {
                                          //await Hive.openBox<Product>(productBoxName);

                                          debugPrint("Opening box . . . .  . . . ");
                                        }
                                      } catch (e) {
                                        //await Hive.openBox<Product>(productBoxName);
                                      }
                                      Navigator.of(context).pop();
                                      if (PrefUtils.prefs!.getString("formapscreen") == "" ||
                                          PrefUtils.prefs!.getString("formapscreen") == "homescreen") {
                                        if (PrefUtils.prefs!.containsKey("fromcart")) {
                                          if (PrefUtils.prefs!.getString("fromcart") == "cart_screen") {
                                            PrefUtils.prefs!.remove("fromcart");
                                            debugPrint("cart....23");

                                            Navigation(context,name: Routename.MapScreen, navigatore: NavigatoreTyp.Push);
                                            debugPrint("cart....23");
                                            Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
                                          } else {
                                            debugPrint("location 7 . . . . .");
                                            //Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                                            Navigation(context, navigatore: NavigatoreTyp.homenav);
                                          }
                                        } else {
                                          debugPrint("location 8 . . . . .");

                                          Navigation(context, name:Routename.NotAvailability,navigatore: NavigatoreTyp.Push,
                                              qparms: {
                                                "val" : val,
                                                "currentbranch": currentBranch,
                                                "item":item

                                              });
                                        }
                                      } else if (PrefUtils.prefs!.getString("formapscreen") == "addressscreen") {
                                        Navigation(context, name: Routename.AddressScreen, navigatore: NavigatoreTyp.Push,
                                            qparms: {
                                              'addresstype': "new",
                                              'addressid': "",
                                            });
                                      }
                                    });
                                  }
                                },
                                child: new Container(
                                    height: 30.0,
                                    width: MediaQuery.of(context).size.width * 35 / 100,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        border: Border.all(color: Theme.of(context).primaryColor,)
                                    ),
                                    child: new Center(
                                      child: Text(S .of(widget.context!).confirm,//"CONFIRM",
                                        style: TextStyle(color: Colors.white),),
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0,),
                        ],
                      )
                  ),
                );
              }
          );
        });
  }

  Future<void> addprimarylocation(String currentBranch, String val, String item) async {
    debugPrint("A d d p r i m r y ....." + val);

    var url = IConstants.API_PATH + 'add-primary-location';
    try {
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(url, body: {
        // await keyword is used to wait to this operation is complete.
        "id": PrefUtils.prefs!.getString("apikey"),

        "latitude":(VxState.store as GroceStore).userData.billingAddress![0].lattitude.toString(),
        "longitude": (VxState.store as GroceStore).userData.billingAddress![0].logingitude.toString(),
        "area": addressdata.billingAddress[0].address.toString(),
        "branch": PrefUtils.prefs!.getString('branch'),
        "ref":  IConstants.refIdForMultiVendor,
        "branchtype":  IConstants.branchtype.toString(),
      });
      final responseJson = json.decode(response.body);
      print("response add primary..."+responseJson.toString()+ (VxState.store as GroceStore).userData.branch.toString() + currentBranch.toString());

      debugPrint("confirmSwap..."+ confirmSwap+"...."+PrefUtils.prefs!.getString('branch')!);
      if (responseJson["data"].toString() == "true") {
        Navigator.of(context).pop();
        if (PrefUtils.prefs!.getString("formapscreen") == "" ||
            PrefUtils.prefs!.getString("formapscreen") == "homescreen") {
          if (PrefUtils.prefs!.containsKey("fromcart")) {
            if (PrefUtils.prefs!.getString("fromcart") == "cart_screen") {
              PrefUtils.prefs!.remove("fromcart");
              debugPrint("cart....24");
              /*Navigator.of(context).pushNamedAndRemoveUntil(MapScreen.routeName,
                  ModalRoute.withName(CartScreen.routeName),arguments: {
                    "after_login": ""
                  });*/
              Navigation(context,name: Routename.MapScreen, navigatore: NavigatoreTyp.Push);
              debugPrint("cart....25");
              Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
            } else {
              debugPrint("location 9 . . . . .");
              //Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
              Navigation(context, navigatore: NavigatoreTyp.homenav);
            }
          } else if(confirmSwap == "confirmSwap" )
          {
            debugPrint("confirm swap....entered");
            /* Navigator.of(context)
                .pushReplacementNamed(NotavailabilityProduct.routeName, arguments: {
              "currentBranch": currentBranch,
              "val": val
            });*/
            Navigation(context, name:Routename.NotAvailability,navigatore: NavigatoreTyp.Push,
                qparms: {
                  "val" : val,
                  "currentbranch": currentBranch,
                  "item":item

                });
          }
          else {
            debugPrint("location 10 . . . . ." );
            HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
                PrefUtils.prefs!.getString("tokenid"),
                branch: (VxState.store as GroceStore).userData.branch ?? "999",
                rows: "0");
            Navigation(context, navigatore: NavigatoreTyp.homenav);
            // Navigation(context, navigatore: NavigatoreTyp.homenav);
            //Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
          }
        }
        else if (PrefUtils.prefs!.getString("formapscreen") == "addressscreen") {
          /* Navigator.of(context)
              .pushReplacementNamed(AddressScreen.routeName, arguments: {
            'addresstype': "new",
            'addressid': "",
          });*/
          Navigation(context, name: Routename.AddressScreen, navigatore: NavigatoreTyp.Push,
              qparms: {
                'addresstype': "new",
                'addressid': "",
              });
        }

      }
    } catch (error) {
      Navigator.of(context).pop();
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

  Future<void> cartCheck( String addressid,
      String addressType, String adressSelected, IconData adressIcon, username,) async {
    Auth _auth = Auth();
   // AddressController addressController = AddressController();
  //  await addressController.setdefult(addressId: addressid,branch:PrefUtils.prefs!.getString('branch'));
    AddressRepo _addressRepo = AddressRepo();
    _addressRepo.setDefultAddress(addressId:addressid ,branch:PrefUtils.prefs!.getString('branch') ).then((value) async {
      SetAddress(value!);
      String itemId = "";
      for (int i = 0; i < productBox.length; i++) {
        if (itemId == "") {
          itemId = productBox[i].itemId.toString();
        } else {
          itemId =
              itemId + "," + productBox[i].itemId.toString();
        }
      }
      debugPrint("rehsjx..."+addressid.toString()+"...."+itemId.toString());
      var url = Api.cartCheck + addressid + "/" + itemId;
      try {
        final response = await http.get(
          url,
        );

        final responseJson = json.decode(response.body);
        debugPrint("rehsjx...1.."+responseJson.toString());
        checkLocation(adressSelected);
      } catch (error) {

        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: S .of(widget.context!).something_went_wrong,//"Something went wrong!",
            fontSize: MediaQuery.of(context).textScaleFactor *13,
            backgroundColor: Colors.black87,
            textColor: Colors.white);
        throw error;
      }
    });

  }



  Widget printAddress() {
    addressdata = (VxState.store as GroceStore).userData;
    if (addressdata.billingAddress[widget.i].isdefault == '1') {
      return GestureDetector(
        onTap: () {
          if(widget.fromscreen == "Mapscreen"){
            _dialogforProcessing();
            GroceStore store = VxState.store;
            store.homescreen.data = null;
            cartCheck(
            //  PrefUtils.prefs!.getString("addressId")!,
              addressdata!.billingAddress![widget.i].id.toString(),
              addressdata!.billingAddress![widget.i].addressType!,
              addressdata!.billingAddress![widget.i].address!,
              addressdata!.billingAddress![widget.i].addressicon!,
              addressdata!.billingAddress![widget.i].fullName,
            );
          }else {
            Navigator.of(context).pop(true);
          }
        },
        child: Container(
          //height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(left: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?5:20)),
              Align(
                  alignment: Alignment.topLeft,
                  child: Icon(Icons.radio_button_checked,
                      size: 18, color: ColorCodes.primaryColor)),
              Padding(padding: EdgeInsets.only(left: 10)),
              // (addressdata.billingAddress[widget.i].addressType == "home")? Image.asset(Images.homeConfirm,
              //   height: 25,
              //   width: 25,
              //   color: ColorCodes.blackColor,
              // ):(addressdata.billingAddress[widget.i].addressType == "Work")?Image.asset(Images.workConfirm,
              //   height: 25,
              //   width: 25,
              //   color: ColorCodes.blackColor,
              // ):Image.asset(Images.otherConfirm,
              //   height: 25,
              //   width: 25,
              //   color: ColorCodes.blackColor,
              // ),
             // Padding(padding: EdgeInsets.only(left: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?10:5)),
              Flexible(
                  fit: FlexFit.tight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      /*Align(
                        alignment: Alignment.topLeft,
                        child:*/
                      /*Text(
                        S .of(context).default_address,//'Default Address:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: ColorCodes.mediumBlackWebColor,
                        ),
                      ),*/
                      // ),
                      //Padding(padding: EdgeInsets.only(top: 5)),


                      new RichText(textAlign: TextAlign.start,
                        text: new TextSpan(

                          // Note: Styles for TextSpans must be explicitly defined.
                          // Child text spans will inherit styles from parent
                          style: new TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                          children: <TextSpan>[
                            new TextSpan(text: S.of(widget.context!).default_address+"\n",
                              style:new TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: ColorCodes.redColor), ),
                            new TextSpan(text: /*addressitemsData.items[i]*/addressdata.billingAddress[widget.i].addressType+"\n",
                              style:new TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: ColorCodes.blackColor), ),
                            new TextSpan(
                                text: addressdata.billingAddress[widget.i].address,
                                style:new TextStyle(fontSize: 14)
                              // style: new TextStyle(color: ColorCodes.darkgreen),
                            ),

                          ],
                        ),
                      ),
                      /* Text(
                        addressitemsData.items[i].useraddtype+  "\n" +addressitemsData.items[i].useraddress,
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorCodes.greyColor,
                        ),
                      ),*/
                    ],
                  )),

              Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?
              Row(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 60,),
                  FlatButton(
                    child: Text(
                      S .of(context)
                          .edit_address, //"Edit",
                      style: TextStyle(
                          color: ColorCodes.blackColor,
                          fontWeight: FontWeight.w700),
                    ),
                    onPressed: () {
                      setState(() {
                        PrefUtils.prefs!.setString(
                            "addressbook",
                            "AddressbookScreen");

                        if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                          // _dialogforaddress(context);
                          AddressWeb(context,
                              addresstype: "edit",
                              addressid: addressdata
                                  .billingAddress[widget.i].id
                                  .toString(),
                              delieveryLocation: deliverylocation,
                              latitude: addressdata
                                  .billingAddress[widget.i]
                                  .lattitude.toString(),
                              longitude: addressdata
                                  .billingAddress[widget.i]
                                  .logingitude.toString(),
                              branch: "");
                        }
                        else {
                          Navigation(context,
                              name: Routename.AddressScreen,
                              navigatore: NavigatoreTyp.Push,
                              qparms: {
                                'addresstype': "edit",
                                'addressid': addressdata
                                    .billingAddress[widget.i].id
                                    .toString(),
                                'delieveryLocation': deliverylocation,
                                'latitude': addressdata
                                    .billingAddress[widget.i]
                                    .lattitude.toString(),
                                'longitude': addressdata
                                    .billingAddress[widget.i]
                                    .logingitude.toString(),
                                'branch': ""
                              });
                        }
                      });
                    },
                  ),
                  SizedBox(width: 50,),
                  FlatButton(
                      child: Text(
                        S .of(context)
                            .delete_address, //"Delete",
                        style: TextStyle(
                            color: ColorCodes
                                .blackColor,
                            fontWeight: FontWeight.w700),
                      ),
                      onPressed: () {

                        _dialogforDeleteAdd(
                            context,
                            addressdata.billingAddress[widget.i].id.toString());
                      }),
                ],
              )
                  :GestureDetector(
                onTap: (){

                },
                child: PopupMenuButton(
                  onSelected: (FilterOptions selectedValue) {
                    if(selectedValue == FilterOptions.Edit/*"Edit"*//*S .of(context).edit*/){
                      setState(() {
                        PrefUtils.prefs!.setString(
                            "addressbook",
                            "AddressbookScreen");
                        /*        Navigator.of(context).pushReplacementNamed(
                                                    AddressScreen.routeName,
                                                    arguments: {
                                                      'addresstype': "edit",
                                                      'addressid': addressdata.billingAddress[i].id
                                                          .toString(),
                                                      'delieveryLocation': deliverylocation,
                                                      'latitude': addressdata.billingAddress[i].lattitude
                                                          .toString(),//"",
                                                      'longitude': addressdata.billingAddress[i].logingitude
                                                          .toString(),//"",
                                                      'branch': ""
                                                    });*/
                        if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                          // _dialogforaddress(context);
                          AddressWeb(context,
                              addresstype: "edit",
                              addressid: addressdata.billingAddress[widget.i].id
                                  .toString(),
                              delieveryLocation: deliverylocation,
                              latitude: addressdata.billingAddress[widget.i]
                                  .lattitude.toString(),
                              longitude: addressdata.billingAddress[widget.i]
                                  .logingitude.toString(),
                              branch: "");
                        }
                        else {
                          Navigation(context, name: Routename.AddressScreen,
                              navigatore: NavigatoreTyp.Push,
                              qparms: {
                                'addresstype': "edit",
                                'addressid': addressdata.billingAddress[widget.i].id
                                    .toString(),
                                'delieveryLocation': deliverylocation,
                                'latitude': addressdata.billingAddress[widget.i]
                                    .lattitude.toString(),
                                'longitude': addressdata.billingAddress[widget.i]
                                    .logingitude.toString(),
                                'branch': ""
                              });
                        }
                      });
                    }
                    else if(selectedValue ==  FilterOptions.Delete/*"Delete"*//*S .of(context).delete*/){
                      _dialogforDeleteAdd(context,
                          addressdata.billingAddress[widget.i].id.toString());
                    }
                    // _dialogforRemoving(context);
                    // removelist(
                    //     shoplistData.itemsshoplist[i].listid);
                  },
                  // icon: Icon(
                  //   Icons.more_horiz,
                  // ),
                  itemBuilder: (_) =>
                  [
                    PopupMenuItem(
                      child: Text(  S .of(widget.context!).edit,
                        style: TextStyle(fontSize: 10),
                        // 'Remove'
                      ),
                      value: FilterOptions.Edit,
                    ),
                    PopupMenuItem(
                      child: Text(  S .of(widget.context!).delete,
                        style: TextStyle(fontSize: 10),
                        // 'Remove'
                      ),
                      value: FilterOptions.Delete,
                    ),
                  ],
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: ShapeDecoration(
                      color: ColorCodes.whiteColor,
                      shape: StadiumBorder(
                        side: BorderSide(color: ColorCodes.lightgrey, width: 1),
                      ),
                    ),
                    child: Icon(Icons.more_horiz,color:IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    else {
      return GestureDetector(
        onTap: () async {
          if(widget.fromscreen == "Mapscreen"){
            _dialogforProcessing();
            GroceStore store = VxState.store;
            store.homescreen.data = null;
            cartCheck(
           //   PrefUtils.prefs!.getString("addressId")!,
              addressdata!.billingAddress![widget.i].id.toString(),
              addressdata!.billingAddress![widget.i].addressType!,
              addressdata!.billingAddress![widget.i].address!,
              addressdata!.billingAddress![widget.i].addressicon!,
              addressdata!.billingAddress![widget.i].fullName,

            );
          }else {
            AddressController addressController = AddressController();
            await addressController.setdefult(addressId: widget.billingAddressId,branch: PrefUtils.prefs!.getString('branch'));
          }
        },
        child: Container(
          // height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(left: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?5:20)),
              Align(
                  alignment: Alignment.topLeft,
                  child: Icon(Icons.radio_button_unchecked,
                      size: 18, color: ColorCodes.primaryColor)),
              Padding(padding: EdgeInsets.only(left: 10)),
              // (addressdata.billingAddress[widget.i].addressType == "home")? Image.asset(Images.homeConfirm,
              //   height: 25,
              //   width: 25,
              //   color: ColorCodes.blackColor,
              // ):(addressdata.billingAddress[widget.i].addressType == "Work")?Image.asset(Images.workConfirm,
              //   height: 25,
              //   width: 25,
              //   color: ColorCodes.blackColor,
              // ):Image.asset(Images.otherConfirm,
              //   height: 25,
              //   width: 25,
              //   color: ColorCodes.blackColor,
              // ),
              Padding(padding: EdgeInsets.only(left: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?10:5)),
              Flexible(
                  fit: FlexFit.tight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      new RichText(
                        textAlign: TextAlign.start,
                        text: new TextSpan(

                          style: new TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                          children: <TextSpan>[
                            new TextSpan(text: addressdata.billingAddress[widget.i].addressType+"\n",
                              style:new TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: ColorCodes.blackColor), ),
                            new TextSpan(
                                text: addressdata.billingAddress[widget.i].address,
                                style:new TextStyle(fontSize: 14)
                              // style: new TextStyle(color: ColorCodes.darkgreen),
                            ),

                          ],
                        ),
                      ),
                    ],
                  )),
              Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?
              Row(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 60,),
                  FlatButton(
                    child: Text(
                      S .of(context)
                          .edit_address, //"Edit",
                      style: TextStyle(
                          color: ColorCodes.blackColor,
                          fontWeight: FontWeight.w700),
                    ),

                    onPressed: () {
                      setState(() {
                        PrefUtils.prefs!.setString(
                            "addressbook",
                            "AddressbookScreen");
                        if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                          // _dialogforaddress(context);
                          AddressWeb(context,
                              addresstype: "edit",
                              addressid: addressdata
                                  .billingAddress[widget.i].id
                                  .toString(),
                              delieveryLocation: deliverylocation,
                              latitude: addressdata
                                  .billingAddress[widget.i]
                                  .lattitude.toString(),
                              longitude: addressdata
                                  .billingAddress[widget.i]
                                  .logingitude.toString(),
                              branch: "");
                        }
                        else {
                          Navigation(context,
                              name: Routename.AddressScreen,
                              navigatore: NavigatoreTyp.Push,
                              qparms: {
                                'addresstype': "edit",
                                'addressid': addressdata
                                    .billingAddress[widget.i].id
                                    .toString(),
                                'delieveryLocation': deliverylocation,
                                'latitude': addressdata
                                    .billingAddress[widget.i]
                                    .lattitude.toString(),
                                'longitude': addressdata
                                    .billingAddress[widget.i]
                                    .logingitude.toString(),
                                'branch': ""
                              });
                        }
                      });
                    },
                  ),
                  SizedBox(width: 50,),

                  FlatButton(
                      child: Text(
                        S .of(context)
                            .delete_address, //"Delete",
                        style: TextStyle(
                            color: ColorCodes
                                .black,
                            fontWeight: FontWeight.w700),
                      ),
                      onPressed: () {

                        _dialogforDeleteAdd(
                            context,
                            addressdata.billingAddress[widget.i].id.toString());
                      }),
                ],
              ):
              PopupMenuButton(
                onSelected: (FilterOptions selectedValue) {
                  print("selected value...."+selectedValue.toString());
                  if(selectedValue == FilterOptions.Edit/*"Edit"*//*S .of(context).edit*/){
                    setState(() {
                      PrefUtils.prefs!.setString(
                          "addressbook",
                          "AddressbookScreen");
                      /*        Navigator.of(context).pushReplacementNamed(
                                                    AddressScreen.routeName,
                                                    arguments: {
                                                      'addresstype': "edit",
                                                      'addressid': addressdata.billingAddress[i].id
                                                          .toString(),
                                                      'delieveryLocation': deliverylocation,
                                                      'latitude': addressdata.billingAddress[i].lattitude
                                                          .toString(),//"",
                                                      'longitude': addressdata.billingAddress[i].logingitude
                                                          .toString(),//"",
                                                      'branch': ""
                                                    });*/
                      if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                        // _dialogforaddress(context);
                        AddressWeb(context,
                            addresstype: "edit",
                            addressid: addressdata
                                .billingAddress[widget.i]
                                .id.toString(),
                            delieveryLocation: deliverylocation,
                            latitude: addressdata
                                .billingAddress[widget.i]
                                .lattitude
                                .toString(),
                            longitude: addressdata
                                .billingAddress[widget.i]
                                .logingitude
                                .toString(),
                            branch: "");
                      }
                      else {
                        Navigation(context,
                            name: Routename
                                .AddressScreen,
                            navigatore: NavigatoreTyp
                                .Push,
                            qparms: {
                              'addresstype': "edit",
                              'addressid': addressdata
                                  .billingAddress[widget.i]
                                  .id.toString(),
                              'delieveryLocation': deliverylocation,
                              'latitude': addressdata
                                  .billingAddress[widget.i]
                                  .lattitude
                                  .toString(),
                              'longitude': addressdata
                                  .billingAddress[widget.i]
                                  .logingitude
                                  .toString(),
                              'branch': ""
                            });
                      }
                    });

                  }
                  else if(selectedValue ==  FilterOptions.Delete/*"Delete"*//*S .of(context).delete*/){
                    _dialogforDeleteAdd(context,
                        addressdata.billingAddress[widget.i].id.toString());
                  }
                  else if(selectedValue ==  FilterOptions.Defaultadd){
                    AddressController addressController = AddressController();
                    addressController.setdefult(addressId: widget.billingAddressId);

                  }
                },

                itemBuilder: (_) =>
                [
                  PopupMenuItem(
                    child: Text( S.of(widget.context!).set_as_default,
                      style: TextStyle(fontSize: 10),
                      // 'Remove'
                    ),
                    value: FilterOptions.Defaultadd,
                  ),
                  PopupMenuItem(
                    child: Text(  S .of(widget.context!).edit,
                      style: TextStyle(fontSize: 10),
                      // 'Remove'
                    ),
                    value: FilterOptions.Edit,
                  ),
                  PopupMenuItem(
                    child: Text(  S .of(widget.context!).delete,
                      style: TextStyle(fontSize: 10),
                      // 'Remove'
                    ),
                    value: FilterOptions.Delete,
                  ),
                ],
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: ShapeDecoration(
                    color: ColorCodes.whiteColor,
                    shape: StadiumBorder(
                      side: BorderSide(color: ColorCodes.lightgrey, width: 1),
                    ),
                  ),
                  child: Icon(Icons.more_horiz,color: ColorCodes.primaryColor,),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}