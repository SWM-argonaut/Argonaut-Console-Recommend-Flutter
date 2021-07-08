import 'package:flutter/material.dart';

enum Genre { AOS, RACING, RPG }
enum OrderBy {
  RECOMMENDED, // 추천순
  REVIEWS, //리뷰 수
  PUBLISHEDDATE, //발매 순
  FULLPRICE, // 정가
  SALEPRICE, // 할인가
  SCORE, //평점 순
}

class SearchOptions {
  final Set<Genre> genres = Set<Genre>(); // 장르들

  bool asc = true; // ASC, DESC
  OrderBy orderBy = OrderBy.RECOMMENDED;

  void addGenre(Genre genre) => genres.add(genre);
  void removeGenre(Genre genre) => genres.remove(genre);
  void clearGenre() => genres.clear();

  void clicked(OrderBy item) {
    if (item == orderBy) {
      // if selected already, change just order
      asc = !asc;
    } else {
      orderBy = item;
    }
  }
}

class SearchOptionsNotifier extends ValueNotifier<SearchOptions> {
  SearchOptionsNotifier(SearchOptions value) : super(value);

  void addGenre(Genre genre) {
    value.addGenre(genre);
    notifyListeners();
  }

  void removeGenre(Genre genre) {
    value.removeGenre(genre);
    notifyListeners();
  }

  void clearGenre(Genre genre) {
    value.clearGenre();
    notifyListeners();
  }

  void clicked(OrderBy item) {
    value.clicked(item);
    notifyListeners();
  }
}
