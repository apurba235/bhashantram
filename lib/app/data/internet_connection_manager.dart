import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class InternetConnectionManager {
  static final instance = InternetConnectionManager._();

  InternetConnectionManager._();

  bool get isInternetConnected => _isInternetConnected.value;

  bool get isOffline => !_isInternetConnected.value;

  bool get isWifi => _isWifi.value;

  ///I am a private variable so that outside world cannot manipulate me
  final RxBool _isInternetConnected = false.obs;

  final RxBool _isWifi = false.obs;

  void initialize() {
    listener((bool internetStatus) {
      if (internetStatus) {
        /// I am connected to a mobile or wifi network.
        _isInternetConnected.value = true;
      } else {
        /// I am NOT connected to a network.
        _isInternetConnected.value = false;
      }
    });
  }

  Future<void> listener(
    void Function(bool) onConnection, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) async {
    final result = await Connectivity().checkConnectivity();
    onConnection((result == ConnectivityResult.mobile) || (result == ConnectivityResult.wifi));
    Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult event) {
        if (event == ConnectivityResult.mobile) {
          /// I am connected to a mobile network.
          _isWifi.value = false;
          onConnection(true);
        } else if (event == ConnectivityResult.wifi) {
          /// I am connected to a wifi network.
          _isWifi.value = true;
          onConnection(true);
        } else {
          /// I am NOT connected to a network.
          _isWifi.value = false;
          onConnection(false);
        }
      },
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}
