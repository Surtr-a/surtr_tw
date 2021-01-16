import 'package:flutter/material.dart';

class SimpleListTile extends StatelessWidget {
  final Widget leading;
  final Widget title;

  SimpleListTile({Key key, this.leading, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(size: 28, color: Colors.grey),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        child: Row(
          children: [leading, SizedBox(width: leading == null ? 0 : 16,), title],
        ),
      ),
    );
  }
}