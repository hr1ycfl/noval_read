abstract class RuleDataInterface {
  Map<String, String> variableMap = {};

  bool putVariable(String key, String? value) {
    if (value == null) {
      variableMap.remove(key);
      putBigVariable(key, value);
      return true;
    }
    if (value.length < 10000) {
      variableMap[key] = value;
      return true;
    }

    return false;
  }

  putBigVariable(String key, String? value);

  String? getBigVariable(String key);
}
