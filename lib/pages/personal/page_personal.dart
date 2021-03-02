import 'package:flutter/material.dart';
import 'package:surtr_tw/components/utils/utils.dart';
import 'package:surtr_tw/material/icon_button_without_padding.dart';

class PersonalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _appBar
      ],
    );
  }

  get _appBar {
    return SliverAppBar(
      expandedHeight: 200.0,
      title: Column(
        children: [
          Text('Surtr', style: TextStyleManager.black_35_b.copyWith(color: Colors.white),),
          Text('4 Tweets', style: TextStyleManager.black_23.copyWith(color: Colors.white),)
        ],
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_outlined,
          color: Colors.white,
        ),
        onPressed: () {},
        constraints: BoxConstraints(minWidth: 0, minHeight: 0),
      ),
      actions: [
        Container(
          decoration: BoxDecoration(
              color: CustomColor.sBlack,
              borderRadius: BorderRadius.all(Radius.circular(200))),
          child: IconButtonWithoutPadding(
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              onPressed: null),
        )

      ],
      flexibleSpace: Container(color: CustomColor.TBlue, width: double.infinity, height: double.infinity,),
    );
  }
}
