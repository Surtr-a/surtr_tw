import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:surtr_tw/bindings/main_binding.dart';
import 'package:surtr_tw/bindings/personal_binding.dart';
import 'package:surtr_tw/bindings/search_binding.dart';
import 'package:surtr_tw/bindings/login_binding.dart';
import 'package:surtr_tw/bindings/tweet_detail_binding.dart';
import 'package:surtr_tw/components/app_routes.dart';
import 'package:surtr_tw/pages/detail/page_tweet_detail.dart';
import 'package:surtr_tw/pages/main/page_main.dart';
import 'package:surtr_tw/pages/personal/page_personal.dart';
import 'package:surtr_tw/pages/search/page_search.dart';
import 'package:surtr_tw/pages/login/page_login.dart';

final Logger _log = Logger('Route');

final pages = [
  GetPage(name: Routes.MAIN, page: () => MainPage(), binding: MainBinding()),
  GetPage(name: Routes.LOGIN, page: () => LoginPage(), binding: LoginBinding()),
  GetPage(name: Routes.TWEET_DETAIL, page: () => TweetDetailPage(), binding: TweetDetailBinding()),
  GetPage(name: Routes.SEARCH, page: () => SearchPage(), binding: SearchBinding()),
  GetPage(name: Routes.PERSONAL, page: () => PersonalPage(), binding: PersonalBinding()),
];