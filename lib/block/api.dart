import 'dart:developer';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:console_game_db/configs.dart' show requestURL;

import 'package:console_game_db/data_class/switch_game.dart';

Future<List<SwitchGame>> getSwitchGameList() async {
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
