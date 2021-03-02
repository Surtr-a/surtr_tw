import 'package:dart_twitter_api/api/tweets/data/tweet.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:surtr_tw/repositories/twitter_repository.dart';

class HomeController extends GetxController {
  final TwitterRepository _twitterRepository = Get.find<TwitterRepository>();
  List<Tweet> _homeTimeline = <Tweet>[];
  final RefreshController refreshController = RefreshController(initialRefresh: true);

  void updateHomeTimeline(Tweet tweet, isRetweeted) {
    _homeTimeline = _homeTimeline.map((e) {
      if (isRetweeted) {
        if (e.retweetedStatus.idStr == tweet.idStr) {
          e.retweetedStatus = tweet;
          update();
        }
      } else {
        if (e.idStr == tweet.idStr) {
          e = tweet;
          update();
        }
      }
    }).toList();
  }

  onRefresh() async {
    List<Tweet> response = await _twitterRepository.homeTimeline();
    if (response == null) {
      refreshController.refreshFailed();
      return;
    } else if (response.length == 0) {
      refreshController.loadNoData();
    } else {
      _homeTimeline.clear();
      _homeTimeline.addAll(response);
      update();
      refreshController.refreshCompleted();
    }
  }

  onLoadMore() async {
    final String maxId = _findMaxId(_homeTimeline);
    List<Tweet> response = await _twitterRepository.homeTimeline(maxId: maxId);
    if (response == null) {
      refreshController.refreshFailed();
      return;
    } else if (response.length == 0) {
      refreshController.loadNoData();
    } else {
      _homeTimeline.addAll(response);
      update();
      refreshController.refreshCompleted();
    }
  }

  // finds the 'maxId' for the request
  // the next result contains item of 'maxId - 1'
  String _findMaxId(List<Tweet> tweets) {
    if (tweets.isNotEmpty) {
      final int lastId = int.tryParse(tweets.last.idStr);

      if (lastId != null) {
        return '${lastId - 1}';
      }
    }

    return null;
  }

  List<Tweet> get homeTimeline => _homeTimeline;
}