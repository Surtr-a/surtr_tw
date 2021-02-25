import 'dart:async';
import 'package:dart_twitter_api/twitter_api.dart' as api;
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:surtr_tw/components/providers/twitter_api.dart';

class TwitterRepository {
  static final Logger _log = Logger('TwitterRepository');

  final api.TwitterApi _twitterApi = Get.find<api.TwitterApi>();

  Future<List<api.Tweet>> homeTimeline() async {
    return await _twitterApi.timelineService
        .homeTimeline(count: 30, includeEntities: true, excludeReplies: false)
        .catchError((e) => _log.severe(e.toString()));
  }

  Future<RepliesResult> loadReplies(
      api.Tweet tweet, RepliesResult lastResult) async {
    final RepliesResult result = await _twitterApi.tweetSearchService
        .findReplies(tweet, lastResult)
        .catchError((e) => _log.severe(e.toString()));

    if (result != null) {
      result.replies.sort((api.Tweet a, api.Tweet b) {
        return b.favoriteCount - a.favoriteCount;
      });
    }

    return result;
  }

  Future<List<Trends>> loadTrends({@required int id, String exclude}) async {
    return await _twitterApi.trendsService
        .place(id: id, exclude: exclude)
        .catchError((e) => _log.severe(e.toString()));
  }

  Future<List<TrendLocation>> availableLocations() async {
    return await _twitterApi.trendsService
        .available()
        .catchError((e) => _log.severe(e.toString()));
  }

  Future<api.TweetSearch> searchTweets(
      {@required String q,
      int count,
      String untilDate,
      String sinceId,
      String maxId}) async {
    return await _twitterApi.tweetSearchService
        .searchTweets(
            q: q,
            count: count,
            until: untilDate,
            sinceId: sinceId,
            maxId: maxId)
        .catchError((e) => _log.severe(e.toString()));
  }

  Future<User> usersShow({
    String userId,
    String screenName,
    bool includeEntities,
  }) async {
    return await _twitterApi.userService
        .usersShow(
            userId: userId,
            screenName: screenName,
            includeEntities: includeEntities)
        .catchError((e) => _log.severe(e.toString()));
  }
}
