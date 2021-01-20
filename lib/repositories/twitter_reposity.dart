import 'dart:async';

import 'package:dart_twitter_api/twitter_api.dart' as api;
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:surtr_tw/twitter_api.dart';

class TwitterRepository {
  static final Logger _log = Logger('TwitterRepository');

  final api.TwitterApi twitterApi = Get.find<api.TwitterApi>();

  Future<List<api.Tweet>> homeTimeline() async {
    return await twitterApi.timelineService
        .homeTimeline(count: 30, includeEntities: true, excludeReplies: false)
        .catchError((e) => _log.severe(e.toString()));
  }

  Future<RepliesResult> loadReplies(
      api.Tweet tweet, RepliesResult lastResult) async {
    final RepliesResult result = await twitterApi.tweetSearchService
        .findReplies(tweet, lastResult)
        .catchError((e) => _log.severe(e.toString()));

    if (result != null) {
      result.replies.sort((api.Tweet a, api.Tweet b) {
        return b.favoriteCount - a.favoriteCount;
      });
    }

    return result;
  }
}
