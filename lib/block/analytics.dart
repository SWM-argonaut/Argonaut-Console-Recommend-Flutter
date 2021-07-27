import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:mixpanel_flutter/mixpanel_flutter.dart';

import 'package:console_game_db/configs.dart';

import 'package:console_game_db/block/list.dart' show SwitchGameListBloc;

class AnalyticsBloc {
  // firebase
  static FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: firebaseAnalytics);
  // mixpanel
  static late Mixpanel mixpanel;

  static void init() async {
    mixpanel = await Mixpanel.init(
      mixpanelToken,
      optOutTrackingDefault: false,
    );
  }

  static _logger({required String name, required Map<String, dynamic> param}) {
    // firebase
    firebaseAnalytics.logEvent(name: name, parameters: param);
    // mixpanel
    mixpanel.track(name, properties: param);
  }

  static onChangeOrder() {
    _logger(name: "orrder", param: <String, dynamic>{
      "search_order_by":
          SwitchGameListBloc.searchOptions.orderBy.toString().split('.').last,
      "search_order": SwitchGameListBloc.searchOptions.asc ? "ASC" : "DESC",
    });
  }

  static onSearch() {
    if (SwitchGameListBloc.searchOptions.searchText != "") {
      _logger(name: "game_search", param: <String, dynamic>{
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
    _logger(name: "detail", param: <String, dynamic>{
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
    _logger(name: "store_opened", param: <String, dynamic>{
      "store": "coupang",
      "idx": "$idx",
      "title": "$title",
    });
  }

  static onNintendoStore(String? idx, String? title) {
    _logger(name: "store_opened", param: <String, dynamic>{
      "store": "nintendo_store",
      "idx": "$idx",
      "title": "$title",
    });
  }
}
