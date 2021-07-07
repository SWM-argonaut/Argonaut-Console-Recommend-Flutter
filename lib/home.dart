import 'dart:io';

import 'package:flutter/material.dart';

import 'package:argonaut_console_recommend/class/search.dart';

SearchOptions searchOptions = SearchOptions();

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: _topAppBar,
          bottomNavigationBar: _bottomAppBar,
          body: TabBarView(
            children: [
              _home,
              Text("2"),
              Text("3"),
              Text("4"),
            ],
          ),
        ));
  }
}

final _topAppBar = AppBar(
  elevation: 0.1,
  title: Text("닌텐도 스위치 게임 추천"),
  actions: <Widget>[
    IconButton(
      icon: Icon(Icons.list),
      onPressed: () {},
    )
  ],
);

final _bottomAppBar = BottomAppBar(
  child: TabBar(
    tabs: [
      Tab(icon: Icon(Icons.home, color: Colors.white)),
      Tab(icon: Icon(Icons.notifications, color: Colors.white)),
      Tab(icon: Icon(Icons.favorite, color: Colors.white)),
      Tab(icon: Icon(Icons.settings, color: Colors.white)),
    ],
  ),
);

final _home = Container(
  child: ListView.builder(
    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    itemCount: 10,
    itemBuilder: (BuildContext context, int index) {
      return _buildCard;
    },
  ),
);

final _buildCard = Card(
  elevation: 8.0,
  margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
  child: Container(
    decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
    child: _buildListTile,
  ),
);

final _buildListTile = ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: Container(
      padding: EdgeInsets.only(right: 12.0),
      decoration: new BoxDecoration(
          border: new Border(
              right: new BorderSide(width: 1.0, color: Colors.white24))),
      child: Icon(Icons.autorenew, color: Colors.white),
    ),
    title: Text(
      "Introduction to Driving",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

    subtitle: Row(
      children: <Widget>[
        Icon(Icons.linear_scale, color: Colors.yellowAccent),
        Text(" Intermediate", style: TextStyle(color: Colors.white))
      ],
    ),
    trailing:
        Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0));
