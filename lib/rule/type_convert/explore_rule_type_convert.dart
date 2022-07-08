import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:novel_read/rule/explore_rule.dart';

class ExploreRuleTypeConvert extends TypeConverter<ExploreRule?, String> {
  @override
  ExploreRule? decode(String databaseValue) {
    if (databaseValue == "") {
      return null;
    }
    return ExploreRule.fromJson(json.decode(databaseValue));
  }

  @override
  String encode(ExploreRule? value) {
    if (value == null) {
      return "";
    }
    return json.encode(value.toJson());
  }
}
