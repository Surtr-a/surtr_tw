import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:get/get.dart';

class AuthenticationService extends GetxService {
  Future<AuthenticationDate> init() async {

  }
}


class AuthenticationDate {
  TwitterLogin twitterLogin;

  TwitterSession twitterSession;

  User user;


}
