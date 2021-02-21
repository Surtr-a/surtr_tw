import 'package:dart_twitter_api/api/tweets/data/tweet.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:surtr_tw/repositories/twitter_repository.dart';

class HomeController extends GetxController {
  final TwitterRepository _twitterRepository = Get.find<TwitterRepository>();
  final List<Tweet> _homeTimeline = <Tweet>[];
  final RefreshController refreshController = RefreshController(initialRefresh: true);

  onRefresh() async {
    List<Tweet> response = await _twitterRepository.homeTimeline();
    if (response == null) {
      refreshController.refreshFailed();
      return;
    } else {
      _homeTimeline.addAll(response);
      update();
      refreshController.refreshCompleted();
    }
    if (response.length == 0) {
      refreshController.loadNoData();
    }
  }

  List<Tweet> get homeTimeline => _homeTimeline;
}