import 'package:argonaut_console_recommend/data_class/api.dart';

// 출시일로 정렬하고 같으면 가격으로 정렬
int orderByReleasedate(SwitchGame a, SwitchGame b, bool asc) {
  if (a.releaseDate == null) {
    return 1;
  } else if (b.releaseDate == null) {
    return -1;
  }
  int res = (a.releaseDate!.compareTo(b.releaseDate!)) * (asc ? 1 : -1);
  if (res != 0) {
    return res;
  }
  if (a.nintendoStore == null) {
    return 1;
  } else if (a.nintendoStore!.price == null) {
    return 1;
  } else if (b.nintendoStore == null) {
    return -1;
  }
  return (a.nintendoStore!.price!.compareTo(b.nintendoStore!.price ?? 0));
}

// 리뷰수 순으로 정렬하고 같으면 출시일로 정렬
int orderByReviews(SwitchGame a, SwitchGame b, bool asc) {
  if (a.coupang == null) {
    return 1;
  } else if (a.coupang!.ratingCount == null) {
    return 1;
  } else if (b.coupang == null) {
    return -1;
  }

  int res = (a.coupang!.ratingCount!.compareTo(b.coupang!.ratingCount ?? 0)) *
      (asc ? 1 : -1);
  return res != 0 ? res : orderByReleasedate(a, b, false);
}

// 가격순으로 정렬하고 같으면 출시일로 정렬
int orderByPrice(SwitchGame a, SwitchGame b, bool asc) {
  if (a.nintendoStore == null) {
    return 1;
  } else if (a.nintendoStore!.price == null) {
    return 1;
  } else if (b.nintendoStore == null) {
    return -1;
  }
  int res = (a.nintendoStore!.price!.compareTo(b.nintendoStore!.price ?? 0)) *
      (asc ? 1 : -1);
  return res != 0 ? res : orderByReleasedate(a, b, false);
}

// 평점순으로 정렬하고 같으면 출시일로 정렬
int orderByScore(SwitchGame a, SwitchGame b, bool asc) {
  if (a.coupang == null) {
    return 1;
  } else if (a.coupang!.rating == null) {
    return 1;
  } else if (b.coupang == null) {
    return -1;
  }
  int res =
      (a.coupang!.rating!.compareTo(b.coupang!.rating ?? 0)) * (asc ? 1 : -1);
  return res != 0 ? res : orderByReleasedate(a, b, false);
}
