import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grocbay/widgets/flutter_flow/flutter_flow_theme.dart';
import '../../repository/productandCategory/category_or_product.dart';
import '../../widgets/SliderShimmer.dart';
import '../../components/sellingitem_component.dart';
import '../controller/mutations/cart_mutation.dart';
import '../controller/mutations/cat_and_product_mutation.dart';
import '../models/VxModels/VxStore.dart';
import '../models/newmodle/category_modle.dart';
import '../models/newmodle/home_page_modle.dart';
import '../rought_genrator.dart';
import '../widgets/product_request.dart';
import '../widgets/simmers/ItemWeb_shimmer.dart';
import 'package:velocity_x/velocity_x.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/simmers/item_list_shimmer.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../data/calculations.dart';
import '../assets/images.dart';
import '../widgets/expansion_drawer.dart';
import '../utils/ResponsiveLayout.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../assets/ColorCodes.dart';
import '../utils/prefUtils.dart';
import '../constants/IConstants.dart';
import '../constants/features.dart';
import '../generated/l10n.dart';

class ItemsScreen extends StatefulWidget {
  static const routeName = '/items-screen';
  Map<String,String> params;
  ItemsScreen(this.params);
  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin,Navigations{
  int startItem = 0;
  bool isLoading = true;
  var load = true;
  bool _initLoad = true;
  int previndex = -1;
  var subcategoryData;
  ItemScrollController _scrollController = ItemScrollController();
  String subCategoryId = "";
  int subcatType = 0;
  bool _isOnScroll = false;
  String maincategory = "";
  String subcatTitle="";
  bool endOfProduct = false;
  bool _checkmembership = false;
  var parentcatid;
  var subcatidinitial;
  String? indvalue;
  int indexvalue = 0;
  MediaQueryData? queryData;
  double? wid;
  double? maxwid;
  String? subcatid;
  String? catId;
  String? _nosub;
  bool iphonex = false;
  int _groupValue = 1;
  bool visiblerefine= true;
  bool visiblesort = false;
  ProductController productController = ProductController();
  List<CategoryData> nestedCategory=[];
  List<CategoryData> subcatData=[];
  var subcatId;
  int index = 0;
  int selected = -1;
  int indexvalues = 0;
  Future<List<CategoryData>>? _futureNestitem ;

  List<CategoryData> ListofNest=[];
  List<CategoryData> subNestCategory=[];

  void Function(VoidCallback fn)? expansionState;

  _displayitem(String catid, int index, int type, String initial) {
    print("cat id....."+catid.toString() + "...."+index.toString() + "...."+type.toString() + "////"+initial.toString());
    setState(() {
      isLoading = true;
      subcatType = type;
      subCategoryId = catid;
      indvalue =  index.toString();
    });
    productController.getCategoryprodutlist(catid, initial,type,(isendofproduct){
      setState(() {
        isLoading = false;
        indvalue =  index.toString();
        endOfProduct = false;
      });
    },isexpress: (_groupValue!=1));
  }

  @override
  void initState() {
   initialRoute((){
     Future.delayed(Duration.zero, () async {
       setState(() {
         if (PrefUtils.prefs!.getString("membership") == "1") {
           _checkmembership = true;
         } else {
           _checkmembership = false;
         }
       });
       subcatId = widget.params['subcatId'];
       catId = widget.params['catId'].toString();
       subcatidinitial= widget.params['subcatId'];
       subCategoryId=widget.params['subcatId']!;
       parentcatid=widget.params['catId'].toString();
       indvalue = (widget.params['indexvalue']??"0");
       index = int.parse(widget.params['indexvalue']!);
       indexvalue = int.parse(widget.params['indexvalue']!);
       _nosub = widget.params['nosub'].toString();
       maincategory = widget.params['maincategory']!;
       _initLoad =false;
       Future.delayed(Duration.zero, () async {
         productController.geSubtCategory(parentcatid,onload: (status){
         });
           ProductRepo().getSubNestcategory(subcatId.toString()).then((value) {
             setState(() {
               _futureNestitem = Future.value(value);
               ListofNest = value.where((element) => element.categoryName!.toLowerCase().trim()!="all").toList();
               if(value.length==1){
                 subcatId=subcatId;
               }else{
                 subcatId= ListofNest.first.id;
               }
             });
             _displayitem(subcatId.toString(), ListofNest.length>0?int.parse(/*"0"*/indvalue!)+1:(_nosub == "true"&& VxState.store.homescreen.data!.allCategoryDetails![index].categoryType == 0)?int.parse("0"):int.parse(/*"0"*/indvalue!)+1,0,"0");
           });
       });
     });
   });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget itemsWidget() {
    final homedata = (VxState.store as GroceStore).homescreen;
    double deviceWidth = MediaQuery.of(context).size.width;
    int widgetsInRow =  (kIsWeb && !ResponsiveLayout.isSmallScreen(context)) ? 2 : 1;

    if (deviceWidth > 1200) {
      widgetsInRow = 5;
    } else if (deviceWidth > 768) {
      widgetsInRow = 3;
    }
    double aspectRatio =   (kIsWeb && !ResponsiveLayout.isSmallScreen(context))?
    (Features.isSubscription)?(deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 430:
    (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 430 :
    (!Features.ismultivendor) ? (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 165 : Features.btobModule?(deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 219:(deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 165;

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        VxBuilder(
          mutations: {ProductMutation},
          builder: (ctx, store,VxStatus? state){
            nestedCategory = store!.homescreen.data!.allCategoryDetails!.where((element) => element.id == parentcatid).first.subCategory;
            for(int i = 0; i < nestedCategory.length; i++) {
              if(nestedCategory[i].id == subCategoryId){
                indvalue = i.toString();
              }
            }
            Future.delayed(const Duration(seconds: 1), () async {
              _scrollController.jumpTo(index: int.parse(indvalue.toString()));
            });
            final productlist = store.productlist;
            return    (isLoading) ?
            Center(
              child: (kIsWeb && !ResponsiveLayout.isSmallScreen(context))
                  ? ItemListShimmerWeb()
                  : ItemListShimmer(),
            ) :
            (productlist.length>0)
                ? ResponsiveLayout.isExtraLargeScreen(context) ?
            Column(
              children: <Widget>[
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child:
                  GridView.builder(
                      shrinkWrap: true,
                      controller: new ScrollController(
                          keepScrollOffset: false),
                      itemCount: productlist.length,
                      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: widgetsInRow,
                        crossAxisSpacing: 3,
                        childAspectRatio: aspectRatio,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return SellingItemsv2(
                          fromScreen: "item_screen",
                          seeallpress: "",
                          itemdata: productlist[index],
                          notid: "",
                          returnparm: {
                            'maincategory': widget.params['maincategory']!,
                            'catId': catId!,
                            'catTitle': widget.params['catTitle']!,
                            'subcatId': subcatId,
                            'indexvalue': widget.params['indexvalue']!,
                            'prev': widget.params['prev']!,
                          },
                        );
                      }),
                ),
                if (endOfProduct)
                  Features.suggestproduct ?
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.black12,
                      ),
                      margin: EdgeInsets.only(top: 10.0),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: _footer(homedata)
                  ) : Container(
                    decoration: BoxDecoration(
                      color: Colors.black12,
                    ),
                    margin: EdgeInsets.only(top: 10.0),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    padding: EdgeInsets.only(
                        top: 25.0, bottom: 25.0),
                    child: Text(
                      S
                          .of(context)
                          .thats_all_folk, // "That's all folks!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
              ],
            )
                : Column(
                  children: [
                    SingleChildScrollView(
              child: Column(
                    children: <Widget>[

                      if(!Vx.isWeb)
                        if(nestedCategory[int.parse(indvalue.toString())].banner!=null&&nestedCategory[int.parse(indvalue.toString())].banner!="")
                          CachedNetworkImage(
                              imageUrl: nestedCategory[int.parse(indvalue.toString())].banner??"",
                              placeholder: (context, url) {
                                return SliderShimmer().sliderShimmer(context, height: 180);
                              },
                              errorWidget: (context, url, error) => Image.asset(Images.defaultSliderImg),
                              fit: BoxFit.fitWidth),

                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child:
                        GridView.builder(
                            shrinkWrap: true,
                            controller: new ScrollController(
                                keepScrollOffset: false),
                            itemCount: productlist.length,
                            gridDelegate:
                            new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: widgetsInRow,
                              crossAxisSpacing: 3,
                              childAspectRatio: aspectRatio,
                              mainAxisSpacing: 3,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                               return SellingItemsv2(
                                fromScreen: "item_screen",
                                seeallpress: "",
                                 itemdata: productlist[index],
                                notid: "",
                                returnparm: {
                                  'maincategory': maincategory,
                                  'catId': catId!,
                                  'catTitle': subcatTitle,
                                  'subcatId': subcatId,
                                  'indexvalue': index.toString(),
                                  'prev': widget.params['prev'].toString(),
                                },
                              ) ;
                            }),

                      ),
                      if (endOfProduct)
                        Features.suggestproduct ?
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.black12,
                            ),
                            margin: EdgeInsets.only(top: 10.0),
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            child: _footer(homedata)
                        ) : Container(
                          decoration: BoxDecoration(
                            color: Colors.black12,
                          ),
                          margin: EdgeInsets.only(top: 10.0),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          padding: EdgeInsets.only(
                              top: 25.0, bottom: 25.0),
                          child: Text(
                            S
                                .of(context)
                                .thats_all_folk, // "That's all folks!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                    ],
              ),
            ),
                  ],
                )
                :
            Center(
              child: Column(
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
                      )
                    ],
                  ),
            );
          },
        ),

        if(!kIsWeb) Container(
          height: _isOnScroll ? 50 : 0,
          child: Center(
            child: new CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }

  Widget _myRadioButton({int? value, Function(int)? onChanged}) {
    return Radio<int>(
      activeColor: Theme.of(context).primaryColor,
      value: value!,
      groupValue: _groupValue,
      onChanged:(int) =>onChanged!(int!),
    );
  }

  _dialogsetExpress() async{
    Navigator.of(context).pop(true);
    setState(() {
      load = false;
    });
  }

  ShowpopupForRadioButton(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter setState1) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: Container(
              height: 200,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 5,),
                  Container(
                    child: Text(S.current.select_option, style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                  ),
                  SizedBox(height: 10,),
                  ListTile(
                    dense: true,
                    leading:  Container(

                      child: _myRadioButton(
                        value: 1,
                        onChanged: (newValue) {
                          setState1(() {
                            _groupValue = newValue;

                              load = true;

                              _dialogsetExpress();

                          });
                        },
                      ),
                    ),
                    contentPadding: EdgeInsets.all(0.0),
                    title:  Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 50 /100,
                          child: Text(
                              S.current.all_product,
                              style: TextStyle(
                                  color: ColorCodes.blackColor,
                                  fontSize: 16, fontWeight: FontWeight.bold
                              )
                          ),
                        ),

                      ],
                    ),
                  ),
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.all(0.0),
                    leading: Container(
                      child: _myRadioButton(
                        value: 2,
                        onChanged: (newValue) {
                          setState1(() {
                            _groupValue = newValue;
                            load = true;

                            _dialogsetExpress();
                          });
                        },
                      ),
                    ),
                    title:
                    Row(
                      children: [
                        Container(

                          child: Text(
                              S.current.express_delivery,
                              style: TextStyle(
                                  color: ColorCodes.blackColor,
                                  fontSize: 16, fontWeight: FontWeight.bold
                              )
                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          child: Text(S.current.cancel, style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
                        ),
                      ),
                      SizedBox(width: 20,),
                    ],
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          );
        });

      },
    );
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    wid= queryData!.size.width;
    maxwid=wid!*0.90;
    _buildBottomNavigationBar() {
      return VxBuilder(
          mutations: {SetCartItem},
          builder: (context, store, index) {
            final box = (VxState.store as GroceStore).CartItemList;
            if (box.isEmpty) return SizedBox.shrink();
          return BottomNaviagation(
            itemCount: CartCalculations.itemCount.toString() + " " + S.of(context).items,
            title: S.current.view_cart,
            total: _checkmembership ? (CartCalculations.totalMember).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)
                :
            (CartCalculations.total).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
            onPressed: (){
              Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
            },
          );
        }
      );
    }
    PreferredSizeWidget _appBarMobile() {
      return AppBar(
        elevation: (IConstants.isEnterprise)?0:1,
        automaticallyImplyLeading: false,
        title: Text(maincategory,style: TextStyle(color: ColorCodes.iconColor, fontWeight: FontWeight.bold, fontSize: 18),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorCodes.iconColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          if(Features.isFilter)
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                _showBottomSheet();
              },
              child: Container(
                margin: EdgeInsets.only(top: 15, right: 10, bottom: 15),
                width: 60,
                height: 25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                ),

                child: Row(
                  children: [
                    Text(S.of(context).filter, style: TextStyle(fontSize: 13, color: ColorCodes.iconColor, fontWeight: FontWeight.bold),),
                    SizedBox(width: 4,),
                    Image.asset(
                      Images.filter,
                      color: ColorCodes.iconColor,
                      height: 14,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
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
    Widget _body(){
      return _initLoad
          ? Center(child: (kIsWeb && !ResponsiveLayout.isSmallScreen(context))?ItemListShimmerWeb():ItemListShimmer(),)
          :  itemsWidget();
    }
    _bodyweb(){
      return
        NotificationListener<
            ScrollNotification>(
          // ignore: missing_return
          onNotification:
              (ScrollNotification scrollInfo) {
            if (!endOfProduct) if (!_isOnScroll &&
                // ignore: missing_return
                scrollInfo.metrics.pixels ==
                    scrollInfo
                        .metrics.maxScrollExtent) {
              setState(() {
                _isOnScroll = true;
              });
              productController.getCategoryprodutlist(subCategoryId, (VxState.store as GroceStore).productlist.length,subcatType,(isendofproduct){
                endOfProduct = isendofproduct;
                if(endOfProduct){

                  setState(() {
                    isLoading = false;
                    _isOnScroll = false;
                    endOfProduct = true;
                  });
                }else {
                  setState(() {
                    isLoading = false;
                    _isOnScroll = false;
                    endOfProduct = false;
                  });
                }
              },isexpress: _groupValue==1?false:true);
              setState(() {
                isLoading = false;
              });
            }
            return true;
          },
          child: SingleChildScrollView(
              child:
              Column(
                children: [
                  if(kIsWeb && !ResponsiveLayout.isSmallScreen(context))
                    Header(false,),
                   Container(
                     constraints: (Vx.isWeb &&
                         !ResponsiveLayout.isSmallScreen(context))
                         ? BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.90)
                         : null,
                    padding: EdgeInsets.only(top:(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?40:0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        if(kIsWeb && !ResponsiveLayout.isSmallScreen(context))
                          if(subcatidinitial!=null&& parentcatid!=null)
                            ExpansionDrawer(parentcatid,subcatidinitial,widget.params['catTitle']!,onclick:(catid,type,index){
                              setState(() {
                                isLoading = false;
                                endOfProduct = false;
                              });
                                _displayitem(catid.toString(),index,0,"0");
                            }),
                        SizedBox(width: 15,),
                        Flexible(
                            child:
                            Padding(
                              padding: EdgeInsets.only(top: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?20:0),
                              child: _body(),
                            )
                        ),
                      ],
                    ),
                  ),
                  if (kIsWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
                ],
              )
          ),
        );
    }

    return DefaultTabController(
      length: ListofNest.length >0?ListofNest.length:nestedCategory.length,
      child: Scaffold(

        appBar: ResponsiveLayout.isSmallScreen(context) ?_appBarMobile():PreferredSize(preferredSize: Size.fromHeight(0),child: SizedBox.shrink()),
        backgroundColor: ColorCodes.whiteColor,
        body:
        (kIsWeb )?
        _bodyweb():
        Column(
          children: [
            if(!kIsWeb)
              VxBuilder(
                  mutations: {ProductMutation},
                  builder: (ctx,store,VxStatus? state) {
                    parentcatid = widget.params['catId'].toString();
                    nestedCategory =
                        store!.homescreen.data!.allCategoryDetails!.where((
                            element) {
                          return element.id == parentcatid;
                        }).first.subCategory;

                       if(ListofNest.length >0){
                         {
                           return isLoading ? SizedBox.shrink() : Column(
                             children: [
                               Container(
                                 padding: EdgeInsets.only(top: 15),
                                 color: Colors.white,
                                 child: SizedBox(
                                   height: 60,
                                   child: ScrollablePositionedList.builder(
                                     itemScrollController: _scrollController,
                                     scrollDirection: Axis.horizontal,
                                     itemCount:
                                     ListofNest
                                         .length ,
                                     itemBuilder: (_, i) =>
                                         Column(
                                           children: [
                                             SizedBox(
                                               width: 10.0,
                                             ),
                                             MouseRegion(
                                               cursor: SystemMouseCursors.click,
                                               child: GestureDetector(
                                                 onTap: () {
                                                   _displayitem(
                                                       ListofNest[i].id!, i,
                                                       ListofNest[i].type!,
                                                       "0");
                                                   Future.delayed(const Duration(seconds: 1), () async {
                                                     _scrollController.jumpTo(index: int.parse(i.toString()));
                                                   });
                                                 },
                                                 child: Container(
                                                   height: 45,
                                                   margin:
                                                   EdgeInsets.only(
                                                       left: 5.0, right: 5.0),
                                                   decoration: BoxDecoration(
                                                       color: Colors.white,
                                                       borderRadius: BorderRadius
                                                           .circular(6),
                                                       border: Border.all(
                                                         width: 1.0,
                                                         color: i.toString() !=
                                                             index
                                                                 .toString()
                                                             ? ColorCodes.grey
                                                             : ColorCodes
                                                             .greenColor
                                                       )),
                                                   child: Padding(
                                                     padding:
                                                     EdgeInsets.only(
                                                         left: 5.0, right: 5.0),
                                                     child: Row(
                                                       crossAxisAlignment:
                                                       CrossAxisAlignment.center,
                                                       mainAxisAlignment:
                                                       MainAxisAlignment.center,
                                                       children: <Widget>[
                                                         CachedNetworkImage(
                                                           imageUrl: ListofNest[i]
                                                               .iconImage,
                                                           placeholder: (context,
                                                               url) =>
                                                               Image.asset(
                                                                 Images
                                                                     .defaultCategoryImg,
                                                                 height: 40,
                                                                 width: 40,
                                                               ),
                                                           errorWidget: (context,
                                                               url, error) =>
                                                               Image.asset(
                                                                 Images
                                                                     .defaultCategoryImg,
                                                                 width: 40,
                                                                 height: 40,
                                                               ),
                                                           height: 40,
                                                           width: 40,
                                                           fit: BoxFit.cover,
                                                         ),
                                                         SizedBox(
                                                           width: 5,
                                                         ),
                                                         Text(
                                                           ListofNest[i]
                                                               .categoryName!,
                                                           style: TextStyle(
                                                               fontWeight:
                                                               FontWeight.bold,
                                                               color: (i
                                                                   .toString() !=
                                                                   index
                                                                       .toString())
                                                                   ? ColorCodes
                                                                   .grey
                                                                   : ColorCodes
                                                                   .greenColor),
                                                         ),
                                                         SizedBox(
                                                           width: 5,
                                                         ),
                                                       ],
                                                     ),
                                                   ),
                                                 ),
                                               ),
                                             ),
                                             SizedBox(
                                               width: 10.0,
                                             ),
                                           ],
                                         ),
                                   ),
                                 ),
                               ),

                             ],
                           );
                         }
                       }
                       else {
                         if (nestedCategory.length > 0) {
                           return isLoading ? SizedBox.shrink() : Column(
                             children: [
                               Container(
                                 padding: EdgeInsets.only(top: 15),
                                 color: Colors.white,
                                 child: SizedBox(
                                   height: 60,
                                   child: ScrollablePositionedList.builder(
                                     itemScrollController: _scrollController,
                                     scrollDirection: Axis.horizontal,
                                     itemCount:
                                     nestedCategory
                                         .length,
                                     itemBuilder: (_, i) =>
                                         Column(
                                           children: [
                                             SizedBox(
                                               width: 10.0,
                                             ),
                                             MouseRegion(
                                               cursor: SystemMouseCursors.click,
                                               child: GestureDetector(
                                                 onTap: () {
                                                   _displayitem(
                                                       nestedCategory[i].id!, i,
                                                       nestedCategory[i].type!,
                                                       "0");
                                                   Future.delayed(const Duration(seconds: 1), () async {
                                                     _scrollController.jumpTo(index: int.parse(i.toString()));
                                                   });
                                                 },
                                                 child: Container(
                                                   height: 40,
                                                   margin:
                                                   EdgeInsets.only(
                                                       left: 5.0, right: 5.0),
                                                   decoration: BoxDecoration(
                                                       color: i.toString() !=
                                                           indvalue
                                                               .toString() ? Colors.white: ColorCodes.varcolor,
                                                       borderRadius: BorderRadius
                                                           .circular(6),
                                                       border: Border.all(
                                                         width: 1.0,
                                                         color: i.toString() !=
                                                             indvalue
                                                                 .toString()
                                                             ? ColorCodes.grey
                                                             : ColorCodes
                                                             .greenColor
                                                       )),
                                                   child: Padding(
                                                     padding:
                                                     EdgeInsets.only(
                                                         left: 5.0, right: 5.0),
                                                     child: Row(
                                                       crossAxisAlignment:
                                                       CrossAxisAlignment.center,
                                                       mainAxisAlignment:
                                                       MainAxisAlignment.center,
                                                       children: <Widget>[
                                                         CachedNetworkImage(
                                                           imageUrl: nestedCategory[i]
                                                               .iconImage,
                                                           placeholder: (context,
                                                               url) =>
                                                               Image.asset(
                                                                 Images
                                                                     .defaultCategoryImg,
                                                                 height: 35,
                                                                 width: 35,
                                                               ),
                                                           errorWidget: (context,
                                                               url, error) =>
                                                               Image.asset(
                                                                 Images
                                                                     .defaultCategoryImg,
                                                                 width: 35,
                                                                 height: 35,
                                                               ),
                                                           height: 35,
                                                           width: 35,
                                                           fit: BoxFit.cover,
                                                         ),
                                                         SizedBox(
                                                           width: 5,
                                                         ),
                                                         Text(
                                                           nestedCategory[i]
                                                               .categoryName!,
                                                           style: TextStyle(
                                                               fontWeight:
                                                               FontWeight.bold,
                                                               color: (i
                                                                   .toString() !=
                                                                   indvalue
                                                                       .toString())
                                                                   ? ColorCodes
                                                                   .grey
                                                                   : IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor),
                                                         ),
                                                         SizedBox(
                                                           width: 5,
                                                         ),
                                                       ],
                                                     ),
                                                   ),
                                                 ),
                                               ),
                                             ),
                                             SizedBox(
                                               width: 10.0,
                                             ),
                                           ],
                                         ),
                                   ),
                                 ),
                               ),

                             ],
                           );
                         }
                         else {
                           return SizedBox.shrink();
                         }
                       }




                  }




              ),
            Flexible(
              fit: FlexFit.loose,
              child: NotificationListener<
                  ScrollNotification>(
                // ignore: missing_return
                  onNotification:
                      (ScrollNotification scrollInfo) {
                        if (!endOfProduct) if (!_isOnScroll &&
                            // ignore: missing_return
                            scrollInfo.metrics.pixels ==
                                scrollInfo
                                    .metrics.maxScrollExtent) {
                          setState(() {
                            _isOnScroll = true;
                          });
                      productController.getCategoryprodutlist(subCategoryId, (VxState.store as GroceStore).productlist.length,subcatType,(isendofproduct){
                        startItem = (VxState.store as GroceStore).productlist.length;
                        endOfProduct = isendofproduct;
                        if(endOfProduct){
                          setState(() {
                            _isOnScroll = false;
                            endOfProduct = true;
                          });
                        }else {
                          setState(() {
                            _isOnScroll = false;
                            endOfProduct = false;
                          });
                        }
                      },isexpress: _groupValue==1?false:true);
                      setState(() {
                        isLoading = false;
                      });
                    }
                    return true;
                  },child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: _body())),
            ),
          ],
        ),
        bottomNavigationBar:   (Vx.isWeb && ResponsiveLayout.isSmallScreen(context))?Container(
          color: Colors.white,
          child: Padding(
              padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
              child: _buildBottomNavigationBar()
          ),
        ): Vx.isWeb ? SizedBox.shrink() :Container(
          color: Colors.white,
          child: Padding(
              padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
              child: _buildBottomNavigationBar()
          ),
        ),
      ),
    );
  }

  _showBottomSheet(){
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0),topRight: Radius.circular(15.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState)
        {
          return Wrap(
              children: [
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          Image.asset(
                            Images.filter,
                            color: ColorCodes.iconColor,
                            height: 19,
                          ),
                          SizedBox(width: 5,),
                          Text(S
                              .of(context)
                              .filter, style: TextStyle(fontSize: 18,
                              color: ColorCodes.iconColor,
                              fontWeight: FontWeight.bold),),
                          Spacer(),
                          Text(S
                              .of(context)
                              .clear_all, style: TextStyle(
                              fontSize: 13, color: ColorCodes.primaryColor),),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              setState(() {
                                visiblerefine = true;
                                visiblesort = false;
                              });
                            },
                            child: Container(
                              height: 40,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width / 2.1,
                              decoration: BoxDecoration(
                                border: Border.all(color: ColorCodes.supportbg),
                                color: visiblerefine ? ColorCodes.whiteColor : ColorCodes
                                    .supportbg,
                              ),
                              child: Center(child: Text(S.of(context).refine_by, style: TextStyle(
                                  fontSize: 15,
                                  color: visiblerefine
                                      ? ColorCodes.primaryColor
                                      : ColorCodes.black,
                                  fontWeight: FontWeight.bold),)),
                            ),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              setState(() {
                                visiblesort = true;
                                visiblerefine = false;
                              });
                            },
                            child: Container(
                              height: 40,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width / 2.1,
                              decoration: BoxDecoration(
                                border: Border.all(color: ColorCodes.supportbg),
                                color: visiblesort ? ColorCodes.whiteColor : ColorCodes
                                    .supportbg,
                              ),
                              child: Center(child: Text(S.of(context).sort_by, style: TextStyle(
                                  fontSize: 15,
                                  color: visiblesort
                                      ? ColorCodes.primaryColor
                                      : ColorCodes.black,
                                  fontWeight: FontWeight.bold),)),
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: visiblerefine,
                        child: _redefine(),
                      ),
                      Visibility(
                        visible: visiblesort,
                        child: Text("fggghfgbfgb"),
                      ),
                      SizedBox(height: 30,),
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: ColorCodes.primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          child: Center(child: Text(S.of(context).done, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ColorCodes.whiteColor))),
                        ),
                      ),
                      SizedBox(height: 20,),
                    ],
                  ),
                ),
              ],
            );
        }
      );


    },
    );

  }
  _redefine(){
    return Container(
      child: ListView.builder(
          key: Key('builder ${selected.toString()}'),
          shrinkWrap: true,
          controller: new ScrollController(keepScrollOffset: false),
          padding: const EdgeInsets.all(5.0),
          itemCount: 4,
          itemBuilder: (ctx, i)
          {
            return ExpansionTile(
            key: Key(i.toString()),
            onExpansionChanged: (val1){

            },
            initiallyExpanded: true,
            title: Text("Text band", style: TextStyle(fontWeight: FontWeight.bold)),
            children: [
              Text("nbfhvvfv"),
            ]
         );
        }
      )
    );
  }

  Widget _footer(HomePageData homedata) {
    if (homedata.data!.footerImage!.length > 0) {
      return GestureDetector(
        onTap: () {
          !PrefUtils.prefs!.containsKey("apikey")
              ?
          Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push) :
          showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0),topRight: Radius.circular(15.0)),
            ),
            context: context,
            builder: ( context) {
              return productRequest();
            },
          );
        },
        child: new ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          itemCount: homedata.data!.footerImage!.length,
          itemBuilder: (_, i) =>
              Container(
                child: CachedNetworkImage(
                  imageUrl: homedata.data!.footerImage![i].bannerImage,
                  fit: BoxFit.fill,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  placeholder: (context, url) =>
                      Image.asset(Images.defaultSliderImg),
                  errorWidget: (context, url, error) =>
                      Image.asset(Images.defaultSliderImg),
                ),
              ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

}