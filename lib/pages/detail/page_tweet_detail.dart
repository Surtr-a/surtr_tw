import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:surtr_tw/controllers/tweet_detail_controller.dart';
import 'package:surtr_tw/pages/detail/body.dart';

class TweetDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tweet'),),
      body: Column(
        children: [
          Body(),
          _replyInput
        ],
      ),
    );
  }

  Widget get _replyInput {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Tweet your reply',
        suffixIcon: Icon(Icons.camera_alt_outlined),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey
          )
        )
      ),
    );
  }
}