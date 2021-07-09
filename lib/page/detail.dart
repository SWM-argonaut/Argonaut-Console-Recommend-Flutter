// TODO 데이터 구조 확정 짓고서 여기 마무리 하는게 좋을듯

import 'package:flutter/material.dart';

import 'package:expandable/expandable.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:argonaut_console_recommend/data_class/api.dart';

void _launchURL(String _url) async =>
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

class DetailPage extends StatelessWidget {
  final Recommendation? recommendation;
  DetailPage({Key? key, required this.recommendation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${recommendation?.title}"),
        centerTitle: true,
      ),
      body: LayoutBuilder(builder: (BuildContext context, constraints) {
        return SingleChildScrollView(
            child: Column(
          children: <Widget>[
            _photos(context, recommendation, constraints),
            _bottomContent(context, recommendation)
          ],
        ));
      }),
    );
  }
}

Container _photos(BuildContext context, Recommendation? recommendation,
    BoxConstraints constraints) {
  return Container(
      height: constraints.maxHeight / 3,
      child: ExtendedImageGesturePageView.builder(
        itemBuilder: (BuildContext context, int index) {
          String _url = "${recommendation?.imageUrls?[index]}";
          Widget image = ExtendedImage.network(
            _url,
            cache: true,
            fit: BoxFit.contain,
            mode: ExtendedImageMode.gesture,
          );
          return Container(
            child: image,
            padding: EdgeInsets.all(5.0),
          );
        },
        itemCount: recommendation?.imageUrls?.length,
        controller: PageController(
          initialPage: 0,
        ),
        scrollDirection: Axis.horizontal,
      ));
}

Container _bottomContent(BuildContext context, Recommendation? recommendation) {
  return Container(
    padding: EdgeInsets.all(10.0),
    child: Column(
      children: <Widget>[
        RatingBarIndicator(
          rating: (recommendation?.score ?? 0).toDouble(),
          itemBuilder: (context, index) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          itemCount: 5,
          itemSize: 50.0,
          direction: Axis.horizontal,
        ),
        ExpandablePanel(
          header: Text(
            "description",
            style: TextStyle(color: Colors.white),
          ),
          collapsed: Text(
            "${recommendation?.description}",
            softWrap: true,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white),
          ),
          expanded: Text("${recommendation?.description}",
              softWrap: true, style: TextStyle(color: Colors.white)),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () => _launchURL("${recommendation?.coupang?.url}"),
              style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(58, 66, 86, 1.0)),
              child: Text("쿠팡에서 구매", style: TextStyle(color: Colors.white)),
            )),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () =>
                  _launchURL("${recommendation?.nintendoStore?.url}"),
              style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(58, 66, 86, 1.0)),
              child:
                  Text("닌텐도 스토어에서 구매", style: TextStyle(color: Colors.white)),
            ))
      ],
    ),
  );
}
