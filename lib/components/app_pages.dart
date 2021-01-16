import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:surtr_tw/bindings/main_binding.dart';
import 'package:surtr_tw/bindings/splash_binding.dart';
import 'package:surtr_tw/components/app_routes.dart';
import 'package:surtr_tw/pages/page_main.dart';
import 'package:surtr_tw/pages/splash/page_splash.dart';

final Logger _log = Logger('Route');


final pages = [
  GetPage(name: Routes.MAIN, page: () => MainPage(), binding: MainBinding()),
  GetPage(name: Routes.SPLASH, page: () => SplashPage(), binding: SplashBinding())
];