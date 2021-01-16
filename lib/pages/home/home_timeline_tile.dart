import 'dart:collection';
import 'dart:core';
import 'dart:ffi';

import 'package:dart_twitter_api/api/tweets/data/tweet.dart';
import 'package:dart_twitter_api/api/users/data/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:surtr_tw/components/utils/utils.dart';
import 'package:surtr_tw/pages/home/simple_list_tile.dart';

final Logger _log = Logger('HomeTimelineTile');

enum Hyperlinks { mention, tag, url }

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
    // tag 和 url 的开始下标
    var hyperlinks = Map<int, Hyperlinks>();
    // tag 和 url 的截止下标
    var tagQueue = Queue<int>();
    var urlQueue = Queue<int>();
    var mentionQueue = Queue<int>();
    String fullText = sourceTweet.fullText;
    // 字符差值
    int diff = fullText.length - fullText.runes.length;
    // 正文截断
    fullText = fullText.substring(sourceTweet.displayTextRange[0],
        sourceTweet.displayTextRange[1] + diff);

    // 替换 url 后的实际结束下标
    int lastMark = 0;
    for (int i = 0; i < sourceTweet.entities.urls.length; ++i) {
      String url = sourceTweet.entities.urls[i].url;
      String displayUrl = sourceTweet.entities.urls[i].displayUrl;
      // url 替换
      int curStartIndex = fullText.indexOf(url, lastMark);
      if (curStartIndex != -1) {
        fullText = fullText.replaceRange(
            curStartIndex, curStartIndex + url.length, displayUrl);
        lastMark = curStartIndex + displayUrl.length;
        // url indexes
        hyperlinks.addAll({curStartIndex: Hyperlinks.url});
        urlQueue.add(curStartIndex + displayUrl.length);
      }
    }

    lastMark = 0;
    for (int i = 0; i < sourceTweet.entities.userMentions.length; ++i) {
      String mention = sourceTweet.entities.userMentions[i].screenName;
      int curStartIndex = fullText.indexOf('@$mention', lastMark);
      if (curStartIndex != -1) {
        lastMark = curStartIndex + mention.length + 1;
        hyperlinks.addAll({curStartIndex: Hyperlinks.mention});
        mentionQueue.add(curStartIndex + mention.length + 1);
      }
    }

    // 上次标记 Tag 的结束下标
    lastMark = 0;
    // tag indexes
    for (int i = 0; i < sourceTweet.entities.hashtags.length; ++i) {
      String tag = sourceTweet.entities.hashtags[i].text;
      int curStartIndex = fullText.indexOf('#$tag', lastMark);
      if (curStartIndex != -1) {
        lastMark = curStartIndex + tag.length + 1;
        hyperlinks.addAll({curStartIndex: Hyperlinks.tag});
        tagQueue.add(curStartIndex + tag.length + 1);
      }
    }
    var sortedKey = hyperlinks.keys.toList()..sort();

    // 最后标记的 index
    lastMark = 0;
    var spanList = List<TextSpan>();
    if (sortedKey.length != 0) {
      for (int index in sortedKey) {
        // 绘制上一个 hyperlinks 到 这个 hyperlinks 之间的内容
        if (index != lastMark)
          spanList.add(_buildCommonText(fullText.substring(lastMark, index)));
        switch (hyperlinks[index]) {
          case Hyperlinks.tag:
            spanList.add(_buildTagText(
                fullText.substring(index, lastMark = tagQueue.removeFirst())));
            break;
          case Hyperlinks.mention:
            spanList.add(_buildMentionText(fullText.substring(
                index, lastMark = mentionQueue.removeFirst())));
            break;
          case Hyperlinks.url:
            spanList.add(_buildUrlText(
                fullText.substring(index, lastMark = urlQueue.removeFirst())));
            break;
        }
        // 没有 hyperlinks 需要绘制直接绘制剩下的文本内容
        if (tagQueue.isEmpty &&
            urlQueue.isEmpty &&
            mentionQueue.isEmpty &&
            lastMark != fullText.length)
          spanList.add(
              _buildCommonText(fullText.substring(lastMark, fullText.length)));
      }
    } else {
      spanList.add(_buildCommonText(fullText));
    }
    return Text.rich(TextSpan(children: spanList));
  }

  // 计算当前下标
  int getCurrentIndex(int index, String text, int maxDisplayIndex) {
    double position = (text.length - 1) * index / maxDisplayIndex;
    int curIndex;
    if (position > position.floor())
      curIndex = position.ceil();
    else
      curIndex = position.toInt();
    try {
      text.substring(0, curIndex);
    } catch (e) {
      ++curIndex;
    }
    return curIndex;
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

  TextSpan _buildMentionText(String text) {
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
    User user = User.fromJson(isRetweeted
        ? tweet.retweetedStatus.user.toJson()
        : tweet.user.toJson());
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent));
    Future<void> future = Get.bottomSheet<void>(
        Column(
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
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        backgroundColor: Colors.white);
    future.then((value) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark
          .copyWith(statusBarColor: Color(0xFFeaeaea)));
    });
    return null;
  }
}
