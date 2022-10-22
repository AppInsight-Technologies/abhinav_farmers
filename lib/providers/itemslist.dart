import 'dart:convert';
import 'package:flutter/material.dart';
import '../constants/features.dart';
import '../blocs/item_bloc.dart';
import '../blocs/search_item_bloc.dart';
import 'package:http/http.dart' as http;

import '../constants/IConstants.dart';
import '../models/sellingitemsfields.dart';
import '../utils/prefUtils.dart';
import '../constants/api.dart';

class ItemsList with ChangeNotifier {
  List<SellingItemsFields> _items = [];
  List<SellingItemsFields> _itemspricevar = [];

  List<SellingItemsFields> _searchitems = [];
  List<SellingItemsFields> _searchitemspricevar = [];

  List<SellingItemsFields> _singleitems = [];
  List<SellingItemsFields> _singleitemspricevar = [];

  List<SellingItemsFields> _multiimages = [];
  List<SellingItemsFields> _itemimages =[];
  List<SellingItemsFields> _searchimage=[];

  Future<void> fetchItems(String catId, String type, int startitem, String checkinitialy) async {
    // imp feature in adding async is the it automatically wrap into Future.
    var url = Api.getMenuitemByCart;
    String user = (!PrefUtils.prefs!.containsKey("apikey")) ? PrefUtils.prefs!.getString("tokenid")! : PrefUtils.prefs!.getString('apikey')!;
    PrefUtils.prefs!.setBool("endOfProduct", false);
    try {
      final response = await http
          .post(
          url,
          body: {
            "id": catId,
            "start": startitem.toString(),
            "end": "0",
            "type" : type,
            "branch": PrefUtils.prefs!.getString('branch'),
            "user": user,
            "language_id": IConstants.languageId,
            // await keyword is used to wait to this operation is complete.
          }
      );
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      debugPrint("banproduct."+responseJson.toString());
      if (responseJson.toString() == "[]"){
        PrefUtils.prefs!.setBool("endOfProduct", true);
      } else {
        if(checkinitialy == "initialy") {
          _items.clear();
          _itemspricevar.clear();
          _itemimages.clear();
        }
        List data = [];

        responseJson.asMap().forEach((index, value) =>
            data.add(responseJson[index] as Map<String, dynamic>)
        );

        for (int i = 0; i < data.length; i++) {
          final deliveryduration = json.encode(
              data[i]['delivery_duration']);

          final deliverydurationJsondecode = json.decode(deliveryduration);
          List deliverydurationdata = [];

          String _duration = "";
          String _durationType = "";
          String _note = "";

          if(deliverydurationJsondecode.toString() == "slot" || deliverydurationJsondecode.toString() ==" ") {
            _duration = "";
            _durationType = "";
            _note = "";
          } else {
            deliverydurationJsondecode.asMap().forEach((index, value) =>
                deliverydurationdata.add(
                    deliverydurationJsondecode[index] as Map<String, dynamic>)
            );
            _duration = Features.isSplit ? deliverydurationdata[0]["duration"].toString() : "";
            _durationType = Features.isSplit ? deliverydurationdata[0]["durationType"].toString() : "";

            _note = (deliverydurationdata[0]["note"] ?? "").toString();
          }

          /////Subscription

          final subscriptionslot= json.encode(data[i]['subscription_slot']);
          final subscriptionslotJsondecode = json.decode(subscriptionslot);
          List subscriptionslotdata = [];
          String _cronTime = "";
          String _status = "";

          if(subscriptionslotJsondecode.toString() == "[]") {
            _cronTime = "";
            _status = "";
          } else {
            subscriptionslotJsondecode.asMap().forEach((index, value) =>
                subscriptionslotdata.add(
                    subscriptionslotJsondecode[index] as Map<String, dynamic>)
            );
            _cronTime = subscriptionslotdata[0]["cronTime"].toString();
            _status = subscriptionslotdata[0]["deliveryTime"].toString();

          }

          _items.add(SellingItemsFields(
            id: data[i]['id'].toString(),
            title: data[i]['item_name'].toString(),
            imageUrl: IConstants.API_IMAGE + "items/images/" +
                data[i]['item_featured_image'].toString(),
            brand: data[i]['brand'].toString(),
            veg_type: data[i]["veg_type"].toString(),
            type: data[i]["type"].toString(),
            salePrice: data[i]["sale_price"].toString(),
            eligible_for_express: Features.isExpressDelivery ? Features.isSplit ? data[i]['eligible_for_express'].toString(): "0" : "1",

            delivery: (data[i]['delivery'] ?? "").toString(),
            duration: _duration,
            durationType: _durationType,
            note: _note,
            subscribe:data[i]['eligible_for_subscription'].toString(),
            paymentmode:data[i]['payment_mode'].toString(),
            cronTime: _cronTime,
            name: _status,
          ));
          itembloc.itemsink.add(_items);
          final pricevarJson = json.encode(
              data[i]['price_variation']); //fetching sub categories data
          final pricevarJsondecode = json.decode(pricevarJson);
          List pricevardata = []; //list for subcategories

          if (pricevarJsondecode == null) {

          } else {
            pricevarJsondecode.asMap().forEach((index, value) =>
                pricevardata.add(
                    pricevarJsondecode[index] as Map<String, dynamic>)
            );

            for (int j = 0; j < pricevardata.length; j++) {
              bool _discointDisplay = false;
              bool _membershipDisplay = false;

              if (double.parse(pricevardata[j]['price'].toString()) <= 0 || pricevardata[j]['price'].toString() == "" || double.parse(pricevardata[j]['price'].toString()) == double.parse(pricevardata[j]['mrp'].toString())) {
                _discointDisplay = false;
              } else {
                _discointDisplay = true;
              }
              if (pricevardata[j]['membership_price'].toString() == '-' || pricevardata[j]['membership_price'].toString() == "0" || double.parse(pricevardata[j]['membership_price'].toString()) == double.parse(pricevardata[j]['mrp'].toString())
                  || double.parse(pricevardata[j]['membership_price'].toString()) == double.parse(pricevardata[j]['price'].toString())) {
                _membershipDisplay = false;
              } else {
                _membershipDisplay = true;
              }

              _itemspricevar.add(SellingItemsFields(
                varid: pricevardata[j]['id'].toString(),
                menuid: pricevardata[j]['menu_item_id'].toString(),
                varname: pricevardata[j]['variation_name'].toString(),
                varmrp: (IConstants.numberFormat == "1")
                    ? pricevardata[j]['mrp'].toStringAsFixed(0)
                    : pricevardata[j]['mrp'].toStringAsFixed(IConstants.decimaldigit),
                varprice: (IConstants.numberFormat == "1")
                    ? pricevardata[j]['price'].toStringAsFixed(0)
                    : pricevardata[j]['price'].toStringAsFixed(IConstants.decimaldigit),
                varmemberprice: (IConstants.numberFormat ==
                    "1") ? pricevardata[j]['membership_price'].toStringAsFixed(
                    0) : pricevardata[j]['membership_price'].toStringAsFixed(IConstants.decimaldigit),
                varstock: pricevardata[j]['stock'].toString(),
                varminitem: pricevardata[j]['min_item'].toString(),
                varmaxitem: pricevardata[j]['max_item'].toString(),
                varLoyalty: pricevardata[j]['loyalty'].toString() == "" ||
                    pricevardata[j]['loyalty'].toString() == "null" ? 0 : int
                    .parse(pricevardata[j]['loyalty'].toString()),
                varQty: int.parse(pricevardata[j]['quantity'].toString()),
                discountDisplay: _discointDisplay,
                membershipDisplay: _membershipDisplay,
                unit: (pricevardata[j]['unit'].toString() == "null")? "" : (pricevardata[j]['unit'] ?? "").toString(),
                weight: double.parse(pricevardata[j]['weight'].toString()),
                netWeight: double.parse(pricevardata[j]['net_weight'].toString()),
              ));
              final multiimagesJson = json.encode(
                  pricevardata[j]['images']); //fetching sub categories data
              final multiimagesJsondecode = json.decode(multiimagesJson);
              List multiimagesdata = [];

              if (multiimagesJsondecode.toString() == "[]") {
                _itemimages.add(SellingItemsFields(
                  varid: pricevardata[j]['id'].toString(),
                  menuid: data[i]['id'].toString(),
                  imageUrl: IConstants.API_IMAGE + "items/images/" +
                      data[i]['item_featured_image'].toString(),
                  varcolor: Color(0xff012961),
                ));
              } else {
                multiimagesJsondecode.asMap().forEach((index, value) =>
                    multiimagesdata.add(
                        multiimagesJsondecode[index] as Map<String, dynamic>)
                );

                for (int k = 0; k < multiimagesdata.length; k++) {
                  var varcolor;
                  if (k == 0) {
                    varcolor = Color(0xff012961);
                  } else {
                    varcolor = Color(0xffBEBEBE);
                  }
                  _itemimages.add(SellingItemsFields(
                    varid: pricevardata[j]['id'].toString(),
                    menuid: data[i]['id'].toString(),
                    imageUrl: IConstants.API_IMAGE + "items/images/" +
                        multiimagesdata[k]['image'].toString(),
                    varcolor: varcolor,
                  ));
                }
              }
            }
          }
        }


        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  List<SellingItemsFields> get items {
    return [..._items];
  }

  List<SellingItemsFields> findById(String menuid) {
    return [..._itemspricevar.where((pricevar) => pricevar.menuid == menuid)];
  }
  List<SellingItemsFields> findByIdExpress() {
    return [..._items.where((express) => (express.eligible_for_express == "0") )];
  }

  Future<bool> fetchsearchItems(String item_name,[bool isonsubmit = false]) async { // imp feature in adding async is the it automatically wrap into Future.

    var url = Api.getSerachitemByCart;
    String user = (!PrefUtils.prefs!.containsKey("apiKey")) ? PrefUtils.prefs!.getString("tokenid")! : PrefUtils.prefs!.getString('apikey')!;
    debugPrint("search..."+{
      "apiKey": user,
      "item_name": item_name,
      "branch": PrefUtils.prefs!.getString('branch'),
      "user": user,
      "language_id": IConstants.languageId,
    }.toString());
    try {
      _searchitems.clear();
      _searchitemspricevar.clear();
      _searchimage.clear();
      final response = await http
          .post(
          url,
          body: {
            "apiKey": user,
            "item_name": item_name,
            "branch": PrefUtils.prefs!.getString('branch'),
            "user": user,
            "language_id": IConstants.languageId,
            // await keyword is used to wait to this operation is complete.
          }
      );
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      final dataJson = json.encode(responseJson['data']);
      final dataJsondecode = json.decode(dataJson);
      List data = [];


      dataJsondecode.asMap().forEach((index, value) =>
          data.add(
              dataJsondecode[index] as Map<String, dynamic>)
      );
      _searchitems.clear();
      _searchitemspricevar.clear();
      _searchimage.clear();
      for (int i = 0; i < data.length; i++){
        final deliveryduration= json.encode(
            data[i]['delivery_duration']);

        final deliverydurationJsondecode = json.decode(deliveryduration);
        List deliverydurationdata = [];

        String _duration = "";
        String _durationType = "";
        String _note = "";

        if(deliverydurationJsondecode.toString() == "slot" || deliverydurationJsondecode.toString() ==" ") {
          _duration = "";
          _durationType = "";
          _note = "";
        } else {
          deliverydurationJsondecode.asMap().forEach((index, value) =>
              deliverydurationdata.add(
                  deliverydurationJsondecode[index] as Map<String, dynamic>)
          );
          _duration = Features.isSplit ? deliverydurationdata[0]["duration"].toString() : "";
          _durationType = Features.isSplit ? deliverydurationdata[0]["durationType"].toString() : "";

          _note = (deliverydurationdata[0]["note"] ?? "").toString();
        }

        /////Subscription

        final subscriptionslot= json.encode(data[i]['subscription_slot']);
        final subscriptionslotJsondecode = json.decode(subscriptionslot);
        List subscriptionslotdata = [];
        String _cronTime = "";
        String _status = "";

        if(subscriptionslotJsondecode.toString() == "[]") {
          _cronTime = "";
          _status = "";
        } else {
          subscriptionslotJsondecode.asMap().forEach((index, value) =>
              subscriptionslotdata.add(
                  subscriptionslotJsondecode[index] as Map<String, dynamic>)
          );
          _cronTime = subscriptionslotdata[0]["cronTime"].toString();
          _status = subscriptionslotdata[0]["deliveryTime"].toString();

        }

        _searchitems.add(SellingItemsFields(
          id: data[i]['id'].toString(),
          title: data[i]['itemName'].toString(),
          imageUrl: IConstants.API_IMAGE + "items/images/" + data[i]['itemFeaturedImage'].toString(),
          brand: data[i]['brand'].toString(),
          veg_type: data[i]["veg_type"].toString(),
          type: data[i]["type"].toString(),
          salePrice: data[i]["sale_price"].toString(),
          eligible_for_express: Features.isExpressDelivery ? Features.isSplit ? data[i]['eligible_for_express'].toString(): "0" : "1",

          delivery:(data[i]['delivery'] ?? "").toString(),
          duration: _duration,
          durationType: _durationType,
          note: _note,
          subscribe:data[i]['eligible_for_subscription'].toString(),
          paymentmode:data[i]['payment_mode'].toString(),
          cronTime: _cronTime,
          name: _status,
        ));


        final pricevarJson = json.encode(data[i]['priceVariation']); //fetching sub categories data
        final pricevarJsondecode = json.decode(pricevarJson);
        List pricevardata = []; //list for subcategories

        if (pricevarJsondecode == null){

        } else {
          pricevarJsondecode.asMap().forEach((index, value) =>
              pricevardata.add(
                  pricevarJsondecode[index] as Map<String, dynamic>)
          );

          for (int j = 0; j < pricevardata.length; j++) {
            bool _discointDisplay = false;
            bool _membershipDisplay = false;

            if(double.parse(pricevardata[j]['price'].toString()) <= 0 || pricevardata[j]['price'].toString() == "" || double.parse(pricevardata[j]['price'].toString()) == double.parse(pricevardata[j]['mrp'].toString())){
              _discointDisplay = false;
            } else {
              _discointDisplay = true;
            }

            if(pricevardata[j]['membership_price'].toString() == '-' || pricevardata[j]['membership_price'].toString() == "0" || double.parse(pricevardata[j]['membership_price'].toString()) == double.parse(pricevardata[j]['mrp'].toString())
                || double.parse(pricevardata[j]['membership_price'].toString()) == double.parse(pricevardata[j]['price'].toString())) {
              _membershipDisplay = false;
            } else {
              _membershipDisplay = true;
            }
            _searchitemspricevar.add(SellingItemsFields(
              varid: pricevardata[j]['id'].toString(),
              menuid: pricevardata[j]['menu_item_id'].toString(),
              varname: pricevardata[j]['variationName'].toString(),
              ///variation_name depreciated new value  variationName
              varmrp: (IConstants.numberFormat == "1") ? pricevardata[j]['mrp'].toStringAsFixed(0) : pricevardata[j]['mrp'].toStringAsFixed(IConstants.decimaldigit),
              varprice: (IConstants.numberFormat == "1") ? pricevardata[j]['price'].toStringAsFixed(0) : pricevardata[j]['price'].toStringAsFixed(IConstants.decimaldigit),
              varmemberprice: (IConstants.numberFormat == "1") ? pricevardata[j]['membership_price'].toStringAsFixed(0) : pricevardata[j]['membership_price'].toStringAsFixed(IConstants.decimaldigit),
              varstock: pricevardata[j]['stock'].toString(),
              varminitem: pricevardata[j]['minItem'].toString(),
              varmaxitem: pricevardata[j]['maxItem'].toString(),
              varLoyalty: pricevardata[j]['loyalty'].toString() == "" ||
                  pricevardata[j]['loyalty'].toString() == "null" ? 0 : int.parse(pricevardata[j]['loyalty'].toString()),
              varQty: int.parse(pricevardata[j]['quantity'].toString()),
              discountDisplay: _discointDisplay,
              membershipDisplay: _membershipDisplay,
              unit: (pricevardata[j]['unit'].toString() == "null")? "" : (pricevardata[j]['unit'] ?? "").toString(),
              weight: double.parse(pricevardata[j]['weight'].toString()),
              netWeight: double.parse(pricevardata[j]['net_weight'].toString()),
            ));
            final multiimagesJson = json.encode(
                pricevardata[j]['images']); //fetching sub categories data
            final multiimagesJsondecode = json.decode(multiimagesJson);
            List multiimagesdata = [];

            if (multiimagesJsondecode.toString() == "[]") {
              _searchimage.add(SellingItemsFields(
                varid: pricevardata[j]['id'].toString(),
                menuid: data[i]['id'].toString(),
                imageUrl: IConstants.API_IMAGE + "items/images/" +
                    data[i]['itemFeaturedImage'].toString(),
                varcolor: Color(0xff012961),
              ));
            } else {
              multiimagesJsondecode.asMap().forEach((index, value) =>
                  multiimagesdata.add(
                      multiimagesJsondecode[index] as Map<String, dynamic>)
              );

              for (int k = 0; k < multiimagesdata.length; k++) {
                var varcolor;
                if (k == 0) {
                  varcolor = Color(0xff012961);
                } else {
                  varcolor = Color(0xffBEBEBE);
                }
                _searchimage.add(SellingItemsFields(
                  varid: pricevardata[j]['id'].toString(),
                  menuid: data[i]['id'].toString(),
                  imageUrl: IConstants.API_IMAGE + "items/images/" +
                      multiimagesdata[k]['image'].toString(),
                  varcolor: varcolor,
                ));
              }
            }
          }
        }
      }

     if(isonsubmit) {
       print("isonsubmit $isonsubmit");
        sbloc.searchitemsink.add(_searchitems);
      }
      notifyListeners();
      return true;
    } catch (error) {
      return true;
    }

  }


  List<SellingItemsFields> get searchitems {
    return [..._searchitems];
  }

  List<SellingItemsFields> findByIdsearch(String menuid) {
    List<SellingItemsFields> list = [];
    _searchitemspricevar.forEach((element) {
      if(element.menuid == menuid){
        list.add(element);
      }
    });
    sbloc.searchsubitemsink.add(list);
    return [..._searchitemspricevar.where((pricevar) => pricevar.menuid == menuid)];
  }
  List<SellingItemsFields> findBysearchimage(String pricevarid){
    return [..._searchimage.where((pricevar) => pricevar.varid == pricevarid)];
  }
  Future<void> fetchSingleItems(String itemid, String notificationFor) async { // imp feature in adding async is the it automatically wrap into Future.
    var url = notificationFor.toString() == "13"?Api.getSingleProductvarIdByCart:Api.getSingleProductByCart;
    String user = (!PrefUtils.prefs!.containsKey("apikey")) ? PrefUtils.prefs!.getString("ftokenid")! : PrefUtils.prefs!.getString('apikey')!;
   print("fetch singel item:"+{
     "id": itemid,
     "branch": PrefUtils.prefs!.getString('branch'),
     "user": user,
     "language_id": IConstants.languageId,
     "ref": IConstants.refIdForMultiVendor.toString(),
     "branchtype": IConstants.branchtype.toString(),
     // await keyword is used to wait to this operation is complete.
   }.toString());
    try {
      _singleitems.clear();
      _singleitemspricevar.clear();
      _multiimages.clear();
      final response = await http
          .post(
          url,
          body: {
              "id": itemid,
              "branch": PrefUtils.prefs!.getString('branch'),
              "user": user,
              "language_id": IConstants.languageId,
            // await keyword is used to wait to this operation is complete.
          }
      );
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      debugPrint("single..."+responseJson.toString());
      if(responseJson.toString() != "[]") {
        List data = [];

        responseJson.asMap().forEach((index, value) =>
            data.add(
                responseJson[index] as Map<String, dynamic>)
        );

        for (int i = 0; i < data.length; i++) {

          final deliveryduration= json.encode(
              data[i]['delivery_duration']);

          final deliverydurationJsondecode = json.decode(deliveryduration);

          List deliverydurationdata = [];


          String _duration = "";
          String _durationType = "";
          String _note = "";

          if(deliverydurationJsondecode.toString() == "slot" || deliverydurationJsondecode.toString() ==" ") {
            _duration = "";
            _durationType = "";
            _note = "";
          } else {
            deliverydurationJsondecode.asMap().forEach((index, value) =>
                deliverydurationdata.add(
                    deliverydurationJsondecode[index] as Map<String, dynamic>)
            );
            _duration = Features.isSplit ? deliverydurationdata[0]["duration"].toString() : "";
            _durationType = Features.isSplit ? deliverydurationdata[0]["durationType"].toString() : "";

            _note = (deliverydurationdata[0]["note"] ?? "").toString();
          }

          /////Subscription

          final subscriptionslot= json.encode(data[i]['subscription_slot']);
          final subscriptionslotJsondecode = json.decode(subscriptionslot);
          List subscriptionslotdata = [];
          String _cronTime = "";
          String _status = "";

          if(subscriptionslotJsondecode.toString() == "[]") {
            _cronTime = "";
            _status = "";
          } else {
            subscriptionslotJsondecode.asMap().forEach((index, value) =>
                subscriptionslotdata.add(
                    subscriptionslotJsondecode[index] as Map<String, dynamic>)
            );
            _cronTime = subscriptionslotdata[0]["cronTime"].toString();
            _status = subscriptionslotdata[0]["deliveryTime"].toString();

          }

          _singleitems.add(SellingItemsFields(
            id: data[i]['id'].toString(),
            title: data[i]['item_name'].toString(),
            imageUrl: IConstants.API_IMAGE + "items/images/" + data[i]['item_featured_image'].toString(),
            brand: data[i]['brand'].toString(),
            description: data[i]['item_description'].toString(),
            manufacturedesc: data[i]['manufacturer_description'].toString(),
            veg_type: data[i]["veg_type"].toString(),
            type: data[i]["type"].toString(),
            salePrice: data[i]["sale_price"].toString(),
            eligible_for_express: Features.isExpressDelivery ? Features.isSplit ? data[i]['eligible_for_express'].toString(): "0" : "1",
            delivery:(data[i]['delivery'] ?? "").toString(),
            duration: _duration,
            durationType: _durationType,
            note: _note,
            subscribe:data[i]['eligible_for_subscription'].toString(),
            paymentmode:data[i]['payment_mode'].toString(),
            cronTime: _cronTime,
            name: _status,
          ));


          final pricevarJson = json.encode(
              data[i]['price_variation']); //fetching sub categories data
          final pricevarJsondecode = json.decode(pricevarJson);
          List pricevardata = []; //list for subcategories

          if (pricevarJsondecode == null) {

          } else {
            pricevarJsondecode.asMap().forEach((index, value) =>
                pricevardata.add(
                    pricevarJsondecode[index] as Map<String, dynamic>)
            );
            for (int j = 0; j < pricevardata.length; j++) {
              var varcolor;
              if(j == 0) {
                varcolor = Color(0xff012961);
              } else {
                varcolor = Color(0xff000000);//Color(0xffBEBEBE);
              }
              bool _discointDisplay = false;
              bool _membershipDisplay = false;

              if(double.parse(pricevardata[j]['price'].toString()) <= 0 || pricevardata[j]['price'].toString() == "" || double.parse(pricevardata[j]['price'].toString()) == double.parse(pricevardata[j]['mrp'].toString())){
                _discointDisplay = false;
              } else {
                _discointDisplay = true;
              }

              if(pricevardata[j]['membership_price'].toString() == '-' || pricevardata[j]['membership_price'].toString() == "0" || double.parse(pricevardata[j]['membership_price'].toString()) == double.parse(pricevardata[j]['mrp'].toString())
              || double.parse(pricevardata[j]['membership_price'].toString()) == double.parse(pricevardata[j]['price'].toString())) {
                _membershipDisplay = false;
              } else {
                _membershipDisplay = true;
              }

              _singleitemspricevar.add(SellingItemsFields(
                varid: pricevardata[j]['id'].toString(),
                menuid: data[i]['id'].toString(),
                varname: pricevardata[j]['variation_name'].toString(),
                varmrp: (IConstants.numberFormat == "1") ? pricevardata[j]['mrp'].toStringAsFixed(0) : pricevardata[j]['mrp'].toStringAsFixed(IConstants.decimaldigit),
                varprice: (IConstants.numberFormat == "1") ? pricevardata[j]['price'].toStringAsFixed(0) : pricevardata[j]['price'].toStringAsFixed(IConstants.decimaldigit),
                varmemberprice: (IConstants.numberFormat == "1") ? pricevardata[j]['membership_price'].toStringAsFixed(0) : pricevardata[j]['membership_price'].toStringAsFixed(IConstants.decimaldigit),
                varstock: pricevardata[j]['stock'].toString(),
                varminitem: pricevardata[j]['min_item'].toString(),
                varmaxitem: pricevardata[j]['max_item'].toString(),
                varLoyalty: pricevardata[j]['loyalty'].toString() == "" ||
                    pricevardata[j]['loyalty'].toString() == "null" ? 0 : int.parse(pricevardata[j]['loyalty'].toString()),
                varQty: int.parse(pricevardata[j]['quantity'].toString()),
                discountDisplay: _discointDisplay,
                membershipDisplay: _membershipDisplay,
                varcolor: varcolor,
                unit: (pricevardata[j]['unit'].toString() == "null")? "" : (pricevardata[j]['unit'] ?? "").toString(),
                weight: double.parse(pricevardata[j]['weight'].toString()),
                netWeight: double.parse(pricevardata[j]['net_weight'].toString()),
              ));

              final multiimagesJson = json.encode(pricevardata[j]['images']); //fetching sub categories data

              final multiimagesJsondecode = json.decode(multiimagesJson);

              List multiimagesdata = [];

              if(multiimagesJsondecode.toString() == "[]") {
                _multiimages.add(SellingItemsFields(
                  varid: pricevardata[j]['id'].toString(),
                  menuid: data[i]['id'].toString(),
                  imageUrl: IConstants.API_IMAGE + "items/images/" + data[i]['item_featured_image'].toString(),
                  varcolor: Color(0xff012961),
                ));
              } else {
                multiimagesJsondecode.asMap().forEach((index, value) =>
                    multiimagesdata.add(
                        multiimagesJsondecode[index] as Map<String, dynamic>)
                );

                for(int k = 0; k < multiimagesdata.length; k++) {
                  var varcolor;
                  if(k == 0) {
                    varcolor = Color(0xff012961);
                  } else {
                    varcolor = Color(0xff000000);//Color(0xffBEBEBE);
                  }
                  _multiimages.add(SellingItemsFields(
                    varid: pricevardata[j]['id'].toString(),
                    menuid: data[i]['id'].toString(),
                    imageUrl: IConstants.API_IMAGE + "items/images/" + multiimagesdata[k]['image'].toString(),
                    varcolor: varcolor,
                  ));
                }
              }
            }
          }
        }
        notifyListeners();
      }

    } catch (error) {
      throw error;
    }
  }

  List<SellingItemsFields> get singleitems {
    return [..._singleitems];
  }

  List<SellingItemsFields> findByIdsingleitems(String menuitemid, String notificationFor) {
    return [..._singleitemspricevar.where((pricevar) => notificationFor.toString() == "13"?pricevar.varid == menuitemid:pricevar.menuid == menuitemid)];
  }

  List<SellingItemsFields> findByIdmulti(String pricevarid) {
    return [..._multiimages.where((pricevar) => pricevar.varid == pricevarid)];
  }
  List<SellingItemsFields> findByIditemimage(String pricevarid){
    return [..._itemimages.where((pricevar) => pricevar.varid == pricevarid)];
  }
}