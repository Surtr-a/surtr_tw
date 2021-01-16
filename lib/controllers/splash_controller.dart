import 'package:get/get.dart';
import 'package:surtr_tw/components/app_routes.dart';
import 'package:surtr_tw/components/providers/login_provider.dart';

class SplashController extends GetxController {
  @override
  Future<void> onReady() async {
    super.onReady();

    LoginProvider loginProvider = Get.find<LoginProvider>();
    if (loginProvider.isLogin()) {
      Get.offNamed(Routes.MAIN);
    } else {
      // 暂时跳转MAIN
      Get.offNamed(Routes.MAIN);
    }
  }
}