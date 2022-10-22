import 'package:grocbay/constants/IConstants.dart';
import 'package:grocbay/models/VxModels/VxStore.dart';
import 'package:grocbay/repository/fetchdata/home_store_repo.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../repository/fetchdata/category_store_repo.dart';

class CategoryStoreScreenController  extends VxMutation<GroceStore>{
  // HomePageRepo _homePagerepo;
  var lat;
  var long;
  var id;

  //var languageid;

  CategoryStoreScreenController({this.lat,this.long,this.id});
  @override
  Future<bool> perform() async{
    // print("homepagerepo:${((await homePagerepo.getData(ParamBodyData(user: user,branch:branch ,languageId: IConstants.languageId,mode: mode,rows: "0"))).toJson())}");
    // TODO: implement perform
    print("lat laong..."+lat.toString()+",,,,"+long.toString());
    store!.storeofferbanner =await categoryStoreRepo.getBanner(ParamBodyData1(lat: lat,long: long, id: id,refid: IConstants.refIdForMultiVendor));
    store!.storedata = await categoryStoreRepo.getData(ParamBodyData1(lat: lat,long: long, id: id,refid: IConstants.refIdForMultiVendor));

    return Future.value(true);
  }}