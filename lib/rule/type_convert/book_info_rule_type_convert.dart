import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:novel_read/rule/book_info_rule.dart';

class BookInfoRuleTypeConvert extends TypeConverter<BookInfoRule?, String> {
  @override
  BookInfoRule? decode(String databaseValue) {
    if (databaseValue == "") {
      return null;
    }
    return BookInfoRule.fromJson(json.decode(databaseValue));
  }

  @override
  String encode(BookInfoRule? value) {
    if (value == null) {
      return "";
    }
    return json.encode(value.toJson());
  }
}
