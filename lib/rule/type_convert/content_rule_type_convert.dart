import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:novel_read/rule/content_rule.dart';

class ContentRuleTypeConvert extends TypeConverter<ContentRule?, String> {
  @override
  ContentRule? decode(String databaseValue) {
    if (databaseValue == "") {
      return null;
    }
    return ContentRule.fromJson(json.decode(databaseValue));
  }

  @override
  String encode(ContentRule? value) {
    if (value == null) {
      return "";
    }
    return json.encode(value.toJson());
  }
}
