import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:surtr_tw/pages/main/page_main.dart';

final Logger _log = Logger('Route');

const pageMain = Navigator.defaultRouteName;

final Map<String, WidgetBuilder> routes = {
  pageMain: (context) => MainPage()
};

Route<dynamic> routeFactory(RouteSettings settings) {
  WidgetBuilder builder;
  switch (settings.name) {

  }

  if (builder != null) return MaterialPageRoute(builder: builder, settings: settings);

  _log.severe('can not generate Route for ${settings.name}');
  return null;
}