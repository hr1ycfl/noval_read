import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:novel_read/rule/search_rule.dart';

class SearchRuleTypeConvert extends TypeConverter<SearchRule?, String> {
  @override
  SearchRule? decode(String databaseValue) {
    if (databaseValue == "") {
      return null;
    }
    return SearchRule.fromJson(json.decode(databaseValue));
  }

  @override
  String encode(SearchRule? value) {
    if (value == null) {
      return "";
    }
    return json.encode(value.toJson());
  }
}
