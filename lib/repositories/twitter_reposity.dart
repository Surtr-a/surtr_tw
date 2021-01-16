
import 'dart:async';

import 'package:dart_twitter_api/twitter_api.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';

class TwitterRepository {
  static final Logger _log = Logger('TwitterRepository');

  final TwitterApi twitterApi = Get.find<TwitterApi>();

  Future<List<Tweet>> homeTimeline() async {
    return await twitterApi.timelineService
        .homeTimeline(count: 30, includeEntities: true, excludeReplies: false)
        .catchError((e) => _log.severe(e.toString()));
  }
}