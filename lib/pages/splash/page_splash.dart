import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

typedef AppBuilder = Function(BuildContext context, List<dynamic> data);

final Logger _log = Logger('PageSplash');

class PageSplash extends StatefulWidget {
  final List<Future> futures;

  final AppBuilder builder;

  const PageSplash({Key key, this.futures, @required this.builder}) : super(key: key);

  @override
  _PageSplashState createState() => _PageSplashState();
}

class _PageSplashState extends State<PageSplash> {
  List _data;

  @override
  void initState() {
    super.initState();
    final start = DateTime.now().millisecondsSinceEpoch;
    if (widget.futures != null) {
      Future.wait(widget.futures).then((data) {
        final duration = DateTime.now().millisecondsSinceEpoch - start;
        _log.fine("flutter initial in: $duration");
        setState(() {
          _data = data;
        });
      });
    } else {
      setState(() {
        _data = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_data == null) {
      return Container(color: Colors.deepOrange,);
    }
    return widget.builder(context, _data);
  }
}
