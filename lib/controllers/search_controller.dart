import 'package:dart_twitter_api/twitter_api.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:surtr_tw/repositories/twitter_repository.dart';

final Logger _log = Logger('SearchController');

class SearchController extends GetxController {
  final RefreshController refreshController = RefreshController(initialRefresh: false);
  final TwitterRepository _twitterRepository = Get.find<TwitterRepository>();
  List<Tweet> _result = <Tweet>[];
  String query = Get.arguments;

  List<Tweet> get result => _result;


  @override
  void onInit() {
    super.onInit();
    onRefresh();
  }

  onRefresh() async {
    var response = await _twitterRepository.searchTweets(q: query, count: 40);
    if (response == null) {
      refreshController.refreshFailed();
      return;
    } else {
      _result.clear();
      _result.addAll(response.statuses);
      refreshController.refreshCompleted();
      update();
    }
    if (response.statuses.length == 0) {
      refreshController.loadNoData();
    }
  }
}