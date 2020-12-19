import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:surtr_tw/material/drawer.dart';
import 'package:surtr_tw/pages/main/page_home.dart';
import 'package:surtr_tw/pages/main/page_messages.dart';
import 'package:surtr_tw/pages/main/page_notifications.dart';
import 'package:surtr_tw/pages/main/page_search.dart';

final Logger _log = Logger('MainPage');

final GlobalKey key = GlobalKey();

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  List<Widget> _children = [HomePage(key: key,), SearchPage(), NotificationsPage(), MessagesPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: .3, color: Colors.grey))
        ),
        child: Builder(
          builder: (BuildContext context) {
            return NotificationListener<DrawerNotification>(
              child: IndexedStack(
                index: _currentIndex,
                children: _children,
              ),
              onNotification: (notification) {
                if (notification != null) {
                  Scaffold.of(context).openDrawer();
                }
                return true;
              },
            );
          },
        ),
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
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      iconSize: 28,
      selectedItemColor: Theme.of(context).accentColor,
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
        if (_currentIndex != index) {
          setState(() {
            _currentIndex = index;
          });
        }
      },
    );
  }
}

class DrawerNotification extends Notification {}