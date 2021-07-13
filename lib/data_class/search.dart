import 'package:flutter/material.dart';

import 'package:argonaut_console_recommend/data_class/api.dart';

// 전체 장르 리스트:
// ['RPG', 'etc', '격투', '기타', '레이싱', '보드', '슈팅', '스포츠', '시뮬레이션', '실용', '아케이드', '액션', '어드벤처', '음악', '전략', '커뮤니케이션', '트레이닝', '파티', '퍼즐', '학습']
// 전체 언어 리스트:
// ['네덜란드어', '독일어', '러시아어', '스페인어', '영어', '이태리어', '일본어', '중국어', '포르투갈어', '프랑스어', '한국어']

enum Genre { AOS }
const List<String> genreName = ['AOS'];
enum Language { KOR }
const List<String> languageName = ['한국어'];
enum OrderBy {
  REVIEWS, //리뷰 수
  RELEASEDATE, //발매 순
  PRICE, // 가격
  SCORE, //평점 순
}
const List<String> orderByName = ['리뷰 수', '발매일', '가격', '평점'];

class SearchOptions {
  final Set<Genre> _genres = Set<Genre>(); // 장르들
  final Set<Language> _languages = Set<Language>(); // 장르들

  String searchText = "";
  bool _asc = false; // ASC, DESC
  OrderBy _orderBy = OrderBy.RELEASEDATE;

  bool get asc => _asc;
  OrderBy get orderBy => _orderBy;
  Set<Genre> get genres => _genres;
  Set<Language> get languages => _languages;

  void addGenre(Genre genre) => _genres.add(genre);
  void removeGenre(Genre genre) => _genres.remove(genre);
  void clearGenre() => _genres.clear();

  void addLanguage(Language language) => _languages.add(language);
  void removeLanguage(Language language) => _languages.remove(language);
  void clearLanguage() => _languages.clear();

  void clicked(OrderBy item) {
    if (item == _orderBy) {
      // if selected already, change just order
      _asc = !_asc;
    } else {
      _orderBy = item;
    }
  }

  bool checkItem(SwitchGame? item) {
    // TODO 태그랑 언어
    if (item!.title!.contains(searchText) == false) {
      return false;
    }

    return true;
  }
}

// 정렬만
class ItemOrderNotifier extends ValueNotifier<SearchOptions> {
  ItemOrderNotifier(SearchOptions value) : super(value);

  void clicked(OrderBy item) {
    value.clicked(item);
    notifyListeners();
  }
}

// 장르
class GenreOptionNotifier extends ValueNotifier<SearchOptions> {
  GenreOptionNotifier(SearchOptions value) : super(value);

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
}

class LanguageOptionNotifier extends ValueNotifier<SearchOptions> {
  LanguageOptionNotifier(SearchOptions value) : super(value);

  void addLanguage(Language language) {
    value.addLanguage(language);
    notifyListeners();
  }

  void removeLanguage(Language language) {
    value.removeLanguage(language);
    notifyListeners();
  }

  void clearLanguage(Language language) {
    value.clearLanguage();
    notifyListeners();
  }
}
