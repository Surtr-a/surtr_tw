import 'package:flutter/material.dart';
import 'package:surtr_tw/components/utils/color.dart';
import 'package:surtr_tw/material/circular_progress_indicator.dart' as cpi;

class Loading extends StatelessWidget {
  final double size;

  Loading({this.size = 12});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(8),
        width: size,
        height: size,
        child: cpi.CircularProgressIndicator(
          valueColor:
          AlwaysStoppedAnimation<Color>(CustomColor.TBlue),
          strokeWidth: 2,
        ),
      ),
    );
  }
}
