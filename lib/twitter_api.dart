import 'package:dart_twitter_api/twitter_api.dart' as api;
import 'package:get/get.dart';
import 'package:surtr_tw/app_config.dart';

class TwitterApi extends GetxService {
  api.TwitterApi init() {
    final AppConfigData appConfigData = Get.find<AppConfigData>();
    api.TwitterApi twitterApi= api.TwitterApi(
        client: api.TwitterClient(
            consumerKey: appConfigData.twitterConsumerKey,
            consumerSecret: appConfigData.twitterConsumerSecret,
            token: appConfigData.token,
            secret: appConfigData.tokenSecret));
    return twitterApi;
  }
}