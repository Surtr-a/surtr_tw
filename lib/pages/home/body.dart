import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:surtr_tw/components/app_routes.dart';
import 'package:surtr_tw/controllers/home_controller.dart';
import 'package:surtr_tw/components/utils/utils.dart';
import 'package:surtr_tw/material/tweet_list_tile.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: HomeController(),
        builder: (_) {
          return MediaQuery.removePadding(
            context: Get.context,
            removeTop: true,
            child: Scrollbar(
              thickness: 4,
              child: SmartRefresher(
                header: MaterialClassicHeader(
                  color: CustomColor.TBlue,
                ),
                controller: _.refreshController,
                onRefresh: _.onRefresh,
                enablePullUp: true,
                onLoading: _.onLoadMore,
                child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      return TweetListTile(_.homeTimeline[index], false,);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider();
                    },
                    itemCount: _.homeTimeline.length),
              ),
            ),
          );
        });
  }
}
