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
          twitterConsumerKey: _yamlMap['twitter']['consumer_key'],
          twitterConsumerSecret: _yamlMap['twitter']['consumer_secret'],
          token: _yamlMap['default_token']['token'] ?? '',
          tokenSecret: _yamlMap['default_token']['secret'] ?? '');

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
  String token;
  String tokenSecret;

  AppConfigData(
      {@required this.twitterConsumerKey,
      @required this.twitterConsumerSecret,
      this.token,
      this.tokenSecret});

  bool get invalidTwitterConfig =>
      twitterConsumerKey?.isEmpty == true ||
      twitterConsumerSecret?.isEmpty == true;
}
