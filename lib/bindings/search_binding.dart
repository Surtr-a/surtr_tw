import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:surtr_tw/controllers/search_controller.dart';
import 'package:surtr_tw/repositories/twitter_repository.dart';

final Logger _log = Logger('SearchBinding');

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TwitterRepository());
    Get.create(() => SearchController(), permanent: false);
  }
}