import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surtr_tw/components/utils/utils.dart';
import 'package:surtr_tw/controllers/tweet_detail_controller.dart';
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
                    child: TweetListTile(controller.tweet, true, true)),
                controller.replies.length == 0
                    ? _indicator
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                        return TweetListTile(
                            controller.replies[index], false, false, replyScreenName: controller.replies[index].inReplyToScreenName,);
                      }, childCount: controller.replies.length))
              ],
          ),
        );
      }
    );
  }

  Widget get _indicator {
    return SliverToBoxAdapter(
      child: Center(
        child: Container(
          width: 12,
          height: 12,
          child: cpi.CircularProgressIndicator(
            valueColor:
            AlwaysStoppedAnimation<Color>(CustomColor.TBlue),
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}