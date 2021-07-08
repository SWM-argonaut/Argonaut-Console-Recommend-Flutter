// TODO 데이터 구조 확정 짓고서 여기 마무리 하는게 좋을듯

import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:argonaut_console_recommend/data_class/api.dart';

class DetailPage extends StatelessWidget {
  final Recommendation? recommendation;
  DetailPage({Key? key, required this.recommendation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _topContent(context, recommendation),
          _bottomContent(context, recommendation)
        ],
      ),
    );
  }
}

Stack _topContent(BuildContext context, Recommendation? recommendation) {
  return Stack(
    children: <Widget>[
      Container(
          padding: EdgeInsets.only(left: 10.0),
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: NetworkImage("${recommendation?.imgUrl}"),
              fit: BoxFit.cover,
            ),
          )),
      Container(
        height: MediaQuery.of(context).size.height * 0.5,
        padding: EdgeInsets.all(40.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .9)),
        child: Center(
          child: _topContentText(recommendation),
        ),
      ),
      Positioned(
        left: 8.0,
        top: 60.0,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
      )
    ],
  );
}

Column _topContentText(Recommendation? recommendation) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      SizedBox(height: 120.0),
      Icon(
        Icons.directions_car,
        color: Colors.white,
        size: 40.0,
      ),
      Container(
        width: 90.0,
        child: new Divider(color: Colors.green),
      ),
      SizedBox(height: 10.0),
      Text(
        "${recommendation?.title}",
        style: TextStyle(color: Colors.white, fontSize: 45.0),
      ),
      SizedBox(height: 30.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(flex: 1, child: _levelIndicator(recommendation)),
          Expanded(
              flex: 6,
              child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    "${recommendation?.price}",
                    style: TextStyle(color: Colors.white),
                  ))),
          Expanded(flex: 1, child: _coursePrice(recommendation))
        ],
      ),
    ],
  );
}

Container _levelIndicator(Recommendation? recommendation) {
  return Container(
    child: Container(
      child: LinearProgressIndicator(
          backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
          value: recommendation?.sentiment,
          valueColor: AlwaysStoppedAnimation(Colors.green)),
    ),
  );
}

Container _coursePrice(Recommendation? recommendation) {
  return Container(
    padding: const EdgeInsets.all(7.0),
    decoration: new BoxDecoration(
        border: new Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(5.0)),
    child: new Text(
      // "\$20",
      "\$" + "${recommendation?.price}",
      style: TextStyle(color: Colors.white),
    ),
  );
}

Container _bottomContent(BuildContext context, Recommendation? recommendation) {
  return Container(
    // height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    // color: Theme.of(context).primaryColor,
    padding: EdgeInsets.all(40.0),
    child: Center(
      child: Column(
        children: <Widget>[
          Text(
            "${recommendation?.title}",
            style: TextStyle(fontSize: 18.0),
          ),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () => {},
                style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(58, 66, 86, 1.0)),
                child: Text("쿠팡에서 구매", style: TextStyle(color: Colors.white)),
              ))
        ],
      ),
    ),
  );
}
