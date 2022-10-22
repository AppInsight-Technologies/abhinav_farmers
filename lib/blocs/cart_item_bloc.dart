import 'dart:async';

import '../models/cartItemsField.dart';
import '../providers/cartItems.dart';
import 'package:rxdart/rxdart.dart';

class CartItemBloc{
  final CartItems _cartItems = CartItems();
  final _cartitems = CartItems();
  final _cartStreamController = BehaviorSubject<List<CartItemsFields>>();
  final _cartItemController = BehaviorSubject<List<CartItemsFields>>();
  final _iscarthavedateController = BehaviorSubject<bool>();

  bool isempty = false;

  Stream< List<CartItemsFields>> get cartblostream => _cartStreamController.stream;
  StreamSink< List<CartItemsFields>> get cartitemsink => _cartStreamController.sink;
  StreamSink<bool> get iscartshow => _iscarthavedateController.sink;
  Stream<bool> get iscartshowStream => _iscarthavedateController.stream;
  Cartbloc() async{

    await _cartItems.fetchCartItems();
    // _cartItems.fetchCartItems().whenComplete(() => _cartStreamController.sink.addStream(_cartItems.cartitemstream));
/*    cartitemrepo.cartitemstream.listen((event) {

    });*/

    /* _cartStreamController.stream.listen((event) async{
    });*/
  }
  StreamSink<List<CartItemsFields>> get cartitemSink =>_cartItemController.sink;
  Stream<List<CartItemsFields>> get cartitemStream => _cartItemController.stream;
  cartItems()async{
    await _cartitems.fetchCartItems();
  }
  /* dispose(){
    _cartStreamController.close();
    // cartitemrepo.dispose();
  }*/
  Future<bool> iscartNotEmpty() {
    iscartshow.add(false);
    _iscarthavedateController.stream.listen((event) {
      isempty = event;
    });
    return Future.value(isempty);
  }
}
final cartBloc =CartItemBloc();