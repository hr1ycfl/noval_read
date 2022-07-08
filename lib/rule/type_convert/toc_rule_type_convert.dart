import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:novel_read/rule/toc_rule.dart';

class TocRuleTypeConvert extends TypeConverter<TocRule?, String> {
  @override
  TocRule? decode(String databaseValue) {
    if (databaseValue == "") {
      return null;
    }
    return TocRule.fromJson(json.decode(databaseValue));
  }

  @override
  String encode(TocRule? value) {
    if (value == null) {
      return "";
    }
    return json.encode(value.toJson());
  }
}
