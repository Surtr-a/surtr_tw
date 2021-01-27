import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:surtr_tw/components/app_routes.dart';
import 'package:surtr_tw/components/utils/color.dart';
import 'package:surtr_tw/controllers/home_controller.dart';
import 'package:surtr_tw/material/tweet_list_tile.dart';
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
          return NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[_appBar, SliverToBoxAdapter(child: Divider(color: CustomColor.DivGrey, thickness: .6, height: .6))];
              },
              body: MediaQuery.removePadding(
                context: Get.context,
                removeTop: true,
                child: Scrollbar(
                  thickness: 4,
                  child: SmartRefresher(
                    header: MaterialClassicHeader(color: CustomColor.TBlue,),
                    controller: controller.refreshController,
                    onRefresh: controller.onRefresh,
                    child: ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                          onTap: () => Get.toNamed(Routes.TWEET_DETAIL,
                              arguments: controller.homeTimeline[index]),
                          child: TweetListTile(
                              controller.homeTimeline[index], index == 0, false));
                    }, itemCount: controller.homeTimeline.length),
                  ),
                ),
              ), floatHeaderSlivers: true);
        });
  }

  get _appBar {
    return SliverAppBar(
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
