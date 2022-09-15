/*
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../utils/ResponsiveLayout.dart';
import '../providers/addressitems.dart';
import '../screens/address_screen.dart';
import '../constants/ColorCodes.dart';
import '../screens/map_screen.dart';
import '../screens/home_screen.dart';
import '../constants/images.dart';
import '../utils/prefUtils.dart';
import '../constants/IConstants.dart';

enum FilterOptions {
  Edit,
  Delete,
}

class AddressbookScreen extends StatefulWidget {
  static const routeName = '/addressbook-screen';

  @override
  _AddressbookScreenState createState() => _AddressbookScreenState();
}

class _CustomRadioButton {
  bool buttonLables;
  bool buttonValues;
  bool radioButtonValue;
  bool buttonWidth;
  bool buttonList;

  _CustomRadioButton({
    this.buttonLables,
    this.buttonValues,
    this.radioButtonValue,
    this.buttonWidth,
    // this.buttonColor,
    // this.selectedColor,
    // this.buttonHeight,
    // this.horizontal,
    // this.enableShape,
    // this.elevation,
    // this.customShape,
    // this.fontSize,
    // this.lineSpace,
    // this.buttonSpace,
    // this.buttonBorderColor,
    // this.textColor,
    // this.selectedTextColor,
    // this.initialSelection,
    // this.unselectedButtonBorderColor
  });
}

class _AddressbookScreenState extends State<AddressbookScreen> {
  AddressItemsList addressitemsData;
  //SharedPreferences prefs;
  bool _addresscheck = false;
  int _groupValue = 0;
  String singleAddress = '1';
  int value = 0;
  bool _isWeb = false;
  var _address = "";
  bool _isLoading = true;
  MediaQueryData queryData;
  double wid;
  double maxwid;

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
      _address = PrefUtils.prefs!.getString("restaurant_address");
      PrefUtils.prefs!.getString("deliverylocation");
      PrefUtils.prefs!.getString("lati");
      PrefUtils.prefs!.getString("long");
      Provider.of<AddressItemsList>(context,listen: false).fetchAddress().then((_) {
        setState(() {
          addressitemsData = Provider.of<AddressItemsList>(context, listen: false);
          if (addressitemsData.items.length <= 0) {
            _addresscheck = false;
            _isLoading = false;
          } else {
            _addresscheck = true;
            _isLoading = false;
          }
        });
      });
    });
    super.initState();
  }

  void deleteaddress(String addressid) {
    Provider.of<AddressItemsList>(context,listen: false).deleteAddress(addressid).then((_) {
      Provider.of<AddressItemsList>(context,listen: false).fetchAddress().then((_) {
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
      });
    });
  }

  void setDefaultAddress(String addressid) {
    Provider.of<AddressItemsList>(context,listen: false)
        .setDefaultAddress(addressid)
        .then((_) {
      */
/*Provider.of<AddressItemsList>(context,listen: false).fetchAddress().then((_) {*//*

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
    });
  }

  Widget printAddress(BuildContext context, i, String addressid) {
    if (addressitemsData.items[i].addressdefault == '1') {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pop(true);
        },
        child: Container(
          //height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(left: 20)),
              Align(
                  alignment: Alignment.topLeft,
                  child: Icon(Icons.radio_button_checked,
                      size: 18, color: ColorCodes.mediumBlueColor)),
              Padding(padding: EdgeInsets.only(left: 10)),
              Flexible(
                  fit: FlexFit.loose,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          S .of(context).default_address,//'Default Address:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: ColorCodes.mediumBlackWebColor,
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 5)),
                      Text(
                        addressitemsData.items[i].useraddress,
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorCodes.greyColor,
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () async {
          setDefaultAddress(addressid);
          //UpdateAddress(addressid,latitude,longitude,branch);
          // Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
          Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
          //Navigator.of(context).pop(true);
        },
        child: Container(
          // height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(left: 20)),
              Align(
                  alignment: Alignment.topLeft,
                  child: Icon(Icons.radio_button_unchecked,
                      size: 18, color: ColorCodes.mediumBlueColor)),
              Padding(padding: EdgeInsets.only(left: 10)),
              Flexible(
                  fit: FlexFit.loose,
                  child: Column(
                    children: [
                      Text(
                        addressitemsData.items[i].useraddress,
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorCodes.greyColor,
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      );
    }
  }

  Widget _myRadioButton({int value, Function onChanged}) {
    return Radio(
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged,
    );
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
                  width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.40:MediaQuery.of(context).size.width,
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
                              onTap: () {
                                Navigator.of(context).pop(true);
                                deleteaddress(addressid);
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

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    wid= queryData.size.width;
    maxwid=wid*0.90;

    return Scaffold(
        appBar: ResponsiveLayout.isSmallScreen(context) ?
        gradientappbarmobile() : null,
        backgroundColor: Colors.white,
        body: Column(
            children: <Widget>[
              if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
                Header(false),
              _isLoading ?
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
                  :
              _body(),
            ]
        )
    );


  }

  _body(){
    return _isWeb ? _bodyweb():
    _bodymobile();
  }
  _bodymobile(){
    return Expanded(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              !_addresscheck
                  ? Column(
                children: <Widget>[
                  Image.asset(
                    Images.noAddressImg,
                    fit: BoxFit.fill,
                    width: 200.0,
                    height: 200.0,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Center(
                      child: Text(
                        S .of(context).save_address_convenient,//"Save addresses to make home delivery more convenient.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 14.0),
                      )),
                  SizedBox(
                    height: 20.0,
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        PrefUtils.prefs!.setString("addressbook", "AddressbookScreen");
                        Navigator.of(context)
                            .pushReplacementNamed(AddressScreen.routeName, arguments: {
                          'addresstype': "new",
                          'addressid': "",
                          'delieveryLocation': "",
                          'latitude': "",
                          'longitude': "",
                          'branch': ""
                        });
                      },
                      child: Text(
                        S .of(context).add_address,//"Add Address",
                        style: TextStyle(
                          //fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ],
              )
                  : Expanded(child:Column(
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Container(
                      child: RaisedButton(
                        onPressed: () {},
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: ColorCodes.whiteColor,
                          ),
                          child: GestureDetector(
                            onTap: () async {
                              PrefUtils.prefs!.setString(
                                  "formapscreen", "addressbook_screen");
                              Navigator.of(context)
                                  .pushNamed(MapScreen.routeName);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.gps_fixed),
                                Padding(padding: EdgeInsets.only(left: 5)),
                                Text(
                                  S.of(context).choose_current_location,//'Choose Current Location',
                                  style: TextStyle(
                                    fontSize: 19,
                                    color: ColorCodes.mediumBlackColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                      top: 25.0,
                      left: 20,
                      right: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S .of(context).saved_address,//'Saved Addresses',
                          style: TextStyle(
                            fontSize: 19,
                            color: ColorCodes.greyColor,
                          ),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              PrefUtils.prefs!.setString("addressbook", "AddressbookScreen");
                              Navigator.of(context)
                                  .pushReplacementNamed(AddressScreen.routeName, arguments: {
                                'addresstype': "new",
                                'addressid': "",
                                'delieveryLocation': "",
                                'latitude': "",
                                'longitude': "",
                                'branch': ""
                              });
                            },
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 10.0,
                                ),
                                Icon(
                                  Icons.add,
                                  color: ColorCodes.mediumBlueColor,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  S .of(context).add_address,//"Add Address",
                                  style: TextStyle(
                                    //fontWeight: FontWeight.bold,
                                      fontSize: 19.0,
                                      color: ColorCodes.mediumBlueColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Divider(),
                  //Padding(padding: EdgeInsets.only(top: 10)),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                  ),
                  Expanded(
                    child: new ListView.builder(
                      itemCount: addressitemsData.items.length,
                      itemBuilder: (_, i) => Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            //padding: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Container(
                              //height: 50,
                              margin: EdgeInsets.only(right: 10, bottom: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(top: 15, bottom: 15),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          printAddress(context, i,
                                              addressitemsData.items[i].userid),
                                        ],
                                      ),
                                    ),
                                  ),
                                  //SizedBox(width: 20.0),
                                  //Spacer(),
                                  Padding(
                                    padding: EdgeInsets.only(left: 90),
                                  ),

                                  Row(
                                    //crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      IconButton(
                                        padding: EdgeInsets.all(0),
                                        icon: Icon(Icons.edit, size: 20),
                                        color: Colors.grey,
                                        onPressed: () {
                                          setState(() {
                                            PrefUtils.prefs!.setString("addressbook",
                                                "AddressbookScreen");
                                            Navigator.of(context).pushNamed(
                                                AddressScreen.routeName,
                                                arguments: {
                                                  'addresstype': "edit",
                                                  'addressid': addressitemsData
                                                      .items[i].userid
                                                      .toString(),
                                                  'delieveryLocation': addressitemsData.items[i].useraddress,
                                                  'latitude': addressitemsData..items[i].userlat,
                                                  'longitude': addressitemsData..items[i].userlong,
                                                  'branch': "",
                                                });
                                          });
                                        },
                                      ),
                                      Container(
                                        height: 12,
                                        width: 1,
                                        child: VerticalDivider(
                                            color: Colors.black),
                                      ),
                                      IconButton(
                                          padding: EdgeInsets.all(0),
                                          icon: Icon(Icons.delete_outline,
                                              size: 20),
                                          color: Colors.grey,
                                          onPressed: () {
                                            _dialogforDeleteAdd(
                                                context,
                                                addressitemsData
                                                    .items[i].userid);
                                          }),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          //Divider(color: Colors.grey,),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
            ]
        )
    );
  }
  _bodyweb(){
    return  Expanded(
      child: !_addresscheck?SingleChildScrollView(
          child: Column(
              children: <Widget>[
                _isLoading
                    ? Container(
                  height: 100,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
                    :
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    constraints: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid):null,
                    height: MediaQuery.of(context).size.height*/
/**0.8*//*
,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          Images.noAddressImg,
                          fit: BoxFit.fill,
                          width: 200.0,
                          height: 200.0,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Center(
                            child: Text(
                              S .of(context).save_address_convenient,//"Save addresses to make home delivery more convenient.",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey, fontSize: 14.0),
                            )),
                        SizedBox(
                          height: 20.0,
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              PrefUtils.prefs!.setString("addressbook", "AddressbookScreen");
                              Navigator.of(context)
                                  .pushReplacementNamed(AddressScreen.routeName, arguments: {
                                'addresstype': "new",
                                'addressid': "",
                                'delieveryLocation': "",
                                'latitude': "",
                                'longitude': "",
                                'branch': ""
                              });
                            },
                            child: Text(
                              S .of(context).add_address,//"Add Address",
                              style: TextStyle(
                                //fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                if(_isWeb) Footer(address: _address),
              ]
          )
      ) :
      SingleChildScrollView(
        child: Column(
            children:[
              _isLoading
                  ? Container(
                height: 100,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
                  :
              Align(
                alignment: Alignment.center,
                child: Container(
                  constraints: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid):null,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Container(
                          child: RaisedButton(
                            onPressed: () {},
                            child: Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: ColorCodes.whiteColor,
                              ),
                              child: GestureDetector(
                                onTap: () async {
                                  PrefUtils.prefs!.setString(
                                      "formapscreen", "addressbook_screen");
                                  Navigator.of(context).pushNamed(MapScreen.routeName);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.gps_fixed),
                                    Padding(padding: EdgeInsets.only(left: 5)),
                                    Text(
                                      S.of(context).choose_current_location,//'Choose Current Location',
                                      style: TextStyle(
                                        fontSize: 19,
                                        color: ColorCodes.mediumBlackColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                          top: 25.0,
                          left: 20,
                          right: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              S .of(context).saved_address,//'Saved Addresses',
                              style: TextStyle(
                                fontSize: 19,
                                color: ColorCodes.greyColor,
                              ),
                            ),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  PrefUtils.prefs!.setString("addressbook", "AddressbookScreen");
                                  Navigator.of(context).pushReplacementNamed(MapAddressScreen.routeName, arguments: {
                                    'addresstype': "new",
                                    'addressid': "",
                                    'delieveryLocation': "",
                                    'latitude': "",
                                    'longitude': "",
                                    'branch': ""
                                  });
                                },
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Icon(
                                      Icons.add,
                                      color: ColorCodes.mediumBlueColor,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      S .of(context).add_address,//"Add Address",
                                      style: TextStyle(
                                        //fontWeight: FontWeight.bold,
                                          fontSize: 19.0,
                                          color: ColorCodes.mediumBlueColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Divider(),
                      //Padding(padding: EdgeInsets.only(top: 10)),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                      ),
                      Flexible(
                        // height: MediaQuery.of(context).size.height,
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          child: new ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: addressitemsData.items.length,
                            itemBuilder: (_, i) => Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  //padding: EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Container(
                                    //height: 50,
                                    margin: EdgeInsets.only(right: 10, bottom: 10),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,

                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(top: 15, bottom: 15),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                printAddress(context, i, addressitemsData.items[i].userid),
                                              ],
                                            ),
                                          ),
                                        ),
                                        //SizedBox(width: 20.0),
                                        //Spacer(),
                                        Padding(
                                          padding: EdgeInsets.only(left: 90),
                                        ),

                                        Row(
                                          //crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            IconButton(
                                              padding: EdgeInsets.all(0),
                                              icon: Icon(Icons.edit, size: 20),
                                              color: Colors.grey,
                                              onPressed: () {
                                                setState(() {
                                                  PrefUtils.prefs!.setString("addressbook",
                                                      "AddressbookScreen");
                                                  String adress =addressitemsData.items[i].useraddress;
                                                  String userlat =addressitemsData.items[i].userlat;
                                                  String userlong =addressitemsData.items[i].userlong;
                                                  String userid =addressitemsData.items[i].userid.toString();
                                                 PrefUtils.prefs!.setString("delieveryLocation", addressitemsData.items[i].useraddress.toString());
                                                 PrefUtils.prefs!.setString("lati", addressitemsData.items[i].userlat.toString());
                                                 PrefUtils.prefs!.setString("longi", addressitemsData.items[i].userlong.toString());
                                                  Navigator.of(context).pushNamed(
                                                      MapAddressScreen.routeName,
                                                      arguments: {
                                                        'addresstype': "edit",
                                                        'addressid': addressitemsData
                                                            .items[i].userid
                                                            .toString(),
                                                        'delieveryLocation': adress,
                                                        'latitude': userlat,
                                                        'longitude':userlong,
                                                        'branch': "",
                                                      });
                                                });
                                              },
                                            ),
                                            Container(
                                              height: 12,
                                              width: 1,
                                              child: VerticalDivider(
                                                  color: Colors.black),
                                            ),
                                            IconButton(
                                                padding: EdgeInsets.all(0),
                                                icon: Icon(Icons.delete_outline,
                                                    size: 20),
                                                color: Colors.grey,
                                                onPressed: () {
                                                  _dialogforDeleteAdd(
                                                      context,
                                                      addressitemsData
                                                          .items[i].userid);
                                                }),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                //Divider(color: Colors.grey,),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              if(_isWeb) Footer(address: _address),
            ]
        ),
      ),
    );
  }
  gradientappbarmobile() {
    return  AppBar(
      brightness: Brightness.dark,
      toolbarHeight: 60.0,
      elevation:  (IConstants.isEnterprise)?0:1,
      automaticallyImplyLeading: false,
      leading: IconButton(icon: Icon(Icons.arrow_back, color: ColorCodes.menuColor),onPressed: ()=>Navigator.of(context).pop()),
      title: Text(S .of(context).my_address,//'My Addresses'
      ,style: TextStyle(color: ColorCodes.menuColor),),
      titleSpacing: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  ColorCodes.accentColor,
                  ColorCodes.primaryColor
                ]
            )
        ),
      ),
    );
  }
}
*/
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:grocbay/models/newmodle/address.dart';
import 'package:provider/provider.dart';
import 'package:grocbay/constants/IConstants.dart';
import 'package:grocbay/constants/features.dart';
import '../controller/mutations/address_mutation.dart';
import '../controller/mutations/login.dart';
import '../models/VxModels/VxStore.dart';
import 'package:velocity_x/velocity_x.dart';
import '../generated/l10n.dart';
import '../providers/addressitems.dart';
import '../rought_genrator.dart';
import '../utils/prefUtils.dart';

import '../widgets/Address_display.dart';

import '../widgets/addresswidget/address_info.dart';

import '../widgets/simmers/order_screen_shimmer.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../utils/ResponsiveLayout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/address_screen.dart';
import '../assets/ColorCodes.dart';
import '../assets/images.dart';

enum FilterOptions {
  Edit,
  Delete,
  Defaultadd,
}

class AddressbookScreen extends StatefulWidget {
  static const routeName = '/addressbook-screen';

  @override
  _AddressbookScreenState createState() => _AddressbookScreenState();
}

class _CustomRadioButton {
  bool? buttonLables;
  bool? buttonValues;
  bool? radioButtonValue;
  bool? buttonWidth;
  bool? buttonList;

  _CustomRadioButton({
    this.buttonLables,
    this.buttonValues,
    this.radioButtonValue,
    this.buttonWidth,
    // this.buttonColor,
    // this.selectedColor,
    // this.buttonHeight,
    // this.horizontal,
    // this.enableShape,
    // this.elevation,
    // this.customShape,
    // this.fontSize,
    // this.lineSpace,
    // this.buttonSpace,
    // this.buttonBorderColor,
    // this.textColor,
    // this.selectedTextColor,
    // this.initialSelection,
    // this.unselectedButtonBorderColor
  });
}

class _AddressbookScreenState extends State<AddressbookScreen> with Navigations {
  var addressitemsData;
  var addressdata;
  late SharedPreferences prefs;
  var deliverylocation;
  bool _addresscheck = true;
  int _groupValue = 0;
  String singleAddress = '1';
  int value = 0;
  bool _isWeb = false;
  var _address = "";
  bool _isLoading = false;
  late MediaQueryData queryData;
  late double wid;
  late double maxwid;


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

    super.initState();
  }


  Widget printAddress(BuildContext context, i, String addressid) {
    if (addressdata.billingAddress[i].isdefault == '1') {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pop(true);
        },
        child: Container(
          //height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(left: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?5:20)),
              // Align(
              //     alignment: Alignment.topLeft,
              //     child: Icon(Icons.radio_button_checked,
              //         size: 18, color: ColorCodes.mediumBlueColor)),
              //Padding(padding: EdgeInsets.only(left: 10)),
              (addressdata.billingAddress[i].addressType == "home")? Image.asset(Images.homeConfirm,
                height: 25,
                width: 25,
                color: ColorCodes.blackColor,
              ):(addressdata.billingAddress[i].addressType == "Work")?Image.asset(Images.workConfirm,
                height: 25,
                width: 25,
                color: ColorCodes.blackColor,
              ):Image.asset(Images.otherConfirm,
                height: 25,
                width: 25,
                color: ColorCodes.blackColor,
              ),
              Padding(padding: EdgeInsets.only(left: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?10:5)),
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
                      Padding(padding: EdgeInsets.only(top: 5)),


                      new RichText(textAlign: TextAlign.start,
                        text: new TextSpan(

                          // Note: Styles for TextSpans must be explicitly defined.
                          // Child text spans will inherit styles from parent
                          style: new TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                          children: <TextSpan>[
                            new TextSpan(text: /*addressitemsData.items[i]*/addressdata.billingAddress[i].addressType+"\n",
                              style:new TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: ColorCodes.blackColor), ),
                            new TextSpan(
                                text: addressdata.billingAddress[i].address,
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
                                  .billingAddress[i].id
                                  .toString(),
                              delieveryLocation: deliverylocation,
                              latitude: addressdata
                                  .billingAddress[i]
                                  .lattitude.toString(),
                              longitude: addressdata
                                  .billingAddress[i]
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
                                    .billingAddress[i].id
                                    .toString(),
                                'delieveryLocation': deliverylocation,
                                'latitude': addressdata
                                    .billingAddress[i]
                                    .lattitude.toString(),
                                'longitude': addressdata
                                    .billingAddress[i]
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
                            addressdata.billingAddress[i].id.toString());
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
                              addressid: addressdata.billingAddress[i].id
                                  .toString(),
                        delieveryLocation: deliverylocation,
                        latitude: addressdata.billingAddress[i]
                            .lattitude.toString(),
                        longitude: addressdata.billingAddress[i]
                            .logingitude.toString(),
                        branch: "");
                        }
                        else {
                          Navigation(context, name: Routename.AddressScreen,
                              navigatore: NavigatoreTyp.Push,
                              qparms: {
                                'addresstype': "edit",
                                'addressid': addressdata.billingAddress[i].id
                                    .toString(),
                                'delieveryLocation': deliverylocation,
                                'latitude': addressdata.billingAddress[i]
                                    .lattitude.toString(),
                                'longitude': addressdata.billingAddress[i]
                                    .logingitude.toString(),
                                'branch': ""
                              });
                        }
                      });
                    }
                    else if(selectedValue ==  FilterOptions.Delete/*"Delete"*//*S .of(context).delete*/){
                      _dialogforDeleteAdd(context,
                                        addressdata.billingAddress[i].id.toString());
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
                      child: Text(  S .of(context).edit,
                        style: TextStyle(fontSize: 10),
                        // 'Remove'
                      ),
                      value: FilterOptions.Edit,
                    ),
                    PopupMenuItem(
                      child: Text(  S .of(context).delete,
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
          AddressController addressController = AddressController();
          await addressController.setdefult(addressId: addressid,branch: PrefUtils.prefs!.getString('branch'));
        },
        child: Container(
          // height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(left: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?5:20)),
              // Align(
              //     alignment: Alignment.topLeft,
              //     child: Icon(Icons.radio_button_unchecked,
              //         size: 18, color: ColorCodes.mediumBlueColor)),
              //Padding(padding: EdgeInsets.only(left: 10)),
              (addressdata.billingAddress[i].addressType == "home")? Image.asset(Images.homeConfirm,
                height: 25,
                width: 25,
                color: ColorCodes.blackColor,
              ):(addressdata.billingAddress[i].addressType == "Work")?Image.asset(Images.workConfirm,
                height: 25,
                width: 25,
                color: ColorCodes.blackColor,
              ):Image.asset(Images.otherConfirm,
                height: 25,
                width: 25,
                color: ColorCodes.blackColor,
              ),
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

                          // Note: Styles for TextSpans must be explicitly defined.
                          // Child text spans will inherit styles from parent
                          style: new TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                          children: <TextSpan>[
                            new TextSpan(text: addressdata.billingAddress[i].addressType+"\n",
                              style:new TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: ColorCodes.blackColor), ),
                            new TextSpan(
                                text: addressdata.billingAddress[i].address,
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
                                  .billingAddress[i].id
                                  .toString(),
                              delieveryLocation: deliverylocation,
                              latitude: addressdata
                                  .billingAddress[i]
                                  .lattitude.toString(),
                              longitude: addressdata
                                  .billingAddress[i]
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
                                    .billingAddress[i].id
                                    .toString(),
                                'delieveryLocation': deliverylocation,
                                'latitude': addressdata
                                    .billingAddress[i]
                                    .lattitude.toString(),
                                'longitude': addressdata
                                    .billingAddress[i]
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
                            addressdata.billingAddress[i].id.toString());
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
                                                              .billingAddress[i]
                                                              .id.toString(),
                                                    delieveryLocation: deliverylocation,
                                                    latitude: addressdata
                                                        .billingAddress[i]
                                                        .lattitude
                                                        .toString(),
                                                    longitude: addressdata
                                                        .billingAddress[i]
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
                                                                .billingAddress[i]
                                                                .id.toString(),
                                                            'delieveryLocation': deliverylocation,
                                                            'latitude': addressdata
                                                                .billingAddress[i]
                                                                .lattitude
                                                                .toString(),
                                                            'longitude': addressdata
                                                                .billingAddress[i]
                                                                .logingitude
                                                                .toString(),
                                                            'branch': ""
                                                          });
                                                    }
                                                  });

                                                }
                                                else if(selectedValue ==  FilterOptions.Delete/*"Delete"*//*S .of(context).delete*/){
                                                  _dialogforDeleteAdd(context,
                                                      addressdata.billingAddress[i].id.toString());
                                                }
                                                else if(selectedValue ==  FilterOptions.Defaultadd){
                                                  AddressController addressController = AddressController();
                                                  addressController.setdefult(addressId: addressid);

                                                }
                                              },

                                              itemBuilder: (_) =>
                                              [
                                                PopupMenuItem(
                                                  child: Text( S.of(context).set_as_default,
                                                    style: TextStyle(fontSize: 10),
                                                    // 'Remove'
                                                  ),
                                                  value: FilterOptions.Defaultadd,
                                                ),
                                                PopupMenuItem(
                                                  child: Text(  S .of(context).edit,
                                                    style: TextStyle(fontSize: 10),
                                                    // 'Remove'
                                                  ),
                                                  value: FilterOptions.Edit,
                                                ),
                                                PopupMenuItem(
                                                  child: Text(  S .of(context).delete,
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

  // Widget _myRadioButton({required int value, required Function onChanged}) {
  //   return Radio(
  //     value: value,
  //     groupValue: _groupValue,
  //     onChanged: onChanged,
  //   );
  // }

  _dialogforDeleteAdd(BuildContext context, String addressid) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              child: Container(
                  width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.25:MediaQuery.of(context).size.width,
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

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    wid= queryData.size.width;
    maxwid=wid*0.90;

    return WillPopScope(
      onWillPop: (){
        Navigation(context, navigatore: NavigatoreTyp.homenav);
        return Future.value(false);
      },
      child: Scaffold(
          appBar: ResponsiveLayout.isSmallScreen(context) || !_isWeb ?
          gradientappbarmobile() : null,
          backgroundColor: Colors.white,
          body:Column(
              children: <Widget>[
                if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
                  Header(false),
                _isLoading ?
                (_isWeb && !ResponsiveLayout.isSmallScreen(context))? Center(
                  child: OrderScreenShimmer(),
                ):
                Center(
                  child: OrderScreenShimmer(),
                )
                    :
                _body(),
              ]
          )
      ),
    );


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

  _body(){
    return _isWeb?_bodyweb():
    _bodymobile();
  }
  _bodymobile(){
    return VxBuilder(
       mutations: {SetAddress,SetUserData},
      builder: (ctx,store,VxStatus? state){
          addressdata = store!.userData;
          debugPrint("./././" + store.userData.toString());

        return Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  (addressdata.billingAddress.length<=0)
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        Images.noAddressImg,
                        fit: BoxFit.fill,
                        width: 200.0,
                        height: 200.0,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Center(
                          child: Text(
                            S .of(context).save_address_convenient,//"Save addresses to make home delivery more convenient.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey, fontSize: 14.0),
                          )),
                      SizedBox(
                        height: 20.0,
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            PrefUtils.prefs!.setString("addressbook", "AddressbookScreen");
                       /*     Navigator.of(context)
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
                                    branch: "");
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
                                        'branch': ""
                                      });
                                }
                          },
                          child: Text(
                            S .of(context).add_address,//"Add Address",
                            style: TextStyle(
                              //fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ],
                  )
                      : Expanded(child:Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),

                      /*Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Container(
                      child: RaisedButton(
                        onPressed: () {},
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: ColorCodes.whiteColor,
                          ),
                          child: GestureDetector(
                            onTap: () async {
                              prefs.setString(
                                "formapscreen", "addressbook_screen");
                              Navigator.of(context)
                                .pushNamed(MapScreen.routeName);
                              },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.gps_fixed),
                                Padding(padding: EdgeInsets.only(left: 5)),
                                Text(
                                S.of(context).choose_current_location,//'Choose Current Location',
                                  style: TextStyle(
                                    fontSize: 19,
                                    color: ColorCodes.mediumBlackColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),*/

                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          left: 28,
                          right: 28,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Text(
                            //   S .of(context).saved_address,//'Saved Addresses',
                            //   style: TextStyle(
                            //     fontSize: 19,
                            //     color: ColorCodes.greyColor,
                            //   ),
                            // ),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  PrefUtils.prefs!.setString("addressbook", "AddressbookScreen");
                           /*       Navigator.of(context)
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
                                branch: "");
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
                                    'branch': ""
                                  });
                               }
                                },
                                child: Row(
                                  children: <Widget>[
                                    // SizedBox(
                                    //   width: 10.0,
                                    // ),
                                    Icon(
                                      Icons.add,
                                      color:  Theme.of(context).primaryColor,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      S .of(context).add_new_address,//"Add Address",
                                      style: TextStyle(
                                        //fontWeight: FontWeight.bold,
                                          fontSize: 17.0,
                                          color: Theme.of(context).primaryColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:25.0,right:25),
                        child: Divider(color: ColorCodes.lightGreyColor,),
                      ),
                      //Divider(),
                      //Padding(padding: EdgeInsets.only(top: 10)),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                      ),
                      Expanded(
                        child:/* StreamBuilder(
                          stream: adressbloc.streamaddress,
                          builder: (context,snapshot){*/
                           // if(addressdata.billingAddress.length>0){
                             // return new
                              ListView.builder(
                                itemCount: addressdata.billingAddress.length,/*snapshot.data.length*/
                                itemBuilder: (_, i) => Column(
                                  children: [
                                    Container(
                                      width:MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.only(left: 10, right: 10),
                                      //padding: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child: Container(
                                        //height: 50,
                                        margin: EdgeInsets.only(right: 10, ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal:10.0),
                                              child: Row(
                                                children: [
                                                  /* Icon( addressitemsData.items[i].addressicon,color: ColorCodes.lightGreyColor,),
                                          Padding(
                                            padding: const EdgeInsets.only(left:5.0),
                                            child: Text(addressitemsData.items[i].useraddtype.toString()),
                                          ),*/

                                                  /* CachedNetworkImage(
                                            imageUrl: addressitemsData.items[i].addressicon,
                                           *//* placeholder: (context, url) => Image.asset(
                                                Images.defaultCategoryImg),*//*

                                            height: ResponsiveLayout.isSmallScreen(context)?100:120,
                                            width: ResponsiveLayout.isSmallScreen(context)?115:160,
                                            //fit: BoxFit.fill,
                                          ) ,*/
                                                ],
                                              ),
                                            ),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                    padding: EdgeInsets.only(top: 15),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        AddressDisplay(context:
                                                        context,
                                                          i: i,
                                                          billingAddressId: addressdata.billingAddress[i].id.toString(),
                                                          fromscreen: "Addressbook",
                                                        ),
                                                      //  printAddress(context, i,
                                                       //     /*snapshot.data[i].userid*/addressdata.billingAddress[i].id.toString()),
                                                       /*  Padding(
                                                  padding: const EdgeInsets.only(left:15.0),
                                                  child: Text(addressitemsData.items[i].useraddtype.toString()),
                                                ),*/
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                //SizedBox(width: 20.0),
                                                //Spacer(),
                                                /* Padding(
                                          padding: EdgeInsets.only(left: 90),
                                        ),*/

                                                /*Row(
                                        //crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            IconButton(
                                              padding: EdgeInsets.all(0),
                                              icon: Icon(Icons.edit, size: 20),
                                              color: Colors.grey,
                                              onPressed: () {
                                                setState(() {
                                                  prefs.setString("addressbook",
                                                    "AddressbookScreen");
                                                  Navigator.of(context).pushNamed(
                                                    ExampleScreen.routeName,
                                                    arguments: {
                                                      'addresstype': "edit",
                                                      'addressid': addressitemsData
                                                          .items[i].userid
                                                          .toString(),
                                                      'delieveryLocation': deliverylocation,
                                                      'latitude': "",
                                                      'longitude': "",
                                                      'branch': ""
                                                    });
                                                });
                                                },
                                            ),
                                            Container(
                                              height: 12,
                                              width: 1,
                                              child: VerticalDivider(
                                                color: Colors.black),
                                            ),
                                            IconButton(
                                                padding: EdgeInsets.all(0),
                                                icon: Icon(Icons.delete_outline,
                                                  size: 20),
                                                color: Colors.grey,
                                                onPressed: () {
                                                _dialogforDeleteAdd(
                                                    context,
                                                    addressitemsData
                                                        .items[i].userid);
                                                }),
                                          ],
                                        ),*/
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    /* SizedBox(
                              height: 10.0,
                            ),*/
                                    Padding(
                                      padding: const EdgeInsets.only(left:30.0),
                                      child: Column(
                                        children: [
                                      //     Row(
                                      //       //crossAxisAlignment: CrossAxisAlignment.start,
                                      //       children: [
                                      //         FlatButton(
                                      //           child:Text(S .of(context).edit,//"EDIT",
                                      //             style: TextStyle(color:Theme.of(context).primaryColor,fontWeight: FontWeight.normal,fontSize: 14.0,),),
                                      //           padding: EdgeInsets.all(0),
                                      //           //  icon: Icon(Icons.edit, size: 20),
                                      //           // color: Colors.grey,
                                      //           onPressed: () {
                                      //             setState(() {
                                      //               PrefUtils.prefs!.setString("addressbook",
                                      //                   "AddressbookScreen");
                                      //             /*  Navigator.of(context).pushReplacementNamed(
                                      //                 AddressScreen.routeName,
                                      //                   arguments: {
                                      //                     'addresstype': "edit",
                                      //                     'addressid': addressdata.billingAddress[i].id
                                      //                         .toString(),
                                      //                     'delieveryLocation': deliverylocation,
                                      //                     'latitude': addressdata.billingAddress[i].lattitude
                                      //                         .toString(),//"",
                                      //                     'longitude': addressdata.billingAddress[i].logingitude
                                      //                         .toString(),//"",
                                      //                     'branch': ""
                                      //                   });*/
                                      //               Navigation(context, name: Routename.AddressScreen, navigatore: NavigatoreTyp.Push,
                                      //                   qparms: {
                                      //                     'addresstype': "edit",
                                      //                     'addressid': addressdata.billingAddress[i].id.toString(),
                                      //                     'delieveryLocation': deliverylocation,
                                      //                     'latitude': addressdata.billingAddress[i].lattitude.toString(),
                                      //                     'longitude': addressdata.billingAddress[i].logingitude.toString(),
                                      //                     'branch': "",
                                      //                   });
                                      //             });
                                      //           },
                                      //         ),
                                      //         /* Container(
                                      //   height: 12,
                                      //   width: 1,
                                      //   child: VerticalDivider(
                                      //       color: Colors.black),
                                      // ),*/
                                      //         FlatButton(
                                      //             child:Text(S .of(context).delete,//"DELETE",
                                      //               style: TextStyle(color:ColorCodes.banner,fontWeight: FontWeight.normal,fontSize: 14.0,),),
                                      //             padding: EdgeInsets.all(0),
                                      //             /*icon: Icon(Icons.delete_outline,
                                      //       size: 20),*/
                                      //             // color: Colors.grey,
                                      //             onPressed: () {
                                      //              //  _dialogforSaveadd();
                                      //               _dialogforDeleteAdd(
                                      //                   context,
                                      //               addressdata.billingAddress[i].id.toString());
                                      //
                                      //             }),
                                      //
                                      //       ],
                                      //     ),
                                          Padding(
                                            padding: const EdgeInsets.only(left:10.0,right:10),
                                            child: Divider(color: ColorCodes.lightGreyColor,),
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            // }else if(snapshot.hasError){
                            //
                            //   return SizedBox.shrink();
                            // }else if(!snapshot.hasData){
                            //
                            //   return SizedBox.shrink();
                            // }
                            // return  OrderScreenShimmer();
                        //   },
                        //
                        // ),
                      ),
                    ],
                  )),
                ]
            )
        );
      }
    );

  }
//   void setDefaultAddress(String addressid) {
//     Provider.of<AddressItemsList>(context,listen: false)
//         .setDefaultAddress(addressid)
//         .then((_) {
//
// /*Provider.of<AddressItemsList>(context,listen: false).fetchAddress().then((_) {*/
//
//       setState(() {
//         addressitemsData =
//             Provider.of<AddressItemsList>(context, listen: false);
//         if (addressitemsData.items.length <= 0) {
//           _addresscheck = false;
//           _isLoading = false;
//         } else {
//           _addresscheck = true;
//           _isLoading = false;
//         }
//       });
//     });
//   }



  _bodyweb(){
    return VxBuilder(
        mutations: {SetAddress,SetUserData},
        builder: (ctx,store,VxStatus? state) {
      addressdata = store!.userData;
      return Expanded(
        child: (addressdata.billingAddress.length<=0) ? SingleChildScrollView(
            child: Column(
                children: <Widget>[
                  _isLoading
                      ? Container(
                    height: 100,
                    child: Center(
                      child: OrderScreenShimmer(
                      ),
                    ),
                  )
                      :
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      constraints: (_isWeb &&
                          !ResponsiveLayout.isSmallScreen(context))
                          ? BoxConstraints(maxWidth: maxwid)
                          : null,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height /**0.8*/,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            Images.noAddressImg,
                            fit: BoxFit.fill,
                            width: 200.0,
                            height: 200.0,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                PrefUtils.prefs!.setString(
                                    "addressbook", "AddressbookScreen");
                                /*     Navigator.of(context)
                                    .pushReplacementNamed(
                                    AddressScreen.routeName, arguments: {
                                  'addresstype': "new",
                                  'addressid': "",
                                  'delieveryLocation': "",
                                  'latitude': "",
                                  'longitude': "",
                                  'branch': ""
                                });*/
                                if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                                  //_dialogforaddress(context);
                                  AddressWeb(context,
                                      addresstype: "new",
                                      addressid: "",
                                      delieveryLocation: "",
                                      latitude: "",
                                      longitude: "",
                                      branch: "");
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
                                        'branch': ""
                                      });
                                }


                              },
                              child: Text(
                                S .of(context)
                                    .add_new_address, //"Add Address",
                                style: TextStyle(
                                  //fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: Theme
                                        .of(context)
                                        .primaryColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),

                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  if(_isWeb) Footer(
                      address: PrefUtils.prefs!.getString("restaurant_address")!),
                ]
            )
        ) : SingleChildScrollView(
          child: Column(
              children: [
                _isLoading
                    ? Container(
                  height: 100,
                  child: Center(
                    child: OrderScreenShimmer(
                    ),
                  ),
                )
                    :
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    // margin: EdgeInsets.only(top: 15),
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.all(Radius.circular(5)),
                    //   border: Border.all(color: ColorCodes.emailColor)
                    // ),
                    constraints: (_isWeb &&
                        !ResponsiveLayout.isSmallScreen(context))
                        ? BoxConstraints(maxWidth: maxwid)
                        : null,
                    // height: MediaQuery
                    //     .of(context)
                    //     .size
                    //     .height,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 15.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10.0,
                            left: 5,
                            right: 5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [

                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    debugPrint("why.....");
                                    PrefUtils.prefs!.setString(
                                        "addressbook", "AddressbookScreen");

                                    if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                                     // _dialogforaddress(context);
                                      AddressWeb(context,
                                          addresstype: "new",
                                          addressid: "",
                                          delieveryLocation: "",
                                          latitude: "",
                                          longitude: "",
                                          branch: "");
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
                                            'branch': ""
                                          });
                                    }
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      // SizedBox(
                                      //   width: 10.0,
                                      // ),
                                      Icon(
                                        Icons.add,
                                        color: ColorCodes.primaryColor,
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text(
                                        S .of(context)
                                            .add_new_address, //"Add Address",
                                        style: TextStyle(
                                          //fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                            color: ColorCodes.primaryColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                       // Divider(),
                        //Padding(padding: EdgeInsets.only(top: 10)),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                        ),
                        Flexible(
                          // height: MediaQuery.of(context).size.height,
                          child: Container(
                            // height: MediaQuery
                            //     .of(context)
                            //     .size
                            //     .height,
                            child: new ListView.separated(
                              separatorBuilder: (context, index) {
                                return Divider();
                              },
                              physics: AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: addressdata.billingAddress.length,
                              itemBuilder: (_, i) =>
                                  Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?0:10, right: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?0:10),
                                        //padding: EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Container(
                                          //height: 50,
                                          margin: EdgeInsets.only(
                                              right: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?0:10, bottom:Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?0:10),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,

                                            children: <Widget>[
                                              Expanded(
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      top: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?0:15, bottom: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?0:10),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize
                                                        .min,
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .start,
                                                    children: <Widget>[
                                                      // printAddress(context, i,
                                                      //     addressdata.billingAddress[i].id.toString()),

                                                      AddressDisplay(context:
                                                          context,
                                                          i: i,
                                                          billingAddressId: addressdata.billingAddress[i].id.toString(),
                                                          fromscreen: "Addressbook",
                                                      ),
                                                     // Divider(),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              //SizedBox(width: 20.0),
                                              //Spacer(),

                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),



                                      //Divider(color: Colors.grey,),
                                    ],
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                if(_isWeb) Footer(
                    address: PrefUtils.prefs!.getString("restaurant_address")!),
              ]
          ),
        ),
      );
    });
  }
  gradientappbarmobile() {
    return  AppBar(
      brightness: Brightness.dark,
      toolbarHeight: 60.0,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: IconButton(icon: Icon(Icons.arrow_back,size: 20, color: ColorCodes.iconColor),onPressed: ()=>
          Navigation(context, navigatore: NavigatoreTyp.homenav)
      //Navigation(context, navigatore: NavigatoreTyp.homenav)
      ),
      title: Text(S .of(context).my_address,//'My Addresses',
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
