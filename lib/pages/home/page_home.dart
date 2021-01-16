import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surtr_tw/controllers/home_controller.dart';
import 'package:surtr_tw/pages/home/home_timeline_tile.dart';
import 'package:surtr_tw/repositories/twitter_reposity.dart';

// final Logger _log = Logger('HomePage');
class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _globalKey;
  HomePage(this._globalKey);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => TwitterRepository());

    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return CustomScrollView(
          slivers: [
            _appBar,
            SliverList(
                delegate:
                    SliverChildBuilderDelegate((BuildContext context, int index) {
              return TweetListTile(context, controller.homeTimeline[index], index == 0);
              // return Geni
            }, childCount: controller.homeTimeline.length))
          ],
        );
      }
    );
  }

  get _appBar {
    return SliverAppBar(
      elevation: .8,
      shadowColor: Colors.grey,
      floating: true,
      title: Text(
        'Twitter',
        style: TextStyle(color: Theme.of(Get.context).accentColor),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.account_circle,
        ),
        onPressed: () {
          _globalKey.currentState.openDrawer();
        },
      ),
      actions: [
        IconButton(
            icon: Icon(
              Icons.star_border,
              color: Theme.of(Get.context).accentColor,
            ),
            onPressed: null)
      ],
    );
  }
}
