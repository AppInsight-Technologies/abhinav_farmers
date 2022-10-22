
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grocbay/widgets/shoppingList/dialogforitemCreateList.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../assets/ColorCodes.dart';
import '../../generated/l10n.dart';
import '../../main.dart';
import '../../providers/branditems.dart';
import '../../providers/itemslist.dart';
import '../../providers/sellingitems.dart';
import '../../utils/ResponsiveLayout.dart';
import '../../utils/prefUtils.dart';

class CreateshoppingListBox extends StatefulWidget{
  BuildContext context;
  CreateshoppingListBox({Key? key,required this.context}) : super(key: key);
  @override
  CreateshoppingListBoxState createState() => CreateshoppingListBoxState();
}

class CreateshoppingListBoxState extends State<CreateshoppingListBox> {
  bool _isWeb = Vx.isWeb;
  bool checkskip = false;
  final _form = GlobalKey<FormState>();
  var shoplistData;
  var itemid;
  var fromScreen;
  var notificationFor;
  bool _isLoading = true;
  var singleitemvar;
  String? varid;
  @override
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
        Provider.of<BrandItemsList>(widget.context,listen: false)
            .fetchShoppinglist()
            .then((_) {
          shoplistData =
              Provider.of<BrandItemsList>(context, listen: false);
        });
      });
      checkskip = !PrefUtils.prefs!.containsKey('apikey');
      final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;


        });
    }
  addListnameToSF(String value) async {
    PrefUtils.prefs!.setString('list_name', value);
  }
  _saveFormTwo(BuildContext context1) async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    } //it will check all validators
    _form.currentState!.save();
    Navigator.of(context1).pop();
    _dialogforProceesing(context1, S.current.creating_list);

    Provider.of<BrandItemsList>(context1, listen: false).CreateShoppinglist().then((_) {
      Navigator.pop(context1);
      CreateItemListBox();
     /* Provider.of<BrandItemsList>(context1, listen: false).fetchShoppinglist().then((_) {
        shoplistData = Provider.of<BrandItemsList>(context1, listen: false);
        Navigator.pop(context1);
        CreateItemListBox();
      });*/
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
    return Container(
        width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
        height: 250.0,
        margin: EdgeInsets.only(
            left: 20.0, top: 10.0, right: 10.0, bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              S.current.create_shopping_list,
              style: TextStyle(
                  fontSize: 16.0,
                  color: Theme
                      .of(context)
                      .primaryColor,
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
                        return S.current.please_enter_list_name;
                      }
                      return null; //it means user entered a valid input
                    },
                    onSaved: (value) {
                      addListnameToSF(value!);
                    },
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: S.current.shopping_list_name,
                      labelStyle: TextStyle(
                          color: ColorCodes.primaryColor)/*Theme
                              .of(context)
                              .accentColor)*/,
                      contentPadding: EdgeInsets.all(12),
                      hintText: 'ex: Monthly Grocery',
                      hintStyle: TextStyle(
                          color: Colors.black12, fontSize: 10.0),
                      //prefixIcon: Icon(Icons.alternate_email, color: Theme.of(context).accentColor),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme
                                  .of(context)
                                  .focusColor
                                  .withOpacity(0.2))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme
                                  .of(context)
                                  .focusColor
                                  .withOpacity(0.5))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme
                                  .of(context)
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
                _saveFormTwo(widget.context);
              },
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: 40.0,
                decoration: BoxDecoration(
                  color: Theme
                      .of(context)
                      .primaryColor,
                  borderRadius: BorderRadius.circular(3.0),
                ),
                child: Center(
                    child: Text(
                      S.current.create_shopping_list,
                      textAlign: TextAlign.center,
                      style:
                      TextStyle(color:ColorCodes.whiteColor /*Theme
                          .of(context)
                          .buttonColor*/),
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
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: 40.0,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(3.0),
                ),
                child: Center(
                    child: Text(
                      S.current.cancel,
                      textAlign: TextAlign.center,
                      style:
                      TextStyle(color: ColorCodes.whiteColor),
                    )),
              ),
            ),
          ],
        ));

  }
}






