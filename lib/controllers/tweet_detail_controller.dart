import 'package:dart_twitter_api/twitter_api.dart';
import 'package:get/get.dart';
import 'package:surtr_tw/repositories/twitter_reposity.dart';

import '../twitter_api.dart';

class TweetDetailController extends GetxController {
  final TwitterRepository _twitterRepository = Get.find<TwitterRepository>();
  final Tweet tweet = Get.arguments;
  RepliesResult _lastResult;
  List<Tweet> replies = <Tweet>[];

  @override
  void onInit() async {
    super.onInit();
    RepliesResult result = await _twitterRepository.loadReplies(tweet, _lastResult);
    replies.addAll(result.replies);
    _lastResult = result;
  }
}