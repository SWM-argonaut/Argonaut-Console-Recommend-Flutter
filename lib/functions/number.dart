import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String priceString(int? price) {
  if (price == null) {
    return "?원";
  }
  return NumberFormat('###,###,###,###')
          .format(price)
          .replaceAll(' ', '')
          .toString() +
      "원";
}

Column salePriceWidget(
    {required int price,
    int? salePrice,
    alignment = CrossAxisAlignment.start}) {
  return Column(
    crossAxisAlignment: alignment,
    children: [
      Text(
        "${priceString(price)}",
        style: TextStyle(
          decoration: TextDecoration.lineThrough,
          decorationThickness: 3,
          fontSize: 10,
        ),
      ),
      Text("${priceString(salePrice)}"),
    ],
  );
}

Widget priceWidget(
    {required int price, int? salePrice, required String shopName}) {
  if (salePrice != null) {
    int? _discountRate = ((price - salePrice) / price * 100).toInt();
    return Row(children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$_discountRate% 할인",
            style: TextStyle(color: Colors.red),
          ),
          Text("$shopName 가격 : "),
        ],
      ),
      salePriceWidget(
          price: price, salePrice: salePrice, alignment: CrossAxisAlignment.end)
    ]);
  } else {
    return Text("$shopName 가격 : ${priceString(price)}");
  }
}
