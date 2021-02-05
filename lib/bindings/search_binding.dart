import 'package:get/get.dart';
import 'package:surtr_tw/controllers/search_controller.dart';
import 'package:surtr_tw/repositories/twitter_repository.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TwitterRepository());
    Get.lazyPut(() => SearchController());
  }
}