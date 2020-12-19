import 'dart:collection';
import 'dart:core';
import 'dart:ffi';

import 'package:dart_twitter_api/api/tweets/data/tweet.dart';
import 'package:dart_twitter_api/api/users/data/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:surtr_tw/component/utils/utils.dart';
import 'package:surtr_tw/pages/main/simple_list_tile.dart';

final Logger _log = Logger('HomeTimelineTile');

class TweetListTile extends StatelessWidget {
  TweetListTile(this.context, this.tweet, this.isFirst)
      : isRetweeted = tweet.retweetedStatus != null,
        isQuoted = tweet.isQuoteStatus,
        sourceTweet =
            tweet.retweetedStatus == null ? tweet : tweet.retweetedStatus;

  final BuildContext context;
  final Tweet tweet;
  final Tweet sourceTweet;
  final bool isFirst;
  final bool isRetweeted;
  final bool isQuoted;

  Widget get _typeIcon {
    if (isRetweeted) {
      return SizedBox(
        height: 20,
      );
    } else {
      return Container();
    }
  }

  Widget get _typeWord {
    if (isRetweeted) {
      return Text(
        '${tweet.user.screenName} Retweeted',
        style: TextStyleManager.grey_15,
      );
    } else {
      return Container();
    }
  }

  Widget get _headImage {
    String obtainedUrl = sourceTweet.user.profileImageUrlHttps;
    // 改为原图Url
    String originalVariant = obtainedUrl.replaceAll('_normal.', '.');

    return Padding(
      padding: EdgeInsets.only(top: 4),
      child: _buildHeadImage(originalVariant),
    );
  }

  Widget get _userName {
    return _buildUserName(sourceTweet.user.name, sourceTweet.user.screenName);
  }

  // 推文正文
  Widget get _contentText {
    var isTag = Map<int, bool>();

    var tagQueue = Queue<int>();
    var urlQueue = Queue<int>();
    String fullText = sourceTweet.fullText;
    // 正文截断
    fullText = fullText.substring(
        sourceTweet.displayTextRange[0], sourceTweet.displayTextRange[1]);
    for (int i = 0; i < sourceTweet.entities.urls.length; ++i) {
      // url 替换
      fullText = fullText.replaceRange(
          sourceTweet.entities.urls[i].indices[0],
          sourceTweet.entities.urls[i].indices[1],
          sourceTweet.entities.urls[i].displayUrl);
      // url indexes
      isTag.addAll({sourceTweet.entities.urls[i].indices[0]: false});
      urlQueue.add(sourceTweet.entities.urls[i].indices[0] +
          sourceTweet.entities.urls[i].displayUrl.length);
    }
    // tag indexes
    for (int i = 0; i < sourceTweet.entities.hashtags.length; ++i) {
      isTag.addAll({sourceTweet.entities.hashtags[i].indices[0]: true});
      tagQueue.add(sourceTweet.entities.hashtags[i].indices[1]);
    }
    var sortedKey = isTag.keys.toList()..sort();

    // _log.fine('-------------------${fullText.length}');
    // return Text(
    //   fullText,
    //   maxLines: 20,
    //   style: TextStyleManager.black_23,
    // );
    int last = 0;
    List<TextSpan> spanList;
    sortedKey.map((int index) {
      spanList.addAll([
        if (index != last) _buildCommonText(fullText.substring(last, index)),
        isTag[index]
            ? _buildTagText(
                fullText.substring(index, last = tagQueue.removeFirst()))
            : _buildUrlText(
                fullText.substring(index, last = urlQueue.removeFirst())),
        if (tagQueue.isEmpty && urlQueue.isEmpty && last != fullText.length)
          _buildCommonText(fullText.substring(last, fullText.length))
      ]);
    });
    return Text.rich(TextSpan(children: spanList));
  }

  TextSpan _buildCommonText(String text) {
    return TextSpan(
      text: text,
      style: TextStyleManager.black_23,
    );
  }

  TextSpan _buildUrlText(String text) {
    return TextSpan(
      text: text,
      style: TextStyleManager.blue_23,
    );
  }

  TextSpan _buildTagText(String text) {
    return TextSpan(
      text: text,
      style: TextStyleManager.blue_23,
    );
  }

  Widget get _media {
    if (sourceTweet.entities != null && sourceTweet.entities.media != null) {
      String mediaUrl = sourceTweet.entities.media[0].mediaUrlHttps;

      if (sourceTweet.entities.media[0].type == 'photo') {
        return _buildContentImage(mediaUrl);
      } else {
        return Container();
      }
    } else
      return Container();
  }

  Widget get _options {
    return IconTheme(
      data: IconThemeData(color: Colors.grey, size: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildOptionItem(
              Icons.mode_comment_outlined, sourceTweet.replyCount.toString()),
          _buildOptionItem(
              Icons.repeat_outlined, sourceTweet.retweetCount.toString()),
          _buildOptionItem(
              Icons.favorite_outline, sourceTweet.favoriteCount.toString()),
          _buildOptionItem(Icons.share_outlined, ''),
          SizedBox(
            width: 1,
          )
        ],
      ),
    );
  }

  Widget get _title {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _userName,
        IconButton(
          iconSize: 18,
          color: Colors.grey,
          icon: Icon(Icons.keyboard_arrow_down),
          onPressed: () {
            _showBottomSheet(sourceTweet);
          },
          padding: EdgeInsets.all(2),
          constraints: BoxConstraints(minHeight: 0, minWidth: 0),
          splashRadius: 24,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(top: BorderSide(width: .3, color: Colors.grey))),
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, isFirst ? 8 : 4, 4, 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(children: [_typeIcon, _headImage]),
            Flexible(
              child: Padding(
                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [_typeWord, _title, _contentText, _media, _options],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem(IconData icon, String num) {
    return Row(
      children: [
        Padding(padding: EdgeInsets.all(4), child: Icon(icon)),
        Padding(
          padding: EdgeInsets.only(bottom: 2),
          child:
              Text(num == 'null' ? ' ' : num, style: TextStyleManager.grey_5),
        )
      ],
    );
  }

  Widget _buildHeadImage(String url) {
    return ClipOval(
        child: Image.network(
      url,
      height: 55,
      width: 55,
      fit: BoxFit.cover,
    ));
  }

  Widget _buildContentImage(String url) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: Image.network(
          url,
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildUserName(String name, String screenName) {
    return Text.rich(TextSpan(children: [
      TextSpan(text: name, style: TextStyleManager.black_35_b),
      TextSpan(text: ' @$screenName', style: TextStyleManager.grey_35),
    ]));
  }

  Future<Void> _showBottomSheet(Tweet tweet) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent));
    Future<void> future = showMaterialModalBottomSheet<void>(
        context: context,
        duration: Duration(milliseconds: 200),
        builder: (BuildContext context) {
          User user = User.fromJson(isRetweeted
              ? tweet.retweetedStatus.user.toJson()
              : tweet.user.toJson());
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 5,
                width: 32,
                margin: EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                    color: Color(0xFFE5EDF0),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
              SimpleListTile(
                leading: Icon(Icons.sentiment_dissatisfied_rounded),
                title: Text(
                  'Not interesting in this Tweet',
                  style: TextStyleManager.black_47,
                ),
              ),
              SimpleListTile(
                leading: Icon(Icons.cancel_outlined),
                title: Text('Unfollow @${user.screenName}',
                    style: TextStyleManager.black_47),
              ),
              SimpleListTile(
                leading: Icon(Icons.volume_off_outlined),
                title: Text('Mute @${user.screenName}',
                    style: TextStyleManager.black_47),
              ),
              SimpleListTile(
                leading: Icon(Icons.block),
                title: Text('Block @${user.screenName}',
                    style: TextStyleManager.black_47),
              ),
              SimpleListTile(
                leading: Icon(Icons.flag_outlined),
                title: Text('Report Tweet', style: TextStyleManager.black_47),
              ),
            ],
          );
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(12), topLeft: Radius.circular(12))));
    future.then((value) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark
          .copyWith(statusBarColor: Color(0xFFeaeaea)));
    });
    return null;
  }
}
