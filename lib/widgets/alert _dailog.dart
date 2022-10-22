import 'package:awesome_dialog/awesome_dialog.dart';

class Alert {
  AwesomeDialog showallert(context,{String? messege}){
   return AwesomeDialog(
     // autoDismiss: true,
     // dismissOnTouchOutside: true,
     // dismissOnBackKeyPress: true,
      context: context,
      width: 400,
      dialogType: DialogType.WARNING,
      animType: AnimType.BOTTOMSLIDE,
      title: messege,
      // btnCancelOnPress: () {},
      // btnOkOnPress: () {},
    )..show();
  }
  showSuccess(context,{String? messege, required Function() onpress}){
    return AwesomeDialog(
      // autoDismiss: true,
       dismissOnTouchOutside: false,
      // dismissOnBackKeyPress: true,
      context: context,
      width: 400,
      dialogType: DialogType.SUCCES,
      animType: AnimType.BOTTOMSLIDE,
      title: messege,
      // btnCancelOnPress: () {},
       btnOkOnPress: () =>onpress(),
    )..show();
  }
  showError(){

  }
}