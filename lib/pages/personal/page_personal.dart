import 'package:flutter/material.dart';
import 'package:surtr_tw/components/utils/utils.dart';

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
      leading: Container(
        decoration: BoxDecoration(
            color: CustomColor.sBlack,
            borderRadius: BorderRadius.all(Radius.circular(200))),
        child: IconButton(
            icon: Icon(
              Icons.arrow_back_outlined,
              color: Colors.white,
            ),
            onPressed: null),
      ),
      actions: [
        Container(
          decoration: BoxDecoration(
              color: CustomColor.sBlack,
              borderRadius: BorderRadius.all(Radius.circular(200))),
          child: IconButton(
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
