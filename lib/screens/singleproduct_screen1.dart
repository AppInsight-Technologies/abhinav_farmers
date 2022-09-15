import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import '../../components/singleItemComponents/singel_Item_web.dart';
import '../../components/singleItemComponents/single_item_mobile.dart';
import '../../controller/mutations/cat_and_product_mutation.dart';
import '../../models/sellingitemsfields.dart';
import '../../widgets/eception_widget/product_not_found.dart';
import '../controller/mutations/cart_mutation.dart';
import '../models/VxModels/VxStore.dart';
import '../models/newmodle/cartModle.dart';
import '../models/newmodle/shoppingModel.dart';
import '../repository/authenticate/AuthRepo.dart';
import '../repository/productandCategory/category_or_product.dart';
import '../rought_genrator.dart';
import 'package:velocity_x/velocity_x.dart';
import '../generated/l10n.dart';
import 'package:intl/intl.dart';
import '../widgets/header.dart';
import '../widgets/productWidget/product_sliding_image_widget.dart';
import '../widgets/simmers/singel_item_screen_shimmer.dart';
import 'package:share/share.dart';
import 'package:provider/provider.dart';
import '../providers/sellingitems.dart';
import '../providers/branditems.dart';
import '../constants/IConstants.dart';
import '../data/calculations.dart';
import '../widgets/badge.dart';
import '../assets/images.dart';
import '../utils/prefUtils.dart';
import '../constants/features.dart';
import '../assets/ColorCodes.dart';
import '../utils/ResponsiveLayout.dart';
import 'dart:async';

class SingleproductScreen extends StatefulWidget {
  static const routeName = '/singleproduct-screen';

  String _varid;
  String _productID;
  SingleproductScreen(this._varid, this._productID);

  @override
  _SingleproductScreenState createState() => _SingleproductScreenState();
}

class _SingleproductScreenState extends State<SingleproductScreen> with TickerProviderStateMixin, Navigations {
  bool _isLoading = true;
  List<SellingItemsFields> singleitemvar =[];
  bool _isWeb = Vx.isWeb;
  bool _isIOS = !Vx.isWeb&&!Vx.isAndroid;
  String? varid;
  final _form = GlobalKey<FormState>();
   MediaQueryData? queryData;
  bool iphonex = false;
  var currentDate;
  bool checkskip = false;
  StreamController<int>? _events;
  GroceStore store = VxState.store;
    Future<ItemModle>? _product;
  List<CartItem> productBox = [];
  Uri? dynamicUrl;
  List<ShoppingListData> shoplistData=[];
  Auth _auth = Auth();

  @override
  void initState() {
    _events = new StreamController<int>.broadcast();
    _events!.add(30);
    productBox =(VxState.store as GroceStore).CartItemList;
    initialRoute(()async {
      checkskip = !PrefUtils.prefs!.containsKey('apikey');
      _product = ProductRepo().getRecentProduct(widget._productID.toString());
      ProductController().getprodut(widget._varid.toString(),"").whenComplete(() {
      createShareLink(widget._varid,widget._productID);
      setState(() {
      _isLoading= false;
      });
      });
      final now = new DateTime.now();
      currentDate = DateFormat('dd/MM/y').format(now);
    });

    if(Features.isShoppingList){
      shoplistData = (VxState.store as GroceStore).ShoppingList;
    }
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  addListnameToSF(String value) async {
    PrefUtils.prefs!.setString('list_name', value);
  }

  _saveFormTwo() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    } //it will check all validators
    _form.currentState!.save();
    Navigator.of(context).pop();
    _dialogforProceesing(context, S.current.creating_list);

    Provider.of<BrandItemsList>(context, listen: false).CreateShoppinglist().then((_) {
      _auth.getuserProfile(onsucsess: (value){
        shoplistData = (VxState.store as GroceStore).ShoppingList;
        Navigator.of(context).pop();
        _dialogforShoppinglistTwo(context);
      },onerror: (){

      });
    });
  }

  additemtolistTwo() {
    final shoplistDataTwo = shoplistData;//Provider.of<BrandItemsList>(context, listen: false);
    _dialogforProceesing(context, "Add item to list...");
    for (int i = 0; i < shoplistDataTwo.length; i++) {
      //adding item to multiple list
      if (shoplistDataTwo[i].listcheckbox == true) {
        addtoshoppinglisttwo(i);
      }
    }
  }

  addtoshoppinglisttwo(i) async {
    final shoplistDataTwo = shoplistData;//Provider.of<BrandItemsList>(context, listen: false);

    Provider.of<BrandItemsList>(context, listen: false).AdditemtoShoppinglist(
        widget._productID.toString(), widget._varid.toString(), shoplistDataTwo[i].id!,store.singelproduct!.type.toString()).then((_) {
      _auth.getuserProfile(onsucsess: (value){
        shoplistData = (VxState.store as GroceStore).ShoppingList;
        Navigator.of(context).pop();
      },onerror: (){

      });
    });
  }

  _dialogforProceesing(BuildContext context, String text) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              child: Container(
                  width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
                  height: 100.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(
                        width: 40.0,
                      ),
                      Text(text),
                    ],
                  )),
            );
          });
        });
  }

  _dialogforCreatelistTwo(BuildContext context, shoplistData) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              child: Container(
                  width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
                  height: 250.0,
                  margin: EdgeInsets.only(
                      left: 20.0, top: 10.0, right: 10.0, bottom: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        S.current.create_shopping_list,
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Theme
                                .of(context)
                                .primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Form(
                        key: _form,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return S.current.please_enter_list_name;
                                }
                                return null; //it means user entered a valid input
                              },
                              onSaved: (value) {
                                addListnameToSF(value!);
                              },
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: S.current.shopping_list_name,
                                labelStyle: TextStyle(
                                    color: ColorCodes.primaryColor),
                                contentPadding: EdgeInsets.all(12),
                                hintText: S.of(context).monthly_grocery,//'ex: Monthly Grocery',
                                hintStyle: TextStyle(
                                    color: Colors.black12, fontSize: 10.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme
                                            .of(context)
                                            .focusColor
                                            .withOpacity(0.2))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme
                                            .of(context)
                                            .focusColor
                                            .withOpacity(0.5))),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme
                                            .of(context)
                                            .focusColor
                                            .withOpacity(0.2))),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          _saveFormTwo();
                        },
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          child: Center(
                              child: Text(
                                S.current.create_shopping_list,
                                textAlign: TextAlign.center,
                                style:
                                TextStyle(color: ColorCodes.whiteColor),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          child: Center(
                              child: Text(
                                S.current.cancel,
                                textAlign: TextAlign.center,
                                style:
                                TextStyle(color: ColorCodes.whiteColor),
                              )),
                        ),
                      ),
                    ],
                  )),
            );
          });
        });
  }

  _dialogforShoppinglistTwo(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          shoplistData = (VxState.store as GroceStore).ShoppingList;
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.0)),
                child: Container(
                  width: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                      left: 10.0, top: 20.0, right: 10.0, bottom: 30.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          S.current.add_to_list,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Theme
                                  .of(context)
                                  .primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        SizedBox(
                          child: new ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: shoplistData.length,
                            itemBuilder: (_, i) =>
                                Row(
                                  children: [
                                    Checkbox(
                                      checkColor: ColorCodes.primaryColor,
                                      activeColor: ColorCodes.whiteColor,
                                      value: shoplistData[i].listcheckbox,
                                      onChanged: ( bool? value) async {
                                        setState(() {
                                          shoplistData[i].listcheckbox = value;
                                        });
                                      },
                                    ),
                                    Text(shoplistData[i].name!,
                                        style: TextStyle(fontSize: 18.0)),
                                  ],
                                ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();

                            _dialogforCreatelistTwo(context, shoplistData);

                            for (int i = 0; i < shoplistData.length; i++) {
                               shoplistData[i].listcheckbox = false;
                            }
                          },
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 10.0,
                              ),
                              Icon(
                                Icons.add,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                S.current.create_new,
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 18.0),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            bool check = false;
                            for (int i = 0; i < shoplistData.length; i++) {
                              if (shoplistData[i].listcheckbox!)
                                setState(() {
                                  check = true;
                                });
                            }
                            if (check) {
                              Navigator.of(context).pop();
                              additemtolistTwo();
                            } else {
                              Fluttertoast.showToast(
                                  msg: S.current.please_select_atleastonelist,
                                  fontSize: MediaQuery.of(context).textScaleFactor *13,
                                  backgroundColor: Colors.black87,
                                  textColor: Colors.white);
                            }
                          },
                          child: Container(
                            width: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
                            // color: Theme.of(context).primaryColor,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: Theme
                                  .of(context)
                                  .primaryColor,
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                            child: Center(
                                child: Text(
                                  S.current.add,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme
                                          .of(context)
                                          .buttonColor),
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            for (int i = 0; i < shoplistData.length; i++) {
                              shoplistData[i].listcheckbox = false;
                            }
                          },
                          child: Container(
                            width: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
                            // color: Theme.of(context).primaryColor,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                            child: Center(
                                child: Text(
                                  S.current.cancel,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme
                                          .of(context)
                                          .buttonColor),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);

    return  WillPopScope(
        onWillPop: () { // this is the block you need
          if(GoRouter.of(context).navigator!.canPop())
            Navigation(context, navigatore: NavigatoreTyp.Pop);
          else
            Navigation(context, navigatore: NavigatoreTyp.homenav,);
      return Future.value(false);
    },
    child: Scaffold(
      appBar: ResponsiveLayout.isSmallScreen(context) ?
      AppBarMobile(routeArgs,sellingitemData) : null,
      backgroundColor: Colors.white,
      body:
      //(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?Column(
      //   children: [
      //     if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))Header(false),
      //     //_isLoading?SingelItemScreenShimmer():SizedBox.shrink()
      //     // _isLoading?SingelItemScreenShimmer():VxBuilder(builder: (context,GroceStore store,state){
      //     //   if (store.singelproduct!=null&&store.singelproduct!.toJson().isNotEmpty) {
      //     //     return
      //     //     SingleItemWebComponent(similarProduct: _product,
      //     //       product: store.singelproduct!,
      //     //       variationId: widget._varid.toString(),);
      //     //   }else {
      //     //     return ProductNotFound();
      //     //   }
      //     // }, mutations: {ProductMutation},),
      //   ],
      // ):
      _isLoading?SingelItemScreenShimmer():VxBuilder(builder: (context,store,state){
       if (store.singelproduct!=null&&store.singelproduct!.toJson().isNotEmpty) {
         return ResponsiveLayout.isSmallScreen(context) ?
         SingleItemMobileComponent(similarProduct: _product,
             product: store.singelproduct!,
             variationId: widget._varid.toString(),
             iphonex: iphonex) :
         SingleItemWebComponent(similarProduct: _product,
           product: store.singelproduct!,
           variationId: widget._varid.toString(),);
       }else {
         return ProductNotFound();
       }
    }, mutations: {ProductMutation},),
    ));
  }

  Future<String> createShareLink(String singleProduct, String productID) async {
    final DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
        uriPrefix: 'https://gbay.page.link',
        link: Uri.parse('${IConstants.AppDomain}/store/product/$singleProduct/$productID'),
        androidParameters: AndroidParameters(
          packageName: IConstants.androidId,
        ),
        iosParameters: IOSParameters(
            bundleId: IConstants.androidId,
            appStoreId: IConstants.appleId
        ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: store.singelproduct!=null?store.singelproduct!.item_description:"",
        //  description: store.singelproduct!=null?store.singelproduct!.item_description:"",
          imageUrl: Uri.parse(store.singelproduct!.itemFeaturedImage.toString())),
    );

//Short link
   final ShortDynamicLink shortLink = await (await FirebaseDynamicLinks.instance).buildShortLink(dynamicLinkParameters);
    dynamicUrl = shortLink.shortUrl;

//Long link
 //  dynamicUrl = await (FirebaseDynamicLinks.instance).buildLink(dynamicLinkParameters);
    return dynamicUrl.toString();
  }
  AppBarMobile(Map<String, dynamic> routeArgs, SellingItemsList sellingitemData){
    return  AppBar(
      toolbarHeight: 55.0,
      elevation: (IConstants.isEnterprise)?0:1,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Text(_isLoading?"":store.singelproduct!=null&&store.singelproduct!.toJson().isNotEmpty?store.singelproduct!.itemName.toString():"",style: TextStyle(color: ColorCodes.iconColor, fontWeight: FontWeight.bold, fontSize: 18),),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color:ColorCodes.iconColor),
        onPressed: () {
          if(GoRouter.of(context).navigator!.canPop())
             Navigation(context, navigatore: NavigatoreTyp.Pop);
          else
            Navigation(context, navigatore: NavigatoreTyp.homenav,);
          },
      ),
      actions: [
        if(Features.isShare)
          Container(
            width: 25,
            height: 25,
            margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
            ),
            child: GestureDetector(
              onTap: () {
                if (_isIOS) {
                  Share.share(S.current.download_app +
                      IConstants.APP_NAME +
                      '${S.current.from_app_store} https://apps.apple.com/us/app/id' + IConstants.appleId);
                } else {
                  Share.share('Check out '+store.singelproduct!.itemName.toString()  +' on '+IConstants.APP_NAME+". "+"\n"+dynamicUrl.toString());
                }
              },
              child: Icon(
                Icons.share_outlined,
                size: 20,
                color: ColorCodes.iconColor,
              ),
            ),
          ),
        if(Features.isShare)
        SizedBox(width: 15,),
        if(Features.isShoppingList && !Features.ismultivendor)
          (PrefUtils.prefs!.containsKey("apikey"))?
          Container(
          width: 25,
          height: 25,
          margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
          ),
          child: GestureDetector(
            onTap: () {
              if (shoplistData.length <= 0) {
                _dialogforCreatelistTwo(context, shoplistData);
              } else {
                _dialogforShoppinglistTwo(context);
              }
            },
            child: Image.asset(
              Images.addToListImg,width: 25,height: 25,color: ColorCodes.iconColor),
          ),
        ):
        SizedBox.shrink(),
        if(Features.isShoppingList)
        SizedBox(
          width: 15,
        ),
        VxBuilder(
          mutations: {SetCartItem},
          builder: (context, store, index) {
            final box = (VxState.store as GroceStore).CartItemList;
            if (box.isEmpty)
              return GestureDetector(
                onTap: () {
                  Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10, right: 10, bottom: 10),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                     ),
                  child:   Image.asset(
                    Features.ismultivendor?Images.MultivendorCart:Images.header_cart,
                    height: 28,
                    width: 28,
                    color: ColorCodes.iconColor,
                  ),
                ),
              );
            return Consumer<CartCalculations>(
              builder: (_, cart, ch) => Badge(
                child: ch!,
                color:  ColorCodes.badgecolor,
                value: CartCalculations.itemCount.toString(),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10, right: 10, bottom: 10),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                     ),
                  child: Image.asset(
                    Features.ismultivendor ? Images.MultivendorCart : Images.header_cart,
                    height: 28,
                    width: 28,
                    color: ColorCodes.iconColor,
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(width: 10,)
      ],
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  ColorCodes.appbarColor,
                  ColorCodes.appbarColor2
                ])
        ),
      ),
    );
  }

  @override
  onloaddata() {
    productBox =(VxState.store as GroceStore).CartItemList;
    Future.delayed(Duration.zero, () async {
      iphonex = _isIOS ? MediaQuery.of(context).size.height >= 812.0 : false;
      checkskip = !PrefUtils.prefs!.containsKey('apikey');
      _product = ProductRepo().getRecentProduct(widget._productID.toString());
      ProductController().getprodut(widget._varid.toString(),"").whenComplete(() {
        createShareLink(widget._varid,widget._productID);
        setState(() {
          _isLoading= false;
        });
      });
      final now = new DateTime.now();
      currentDate = DateFormat('dd/MM/y').format(now);
    });
    // TODO: implement onloaddata
  }
}