import 'package:get/get.dart';
import 'package:surtr_tw/repositories/local_search_history_repository.dart';

class SearchDelegateController extends GetxController {
  List<String> _histories = <String>[];

  List<String> get histories => _histories;

  void updateOrder(String query) {
    _histories.remove(query);
    _histories.insert(0, query);
    LocalSearchHistoryRepository.saveSearchHistories(_histories);
  }

  void getHistories() {
    var h = LocalSearchHistoryRepository.getSearchHistories();
    if (h != null && h.length != 0) {
      _histories.clear();
      _histories.addAll(h);
    }
  }

  void clearAll() {
    _histories.clear();
    LocalSearchHistoryRepository.saveSearchHistories(_histories);
    update();
  }
  
  void clear(String history) {
    _histories.remove(history);
    LocalSearchHistoryRepository.saveSearchHistories(_histories);
    update();
  }

  void submit(String query) {
    if (!_histories.contains(query)) {
      _histories.insert(0, query);
    }
    LocalSearchHistoryRepository.saveSearchHistories(_histories);
  }
}