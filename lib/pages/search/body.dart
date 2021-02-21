import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:surtr_tw/components/utils/utils.dart';
import 'package:surtr_tw/controllers/search_controller.dart';
import 'package:surtr_tw/material/loading.dart';
import 'package:surtr_tw/material/tweet_list_tile.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SearchController controller = Get.find();
    return GetBuilder<SearchController>(
        init: controller,
        builder: (_) {
          if (_.result.length == 0) {
            return Loading();
          } else {
            return SmartRefresher(
              controller: _.refreshController,
              header: MaterialClassicHeader(
                color: CustomColor.TBlue,
              ),
              onRefresh: _.onRefresh,
              child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return TweetListTile(_.result[index], false, query: _.query,);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                  itemCount: _.result.length),
            );
          }
        });
  }
}
