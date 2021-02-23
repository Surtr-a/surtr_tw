import 'package:flutter/material.dart';
import 'package:surtr_tw/components/utils/utils.dart';
import 'package:get/get.dart';
import 'package:surtr_tw/pages/home/simple_list_tile.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;
  bool expanded = false;


  @override
  void initState() {
    _animationController = AnimationController(duration: Duration(milliseconds: 120), vsync: this);
    _animation = Tween(begin: Offset.zero, end: Offset(0, 1)).animate(_animationController);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MediaQuery.removePadding(
          context: Get.context,
          removeTop: true,
          child: ListView(
            children: [
              _header,
              _body
            ],
          ),
        ),
        _bottom
      ],
    );
  }

  get _header {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 12, 16, 12),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: .6, color: CustomColor.DivGrey))
      ),
      child: Column(
        children: [
          SizedBox(
              width: 60,
              height: 60,
              child: CircleAvatar(
                backgroundColor: Colors.cyan,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Surtr', style: TextStyleManager.black_43_b.copyWith(height: 1.7),),
              IconButton(
                  splashRadius: 5,
                  padding: EdgeInsets.all(0),
                  constraints: BoxConstraints(minHeight: 0, minWidth: 0),
                  icon: Icon(
                    expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: CustomColor.TBlue,
                    size: 20,
                  ),
                  onPressed: () {
                    if (_animationController.status == AnimationStatus.completed) {
                      _animationController.reverse();
                      setState(() {
                        expanded = false;
                      });
                    } else if (_animationController.status == AnimationStatus.dismissed) {
                      _animationController.forward();
                      setState(() {
                        expanded = true;
                      });
                    }
                  })
            ],
          ),
          Text(
            '@Surtr21959148',
            style: TextStyleManager.grey_35_s,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text.rich(TextSpan(children: <TextSpan>[
              TextSpan(text: '6 ', style: TextStyleManager.black_35_b),
              TextSpan(
                  text: 'Following    ', style: TextStyleManager.grey_35_s),
              TextSpan(text: '1 ', style: TextStyleManager.black_35_b),
              TextSpan(text: 'Followers', style: TextStyleManager.grey_35_s),
            ])),
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }

  get _body {
    return expanded
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: Text(
                  'Create a new account',
                  style: TextStyleManager.blue_23,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                child: Text(
                  'Add an existing account',
                  style: TextStyleManager.blue_23,
                ),
              )
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SimpleListTile(
                leading: Icon(Icons.account_circle_outlined),
                title: 'Profile',
              ),
              SimpleListTile(
                leading: Icon(Icons.list_alt_outlined),
                title: 'Lists',
              ),
              SimpleListTile(
                leading: Icon(Icons.chat_bubble_outline),
                title: 'Topics',
              ),
              SimpleListTile(
                leading: Icon(Icons.bookmark_border_outlined),
                title: 'BookMarks',
              ),
              SimpleListTile(
                leading: Icon(Icons.flash_on_outlined),
                title: 'Moments',
              ),
              Divider(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: Text(
                  'Settings and privacy',
                  style: TextStyleManager.black_47,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                child: Text(
                  'Help Center',
                  style: TextStyleManager.black_47,
                ),
              ),
            ],
          );
  }

  get _bottom {
    return Align(
      alignment: Alignment(0, 1),
      child: SlideTransition(
        position: _animation,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
              border: Border(top: BorderSide(width: .6, color: CustomColor.DivGrey))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(icon: Icon(Icons.lightbulb_outline, color: CustomColor.TBlue,), onPressed: null,),
              IconButton(icon: Icon(Icons.qr_code, color: CustomColor.TBlue,), onPressed: null,),
            ],
          ),
        ),
      ),
    );
  }
}
