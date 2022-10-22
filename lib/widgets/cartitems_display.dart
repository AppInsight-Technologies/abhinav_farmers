import '../../controller/mutations/cat_and_product_mutation.dart';

import '../../constants/features.dart';
import '../../controller/mutations/cart_mutation.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/cartModle.dart';
import 'package:velocity_x/velocity_x.dart';
import '../assets/ColorCodes.dart';
import '../generated/l10n.dart';
import '../constants/IConstants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../assets/images.dart';
import '../utils/ResponsiveLayout.dart';
import '../utils/prefUtils.dart';

class CartitemsDisplay extends StatefulWidget {

  Function? isdbonprocess ;
  var onempty;
  CartItem snapshot;

  CartitemsDisplay(this.snapshot,
      {this.onempty});

  @override
  _CartitemsDisplayState createState() => _CartitemsDisplayState();
}

class _CartitemsDisplayState extends State<CartitemsDisplay> {
  bool _isAddToCart = false;
  var checkmembership = false;
  String _itemPrice = "";
  bool _checkMembership = false;
  bool _isLoading = true;
  bool iphonex = false;
  bool _isaddOn = false;
  List<CartItem> productBox=[];

  @override
  void initState() {
    productBox = (VxState.store as GroceStore).CartItemList;
    Future.delayed(Duration.zero, () async {
      if(widget.snapshot.addOn.toString() == "0"){
        _isaddOn = true;
      }
      else{
        _isaddOn = false;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if (!_isLoading)
      if ((VxState.store as GroceStore).userData.membership == "1") {
        _checkMembership = true;
      } else {
        _checkMembership = false;
      }
    for (int i = 0; i < (VxState.store as GroceStore).CartItemList.length; i++) {
      if ((VxState.store as GroceStore).CartItemList[i].mode == "1") {
        _checkMembership = true;
      }
    }
    if (VxState.store.userData.membership! == "1" || _checkMembership) {
      if(widget.snapshot.toppings_data!.length > 0){
        double itemtotal = 0;
        for(int i = 0 ;i < widget.snapshot.toppings_data!.length;i++) {
          if (widget.snapshot.membershipPrice == '-' ||
              widget.snapshot.membershipPrice == "0") {
            if (double.parse(widget.snapshot.price!) <= 0 ||
                widget.snapshot.price.toString() == "") {
              itemtotal = itemtotal + double.parse(widget.snapshot.toppings_data![i].price!);
              _itemPrice = (double.parse(widget.snapshot.varMrp!)+itemtotal).toString();
            } else {
              itemtotal = itemtotal + double.parse(widget.snapshot.toppings_data![i].price!);
              _itemPrice = (double.parse(widget.snapshot.price!)+itemtotal).toString();
            }
          } else {
            itemtotal = itemtotal + double.parse(widget.snapshot.toppings_data![i].price!);
            _itemPrice = (double.parse(widget.snapshot.membershipPrice!)+itemtotal).toString();
          }
        }
      }
      else {
        if (widget.snapshot.membershipPrice == '-' ||
            widget.snapshot.membershipPrice == "0") {
          if (double.parse(widget.snapshot.price!) <= 0 ||
              widget.snapshot.price.toString() == "") {
            _itemPrice = widget.snapshot.varMrp!;
          } else {
            _itemPrice = widget.snapshot.price!;
          }
        } else {
          _itemPrice = widget.snapshot.membershipPrice!;
        }
      }
    }
    else {
      if(widget.snapshot.toppings_data!.length > 0){
        double itemtotal = 0;
        for(int i = 0 ;i < widget.snapshot.toppings_data!.length;i++) {
          if (double.parse(widget.snapshot.price!) <= 0 ||
              widget.snapshot.price.toString() == "") {
            itemtotal = itemtotal + double.parse(widget.snapshot.toppings_data![i].price!);
            _itemPrice = (double.parse(widget.snapshot.varMrp!)+itemtotal).toString();
          } else {
            itemtotal = itemtotal + double.parse(widget.snapshot.toppings_data![i].price!);
            _itemPrice = (double.parse(widget.snapshot.price!)+itemtotal).toString();
          }
        }
      }
      else {
        if (double.parse(widget.snapshot.price!) <= 0 ||
            widget.snapshot.price.toString() == "") {
          _itemPrice = widget.snapshot.varMrp!;
        } else {
          _itemPrice = widget.snapshot.price!;
        }
      }
    }

    updateCart(int qty,double weight,CartStatus cart,String varid,String increment){
      switch(cart){
        case CartStatus.increment:
          cartcontroller.update((done){
            setState(() {
              _isAddToCart = !done;
            });
          },price: widget.snapshot.price.toString(),
            quantity:widget.snapshot.type=="1"?"1":( qty+1).toString(),
            type: widget.snapshot.type,
            weight:widget.snapshot.type=="1"?(weight+double.parse(widget.snapshot.increment!)).toString():"1",
            var_id: varid,
            increament: increment,
            cart_id: widget.snapshot.parent_id.toString(),
            toppings: "",
            topping_id: "",
            item_id: widget.snapshot.itemId.toString(),);

          // TODO: Handle this case.
          break;
        case CartStatus.remove:
          cartcontroller.update((done){
            setState(() {
              _isAddToCart = !done;
            });
          },price: widget.snapshot.price.toString(),quantity:"0",
            type: widget.snapshot.type,
            weight:"0",var_id: varid,increament: increment,cart_id: widget.snapshot.parent_id.toString(),toppings: "",
            topping_id: "", item_id: '',);
          // TODO: Handle this case.
          break;
        case CartStatus.decrement:
          cartcontroller.update((done){
            setState(() {
              _isAddToCart = !done;
            });
          },price: widget.snapshot.price.toString(),
            quantity:widget.snapshot.type=="1"?((weight)<= (double.parse(widget.snapshot.varMinItem!)*double.parse(widget.snapshot.increment!)))?"0":qty.toString():((qty)<= int.parse(widget.snapshot.varMinItem!))?"0":(qty-1).toString(),
            type: widget.snapshot.type,
            weight:widget.snapshot.type=="1"? ((weight)<= (double.parse(widget.snapshot.varMinItem!)*double.parse(widget.snapshot.increment!)))?"0":(weight-double.parse(widget.snapshot.increment!)).toString():"0",
            var_id: varid,increament: increment,cart_id: widget.snapshot.parent_id.toString(),toppings: "",
            topping_id: "",
            item_id: widget.snapshot.itemId.toString(),);
          // TODO: Handle this case.
          break;
      }
    }
    return
      //_isaddOn?
      Container(
        // color: Colors.white,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: (Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))? BorderRadius.circular(5) : BorderRadius.circular(12)
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10),
          child: Row(
            children: <Widget>[
              (widget.snapshot.mode == "1")?
              // SizedBox.shrink() ?
              Image.asset(Images.cartmembershipImage,
                  width:100,
                  height:100
              )
                  :
              Container(
                width: 100,
                height: 100,
                child: FadeInImage(
                  image: NetworkImage(widget.snapshot.itemImage??""),
                  placeholder: AssetImage(
                    Images.defaultProductImg,
                  ),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //SizedBox(height: 10,),
                        // if(widget.snapshot.mode != "1")
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.snapshot.itemName!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ),
                            (widget.snapshot.mode == "3")? SizedBox.shrink() :GestureDetector(
                                onTap: (){
                                  // cartBloc.cartItems();
                                  updateCart(int.parse(widget.snapshot.quantity!),double.parse(widget.snapshot.weight!), CartStatus.remove, widget.snapshot.varId.toString(),widget.snapshot.increment.toString());
                                  if(widget.snapshot.mode == "1"){
                                    PrefUtils.prefs!.setString("memberback", "no");
                                  }else{
                                    PrefUtils.prefs!.setString("memberback", "");
                                  }
                                },
                                child:Image.asset(
                                  Images.Delete,
                                  height: 22.0,
                                  color: IConstants.isEnterprise?ColorCodes.primaryColor:ColorCodes.emailColor,
                                )),
                            SizedBox(
                              width: 10,
                            )
                          ],
                        ),
                        if(widget.snapshot.mode != "1")
                        SizedBox(
                          height: 5,
                        ),
                        if(widget.snapshot.mode != "1")
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                                  widget.snapshot.varName!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: ColorCodes.greyColor),
                                )),
                            SizedBox(
                              width: 10,
                            )
                          ],
                        ),
                        if(widget.snapshot.mode != "1")
                        SizedBox(
                          height: 10,
                        ),
                        if(widget.snapshot.mode != "1")
                        VxBuilder(
                            mutations: {ProductMutation,SetCartItem},
                            builder: (context, box, _) {
                              if (VxState.store.userData.membership! == "1") {
                                _checkMembership = true;
                              } else {
                                _checkMembership = false;
                                for (int i = 0; i < productBox.length; i++) {
                                  if (productBox[i].mode == "1") {
                                    _checkMembership = true;
                                  }
                                }
                              }
                              if (VxState.store.userData.membership! == "1" || _checkMembership) {
                                if(widget.snapshot.toppings_data!.length > 0){
                                  double itemtotal = 0;
                                  for(int i = 0 ;i < widget.snapshot.toppings_data!.length;i++) {
                                    if (widget.snapshot.membershipPrice == '-' ||
                                        double.parse(widget.snapshot.membershipPrice.toString()).toStringAsFixed(0) == "0") {
                                      if (double.parse(widget.snapshot.price!) <= 0 ||
                                          widget.snapshot.price.toString() == "") {
                                        itemtotal = itemtotal + double.parse(widget.snapshot.toppings_data![i].price!);
                                        _itemPrice = (double.parse(widget.snapshot.varMrp!)+itemtotal).toString();
                                      } else {
                                        itemtotal = itemtotal + double.parse(widget.snapshot.toppings_data![i].price!);
                                        _itemPrice = (double.parse(widget.snapshot.price!)+itemtotal).toString();
                                      }
                                    } else {
                                      itemtotal = itemtotal + double.parse(widget.snapshot.toppings_data![i].price!);
                                      _itemPrice = (double.parse(widget.snapshot.membershipPrice!)+itemtotal).toString();
                                    }
                                  }
                                }
                                else {
                                  if (widget.snapshot.membershipPrice == '-' ||
                                      double.parse(widget.snapshot.membershipPrice.toString()).toStringAsFixed(0) == "0") {
                                    if (double.parse(widget.snapshot.price!) <= 0 ||
                                        widget.snapshot.price.toString() == "") {
                                      _itemPrice = widget.snapshot.varMrp!;
                                    } else {
                                      _itemPrice = widget.snapshot.price!;
                                    }
                                  } else {
                                    _itemPrice = widget.snapshot.membershipPrice!;
                                  }
                                }
                              }
                              else {
                                if(widget.snapshot.toppings_data!.length > 0){
                                  double itemtotal = 0;
                                  for(int i = 0 ;i < widget.snapshot.toppings_data!.length;i++) {
                                    if (double.parse(widget.snapshot.price!) <= 0 ||
                                        widget.snapshot.price.toString() == "") {
                                      itemtotal = itemtotal + double.parse(widget.snapshot.toppings_data![i].price!);
                                      _itemPrice = (double.parse(widget.snapshot.varMrp!)+itemtotal).toString();
                                    } else {
                                      itemtotal = itemtotal + double.parse(widget.snapshot.toppings_data![i].price!);
                                      _itemPrice = (double.parse(widget.snapshot.price!)+itemtotal).toString();
                                    }
                                  }
                                }
                                else {
                                  if (double.parse(widget.snapshot.price!) <= 0 ||
                                      widget.snapshot.price.toString() == "") {
                                    _itemPrice = widget.snapshot.varMrp!;
                                  } else {
                                    _itemPrice = widget.snapshot.price!;
                                  }
                                }

                              }

                              return Row(
                                children: [
                                  if(widget.snapshot.mode != "3")
                                    (widget.snapshot.type=="1")?  Text((double.parse(widget.snapshot.quantity!) == 0 || widget.snapshot.status.toString() == "0") ?
                                    Features.iscurrencyformatalign?
                                    IConstants.numberFormat == "1"?' ' + (double.parse(_itemPrice)*(double.parse(widget.snapshot.weight!))).toStringAsFixed(0)  + ' ' + IConstants.currencyFormat:
                                    ' ' + (double.parse(_itemPrice)*(double.parse(widget.snapshot.weight!))).toStringAsFixed(IConstants.decimaldigit)  + ' ' + IConstants.currencyFormat:
                                    IConstants.numberFormat == "1"?IConstants.currencyFormat + ' ' + ' ' + (double.parse(_itemPrice)*(double.parse(widget.snapshot.weight!))).toStringAsFixed(0):
                                    IConstants.currencyFormat + ' ' + ' ' + (double.parse(_itemPrice)*(double.parse(widget.snapshot.weight!))).toStringAsFixed(IConstants.decimaldigit)
                                        :
                                    Features.iscurrencyformatalign?
                                    IConstants.numberFormat == "1"?' ' + (double.parse(_itemPrice)*(double.parse(widget.snapshot.weight!))).toStringAsFixed(0) + ' ' + IConstants.currencyFormat:' ' + (double.parse(_itemPrice)*(double.parse(widget.snapshot.weight!))).toStringAsFixed(IConstants.decimaldigit)  + ' ' +  IConstants.currencyFormat:
                                    IConstants.numberFormat == "1"?IConstants.currencyFormat + ' ' + ' ' + (double.parse(_itemPrice)*(double.parse(widget.snapshot.weight!))).toStringAsFixed(0):IConstants.currencyFormat + ' ' + ' ' + (double.parse(_itemPrice)*(double.parse(widget.snapshot.weight!))).toStringAsFixed(IConstants.decimaldigit),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600, fontSize: 14)):
                                    Text((double.parse(widget.snapshot.quantity!) == 0 || widget.snapshot.status.toString() == "0") ?
                                    Features.iscurrencyformatalign?
                                    IConstants.numberFormat == "1"?' ' + (double.parse(_itemPrice)*(double.parse(widget.snapshot.quantity!))).toStringAsFixed(0)  + ' ' + IConstants.currencyFormat:
                                    ' ' + (double.parse(_itemPrice)*(double.parse(widget.snapshot.quantity!))).toStringAsFixed(IConstants.decimaldigit)  + ' ' + IConstants.currencyFormat:
                                    IConstants.numberFormat == "1"?IConstants.currencyFormat + ' ' + ' ' + (double.parse(_itemPrice)*(double.parse(widget.snapshot.quantity!))).toStringAsFixed(0):
                                    IConstants.currencyFormat + ' ' + ' ' + (double.parse(_itemPrice)*(double.parse(widget.snapshot.quantity!))).toStringAsFixed(IConstants.decimaldigit)
                                        :
                                    Features.iscurrencyformatalign?
                                    IConstants.numberFormat == "1"?' ' + (double.parse(_itemPrice)*(double.parse(widget.snapshot.quantity!))).toStringAsFixed(0) + ' ' + IConstants.currencyFormat:' ' + (double.parse(_itemPrice)*(double.parse(widget.snapshot.quantity!))).toStringAsFixed(IConstants.decimaldigit)  + ' ' +  IConstants.currencyFormat:
                                    IConstants.numberFormat == "1"?IConstants.currencyFormat + ' ' + ' ' + (double.parse(_itemPrice)*(double.parse(widget.snapshot.quantity!))).toStringAsFixed(0):IConstants.currencyFormat + ' ' + ' ' + (double.parse(_itemPrice)*(double.parse(widget.snapshot.quantity!))).toStringAsFixed(IConstants.decimaldigit),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600, fontSize: 14)),
                                  Spacer(),

                                  // SizedBox(
                                  //   width: 5,
                                  // ),
                                  (double.parse(widget.snapshot.varStock!) == 0 || widget.snapshot.status == "1") ? Container(
                                    height:30,
                                    decoration:BoxDecoration(
                                      border: Border.all(
                                        color: widget.snapshot.status == "1"?ColorCodes.lightgrey:ColorCodes.badgecolor,
                                      ),
                                 // borderRadius: BorderRadius.circular(5),
                              ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left:8.0,right:8,top:5),
                                      child: Text(
                                        double.parse(widget.snapshot.varStock!) == 0 ? S .of(context).out_of_stock/*"Out Of Stock"*/ : S .of(context).unavailable,/*"Unavailable"*/
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: widget.snapshot.status == "1"?ColorCodes.lightgrey:ColorCodes.badgecolor),
                                      ),
                                    ),
                                  )
                                      :
                                  VxBuilder(builder: (context, store,state){
                                    final box = store.CartItemList;
                                    if(box.isNotEmpty){
                                      if(box.isNotEmpty){

                                        return widget.snapshot.type=="1"?Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: ColorCodes.varcolor),
                                            borderRadius: BorderRadius.circular(3),
                                          ),
                                          child: Row(
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () async {
                                                  if(widget.snapshot.mode == "3"){

                                                  }else {
                                                    if (int.parse(
                                                        widget.snapshot.quantity!) <=
                                                        int.parse(widget.snapshot
                                                            .varMinItem!)) {
                                                      setState(() {
                                                        updateCart(int.parse(
                                                            widget.snapshot
                                                                .quantity!),
                                                            double.parse(
                                                                widget.snapshot
                                                                    .weight!),
                                                            CartStatus.decrement,
                                                            widget.snapshot.varId
                                                                .toString(),
                                                            widget.snapshot.increment
                                                                .toString());
                                                      });
                                                    } else {
                                                      setState(() {
                                                        updateCart(int.parse(
                                                            widget.snapshot
                                                                .quantity!),
                                                            double.parse(
                                                                widget.snapshot
                                                                    .weight!),
                                                            CartStatus.decrement,
                                                            widget.snapshot.varId
                                                                .toString(),
                                                            widget.snapshot.increment
                                                                .toString());
                                                      });
                                                    }
                                                    if (widget.snapshot.mode == "1") {
                                                      PrefUtils.prefs!.setString(
                                                          "memberback", "no");
                                                    } else {
                                                      PrefUtils.prefs!.setString(
                                                          "memberback", "");
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                      color: /*IConstants.isEnterprise?ColorCodes.whiteColor:*/ColorCodes.whiteColor,
                                                    /*  border: Border(
                                                        top: BorderSide(
                                                            width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                                                        bottom: BorderSide(
                                                            width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                                                        left: BorderSide(
                                                            width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                                                      ),*/
                                                    ),
                                                    width: 25,
                                                    height: 30,
                                                    child: Center(
                                                      child: Text(
                                                        "-",
                                                        textAlign: TextAlign.center,
                                                        style:
                                                        TextStyle(color: ColorCodes.greyColor,
                                                          fontSize: 20,),
                                                      ),
                                                    )),
                                              ),
                                              _isAddToCart ?
                                              Container(
                                                width: 35,
                                                height: 25,
                                                padding: EdgeInsets.only(left: 7.5, top: 2.5, right: 7.5, bottom: 2.5),
                                                child: SizedBox(
                                                    width: 20.0,
                                                    height: 20.0,
                                                    child: new CircularProgressIndicator(
                                                      strokeWidth: 2.0,
                                                      valueColor: new AlwaysStoppedAnimation<Color>(IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome),)),
                                              )
                                                  :
                                              Container(
                                                  width: 55,
                                                  height: 30,
                                               /*   decoration: BoxDecoration(
                                                    border: Border(
                                                      top: BorderSide(
                                                          width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                                                      bottom: BorderSide(
                                                          width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                                                      left: BorderSide(
                                                          width: 1.0, color: IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.maphome),
                                                      right: BorderSide(
                                                          width: 1.0, color: IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.maphome),
                                                    ),
                                                  ),*/
                                                  // decoration: BoxDecoration(color: Colors.green,border: Border.),
                                                  child: Center(
                                                    child: Text(
                                                      widget.snapshot.weight.toString()+" "+widget.snapshot.unit.toString(),
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        color: Theme.of(context).primaryColor,
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                  )),
                                              GestureDetector(
                                                onTap: () {
                                                  if(widget.snapshot.mode == "3"){

                                                  }else {
                                                    if (double.parse(
                                                        widget.snapshot.weight!) <
                                                        double.parse(widget.snapshot
                                                            .varStock!)) {
                                                      if (double.parse(
                                                          widget.snapshot.weight!) <
                                                          (double.parse(
                                                              widget.snapshot
                                                                  .varMaxItem!) *
                                                              double.parse(
                                                                  widget.snapshot
                                                                      .increment!))) {
                                                        updateCart(int.parse(
                                                            widget.snapshot
                                                                .quantity!),
                                                            double.parse(
                                                                widget.snapshot
                                                                    .weight!),
                                                            CartStatus.increment,
                                                            widget.snapshot.itemId!,
                                                            widget.snapshot.increment
                                                                .toString());
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                            S
                                                                .of(context)
                                                                .cant_add_more_item,
                                                            //"Sorry, you can\'t add more of this item!",
                                                            fontSize: MediaQuery
                                                                .of(context)
                                                                .textScaleFactor * 13,
                                                            backgroundColor: Colors
                                                                .black87,
                                                            textColor: Colors.white);
                                                      }
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg: S
                                                              .of(context)
                                                              .sorry_outofstock,
                                                          //"Sorry, Out of Stock!",
                                                          fontSize: MediaQuery
                                                              .of(context)
                                                              .textScaleFactor * 13,
                                                          backgroundColor: Colors
                                                              .black87,
                                                          textColor: Colors.white);
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                    width: 25,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      color: /*IConstants.isEnterprise?ColorCodes.whiteColor:*/ColorCodes.whiteColor,
                                                     /* border: Border(
                                                        top: BorderSide(
                                                            width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                                                        bottom: BorderSide(
                                                            width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                                                        right: BorderSide(
                                                            width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                                                      ),*/
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "+",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: IConstants.isEnterprise?ColorCodes.primaryColor:ColorCodes.liteColor,
                                                          fontSize: 20,
                                                          //color: Theme.of(context).buttonColor,
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ):Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: ColorCodes.varcolor),
                                              borderRadius: BorderRadius.circular(3),
                                          ),
                                          child: Row(
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () async {
                                                  if(widget.snapshot.mode == "3"){

                                                  }else {
                                                    if (int.parse(
                                                        widget.snapshot.quantity!) <=
                                                        int.parse(widget.snapshot
                                                            .varMinItem!)) {
                                                      setState(() {
                                                        updateCart(int.parse(
                                                            widget.snapshot
                                                                .quantity!),
                                                            double.parse(
                                                                widget.snapshot
                                                                    .weight!),
                                                            CartStatus.decrement,
                                                            widget.snapshot.varId
                                                                .toString(),
                                                            widget.snapshot.increment
                                                                .toString());
                                                      });
                                                    } else {
                                                      setState(() {
                                                        updateCart(int.parse(
                                                            widget.snapshot
                                                                .quantity!),
                                                            double.parse(
                                                                widget.snapshot
                                                                    .weight!),
                                                            CartStatus.decrement,
                                                            widget.snapshot.varId
                                                                .toString(),
                                                            widget.snapshot.increment
                                                                .toString());
                                                      });
                                                    }
                                                    if (widget.snapshot.mode == "1") {
                                                      PrefUtils.prefs!.setString(
                                                          "memberback", "no");
                                                    } else {
                                                      PrefUtils.prefs!.setString(
                                                          "memberback", "");
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                      color: /*IConstants.isEnterprise?ColorCodes.whiteColor:*/ColorCodes.whiteColor,
                                                      // border: Border(
                                                      //   top: BorderSide(
                                                      //       width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.stepperColor),
                                                      //   bottom: BorderSide(
                                                      //       width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.stepperColor),
                                                      //   left: BorderSide(
                                                      //       width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.stepperColor),
                                                      // ),
                                                    ),
                                                    width: 30,
                                                    height: 30,
                                                    child: Center(
                                                      child: Text(
                                                        "-",
                                                        textAlign: TextAlign.center,
                                                        style:
                                                        TextStyle(color: ColorCodes.greyColor,
                                                          fontSize: 20,),
                                                      ),
                                                    )),
                                              ),
                                              _isAddToCart ?
                                              Container(
                                                width: 35,
                                                height: 25,
                                                padding: EdgeInsets.only(left: 7.5, top: 2.5, right: 7.5, bottom: 2.5),
                                                child: SizedBox(
                                                    width: 20.0,
                                                    height: 20.0,
                                                    child: new CircularProgressIndicator(
                                                      strokeWidth: 2.0,
                                                      valueColor: new AlwaysStoppedAnimation<Color>(IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.stepperColor),)),
                                              )
                                                  :
                                              Container(
                                                  width: 35,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    // border: Border(
                                                    //   top: BorderSide(
                                                    //       width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.stepperColor),
                                                    //   bottom: BorderSide(
                                                    //       width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.stepperColor),
                                                    //   left: BorderSide(
                                                    //       width: 1.0, color: IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.stepperColor),
                                                    //   right: BorderSide(
                                                    //       width: 1.0, color: IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.stepperColor),
                                                    // ),
                                                  ),
                                                  // decoration: BoxDecoration(color: Colors.green,border: Border.),
                                                  child: Center(
                                                    child: Text(
                                                      widget.snapshot.quantity.toString(),
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        color: Theme.of(context).primaryColor,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  )),
                                              GestureDetector(
                                                onTap: () {
                                                  if(widget.snapshot.mode == "3"){

                                                  }else {
                                                    if (double.parse(
                                                        widget.snapshot.quantity!) <
                                                        double.parse(widget.snapshot
                                                            .varStock!)) {
                                                      if (double.parse(
                                                          widget.snapshot.quantity!) <
                                                          int.parse(widget.snapshot
                                                              .varMaxItem!)) {
                                                        updateCart(int.parse(
                                                            widget.snapshot
                                                                .quantity!),
                                                            double.parse(
                                                                widget.snapshot
                                                                    .weight!),
                                                            CartStatus.increment,
                                                            widget.snapshot.varId!,
                                                            widget.snapshot.increment
                                                                .toString());
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                            S
                                                                .of(context)
                                                                .cant_add_more_item,
                                                            //"Sorry, you can\'t add more of this item!",
                                                            fontSize: MediaQuery
                                                                .of(context)
                                                                .textScaleFactor * 13,
                                                            backgroundColor: Colors
                                                                .black87,
                                                            textColor: Colors.white);
                                                      }
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg: S
                                                              .of(context)
                                                              .sorry_outofstock,
                                                          //"Sorry, Out of Stock!",
                                                          fontSize: MediaQuery
                                                              .of(context)
                                                              .textScaleFactor * 13,
                                                          backgroundColor: Colors
                                                              .black87,
                                                          textColor: Colors.white);
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                    width: 30,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      color: /*IConstants.isEnterprise?ColorCodes.whiteColor:*/ColorCodes.whiteColor,
                                                      // border: Border(
                                                      //   top: BorderSide(
                                                      //       width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.stepperColor),
                                                      //   bottom: BorderSide(
                                                      //       width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.stepperColor),
                                                      //   right: BorderSide(
                                                      //       width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.stepperColor),
                                                      // ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "+",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                            color:IConstants.isEnterprise?ColorCodes.primaryColor:ColorCodes.liteColor,
                                                          //color: Theme.of(context).buttonColor,
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        );
                                      }else{
                                        widget.onempty;
                                        return Row(
                                          children: <Widget>[
                                            Container(
                                                decoration: BoxDecoration(
                                                  color: IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.stepperColor,
                                                  border: Border(
                                                    top: BorderSide(
                                                        width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.stepperColor),
                                                    bottom: BorderSide(
                                                        width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.stepperColor),
                                                    left: BorderSide(
                                                        width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.stepperColor),
                                                  ),
                                                ),
                                                width: 30,
                                                height: 25,
                                                child: Center(
                                                  child: Text(
                                                    "-",
                                                    textAlign: TextAlign.center,
                                                    style:
                                                    TextStyle(color: ColorCodes.greyColor,
                                                      fontSize: 20,),
                                                  ),
                                                )),
                                            Container(
                                              width: 35,
                                              height: 25,
                                              padding: EdgeInsets.only(left: 7.5, top: 2.5, right: 7.5, bottom: 2.5),
                                              child: SizedBox(
                                                  width: 20.0,
                                                  height: 20.0,
                                                  child: new CircularProgressIndicator(
                                                    strokeWidth: 2.0,
                                                    valueColor: new AlwaysStoppedAnimation<Color>(IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.stepperColor),)),
                                            ),
                                            Container(
                                                width: 30,
                                                height: 25,
                                                decoration: BoxDecoration(
                                                  color: IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.stepperColor,
                                                  border: Border(
                                                    top: BorderSide(
                                                        width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.stepperColor),
                                                    bottom: BorderSide(
                                                        width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.stepperColor),
                                                    right: BorderSide(
                                                        width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.stepperColor),
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "+",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: ColorCodes.primaryColor,
                                                      fontSize: 20,
                                                      //color: Theme.of(context).buttonColor,
                                                    ),
                                                  ),
                                                )),
                                          ],
                                        );
                                      }
                                    }else if(box.isEmpty){
                                      widget.onempty;
                                      return Row(
                                        children: <Widget>[
                                          Container(
                                              decoration: BoxDecoration(
                                                color: IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.stepperColor,
                                                border: Border(
                                                  top: BorderSide(
                                                      width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.stepperColor),
                                                  bottom: BorderSide(
                                                      width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.stepperColor),
                                                  left: BorderSide(
                                                      width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.stepperColor),
                                                ),
                                              ),
                                              width: 30,
                                              height: 25,
                                              child: Center(
                                                child: Text(
                                                  "-",
                                                  textAlign: TextAlign.center,
                                                  style:
                                                  TextStyle(color: ColorCodes.greyColor,
                                                    fontSize: 20,),
                                                ),
                                              )),
                                          Container(
                                            width: 35,
                                            height: 25,
                                            padding: EdgeInsets.only(left: 7.5, top: 2.5, right: 7.5, bottom: 2.5),
                                            child: SizedBox(
                                                width: 20.0,
                                                height: 20.0,
                                                child: new CircularProgressIndicator(
                                                  strokeWidth: 2.0,
                                                  valueColor: new AlwaysStoppedAnimation<Color>(IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.stepperColor),)),
                                          ),
                                          Container(
                                              width: 30,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                color: IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.stepperColor,
                                                border: Border(
                                                  top: BorderSide(
                                                      width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.stepperColor),
                                                  bottom: BorderSide(
                                                      width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.stepperColor),
                                                  right: BorderSide(
                                                      width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.stepperColor),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "+",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: ColorCodes.primaryColor,
                                                    fontSize: 20,
                                                    //color: Theme.of(context).buttonColor,
                                                  ),
                                                ),
                                              )),
                                        ],
                                      );
                                    }else {
                                      Future.delayed(Duration.zero).then((value) => widget.onempty);
                                      return Row(
                                        children: <Widget>[
                                          Container(
                                              decoration: BoxDecoration(
                                                color: IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.stepperColor,
                                                border: Border(
                                                  top: BorderSide(
                                                      width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.stepperColor),
                                                  bottom: BorderSide(
                                                      width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.stepperColor),
                                                  left: BorderSide(
                                                      width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.stepperColor),
                                                ),
                                              ),
                                              width: 30,
                                              height: 25,
                                              child: Center(
                                                child: Text(
                                                  "-",
                                                  textAlign: TextAlign.center,
                                                  style:
                                                  TextStyle(color: ColorCodes.greyColor,
                                                    fontSize: 20,),
                                                ),
                                              )),
                                          Container(
                                            width: 35,
                                            height: 25,
                                            padding: EdgeInsets.only(left: 7.5, top: 2.5, right: 7.5, bottom: 2.5),
                                            child: SizedBox(
                                                width: 20.0,
                                                height: 20.0,
                                                child: new CircularProgressIndicator(
                                                  strokeWidth: 2.0,
                                                  valueColor: new AlwaysStoppedAnimation<Color>(IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.stepperColor),)),
                                          ),
                                          Container(
                                              width: 30,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                color: IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.stepperColor,
                                                border: Border(
                                                  top: BorderSide(
                                                      width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.stepperColor),
                                                  bottom: BorderSide(
                                                      width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.stepperColor),
                                                  right: BorderSide(
                                                      width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.stepperColor),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "+",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: ColorCodes.primaryColor,
                                                    fontSize: 20,
                                                    //color: Theme.of(context).buttonColor,
                                                  ),
                                                ),
                                              )),
                                        ],
                                      );
                                    }
                                  }, mutations: {SetCartItem}),
                                  SizedBox(
                                    width: 10,
                                  )
                                ],
                              );
                            }
                        ),
                        (widget.snapshot.mode == "3")?
                        Text(
                          S.of(context).free_product,//"Free Product",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: ColorCodes.redColor),
                        )
                            :SizedBox.shrink(),
                        (widget.snapshot.toppings_data!.length > 0)?
                        ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: widget.snapshot.toppings_data!.length,
                            itemBuilder: (_, i) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text( widget.snapshot.toppings_data![i].name!, style: TextStyle(fontSize: 12,
                                        color: ColorCodes.greyColor,
                                        fontWeight: FontWeight.normal),),
                                    SizedBox(height: 3,)
                                  ],
                                ),
                              );
                            }):
                        SizedBox.shrink(),

                      ])),
            ],
          ),
        ),
      );
    //:SizedBox.shrink();
  }
}