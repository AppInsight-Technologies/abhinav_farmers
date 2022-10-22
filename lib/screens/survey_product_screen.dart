import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../assets/ColorCodes.dart';
import '../assets/images.dart';
import '../constants/IConstants.dart';
import '../constants/features.dart';
import '../controller/mutations/cart_mutation.dart';
import '../controller/mutations/cat_and_product_mutation.dart';
import '../data/calculations.dart';
import '../generated/l10n.dart';
import '../models/VxModels/VxStore.dart';
import '../models/newmodle/cartModle.dart';
import '../models/newmodle/product_data.dart';
import '../repository/productandCategory/category_or_product.dart';
import '../rought_genrator.dart';
import '../utils/ResponsiveLayout.dart';
import '../utils/prefUtils.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../widgets/simmers/checkout_screen.dart';

class SurveyProductScreen extends StatefulWidget{
  @override
  State<SurveyProductScreen> createState() => _SurveyProductScreenState();
}

class _SurveyProductScreenState extends State<SurveyProductScreen> with Navigations {
bool _isLoading = true;
late Future<List<ItemData>> _futureCustomerEngagementSurvey = Future.value([]);
int _selectedOffer = -1;
List<CartItem> productBox=[];
bool _isAddToCart = false;
bool _checkmembership = false;
String itemFeaturedImage="";
String type ="";
String CatId ="";
String price ="";
String eligibleForExpress = "";
String vegType = "";
String delivery = "";
String duration = "";
String brand = "";
String id = "";
String itemName = "";
String durationd = "";
String durationType = "";
bool membershipDisplayitem =  false;
bool discointDisplay = false;
int loyaltys = 0;
bool membershipDisplay = false;
String menuItemId = "";
String netWeight = "";
String weight = "";
String pid = "";
String variationName = "";
String unit = "";
String minItem = "";
String maxItem = "";
String minItemSing = "";
String maxItemSing = "";
String increment = "";
String status = "";
double stock = 0.0;
String mrp = "";
String priceSin = "";
String membershipPrice = "";

  @override
  void initState() {
    // TODO: implement initState

    if (VxState.store.userData.membership! == "1") {
      _checkmembership = true;
    } else {
      _checkmembership = false;
    }

    ProductRepo().getSurveytProductLists().then((value) {
      setState(() {
        _futureCustomerEngagementSurvey = Future.value(value);
        _isLoading = false;
      });

      _futureCustomerEngagementSurvey.then((value) {
        for (int j = 0; j < value.length; j++) {

          itemFeaturedImage = value[j].itemFeaturedImage!;
          type = value[j].type!;
          eligibleForExpress = value[j].eligibleForExpress!;
          vegType = value[j].vegType!;
          delivery = value[j].delivery!;
          duration = value[j].duration!;
          brand = value[j].brand!;
          id = value[j].id!;
          itemName = value[j].itemName!;
          minItemSing = value[j].minItem!;
          maxItemSing = value[j].maxItem!;
          increment = value[j].increament!;
          status = value[j].status!;
          duration = value[j].deliveryDuration.duration!;
          durationType = value[j].deliveryDuration.durationType!;
          membershipDisplayitem = value[j].membershipDisplay!;
          CatId = value[j].categoryId!;
          if(value[j].type == "1")
            priceSin = value[j].price!;
          for(int i= 0;i<value[j].priceVariation!.length; i++) {
            discointDisplay = value[j].priceVariation![i].discointDisplay!;
            loyaltys = value[j].priceVariation![i].loyalty!;
            membershipDisplay = value[j].priceVariation![i].membershipDisplay!;
            menuItemId = value[j].priceVariation![i].id!;
            netWeight = value[j].priceVariation![i].netWeight!;
            weight = value[j].priceVariation![i].weight!;
            pid = value[j].priceVariation![i].id!;
            variationName = value[j].priceVariation![i].variationName!;
            unit = value[j].priceVariation![i].unit!;
            minItem = value[j].priceVariation![i].minItem!;
            maxItem = value[j].priceVariation![i].maxItem!;
            stock = value[j].priceVariation![i].stock!;
            mrp = value[j].priceVariation![i].mrp!;
            price = value[j].priceVariation![i].price!;
            membershipPrice = value[j].priceVariation![i].membershipPrice!;
          }

          if(value[j].type =="1")
            cartcontroller.addtoCart(itemdata: ItemData(loyalty: value[j].loyalty,
                mrp: value[j].mrp,
                membershipPrice: value[j].membershipPrice,
                regularPrice: value[j].regularPrice,
                salePrice:value[j].salePrice,
                status:status,increament:increment,minItem:minItemSing,
                maxItem:maxItemSing,categoryId:CatId,itemFeaturedImage: itemFeaturedImage,type: type,eligibleForExpress: eligibleForExpress,vegType:vegType,delivery: delivery,price: priceSin,
                duration: duration,stock: value[j].stock!,brand: brand,id: id,itemName: itemName,mode: "3",deliveryDuration:DeliveryDurationData(duration:durationd,status: "",durationType: durationType,note: "", id: "",branch: "",blockFor: "") ), onload: (onload){

              setState(() {
                _isAddToCart = onload;
              });
              setState(() {
                _isAddToCart = false;

              });
            },topping_type: "",varid: "",toppings: "0",parent_id: "",newproduct: "0",toppingsList: [],itembody: PriceVariation(quantity: 1,mode: "3",status: "0",discointDisplay: discointDisplay,
                loyaltys: 0,membershipDisplay: membershipDisplayitem,menuItemId: menuItemId,
                netWeight: "",weight: "",id: id,variationName: "",unit:"",minItem:minItemSing,
                maxItem:maxItemSing,loyalty: value[j].loyalty,stock: double.parse(value[j].stock.toString()), mrp: value[j].mrp,
                price: value[j].regularPrice, membershipPrice: value[j].membershipPrice),context: context);
          else

            cartcontroller.addtoCart(itemdata: ItemData(loyalty: value[j].loyalty,status:status,increament:increment,minItem:minItemSing, maxItem:maxItemSing,categoryId:CatId,itemFeaturedImage: itemFeaturedImage,type:type,eligibleForExpress: eligibleForExpress,vegType:vegType,delivery: delivery,price: priceSin,
                duration: duration,brand: brand,stock: value[j].stock!,id: id,itemName: itemName,mode: "3",deliveryDuration:DeliveryDurationData(duration:durationd,status: "",durationType: durationType,note: "", id: "",branch: "",blockFor: "") ), onload: (onload){

              setState(() {
                _isAddToCart = onload;
              });
              setState(() {
                _isAddToCart = false;

              });
            },topping_type: "",varid: "",toppings: "0",parent_id: "",newproduct: "0",toppingsList: [],itembody:
            PriceVariation(quantity: 1,mode: "3",status: "0",discointDisplay: discointDisplay,
                loyaltys: loyaltys,membershipDisplay: membershipDisplay,menuItemId: menuItemId,
                netWeight: netWeight,weight: weight,id: pid,variationName: variationName,
                unit:unit,minItem: minItem,maxItem:maxItem,
                loyalty: 0,stock: stock,mrp: mrp,
                price: price,membershipPrice: membershipPrice),context: context);
        }
      });



    });
    super.initState();
  }
removeToCart() async {
    debugPrint("remove...");
  String?  varId, price;
  productBox = (VxState.store as GroceStore).CartItemList;
  try {
    for (int i = 0; i < productBox.length; i++) {
      debugPrint("remove...1");
      if (productBox[i].mode =="3") {
        debugPrint("remove...2");
        varId =  productBox[i]
            .varId
            .toString();
        debugPrint("remove...3"+productBox[i].parent_id!);
        price = productBox[i]
            .price
            .toString();


        cartcontroller.update((done){
          debugPrint("update...");
          setState(() {
            _isAddToCart = !done;
          });
        },price: double.parse(price).toString(),var_id:varId,quantity: "0",weight: "0", cart_id: productBox[i].parent_id!,toppings: "",
          topping_id: "",);
        break;
      }
    }

  }catch(e){

  }
}
_buildBottomNavigationBar() {
  return VxBuilder(
    mutations: {SetCartItem},
    builder: (context, store, index) {
      final box = (VxState.store as GroceStore).CartItemList;
      if (box.isEmpty) return SizedBox.shrink();
      return  BottomNaviagation(
        itemCount: CartCalculations.itemCount.toString() + " " + S.of(context).items,
        title: S.current.view_cart,
        total: _checkmembership ? (CartCalculations.totalMember).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)
            :
        (CartCalculations.total).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
        onPressed: (){
          Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
        },
      );
    },
  );
}


  gradientappbarmobile() {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: (IConstants.isEnterprise)?0:1,
      leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorCodes.iconColor),
          onPressed: () {
           // Navigator.of(context).pop();
            Navigation(context, navigatore: NavigatoreTyp.homenav);
          }),
      titleSpacing: 0,
      title: Text(
       S.of(context).survey_product,// "Survey Product",
        style: TextStyle(color: ColorCodes.iconColor, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  ColorCodes.appbarColor,
                  ColorCodes.appbarColor2
                ])),
      ),
    );
  }

Widget _surveyProduct() {

  double deviceWidth = MediaQuery.of(context).size.width;
  int widgetsInRow = 3;
  double aspectRatio = (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 125;

  if (deviceWidth > 1200) {
    widgetsInRow = 5;
    aspectRatio =
        (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 295;
  } else if (deviceWidth > 768) {
    widgetsInRow = 4;
    aspectRatio =
        (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 195;
  }
  return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: AlwaysScrollableScrollPhysics(),
      child: Container(
          color: ColorCodes.whiteColor,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(
              top: 8.0, left: 20.0, right: 20.0, bottom: 8.0),
          child:FutureBuilder<List<ItemData>>(
            future: _futureCustomerEngagementSurvey,
            builder: (BuildContext context,AsyncSnapshot<List<ItemData>> snapshot){
              final CustomerEngagementSurvey = snapshot.data;

              return (CustomerEngagementSurvey != null)?
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        Images.Offer,
                        height: 25.0,
                        width: 25.0,
                      ),
                      SizedBox(width: 10,),
                      Text(
                       S.of(context).qualified_free_product,//"You are qualified for free Product!",
                        style: TextStyle(
                            color: ColorCodes.greenColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height:10),
                  SizedBox(
                    // height: 190,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: CustomerEngagementSurvey.length,
                      itemBuilder: (_, i) =>  Container(
                          width: 150.0,
                          // padding: EdgeInsets.all(10.0),
                          padding: Vx.isWeb?EdgeInsets.symmetric(horizontal: 200):EdgeInsets.all(0),
                          margin: EdgeInsets.only(top: 5.0, right: 10.0, bottom: 5.0),
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.all(new Radius.circular(2.0)),
                          ),

                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  width:MediaQuery.of(context).size.width,
                                  height: 100,
                                  decoration: BoxDecoration(
                                  ),
                                  margin: EdgeInsets.all(5),
                                  child:Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment: Vx.isWeb?MainAxisAlignment.center:MainAxisAlignment.start,
                                        children: [
                                          SizedBox(width: 10,),
                                          CachedNetworkImage(
                                            imageUrl: CustomerEngagementSurvey[i].itemFeaturedImage,
                                            placeholder: (context, url) =>
                                                Image.asset(
                                                  Images.defaultProductImg,
                                                  width: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                                  height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                                ),
                                            errorWidget: (context, url, error) => Image.asset(
                                              Images.defaultProductImg,
                                              width: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                              height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                            ),
                                            width: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                            height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                            fit: BoxFit.fill,
                                          ),
                                          SizedBox(width: 5,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(CustomerEngagementSurvey[i].brand!,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    // fontWeight: FontWeight.bold,
                                                  )),
                                              Container(
                                                height: 45,
                                                width: MediaQuery.of(context).size.width/2,
                                                child: Text(CustomerEngagementSurvey[i].itemName!,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                    )),
                                              ),
                                  //
                                  //              Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  //   children: [
                                  //     VxBuilder(
                                  //         mutations: {ProductMutation},
                                  //         builder: (context, GroceStore box, _) {
                                  //           if ( _selectedOffer == i)
                                  //             return Container(
                                  //               height: 25,
                                  //               width: MediaQuery.of(context).size.width/4,
                                  //               decoration: BoxDecoration(
                                  //               ),
                                  //               child: Row(
                                  //                 children: [
                                  //                   GestureDetector(
                                  //                     onTap:(){
                                  //                       setState(() {
                                  //                         _selectedOffer=-1;
                                  //                         removeToCart();
                                  //                       });
                                  //                     },
                                  //                     child: Container(
                                  //                         width: 30,
                                  //                         height: 25,
                                  //                         decoration: new BoxDecoration(
                                  //                           border: Border.all(
                                  //                             color: ColorCodes.lightblue,
                                  //                             width: 2,
                                  //                           ),
                                  //                           borderRadius:
                                  //                           new BorderRadius.only(
                                  //                             bottomLeft:
                                  //                             const Radius.circular(
                                  //                                 3),
                                  //                             topLeft:
                                  //                             const Radius.circular(
                                  //                                 3),
                                  //                           ),
                                  //                         ),
                                  //                         child: Center(
                                  //                           child: Text(
                                  //                             "-",
                                  //                             textAlign: TextAlign
                                  //                                 .center,
                                  //                             style: TextStyle(
                                  //                               fontSize: 18,
                                  //                               color:ColorCodes.lightblue,
                                  //                             ),
                                  //                           ),
                                  //                         )),
                                  //                   ),
                                  //                   Spacer(),
                                  //                   Container(
                                  //                       child:Center(
                                  //                         child:Text("1",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: ColorCodes.lightblue),),
                                  //                       )
                                  //                   ),
                                  //                   Spacer(),
                                  //                   GestureDetector(
                                  //                       onTap: (){
                                  //
                                  //                       },
                                  //                       child:Container(
                                  //                           width: 30,
                                  //                           height: 25,
                                  //                           decoration: new BoxDecoration(
                                  //                             border: Border.all(
                                  //                               color: ColorCodes.lightblue,
                                  //                               width: 2,
                                  //                             ),
                                  //                             borderRadius:
                                  //                             new BorderRadius.only(
                                  //                               bottomRight:
                                  //                               const Radius.circular(
                                  //                                   3),
                                  //                               topRight:
                                  //                               const Radius.circular(
                                  //                                   3),
                                  //                             ),
                                  //                           ),
                                  //                           child: Center(
                                  //                             child: Text(
                                  //                               "+",
                                  //                               textAlign: TextAlign
                                  //                                   .center,
                                  //                               style: TextStyle(
                                  //                                 fontSize: 18,
                                  //                                 color:ColorCodes.lightblue,
                                  //                               ),
                                  //                             ),
                                  //                           ))),
                                  //                 ],
                                  //               ),
                                  //             );
                                  //           else return VxBuilder(
                                  //               mutations: {SetCartItem},
                                  //               // valueListenable: Hive.box<Product>(productBoxName).listenable(),
                                  //               builder: (context,GroceStore store, index)
                                  //               {
                                  //                 final box = (VxState
                                  //                     .store as GroceStore)
                                  //                     .CartItemList;
                                  //                 return GestureDetector(
                                  //                     onTap: () {
                                  //                       setState(() {
                                  //                         _selectedOffer =
                                  //                             i;
                                  //                         CustomerEngagementSurvey[i].quantity = "1";
                                  //                         _addToCart();
                                  //                       });
                                  //
                                  //                     },
                                  //                     child: Container(
                                  //                       height: 25,
                                  //                       width: MediaQuery
                                  //                           .of(context)
                                  //                           .size
                                  //                           .width / 4,
                                  //                       decoration: BoxDecoration(
                                  //                           border: Border
                                  //                               .all(
                                  //                               color: ColorCodes
                                  //                                   .lightblue,
                                  //                               width: 2)
                                  //                       ),
                                  //                       child: Center(
                                  //                           child: Text(
                                  //                             'ADD',
                                  //                             style: TextStyle(
                                  //                                 fontWeight: FontWeight
                                  //                                     .bold,
                                  //                                 color: ColorCodes
                                  //                                     .lightblue,
                                  //                                 fontSize: 18),)),
                                  //                     )
                                  //                 );
                                  //               });
                                  //
                                  //         }),
                                  //   ],
                                  // ),
                                            ],
                                          ),
                                        ],

                                      ))),

                            ],
                          )
                      ),
                      //  ),
                    ),

                  ),
                  if(Vx.isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
                ],
              ):
              // Column(
              //   children: [
              //     Container(
              //       height: MediaQuery.of(context).size.height /1.5,
              //       child: Center(
              //         child: new Image.asset(
              //           Images.noItemImg,
              //           fit: BoxFit.fill,
              //           height: 250.0,
              //           width: 200.0,
              //         ),
              //       ),
              //     ),
              //     if(Vx.isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
              //   ],
              // )
              Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              SizedBox(height: MediaQuery.of(context).size.height/8,),
              new Image.asset(
              Images.noItemImg,
                fit: BoxFit.fitHeight,
                height: 200.0,
              ),
              Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Text(S.of(context).no_product,style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              ),),
              ),
              Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(S.of(context).find_item,
              style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w500,color:ColorCodes.grey),),
              ),
              ],
              );
              },
          ))
  );
}

_body(){

  return (_isLoading)? CheckOutShimmer() :

  _surveyProduct()
  ;
}
  @override
  Widget build(BuildContext context) {
   return WillPopScope(
     onWillPop: (){
      // Navigator.of(context).pop();
       Navigation(context,navigatore: NavigatoreTyp.homenav);
       return Future.value(false);
     },
     child: Scaffold(
        appBar: ResponsiveLayout.isSmallScreen(context)
            ? gradientappbarmobile()
            : null,
        backgroundColor: ColorCodes.whiteColor,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
                Header(false),
              _body(),
            ],
          ),
        ),
       bottomNavigationBar:  Vx.isWeb ? SizedBox.shrink() :Container(
         color: Colors.white,
         child: Padding(
             padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom:  0.0),
             child: _buildBottomNavigationBar()
         ),
       ),
      ),
   );
  }
}