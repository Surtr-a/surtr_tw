import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:surtr_tw/components/utils/utils.dart';
import 'package:surtr_tw/pages/detail/body.dart';

class TweetDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tweet'),
        iconTheme: IconThemeData(color: Colors.blue),
        elevation: .8,
        shadowColor: Colors.grey,
      ),
      body: Column(
        children: [Body(), Divider(height: 1, thickness: 1,), _replyInput],
      ),
    );
  }

  Widget get _replyInput {
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 0, 12, 6),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Tweet your reply',
          suffixIcon: Icon(Icons.camera_alt_outlined, color: CustomColor.TBlue,),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFFCCD7DD),
              width: 1.2
            )
          )
        ),
      ),
    );
  }
}