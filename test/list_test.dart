import 'package:flutter_test/flutter_test.dart';

import 'package:console_game_db/data_class/search.dart';

void main() {
  test("list test", () {
    assert(Genre.values.length == genreName.length);
    assert(Language.values.length == languageName.length);
    assert(OrderBy.values.length == orderByName.length);
    assert(FilterOptions.values.length == filterOptionsName.length);
  });
}
