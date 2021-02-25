import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:surtr_tw/components/app_routes.dart';
import 'package:surtr_tw/components/providers/app_config.dart';
import 'package:surtr_tw/components/providers/login_provider.dart';
import 'package:surtr_tw/repositories/twitter_repository.dart';

final Logger _log = Logger('LoginController');

class LoginController extends GetxController {
  LoginProvider _loginProvider = Get.find<LoginProvider>();
  // TwitterRepository _twitterRepository = Get.find<TwitterRepository>();
  AppConfigData _appConfigData = Get.find<AppConfigData>();
  
  @override
  Future<void> onReady() async {
    super.onReady();
    _log.fine('isLogin------------------------>${_loginProvider.isLogin()}');
    if (_loginProvider.isLogin()) {
      Get.offNamed(Routes.MAIN);
    } else {
      // 暂时跳转MAIN
      // Get.offNamed(Routes.MAIN);
      TwitterLogin twitterLogin = TwitterLogin(consumerKey: _appConfigData.twitterConsumerKey, consumerSecret: _appConfigData.twitterConsumerSecret);
      await twitterLogin.authorize();
    }
  }
}