import 'package:flutter_gemini/src/features/internet_screen/no_intrnet_screen.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'connectivity_service.dart';

class ConnectivityController extends GetxController {
  final ConnectivityService _connectivityService = ConnectivityService();
  var connectivityResult = ConnectivityResult.none.obs;

  @override
  void onInit() {
    super.onInit();
    _connectivityService.connectivityStream.listen((ConnectivityResult result) {
      connectivityResult.value = result;
      if (result == ConnectivityResult.none) {
        Get.to(() => const NoInternetScreen());
      } else {
        Get.back();
      }
    });

    _initializeConnectivity();
  }

  void _initializeConnectivity() async {
    connectivityResult.value = await _connectivityService.checkConnectivity();
  }
}
