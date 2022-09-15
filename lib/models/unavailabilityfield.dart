import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'unavailableproducts_field.dart';

class unavailabilities with ChangeNotifier {
  List<unavailabilitiesfield> _items = [];

  Future<void>  unavailable(
      String id,
      String title,
      String brand,
      String varid,
      String menuid,
      String varname,
      String varmrp,
      String price,
      String varmembership,
      String varstock,
      String varminitem,
      String varmaxitem,
      String imageUrl
      ) async{

    _items.add(unavailabilitiesfield(
        id: id,
        title: title,
        brand: brand,
        varid: varid,
        menuid: menuid,
        varname: varname,
        varmrp: varmrp,
        varprice: price,
        varmemberprice: varmembership,
        varstock: varstock,
        varminitem: varminitem,
        varmaxitem: varmaxitem,
        imageUrl: imageUrl
    )
    );

  }

  List<unavailabilitiesfield> get items {
    return [..._items];
  }
}