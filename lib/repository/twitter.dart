
import 'dart:async';

import 'package:dart_twitter_api/twitter_api.dart';
import 'package:logging/logging.dart';
import 'package:surtr_tw/app_config.dart';

TwitterRepository twitterRepository;

class TwitterRepository {
  static final Logger _log = Logger('TwitterRepository');

  TwitterApi twitterApi;

  TwitterRepository() {
    twitterApi= TwitterApi(
        client: TwitterClient(
            consumerKey: appConfig.data.twitterConsumerKey,
            consumerSecret: appConfig.data.twitterConsumerSecret,
            token: appConfig.data.token,
            secret: appConfig.data.tokenSecret));
  }

  Future<List<Tweet>> homeTimeline() async {
    return await twitterApi.timelineService
        .homeTimeline(count: 20, includeEntities: true, excludeReplies: false)
        .catchError((e) => _log.severe(e.toString()));
  }
}