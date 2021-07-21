import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:console_game_db/block/list.dart' show SwitchGameListBloc;

class AnalyticsBloc {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  static onChangeOrder() {
    AnalyticsBloc.analytics
        .logEvent(name: "order", parameters: <String, dynamic>{
      "search_order_by":
          SwitchGameListBloc.searchOptions.orderBy.toString().split('.').last,
      "search_order": SwitchGameListBloc.searchOptions.asc ? "ASC" : "DESC",
    });
  }

  static onSearch() {
    if (SwitchGameListBloc.searchOptions.searchText != "") {
      AnalyticsBloc.analytics
          .logEvent(name: "game_search", parameters: <String, dynamic>{
        "search_text": SwitchGameListBloc.searchOptions.searchText,
        "search_genres": SwitchGameListBloc.searchOptions.genres
            .toString()
            .replaceAll("Genre.", ""),
        "search_languages": SwitchGameListBloc.searchOptions.languages
            .toString()
            .replaceAll("Language.", ""),
        "search_order_by":
            SwitchGameListBloc.searchOptions.orderBy.toString().split('.').last,
        "search_order": SwitchGameListBloc.searchOptions.asc ? "ASC" : "DESC",
      });
    }
  }

  static onDetail(String? idx, String? title) {
    AnalyticsBloc.analytics
        .logEvent(name: "detail", parameters: <String, dynamic>{
      "search_text": SwitchGameListBloc.searchOptions.searchText,
      "search_genres": SwitchGameListBloc.searchOptions.genres
          .toString()
          .replaceAll("Genre.", ""),
      "search_languages": SwitchGameListBloc.searchOptions.languages
          .toString()
          .replaceAll("Language.", ""),
      "search_order_by":
          SwitchGameListBloc.searchOptions.orderBy.toString().split('.').last,
      "search_order": SwitchGameListBloc.searchOptions.asc ? "ASC" : "DESC",
      "idx": "$idx",
      "title": "$title",
    });
  }

  static onCoupang(String? idx, String? title) {
    analytics.logEvent(name: "store_opened", parameters: <String, dynamic>{
      "store": "coupang",
      "idx": "$idx",
      "title": "$title",
    });
  }

  static onNintendoStore(String? idx, String? title) {
    analytics.logEvent(name: "store_opened", parameters: <String, dynamic>{
      "store": "nintendo_store",
      "idx": "$idx",
      "title": "$title",
    });
  }
}
