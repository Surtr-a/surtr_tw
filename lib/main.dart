import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:surtr_tw/component/route.dart';
import 'package:surtr_tw/pages/splash/page_splash.dart';
import 'package:surtr_tw/repository/twitter.dart';
import 'package:surtr_tw/app_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _initLogger();
  // 状态栏颜色
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xFFeaeaea)));
  runApp(PageSplash(
    futures: [
      // SharedPreferences.getInstance()
      // initializeAppConfig()
      appConfig.loadAppConfig()
    ],
    builder: (context, data) {
      if (data[0] == true) {
        twitterRepository = TwitterRepository();
      }
      return MyApp();
    },
  ));
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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SurTW',
        routes: routes,
        onGenerateRoute: routeFactory,
        theme: ThemeData(
          appBarTheme: AppBarTheme(elevation: 0),
          primaryColor: Colors.white,
          accentColor: Colors.blue,
          unselectedWidgetColor: Colors.grey,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          dividerColor: Colors.grey
        ),
      ),
    );
  }
}
