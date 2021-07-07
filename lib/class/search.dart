import 'package:flutter/material.dart';

enum Genre { RPG }

class SearchOptions {
  final ValueNotifier<Set<Genre>> genres = ValueNotifier<Set<Genre>>({}); // 장르들

  // true = ASC, false = DESC
  static ValueNotifier<bool> recommended = ValueNotifier<bool>(true); // 추천순
  static ValueNotifier<bool> reviews = ValueNotifier<bool>(true); // 리뷰 수
  static ValueNotifier<bool> publishedDate = ValueNotifier<bool>(true); // 발매 순
  static ValueNotifier<bool> fullPrice = ValueNotifier<bool>(true); // 정가
  static ValueNotifier<bool> salePrice = ValueNotifier<bool>(true); // 할인가
  static ValueNotifier<bool> score = ValueNotifier<bool>(true); // 평점 순

  void addGenre(Genre genre) => genres.value.add(genre);
  void removeGenre(Genre genre) => genres.value.remove(genre);
  void clearGenre() => genres.value.clear();

  void changeRecommended() => recommended.value = !recommended.value;
  void changeReviews() => reviews.value = !reviews.value;
  void changePublishedDate() => publishedDate.value = !publishedDate.value;
  void changeFullPrice() => fullPrice.value = !fullPrice.value;
  void changeSalePrice() => salePrice.value = !salePrice.value;
  void changeScore() => score.value = !score.value;
}
