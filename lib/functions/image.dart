import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:console_game_db/configs.dart';

import 'package:console_game_db/data_class/switch_game.dart';

Widget getThumbnail(SwitchGame? item) {
  const double _height = 200;
  const double _width = 120;

  if (item!.images != null && item.images!.length > 0) {
    return CachedNetworkImage(
      fit: BoxFit.fill,
      imageUrl: "$requestImageURLBase${item.idx}/${item.images![0]}",
      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Icon(Icons.image_not_supported),
    );
  }
  return Container(
      height: _height,
      width: _width,
      alignment: Alignment.center,
      child: Icon(Icons.image_not_supported));
}

class ImagePageView extends StatefulWidget {
  final SwitchGame? item;
  const ImagePageView({Key? key, required this.item}) : super(key: key);

  @override
  _ImagePageViewState createState() => _ImagePageViewState();
}

class _ImagePageViewState extends State<ImagePageView> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    List<String>? _images = widget.item!.images?.sublist(1);

    if (widget.item!.images != null && widget.item!.images!.length > 0) {
      return Column(children: [
        Expanded(
            child: CarouselSlider.builder(
                options: CarouselOptions(
                    height: 400,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }),
                itemCount: _images?.length ?? 0,
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) {
                  return Container(
                    child: Container(
                      margin: EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        child: CachedNetworkImage(
                          imageUrl:
                              "$requestImageURLBase${widget.item!.idx}/${_images![itemIndex]}",
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.image_not_supported),
                        ),
                      ),
                    ),
                  );
                })),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.item!.images!.asMap().entries.map((entry) {
            return Container(
              width: 10.0,
              height: 10.0,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black
                      .withOpacity(_current == entry.key ? 0.9 : 0.4)),
            );
          }).toList(),
        )
      ]);
    }

    return Container(
      height: 400,
      child: Icon(Icons.image_not_supported),
    );
  }
}
