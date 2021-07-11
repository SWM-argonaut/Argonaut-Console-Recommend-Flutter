import 'dart:developer';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:argonaut_console_recommend/configs.dart' show requestURL;

import 'package:argonaut_console_recommend/data_class/api.dart';
import 'package:argonaut_console_recommend/data_class/search.dart';

Future<List<SwitchGame>> getSwitchGameList(SearchOptions options) async {
  var url = Uri.parse(requestURL);
  var response = await http.get(url);

  log('Response status: ${response.statusCode}');

  if (response.statusCode == 200) {
    return json
        .decode(utf8.decode(response.bodyBytes))
        .map<SwitchGame>((item) => SwitchGame.fromJson(item))
        .toList();
  } else {
    return [];
  }
}
