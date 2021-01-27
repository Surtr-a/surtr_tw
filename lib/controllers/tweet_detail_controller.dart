import 'package:dart_twitter_api/twitter_api.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:surtr_tw/repositories/twitter_reposity.dart';

import '../twitter_api.dart';

final Logger _log = Logger('TweetDetailController');

class TweetDetailController extends GetxController {
  final TwitterRepository _twitterRepository = Get.find<TwitterRepository>();
  final Tweet tweet = Get.arguments;
  RepliesResult _lastResult;
  List<Tweet> _replies = <Tweet>[];

  List<Tweet> get replies => _replies;

  @override
  void onInit() {
    super.onInit();
    _twitterRepository.loadReplies(tweet, _lastResult).then((value) {
      replies.addAll(value.replies);
      _lastResult = value;
      update();
    });
  }
}
