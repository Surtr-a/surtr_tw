import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:surtr_tw/bindings/main_binding.dart';
import 'package:surtr_tw/components/app_pages.dart';
import 'package:surtr_tw/components/app_routes.dart';
import 'package:surtr_tw/components/utils/utils.dart';
import 'package:surtr_tw/components/dependency_injection.dart';
import 'package:surtr_tw/pages/main/page_main.dart';
import 'package:surtr_tw/repositories/twitter_repository.dart';

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
        home: MainPage(),
        initialBinding: MainBinding(),
        theme: ThemeData(
          cursorColor: CustomColor.TBlue,
          primaryColor: Colors.white,
          accentColor: CustomColor.TBlue,
          unselectedWidgetColor: Colors.grey,
          highlightColor: CustomColor.highlightBlue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          dividerColor: CustomColor.divGrey,
          dividerTheme: DividerThemeData(space: .6, thickness: .6),
          buttonTheme: ButtonThemeData(
            minWidth: 0,
            height: 0,
            padding: EdgeInsets.zero
          )
        ),
        // routingCallback: (routing) {
        //   if (routing.previous == Routes.LOGIN) {
        //     Get.find<TwitterRepository>().updateApi();
        //   }
        // },
      ),
    );
  }
}
