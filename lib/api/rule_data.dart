import 'dart:convert';

import 'package:novel_read/api/rule_data_interface.dart';

class RuleData extends RuleDataInterface {
  @override
  String? getBigVariable(String key) {
    return null;
  }

  @override
  putBigVariable(String key, String? value) {
    if (value == null) {
      variableMap.remove(key);
    } else {
      variableMap[key] = value;
    }
  }

  String? getVariable() {
    if (variableMap.isEmpty) {
      return null;
    }
    return json.encode(variableMap);
  }
}
