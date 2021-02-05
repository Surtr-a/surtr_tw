import 'package:get/get.dart';
import 'package:surtr_tw/controllers/main_controller.dart';
import 'package:surtr_tw/repositories/twitter_repository.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TwitterRepository());
    Get.lazyPut(() => MainController());
  }
}