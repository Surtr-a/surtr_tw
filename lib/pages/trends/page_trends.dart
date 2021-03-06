import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:surtr_tw/components/utils/utils.dart';
import 'package:surtr_tw/controllers/trends_controller.dart';
import 'package:surtr_tw/material/custom_search_delegate.dart';
import 'package:surtr_tw/material/sliver_tab_bar_delegate.dart';
import 'package:surtr_tw/material/search.dart' as s;
import 'package:surtr_tw/pages/trends/body.dart';
import 'package:surtr_tw/repositories/twitter_repository.dart';

final Logger _log = Logger('TrendsPage');

class TrendsPage extends GetView<TrendsController> {
  final GlobalKey<ScaffoldState> _globalKey;
  final List<Tab> _tabs = <Tab>[
    Tab(child: Text('For you', style: TextStyle(fontSize: 16))),
    Tab(child: Text('COVID-19', style: TextStyle(fontSize: 16))),
    Tab(child: Text('Trending', style: TextStyle(fontSize: 16))),
    Tab(child: Text('News', style: TextStyle(fontSize: 16))),
    Tab(child: Text('Sports', style: TextStyle(fontSize: 16))),
    Tab(child: Text('Entertainment', style: TextStyle(fontSize: 16)))
  ];

  TrendsPage(this._globalKey);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => TwitterRepository());

    return SafeArea(
      child: DefaultTabController(
        length: _tabs.length,
        initialIndex: 2,
        child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                _appBar,
                SliverPersistentHeader(
                    delegate: SliverTabBarDelegate(TabBar(
                      tabs: _tabs,
                      labelColor: CustomColor.TBlue,
                      unselectedLabelColor: Colors.grey,
                      isScrollable: true,
                      indicatorWeight: 3,
                    )),
                    pinned: true),
              ];
            },
            body: TabBarView(
                children: [1, 2, 3, 4, 5, 6]
                    .map((e) => e == 3
                        ? Body()
                        : Center(
                            child: Text(
                              'Unimplemented',
                            ),
                          ))
                    .toList()),
            floatHeaderSlivers: true),
      ),
    );
  }

  Widget get _appBar {
    return SliverAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: CustomColor.TBlue,
          size: 32,
        ),
        onPressed: () {
          _globalKey.currentState.openDrawer();
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Icon(
            Icons.settings,
            color: CustomColor.TBlue,
          ),
        )
      ],
      title: GestureDetector(
        onTap: () async {
          await s.showSearch(
              context: Get.context,
              delegate: CustomSearchDelegate());
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(24)),
              color: CustomColor.sGrey),
          child: Text(
            'Search Twitter',
            style: TextStyleManager.grey_35_s,
          ),
        ),
      ),
    );
  }
}