import 'dart:async';

import '../models/SellingItemsModle.dart';
import '../models/brandFiledModel.dart';
import '../models/categoriesModel.dart';
import '../models/sellingitemsfields.dart';
import '../providers/branditems.dart';
import '../providers/categoryProvider.dart';
import '../providers/sellingitems.dart';

import '../models/brandfieldsModel.dart';
import '../providers/carouselProvider.dart';

class HomeRepository {
  final sliderbanner = CarouselItems();
  final categories = CategoryProvider();
  final branditems = BrandItemsList();
  final sellingitem = SellingItemsList();
  final _discountItemController = StreamController<List<SellingItemsFields>>();
  final _featuredItemsController = StreamController<List<SellingItemsFields>>();

  Future<List<BrandsFields>> fetchBanner() => sliderbanner.fetchBanner();

  Future<List<CategoriesModel>> fetchCategoryOne() => categories.fetchCategoryOne();

  Future<List<BrandsFields>> fetchAdvertisecategory1() => sliderbanner.fetchadvertisecategory1();

  Future<List<BrandsFields>> fetchAdvertisecategory2() => sliderbanner.fetchAdvertisecategory2();

  Future<List<CategoriesModel>> fetchCategoryTwo() => categories.fetchCategoryTwo();

  Future<List<CategoriesModel>> fetchCategoryThree() => categories.fetchCategoryThree();

  Future<List<BrandsFieldModel>> fecthBrandFiled() => branditems.fetchBrands();

  Future<List<BrandsFields>> fetchAdvertisecategory3() => sliderbanner.fetchAdvertisecategory3();

  Future<List<BrandsFields>> fetchAdvertisecategory4() => sliderbanner.fetchAdvertisecategory4();

  Future<List<BrandsFields>> fetchAdvertisecategory5() => sliderbanner.fetchAdvertisecategory5();

  Future<List<BrandsFields>> fetchFooter() => sliderbanner.fetchFooter();

  Future<SellingItemModel?> searchedItemsRepo() => sellingitem.fetchSellingItem();
/*
 Stream< List<SellingItemsFields>> get feauturedrepstream => _featuredItemsController.stream;
  List<SellingItemsFields> featuredItemsRepo() {
    sellingitem.fetchSellingItems();
     sellingitem.feauterditems.listen((event) {
       _featuredItemsController.sink.add(event);
    });

  }*/

/*  Stream< List<SellingItemsFields>> get discountrepstream => _discountItemController.stream;
  List<SellingItemsFields> discountItemRepo() {
    sellingitem.fetchDiscountItems();
     sellingitem.itemsdiscounts.listen((event) {
       _discountItemController.sink.add(event);
    });
  }*/
dispose(){
  //_discountItemController.close();
  seelingitem.dispose();
}
}
final repo = HomeRepository();
