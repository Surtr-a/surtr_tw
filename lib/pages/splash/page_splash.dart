import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:surtr_tw/controllers/splash_controller.dart';

final Logger _log = Logger('PageSplash');

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(builder: (_) {
      return Container(
        color: Colors.blue,
      );
    });
  }
}
