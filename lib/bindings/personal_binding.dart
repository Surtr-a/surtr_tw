import 'package:get/get.dart';
import 'package:surtr_tw/controllers/personal_controller.dart';
import 'package:surtr_tw/repositories/twitter_repository.dart';

class PersonalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TwitterRepository());
    Get.create(() => PersonalController(), permanent: false);
  }
}