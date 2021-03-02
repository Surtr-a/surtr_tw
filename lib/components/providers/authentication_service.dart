import 'dart:async';

import 'package:dart_twitter_api/twitter_api.dart' as api;
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:surtr_tw/components/app_routes.dart';
import 'package:surtr_tw/components/providers/app_config.dart';
import 'package:surtr_tw/components/providers/twitter_api.dart';
import 'package:surtr_tw/repositories/local_login_model_repository.dart';
import 'package:surtr_tw/repositories/twitter_repository.dart';

final Logger _log = Logger('Authentication');

class AuthenticationService extends GetxService {
  Future<Authentication> init() async {
    await _authentication.initializeTwitterSession();
    return _authentication;
  }
}

Authentication _authentication = Authentication._();

class Authentication{
  Authentication._();

  TwitterLogin twitterLogin;

  TwitterSession twitterSession;

  Completer<bool> sessionInitialization = Completer<bool>();

  Future<void> initializeTwitterSession() async {
    final AppConfigData appConfigData = Get.find<AppConfigData>();

    if (appConfigData != null) {
      twitterLogin = TwitterLogin(
          consumerKey: appConfigData.twitterConsumerKey,
          consumerSecret: appConfigData.twitterConsumerSecret);
    }

    twitterSession = await twitterLogin.currentSession;

    if (twitterSession != null) {
      if (await _onLogin(twitterSession)) {
        _log.fine('authenticated');
        sessionInitialization.complete(true);
        return;
      }
    }

    sessionInitialization.complete(false);
  }

  Future<void> login() async {
    final TwitterLoginResult result = await twitterLogin?.authorize();

    switch (result?.status) {
      case TwitterLoginStatus.loggedIn:
        _log.fine('successfully logged in');
        twitterSession = result.session;

        if (await _onLogin(twitterSession)) {
          Get.find<TwitterRepository>().updateApi();
          Get.offAllNamed(Routes.MAIN);
        } else {
          await _onLogout();
        }
        break;
      case TwitterLoginStatus.cancelledByUser:
        Get.back();
        break;
      case TwitterLoginStatus.error:
      default:
        _log.warning('error during login');
        // toast('Authentication failed, please try again.');
        break;
    }
  }

  Future<void> logout() async {
    _log.fine('logged out');
    await _onLogout();

    Get.offAllNamed(Routes.LOGIN);
  }

  Future<bool> _onLogin(TwitterSession session) async {
    final AppConfigData appConfigData = Get.find<AppConfigData>();
    final List<String> tokenCache = LocalLoginModelRepository.getCurrentLoginTokenAndSecret();

    // compare with token cache
    if (tokenCache != null &&
        session.token == tokenCache[0] &&
        session.secret == tokenCache[1]) {
      final bool initialized =
          await _initializeAuthenticatedUser(Get.find<api.TwitterApi>());
      return initialized;
    } else {
      LocalLoginModelRepository.saveCurrentLoginTokenAndSecret(
          [session.token, session.secret]);
    }

    api.TwitterApi twitterApi = api.TwitterApi(
        client: api.TwitterClient(
            consumerKey: appConfigData.twitterConsumerKey,
            consumerSecret: appConfigData.twitterConsumerSecret,
            token: session.token ?? '',
            secret: session.secret ?? ''));


    final bool initialized = await _initializeAuthenticatedUser(twitterApi);

    if (initialized) {
      _log.fine('User initialization successfully');
      Get.delete<api.TwitterApi>();
      Get.put(TwitterApi().init(twitterApi: twitterApi));
    }

    return initialized;
  }

  Future<void> _onLogout() async {
    _log.fine('onLogout');
    await twitterLogin.logOut();

    // wait until navigation changed to clear user information to avoid
    // rebuilding the home screen without an authenticated user and therefore
    // causing unexpected errors
    Future<void>.delayed(const Duration(milliseconds: 400)).then((_) {
      twitterSession = null;
      LocalLoginModelRepository.saveCurrentLoginModel(null);
      LocalLoginModelRepository.saveCurrentLoginTokenAndSecret(null);
    });
  }

  Future<bool> _initializeAuthenticatedUser(api.TwitterApi twitterApi) async {
    final String userId = twitterSession.userId;

    api.User authenticatedUser = await twitterApi?.userService
        ?.usersShow(userId: userId)
        ?.catchError((e) => _log.warning(e));
    LocalLoginModelRepository.saveCurrentLoginModel(authenticatedUser);

    return authenticatedUser != null;
  }
}
