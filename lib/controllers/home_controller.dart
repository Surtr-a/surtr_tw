import 'package:dart_twitter_api/api/tweets/data/tweet.dart';
import 'package:get/get.dart';
import 'package:surtr_tw/repositories/twitter_reposity.dart';

class HomeController extends GetxController {
  final TwitterRepository _twitterRepository = Get.find<TwitterRepository>();
  final List<Tweet> _homeTimeline = <Tweet>[];

  @override
  void onInit() async {
    super.onInit();
    await _twitterRepository.homeTimeline().then((value) {
        _homeTimeline.addAll(value);
    });
    update();
  }

  List<Tweet> get homeTimeline => _homeTimeline;
}