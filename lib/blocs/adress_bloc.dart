import 'dart:async';

import '../models/addressfields.dart';
import '../providers/addressitems.dart';
import 'package:rxdart/subjects.dart';

class AddressBloc{
  final _addressrepo = AddressItemsList();
      final _adressController = BehaviorSubject<List<AddressFields>>();
 StreamSink<List<AddressFields>> get sinkadress => _adressController.sink;
 Stream<List<AddressFields>> get streamaddress => _adressController.stream;
  getAddress()async{
    await _addressrepo.fetchAddress();
  }
}
final adressbloc = AddressBloc();