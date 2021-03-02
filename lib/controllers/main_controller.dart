import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:surtr_tw/components/app_routes.dart';
import 'package:surtr_tw/components/providers/login_provider.dart';

final Logger _log = Logger('MainController');

class MainController extends GetxController {
  var currentIndex = 0.obs;

  @override
  void onReady() {
    super.onReady();
    if (!Get.find<LoginProvider>().isLogin()) {
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}