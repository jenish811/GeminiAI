import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  // Corrected the return type to match the type expected
  Stream<ConnectivityResult> get connectivityStream => _connectivity.onConnectivityChanged;

  Future<ConnectivityResult> checkConnectivity() async {
    return await _connectivity.checkConnectivity();
  }
}
