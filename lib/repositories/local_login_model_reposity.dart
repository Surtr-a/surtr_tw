
import 'dart:convert';

import 'package:dart_twitter_api/twitter_api.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _key_current_login_model = 'current_kogin_model';

final Logger _log = Logger('LocalLoginModelRepository');

class LocalLoginModelRepository {

  static saveCurrentLoginModel(User user) {
    SharedPreferences sp = Get.find<SharedPreferences>();
    sp.setString(_key_current_login_model, jsonEncode(user.toJson()));
  }

  static User getCurrentLoginModel() {
    SharedPreferences sp = Get.find<SharedPreferences>();
    try {
      var json = sp.getString(_key_current_login_model);
      return User.fromJson(jsonDecode(json));
    } catch (e) {
      _log.warning(e.toString());
      return null;
    }
  }
}