import 'package:dart_twitter_api/twitter_api.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:surtr_tw/repositories/local_search_history_repository.dart';
import 'package:surtr_tw/repositories/twitter_repository.dart';

// final Logger _log = Logger('TrendsController');

class TrendsController extends GetxController {
  final TwitterRepository _twitterRepository = Get.find<TwitterRepository>();
  List<TrendLocation> _trendLocations = <TrendLocation>[];
  List<Trends> _trends = <Trends>[];
  final RefreshController refreshController = RefreshController(initialRefresh: true);

  List<Trends> get trends => _trends;

  List<TrendLocation> get trendLocations => _trendLocations;

  @override
  void onInit() {
    super.onInit();
    availableLocations();
  }

  onRefresh() async {
    if (_trendLocations == null || _trendLocations.length == 0) {
      await availableLocations();
    }
    var country = _trendLocations.where((element) => element.countryCode == Get.deviceLocale.countryCode).toList();
    List<Trends> result = await _twitterRepository.loadTrends(id: country.length != 0 ? country[0].parentid : 1);
    if (result == null) {
      refreshController.refreshFailed();
      return;
    } else {
      _trends.addAll(result);
      update();
      refreshController.refreshCompleted();
    }
    if (result.length == 0) {
      refreshController.loadNoData();
    }
  }

  Future<void> availableLocations() async {
    List<TrendLocation> result = await _twitterRepository.availableLocations();
    if (result != null && result.length != 0) {
      _trendLocations.clear();
      _trendLocations.addAll(result);
      update();
    }
  }
}