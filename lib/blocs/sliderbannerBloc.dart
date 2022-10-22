import 'dart:async';
import '../providers/branditems.dart';
import '../models/SellingItemsModle.dart';
import '../models/brandFiledModel.dart';
import '../models/categoriesModel.dart';
import '../models/sellingitemsfields.dart';
import '../providers/sellingitems.dart';

import '../models/brandfieldsModel.dart';
import '../repository/home_repository.dart';
import 'package:rxdart/rxdart.dart';

class BannerSliderBloc {
  final _repository = HomeRepository();
  final _sellingitem = SellingItemsList();
  final _SliderbannerFetcher = BehaviorSubject<List<BrandsFields>>();
  final _categoryOneController = BehaviorSubject<List<CategoriesModel>>();
  final _categoryTwoController = BehaviorSubject<List<CategoriesModel>>();
  final _categoryThreeController = BehaviorSubject<List<CategoriesModel>>();
  final _beandFildModleController = BehaviorSubject<List<BrandsFieldModel>>();
  final _footerController = BehaviorSubject<List<BrandsFields>>();
  final _advertiseOneController = BehaviorSubject<List<BrandsFields>>();
  final _featureAdsOneController = BehaviorSubject<List<BrandsFields>>();
  final _featureAdsTwoController = BehaviorSubject<List<BrandsFields>>();
  final _featureAdsThreeController = BehaviorSubject<List<BrandsFields>>();
  final _featureAdsFourController = BehaviorSubject<List<BrandsFields>>();
  final _featureditemController = BehaviorSubject<List<SellingItemsFields>>();
  final _featureditemVariabelController = BehaviorSubject<List<SellingItemsFields>>();
  final _discountItemController = BehaviorSubject<List<SellingItemsFields>>();
  final _forgetItemController = BehaviorSubject<List<SellingItemsFields>>();
  final _offerItemController = BehaviorSubject<List<SellingItemsFields>>();
  final _swapItemController = BehaviorSubject<List<SellingItemsFields>>();
  final _searcheditemController = StreamController<SellingItemModel>.broadcast();
  final sellingitem = SellingItemsList();
  final payment= BrandItemsList();

  Stream<List<BrandsFields>> get allBanner => _SliderbannerFetcher.stream;

  String? get varId => null;

  String? get prevBranch => null;

  String? get item => null;

  fetchBanner() async {
    List<BrandsFields> itemModel = await _repository.fetchBanner();
    _SliderbannerFetcher.sink.add(itemModel);
  }

  Stream<List<CategoriesModel>> get categoryOne => _categoryOneController.stream;
  CategoryOne() async {
    List<CategoriesModel> itemModel = await _repository.fetchCategoryOne();
    _categoryOneController.sink.add(itemModel);
  }

  Stream<List<BrandsFields>> get advertiseOne => _advertiseOneController.stream;
  fetchAdvertiseOne() async {
    List<BrandsFields> itemModel = await _repository.fetchAdvertisecategory1();
    _advertiseOneController.sink.add(itemModel);
  }

  Stream<List<BrandsFields>> get featuredAdsOne => _featureAdsOneController.stream;
  featureAdsOne() async {
    List<BrandsFields> itemModel = await _repository.fetchAdvertisecategory2();
    _featureAdsOneController.sink.add(itemModel);
  }
  Stream<SellingItemModel> get searcheditem => _searcheditemController.stream;
  SearcheditemBloc() async {
    SellingItemModel? itemModel = await _repository.searchedItemsRepo();
    _searcheditemController.sink.add(itemModel!);
  }

  Stream<List<CategoriesModel>> get categoryTwo => _categoryTwoController.stream;
  CategoryTwo() async {
    List<CategoriesModel> itemModel = await _repository.fetchCategoryTwo();

    _categoryTwoController.sink.add(itemModel);
  }
  Stream<List<CategoriesModel>> get category => _categoryThreeController.stream;
  fetchCategoryThree() async {
    List<CategoriesModel> itemModel = await _repository.fetchCategoryThree();
    _categoryThreeController.sink.add(itemModel);
  }
  Stream<List<BrandsFieldModel>> get brandfiledBloc => _beandFildModleController.stream;
  BrandfiledBloc() async {
    List<BrandsFieldModel> itemModel = await _repository.fecthBrandFiled();
    _beandFildModleController.sink.add(itemModel);
  }

  Stream<List<BrandsFields>> get featuredAdsTwo => _featureAdsTwoController.stream;
  featureAdsTwo() async {
    List<BrandsFields> itemModel = await _repository.fetchAdvertisecategory3();
    _featureAdsTwoController.sink.add(itemModel);
  }

  Stream<List<BrandsFields>> get featuredAdsThree => _featureAdsThreeController.stream;
  featureAdsThree() async {
    List<BrandsFields> itemModel = await _repository.fetchAdvertisecategory4();
    _featureAdsThreeController.sink.add(itemModel);
  }

  Stream<List<BrandsFields>> get featuredAdsFour => _featureAdsFourController.stream;
  featureAdsFour() async {
    List<BrandsFields> itemModel = await _repository.fetchAdvertisecategory5();
    _featureAdsFourController.sink.add(itemModel);
  }

  StreamSink<List<SellingItemsFields>> get feaurditemssink => _featureditemController.sink;
  Stream<List<SellingItemsFields>>  get featureditems => _featureditemController.stream;


  Stream<List<SellingItemsFields>> get feutureditemvariabel => _featureditemVariabelController.stream;
  StreamSink<List<SellingItemsFields>> get feutureditemvariabelsink => _featureditemVariabelController.sink;
  featuredItems() async {
    await _sellingitem.fetchSellingItems();
   /* _repository.featuredItemsRepo();
    _repository.feauturedrepstream.listen((event) {
      _featureditemController.sink.add(event);
    });*/
  }

  Stream<List<BrandsFields>> get footer => _footerController.stream;
  fetchFooter() async {
    List<BrandsFields> itemModel = await _repository.fetchFooter();
    _footerController.sink.add(itemModel);
  }
  StreamSink<List<SellingItemsFields>> get discountitemSink => _discountItemController.sink;
  Stream<List<SellingItemsFields>> get discountItemStream => _discountItemController.stream;
  sellingitemBloc() async{
    sellingitem.fetchDiscountItems();
   /* _repository.discountItemRepo();
    _repository.discountrepstream.listen((event) {
      _discountItemController.sink.add(event);
    }) ;*/
  }
  StreamSink<List<SellingItemsFields>> get forgetitemSink => _forgetItemController.sink;
  Stream<List<SellingItemsFields>> get forgetitemStream => _forgetItemController.stream;
  forgetItems() async {
    sellingitem.fetchForget();
  }

  StreamSink<List<SellingItemsFields>> get offeritemSink => _offerItemController.sink;
  Stream<List<SellingItemsFields>> get offerItemStream => _offerItemController.stream;
  offeritemBloc() async{
    sellingitem.fetchOffers();
  }

  StreamSink<List<SellingItemsFields>> get swapitemSink => _swapItemController.sink;
  Stream<List<SellingItemsFields>> get swapItemStream => _swapItemController.stream;
  swapitemBloc() async{
    sellingitem.fetchSwapProduct(prevBranch!, varId!,item!);
  }
/*  StreamSink<List<BrandsFields>> get paymentSink => payment.sink;
  Stream<List<BrandsFields>> get paymentStream => payment.stream;
  fetchPaymentMode() async{
    payment.fetchPaymentMode();

  }*/
/*  dispose() {
    _SliderbannerFetcher.close();
    _categoryOneController.close();
    _advertiseOneController.close();
    _featureAdsOneController.close();
    _categoryTwoController.close();
    _featureAdsTwoController.close();
    _featureAdsThreeController.close();
    _featureAdsFourController.close();
    _footerController.close();
    _beandFildModleController.close();
    _featureditemController.close();
    _discountItemController.close();
    repo.dispose();
  }*/

}
final bloc = BannerSliderBloc();