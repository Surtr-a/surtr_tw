import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:yaml/yaml.dart';

final Logger _log = Logger('AppConfig');

// 加载 app_config 到 [AppConfigData]
class AppConfig {
  Future<AppConfigData> init() async {
    AppConfigData data;

    _log.fine('loading app config');

    try {
      final String _appConfigString = await rootBundle
          .loadString('assets/config/app_config.yaml', cache: false);

      final YamlMap _yamlMap = loadYaml(_appConfigString);

      final AppConfigData _appConfigData = AppConfigData(
          _yamlMap['twitter']['consumer_key'],
          _yamlMap['twitter']['consumer_secret']);

      if (_appConfigData.invalidTwitterConfig) {
        throw Exception('Twitter api key or secret is empty.');
      } else {
        data = _appConfigData;
      }
    } catch (e, stacktrace) {
      _log.severe(
        'Error while loading app_config.yaml\n'
        'Make sure an `app_config.yaml` file exists in the `assets/config/` '
        'directory with the twitter api key and secret.\n'
        'example:\n'
        'assets/config/app_config.yaml:\n'
        'twitter:\n'
        '    consumer_key: <key>\n'
        '    consumer_secret: <secret>',
        e,
        stacktrace,
      );
    }
    return data;
  }
}

class AppConfigData {
  final String twitterConsumerKey;
  final String twitterConsumerSecret;

  AppConfigData(this.twitterConsumerKey, this.twitterConsumerSecret);

  bool get invalidTwitterConfig =>
      twitterConsumerKey?.isEmpty == true ||
      twitterConsumerSecret?.isEmpty == true;
}
