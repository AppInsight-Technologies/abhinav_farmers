import 'dart:async';

import '../models/search_item_model.dart';
import '../repository/searchScreenRepo.dart';
import 'package:rxdart/rxdart.dart';

class SearchItemBlock {
  var _repository = SearchScreenRepo();
  final _serchItemsController = PublishSubject<List<SearchtemModel>>();
  final _serchItemsPricVarController = PublishSubject<List<PriceVariation1>>();
  final _serchItemsofController = PublishSubject<String>();
  final _searchiteidController = PublishSubject<String>();

  late List<PriceVariation1> itemlist;
  StreamSink<String> get searchiemsof =>_serchItemsofController.sink;
  Stream<List<SearchtemModel>> get serchItems => _serchItemsController.stream;
  Stream<List<PriceVariation1>> get serchItemspricevar => _serchItemsPricVarController.stream;
  StreamSink<List<PriceVariation1>> get serchItemspricevarsink => _serchItemsPricVarController.sink;

  searchItemsBloc() async {
    _serchItemsofController.stream.listen(_searchitem);
    // List<SellingItemsFields> itemModel = await _repository.searchItems(item_name);
  }
  searchItById(String ItemId,name) async {
    /*   searchiemsof.add(name);
    _serchItemsController.stream.listen((event) {
     for( SearchtemModel eve in event){
      itemlist = eve.priceVariation.where((element) => element.menuItemId == ItemId);

      _serchItemsPricVarController.sink.add(itemlist);
     }
      // event.where((element) => element.priceVariation.where((element) => element.menuItemId==ItemId));
    });*/

  }

  void _searchitem(String item_name) async{
    List<SearchtemModel> itemModel = await _repository.searchItems(item_name);
    _serchItemsController.sink.add(itemModel);
  }

  dispose(){
    _serchItemsController.close();
    _serchItemsofController.close();
    _serchItemsPricVarController.close();
  }


}
// final sbloc = SearchItemBlock();