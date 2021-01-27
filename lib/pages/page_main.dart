import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surtr_tw/components/utils/color.dart';
import 'package:surtr_tw/controllers/main_controller.dart';
import 'package:surtr_tw/material/drawer.dart';
import 'package:surtr_tw/pages/home/page_home.dart';
import 'package:surtr_tw/pages/message/page_messages.dart';
import 'package:surtr_tw/pages/notification/page_notifications.dart';
import 'package:surtr_tw/pages/trends/page_trends.dart';

// final Logger _log = Logger('MainPage');
final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

class MainPage extends GetView<MainController> {
  final List<Widget> _children = [HomePage(_globalKey), TrendsPage(), NotificationsPage(), MessagesPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: .6, color: CustomColor.DivGrey))),
        child: Obx(() => IndexedStack(
          index: controller.currentIndex.value,
          children: _children,
        )),
      ),
      bottomNavigationBar: _buildBottomNavBar,
      drawer: FlexibleDrawer(
        child: ListView(
          children: [Text('sss')],
        ),
      ),
    );
  }

  get _buildBottomNavBar {
    return BottomNavigationBar(
      elevation: 0,
      currentIndex: controller.currentIndex.value,
      type: BottomNavigationBarType.fixed,
      iconSize: 28,
      selectedItemColor: Theme.of(Get.context).accentColor,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
        BottomNavigationBarItem(label: 'Search', icon: Icon(Icons.search)),
        BottomNavigationBarItem(
            label: 'Notifications', icon: Icon(Icons.notifications)),
        BottomNavigationBarItem(
            label: 'Messages', icon: Icon(Icons.email_outlined)),
      ],
      onTap: (index) {
        // if (controller.currentIndex != index) {
        //   controller.changeIndex(index);
        // }
        controller.currentIndex.value = index;
      },
    );
  }
}
