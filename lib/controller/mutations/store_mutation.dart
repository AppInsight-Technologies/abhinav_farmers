import 'package:grocbay/constants/IConstants.dart';
import 'package:grocbay/models/VxModels/VxStore.dart';
import 'package:grocbay/models/newmodle/store_data.dart';
import 'package:grocbay/repository/store_repo.dart';
import 'package:velocity_x/velocity_x.dart';

/*class StoreController{
  StoreRepo _storeRepo = StoreRepo();


  fetchstore( {required String lat,required String long,required String ids,}) async{
    SetStore(_storeRepo,{
      'lat': lat,
      'long': long,
      'ids': ids,
    });
  }

}

class SetStore extends VxMutation<GroceStore>{
  StoreRepo storeRepo;
  Map<String, String> data;
  SetStore(this.storeRepo, this.data);
  @override
  perform() async{
   final result = await storeRepo.getStore(data);
    // TODO: implement perform
    store!.storedata = result!;
  }

}*/


class StoreController  extends VxMutation<GroceStore>{
  // HomePageRepo _homePagerepo;
  var ids;
  var lat;
  var long;

  //var languageid;

  StoreController({this.lat,this.long,this.ids});
  @override
  Future<bool> perform() async{
    // print("homepagerepo:${((await homePagerepo.getData(ParamBodyData(user: user,branch:branch ,languageId: IConstants.languageId,mode: mode,rows: "0"))).toJson())}");
    // TODO: implement perform
    store!.storeofferbanner =await storeRepo.getBanner(ParamBodyData(lat: lat,long: long,id: ids,refid: IConstants.refIdForMultiVendor));
    store!.storedata = await storeRepo.getStore(ParamBodyData(lat: lat,long: long,id: ids,refid: IConstants.refIdForMultiVendor));
    return Future.value(true);
  }}
