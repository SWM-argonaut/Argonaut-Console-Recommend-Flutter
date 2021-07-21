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
