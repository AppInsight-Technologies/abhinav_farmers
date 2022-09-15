
import 'package:grocbay/constants/api.dart';
import 'package:grocbay/models/newmodle/upcomingsubscription.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constants/IConstants.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/subscription_data.dart';

class UpcomingSunscriptionController  extends VxMutation<GroceStore>{
  // HomePageRepo _homePagerepo;
  var branch;
  var languageid;
  var user;
  var ref;

  UpcomingSunscriptionController({this.branch,this.languageid,this.user,this.ref});
  @override
  Future<bool> perform() async{
    // print("homepagerepo:${((await homePagerepo.getData(ParamBodyData(user: user,branch:branch ,languageId: IConstants.languageId,mode: mode,rows: "0"))).toJson())}");
    // TODO: implement perform
    //print("lat laong..."+lat.toString()+",,,,"+long.toString());
    store!.upcomingsubscriptionlist =await upcomingSubscriptionApi.getUpcomingSubscription(ParamBodyDataUpcomingbox(branch: branch ,languageid: languageid, user: user , ref:ref));
    // store!.storedata = await categoryStoreRepo.getData(ParamBodyData1(lat: lat,long: long, id: id,refid: IConstants.refIdForMultiVendor));

    return Future.value(true);
  }}