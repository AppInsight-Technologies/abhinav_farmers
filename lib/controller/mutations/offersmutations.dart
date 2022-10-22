import '../../models/VxModels/VxStore.dart';
import '../../models/sellingitemsfields.dart';
import 'package:velocity_x/velocity_x.dart';
enum Carts{
  ADD,REMOVE,DELETE,CLEAR,
}
class cartMutation extends VxMutation<GroceStore>{
  Carts type;
  SellingItemsFields cartitemsfields;
  int position;
  cartMutation({
    required this.type,
    required this.cartitemsfields,
    required this.position,
});
  @override
  perform() {
    // TODO: implement perform
    print('enter...');
    switch (type){

      case Carts.ADD:
        // TODO: Handle this case.
      print("id...."+cartitemsfields.id.toString());
      store!.OfferCartList[position] = SellingItemsFields(
        id: cartitemsfields.id,
        title: cartitemsfields.title,
        imageUrl:cartitemsfields.imageUrl,
        brand:cartitemsfields.brand,
        itemqty:cartitemsfields.itemqty,
        varid:cartitemsfields.varid,
        menuid:cartitemsfields.menuid,
        varname:cartitemsfields.varname,
        varmrp:cartitemsfields.varmrp,
        varprice:cartitemsfields.varprice,
        varmemberprice:cartitemsfields.varmemberprice,
        varmemberid:cartitemsfields.varmemberid,
        varstock:cartitemsfields.varstock,
        varminitem:cartitemsfields.varminitem,
        varmaxitem:cartitemsfields.varmaxitem,
        varLoyalty:cartitemsfields.varLoyalty,
        varQty:cartitemsfields.varQty,
        varcolor:cartitemsfields.varcolor,
        mode:cartitemsfields.mode,
        discountDisplay:cartitemsfields.discountDisplay,
        membershipDisplay:cartitemsfields.membershipDisplay,
        description:cartitemsfields.description,
        manufacturedesc:cartitemsfields.manufacturedesc,
        offerId:cartitemsfields.offerId,
        offerTitle:cartitemsfields.offerTitle,
        border:cartitemsfields.border,
        veg_type:cartitemsfields.veg_type,
        type:cartitemsfields.type,
        eligible_for_express:cartitemsfields.eligible_for_express,
        delivery:cartitemsfields.delivery,
        duration:cartitemsfields.duration,
        durationType:cartitemsfields.durationType,
        note:cartitemsfields.note,
        subscribe:cartitemsfields.subscribe,
        paymentmode:cartitemsfields.paymentmode,
        cronTime:cartitemsfields.cronTime,
        name:cartitemsfields.name,
      );
      store!.CartOfferList.add( SellingItemsFields(
        id: cartitemsfields.id,
        title: cartitemsfields.title,
        imageUrl:cartitemsfields.imageUrl,
        brand:cartitemsfields.brand,
        itemqty:cartitemsfields.itemqty,
        varid:cartitemsfields.varid,
        menuid:cartitemsfields.menuid,
        varname:cartitemsfields.varname,
        varmrp:cartitemsfields.varmrp,
        varprice:cartitemsfields.varprice,
        varmemberprice:cartitemsfields.varmemberprice,
        varmemberid:cartitemsfields.varmemberid,
        varstock:cartitemsfields.varstock,
        varminitem:cartitemsfields.varminitem,
        varmaxitem:cartitemsfields.varmaxitem,
        varLoyalty:cartitemsfields.varLoyalty,
        varQty:cartitemsfields.varQty,
        varcolor:cartitemsfields.varcolor,
        mode:cartitemsfields.mode,
        discountDisplay:cartitemsfields.discountDisplay,
        membershipDisplay:cartitemsfields.membershipDisplay,
        description:cartitemsfields.description,
        manufacturedesc:cartitemsfields.manufacturedesc,
        offerId:cartitemsfields.offerId,
        offerTitle:cartitemsfields.offerTitle,
        border:cartitemsfields.border,
        veg_type:cartitemsfields.veg_type,
        type:cartitemsfields.type,
        eligible_for_express:cartitemsfields.eligible_for_express,
        delivery:cartitemsfields.delivery,
        duration:cartitemsfields.duration,
        durationType:cartitemsfields.durationType,
        note:cartitemsfields.note,
        subscribe:cartitemsfields.subscribe,
        paymentmode:cartitemsfields.paymentmode,
        cronTime:cartitemsfields.cronTime,
        name:cartitemsfields.name,
      ));
      print("varmrp..."+store!.CartOfferList[position].varprice.toString());
        break;
      case Carts.REMOVE:
        // TODO: Handle this case.
        print("idssss...."+cartitemsfields.id.toString());
        store!.OfferCartList[position] = SellingItemsFields(
          id: cartitemsfields.id,
          title: cartitemsfields.title,
          imageUrl:cartitemsfields.imageUrl,
          brand:cartitemsfields.brand,
          itemqty:cartitemsfields.itemqty,
          varid:cartitemsfields.varid,
          menuid:cartitemsfields.menuid,
          varname:cartitemsfields.varname,
          varmrp:cartitemsfields.varmrp,
          varprice:cartitemsfields.varprice,
          varmemberprice:cartitemsfields.varmemberprice,
          varmemberid:cartitemsfields.varmemberid,
          varstock:cartitemsfields.varstock,
          varminitem:cartitemsfields.varminitem,
          varmaxitem:cartitemsfields.varmaxitem,
          varLoyalty:cartitemsfields.varLoyalty,
          varQty:cartitemsfields.varQty,
          varcolor:cartitemsfields.varcolor,
          mode:cartitemsfields.mode,
          discountDisplay:cartitemsfields.discountDisplay,
          membershipDisplay:cartitemsfields.membershipDisplay,
          description:cartitemsfields.description,
          manufacturedesc:cartitemsfields.manufacturedesc,
          offerId:cartitemsfields.offerId,
          offerTitle:cartitemsfields.offerTitle,
          border:cartitemsfields.border,
          veg_type:cartitemsfields.veg_type,
          type:cartitemsfields.type,
          eligible_for_express:cartitemsfields.eligible_for_express,
          delivery:cartitemsfields.delivery,
          duration:cartitemsfields.duration,
          durationType:cartitemsfields.durationType,
          note:cartitemsfields.note,
          subscribe:cartitemsfields.subscribe,
          paymentmode:cartitemsfields.paymentmode,
          cronTime:cartitemsfields.cronTime,
          name:cartitemsfields.name,
        );
        store!.CartOfferList.remove(SellingItemsFields(
          id: cartitemsfields.id,
          title: cartitemsfields.title,
          imageUrl:cartitemsfields.imageUrl,
          brand:cartitemsfields.brand,
          itemqty:cartitemsfields.itemqty,
          varid:cartitemsfields.varid,
          menuid:cartitemsfields.menuid,
          varname:cartitemsfields.varname,
          varmrp:cartitemsfields.varmrp,
          varprice:cartitemsfields.varprice,
          varmemberprice:cartitemsfields.varmemberprice,
          varmemberid:cartitemsfields.varmemberid,
          varstock:cartitemsfields.varstock,
          varminitem:cartitemsfields.varminitem,
          varmaxitem:cartitemsfields.varmaxitem,
          varLoyalty:cartitemsfields.varLoyalty,
          varQty:cartitemsfields.varQty,
          varcolor:cartitemsfields.varcolor,
          mode:cartitemsfields.mode,
          discountDisplay:cartitemsfields.discountDisplay,
          membershipDisplay:cartitemsfields.membershipDisplay,
          description:cartitemsfields.description,
          manufacturedesc:cartitemsfields.manufacturedesc,
          offerId:cartitemsfields.offerId,
          offerTitle:cartitemsfields.offerTitle,
          border:cartitemsfields.border,
          veg_type:cartitemsfields.veg_type,
          type:cartitemsfields.type,
          eligible_for_express:cartitemsfields.eligible_for_express,
          delivery:cartitemsfields.delivery,
          duration:cartitemsfields.duration,
          durationType:cartitemsfields.durationType,
          note:cartitemsfields.note,
          subscribe:cartitemsfields.subscribe,
          paymentmode:cartitemsfields.paymentmode,
          cronTime:cartitemsfields.cronTime,
          name:cartitemsfields.name,
        ));
       store!.OfferCartList[position].id;
       for(int i=0;i<store!.CartOfferList.length;i++){
         if(store!.CartOfferList[i].id== store!.OfferCartList[position].id){
           store!.CartOfferList.removeAt(i);
         }
       }
        break;
      case Carts.DELETE:
        // TODO: Handle this case.
        break;
      case Carts.CLEAR:
        // TODO: Handle this case.
        break;
    }
  }

}
class AddOffersCart extends VxMutation<GroceStore>{
  List<SellingItemsFields> listcart = [];
  AddOffersCart(this.listcart);
  @override
  perform() {
    // TODO: implement perform
   store!.OfferCartList  = listcart;
  // store.CartOfferList = listcart;
  }

}