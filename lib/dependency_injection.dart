// 依赖注入
import 'package:get/get.dart';
import 'package:surtr_tw/app_config.dart';
import 'package:surtr_tw/components/providers/login_provider.dart';
import 'package:surtr_tw/controllers/app_sp_controller.dart';
import 'package:surtr_tw/twitter_api.dart';

class DependencyInjection {
  static Future<void> init() async {
    // shared_preference
    await Get.putAsync(() => AppSpController().init());
    // key & secret
    await Get.putAsync(() => AppConfig().init());
    // api
    Get.put(TwitterApi().init());
    // 登录信息提供者
    Get.put(LoginProvider());
  }
}