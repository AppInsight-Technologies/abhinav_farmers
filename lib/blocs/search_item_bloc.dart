import 'dart:async';

import '../models/sellingitemsfields.dart';
import '../providers/itemslist.dart';
import 'package:rxdart/subjects.dart';

class SearchItemBloc{
  final ItemsList catlistrepository = ItemsList();
  final _serchItemsofController = PublishSubject<String>();
  final _serchsubItemsofController = PublishSubject<String>();
  final _categorytreamController = BehaviorSubject<List<SellingItemsFields>>();
  final _subcategorytreamController = BehaviorSubject<List<SellingItemsFields>>();
  // StreamSink<String> get searchiemsof =>_serchItemsofController.sink;
  set searchitemof(vale){
    _searchitem(vale);
  }
  StreamSink<String> get searchsubitemsof =>_serchsubItemsofController.sink;
  Stream< List<SellingItemsFields>> get serchitemstream => _categorytreamController.stream;
  StreamSink< List<SellingItemsFields>> get searchitemsink => _categorytreamController.sink;
  Stream< List<SellingItemsFields>> get serchsubitemstream => _subcategorytreamController.stream;
  StreamSink< List<SellingItemsFields>> get searchsubitemsink => _subcategorytreamController.sink;
  fetchsearchItems(item_name)async{

  }
  searchItemsBloc() async {
  /*  _serchItemsofController.stream.listen(_searchitem);
    _serchsubItemsofController.stream.listen((event) {
      catlistrepository.findByIdsearch(event);
    });*/
    // List<SellingItemsFields> itemModel = await _repository.searchItems(item_name);
  }
/*  findByIdsearch(String menuid){

  }*/

   _searchitem(String event) async{
     await catlistrepository.fetchsearchItems(event);
  }
}
final sbloc = SearchItemBloc();