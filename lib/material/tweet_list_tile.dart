import 'dart:collection';
import 'dart:core';
import 'dart:ffi';

import 'package:dart_twitter_api/api/tweets/data/tweet.dart';
import 'package:dart_twitter_api/api/users/data/user.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:surtr_tw/components/app_routes.dart';
import 'package:surtr_tw/components/utils/utils.dart';
import 'package:surtr_tw/controllers/home_controller.dart';
import 'package:surtr_tw/pages/home/simple_list_tile.dart';
import 'package:surtr_tw/repositories/twitter_repository.dart';
import 'package:url_launcher/url_launcher.dart';

final Logger _log = Logger('HomeTimelineTile');

enum Hyperlinks { mention, tag, url, keyword }

typedef GestureTapCallback = void Function();

// ignore: must_be_immutable
class TweetListTile extends StatelessWidget {
  TweetListTile(this.tweet, this.isDetail, {this.replyScreenName, this.query})
      : isRetweeted = tweet.retweetedStatus != null,
        isQuoted = tweet.isQuoteStatus,
        sourceTweet =
            tweet.retweetedStatus == null ? tweet : tweet.retweetedStatus {
    retweeted = sourceTweet.retweeted.obs;
    favorited = sourceTweet.favorited.obs;
    retweetCount = sourceTweet.retweetCount.obs;
    favoriteCount = sourceTweet.favoriteCount.obs;
  }

  final Tweet tweet;
  final Tweet sourceTweet;
  final bool isRetweeted;
  final bool isQuoted;
  final bool isDetail;
  final String replyScreenName;
  final String query;
  RxBool retweeted;
  RxBool favorited;
  RxInt retweetCount;
  RxInt favoriteCount;

  @override
  Widget build(BuildContext context) {
    Function _updateHomeTimeline = (Tweet newTweet) {
      if (newTweet != null) {
        // Get.find<HomeController>().updateHomeTimeline(newTweet, isRetweeted);
      }
    };

    GestureTapCallback onRetweetChange = () {
      if (retweeted.value) {
        retweeted.value = false;
        --retweetCount.value;
        Get.find<TwitterRepository>().unretweet(sourceTweet.idStr).then(_updateHomeTimeline);
      } else {
        retweeted.value = true;
        ++retweetCount.value;
        Get.find<TwitterRepository>().retweet(sourceTweet.idStr).then(_updateHomeTimeline);
      }
    };

    GestureTapCallback onFavoriteChange = () {
      if (favorited.value) {
        favorited.value = false;
        --favoriteCount.value;
        Get.find<TwitterRepository>()
            .destroyFavorites(sourceTweet.idStr)
            .then(_updateHomeTimeline);
      } else {
        favorited.value = true;
        ++favoriteCount.value;
        Get.find<TwitterRepository>()
            .createFavorites(sourceTweet.idStr)
            .then(_updateHomeTimeline);
      }
    };

    return isDetail
        ? Padding(
            padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: Column(
              children: [
                Padding(
                  padding: isRetweeted ? EdgeInsets.fromLTRB(64, 4, 0, 4) : EdgeInsets.zero,
                  child: Row(
                    children: [
                      _typeIcon,
                      _typeWord,
                    ],
                  ),
                ),
                Row(
                  children: [_headImage, _title],
                  mainAxisSize: MainAxisSize.max,
                ),
                _contentText,
                _media,
                _time,
                Divider(indent: 4, endIndent: 4, thickness: .6, height: 20,),
                _shareData,
                Divider(indent: 4, endIndent: 4, thickness: .6, height: 20,),
                _shareIcons(onRetweetChange, onFavoriteChange),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
            ),
          )
        : InkWell(
          highlightColor: CustomColor.sGrey,
          radius: 0,
          onTap: () => Get.toNamed(Routes.TWEET_DETAIL, arguments: tweet, preventDuplicates: false),
          child: Padding(
            padding: EdgeInsets.fromLTRB(12, 4, 4, 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(children: [_typeIcon, _headImage]),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _typeWord,
                        _title,
                        if (replyScreenName != null) _target,
                        _contentText,
                        _media,
                        _options(onRetweetChange, onFavoriteChange)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
  }

  Widget get _target {
    return Text.rich(TextSpan(
      children: [
        TextSpan(text: 'Replying to ', style: TextStyleManager.grey_35),
        TextSpan(text: '@$replyScreenName', style: TextStyleManager.blue_23)
      ],
    ), overflow: TextOverflow.ellipsis, maxLines: 1,);
  }

  Widget _shareIcons(GestureTapCallback onRetweetChange, GestureTapCallback onFavoriteChange) {
    return Row(
      children: [
        Icon(Icons.mode_comment_outlined, size: 24, color: Colors.grey),
        Obx(() => GestureDetector(
            onTap: onRetweetChange,
            child: Icon(Icons.repeat_outlined,
                size: 24,
                color: retweeted.value
                    ? CustomColor.retweetedGreen
                    : Colors.grey))),
        Obx(() => GestureDetector(
          onTap: onFavoriteChange,
          child: Icon(
              favorited.value ? Icons.favorite : Icons.favorite_outline,
              size: 24,
              color: favorited.value ? CustomColor.favoriteRed : Colors.grey),
        )),
        Icon(Icons.share_outlined, size: 24, color: Colors.grey)
      ],
      mainAxisAlignment: MainAxisAlignment.spaceAround,
    );
  }

  Widget get _shareData {
    return Obx(() => Text.rich(TextSpan(
        children: [
          TextSpan(text: retweetCount.value.toString(), style: TextStyleManager.black_35_b),
          TextSpan(text: ' Retweets   ', style: TextStyleManager.grey_35),
          TextSpan(text: sourceTweet.quoteCount == null ? '0' : sourceTweet.quoteCount.toString(), style: TextStyleManager.black_35_b),
          TextSpan(text: ' Quote Tweets   ', style: TextStyleManager.grey_35),
          TextSpan(text: favoriteCount.value.toString(), style: TextStyleManager.black_35_b),
          TextSpan(text: ' Likes   ', style: TextStyleManager.grey_35),
        ]
    )));
  }

  Widget get _time {
    DateTime createAt = sourceTweet.createdAt;
    int startIndex = sourceTweet.source.indexOf('>') + 1;
    int endIndex = sourceTweet.source.indexOf('<\/a>');
    String from = sourceTweet.source.substring(startIndex, endIndex);
    return Text.rich(TextSpan(children: [
      TextSpan(
          text:
              '${createAt.hour}:${createAt.minute} · ${createAt.day} ${TimeUtil.month[createAt.month]} ${createAt.year.toString().substring(2, 4)} · ',
          style: TextStyleManager.grey_35),
      TextSpan(text: from, style: TextStyleManager.blue_23)
    ]));
  }

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
        '${tweet.user.name} Retweeted',
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
      padding: EdgeInsets.only(top: 6),
      child: _buildHeadImage(originalVariant),
    );
  }

  Widget get _userName {
    return isDetail
        ? Text(
            '${sourceTweet.user.name} ',
            style: TextStyleManager.black_35_b,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          )
        : Text.rich(
            TextSpan(
              children: [
                TextSpan(
                    text: '${sourceTweet.user.name} ',
                    style: TextStyleManager.black_35_b),
                TextSpan(
                    text:
                        '@${sourceTweet.user.screenName} · ${TimeUtil.getTimeIntervalStr(sourceTweet.createdAt)}',
                    style: TextStyleManager.grey_35)
              ],
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          );
  }

  Widget get _screenName {
    return Text(
      '@${sourceTweet.user.screenName}',
      style: TextStyleManager.grey_35,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  // 推文正文
  Widget get _contentText {
    // tag 和 url 的开始下标
    var hyperlinks = Map<int, Hyperlinks>();
    // tag 和 url 的截止下标
    var tagQueue = Queue<int>();
    var urlQueue = Queue<int>();
    var mentionQueue = Queue<int>();
    var keywordQueue = Queue<int>();
    String fullText = sourceTweet.fullText;
    // 字符长度差值
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
    
    // lastMark = 0;
    // while (true) {
    //   if (query == null) break;
    //   int curStartIndex = fullText.indexOf(query, lastMark);
    //   if (curStartIndex != -1) {
    //     lastMark = curStartIndex + query.length + 1;
    //     if (!hyperlinks.containsKey(curStartIndex)) {
    //       hyperlinks.addAll({curStartIndex: Hyperlinks.keyword});
    //       keywordQueue.add(curStartIndex + query.length);
    //     }
    //   } else break;
    // }

    var sortedKey = hyperlinks.keys.toList()..sort();

    // 最后标记的 index
    lastMark = 0;
    // built url index
    int urlIndex = 0;
    var spanList = List<TextSpan>();
    if (sortedKey.length != 0) {
      for (int index in sortedKey) {
        // 绘制上一个 hyperlinks 到 这个 hyperlinks 之间的内容
        if (index != lastMark)
          spanList.add(_buildCommonText(fullText.substring(lastMark, index), isDetail));
        switch (hyperlinks[index]) {
          case Hyperlinks.tag:
            spanList.add(_buildTagText(
                fullText.substring(index, lastMark = tagQueue.removeFirst()), isDetail));
            break;
          case Hyperlinks.mention:
            spanList.add(_buildMentionText(fullText.substring(
                index, lastMark = mentionQueue.removeFirst())));
            break;
          case Hyperlinks.url:
            spanList.add(_buildUrlText(
                fullText.substring(index, lastMark = urlQueue.removeFirst()), isDetail, sourceTweet.entities.urls[urlIndex].url));
            ++urlIndex;
            break;
          case Hyperlinks.keyword:
            spanList.add(_buildKeywordText(fullText.substring(index, lastMark = keywordQueue.removeFirst())));
            break;
        }
        // 没有 hyperlinks 需要绘制直接绘制剩下的文本内容
        if (tagQueue.isEmpty &&
            urlQueue.isEmpty &&
            mentionQueue.isEmpty &&
            keywordQueue.isEmpty &&
            lastMark != fullText.length)
          spanList.add(
              _buildCommonText(fullText.substring(lastMark, fullText.length), isDetail));
      }
    } else {
      spanList.add(_buildCommonText(fullText, isDetail));
    }
    return Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text.rich(TextSpan(children: spanList)));
  }

  TextSpan _buildKeywordText(String text) {
    return TextSpan(
      text: text,
      style: TextStyleManager.black_35_b
    );
  }

  TextSpan _buildCommonText(String text, bool isDetail) {
    return TextSpan(
      text: text,
      style: isDetail ? TextStyleManager.black_83 : TextStyleManager.black_23,
    );
  }

  TextSpan _buildUrlText(String text, bool isDetail, String sourceUrl) {
    return TextSpan(
      text: text,
      style: isDetail ? TextStyleManager.blue_83 : TextStyleManager.blue_23,
      recognizer: TapGestureRecognizer()
        ..onTap = () async {
          if (await canLaunch(sourceUrl)) {
            await launch(sourceUrl);
          } else {
            _log.warning('Could not launch $sourceUrl');
          }
        }
    );
  }

  TextSpan _buildTagText(String text, bool isDetail) {
    return TextSpan(
      text: text,
      style: isDetail ? TextStyleManager.blue_83 : TextStyleManager.blue_23,
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          Get.toNamed(Routes.SEARCH, arguments: text);
        }
    );
  }

  TextSpan _buildMentionText(String text) {
    return TextSpan(
      text: text,
      style: isDetail ? TextStyleManager.blue_83 : TextStyleManager.blue_23,
    );
  }

  Widget get _media {
    if (sourceTweet.entities != null && sourceTweet.entities.media != null) {
      String mediaUrl = sourceTweet.entities.media[0].mediaUrlHttps;

      if (sourceTweet.entities.media[0].type == 'photo') {
        return _buildContentImage(mediaUrl, isDetail);
      } else {
        return Container();
      }
    } else
      return Container();
  }

  Widget _options(GestureTapCallback onRetweetChange, GestureTapCallback onFavoriteChange) {
    return IconTheme(
      data: IconThemeData(color: Colors.grey, size: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildOptionItem(
              Icons.mode_comment_outlined, sourceTweet.replyCount.toString(), () {}),
          _buildRetweetedOptionItem(
              retweeted, retweetCount, onRetweetChange),
          _buildFavoriteOptionItem(
              favorited, favoriteCount, onFavoriteChange),
          _buildOptionItem(Icons.share_outlined, '', () {}),
          SizedBox(
            width: 1,
          )
        ],
      ),
    );
  }

  Widget get _title {
    return isDetail
        ? Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(12, 4, 0, 4),
              child: Column(
                children: [
                  Row(
                    children: [
                      _userName,
                      _extension,
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  _screenName
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
          )
        : Row(
            children: [
              Expanded(
                child: _userName,
              ),
              _extension
            ],
            mainAxisSize: MainAxisSize.max,
          );
  }

  Widget get _extension {
    return IconButton(
      iconSize: 20,
      color: Colors.grey,
      icon: Icon(Icons.keyboard_arrow_down),
      onPressed: () {
        _showBottomSheet(sourceTweet);
      },
      padding: EdgeInsets.all(0),
      constraints: BoxConstraints(minHeight: 0, minWidth: 0),
      splashRadius: 24,
    );
  }

  Widget _buildOptionItem(IconData icon, String num, GestureTapCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Padding(padding: EdgeInsets.all(4), child: Icon(icon,)),
          Padding(
            padding: EdgeInsets.only(bottom: 2),
            child:
            Text(num == 'null' ? ' ' : num, style: TextStyleManager.grey_5),
          )
        ],
      ),
    );
  }

  Widget _buildFavoriteOptionItem(RxBool favorited, RxInt num, GestureTapCallback onTap) {
    return Obx(() => GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    favorited.value ? Icons.favorite : Icons.favorite_outline,
                    color: favorited.value ? CustomColor.favoriteRed : Colors.grey,
                  )),
              Padding(
            padding: EdgeInsets.only(bottom: 2),
            child:
            Text(num.value == 0 ? ' ' : num.value.toString(),
                    style: favorited.value
                        ? TextStyleManager.grey_5
                            .copyWith(color: CustomColor.favoriteRed)
                        : TextStyleManager.grey_5),
              )
        ],
      ),
    ));
  }

  Widget _buildRetweetedOptionItem(RxBool retweeted, RxInt num, GestureTapCallback onTap) {
    return Obx(() => GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.repeat_outlined,
                color: retweeted.value ? CustomColor.retweetedGreen : Colors.grey,
              )),
          Padding(
            padding: EdgeInsets.only(bottom: 2),
            child:
            Text(num.value == 0 ? ' ' : num.value.toString(),
                style: retweeted.value
                    ? TextStyleManager.grey_5
                    .copyWith(color: CustomColor.retweetedGreen)
                    : TextStyleManager.grey_5),
          )
        ],
      ),
    ));
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

  Widget _buildContentImage(String url, bool isDetail) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isDetail ? 16 : 8),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: Image.network(
          url,
          height: isDetail ? 292 : 180,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
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
              title: 'Not interesting in this Tweet',
            ),
            SimpleListTile(
              leading: Icon(Icons.cancel_outlined),
              title: 'Unfollow @${user.screenName}',
            ),
            SimpleListTile(
              leading: Icon(Icons.volume_off_outlined),
              title: 'Mute @${user.screenName}',
            ),
            SimpleListTile(
              leading: Icon(Icons.block),
              title: 'Block @${user.screenName}',
            ),
            SimpleListTile(
              leading: Icon(Icons.flag_outlined),
              title: 'Report Tweet',
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        backgroundColor: Colors.white);
    future.then((value) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark
          .copyWith(statusBarColor: Color(0xFFeaeaea)));
    });
    return null;
  }
}
