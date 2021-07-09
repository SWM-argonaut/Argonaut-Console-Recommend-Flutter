import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:argonaut_console_recommend/block/api.dart';

import 'package:argonaut_console_recommend/data_class/search.dart';
import 'package:argonaut_console_recommend/data_class/api.dart';

import 'package:argonaut_console_recommend/page/detail.dart';

SearchOptionsNotifier searchOptionsNoti =
    SearchOptionsNotifier(SearchOptions());

late Future<List<Recommendation>> recommendedList;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    recommendedList = getRecommendList(searchOptionsNoti.value);
  }

  int _selectedIndex = 0;
  static List<Widget> _tabs = <Widget>[
    _home(),
    Text("2"),
    Text("3"),
    Text("4"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        title: Text("닌텐도 스위치 게임 추천"),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.list),
        //     onPressed: () {},
        //   )
        // ],
      ),
      body: _tabs.elementAt(_selectedIndex),
      bottomNavigationBar: BottomAppBar(
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: (index) => setState(() => _selectedIndex = index),
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                label: "home"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
                label: "home"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
                label: "home"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                label: "home"),
          ],
        ),
      ),
    );
  }
}

LayoutBuilder _home() {
  return LayoutBuilder(builder: (BuildContext context, constraints) {
    const double _optionHeight = 50;

    double _height = constraints.maxHeight;

    return Column(children: [
      Container(
        height: _optionHeight,
        child: ValueListenableBuilder(
            valueListenable: searchOptionsNoti, builder: _orderListBuilder),
      ),
      Container(height: _height - _optionHeight, child: _buildList()),
    ]);
  });
}

ListView _orderListBuilder(BuildContext context, SearchOptions options, _) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: OrderBy.values.length,
    scrollDirection: Axis.horizontal,
    itemBuilder: (BuildContext context, int index) {
      OrderBy _order = OrderBy.values[index];
      Color _butttonColor;
      Widget _child;
      if (options.orderBy == _order) {
        _butttonColor = Colors.green;
        _child = Row(
          children: [
            Text("${OrderBy.values[index]}".split(".").last + " "),
            Icon(options.asc ? Icons.arrow_upward : Icons.arrow_downward)
          ],
        );
      } else {
        _butttonColor = Colors.orange;
        _child = Text("${OrderBy.values[index]}".split(".").last);
      }

      return Padding(
          padding: EdgeInsets.all(3),
          child: ElevatedButton(
            onPressed: () => searchOptionsNoti.clicked(_order),
            child: _child,
            style:
                ElevatedButton.styleFrom(primary: _butttonColor, elevation: 10),
          ));
    },
  );
}

_buildList() {
  return FutureBuilder(
      future: recommendedList,
      builder:
          (BuildContext context, AsyncSnapshot<List<Recommendation>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return CircularProgressIndicator();
        } else {
          if (snapshot.hasError) {
            // TODO 에러 처리
            return Center(child: Text("Something went wrong..."));
          }

          if (snapshot.data?.length == 0) {
            return Center(child: Text("Empty"));
          }
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: snapshot.data?.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildCard(context, snapshot.data?[index]);
            },
          );
        }
      });
}

Card _buildCard(BuildContext context, Recommendation? item) {
  return Card(
    elevation: 8.0,
    margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    child: Container(
      decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
      child: _buildListTile(context, item),
    ),
  );
}

ListTile _buildListTile(BuildContext context, Recommendation? item) {
  const Color _progressIndicatorColor = Color.fromRGBO(209, 224, 224, 0.2);
  const Color _progressIndicatorValueColor = Colors.green;

  return ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white24))),
        child: item?.thumbnailUrl != ""
            ? Image.network("${item?.thumbnailUrl}")
            : Icon(Icons.autorenew, color: Colors.white)),
    title: Text(
      "${item?.title}",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    subtitle: Row(
      children: <Widget>[
        Expanded(
            flex: 1,
            child: Container(
              child: LinearProgressIndicator(
                backgroundColor: _progressIndicatorColor,
                value: item?.sentiment,
                valueColor:
                    AlwaysStoppedAnimation(_progressIndicatorValueColor),
              ),
            )),
        Expanded(
          flex: 4,
          child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text("${item?.coupang?.price}",
                  style: TextStyle(color: Colors.white))),
        )
      ],
    ),
    trailing: Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailPage(recommendation: item)));
    },
  );
}
