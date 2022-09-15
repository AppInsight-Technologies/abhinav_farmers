import '../../models/newmodle/category_modle.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/product_data.dart';
import '../../repository/productandCategory/category_or_product.dart';
import 'package:velocity_x/velocity_x.dart';

enum Productof{
  category,productlist,singleProduct,subcategory,nestedcategory,stores
}
class ProductController {
  ProductRepo _product = ProductRepo();
  final store = VxState.store as GroceStore;
  getCategory()async{
    ProductMutation(Productof.category,await _product.getCategory());
  }
 geSubtCategory(catid, {required Function(bool) onload})async{
     _product.getSubcategory(catid, (value) {
       ProductMutation(Productof.subcategory,value,catid: catid);
       onload(value.isNotEmpty);
     });
  }
  getNestedCategory(catid)async{

    await _product.getSubNestcategory(catid);
  }
  getCategoryprodutlist(categoryId,initial,type,Function(bool) isendofproduct, {isexpress =false})async{
if(initial == "0") store.productlist.clear();
    await _product.getCartProductLists(categoryId,start: initial,type:type).then((value) {
      if(initial == "0") store.productlist.clear();
      if(value.isNotEmpty) {
        isendofproduct(false);
        if(initial == "0") store.productlist.clear();
        ProductMutation(Productof.productlist, isexpress?value.where((element) => element.eligibleForExpress == isexpress).toList():value);
      } else {
        isendofproduct(true);
      }
    });
  }
  getcategoryitemlist(categoryId)async{
    await _product.getcategoryitemlist(categoryId).then((value) {
        store.productlist.clear();
        ProductMutation(Productof.productlist,value);
    });
}
  getbrandprodutlist(categoryId,int initial,Function(bool) isendofproduct)async{
    if(initial.toString() == "0")
    store.productlist.clear();
    await _product.getBrandProductLists(categoryId,start: initial).then((value){
      if(value != null) {
        isendofproduct(false);
        ProductMutation(Productof.productlist, value);
      } else {
        isendofproduct(true);
      }
    });
  }
  /// Send variaon id in the place of productid
  Future<void> getprodut(String variationId, String type)async{
    store.singelproduct = null;
    ProductMutation(Productof.singleProduct,await _product.getProduct(variationId,type));
  }
  getStore(lat,long,ids)async{

    await _product.getStore(lat,long,ids);
  }

}
class ProductMutation  extends VxMutation<GroceStore> {
  Productof productof;
  List<dynamic>? list;
  String? catid;
  String? parentid;

  ProductMutation(this. productof,this. list,{this.catid,this.parentid});

  @override
  perform() async{
    // TODO: implement perform
switch(productof){

  case Productof.category:
    store!.homescreen.data!.allCategoryDetails = list! as List<CategoryData>;
    // TODO: Handle this case.
    break;
  case Productof.productlist:
    final productlist = store?.productlist;
    productlist!.addAll(list as List<ItemData>);
    store!.productlist = productlist;
    // TODO: Handle this case.
    break;
  case Productof.singleProduct:
    if(list!.isNotEmpty)
    store!.singelproduct = list!.first;
    // TODO: Handle this case.
    break;

  case Productof.subcategory:
    store!.homescreen.data!.allCategoryDetails!.where((element) {
      return element.id == catid;
    }).first.subCategory = list! as List<CategoryData>;
    // TODO: Handle this case.
    break;
  case Productof.nestedcategory:
    store!.homescreen.data!.allCategoryDetails!.where((element) {
      return element.id == catid;}).first.
    subCategory.where((element) {
      return element.id == catid;}).length>0?
    store!.homescreen.data!.allCategoryDetails!.where((element) => element.id==catid).first.subCategory.where((element) => element.id == catid).first.subCategory = list! as List<CategoryData>:[];
    // TODO: Handle this case.
    break;
}
  }
}