
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../generated/l10n.dart';
import '../../providers/branditems.dart';
import '../../providers/itemslist.dart';
import '../../providers/sellingitems.dart';
import '../../utils/ResponsiveLayout.dart';
import '../../utils/prefUtils.dart';
import 'dialogforshoppingCreateList.dart';

class CreateItemListBox extends StatefulWidget{
  CreateItemListBox({Key? key}) : super(key: key);
  @override
  CreateItemListBoxState createState() => CreateItemListBoxState();
}

class CreateItemListBoxState extends State<CreateItemListBox> {
  bool _isWeb = Vx.isWeb;
  bool checkskip = false;
  final _form = GlobalKey<FormState>();
  var shoplistData;
  var itemid;
  var fromScreen;
  var notificationFor;
  String? varid;
  var singleitemvar;
  bool _isLoading = true;
  void initState(){
    Future.delayed(Duration.zero, () async {
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
      setState(() {
        Provider.of<BrandItemsList>(context,listen: false)
            .fetchShoppinglist()
            .then((_) {
          shoplistData =
              Provider.of<BrandItemsList>(context, listen: false);
          print("shoping list length...."+shoplistData.itemsshoplist.length.toString());
        });
      });

      checkskip = !PrefUtils.prefs!.containsKey('apikey');

    });
  }

  additemtolistTwo() {
    final shoplistDataTwo = Provider.of<BrandItemsList>(context, listen: false);
    _dialogforProceesing(context, "Add item to list...");
    for (int i = 0; i < shoplistDataTwo.itemsshoplist.length; i++) {
      //adding item to multiple list
      if (shoplistDataTwo.itemsshoplist[i].listcheckbox == true) {
        addtoshoppinglisttwo(i);
      }
    }
  }

  addtoshoppinglisttwo(i) async {
    final shoplistDataTwo = Provider.of<BrandItemsList>(context, listen: false);
    final routeArgs =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final itemid = routeArgs['itemid'];

    Provider.of<BrandItemsList>(context, listen: false).AdditemtoShoppinglist(
        itemid.toString(), varid.toString(), shoplistDataTwo.itemsshoplist[i].listid!,"0").then((_) {
      Provider.of<BrandItemsList>(context, listen: false).fetchShoppinglist().then((_) {
        shoplistData = Provider.of<BrandItemsList>(context, listen: false);
        Navigator.of(context).pop();
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
                  width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
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
  @override
  Widget build(BuildContext context) {
     shoplistData = Provider.of<BrandItemsList>(context, listen: false);
    print("shopping build list..."+shoplistData.itemsshoplist.length.toString());
    // TODO: implement build
    return Container(
      width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
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
                itemCount: shoplistData.itemsshoplist.length,
                itemBuilder: (_, i) =>
                    Row(
                      children: [
                        Checkbox(
                          value: shoplistData.itemsshoplist[i].listcheckbox,
                          onChanged: ( bool? value) async {
                            setState(() {
                              shoplistData.itemsshoplist[i].listcheckbox = value;
                            });
                          },
                        ),
                        Text(shoplistData.itemsshoplist[i].listname!,
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
                showDialog(
                    context: context,
                    builder: (context) {
                      final x = Provider.of<BrandItemsList>(context, listen: false);
                      return StatefulBuilder(builder: (context, setState) {
                        return Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.0)),
                            child: CreateshoppingListBox(context: context,)
                        );
                      });
                    });

                for (int i = 0; i < shoplistData.itemsshoplist.length; i++) {
                  shoplistData.itemsshoplist[i].listcheckbox = false;
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
                for (int i = 0; i < shoplistData.itemsshoplist.length; i++) {
                  if (shoplistData.itemsshoplist[i].listcheckbox!)
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
                width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
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
                for (int i = 0; i < shoplistData.itemsshoplist.length; i++) {
                  shoplistData.itemsshoplist[i].listcheckbox = false;
                }
              },
              child: Container(
                width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
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
    );
  }
}