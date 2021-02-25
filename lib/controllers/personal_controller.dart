import 'package:dart_twitter_api/twitter_api.dart';
import 'package:get/get.dart';
import 'package:surtr_tw/repositories/twitter_repository.dart';

class PersonalController extends GetxController {
  TwitterRepository _twitterRepository = Get.find<TwitterRepository>();
  User user;
}