
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../assets/ColorCodes.dart';
import '../controller/mutations/cat_and_product_mutation.dart';
import '../models/newmodle/category_modle.dart';
import 'package:velocity_x/velocity_x.dart';
import '../constants/IConstants.dart';
import '../utils/ResponsiveLayout.dart';
import '../providers/categoryitems.dart';
import './categories_item.dart';
import 'package:shimmer/shimmer.dart';


class CategoriesGrid extends StatefulWidget {
  CategoryData allCategoryDetail;
  CategoriesGrid(this.allCategoryDetail);

  @override
  _CategoriesGridState createState() => _CategoriesGridState();
}

class _CategoriesGridState extends State<CategoriesGrid> {
  //bool _isLoading = true;
  bool _isCategory = false;
  bool _isCategoryShimmer = false;
  var subcategoryData;

  CategoriesItemsList? subNestedcategoryData;

  List<CategoryData> subcatData=[];

  @override
  void initState() {

    // widget.allCategoryDetail.subCategory=null;
    Future.delayed(Duration.zero, () async {
      ProductController productController = ProductController();
      print("alll categprty id....alll categprty id...."+widget.allCategoryDetail.id.toString());
      productController.geSubtCategory(widget.allCategoryDetail.id,onload: (status){

      });
  /*    await Provider.of<CategoriesItemsList>(context, listen: false).fetchNestedCategory(widget.allCategoryDetail.id, "categoriesGrid").then((_) {
        subNestedcategoryData = Provider.of<CategoriesItemsList>(context, listen: false,);

        setState(() {
          _isCategory = true;
          _isCategoryShimmer = false;
        });
      });*/
    });


  }
  Widget _sliderShimmer() {
    return Vx.isWeb ?
    Center(
      child: CircularProgressIndicator(),
    )
        :
    Container(
        margin: EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: Colors.white,
        ),
        child: Shimmer.fromColors(
          baseColor: ColorCodes.shimmerColor,
          highlightColor: ColorCodes.shimmerColor,

          child: GridView.builder(
            shrinkWrap: true,
            controller: new ScrollController(keepScrollOffset: false),
            padding: ResponsiveLayout.isSmallScreen(context)? const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0):
            const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
            itemCount: 3,
            itemBuilder: (ctx, i) => Card(
              color: ColorCodes.shimmerColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              elevation: 0,
              margin: EdgeInsets.all(5),

              child: Container(),
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
          ),
          // )),
        ));
  }

  Widget _category() {

    //  final subNestedcategoryData = Provider.of<CategoriesItemsList>(context,listen: false);

    double deviceWidth = MediaQuery.of(context).size.width;
    int widgetsInRow = 4;
    double aspectRatio = (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 135;

    // ProductController productController = ProductController();
    // productController.geSubtCategory(widget.allCategoryDetail.id);
print("id....click....");
 /*  Vx.isWeb?
     subcategoryData = Provider.of<CategoriesItemsList>(
      context,
      listen: false,
    ).findByIdweb(widget.allCategoryDetail.id):
     subcategoryData = Provider.of<CategoriesItemsList>(
      context,
      listen: false,
    ).findById(widget.allCategoryDetail.id);*/
    //print("sub cat length......"+subNestedcategoryData.itemsubNested.length.toString());


    if (deviceWidth > 1200) {
      widgetsInRow = 9;
      aspectRatio =
      (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
      (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 190:
      (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 295;
    } else if (deviceWidth > 968) {
      widgetsInRow = 8;
      aspectRatio =
      (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
      (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 195:
      (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 195;
    } else if (deviceWidth > 768) {
      widgetsInRow = 6;
      aspectRatio =
      (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
      (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 195:
      (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 195;
    }
    return  VxBuilder(
        mutations: {ProductMutation},
        builder: (ctx,store,VxStatus? state)
    {

      if(widget.allCategoryDetail.subCategory!=null&&widget.allCategoryDetail.subCategory.length>0)
        subcatData = widget.allCategoryDetail.subCategory.where((element) => element.categoryName!.toLowerCase().trim() != "all").toList();
      print("subcat length..."+subcatData.length.toString());
      return subcatData.length > 0?
        (subcatData!=null||subcatData.length>0)
          ? (IConstants.isEnterprise) ?
      Column(
        children: <Widget>[
          SizedBox(
            width: 5.0,
          ),
          Container(
            margin: EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: Colors.white,
            ),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GridView.builder(
                shrinkWrap: true,
                controller: new ScrollController(keepScrollOffset: false),
                /*  padding: ResponsiveLayout.isSmallScreen(context)? const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0):
              const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),*/
                itemCount: /*subNestedcategoryData.itemsubNested.length*/subcatData.length,
                itemBuilder: (ctx, i) {
                  debugPrint("items...."+subcatData.length.toString());
                  return Card(
                    color: /*Color(0xFFD0F0DE)*/ColorCodes.whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    elevation: 0,
                    //  margin: EdgeInsets.all(5),

                    child: CategoriesItem(
                        "SubcategoryScreen",
                        widget.allCategoryDetail.categoryName!,
                        widget.allCategoryDetail.id!,
                        subcatData[i].id!,
                        subcatData[i].categoryName!,
                        i,
                        subcatData[i].iconImage!),
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widgetsInRow,
                  childAspectRatio: aspectRatio,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
              ),
            ),
          )
        ],
      ) :
      Column(
        children: <Widget>[
          SizedBox(
            width: 5.0,
          ),
          SizedBox(
            height: 140,
            child: ListView.builder(
                shrinkWrap: true,
                controller: new ScrollController(keepScrollOffset: false),
                scrollDirection: Axis.horizontal,
                itemCount: subcatData.length,
                itemBuilder: (ctx, i) {
                  debugPrint("subcat..." + subcatData.length.toString());
                  return Container(
                    width: ResponsiveLayout.isSmallScreen(context)?100:150,
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      elevation: 0,
                      margin: EdgeInsets.all(5),
                      child: CategoriesItem(
                          "SubcategoryScreen",
                          widget.allCategoryDetail.categoryName!,
                          widget.allCategoryDetail.id!,
                          subcatData[i].id!,
                          subcatData[i].categoryName!,
                          i,
                          subcatData[i].iconImage!
                        /* "SubcategoryScreen",
                    widget.catTitle,
                    widget.catId,
                    subNestedcategoryData.itemsubNested[i].catid,
                    subNestedcategoryData.itemsubNested[i].title,
                    i,
                    subNestedcategoryData.itemsubNested[i].imageUrl*/),
                    ),
                  );
                }
            ),
          ),
        ],
      )
          :
      _sliderShimmer():
      _sliderShimmer();

    });
  }
  @override
  Widget build(BuildContext context) {

    return _category();

  }
}