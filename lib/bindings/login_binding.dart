import 'package:get/get.dart';
import 'package:surtr_tw/controllers/Login_controller.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}