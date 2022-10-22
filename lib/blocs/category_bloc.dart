import 'dart:async';

import '../models/categoriesfields.dart';
import '../providers/categoryitems.dart';
import 'package:rxdart/subjects.dart';

class CategoryBloc{
  final CategoriesItemsList catlistrepository = CategoriesItemsList();
  final _categorytreamController = BehaviorSubject<List<CategoriesFields>>();
  final _subcategorytreamController = BehaviorSubject<List<CategoriesFields>>();
  Stream< List<CategoriesFields>> get catblostream => _categorytreamController.stream;
  StreamSink< List<CategoriesFields>> get catitemsink => _categorytreamController.sink;
  Stream< List<CategoriesFields>> get subcatblostream => _subcategorytreamController.stream;
  StreamSink< List<CategoriesFields>> get subcatitemsink => _subcategorytreamController.sink;

  fetchCaegory()async{
    print("fetch category home bloc......");
    await catlistrepository.fetchCategory();
  }
dispose(){
  _subcategorytreamController.close();
}
}
final catbloc = CategoryBloc();