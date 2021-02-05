import 'package:get/get.dart';
import 'package:surtr_tw/repositories/twitter_repository.dart';

class SearchController extends GetxController {
  final TwitterRepository _twitterRepository = Get.find<TwitterRepository>();
}