import 'package:dart_twitter_api/api/tweets/data/tweet.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:surtr_tw/repositories/twitter_reposity.dart';

class HomeController extends GetxController {
  final TwitterRepository _twitterRepository = Get.find<TwitterRepository>();
  final List<Tweet> _homeTimeline = <Tweet>[];
  final RefreshController refreshController = RefreshController(initialRefresh: true);

  onRefresh() async {
    List<Tweet> result = await _twitterRepository.homeTimeline();
    if (result == null) {
      refreshController.refreshFailed();
      return;
    } else {
      _homeTimeline.addAll(result);
      update();
      refreshController.refreshCompleted();
    }
    if (result.length == 0) {
      refreshController.loadNoData();
    }
  }

  List<Tweet> get homeTimeline => _homeTimeline;
}