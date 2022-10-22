import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../controller/mutations/cat_and_product_mutation.dart';
import '../../../widgets/custome_stepper.dart';
import '../../../controller/mutations/cart_mutation.dart';
import '../../../helper/custome_calculation.dart';
import '../../../models/VxModels/VxStore.dart';
import '../../../models/newmodle/cartModle.dart';
import '../../../models/newmodle/product_data.dart';
import '../../../models/newmodle/user.dart';
import '../../../components/login_web.dart';
import '../../controller/mutations/home_screen_mutation.dart';
import '../../helper/custome_checker.dart';
import '../../models/newmodle/shoppingModel.dart';
import '../../providers/branditems.dart';
import '../../repository/authenticate/AuthRepo.dart';
import '../../rought_genrator.dart';
import '../../screens/membership_screen.dart';
import '../../widgets/productWidget/item_badge.dart';
import '../../widgets/productWidget/item_variation.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../generated/l10n.dart';
import '../../../constants/IConstants.dart';
import '../../../constants/features.dart';
import '../../../assets/images.dart';
import '../../../utils/prefUtils.dart';
import '../../../utils/ResponsiveLayout.dart';
import '../../../assets/ColorCodes.dart';

class Itemsv2 extends StatefulWidget {
  final String _fromScreen;
  final ItemData _itemdata;
  final UserData _customerDetail;
  Itemsv2(this._fromScreen, this._itemdata, this._customerDetail);

  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Itemsv2> with Navigations {
  int itemindex = 0;
  var textcolor;
  bool _checkmembership = false;
  List<CartItem> productBox=[];
  int _groupValue = 0;
  int quantity = 0;
  double weight = 0.0;
  int _count = 1;
 // var shoplistData;
  List<ShoppingListData> shoplistData=[];
  final _form = GlobalKey<FormState>();
  GroceStore store = VxState.store;
  Auth _auth = Auth();

  @override
  void initState() {
    productBox = (VxState.store as GroceStore).CartItemList;
    if(Features.btobModule){
      if (productBox.where((element) => element.itemId == widget._itemdata.id).count() >= 1) {
        for (int i = 0; i < productBox.length; i++) {
          for(int j = 0 ; j < widget._itemdata.priceVariation!.length; j++)
          {
            if ((int.parse(productBox.where((element) => element.itemId == widget._itemdata.id).first.quantity.toString()) >=  int.parse(widget._itemdata.priceVariation![j].minItem.toString())) && int.parse(productBox.where((element) => element.itemId == widget._itemdata.id).first.quantity.toString()) <=  int.parse(widget._itemdata.priceVariation![j].maxItem.toString())) {
              _groupValue = j;
            }
          }

        }
      }
    }
    if(Features.isShoppingList){
      shoplistData = (VxState.store as GroceStore).ShoppingList;
      //shoplistData = (VxState.store as GroceStore).ShoppingList;

      //shoplistData =  store.shoppingList.;
      /*Provider.of<BrandItemsList>(context,listen: false)
          .fetchShoppinglist()
          .then((_) {
        shoplistData =
            Provider.of<BrandItemsList>(context, listen: false);
      });*/
    }
    super.initState();
  }

   showoptions1() {
    (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context, setState) {
            return  Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius. only(topLeft: Radius. circular(15.0), topRight: Radius. circular(15.0)),),
              child: Container(
                width: MediaQuery.of(context).size.width / 2.5,
                padding: EdgeInsets.fromLTRB(30, 20, 20, 20),
                child: ItemVariation(itemdata: widget._itemdata,ismember: _checkmembership,selectedindex: itemindex,onselect: (i){
                  setState(() {
                    itemindex = i;
                  });
                },),
              ),
            );
          });
        })
    :showModalBottomSheet<dynamic>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius. only(topLeft: Radius. circular(15.0), topRight: Radius. circular(15.0)),),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return ItemVariation(itemdata: widget._itemdata,ismember: _checkmembership,selectedindex: itemindex,onselect: (i){
            setState(() {
              itemindex = i;
            });
          },);
        });
  }

  addListnameToSF(String value) async {
    PrefUtils.prefs!.setString('list_name', value);
  }

  _saveFormTwo() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    } //it will check all validators
    _form.currentState!.save();
    Navigator.of(context).pop();
    _dialogforProceesing(context, S.current.creating_list);

    Provider.of<BrandItemsList>(context, listen: false).CreateShoppinglist().then((_) {
      _auth.getuserProfile(onsucsess: (value){
        shoplistData = (VxState.store as GroceStore).ShoppingList;
        Navigator.of(context).pop();
        _dialogforShoppinglistTwo(context);
      },onerror: (){
      });
    });
  }

  additemtolistTwo() {
    final shoplistDataTwo = shoplistData;//Provider.of<BrandItemsList>(context, listen: false);
    _dialogforProceesing(context, "Add item to list...");
    for (int i = 0; i < shoplistDataTwo.length; i++) {
      //adding item to multiple list
      if (shoplistDataTwo[i].listcheckbox == true) {
        addtoshoppinglisttwo(i);
      }
    }
  }

  addtoshoppinglisttwo(i) async {
    final shoplistDataTwo = shoplistData;//Provider.of<BrandItemsList>(context, listen: false);

    Provider.of<BrandItemsList>(context, listen: false).AdditemtoShoppinglist(
        widget._itemdata.id.toString(), widget._itemdata.type == "1" ?widget._itemdata.id.toString():widget._itemdata.priceVariation![itemindex].id.toString(), shoplistDataTwo[i].id!,widget._itemdata.type.toString()).then((_) {
      _auth.getuserProfile(onsucsess: (value){
        shoplistData = (VxState.store as GroceStore).ShoppingList;
        shoplistData[i].listcheckbox = false;
        Navigator.of(context).pop();
      },onerror: (){

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


  _dialogforCreatelistTwo(BuildContext context, shoplistData) {
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
                                    color: ColorCodes.primaryColor),
                                contentPadding: EdgeInsets.all(12),
                                hintText: S.of(context).monthly_grocery,//'ex: Monthly Grocery',
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
                          _saveFormTwo();
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
                                TextStyle(color: ColorCodes.whiteColor/*Theme
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
                  )),
            );
          });
        });
  }

  _dialogforShoppinglistTwo(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          shoplistData = (VxState.store as GroceStore).ShoppingList;
          //final x = Provider.of<BrandItemsList>(context, listen: false);
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
                                itemCount: shoplistData.length,
                                itemBuilder: (_, i) =>
                                    Row(
                                      children: [
                                        Checkbox(
                                          checkColor: ColorCodes.primaryColor,
                                          activeColor: ColorCodes.whiteColor,
                                          value: shoplistData[i].listcheckbox,
                                          onChanged: ( bool? value) async {
                                            setState(() {
                                              /*x.itemsshoplist[i].listcheckbox*/ shoplistData[i].listcheckbox = value;
                                            });
                                          },
                                        ),
                                        Text(/*x.itemsshoplist[i].listname!*/shoplistData[i].name!,
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

                            _dialogforCreatelistTwo(context, shoplistData);

                            for (int i = 0; i < shoplistData.length/*x.itemsshoplist.length*/; i++) {
                             /* x.itemsshoplist[i].listcheckbox*/ shoplistData[i].listcheckbox = false;
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
                            for (int i = 0; i < /*x.itemsshoplist.length*/shoplistData.length; i++) {
                              if (/*x.itemsshoplist[i].listcheckbox!*/shoplistData[i].listcheckbox!)
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
                            width: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
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
                            for (int i = 0; i < shoplistData.length; i++) {
                              /*x.itemsshoplist[i].listcheckbox*/shoplistData[i].listcheckbox = false;
                            }
                          },
                          child: Container(
                            width: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
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
                ));
          });
        });
  }

  @override
  Widget build(BuildContext context) {

    if(Features.btobModule){
      if (productBox.where((element) => element.itemId == widget._itemdata.id)
          .count() >= 1) {
        for (int i = 0; i < productBox.length; i++) {
          if (productBox[i].itemId == widget._itemdata.id && productBox[i].toppings == "0") {
            quantity = quantity + int.parse(productBox.where((element) =>
            element.itemId == widget._itemdata.id).first.quantity!);
            weight = weight + double.parse(productBox.where((element) =>
            element.itemId == widget._itemdata.id).first.weight!);
          }
        }
      }
    }
    else {
      if (productBox.where((element) => element.itemId == widget._itemdata.id).count() >= 1) {
        for (int i = 0; i < productBox.length; i++) {
          if (productBox[i].itemId == widget._itemdata.id && productBox[i].toppings == "0") {
            quantity = quantity + int.parse(productBox
                .where((element) =>
            element.itemId == widget._itemdata.id)
                .first
                .quantity!);
            weight = weight + double.parse(productBox
                .where((element) =>
            element.itemId == widget._itemdata.id)
                .first
                .weight!);
          }
        }
      }
    }

    String _membershipSavings = "";
    String _priceDisplay = "";
    String _mrpDisplay = "";
    String _mrp = "0";
    String _price = "0";
    bool _isSingleSKU = widget._itemdata.type == "1" ? true : false;

    if(Check().checkmembership()) { //Membered user
      if(_isSingleSKU ? widget._itemdata.membershipDisplay! : widget._itemdata.priceVariation![Features.btobModule ? _groupValue : itemindex].membershipDisplay!){ //Eligible to display membership price
        _priceDisplay = _isSingleSKU ? widget._itemdata.membershipPrice! : widget._itemdata.priceVariation![Features.btobModule ? _groupValue : itemindex].membershipPrice!;
        _mrpDisplay = _isSingleSKU ? widget._itemdata.mrp! : widget._itemdata.priceVariation![Features.btobModule ? _groupValue : itemindex].mrp!;
        _mrp = _mrpDisplay;
        _membershipSavings = (double.parse(_isSingleSKU ? widget._itemdata.mrp! :
        widget._itemdata.priceVariation![Features.btobModule ? _groupValue : itemindex].mrp!) - double.parse(_isSingleSKU ? widget._itemdata.membershipPrice! : widget._itemdata.priceVariation![Features.btobModule ? _groupValue : itemindex].membershipPrice!)).toStringAsFixed(IConstants.decimaldigit);
      } else if(_isSingleSKU ? widget._itemdata.discointDisplay! : widget._itemdata.priceVariation![Features.btobModule ? _groupValue : itemindex].discointDisplay!){ //Eligible to display discounted price
        _priceDisplay = _isSingleSKU ? widget._itemdata.price! : widget._itemdata.priceVariation![Features.btobModule ? _groupValue : itemindex].price!;
        _mrpDisplay = _isSingleSKU ? widget._itemdata.mrp! : widget._itemdata.priceVariation![Features.btobModule ? _groupValue : itemindex].mrp!;
        _mrp = _mrpDisplay;
        _membershipSavings = (double.parse(_isSingleSKU ? widget._itemdata.mrp! : widget._itemdata.priceVariation![Features.btobModule ? _groupValue : itemindex].mrp!) - double.parse(_isSingleSKU ? widget._itemdata.price! : widget._itemdata.priceVariation![Features.btobModule ? _groupValue : itemindex].price!)).toStringAsFixed(IConstants.decimaldigit);

      } else { //Otherwise display mrp
        _priceDisplay = _isSingleSKU ? widget._itemdata.mrp! : widget._itemdata.priceVariation![Features.btobModule ? _groupValue : itemindex].mrp!;
        _mrp = _priceDisplay;
      }
    } else { //Non membered user
      if(_isSingleSKU ? widget._itemdata.discointDisplay! : widget._itemdata.priceVariation![Features.btobModule ? _groupValue : itemindex].discointDisplay!){ //Eligible to display discounted price
        _priceDisplay = _isSingleSKU ? widget._itemdata.price! : widget._itemdata.priceVariation![Features.btobModule ? _groupValue : itemindex].price!;
        _mrpDisplay = _isSingleSKU ? widget._itemdata.mrp! : widget._itemdata.priceVariation![Features.btobModule ? _groupValue : itemindex].mrp!;
        _mrp = _mrpDisplay;
      } else { //Otherwise display mrp
        _priceDisplay = _isSingleSKU ? widget._itemdata.mrp! : widget._itemdata.priceVariation![Features.btobModule ? _groupValue : itemindex].mrp!;
        _mrp = _priceDisplay;
      }
    }
    _price = _priceDisplay;
    if(Features.iscurrencyformatalign) {
      _priceDisplay = '${double.parse(_priceDisplay).toStringAsFixed(IConstants.decimaldigit)} ' + IConstants.currencyFormat;
      if(_mrpDisplay != "")
        _mrpDisplay = '${double.parse(_mrpDisplay).toStringAsFixed(IConstants.decimaldigit)} ' + IConstants.currencyFormat;
      if(_membershipSavings != "")
        _membershipSavings = '${double.parse(_membershipSavings).toStringAsFixed(IConstants.decimaldigit)} ' + IConstants.currencyFormat;
    } else {
      _priceDisplay = IConstants.currencyFormat + '${double.parse(_priceDisplay).toStringAsFixed(IConstants.decimaldigit)} ';
      if(_mrpDisplay != "")
        _mrpDisplay =  IConstants.currencyFormat + '${double.parse(_mrpDisplay).toStringAsFixed(IConstants.decimaldigit)} ';
      if(_membershipSavings != "")
        _membershipSavings =  IConstants.currencyFormat + '${double.parse(_membershipSavings).toStringAsFixed(IConstants.decimaldigit)} ';
    }

    double margins = Calculate().getmargin(_mrp, _price);
    /*(widget._itemdata.type=="1")?Calculate().getmargin(widget._itemdata.mrp,
        VxState.store.userData.membership! == "0" || VxState.store.userData.membership! == "2" ?
        widget._itemdata.discointDisplay! ? widget._itemdata.price : widget._itemdata.mrp
            : widget._itemdata.membershipDisplay!? widget._itemdata.membershipPrice: widget._itemdata.price):
    Calculate().getmargin(widget._itemdata.priceVariation![itemindex].mrp,
        VxState.store.userData.membership! == "0" || VxState.store.userData.membership! == "2" ?
        widget._itemdata.priceVariation![itemindex].discointDisplay! ? widget._itemdata.priceVariation![itemindex].price : widget._itemdata.priceVariation![itemindex].mrp
            : widget._itemdata.priceVariation![itemindex].membershipDisplay!? widget._itemdata.priceVariation![itemindex].membershipPrice: widget._itemdata.priceVariation![itemindex].price);*/

    return widget._itemdata.type == "1" ?
    Expanded(
      child:
      Container(
        width: _checkmembership? 210:195.0,
        child:Container(
          margin: EdgeInsets.only(left: 10.0, top: 5.0, right: 2.0, bottom: 5.0),
          decoration: new BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[300]!,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 0.50)),
              ],
              borderRadius: new BorderRadius.all(const Radius.circular(8.0),)),
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Column(
                children: [
                  SizedBox(height: 8,),
                  Stack(
                      children:[
                        ItemBadge(
                          outOfStock: widget._itemdata.stock!<=0?OutOfStock(singleproduct: false,):null,
                          badgeDiscount: BadgeDiscounts(value: margins.toStringAsFixed(0)),
                          child: Align(
                            alignment: Alignment.center,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid": widget._itemdata.id.toString(),"productId": widget._itemdata.id!});
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 10.0, bottom: 8.0),
                                  child: CachedNetworkImage(
                                    imageUrl: widget._itemdata.itemFeaturedImage,
                                    errorWidget: (context, url, error) => Image.asset(
                                      Images.defaultProductImg,
                                      width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                      height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                    ),
                                    placeholder: (context, url) => Image.asset(
                                      Images.defaultProductImg,
                                      width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                      height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                    ),
                                    width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                    height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        widget._itemdata.eligibleForExpress=="0"?Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 5.0,left: 5,bottom: 5),
                            child: Container(
                              width: 46,
                              height: 17,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                border: Border.all(
                                    color: ColorCodes.varcolor),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left:2.0),
                                    child: Text(/*"Express"*/S.of(context).express,style: TextStyle(fontSize: 8,color: ColorCodes.primaryColor,fontWeight: FontWeight.w800),),
                                  ),
                                  Image.asset(Images.express,
                                    height: 15.0,
                                    width: 13.0,
                                    color: ColorCodes.primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ):SizedBox.shrink(),
                      ]

                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),

              Row(
                children: [
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Text(
                      widget._itemdata.brand!,
                      style: TextStyle(
                          fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 13,
                          color: ColorCodes.lightGreyColor,fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Spacer(),
                  if(Features.isLoyalty)
                    if(double.parse(widget._itemdata.loyalty.toString()) > 0)
                      Container(
                        height: 18,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(Images.coinImg,
                              height: 12.0,
                              width: 18.0,),
                            SizedBox(width: 2),
                            Text(widget._itemdata.loyalty.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 11),),
                          ],
                        ),
                      ),
                ],
              ),
              SizedBox(height: 2,),
              Row(
                children: [
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      height: 35,
                      child: Text(
                        widget._itemdata.itemName!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style:
                        TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Features.isSubscription && widget._itemdata.eligibleForSubscription=="0"?
                  Container(
                    height:30,
                    width: 70,
                    child: Padding(
                      padding: const EdgeInsets.only(left:0,right:5.0),
                      child: CustomeStepper(fontSize: 9,itemdata: widget._itemdata,from:"item_screen",height: (Features.isSubscription)?90:60,issubscription: "Subscribe",addon:(widget._itemdata.addon!.length > 0)?widget._itemdata.addon![0]:null, index: itemindex),
                    ),
                  ):SizedBox.shrink(),
                  SizedBox(
                    width: 5.0,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 10.0,
                  ),
                  (widget._itemdata.singleshortNote.toString() == "0" || widget._itemdata.singleshortNote.toString() == "") ?
                  SizedBox(height: 15) :
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(widget._itemdata.singleshortNote.toString(),style: TextStyle(fontSize: 9,color: ColorCodes.emailColor,fontWeight: FontWeight.bold),),
                    ],
                  ),
                  SizedBox(width: 10)
                ],
              ),
              SizedBox(height:2),
              (Features.netWeight && widget._itemdata.vegType == "fish")?
              Row(
                children: [
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    Features.iscurrencyformatalign?
                    /*"Whole Uncut:"*/ S.of(context).whole_uncut +" " +
                        widget._itemdata.salePrice! + IConstants.currencyFormat +" / "+ /*"500 G"*/S.of(context).gram:
                    /*"Whole Uncut:"*/S.of(context).whole_uncut +" "+ IConstants.currencyFormat +
                        widget._itemdata.salePrice! +" / "+ /*"500 G"*/S.of(context).gram,
                    style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 11 : 11, fontWeight: FontWeight.bold),),
                  SizedBox(
                    width: 10.0,
                  ),
                ],
              ):SizedBox.shrink(),
              (Features.netWeight && widget._itemdata.vegType == "fish")?
              SizedBox(
                height: 2,
              ) : SizedBox.shrink(),
              (Features.netWeight && widget._itemdata.vegType == "fish")
                  ? Row(
                  children: [
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(/*"G Weight:"*/S.of(context).g_weight +" "+
                            widget._itemdata.weight!,
                            style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 11 : 11, fontWeight: FontWeight.bold)
                        ),
                      ],
                    ),
                    SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(/*"N Weight:"*/S.of(context).n_weight +" "+
                            widget._itemdata.netWeight!,
                            style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 11 : 11, fontWeight: FontWeight.bold)
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                  ]
              ):SizedBox.shrink(),
              (Features.netWeight && widget._itemdata.vegType == "fish") ?
              SizedBox(height: 18,):SizedBox.shrink(),
              SizedBox(height:5),
              Padding(
                padding: const EdgeInsets.only(left:10,right:5.0),
                child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VxBuilder(
                          mutations: {ProductMutation,SetCartItem},
                          builder: (context, box, _) {
                            if(VxState.store.userData.membership! == "1"){
                              _checkmembership = true;
                            } else {
                              _checkmembership = false;
                              for (int i = 0; i < productBox.length; i++) {
                                if (productBox[i].mode == "1") {
                                  _checkmembership = true;
                                }
                              }
                            }
                            return  Row(
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    new RichText(
                                      text: new TextSpan(
                                        style: new TextStyle(
                                          fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,
                                          color: Colors.black,
                                        ),
                                        children: <TextSpan>[
                                          new TextSpan(
                                              text: _priceDisplay,
                                              style: new TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: _checkmembership?ColorCodes.greenColor:Colors.black,
                                                fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,)),
                                          new TextSpan(
                                              text: _mrpDisplay,
                                              style: TextStyle(
                                                color: ColorCodes.emailColor,
                                                decoration:
                                                TextDecoration.lineThrough,
                                                fontSize: ResponsiveLayout.isSmallScreen(context) ? 7 : ResponsiveLayout.isMediumScreen(context) ? 8 : 9)),
                                        ],
                                      ),
                                    ),
                                    Check().checkmembership() ? Text(/*"Membership Price"*/S.of(context).membership_price,style: TextStyle(color: ColorCodes.greenColor,fontSize:7),):SizedBox.shrink(),
                                  ],
                                ),
                                Spacer(),
                                Check().checkmembership() ? _membershipSavings != "" ?
                                Container(
                                  height: 20,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(width: 3.0, color: ColorCodes.darkgreen),
                                    ),
                                    color: ColorCodes.varcolor,
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(width: 3),
                                      Image.asset(
                                        Images.bottomnavMembershipImg,
                                        color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                                        width: 15,
                                        height: 10,),
                                      SizedBox(width: 2),
                                      Padding(
                                        padding: const EdgeInsets.only(top:4.0,bottom: 3),
                                        child: Text(
                                            S.of(context).savings + " " + _membershipSavings,
                                            style: TextStyle(fontSize: 9, color: ColorCodes.darkgreen,fontWeight: FontWeight.bold)),
                                      ),
                                      SizedBox(width: 5),
                                    ],
                                  ),
                                ):SizedBox.shrink()
                                    :
                                Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: VxBuilder(
                                    mutations: {SetCartItem,ProductMutation},
                                    builder: (context, box, index) {
                                      return Column(
                                        children: [
                                          if(Features.isMembership && double.parse(widget._itemdata.membershipPrice.toString()) > 0)
                                            Row(
                                              children: <Widget>[
                                                !_checkmembership
                                                    ? widget._itemdata.membershipDisplay!
                                                    ? GestureDetector(
                                                  onTap: () {
                                                    if(!PrefUtils.prefs!.containsKey("apikey")) {
                                                      if (kIsWeb && !ResponsiveLayout.isSmallScreen(
                                                          context)) {
                                                        LoginWeb(context, result: (sucsess) {
                                                          if (sucsess) {
                                                            Navigator.of(context).pop();
                                                            Navigation(context, navigatore: NavigatoreTyp.homenav);
                                                          } else {
                                                            Navigator.of(context).pop();
                                                          }
                                                        });
                                                      } else {
                                                        Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push);
                                                      }
                                                    }
                                                    else{
                                                      if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                                                        MembershipInfo(context);
                                                      }
                                                      else {
                                                        Navigation(context,
                                                            name: Routename
                                                                .Membership,
                                                            navigatore: NavigatoreTyp
                                                                .Push);
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 20,
                                                    padding: EdgeInsets.only(left: 2),
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        right: BorderSide(width: 3.0, color: ColorCodes.darkgreen),
                                                      ),
                                                      color: ColorCodes.varcolor,
                                                    ),
                                                    child: Row(
                                                      children: <Widget>[
                                                        SizedBox(width: 3),
                                                        Image.asset(
                                                          Images.bottomnavMembershipImg,
                                                          color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                                                          width: 14,
                                                          height: 8,),
                                                        SizedBox(width: 2),
                                                        Text(
                                                          // S .of(context).membership_price+ " " +//"Membership Price "
                                                            S.of(context).price + " ",
                                                            style: TextStyle(fontSize: 8.0,color: ColorCodes.darkgreen,fontWeight: FontWeight.bold)),
                                                        Text(
                                                          // S .of(context).membership_price+ " " +//"Membership Price "
                                                            Features.iscurrencyformatalign?
                                                            widget._itemdata.membershipPrice.toString() + IConstants.currencyFormat:
                                                            IConstants.currencyFormat +
                                                                widget._itemdata.membershipPrice.toString(),
                                                            style: TextStyle(fontSize: 8.0,color: ColorCodes.darkgreen,fontWeight: FontWeight.bold)),

                                                        SizedBox(width: 5),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                                    : SizedBox.shrink()
                                                    : SizedBox.shrink(),
                                              ],
                                            ),
                                          !_checkmembership
                                              ? widget._itemdata.membershipDisplay!
                                              ? SizedBox(
                                            height:( Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?0:1,
                                          )
                                              : SizedBox(
                                            height:( Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?0:1,
                                          )
                                              : SizedBox(
                                            height:( Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?0:1,
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                      ],
                    )),
              ),
              SizedBox(height:5),
              Padding(
                padding: const EdgeInsets.only(left: 5.0,right: 5.0),
                child: Container(
                  height:40,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height:(Features.isSubscription)?40:40,
                        width: Features.isShoppingList ? _checkmembership?155:140 : _checkmembership?188:173,
                        child: Padding(
                          padding: const EdgeInsets.only(left:5,right:5.0),
                          child: CustomeStepper(itemdata: widget._itemdata,from:"item_screen",height: (Features.isSubscription)?90:60,addon:(widget._itemdata.addon!.length > 0)?widget._itemdata.addon![0]:null, index: itemindex,issubscription: "Add", ),
                        ),
                      ),
                      if(Features.isShoppingList)
                      SizedBox(width: 1,),
                      if(Features.isShoppingList)
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {

                         /* if(!PrefUtils.prefs!.containsKey("apikey")) {
                            Navigation(context, name: Routename.SignUpScreen,
                                navigatore: NavigatoreTyp.Push);
                          }
                          else {
                            final shoplistData = Provider.of<BrandItemsList>(context, listen: false);

                            if (shoplistData.itemsshoplist.length <= 0) {
                              _dialogforCreatelistTwo(context, shoplistData);
                            } else {
                              _dialogforShoppinglistTwo(context);
                            }
                          }*/
                          if(!PrefUtils.prefs!.containsKey("apikey")) {
                            if (kIsWeb && !ResponsiveLayout.isSmallScreen(
                                context)) {
                              LoginWeb(context, result: (sucsess) {
                                if (sucsess) {
                                  Navigator.of(context).pop();
                                  Navigation(context, navigatore: NavigatoreTyp.homenav);
                                } else {
                                  Navigator.of(context).pop();
                                }
                              });
                            } else {
                              Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push);
                            }
                          }
                          else {
                            //final shoplistData = Provider.of<BrandItemsList>(context, listen: false);

                            if (shoplistData.length <= 0) {
                              _dialogforCreatelistTwo(context, shoplistData);
                            } else {
                              _dialogforShoppinglistTwo(context);
                            }
                          }

                        },
                        child: Container(
                          height: 32,
                          padding: EdgeInsets.all(5),
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: ColorCodes.varcolor,
                            border: Border(
                              right: BorderSide(width: 1.0, color: ColorCodes.varcolor,),
                              left: BorderSide(width: 1.0, color: ColorCodes.varcolor,),
                              bottom: BorderSide(width: 1.0, color: ColorCodes.varcolor),
                              top: BorderSide(width: 1.0, color: ColorCodes.varcolor),
                            ),),
                          child: Image.asset(
                              Images.addToListImg,width: 20,height: 20,color: ColorCodes.primaryColor),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ):
    Expanded(
      child:
      Container(
        width: _checkmembership? 210:195.0,
        child:Container(
          margin: EdgeInsets.only(left: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?0:10.0, top: 5.0, right: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?10:2.0, bottom: 5.0),
          decoration: new BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[300]!,
                    blurRadius: 5.0,
                    offset: Offset(0.0, 0.50)),
              ],
              borderRadius: new BorderRadius.all(const Radius.circular(8.0),)),
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                children: [
                  SizedBox(height: 8,),
                  Stack(
                    children:[
                      Padding(
                        padding: const EdgeInsets.only(left:5.0),
                        child: ItemBadge(
                          outOfStock: widget._itemdata.priceVariation![itemindex].stock! <= 0 ? OutOfStock(singleproduct: false,) : null,
                          badgeDiscount: BadgeDiscounts(value: margins.toStringAsFixed(0)),
                          child: Align(
                            alignment: Alignment.center,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  if(widget._fromScreen =="Forget"){
                                    Navigation(context, navigatore: NavigatoreTyp.Pop);
                                    Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid": widget._itemdata.priceVariation![itemindex].menuItemId.toString(),"productId": widget._itemdata.priceVariation![itemindex].menuItemId.toString()});
                                  }else{
                                    Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid": widget._itemdata.priceVariation![itemindex].menuItemId.toString(),"productId": widget._itemdata.priceVariation![itemindex].menuItemId.toString()});
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 10.0, bottom: 8.0),
                                  child: CachedNetworkImage(
                                    imageUrl: widget._itemdata.priceVariation![itemindex].images!.length<=0?widget._itemdata.itemFeaturedImage:widget._itemdata.priceVariation![itemindex].images![0].image,
                                    errorWidget: (context, url, error) => Image.asset(
                                      Images.defaultProductImg,
                                      width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                      height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                    ),
                                    placeholder: (context, url) => Image.asset(
                                      Images.defaultProductImg,
                                      width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                      height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                    ),
                                    width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                    height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      widget._itemdata.eligibleForExpress == "0" ?Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 5.0,left: 5,bottom: 5),
                          child: Container(
                            width: 46,
                            height: 17,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(
                                  color: ColorCodes.varcolor),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left:2.0),
                                  child: Text(S.of(context).express,style: TextStyle(fontSize: 8,color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,fontWeight: FontWeight.w800),),
                                ),
                                Image.asset(Images.express,
                                  height: 15.0,
                                  width: 13.0,
                                  color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ):SizedBox.shrink(),
                    ],

                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),

              Row(
                children: [
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Text(
                      widget._itemdata.brand!,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 13,
                          color: ColorCodes.lightGreyColor,fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  if(Features.btobModule)
                    SizedBox(
                      width: 10.0,
                    ),
                  if(Features.btobModule)
                    if(Features.isLoyalty)
                      if(double.parse(widget._itemdata.priceVariation![itemindex].loyalty.toString()) > 0)
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(Images.coinImg,
                                height: 13.0,
                                width: 20.0,),
                              SizedBox(width: 2),
                              Text(widget._itemdata.priceVariation![itemindex].loyalty.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),
                            ],
                          ),
                        ),
                  if(Features.isLoyalty)
                    Spacer(),
                  if(Features.isLoyalty)
                    if(double.parse(widget._itemdata.priceVariation![itemindex].loyalty.toString()) > 0)
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(Images.coinImg,
                              height: 12.0,
                              width: 18.0,),
                            SizedBox(width: 2),
                            Text(widget._itemdata.priceVariation![itemindex].loyalty.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 11),),
                          ],
                        ),
                      ),
                  SizedBox(
                    width: 10.0,
                  ),
                ],
              ),
              SizedBox(
                height: 2,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      height: 35,
                      child: Text(
                        widget._itemdata.itemName!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style:
                        TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),

                  Features.isSubscription && widget._itemdata.eligibleForSubscription=="0"?
                  Container(
                    height:30,
                    width: 70,
                    child: Padding(
                      padding: const EdgeInsets.only(left:0,right:5.0),
                      child: CustomeStepper(fontSize: 9,priceVariation:widget._itemdata.priceVariation![itemindex],itemdata: widget._itemdata,from:"item_screen",height: (Features.isSubscription)?90:60,issubscription: "Subscribe",addon:(widget._itemdata.addon!.length > 0)?widget._itemdata.addon![0]:null, index: itemindex),
                    ),
                  ):SizedBox.shrink(),
                  SizedBox(
                    width: 5.0,
                  ),
                ],
              ),
              (Features.netWeight && widget._itemdata.vegType == "fish")?
              Row(
                children: [
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    Features.iscurrencyformatalign?
                    /*"Whole Uncut:"*/S.of(context).whole_uncut +" " +
                        widget._itemdata.salePrice! + IConstants.currencyFormat +" / "+ /*"500 G"*/S.of(context).gram:
                    /*"Whole Uncut:"*/S.of(context).whole_uncut +" "+ IConstants.currencyFormat +
                        widget._itemdata.salePrice! +" / "+ /*"500 G"*/S.of(context).gram,
                    style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 11 : 11, fontWeight: FontWeight.bold),),
                  SizedBox(
                    width: 10.0,
                  ),
                ],
              ):
              SizedBox.shrink(),
              (Features.netWeight && widget._itemdata.vegType == "fish")?
              SizedBox(
                height: 2,
              ):
              SizedBox.shrink(),
              (Features.netWeight && widget._itemdata.vegType == "fish")
                  ? Row(
                  children: [
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(/*"G Weight:"*/S.of(context).g_weight + " " + widget._itemdata.priceVariation![itemindex].weight!,
                            style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 11 : 11, fontWeight: FontWeight.bold)
                        ),
                      ],
                    ),
                    SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(/*"N Weight:"*/S.of(context).n_weight + " " + widget._itemdata.priceVariation![itemindex].netWeight!,
                            style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 11 : 11, fontWeight: FontWeight.bold)
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                  ]
              ) : SizedBox.shrink(),

              SizedBox(height: 2),
              ( widget._itemdata.priceVariation!.length > 1)
                  ? Features.btobModule?
              Container(
                  child: SingleChildScrollView(
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: widget._itemdata.priceVariation!.length,
                          itemBuilder: (_, i) {
                            return MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _groupValue = i;
                                  });
                                  if(productBox
                                      .where((element) =>
                                  element.itemId! == widget._itemdata.id
                                  ).length >= 1) {
                                    cartcontroller.update((done) {
                                    }, price: widget._itemdata.price.toString(),
                                        quantity: widget._itemdata.priceVariation![i].minItem.toString(),
                                        type: widget._itemdata.type,
                                        weight: (
                                            double.parse(widget._itemdata.increament!)).toString(),
                                        var_id: widget._itemdata.priceVariation![0].id.toString(),
                                        increament: widget._itemdata.increament,
                                        cart_id: productBox
                                            .where((element) =>
                                        element.itemId! == widget._itemdata.id
                                        ).first.parent_id.toString(),
                                        toppings: "",
                                        topping_id: "",
                                        item_id: widget._itemdata.id!

                                    );
                                  }
                                  else {
                                    cartcontroller.addtoCart(itemdata: widget._itemdata,
                                        onload: (isloading) {
                                        },
                                        topping_type: "",
                                        varid: widget._itemdata.priceVariation![0].id,
                                        toppings: "",
                                        parent_id: "",
                                        newproduct: "0",
                                        toppingsList: [],
                                        itembody: widget._itemdata.priceVariation![i],
                                        context: context);
                                  }
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Expanded(
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: _groupValue == i ? ColorCodes.mediumgren : ColorCodes.whiteColor,
                                            borderRadius: BorderRadius.circular(5.0),
                                            border: Border.all(
                                              color: ColorCodes.greenColor,
                                            ),
                                          ),
                                          height: 30,
                                          margin: EdgeInsets.only(bottom:5),
                                          padding: EdgeInsets.fromLTRB(5.0, 4.5, 0.0, 4.5),
                                          child:
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${widget._itemdata.priceVariation![i].minItem}"+"-"+"${widget._itemdata.priceVariation![i].maxItem}"+" "+"${widget._itemdata.priceVariation![i].unit}",
                                                style: TextStyle(color: _groupValue == i?ColorCodes.darkgreen:ColorCodes.blackColor,fontWeight: FontWeight.bold,fontSize: 12),
                                              ),
                                              new RichText(
                                                text: new TextSpan(
                                                  style: new TextStyle(
                                                    fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,
                                                    color: _groupValue == i?ColorCodes.darkgreen:ColorCodes.blackColor,
                                                  ),
                                                  children: <TextSpan>[
                                                    new TextSpan(
                                                        text:  Features.iscurrencyformatalign?
                                                        '${_checkmembership?widget._itemdata.priceVariation![i].membershipPrice:widget._itemdata.priceVariation! [i].price} ' + IConstants.currencyFormat:
                                                        IConstants.currencyFormat + '${_checkmembership?widget._itemdata.priceVariation![i].membershipPrice:widget._itemdata.priceVariation![i].price} ',
                                                        style: new TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color:_checkmembership?_groupValue == i?ColorCodes.darkgreen:ColorCodes.blackColor: _groupValue == i?ColorCodes.darkgreen:ColorCodes.blackColor,
                                                          fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,)),
                                                    new TextSpan(
                                                        text: _checkmembership?
                                                        ( (widget._itemdata.priceVariation![i].membershipPrice==widget._itemdata.priceVariation![i].price)||(widget._itemdata.priceVariation![i].membershipPrice==widget._itemdata.priceVariation![i].mrp)) ?""
                                                            : widget._itemdata.priceVariation![i].price!=widget._itemdata.priceVariation![i].mrp?
                                                        Features.iscurrencyformatalign?
                                                        '${widget._itemdata.priceVariation![i].mrp} ' + IConstants.currencyFormat:
                                                        IConstants.currencyFormat + '${widget._itemdata.priceVariation![i].mrp} ':""
                                                            :widget._itemdata.priceVariation![i].price!=widget._itemdata.priceVariation![i].mrp?
                                                        Features.iscurrencyformatalign?
                                                        '${widget._itemdata.priceVariation![i].mrp} ' + IConstants.currencyFormat:
                                                        IConstants.currencyFormat + '${widget._itemdata.priceVariation![i].mrp} ':"",
                                                        style: TextStyle(
                                                          decoration:
                                                          TextDecoration.lineThrough,
                                                          fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 13,)),
                                                  ],
                                                ),
                                              ),

                                              _groupValue == i ?
                                              Container(
                                                width: 18.0,
                                                height: 18.0,
                                                padding: EdgeInsets.only(right:3),
                                                decoration: BoxDecoration(
                                                  color: ColorCodes.greenColor,
                                                  border: Border.all(
                                                    color: ColorCodes.greenColor,
                                                  ),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Container(
                                                  margin: EdgeInsets.all(1.5),
                                                  decoration: BoxDecoration(
                                                    color: ColorCodes.greenColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(Icons.check,
                                                      color: ColorCodes.whiteColor,
                                                      size: 12.0),
                                                ),
                                              )
                                                  :
                                              Icon(
                                                  Icons.radio_button_off_outlined,
                                                  color: ColorCodes.greenColor),
                                            ],
                                          )

                                      ),
                                    ),
                                    Spacer(),
                                    Text(widget._itemdata.singleshortNote.toString(),style: TextStyle(fontSize: 9,color: ColorCodes.emailColor,fontWeight: FontWeight.bold),),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                      )
                  )
              )
                  :
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    showoptions1();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 10.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(2.0),
                              bottomLeft: const Radius.circular(2.0),
                            )),
                        height: 18,
                        padding: EdgeInsets.fromLTRB(0.0, 0, 5.0, 0),
                        child: Text(
                          "${widget._itemdata.priceVariation![itemindex].variationName}" + " " + "${widget._itemdata.priceVariation![itemindex].unit}",
                          style: TextStyle(color: ColorCodes.darkgreen, fontWeight: FontWeight.w600,fontSize: 12),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: ColorCodes.darkgreen,
                        size: 18,
                      ),
                      Spacer(),
                      Text(widget._itemdata.singleshortNote.toString(),style: TextStyle(fontSize: 9,color: ColorCodes.emailColor,fontWeight: FontWeight.bold),),
                      SizedBox(
                        width: 10.0,
                      ),
                    ],
                  ),
                ),
              ) :
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(2.0),
                          topRight: const Radius.circular(2.0),
                          bottomLeft: const Radius.circular(2.0),
                          bottomRight: const Radius.circular(2.0),
                        )),
                    height: 18,
                    padding: EdgeInsets.fromLTRB(0.0, 0, 0.0, 0.0),
                    child: Text(
                      "${widget._itemdata.priceVariation![itemindex].variationName}"+" "+"${widget._itemdata.priceVariation![itemindex].unit}",
                      style: TextStyle(color: ColorCodes.darkgreen,fontWeight: FontWeight.w600,fontSize: 12),
                    ),
                  ),
                  Spacer(),
                  Expanded(child: Text(widget._itemdata.singleshortNote.toString(),maxLines:1,overflow:TextOverflow.ellipsis,style: TextStyle(fontSize: 9,color: ColorCodes.emailColor,fontWeight: FontWeight.bold),)),
                  SizedBox(
                    width: 10.0,
                  ),
                ],
              ),
              SizedBox(height: 2,),
              if(!Features.btobModule)
                Padding(
                  padding: const EdgeInsets.only(left:10.0,right:10),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VxBuilder(
                          mutations: {ProductMutation,SetCartItem},
                          builder: (context, box, _) {
                            if(VxState.store.userData.membership! == "1"){
                              _checkmembership = true;
                            } else {
                              _checkmembership = false;
                              for (int i = 0; i < productBox.length; i++) {
                                if (productBox[i].mode == "1") {
                                  _checkmembership = true;
                                }
                              }
                            }
                            return  Row(
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    new RichText(
                                      text: new TextSpan(
                                        style: new TextStyle(
                                          fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,
                                          color: Colors.black,
                                        ),
                                        children: <TextSpan>[
                                          new TextSpan(
                                              text: _priceDisplay,
                                              style: new TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color:_checkmembership?ColorCodes.greenColor: Colors.black,
                                                fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,)),
                                          new TextSpan(
                                              text: _mrpDisplay,
                                              style: TextStyle(
                                                color: ColorCodes.emailColor,
                                                decoration:
                                                TextDecoration.lineThrough,
                                                fontSize: ResponsiveLayout.isSmallScreen(context) ? 7 : ResponsiveLayout.isMediumScreen(context) ? 8 : 9,)),
                                        ],
                                      ),
                                    ),

                                    _checkmembership?Text(S.of(context).membership_price, style: TextStyle(color: ColorCodes.greenColor,fontSize: 7),):SizedBox.shrink(),
                                    SizedBox(height:5),
                                  ],
                                ),
                                Spacer(),
                                _checkmembership ? _membershipSavings != "" ?
                                Container(
                                  height: 20,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(width: 3.0, color: ColorCodes.darkgreen),
                                    ),
                                    color: ColorCodes.varcolor,
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(width: 3,),
                                      Image.asset(
                                        Images.bottomnavMembershipImg,
                                        color: ColorCodes.primaryColor,
                                        width: 15,
                                        height: 10,),
                                      SizedBox(width: 2),
                                      Text(S.of(context).savings,style: TextStyle(fontSize: 8.5, color: ColorCodes.darkgreen,fontWeight: FontWeight.bold)),
                                      Padding(
                                        padding: const EdgeInsets.only(top:4.0,bottom: 3),
                                        child: Text(
                                            _membershipSavings,
                                            style: TextStyle(fontSize: 9, color: ColorCodes.darkgreen,fontWeight: FontWeight.bold)),
                                      ),


                                      SizedBox(width: 5),
                                    ],
                                  ),
                                ):SizedBox(height: 20,)
                                    :VxBuilder(
                                  mutations: {SetCartItem,ProductMutation},
                                  builder: (context, box, index) {
                                    return Column(
                                      children: [
                                        if(Features.isMembership && double.parse(widget._itemdata.priceVariation![Features.btobModule?_groupValue:itemindex].membershipPrice.toString()) > 0)
                                          Row(
                                            children: <Widget>[
                                              !_checkmembership
                                                  ? widget._itemdata.priceVariation![Features.btobModule?_groupValue:itemindex].membershipDisplay!
                                                  ? GestureDetector(
                                                onTap: () {
                                                  if(!PrefUtils.prefs!.containsKey("apikey")) {
                                                    if (kIsWeb && !ResponsiveLayout.isSmallScreen(
                                                        context)) {
                                                      LoginWeb(context, result: (sucsess) {
                                                        if (sucsess) {
                                                          Navigator.of(context).pop();
                                                          Navigation(context, navigatore: NavigatoreTyp.homenav);
                                                        } else {
                                                          Navigator.of(context).pop();
                                                        }
                                                      });
                                                    } else {
                                                      Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push);
                                                    }
                                                  }
                                                  else{
                                                    if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                                                    MembershipInfo(context);
                                                    }
                                                    else {
                                                      Navigation(context, name: Routename.Membership, navigatore: NavigatoreTyp.Push);
                                                    }

                                                  }
                                                },
                                                child: Container(
                                                  height: 19,
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      right: BorderSide(width: 3.0, color: ColorCodes.darkgreen),
                                                    ),
                                                    color: ColorCodes.varcolor,
                                                  ),
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(width: 3),
                                                      Image.asset(
                                                        Images.bottomnavMembershipImg,
                                                        color: ColorCodes.primaryColor,
                                                        width: 14,
                                                        height: 8,),
                                                      SizedBox(width: 2),
                                                      Text(
                                                        // S .of(context).membership_price+ " " +//"Membership Price "
                                                          S.of(context).price + " ",
                                                          style: TextStyle(fontSize: 8.0,color: ColorCodes.darkgreen,fontWeight: FontWeight.bold)),
                                                      Text(
                                                        // S .of(context).membership_price+ " " +//"Membership Price "
                                                          Features.iscurrencyformatalign?
                                                          widget._itemdata.priceVariation![Features.btobModule?_groupValue:itemindex].membershipPrice.toString() + IConstants.currencyFormat:
                                                          IConstants.currencyFormat +
                                                              widget._itemdata.priceVariation![Features.btobModule?_groupValue:itemindex].membershipPrice.toString(),
                                                          style: TextStyle(fontSize: 8.0, color: ColorCodes.darkgreen,fontWeight: FontWeight.bold)),

                                                      SizedBox(width: 5),
                                                    ],
                                                  ),
                                               
                                                ),
                                              )
                                                  : SizedBox.shrink()
                                                  : SizedBox.shrink(),
                                            ],
                                          ),
                                        !_checkmembership
                                            ? widget._itemdata.priceVariation![Features.btobModule?_groupValue:itemindex].membershipDisplay!
                                            ? SizedBox(
                                          height:( Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?0:1,
                                        )
                                            : SizedBox(
                                          height:( Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?0:1,
                                        )
                                            : SizedBox(
                                          height:( Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?0:1,
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height:4),
              Features.btobModule ?
              Padding(
                padding: const EdgeInsets.only(left: 8.0,right: 8.0,),
                child: Container(
                  height:40,
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text(S.of(context).total,style: TextStyle(color: ColorCodes.blackColor)),
                          productBox
                              .where((element) =>
                          element.itemId == widget._itemdata.id).length > 0?
                          Text( IConstants.currencyFormat + (double.parse(widget._itemdata.priceVariation![_groupValue].price!) * _count).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                            style: TextStyle(
                                color: ColorCodes.greenColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                            ),): Text( IConstants.currencyFormat + (double.parse(widget._itemdata.priceVariation![itemindex].price!)).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                            style: TextStyle(
                                color: ColorCodes.greenColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                            ),),

                        ],
                      ),
                      Container(
                        height:(Features.isSubscription)?40:40,
                        width: _checkmembership ? 180 : 110,
                        child: Padding(
                          padding: const EdgeInsets.only(left:10,right:5.0),
                          child: Features.btobModule?CustomeStepper(priceVariation:widget._itemdata.priceVariation![itemindex],itemdata: widget._itemdata,from:"item_screen",height: (Features.isSubscription)?90:40,issubscription: "Add",addon:(widget._itemdata.addon!.length > 0)?widget._itemdata.addon![0]:null, index: itemindex,groupvalue: _groupValue,onChange: (int value,int count){
                            setState(() {
                              _groupValue = value;
                              _count = count;
                            });
                          },):CustomeStepper(priceVariation:widget._itemdata.priceVariation![itemindex],itemdata: widget._itemdata,from:"item_screen",height: (Features.isSubscription)?90:40,issubscription: "Add",addon:(widget._itemdata.addon!.length > 0)?widget._itemdata.addon![0]:null, index: itemindex),
                        ),
                      ),
                    ],
                  ),
                ),
              ) :
              Padding(
                padding: const EdgeInsets.only(left: 5.0,right: 5.0),
                child: Container(
                  height:40,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height:(Features.isSubscription)?38:38,
                        width: Features.isShoppingList ? _checkmembership?155:140 : _checkmembership?188:173,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0,right: 5.0),
                          child: Features.btobModule?CustomeStepper(priceVariation:widget._itemdata.priceVariation![itemindex],itemdata: widget._itemdata,from:"item_screen",height: (Features.isSubscription)?90:40,issubscription: "Add",addon:(widget._itemdata.addon!.length > 0)?widget._itemdata.addon![0]:null, index: itemindex,groupvalue: _groupValue,onChange: (int value,int count){
                            setState(() {
                              _groupValue = value;
                              _count = count;
                            });
                          },):CustomeStepper(priceVariation:widget._itemdata.priceVariation![itemindex],itemdata: widget._itemdata,from:"item_screen",height: (Features.isSubscription)?90:40,issubscription: "Add",addon:(widget._itemdata.addon!.length > 0)?widget._itemdata.addon![0]:null, index: itemindex),
                        ),
                      ),
                      if(Features.isShoppingList)
                      SizedBox(width: 1,),
                      if(Features.isShoppingList)
                        VxBuilder(
                            mutations: {UserData},
                            builder: (context, box, _) {
                          return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              if(!PrefUtils.prefs!.containsKey("apikey")) {
                                (Vx.isWeb)?
                                LoginWeb(context,result: (sucsess){
                                  if(sucsess){
                                    Navigator.of(context).pop();
                                    HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
                                        PrefUtils.prefs!.getString("ftokenid"),
                                        branch: (VxState.store as GroceStore).userData.branch ?? "999",
                                        rows: "0");
                                    Navigation(context, navigatore: NavigatoreTyp.homenav);
                                    GoRouter.of(context).refresh();

                                  }else{
                                    Navigator.of(context).pop();
                                  }
                                })
                                :Navigation(context, name: Routename.SignUpScreen,
                                    navigatore: NavigatoreTyp.Push);
                              }
                              else {
                                 // final shoplistData = Provider.of<BrandItemsList>(context, listen: false);

                                  if (shoplistData.length <= 0) {
                                  _dialogforCreatelistTwo(context, shoplistData);
                                  } else {
                                  _dialogforShoppinglistTwo(context);
                                  }
                              }
                            },
                            child: Container(
                              height: 32,
                              padding: EdgeInsets.all(5),
                              decoration: new BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: ColorCodes.varcolor,
                                border: Border(
                                  right: BorderSide(width: 1.0, color: ColorCodes.varcolor,),
                                  left: BorderSide(width: 1.0, color: ColorCodes.varcolor,),
                                  bottom: BorderSide(width: 1.0, color: ColorCodes.varcolor),
                                  top: BorderSide(width: 1.0, color: ColorCodes.varcolor),
                                ),),
                              child: Image.asset(
                                  Images.addToListImg,width: 20,height: 20,color: ColorCodes.primaryColor),
                            ),
                          );
                        }
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}