import 'package:grocbay/utils/network_cookie.dart';

import '../constants/IConstants.dart';
import 'package:http/http.dart' as http;
class Api{
  Map<String, String>? _header;
  Map<String, String>? _body;
  List<Map<String, dynamic>>? files;
  String baseurl = "${IConstants.API_PATH}v2/";
  set header(Map<String,String>? header)=> this._header = header;
  Map<String, String>? get header => _header;
  set body(Map<String,String> body)=>this._body = body;
  Map<String, String> get body => _body!;
  Future<String> Geturl(String url,{isv2 = true}) async {
    // NetworkService().get("${isv2?baseurl:IConstants.API_PATH}$url")
    var headers = header?? {
    'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request('GET', Uri.parse('${isv2?baseurl:IConstants.API_PATH}$url'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print('${isv2?baseurl:IConstants.API_PATH}$url');
    if (response.statusCode == 200) {
      return Future.value(await response.stream.bytesToString());
      // print(await response.stream.bytesToString());
    }
    else {
      return Future.value(response.reasonPhrase);
      //
      // print(response.reasonPhrase);
    }

  }
  Future<String> Posturl(String url,{isv2 = true}) async {

    Map<String,String> headers = header?? {
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    // var bodys = body;
    final request = http.Request('POST', Uri.parse('${isv2?baseurl:IConstants.API_PATH}$url'),);
    // if(files.isNotEmpty){
    //   files.map((e) {
    //     e.map((key, value)  => );
    //   }).toList();
    //   // Future.delayed(Duration.zero,() async=> request.files.add(await http.MultipartFile.fromPath(key, value););
    // }
    // request.files.add(await http.MultipartFile.fromPath('language_id', '/path/to/file'));
    request.headers.addAll(headers);
    request.bodyFields = body;
    http.StreamedResponse response = await request.send();
    print("sending post with url: ${isv2?baseurl:IConstants.API_PATH}$url and parm: "+body.toString());
    print("status ${response.statusCode}");
    if (response.statusCode == 200) {
      final responsees =await response.stream.bytesToString();
      return Future.value(responsees);
      // print(await response.stream.bytesToString());
    }
    else {
      return Future.value('''{"status":${response.statusCode}}''');

      // print(response.reasonPhrase);
    }

  }
}