import 'package:flutter/material.dart';
import 'package:grocbay/controller/mutations/cart_mutation.dart';
import '../../controller/mutations/cat_and_product_mutation.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/category_modle.dart';
import '../../repository/productandCategory/category_or_product.dart';
import 'package:velocity_x/velocity_x.dart';
import '../assets/ColorCodes.dart';
import '../generated/l10n.dart';
import '../screens/items_screen.dart';
import '../providers/categoryitems.dart';

import 'package:provider/provider.dart';

class ExpansionDrawer extends StatefulWidget {

  final String parentcatId;
  final  Function(String,int,int)? onclick;
  final String subcatID;
  final String catTitle;

  // void Function(VoidCallback fn) state;
  ExpansionDrawer(this.parentcatId, this.subcatID,this.catTitle,{this.onclick});

  @override
  _ExpansionDrawerState createState() => _ExpansionDrawerState();
}

class _ExpansionDrawerState extends State<ExpansionDrawer> {
  List variddata = [];
  var subcategoryData;
  var varlength;
  bool _expanded = false;
  int selected = -1;
  final categoriesData = (VxState.store as GroceStore).homescreen.data!.allCategoryDetails;
  List<CategoryData> subcategory=[];
  List<CategoryData> subcategorytrim=[];
  int higliteindex = 0;
  @override
  void initState() {
    // TODO: implement initState
    // setState(() {
    //   categoriesData = Provider.of<CategoriesItemsList>(context, listen: false);
    // });
    subcategory =  (VxState.store as GroceStore).homescreen.data!.allCategoryDetails!.where((element) => element.id == widget.parentcatId).first.subCategory ;
    subcategorytrim = subcategory.where((element) => element.categoryName!.toLowerCase().trim()!="all").toList();
    higliteindex = subcategorytrim.indexWhere((element) => element.id==widget.subcatID);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ProductController productController = ProductController();
    debugPrint("maincatidexpansion" + widget.parentcatId);
    debugPrint("subcatidexpansion" + widget.subcatID);

    if(subcategorytrim.length>0)
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.catTitle,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
          SizedBox(height: 10,),
          Container(
            width: 300,
            height:MediaQuery.of(context).size.height/3,
            decoration: BoxDecoration(
              border: Border.all(color: ColorCodes.greyColord,)
            ),
            constraints: BoxConstraints(
              minHeight: 350,
              maxHeight:double.infinity,
              // maxWidth: 30.0,
            ),
            child:
            ListView.builder(
              key: Key('lbuilder ${selected.toString()}'),
              itemCount: subcategorytrim.length,
              itemBuilder: (_, index) {
                // if(index>0)
                // productController.geSubtCategory(categoriesData[index].id);
                debugPrint("building........"+subcategorytrim[index].parentId.toString()+"..."+subcategorytrim[index].id.toString()+"name..."+subcategorytrim[index].categoryName.toString()+"/////"+widget.subcatID.toString()+"...."+widget.parentcatId.toString());
                return ListTileTheme(

                    key: Key(index.toString()),
                    contentPadding: EdgeInsets.only(left: 10,right: 10),
                    child: Theme(
                data: ThemeData().copyWith(dividerColor: ColorCodes.greyColord),
                      child: ExpansionTile(
                          onExpansionChanged: (val1){
                            if (val1)
                              setState(() {
                                Duration(seconds: 20000);
                                selected = index;
                                higliteindex = index;
                              });
                            else
                              setState(() {
                                selected = -1;
                              });

                            widget.onclick!(subcategorytrim[index].id!, subcategorytrim[index].type!, index);

                          },
                          trailing: (index == higliteindex)?Icon(Icons.remove,color: ColorCodes.greylight,):Icon(Icons.add,color: ColorCodes.greylight,),
                          initiallyExpanded: selected<0?(widget.subcatID == subcategorytrim[index].id):index==selected,
                          title: Text(subcategorytrim[index].categoryName!,style: TextStyle(color: (index == higliteindex) ?ColorCodes.blackColor:ColorCodes.blackColor,fontWeight: FontWeight.bold)),
                          children: [
                            if(widget.subcatID!=null&& widget.parentcatId!=null) SubCategoriesGrid(subcategorytrim[index],subcategorytrim[index].id.toString(),widget.onclick!),
                           // if(widget.subcatID!=null&& widget.parentcatId!=null) SubCategoriesGrid(subcategory[index],widget.subcatID,widget.parentcatId,widget.onclick!),
                          ]
                      ),
                    ));
              },
            ),
          ),
        ],
      );
    else
      return CircularProgressIndicator();
  }


}
//subNested
class SubCategoriesGrid extends StatefulWidget {
  CategoryData categoriesData ;
  String subcatID;
  //String parentId;
  Function(String,int,int) onclick;

  SubCategoriesGrid(this.categoriesData, this.subcatID, /*this.parentId,*/this.onclick);

  @override
  _SubCategoriesGridState createState() => _SubCategoriesGridState();
}

class _SubCategoriesGridState extends State<SubCategoriesGrid> {

  // CategoriesItemsList subcategoryData;
  var _isloading = true;

  int higliteindex = 0;
  int selectedsub = -1;
  List<CategoryData> subcatData=[];
  Future<List<CategoryData>>? _futureNestitem ;
  List<CategoryData> ListofNest=[];
  List<CategoryData> subNestCategory=[];
  ProductController productController = ProductController();
  var subcatId;

  @override
  void initState() {
    // Provider.of<CategoriesItemsList>(context, listen: false)
    //     .fetchNestedCategory(widget.catId,"subitemScreen")
    //     .then((_) {
    //   setState(() {
    //     subcategoryData = Provider.of<CategoriesItemsList>(
    //       context,
    //       listen: false,
    //     );
    //     _isloading = subcategoryData.itemsubNested.isEmpty? true:!true;
    //   });
    // });
    // TODO: implement initState
    // Future.delayed(Duration.zero, () async {
    //  // subcatData = widget.categoriesData.subCategory.toList();
    //
    //     ProductController productController = ProductController();
    //     productController.geSubtCategory(widget.categoriesData.id,onload: (status){
    //       setState(() {
    //         subcatData = widget.categoriesData.subCategory.where((element) => element.categoryName!.toLowerCase().trim() != "all").toList();
    //       });
    //       debugPrint("check"+subcatData.length.toString());
    //     });
    //     setState(() {
    //       higliteindex = subcatData.indexWhere((element) => element.id==widget.subcatID);
    //       selectedsub = subcatData.indexWhere((element) => element.id==widget.subcatID);
    //     });
    //
    // });
    print("widget subcatid..."+widget.subcatID.toString());
    Future.delayed(Duration.zero, () async {
      ProductRepo().getSubNestcategory(widget.subcatID.toString()).then((value) {
        setState(() {
          _futureNestitem = Future.value(value);
          ListofNest = value.where((element) => element.categoryName!.toLowerCase().trim()!="all").toList();
          if(value.length==1){
            subcatId=widget.subcatID.toString();
          }else{
            subcatId= ListofNest.first.id;
          }
        });
        productController.getCategoryprodutlist(subcatId, "0",0,(isendofproduct){

        });
      });
    });
    higliteindex = 0;
    debugPrint("sss,,,,"+higliteindex.toString()+",,"+selectedsub.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*  subcategoryData = Provider.of<CategoriesItemsList>(
      context,
      listen: false,
    );*/
    // double deviceWidth = MediaQuery.of(context).size.width;
    // int widgetsInRow = 3;
    // double aspectRatio =
    //     (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 125;
    //
    // if (deviceWidth > 1200) {
    //   widgetsInRow = 5;
    //   aspectRatio =
    //       (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 295;
    // } else if (deviceWidth > 768) {
    //   widgetsInRow = 4;
    //   aspectRatio =
    //       (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 195;
    // }
    //
    // return  Column(
    //   children: <Widget>[
    //     SizedBox(
    //       width: 5.0,
    //     ),
    //     Container(
    //       margin: EdgeInsets.all(6),
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(3),
    //         //color: Colors.white,
    //       ),
    //
    //       child: /*_isloading? Center(
    //         child: CircularProgressIndicator(),
    //       ) :*/
    //      /* widget.categoriesData.subCategory */subcatData.length==null?Padding(
    //         padding: EdgeInsets.only(bottom: 10),
    //         child:  Text(/*"No Item Found",*/S.of(context).no_items_found),
    //       ):
    //       ListView.builder(
    //           key: Key(' ${selectedsub.toString()}'),
    //           shrinkWrap: true,
    //           controller: new ScrollController(keepScrollOffset: false),
    //           padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
    //           itemCount: /*widget.categoriesData.subCategory.length*/subcatData.length,
    //           itemBuilder: (ctx, i) {
    //             return ListTileTheme(
    //                 key: Key(i.toString()),
    //                 contentPadding: EdgeInsets.all(0),
    //                 child: ExpansionTile(
    //                     onExpansionChanged: (val){
    //                       if (val)
    //                         setState(() {
    //                           Duration(seconds: 20000);
    //                           selectedsub = i;
    //                           print("select.."+selectedsub.toString()+",,,,"+i.toString());
    //                         });
    //                       else
    //                         setState(() {
    //                           selectedsub = -1;
    //                           print("selectqqq.."+selectedsub.toString()+",,,,"+i.toString());
    //                         });
    //                     },
    //                     trailing: selectedsub<0?Icon(Icons.add):Icon(Icons.remove),
    //                     initiallyExpanded: selectedsub<0?(widget.subcatID == subcatData[i].id):i==selectedsub,
    //                     title: Text(subcatData[i].categoryName!),
    //                     children: [
    //                       if(widget.subcatID!=null) NestCategoriesGrid(subcatData[i],subcatData[i].id.toString(),widget.onclick),
    //                     ]
    //                 ));
    //             /*GestureDetector(
    //             behavior: HitTestBehavior.translucent,
    //             onTap: () {
    //               setState(() {
    //                 higliteindex = i;
    //               });
    //               widget.onclick(widget.categoriesData.subCategory[i].id!,
    //                   widget.categoriesData.subCategory[i].type!, i);
    //               // print("clickforid: "+{
    //               //   'maincategory':  widget.categoriesData.categoryName,
    //               //   'catId':  widget.categoriesData.id,
    //               //   'catTitle':  widget.categoriesData.categoryName,
    //               //   'subcatId': widget.categoriesData.subCategory[i].id,
    //               //   'indexvalue': i.toString(),
    //               //   'type': widget.categoriesData.subCategory[i].type.toString(),
    //               //   'subcattitle':widget.categoriesData.subCategory[i].categoryName,
    //               //   'prev': "category_item"}.toString());
    //               // Navigator.of(context).pushReplacementNamed(ItemsScreen.routeName, arguments: {
    //               //   'maincategory': widget.categoriesData.categoryName,
    //               //   'catId': widget.categoriesData.id,
    //               //   'catTitle': widget.categoriesData.categoryName,
    //               //   'subcatId': widget.categoriesData.subCategory[i].id,
    //               //   'indexvalue': i.toString(),
    //               //   'subcattitle':widget.categoriesData.subCategory[i].categoryName,
    //               //   'prev': "category_item"});
    //             },
    //             child: Padding(
    //               padding: EdgeInsets.only(bottom: 10),
    //               child: Text(
    //                 widget.categoriesData.subCategory[i].categoryName!,
    //                 style: TextStyle(
    //                     color: (i == higliteindex)
    //                         ? ColorCodes.discount
    //                         : Colors.black
    //                 ),
    //               ),
    //             ),
    //           );*/
    //           }
    //       ),
    //     )
    //   ],
    // );

    double deviceWidth = MediaQuery.of(context).size.width;
    int widgetsInRow = 3;
    double aspectRatio =
        (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 125;

    if (deviceWidth > 1200) {
      widgetsInRow = 5;
      aspectRatio =
          (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 295;
    } else if (deviceWidth > 768) {
      widgetsInRow = 4;
      aspectRatio =
          (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 195;
    }

    return  Column(
      children: <Widget>[
        SizedBox(
          width: 5.0,
        ),
        Container(
          margin: EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            //color: Colors.white,
          ),

          child: /*_isloading? Center(
            child: CircularProgressIndicator(),
          ) :*/
          /*  widget.categoriesData.subCategory .length<=1?*/
          FutureBuilder(
              future: /*{ProductMutation}*/_futureNestitem,
              builder: (BuildContext context, AsyncSnapshot<List<CategoryData>> snapshot) {
                if(snapshot.data!=null) {
                  subNestCategory =
                      snapshot.data!.where((element) => element.categoryName!
                          .toLowerCase().trim() != "all").toList();
                }
                return  (subNestCategory!= null) ?ListView.builder(
                    shrinkWrap: true,
                    controller: new ScrollController(keepScrollOffset: false),
                    padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
                    itemCount:subNestCategory.length/*snapshot
                          .data!.length*/,
                    itemBuilder: (ctx, i) {
                      return MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            setState(() {
                              higliteindex = i;
                            });
                            widget.onclick(subNestCategory[i].id!,
                                subNestCategory[i].type!, i);
                            // print("clickforid: "+{
                            //   'maincategory':  widget.categoriesData.categoryName,
                            //   'catId':  widget.categoriesData.id,
                            //   'catTitle':  widget.categoriesData.categoryName,
                            //   'subcatId': widget.categoriesData.subCategory[i].id,
                            //   'indexvalue': i.toString(),
                            //   'type': widget.categoriesData.subCategory[i].type.toString(),
                            //   'subcattitle':widget.categoriesData.subCategory[i].categoryName,
                            //   'prev': "category_item"}.toString());
                            // Navigator.of(context).pushReplacementNamed(ItemsScreen.routeName, arguments: {
                            //   'maincategory': widget.categoriesData.categoryName,
                            //   'catId': widget.categoriesData.id,
                            //   'catTitle': widget.categoriesData.categoryName,
                            //   'subcatId': widget.categoriesData.subCategory[i].id,
                            //   'indexvalue': i.toString(),
                            //   'subcattitle':widget.categoriesData.subCategory[i].categoryName,
                            //   'prev': "category_item"});
                          },
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              subNestCategory[i].categoryName!,
                              style: TextStyle(
                                fontSize: 15,
                                  color: (i == higliteindex) ? ColorCodes
                                      .blackColor : ColorCodes.greylight
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                ):Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child:  Text(/*"No Item Found",*/S.of(context).no_items_found),
                );
              }
          ),
        ),
      ],
    );
  }
}


//Nested......
class NestCategoriesGrid extends StatefulWidget {
  CategoryData categoriesData ;
  String subcatID;
  Function(String,int,int) onclick;

  NestCategoriesGrid(this.categoriesData, this.subcatID, this.onclick);

  @override
  _NestCategoriesGridState createState() => _NestCategoriesGridState();
}

class _NestCategoriesGridState extends State<NestCategoriesGrid> {

  // CategoriesItemsList subcategoryData;
  var _isloading = true;
  Future<List<CategoryData>>? _futureNestitem ;
  List<CategoryData> ListofNest=[];
  List<CategoryData> subNestCategory=[];
  ProductController productController = ProductController();
  var subcatId;

  int higliteindex = 0;
  @override
  void initState() {
    // Provider.of<CategoriesItemsList>(context, listen: false)
    //     .fetchNestedCategory(widget.catId,"subitemScreen")
    //     .then((_) {
    //   setState(() {
    //     subcategoryData = Provider.of<CategoriesItemsList>(
    //       context,
    //       listen: false,
    //     );
    //     _isloading = subcategoryData.itemsubNested.isEmpty? true:!true;
    //   });
    // });
    // TODO: implement initState
    Future.delayed(Duration.zero, () async {
      ProductRepo().getSubNestcategory(widget.subcatID.toString()).then((value) {
        setState(() {
          _futureNestitem = Future.value(value);
          ListofNest = value.where((element) => element.categoryName!.toLowerCase().trim()!="all").toList();
          if(value.length==1){
            subcatId=widget.subcatID.toString();
          }else{
            subcatId= ListofNest.first.id;
          }
        });
          productController.getCategoryprodutlist(subcatId, "0",0,(isendofproduct){

          });
      });
    });
    higliteindex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*  subcategoryData = Provider.of<CategoriesItemsList>(
      context,
      listen: false,
    );*/
    double deviceWidth = MediaQuery.of(context).size.width;
    int widgetsInRow = 3;
    double aspectRatio =
        (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 125;

    if (deviceWidth > 1200) {
      widgetsInRow = 5;
      aspectRatio =
          (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 295;
    } else if (deviceWidth > 768) {
      widgetsInRow = 4;
      aspectRatio =
          (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 195;
    }

    return  Column(
      children: <Widget>[
        SizedBox(
          width: 5.0,
        ),
        Container(
          margin: EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            //color: Colors.white,
          ),

          child: /*_isloading? Center(
            child: CircularProgressIndicator(),
          ) :*/
        /*  widget.categoriesData.subCategory .length<=1?*/
          FutureBuilder(
              future: /*{ProductMutation}*/_futureNestitem,
              builder: (BuildContext context, AsyncSnapshot<List<CategoryData>> snapshot) {
                if(snapshot.data!=null) {
                  subNestCategory =
                      snapshot.data!.where((element) => element.categoryName!
                          .toLowerCase().trim() != "all").toList();
                }
                  return  (subNestCategory!= null) ?ListView.builder(
                      shrinkWrap: true,
                      controller: new ScrollController(keepScrollOffset: false),
                      padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
                      itemCount:subNestCategory.length/*snapshot
                          .data!.length*/,
                      itemBuilder: (ctx, i) {
                        return GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            setState(() {
                              higliteindex = i;
                            });
                            widget.onclick(subNestCategory[i].id!,
                                subNestCategory[i].type!, i);
                            // print("clickforid: "+{
                            //   'maincategory':  widget.categoriesData.categoryName,
                            //   'catId':  widget.categoriesData.id,
                            //   'catTitle':  widget.categoriesData.categoryName,
                            //   'subcatId': widget.categoriesData.subCategory[i].id,
                            //   'indexvalue': i.toString(),
                            //   'type': widget.categoriesData.subCategory[i].type.toString(),
                            //   'subcattitle':widget.categoriesData.subCategory[i].categoryName,
                            //   'prev': "category_item"}.toString());
                            // Navigator.of(context).pushReplacementNamed(ItemsScreen.routeName, arguments: {
                            //   'maincategory': widget.categoriesData.categoryName,
                            //   'catId': widget.categoriesData.id,
                            //   'catTitle': widget.categoriesData.categoryName,
                            //   'subcatId': widget.categoriesData.subCategory[i].id,
                            //   'indexvalue': i.toString(),
                            //   'subcattitle':widget.categoriesData.subCategory[i].categoryName,
                            //   'prev': "category_item"});
                          },
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              subNestCategory[i].categoryName!,
                              style: TextStyle(
                                  color: (i == higliteindex) ? ColorCodes
                                      .discount : Colors.black
                              ),
                            ),
                          ),
                        );
                      }
                  ):Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child:  Text(/*"No Item Found",*/S.of(context).no_items_found),
                  );
              }
          ),
        ),
      ],
    );
  }
}