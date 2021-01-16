import 'package:get/get.dart';
import 'package:surtr_tw/controllers/splash_controller.dart';

class SplashBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}