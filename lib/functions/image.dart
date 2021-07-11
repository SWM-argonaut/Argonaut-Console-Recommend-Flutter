import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:extended_image/extended_image.dart';

import 'package:argonaut_console_recommend/data_class/api.dart';

Widget getThumbnail(SwitchGame? item) {
  if (item!.images != null && item.images!.length > 0) {
    return Image.network(item.images![0]);
  }

  return FutureBuilder(
      future: rootBundle.loadString('assets/images/${item.idx}/info.json'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return CircularProgressIndicator();
        }

        List<String> images =
            json.decode(snapshot.data)['images'].cast<String>();
        for (String i in images) {
          // 0은 썸네일
          if (i.split(".")[0] == "0") {
            return Image(image: AssetImage('assets/images/${item.idx}/$i'));
          }
        }

        // not founded
        return Icon(Icons.autorenew, color: Colors.white);
      });
}

Widget imagePageView(SwitchGame? item) {
  if (item!.images != null && item.images!.length > 0) {
    return ExtendedImageGesturePageView.builder(
      itemBuilder: (BuildContext context, int index) {
        String _url = "${item.images?[index]}";
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
      itemCount: item.images!.length,
      controller: PageController(
        initialPage: 0,
      ),
      scrollDirection: Axis.horizontal,
    );
  }

  return FutureBuilder(
      future: rootBundle.loadString('assets/images/${item.idx}/info.json'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return CircularProgressIndicator();
        }

        List<String> images =
            json.decode(snapshot.data)['images'].cast<String>();
        images.removeAt(0); // 0 은 썸네일

        return ExtendedImageGesturePageView.builder(
          itemBuilder: (BuildContext context, int index) {
            Widget image = ExtendedImage.asset(
              'assets/images/${item.idx}/${images[index]}',
              fit: BoxFit.contain,
              mode: ExtendedImageMode.gesture,
            );
            return Container(
              child: image,
              padding: EdgeInsets.all(5.0),
            );
          },
          itemCount: images.length,
          controller: PageController(
            initialPage: 0,
          ),
          scrollDirection: Axis.horizontal,
        );
      });
}
