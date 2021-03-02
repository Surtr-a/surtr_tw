import 'package:get/get.dart';
import 'package:dart_twitter_api/twitter_api.dart' as api;
import 'package:surtr_tw/components/providers/app_config.dart';
import 'package:surtr_tw/repositories/local_login_model_repository.dart';

class TwitterApi extends GetxService {
  api.TwitterApi init({api.TwitterApi twitterApi}) {
    final AppConfigData appConfigData = Get.find<AppConfigData>();
    final List<String> tokenPair = LocalLoginModelRepository.getCurrentLoginTokenAndSecret();

    return twitterApi ?? api.TwitterApi(
        client: api.TwitterClient(
            consumerKey: appConfigData.twitterConsumerKey,
            consumerSecret: appConfigData.twitterConsumerSecret,
            token: tokenPair != null ? tokenPair[0] ?? '' : '',
            secret: tokenPair != null ? tokenPair[1] ?? '' : ''));
  }
}