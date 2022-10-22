import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/product_data.dart';
import '../../models/newmodle/search_data.dart';
import '../../models/sellingitemsfields.dart';
import 'package:velocity_x/velocity_x.dart';
import '../constants/features.dart';

class Check{

  isOutofStock({double? maxstock,String? stocktype,String? qty, List<SellingItemsFields>?  itemData, PriceVariation? variation,PriceVariationSearch? searchvariation,String? screen}){
    double quantity =0;
    if( stocktype =="1") {
      itemData!.forEach((element) {
        quantity = quantity+ (element.varQty * element.weight!);
      });
      quantity = (screen == "search_screen" && Features.ismultivendor)?(quantity) + double.parse(searchvariation!.weight!):(quantity) + double.parse(variation!.weight!);
      return quantity > maxstock!;
    } else {
      return double.parse(qty!) >= maxstock!;
    }
  }
  isOutofStockSingleProduct({PriceVariation? variation ,PriceVariationSearch? searchvariation,double? maxstock,String? stocktype,List<SellingItemsFields>?  itemData,String? screen}){
    double quantity =0;
    if( stocktype =="1") {
      itemData!.forEach((element) {
        quantity = quantity + (element.varQty * element.weight!);
      });
      quantity = (screen == "search_screen" && Features.ismultivendor)?(quantity) + double.parse(searchvariation!.weight!):(quantity) + double.parse(variation!.weight!);
      return quantity >= maxstock!;
    } else {
      return double.parse(variation!.quantity!.toString()) >= maxstock!;
    }
  }

 bool checkmembership(){
    bool _checkmembership = false;
    if (VxState.store.userData.membership! =="1") {
      _checkmembership=true;
    } else {
      _checkmembership = false;
      for (int i = 0; i < (VxState.store as GroceStore).CartItemList.length; i++) {
        if ((VxState.store as GroceStore).CartItemList[i].mode == "1") {
          _checkmembership=true;
        }
      }
    }
    return _checkmembership;
  }
}