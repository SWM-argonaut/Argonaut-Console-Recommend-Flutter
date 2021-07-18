import 'package:flutter_test/flutter_test.dart';

import 'package:argonaut_console_recommend/data_class/search.dart';

void main() {
  test("list test", () {
    assert(Genre.values.length == genreName.length);
    assert(Language.values.length == languageName.length);
    assert(OrderBy.values.length == orderByName.length);
    assert(FilterOptions.values.length == filterOptionsName.length);
  });
}
