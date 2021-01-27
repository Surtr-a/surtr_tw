import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:surtr_tw/bindings/splash_binding.dart';
import 'package:surtr_tw/components/app_pages.dart';
import 'package:surtr_tw/components/utils/utils.dart';
import 'package:surtr_tw/dependency_injection.dart';
import 'package:surtr_tw/pages/splash/page_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 初始化 Logger
  _initLogger();
  // 依赖注入
  await DependencyInjection.init();
  // 状态栏颜色
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xFFeaeaea)));
  runApp(MyApp());
}

_initLogger() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('[-->${record.loggerName}<--]: ${record.level.name}: ${record.time}: ${record.message}');
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPaintSizeEnabled = false;
    return OverlaySupport(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SurTW',
        initialRoute: '/',
        getPages: pages,
        home: SplashPage(),
        initialBinding: SplashBinding(),
        theme: ThemeData(
          appBarTheme: AppBarTheme(elevation: 0),
          primaryColor: Colors.white,
          accentColor: CustomColor.TBlue,
          unselectedWidgetColor: Colors.grey,
          highlightColor: CustomColor.highlightBlue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          dividerColor: Color(0xFFCCD7DD),
        ),
      ),
    );
  }
}
