import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surtr_tw/components/utils/utils.dart';
import 'package:surtr_tw/material/custom_search_delegate.dart';
import 'package:surtr_tw/material/loading.dart';
import 'package:surtr_tw/material/sliver_tab_bar_delegate.dart';
import 'package:surtr_tw/pages/search/body.dart';
import 'package:surtr_tw/material/search.dart' as s;

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String query = Get.arguments;
    final List<Tab> _tabs = <Tab>[
      Tab(child: Text('Top', style: TextStyle(fontSize: 16))),
      Tab(child: Text('Latest', style: TextStyle(fontSize: 16))),
      Tab(child: Text('People', style: TextStyle(fontSize: 16))),
      Tab(child: Text('Photos', style: TextStyle(fontSize: 16))),
      Tab(child: Text('Videos', style: TextStyle(fontSize: 16))),
    ];

    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
      body: DefaultTabController(
        length: _tabs.length,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              _buildAppBar(query),
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
            children: [1, 2, 3, 4, 5].map((e) {
              if (e == 1) return Body();
              else return Loading();
            }).toList(),
          ),
        ),
      ),
    ));
  }

  Widget _buildAppBar(String query) {
    return SliverAppBar(
      pinned: true,
      shadowColor: Colors.transparent,
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: CustomColor.TBlue,
          ),
          onPressed: () => Get.back()),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Icon(
            Icons.tune_rounded,
            color: CustomColor.TBlue,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Icon(
            Icons.more_vert,
            color: CustomColor.TBlue,
          ),
        )
      ],
      title: GestureDetector(
        onTap: () async {
          await s.showSearch(
              context: Get.context,
              delegate: CustomSearchDelegate(),
              query: query);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(24)),
              color: CustomColor.sGrey),
          child: Text(
            query,
            style: TextStyleManager.black_23,
          ),
        ),
      ),
    );
  }
}
