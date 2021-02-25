import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:surtr_tw/components/utils/utils.dart';
import 'package:surtr_tw/controllers/trends_controller.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrendsController>(
        init: TrendsController(),
        builder: (_) {
          return MediaQuery.removePadding(
            context: Get.context,
            removeTop: true,
            child: Scrollbar(
              thickness: 4,
              child: SmartRefresher(
                header: MaterialClassicHeader(
                  color: CustomColor.TBlue,
                ),
                controller: _.refreshController,
                onRefresh: _.onRefresh,
                child: CustomScrollView(
                  slivers: [
                    SliverPersistentHeader(
                      delegate: _SliverTitleDelegate(Text('United States trends',style: TextStyleManager.black_43_b,)),
                      pinned: true,
                    ),
                    SliverList(delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                      return Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: .6, color: CustomColor.divGrey)),
                            color: Colors.white),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [Text('${index + 1} · Trending', style: TextStyleManager.grey_15,), _extension], mainAxisAlignment: MainAxisAlignment.spaceBetween,),
                            Text('${_.trends[0].trends[index].name}', style: TextStyleManager.black_35_b,)
                          ],
                        ),
                      );
                    }, childCount: _.trends.length == 0 ? 0 : _.trends[0].trends.length))
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget get _extension {
    return IconButton(
      iconSize: 20,
      color: Colors.grey,
      icon: Icon(Icons.keyboard_arrow_down),
      onPressed: () {
        showDialog(context: Get.context, builder: (BuildContext context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                child: Text('Not interested in this', style: TextStyleManager.black_23,),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                child: Text('This trend is harmful or spammy', style: TextStyleManager.black_23,),
              )
            ],
          );
        });
      },
      padding: EdgeInsets.all(0),
      constraints: BoxConstraints(minHeight: 0, minWidth: 0),
      splashRadius: 24,
    );
  }
}

class _SliverTitleDelegate extends SliverPersistentHeaderDelegate {
  final Text title;
  double padding = 10;

  _SliverTitleDelegate(this.title);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: title,
      width: double.infinity,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: .6,
            color: CustomColor.divGrey
          )
        )
      ),
    );
  }

  @override
  double get maxExtent => title.calculateHeight(double.infinity) + padding * 2;

  @override
  double get minExtent => title.calculateHeight(double.infinity) + padding * 2;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}