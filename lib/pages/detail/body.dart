import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surtr_tw/components/utils/utils.dart';
import 'package:surtr_tw/controllers/tweet_detail_controller.dart';
import 'package:surtr_tw/material/loading.dart';
import 'package:surtr_tw/material/tweet_list_tile.dart';
import 'package:surtr_tw/material/circular_progress_indicator.dart' as cpi;

class Body extends GetView<TweetDetailController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TweetDetailController>(
      init: controller,
      builder: (_) {
        return Expanded(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                  child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: .6, color: CustomColor.divGrey))),
                        child: TweetListTile(_.tweet, true,))),
                _.replies.length == 0
                    ? SliverToBoxAdapter(child: Loading(),)
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(width: .6, color: CustomColor.divGrey))
                          ),
                          child: TweetListTile(
                              _.replies[index], false, replyScreenName: _.replies[index].inReplyToScreenName,),
                        );
                      }, childCount: _.replies.length))
              ],
          ),
        );
      }
    );
  }
}