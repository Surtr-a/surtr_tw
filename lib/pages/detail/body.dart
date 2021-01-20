import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:surtr_tw/controllers/tweet_detail_controller.dart';
import 'package:surtr_tw/material/home_timeline_tile.dart';

class Body extends GetView<TweetDetailController> {
  @override
  Widget build(BuildContext context) {
    return TweetListTile(controller.tweet, true);
  }
}