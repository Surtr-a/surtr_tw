import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Logger _log = Logger('LocalSearchHistoryRepository');

class LocalSearchHistoryRepository {
  static final String _keySearchHistory = 'key_search_history';

  static saveSearchHistories(List<String> histories) {
    SharedPreferences sp = Get.find<SharedPreferences>();
    sp.setStringList(_keySearchHistory, histories);
  }

  static List<String> getSearchHistories() {
    SharedPreferences sp = Get.find<SharedPreferences>();
    try {
      List<String> histories = sp.getStringList(_keySearchHistory);
      return histories;
    } catch (e) {
      _log.severe(e);
      return null;
    }
  }
}