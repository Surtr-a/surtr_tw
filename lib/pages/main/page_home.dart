import 'package:dart_twitter_api/api/tweets/data/tweet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:surtr_tw/pages/main/home_timeline_tile.dart';
import 'package:surtr_tw/pages/main/page_main.dart';
import 'package:surtr_tw/repository/twitter.dart';

// final Logger _log = Logger('HomePage');

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Tweet> homeTimeline = <Tweet>[];

  DrawerNotification drawerNotification;

  @override
  void initState() {
    super.initState();
    twitterRepository.homeTimeline().then((value) {
      setState(() {
        homeTimeline.addAll(value);
      });
    });
    drawerNotification = DrawerNotification();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _appBar,
        SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
          return TweetListTile(context, homeTimeline[index], index == 0);
          // return GestureDetector(
          //     child: Padding(
          //   padding: EdgeInsets.all(12),
          //   child: Text(homeTimeline[index].fullText),
          // ), onLongPress: () {
          //   Clipboard.setData(ClipboardData(text: homeTimeline[index].toJson().toString()));
          //   toast('复制成功！');
          // },);
        }, childCount: homeTimeline.length))
      ],
    );
  }

  get _appBar {
    return SliverAppBar(
      elevation: .8,
      shadowColor: Colors.grey,
      floating: true,
      title: Text(
        'Twitter',
        style: TextStyle(color: Theme.of(context).accentColor),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.account_circle,
        ),
        onPressed: () {
          drawerNotification.dispatch(key.currentContext);
        },
      ),
      actions: [
        IconButton(
            icon: Icon(
              Icons.star_border,
              color: Theme.of(context).accentColor,
            ),
            onPressed: null)
      ],
    );
  }
}
