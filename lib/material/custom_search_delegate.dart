import 'package:flutter/material.dart';
import 'package:surtr_tw/components/app_routes.dart';
import 'package:surtr_tw/controllers/saerch_delegate_controller.dart';
import 'package:surtr_tw/controllers/search_controller.dart';
import 'package:surtr_tw/material/search.dart' as s;
import 'package:surtr_tw/components/utils/utils.dart';
import 'package:get/get.dart';

class CustomSearchDelegate extends s.SearchDelegate<String> {

  @override
  ThemeData appBarTheme(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return theme.copyWith(
        textTheme:
        theme.textTheme.copyWith(headline6: TextStyleManager.blue_23));
  }

  @override
  String get searchFieldLabel => 'Search Twitter';

  @override
  TextStyle get searchFieldStyle => TextStyleManager.grey_35_s;

  @override
  void showResults(BuildContext context) {
    SearchDelegateController controller = Get.find<SearchDelegateController>();
    controller.submit(query);
    Get.offNamed(Routes.SEARCH, arguments: query);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      if (query.isNotEmpty)
        IconButton(
            icon: Icon(
              Icons.clear,
              size: 28,
              color: CustomColor.TBlue,
            ),
            onPressed: () => query = '')
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(
          Icons.arrow_back,
          size: 32,
          color: CustomColor.TBlue,
        ),
        onPressed: () => close(context, ''));
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: CustomColor.sGrey,
        ),
        Align(
            alignment: Alignment(0, -0.92),
            child: Text(
              'Try searching for people, topics or keywords',
              style: TextStyleManager.grey_15_b,
            )),
        GetBuilder<SearchDelegateController>(
            init: SearchDelegateController(),
            builder: (_) {
              _.getHistories();
              if (_.histories.length != 0) {
                return ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0)
                        return Container(
                          color: Colors.white,
                          child: ListTile(
                            title: Text(
                              'Recent',
                              style: TextStyleManager.grey_55_b,
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.clear,
                              ),
                              onPressed: () async {
                                var result = await _showDialog(context, 'Clear recent searches?');
                                if (result == 'clear') {
                                  _.clearAll();
                                }
                              },
                            ),
                            contentPadding: EdgeInsets.only(left: 16, right: 8),
                          ),
                        );
                      else {
                        return GestureDetector(
                          onTap: () {
                            if (_.histories[index - 1] != query) {
                              _.updateOrder(_.histories[index - 1]);
                              Get.offNamed(Routes.SEARCH, arguments: _.histories[0]);
                            } else {
                              Get.back();
                            }
                          },
                          onLongPress: () async {
                            var result = await _showDialog(context, 'Clear ${_.histories[index - 1]} from your history?');
                            if (result == 'clear') {
                              _.clear(_.histories[index - 1]);
                            }
                          },
                          child: Container(
                            color: Colors.white,
                            child: ListTile(
                              title: Text(
                                _.histories[index - 1],
                                style: TextStyleManager.black_23,
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.arrow_upward),
                                onPressed: () => query = _.histories[index - 1],
                              ),
                              contentPadding: EdgeInsets.only(left: 16, right: 8),
                            ),
                          ),
                        );
                      }
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider();
                    },
                    itemCount: _.histories.length + 1);
              } else
                return Container();
            })
      ],
    );
  }

  Future<String> _showDialog(BuildContext context, String content) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(content),
            shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(1))),
            actions: [
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'CANCEL',
                    style: TextStyle(color: Colors.black),
                  )),
              FlatButton(
                  onPressed: () => Navigator.of(context).pop('clear'),
                  child: Text(
                    'CLEAR',
                    style: TextStyle(color: Colors.black),
                  )),
            ],
          );
        });
  }
}