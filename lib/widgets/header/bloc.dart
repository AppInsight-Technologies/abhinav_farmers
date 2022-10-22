import 'package:rxdart/rxdart.dart';

class HeaderBloc {

  final _notificationCountStreamController = BehaviorSubject<int>.seeded(0);
  Stream<int> get notificationCountStream => _notificationCountStreamController.stream;
  Function? get setNotificationCountStream => _notificationCountStreamController.isClosed ? null : _notificationCountStreamController.sink.add;


  void dispose() {
    _notificationCountStreamController.close();
  }
}
final headerBloc = HeaderBloc();