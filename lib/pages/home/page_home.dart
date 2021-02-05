import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surtr_tw/components/utils/color.dart';
import 'package:surtr_tw/pages/home/body.dart';
import 'package:surtr_tw/repositories/twitter_repository.dart';

// final Logger _log = Logger('HomePage');
class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _globalKey;

  HomePage(this._globalKey);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => TwitterRepository());

    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            _appBar,
            SliverToBoxAdapter(
                child: Divider(
                    color: CustomColor.DivGrey, thickness: .6, height: .6))
          ];
        },
        body: Body(),
        floatHeaderSlivers: true);
  }

  get _appBar {
    return SliverAppBar(
      floating: true,
      title: Text(
        'Twitter',
        style: TextStyle(color: Theme.of(Get.context).accentColor),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          size: 32,
          color: CustomColor.TBlue,
        ),
        onPressed: () {
          _globalKey.currentState.openDrawer();
        },
      ),
      actions: [
        IconButton(
            icon: Icon(
              Icons.star_border,
              color: Theme.of(Get.context).accentColor,
            ),
            onPressed: null)
      ],
    );
  }
}
