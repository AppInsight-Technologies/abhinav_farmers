import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../models/newmodle/product_data.dart';
import '../constants/features.dart';
import '../blocs/sliderbannerBloc.dart';
import '../models/SellingItemsModle.dart';
import 'package:http/http.dart' as http;

import '../constants/IConstants.dart';
import '../models/VxModels/VxStore.dart';
import '../models/newmodle/swap.dart';
import '../models/sellingitemsfields.dart';
import '../utils/prefUtils.dart';
import '../constants/api.dart';

class SellingItemsList with ChangeNotifier {
  List<SellingItemsFields> _items = [];
  List<SellingItemsFields> _itemspricevar = [];

  List<SellingItemsFields> _itemsall = [];
  List<SellingItemsFields> _itemspricevarall = [];

  List<SellingItemsFields> _itemsdiscount = [];
  List<SellingItemsFields> _itemspricevardiscount = [];

  List<SellingItemsFields> _itemsForget =[];
  List<SellingItemsFields> _itemspricevarforget =[];

  List<SellingItemsFields> _itemsnew = [];
  List<SellingItemsFields> _itemspricevarnew = [];

  List<SellingItemsFields> _itemsnewimage =[];
  List<SellingItemsFields> _itemallimage=[];
  List<SellingItemsFields> _itemdiscountimage=[];
  List<SellingItemsFields> _itemfeatureimage=[];
  List<SellingItemsFields> _itemforgetimage=[];

  List<SellingItemsFields> _itemsoffer = [];
  List<SellingItemsFields> _itemspricevaroffer = [];
  List<SellingItemsFields> _itemofferimage=[];

  List<SellingItemsFields> _itemsSwap = [];
  List<SellingItemsFields> _itemspricevarSwap = [];
  List<SellingItemsFields> _itemSwapimage=[];

  final _featuredItemsController = StreamController<List<SellingItemsFields>>();
  final _discountItemController = StreamController<List<SellingItemsFields>>();
  final _offerItemController = StreamController<List<SellingItemsFields>>();
  final _forgetItemController = StreamController<List<SellingItemsFields>>();
  var featuredname = "";
  var discountedname = "";
  var newitemname = "";
  var offersname ="";
  var swapname ="";
  var forgetname = "";

// TODO HomeScreen
  Future<SellingItemModel?> fetchSellingItem() async { // imp feature in adding async is the it automatically wrap into Future.
    var url = Api.getFeaturedByCart;
    String user = (PrefUtils.prefs!.containsKey("apikey")) ? PrefUtils.prefs!.getString("tokenid")! : PrefUtils.prefs!.getString('apikey')!;
    // try {
      // _sellingitems.clear();
      final response = await http
          .post(
          url,
          body: {
            "rows": "2",
            "branch": PrefUtils.prefs!.getString('branch'),
            "user": user,
            "language_id": IConstants.languageId,
            // await keyword is used to wait to this operation is complete.
          }
      );
      SellingItemModel result;
      final responseJson = json.decode(utf8.decode(response.bodyBytes));

      if(responseJson.toString() != "[]") {
        Map<String, dynamic> resdata;
        resdata = responseJson as Map<String, dynamic>;
        // resdata["featuredCategoryBColor"] = list[_random.nextInt(list.length)];
        return  Future.value(SellingItemModel.fromJson(resdata));
      }
      else{
        return null;
      }

/*    } catch (error) {
      throw error;
    }*/
  }

  Future<void> fetchSellingItems() async { // imp feature in adding async is the it automatically wrap into Future.
    var url = Api.getFeaturedByCart;
    String user = (!PrefUtils.prefs!.containsKey("apikey")) ? PrefUtils.prefs!.getString("tokenid")! : PrefUtils.prefs!.getString('apikey')!;
    try {
      _items.clear();
      _itemspricevar.clear();
      _itemfeatureimage.clear();
      final response = await http
          .post(
          url,
          body: {
            "rows": "0",
            "branch": PrefUtils.prefs!.getString('branch'),
            "user": user,
            "language_id": IConstants.languageId,
            // await keyword is used to wait to this operation is complete.
          }
      );
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      _items.clear();
      _itemspricevar.clear();
      _itemfeatureimage.clear();
      featuredname = responseJson["label"].toString();

      final dataJson = json.encode(responseJson['data']); //fetching categories data
      final dataJsondecode = json.decode(dataJson);

      List data = [];
     if(dataJsondecode.toString()!="[]"){
       dataJsondecode.asMap().forEach((index, value) =>
           data.add(dataJsondecode[index] as Map<String, dynamic>)
       );
       for (int i = 0; i < data.length; i++){

         final deliveryduration= json.encode(data[i]['delivery_duration']);
         final deliverydurationJsondecode = json.decode(deliveryduration);
         List deliverydurationdata = [];
         String _duration = "";
         String _durationType = "";
         String _note = "";

         if(deliverydurationJsondecode.toString() == "slot" || deliverydurationJsondecode.toString() =="") {
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
           imageUrl: IConstants.API_IMAGE + "items/images/" + data[i]['item_featured_image'].toString(),
           brand: data[i]['brand'].toString(),
           veg_type: data[i]["veg_type"].toString(),
           type: data[i]["type"].toString(),
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
         bloc.feaurditemssink.add(_items);
         final pricevarJson = json.encode(data[i]['price_variation']); //fetching sub categories data
         final pricevarJsondecode = json.decode(pricevarJson);
         List pricevardata = []; //list for subcategories


         pricevarJsondecode.asMap().forEach((index, value) =>
             pricevardata.add(pricevarJsondecode[index] as Map<String, dynamic>)
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

           _itemspricevar.add(SellingItemsFields(
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
             unit: (pricevardata[j]['unit'].toString() == "null")? "" : (pricevardata[j]['unit'] ?? "").toString(),
             weight: double.parse(pricevardata[j]['weight'].toString()),
           ),);
           bloc.feutureditemvariabelsink.add(_itemspricevar);
           _featuredItemsController.sink.add(_items);
           final multiimagesJson = json.encode(
               pricevardata[j]['images']); //fetching sub categories data
           final multiimagesJsondecode = json.decode(multiimagesJson);
           List multiimagesdata = [];

           if (multiimagesJsondecode.toString() == "[]") {
             _itemfeatureimage.add(SellingItemsFields(
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
               _itemfeatureimage.add(SellingItemsFields(
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
    } catch (error) {
      throw error;
    }
  }


  Future<swap> fetchSwapProduct(String prevBranch, String varId, String item) async { // imp feature in adding async is the it automatically wrap into Future.
    var url = Api.getSwapProduct;
    final productBox = (VxState.store as GroceStore).CartItemList;
    // List<swap> listswapprod= [];
    // try {
    _itemsSwap.clear();
    _itemspricevarSwap.clear();
    _itemSwapimage.clear();
    debugPrint("get swap product..."+{
      "id": varId,
      "branch": prevBranch,
      "ref": IConstants.refIdForMultiVendor.toString(),
      "branchtype": IConstants.branchtype.toString(),
      "survey_product_id": item,

    }.toString());
    final response = await http
        .post(
        url,
        body: {
          "id": varId,
          "branch": prevBranch,
          "ref": IConstants.refIdForMultiVendor.toString(),
          "branchtype": IConstants.branchtype.toString(),
          "survey_product_id":item,
        }
    );
    final responseJson = json.decode(utf8.decode(response.bodyBytes));
    debugPrint("swap response new....." + responseJson.toString());

    return Future.value(swap.fromJson(responseJson));


    /* }catch(e){
      debugPrint("listswapprod..else.."+ e.toString());
      return  [];
     }*/
  }
  // Future<swap> fetchSwapProduct(String prevBranch, String varId, String? item) async { // imp feature in adding async is the it automatically wrap into Future.
  //   var url = Api.getSwapProduct;
  //   List<ItemData> listswapprod= [];
  //  try {
  //      _itemsSwap.clear();
  //      _itemspricevarSwap.clear();
  //      _itemSwapimage.clear();
  //      final response = await http
  //          .post(
  //          url,
  //          body: {
  //            "id": varId,
  //            "branch": prevBranch,
  //            "ref": IConstants.isEnterprise && Features.ismultivendor?IConstants.refIdForMultiVendor.toString():"",
  //            "branchtype": IConstants.isEnterprise && Features.ismultivendor?IConstants.branchtype.toString():"",
  //            "survey_product_id":item
  //          }
  //      );
  //      final responseJson = json.decode(utf8.decode(response.bodyBytes));
  //
  //      if (responseJson.toString() == "[]") {
  //        return [];
  //      }
  //      else {
  //        responseJson.forEach((v) {
  //          debugPrint("print v....."+ v.toString());
  //          v.forEach((v1) {
  //            debugPrint("print v1....."+ v1.toString());
  //            listswapprod.add(ItemData.fromJson(v1));
  //          });
  //          debugPrint("print t.....");
  //        });
  //        debugPrint("listswapprod..op.."+listswapprod.toString());
  //        return Future.value(listswapprod);
  //      }
  //    }catch(e){
  //     return  [];
  //    }
  // }

  Future<void> fetchNewItems(String id) async { // imp feature in adding async is the it automatically wrap into Future.
    String user = (!PrefUtils.prefs!.containsKey("apikey")) ? PrefUtils.prefs!.getString("tokenid")! : PrefUtils.prefs!.getString('apikey')!;
    var url = Api.getRecentProductsByCart + id + "/" + user + "/" + PrefUtils.prefs!.getString('branch')!;
    try {
      _itemsnew.clear();
      _itemspricevarnew.clear();
      _itemsnewimage.clear();
      final response = await http
          .post(
        url,
        body: {
          //"branch": PrefUtils.prefs!.getString('branch'),
          "language_id": IConstants.languageId,
            // await keyword is used to wait to this operation is complete.
          }
      );
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
    _itemsnew.clear();
    _itemspricevarnew.clear();
    _itemsnewimage.clear();
      newitemname = responseJson["label"].toString();

      final dataJson = json.encode(responseJson['data']); //fetching categories data
      final dataJsondecode = json.decode(dataJson);

      List data = [];

      dataJsondecode.asMap().forEach((index, value) =>
          data.add(dataJsondecode[index] as Map<String, dynamic>)
      );

      for (int i = 0; i < data.length; i++){

        final deliveryduration= json.encode(data[i]['delivery_duration']);

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

        _itemsnew.add(SellingItemsFields(
          id: data[i]['id'].toString(),
          title: data[i]['item_name'].toString(),
          imageUrl: IConstants.API_IMAGE + "items/images/" + data[i]['item_featured_image'].toString(),
          brand: data[i]['brand'].toString(),
          veg_type: data[i]["veg_type"].toString(),
          type: data[i]["type"].toString(),
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

        final pricevarJson = json.encode(data[i]['price_variation']); //fetching sub categories data
        final pricevarJsondecode = json.decode(pricevarJson);
        List pricevardata = []; //list for subcategories


        pricevarJsondecode.asMap().forEach((index, value) =>
            pricevardata.add(pricevarJsondecode[index] as Map<String, dynamic>)
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

          _itemspricevarnew.add(SellingItemsFields(
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
            unit: (pricevardata[j]['unit'].toString() == "null")? "" : (pricevardata[j]['unit'] ?? "").toString(),
            weight: double.parse(pricevardata[j]['weight'].toString()),
          ),);
          final multiimagesJson = json.encode(
              pricevardata[j]['images']); //fetching sub categories data
          final multiimagesJsondecode = json.decode(multiimagesJson);
          List multiimagesdata = [];

          if (multiimagesJsondecode.toString() == "[]") {
            _itemsnewimage.add(SellingItemsFields(
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
              _itemsnewimage.add(SellingItemsFields(
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
      notifyListeners();

    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchOffers() async { // imp feature in adding async is the it automatically wrap into Future.
    var url = Api.getOfferByCart;
    String user = (PrefUtils.prefs!.containsKey("apikey")) ? PrefUtils.prefs!.getString("tokenid")! : PrefUtils.prefs!.getString('apikey')!;
    try {
      _itemsoffer.clear();
      _itemspricevaroffer.clear();
      _itemofferimage.clear();
      final response = await http
          .post(
          url,
          body: {
            "rows": "10",
            "branch": PrefUtils.prefs!.getString('branch'),
            "user": user,
            // await keyword is used to wait to this operation is complete.
          }
      );
      final responseJson = json.decode(utf8.decode(response.bodyBytes));

      offersname = responseJson["label"].toString();
      final dataJson = json.encode(responseJson['data']); //fetching categories data
      final dataJsondecode = json.decode(dataJson);

      List data = [];

      dataJsondecode.asMap().forEach((index, value) =>
          data.add(dataJsondecode[index] as Map<String, dynamic>)
      );

      for (int i = 0; i < data.length; i++){
        final deliveryduration= json.encode(data[i]['delivery_duration']);
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

        _itemsoffer.add(SellingItemsFields(
          id: data[i]['id'].toString(),
          title: data[i]['item_name'].toString(),
          imageUrl: IConstants.API_IMAGE + "items/images/" + data[i]['item_featured_image'].toString(),
          brand: data[i]['brand'].toString(),
          eligible_for_express: Features.isExpressDelivery ? Features.isSplit ? data[i]['eligible_for_express'].toString(): "0" : "1",
          delivery:(data[i]['delivery'] ?? "").toString(),
          duration: _duration,
          durationType: _durationType,
          note: _note,
          veg_type: data[i]["veg_type"].toString(),
          type: data[i]["type"].toString(),
          subscribe:data[i]['eligible_for_subscription'].toString(),
          paymentmode:data[i]['payment_mode'].toString(),
          cronTime: _cronTime,
          name: _status,
        ));
        bloc.offeritemSink.add(_itemsoffer);

        final pricevarJson = json.encode(data[i]['price_variation']); //fetching sub categories data
        final pricevarJsondecode = json.decode(pricevarJson);
        List pricevardata = []; //list for subcategories


        pricevarJsondecode.asMap().forEach((index, value) =>
            pricevardata.add(pricevarJsondecode[index] as Map<String, dynamic>)
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

          _itemspricevaroffer.add(SellingItemsFields(
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
            unit: (pricevardata[j]['unit'].toString() == "null")? "" : (pricevardata[j]['unit'] ?? "").toString(),
            weight: double.parse(pricevardata[j]['weight'].toString()),
          ),);

          final multiimagesJson = json.encode(
              pricevardata[j]['images']); //fetching sub categories data
          final multiimagesJsondecode = json.decode(multiimagesJson);
          List multiimagesdata = [];

          if (multiimagesJsondecode.toString() == "[]") {
            _itemofferimage.add(SellingItemsFields(
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
              _itemofferimage.add(SellingItemsFields(
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
      notifyListeners();

    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAllSellingItems(String seeallpress) async { // imp feature in adding async is the it automatically wrap into Future.
    var url = "";
    if(seeallpress == "featured") {
      url = Api.getFeaturedByCart;
    } else if(seeallpress == "discount"){
      url = Api.getDiscountedByCart;
    }else if(seeallpress == "forget"){
      url = Api.getForgetByCart;
    }else{
      url = Api.getOfferByCart;
    }
    String user =  !PrefUtils.prefs!.containsKey('apikey') ? PrefUtils.prefs!.getString("tokenid")! : PrefUtils.prefs!.getString('apikey')!;
    try {
      _itemsall.clear();
      _itemspricevarall.clear();
      _itemallimage.clear();
      final response = await http
          .post(
          url,
          body: {
            "rows": "0",
            "branch": PrefUtils.prefs!.getString('branch'),
            "user": user,
            "language_id": IConstants.languageId,
            // await keyword is used to wait to this operation is complete.
          }
      );


      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      _itemsall.clear();
      _itemspricevarall.clear();
      _itemallimage.clear();
      final dataJson = json.encode(responseJson['data']); //fetching categories data
      final dataJsondecode = json.decode(dataJson);

      List data = [];

      dataJsondecode.asMap().forEach((index, value) =>
          data.add(dataJsondecode[index] as Map<String, dynamic>)
      );

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
       String delivery = (data[i]['delivery'] ?? "").toString();

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

        _itemsall.add(SellingItemsFields(
          id: data[i]['id'].toString(),
          title: data[i]['item_name'].toString(),
          imageUrl: IConstants.API_IMAGE + "items/images/" + data[i]['item_featured_image'].toString(),
          brand: data[i]['brand'].toString(),
          veg_type: data[i]["veg_type"].toString(),
          type: data[i]["type"].toString(),
          eligible_for_express: Features.isExpressDelivery ? Features.isSplit ? data[i]['eligible_for_express'].toString(): "0" : "1",
          delivery:(data[i]['delivery'] ?? "").toString(),
          duration: _duration,
          durationType: _durationType,
          note: _note,
          subscribe:data[i]['eligible_for_subscription'].toString(),
          paymentmode:data[i]['payment_mode'].toString(),
          cronTime: _cronTime,
          name: _status,
        )
        );

        final pricevarJson = json.encode(data[i]['price_variation']); //fetching sub categories data
        final pricevarJsondecode = json.decode(pricevarJson);
        List pricevardata = []; //list for subcategories


        pricevarJsondecode.asMap().forEach((index, value) =>
            pricevardata.add(pricevarJsondecode[index] as Map<String, dynamic>)
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

          _itemspricevarall.add(SellingItemsFields(
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
            unit: (pricevardata[j]['unit'].toString() == "null")? "" : (pricevardata[j]['unit'] ?? "").toString(),
            weight: double.parse(pricevardata[j]['weight'].toString()),
          ),);
          final multiimagesJson = json.encode(
              pricevardata[j]['images']); //fetching sub categories data
          final multiimagesJsondecode = json.decode(multiimagesJson);
          List multiimagesdata = [];

          if (multiimagesJsondecode.toString() == "[]") {
            _itemallimage.add(SellingItemsFields(
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
              _itemallimage.add(SellingItemsFields(
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

      notifyListeners();

    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchForget() async { // imp feature in adding async is the it automatically wrap into Future.
    var url = Api.getForgetByCart;
    String user = PrefUtils.prefs!.containsKey('apikey') ?PrefUtils.prefs!.getString('apikey')!: PrefUtils.prefs!.getString("tokenid") !;
    try {
      _itemsForget.clear();
      _itemspricevarforget.clear();
      final response = await http
          .post(
          url,
          body: {
            // "rows": "0",
            "branch": PrefUtils.prefs!.getString('branch'),
            "user": user,
            "language_id": IConstants.languageId,
            // await keyword is used to wait to this operation is complete.
          }
      );
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      _itemsForget.clear();
      _itemspricevarforget.clear();

      forgetname = responseJson["label"].toString();
      final dataJson = json.encode(responseJson['data']); //fetching categories data
      final dataJsondecode = json.decode(dataJson);

      List data = [];

      dataJsondecode.asMap().forEach((index, value) =>
          data.add(dataJsondecode[index] as Map<String, dynamic>)
      );

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
        _itemsForget.add(SellingItemsFields(
          id: data[i]['id'].toString(),
          title: data[i]['item_name'].toString(),
          imageUrl: IConstants.API_IMAGE + "items/images/" + data[i]['item_featured_image'].toString(),
          brand: data[i]['brand'].toString(),
          veg_type: data[i]["veg_type"].toString(),
          type: data[i]["type"].toString(),
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

        final pricevarJson = json.encode(data[i]['price_variation']); //fetching sub categories data
        final pricevarJsondecode = json.decode(pricevarJson);
        List pricevardata = []; //list for subcategories


        pricevarJsondecode.asMap().forEach((index, value) =>
            pricevardata.add(pricevarJsondecode[index] as Map<String, dynamic>)
        );

        for (int j = 0; j < pricevardata.length; j++) {
          bool _discointDisplay = false;
          bool _membershipDisplay = false;

          if(double.parse(pricevardata[j]['price'].toString()) <= 0 || pricevardata[j]['price'].toString() == "" || double.parse(pricevardata[j]['price'].toString()) == double.parse(pricevardata[j]['mrp'].toString())){
            _discointDisplay = false;
          } else {
            _discointDisplay = true;
          }

          if(pricevardata[j]['membership_price'].toString() == '-' || pricevardata[j]['membership_price'].toString() == "0" || double.parse(pricevardata[j]['membership_price'].toString()) == double.parse(pricevardata[j]['mrp'].toString())) {
            _membershipDisplay = false;
          } else {
            _membershipDisplay = true;
          }

          _itemspricevarforget.add(SellingItemsFields(
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
            unit: (pricevardata[j]['unit'].toString() == "null")? "" : (pricevardata[j]['unit'] ?? "").toString(),
            weight: double.parse(pricevardata[j]['weight'].toString()),
          ),);
          final multiimagesJson = json.encode(
              pricevardata[j]['images']); //fetching sub categories data
          final multiimagesJsondecode = json.decode(multiimagesJson);
          List multiimagesdata = [];

          if (multiimagesJsondecode.toString() == "[]") {
            _itemforgetimage.add(SellingItemsFields(
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
              _itemforgetimage.add(SellingItemsFields(
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
      bloc.forgetitemSink.add(_itemsForget);
/*      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      if (responseJson.toString() == "[]"){
      } else {
        List data = [];

        responseJson.asMap().forEach((index, value) =>
            data.add(responseJson[index] as Map<String, dynamic>)
        );

        for (int i = 0; i < data.length; i++){
          _items.add(SellingItemsFields(
            id: data[i]['id'].toString(),
            title: data[i]['item_name'].toString(),
            imageUrl: IConstants.API_IMAGE + "items/images/" + data[i]['item_featured_image'].toString(),
            brand: data[i]['brand'].toString(),
          ));

          final pricevarJson = json.encode(data[i]['price_variation']); //fetching sub categories data
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

              if(pricevardata[j]['membership_price'].toString() == '-' || pricevardata[j]['membership_price'].toString() == "0" || double.parse(pricevardata[j]['membership_price'].toString()) == double.parse(pricevardata[j]['mrp'].toString())) {
                _membershipDisplay = false;
              } else {
                _membershipDisplay = true;
              }

              _itemspricevar.add(SellingItemsFields(
                varid: pricevardata[j]['id'].toString(),
                menuid: pricevardata[j]['menu_item_id'].toString(),
                varname: pricevardata[j]['variation_name'].toString(),
                varmrp: pricevardata[j]['mrp'].toString(),
                varprice: pricevardata[j]['price'].toString(),
                varmemberprice:pricevardata[j]['membership_price'].toString(),
                varstock: pricevardata[j]['stock'].toString(),
                varminitem: pricevardata[j]['min_item'].toString(),
                varmaxitem: pricevardata[j]['max_item'].toString(),
                pricevardata[j]['loyalty'].toString() == "" ||
                pricevardata[j]['loyalty'].toString() == "null" ? 0 : int.parse(pricevardata[j]['loyalty'].toString()),
                discountDisplay: _discointDisplay,
                membershipDisplay: _membershipDisplay,
              ));
            }
          }
        }
      }*/

      notifyListeners();

    } catch (error) {
      throw error;
    }
  }
  Future<void> fetchDiscountItems() async { // imp feature in adding async is the it automatically wrap into Future.
    var url = Api.getDiscountedByCart;
    String user = (PrefUtils.prefs!.containsKey("apikey")) ? PrefUtils.prefs!.getString("tokenid")! : PrefUtils.prefs!.getString('apikey')!;
    try {
      _itemsdiscount.clear();
      _itemspricevardiscount.clear();
      _itemdiscountimage.clear();
      final response = await http
          .post(
          url,
          body: {
            "rows": "4",
            "branch": PrefUtils.prefs!.getString('branch'),
            "user": user,
            "language_id": IConstants.languageId,
            // await keyword is used to wait to this operation is complete.
          }
      );
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      _itemsdiscount.clear();
      _itemspricevardiscount.clear();
      _itemdiscountimage.clear();
      discountedname = responseJson["label"].toString();
      final dataJson = json.encode(responseJson['data']); //fetching categories data
      final dataJsondecode = json.decode(dataJson);

      List data = [];

      dataJsondecode.asMap().forEach((index, value) =>
          data.add(dataJsondecode[index] as Map<String, dynamic>)
      );

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

        _itemsdiscount.add(SellingItemsFields(
          id: data[i]['id'].toString(),
          title: data[i]['item_name'].toString(),
          imageUrl: IConstants.API_IMAGE + "items/images/" + data[i]['item_featured_image'].toString(),
          brand: data[i]['brand'].toString(),
          veg_type: data[i]["veg_type"].toString(),
          type: data[i]["type"].toString(),
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

        // _discountItemController.sink.add(_itemsdiscount);
        final pricevarJson = json.encode(data[i]['price_variation']); //fetching sub categories data
        final pricevarJsondecode = json.decode(pricevarJson);
        List pricevardata = []; //list for subcategories


        pricevarJsondecode.asMap().forEach((index, value) =>
            pricevardata.add(pricevarJsondecode[index] as Map<String, dynamic>)
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

          _itemspricevardiscount.add(SellingItemsFields(
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
            unit: (pricevardata[j]['unit'].toString() == "null")? "" : (pricevardata[j]['unit'] ?? "").toString(),
            weight: double.parse(pricevardata[j]['weight'].toString()),
          ),);
          final multiimagesJson = json.encode(
              pricevardata[j]['images']); //fetching sub categories data
          final multiimagesJsondecode = json.decode(multiimagesJson);
          List multiimagesdata = [];

          if (multiimagesJsondecode.toString() == "[]") {
            _itemdiscountimage.add(SellingItemsFields(
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
              _itemdiscountimage.add(SellingItemsFields(
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
      bloc.discountitemSink.add(_itemsdiscount);

      notifyListeners();

    } catch (error) {
      throw error;
    }
  }


  List<SellingItemsFields> get items {
    return [..._items];
  }

  List<SellingItemsFields> findByIdoffer(String menuid) {
    return [..._itemspricevaroffer.where((pricevar) => pricevar.menuid == menuid)];
  }
  List<SellingItemsFields> findByIdswap(String menuid) {
    return [..._itemspricevarSwap.where((pricevar) => pricevar.menuid == menuid)];
  }
  List<SellingItemsFields> get itemsoffer {
    return [..._itemsoffer];
  }
  List<SellingItemsFields> get itemsSwap {
    return [..._itemsSwap];
  }
  List<SellingItemsFields> get itemspricevarOffer {
    return [..._itemspricevaroffer];
  }
  List<SellingItemsFields> get itemspricevarSwap {
    return [..._itemspricevarSwap];
  }
  List<SellingItemsFields> findById(String menuid) {
    return [..._itemspricevar.where((pricevar) => pricevar.menuid == menuid)];
  }

  List<SellingItemsFields> get featuredVariation {
    return [..._itemspricevar];
  }

  List<SellingItemsFields> get discountedVariation {
    return [..._itemspricevardiscount];
  }

  List<SellingItemsFields> get itemsall {
    return [..._itemsall];
  }

  List<SellingItemsFields> findByIdall(String menuid) {
    return [..._itemspricevarall.where((pricevar) => pricevar.menuid == menuid)];
  }

  List<SellingItemsFields> get itemsdiscount {
      return   [..._itemsdiscount];

  }
  Stream<List<SellingItemsFields>> get itemsdiscounts {
  return  _discountItemController.stream;
  }
  Stream<List<SellingItemsFields>> get feauterditems {
  return  _featuredItemsController.stream;
  }
  Stream<List<SellingItemsFields>> get itemsForget {
    return  _forgetItemController.stream;
  }
  List<SellingItemsFields> findByIddiscount(String menuid) {
    return [..._itemspricevardiscount.where((pricevar) => pricevar.menuid == menuid)];
  }

  List<SellingItemsFields> get itemsnew {
    return [..._itemsnew];
  }

  List<SellingItemsFields> findByIdnew(String menuid) {
    return [..._itemspricevarnew.where((pricevar) => pricevar.menuid == menuid)];
  }

  List<SellingItemsFields> get recentVariation {
    return [..._itemspricevarnew];
  }
  List<SellingItemsFields> findByIdforget(String menuid) {
    return [..._itemspricevarforget.where((pricevar) => pricevar.menuid == menuid)];
  }
  List<SellingItemsFields> get forgetVariation {
    return [..._itemspricevarforget];
  }
  List<SellingItemsFields> findByIditemsnewimage(String pricevarid){
    return [..._itemsnewimage.where((pricevar) => pricevar.varid == pricevarid)];
  }
  List<SellingItemsFields> findByIdallimage(String pricevarid){
    return [..._itemallimage.where((pricevar) => pricevar.varid == pricevarid)];
  }
  List<SellingItemsFields> findBydiscountimage(String pricevarid){
    return [..._itemdiscountimage.where((pricevar) => pricevar.varid == pricevarid)];
  }
  List<SellingItemsFields> findByfeaturedimage(String pricevarid){
    return [..._itemfeatureimage.where((pricevar) => pricevar.varid == pricevarid)];
  }
  List<SellingItemsFields> findByofferimage(String pricevarid){
    return [..._itemofferimage.where((pricevar) => pricevar.varid == pricevarid)];
  }
  List<SellingItemsFields> findBySwapimage(String pricevarid){
    return [..._itemSwapimage.where((pricevar) => pricevar.varid == pricevarid)];
  }
  List<SellingItemsFields> findByForgotimage(String pricevarid){
    return [..._itemforgetimage.where((pricevar) => pricevar.varid == pricevarid)];
  }
   dispose() {
     _discountItemController.close();
  }
}
final seelingitem = SellingItemsList();