import 'package:dart_twitter_api/api/tweets/tweet_search_service.dart';
import 'package:dart_twitter_api/twitter_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surtr_tw/app_config.dart';

class TwitterApi extends GetxService {
  api.TwitterApi init() {
    final AppConfigData appConfigData = Get.find<AppConfigData>();
    api.TwitterApi twitterApi = api.TwitterApi(
        client: api.TwitterClient(
            consumerKey: appConfigData.twitterConsumerKey,
            consumerSecret: appConfigData.twitterConsumerSecret,
            token: appConfigData.token,
            secret: appConfigData.tokenSecret));
    return twitterApi;
  }
}

extension RepliesExtension on TweetSearchService {
  /// Returns a [RepliesResult] that contains paginated replies for the [tweet].
  ///
  /// When the [lastResult] is included, only replies after the last response
  /// will be searched for.
  ///
  /// When [RepliesResult.lastPage] is `true`, we assume that no more replies
  /// can be found.
  ///
  /// There is a chance that more replies can be found, because to retrieve
  /// the replies we get the last 100 user replies, filter those for the [tweet]
  /// and if the request didn't yield replies twice in a row we assume that
  /// we won't get any more.
  /// We could request until we received all of the user replies of the last
  /// 7 days to make sure every reply to the [tweet] has been found but that
  /// could mean many requests without any replies.
  ///
  /// Throws an exception when the [searchTweets] did not return a 200 response.
  Future<RepliesResult> findReplies(
      api.Tweet tweet,
      RepliesResult lastResult,
      ) async {
    final String screenName = tweet.user.screenName;

    final String maxId =
    lastResult == null ? null : '${int.tryParse(lastResult.maxId) + 1}';

    final api.TweetSearch result = await searchTweets(
      q: 'to:$screenName',
      sinceId: tweet.idStr,
      count: 100,
      maxId: maxId,
    );

    final List<api.Tweet> replies = <api.Tweet>[];

    // filter found tweets by replies
    for (api.Tweet reply in result.statuses) {
      if (reply.inReplyToStatusIdStr == tweet.idStr) {
        replies.add(reply);
      }
    }

    // expect no more replies exists if no replies in the last 2 requests have
    // been found
    final bool isLastPage = result.statuses.length < 100 ||
        (lastResult?.replies?.isEmpty == true && replies.isEmpty);

    return RepliesResult(
      replies: replies,
      maxId: result.statuses.isEmpty ? '0' : result.statuses.last.idStr,
      isLastPage: isLastPage,
    );
  }
}

/// Paginated result for replies to a tweet
class RepliesResult {
  RepliesResult({
      @required this.replies,
      @required this.maxId,
      @required this.isLastPage
  });

  /// The list of replies to a tweet
  final List<api.Tweet> replies;

  /// The id of the last replay
  final String maxId;

  /// 'true' when we assume we can't receive more replies
  final bool isLastPage;
}
