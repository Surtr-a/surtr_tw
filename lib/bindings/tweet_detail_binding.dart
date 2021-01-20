import 'package:get/get.dart';
import 'package:surtr_tw/controllers/tweet_detail_controller.dart';
import 'package:surtr_tw/repositories/twitter_reposity.dart';

class TweetDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TwitterRepository());
    Get.lazyPut(() => TweetDetailController());
  }
}