import 'package:flutter/material.dart';

import 'package:argonaut_console_recommend/home.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '닌텐도 스위치 게임 추천',
      theme: new ThemeData(
          primaryColor: Color.fromRGBO(58, 66, 86, 1.0),
          accentColor: Color.fromRGBO(58, 66, 86, 1.0),
          bottomAppBarColor: Color.fromRGBO(58, 66, 86, 1.0),
          backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
          cardColor: Color.fromRGBO(58, 66, 86, 1.0),
          canvasColor: Color.fromRGBO(58, 66, 86, 1.0)),
      home: new Home(),
    );
  }
}
