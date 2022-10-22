
import 'package:velocity_x/velocity_x.dart';

import '../../constants/IConstants.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/subscription_data.dart';

class SubscriptionBoxController  extends VxMutation<GroceStore>{
  // HomePageRepo _homePagerepo;
  var subscription_id;
  var subscription_type;
  var type;
  var branch;
  var languageid;
  var user;

  SubscriptionBoxController({this.subscription_id,this.subscription_type,this.type,this.branch,this.languageid,this.user});
  @override
  Future<bool> perform() async{
    // print("homepagerepo:${((await homePagerepo.getData(ParamBodyData(user: user,branch:branch ,languageId: IConstants.languageId,mode: mode,rows: "0"))).toJson())}");
    // TODO: implement perform
    //print("lat laong..."+lat.toString()+",,,,"+long.toString());
    store!.subscriptionboxlist =await subscriptionApibox.getSubsctiptionBoxIDNew(ParamBodyDatabox(subscription_id:subscription_id ,subscription_type: subscription_type,type: type,branch: branch ,languageid: languageid, user: user));
   // store!.storedata = await categoryStoreRepo.getData(ParamBodyData1(lat: lat,long: long, id: id,refid: IConstants.refIdForMultiVendor));

    return Future.value(true);
  }}