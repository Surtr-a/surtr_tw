import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:surtr_tw/components/app_routes.dart';
import 'package:surtr_tw/components/utils/color.dart';

final Logger _log = Logger('PageSplash');

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Align(
              alignment: Alignment(-.78, -.83),
              child: Image.asset('assets/images/twitter.png', scale: 8, color: CustomColor.TBlue,),
            ),
            Align(
              alignment: Alignment(0, 0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'See what\'s happening in the world right now.',
                      style: TextStyle(fontSize: 32, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 36),
                      child: FlatButton(
                          minWidth: double.infinity,
                          color: CustomColor.TBlue,
                          shape: StadiumBorder(),
                          onPressed: () {
                            Get.offNamed(Routes.MAIN);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              'Log in',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
